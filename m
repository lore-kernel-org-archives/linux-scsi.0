From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Sat, 23 Apr 2005 15:01:44 -0400
Message-ID: <1114282904.5068.19.camel@mulgrave>
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
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:36825 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261699AbVDWTB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Apr 2005 15:01:57 -0400
In-Reply-To: <Pine.LNX.4.60.0504231159260.8537@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>

On Sat, 2005-04-23 at 12:06 +0200, Guennadi Liakhovetski wrote:
> Hm, it is sometimes a good idea to at least compile-test ones patches... 
> So, the one below at least compiles.
> 
> One more thing I wanted to ask - what can one assume about request 
> buffers? If it is a sg, I guess, each segment is within one page frame, 
> right? And if sg is not used, is request_buffer also guaranteed to be 
> within one page or not?

No to the first one if you've enabled clustering or have an IOMMU and no
to the second one.

As long as the sg list hasn't gone through dma_map_sg, then you can rely
on its elements being contiguous in physical space.  Once it's gone
through dma_map_sg, it's elements are contiguous in the bus space beyond
the IOMMU, so no longer (possibly) even physically contiguous.

The request_buffer for no sg cases is guaranteed to be both physically
and virtually contiguous.

James


