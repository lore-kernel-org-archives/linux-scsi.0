From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: [PATCH] dpt_i2o: don't set DMA_64BIT_MASK [was: Re: [stable] broken dpt_i2o in 2.6.23 (was: ext2 check page: bad entry in directory) (fwd)]
Date: Thu, 13 Dec 2007 11:11:44 +0100
Message-ID: <20071213101144.GA61767@xs4all.net>
References: <20071212105841.GN6770@1und1.de> <20071212033808.6fb92139.akpm@linux-foundation.org> <1197464879.20796.15.camel@n2o.xs4all.nl> <20071212134342.GR6770@1und1.de> <20071212111629.9a4f7f73.akpm@linux-foundation.org> <1197489294.4203.40.camel@localhost.localdomain> <20071212221627.GA16474@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3963 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbXLMKNI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2007 05:13:08 -0500
Content-Disposition: inline
In-Reply-To: <20071212221627.GA16474@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Miquel van Smoorenburg <miquels@cistron.nl>, linux-scsi@vger.kernel.org, matthew@wil.cx, linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Anders Henke <anders.henke@1und1.de>, stable@kernel.org

According to Greg KH:
> So, what should be added to 2.6.23-stable then?  And, can I get a real
> changelog entry for it?

This is suitable for both 2.6.23.x and 2.6.24-rc5 :

linux-2.6-dpt_i2o-no-dma64.patch

The dpt_i2o driver can't handle 64 bit DMA addresses, so do not
let it set pci_set_dma_mask(pDev, DMA_64BIT_MASK) .

Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>

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

