From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 3/6] hisi_sas: use slot abort in v1 hw
Date: Thu, 18 Feb 2016 09:52:23 +0000
Message-ID: <56C59457.9040202@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-4-git-send-email-john.garry@huawei.com>
 <56C340E9.1030503@suse.de> <56C34AA9.8080604@huawei.com>
 <56C56FDB.5050802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C56FDB.5050802@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>    /* by default, task resp is complete */
>>>> -static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
>>>> -               struct sas_task *task,
>>>> -               struct hisi_sas_slot *slot)
>>>> +static void slot_err_v1_hw(struct hisi_hba *hisi_hba, struct
>>>> sas_task *task,
>>>> +               struct hisi_sas_slot *slot, int *abort_slot)
>>>>    {
>>>>        struct task_status_struct *ts = &task->task_status;
>>>>        struct hisi_sas_err_record_v1 *err_record =
>>>> slot->status_buffer;
>>>> @@ -1212,6 +1211,14 @@ static void slot_err_v1_hw(struct hisi_hba
>>>> *hisi_hba,
>>>>                ts->stat = SAS_NAK_R_ERR;
>>>>                break;
>>>>            }
>>>> +        case TRANS_TX_CREDIT_TIMEOUT_ERR:
>>>> +        case TRANS_TX_CLOSE_NORMAL_ERR:
>>>> +        {
>>>> +            /* This will request a retry */
>>>> +            ts->stat = SAS_QUEUE_FULL;
>>>> +            ++(*abort_slot);
>>>> +            break;
>>>> +        }
>>>>            default:
>>>>            {
>>>>                ts->stat = SAM_STAT_CHECK_CONDITION;
>>>> @@ -1317,8 +1324,14 @@ static int slot_complete_v1_hw(struct
>>>> hisi_hba *hisi_hba,
>>>>
>>>>        if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK &&
>>>>            !(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
>>>> +        int abort_slot = 0;
>>>>
>>>> -        slot_err_v1_hw(hisi_hba, task, slot);
>>>> +        slot_err_v1_hw(hisi_hba, task, slot,  &abort_slot);
>>>> +        if (unlikely(abort_slot)) {
>>>> +            queue_work(hisi_hba->wq, &slot->abort_slot);
>>>> +            sts = ts->stat;
>>>> +            goto out_1;
>>>> +        }
>>>>            goto out;
>>>>        }
>>>>
>>
>> static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
>>                     struct hisi_sas_slot *slot, int abort)
>> {
>> ...
>>
>>      if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK &&
>>          !(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
>>          int abort_slot = 0;
>>
>>          slot_err_v1_hw(hisi_hba, task, slot,  &abort_slot);
>>          if (unlikely(abort_slot)) { /* check if we need to abort the
>> task */
>>              queue_work(hisi_hba->wq, &slot->abort_slot);
>>              sts = ts->stat;
>>              goto out_1;
>>          }
>>          goto out;
>>      }

>>
>> Variable abort_slot is really a boolean flag which can be set in
>> slot_err_v1_hw(). When error TRANS_TX_CREDIT_TIMEOUT_ERR or
>> TRANS_TX_CLOSE_NORMAL_ERR occurs in the slot, abort_slot is set. In
>> this case we don't immediately complete the task (goto out and call
>> hisi_sas_slot_task_free() and task->task_done()), but instead queue
>> the task to be aborted in the device before completing (call
>> queue_work() and then goto out_1).
> So why not make slot_err_vi_hw() a boolean and have abort_slot as
> the return value?
>

I am not happy that this function should return anything, more 
specifically only whether the task should be aborted. I would be 
concerned that if it did return this value then it may have to be 
changed later on if the code needs to be changed. However it would make 
the code a bit tighter now.

Alternatively I could pass a pointer to a boolean (sounds bad), or even 
inline slot_err_v1_hw() in slot_complete_v1_hw(), as this is the only 
place it is called from.

Cheers,
John
