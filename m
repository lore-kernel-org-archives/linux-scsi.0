From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH V3 4/4] scsi: ufs: Improve UFS fatal error handling
Date: Wed, 24 Jul 2013 22:39:33 +0900
Message-ID: <001a01ce8873$3aed9b70$b0c8d250$%jun@samsung.com>
References: <1373361378-30749-1-git-send-email-sthumma@codeaurora.org>
 <1373361378-30749-5-git-send-email-sthumma@codeaurora.org>
 <002201ce8488$0a9ec8c0$1fdc5a40$%jun@samsung.com>
 <51E984F1.9020408@codeaurora.org>
 <001901ce877f$6c412c90$44c385b0$%jun@samsung.com>
 <51EEA40E.9010506@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32294 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXNjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jul 2013 09:39:35 -0400
In-reply-to: <51EEA40E.9010506@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Sujit Reddy Thumma' <sthumma@codeaurora.org>
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

On Wed, July 24, 2013, Sujit Reddy Thumma wrote:
> On 7/23/2013 2:04 PM, Seungwon Jeon wrote:
> > On Sat, July 20, 2013, Sujit Reddy Thumma wrote:
> >> On 7/19/2013 7:28 PM, Seungwon Jeon wrote:
> >>> On Tue, July 09, 2013, Sujit Reddy Thumma wrote:
> >>>> Error handling in UFS driver is broken and resets the host controller
> >>>> for fatal errors without re-initialization. Correct the fatal error
> >>>> handling sequence according to UFS Host Controller Interface (HCI)
> >>>> v1.1 specification.
> >>>>
> >>>> o Upon determining fatal error condition the host controller may hang
> >>>>     forever until a reset is applied, so just retrying the command doesn't
> >>>>     work without a reset. So, the reset is applied in the driver context
> >>>>     in a separate work and SCSI mid-layer isn't informed until reset is
> >>>>     applied.
> >>>>
> >>>> o Processed requests which are completed without error are reported to
> >>>>     SCSI layer as successful and any pending commands that are not started
> >>>>     yet or are not cause of the error are re-queued into scsi midlayer queue.
> >>>>     For the command that caused error, host controller or device is reset
> >>>>     and DID_ERROR is returned for command retry after applying reset.
> >>>>
> >>>> o SCSI is informed about the expected Unit-Attentioni exception from the
> >>> Attention'i',  typo.
> >> Okay.
> >>
> >>>
> >>>>     device for the immediate command after a reset so that the SCSI layer
> >>>>     take necessary steps to establish communication with the device.
> >>>>
> >>>> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> >>>> ---
> >>>>    drivers/scsi/ufs/ufshcd.c |  349 +++++++++++++++++++++++++++++++++++---------
> >>>>    drivers/scsi/ufs/ufshcd.h |    2 +
> >>>>    drivers/scsi/ufs/ufshci.h |   19 ++-
> >>>>    3 files changed, 295 insertions(+), 75 deletions(-)
> >>>>
> >>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> >>>> index b4c9910..2a3874f 100644
> >>>> --- a/drivers/scsi/ufs/ufshcd.c
> >>>> +++ b/drivers/scsi/ufs/ufshcd.c
> >>>> @@ -80,6 +80,14 @@ enum {
> >>>>    	UFSHCD_EH_DEVICE_RESET_PENDING = (1 << 1),
> >>>>    };
> >>>>
> >>>> +/* UFSHCD UIC layer error flags */
> >>>> +enum {
> >>>> +	UFSHCD_UIC_DL_PA_INIT_ERROR = (1 << 0), /* Data link layer error */
> >>>> +	UFSHCD_UIC_NL_ERROR = (1 << 1), /* Network layer error */
> >>>> +	UFSHCD_UIC_TL_ERROR = (1 << 2), /* Transport Layer error */
> >>>> +	UFSHCD_UIC_DME_ERROR = (1 << 3), /* DME error */
> >>>> +};
> >>>> +
> >>>>    /* Interrupt configuration options */
> >>>>    enum {
> >>>>    	UFSHCD_INT_DISABLE,
> >>>> @@ -108,6 +116,7 @@ enum {
> >>>>
> >>>>    static void ufshcd_tmc_handler(struct ufs_hba *hba);
> >>>>    static void ufshcd_async_scan(void *data, async_cookie_t cookie);
> >>>> +static int ufshcd_reset_and_restore(struct ufs_hba *hba);
> >>>>
> >>>>    /*
> >>>>     * ufshcd_wait_for_register - wait for register value to change
> >>>> @@ -1605,9 +1614,6 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
> >>>>    		goto out;
> >>>>    	}
> >>>>
> >>>> -	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
> >>>> -		scsi_unblock_requests(hba->host);
> >>>> -
> >>>>    out:
> >>>>    	return err;
> >>>>    }
> >>>> @@ -1733,66 +1739,6 @@ static int ufshcd_validate_dev_connection(struct ufs_hba *hba)
> >>>>    }
> >>>>
> >>>>    /**
> >>>> - * ufshcd_do_reset - reset the host controller
> >>>> - * @hba: per adapter instance
> >>>> - *
> >>>> - * Returns SUCCESS/FAILED
> >>>> - */
> >>>> -static int ufshcd_do_reset(struct ufs_hba *hba)
> >>>> -{
> >>>> -	struct ufshcd_lrb *lrbp;
> >>>> -	unsigned long flags;
> >>>> -	int tag;
> >>>> -
> >>>> -	/* block commands from midlayer */
> >>>> -	scsi_block_requests(hba->host);
> >>>> -
> >>>> -	spin_lock_irqsave(hba->host->host_lock, flags);
> >>>> -	hba->ufshcd_state = UFSHCD_STATE_RESET;
> >>>> -
> >>>> -	/* send controller to reset state */
> >>>> -	ufshcd_hba_stop(hba);
> >>>> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >>>> -
> >>>> -	/* abort outstanding commands */
> >>>> -	for (tag = 0; tag < hba->nutrs; tag++) {
> >>>> -		if (test_bit(tag, &hba->outstanding_reqs)) {
> >>>> -			lrbp = &hba->lrb[tag];
> >>>> -			if (lrbp->cmd) {
> >>>> -				scsi_dma_unmap(lrbp->cmd);
> >>>> -				lrbp->cmd->result = DID_RESET << 16;
> >>>> -				lrbp->cmd->scsi_done(lrbp->cmd);
> >>>> -				lrbp->cmd = NULL;
> >>>> -				clear_bit_unlock(tag, &hba->lrb_in_use);
> >>>> -			}
> >>>> -		}
> >>>> -	}
> >>>> -
> >>>> -	/* complete device management command */
> >>>> -	if (hba->dev_cmd.complete)
> >>>> -		complete(hba->dev_cmd.complete);
> >>>> -
> >>>> -	/* clear outstanding request/task bit maps */
> >>>> -	hba->outstanding_reqs = 0;
> >>>> -	hba->outstanding_tasks = 0;
> >>>> -
> >>>> -	/* Host controller enable */
> >>>> -	if (ufshcd_hba_enable(hba)) {
> >>>> -		dev_err(hba->dev,
> >>>> -			"Reset: Controller initialization failed\n");
> >>>> -		return FAILED;
> >>>> -	}
> >>>> -
> >>>> -	if (ufshcd_link_startup(hba)) {
> >>>> -		dev_err(hba->dev,
> >>>> -			"Reset: Link start-up failed\n");
> >>>> -		return FAILED;
> >>>> -	}
> >>>> -
> >>>> -	return SUCCESS;
> >>>> -}
> >>>> -
> >>>> -/**
> >>>>     * ufshcd_slave_alloc - handle initial SCSI device configurations
> >>>>     * @sdev: pointer to SCSI device
> >>>>     *
> >>>> @@ -1809,6 +1755,9 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
> >>>>    	sdev->use_10_for_ms = 1;
> >>>>    	scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
> >>>>
> >>>> +	/* allow SCSI layer to restart the device in case of errors */
> >>>> +	sdev->allow_restart = 1;
> >>>> +
> >>>>    	/*
> >>>>    	 * Inform SCSI Midlayer that the LUN queue depth is same as the
> >>>>    	 * controller queue depth. If a LUN queue depth is less than the
> >>>> @@ -2013,6 +1962,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> >>>>    	case OCS_ABORTED:
> >>>>    		result |= DID_ABORT << 16;
> >>>>    		break;
> >>>> +	case OCS_INVALID_COMMAND_STATUS:
> >>>> +		result |= DID_REQUEUE << 16;
> >>>> +		break;
> >>>>    	case OCS_INVALID_CMD_TABLE_ATTR:
> >>>>    	case OCS_INVALID_PRDT_ATTR:
> >>>>    	case OCS_MISMATCH_DATA_BUF_SIZE:
> >>>> @@ -2405,42 +2357,295 @@ out:
> >>>>    	return err;
> >>>>    }
> >>>>
> >>>> +static void ufshcd_decide_eh_xfer_req(struct ufs_hba *hba, u32 ocs)
> >>>> +{
> >>>> +	switch (ocs) {
> >>>> +	case OCS_SUCCESS:
> >>>> +	case OCS_INVALID_COMMAND_STATUS:
> >>>> +		break;
> >>>> +	case OCS_MISMATCH_DATA_BUF_SIZE:
> >>>> +	case OCS_MISMATCH_RESP_UPIU_SIZE:
> >>>> +	case OCS_PEER_COMM_FAILURE:
> >>>> +	case OCS_FATAL_ERROR:
> >>>> +	case OCS_ABORTED:
> >>>> +	case OCS_INVALID_CMD_TABLE_ATTR:
> >>>> +	case OCS_INVALID_PRDT_ATTR:
> >>>> +		ufshcd_set_host_reset_pending(hba);
> >>> Should host be reset on ocs error, including below ufshcd_decide_eh_task_req?
> >>> It's just overall command status.
> >>
> >> Yes, the error handling section in the UFS 1.1 spec. mentions so.
> > If host's reset is required, it should be allowed in fatal situation.
> > Deciding with OCS field seems not proper. There is no mentions for that in spec.
> > If I have a wrong information, please let it clear.
> >
> 
> You can refer to section 8.3 of HCI spec.
> On fatal errors the controller h/w will have to update the OCS field of
> the command that caused error and then raise an fatal error interrupt.
> The s/w reads the OCS value and determine commands that are in error
> and then carry out reset.
I don't think so.
OCS field can be updated regardless of fatal error.
As mentioned previously, your implementations are gathering all errors into 'ufshcd_fatal_err_handler'.
It means that non-fatal error is also handled and if any OCS value, host reset will be reserved.

> 
> >>
> >>>
> >>>> +		break;
> >>>> +	default:
> >>>> +		dev_err(hba->dev, "%s: unknown OCS 0x%x\n",
> >>>> +				__func__, ocs);
> >>>> +		BUG();
> >>>> +	}
> >>>> +}
> >>>> +
> >>>> +static void ufshcd_decide_eh_task_req(struct ufs_hba *hba, u32 ocs)
> >>>> +{
> >>>> +	switch (ocs) {
> >>>> +	case OCS_TMR_SUCCESS:
> >>>> +	case OCS_TMR_INVALID_COMMAND_STATUS:
> >>>> +		break;
> >>>> +	case OCS_TMR_MISMATCH_REQ_SIZE:
> >>>> +	case OCS_TMR_MISMATCH_RESP_SIZE:
> >>>> +	case OCS_TMR_PEER_COMM_FAILURE:
> >>>> +	case OCS_TMR_INVALID_ATTR:
> >>>> +	case OCS_TMR_ABORTED:
> >>>> +	case OCS_TMR_FATAL_ERROR:
> >>>> +		ufshcd_set_host_reset_pending(hba);
> >>>> +		break;
> >>>> +	default:
> >>>> +		dev_err(hba->dev, "%s: uknown TMR OCS 0x%x\n",
> >>>> +				__func__, ocs);
> >>>> +		BUG();
> >>>> +	}
> >>>> +}
> >>>> +
> >>>>    /**
> >>>> - * ufshcd_fatal_err_handler - handle fatal errors
> >>>> + * ufshcd_error_autopsy_transfer_req() - reads OCS field of failed command and
> >>>> + *                          decide error handling
> >>>>     * @hba: per adapter instance
> >>>> + * @err_xfer: bit mask for transfer request errors
> >>>> + *
> >>>> + * Iterate over completed transfer requests and
> >>>> + * set error handling flags.
> >>>> + */
> >>>> +static void
> >>>> +ufshcd_error_autopsy_transfer_req(struct ufs_hba *hba, u32 *err_xfer)
> >>>> +{
> >>>> +	unsigned long completed;
> >>>> +	u32 doorbell;
> >>>> +	int index;
> >>>> +	int ocs;
> >>>> +
> >>>> +	if (!err_xfer)
> >>>> +		goto out;
> >>>> +
> >>>> +	doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> >>>> +	completed = doorbell ^ (u32)hba->outstanding_reqs;
> >>>> +
> >>>> +	for (index = 0; index < hba->nutrs; index++) {
> >>>> +		if (test_bit(index, &completed)) {
> >>>> +			ocs = ufshcd_get_tr_ocs(&hba->lrb[index]);
> >>>> +			if ((ocs == OCS_SUCCESS) ||
> >>>> +					(ocs == OCS_INVALID_COMMAND_STATUS))
> >>>> +				continue;
> >>>> +
> >>>> +			*err_xfer |= (1 << index);
> >>>> +			ufshcd_decide_eh_xfer_req(hba, ocs);
> >>>> +		}
> >>>> +	}
> >>>> +out:
> >>>> +	return;
> >>>> +}
> >>>> +
> >>>> +/**
> >>>> + * ufshcd_error_autopsy_task_req() - reads OCS field of failed command and
> >>>> + *                          decide error handling
> >>>> + * @hba: per adapter instance
> >>>> + * @err_tm: bit mask for task management errors
> >>>> + *
> >>>> + * Iterate over completed task management requests and
> >>>> + * set error handling flags.
> >>>> + */
> >>>> +static void
> >>>> +ufshcd_error_autopsy_task_req(struct ufs_hba *hba, u32 *err_tm)
> >>>> +{
> >>>> +	unsigned long completed;
> >>>> +	u32 doorbell;
> >>>> +	int index;
> >>>> +	int ocs;
> >>>> +
> >>>> +	if (!err_tm)
> >>>> +		goto out;
> >>>> +
> >>>> +	doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> >>>> +	completed = doorbell ^ (u32)hba->outstanding_tasks;
> >>>> +
> >>>> +	for (index = 0; index < hba->nutmrs; index++) {
> >>>> +		if (test_bit(index, &completed)) {
> >>>> +			struct utp_task_req_desc *tm_descp;
> >>>> +
> >>>> +			tm_descp = hba->utmrdl_base_addr;
> >>>> +			ocs = ufshcd_get_tmr_ocs(&tm_descp[index]);
> >>>> +			if ((ocs == OCS_TMR_SUCCESS) ||
> >>>> +					(ocs == OCS_TMR_INVALID_COMMAND_STATUS))
> >>>> +				continue;
> >>>> +
> >>>> +			*err_tm |= (1 << index);
> >>>> +			ufshcd_decide_eh_task_req(hba, ocs);
> >>>> +		}
> >>>> +	}
> >>>> +
> >>>> +out:
> >>>> +	return;
> >>>> +}
> >>>> +
> >>>> +/**
> >>>> + * ufshcd_fatal_err_handler - handle fatal errors
> >>>> + * @work: pointer to work structure
> >>>>     */
> >>>>    static void ufshcd_fatal_err_handler(struct work_struct *work)
> >>>>    {
> >>>>    	struct ufs_hba *hba;
> >>>> +	unsigned long flags;
> >>>> +	u32 err_xfer = 0;
> >>>> +	u32 err_tm = 0;
> >>>> +	int err;
> >>>> +
> >>>>    	hba = container_of(work, struct ufs_hba, feh_workq);
> >>>>
> >>>>    	pm_runtime_get_sync(hba->dev);
> >>>> -	/* check if reset is already in progress */
> >>>> -	if (hba->ufshcd_state != UFSHCD_STATE_RESET)
> >>>> -		ufshcd_do_reset(hba);
> >>>> +	spin_lock_irqsave(hba->host->host_lock, flags);
> >>>> +	if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> >>>> +		/* complete processed requests and exit */
> >>>> +		ufshcd_transfer_req_compl(hba);
> >>>> +		ufshcd_tmc_handler(hba);
> >>>> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> >>>> +		pm_runtime_put_sync(hba->dev);
> >>>> +		return;
> >>> Host driver is here with finishing 'scsi_block_requests'.
> >>> 'scsi_unblock_requests' can be called somewhere?
> >>
> >> No, but it can be possible that SCSI command timeout which triggers
> >> device/host reset and fatal error handler race each other.
> > Sorry, I didn't get your meaning exactly.
> > I saw that scsi_block_requests is done before ufshcd_fatal_err_handler is scheduled.
> > If device or host was requested from scsi mid-layer just before ufshcd_fatal_err_handler,
> > ufshcd_fatal_err_handler will be out through if statement. Then, there is nowhere to call
> scsi_unblock_requests
> > though device/host reset is done successfully.
> 
> You are right, this should return with scsi_unblock_requests()
> called and there is no need to complete the processed requests as we
> might be in middle of something else while the RESET is in progress.
> 
> 
> >>
> >>>
> >>>> +	}
> >>>> +
> >>>> +	hba->ufshcd_state = UFSHCD_STATE_RESET;
> >>>> +	ufshcd_error_autopsy_transfer_req(hba, &err_xfer);
> >>>> +	ufshcd_error_autopsy_task_req(hba, &err_tm);
> >>>> +
> >>>> +	/*
> >>>> +	 * Complete successful and pending transfer requests.
> >>>> +	 * DID_REQUEUE is returned for pending requests as they have
> >>>> +	 * nothing to do with error'ed request and SCSI layer should
> >>>> +	 * not treat them as errors and decrement retry count.
> >>>> +	 */
> >>>> +	hba->outstanding_reqs &= ~err_xfer;
> >>>> +	ufshcd_transfer_req_compl(hba);
> >>>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >>>> +	ufshcd_complete_pending_reqs(hba);
> >>>> +	spin_lock_irqsave(hba->host->host_lock, flags);
> >>>> +	hba->outstanding_reqs |= err_xfer;
> >>> Hmm... error handling seems so complicated.
> >>> To simplify it, how about below?
> >>>
> >>> 1. If requests(transfer or task management) are completed, finish them with success/failure.
> >> This is what we are trying to do above.
> >>
> >>> 2. If there are pending requests, abort them.
> >> No, if a fatal error is occurred it is possible that host controller is
> >> freez'ed we are not sure if it can take task management commands and
> >> execute them.
> > I meant that aborting the request by clearing corresponding UTMRLCLR/UTMRLCLR.
> >
> 
> I am doing the same in this patch -
> 1) Return to SCSI the successful commands.
> 2) Clear the pending (but not cause of error) commands by writing into
> UTMRLCLR/UTRCLR registers. So scsi_host_result = DID_REQUEUE
> 3) Reset and return the commands that "caused error" to SCSI with
> DID_ERROR.
> 
> Am I doing anything extra than what you have suggested?
If some are cleared, let me review more.

> 
> >>
> >>> 3. If fatal error, reset.
> >>>
> >>
> >>
> >>>> +
> >>>> +	/* Complete successful and pending task requests */
> >>>> +	hba->outstanding_tasks &= ~err_tm;
> >>>> +	ufshcd_tmc_handler(hba);
> >>>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >>>> +	ufshcd_complete_pending_tasks(hba);
> >>>> +	spin_lock_irqsave(hba->host->host_lock, flags);
> >>>> +
> >>>> +	hba->outstanding_tasks |= err_tm;
> >>>> +
> >>>> +	/*
> >>>> +	 * Controller may generate multiple fatal errors, handle
> >>>> +	 * errors based on severity.
> >>>> +	 * 1) DEVICE_FATAL_ERROR
> >>>> +	 * 2) SYSTEM_BUS/CONTROLLER_FATAL_ERROR
> >>>> +	 * 3) UIC_ERROR
> >>>> +	 */
> >>>> +	if (hba->errors & DEVICE_FATAL_ERROR) {
> >>>> +		/*
> >>>> +		 * Some HBAs may not clear UTRLDBR/UTMRLDBR or update
> >>>> +		 * OCS field on device fatal error.
> >>>> +		 */
> >>>> +		ufshcd_set_host_reset_pending(hba);
> >>> In DEVICE_FATAL_ERROR, ufshcd_device_reset_pending is right?
> >>
> >> It looks so, but the spec. mentions to reset the host as well (8.3.6).
> > Do you pointing below?
> > [8.3.6. Device Errors are fatal errors. ...the host software shall reset the device too.]
> >
> 
> I meant "8.3.6: When this condition occurs, host software shall follow
> the same procedure for UIC error handling as described in 8.2.2,". There
> is an error in the spec. it was not 8.2.2 but 8.3.2 for UIC error
> handling. So going by 8.3.2 HCE needs to be toggled.
I feel like 8.3.2 of spec. makes it difficult to identifying 'device fatal error' with a fatal UIC error.
It needs to clarify these.

Anyway, I found some descriptions related to host' reset.
5.3.1 Device Fatal Error Status (DFES):
...
If the error occurs, host SW should reset the host controller.
I's explicit. If spec. saying is right, we would reset host.

> 
> 
> 
> >>
> >>>
> >>>> +	} else if (hba->errors & (SYSTEM_BUS_FATAL_ERROR |
> >>>> +			CONTROLLER_FATAL_ERROR)) {
> >>>> +		/* eh flags should be set in err autopsy based on OCS values */
> >>>> +		if (!hba->eh_flags)
> >>>> +			WARN(1, "%s: fatal error without error handling\n",
> >>>> +				dev_name(hba->dev));
> >>>> +	} else if (hba->errors & UIC_ERROR) {
> >>>> +		if (hba->uic_error & UFSHCD_UIC_DL_PA_INIT_ERROR) {
> >>>> +			/* fatal error - reset controller */
> >>>> +			ufshcd_set_host_reset_pending(hba);
> >>>> +		} else if (hba->uic_error & (UFSHCD_UIC_NL_ERROR |
> >>>> +					UFSHCD_UIC_TL_ERROR |
> >>>> +					UFSHCD_UIC_DME_ERROR)) {
> >>>> +			/* non-fatal, report error to SCSI layer */
> >>>> +			if (!hba->eh_flags) {
> >>>> +				spin_unlock_irqrestore(
> >>>> +						hba->host->host_lock, flags);
> >>>> +				ufshcd_complete_pending_reqs(hba);
> >>>> +				ufshcd_complete_pending_tasks(hba);
> >>>> +				spin_lock_irqsave(hba->host->host_lock, flags);
> >>>> +			}
> >>>> +		}
> >>>> +	}
> >>>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >>>> +
> >>>> +	if (hba->eh_flags) {
> >>>> +		err = ufshcd_reset_and_restore(hba);
> >>>> +		if (err) {
> >>>> +			ufshcd_clear_host_reset_pending(hba);
> >>>> +			ufshcd_clear_device_reset_pending(hba);
> >>>> +			dev_err(hba->dev, "%s: reset and restore failed\n",
> >>>> +					__func__);
> >>>> +			hba->ufshcd_state = UFSHCD_STATE_ERROR;
> >>>> +		}
> >>>> +		/*
> >>>> +		 * Inform scsi mid-layer that we did reset and allow to handle
> >>>> +		 * Unit Attention properly.
> >>>> +		 */
> >>>> +		scsi_report_bus_reset(hba->host, 0);
> >>>> +		hba->errors = 0;
> >>>> +		hba->uic_error = 0;
> >>>> +	}
> >>>> +	scsi_unblock_requests(hba->host);
> >>>>    	pm_runtime_put_sync(hba->dev);
> >>>>    }
> >>>>
> >>>>    /**
> >>>> - * ufshcd_err_handler - Check for fatal errors
> >>>> - * @work: pointer to a work queue structure
> >>>> + * ufshcd_update_uic_error - check and set fatal UIC error flags.
> >>>> + * @hba: per-adapter instance
> >>>>     */
> >>>> -static void ufshcd_err_handler(struct ufs_hba *hba)
> >>>> +static void ufshcd_update_uic_error(struct ufs_hba *hba)
> >>>>    {
> >>>>    	u32 reg;
> >>>>
> >>>> +	/* PA_INIT_ERROR is fatal and needs UIC reset */
> >>>> +	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
> >>>> +	if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
> >>>> +		hba->uic_error |= UFSHCD_UIC_DL_PA_INIT_ERROR;
> >>>> +
> >>>> +	/* UIC NL/TL/DME errors needs software retry */
> >>>> +	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_NETWORK_LAYER);
> >>>> +	if (reg)
> >>>> +		hba->uic_error |= UFSHCD_UIC_NL_ERROR;
> >>>> +
> >>>> +	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_TRANSPORT_LAYER);
> >>>> +	if (reg)
> >>>> +		hba->uic_error |= UFSHCD_UIC_TL_ERROR;
> >>>> +
> >>>> +	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DME);
> >>>> +	if (reg)
> >>>> +		hba->uic_error |= UFSHCD_UIC_DME_ERROR;
> >>> REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER is not handled.
> >>
> >> UFS spec. mentions that it is non-fatal error and UIC recovers
> >> by itself and doesn't need software intervention.
> > Ok.
> >
> >>
> >>>
> >>>> +
> >>>> +	dev_dbg(hba->dev, "%s: UIC error flags = 0x%08x\n",
> >>>> +			__func__, hba->uic_error);
> >>>> +}
> >>>> +
> >>>> +/**
> >>>> + * ufshcd_err_handler - Check for fatal errors
> >>>> + * @hba: per-adapter instance
> >>>> + */
> >>>> +static void ufshcd_err_handler(struct ufs_hba *hba)
> >>>> +{
> >>>>    	if (hba->errors & INT_FATAL_ERRORS)
> >>>>    		goto fatal_eh;
> >>>>
> >>>>    	if (hba->errors & UIC_ERROR) {
> >>>> -		reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
> >>>> -		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
> >>>> +		hba->uic_error = 0;
> >>>> +		ufshcd_update_uic_error(hba);
> >>>> +		if (hba->uic_error)
> >>> Except UFSHCD_UIC_DL_PA_INIT_ERROR, it's not fatal. Should it go to fatal_eh?
> >>
> >> Please see the UIC error handling in ufshcd_fatal_err_handler(), others
> >> need software intervention so I combined it with fatal_eh to complete
> >> the requests and report to SCSI.
> > As gathering all error(fatal, non-fatal)handling into origin one, it makes confused.
> > Then, I would be better to rename ufshcd_fatal_err_handler.
> >
> 
> Yeah, ufshcd_err_handler is apt but it is already consumed. Probably,
> ufshcd_err_handler -> ufshcd_check_errors
> ufshcd_fatal_err_handler -> ufshcd_err_handler
> rename would be fine?
I like it.

Thanks,
Seungwon Jeon

