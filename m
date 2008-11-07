From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Problems with the block-layer timeouts
Date: Fri, 7 Nov 2008 12:24:50 +0100
Message-ID: <20081107112449.GN21867@kernel.dk>
References: <20081103085247.GO31673@kernel.dk> <20081106090117U.fujita.tomonori@lab.ntt.co.jp> <20081106072352.GR21867@kernel.dk> <20081107130552K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:56488 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYKGL0T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2008 06:26:19 -0500
Content-Disposition: inline
In-Reply-To: <20081107130552K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Nov 07 2008, FUJITA Tomonori wrote:
> On Thu, 6 Nov 2008 08:23:54 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Nov 06 2008, FUJITA Tomonori wrote:
> > > On Mon, 3 Nov 2008 09:52:48 +0100
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > > In blk_del_timer(), there's no reason to test q->rq_timed_out_fn.  If 
> > > > > the method pointer is NULL then req->deadline would be 0 anyway.  In 
> > > > > addition, req->deadline should be set to 0 and the end of the routine, 
> > > > > just in case req gets requeued.
> > > > > 
> > > > > In blk_add_timer(), the line
> > > > > 
> > > > > 	expiry = round_jiffies(req->deadline);
> > > > > 
> > > > > is not optimal.  round_jiffies() will sometimes round a value _down_ to
> > > > > the nearest second.  But blk_rq_timed_out_timer() tests whether
> > > > > req->deadline is in the past -- and if the deadline was rounded down
> > > > > then this won't be true the first time through.  You wind up getting an
> > > > > unnecessary timer interrupt.  Instead there should be a
> > > > > round_jiffies_up() utility routine, and it should be used in both
> > > > > blk_add_timer() and blk_rq_timed_out_timer().
> > > > 
> > > > Very good point, we do indeed want a round_jiffies_up() for this!
> > > 
> > > Just out of curiosity, why do we need to use round_jiffies here? We
> > > didn't do that for SCSI, right?
> > 
> > We don't have to, but given that we don't care about exact timeouts, we
> > may as well. It's not a new thing, we've done that since pretty much the
> > beginning of the generic timeout development.
> 
> I'm not sure that the users of the timeout feature can control exact
> timeouts because the block layer doesn't let the users directly play
> with the timer. elv_dequeue_request() is not the exact time that the
> users want to start the timer. Instead, the block layer hides the
> details behind the elevator (note that as I said before, I think that
> it's the right thing). So the round_jiffies in the block layer doesn't
> make sense to me. I prefer remove them instead of adding a bunch of
> round_jiffies_up_* (I bet that some of them will never be used).

I don't understand your concern, to be honest. We only need to round up
once, and that is when we add/mod the timer. And we do that simply to
play nice and group the timout with other timers, to save a bit of
power.

-- 
Jens Axboe

