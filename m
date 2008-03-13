From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Thu, 13 Mar 2008 17:06:20 -0500
Message-ID: <1205445980.2893.85.camel@localhost.localdomain>
References: <20080307653.720459648@firstfloor.org>
	 <20080307175408.E290E1B41AE@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56042 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756285AbYCMWG1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 18:06:27 -0400
In-Reply-To: <20080307175408.E290E1B41AE@basil.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk

\On Fri, 2008-03-07 at 18:54 +0100, Andi Kleen wrote:
> When a user is doing IO in the kernel and wants to avoid bouncing
> it is best to just ask the block layer to allocate the memory for it.
> This patch adds two simple wrappers: blk_kmalloc and blk_alloc_pages
> and respective free functions to do this.
> 
> blk_alloc_pages is a little unusual in that it takes size
> instead of order arguments -- i did this because I have later
> patches to convert it over to a new allocator which does not 
> require power of two for pages.

I really don't like this ... it's wedging something in the block layer
that shouldn't be there just to avoid doing it properly in terms of
allocations on the device dma_mask.

I also think the kfree takes a length part is asking for trouble because
it's pretty fragile.

However, if Jens will ack it, I'll (reluctantly) add it.

James


