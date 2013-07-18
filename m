From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH V3 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
Date: Thu, 18 Jul 2013 09:18:38 +0530
Message-ID: <51E76596.5090509@codeaurora.org>
References: <1373361310-30674-1-git-send-email-sthumma@codeaurora.org> <1373361310-30674-2-git-send-email-sthumma@codeaurora.org> <002501ce7d71$4c7a8f40$e56fadc0$%jun@samsung.com> <51DE7D08.9000306@codeaurora.org> <001a01ce82c5$8bd47d50$a37d77f0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:33080 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994Ab3GRDsp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jul 2013 23:48:45 -0400
In-Reply-To: <001a01ce82c5$8bd47d50$a37d77f0$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 'Dolev Raviv' <draviv@codeaurora.org>



>>>> + * ufshcd_wait_for_register - wait for register value to change
>>>> + * @hba - per-adapter interface
>>>> + * @reg - mmio register offset
>>>> + * @mask - mask to apply to read register value
>>>> + * @val - wait condition
>>>> + * @interval_us - polling interval in microsecs
>>>> + * @timeout_ms - timeout in millisecs
>>>> + *
>>>> + * Returns final register value after iteration
>>>> + */
>>>> +static u32 ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
>>>> +		u32 val, unsigned long interval_us, unsigned long timeout_ms)
>>> I feel like this function's role is to wait for clearing register (specially, doorbells).
>>> If you really don't intend to apply other all register, I think it would better to change the
>> function name.
>>> ex> ufshcd_wait_for_clear_doorbell or ufshcd_wait_for_clear_reg?
>>
>> Although, this API is introduced in this patch and used only for
>> clearing the doorbell, I have intentionally made it generic to avoid
>> duplication of wait condition code in future (not just clearing but
>> also for setting a bit). For example, when we write to HCE.ENABLE we
>> wait for it turn to 1.
>>
>>
>>> And if you like it, it could be more simple like below
>>>
>>> static bool ufshcd_wait_for_clear_reg(struct ufs_hba *hba, u32 reg, u32 mask,
>>>                                            unsigned long interval_us,
>>>                                            unsigned int timeout_ms)
>>> {
>>>           unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
>>
>> Jiffies on 100Hz systems have minimum granularity of 10ms. So we really
>> wait for more 10ms even though the timeout_ms < 10ms.
> Yes. Real timeout depends on system.
> But normally actual wait will be maintained until 'ufshcd_readl' is done.
> Timeout is valid for failure case.  If we don't need to apply a strict timeout value, it's not bad.

Hmm.. make sense. Will take care in the next patchset.

>
>>
>>>           /* wakeup within 50us of expiry */
>>>           const unsigned int expiry = 50;
>>>
>>>           while (ufshcd_readl(hba, reg) & mask) {
>>>                   usleep_range(interval_us, interval_us + expiry);
>>>                   if (time_after(jiffies, timeout)) {
>>>                           if (ufshcd_readl(hba, reg) & mask)
>>>                                   return false;
>>
>> I really want the caller to decide on what to do after the timeout.
>> This helps in error handling cases where we try to clear off the entire
>> door-bell register but only a few of the bits are cleared after timeout.
> I don't know what we can do with the report of the partial success on clearing bit.
> It's just failure case. Isn't enough with false/true?

The point is, if a bit can't be cleared it can be regarded as a
permanent failure (only for that request), otherwise, it can be
retried with the same tag value.

>
>>
>>>                           else
>>>                                   return true;
>>>                   }
>>>           }
>>>
>>>           return true;
>>> }
>>>> +{
>>>> +	u32 tmp;
>>>> +	ktime_t start;
>>>> +	unsigned long diff;
>>>> +
>>>> +	tmp = ufshcd_readl(hba, reg);
>>>> +
>>>> +	if ((val & mask) != val) {
>>>> +		dev_err(hba->dev, "%s: Invalid wait condition 0x%x\n",
>>>> +				__func__, val);
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	start = ktime_get();
>>>> +	while ((tmp & mask) != val) {
>>>> +		/* wakeup within 50us of expiry */
>>>> +		usleep_range(interval_us, interval_us + 50);
>>>> +		tmp = ufshcd_readl(hba, reg);
>>>> +		diff = ktime_to_ms(ktime_sub(ktime_get(), start));
>>>> +		if (diff > timeout_ms) {
>>>> +			tmp = ufshcd_readl(hba, reg);
>>>> +			break;
>>>> +		}
>>>> +	}
>>>> +out:
>>>> +	return tmp;
>>>> +}
>>>> +
..
>>>> +static int
>>>> +ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
>>>> +{
>>>> +	int err = 0;
>>>> +	unsigned long flags;
>>>> +	u32 reg;
>>>> +	u32 mask = 1 << tag;
>>>> +
>>>> +	/* clear outstanding transaction before retry */
>>>> +	spin_lock_irqsave(hba->host->host_lock, flags);
>>>> +	ufshcd_utrl_clear(hba, tag);
>>>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
>>>> +
>>>> +	/*
>>>> +	 * wait for for h/w to clear corresponding bit in door-bell.
>>>> +	 * max. wait is 1 sec.
>>>> +	 */
>>>> +	reg = ufshcd_wait_for_register(hba,
>>>> +			REG_UTP_TRANSFER_REQ_DOOR_BELL,
>>>> +			mask, 0, 1000, 1000);
>>> 4th argument should be (~mask) instead of '0', right?
>>
>> True, but not really for this implementation. It breaks the check in
>> in wait_for_register -
>> if ((val & mask) != val)
>>              dev_err(...);
> Hmm, it seems complicated to use.
> Ok. Is right the following about val as 4th argument?
> - clear: val  should be '0' regardless corresponding bit.
> - set: val should be same with mask.
> If the related comment is added, it will be helpful.

Thinking again it looks like it is complicated. How about changing
the check to -

val = val & mask; /* ignore the bits we don't intend to wait on */
while (ufshcd_readl() & mask != val) {
  sleep
}

Usage will be ~mask for clearing the bits, mask for setting the bits
in the fourth argument.

>
>>
>>> Actually, mask value involves the corresponding bit to be cleared.
>>> So, 4th argument may be unnecessary.
>>
>> As I described above, the wait_for_register can also be used to
>> check if the value is set or not. In which case, we need 4th argument.
>>
>>>
>>>> +	if ((reg & mask) == mask)
>>>> +		err = -ETIMEDOUT;
>>> Also, checking the result can be involved in ufshcd_wait_for_register.
> Any comment?

Sorry I missed this. But the point was the same. To make
wait_for_register() just to wait a definite time and not return any
error condition when the bits don't turn as expected.

>
>>>
>>>> +
>>>> +	return err;
>>>> +}
>>>> +
>>>> +/**
>>>> + * ufshcd_dev_cmd_completion() - handles device management command responses
>>>> + * @hba: per adapter instance
>>>> + * @lrbp: pointer to local reference block
>>>> + */
>>>> +static int
>>>> +ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>>>> +{
>>>> +	int resp;
>>>> +	int err = 0;
>>>> +
>>>> +	resp = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
>>>> +
>>>> +	switch (resp) {
>>>> +	case UPIU_TRANSACTION_NOP_IN:
>>>> +		if (hba->dev_cmd.type != DEV_CMD_TYPE_NOP) {
>>>> +			err = -EINVAL;
>>>> +			dev_err(hba->dev, "%s: unexpected response %x\n",
>>>> +					__func__, resp);
>>>> +		}
>>>> +		break;
>>>> +	case UPIU_TRANSACTION_REJECT_UPIU:
>>>> +		/* TODO: handle Reject UPIU Response */
>>>> +		err = -EPERM;
>>>> +		dev_err(hba->dev, "%s: Reject UPIU not fully implemented\n",
>>>> +				__func__);
>>>> +		break;
>>>> +	default:
>>>> +		err = -EINVAL;
>>>> +		dev_err(hba->dev, "%s: Invalid device management cmd response: %x\n",
>>>> +				__func__, resp);
>>>> +		break;
>>>> +	}
>>>> +
>>>> +	return err;
>>>> +}
>>>> +
>>>> +/**
>>>> + * ufshcd_get_dev_cmd_tag - Get device management command tag
>>>> + * @hba: per-adapter instance
>>>> + * @tag: pointer to variable with available slot value
>>>> + *
>>>> + * Get a free slot and lock it until device management command
>>>> + * completes.
>>>> + *
>>>> + * Returns false if free slot is unavailable for locking, else
>>>> + * return true with tag value in @tag.
>>>> + */
>>>> +static bool ufshcd_get_dev_cmd_tag(struct ufs_hba *hba, int *tag_out)
>>>> +{
>>>> +	int tag;
>>>> +	bool ret = false;
>>>> +	unsigned long tmp;
>>>> +
>>>> +	if (!tag_out)
>>>> +		goto out;
>>>> +
>>>> +	do {
>>>> +		tmp = ~hba->lrb_in_use;
>>>> +		tag = find_last_bit(&tmp, hba->nutrs);
>>>> +		if (tag >= hba->nutrs)
>>>> +			goto out;
>>>> +	} while (test_and_set_bit_lock(tag, &hba->lrb_in_use));
>>>> +
>>>> +	*tag_out = tag;
>>>> +	ret = true;
>>>> +out:
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static inline void ufshcd_put_dev_cmd_tag(struct ufs_hba *hba, int tag)
>>>> +{
>>>> +	clear_bit_unlock(tag, &hba->lrb_in_use);
>>>> +}
>>>> +
>>>> +/**
>>>> + * ufshcd_exec_dev_cmd - API for sending device management requests
>>>> + * @hba - UFS hba
>>>> + * @cmd_type - specifies the type (NOP, Query...)
>>>> + * @timeout - time in seconds
>>>> + *
>>>> + * NOTE: There is only one available tag for device management commands. Thus
>>>> + * synchronisation is the responsibilty of the user.
>>>> + */
>>>> +static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>>>> +		enum dev_cmd_type cmd_type, int timeout)
>>>> +{
>>>> +	struct ufshcd_lrb *lrbp;
>>>> +	int err;
>>>> +	int tag;
>>>> +	struct completion wait;
>>>> +	unsigned long flags;
>>>> +
>>>> +	/*
>>>> +	 * Get free slot, sleep if slots are unavailable.
>>>> +	 * Even though we use wait_event() which sleeps indefinitely,
>>>> +	 * the maximum wait time is bounded by SCSI request timeout.
>>>> +	 */
>>>> +	wait_event(hba->dev_cmd.tag_wq, ufshcd_get_dev_cmd_tag(hba, &tag));
>>>> +
>>>> +	init_completion(&wait);
>>>> +	lrbp = &hba->lrb[tag];
>>>> +	WARN_ON(lrbp->cmd);
>>>> +	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
>>>> +	if (unlikely(err))
>>>> +		goto out_put_tag;
>>>> +
>>>> +	hba->dev_cmd.complete = &wait;
>>>> +
>>>> +	spin_lock_irqsave(hba->host->host_lock, flags);
>>>> +	ufshcd_send_command(hba, tag);
>>>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
>>>> +
>>>> +	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>>>> +
>>> <snip>
>>>> +	if (err == -ETIMEDOUT) {
>>>> +		if (!ufshcd_clear_cmd(hba, tag))
>>>> +			err = -EAGAIN;
>>>> +	} else if (!err) {
>>>> +		spin_lock_irqsave(hba->host->host_lock, flags);
>>>> +		err = ufshcd_dev_cmd_completion(hba, lrbp);
>>>> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
>>>> +	}
>>> </snip>
>>> I think sniped part can be involved in ufshcd_wait_for_dev_cmd.
>>> How do you think about that?
>>
>> Yes, it can be moved.
>>
>>>
>>>> +
>>>> +out_put_tag:
>>>> +	ufshcd_put_dev_cmd_tag(hba, tag);
>>>> +	wake_up(&hba->dev_cmd.tag_wq);
>>>> +	return err;
>>>> +}
>>>> +
>>>>    /**
>>>>     * ufshcd_memory_alloc - allocate memory for host memory space data structures
>>>>     * @hba: per adapter instance
>>>> @@ -774,8 +1075,8 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>>>>    				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
>>>>
>>>>    		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
>>>> -		hba->lrb[i].ucd_cmd_ptr =
>>>> -			(struct utp_upiu_cmd *)(cmd_descp + i);
>>>> +		hba->lrb[i].ucd_req_ptr =
>>>> +			(struct utp_upiu_req *)(cmd_descp + i);
>>>>    		hba->lrb[i].ucd_rsp_ptr =
>>>>    			(struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
>>>>    		hba->lrb[i].ucd_prdt_ptr =
>>>> @@ -961,6 +1262,38 @@ out:
>>>>    }
>>>>
>>>>    /**
>>>> + * ufshcd_validate_dev_connection() - Check device connection status
>>>> + * @hba: per-adapter instance
>>>> + *
>>>> + * Send NOP OUT UPIU and wait for NOP IN response to check whether the
>>>> + * device Transport Protocol (UTP) layer is ready after a reset.
>>>> + * If the UTP layer at the device side is not initialized, it may
>>>> + * not respond with NOP IN UPIU within timeout of %NOP_OUT_TIMEOUT
>>>> + * and we retry sending NOP OUT for %NOP_OUT_RETRIES iterations.
>>>> + */
>>>> +static int ufshcd_validate_dev_connection(struct ufs_hba *hba)
>>> I think ufshcd_verify_dev_init is close to standard description.
>>>
>>
>> Okay.
>>
>>>> +{
>>>> +	int err = 0;
>>>> +	int retries;
>>>> +
>>>> +	mutex_lock(&hba->dev_cmd.lock);
>>>> +	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
>>>> +		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
>>>> +					       NOP_OUT_TIMEOUT);
>>>> +
>>>> +		if (!err || err == -ETIMEDOUT)
>>>> +			break;
>>>> +
>>>> +		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
>>>> +	}
>>>> +	mutex_unlock(&hba->dev_cmd.lock);
>>>> +
>>>> +	if (err)
>>>> +		dev_err(hba->dev, "%s: NOP OUT failed %d\n", __func__, err);
>>>> +	return err;
>>>> +}
>>>> +
>>>> +/**
>>>>     * ufshcd_do_reset - reset the host controller
>>>>     * @hba: per adapter instance
>>>>     *
>>>> @@ -986,13 +1319,20 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
>>>>    	for (tag = 0; tag < hba->nutrs; tag++) {
>>>>    		if (test_bit(tag, &hba->outstanding_reqs)) {
>>>>    			lrbp = &hba->lrb[tag];
>>>> -			scsi_dma_unmap(lrbp->cmd);
>>>> -			lrbp->cmd->result = DID_RESET << 16;
>>>> -			lrbp->cmd->scsi_done(lrbp->cmd);
>>>> -			lrbp->cmd = NULL;
>>>> +			if (lrbp->cmd) {
>>>> +				scsi_dma_unmap(lrbp->cmd);
>>>> +				lrbp->cmd->result = DID_RESET << 16;
>>>> +				lrbp->cmd->scsi_done(lrbp->cmd);
>>>> +				lrbp->cmd = NULL;
>>>> +				clear_bit_unlock(tag, &hba->lrb_in_use);
>>>> +			}
>>> I know above.
>>> But there is no relation to this patch.
>>> Can be it moved to scsi: ufs: Fix device and host reset methods?
>>
>> Yes, but it is basically to avoid NULL pointer derefernce in case
>> someone picks this patch but not the other one.
>>
>>>
>>>>    		}
>>>>    	}
>>>>
>>>> +	/* complete device management command */
>>>> +	if (hba->dev_cmd.complete)
>>>> +		complete(hba->dev_cmd.complete);
>>>> +
>>>>    	/* clear outstanding request/task bit maps */
>>>>    	hba->outstanding_reqs = 0;
>>>>    	hba->outstanding_tasks = 0;
>>>> @@ -1199,27 +1539,37 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>>>>
>>>>    	switch (ocs) {
>>>>    	case OCS_SUCCESS:
>>>> -
>>>>    		/* check if the returned transfer response is valid */
>>> As replaced with new function, comment isn't valid.
>>> Remove or "get the TR response transaction type" seems proper.
>>
>> Okay.
>>
>>>
>>>> -		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
>>>> -		if (result) {
>>>> +		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
>>>> +
>>>> +		switch (result) {
>>>> +		case UPIU_TRANSACTION_RESPONSE:
>>>> +			/*
>>>> +			 * get the response UPIU result to extract
>>>> +			 * the SCSI command status
>>>> +			 */
>>>> +			result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
>>>> +
>>>> +			/*
>>>> +			 * get the result based on SCSI status response
>>>> +			 * to notify the SCSI midlayer of the command status
>>>> +			 */
>>>> +			scsi_status = result & MASK_SCSI_STATUS;
>>>> +			result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
>>>> +			break;
>>>> +		case UPIU_TRANSACTION_REJECT_UPIU:
>>>> +			/* TODO: handle Reject UPIU Response */
>>>> +			result = DID_ERROR << 16;
>>>> +			dev_err(hba->dev,
>>>> +				"Reject UPIU not fully implemented\n");
>>>> +			break;
>>>> +		default:
>>>> +			result = DID_ERROR << 16;
>>>>    			dev_err(hba->dev,
>>>> -				"Invalid response = %x\n", result);
>>>> +				"Unexpected request response code = %x\n",
>>>> +				result);
>>>>    			break;
>>>>    		}
>>>> -
>>>> -		/*
>>>> -		 * get the response UPIU result to extract
>>>> -		 * the SCSI command status
>>>> -		 */
>>>> -		result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
>>>> -
>>>> -		/*
>>>> -		 * get the result based on SCSI status response
>>>> -		 * to notify the SCSI midlayer of the command status
>>>> -		 */
>>>> -		scsi_status = result & MASK_SCSI_STATUS;
>>>> -		result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
>>>>    		break;
>>>>    	case OCS_ABORTED:
>>>>    		result |= DID_ABORT << 16;
>>>> @@ -1259,28 +1609,37 @@ static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
>>>>     */
>>>>    static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>>>>    {
>>>> -	struct ufshcd_lrb *lrb;
>>>> +	struct ufshcd_lrb *lrbp;
>>>> +	struct scsi_cmnd *cmd;
>>>>    	unsigned long completed_reqs;
>>>>    	u32 tr_doorbell;
>>>>    	int result;
>>>>    	int index;
>>>> +	bool int_aggr_reset = false;
>>>>
>>>> -	lrb = hba->lrb;
>>>>    	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>>>>    	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
>>>>
>>>>    	for (index = 0; index < hba->nutrs; index++) {
>>>>    		if (test_bit(index, &completed_reqs)) {
>>>> -
>>>> -			result = ufshcd_transfer_rsp_status(hba, &lrb[index]);
>>>> -
>>>> -			if (lrb[index].cmd) {
>>>> -				scsi_dma_unmap(lrb[index].cmd);
>>>> -				lrb[index].cmd->result = result;
>>>> -				lrb[index].cmd->scsi_done(lrb[index].cmd);
>>>> -
>>>> +			lrbp = &hba->lrb[index];
>>>> +			cmd = lrbp->cmd;
>>>> +			/* Don't reset counters for interrupt cmd */
>>>> +			int_aggr_reset |= !lrbp->intr_cmd;
>>>> +
>>>> +			if (cmd) {
>>>> +				result = ufshcd_transfer_rsp_status(hba, lrbp);
>>>> +				scsi_dma_unmap(cmd);
>>>> +				cmd->result = result;
>>>>    				/* Mark completed command as NULL in LRB */
>>>> -				lrb[index].cmd = NULL;
>>>> +				lrbp->cmd = NULL;
>>>> +				clear_bit_unlock(index, &hba->lrb_in_use);
>>>> +				/* Do not touch lrbp after scsi done */
>>>> +				cmd->scsi_done(cmd);
>>>> +			} else if (lrbp->command_type ==
>>>> +					UTP_CMD_TYPE_DEV_MANAGE) {
>>>> +				if (hba->dev_cmd.complete)
>>>> +					complete(hba->dev_cmd.complete);
>>>>    			}
>>>>    		} /* end of if */
>>>>    	} /* end of for */
>>>> @@ -1288,8 +1647,12 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>>>>    	/* clear corresponding bits of completed commands */
>>>>    	hba->outstanding_reqs ^= completed_reqs;
>>>>
>>>> +	/* we might have free'd some tags above */
>>>> +	wake_up(&hba->dev_cmd.tag_wq);
>>>> +
>>>>    	/* Reset interrupt aggregation counters */
>>>> -	ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
>>>> +	if (int_aggr_reset)
>>>> +		ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
>>> Do you assume that interrupt command(device management command) is completed alone?
>>> Of course, interrupt command is not counted in aggregation unlike regular command.
>>> We need to consider that interrupt command comes along with regular command?
>>> If right, ufshcd_config_int_aggr should not be skipped.
>>
>> True. We are not skipping it. int_aggr_reset will be false only when
>> there is single interrupt command completed.
>>
>> Check the above part which reads -
>> for_all_completed_commands() {
>>    int_aggr_reset |= !lrbp->intr_cmd;
>> }
>>
>> Even if one of the command in the iteration is not interrupt command
>> (lrbp->intr_cmd is false) then int_aggr_reset is always true.
> Clear!
> But I confused it with your comment line. (/* Don't reset counters for interrupt cmd */)
> How about changing like below?
> 'Don't skip to reset counters if a regular command is present'

Makes sense.

-- 
Regards,
Sujit
