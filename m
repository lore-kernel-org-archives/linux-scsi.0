From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 4/6] hisi_sas: use slot abort in v2 hw
Date: Tue, 16 Feb 2016 16:58:50 +0000
Message-ID: <56C3554A.9040106@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
 <1455625351-165881-5-git-send-email-john.garry@huawei.com>
 <56C34111.7080400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C34111.7080400@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 16/02/2016 15:32, Hannes Reinecke wrote:
> On 02/16/2016 01:22 PM, John Garry wrote:
>> When TRANS_TX_ERR_FRAME_TXED error occurs for
>> a command, the command should be re-attempted.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 19 +++++++++++++++++--
>>   1 file changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> index 58e1956..2bf93079b 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> @@ -1190,7 +1190,8 @@ static void sata_done_v2_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
>>   /* by default, task resp is complete */
>>   static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
>>   			   struct sas_task *task,
>> -			   struct hisi_sas_slot *slot)
>> +			   struct hisi_sas_slot *slot,
>> +			   int *abort_slot)
>>   {
>>   	struct task_status_struct *ts = &task->task_status;
>>   	struct hisi_sas_err_record_v2 *err_record = slot->status_buffer;
>> @@ -1299,6 +1300,13 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
>>   			ts->stat = SAS_DATA_UNDERRUN;
>>   			break;
>>   		}
>> +		case TRANS_TX_ERR_FRAME_TXED:
>> +		{
>> +			/* This will request a retry */
>> +			ts->stat = SAS_QUEUE_FULL;
>> +			++(*abort_slot);
>> +			break;
>> +		}
>>   		case TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS:
>>   		case TRANS_TX_ERR_PHY_NOT_ENABLE:
>>   		case TRANS_TX_OPEN_CNX_ERR_BY_OTHER:
>> @@ -1491,11 +1499,17 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
>>
>>   	if ((complete_hdr->dw0 & CMPLT_HDR_ERX_MSK) &&
>>   		(!(complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK))) {
>> +		int abort_slot = 0;
>>   		dev_dbg(dev, "%s slot %d has error info 0x%x\n",
>>   			__func__, slot->cmplt_queue_slot,
>>   			complete_hdr->dw0 & CMPLT_HDR_ERX_MSK);
>>
>> -		slot_err_v2_hw(hisi_hba, task, slot);
>> +		slot_err_v2_hw(hisi_hba, task, slot, &abort_slot);
>> +		if (unlikely(abort_slot)) {
>> +			queue_work(hisi_hba->wq, &slot->abort_slot);
>> +			sts = ts->stat;
>> +			goto out_1;
>> +		}
>>   		goto out;
>>   	}
>>
> Again this weird 'abort_slot' pointer reshuffling.
> Care to clarify?
>
> Cheers,
>
> Hannes
>

Hopefully my explanation for patch #3 will help clarify here, as the 
code is functionally the same.

Thanks,
John
