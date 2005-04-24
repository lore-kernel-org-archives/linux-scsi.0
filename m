From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Sun, 24 Apr 2005 18:11:58 -0400
Message-ID: <1114380718.4786.10.camel@mulgrave>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
	 <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>
	 <20050321104419.GH23911@suse.de>
	 <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
	 <Pine.LNX.4.60.0503302318250.9431@poirot.grange>
	 <1112220802.9435.1.camel@mulgrave>
	 <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de>
	 <Pine.LNX.4.60.0504100035110.4283@poirot.grange>
	 <Pine.LNX.4.60.0504212341390.6761@poirot.grange>
	 <20050422113654.GY9371@suse.de>
	 <Pine.LNX.4.60.0504222203190.5348@poirot.grange>
	 <Pine.LNX.4.60.0504231159260.8537@poirot.grange>
	 <1114282904.5068.19.camel@mulgrave>
	 <Pine.LNX.4.60.0504240212090.13715@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:55787 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262480AbVDXX0l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Apr 2005 19:26:41 -0400
In-Reply-To: <Pine.LNX.4.60.0504240212090.13715@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>

On Sun, 2005-04-24 at 02:22 +0200, Guennadi Liakhovetski wrote:
> Thanks for the info. Let me see, if I got you right. Say, we've got an sg 
> with 2 elements: first 2 * PAGE_SIZE long, offset 0, pointing to page #0, 
> second PAGE_SIZE long, offset 0, page #3. Say, dma_map_sg returned 1, so, 
> it mapped all those 3 (physically discontiguous) pages to a contiguous bus 
> address range. And now sg_dma_len() returns 3 * PAGE_SIZE.

Yes, that's true.

>  But, I hope, 
> the .page, .length, and .offset elements stayed unchanged, so, one can 
> still walk elements 0 and 1, calculating a sum of sg[i].length and thus 
> arrive to the required page, right?

This, I'm not entirely sure about.  There are some weird iommu mapping
implementations out there.  The only absolute requirement is that the
map_sg unmap_sg map_sg actually work.  There was some debate over
whether unmap_sg was supposed to return the sg list to its original
form, but x86_64 got beaten up in the argument, so this is true too.

So ... I think the answer to your question is "yes", at least for all
the iommu implementations I know about.  However, nothing in the
published API actually requires this.

What I think all this means is that you can get away with what you're
proposing.  However, the proper route would be to unmap the sglist
before you start feeding the leftovers via pio.

James


