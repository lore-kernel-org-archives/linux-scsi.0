From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Fri, 14 Mar 2008 14:48:14 +0100
Message-ID: <20080314134814.GS17940@kernel.dk>
References: <20080307653.720459648@firstfloor.org> <20080307175408.E290E1B41AE@basil.firstfloor.org> <1205445980.2893.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:17705 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYCNNsR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2008 09:48:17 -0400
Content-Disposition: inline
In-Reply-To: <1205445980.2893.85.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org

On Thu, Mar 13 2008, James Bottomley wrote:
> \On Fri, 2008-03-07 at 18:54 +0100, Andi Kleen wrote:
> > When a user is doing IO in the kernel and wants to avoid bouncing
> > it is best to just ask the block layer to allocate the memory for it.
> > This patch adds two simple wrappers: blk_kmalloc and blk_alloc_pages
> > and respective free functions to do this.
> > 
> > blk_alloc_pages is a little unusual in that it takes size
> > instead of order arguments -- i did this because I have later
> > patches to convert it over to a new allocator which does not 
> > require power of two for pages.
> 
> I really don't like this ... it's wedging something in the block layer
> that shouldn't be there just to avoid doing it properly in terms of
> allocations on the device dma_mask.
> 
> I also think the kfree takes a length part is asking for trouble because
> it's pretty fragile.
> 
> However, if Jens will ack it, I'll (reluctantly) add it.

I agree with you, I don't like it at all (for a variety of reasons).
Since callers need to remember size for free anyway (I've always hated
such interfaces), they may as well do their own allocations. I don't
think the block abstraction buys us anything.

If anything, add a generic allocator helper that you can pass a mask to
instead.

-- 
Jens Axboe

