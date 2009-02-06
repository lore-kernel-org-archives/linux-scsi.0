From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 sent again] introduce soft reset handler
Date: Fri, 6 Feb 2009 12:45:22 -0800
Message-ID: <20090206124522.63f906c3.akpm@linux-foundation.org>
References: <200902060046.14606.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbZBFUqO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2009 15:46:14 -0500
In-Reply-To: <200902060046.14606.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@lsi.com, bs@q-leap.de, linux-scsi@vger.kernel.org, Kashyap.Desai@lsi.com, Eric.Moore@lsi.com, James.Bottomley@hansenpartnership.com, DL-MPTFusionLinux@lsi.com

On Fri, 6 Feb 2009 00:46:12 +0100
Bernd Schubert <bs@q-leap.de> wrote:

> Sathya, any chance you can ACK this patch before 2.6.30?
> 
> Thanks,
> Bernd
> 
> 
> Hello Sathya,
> 
> thanks for your patch review! Below is the updated version with DiagPending 
> replaced by ioc_reset_in_progress.
> 
> On dual port 53C1030 based HBAs such as the LSI22320R, the hard reset handler
> will cause DID_SOFT_ERROR for innocent devices on the second port.
> Introduce a mpt_SoftResetHandler() which doesn't cause this issue and 
> slightly improve mpt_HardResetHandler(). Replace DiagPending by 
> ioc_reset_in_progress to check for running resets.
> This is mostly a backport of the fusion-4.x driver available from LSI.
> 

The patch is rather wordwrapped.

The patch (and the file which it patches) is stuffed full of
excessively long lines, which makes the wordwrapping more common.

After fixing the wordwrapping, the patch doesn't apply against current
mainline.


> 
> Index: linux-2.6/drivers/message/fusion/mptbase.c
> ===================================================================
> --- linux-2.6.orig/drivers/message/fusion/mptbase.c
> +++ linux-2.6/drivers/message/fusion/mptbase.c
> @@ -5945,7 +5945,7 @@ mpt_timer_expired(unsigned long data)
>  	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_timer_expired! \n", ioc->name));
>  
>  	/* Perform a FW reload */
> -	if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0)
> +	if (mpt_SoftHardResetHandler(ioc, NO_SLEEP) < 0)
>  		printk(MYIOC_s_WARN_FMT "Firmware Reload FAILED!\n", ioc->name);
>  
>  	/* No more processing.
> @@ -6319,6 +6319,134 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, 
>  /*
>   *	Reset Handling
>   */
> +
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
> +static int
> +mpt_SoftResetHandler(MPT_ADAPTER *ioc, int sleepFlag)

`sleepFlag' is a poorly chosen identifier.  It's hard to tell whether
sleepFlag=true means "you can sleep" or "you can't sleep".  A better
name would be "can_sleep".

Or, better, make it a gfp_t, use GFP_ATOMIC/GFP_KERNEL test __GFP_WAIT.
This has the advantage that everyone knows what it means, so new and
duplicative mechanisms don't have to be learned.

> +{
> +	int		 rc;
> +	int		 ii;
> +	u8		 cb_idx;
> +	unsigned long	 flags;
> +	u32		 ioc_state;
> +	unsigned long	 time_count;
> +
> +	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SoftResetHandler Entered!\n",
> +			      ioc->name));
> +
> +	ioc_state = mpt_GetIocState(ioc, 0) & MPI_IOC_STATE_MASK;
> +	if (ioc_state == MPI_IOC_STATE_FAULT ||
> +	    ioc_state == MPI_IOC_STATE_RESET) {
> +		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		    "skipping, either in FAULT or RESET state!\n", ioc->name));
> +		return -1;
> +	}
> +
> +	spin_lock_irqsave(&ioc->diagLock, flags);
> +	if (ioc->ioc_reset_in_progress) {
> +		spin_unlock_irqrestore(&ioc->diagLock, flags);
> +		return -1;
> +	}
> +	ioc->ioc_reset_in_progress = 1;
> +	spin_unlock_irqrestore(&ioc->diagLock, flags);

Why not make ioc_reset_in_progress an unsigned long and use bitops? 
All the above can be replaced with

	if (test_and_set_bit(0, &ioc->flags))
		return -1;

> +	rc = -1;
> +
> +	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> +		if (MptResetHandlers[cb_idx])
> +			mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
> +	}
> +
> +	/* Disable reply interrupts (also blocks FreeQ) */
> +	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
> +	ioc->active = 0;
> +	time_count = jiffies;
> +	rc = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag);
> +	if (rc != 0)
> +		goto out;
> +
> +	/* MPT_IOC_PRE_RESET clears pending requests, but MUR
> +	 * (MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET) tries to find a DMA request and
> +	 * will fault the fw if no request is found. So we need to do
> +	 * MPT_IOC_PRE_RESET after MUR */
> +	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> +		if (MptResetHandlers[cb_idx])
> +			mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);
> +	}
> +
> +	ioc_state = mpt_GetIocState(ioc, 0) & MPI_IOC_STATE_MASK;
> +	if (ioc_state != MPI_IOC_STATE_READY)
> +		goto out;
> +
> +	for (ii = 0; ii < 5; ii++) {
> +		/* Get IOC facts! Allow 5 retries */
> +		rc = GetIocFacts(ioc, sleepFlag, MPT_HOSTEVENT_IOC_RECOVER);
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
> +	rc = SendEventNotification(ioc, 1);
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

Do we need lcoking coverage for ->active?

> +	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
> +
> + out:
> +	spin_lock_irqsave(&ioc->diagLock, flags);
> +	ioc->ioc_reset_in_progress = 0;
> +	ioc->taskmgmt_quiesce_io = 0;
> +	ioc->taskmgmt_in_progress = 0;
> +	spin_unlock_irqrestore(&ioc->diagLock, flags);
> +
> +	if (ioc->active) {	/* otherwise, hard reset coming */
> +		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> +			if (MptResetHandlers[cb_idx])
> +				mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
> +		}
> +	}
> +
> +	printk(MYIOC_s_INFO_FMT "SoftResetHandler: completed (%d seconds): %s\n",
> +	    ioc->name, jiffies_to_msecs(jiffies - time_count)/1000,

Using MSEC_PER_SEC would clarify the intent.

> +	    ((rc == 0) ? "SUCCESS" : "FAILED"));
> +
> +	return rc;
> +}
> +
>
> ...
>
> @@ -6368,42 +6499,70 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i
>  	 * Prevents timeouts occurring during a diagnostic reset...very bad.
>  	 * For all other protocol drivers, this is a no-op.
>  	 */
> -	{
> -		u8	 cb_idx;
> -		int	 r = 0;
> -
> -		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> -			if (MptResetHandlers[cb_idx]) {
> -				dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling IOC reset_setup handler 
> #%d\n",
> -						ioc->name, cb_idx));
> -				r += mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
> -				if (ioc->alt_ioc) {
> -					dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling alt-%s setup reset 
> handler #%d\n",
> -							ioc->name, ioc->alt_ioc->name, cb_idx));
> -					r += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
> -				}
> -			}
> +	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {

This loop omits the zeroeth element.  Was that intended?

> +		if (MptResetHandlers[cb_idx]) {
> +			mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
> +			if (ioc->alt_ioc)
> +				mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
>  		}
>  	}
>  
>
> ...
>
> --- linux-2.6.orig/drivers/message/fusion/mptscsih.c
> +++ linux-2.6/drivers/message/fusion/mptscsih.c
> @@ -1605,7 +1605,7 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
>  			"TM Handler for type=%x: IOC Not operational (0x%x)!\n",
>  			ioc->name, type, ioc_raw_state);
>  		printk(MYIOC_s_WARN_FMT " Issuing HardReset!!\n", ioc->name);
> -		if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0)
> +		if (mpt_SoftHardResetHandler(ioc, CAN_SLEEP) < 0)
>  			printk(MYIOC_s_WARN_FMT "TMHandler: HardReset "
>  			    "FAILED!!\n", ioc->name);
>  		return FAILED;
> @@ -1621,8 +1621,8 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
>  
>  	/* Isse the Task Mgmt request.

someone had a typo

>  	 */
> -	if (hd->hard_resets < -1)
> -		hd->hard_resets++;
> +	if (ioc->hard_resets < -1)

what strange code.

> +		ioc->hard_resets++;

Does this non-atomic increment have locking coverage?

>  	rc = mptscsih_IssueTaskMgmt(hd, type, channel, id, lun,
>  	    ctx2abort, timeout);
> @@ -1724,7 +1724,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd
>  			ioc, mf));
>  		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling HardReset! \n",
>  			 ioc->name));
> -		retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
> +		retval = mpt_SoftHardResetHandler(ioc, CAN_SLEEP);
>  		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "rc=%d \n",
>  			 ioc->name, retval));
>  		goto fail_out;
>
> ...
>
