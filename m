From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 1/9] Fix race between starved list and device removal
Date: Mon, 24 Jun 2013 18:16:14 +0200
Message-ID: <51C870CE.4020900@acm.org>
References: <51B86E26.6030108@acm.org> <51B86E74.60909@acm.org> <1372088320.2013.33.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:53723 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FXQQU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 12:16:20 -0400
In-Reply-To: <1372088320.2013.33.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

On 06/24/13 17:38, James Bottomley wrote:
> I really don't like this because it's shuffling potentially fragile
> lifetime rules since you now have to have the sdev deleted from the
> starved list before final put.  That becomes an unstated assumption
> within the code.
>
> The theory is that the starved list processing may be racing with a
> scsi_remove_device, so when we unlock the host lock, the device (and the
> queue) may be destroyed.  OK, so I agree with this, remote a possibility
> though it may be.  The easy way of fixing it without making assumptions
> is this, isn't it?  All it requires is that the queue be destroyed after
> the starved list entry is deleted in the sdev release code.
>
> James
>
> ---
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 86d5220..f294cc6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -434,6 +434,7 @@ static void scsi_run_queue(struct request_queue *q)
>   	list_splice_init(&shost->starved_list, &starved_list);
>
>   	while (!list_empty(&starved_list)) {
> +		struct request_queue *slq;
>   		/*
>   		 * As long as shost is accepting commands and we have
>   		 * starved queues, call blk_run_queue. scsi_request_fn
> @@ -456,10 +457,21 @@ static void scsi_run_queue(struct request_queue *q)
>   			continue;
>   		}
>
> +		/*
> +		 * once we drop the host lock, a racing scsi_remove_device may
> +		 * remove the sdev from the starved list and destroy it and
> +		 * the queue.  Mitigate by taking a reference to the queue and
> +		 * never touching the sdev again after we drop the host lock.
> +		 */
> +		slq = sdev->request_queue;
> +		if (!blk_get_queue(slq))
> +			continue;
> +
>   		spin_unlock(shost->host_lock);
> -		spin_lock(sdev->request_queue->queue_lock);
> -		__blk_run_queue(sdev->request_queue);
> -		spin_unlock(sdev->request_queue->queue_lock);
> +
> +		blk_run_queue(slq);
> +		blk_put_queue(slq);
> +
>   		spin_lock(shost->host_lock);
>   	}
>   	/* put any unprocessed entries back */

Since the above patch invokes blk_put_queue() with interrupts disabled 
it may cause blk_release_queue() to be invoked with interrupts disabled. 
Sorry but I'm not sure whether that will work fine.

Bart.
