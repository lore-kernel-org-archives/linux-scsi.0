From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Wed, 09 Jan 2008 16:10:37 -0600
Message-ID: <1199916637.3493.72.camel@localhost.localdomain>
References: <200712191731.26512.rusty@rustcorp.com.au>
	 <200801071538.58875.rusty@rustcorp.com.au>
	 <1199720904.3126.24.camel@localhost.localdomain>
	 <200801081139.14748.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46368 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbYAIWKy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 17:10:54 -0500
In-Reply-To: <200801081139.14748.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Tejun Heo <htejun@gmail.com>


On Tue, 2008-01-08 at 11:39 +1100, Rusty Russell wrote:
> On Tuesday 08 January 2008 02:48:23 James Bottomley wrote:
> > We're always open to new APIs (or more powerful and expanded old ones).
> > The way we've been doing the sg_chain conversion is to slide API layers
> > into the drivers so sg_chain becomes a simple API flip when we turn it
> > on.  Unfortunately sg_ring doesn't quite fit nicely into this.
> 
> Hi James,
> 
>    Well, it didn't touch any drivers.  The only ones which needed altering 
> were those which wanted to use large scatter-gather lists.  You think of the 
> subtlety of sg-chain conversion as a feature; it's a bug :)

No, I think of the side effect of hiding scatterlist manipulations
inside accessors as a feature because it insulates the drivers from the
details of the implementation.

> > > > The other thing I note is that the problem you're claiming to solve
> > > > with sg_ring (the ability to add extra scatterlists to the front or the
> > > > back of an existing one) is already solved with sg_chain, so the only
> > > > real advantage of sg_ring was that it contains explicit counts, which
> > > > sg_table (in -mm) also introduces.
> > >
> > > I just converted virtio using latest Linus for fair comparison
> >
> > Erm, but that's not really a fair comparison; you need the sg_table code
> > in
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
> >
> > branch sg as well.
> 
> Actually, I think it's a wash.  Now callers need to set up an sg_table as 
> well.  It will save the count_sg() calls though.
> 
> > > , and it's still
> > > pretty ugly.  sg_ring needs more work to de-scsi it.  sg_table is almost
> > > sg_ring except it retains all the chaining warts.
> > >
> > > But we hit the same problems:
> > >
> > > 1) sg_chain loses information.  The clever chain packaging makes reading
> > > easy, but manipulation is severely limited.  You can append to your own
> > > chains by padding, but not someone elses.  This works for SCSI, but what
> > > about the rest of us?  And don't even think of joining mapped chains: it
> > > will almost work.
> >
> > OK, but realistically some of your criticisms are way outside of the
> > design intent.  Scatterlists (and now sg_chains) are the way the block
> > subsystem hands pages to its underlying block devices.
> 
> James, scatterlists are used for more than the block subsystem.  I know you're 
> designing for that, but we can do better.
> 
>     Because a single sg_ring is trivially convertable to and from a 
> scatterlist *, the compatibility story is nice.  You can implement a 
> subsystem (say, the block layer) with sg_ring, and still hand out struct 
> scatterlist arrays for backwards compat: old code won't ask for v. long 
> scatterlist arrays anyway.
> 
>     Now we have sg_chaining, we can actually convert complex sg_rings into sg 
> chains when someone asks, as my most recent patch does.  I think that's one 
> abstraction too many, but it provides a transition path.
> 
> > There have never until now been any requirements to join already
> > dma_map_sg() converted scatterlists ... that would wreak havoc with the
> > way we reuse the list plus damage the idempotence of map/unmap.  What is
> > the use case you have for this?
> 
> (This was, admittedly, a made-up example).
> 
> > > 2) sg_chain's end marker is only for reading non-dma elements, not for
> > > mapped chains, nor for writing into chains.  Plus it's a duplicate of the
> > > num arg, which is still passed around for efficiency.  (virtio had to
> > > implement count_sg() because I didn't want those two redundant num args).
> > >
> > > 3) By overloading struct scatterlist, it's invisible what code has been
> > > converted to chains, and which hasn't.  Too clever by half!
> >
> > No it's not ... that's the whole point.  Code not yet converted to use
> > the API accessors is by definition unable to use chaining.  Code
> > converted to use the accessors by design doesn't care (and so is
> > "converted to chains").
> 
> But you've overloaded the type: what's the difference between:
> 	/* Before conversion */
> 	int foo(struct scatterlist *, int);
> And:
> 	/* After conversion */
> 	int foo(struct scatterlist *, int);
> 
> You have to wade through the implementation to see the difference: does this 
> function take a "chained scatterlist" or an "array scatterlist"?
> 
> Then you add insult to injury by implementing sg_chain() *which doesn't handle 
> chained scatterlists!*.
> 
> > > sg_ring would not have required any change to existing drivers, just
> > > those that want to use long sg lists.  And then it's damn obvious which
> > > are which.
> >
> > Which, by definition, would have been pretty much all of them.
> 
> But it would have started with none of them, and it would have been done over 
> time.  Eventually we might have had a flag day to remove raw scatterlist 
> arrays.
> 
> > > 4) sg_chain missed a chance to combine all the relevent information (max,
> > > num, num_dma and the sg array). sg_table comes close, but you still can't
> > > join them (no max information, and even if there were, what if it's
> > > full?). Unlike sg_ring, it's unlikely to reduce bugs.
> >
> > sg_table is sg_chain ... they're incremental extensions of the same body
> > of work.
> 
> Yes.
> 
> > The only such example of a driver like that I know is the
> > crypto API and now your virtio.  Once we have the actual requirements
> > and then the API, I think the natural data structures will probably drop
> > out.
> 
> ATA wants to chain sgs (Tejun cc'd).  It hasn't been practical to chain up 
> until now, but I'd say it's going to be more widely used now it is.

Actually, I think we might be able to solve ATA's problem without ever
having it manipulate the sg lists, but that's really a different issue.

> Basically, sg_chain solves one problem: larger sg lists for scsi.  That's 
> fine, but I want to see better use of scatterlists everywhere in the kernel.
> 
> sg_chains suck for manipulation, and AFAICT that's inherent.  Here, take a 
> look at the sg_ring conversion of scsi_alloc_sgtable and scsi_free_sgtable 
> and you can see why I'm unhappy with the sg_chain code:
> 
[...]
> Hope that clarifies,

Actually, not really.  If I want to continue the competition, I can just
point out that your sg_ring code is bigger than those corresponding
segments are after the sg_table conversion of scsi_lib.c ...

However, this is pointless.  We seem to be talking past each other.
Your sg_ring is an implementation, like sg_table.  What I want to do is
actually insulate the device drivers (even the drivers that want to
manipulate sg lists) from the implementation.  The idea being that if
this is done correctly, we can alter the implementation from sg_table to
sg_ring to sg_annulus and not have to change any of the driver code.

Since your code introduces new ring handling primitives, it's running
counter to that grain.  What I'm primarily interested in is what's
broken about the new accessor API ... why doesn't it work to hide the
internals of sg_ring?  It seems to me, if I try to do the conversion,
all that's missing is this problematic two level traversal of primitives
that sg_ring requires.

However, a lot of the churn seems to be because you want to change the
fundamental element from a scatterlist entry to a sg_ring.  Worse still,
we now get exposure of locations of scatterlist elements.  Like this
conversion for instance:


> -       for (k = 0; k < scp->use_sg; ++k, sg = sg_next(sg)) {
> -               kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
> +       sg_ring_for_each(scp->sg, sg, k) {
> +               kaddr = (unsigned char *)kmap_atomic(sg_page(&sg->sg[k]),
> +                                                    KM_USER0);
>                 if (NULL == kaddr)
>                         return -1;
> -               kaddr_off = (unsigned char *)kaddr + sg->offset;
> -               len = sg->length;
> +               kaddr_off = (unsigned char *)kaddr + sg->sg[k].offset;
> +               len = sg->sg[k].length;

Here, you're re-exposing the internals of how we traverse the lists.
This is explicitly something the sg_next() and friends designedly get
rid of.  All drivers want to know is what the next scatterlist entry is,
not where it comes from.

>                 if ((req_len + len) > max_arr_len) {
>                         len = max_arr_len - req_len;
>                         fin = 1;

I suspect if you re-roll sg_ring to conform to the current accessors,
you'll find it pretty much fits, but probably looks a lot like sg_table.
But if it doesn't; if there's something in the accessors that's missing,
that's what I want to know about.

James


