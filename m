From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Mon, 17 Mar 2008 21:29:31 +0100
Message-ID: <20080317202931.GO17940@kernel.dk>
References: <20080307653.720459648@firstfloor.org> <20080307175408.E290E1B41AE@basil.firstfloor.org> <1205445980.2893.85.camel@localhost.localdomain> <20080314134814.GS17940@kernel.dk> <20080314135945.GO2522@one.firstfloor.org> <20080317082711.GB17940@kernel.dk> <20080317083603.GJ27015@one.firstfloor.org> <20080317083832.GE17940@kernel.dk> <20080317085341.GK27015@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:23749 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbYCQU3g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 16:29:36 -0400
Content-Disposition: inline
In-Reply-To: <20080317085341.GK27015@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Mon, Mar 17 2008, Andi Kleen wrote:
> On Mon, Mar 17, 2008 at 09:38:32AM +0100, Jens Axboe wrote:
> > On Mon, Mar 17 2008, Andi Kleen wrote:
> > > On Mon, Mar 17, 2008 at 09:27:11AM +0100, Jens Axboe wrote:
> > > > On Fri, Mar 14 2008, Andi Kleen wrote:
> > > > > On Fri, Mar 14, 2008 at 02:48:14PM +0100, Jens Axboe wrote:
> > > > > > On Thu, Mar 13 2008, James Bottomley wrote:
> > > > > > > \On Fri, 2008-03-07 at 18:54 +0100, Andi Kleen wrote:
> > > > > > > > When a user is doing IO in the kernel and wants to avoid bouncing
> > > > > > > > it is best to just ask the block layer to allocate the memory for it.
> > > > > > > > This patch adds two simple wrappers: blk_kmalloc and blk_alloc_pages
> > > > > > > > and respective free functions to do this.
> > > > > > > > 
> > > > > > > > blk_alloc_pages is a little unusual in that it takes size
> > > > > > > > instead of order arguments -- i did this because I have later
> > > > > > > > patches to convert it over to a new allocator which does not 
> > > > > > > > require power of two for pages.
> > > > > > > 
> > > > > > > I really don't like this ... it's wedging something in the block layer
> > > > > > > that shouldn't be there just to avoid doing it properly in terms of
> > > > > > > allocations on the device dma_mask.
> > > > > > > 
> > > > > > > I also think the kfree takes a length part is asking for trouble because
> > > > > > > it's pretty fragile.
> > > > > > > 
> > > > > > > However, if Jens will ack it, I'll (reluctantly) add it.
> > > > > > 
> > > > > > I agree with you, I don't like it at all (for a variety of reasons).
> > > > > 
> > > > > For what reasons exactly? 
> > > > 
> > > > Mainly the one I list below. Using the interface for allocation is
> > > > actually more involved that just doing it yourself, which is not a sign
> > > > of a good abstraction.
> > > 
> > > hmm, missed the point sorry. How is using the interface more
> > > involved? It has to get a mask or a pfn from somewhere and 
> > > without the interface that's actually more code to write out.
> > 
> > Because it requires tracking length, for instance. Your interface just
> 
> While the implementation in the first patch does not require tracking
> length, the mask allocator version that is only introduced about 15 
> patches later or so does. That is why i added the length parameter
> in the first patch already, although it is not used yet.
> 
> Sorry for not making that more clear in the changelog
> 
> I actually considered tracking length in the struct page in the
> mask allocator for this, but when I looked at the callers I noticed 90+% 
> of them only used a constant length which does not really
> need to get tracked. It is always the same. Then there are two
> or so with a variable length, but it is all local to a single
> function so it's also not particularly burdensome to track either.
> Please take a look at the callers and you'll see the same.
> 
> > doesn't add anything useful, 
> 
> Well for once it allows easy conversion to the mask alloactor linux
> world.  That is the reason'd'etre of the whole patchkit as far as I'm
> concerned anyways.

The queue_to_gfp_mask() would make that conversion equally simple.

> > it's not a good abstraction/api imho.
> 
> I'm still trying to figure out what exactly you object to. 
> 
> Is the only problem the length? Would blk_kmalloc/kfree() be ok 
> for you if kfree didn't require a length parameter? It would
> not be that hard to add one, although frankly I personally
> don't see the need.

Well both - as mentioned, the queue_to_gfp_mask() is cleaner I think.
And I just don't think it's a good API to begin with, to me it's
inventing something that doesn't really buy you anything. With an
exported mask function, you can pass that to any allocator.

> Or alternatively I will just remove it if James can get convinced
> to back down on his earlier requirement for bounce less scanning.

Personally, for scanning I could not care less. It may actually be a
good idea, as bouncing would get tested more so we're sure it doesn't
get broken ;-)

> > Put it in block/ or blkdev.h and call it queue_mask_to_gfp() or
> > something, that would be fine.
> 
> There is no gfp anymore for this in the mask allocator world!!!! Only
> masks and a slight abstraction for some cases request queues with 
> bounce pfns.

Then name it queue_bounce_mask() or something, principle is the same
(export mask vs export silly api for allocation/free).

-- 
Jens Axboe

