From: Omar Sandoval <osandov@osandov.com>
Subject: Re: mpt3sas sleep from atomic context on v4.10
Date: Tue, 28 Feb 2017 22:20:27 -0800
Message-ID: <20170301062027.GA30216@vader>
References: <20170301002533.GA12292@vader.DHCP.thefacebook.com>
 <1488330334.2370.23.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33089 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbdCAGaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 01:30:39 -0500
Received: by mail-pf0-f172.google.com with SMTP id w189so7833837pfb.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 22:30:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1488330334.2370.23.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "kernel-team@fb.com" <kernel-team@fb.com>

On Wed, Mar 01, 2017 at 01:07:12AM +0000, Bart Van Assche wrote:
> On Tue, 2017-02-28 at 16:25 -0800, Omar Sandoval wrote:
> > I'm seeing this while testing on Linus' current master:
> > 
> > [  427.814466] WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:149 __handle_irq_event_percpu+0x187/0x190
> > [  427.832552] irq 116 handler _base_interrupt+0x0/0x9e0 [mpt3sas] enabled interrupts
> > 
> > I tracked it down to commit 669f044170d8 ("scsi: srp_transport: Move
> > queuecommand() wait code to SCSI core"). That commit made it so
> > scsi_internal_device_block() can sleep, but mpt3sas calls this from an
> > interrupt handler:
> > 
> > _base_interrupt
> > -> _base_async_event
> >    -> mpt3sas_scsih_event_callback
> >       -> _scsih_check_topo_delete_events
> >          -> _scsih_block_io_to_children_attached_directly
> > 	    -> _scsih_block_io_device
> > 	       -> _scsih_internal_device_block
> > 	          -> scsi_internal_device_block
> > 
> > This change was made in 4.10. Bart, can you take a look?
> 
> How about the (entirely untested) patch below?
> 
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 ++--
>  drivers/scsi/scsi_lib.c              | 32 ++++++++++++++++++--------------
>  drivers/scsi/scsi_priv.h             |  3 ---
>  include/scsi/scsi_device.h           |  4 ++++
>  5 files changed, 24 insertions(+), 22 deletions(-)

[snip]

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3e32dc954c3c..77851697f130 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2945,6 +2945,8 @@ EXPORT_SYMBOL(scsi_target_resume);
>  /**
>   * scsi_internal_device_block - internal function to put a device temporarily into the SDEV_BLOCK state
>   * @sdev:	device to block
> + * @wait:       Whether or not to wait until ongoing .queuecommand() /
> + *		.queue_rq() calls have finished.
>   *
>   * Block request made by scsi lld's to temporarily stop all
>   * scsi commands on the specified device. May sleep.
> @@ -2962,7 +2964,7 @@ EXPORT_SYMBOL(scsi_target_resume);
>   * remove the rport mutex lock and unlock calls from srp_queuecommand().
>   */
>  int
> -scsi_internal_device_block(struct scsi_device *sdev)
> +scsi_internal_device_block(struct scsi_device *sdev, bool wait)
>  {
>  	struct request_queue *q = sdev->request_queue;
>  	unsigned long flags;
> @@ -2976,18 +2978,20 @@ scsi_internal_device_block(struct scsi_device *sdev)
>  			return err;
>  	}
>  
> -	/* 
> -	 * The device has transitioned to SDEV_BLOCK.  Stop the
> -	 * block layer from calling the midlayer with this device's
> -	 * request queue. 
> -	 */
> -	if (q->mq_ops) {
> -		blk_mq_quiesce_queue(q);
> -	} else {
> -		spin_lock_irqsave(q->queue_lock, flags);
> -		blk_stop_queue(q);
> -		spin_unlock_irqrestore(q->queue_lock, flags);
> -		scsi_wait_for_queuecommand(sdev);
> +	if (wait) {
> +		/*
> +		 * The device has transitioned to SDEV_BLOCK.  Stop the
> +		 * block layer from calling the midlayer with this device's
> +		 * request queue.
> +		 */
> +		if (q->mq_ops) {
> +			blk_mq_quiesce_queue(q);
> +		} else {
> +			spin_lock_irqsave(q->queue_lock, flags);
> +			blk_stop_queue(q);
> +			spin_unlock_irqrestore(q->queue_lock, flags);
> +			scsi_wait_for_queuecommand(sdev);
> +		}
>  	}

I think here, we want this instead:

@@ -2987,7 +2989,8 @@ scsi_internal_device_block(struct scsi_device *sdev)
                spin_lock_irqsave(q->queue_lock, flags);
                blk_stop_queue(q);
                spin_unlock_irqrestore(q->queue_lock, flags);
-               scsi_wait_for_queuecommand(sdev);
+               if (wait)
+                       scsi_wait_for_queuecommand(sdev);
        }

        return 0;

That fixes the warnings for me.
