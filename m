From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/4] scsi: Stop accepting SCSI requests before removing
 a device
Date: Tue, 05 Jun 2012 17:08:09 -0500
Message-ID: <4FCE8349.2000908@cs.wisc.edu>
References: <4FCE3D20.4000205@acm.org> <4FCE3E63.7000002@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49140 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2FEWIc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jun 2012 18:08:32 -0400
In-Reply-To: <4FCE3E63.7000002@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

On 06/05/2012 12:14 PM, Bart Van Assche wrote:
> Avoid that the code for requeueing SCSI requests triggers a
> crash by making sure that that code isn't scheduled anymore
> after a device has been removed.
> 
> Also, source code inspection of __scsi_remove_device() revealed
> a race condition in this function: no new SCSI requests must be
> accepted for a SCSI device after device removal started.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Bottomley <JBottomley@parallels.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Joe Lawrence <jdl1291@gmail.com>
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: <stable@kernel.org>
> ---
>  drivers/scsi/scsi_lib.c   |    7 ++++---
>  drivers/scsi/scsi_sysfs.c |   11 +++++++++--
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 082c1e5..b722a8b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -158,10 +158,11 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
>  	 * that are already in the queue.
>  	 */
>  	spin_lock_irqsave(q->queue_lock, flags);
> -	blk_requeue_request(q, cmd->request);
> +	if (!blk_queue_dead(q)) {
> +		blk_requeue_request(q, cmd->request);
> +		kblockd_schedule_work(q, &device->requeue_work);
> +	}
>  	spin_unlock_irqrestore(q->queue_lock, flags);
> -
> -	kblockd_schedule_work(q, &device->requeue_work);

If we do not have the part of the patch above, but have your other
patches and the code below, will we  be ok?

I think we will requeue the request, then blk_drain_queue will end up
running the queue (blk_drain_queue will not return while req is requeued
because the rq count is still incremented). Then scsi_request_fn will be
run. blk_peek_request will give us the requeued request. We will hit the
scsi_device_online check with the state being SDEV_DEL, and then call we
call scsi_kill_request. This should then lead to the scsi_cmnd and its
other scsi stuff, like the scatterlist, and sense bufffer, to be
released. And then the request struct will be finished and freed and
then the rq count decremented?


>  }
>  
>  /*
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 42c35ff..efffc92 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -966,13 +966,20 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  		device_del(dev);
>  	} else
>  		put_device(&sdev->sdev_dev);
> +
> +	/*
> +	 * Stop accepting new requests and wait until all queuecommand() and
> +	 * scsi_run_queue() invocations have finished before tearing down the
> +	 * device.
> +	 */
>  	scsi_device_set_state(sdev, SDEV_DEL);
> +	blk_cleanup_queue(sdev->request_queue);
> +	cancel_work_sync(&sdev->requeue_work);


I agree we do still need this part of the patch with the cancel, because
the workstruct could still be queued but something could run the queue
without dequeueing the workstruct. That would free the request and that
could lead to blk_cleanup_queue running and us freeing the scsi_device
from under the workstruct.

> +
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
>  
> -	/* Freeing the queue signals to block that we're done */
> -	blk_cleanup_queue(sdev->request_queue);
>  	put_device(dev);
>  }
>  

