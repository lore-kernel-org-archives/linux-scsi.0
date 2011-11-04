From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
Date: Fri, 4 Nov 2011 10:40:42 +0100
Message-ID: <20111104104042.46a33554@stein>
References: <4EB2BC88.3070105@suse.cz>
	<20111103161436.GJ4417@google.com>
	<20111103162634.GK4417@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111103162634.GK4417@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jiri Slaby <jslaby@suse.cz>, "James E.J. Bottomley" <jejb@parisc-linux.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Nov 03 Tejun Heo wrote:
> blk_cleanup_queue() may be called before elevator is set up on a
> queue which triggers the following oops.
[...]
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -407,8 +407,13 @@ void blk_cleanup_queue(struct request_queue *q)
>  	spin_unlock_irq(lock);
>  	mutex_unlock(&q->sysfs_lock);
>  
> -	/* drain all requests queued before DEAD marking */
> -	blk_drain_queue(q, true);
> +	/*
> +	 * Drain all requests queued before DEAD marking.  The caller might
> +	 * be trying to tear down @q before its elevator is initialized, in
> +	 * which case we don't want to call into draining.
> +	 */
> +	if (q->elevator)
> +		blk_drain_queue(q, true);
>  
>  	/* @q won't process any more request, flush async actions */
>  	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);

What prevents elevator_attach to be called and requests to be inserted
between 'if (q-elevator)' and 'blk_put_queue(q)'?
-- 
Stefan Richter
-=====-==-== =-== --=--
http://arcgraph.de/sr/
