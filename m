From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] block: fix barrier error transmission
Date: Fri, 4 Apr 2008 13:46:11 +0200
Message-ID: <20080404114611.GH29686@kernel.dk>
References: <1207159348.3082.45.camel@localhost.localdomain> <20080402190827.GJ12774@kernel.dk> <1207177912.3082.57.camel@localhost.localdomain> <20080403080626.GO12774@kernel.dk> <1207231339.3048.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:22736 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454AbYDDLtC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2008 07:49:02 -0400
Content-Disposition: inline
In-Reply-To: <1207231339.3048.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, mtosatti@redhat.com

On Thu, Apr 03 2008, James Bottomley wrote:
> On Thu, 2008-04-03 at 10:06 +0200, Jens Axboe wrote:
> > On Wed, Apr 02 2008, James Bottomley wrote:
> > > On Wed, 2008-04-02 at 21:08 +0200, Jens Axboe wrote:
> > > > > diff --git a/block/blk-barrier.c b/block/blk-barrier.c
> > > > > index 55c5f1f..3a3947c 100644
> > > > > --- a/block/blk-barrier.c
> > > > > +++ b/block/blk-barrier.c
> > > > > @@ -114,18 +114,24 @@ void blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
> > > > >  
> > > > >  static void pre_flush_end_io(struct request *rq, int error)
> > > > >  {
> > > > > +	error = rq->errors ? -EIO : error;
> > > > > +
> > > > >  	elv_completed_request(rq->q, rq);
> > > > >  	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_PREFLUSH, error);
> > > > >  }
> > > > 
> > > > It's a bit of a hack, SCSI really should pass the error value back
> > > > instead of fiddling around with possibly perhaps finding it in ->errors.
> > > > And please don't use these ?: constructs, in this case it doesn't even
> > > > make a lot of sense and a
> > > > 
> > > >         if (rq->errors)
> > > >                 error = -EIO;
> > > > 
> > > > would have been much cleaner ;-)
> > > > 
> > > > So my question is why does the model not allow you to return the error
> > > > properly?
> > > 
> > > I thought it was the sg_io that would be the problem, but apparently on
> > > further research, it simply discards the error as does scsi_execute_req.
> > > 
> > > I suppose that's a strong enough reason to try returning an error ...
> > > I'm just a bit leery this close to a release.
> > > 
> > > I think this will work ... it just really needs quite a bit of
> > > testing ...
> > 
> > This looks much better, but I'm with you on the danger of applying
> > something like this so close to a release...
> 
> Yes.
> 
> > Now, this isn't a regression, but it also impacts barrier reliability
> > and as such it's a big nasty to leave this open for another release.
> 
> Yes, I agree ... let's put it in after 2.6.25 (so into scsi-misc) but if
> no problems turn up by -rc2 say, I'll send it as a backport to stable
> 2.6.25.X.  That way we don't have to wait out the entire release cycle
> for users to see the benefit.

Sounds like a good plan.

-- 
Jens Axboe

