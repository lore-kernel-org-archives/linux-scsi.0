From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [SCSI] Wake blockdev queue in scsi_internal_device_unblock()
 for SDEV_RUNNING
Date: Mon, 11 Mar 2013 13:08:53 -0500
Message-ID: <513E1DB5.8040404@cs.wisc.edu>
References: <1361814905-7201-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59877 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3CKSMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Mar 2013 14:12:31 -0400
In-Reply-To: <1361814905-7201-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

On 02/25/2013 11:55 AM, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> If a SCSI device's old state is already SDEV_RUNNING and we're moving
> to the same SDEV_RUNNING state, still wake the blockdev queue in
> scsi_internal_device_unblock().  This fixes a case where we silently
> hang SCSI commands forever during device discovery.  One way this can
> happen is when mpt2sas is discovering a reasonably big SAS topology,
> and the sd driver has queued up a bunch of sd_probe_async() instances
> that are queueing SCSI commands to various devices.
> 
> If at the same time a SAS fabric event goes to the HBA, what can
> happen is the following:
> 
>      - mpt2sas calls _scsih_block_io_all_device() -> scsi_internal_device_block(sdev)
> 
>        (In response to some HBA firmware event like MPI2_EVENT_SAS_BROADCAST_PRIMITIVE)
>        Now sdev state is SDEV_BLOCK and blockdev queue has QUEUE_FLAG_STOPPED set.
> 
>      - Someone like scsi_add_lun() calls scsi_device_set_state(sdev, SDEV_RUNNING)
> 
>        (SCSI bus scanning runs asynchronously to firmware event handling)
>        Now sdev state is SDEV_RUNNING but blockdev queue still has QUEUE_FLAG_STOPPED set

Is this a valid state change? Should it be failed in
scsi_device_set_state when we try to go from SDEV_BLOCKED ->
SDEV_RUNNING? I am not sure if it make senses to ever have a device in
SDEV_RUNNING but have the stopped queue bit set.

It used to be that scsi_internal_device_unblock called
scsi_device_set_state so the transition from SDEV_BLOCKED to
SDEV_RUNNUNG had to be a valid transition. scsi_internal_device_unblock
then started the queue. I am not sure if the sequence you were hitting
was actually a transition that was intended or just worked by accident.

Should we be failing the above call to scsi_device_set_state, and then
the call to scsi_internal_device_unblock would work as expected.

OTOH, your patch makes the block/unblock API easier to use.



> 
>      - mpt2sas calls _scsih_ublock_io_all_device() -> scsi_internal_device_unblock(sdev, SDEV_RUNNING)
> 
>        (Finishes handling the firmware event)
> 
> With the old scsi_lib code, scsi_internal_device_unblock() will return
> an error at this point because the sdev state is already SDEV_RUNNING.
> This means we skip the call to blk_start_queue() and never actually
> start executing commands again.
> 
> Fix this by still going ahead and finishing scsi_internal_device_unblock()
> even if the sdev state is already SDEV_RUNNING.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/scsi_lib.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 765398c..75108ea 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2495,7 +2495,9 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
>  		else
>  			sdev->sdev_state = SDEV_CREATED;
>  	} else if (sdev->sdev_state != SDEV_CANCEL &&
> -		 sdev->sdev_state != SDEV_OFFLINE)
> +		   sdev->sdev_state != SDEV_OFFLINE &&
> +		   (sdev->sdev_state != SDEV_RUNNING ||
> +		    new_state != SDEV_RUNNING))
>  		return -EINVAL;
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
> 

