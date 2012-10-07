From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH, resend] Fix race between starved list processing and
 device removal
Date: Sun, 07 Oct 2012 11:47:17 +0100
Message-ID: <1349606837.2541.19.camel@dabdike.int.hansenpartnership.com>
References: <5024088C.9060205@acm.org> <50605CBC.5080701@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54353 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986Ab2JGKrV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Oct 2012 06:47:21 -0400
In-Reply-To: <50605CBC.5080701@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On Mon, 2012-09-24 at 15:14 +0200, Bart Van Assche wrote:
> Avoid that the sdev reference count can drop to zero before
> the queue is run by scsi_run_queue(). Also avoid that the sdev
> reference count can drop to zero in the same function by invoking
> __blk_run_queue().
[...]		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> @@ -977,6 +978,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	blk_cleanup_queue(sdev->request_queue);
>  	cancel_work_sync(&sdev->requeue_work);
>  
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_del(&sdev->starved_entry);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +

This hunk doesn't make much sense.  It seems to be orthogonal to the
problem listed in the changelog and this action is done on last put
anyway.

James


