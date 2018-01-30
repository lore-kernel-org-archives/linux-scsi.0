From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 14:33:23 -0500
Message-ID: <20180130193323.GA15943@redhat.com>
References: <20180130142459.52668-1-snitzer@redhat.com>
 <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753176AbeA3Td1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jan 2018 14:33:27 -0500
Content-Disposition: inline
In-Reply-To: <43ac2314-c98d-bb76-0dfb-171d15cc5fd8@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Tue, Jan 30 2018 at 12:52pm -0500,
Bart Van Assche <bart.vanassche@wdc.com> wrote:

> On 01/30/18 06:24, Mike Snitzer wrote:
> >+		 *
> >+		 * If driver returns BLK_STS_RESOURCE and SCHED_RESTART
> >+		 * bit is set, run queue after a delay to avoid IO stalls
> >+		 * that could otherwise occur if the queue is idle.
> >  		 */
> >-		if (!blk_mq_sched_needs_restart(hctx) ||
> >+		needs_restart = blk_mq_sched_needs_restart(hctx);
> >+		if (!needs_restart ||
> >  		    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
> >  			blk_mq_run_hw_queue(hctx, true);
> >+		else if (needs_restart && (ret == BLK_STS_RESOURCE))
> >+			blk_mq_delay_run_hw_queue(hctx, BLK_MQ_QUEUE_DELAY);
> >  	}
> 
> If a request completes concurrently with execution of the above code
> then the request completion will trigger a call of
> blk_mq_sched_restart_hctx() and that call will clear the
> BLK_MQ_S_SCHED_RESTART bit. If that bit is cleared before the above
> code tests it then the above code will schedule an asynchronous call
> of __blk_mq_run_hw_queue(). If the .queue_rq() call triggered by the
> new queue run returns again BLK_STS_RESOURCE then the above code
> will be executed again. In other words, a loop occurs. That loop
> will repeat as long as the described race occurs. The current
> (kernel v4.15) block layer behavior is simpler: only block drivers
> call blk_mq_delay_run_hw_queue() and the block layer core never
> calls that function. Hence that loop cannot occur with the v4.15
> block layer core and block drivers. A motivation of why that loop is
> preferred compared to the current behavior (no loop) is missing.
> Does this mean that that loop is a needless complication of the
> block layer core?

No it means the loop is an internal blk-mq concern.  And that drivers
needn't worry about kicking the queue.  And it affords blk-mq latitude
to change how it responds to BLK_STS_RESOURCE in the future (without
needing to change every driver).

But even v4.15 has a similar loop.  It just happens to extend into the
.queue_rq() where the driver is completely blind to SCHED_RESTART.  And
the driver may just repeatedly kick the queue after a delay (via
blk_mq_delay_run_hw_queue).

This cycle should be a very rare occurrence regardless of which approach
is taken (V5 vs 4.15).  The fact that you engineered your SRP initiator
and target code to pathologically trigger this worst case (via
target_can_queue) doesn't mean it is the fast path for a properly
configured and functioning storage network.

> Sorry but I still prefer the v4.15 block layer approach because this
> patch has in my view the following disadvantages:
> - It involves a blk-mq API change. API changes are always risky and need
>   some time to stabilize.

The number of blk-mq API changes that have occurred since blk-mq was
introduced is a very long list.  Seems contrived to make this the one
that is breaking the camel's back.

> - The delay after which to rerun the queue is moved from block layer
>   drivers into the block layer core. I think that's wrong because only
>   the block driver authors can make a good choice for this constant.

Unsubstantiated.  3ms (scsi-mq, nvmefc) vs 100ms (dm-mq mpath): which is
better?  Pretty sure if the underlying storage network is 1) performant
2) properly configured -- then a shorter delay is preferable.

> - This patch makes block drivers harder to understand. Anyone who sees
>   return BLK_STS_RESOURCE / return BLK_STS_DEV_RESOURCE for the first
>   time will have to look up the meaning of these constants. An explicit
>   blk_mq_delay_run_hw_queue() call is easier to understand.

No it doesn't make blk-mq harder to understand.  But even if it did it
actually acknowledges that there is existing blk-mq SCHED_RESTART
heuristic for how to deal with the need for blk-mq to back-off in the
face of BLK_STS_RESOURCE returns.  By just having each blk-mq driver
blindly kick the queue you're actively ignoring, and defeating, that
entire design element of blk-mq (SCHED_RESTART).

It is an instance where blk-mq can and does know better.  Acknowledging
that fact is moving blk-mq in a better direction.

> - This patch makes the blk-mq core harder to understand because of the
>   loop mentioned above.

You've said your peace.  But you've taken on this campaign to undermine
this line of development with such passion that we're now in a place
where Jens is shell-shocked by all the repeat campaigning and noise.

Bart you keep saying the same things over and over.  Yet you cannot show
the patch to actively be a problem with testing-based detail.

Seems you'd rather refuse to even test it than open yourself up to the
possibility that this concern of yours has been making a mountain out of
a mole hill.

> - This patch does not fix any bugs nor makes block drivers easier to
>   read or to implement. So why is this patch considered useful?

It enables blk-mq core to own the problem that individual drivers should
have no business needing to worry about.  Period.
