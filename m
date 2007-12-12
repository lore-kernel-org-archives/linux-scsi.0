From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2 check page: bad entry in
	directory) (fwd)
Date: Wed, 12 Dec 2007 14:07:59 +0100
Message-ID: <1197464879.20796.15.camel@n2o.xs4all.nl>
References: <20071212105841.GN6770@1und1.de>
	 <20071212033808.6fb92139.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-4P8+dsHXux8CM93aqNY6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1220 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbXLLNIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 08:08:36 -0500
In-Reply-To: <20071212033808.6fb92139.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anders Henke <anders.henke@1und1.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, matthew@wil.cx, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


--=-4P8+dsHXux8CM93aqNY6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2007-12-12 at 03:38 -0800, Andrew Morton wrote:
> On Wed, 12 Dec 2007 11:58:41 +0100 Anders Henke <anders.henke@1und1.de> wrote:
> 
> > Hi,
> > 
> > I'd like to let you now that my boxes are running a 32-bit kernel, so
> > the 64-bit-uncleanliness shouldn't apply to my boxes; however,
> > 
> > http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch
> > 
> > fixed the issue on my testbox.
> > 
> > I took a clean 2.6.23, applied patch, recompiled the kernel, reboot: works.
> 
> What a huge patch :(
> 
> We already reverted the offening patch so I assume that 2.6.24-rc5 is
> working for you?
> 
> I guess we need to look at restoring "dpt_i2o: convert to SCSI hotplug
> model" and then absorbing what Miquel has done there.

This was just a patch I had lying around, if it worked it would confirm
my suspicion, which it has.

The minimal patch which is suitable for 2.6.23-stable and 2.6.24 would
be the attached one-liner. The "dpt_i2o: convert to SCSI hotplug model"
patch could be restored then.

(if the list eats the attachment, it's also available here:
http://www.miquels.cistron.nl/linux/linux-2.6.23+24-dpt_i2o-dma64.patch 
)

Anders, does this one-liner patch work for you ?

Mike.

--=-4P8+dsHXux8CM93aqNY6
Content-Disposition: attachment; filename=linux-2.6.23+24-dpt_i2o-dma64.patch
Content-Type: text/x-patch; name=linux-2.6.23+24-dpt_i2o-dma64.patch; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

diff -ruN linux-2.6.23.9.orig/drivers/scsi/dpt_i2o.c linux-2.6.23.9/drivers/scsi/dpt_i2o.c
--- linux-2.6.23.9.orig/drivers/scsi/dpt_i2o.c	2007-11-26 18:51:43.000000000 +0100
+++ linux-2.6.23.9/drivers/scsi/dpt_i2o.c	2007-12-12 13:21:05.000000000 +0100
@@ -905,8 +905,7 @@
 	}
 
 	pci_set_master(pDev);
-	if (pci_set_dma_mask(pDev, DMA_64BIT_MASK) &&
-	    pci_set_dma_mask(pDev, DMA_32BIT_MASK))
+	if (pci_set_dma_mask(pDev, DMA_32BIT_MASK))
 		return -EINVAL;
 
 	base_addr0_phys = pci_resource_start(pDev,0);

--=-4P8+dsHXux8CM93aqNY6--

