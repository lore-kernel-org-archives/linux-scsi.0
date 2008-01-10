From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Thu, 10 Jan 2008 09:27:08 -0600
Message-ID: <1199978828.3141.27.camel@localhost.localdomain>
References: <200712191731.26512.rusty@rustcorp.com.au>
	 <200801081139.14748.rusty@rustcorp.com.au>
	 <1199916637.3493.72.camel@localhost.localdomain>
	 <200801101301.03846.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54311 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753712AbYAJP1O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 10:27:14 -0500
In-Reply-To: <200801101301.03846.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Tejun Heo <htejun@gmail.com>

On Thu, 2008-01-10 at 13:01 +1100, Rusty Russell wrote: 
> On Thursday 10 January 2008 09:10:37 James Bottomley wrote:
> > On Tue, 2008-01-08 at 11:39 +1100, Rusty Russell wrote:
> > > On Tuesday 08 January 2008 02:48:23 James Bottomley wrote:
> > > > We're always open to new APIs (or more powerful and expanded old ones).
> > > > The way we've been doing the sg_chain conversion is to slide API layers
> > > > into the drivers so sg_chain becomes a simple API flip when we turn it
> > > > on.  Unfortunately sg_ring doesn't quite fit nicely into this.
> > >
> > > Hi James,
> > >
> > >    Well, it didn't touch any drivers.  The only ones which needed
> > > altering were those which wanted to use large scatter-gather lists.  You
> > > think of the subtlety of sg-chain conversion as a feature; it's a bug :)
> >
> > No, I think of the side effect of hiding scatterlist manipulations
> > inside accessors as a feature because it insulates the drivers from the
> > details of the implementation.
> 
> I completely disagree.  Abstractions add complexity, and that costs.  They 
> steal information from their users, and as they build up like sediment they 
> make debugging and understanding harder.

Don't be silly ... abstractions are the core of how we program something
as complex as platform hardware.  By design, abstractions hide
information.  Good abstractions hide information you don't need to know.
Take the DMA API for instance: dma_map_sg() hides all of the platform
specifics of whether or not you have an IOMMU and how it is programmed.
That's a good abstraction ... drivers would be a complete mess if they
had to do it themselves.

> For example, an array is simple and well understood.   An abstraction would 
> just buy confusion and YA thing to learn.

> When a single array was no longer sufficient, I figured a linked-list of 
> arrays was the simplest replacement.  Easy to understand and accepted 
> practice (tho rings are a bit exotic).  Because the implementation is the 
> interface, authors can see what is legal.

Really, I don't buy this at all.  The first thing you complained about
when you came up with sg_ring was how painful it was to update the 30
odd SCSI drivers.  That was also my reaction when the scatterlist
chaining idea came along.  My second was supposing this isn't quite
right and we modify the way chaining is done ... do I have to update all
the drivers all over again?  Hence one of the input requirements to the
update was a consumer abstraction to insulate drivers from the
implementation.

Thinking about information that the drivers don't need to know, the
obvious thing is how the actual scatterlist is implemented, whether its
a list based ring, a pointer/mark based chain or an as yet to be
invented annulus.  All I think most consumers need is:

     1. A way to get the first scatterlist element
     2. A way to get the next scatterlist element
     3. An iterator over the entire scatterlist
     4. A way to tell if they've reached the last scatterlist element.

Actually 1,2,4 satisfy 3 but it's such a common operation in most
drivers that it was a good simplification.  Other things are sizing and
element count.

> More concretely, you're already regarding your abstractions as too expensive, 
> which is why sg_chain() doesn't handle chained sgs.

sg_chain isn't part of the consumer interface it's part of the
producer/manipulator interface.  I care a lot less about getting that
one right first time because it only occurs in one place in the SCSI
mid-layer and is easy to update and fix.

My principal concern at the moment is the consumer interface ... if
there's a fault in that we need to know now.

> Result: you've got a complex implementation and a complex interface with a 
> complex abstraction.
> 
> > > sg_chains suck for manipulation, and AFAICT that's inherent.  Here, take
> > > a look at the sg_ring conversion of scsi_alloc_sgtable and
> > > scsi_free_sgtable and you can see why I'm unhappy with the sg_chain code:
> > [...]
> >
> > > Hope that clarifies,
> >
> > Actually, not really.  If I want to continue the competition, I can just
> > point out that your sg_ring code is bigger than those corresponding
> > segments are after the sg_table conversion of scsi_lib.c ...
> >
> > However, this is pointless.
> 
> No, it's exactly the point.  These details *matter*.  The implementation 
> *matters*.  sg_table moves this code out of scsi_lib (good!), but still 
> demonstrates how much of a PITA they are to manipulate.
> 
> As for being able to make arbitrary changes in future without hitting drivers: 
> this is the Kernel ABI pipe dream writ small.

No, the kernel ABI is about preserving binary semantics for proprietary
drivers.  We're talking about an API here which is a totally different
thing.  I don't believe I said anywhere that it should be a fixed API
for all time ... that would also be silly.  However, that doesn't mean
you don't take the best care you can to get an API as right as you can.
If it's wrong, it will be altered, but it is much nicer to get it right
first time so it doesn't have to be.

James

> OK, I give in with -ETIMEDOUT.  I'll go away now and do something 
> productive :)
> 
> Cheers,
> Rusty.

