From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: fix length error in sas_smp_handler()
Date: Thu, 7 Dec 2017 09:27:37 +0000
Message-ID: <52a9871a-5861-6566-781b-7dbe0e4c3efe@huawei.com>
References: <20171205093943.40116-1-yanaijie@huawei.com>
 <5A289C39.8080203@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:59750 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750910AbdLGJ1v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Dec 2017 04:27:51 -0500
In-Reply-To: <5A289C39.8080203@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Linuxarm <linuxarm@huawei.com>

On 07/12/2017 01:41, Jason Yan wrote:
> Can anybody review this patch? Our test of SG_IO all failed because of
> this bug.
>
> On 2017/12/5 17:39, Jason Yan wrote:
>> The bsg_job_done() requires the length of payload received, but we give
>> it the untransferred residual.
>>
>> Fixes: 651a01364994 ("scsi: scsi_transport_sas: switch to bsg-lib for
>> SMP")
>> Reported-and-tested-by: chenqilin <chenqilin2@huawei.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> CC: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c
>> b/drivers/scsi/libsas/sas_expander.c
>> index 50cb0f3..8323dc1 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -2177,9 +2177,9 @@ void sas_smp_handler(struct bsg_job *job, struct
>> Scsi_Host *shost,
>>
>>       ret = smp_execute_task_sg(dev, job->request_payload.sg_list,
>>               job->reply_payload.sg_list);
>> -    if (ret > 0) {
>> +    if (ret >= 0) {
>>           /* positive number is the untransferred residual */
>> -        reslen = ret;
>> +        reslen = job->reply_payload.payload_len - ret;

Hi Jason,

If we really want the length of the payload received, then should you 
change the reslen variable name? The name implies "residual length", 
which is not really what it is holding according to your change.

Thanks,
John

>>           ret = 0;
>>       }
>>
>>
>
>
> .
>
