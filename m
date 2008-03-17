From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Mon, 17 Mar 2008 09:53:41 +0100
Message-ID: <20080317085341.GK27015@one.firstfloor.org>
References: <20080307653.720459648@firstfloor.org> <20080307175408.E290E1B41AE@basil.firstfloor.org> <1205445980.2893.85.camel@localhost.localdomain> <20080314134814.GS17940@kernel.dk> <20080314135945.GO2522@one.firstfloor.org> <20080317082711.GB17940@kernel.dk> <20080317083603.GJ27015@one.firstfloor.org> <20080317083832.GE17940@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:35754 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbYCQIvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 04:51:15 -0400
Content-Disposition: inline
In-Reply-To: <20080317083832.GE17940@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Mon, Mar 17, 2008 at 09:38:32AM +0100, Jens Axboe wrote:
> On Mon, Mar 17 2008, Andi Kleen wrote:
> > On Mon, Mar 17, 2008 at 09:27:11AM +0100, Jens Axboe wrote:
> > > On Fri, Mar 14 2008, Andi Kleen wrote:
> > > > On Fri, Mar 14, 2008 at 02:48:14PM +0100, Jens Axboe wrote:
> > > > > On Thu, Mar 13 2008, James Bottomley wrote:
> > > > > > \On Fri, 2008-03-07 at 18:54 +0100, Andi Kleen wrote:
> > > > > > > When a user is doing IO in the kernel and wants to avoid bouncing
> > > > > > > it is best to just ask the block layer to allocate the memory for it.
> > > > > > > This patch adds two simple wrappers: blk_kmalloc and blk_alloc_pages
> > > > > > > and respective free functions to do this.
> > > > > > > 
> > > > > > > blk_alloc_pages is a little unusual in that it takes size
> > > > > > > instead of order arguments -- i did this because I have later
> > > > > > > patches to convert it over to a new allocator which does not 
> > > > > > > require power of two for pages.
> > > > > > 
> > > > > > I really don't like this ... it's wedging something in the block layer
> > > > > > that shouldn't be there just to avoid doing it properly in terms of
> > > > > > allocations on the device dma_mask.
> > > > > > 
> > > > > > I also think the kfree takes a length part is asking for trouble because
> > > > > > it's pretty fragile.
> > > > > > 
> > > > > > However, if Jens will ack it, I'll (reluctantly) add it.
> > > > > 
> > > > > I agree with you, I don't like it at all (for a variety of reasons).
> > > > 
> > > > For what reasons exactly? 
> > > 
> > > Mainly the one I list below. Using the interface for allocation is
> > > actually more involved that just doing it yourself, which is not a sign
> > > of a good abstraction.
> > 
> > hmm, missed the point sorry. How is using the interface more
> > involved? It has to get a mask or a pfn from somewhere and 
> > without the interface that's actually more code to write out.
> 
> Because it requires tracking length, for instance. Your interface just

While the implementation in the first patch does not require tracking
length, the mask allocator version that is only introduced about 15 
patches later or so does. That is why i added the length parameter
in the first patch already, although it is not used yet.

Sorry for not making that more clear in the changelog

I actually considered tracking length in the struct page in the
mask allocator for this, but when I looked at the callers I noticed 90+% 
of them only used a constant length which does not really
need to get tracked. It is always the same. Then there are two
or so with a variable length, but it is all local to a single
function so it's also not particularly burdensome to track either.
Please take a look at the callers and you'll see the same.

> doesn't add anything useful, 

Well for once it allows easy conversion to the mask alloactor linux
world.  That is the reason'd'etre of the whole patchkit as far as I'm
concerned anyways.

> it's not a good abstraction/api imho.

I'm still trying to figure out what exactly you object to. 

Is the only problem the length? Would blk_kmalloc/kfree() be ok 
for you if kfree didn't require a length parameter? It would
not be that hard to add one, although frankly I personally
don't see the need.

Or alternatively I will just remove it if James can get convinced
to back down on his earlier requirement for bounce less scanning.

> > > > 
> > > > Of course if you don't want the helpers it could be something like
> > > > 
> > > > 	get_pages_mask(GFP_KERNEL, size, blk_q_mask(request_Queue))
> > > > 
> > > > written out but why not have simple helpers that allows this a little nicer?  
> > > 
> > > I'd greatly prefer that, a helper that converts the dma mask to a
> > > suitable GFP for the architecture. The benefit is that all allocators
> > > takes this mask, and it still leaves the driver free to do whatever it
> > 
> > These are not really used by drivers (except libata) 
> > 
> > > wants to allocate memory.
> > 
> > Well it already exists, it is just called blk_q_mask() and 
> > is added later with the mask allocator block layer code and was used
> > there internally. I can move that out into SCSI if it's really needed.
> 
> Put it in block/ or blkdev.h and call it queue_mask_to_gfp() or
> something, that would be fine.

There is no gfp anymore for this in the mask allocator world!!!! Only
masks and a slight abstraction for some cases request queues with 
bounce pfns.

-Andi

