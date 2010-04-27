From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH 01/12] mptfusion: Added new less expensive RESET (Message Unit Reset)
Date: Wed, 28 Apr 2010 00:43:36 +0200
Message-ID: <201004280043.36490.bernd.schubert@fastmail.fm>
References: <20100318134205.GB22510@lsi.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38045 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757421Ab0D0Wnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 18:43:39 -0400
In-Reply-To: <20100318134205.GB22510@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Sathya,

thanks for resending this patch. After I send it beginning of last year, 
Andrew gave some comments, I think we need to work on these first:

http://markmail.org/message/xig5zoo4lbfaldhl?q=thread:oy5eyda62vca7cbc

Andrew I'm sorry I didn't reply earlier, my only excuse is that I got sick 
that month and then started a new job immediately after.

As I also mostly only took the patch from the 4.x driver series, I'm also not 
familiar with all details Andrew ask about. 

Some comments of Andrews remarks are still valid (see the link above for more 
details).

1) `sleepFlag' is a poorly chosen identifier, make it it a gfp_t, use 
GFP_ATOMIC/GFP_KERNEL test __GFP_WAIT.

2) Why not make ioc_reset_in_progress an unsigned long and use bitops? 
All the above can be replaced with

3) Do we need lcoking coverage for ->active?

4) Using MSEC_PER_SEC would clarify the intent.

5) +        for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {


This loop omits the zeroeth element.  Was that intended?



Sathya, what do you think shall we improve the patch according to Andrews 
comments?


Thanks,
Bernd


On Thursday 18 March 2010, Kashyap, Desai wrote:
> Added Message unit reset.
> Message Unit Reset - instructs the IOC to reset the Reply Post and
> Free FIFO's. All the Message Frames on Reply Free FIFO are
> discarded. All posted buffers are freed, and event notification is turned
>  off. IOC doesnt reply to any outstanding request. This will transfer IOC
>  to READY state.
> Message unit ready is less expensive operations than Hard Reset.
> soft reset will not force Firmware to reload again, it only do clean up of
> Message units.
> 
> mpt_Soft_Hard_ResetHandler will first try for Soft Reset,if
> it fails then go for big hammer reset which is Hard Reset.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/mptbase.c
>  b/drivers/message/fusion/mptbase.c index 5382b5a..a4f023b 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -5064,7 +5064,7 @@ mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8
>  persist_opcode) if (!timeleft) {
>  			printk(KERN_DEBUG "%s: Issuing Reset from %s!!\n",
>  			    ioc->name, __func__);
> -			mpt_HardResetHandler(ioc, CAN_SLEEP);
> +			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  			mpt_free_msg_frame(ioc, mf);
>  		}
>  		goto out;
> @@ -6456,7 +6456,7 @@ out:
>  		issue_hard_reset = 0;
>  		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
>  		    ioc->name, __func__);
> -		mpt_HardResetHandler(ioc, CAN_SLEEP);
> +		mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  		mpt_free_msg_frame(ioc, mf);
>  		/* attempt one retry for a timed out command */
>  		if (!retry_count) {
> @@ -6904,6 +6904,172 @@ mpt_halt_firmware(MPT_ADAPTER *ioc)
>  }
>  EXPORT_SYMBOL(mpt_halt_firmware);
> 
> +/**
> + *	mpt_SoftResetHandler - Issues a less expensive reset
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@sleepFlag: Indicates if sleep or schedule must be called.
> +
> + *
> + *	Returns 0 for SUCCESS or -1 if FAILED.
> + *
> + *	Message Unit Reset - instructs the IOC to reset the Reply Post and
> + *	Free FIFO's. All the Message Frames on Reply Free FIFO are discarded.
> + *	All posted buffers are freed, and event notification is turned off.
> + *	IOC doesnt reply to any outstanding request. This will transfer IOC
> + *	to READY state.
> + **/
> +int
> +mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
> +{
> +	int		 rc;
> +	int		 ii;
> +	u8		 cb_idx;
> +	unsigned long	 flags;
> +	u32		 ioc_state;
> +	unsigned long	 time_count;
> +
> +	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SoftResetHandler Entered!\n",
> +		ioc->name));
> +
> +	ioc_state = mpt_GetIocState(ioc, 0) & MPI_IOC_STATE_MASK;
> +
> +	if (mpt_fwfault_debug)
> +		mpt_halt_firmware(ioc);
> +
> +	if (ioc_state == MPI_IOC_STATE_FAULT ||
> +	    ioc_state == MPI_IOC_STATE_RESET) {
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		    "skipping, either in FAULT or RESET state!\n", ioc->name));
> +		return -1;
> +	}
> +
> +	if (ioc->bus_type == FC) {
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		    "skipping, because the bus type is FC!\n", ioc->name));
> +		return -1;
> +	}
> +
> +	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
> +	if (ioc->ioc_reset_in_progress) {
> +		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
> +		return -1;
> +	}
> +	ioc->ioc_reset_in_progress = 1;
> +	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
> +
> +	rc = -1;
> +
> +	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> +		if (MptResetHandlers[cb_idx])
> +			mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
> +	}
> +
> +	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
> +	if (ioc->taskmgmt_in_progress) {
> +		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
> +		return -1;
> +	}
> +	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
> +	/* Disable reply interrupts (also blocks FreeQ) */
> +	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
> +	ioc->active = 0;
> +	time_count = jiffies;
> +
> +	rc = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag);
> +
> +	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> +		if (MptResetHandlers[cb_idx])
> +			mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);
> +	}
> +
> +	if (rc)
> +		goto out;
> +
> +	ioc_state = mpt_GetIocState(ioc, 0) & MPI_IOC_STATE_MASK;
> +	if (ioc_state != MPI_IOC_STATE_READY)
> +		goto out;
> +
> +	for (ii = 0; ii < 5; ii++) {
> +		/* Get IOC facts! Allow 5 retries */
> +		rc = GetIocFacts(ioc, sleepFlag,
> +			MPT_HOSTEVENT_IOC_RECOVER);
> +		if (rc == 0)
> +			break;
> +		if (sleepFlag == CAN_SLEEP)
> +			msleep(100);
> +		else
> +			mdelay(100);
> +	}
> +	if (ii == 5)
> +		goto out;
> +
> +	rc = PrimeIocFifos(ioc);
> +	if (rc != 0)
> +		goto out;
> +
> +	rc = SendIocInit(ioc, sleepFlag);
> +	if (rc != 0)
> +		goto out;
> +
> +	rc = SendEventNotification(ioc, 1, sleepFlag);
> +	if (rc != 0)
> +		goto out;
> +
> +	if (ioc->hard_resets < -1)
> +		ioc->hard_resets++;
> +
> +	/*
> +	 * At this point, we know soft reset succeeded.
> +	 */
> +
> +	ioc->active = 1;
> +	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
> +
> + out:
> +	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
> +	ioc->ioc_reset_in_progress = 0;
> +	ioc->taskmgmt_quiesce_io = 0;
> +	ioc->taskmgmt_in_progress = 0;
> +	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
> +
> +	if (ioc->active) {	/* otherwise, hard reset coming */
> +		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> +			if (MptResetHandlers[cb_idx])
> +				mpt_signal_reset(cb_idx, ioc,
> +					MPT_IOC_POST_RESET);
> +		}
> +	}
> +
> +	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		"SoftResetHandler: completed (%d seconds): %s\n",
> +		ioc->name, jiffies_to_msecs(jiffies - time_count)/1000,
> +		((rc == 0) ? "SUCCESS" : "FAILED")));
> +
> +	return rc;
> +}
> +
> +/**
> + *	mpt_Soft_Hard_ResetHandler - Try less expensive reset
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@sleepFlag: Indicates if sleep or schedule must be called.
> +
> + *
> + *	Returns 0 for SUCCESS or -1 if FAILED.
> + *	Try for softreset first, only if it fails go for expensive
> + *	HardReset.
> + **/
> +int
> +mpt_Soft_Hard_ResetHandler(MPT_ADAPTER *ioc, int sleepFlag) {
> +	int ret = -1;
> +
> +	ret = mpt_SoftResetHandler(ioc, sleepFlag);
> +	if (ret == 0)
> +		return ret;
> +	ret = mpt_HardResetHandler(ioc, sleepFlag);
> +	return ret;
> +}
> +EXPORT_SYMBOL(mpt_Soft_Hard_ResetHandler);
> +
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=*/ /*
>   *	Reset Handling
> diff --git a/drivers/message/fusion/mptbase.h
>  b/drivers/message/fusion/mptbase.h index 9718c8f..e25dbfb 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -940,6 +940,7 @@ extern int	 mpt_verify_adapter(int iocid, MPT_ADAPTER
>  **iocpp); extern u32	 mpt_GetIocState(MPT_ADAPTER *ioc, int cooked);
>  extern void	 mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buf, int *size,
>  int len, int showlan); extern int	 mpt_HardResetHandler(MPT_ADAPTER *ioc,
>  int sleepFlag); +extern int	 mpt_Soft_Hard_ResetHandler(MPT_ADAPTER *ioc,
>  int sleepFlag); extern int	 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
>  *cfg);
>  extern int	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
>  extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
> diff --git a/drivers/message/fusion/mptctl.c
>  b/drivers/message/fusion/mptctl.c index caa8f56..d0aa8fc 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -311,7 +311,7 @@ mptctl_timeout_expired(MPT_ADAPTER *ioc, MPT_FRAME_HDR
>  *mf) dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
>  ioc->name));
>  	CLEAR_MGMT_PENDING_STATUS(ioc->ioctl_cmds.status)
> -	mpt_HardResetHandler(ioc, CAN_SLEEP);
> +	mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  	mpt_free_msg_frame(ioc, mf);
>  }
> 
> diff --git a/drivers/message/fusion/mptsas.c
>  b/drivers/message/fusion/mptsas.c index c20bbe4..977d800 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -2040,7 +2040,7 @@ static int mptsas_phy_reset(struct sas_phy *phy, int
>  hard_reset) if (!timeleft) {
>  		/* On timeout reset the board */
>  		mpt_free_msg_frame(ioc, mf);
> -		mpt_HardResetHandler(ioc, CAN_SLEEP);
> +		mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  		error = -ETIMEDOUT;
>  		goto out_unlock;
>  	}
> @@ -2225,7 +2225,7 @@ static int mptsas_smp_handler(struct Scsi_Host
>  *shost, struct sas_rphy *rphy, if (!timeleft) {
>  		printk(MYIOC_s_ERR_FMT "%s: smp timeout!\n", ioc->name, __func__);
>  		/* On timeout reset the board */
> -		mpt_HardResetHandler(ioc, CAN_SLEEP);
> +		mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  		ret = -ETIMEDOUT;
>  		goto unmap;
>  	}
> @@ -2832,7 +2832,7 @@ mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
>  		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
>  			goto out_free;
>  		if (!timeleft)
> -			mpt_HardResetHandler(ioc, CAN_SLEEP);
> +			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  		goto out_free;
>  	}
> 
> @@ -4716,7 +4716,7 @@ mptsas_broadcast_primative_work(struct fw_event_work
>  *fw_event) if (issue_reset) {
>  		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
>  		    ioc->name, __func__);
> -		mpt_HardResetHandler(ioc, CAN_SLEEP);
> +		mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  	}
>  	mptsas_free_fw_event(ioc, fw_event);
>  }
> diff --git a/drivers/message/fusion/mptscsih.c
>  b/drivers/message/fusion/mptscsih.c index 4a7d1af..ea68970 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1710,7 +1710,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8
>  channel, u8 id, int lun, if (issue_hard_reset) {
>  		printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
>  			ioc->name, __func__);
> -		retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
> +		retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  		mpt_free_msg_frame(ioc, mf);
>  	}
> 
> @@ -1990,7 +1990,7 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
>  	/*  If our attempts to reset the host failed, then return a failed
>  	 *  status.  The host will be taken off line by the SCSI mid-layer.
>  	 */
> -    retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
> +    retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  	if (retval < 0)
>  		status = FAILED;
>  	else
> @@ -3039,7 +3039,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
>  		if (!timeleft) {
>  			printk(MYIOC_s_WARN_FMT "Issuing Reset from %s!!\n",
>  			    ioc->name, __func__);
> -			mpt_HardResetHandler(ioc, CAN_SLEEP);
> +			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
>  			mpt_free_msg_frame(ioc, mf);
>  		}
>  		goto out;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

