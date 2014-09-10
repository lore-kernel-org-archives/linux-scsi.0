From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 03/11] megaraid_sas : Update threshold based reply post
 host index register
Date: Wed, 10 Sep 2014 16:41:20 +0530
Message-ID: <b8e94c892d10613a97c5ddcf1ae5db57@mail.gmail.com>
References: <201409061328.s86DS5EM012885@palmhbs0.lsi.com> <540F09FA.1080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:53112 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaIJLQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 07:16:31 -0400
Received: by mail-qg0-f52.google.com with SMTP id i50so4495904qgf.39
        for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2014 04:16:30 -0700 (PDT)
In-Reply-To: <540F09FA.1080708@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>, aradford@gmail.com

>-----Original Message-----
>From: Tomas Henzl [mailto:thenzl@redhat.com]
>Sent: Tuesday, September 09, 2014 7:39 PM
>To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
>Cc: martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com;
>aradford@gmail.com
>Subject: Re: [PATCH 03/11] megaraid_sas : Update threshold based reply
post
>host index register
>
>On 09/06/2014 03:25 PM, Sumit.Saxena@avagotech.com wrote:
>> Current driver updates reply post host index to let firmware know that
>> replies are processed, while returning from ISR function, only if there
is no
>oustanding replies in reply queue.
>>
>> Driver will free the request frame immediately from ISR but reply post
host
>index is not yet updated.
>> It means freed request can be used by submission path and there may be
>> a tight loop in request/reply path. In such condition, firmware may
>> crash when it tries to post reply and there is no free reply post
descriptor.
>>
>> Eventually two things needs to be change to avoid this issue.
>>
>> Increase reply queue depth (double than request queue) to accommodate
>worst case scenario.
>> Update reply post host index to firmware once it reach to some
pre-defined
>threshold value.
>>
>> This change will make sure that firmware will always have some buffer
>> of reply descriptor and will never find empty reply descriptor in
completion
>path.
>>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 23
>> ++++++++++++++++++++++-
>drivers/scsi/megaraid/megaraid_sas_fusion.h |
>> 1 +
>>  2 files changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index c69c1ac..f30297d 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -971,7 +971,7 @@ megasas_init_adapter_fusion(struct
>> megasas_instance *instance)
>>
>>  	max_cmd = instance->max_fw_cmds;
>>
>> -	fusion->reply_q_depth = ((max_cmd + 1 + 15)/16)*16;
>> +	fusion->reply_q_depth = (((max_cmd * 2) + 1 + 15)/16)*16;
>
>This computation gives for certain values the same result as before, for
some
>the result is 1.5*higher and for others 2*higher. Is this intended?
>(I'm not asking what all the magic numbers mean..) what about a simple
>fusion->reply_q_depth = 2*(((max_cmd + 1 + 15)/16)*16);

I agree to make this computation simple and more accurate to give always
2*higher.
In most of the cases, we need reply queue depth = request_queue_depth +
additional room as provide in THRESHOLD_REPLY_COUNT.

Thanks for the feedback. We will do this change and will resubmit  the
patch.

>
>>
>>  	fusion->request_alloc_sz =
>>  		sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION)
>*max_cmd; @@ -1876,6
>> +1876,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32
>MSIxIndex)
>>  	u32 status, extStatus, device_id;
>>  	union desc_value d_val;
>>  	struct LD_LOAD_BALANCE_INFO *lbinfo;
>> +	int threshold_reply_count = 0;
>>
>>  	fusion = instance->ctrl_context;
>>
>> @@ -1963,6 +1964,7 @@ complete_cmd_fusion(struct megasas_instance
>> *instance, u32 MSIxIndex)
>>
>>  		desc->Words = ULLONG_MAX;
>>  		num_completed++;
>> +		threshold_reply_count++;
>>
>>  		/* Get the next reply descriptor */
>>  		if (!fusion->last_reply_idx[MSIxIndex])
>> @@ -1982,6 +1984,25 @@ complete_cmd_fusion(struct megasas_instance
>> *instance, u32 MSIxIndex)
>>
>>  		if (reply_descript_type ==
>MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
>>  			break;
>> +		/*
>> +		 * Write to reply post host index register after
completing
>threshold
>> +		 * number of reply counts and still there are more replies
in
>reply queue
>> +		 * pending to be completed
>> +		 */
>> +		if (threshold_reply_count >= THRESHOLD_REPLY_COUNT) {
>> +			if ((instance->pdev->device ==
>> +				PCI_DEVICE_ID_LSI_INVADER) ||
>> +				(instance->pdev->device ==
>> +				PCI_DEVICE_ID_LSI_FURY))
>> +				writel(((MSIxIndex & 0x7) << 24) |
>> +					fusion->last_reply_idx[MSIxIndex],
>> +					instance-
>>reply_post_host_index_addr[MSIxIndex/8]);
>> +			else
>> +				writel((MSIxIndex << 24) |
>> +					fusion->last_reply_idx[MSIxIndex],
>> +					instance-
>>reply_post_host_index_addr[0]);
>> +			threshold_reply_count = 0;
>> +		}
>>  	}
>>
>>  	if (!num_completed)
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>> index e76af54..d660c4d 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>> @@ -86,6 +86,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
>>
>>  #define MEGASAS_FP_CMD_LEN	16
>>  #define MEGASAS_FUSION_IN_RESET 0
>> +#define THRESHOLD_REPLY_COUNT 50
>>
>>  /*
>>   * Raid Context structure which describes MegaRAID specific IO
>> Parameters
