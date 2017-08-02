From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 04/14] blk-mq-sched: improve dispatching from sw queue
Date: Wed, 2 Aug 2017 11:31:36 +0800
Message-ID: <20170802033135.GB7267@ming.t460p>
References: <20170731165111.11536-1-ming.lei@redhat.com>
 <20170731165111.11536-6-ming.lei@redhat.com>
 <1501544074.2466.29.camel@wdc.com>
 <20170801101718.GB31452@ming.t460p>
 <20170801105013.GD31452@ming.t460p>
 <1501600301.2475.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751659AbdHBDbx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Aug 2017 23:31:53 -0400
Content-Disposition: inline
In-Reply-To: <1501600301.2475.1.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Laurence Oberman <loberman@redhat.com>

On Tue, Aug 01, 2017 at 03:11:42PM +0000, Bart Van Assche wrote:
> On Tue, 2017-08-01 at 18:50 +0800, Ming Lei wrote:
> > On Tue, Aug 01, 2017 at 06:17:18PM +0800, Ming Lei wrote:
> > > How can we get the accurate 'number of requests in progress' efficiently?
> 
> Hello Ming,
> 
> How about counting the number of bits that have been set in the tag set?
> I am aware that these bits can be set and/or cleared concurrently with the
> dispatch code but that count is probably a good starting point.

It has to be atomic_t, which is too too heavy for us, please see the report:

	http://marc.info/?t=149868448400003&r=1&w=2

Both Jens and I want to kill hd_struct.in_flight, but looks still no
good way. 

> 
> > > From my test data of mq-deadline on lpfc, the performance is good,
> > > please see it in cover letter.
> > 
> > Forget to mention, ctx->list is one per-cpu list and the lock is percpu
> > lock, so changing to this way shouldn't be a performance issue.
> 
> Sorry but I don't consider this reply as sufficient. The latency of IB HCA's
> is significantly lower than that of any FC hardware I ran performance
> measurements on myself. It's not because this patch series improves performance
> for lpfc that that guarantees that there won't be a performance regression for
> ib_srp, ib_iser or any other low-latency initiator driver for which q->depth
> != 0.

If IB HCA has lower latency than other FC, there should be less chances
to trigger BUSY. Otherwise IB should have the same sequential I/O
performance issue, I guess.

ctx list is per-cpu list, in theory there shouldn't be issues with this
change, and the only change for IB is the following:

V4.13-rc3:
	blk_mq_flush_busy_ctxs(hctx, &rq_list);
    blk_mq_dispatch_rq_list(q, &rq_list);

v4.13-rc3 patched:
        do {
                struct request *rq;

				/* pick up one request from one ctx list */
                rq = blk_mq_dispatch_rq_from_ctxs(hctx); 
                if (!rq)
                        break;
                list_add(&rq->queuelist, &rq_list);
        } while (blk_mq_dispatch_rq_list(q, &rq_list));

I doubt that the change can be observable in actual test.

Never mind, we will provide test data on IB HCA with V2, and Laurence
will help me run the test on IB.

> 
> Additionally, patch 03/14 most likely introduces a fairness problem. Shouldn't
> blk_mq_dispatch_rq_from_ctxs() dequeue requests from the per-CPU queues in a
> round-robin fashion instead of always starting at the first per-CPU queue in
> hctx->ctx_map?

That is a good question, looks round-robin should be more fair, will
change to it in V2 ant the implementation should be simple.

-- 
Ming
