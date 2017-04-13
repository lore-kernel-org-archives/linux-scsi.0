From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Thu, 13 Apr 2017 10:20:31 +0800
Message-ID: <20170413022030.GD8835@ming.t460p>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
 <20170407181654.27836-7-bart.vanassche@sandisk.com>
 <20170411160958.GA19222@redhat.com>
 <1491928005.2654.6.camel@sandisk.com>
 <20170411174739.GA19620@redhat.com>
 <1491933092.2654.10.camel@sandisk.com>
 <20170411180358.GA19660@redhat.com>
 <1491934715.2654.14.camel@sandisk.com>
 <20170412034229.GA8835@ming.t460p>
 <1492022286.2764.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1492022286.2764.15.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 12, 2017 at 06:38:07PM +0000, Bart Van Assche wrote:
> On Wed, 2017-04-12 at 11:42 +0800, Ming Lei wrote:
> > On Tue, Apr 11, 2017 at 06:18:36PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-04-11 at 14:03 -0400, Mike Snitzer wrote:
> > > > Rather than working so hard to use DM code against me, your argument
> > > > should be: "blk-mq drivers X, Y and Z rerun the hw queue; this is a well
> > > > established pattern"
> > > > 
> > > > I see drivers/nvme/host/fc.c:nvme_fc_start_fcp_op() does.  But that is
> > > > only one other driver out of ~20 BLK_MQ_RQ_QUEUE_BUSY returns
> > > > tree-wide.
> > > > 
> > > > Could be there are some others, but hardly a well-established pattern.
> > > 
> > > Hello Mike,
> > > 
> > > Several blk-mq drivers that can return BLK_MQ_RQ_QUEUE_BUSY from their
> > > .queue_rq() implementation stop the request queue (blk_mq_stop_hw_queue())
> > > before returning "busy" and restart the queue after the busy condition has
> > > been cleared (blk_mq_start_stopped_hw_queues()). Examples are virtio_blk and
> > > xen-blkfront. However, this approach is not appropriate for the dm-mq core
> > > nor for the scsi core since both drivers already use the "stopped" state for
> > > another purpose than tracking whether or not a hardware queue is busy. Hence
> > > the blk_mq_delay_run_hw_queue() and blk_mq_run_hw_queue() calls in these last
> > > two drivers to rerun a hardware queue after the busy state has been cleared.
> > 
> > But looks this patch just reruns the hw queue after 100ms, which isn't
> > that after the busy state has been cleared, right?
> 
> Hello Ming,
> 
> That patch can be considered as a first step that can be refined further, namely
> by modifying the dm-rq code further such that dm-rq queues are only rerun after
> the busy condition has been cleared. The patch at the start of this thread is
> easier to review and easier to test than any patch that would only rerun dm-rq
> queues after the busy condition has been cleared.

OK, got it, it should have been better to add comments about this change
since reruning the queue after 100ms is actually a workaround, instead
of final solution.

> 
> > Actually if BLK_MQ_RQ_QUEUE_BUSY is returned from .queue_rq(), blk-mq
> > will buffer this request into hctx->dispatch and run the hw queue again,
> > so looks blk_mq_delay_run_hw_queue() in this situation shouldn't have been
> > needed at my 1st impression.
> 
> If the blk-mq core would always rerun a hardware queue if a block driver
> returns BLK_MQ_RQ_QUEUE_BUSY then that would cause 100% of a single CPU core

It won't casue 100% CPU utilization since we restart queue in completion
path and at that time at least one tag is available, then progress can be
made.

> to be busy with polling a hardware queue until the "busy" condition has been
> cleared. One can see easily that that's not what the blk-mq core does. From
> blk_mq_sched_dispatch_requests():
> 
> 	if (!list_empty(&rq_list)) {
> 		blk_mq_sched_mark_restart_hctx(hctx);
> 		did_work = blk_mq_dispatch_rq_list(q, &rq_list);
> 	}
> 
> From the end of blk_mq_dispatch_rq_list():
> 
> 	if (!list_empty(list)) {
> 		[ ... ]
> 		if (!blk_mq_sched_needs_restart(hctx) &&
> 		    !test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state))
> 			blk_mq_run_hw_queue(hctx, true);
> 	}

That is exactly what I meant, blk-mq already provides this mechanism
to rerun the queue automatically in case of BLK_MQ_RQ_QUEUE_BUSY. If the
mechanism doesn't work well, we need to fix that, then why bother
drivers to workaround it?

> 
> In other words, the BLK_MQ_S_SCHED_RESTART flag is set before the dispatch list
> is examined and only if that flag gets cleared while blk_mq_dispatch_rq_list()
> is in progress by a concurrent blk_mq_sched_restart_hctx() call then the
> dispatch list will be rerun after a block driver returned BLK_MQ_RQ_QUEUE_BUSY.

Yes, the queue is rerun either in completion path when
BLK_MQ_S_SCHED_RESTART is set, or just .queue_rq() returning _BUSY
and the flag is cleared at the same time from completion path.

So in theroy we can make sure the queue will be run again if _BUSY
happened, then what is the root cause why we have to add
blk_mq_delay_run_hw_queue(hctx, 100) in dm's .queue_rq()?

Thanks,
Ming
