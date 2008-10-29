From: malahal@us.ibm.com
Subject: Re: [PATCH] block: optimizations in blk_rq_timed_out_timer()
Date: Tue, 28 Oct 2008 23:06:25 -0700
Message-ID: <20081029060625.GA5080@us.ibm.com>
References: <20081028182243.GA6716@us.ibm.com> <20081029130656G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59578 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYJ2GG1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 02:06:27 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e8.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9T630Pu020443
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 02:03:00 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9T66Qsg134512
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 02:06:26 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9T66QHb005474
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 02:06:26 -0400
Content-Disposition: inline
In-Reply-To: <20081029130656G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

FUJITA Tomonori [fujita.tomonori@lab.ntt.co.jp] wrote:
> On Tue, 28 Oct 2008 11:22:43 -0700
> malahal@us.ibm.com wrote:
> 
> > Now the rq->deadline can't be zero if the request is in the
> > timeout_list, so there is no need to have next_set. There is no need to
> > access a request's deadline field if blk_rq_timed_out is called on it.
> > 
> > Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> > 
> > diff -r a6ae42397ede block/blk-timeout.c
> > --- a/block/blk-timeout.c	Thu Oct 23 11:48:45 2008 -0700
> > +++ b/block/blk-timeout.c	Fri Oct 24 17:08:24 2008 -0700
> > @@ -118,7 +118,7 @@
> >  void blk_rq_timed_out_timer(unsigned long data)
> >  {
> >  	struct request_queue *q = (struct request_queue *) data;
> > -	unsigned long flags, uninitialized_var(next), next_set = 0;
> > +	unsigned long flags, next = 0;
> >  	struct request *rq, *tmp;
> >  
> >  	spin_lock_irqsave(q->queue_lock, flags);
> > @@ -133,15 +133,13 @@
> >  			if (blk_mark_rq_complete(rq))
> >  				continue;
> >  			blk_rq_timed_out(rq);
> > +		} else {
> > +			if (!next || time_after(next, rq->deadline))
> > +				next = rq->deadline;
> 
> Hmm, blk_rq_timed_out(rq) could put the rq back to q->timeout_list. We
> need to take care of the rq->deadline like this?

If it is put back on the list, it would be placed at the end of the list
so we will get to work on it again in the list traversal. There is no
need to access it now.

> 
> >  			if (blk_mark_rq_complete(rq))
> >  				continue;
> >  			blk_rq_timed_out(rq);
> > +		}
> >
> > +		if (!next || time_after(next, rq->deadline))
> > +			next = rq->deadline;
> 
> But if blk_rq_timed_out calls __blk_complete_request, we don't want to
> touch the rq here, I guess.

Yes, we should not access it although I don't think the request can be
freed while the existing code is accessing the deadline field. What 
likely can happen is that we may call mod_timer with jiffies that is
older than current which would call the timer immediately...
