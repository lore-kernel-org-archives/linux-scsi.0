From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v5] sd: Fix device removal NULL pointer dereference
Date: Wed, 02 May 2012 02:58:55 -0500
Message-ID: <4FA0E93F.7020005@cs.wisc.edu>
References: <4F959CED.8000200@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59042 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2EBH7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 May 2012 03:59:20 -0400
In-Reply-To: <4F959CED.8000200@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

On 04/23/2012 01:18 PM, Bart Van Assche wrote:
> Since scsi_prep_fn() may be invoked concurrently with
> scsi_remove_device(), keep the queuedata pointer in
> scsi_remove_device(). This patch fixes a kernel oops that
> can be triggered by USB device removal. See also
> http://www.spinics.net/lists/linux-scsi/msg56254.html.

I think the patch make sense. After blk_cleanup_queue calls
blk_drain_queue then no more IO will be queued to us and no IO is
running. At that point it is safe to release resources and clean things
up. Before that though there is no guarantee, so we hit your oops.

>  void scsi_free_queue(struct request_queue *q)
>  {
> -	unsigned long flags;
> -
> -	WARN_ON(q->queuedata);
> -
> -	/* cause scsi_request_fn() to kill all non-finished requests */
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	q->request_fn(q);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> -
>  	blk_cleanup_queue(q);

I think you should just remove scsi_free_queue and then call
blk_cleanup_queue directly since there is nothing in scsi_free_queue now.

>  }
>  
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 04c2a27..65801e9 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -971,9 +971,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);
>  
> -	/* cause the request function to reject all I/O requests */
> -	sdev->request_queue->queuedata = NULL;
> -
>  	/* Freeing the queue signals to block that we're done */
>  	scsi_free_queue(sdev->request_queue);
>  	put_device(dev);

I think your patch fixes your issue, but I think we have a similar one
where if a user were to remove the device through sysfs IO could be just
hitting the LLD's queuecommand function when __scsi_remove_device is
run. __scsi_remove_device could call slave_destroy and other transport
desctructors could get called. Then the LLD could try to be accessing
those resources from their queuecommand. To also fix that I think we
would want to move the scsi_free_queue/blk_cleanup_queue call to the
beginning of __scsi_remove_device. Maybe that can be another patch since
it fixes a slightly different bug.
