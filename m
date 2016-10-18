From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to
 firmware
Date: Tue, 18 Oct 2016 09:07:49 -0400
Message-ID: <f4675146-08b0-cd7e-03c5-a52a6de36000@gmail.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-5-git-send-email-sumit.saxena@broadcom.com>
 <bfbd5d44-aff0-dc4e-2c3d-ed8143408043@redhat.com>
 <e4f4409887660ef78e55e857fa872b29@mail.gmail.com>
 <e7606792-e878-cfa3-a40c-931da28b6fb5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35738 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754884AbcJRNHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 09:07:54 -0400
Received: by mail-qk0-f196.google.com with SMTP id v138so16771814qka.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 06:07:53 -0700 (PDT)
In-Reply-To: <e7606792-e878-cfa3-a40c-931da28b6fb5@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>

On 10/17/2016 09:57 AM, Tomas Henzl wrote:
> On 17.10.2016 15:28, Sumit Saxena wrote:
>>> -----Original Message-----
>>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>>> Sent: Monday, October 17, 2016 6:44 PM
>>> To: Sumit Saxena; linux-scsi@vger.kernel.org
>>> Cc: martin.petersen@oracle.com; jejb@linux.vnet.ibm.com;
>>> kashyap.desai@broadcom.com
>>> Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to
>>> firmware
>>>
>>> On 17.10.2016 12:24, Sumit Saxena wrote:
>>>> megaraid_sas driver returns SYNCHRONIZE_CACHE command back to SCSI
>>>> layer without sending it to firmware as firmware takes care of flushing
>> cache.
>>>> This patch will change the driver behavior wrt SYNCHRONIZE_CACHE
>> handling.
>>>> If underlying firmware has support to handle the SYNCHORNIZE_CACHE,
>>>> driver will send it for firmware otherwise complete it back to SCSI
>>>> layer with SUCCESS immediately.
>>>> If  Firmware  handle SYNCHORNIZE_CACHE for both VD and JBOD
>>>> "canHandleSyncCache" bit in scratch pad register(offset 0x00B4) will
>>>> be set.
>>>>
>>>> This behavior can be controlled via module parameter and user can
>>>> fallback to old behavior of returning SYNCHRONIZE_CACHE by driver only
>>>> without sending it to firmware.
>>>>
>>>> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
>>>> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
>>>> ---
>>>>   drivers/scsi/megaraid/megaraid_sas.h        |  3 +++
>>>>   drivers/scsi/megaraid/megaraid_sas_base.c   | 14 ++++++--------
>>>>   drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 +++
>>>> drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 ++
>>>>   4 files changed, 14 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>>>> b/drivers/scsi/megaraid/megaraid_sas.h
>>>> index ca86c88..43fd14f 100644
>>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>>>> @@ -1429,6 +1429,8 @@ enum FW_BOOT_CONTEXT {
>>>>   #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
>>>>   #define MR_MAX_MSIX_REG_ARRAY                   16
>>>>   #define MR_RDPQ_MODE_OFFSET			0X00800000
>>>> +#define MR_CAN_HANDLE_SYNC_CACHE_OFFSET		0X01000000
>>>> +
>>>>   /*
>>>>   * register set for both 1068 and 1078 controllers
>>>>   * structure extended for 1078 registers @@ -2140,6 +2142,7 @@ struct
>>>> megasas_instance {
>>>>   	u8 is_imr;
>>>>   	u8 is_rdpq;
>>>>   	bool dev_handle;
>>>> +	bool fw_sync_cache_support;
>>>>   };
>>>>   struct MR_LD_VF_MAP {
>>>>   	u32 size;
>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> index 092387f..a4a8e2f 100644
>>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>> @@ -104,6 +104,10 @@ unsigned int scmd_timeout =
>>>> MEGASAS_DEFAULT_CMD_TIMEOUT;  module_param(scmd_timeout, int,
>>>> S_IRUGO);  MODULE_PARM_DESC(scmd_timeout, "scsi command timeout
>>>> (10-90s), default 90s. See megasas_reset_timer.");
>>>>
>>>> +bool block_sync_cache;
>>>> +module_param(block_sync_cache, bool, S_IRUGO);
>>>> +MODULE_PARM_DESC(block_sync_cache, "Block SYNC CACHE by driver
>>>> +Default: 0(Send it to firmware)");
>>>> +
>>>>   MODULE_LICENSE("GPL");
>>>>   MODULE_VERSION(MEGASAS_VERSION);
>>>>   MODULE_AUTHOR("megaraidlinux.pdl@avagotech.com");
>>>> @@ -1700,16 +1704,10 @@ megasas_queue_command(struct Scsi_Host
>>> *shost, struct scsi_cmnd *scmd)
>>>>   		goto out_done;
>>>>   	}
>>>>
>>>> -	switch (scmd->cmnd[0]) {
>>>> -	case SYNCHRONIZE_CACHE:
>>>> -		/*
>>>> -		 * FW takes care of flush cache on its own
>>>> -		 * No need to send it down
>>>> -		 */
>>>> +	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) &&
>>>> +		(!instance->fw_sync_cache_support)) {
>>> Maybe I'm wrong, but isn't the logic inverted?
>>> when fw_sync_cache_support is true  it means that there is a flash cache
>> or a
>>> battery and we don't have to send the command down ?
>>>
>> If "instance->fw_sync_cache_support" is set to true, it means driver can
>> send SYNCHRONIZE_CACHE to firmware(firmware has infrastructure to support
>> SYNCHRONIZE_CACHE).
>> If "instance->fw_sync_cache_support" is set to false, it means FW does not
>> support to handle SYNCHRONIZE_CACHE and FW will flush cache during
>> shutdown.
> Thanks, in that case it is correct.
>
>>>> +	if (!block_sync_cache)
>>>> +		instance->fw_sync_cache_support = (scratch_pad_2 &
>>>> +			MR_CAN_HANDLE_SYNC_CACHE_OFFSET) ? 1 : 0;
> Please add a warning or log the state of the synchronise cache command
> on the controller.

Any logging should be limited to once per device - say when the device is 
opened. Note that synchronize_cache commands are extremely common, we don't want 
to fill the log with this.

thanks!

Ric

>
>
>>>>   	IOCInitMessage =
>>>>   	  dma_alloc_coherent(&instance->pdev->dev,
>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>> index e3bee04..2857154 100644
>>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>> @@ -72,6 +72,8 @@
>>>>   #define MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET   (0x0000030C)
>>>>   #define MPI2_REPLY_POST_HOST_INDEX_OFFSET	(0x0000006C)
>>>>
>>>> +extern bool block_sync_cache;
>>>> +
>>>>   /*
>>>>    * Raid context flags
>>>>    */

