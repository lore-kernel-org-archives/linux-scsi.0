From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to
 firmware
Date: Mon, 17 Oct 2016 12:27:00 -0400
Message-ID: <14aa9905-b7fc-9695-dd19-1cc31cbee330@redhat.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-5-git-send-email-sumit.saxena@broadcom.com>
 <d9e79049-b4ce-588f-263d-dad015b3368d@suse.de>
 <9e5fbcef-bd72-71be-76f6-f41e26b5cb3c@redhat.com>
 <1476721205.2734.12.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934893AbcJQQ1D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 12:27:03 -0400
In-Reply-To: <1476721205.2734.12.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, kashyap.desai@broadcom.com, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Gris Ge <fge@redhat.com>, Ewan Milne <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>

On 10/17/2016 12:20 PM, James Bottomley wrote:
> On Mon, 2016-10-17 at 09:01 -0400, Ric Wheeler wrote:
>> On 10/17/2016 07:34 AM, Hannes Reinecke wrote:
>>> On 10/17/2016 12:24 PM, Sumit Saxena wrote:
>>>> megaraid_sas driver returns SYNCHRONIZE_CACHE command back to
>>>> SCSI layer without sending it to firmware as firmware takes care
>>>> of flushing cache.  This patch will change the driver behavior
>>>> wrt SYNCHRONIZE_CACHE handling. If underlying firmware has
>>>> support to handle the SYNCHORNIZE_CACHE, driver will send it for
>>>> firmware otherwise complete it back to SCSI layer with SUCCESS
>>>> immediately.  If  Firmware  handle SYNCHORNIZE_CACHE for both VD
>>>> and JBOD "canHandleSyncCache" bit in scratch pad register(offset
>>>> 0x00B4) will be set.
>>>>
>>>> This behavior can be controlled via module parameter and user can
>>>> fallback to old behavior of returning SYNCHRONIZE_CACHE by driver
>>>> only without sending it to firmware.
>>>>
>>>> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
>>>> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
>>>> ---
>>>>    drivers/scsi/megaraid/megaraid_sas.h        |  3 +++
>>>>    drivers/scsi/megaraid/megaraid_sas_base.c   | 14 ++++++--------
>>>>    drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 +++
>>>>    drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 ++
>>>>    4 files changed, 14 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>>>> b/drivers/scsi/megaraid/megaraid_sas.h
>>>> index ca86c88..43fd14f 100644
>>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>>>> @@ -1429,6 +1429,8 @@ enum FW_BOOT_CONTEXT {
>>>>    #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
>>>>    #define MR_MAX_MSIX_REG_ARRAY                   16
>>>>    #define MR_RDPQ_MODE_OFFSET			0X00800000
>>>> +#define MR_CAN_HANDLE_SYNC_CACHE_OFFSET		0X0100000
>>>> 0
>>>> +
>>>>    /*
>>>>    * register set for both 1068 and 1078 controllers
>>>>    * structure extended for 1078 registers
>>>> @@ -2140,6 +2142,7 @@ struct megasas_instance {
>>>>    	u8 is_imr;
>>>>    	u8 is_rdpq;
>>>>    	bool dev_handle;
>>>> +	bool fw_sync_cache_support;
>>>>    };
>>>>    struct MR_LD_VF_MAP {
>>>>    	u32 size;
>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> index 092387f..a4a8e2f 100644
>>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> @@ -104,6 +104,10 @@ unsigned int scmd_timeout =
>>>> MEGASAS_DEFAULT_CMD_TIMEOUT;
>>>>    module_param(scmd_timeout, int, S_IRUGO);
>>>>    MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s),
>>>> default 90s. See megasas_reset_timer.");
>>>>    
>>>> +bool block_sync_cache;
>>>> +module_param(block_sync_cache, bool, S_IRUGO);
>>>> +MODULE_PARM_DESC(block_sync_cache, "Block SYNC CACHE by driver
>>>> Default: 0(Send it to firmware)");
>>>> +
>>>>    MODULE_LICENSE("GPL");
>>>>    MODULE_VERSION(MEGASAS_VERSION);
>>>>    MODULE_AUTHOR("megaraidlinux.pdl@avagotech.com");
>>>> @@ -1700,16 +1704,10 @@ megasas_queue_command(struct Scsi_Host
>>>> *shost, struct scsi_cmnd *scmd)
>>>>    		goto out_done;
>>>>    	}
>>>>    
>>>> -	switch (scmd->cmnd[0]) {
>>>> -	case SYNCHRONIZE_CACHE:
>>>> -		/*
>>>> -		 * FW takes care of flush cache on its own
>>>> -		 * No need to send it down
>>>> -		 */
>>>> +	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) &&
>>>> +		(!instance->fw_sync_cache_support)) {
>>>>    		scmd->result = DID_OK << 16;
>>>>    		goto out_done;
>>>> -	default:
>>>> -		break;
>>>>    	}
>>>>    
>>>>    	return instance->instancet
>>>> ->build_and_issue_cmd(instance, scmd);
>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>> index 2159f6a..8237580 100644
>>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>> @@ -747,6 +747,9 @@ megasas_ioc_init_fusion(struct
>>>> megasas_instance *instance)
>>>>    		ret = 1;
>>>>    		goto fail_fw_init;
>>>>    	}
>>>> +	if (!block_sync_cache)
>>>> +		instance->fw_sync_cache_support = (scratch_pad_2
>>>> &
>>>> +			MR_CAN_HANDLE_SYNC_CACHE_OFFSET) ? 1 :
>>>> 0;
>>>>    
>>>>    	IOCInitMessage =
>>>>    	  dma_alloc_coherent(&instance->pdev->dev,
>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>> index e3bee04..2857154 100644
>>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>> @@ -72,6 +72,8 @@
>>>>    #define MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET   (0x0000030C)
>>>>    #define MPI2_REPLY_POST_HOST_INDEX_OFFSET	(0x0000006C)
>>>>    
>>>> +extern bool block_sync_cache;
>>>> +
>>>>    /*
>>>>     * Raid context flags
>>>>     */
>>>>
>>> Be extra careful with that.
>>>
>>> SYNCHRONIZE_CACHE has (potentially) a global scope, as there might
>>> be an array-wide cache, and a cache flush would affect the entire
>>> cache. Linux is using SYNCHRONIZE_CACHE as a per device setting, ie
>>> it assumes that the effects of a cache flush is restricted to the
>>> device in question.
>>>
>>> If this is _not_ the case I'd rather not enable it.
>>> Have you checked that enabling this functionality doesn't have
>>> negative performance impact?
>>>
>>> Cheers,
>>>
>>> Hannes
>> This must go in - without this fix, there is no data integrity for
>> any file system.
> That's not what I get from the change log.  What it says to me is that
> the caches are currently firmware managed.  Barring firmware bugs, that
> means that we currently don't have any integrity issues.

Your understanding (or the change log) is incorrect.

The issue here is for devices that are non-RAID or pass through - this is a real 
issue and has been seen in practice.

Ric

>
>> In effect, this driver by default has been throwing away
>> SYNCHRONIZE_CACHE commands even when acting in JBOD/non-RAID mode.
> That's not what the changelog says.  It says the cache flushing has
> been managed by the firmware only.  Meaning the firmware decides when
> to flush the cache.  Barring firmware bugs, this should mean that
> integrity is preserved in either mode.
>
>> Of course, actually doing a SYNCHRONIZE_CACHE to drives will be
>> slower than throwing it away, but this is not optional.
> What Hannes means is that we need to know that turning over cache
> management to Linux is a) safe and b) not a performance regression.
>   Given that there aren't any integrity issues, that's a reasonable
> request.
>
>> We really need to have some ways to validate that our IO stack is
>> properly and safely configured.
>>
>> I would love to see a couple of things:
>>
>> * having T10 & T13 report the existence of a volatile write cache -
>> this is different than WCE set, some devices have a write cache and
>> are battery/flash backed.
> That's the non-volatile cache log page.
>
> James
>
>
>> * having a robust tool to test over power failure/disconnect that our
>> assumptions are true - any write is durable after a SYNCHRONIZE_CACHE
>> or CACHE_FLUSH_EXT is sent and ack'ed
>>
>> Regards,
>>
>> Ric
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

