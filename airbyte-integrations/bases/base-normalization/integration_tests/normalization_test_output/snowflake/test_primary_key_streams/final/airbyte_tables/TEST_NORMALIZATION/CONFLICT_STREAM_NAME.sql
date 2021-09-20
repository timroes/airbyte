

      create or replace transient table "AIRBYTE_DATABASE".TEST_NORMALIZATION."CONFLICT_STREAM_NAME"  as
      (
with __dbt__CTE__CONFLICT_STREAM_NAME_AB1 as (

-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
select
    to_varchar(get_path(parse_json(_airbyte_data), '"id"')) as ID,
    
        get_path(parse_json(table_alias._airbyte_data), '"conflict_stream_name"')
     as CONFLICT_STREAM_NAME,
    _AIRBYTE_EMITTED_AT
from "AIRBYTE_DATABASE".TEST_NORMALIZATION._AIRBYTE_RAW_CONFLICT_STREAM_NAME as table_alias
-- CONFLICT_STREAM_NAME
),  __dbt__CTE__CONFLICT_STREAM_NAME_AB2 as (

-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
select
    cast(ID as 
    varchar
) as ID,
    cast(CONFLICT_STREAM_NAME as 
    variant
) as CONFLICT_STREAM_NAME,
    _AIRBYTE_EMITTED_AT
from __dbt__CTE__CONFLICT_STREAM_NAME_AB1
-- CONFLICT_STREAM_NAME
),  __dbt__CTE__CONFLICT_STREAM_NAME_AB3 as (

-- SQL model to build a hash column based on the values of this record
select
    md5(cast(
    
    coalesce(cast(ID as 
    varchar
), '') || '-' || coalesce(cast(CONFLICT_STREAM_NAME as 
    varchar
), '')

 as 
    varchar
)) as _AIRBYTE_CONFLICT_STREAM_NAME_HASHID,
    tmp.*
from __dbt__CTE__CONFLICT_STREAM_NAME_AB2 tmp
-- CONFLICT_STREAM_NAME
)-- Final base SQL model
select
    ID,
    CONFLICT_STREAM_NAME,
    _AIRBYTE_EMITTED_AT,
    _AIRBYTE_CONFLICT_STREAM_NAME_HASHID
from __dbt__CTE__CONFLICT_STREAM_NAME_AB3
-- CONFLICT_STREAM_NAME from "AIRBYTE_DATABASE".TEST_NORMALIZATION._AIRBYTE_RAW_CONFLICT_STREAM_NAME
      );
    