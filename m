From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V4] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Mon, 29 Jan 2018 16:44:46 -0500
Message-ID: <20180129214446.GD5744@redhat.com>
References: <20180129203300.50595-1-snitzer@redhat.com>
 <1517260932.2687.42.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751645AbeA2Vou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 16:44:50 -0500
Content-Disposition: inline
In-Reply-To: <1517260932.2687.42.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Jan 29 2018 at  4:22pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Mon, 2018-01-29 at 15:33 -0500, Mike Snitzer wrote:
> > +		 * If driver returns BLK_STS_RESOURCE and SCHED_RESTART
> > +		 * bit is set, run queue after 10ms to avoid IO stalls
> > +		 * that could otherwise occur if the queue is idle.
> >  		 */
> > -		if (!blk_mq_sched_needs_restart(hctx) ||
> > +		needs_restart = blk_mq_sched_needs_restart(hctx);
> > +		if (!needs_restart ||
> >  		    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
> >  			blk_mq_run_hw_queue(hctx, true);
> > +		else if (needs_restart && (ret == BLK_STS_RESOURCE))
> > +			blk_mq_delay_run_hw_queue(hctx, BLK_MQ_QUEUE_DELAY);
> >  	}
> 
> The above code only calls blk_mq_delay_run_hw_queue() if the following condition
> is met: !(!needs_restart || (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
> && (needs_restart && (ret == BLK_STS_RESOURCE)). That boolean expression can be
> simplified into the following: needs_restart && ret == BLK_STS_RESOURCE && 
> !(no_tag && list_empty_careful(&hctx->dispatch_wait.entry)). From blk-mq-sched.h:
> 
> static inline bool blk_mq_sched_needs_restart(struct blk_mq_hw_ctx *hctx)
> {
> 	return test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
> }
> 
> In other words, the above code will not call blk_mq_delay_run_hw_queue() if
> BLK_MQ_S_SCHED_RESTART is cleared after it got set and before the above code is
> reached. The BLK_MQ_S_SCHED_RESTART bit gets cleared if a request completes
> concurrently with the above code. From blk-mq-sched.c:
> 
> static bool blk_mq_sched_restart_hctx(struct blk_mq_hw_ctx *hctx)
> {
> 	if (!test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
> 		return false;
> 
> 	if (hctx->flags & BLK_MQ_F_TAG_SHARED) {
> 		struct request_queue *q = hctx->queue;
> 
> 		if (test_and_clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
> 			atomic_dec(&q->shared_hctx_restart);
> 	} else
> 		clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
> 
> 	return blk_mq_run_hw_queue(hctx, true);
> }
> 
> The above blk_mq_run_hw_queue() call may finish either before or after
> blk_mq_dispatch_rq_list() examines the BLK_MQ_S_SCHED_RESTART flag.

But regardless of which wins the race, the queue will have been run.
Which is all we care about right?

> That's why I wrote in previous e-mails that this patch and also the previous
> versions of this patch change a systematic call of blk_mq_delay_run_hw_queue()
> into a call that may or may not happen, depending on whether or not a request
> completes concurrently with request queueing. Sorry but I think that means
> that the above change combined with changing BLK_STS_RESOURCE into
> BLK_STS_DEV_RESOURCE is wrong and why I expect that this will result in
> sporadic queue stalls. As you know sporadic queue stalls are annoying and hard
> to debug.
> 
> Plenty of e-mails have already been exchanged about versions one to four of this
> patch but so far nobody has even tried to contradict the above.

Sure, but we aren't mind-readers.  We're all very open to the idea that
you have noticed something we haven't.  But until your very helpful
mail I'm replying to, you hadn't been specific about the race that
concerned you.  Thanks for sharing.

I'll defer to Jens and/or Ming on whether the race you've raised is of
concern.  As I said above, I'm inclined to think it doesn't matter who
wins the race given the queue will be run again.  And when it does it
may get STS_RESOURCE again, and in that case it may then resort to
blk_mq_delay_run_hw_queue() in blk_mq_dispatch_rq_list().

Mike
