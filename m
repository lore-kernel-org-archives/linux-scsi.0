From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Tue, 15 May 2007 10:01:16 +0100
Message-ID: <20070515090116.GA9297@infradead.org>
References: <20070512190534B.fujita.tomonori@lab.ntt.co.jp> <20070512153023.GA8088@infradead.org> <200705141440.l4EEe3dB004194@mbox.iij4u.or.jp> <4648829A.10602@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38595 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXEOJB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 05:01:29 -0400
Content-Disposition: inline
In-Reply-To: <4648829A.10602@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hch@infradead.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Mon, May 14, 2007 at 05:39:06PM +0200, Stefan Richter wrote:
> FUJITA Tomonori wrote:
> >> > There are two patches for each driver, removing the non-use-sg code
> >> > and converting to use the accessors.
> ...
> > I merged the two. And I finished cleaning up 35 drivers in total.
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git cleanups
> 
> According to what I see via gitweb, at least usb-storage, ieee1394/sbp2,
> and firewire/fw-sbp2 weren't treated yet.  If somebody does so for the
> latter two:  The shost->shost_gendev.parent has to be changed for
> scsi_dma_{un}map.  I don't know if this can be done without breaking
> anything.

That means they should not be converted to these helpers for now.

Personally I'd still love to have the dma mapping routines to work on
any given struct device but walking up the parent chain until an iommu
is found, but that was vetoed when first proposed.

