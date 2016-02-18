From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/6] hisi_sas: add hisi_sas_slot_abort()
Date: Thu, 18 Feb 2016 09:30:56 +0000
Message-ID: <56C58F50.5000903@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-3-git-send-email-john.garry@huawei.com>
 <56C33EC2.3020005@suse.de> <56C34342.9050605@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:59414 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425542AbcBRJbn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2016 04:31:43 -0500
In-Reply-To: <56C34342.9050605@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, john.garry2@mail.dcu.ie, linux-kernel@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org

On 16/02/2016 15:41, John Garry wrote:
> On 16/02/2016 15:22, Hannes Reinecke wrote:
>> On 02/16/2016 01:22 PM, John Garry wrote:
>>> Add a function to abort a slot (task) in the device
>>> (if it is in the task set) and then cleanup and
>>> complete the task.
>>> The function is called from work queue context as
>>> it cannot be called from the context where it is
>>> triggered (interrupt).
>>>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> ---
>>>   drivers/scsi/hisi_sas/hisi_sas.h      |  1 +
>>>   drivers/scsi/hisi_sas/hisi_sas_main.c | 43
>>> +++++++++++++++++++++++++++++++++++
>>>   2 files changed, 44 insertions(+)
>>>
>>> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h
>>> b/drivers/scsi/hisi_sas/hisi_sas.h
>>> index 02da7e4..a05ce71 100644
>>> --- a/drivers/scsi/hisi_sas/hisi_sas.h
>>> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
>>> @@ -120,6 +120,7 @@ struct hisi_sas_slot {
>>>       dma_addr_t command_table_dma;
>>>       struct hisi_sas_sge_page *sge_page;
>>>       dma_addr_t sge_page_dma;
>>> +    struct work_struct abort_slot;
>>>   };
>>>
>>>   struct hisi_sas_tmf_task {
>>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c
>>> b/drivers/scsi/hisi_sas/hisi_sas_main.c
>>> index c600f5e..65509eb 100644
>>> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
>>> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
>>> @@ -15,6 +15,9 @@
>>>   #define DEV_IS_GONE(dev) \
>>>       ((!dev) || (dev->dev_type == SAS_PHY_UNUSED))
>>>
>>> +static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
>>> +                u8 *lun, struct hisi_sas_tmf_task *tmf);
>>> +
>>>   static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
>>>   {
>>>       return device->port->ha->lldd_ha;
>>> @@ -113,6 +116,45 @@ static int hisi_sas_task_prep_ata(struct
>>> hisi_hba *hisi_hba,
>>>       return hisi_hba->hw->prep_stp(hisi_hba, slot);
>>>   }
>>>
>>> +/*
>>> + * This function will issue an abort TMF if a task is still in
>>> + * the target. Then it will do the task complete cleanup and
>>> + * callbacks.
>>> + */
>>> +static void hisi_sas_slot_abort(struct work_struct *work)
>>> +{
>>> +    struct hisi_sas_slot *abort_slot =
>>> +        container_of(work, struct hisi_sas_slot, abort_slot);
>>> +    struct sas_task *task = abort_slot->task;
>>> +    struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
>>> +    struct scsi_cmnd *cmnd = task->uldd_task;
>>> +    struct hisi_sas_tmf_task tmf_task;
>>> +    struct domain_device *device = task->dev;
>>> +    struct hisi_sas_device *sas_dev = device->lldd_dev;
>>> +    struct scsi_lun lun;
>>> +    int tag = abort_slot->idx, rc;
>>> +
>>> +    int_to_scsilun(cmnd->device->lun, &lun);
>>> +    tmf_task.tmf = TMF_QUERY_TASK;
>>> +    tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
>>> +
>>> +    rc = hisi_sas_debug_issue_ssp_tmf(task->dev, lun.scsi_lun,
>>> &tmf_task);
>>> +
>>> +    /* TMF_RESP_FUNC_SUCC means task is present in the task set */
>>> +    if (rc != TMF_RESP_FUNC_SUCC)
>>> +        goto out;
>>> +    tmf_task.tmf = TMF_ABORT_TASK;
>>> +    tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
>>> +
>>> +    rc = hisi_sas_debug_issue_ssp_tmf(task->dev, lun.scsi_lun,
>>> &tmf_task);
>>> +out:
>>> +    hisi_sas_slot_task_free(hisi_hba, task, abort_slot);
>>> +    if (task->task_done)
>>> +        task->task_done(task);
>>> +    if (sas_dev && sas_dev->running_req)
>>> +        sas_dev->running_req--;
>>> +}
>>> +
>>>   static int hisi_sas_task_prep(struct sas_task *task, struct
>>> hisi_hba *hisi_hba,
>>>                     int is_tmf, struct hisi_sas_tmf_task *tmf,
>>>                     int *pass)
>> Do you really need to query the task first?
>> As per SAM a successful return from an ABORT TASK TMF has this meaning:
>>
>> A response of FUNCTION COMPLETE shall indicate that the task was
>> aborted or was not in the task set.
>>
>> Ie it doesn't matter if the task was present or not.
>>
>> Cheers,
>>
>> Hannes
>>
>
> I think that it should be ok to the abort without first querying. I'll
> just test this to double-check. (This would make the first patch in the
> series superflous)
>
> Cheers,
> John
>
>
> _______________________________________________
> linuxarm mailing list
> linuxarm@huawei.com
> http://rnd-openeuler.huawei.com/mailman/listinfo/linuxarm

As suggested, it is ok to remove the query tmf.

Thanks,
John

