From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to
 firmware
Date: Fri, 21 Oct 2016 18:30:05 +0200
Message-ID: <31f0afad-edc3-918d-c2bb-cd25bb67503e@redhat.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-5-git-send-email-sumit.saxena@broadcom.com>
 <d9e79049-b4ce-588f-263d-dad015b3368d@suse.de>
 <9e5fbcef-bd72-71be-76f6-f41e26b5cb3c@redhat.com>
 <1476721205.2734.12.camel@linux.vnet.ibm.com>
 <14aa9905-b7fc-9695-dd19-1cc31cbee330@redhat.com>
 <1476724793.2734.21.camel@linux.vnet.ibm.com>
 <01e727ba166a34a97efdd5e890e4bc22@mail.gmail.com>
 <1476726692.2734.36.camel@linux.vnet.ibm.com>
 <b803c55c-23db-3bec-3d2f-58bc53d4ef37@redhat.com>
 <1476870626.11867.11.camel@Centos6.3-64>
 <5b6d87e8-c1ca-2d3f-cb0d-41df187103e9@redhat.com>
 <4D8E82A446BF54499747901DBDEB737A48427E94@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754872AbcJUQaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Oct 2016 12:30:11 -0400
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A48427E94@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Ching Huang <ching2048@areca.com.tw>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Gris Ge <fge@redhat.com>, Ewan Milne <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>

On 19.10.2016 20:07, Raghava Aditya Renukunta wrote:
> Hi Tomas,
>
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Wednesday, October 19, 2016 5:56 AM
>> To: Ching Huang
>> Cc: James Bottomley; Kashyap Desai; Ric Wheeler; Hannes Reinecke; Sumit
>> Saxena; linux-scsi@vger.kernel.org; martin.petersen@oracle.com; Christoph
>> Hellwig; Martin K. Petersen; Jeff Moyer; Gris Ge; Ewan Milne; Jens Axboe;
>> Raghava Aditya Renukunta
>> Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE
>> command to firmware
>>
>> EXTERNAL EMAIL
>>
>>
>> On 19.10.2016 11:50, Ching Huang wrote:
>>> Hi Tomas,
>>>
>>> SCSI command checking in queuecommand function of arcmsr can be
>> removed safely.
>>> Now driver can pass all scsi command to controller firmware.
>> thanks for your quick reply. Is this (passing the SYNCHRONIZE_CACHE
>> command
>> to firmware) safe for all arcmsr cards, even the oldest?
>>
>> Please start with your patch a new thread and add your 'Signed-off-by:' line.
>>
>>> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
>> b/drivers/scsi/arcmsr/arcmsr_hba.c
>>> --- a/drivers/scsi/arcmsr/arcmsr_hba.c        2016-10-19 16:18:45.000000000
>> +0800
>>> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c        2016-10-19 16:31:59.665524699
>> +0800
>>> @@ -2623,13 +2623,6 @@ static int arcmsr_queue_command_lck(stru
>>>       cmd->scsi_done = done;
>>>       cmd->host_scribble = NULL;
>>>       cmd->result = 0;
>>> -     if ((scsicmd == SYNCHRONIZE_CACHE) ||(scsicmd ==
>> SEND_DIAGNOSTIC)){
>>> -             if(acb->devstate[target][lun] == ARECA_RAID_GONE) {
>>> -                     cmd->result = (DID_NO_CONNECT << 16);
>>> -             }
>>> -             cmd->scsi_done(cmd);
>>> -             return 0;
>>> -     }
>>>       if (target == 16) {
>>>               /* virtual device for iop message transfer */
>>>               arcmsr_handle_virtual_command(acb, cmd);
>>>
>>> Thanks
>>> Ching
>>> On Tue, 2016-10-18 at 15:56 +0200, Tomas Henzl wrote:
>>>> Hi,
>>>>
>>>> similar suspicious code path can be found in the queuecommand
>> functions in other drivers too
>>>> these are -
>>>> pmcraid.c
>>>> arcmsr_hba.c
>>>> cc-ing maintainers -
>>>> (but both drivers seem to be unmaintained for a while -
>>>> I've added Ching for arcmsr and Raghava for pmcraid)
> We do not support this card  anymore nor do we have the hardware to test
> it out, but let me  try and procure the hardware for testing although 
> chances are very slim.

Thanks for looking into this even though the driver is no more supported.


>
> Regards,
> Raghava Aditya
>
>>>> please read this thread and verify that your driver and firmware is safe.
>>>>
>>>> It is expected that a raid card controls the disk write cache (switches it off)
>>>> but this might not be true for all modes of operation a raid adapter
>> handles
>>>> - pass through/non-RAID etc. In such case when disk write cache is
>> enabled
>>>> and your driver skips the SYNCHRONIZE_CACHE command a FS corruption
>>>> is very much possible during unexpected power loss or even a clean
>> shutdown.
>>>> tomash
>>>>
>>>> On 17.10.2016 19:51, James Bottomley wrote:
>>>>> On Mon, 2016-10-17 at 23:06 +0530, Kashyap Desai wrote:
>>>>>>> -----Original Message-----
>>>>>>> From: James Bottomley [mailto:jejb@linux.vnet.ibm.com]
>>>>>>> Sent: Monday, October 17, 2016 10:50 PM
>>>>>>> To: Ric Wheeler; Hannes Reinecke; Sumit Saxena;
>>>>>>> linux-scsi@vger.kernel.org
>>>>>>> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
>>>>>>> kashyap.desai@broadcom.com; Christoph Hellwig; Martin K.
>> Petersen;
>>>>>>> Jeff
>>>>>>> Moyer; Gris Ge; Ewan Milne; Jens Axboe
>>>>>>> Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE
>>>>>>> command
>>>>>>> to firmware
>>>>>>>
>>>>>>> On Mon, 2016-10-17 at 12:27 -0400, Ric Wheeler wrote:
>>>>>>>> On 10/17/2016 12:20 PM, James Bottomley wrote:
>>>>>>>>> On Mon, 2016-10-17 at 09:01 -0400, Ric Wheeler wrote:
>>>>>>>>>> On 10/17/2016 07:34 AM, Hannes Reinecke wrote:
>>>>>>>>>>> On 10/17/2016 12:24 PM, Sumit Saxena wrote:
>>>>>>>>>>>> megaraid_sas driver returns SYNCHRONIZE_CACHE command
>>>>>>>>>>>> back to
>>>>>>>>>>>> SCSI layer without sending it to firmware as firmware
>>>>>>>>>>>> takes
>>>>>>>>>>>> care of flushing cache.  This patch will change the
>>>>>>>>>>>> driver
>>>>>>>>>>>> behavior wrt SYNCHRONIZE_CACHE handling. If underlying
>>>>>>>>>>>> firmware has support to handle the SYNCHORNIZE_CACHE,
>>>>>>>>>>>> driver
>>>>>>>>>>>> will send it for firmware otherwise complete it back to
>>>>>>>>>>>> SCSI
>>>>>>>>>>>> layer with SUCCESS immediately.  If  Firmware  handle
>>>>>>>>>>>> SYNCHORNIZE_CACHE for both VD and JBOD
>>>>>>>>>>>> "canHandleSyncCache"
>>>>>>>>>>>> bit in scratch pad register(offset
>>>>>>>>>>>> 0x00B4) will be set.
>>>>>>>>>>>>
>>>>>>>>>>>> This behavior can be controlled via module parameter and
>>>>>>>>>>>> user
>>>>>>>>>>>> can fallback to old behavior of returning
>>>>>>>>>>>> SYNCHRONIZE_CACHE by
>>>>>>>>>>>> driver only without sending it to firmware.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
>>>>>>>>>>>> Signed-off-by: Kashyap Desai
>> <kashyap.desai@broadcom.com>
>>>>>>>>>>>> ---
>>>>>>>>>>>>    drivers/scsi/megaraid/megaraid_sas.h        |  3 +++
>>>>>>>>>>>>    drivers/scsi/megaraid/megaraid_sas_base.c   | 14
>>>>>>>>>>>> ++++++---
>>>>>>>>>>>> -----
>>>>>>>>>>>>    drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 +++
>>>>>>>>>>>>    drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 ++
>>>>>>>>>>>>    4 files changed, 14 insertions(+), 8 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>>>>>>>>>>>> b/drivers/scsi/megaraid/megaraid_sas.h
>>>>>>>>>>>> index ca86c88..43fd14f 100644
>>>>>>>>>>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>>>>>>>>>>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>>>>>>>>>>>> @@ -1429,6 +1429,8 @@ enum FW_BOOT_CONTEXT {
>>>>>>>>>>>>    #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
>>>>>>>>>>>>    #define MR_MAX_MSIX_REG_ARRAY                   16
>>>>>>>>>>>>    #define MR_RDPQ_MODE_OFFSET                       0X0
>>>>>>>>>>>> 0800
>>>>>>>>>>>> 000
>>>>>>>>>>>> +#define MR_CAN_HANDLE_SYNC_CACHE_OFFSET             0
>>>>>>>>>>>> X010
>>>>>>>>>>>> 0000
>>>>>>>>>>>> 0
>>>>>>>>>>>> +
>>>>>>>>>>>>    /*
>>>>>>>>>>>>    * register set for both 1068 and 1078 controllers
>>>>>>>>>>>>    * structure extended for 1078 registers @@ -2140,6
>>>>>>>>>>>> +2142,7
>>>>>>>>>>>> @@ struct megasas_instance {
>>>>>>>>>>>>      u8 is_imr;
>>>>>>>>>>>>      u8 is_rdpq;
>>>>>>>>>>>>      bool dev_handle;
>>>>>>>>>>>> +    bool fw_sync_cache_support;
>>>>>>>>>>>>    };
>>>>>>>>>>>>    struct MR_LD_VF_MAP {
>>>>>>>>>>>>      u32 size;
>>>>>>>>>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>>>>>>>>>>>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>>>>>>>>>> index 092387f..a4a8e2f 100644
>>>>>>>>>>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>>>>>>>>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>>>>>>>>>> @@ -104,6 +104,10 @@ unsigned int scmd_timeout =
>>>>>>>>>>>> MEGASAS_DEFAULT_CMD_TIMEOUT;
>>>>>>>>>>>>    module_param(scmd_timeout, int, S_IRUGO);
>>>>>>>>>>>>    MODULE_PARM_DESC(scmd_timeout, "scsi command
>> timeout
>>>>>>>>>>>> (10
>>>>>>>>>>>> -90s), default 90s. See megasas_reset_timer.");
>>>>>>>>>>>>
>>>>>>>>>>>> +bool block_sync_cache;
>>>>>>>>>>>> +module_param(block_sync_cache, bool, S_IRUGO);
>>>>>>>>>>>> +MODULE_PARM_DESC(block_sync_cache, "Block SYNC CACHE
>> by
>>>>>>>>>>>> driver
>>>>>>>>>>>> Default: 0(Send it to firmware)");
>>>>>>>>>>>> +
>>>>>>>>>>>>    MODULE_LICENSE("GPL");
>>>>>>>>>>>>    MODULE_VERSION(MEGASAS_VERSION);
>>>>>>>>>>>>    MODULE_AUTHOR("megaraidlinux.pdl@avagotech.com");
>>>>>>>>>>>> @@ -1700,16 +1704,10 @@ megasas_queue_command(struct
>>>>>>> Scsi_Host
>>>>>>>>>>>> *shost, struct scsi_cmnd *scmd)
>>>>>>>>>>>>              goto out_done;
>>>>>>>>>>>>      }
>>>>>>>>>>>>
>>>>>>>>>>>> -    switch (scmd->cmnd[0]) {
>>>>>>>>>>>> -    case SYNCHRONIZE_CACHE:
>>>>>>>>>>>> -            /*
>>>>>>>>>>>> -             * FW takes care of flush cache on its
>>>>>>>>>>>> own
>>>>>>>>>>>> -             * No need to send it down
>>>>>>>>>>>> -             */
>>>>>>>>>>>> +    if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) &&
>>>>>>>>>>>> +            (!instance->fw_sync_cache_support)) {
>>>>>>>>>>>>              scmd->result = DID_OK << 16;
>>>>>>>>>>>>              goto out_done;
>>>>>>>>>>>> -    default:
>>>>>>>>>>>> -            break;
>>>>>>>>>>>>      }
>>>>>>>>>>>>
>>>>>>>>>>>>      return instance->instancet
>>>>>>>>>>>> ->build_and_issue_cmd(instance, scmd);
>>>>>>>>>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>>>>>>>>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>>>>>>>>>> index 2159f6a..8237580 100644
>>>>>>>>>>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>>>>>>>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>>>>>>>>>> @@ -747,6 +747,9 @@ megasas_ioc_init_fusion(struct
>>>>>>>>>>>> megasas_instance *instance)
>>>>>>>>>>>>              ret = 1;
>>>>>>>>>>>>              goto fail_fw_init;
>>>>>>>>>>>>      }
>>>>>>>>>>>> +    if (!block_sync_cache)
>>>>>>>>>>>> +            instance->fw_sync_cache_support =
>>>>>>>>>>>> (scratch_pad_2
>>>>>>>>>>>> &
>>>>>>>>>>>> +                    MR_CAN_HANDLE_SYNC_CACHE_OFFSET)
>>>>>>>>>>>> ? 1
>>>>>>>>>>>> :
>>>>>>>>>>>> 0;
>>>>>>>>>>>>
>>>>>>>>>>>>      IOCInitMessage =
>>>>>>>>>>>>        dma_alloc_coherent(&instance->pdev->dev,
>>>>>>>>>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>>>>>>>>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>>>>>>>>>> index e3bee04..2857154 100644
>>>>>>>>>>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>>>>>>>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>>>>>>>>>>>> @@ -72,6 +72,8 @@
>>>>>>>>>>>>    #define MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET
>>>>>>>>>>>>  (0x0000030C)
>>>>>>>>>>>>    #define MPI2_REPLY_POST_HOST_INDEX_OFFSET (0x00
>>>>>>>>>>>> 0000
>>>>>>>>>>>> 6C)
>>>>>>>>>>>>
>>>>>>>>>>>> +extern bool block_sync_cache;
>>>>>>>>>>>> +
>>>>>>>>>>>>    /*
>>>>>>>>>>>>     * Raid context flags
>>>>>>>>>>>>     */
>>>>>>>>>>>>
>>>>>>>>>>> Be extra careful with that.
>>>>>>>>>>>
>>>>>>>>>>> SYNCHRONIZE_CACHE has (potentially) a global scope, as
>>>>>>>>>>> there
>>>>>>>>>>> might be an array-wide cache, and a cache flush would
>>>>>>>>>>> affect the
>>>>>>>>>>> entire cache. Linux is using SYNCHRONIZE_CACHE as a per
>>>>>>>>>>> device
>>>>>>>>>>> setting, ie it assumes that the effects of a cache flush is
>>>>>>>>>>> restricted to the device in question.
>>>>>>>>>>>
>>>>>>>>>>> If this is _not_ the case I'd rather not enable it.
>>>>>>>>>>> Have you checked that enabling this functionality doesn't
>>>>>>>>>>> have
>>>>>>>>>>> negative performance impact?
>>>>>>>>>>>
>>>>>>>>>>> Cheers,
>>>>>>>>>>>
>>>>>>>>>>> Hannes
>>>>>>>>>> This must go in - without this fix, there is no data
>>>>>>>>>> integrity for
>>>>>>>>>> any file system.
>>>>>>>>> That's not what I get from the change log.  What it says to me
>>>>>>>>> is
>>>>>>>>> that the caches are currently firmware managed.  Barring
>>>>>>>>> firmware
>>>>>>>>> bugs, that means that we currently don't have any integrity
>>>>>>>>> issues.
>>>>>>>> Your understanding (or the change log) is incorrect.
>>>>>>> There's no current way in English of construing "as firmware takes
>>>>>>> care of
>>>>>>> flushing cache" to mean its inverse, so the changelog needs
>>>>>>> updating to
>>>>>>> explain
>>>>>>> that firmware does *not* take care of cache flushing, so
>>>>>>> effectively
>>>>>>> nothing
>>>>>>> does and we'll need a cc to stable if the problem is that nothing
>>>>>>> takes
>>>>>>> care of
>>>>>>> flushing the drive caches.
>>>>>>>
>>>>>>> James
>>>>>> Sorry for confusion. More accurate to say  -
>>>>>>
>>>>>> Current megaraid_sas driver returns SYNCHRONIZE_CACHE command
>> back to
>>>>>> SCSI layer without sending it down to firmware as firmware supposed
>>>>>> to takes care of flushing cache for all Virtual Disk at the time of
>>>>>> system reboot/shutdown. Because of above FW rule driver coded
>> wrongly
>>>>>> and it added bug that SYNCHRONIZE_CACHE is not passed to FW for
>> JBOD
>>>>>> as well.  (MR Firmware wanted OS to manage SYNCHRONIZE_CACHE
>> and pass
>>>>>> the same to the Firmware. ). We figure out that even for VD, why
>>>>>> driver should send back SYNC_CACHE command...let's have the same
>> in
>>>>>> FW (giving all control in FW)
>>>>>>
>>>>>> New behavior described -
>>>>>>
>>>>>> IF application requests SYNCH_CACHE
>>>>>>  IF any FW which supports new API bit called canHandleSyncCache
>>>>>>   Driver sends SYNCH_CACHE command to the FW
>>>>>>   IF 'VirtualDisk'
>>>>>>       FW does not send SYNCH_CACHE to drives
>>>>>>       FW returns SUCCESS
>>>>>> ELSE IF 'JBOD'
>>>>>>      FW sends SYNCH_CACHE to drive
>>>>>>      FW obtains status from drive and returns same status back to
>>>>>> driver
>>>>>>   ENDIF
>>>>>>
>>>>>> Fixing this is robust if FW and driver changes are inline. See below
>>>>>> for more detail.
>>>>>>
>>>>>> Case - 1
>>>>>> This patch is attempt to fix one level problem where Virtual Disks
>>>>>> are not managed correctly in MR FW. There are some MR FW (E.a Gen2
>>>>>> and Gen2.5 FW), which set WCE bit for Virtual Disk but FW is not
>>>>>> reply correct for SYNCH_CACHE.  This was handled in past and carry
>>>>>> forward (in driver + FW ) to all new generation products as well. We
>>>>>> tried to collect all possible details why it was handled such way to
>>>>>> provide better driver fix for this issue(mainly to avoid this FW
>>>>>> checks and module  parameters etc..). But now it looks like to make
>>>>>> generic fix (Device ID based etc..)is even risky, so went with this
>>>>>> protective approach.  It is very risky to find out which Device ID
>>>>>> and FW has capability to manage SYNC_CACHE, so we managed to
>> figure
>>>>>> out which are the new FW using FW capability bit.
>>>>>>
>>>>>> E.g Liberator/Thunderbolt MR FW SYNC_CACHE is write Unsupported
>>>>>> command (this is a firmware bug) and immediately it will be failed to
>>>>>> SML. This will cause File system to go Read-only.
>>>>> That's a better description ... what you're saying is that the patch
>>>>> doesn't actually fix the bug Ric is worrying about.
>>>>>
>>>>>> Case -2
>>>>>> One more thing which we are trying and known driver can send
>>>>>> "SYNC_CACHE" unconditionally to all generation of FW.  For this we
>>>>>> are doing more unit testing on various controllers/FW and planning to
>>>>>> provide another patch to fix JBOD path for any FW. (It will not be
>>>>>> based on FW capability/module parameter).
>>>>> OK, but we really need this ASAP.  As Ric said, data integrity is at
>>>>> risk until this is fixed.  Can you also reference the commit that
>>>>> introduced the problem so we know how far to do the sable backports?
>>>>>
>>>>>> If we remove module parameter, we can ask customer to disable WCE
>> on
>>>>>> drive to get similar impact.
>>>>> Thanks,
>>>>>
>>>>> James
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���"�{ay�
ʇڙ�,j��f���h���z�
�w���
���j:+v���w�j�m��������zZ+�����ݢj"��!tml=


