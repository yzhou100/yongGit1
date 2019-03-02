CREATE OR REPLACE procedure SIPROD.USF_EMTConnect_SAT_Score IS
/******************************************************************************
NAME:  USF_EMTConnect_SAT_Score

PURPOSE:  Procedure to extract the SAT scorecs for EMT_HOBSONS loading

REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/2.2009   Yong Zhou      1. Created this procedure.

******************************************************************************/  
  fHandler UTL_FILE.FILE_TYPE;
  entire_row                    VARCHAR2(1550);
  v_pidm           spriden.spriden_pidm%TYPE;
  counter integer;
  v_ID              SRVPREL.SRVPREL_ID%TYPE;
  v_last_name       SRVPREL.SRVPREL_LAST_NAME%type;
  v_first_name      SRVPREL.SRVPREL_FIRST_NAME%type;
  v_mi              SRVPREL.SRVPREL_MI%TYPE;
  v_gender          SRVPREL.SRVPREL_SEX%TYPE;
  v_dob             SRVPREL.SRVPREL_BIRTH_DATE%type;
  v_ethn            SRVPREL.SRVPREL_ETHN_CODE%type;
  v_addr_source     SRVPREL.SRVPREL_ASRC_CODE%type;
  v_addr_type       SRVPREL.SRVPREL_ATYP_CODE%TYPE;
  v_street1         SRVPREL.SRVPREL_STREET_LINE1%TYPE;
  v_street2         SRVPREL.SRVPREL_STREET_LINE2%TYPE;
  v_street3         SRVPREL.SRVPREL_STREET_LINE3%TYPE;
  v_city            SRVPREL.SRVPREL_CITY%TYPE;
  v_zip             SRVPREL.SRVPREL_ZIP%TYPE;
  v_state           SRVPREL.SRVPREL_STAT_CODE%TYPE;
  v_province           SRVPREL.SRVPREL_STAT_CODE%TYPE;
  v_county          SRVPREL.SRVPREL_CNTY_CODE%TYPE;
  v_nation          SRVPREL.SRVPREL_NATN_CODE%TYPE;
  v_nation_legal    SRVPREL.SRVPREL_NATN_CODE_LEGAL%TYPE;
  v_prel_code       SRVPREL.SRVPREL_PREL_CODE%TYPE;
  v_add_date        SRVPREL.SRVPREL_ADD_DATE%TYPE;
  v_spriden_id      SRVPREL.SRVPREL_SPRIDEN_ID%TYPE;
  v_term            varchar2(5);
  v_level           SRVPREL.SRVPREL_LEVL_CODE%TYPE;
  v_major           SRVPREL.SRVPREL_MAJR_CODE%TYPE;
  v_degree          SRVPREL.SRVPREL_DEGC_CODE%TYPE;
  v_dept            SRVPREL.SRVPREL_DEPT_CODE%TYPE;
  v_stu_type        SRVPREL.SRVPREL_STYP_CODE%TYPE;
  v_high            SRVPREL.SRVPREL_HSCH_SBGI_CODE%TYPE;
  v_high_date       SRVPREL.SRVPREL_HSCH_GRADUATION_DATE%TYPE;
  v_email           SRVPREL.SRVPREL_EMAIL_ADDRESS%TYPE;
  v_phone_type      SRVPREL.SRVPREL_TELE_CODE%TYPE;
  v_phohn_area      SRVPREL.SRVPREL_PHONE_AREA%TYPE;
  v_phone_number    SRVPREL.SRVPREL_PHONE_NUMBER1%TYPE;
  v_coll_code       SRTPCOL.SRTPCOL_SBGI_CODE%TYPE;
  v_coll_date       SRTPCOL.SRTPCOL_GRADUATION_DATE%TYPE;
  v_ethn_cate       SRVPREL.SRVPREL_ETHN_CATEGORY%TYPE;
  v_race_cde        SRTPRAC.SRTPRAC_RACE_CDE%TYPE;
  
  v_dateStamp       varchar2(8);
  
  v_SAT     varchar2(1);
  v_ACT     varchar2(1);
  v_TOEFL   varchar2(1);
  v_GRE     varchar2(1);
  v_GMAT    varchar2(1);
  v_test    srvprel.srvprel_prel_code%type;
  v_inString varchar2(200);
  
   CURSOR c_srvprel IS
        select s.SRVPREL_ID, s.SRVPREL_SSN, s.SRVPREL_LAST_NAME, s.SRVPREL_FIRST_NAME, s.SRVPREL_MI, 
            Decode(s.SRVPREL_SEX, 'M', 'M',
                                 'F', 'F', '')SRVPREL_SEX,
            s.SRVPREL_BIRTH_DATE, 
           Decode(s.SRVPREL_ETHN_CODE, '1', 'I',
                                        '2', 'O',
                                        '3', 'B',
                                        '4', 'H', 
                                        '5', 'P',
                                        '6', 'W',
                                        '7', 'Z', 'Z') SRVPREL_ETHN_CODE,
           s.SRVPREL_ASRC_CODE, Decode(s.SRVPREL_ATYP_CODE, 'TS', 'MA', 'MA') SRVPREL_ATYP_CODE, 
           replace(s.SRVPREL_STREET_LINE1, ',', '') SRVPREL_STREET_LINE1 , 
           replace(s.SRVPREL_STREET_LINE2, ',', '') SRVPREL_STREET_LINE2, 
           replace(s.SRVPREL_STREET_LINE3, ',', '') SRVPREL_STREET_LINE3,
           replace(s.SRVPREL_CITY, ',', '') SRVPREL_CITY,
           substr(s.SRVPREL_ZIP, 1, 5) SRVPREL_ZIP, 
           Case 
                When s.SRVPREL_STAT_CODE in ('AK', 'AL', 'AR', 'AZ', 'CA',
               'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'GU', 'HI', 'IA', 'ID', 
               'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN',
               'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 
               'NY', 'OH', 'OK', 'OR', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 
               'TX', 'UT', 'VA', 'VI', 'VT', 'WA', 'WI', 'WV', 'WY')
                 Then s.SRVPREL_STAT_CODE
               else '' 
           
           End SRVPREL_STAT_CODE ,
               
           Case 
                When s.SRVPREL_STAT_CODE in ('AK', 'AL', 'AR', 'AZ', 'CA',
               'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'GU', 'HI', 'IA', 'ID', 
               'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN',
               'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 
               'NY', 'OH', 'OK', 'OR', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 
               'TX', 'UT', 'VA', 'VI', 'VT', 'WA', 'WI', 'WV', 'WY')
                 Then ''
               else s.SRVPREL_STAT_CODE
           
           End SRVPREL_STAT_CODE1 ,
           
           s.SRVPREL_CNTY_CODE, 
           Case
               When s.SRVPREL_STAT_CODE in ('AK', 'AL', 'AR', 'AZ', 'CA',
               'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'GU', 'HI', 'IA', 'ID', 
               'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN',
               'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 
               'NY', 'OH', 'OK', 'OR', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 
               'TX', 'UT', 'VA', 'VI', 'VT', 'WA', 'WI', 'WV', 'WY')
                 Then 'US'
               else Decode(s.SRVPREL_NATN_CODE, 'XX', null, s.SRVPREL_NATN_CODE)
           End SRVPREL_NATN_CODE,
           s.SRVPREL_NATN_CODE_LEGAL,
           s.SRVPREL_PREL_CODE, s.SRVPREL_ADD_DATE, s.SRVPREL_SPRIDEN_ID, 
           CASE
                WHEN substr(to_char(SRVPREL_HSCH_GRADUATION_DATE, 'MMDDYYYY'), 5, 4) >= '2010'
                   and substr(to_char(SRVPREL_HSCH_GRADUATION_DATE, 'MMDDYYYY'), 1, 4) <= '0601'
                 THEN substr(to_char(SRVPREL_HSCH_GRADUATION_DATE, 'MMDDYYYY'), 5, 4) || 'F'
                WHEN substr(to_char(SRVPREL_HSCH_GRADUATION_DATE, 'MMDDYYYY'), 5, 4) >= '2010'
                   and substr(to_char(SRVPREL_HSCH_GRADUATION_DATE, 'MMDDYYYY'), 1, 4) > '0601'
                 THEN to_char(to_number(substr(to_char(SRVPREL_HSCH_GRADUATION_DATE, 'MMDDYYYY'), 5, 4)) + 1) || 'F'
                  
                WHEN SRVPREL_HSCH_GRADUATION_DATE <=To_date('Jun-01-2009', 'MON-DD-YYYY')
                 and SRVPREL_ADD_DATE_TIME <= To_date('Sep-01-2009', 'MON-DD-YYYY') THEN '2009F'
                WHEN SRVPREL_HSCH_GRADUATION_DATE is null
                 and SRVPREL_ADD_DATE_TIME <= To_date('Sep-01-2009', 'MON-DD-YYYY') THEN '2009F'
                WHEN SRVPREL_HSCH_GRADUATION_DATE is null
                 and SRVPREL_ADD_DATE_TIME >= To_date('Sep-02-2009', 'MON-DD-YYYY') THEN '2010F'
                
                WHEN SRVPREL_HSCH_GRADUATION_DATE <=To_date('Jun-01-2010', 'MON-DD-YYYY')
                 and SRVPREL_ADD_DATE_TIME <= To_date('Sep-01-2010', 'MON-DD-YYYY') THEN '2010F'
                WHEN SRVPREL_HSCH_GRADUATION_DATE is null
                 and SRVPREL_ADD_DATE_TIME >= To_date('Jun-03-2010', 'MON-DD-YYYY') THEN '2011F'
                ELSE '9999F'
           END SRVPREL_TERM_CODE, 
           decode(s.SRVPREL_LEVL_CODE, 'UG', 'U', 'GR', 'G', 'U')SRVPREL_LEVL_CODE,
           decode(s.SRVPREL_MAJR_CODE,'MBA', 'MBA', 'UNLA', 'UNLA', 'UNLA')SRVPREL_MAJR_CODE,
           decode(s.SRVPREL_DEGC_CODE,'MA', 'MA','MBA', 'MBA', 'PHD', 'PHD', 'BA', 'BA',
                               '000000', null)SRVPREL_DEGC_CODE, s.SRVPREL_DEPT_CODE, 
           decode(s.SRVPREL_STYP_CODE, 'F', 'F', 'G', 'G', 'F')SRVPREL_STYP_CODE, SRVPREL_HSCH_SBGI_CODE,
           s.SRVPREL_HSCH_GRADUATION_DATE, s.SRVPREL_EMAIL_ADDRESS, s.SRVPREL_TELE_CODE, s.SRVPREL_PHONE_AREA, s.SRVPREL_PHONE_NUMBER1,
           T.SRTPCOL_SBGI_CODE, T.SRTPCOL_GRADUATION_DATE, s.SRVPREL_ETHN_CATEGORY
            from srvprel s, SRTPCOL T
           where T.srtpcol_ridm(+) = s.srvprel_ridm
           and s.SRVPREL_PREL_CODE = 'SAT'
            and To_date(SRVPREL_ADD_DATE) <= to_date(sysdate)
            and  To_date(SRVPREL_ADD_DATE) > to_date(sysdate-7);
           
    
   cursor c_srttest is 
     select * from srttest;
   
   function f_inString(p_SAT Boolean, 
   p_ACT Boolean, p_TOEFL Boolean, p_GRE Boolean, p_GMAT Boolean)  return varchar2 is
       v_inString varchar(200);
       v_str_SAT    varchar(25);
       v_str_ACT    varchar(25);
       v_str_TOEFL  varchar(25);
       v_str_GRE    varchar(25);
       v_str_GMAT   varchar(25);
       v_str_dummy  varchar(25);
       
   Begin
      
      if p_SAT = True Then
           v_str_SAT := 'SAT'||','; 
      else v_str_SAT := '';
      End if;
      
       if p_ACT = True Then
           v_str_ACT := ''''||'ACT'||''''||','; 
      else v_str_ACT := '';
      End if;
      
      if p_TOEFL = True Then
           v_str_TOEFL := ''''||'TOEFL'||''''||',';
      else v_str_TOEFL := '';
      End if;
      
      if p_GRE = True Then
           v_str_GRE := ''''||'GRE'||''''||','; 
      else v_str_GRE := '';
      End if;
      
      if p_GMAT = True Then
           v_str_GMAT := ''''||'GMAT'||''''||',';
      else v_str_GMAT := '';
      End if;
     
     v_str_dummy := 'DUMMY';
     -- v_inString := ''''|| '('|| v_str_SAT ||v_str_ACT||v_str_TOEFL||v_str_GRE||v_str_GMAT || v_str_dummy || ')' ||'''';
      v_inString :=  '('|| v_str_SAT ||v_str_ACT||v_str_TOEFL||v_str_GRE||v_str_GMAT || v_str_dummy ||')';
      return v_inString;
   End f_inString;
   
   Begin
   DBMS_OUTPUT.ENABLE(1000000);
     v_test :='SAT';
     if v_test = 'SAT' Then
        v_SAT := 'Y';
     else v_SAT := 'N';
     END IF;
     
      if v_test = 'ACT' Then
        v_ACT := 'Y';
     else 
       v_ACT := 'N';
     END IF; 
     
      if v_test = 'TOEFL' Then
        v_TOEFL := 'Y';
     else v_TOEFL := 'N';
     END IF;
     
      if v_test = 'GRE' Then
        v_GRE := 'Y';
     else v_GRE := 'N';
     END IF;
     
      if v_test = 'GMAT' Then
        v_GMAT := 'Y';
     else v_GMAT := 'N';
     END IF;
      
     --v_inString := f_inString(p_SAT, p_ACT, p_TOEFL, p_GRE, p_GMAT);
     -- v_inString := 'SAT';    
     
      SELECT To_char(trunc(SYSDATE), 'YYYYMMDD') into v_dateStamp from dual;
      
       fHandler := UTL_FILE.FOPEN('HOBSONS_DIR', 'EMT_SAT'||v_dateStamp||'.csv', 'W');
       
      entire_row :=
                            'ID'                    ||','    ||
                            'Last Name'             ||','    ||      
                            'Frist Name'            ||','    ||
                            'Middle Initial'        ||','    ||
                            'Gender'                ||','    ||
                            'Birth Date'            ||','    ||
                            'Ethnicity'             ||','    ||
                            'Address Source'        ||','    ||
                            'Address Type'           ||','    ||
                            'Street Line 1'          ||','    ||
                            'Street Line 2'         ||','    ||
                            'Street Line 3'         ||','    ||
                            'City'                  ||','    ||
                            'Zip'                   ||','    ||
                            'State'                 ||','    ||
                            'Province'              ||','    ||
                            'County'                ||','    ||
                            'Nation'                ||','    ||
                            'Nation of Citizen'     ||','    ||
                            'Prospect Code'          ||','    ||
                            'Add Date'               ||','    ||
                            'Banner ID'             ||','    ||
                            'Term'                  ||','    ||
                            'Level'                 ||','    ||
                            'Major'                 ||','    ||
                            'Degree'                ||','    ||
                            'Department'             ||','    ||
                            'Student Type'           ||','    ||
                            'High School'            ||','    ||
                            'Graduation Date'        ||','    ||
                            'Email Adress'           ||','    ||
                            'Phone Type'             ||','    ||
                            'Phone Number'           ||','    ||
                            'College'                ||','    ||
                            'Graduation Date'        ||','    ||
                            'New Ethnicity'          ||','    ||
                            'Race Code'              ||','    ||
                            'SATYN'                  ||','    ||
                            'ACTYN'                  ||','    ||
                            'TOEFLYN'                ||','    ||
                            'GREYN'                  ||','    ||
                            'GMATYN';
                            
     UTL_FILE.PUT_LINE(fHandler, entire_row || CHR(13));
     
     for v_srvprel in c_srvprel Loop
              EXIT WHEN c_srvprel%NOTFOUND;
              v_ID              := v_srvprel.SRVPREL_ID;
              v_last_name       := v_srvprel.SRVPREL_LAST_NAME;
              v_first_name      := v_srvprel.SRVPREL_FIRST_NAME;
              v_mi              := v_srvprel.SRVPREL_MI;
              v_gender          := v_srvprel.SRVPREL_SEX;
              v_dob             := v_srvprel.SRVPREL_BIRTH_DATE;
              v_ethn            := v_srvprel.SRVPREL_ETHN_CODE;
              v_addr_source     := v_srvprel.SRVPREL_ASRC_CODE;
              v_addr_type       := v_srvprel.SRVPREL_ATYP_CODE;
              v_street1         := v_srvprel.SRVPREL_STREET_LINE1;
              v_street2         := v_srvprel.SRVPREL_STREET_LINE2;
              v_street3         := v_srvprel.SRVPREL_STREET_LINE2;
              v_city            := v_srvprel.SRVPREL_CITY;
              v_zip             := v_srvprel.SRVPREL_ZIP;
              v_state           := v_srvprel.SRVPREL_STAT_CODE;
              v_province        := v_srvprel.SRVPREL_STAT_CODE1;
              v_county          := v_srvprel.SRVPREL_CNTY_CODE;
              v_nation          := v_srvprel.SRVPREL_NATN_CODE;
              v_nation_legal    := v_srvprel.SRVPREL_NATN_CODE_LEGAL;
              v_prel_code       := v_srvprel.SRVPREL_PREL_CODE;
              v_add_date        := v_srvprel.SRVPREL_ADD_DATE;
              v_spriden_id      := v_srvprel.SRVPREL_SPRIDEN_ID;
              v_term            := v_srvprel.SRVPREL_TERM_CODE;
              v_level           := v_srvprel.SRVPREL_LEVL_CODE;
              v_major           := v_srvprel.SRVPREL_MAJR_CODE;
              v_degree          := v_srvprel.SRVPREL_DEGC_CODE;
              v_dept            := v_srvprel.SRVPREL_DEPT_CODE;
              v_stu_type        := v_srvprel.SRVPREL_STYP_CODE;
              v_high            := v_srvprel.SRVPREL_HSCH_SBGI_CODE;
              v_high_date       := v_srvprel.SRVPREL_HSCH_GRADUATION_DATE;
              v_email           := v_srvprel.SRVPREL_EMAIL_ADDRESS;
              v_phone_type      := v_srvprel.SRVPREL_TELE_CODE;
              v_phohn_area      := v_srvprel.SRVPREL_PHONE_AREA;
              v_phone_number    := v_srvprel.SRVPREL_PHONE_NUMBER1;
              v_coll_code       := v_srvprel.SRTPCOL_SBGI_CODE;
              v_coll_date       := v_srvprel.SRTPCOL_GRADUATION_DATE;
              v_ethn_cate       := v_srvprel.SRVPREL_ETHN_CATEGORY;
              
              entire_row :=
                            v_ID            ||','    ||
                            v_last_name     ||','    ||      
                            v_first_name    ||','    ||
                            v_mi            ||','    ||
                            v_gender        ||','    ||
                            to_char(trunc(v_dob), 'MM/DD/YYYY')   ||','    ||
                            v_ethn           ||','    ||
                            v_addr_source   ||','    ||
                            v_addr_type     ||','    ||
                            v_street1       ||','    ||
                            v_street2       ||','    ||
                            v_street3       ||','    ||
                            v_city          ||','    ||
                            v_zip           ||','    ||
                            v_state         ||','    ||
                            v_province        ||','    ||
                            v_county        ||','    ||
                            v_nation        ||','    ||
                            v_nation_legal  ||','    ||
                            v_prel_code     ||','    ||
                            to_char(trunc(v_add_date), 'MM/DD/YYYY')     ||','    ||
                            v_spriden_id    ||','    ||
                            v_term          ||','    ||
                            v_level         ||','    ||
                            v_major         ||','    ||
                            v_degree        ||','    ||
                            v_dept          ||','    ||
                            v_stu_type      ||','    ||
                            v_high          ||','    ||
                            to_char(trunc(v_high_date), 'MM/DD/YYYY')     ||','    ||
                            v_email         ||','    ||
                            v_phone_type    ||','    ||
                            v_phohn_area    ||
                            v_phone_number  ||','    ||
                            v_coll_code     ||','    ||
                            to_char(trunc(v_coll_date), 'MM/DD/YYYY')    ||','    ||
                            v_ethn_cate     ||','    ||
                            ''              ||','    ||
                            v_SAT           ||','    ||
                            v_ACT           ||','    ||
                            v_TOEFL         ||','    ||
                            v_GRE           ||','    ||
                            v_GMAT     
                            ;                  
                            
                    UTL_FILE.PUT_LINE(fHandler, entire_row || CHR(13));
              
                   
      
     End Loop;
      
      
     UTL_FILE.FCLOSE(fHandler);

      EXCEPTION

      When No_DATA_FOUND Then
         DBMS_OUTPUT.put_line('fff');
      WHEN UTL_FILE.INVALID_PATH THEN
         DBMS_OUTPUT.PUT_LINE('invalid path utl error');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
   
 END USF_EMTConnect_SAT_Score;
/
