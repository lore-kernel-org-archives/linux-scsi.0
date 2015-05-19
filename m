From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH v3 17/18] megaraid_sas : fix megasas_fire_cmd_fusion
 calling convention
Date: Tue, 19 May 2015 13:01:04 +0530
Message-ID: <aef53f6365d9b67ea035114567afa48a@mail.gmail.com>
References: <201504231106.t3NB6PX8030941@palmhbs0.lsi.com> <1432016578.4337.62.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36849 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbbESHbG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2015 03:31:06 -0400
Received: by qkgw4 with SMTP id w4so3973742qkg.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2015 00:31:06 -0700 (PDT)
In-Reply-To: <1432016578.4337.62.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
>Sent: Tuesday, May 19, 2015 11:53 AM
>To: Sumit.Saxena@avagotech.com
>Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
>martin.petersen@oracle.com; hch@infradead.org;
>kashyap.desai@avagotech.com
>Subject: Re: [PATCH v3 17/18] megaraid_sas : fix megasas_fire_cmd_fusion
>calling convention
>
>On Thu, 2015-04-23 at 16:34 +0530, Sumit.Saxena@avagotech.com wrote:
>> The fusion HBAs don't really use the instance template like the other
>> variants, as it branches off at a much higher level.  So instead of
>> trying to squeeze megasas_fire_cmd_fusion into the wrong calling
>> convention call it locally with argument data types that match what is
>> passed.
>>
>> From: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   72
>> +++++++++++------------
>---
>>  1 files changed, 31 insertions(+), 41 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index 487cd34..826ba1c 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -182,6 +182,31 @@ inline void megasas_return_cmd_fusion(struct
>> megasas_instance *instance,  }
>>
>>  /**
>> + * megasas_fire_cmd_fusion -	Sends command to the FW
>> + */
>> +static void
>> +megasas_fire_cmd_fusion(struct megasas_instance *instance,
>> +		union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
>{ #if
>> +defined(writeq) && defined(CONFIG_64BIT)
>> +	u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
>> +			le32_to_cpu(req_desc->u.low));
>> +
>> +	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
>> +#else
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&instance->hba_lock, flags);
>> +	writel(le32_to_cpu(req_desc->u.low),
>> +		&instance->reg_set->inbound_low_queue_port);
>> +	writel(le32_to_cpu(req_desc.u.high),
>                                    ^^^
>Compile the bloody code.  This should be req_desc->u.high
>
>I fixed it but I expect you to submit better code in future.

I am really sorry for this. I compiled the driver at my setup but since this
code is inside conditional compilation and never get compiled. Code inside
"# if defined(writeq) && defined(CONFIG_64BIT)" was getting compiled and
this got missed.
I will take care of such stuff in future.

Thanks,
Sumit
>
>James
>
