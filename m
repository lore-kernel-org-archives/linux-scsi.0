From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH V3 1/4] scsi: ufs: Fix broken task management command
 implementation
Date: Tue, 23 Jul 2013 17:24:47 +0900
Message-ID: <001701ce877e$17c50520$474f0f60$%jun@samsung.com>
References: <1373361378-30749-1-git-send-email-sthumma@codeaurora.org>
 <1373361378-30749-2-git-send-email-sthumma@codeaurora.org>
 <001f01ce8487$c8b7c060$5a274120$%jun@samsung.com>
 <51E984DC.4040503@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:11599 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3GWIYu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jul 2013 04:24:50 -0400
In-reply-to: <51E984DC.4040503@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Sujit Reddy Thumma' <sthumma@codeaurora.org>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

On Sat, July 20, 2013, Sujit Reddy Thumma wrote:
> On 7/19/2013 7:26 PM, Seungwon Jeon wrote:
> > On Tue, July 09, 2013 Sujit Reddy Thumma wrote:
> >> Currently, sending Task Management (TM) command to the card might
> >> be broken in some scenarios as listed below:
> >>
> >> Problem: If there are more than 8 TM commands the implementation
> >>           returns error to the caller.
> >> Fix:     Wait for one of the slots to be emptied and send the command.
> >>
> >> Problem: Sometimes it is necessary for the caller to know the TM service
> >>           response code to determine the task status.
> >> Fix:     Propogate the service response to the caller.
> >>
> >> Problem: If the TM command times out no proper error recovery is
> >>           implemented.
> >> Fix:     Clear the command in the controller door-bell register, so that
> >>           further commands for the same slot don't fail.
> >>
> >> Problem: While preparing the TM command descriptor, the task tag used
> >>           should be unique across SCSI/NOP/QUERY/TM commands and not the
> >> 	 task tag of the command which the TM command is trying to manage.
> >> Fix:     Use a unique task tag instead of task tag of SCSI command.
> >>
> >> Problem: Since the TM command involves H/W communication, abruptly ending
> >>           the request on kill interrupt signal might cause h/w malfunction.
> >> Fix:     Wait for hardware completion interrupt with TASK_UNINTERRUPTIBLE
> >>           set.
> >>
> >> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> >> ---
> >>   drivers/scsi/ufs/ufshcd.c |  177 ++++++++++++++++++++++++++++++---------------
> >>   drivers/scsi/ufs/ufshcd.h |    8 ++-
> >>   2 files changed, 126 insertions(+), 59 deletions(-)
> >>
> >> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> >> index af7d01d..a176421 100644
> >> --- a/drivers/scsi/ufs/ufshcd.c
> >> +++ b/drivers/scsi/ufs/ufshcd.c
> >> @@ -53,6 +53,9 @@
> >>   /* Query request timeout */
> >>   #define QUERY_REQ_TIMEOUT 30 /* msec */
> >>
> >> +/* Task management command timeout */
> >> +#define TM_CMD_TIMEOUT	100 /* msecs */
> >> +
> >>   /* Expose the flag value from utp_upiu_query.value */
> >>   #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
> >>
> >> @@ -190,13 +193,35 @@ ufshcd_get_tmr_ocs(struct utp_task_req_desc *task_req_descp)
> >>   /**
> >>    * ufshcd_get_tm_free_slot - get a free slot for task management request
> >>    * @hba: per adapter instance
> >> + * @free_slot: pointer to variable with available slot value
> >>    *
> >> - * Returns maximum number of task management request slots in case of
> >> - * task management queue full or returns the free slot number
> >> + * Get a free tag and lock it until ufshcd_put_tm_slot() is called.
> >> + * Returns 0 if free slot is not available, else return 1 with tag value
> >> + * in @free_slot.
> >>    */
> >> -static inline int ufshcd_get_tm_free_slot(struct ufs_hba *hba)
> >> +static bool ufshcd_get_tm_free_slot(struct ufs_hba *hba, int *free_slot)
> >> +{
> >> +	int tag;
> >> +	bool ret = false;
> >> +
> >> +	if (!free_slot)
> >> +		goto out;
> >> +
> >> +	do {
> >> +		tag = find_first_zero_bit(&hba->tm_slots_in_use, hba->nutmrs);
> >> +		if (tag >= hba->nutmrs)
> >> +			goto out;
> >> +	} while (test_and_set_bit_lock(tag, &hba->tm_slots_in_use));
> >> +
> >> +	*free_slot = tag;
> >> +	ret = true;
> >> +out:
> >> +	return ret;
> >> +}
> >> +
> >> +static inline void ufshcd_put_tm_slot(struct ufs_hba *hba, int slot)
> >>   {
> >> -	return find_first_zero_bit(&hba->outstanding_tasks, hba->nutmrs);
> >> +	clear_bit_unlock(slot, &hba->tm_slots_in_use);
> >>   }
> >>
> >>   /**
> >> @@ -1778,10 +1803,11 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
> >>    * ufshcd_task_req_compl - handle task management request completion
> >>    * @hba: per adapter instance
> >>    * @index: index of the completed request
> >> + * @resp: task management service response
> >>    *
> >> - * Returns SUCCESS/FAILED
> >> + * Returns non-zero value on error, zero on success
> >>    */
> >> -static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
> >> +static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index, u8 *resp)
> >>   {
> >>   	struct utp_task_req_desc *task_req_descp;
> >>   	struct utp_upiu_task_rsp *task_rsp_upiup;
> >> @@ -1802,19 +1828,15 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
> >>   				task_req_descp[index].task_rsp_upiu;
> >>   		task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
> >>   		task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
> >> -
> >> -		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
> >> -		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
> >> -			task_result = FAILED;
> >> -		else
> >> -			task_result = SUCCESS;
> >> +		if (resp)
> >> +			*resp = (u8)task_result;
> >>   	} else {
> >> -		task_result = FAILED;
> >> -		dev_err(hba->dev,
> >> -			"trc: Invalid ocs = %x\n", ocs_value);
> >> +		dev_err(hba->dev, "%s: failed, ocs = 0x%x\n",
> >> +				__func__, ocs_value);
> >>   	}
> >>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >> -	return task_result;
> >> +
> >> +	return ocs_value;
> >>   }
> >>
> >>   /**
> >> @@ -2298,7 +2320,7 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
> >>
> >>   	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> >>   	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
> >> -	wake_up_interruptible(&hba->ufshcd_tm_wait_queue);
> >> +	wake_up(&hba->tm_wq);
> >>   }
> >>
> >>   /**
> >> @@ -2348,38 +2370,61 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
> >>   	return retval;
> >>   }
> >>
> >> +static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
> >> +{
> >> +	int err = 0;
> >> +	u32 reg;
> >> +	u32 mask = 1 << tag;
> >> +	unsigned long flags;
> >> +
> >> +	if (!test_bit(tag, &hba->outstanding_reqs))
> >> +		goto out;
> >> +
> >> +	spin_lock_irqsave(hba->host->host_lock, flags);
> >> +	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
> >> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >> +
> >> +	/* poll for max. 1 sec to clear door bell register by h/w */
> >> +	reg = ufshcd_wait_for_register(hba,
> >> +			REG_UTP_TASK_REQ_DOOR_BELL,
> >> +			mask, 0, 1000, 1000);
> >> +	if ((reg & mask) == mask)
> >> +		err = -ETIMEDOUT;
> >> +out:
> >> +	return err;
> >> +}
> >> +
> >>   /**
> >>    * ufshcd_issue_tm_cmd - issues task management commands to controller
> >>    * @hba: per adapter instance
> >> - * @lrbp: pointer to local reference block
> >> + * @lun_id: LUN ID to which TM command is sent
> >> + * @task_id: task ID to which the TM command is applicable
> >> + * @tm_function: task management function opcode
> >> + * @tm_response: task management service response return value
> >>    *
> >> - * Returns SUCCESS/FAILED
> >> + * Returns non-zero value on error, zero on success.
> >>    */
> >> -static int
> >> -ufshcd_issue_tm_cmd(struct ufs_hba *hba,
> >> -		    struct ufshcd_lrb *lrbp,
> >> -		    u8 tm_function)
> >> +static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
> >> +		u8 tm_function, u8 *tm_response)
> >>   {
> >>   	struct utp_task_req_desc *task_req_descp;
> >>   	struct utp_upiu_task_req *task_req_upiup;
> >>   	struct Scsi_Host *host;
> >>   	unsigned long flags;
> >> -	int free_slot = 0;
> >> +	int free_slot;
> >>   	int err;
> >> +	int task_tag;
> >>
> >>   	host = hba->host;
> >>
> >> -	spin_lock_irqsave(host->host_lock, flags);
> >> -
> >> -	/* If task management queue is full */
> >> -	free_slot = ufshcd_get_tm_free_slot(hba);
> >> -	if (free_slot >= hba->nutmrs) {
> >> -		spin_unlock_irqrestore(host->host_lock, flags);
> >> -		dev_err(hba->dev, "Task management queue full\n");
> >> -		err = FAILED;
> >> -		goto out;
> >> -	}
> >> +	/*
> >> +	 * Get free slot, sleep if slots are unavailable.
> >> +	 * Even though we use wait_event() which sleeps indefinitely,
> >> +	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
> >> +	 */
> >> +	wait_event(hba->tm_tag_wq, ufshcd_get_tm_free_slot(hba, &free_slot));
> >>
> >> +	spin_lock_irqsave(host->host_lock, flags);
> >>   	task_req_descp = hba->utmrdl_base_addr;
> >>   	task_req_descp += free_slot;
> >>
> >> @@ -2391,18 +2436,15 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
> >>   	/* Configure task request UPIU */
> >>   	task_req_upiup =
> >>   		(struct utp_upiu_task_req *) task_req_descp->task_req_upiu;
> >> +	task_tag = hba->nutrs + free_slot;
> > Possible, did you intend 'hba->nutmrs', not 'hba->nutrs'?
> > I think it's safer with hba->nutmrs if we can't sure that NUTRS is larger than NUTMRS.
> 
> It should be hba->nutrs and not hba->nutmrs.
> 
> The equation is -
> 0 <= free_slot < hba->nutmrs
> 0 <= transfer_req_task_id < hba->nutrs
> hba->nutrs <= tm_req_task_id < hba->nutmrs + hba_nutrs
> 
> Whatever be the values of NUTRS/NUTMRS the above gives a unique
> task_id.
Yes.

> 
> 
> >
> >>   	task_req_upiup->header.dword_0 =
> >>   		UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
> >> -					      lrbp->lun, lrbp->task_tag);
> >> +				lun_id, task_tag);
> >>   	task_req_upiup->header.dword_1 =
> >>   		UPIU_HEADER_DWORD(0, tm_function, 0, 0);
> >>
> >> -	task_req_upiup->input_param1 = lrbp->lun;
> >> -	task_req_upiup->input_param1 =
> >> -		cpu_to_be32(task_req_upiup->input_param1);
> >> -	task_req_upiup->input_param2 = lrbp->task_tag;
> >> -	task_req_upiup->input_param2 =
> >> -		cpu_to_be32(task_req_upiup->input_param2);
> >> +	task_req_upiup->input_param1 = cpu_to_be32(lun_id);
> >> +	task_req_upiup->input_param2 = cpu_to_be32(task_id);
> >>
> >>   	/* send command to the controller */
> >>   	__set_bit(free_slot, &hba->outstanding_tasks);
> >> @@ -2411,20 +2453,24 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
> >>   	spin_unlock_irqrestore(host->host_lock, flags);
> >>
> >>   	/* wait until the task management command is completed */
> >> -	err =
> >> -	wait_event_interruptible_timeout(hba->ufshcd_tm_wait_queue,
> >> -					 (test_bit(free_slot,
> >> -					 &hba->tm_condition) != 0),
> >> -					 60 * HZ);
> >> +	err = wait_event_timeout(hba->tm_wq,
> >> +			test_bit(free_slot, &hba->tm_condition),
> >> +			msecs_to_jiffies(TM_CMD_TIMEOUT));
> >>   	if (!err) {
> >> -		dev_err(hba->dev,
> >> -			"Task management command timed-out\n");
> >> -		err = FAILED;
> >> -		goto out;
> >> +		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
> >> +				__func__, tm_function);
> >> +		if (ufshcd_clear_tm_cmd(hba, free_slot))
> >> +			dev_WARN(hba->dev, "%s: unable clear tm cmd (slot %d) after timeout\n",
> >> +					__func__, free_slot);
> >> +		err = -ETIMEDOUT;
> >> +	} else {
> >> +		err = ufshcd_task_req_compl(hba, free_slot, tm_response);
> >>   	}
> >> +
> >>   	clear_bit(free_slot, &hba->tm_condition);
> >> -	err = ufshcd_task_req_compl(hba, free_slot);
> >> -out:
> >> +	ufshcd_put_tm_slot(hba, free_slot);
> >> +	wake_up(&hba->tm_tag_wq);
> >> +
> >>   	return err;
> >>   }
> >>
> >> @@ -2441,14 +2487,22 @@ static int ufshcd_device_reset(struct scsi_cmnd *cmd)
> >>   	unsigned int tag;
> >>   	u32 pos;
> >>   	int err;
> >> +	u8 resp;
> >> +	struct ufshcd_lrb *lrbp;
> >>
> >>   	host = cmd->device->host;
> >>   	hba = shost_priv(host);
> >>   	tag = cmd->request->tag;
> >>
> >> -	err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_LOGICAL_RESET);
> >> -	if (err == FAILED)
> >> +	lrbp = &hba->lrb[tag];
> >> +	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
> > Argument 2nd, 3rd can be replaced by lrbp.
> > Then, we can reduce the number of argument.
> >
> 
> TM issue command doesn't need to know about lrbp, It just need
> LUN ID and task ID. This helps when we are not dealing with lrbp's
> and just want to issue some other TM command.
> I believe an extra argument is not so costly on the systems which
> demand high performance UFS devices.
Yes, you're right. only need LUN ID and task ID.
It might be trivial. But 'lrbp' should be referred for getting these.

Thanks,
Seungwon Jeon

