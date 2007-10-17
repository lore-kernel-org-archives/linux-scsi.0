From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 11:27:13 +0200
Message-ID: <20071017092713.GL5043@kernel.dk>
References: <20071017084528.GI5043@kernel.dk> <20071017.021305.74746838.davem@davemloft.net> <20071017091629.GK5043@kernel.dk> <20071017182401X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:8409 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbXJQJ1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 05:27:40 -0400
Content-Disposition: inline
In-Reply-To: <20071017182401X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> On Wed, 17 Oct 2007 11:16:29 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Oct 17 2007, David Miller wrote:
> > > From: Jens Axboe <jens.axboe@oracle.com>
> > > Date: Wed, 17 Oct 2007 10:45:28 +0200
> > > 
> > > > Righto, it's invalid to call sg_next() on the last entry!
> > > 
> > > Unfortunately, that's what the sparc64 code wanted to do, this
> > > transformation in the sparc64 sg chaining patch is not equilavent:
> > > 
> > > -	struct scatterlist *sg_end = sg + nelems;
> > > +	struct scatterlist *sg_end = sg_last(sg, nelems);
> > >  ...
> > > -			while (sg < sg_end &&
> > > +			while (sg != sg_end &&
> > 
> > Auch indeed. That'd probably be better as a
> > 
> >         do {
> >                 ...
> >         } while (sg != sg_end);
> > 
> > > No, that's not what the code was doing.  The while loop
> > > has to process the last entry in the list,
> > > 
> > > We really needed "sg_end" to be "one past the last element",
> > > rather than "the last element".
> > > 
> > > Since you say that sg_next() on the last entry is illegal,
> > > and that's what this code would have done to try and reach
> > > loop termination (it doesn't actually derefrence that
> > > "end plus one" scatterlist entry) I'll try to code this up
> > > some other way.
> > > 
> > > Besides, sg_last() is so absurdly expensive, it has to walk the entire
> > > chain in the chaining case.  So better to implement this without it.
> > 
> > It is, sg_last() should really not be used a lot since it'll leaf
> > through the entire sg list. People should either keep count of the
> > number of entries so that they know when they are dealing with the last
> > valid entry. Or use the for_each_sg() loop helper, if possible.
> > 
> > Drivers are usually very simple, the iommu code does more sg tricks and
> > thus is more complex to audit.
> 
> Can we just remove sg_last?

I think that would be best, we don't want to encourage use of it, it's
not really clear to people how expensive it is unless they go and look
at it. The absolute worst case would be someone doing a

        for_each_sg(sgl, sg, nents) {
                ...
                if (sg == sg_last(sgl))
                        ...
        }

which would be absolutely awful.

But lets let things settle for a few days, then kill sg_last().

-- 
Jens Axboe

