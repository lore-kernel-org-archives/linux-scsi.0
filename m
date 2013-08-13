From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [PATCH V5 3/4] scsi: ufs: Fix device and host reset methods
Date: Tue, 13 Aug 2013 17:55:08 +0300
Message-ID: <006801ce9835$1c58bfb0$550a3f10$@codeaurora.org>
References: <1375163155-1473-1-git-send-email-sthumma@codeaurora.org>    <1375163155-1473-4-git-send-email-sthumma@codeaurora.org> <a3390bf7d5dfccb4c7617f0fae8700f2.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:59302 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892Ab3HMOzO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2013 10:55:14 -0400
In-Reply-To: <a3390bf7d5dfccb4c7617f0fae8700f2.squirrel@www.codeaurora.org>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org

Reviewed-by: Yaniv Gardi <ygardi@codeaurora.org>

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


= > -----Original Message-----
= > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
= > owner@vger.kernel.org] On Behalf Of Dolev Raviv
= > Sent: Monday, August 12, 2013 4:02 PM
= > To: Sujit Reddy Thumma
= > Cc: Vinayak Holikatti; Santosh Y; James E.J. Bottomley; linux-
= > scsi@vger.kernel.org; Sujit Reddy Thumma; linux-arm-
= > msm@vger.kernel.org
= > Subject: Re: [PATCH V5 3/4] scsi: ufs: Fix device and host reset methods
= > 
= > Tested-by: Dolev Raviv <draviv@codeaurora.org>
= > 
= > > As of now SCSI initiated error handling is broken because, the reset
= > > APIs don't try to bring back the device initialized and ready for
= > > further transfers.
= > >
= > > In case of timeouts, the scsi error handler takes care of handling
= > > aborts and resets. Improve the error handling in such scenario by
= > > resetting the device and host and re-initializing them in proper
manner.
= > >
= > > Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
= > > ---
= > >  drivers/scsi/ufs/ufshcd.c |  240
= > > +++++++++++++++++++++++++++++++++++----------
= > >  drivers/scsi/ufs/ufshcd.h |    2 +
= > >  2 files changed, 189 insertions(+), 53 deletions(-)
= > >
= > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
= > > index d4ee48d..c577e6e 100644
= > > --- a/drivers/scsi/ufs/ufshcd.c
= > > +++ b/drivers/scsi/ufs/ufshcd.c
= > > @@ -69,9 +69,14 @@ enum {
= > >
= > >  /* UFSHCD states */
= > >  enum {
= > > -	UFSHCD_STATE_OPERATIONAL,
= > >  	UFSHCD_STATE_RESET,
= > >  	UFSHCD_STATE_ERROR,
= > > +	UFSHCD_STATE_OPERATIONAL,
= > > +};
= > > +
= > > +/* UFSHCD error handling flags */
= > > +enum {
= > > +	UFSHCD_EH_IN_PROGRESS = (1 << 0),
= > >  };
= > >
= > >  /* Interrupt configuration options */ @@ -87,6 +92,16 @@ enum {
= > >  	INT_AGGR_CONFIG,
= > >  };
= > >
= > > +#define ufshcd_set_eh_in_progress(h) \
= > > +	(h->eh_flags |= UFSHCD_EH_IN_PROGRESS) #define
= > > +ufshcd_eh_in_progress(h) \
= > > +	(h->eh_flags & UFSHCD_EH_IN_PROGRESS) #define
= > > +ufshcd_clear_eh_in_progress(h) \
= > > +	(h->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
= > > +
= > > +static void ufshcd_tmc_handler(struct ufs_hba *hba); static void
= > > +ufshcd_async_scan(void *data, async_cookie_t cookie);
= > > +
= > >  /*
= > >   * ufshcd_wait_for_register - wait for register value to change
= > >   * @hba - per-adapter interface
= > > @@ -840,10 +855,25 @@ static int ufshcd_queuecommand(struct
= > Scsi_Host
= > > *host, struct scsi_cmnd *cmd)
= > >
= > >  	tag = cmd->request->tag;
= > >
= > > -	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
= > > +	spin_lock_irqsave(hba->host->host_lock, flags);
= > > +	switch (hba->ufshcd_state) {
= > > +	case UFSHCD_STATE_OPERATIONAL:
= > > +		break;
= > > +	case UFSHCD_STATE_RESET:
= > >  		err = SCSI_MLQUEUE_HOST_BUSY;
= > > -		goto out;
= > > +		goto out_unlock;
= > > +	case UFSHCD_STATE_ERROR:
= > > +		set_host_byte(cmd, DID_ERROR);
= > > +		cmd->scsi_done(cmd);
= > > +		goto out_unlock;
= > > +	default:
= > > +		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
= > > +				__func__, hba->ufshcd_state);
= > > +		set_host_byte(cmd, DID_BAD_TARGET);
= > > +		cmd->scsi_done(cmd);
= > > +		goto out_unlock;
= > >  	}
= > > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
= > >
= > >  	/* acquire the tag to make sure device cmds don't use it */
= > >  	if (test_and_set_bit_lock(tag, &hba->lrb_in_use)) { @@ -880,6
= > +910,7
= > > @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct
= > > scsi_cmnd *cmd)
= > >  	/* issue command to the controller */
= > >  	spin_lock_irqsave(hba->host->host_lock, flags);
= > >  	ufshcd_send_command(hba, tag);
= > > +out_unlock:
= > >  	spin_unlock_irqrestore(hba->host->host_lock, flags);
= > >  out:
= > >  	return err;
= > > @@ -1495,8 +1526,6 @@ static int
= > ufshcd_make_hba_operational(struct
= > > ufs_hba *hba)
= > >  	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
= > >  		scsi_unblock_requests(hba->host);
= > >
= > > -	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
= > > -
= > >  out:
= > >  	return err;
= > >  }
= > > @@ -2245,8 +2274,12 @@ static void ufshcd_err_handler(struct ufs_hba
= > *hba)
= > >  	}
= > >  	return;
= > >  fatal_eh:
= > > -	hba->ufshcd_state = UFSHCD_STATE_ERROR;
= > > -	schedule_work(&hba->feh_workq);
= > > +	/* handle fatal errors only when link is functional */
= > > +	if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
= > > +		/* block commands at driver layer until error is handled */
= > > +		hba->ufshcd_state = UFSHCD_STATE_ERROR;
= > > +		schedule_work(&hba->feh_workq);
= > > +	}
= > >  }
= > >
= > >  /**
= > > @@ -2411,12 +2444,13 @@ static int ufshcd_issue_tm_cmd(struct
= > ufs_hba
= > > *hba, int lun_id, int task_id,  }
= > >
= > >  /**
= > > - * ufshcd_device_reset - reset device and abort all the pending
= > > commands
= > > + * ufshcd_eh_device_reset_handler - device reset handler registered
to
= > > + *                                    scsi layer.
= > >   * @cmd: SCSI command pointer
= > >   *
= > >   * Returns SUCCESS/FAILED
= > >   */
= > > -static int ufshcd_device_reset(struct scsi_cmnd *cmd)
= > > +static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
= > >  {
= > >  	struct Scsi_Host *host;
= > >  	struct ufs_hba *hba;
= > > @@ -2425,6 +2459,7 @@ static int ufshcd_device_reset(struct
= > scsi_cmnd
= > > *cmd)
= > >  	int err;
= > >  	u8 resp = 0xF;
= > >  	struct ufshcd_lrb *lrbp;
= > > +	unsigned long flags;
= > >
= > >  	host = cmd->device->host;
= > >  	hba = shost_priv(host);
= > > @@ -2433,55 +2468,33 @@ static int ufshcd_device_reset(struct
= > > scsi_cmnd
= > > *cmd)
= > >  	lrbp = &hba->lrb[tag];
= > >  	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, 0,
= > UFS_LOGICAL_RESET, &resp);
= > >  	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
= > > -		err = FAILED;
= > > +		if (!err)
= > > +			err = resp;
= > >  		goto out;
= > > -	} else {
= > > -		err = SUCCESS;
= > >  	}
= > >
= > > -	for (pos = 0; pos < hba->nutrs; pos++) {
= > > -		if (test_bit(pos, &hba->outstanding_reqs) &&
= > > -		    (hba->lrb[tag].lun == hba->lrb[pos].lun)) {
= > > -
= > > -			/* clear the respective UTRLCLR register bit */
= > > -			ufshcd_utrl_clear(hba, pos);
= > > -
= > > -			clear_bit(pos, &hba->outstanding_reqs);
= > > -
= > > -			if (hba->lrb[pos].cmd) {
= > > -				scsi_dma_unmap(hba->lrb[pos].cmd);
= > > -				hba->lrb[pos].cmd->result =
= > > -					DID_ABORT << 16;
= > > -				hba->lrb[pos].cmd->scsi_done(cmd);
= > > -				hba->lrb[pos].cmd = NULL;
= > > -				clear_bit_unlock(pos, &hba->lrb_in_use);
= > > -				wake_up(&hba->dev_cmd.tag_wq);
= > > -			}
= > > +	/* clear the commands that were pending for corresponding LUN
= > */
= > > +	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
= > > +		if (hba->lrb[pos].lun == lrbp->lun) {
= > > +			err = ufshcd_clear_cmd(hba, pos);
= > > +			if (err)
= > > +				break;
= > >  		}
= > > -	} /* end of for */
= > > +	}
= > > +	spin_lock_irqsave(host->host_lock, flags);
= > > +	ufshcd_transfer_req_compl(hba);
= > > +	spin_unlock_irqrestore(host->host_lock, flags);
= > >  out:
= > > +	if (!err) {
= > > +		err = SUCCESS;
= > > +	} else {
= > > +		dev_err(hba->dev, "%s: failed with err %d\n", __func__,
= > err);
= > > +		err = FAILED;
= > > +	}
= > >  	return err;
= > >  }
= > >
= > >  /**
= > > - * ufshcd_host_reset - Main reset function registered with scsi layer
= > > - * @cmd: SCSI command pointer
= > > - *
= > > - * Returns SUCCESS/FAILED
= > > - */
= > > -static int ufshcd_host_reset(struct scsi_cmnd *cmd) -{
= > > -	struct ufs_hba *hba;
= > > -
= > > -	hba = shost_priv(cmd->device->host);
= > > -
= > > -	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
= > > -		return SUCCESS;
= > > -
= > > -	return ufshcd_do_reset(hba);
= > > -}
= > > -
= > > -/**
= > >   * ufshcd_abort - abort a specific command
= > >   * @cmd: SCSI command pointer
= > >   *
= > > @@ -2579,6 +2592,122 @@ out:
= > >  }
= > >
= > >  /**
= > > + * ufshcd_host_reset_and_restore - reset and restore host controller
= > > + * @hba: per-adapter instance
= > > + *
= > > + * Note that host controller reset may issue DME_RESET to
= > > + * local and remote (device) Uni-Pro stack and the attributes
= > > + * are reset to default state.
= > > + *
= > > + * Returns zero on success, non-zero on failure  */ static int
= > > +ufshcd_host_reset_and_restore(struct ufs_hba *hba) {
= > > +	int err;
= > > +	async_cookie_t cookie;
= > > +	unsigned long flags;
= > > +
= > > +	/* Reset the host controller */
= > > +	spin_lock_irqsave(hba->host->host_lock, flags);
= > > +	ufshcd_hba_stop(hba);
= > > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
= > > +
= > > +	err = ufshcd_hba_enable(hba);
= > > +	if (err)
= > > +		goto out;
= > > +
= > > +	/* Establish the link again and restore the device */
= > > +	cookie = async_schedule(ufshcd_async_scan, hba);
= > > +	/* wait for async scan to be completed */
= > > +	async_synchronize_cookie(++cookie);
= > > +	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
= > > +		err = -EIO;
= > > +out:
= > > +	if (err)
= > > +		dev_err(hba->dev, "%s: Host init failed %d\n", __func__,
= > err);
= > > +
= > > +	return err;
= > > +}
= > > +
= > > +/**
= > > + * ufshcd_reset_and_restore - reset and re-initialize host/device
= > > + * @hba: per-adapter instance
= > > + *
= > > + * Reset and recover device, host and re-establish link. This
= > > + * is helpful to recover the communication in fatal error conditions.
= > > + *
= > > + * Returns zero on success, non-zero on failure  */ static int
= > > +ufshcd_reset_and_restore(struct ufs_hba *hba) {
= > > +	int err = 0;
= > > +	unsigned long flags;
= > > +
= > > +	err = ufshcd_host_reset_and_restore(hba);
= > > +
= > > +	/*
= > > +	 * After reset the door-bell might be cleared, complete
= > > +	 * outstanding requests in s/w here.
= > > +	 */
= > > +	spin_lock_irqsave(hba->host->host_lock, flags);
= > > +	ufshcd_transfer_req_compl(hba);
= > > +	ufshcd_tmc_handler(hba);
= > > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
= > > +
= > > +	return err;
= > > +}
= > > +
= > > +/**
= > > + * ufshcd_eh_host_reset_handler - host reset handler registered to
= > > +scsi
= > > layer
= > > + * @cmd - SCSI command pointer
= > > + *
= > > + * Returns SUCCESS/FAILED
= > > + */
= > > +static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd) {
= > > +	int err;
= > > +	unsigned long flags;
= > > +	struct ufs_hba *hba;
= > > +
= > > +	hba = shost_priv(cmd->device->host);
= > > +
= > > +	/*
= > > +	 * Check if there is any race with fatal error handling.
= > > +	 * If so, wait for it to complete. Even though fatal error
= > > +	 * handling does reset and restore in some cases, don't assume
= > > +	 * anything out of it. We are just avoiding race here.
= > > +	 */
= > > +	do {
= > > +		spin_lock_irqsave(hba->host->host_lock, flags);
= > > +		if (!(work_pending(&hba->feh_workq) ||
= > > +				hba->ufshcd_state ==
= > UFSHCD_STATE_RESET))
= > > +			break;
= > > +		spin_unlock_irqrestore(hba->host->host_lock, flags);
= > > +		dev_dbg(hba->dev, "%s: reset in progress\n", __func__);
= > > +		flush_work_sync(&hba->feh_workq);
= > > +	} while (1);
= > > +
= > > +	hba->ufshcd_state = UFSHCD_STATE_RESET;
= > > +	ufshcd_set_eh_in_progress(hba);
= > > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
= > > +
= > > +	err = ufshcd_reset_and_restore(hba);
= > > +
= > > +	spin_lock_irqsave(hba->host->host_lock, flags);
= > > +	if (!err) {
= > > +		err = SUCCESS;
= > > +		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
= > > +	} else {
= > > +		err = FAILED;
= > > +		hba->ufshcd_state = UFSHCD_STATE_ERROR;
= > > +	}
= > > +	ufshcd_clear_eh_in_progress(hba);
= > > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
= > > +
= > > +	return err;
= > > +}
= > > +
= > > +/**
= > >   * ufshcd_async_scan - asynchronous execution for link startup
= > >   * @data: data pointer to pass to this function
= > >   * @cookie: cookie data
= > > @@ -2601,8 +2730,13 @@ static void ufshcd_async_scan(void *data,
= > > async_cookie_t cookie)
= > >  		goto out;
= > >
= > >  	ufshcd_force_reset_auto_bkops(hba);
= > > -	scsi_scan_host(hba->host);
= > > -	pm_runtime_put_sync(hba->dev);
= > > +	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
= > > +
= > > +	/* If we are in error handling context no need to scan the host */
= > > +	if (!ufshcd_eh_in_progress(hba)) {
= > > +		scsi_scan_host(hba->host);
= > > +		pm_runtime_put_sync(hba->dev);
= > > +	}
= > >  out:
= > >  	return;
= > >  }
= > > @@ -2615,8 +2749,8 @@ static struct scsi_host_template
= > > ufshcd_driver_template = {
= > >  	.slave_alloc		= ufshcd_slave_alloc,
= > >  	.slave_destroy		= ufshcd_slave_destroy,
= > >  	.eh_abort_handler	= ufshcd_abort,
= > > -	.eh_device_reset_handler = ufshcd_device_reset,
= > > -	.eh_host_reset_handler	= ufshcd_host_reset,
= > > +	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
= > > +	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
= > >  	.this_id		= -1,
= > >  	.sg_tablesize		= SG_ALL,
= > >  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
= > > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
= > > index fe7c947..1e0585c 100644
= > > --- a/drivers/scsi/ufs/ufshcd.h
= > > +++ b/drivers/scsi/ufs/ufshcd.h
= > > @@ -179,6 +179,7 @@ struct ufs_dev_cmd {
= > >   * @tm_condition: condition variable for task management
= > >   * @tm_slots_in_use: bit map of task management request slots in use
= > >   * @ufshcd_state: UFSHCD states
= > > + * @eh_flags: Error handling flags
= > >   * @intr_mask: Interrupt Mask Bits
= > >   * @ee_ctrl_mask: Exception event control mask
= > >   * @feh_workq: Work queue for fatal controller error handling @@
= > > -224,6 +225,7 @@ struct ufs_hba {
= > >  	unsigned long tm_slots_in_use;
= > >
= > >  	u32 ufshcd_state;
= > > +	u32 eh_flags;
= > >  	u32 intr_mask;
= > >  	u16 ee_ctrl_mask;
= > >
= > > --
= > > QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
= > > member of Code Aurora Forum, hosted by The Linux Foundation.
= > >
= > > --
= > > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
= > > in the body of a message to majordomo@vger.kernel.org More
= > majordomo
= > > info at  http://vger.kernel.org/majordomo-info.html
= > >
= > 
= > 
= > --
= > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
= > member of Code Aurora Forum, hosted by The Linux Foundation
= > 
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the
= > body of a message to majordomo@vger.kernel.org More majordomo info
= > at  http://vger.kernel.org/majordomo-info.html

