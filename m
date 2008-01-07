From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Mon, 07 Jan 2008 09:48:23 -0600
Message-ID: <1199720904.3126.24.camel@localhost.localdomain>
References: <200712191731.26512.rusty@rustcorp.com.au>
	 <1199547072.3399.15.camel@localhost.localdomain>
	 <200801071538.58875.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43708 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbYAGPsj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 10:48:39 -0500
In-Reply-To: <200801071538.58875.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Mon, 2008-01-07 at 15:38 +1100, Rusty Russell wrote:
> On Sunday 06 January 2008 02:31:12 James Bottomley wrote:
> > On Wed, 2007-12-19 at 17:31 +1100, Rusty Russell wrote:
> > > This patch series is the start of my attempt to simplify and make
> > > explicit the chained scatterlist logic.
> > >
> > > It's not complete: my SATA box boots and seems happy, but all the other
> > > users of SCSI need to be updated and checked.  But I've gotten far enough
> > > to believe it's worth persuing.
> >
> > Sorry for the delay in looking at this, I was busy with Holidays and
> > things.
> 
> Thankyou for your consideration.
> 
> > When I compare sg_ring with the current sg_chain (and later sg_table)
> > implementations, I'm actually struck by how similar they are.
> 
> I agree, they're solving the same problem.  It is possible that the pain of 
> change is no longer worthwhile, but I hate to see us give up on this.  We're 
> adding complexity without making it harder to misuse.

We're always open to new APIs (or more powerful and expanded old ones).
The way we've been doing the sg_chain conversion is to slide API layers
into the drivers so sg_chain becomes a simple API flip when we turn it
on.  Unfortunately sg_ring doesn't quite fit nicely into this.

> > The other thing I note is that the problem you're claiming to solve with
> > sg_ring (the ability to add extra scatterlists to the front or the back
> > of an existing one) is already solved with sg_chain, so the only real
> > advantage of sg_ring was that it contains explicit counts, which
> > sg_table (in -mm) also introduces.
> 
> I just converted virtio using latest Linus for fair comparison

Erm, but that's not really a fair comparison; you need the sg_table code
in

git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git 

branch sg as well.

> , and it's still 
> pretty ugly.  sg_ring needs more work to de-scsi it.  sg_table is almost 
> sg_ring except it retains all the chaining warts.
> 
> But we hit the same problems:
> 
> 1) sg_chain loses information.  The clever chain packaging makes reading easy, 
> but manipulation is severely limited.  You can append to your own chains by 
> padding, but not someone elses.  This works for SCSI, but what about the rest 
> of us?  And don't even think of joining mapped chains: it will almost work.

OK, but realistically some of your criticisms are way outside of the
design intent.  Scatterlists (and now sg_chains) are the way the block
subsystem hands pages to its underlying block devices.  We do this
through two APIs:  blk_rq_map_sg() to take a request and place all the
pages into a scatterlist respecting the merging parameters and
dma_map_sg() which takes the scatterlist and produces an arch specific
DMA mapped scatterlist reusing the old list.  The requirement is that
dma_unmap_sg return the chain to its former state (so block device may
map, and unmap between congestion waits to avoid running systems out of
scarce IOMMU mappings), but there's not even a parallel
blk_rq_unmap_sg() beacuse the scatterlist is assumed disposable by the
block driver after the request completes.

By "someone elses" I'm assuming you mean a chain in a stacked block
driver?  You are actually allowed to transform these ... depending on
who does the dma mapping, of course, if the lower driver (yours) does
DMA mapping, you can do anything you want.  If the upper driver does,
then you have to preserve idempotence.

There have never until now been any requirements to join already
dma_map_sg() converted scatterlists ... that would wreak havoc with the
way we reuse the list plus damage the idempotence of map/unmap.  What is
the use case you have for this?

> 2) sg_chain's end marker is only for reading non-dma elements, not for mapped 
> chains, nor for writing into chains.  Plus it's a duplicate of the num arg, 
> which is still passed around for efficiency.  (virtio had to implement 
> count_sg() because I didn't want those two redundant num args).
> 
> 3) By overloading struct scatterlist, it's invisible what code has been 
> converted to chains, and which hasn't.  Too clever by half!

No it's not ... that's the whole point.  Code not yet converted to use
the API accessors is by definition unable to use chaining.  Code
converted to use the accessors by design doesn't care (and so is
"converted to chains").

> Look at sg_chain(): it claims to join two scatterlists, but it doesn't.  It 
> assumes that prv is an array, not a chain.  Because you've overloaded an 
> existing type, this happens everywhere.  Try passing skb_to_sgvec a chained 
> skb.
> 
> sg_ring would not have required any change to existing drivers, just those 
> that want to use long sg lists.  And then it's damn obvious which are which.

Which, by definition, would have been pretty much all of them.

Another driving factor is that the mempool allocation of scatterlists is
suboptimal in terms of their bucket size, so we were looking to tune
that once the chaining code was in.  The guess is that we'd probalby end
up with a uniform size for scatterlist chunks, but if all drivers aren't
converted we can't do this type of tuning.

> 4) sg_chain missed a chance to combine all the relevent information (max, num, 
> num_dma and the sg array). sg_table comes close, but you still can't join 
> them (no max information, and even if there were, what if it's full?).  
> Unlike sg_ring, it's unlikely to reduce bugs.

sg_table is sg_chain ... they're incremental extensions of the same body
of work.

> 5) (A little moot now) sg_ring didn't require arch changes.
> 
> > The other differences are that sg_ring only allows adding at the front
> > or back of an existing sg_ring, it doesn't allow splicing at any point
> > like sg_chain does, so I'd say it's less functional (not that I actually
> > want anyone ever to do this, of course ...)
> 
> Well it's just as possible, but you might have to copy more elements (with sg 
> chaining you need only copy 1 sg element to make room for the chain elem).  
> Agreed that it's a little out there...
> 
> > The final point is that sg_ring requires a two level traversal:  ring
> > list then scatterlist, whereas sg_chain only requires a single level
> > traversal.  I grant that we can abstract out the traversal into
> > something that would make users think they're only doing a single level,
> > but I don't see what the extra level really buys us.
> 
> We hide the real complexity from users and it makes it less safe for 
> non-trivial cases.
> 
> Hence the introduction of YA datastructure: sg_table.  This is getting close: 
> just hang the array off it and you'll have sg_ring and no requirement for 
> dynamic alloc all the time.  And once you have a header, no need for chaining 
> tricks...
> 
> > The only thing missing from sg_chain perhaps is an accessor function
> > that does the splicing, which I can easily construct if you want to try
> > it out in virtio.
> 
> I don't need that (I prepend and append), but it'd be nice if sg_next took a 
> const struct scatterlist *.

What all this is saying to me is that we have an undesigned, ad hoc
interface for scatterlist manipulation in passthrough drivers.  Perhaps
we should start by defining that API and its associated requirements.
i.e. what is it that pass through drivers want to be able to do to
scatterlists?  The only such example of a driver like that I know is the
crypto API and now your virtio.  Once we have the actual requirements
and then the API, I think the natural data structures will probably drop
out.

James


