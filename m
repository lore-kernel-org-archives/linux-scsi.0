From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Fri, 10 Jan 2003 15:05:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301102005.h0AK59x04828@localhost.localdomain>
References: <luben@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA32401
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2003 12:05:12 -0800
In-Reply-To: Message from Luben Tuikov <luben@splentec.com>
   of "Fri, 10 Jan 2003 14:23:24 EST." <3E1F1DAC.6060207@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

luben@splentec.com said:
> I think that the slab cache can acknowledge a GFP_DMA flag even after
> creation of the slab, but not 100% sure on this. I.e. in
> scsi_get_command() a check of host->unchecked_isa_dma can be performed
> and the kmem_flags OR-ed with GFP_DMA.

Unfortunately, not.  That's why the kmem caches that are used by kmalloc have 
two separate caches for each buddy size (one for zone normal and one for zone 
dma)---you see this in cat /proc/slabinfo.

The essential problem is that the zone flags must be known at the time slab 
gets fed from __get_free_pages().

> I've no problem changing the slab alloc. just let's decide if we want
> a slab per host (kind of inefficient) or 2 slabs (DMA, and non-DMA) or
> OR-ing the mask upon scsi_get_command(). 

The latter, I think.  We want the *ability* to have one slab per host, but 
we'd then assign each host either to the zone DMA or zone normal allocator.  
Then, when the wierd device that has a strange dma_mask comes along, it may 
use its own slab if necessary.

> Actually, I had this in the 2.5.52 version of this patch but decided
> that the LLDD code will run as normal kernel code and that the actual
> PCI HOST will never have to access the struct scsi_cmnd directly over
> the PCI bus; but will only need to access the sg list. For this reason
> I decided to leave it out. I.e. struct scsi_cmnd will alway be
> accessed in normal operation of the kernel, and thus no need for
> GFP_DMA. (I'd so much rather it be that way, so much... :-) 

I'd be happy about this too.  Just assure me that no legacy ISA drivers do dma 
from the Scsi_Cmnd structure and we can forget about the separate allocators 
and revoke the current promise that Scsi_Cmnd will be in memory dma'able by 
the driver.

James


