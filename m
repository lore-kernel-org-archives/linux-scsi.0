From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] qedi: Fix truncation of name and secret
Date: Mon, 5 Feb 2018 11:21:18 -0800
Message-ID: <37d8588f-5e80-5a5c-3e73-90555ee06ceb@suse.com>
References: <20180201065734.20441-1-nilesh.javali@cavium.com>
 <a8cbb894-63d9-ebb8-6ac0-c59118b08c61@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbeBETVX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 14:21:23 -0500
In-Reply-To: <a8cbb894-63d9-ebb8-6ac0-c59118b08c61@suse.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nilesh Javali <nilesh.javali@cavium.com>, martin.petersen@oracle.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

On 02/05/2018 11:15 AM, Lee Duncan wrote:
> On 01/31/2018 10:57 PM, Nilesh Javali wrote:
>> Adjust the NULL byte added by snprintf.
>>
>> Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>
>> ---
>>  drivers/scsi/qedi/qedi_main.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
>> index cccc34a..cf8badb 100644
>> --- a/drivers/scsi/qedi/qedi_main.c
>> +++ b/drivers/scsi/qedi/qedi_main.c
>> @@ -1840,7 +1840,7 @@ static ssize_t qedi_show_boot_ini_info(void *data, int type, char *buf)
>>  
>>  	switch (type) {
>>  	case ISCSI_BOOT_INI_INITIATOR_NAME:
>> -		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
>> +		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN + 1, "%s",
>>  			      initiator->initiator_name.byte);
>>  		break;
>>  	default:
>> @@ -1908,7 +1908,7 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
>>  
>>  	switch (type) {
>>  	case ISCSI_BOOT_TGT_NAME:
>> -		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
>> +		rc = snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN + 1, "%s",
>>  			      block->target[idx].target_name.byte);
>>  		break;
>>  	case ISCSI_BOOT_TGT_IP_ADDR:
>> @@ -1930,19 +1930,19 @@ static umode_t qedi_ini_get_attr_visibility(void *data, int type)
>>  			      block->target[idx].lun.value[0]);
>>  		break;
>>  	case ISCSI_BOOT_TGT_CHAP_NAME:
>> -		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
>> +		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN + 1, "%s",
>>  			      chap_name);
>>  		break;
>>  	case ISCSI_BOOT_TGT_CHAP_SECRET:
>> -		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
>> +		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN + 1, "%s",
>>  			      chap_secret);
>>  		break;
>>  	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
>> -		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
>> +		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN + 1, "%s",
>>  			      mchap_name);
>>  		break;
>>  	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
>> -		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
>> +		rc = snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN + 1, "%s",
>>  			      mchap_secret);
>>  		break;
>>  	case ISCSI_BOOT_TGT_FLAGS:
>>
> 
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> 

Assuming you address Bart's comments.
-- 
Lee Duncan
SUSE Labs
