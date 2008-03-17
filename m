From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Mon, 17 Mar 2008 11:03:29 +0100
Message-ID: <20080317100329.GC12405@basil.nowhere.org>
References: <20080307653.720459648@firstfloor.org> <20080307175408.E290E1B41AE@basil.firstfloor.org> <1205445980.2893.85.camel@localhost.localdomain> <20080314134814.GS17940@kernel.dk> <20080314135945.GO2522@one.firstfloor.org> <20080317082711.GB17940@kernel.dk> <20080317083603.GJ27015@one.firstfloor.org> <20080317083832.GE17940@kernel.dk> <20080317085341.GK27015@one.firstfloor.org> <47DE3778.2090600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:40744 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYCQKDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 06:03:31 -0400
Content-Disposition: inline
In-Reply-To: <47DE3778.2090600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

> I would like if we could do a regular allocation and let the

That is what v1 of the patchkit did. I only introduced blk_* 
based on feedback from James who was concerned about the additional
bounces.  It would be fine for me to go back to that state.

Please Jens and James work out what way is the preferred one.
Right now there are conflicting requirements from different
maintainers.

> this code wants to change to use proper BIO and blk_ API as was 
> proposed by Mike Christie. So there is only that one user at scsi_scan

It's actually not only scsi-scan, but a couple of users (see the whole
patchkit) 


> On the other hand it is not only the ISA cases right? Even in an
> x86_64 system with a PCI-32 host, we are going to bounce. Perhaps if
> there is a convenient API for allocating un-bounced memory for a 
> block device there will be more users for it, like file-systems. 
> 
> The API, I would like that if failing to allocate un--bounced memory 
> would then allocate any memory and bounce later.

pci dma api/ swiotlb is that API (which either bounces or uses
an iommu), but it doesn't work for ISA DMA

-Andi

