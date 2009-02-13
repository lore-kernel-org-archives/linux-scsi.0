From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Deadlock during multipath failover
Date: Fri, 13 Feb 2009 11:50:43 +0100
Message-ID: <20090213105043.GA9888@schmichrtp.de.ibm.com>
References: <20090212094022.GA4973@schmichrtp.de.ibm.com> <4994234D.1000404@suse.de> <20090212204450.GA3556@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:56705 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZBMKwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Feb 2009 05:52:08 -0500
Content-Disposition: inline
In-Reply-To: <20090212204450.GA3556@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Feb 12, 2009 at 12:44:50PM -0800, Mike Anderson wrote:
> Hannes Reinecke <hare@suse.de> wrote:
> > Hi Christof,
> >
> > Christof Schmitt wrote:
> >> During failover tests on a current distribution kernel, we found this
> >> problem. From reading the code, the upstream kernel has the same
> >> problem:
> >>
> >> During multipath failover tests with SCSI on System z, the kernel
> >> deadlocks in this situation:
> >>
> >>>  STACK:
> >>>  0 blk_add_timer+206 [0x2981ea]
> >>>  1 blk_rq_timed_out+132 [0x2982a8]
> >>>  2 blk_abort_request+114 [0x29833e]
> >>>  3 blk_abort_queue+92 [0x2983a8]
> >>>  4 deactivate_path+74 [0x3e00009625a]
> >>>  5 run_workqueue+236 [0x149e04]
> >>>  6 worker_thread+294 [0x149fce]
> >>>  7 kthread+110 [0x14f436]
> >>>  8 kernel_thread_starter+6 [0x10941a]
> >>
> >> blk_abort_queue takes the queue_lock with spinlock_irqsave and walks
> >> the timer_list with list_for_each_entry_safe. Since a path to a SCSI
> >> device just failed, the rport state is FC_PORTSTATE_BLOCKED. This
> >> rport state triggers blk_add_timer that calls list_add_tail to move
> >> the request to the end of timer_list. Thus, the
> >> list_for_each_entry_safe never reaches the end of the timer_list, it
> >> continously moves the requests to the end of the list.
> >>
> > Hmm. That would be fixes by using list_splice() here:
> >
> > diff --git a/block/blk-timeout.c b/block/blk-timeout.c
> > index a095353..67bcc3f 100644
> > --- a/block/blk-timeout.c
> > +++ b/block/blk-timeout.c
> > @@ -209,12 +209,15 @@ void blk_abort_queue(struct request_queue *q)
> > {
> >        unsigned long flags;
> >        struct request *rq, *tmp;
> > +       LIST_HEAD(list);
> >
> >        spin_lock_irqsave(q->queue_lock, flags);
> >
> >        elv_abort_queue(q);
> >
> > -       list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list)
> > +       list_splice_init(&q->timeout_list, &list);
> > +
> > +       list_for_each_entry_safe(rq, tmp, &list, timeout_list)
> >                blk_abort_request(rq);
> >
> >        spin_unlock_irqrestore(q->queue_lock, flags);
> >
> >> The rport state FC_PORTSTATE_BLOCKED would end, when the function
> >> fc_timeout_deleted_rport would run to remove the rport. But this
> >> function was schedules from queue_delayed_work. The timer already
> >> expired, but the timer function does not run, because the timer
> >> interrupt is disabled from the spinlock_irqsave call.
> >>
> > .. but this shouldn't happen anymore when using splice, as
> > the timer will be called _after_ the irqrestore above.
> 
> If this patch does not address the deadlock another option to look into
> would be to run some testing without blk_abort_request (just using
> elv_abort_queue) and not try to abort in flight IOs at this time. 
> 
> We observed reduced IO delays during storage failover testing (target
> responsive but timing out IOs) with this code, but I do not have good
> breakdown data on the number of IOs handled by elv_abort_queue vs
> blk_abort_request vs IO delay (It is also config dependent).

The patch fixes the observed deadlock. While the rport is BLOCKED,
blk_abort_request only resets the timer for each request, so i would
guess there is no big difference in calling blk_abort_request or not,
at least in this scenario.

Christof Schmitt
