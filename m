From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Sun, 24 Apr 2005 02:22:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0504240212090.13715@poirot.grange>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
  <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>  <20050321104419.GH23911@suse.de>
  <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0503302318250.9431@poirot.grange>  <1112220802.9435.1.camel@mulgrave>
  <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0504100035110.4283@poirot.grange>  <Pine.LNX.4.60.0504212341390.6761@poirot.grange>
  <20050422113654.GY9371@suse.de>  <Pine.LNX.4.60.0504222203190.5348@poirot.grange>
  <Pine.LNX.4.60.0504231159260.8537@poirot.grange> <1114282904.5068.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:60351 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262202AbVDXAXg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Apr 2005 20:23:36 -0400
In-Reply-To: <1114282904.5068.19.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>

On Sat, 23 Apr 2005, James Bottomley wrote:

> As long as the sg list hasn't gone through dma_map_sg, then you can rely
> on its elements being contiguous in physical space.  Once it's gone
> through dma_map_sg, it's elements are contiguous in the bus space beyond
> the IOMMU, so no longer (possibly) even physically contiguous.

Thanks for the info. Let me see, if I got you right. Say, we've got an sg 
with 2 elements: first 2 * PAGE_SIZE long, offset 0, pointing to page #0, 
second PAGE_SIZE long, offset 0, page #3. Say, dma_map_sg returned 1, so, 
it mapped all those 3 (physically discontiguous) pages to a contiguous bus 
address range. And now sg_dma_len() returns 3 * PAGE_SIZE. But, I hope, 
the .page, .length, and .offset elements stayed unchanged, so, one can 
still walk elements 0 and 1, calculating a sum of sg[i].length and thus 
arrive to the required page, right?

I'll redo the patch.

Thanks
Guennadi
---
Guennadi Liakhovetski

