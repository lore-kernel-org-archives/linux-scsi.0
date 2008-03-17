From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Mon, 17 Mar 2008 09:27:11 +0100
Message-ID: <20080317082711.GB17940@kernel.dk>
References: <20080307653.720459648@firstfloor.org> <20080307175408.E290E1B41AE@basil.firstfloor.org> <1205445980.2893.85.camel@localhost.localdomain> <20080314134814.GS17940@kernel.dk> <20080314135945.GO2522@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:15706 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbYCQI1O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 04:27:14 -0400
Content-Disposition: inline
In-Reply-To: <20080314135945.GO2522@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Fri, Mar 14 2008, Andi Kleen wrote:
> On Fri, Mar 14, 2008 at 02:48:14PM +0100, Jens Axboe wrote:
> > On Thu, Mar 13 2008, James Bottomley wrote:
> > > \On Fri, 2008-03-07 at 18:54 +0100, Andi Kleen wrote:
> > > > When a user is doing IO in the kernel and wants to avoid bouncing
> > > > it is best to just ask the block layer to allocate the memory for it.
> > > > This patch adds two simple wrappers: blk_kmalloc and blk_alloc_pages
> > > > and respective free functions to do this.
> > > > 
> > > > blk_alloc_pages is a little unusual in that it takes size
> > > > instead of order arguments -- i did this because I have later
> > > > patches to convert it over to a new allocator which does not 
> > > > require power of two for pages.
> > > 
> > > I really don't like this ... it's wedging something in the block layer
> > > that shouldn't be there just to avoid doing it properly in terms of
> > > allocations on the device dma_mask.
> > > 
> > > I also think the kfree takes a length part is asking for trouble because
> > > it's pretty fragile.
> > > 
> > > However, if Jens will ack it, I'll (reluctantly) add it.
> > 
> > I agree with you, I don't like it at all (for a variety of reasons).
> 
> For what reasons exactly? 

Mainly the one I list below. Using the interface for allocation is
actually more involved that just doing it yourself, which is not a sign
of a good abstraction.

> In my original patchkit I didn't have blk_kmalloc etc. but just relied 
> on the block layer bouncing everything for ISA as needed, but James
> thought it was important that SCSI LUN scan etc do not bounce for ISA.
> That is when I came up with these helpers.
> 
> You think it should go back to always bouncing? That would be fine
> for me too. With that they wouldn't be needed.

I don't see a reason for not bouncing for scanning - James?

> I think the only issue where it might be a problem would be with
> sg.c where it might be a performance issue.
> 
> > Since callers need to remember size for free anyway (I've always hated
> > such interfaces), they may as well do their own allocations. I don't
> > think the block abstraction buys us anything.
> 
> > 
> > If anything, add a generic allocator helper that you can pass a mask to
> > instead.
> 
> The reason I added the size is that the mask allocator (not in the SCSI
> specific patchkit, but I posted that to l-k later) needs a size to free
> because it is based on a similar design as free_pages which always needed
> size. Also at least for the few users I converted (there are not really
> that many) the size is either constant anyways or very easy to remember
> (please take a look at the concrete patches before judging it)  
> 
> The other problem is that there is no mask, except for the bounce mask. These
> old cruft ISA drivers don't have a device (and before anybody asks
> again -- no i don't plan to rewrite them all to be device based);
> but they do have correct bounce_pfn which has all the needed information.
> I don't think it would make sense to add another field for this.
> 
> That is why I ended up with the helpers
> 
> Of course if you don't want the helpers it could be something like
> 
> 	get_pages_mask(GFP_KERNEL, size, blk_q_mask(request_Queue))
> 
> written out but why not have simple helpers that allows this a little nicer?  

I'd greatly prefer that, a helper that converts the dma mask to a
suitable GFP for the architecture. The benefit is that all allocators
takes this mask, and it still leaves the driver free to do whatever it
wants to allocate memory.

-- 
Jens Axboe

