From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: optimizations in blk_rq_timed_out_timer()
Date: Wed, 29 Oct 2008 14:26:15 +0100
Message-ID: <20081029132614.GD31673@kernel.dk>
References: <20081028182243.GA6716@us.ibm.com> <20081029130656G.fujita.tomonori@lab.ntt.co.jp> <20081029060625.GA5080@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:43926 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbYJ2NhJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 09:37:09 -0400
Content-Disposition: inline
In-Reply-To: <20081029060625.GA5080@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On Tue, Oct 28 2008, malahal@us.ibm.com wrote:
> FUJITA Tomonori [fujita.tomonori@lab.ntt.co.jp] wrote:
> > On Tue, 28 Oct 2008 11:22:43 -0700
> > malahal@us.ibm.com wrote:
> > 
> > > Now the rq->deadline can't be zero if the request is in the
> > > timeout_list, so there is no need to have next_set. There is no need to
> > > access a request's deadline field if blk_rq_timed_out is called on it.
> > > 
> > > Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> > > 
> > > diff -r a6ae42397ede block/blk-timeout.c
> > > --- a/block/blk-timeout.c	Thu Oct 23 11:48:45 2008 -0700
> > > +++ b/block/blk-timeout.c	Fri Oct 24 17:08:24 2008 -0700
> > > @@ -118,7 +118,7 @@
> > >  void blk_rq_timed_out_timer(unsigned long data)
> > >  {
> > >  	struct request_queue *q = (struct request_queue *) data;
> > > -	unsigned long flags, uninitialized_var(next), next_set = 0;
> > > +	unsigned long flags, next = 0;
> > >  	struct request *rq, *tmp;
> > >  
> > >  	spin_lock_irqsave(q->queue_lock, flags);
> > > @@ -133,15 +133,13 @@
> > >  			if (blk_mark_rq_complete(rq))
> > >  				continue;
> > >  			blk_rq_timed_out(rq);
> > > +		} else {
> > > +			if (!next || time_after(next, rq->deadline))
> > > +				next = rq->deadline;
> > 
> > Hmm, blk_rq_timed_out(rq) could put the rq back to q->timeout_list. We
> > need to take care of the rq->deadline like this?
> 
> If it is put back on the list, it would be placed at the end of the list
> so we will get to work on it again in the list traversal. There is no
> need to access it now.
> 
> > 
> > >  			if (blk_mark_rq_complete(rq))
> > >  				continue;
> > >  			blk_rq_timed_out(rq);
> > > +		}
> > >
> > > +		if (!next || time_after(next, rq->deadline))
> > > +			next = rq->deadline;
> > 
> > But if blk_rq_timed_out calls __blk_complete_request, we don't want to
> > touch the rq here, I guess.
> 
> Yes, we should not access it although I don't think the request can be
> freed while the existing code is accessing the deadline field. What 
> likely can happen is that we may call mod_timer with jiffies that is
> older than current which would call the timer immediately...

That would not call the timer immediately, that will not call it until
jiffies reaches that value again. So you're looking at a minimum of 49
days :-)

-- 
Jens Axboe

