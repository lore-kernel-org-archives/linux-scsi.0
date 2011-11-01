From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] qla4xx: a small loop fix
Date: Tue, 01 Nov 2011 21:22:09 +0100
Message-ID: <4EB054F1.8030104@redhat.com>
References: <4EB02263.1080603@redhat.com> <4EB0362A.3050408@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab1KAUWS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2011 16:22:18 -0400
In-Reply-To: <4EB0362A.3050408@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 11/01/2011 07:10 PM, Mike Christie wrote:
> On 11/01/2011 11:46 AM, Tomas Henzl wrote:
>> From: Tomas Henzl <thenzl@redhat.com>
>>
>> When the qla4xxx_get_fwddb_entry returns QLA_ERROR
>> the nex_idx is not updated, 
>>       for (idx = 0; idx < max_ddbs; idx = next_idx) {
>>                 ret = qla4xxx_get_fwddb_entry(ha, idx, NULL, 0, NULL,
>>                                               &next_idx, &state, &conn_err,
>>                                                 NULL, NULL);
>>                 if (ret == QLA_ERROR)
>>                         continue;
>>  
>> This means there is a risk that the 'idx < max_ddbs' condition will never
>> met and the loop will loop forever.
>> Fix this by explicitly increasing the next_idx in the error condition.
>>
>> Maybe a break instead of continue is more appropriate, leaving the decision
>> on the qlogic maintainer.
>>
>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>>
>> diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
>> index 3075fba..17acb17 100644
>> --- a/drivers/scsi/qla4xxx/ql4_init.c
>> +++ b/drivers/scsi/qla4xxx/ql4_init.c
>> @@ -787,8 +787,10 @@ static void qla4xxx_free_ddb_index(struct scsi_qla_host *ha)
>>  		ret = qla4xxx_get_fwddb_entry(ha, idx, NULL, 0, NULL,
>>  					      &next_idx, &state, &conn_err,
>>  						NULL, NULL);
>> -		if (ret == QLA_ERROR)
>> +		if (ret == QLA_ERROR) {
>> +			next_idx++;
>>  			continue;
>> +		}
>>  		if (state == DDB_DS_NO_CONNECTION_ACTIVE ||
>>  		    state == DDB_DS_SESSION_FAILED) {
>>  			DEBUG2(ql4_printk(KERN_INFO, ha,
> Patch looks correct.
>
> James, this is a patch for something that is not yet upstream. I will
> just merge this patch with the patch I was going to send upstream, so do
> not worry about it.
It's created on top of scsi-misc (99a700bcc75429ba84a672d04f0b650dcc5b3042 [SCSI] mv_sas: OCZ RevoDrive3 & zDrive R4 support)
it looks like being created on top of the not yet posted patch, but it isn't so :)
To the method how this gets accepted i don't care.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

