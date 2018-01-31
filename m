From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [dm-devel] [PATCH v5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Wed, 31 Jan 2018 10:14:51 +0800
Message-ID: <20180131021450.GD2618@ming.t460p>
References: <20180130142459.52668-1-snitzer@redhat.com>
 <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751653AbeAaCPV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jan 2018 21:15:21 -0500
Content-Disposition: inline
In-Reply-To: <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Tue, Jan 30, 2018 at 09:52:31AM -0800, Bart Van Assche wrote:
> On 01/30/18 06:24, Mike Snitzer wrote:
> > +		 *
> > +		 * If driver returns BLK_STS_RESOURCE and SCHED_RESTART
> > +		 * bit is set, run queue after a delay to avoid IO stalls
> > +		 * that could otherwise occur if the queue is idle.
> >   		 */
> > -		if (!blk_mq_sched_needs_restart(hctx) ||
> > +		needs_restart = blk_mq_sched_needs_restart(hctx);
> > +		if (!needs_restart ||
> >   		    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
> >   			blk_mq_run_hw_queue(hctx, true);
> > +		else if (needs_restart && (ret == BLK_STS_RESOURCE))
> > +			blk_mq_delay_run_hw_queue(hctx, BLK_MQ_QUEUE_DELAY);
> >   	}
> 
> If a request completes concurrently with execution of the above code then
> the request completion will trigger a call of blk_mq_sched_restart_hctx()
> and that call will clear the BLK_MQ_S_SCHED_RESTART bit. If that bit is
> cleared before the above code tests it then the above code will schedule an
> asynchronous call of __blk_mq_run_hw_queue(). If the .queue_rq() call

Right.

> triggered by the new queue run returns again BLK_STS_RESOURCE then the above
> code will be executed again. In other words, a loop occurs. That loop will

This patch doesn't change anything about that. When BLK_STS_RESOURCE is
returned, this request is added to hctx->dispatch, next time, before
dispatching this request, SCHED_RESTART is set and the loop is cut.

> repeat as long as the described race occurs. The current (kernel v4.15)
> block layer behavior is simpler: only block drivers call
> blk_mq_delay_run_hw_queue() and the block layer core never calls that
> function. Hence that loop cannot occur with the v4.15 block layer core and

That way isn't safe, I have explained to you in the following link:

	https://marc.info/?l=dm-devel&m=151727454815018&w=2

> block drivers. A motivation of why that loop is preferred compared to the
> current behavior (no loop) is missing. Does this mean that that loop is a
> needless complication of the block layer core?

No such loop as I explained above.

> 
> Sorry but I still prefer the v4.15 block layer approach because this patch
> has in my view the following disadvantages:
> - It involves a blk-mq API change. API changes are always risky and need
>   some time to stabilize.
> - The delay after which to rerun the queue is moved from block layer
>   drivers into the block layer core. I think that's wrong because only
>   the block driver authors can make a good choice for this constant.
> - This patch makes block drivers harder to understand. Anyone who sees
>   return BLK_STS_RESOURCE / return BLK_STS_DEV_RESOURCE for the first
>   time will have to look up the meaning of these constants. An explicit
>   blk_mq_delay_run_hw_queue() call is easier to understand.
> - This patch makes the blk-mq core harder to understand because of the
>   loop mentioned above.
> - This patch does not fix any bugs nor makes block drivers easier to
>   read or to implement. So why is this patch considered useful?

It does avoid the race I mentioned in the following link:

	https://marc.info/?l=dm-devel&m=151727454815018&w=2

More importantly, every driver need this change, if you have better idea
to fix them all, please post a patch, then we can compare both.

Thanks,
Ming
