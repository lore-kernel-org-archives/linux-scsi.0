From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 08/13] Remove get_device() / put_device() pair from
 scsi_request_fn()
Date: Sun, 2 Dec 2012 05:34:37 -0800
Message-ID: <20121202133437.GH15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B6083B.2000209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53206 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2LBNem (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:34:42 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1422820pbc.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:34:42 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B6083B.2000209@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Hello,

On Wed, Nov 28, 2012 at 01:48:59PM +0100, Bart Van Assche wrote:
> Now that all scsi_request_fn() callers hold a reference on the
> SCSI device that function is invoked on and since
> blk_cleanup_queue() waits until scsi_request_fn() has finished
> it is safe to remove the get_device() / put_device() pair from
> scsi_request_fn().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Jens Axboe <axboe@kernel.dk>

Acked-by: Tejun Heo <tj@kernel.org>

with one nit.

> @@ -1643,11 +1641,7 @@ out_delay:
>  	if (sdev->device_busy == 0)
>  		blk_delay_queue(q, SCSI_QUEUE_DELAY);
>  out:
> -	/* must be careful here...if we trigger the ->remove() function
> -	 * we cannot be holding the q lock */
> -	spin_unlock_irq(q->queue_lock);
> -	put_device(&sdev->sdev_gendev);
> -	spin_lock_irq(q->queue_lock);
> +	;

There's one "goto out" at the end of the usual control flow.  Please
just return from there.

Thanks.

-- 
tejun
