From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH][SCSI] megaraid_sas: Fix synchronization problem between
 sysPD IO path and AEN path
Date: Thu, 17 Oct 2013 17:48:13 +0200
Message-ID: <526006BD.3040405@redhat.com>
References: <201310161134.r9GBYYqK021397@cosmhbs0.lsi.com> <525FEE87.6070808@redhat.com> <088E451FE1854947BD9145EF8C016FF418B04DBF78@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab3JQPs6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Oct 2013 11:48:58 -0400
In-Reply-To: <088E451FE1854947BD9145EF8C016FF418B04DBF78@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saxena, Sumit" <Sumit.Saxena@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "aradford@gmail.com" <aradford@gmail.com>

On 10/17/2013 05:10 PM, Saxena, Sumit wrote:
>
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Thursday, October 17, 2013 7:35 PM
>> To: Saxena, Sumit; linux-scsi@vger.kernel.org
>> Cc: jbottomley@parallels.com; Desai, Kashyap; aradford@gmail.com
>> Subject: Re: [PATCH][SCSI] megaraid_sas: Fix synchronization problem
>> between sysPD IO path and AEN path
>>
>> On 10/16/2013 01:34 PM, Sumit.Saxena@lsi.com wrote:
>>> There is syncronization problem between sysPD IO path and AEN path.
>> Driver maintains instance->pd_list[] array, which will get updated(by
>> calling function megasas_get_pd_list[]), whenever any of below events
>> occurs-
>>
>> Hi Sumit,
>> - I'm a bit confused here- there are two threads which might access the
>> same array, but the problem is still there
>>  when the second thread accesses the array during the final memcpy, I
>> have expected that you will add some locking,
>>  but maybe I'm missing something.
>> - now the code zeroes the pd_list even when the
>>  (ret == 0 && (ci->count < (MEGASAS_MAX_PD_CHANNELS *
>> MEGASAS_MAX_DEV_PER_CHANNEL)))
>>  is not true. This is I think new - is that intentional?
> Tomas,
>
> Having lock to synchronize this will be a good choice, but will need changes in multiple places.
> Without this patch: driver memsets instance->pd_list[] array to zero, same array will be accessed in sysPD IO path, that creates problem.
>
> To resolve this issue, we introduced a new array "instance->local_pd_list[]" array, which we will be filling from Firmware DMAed data and then finally memcpy that array to the "instance->pd_list[]". Since "instance->pd_list" is accessed in IO path, then no problem in memset zero here(memset is on "instance->local_pd_list").
>
> Final "Memcpy" operation is not saved with locking, reason is: "instance->pd_list" array is of type "struct megasas_pd_list", which is of 32-bit, so single entry in "instance->local_pd_list" array will be copied in one CPU cycle, and with current MR FW design, it will not be a problem even if IO path (or any other thread) is accessing old instance->pd_list[]. so we are safe here in memcpy() here.
>
> Adding lock will add overhead in IO path, which could be avoided is main reason to resolve this issue with this fix.

Thanks, what remains is my second question 
- now the code zeroes the pd_list even when the (ret == 0 && (ci->count < (MEGASAS_MAX_PD_CHANNELS * MEGASAS_MAX_DEV_PER_CHANNEL)))
is not true.
This is I think new - is that intentional?

>
>
> Thanks,
> Sumit
>
>
>> Thanks, Tomas
>>
>>
>>>
>>>
>>>
>>>
>>>
>>> MR_EVT_PD_INSERTED
>>> MR_EVT_PD_REMOVED
>>> MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED
>>> MR_EVT_FOREIGN_CFG_IMPORTED
>>>
>>> At same time running sysPD IO will be accessing the same array
>> instance->pd_list[], which is getting updated in AEN path, because
>>> of this IO may not get correct PD info from instance->pd_list[] array.
>>>
>>> Signed-off-by: Adam Radford <adam.radford@lsi.com>
>>> Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
>>> ---
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>> b/drivers/scsi/megaraid/megaraid_sas.h
>>> index 0c73ba4..e9e543c 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>>> @@ -1531,6 +1531,7 @@ struct megasas_instance {
>>>  	struct megasas_register_set __iomem *reg_set;
>>>  	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
>>>  	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
>>> +	struct megasas_pd_list          local_pd_list[MEGASAS_MAX_PD];
>>>  	u8     ld_ids[MEGASAS_MAX_LD_IDS];
>>>  	s8 init_id;
>>>
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> index e62ff02..83ebc75 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> @@ -3194,21 +3194,23 @@ megasas_get_pd_list(struct megasas_instance
>> *instance)
>>>  	     (le32_to_cpu(ci->count) <
>>>  		  (MEGASAS_MAX_PD_CHANNELS * MEGASAS_MAX_DEV_PER_CHANNEL)))
>> {
>>> -		memset(instance->pd_list, 0,
>>> +		memset(instance->local_pd_list, 0,
>>>  			MEGASAS_MAX_PD * sizeof(struct megasas_pd_list));
>>>
>>>  		for (pd_index = 0; pd_index < le32_to_cpu(ci->count);
>> pd_index++) {
>>> -			instance->pd_list[le16_to_cpu(pd_addr->deviceId)].tid
>> 	=
>>> +			instance->local_pd_list[le16_to_cpu(pd_addr-
>>> deviceId)].tid	=
>>>  				le16_to_cpu(pd_addr->deviceId);
>>> -			instance->pd_list[le16_to_cpu(pd_addr-
>>> deviceId)].driveType	=
>>> +			instance->local_pd_list[le16_to_cpu(pd_addr-
>>> deviceId)].driveType	=
>>>  							pd_addr->scsiDevType;
>>> -			instance->pd_list[le16_to_cpu(pd_addr-
>>> deviceId)].driveState	=
>>> +			instance->local_pd_list[le16_to_cpu(pd_addr-
>>> deviceId)].driveState	=
>>>  							MR_PD_STATE_SYSTEM;
>>>  			pd_addr++;
>>>  		}
>>>  	}
>>>
>>> +	memcpy(instance->pd_list, instance->local_pd_list,
>>> +		sizeof(instance->pd_list));
>>>  	pci_free_consistent(instance->pdev,
>>>  				MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST),
>>>  				ci, ci_h);
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

