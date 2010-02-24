From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/1] mid-layer unblocks blocked sdev leaving queue stopped
Date: Wed, 24 Feb 2010 14:17:59 -0600
Message-ID: <4B858977.1030707@sgi.com>
References: <4B29628D.9090208@sgi.com> <4B73322F.2000001@sgi.com> <4B7339C7.10403@cs.wisc.edu> <4B7B12B7.8050601@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:34991 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945Ab0BXUSE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Feb 2010 15:18:04 -0500
In-Reply-To: <4B7B12B7.8050601@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>



Michael Reed wrote:
> Mike Christie wrote:
>> On 02/10/2010 04:24 PM, Michael Reed wrote:
>>>> +	/*
>>>> +	 * If device is blocked, leave state alone and let blocker
>>>> +	 * unblock when appropriate.  Otherwise, set the device
>>>> +	 * running here so that slave configure may perform i/o.
>>>> +	 */
>>>> +	if (sdev->sdev_state != SDEV_BLOCK) {
>>>> +		ret = scsi_device_set_state(sdev, SDEV_RUNNING);
>> Do we need locking here? Is it possible that right after we check the 
>> sdev_state for being blocked, it could be be set to blocked?
> 
> Since the sdev_state can be set to blocked upon entry to the routines,
> it seems likely that it could transition as you describe.  The host_lock
> appears to be the right lock for this.  Nice catch.  It does, however,
> open a can of worms.  The documentation for the _block()/_unblock()
> functions state that it is assumed the host_lock is held upon entry.
> This doesn't line up with the code, which explicitly releases the
> host_lock before calling scsi_internal_device_[un]block().
> 
> I previously toyed around with an alternate method of resolving this which
> put the onus on the unblocking thread which doesn't care about the
> sdev_state.  As scsi_internal_device_block() is the routine which stops
> the queue, I made scsi_internal_device_unblock() allow for the
> possibility that another thread had transitioned sdev_state from SDEV_BLOCK.
> 
> It's been long enough that I don't recall why I chose the patch I
> posted to resolve the issue, but this patch was also effective at
> resolving the issue.  It also confines the change to the _block()/
> _unblock() pair of routines and doesn't require changes to the
> existing locking logic.  In retrospect, this patch was probably the
> one I should have chosen to post.
> 
> Please review.

I've encountered a test system which exhibits this problem regularly.
This patch consistently corrects the hang and allows the system to
boot.  I used a printk to confirm the condition was encountered.

Please consider this patch for integration to stable as well as
any other appropriate trees.

Thank you.

Mike

> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> --- a/drivers/scsi/scsi_lib.c	2010-02-08 11:19:57.000000000 -0600
> +++ b/drivers/scsi/scsi_lib.c	2010-02-11 14:35:26.249142688 -0600
> @@ -2376,7 +2376,7 @@ EXPORT_SYMBOL(scsi_target_resume);
>   *	(which must be a legal transition).  When the device is in this
>   *	state, all commands are deferred until the scsi lld reenables
>   *	the device with scsi_device_unblock or device_block_tmo fires.
> - *	This routine assumes the host_lock is held on entry.
> + *	This routine assumes the host_lock is not held on entry.
>   */
>  int
>  scsi_internal_device_block(struct scsi_device *sdev)
> @@ -2420,7 +2420,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_b
>   *	This routine transitions the device to the SDEV_RUNNING state
>   *	(which must be a legal transition) allowing the midlayer to
>   *	goose the queue for this device.  This routine assumes the 
> - *	host_lock is held upon entry.
> + *	host_lock is not held upon entry.
>   */
>  int
>  scsi_internal_device_unblock(struct scsi_device *sdev)
> @@ -2431,15 +2431,23 @@ scsi_internal_device_unblock(struct scsi
>  	/* 
>  	 * Try to transition the scsi device to SDEV_RUNNING
>  	 * and goose the device queue if successful.  
> +	 * It's possible that an sdev may be blocked before it is
> +	 * completely set up.  scsi_sysfs_add_sdev() and scsi_add_lun()
> +	 * will unconditionally attempt to transition the sdev to
> +	 * SDEV_RUNNING.  To avoid leaving the queue stopped, we
> +	 * allow for the sdev to already be in the SDEV_RUNNING state.
>  	 */
> +	spin_lock_irqsave(q->queue_lock, flags);
> +
>  	if (sdev->sdev_state == SDEV_BLOCK)
>  		sdev->sdev_state = SDEV_RUNNING;
>  	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
>  		sdev->sdev_state = SDEV_CREATED;
> -	else
> +	else if (sdev->sdev_state != SDEV_RUNNING || !blk_queue_stopped(q)) {
> +		spin_unlock_irqrestore(q->queue_lock, flags);
>  		return -EINVAL;
> +	}
>  
> -	spin_lock_irqsave(q->queue_lock, flags);
>  	blk_start_queue(q);
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
