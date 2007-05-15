From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Tue, 15 May 2007 06:54:16 -0500
Message-ID: <1179230056.3685.2.camel@mulgrave.il.steeleye.com>
References: <20070512190534B.fujita.tomonori@lab.ntt.co.jp>
	 <20070512153023.GA8088@infradead.org>
	 <200705141440.l4EEe3dB004194@mbox.iij4u.or.jp>
	 <4648829A.10602@s5r6.in-berlin.de>  <20070515090116.GA9297@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44432 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758606AbXEOLyl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 07:54:41 -0400
In-Reply-To: <20070515090116.GA9297@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Tue, 2007-05-15 at 10:01 +0100, Christoph Hellwig wrote:
> On Mon, May 14, 2007 at 05:39:06PM +0200, Stefan Richter wrote:
> > FUJITA Tomonori wrote:
> > >> > There are two patches for each driver, removing the non-use-sg code
> > >> > and converting to use the accessors.
> > ...
> > > I merged the two. And I finished cleaning up 35 drivers in total.
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git cleanups
> > 
> > According to what I see via gitweb, at least usb-storage, ieee1394/sbp2,
> > and firewire/fw-sbp2 weren't treated yet.  If somebody does so for the
> > latter two:  The shost->shost_gendev.parent has to be changed for
> > scsi_dma_{un}map.  I don't know if this can be done without breaking
> > anything.
> 
> That means they should not be converted to these helpers for now.
> 
> Personally I'd still love to have the dma mapping routines to work on
> any given struct device but walking up the parent chain until an iommu
> is found, but that was vetoed when first proposed.

Er ... I really hope not ... that's exactly how the parisc iommu
platform code works ... and why I designed the generic dma mapping this
way.  The key thing parisc needed was the ability to walk up different
busses until it found the iommu (for example the pci bus -> dino -> GSC
-> IOMMU) which it does by traversing the dev->parent; However, I didn't
mandate working this way for other architectures.

James


