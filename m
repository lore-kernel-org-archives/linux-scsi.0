From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 07/13] Fix race between starved list processing and
 device removal
Date: Sun, 2 Dec 2012 05:32:31 -0800
Message-ID: <20121202133231.GG15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B60818.4060304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:63415 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2LBNcg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:32:36 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so920163dak.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:32:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B60818.4060304@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Hello, Bart.

On Wed, Nov 28, 2012 at 01:48:24PM +0100, Bart Van Assche wrote:
> @@ -452,11 +452,13 @@ static void scsi_run_queue(struct request_queue *q)
>  			continue;
>  		}
>  
> -		spin_unlock(shost->host_lock);
> -		spin_lock(sdev->request_queue->queue_lock);
> -		__blk_run_queue(sdev->request_queue);
> -		spin_unlock(sdev->request_queue->queue_lock);
> -		spin_lock(shost->host_lock);
> +		get_device(&sdev->sdev_gendev);
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +		blk_run_queue(sdev->request_queue);
> +		put_device(&sdev->sdev_gendev);
> +
> +		spin_lock_irqsave(shost->host_lock, flags);

Some comment wouldn't hurt here.

> @@ -977,6 +978,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	blk_cleanup_queue(sdev->request_queue);
>  	cancel_work_sync(&sdev->requeue_work);
>  
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_del(&sdev->starved_entry);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +

And please add a comment explaining what's going on around
->starved_entry.  It's rather different from anything else.

Thanks!

-- 
tejun
