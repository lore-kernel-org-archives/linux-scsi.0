From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 3/6] hisi_sas: use slot abort in v1 hw
Date: Tue, 16 Feb 2016 16:13:29 +0000
Message-ID: <56C34AA9.8080604@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-4-git-send-email-john.garry@huawei.com>
 <56C340E9.1030503@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C340E9.1030503@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 16/02/2016 15:31, Hannes Reinecke wrote:
> On 02/16/2016 01:22 PM, John Garry wrote:
>> When TRANS_TX_CREDIT_TIMEOUT_ERR or
>> TRANS_TX_CLOSE_NORMAL_ERR errors occur for a
>> command, the command should be re-attempted.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 22 ++++++++++++++++++----
>>   1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>> index ce5f65d..34f71a1c 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>> @@ -1118,9 +1118,8 @@ static int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
>>   }
>>
>>   /* by default, task resp is complete */
>> -static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
>> -			   struct sas_task *task,
>> -			   struct hisi_sas_slot *slot)
>> +static void slot_err_v1_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
>> +			   struct hisi_sas_slot *slot, int *abort_slot)
>>   {
>>   	struct task_status_struct *ts = &task->task_status;
>>   	struct hisi_sas_err_record_v1 *err_record = slot->status_buffer;
>> @@ -1212,6 +1211,14 @@ static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
>>   			ts->stat = SAS_NAK_R_ERR;
>>   			break;
>>   		}
>> +		case TRANS_TX_CREDIT_TIMEOUT_ERR:
>> +		case TRANS_TX_CLOSE_NORMAL_ERR:
>> +		{
>> +			/* This will request a retry */
>> +			ts->stat = SAS_QUEUE_FULL;
>> +			++(*abort_slot);
>> +			break;
>> +		}
>>   		default:
>>   		{
>>   			ts->stat = SAM_STAT_CHECK_CONDITION;
>> @@ -1317,8 +1324,14 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
>>
>>   	if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK &&
>>   		!(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
>> +		int abort_slot = 0;
>>
>> -		slot_err_v1_hw(hisi_hba, task, slot);
>> +		slot_err_v1_hw(hisi_hba, task, slot,  &abort_slot);
>> +		if (unlikely(abort_slot)) {
>> +			queue_work(hisi_hba->wq, &slot->abort_slot);
>> +			sts = ts->stat;
>> +			goto out_1;
>> +		}
>>   		goto out;
>>   	}
>>
> What is the 'abort_slot' variable for?
> Currently it's just a counter, no?
> So why the weird pointer passing?
>
> And it does feel weird. Apparently the driver does get a message,
> but still has to abort the command. Why?
> Isn't the message an indicator that the command has been aborted?
>
> Cheers,
>
> Hannes
>

I'll paste some more code for convenience and to help clarify:

static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
                    struct hisi_sas_slot *slot, int abort)
{
...

     if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK &&
         !(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
         int abort_slot = 0;

         slot_err_v1_hw(hisi_hba, task, slot,  &abort_slot);
         if (unlikely(abort_slot)) { /* check if we need to abort the 
task */
             queue_work(hisi_hba->wq, &slot->abort_slot);
             sts = ts->stat;
             goto out_1;
         }
         goto out;
     }

  ...

out:
     if (sas_dev && sas_dev->running_req)
         sas_dev->running_req--;

     hisi_sas_slot_task_free(hisi_hba, task, slot);
     sts = ts->stat;

     if (task->task_done)
         task->task_done(task);
out_1:

     return sts;
}

Variable abort_slot is really a boolean flag which can be set in 
slot_err_v1_hw(). When error TRANS_TX_CREDIT_TIMEOUT_ERR or 
TRANS_TX_CLOSE_NORMAL_ERR occurs in the slot, abort_slot is set. In this 
case we don't immediately complete the task (goto out and call 
hisi_sas_slot_task_free() and task->task_done()), but instead queue the 
task to be aborted in the device before completing (call queue_work() 
and then goto out_1).
When hisi_sas_slot_abort() [patch #2] runs in the workqueue for the 
task, it first aborts the task in the device with a TMF, and then 
completes the task. Finally the status (SAS_QUEUE_FULL) is passed back 
to SCSI framework, which will request a retry for the scsi command.

This is the method our hw people recommended to handle these types of 
errors.

Hope this explains,
Cheers,
John
