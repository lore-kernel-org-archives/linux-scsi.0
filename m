From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 07/19] drivers/scsi/atp870u: Use the DMA_32BIT_MASK constant
Date: Sun, 20 Mar 2005 13:44:01 +0100
Message-ID: <20050320124401.GG3491@localhost.localdomain>
References: <20050220170137.GH14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:31757 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S262149AbVCTMoF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 07:44:05 -0500
Content-Disposition: inline
In-Reply-To: <20050220170137.GH14375@helium.tklauser.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org

The previous patch did not compile cleanly on all architectures so
here's a fixed one.

Use the DMA_32BIT_MASK constant from dma-mapping.h when calling
pci_set_dma_mask() or pci_set_consistent_dma_mask()
This patch includes dma-mapping.h explicitly because it caused errors
on some architectures otherwise.
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11.orig/drivers/scsi/atp870u.c	2005-03-02 12:50:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/atp870u.c	2005-03-20 13:27:54.000000000 +0100
@@ -27,6 +27,7 @@
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
 #include <asm/system.h>
 #include <asm/io.h>
 
@@ -2287,7 +2288,7 @@ static int atp870u_probe(struct pci_dev 
 	if (pci_enable_device(dev))
 		return -EIO;
 
-	if (pci_set_dma_mask(dev, 0xFFFFFFFFUL)) {
+	if (pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
 		printk(KERN_ERR "atp870u: 32bit DMA mask required but not available.\n");
 		return -EIO;
 	}
