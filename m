From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH V3 2/4] scsi: ufs: Fix hardware race conditions while
 aborting a command
Date: Fri, 19 Jul 2013 23:56:42 +0530
Message-ID: <51E984E2.4060704@codeaurora.org>
References: <1373361378-30749-1-git-send-email-sthumma@codeaurora.org> <1373361378-30749-3-git-send-email-sthumma@codeaurora.org> <002001ce8487$d46010c0$7d203240$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <002001ce8487$d46010c0$7d203240$%jun@samsung.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/19/2013 7:26 PM, Seungwon Jeon wrote:
> On Tue, July 09, 2013, Sujit Reddy Thumma wrote:
>> There is a possible race condition in the hardware when the abort
>> command is issued to terminate the ongoing SCSI command as described
>> below:
>>
>> - A bit in the door-bell register is set in the controller for a
>>    new SCSI command.
>> - In some rare situations, before controller get a chance to issue
>>    the command to the device, the software issued an abort command.
> It's interesting.
> I wonder when we can meet this situation.
> Is it possible if SCSI mid layer should send abort command as soon as the transfer command is issued?
> AFAIK abort command is followed if one command has timed out.
> That means command have been already issued and no response?
> If you had some problem, could you share?

You are right. This is a very rare case and probably don't happen at all
until and unless the SCSI error handling is changed. We found it just by
static analysis. Probably, at some point I may push a patch that tries
to reduce the read latencies while aborting a large write transfer when
I come across a UFS device that has command per LU as 1 :-)

I guess this is good to have change. The path chosen is according to
SCSI SAM-5 architecture specification, so I don't expect any issues
here.

> 
>> - If the device recieves abort command first then it returns success
> receives
> 
>>    because the command itself is not present.
>> - Now if the controller commits the command to device it will be
>>    processed.
>> - Software thinks that command is aborted and proceed while still
>>    the device is processing it.
>> - The software, controller and device may go out of sync because of
>>    this race condition.
>>
>> To avoid this, query task presence in the device before sending abort
>> task command so that after the abort operation, the command is guaranteed
>> to be non-existent in both controller and the device.
>>
>> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c |   70 +++++++++++++++++++++++++++++++++++---------
>>   1 files changed, 55 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index a176421..51ce096 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2550,6 +2550,12 @@ static int ufshcd_host_reset(struct scsi_cmnd *cmd)
>>    * ufshcd_abort - abort a specific command
>>    * @cmd: SCSI command pointer
>>    *
>> + * Abort the pending command in device by sending UFS_ABORT_TASK task management
>> + * command, and in host controller by clearing the door-bell register. There can
>> + * be race between controller sending the command to the device while abort is
>> + * issued. To avoid that, first issue UFS_QUERY_TASK to check if the command is
>> + * really issued and then try to abort it.
>> + *
>>    * Returns SUCCESS/FAILED
>>    */
>>   static int ufshcd_abort(struct scsi_cmnd *cmd)
>> @@ -2558,7 +2564,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>>   	struct ufs_hba *hba;
>>   	unsigned long flags;
>>   	unsigned int tag;
>> -	int err;
>> +	int err = 0;
>> +	int poll_cnt;
>>   	u8 resp;
>>   	struct ufshcd_lrb *lrbp;
>>
>> @@ -2566,33 +2573,59 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>>   	hba = shost_priv(host);
>>   	tag = cmd->request->tag;
>>
>> -	spin_lock_irqsave(host->host_lock, flags);
>> +	/* If command is already aborted/completed, return SUCCESS */
>> +	if (!(test_bit(tag, &hba->outstanding_reqs)))
>> +		goto out;
>>
>> -	/* check if command is still pending */
>> -	if (!(test_bit(tag, &hba->outstanding_reqs))) {
>> -		err = FAILED;
>> -		spin_unlock_irqrestore(host->host_lock, flags);
>> +	lrbp = &hba->lrb[tag];
>> +	for (poll_cnt = 100; poll_cnt; poll_cnt--) {
>> +		err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
>> +				UFS_QUERY_TASK, &resp);
>> +		if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {
>> +			/* cmd pending in the device */
>> +			break;
>> +		} else if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
>> +			u32 reg;
>> +
>> +			/*
>> +			 * cmd not pending in the device, check if it is
>> +			 * in transition.
>> +			 */
>> +			reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>> +			if (reg & (1 << tag)) {
>> +				/* sleep for max. 2ms to stabilize */
>> +				usleep_range(1000, 2000);
>> +				continue;
>> +			}
>> +			/* command completed already */
>> +			goto out;
>> +		} else {
>> +			if (!err)
>> +				err = resp; /* service response error */
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	if (!poll_cnt) {
>> +		err = -EBUSY;
>>   		goto out;
>>   	}
>> -	spin_unlock_irqrestore(host->host_lock, flags);
>>
>> -	lrbp = &hba->lrb[tag];
>>   	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
>>   			UFS_ABORT_TASK, &resp);
>>   	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
>> -		err = FAILED;
>> +		if (!err)
>> +			err = resp; /* service response error */
>>   		goto out;
>> -	} else {
>> -		err = SUCCESS;
>>   	}
>>
>> +	err = ufshcd_clear_cmd(hba, tag);
>> +	if (err)
>> +		goto out;
>> +
>>   	scsi_dma_unmap(cmd);
>>
>>   	spin_lock_irqsave(host->host_lock, flags);
>> -
>> -	/* clear the respective UTRLCLR register bit */
>> -	ufshcd_utrl_clear(hba, tag);
>> -
>>   	__clear_bit(tag, &hba->outstanding_reqs);
>>   	hba->lrb[tag].cmd = NULL;
>>   	spin_unlock_irqrestore(host->host_lock, flags);
>> @@ -2600,6 +2633,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>>   	clear_bit_unlock(tag, &hba->lrb_in_use);
>>   	wake_up(&hba->dev_cmd.tag_wq);
>>   out:
>> +	if (!err) {
>> +		err = SUCCESS;
>> +	} else {
>> +		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
>> +		err = FAILED;
>> +	}
>> +
>>   	return err;
>>   }
>>
>> --
>> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
>> of Code Aurora Forum, hosted by The Linux Foundation.
>>

-- 
Regards,
Sujit
