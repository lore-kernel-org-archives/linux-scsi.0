From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 1/1] mid-layer unblocks blocked sdev leaving queue stopped
Date: Tue, 9 Mar 2010 11:14:25 -0500
Message-ID: <4B9673E1.1030408@emulex.com>
References: <4B29628D.9090208@sgi.com> <4B73322F.2000001@sgi.com> <4B7339C7.10403@cs.wisc.edu> <4B7B12B7.8050601@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:31182 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754522Ab0CIQOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2010 11:14:48 -0500
In-Reply-To: <4B7B12B7.8050601@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>

Re: locks-held comment : I went back to some of the original patches (Oct 
2004) and see that the comments were wrong then too...

Re: the patch...
In review, seeing how many places allow for the sdev_state to change w/o being 
under a lock (host lock or scan lock) is a real concern. But, as you mention 
(prior post), really correcting it opens a rats nest.  This does get around 
the primary issue - which is the overwrite of the blocked state by the scan 
code.  I wasn't sure the queue lock synchronization was good relative to the 
scan state, but I assume that's more for the potential blocked_queue_stopped() 
call than for anything else.

Acked-by: James Smart <james.smart@emulex.com>

-- james s


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
> 
