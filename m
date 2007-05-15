From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Tue, 15 May 2007 12:57:25 -0400
Message-ID: <1179248245.3685.23.camel@mulgrave.il.steeleye.com>
References: <20070512190534B.fujita.tomonori@lab.ntt.co.jp>
	 <20070512153023.GA8088@infradead.org>
	 <200705141440.l4EEe3dB004194@mbox.iij4u.or.jp>
	 <4648829A.10602@s5r6.in-berlin.de> <20070515090116.GA9297@infradead.org>
	 <1179230056.3685.2.camel@mulgrave.il.steeleye.com>
	 <20070515115748.GA12461@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:46142 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757277AbXEORFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 13:05:54 -0400
In-Reply-To: <20070515115748.GA12461@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Tue, 2007-05-15 at 12:57 +0100, Christoph Hellwig wrote:
> On Tue, May 15, 2007 at 06:54:16AM -0500, James Bottomley wrote:
> > Er ... I really hope not ... that's exactly how the parisc iommu
> > platform code works ... and why I designed the generic dma mapping this
> > way.  The key thing parisc needed was the ability to walk up different
> > busses until it found the iommu (for example the pci bus -> dino -> GSC
> > -> IOMMU) which it does by traversing the dev->parent; However, I didn't
> > mandate working this way for other architectures.
> 
> Well, the NACK was not for the implementation details but rather the
> exported and documented interface.  IIRC the rationale was that Dave wants
> to keep the sparc implementation super-optimized and avoid indirection.

Well, actually, I do understand that.  How about the weaker requirement
that you be able to call the dma_ functions on any dev (provided it's
properly parented) and leave the implementation up to the platform?

> If it was up to me I'd have something like the parisc implementation in
> generic code.

It might make sense to put it in lib ... however, I don't think many
architectures have the problems we have ... specifically certain boxes
can have >1 IOMMU, then you really have to know *which* iommu you're
programming.

James


