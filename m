From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Problems with the block-layer timeouts
Date: Thu, 6 Nov 2008 08:23:54 +0100
Message-ID: <20081106072352.GR21867@kernel.dk>
References: <Pine.LNX.4.44L0.0811011214470.21703-100000@netrider.rowland.org> <20081103085247.GO31673@kernel.dk> <20081106090117U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:47175 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbYKFHZU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2008 02:25:20 -0500
Content-Disposition: inline
In-Reply-To: <20081106090117U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 06 2008, FUJITA Tomonori wrote:
> On Mon, 3 Nov 2008 09:52:48 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > In blk_del_timer(), there's no reason to test q->rq_timed_out_fn.  If 
> > > the method pointer is NULL then req->deadline would be 0 anyway.  In 
> > > addition, req->deadline should be set to 0 and the end of the routine, 
> > > just in case req gets requeued.
> > > 
> > > In blk_add_timer(), the line
> > > 
> > > 	expiry = round_jiffies(req->deadline);
> > > 
> > > is not optimal.  round_jiffies() will sometimes round a value _down_ to
> > > the nearest second.  But blk_rq_timed_out_timer() tests whether
> > > req->deadline is in the past -- and if the deadline was rounded down
> > > then this won't be true the first time through.  You wind up getting an
> > > unnecessary timer interrupt.  Instead there should be a
> > > round_jiffies_up() utility routine, and it should be used in both
> > > blk_add_timer() and blk_rq_timed_out_timer().
> > 
> > Very good point, we do indeed want a round_jiffies_up() for this!
> 
> Just out of curiosity, why do we need to use round_jiffies here? We
> didn't do that for SCSI, right?

We don't have to, but given that we don't care about exact timeouts, we
may as well. It's not a new thing, we've done that since pretty much the
beginning of the generic timeout development.

-- 
Jens Axboe

