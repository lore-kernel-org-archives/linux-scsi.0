From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 01/19] drivers/scsi/a100u2w: Use the DMA_32BIT_MASK constant
Date: Sun, 20 Mar 2005 13:32:40 +0100
Message-ID: <20050320123240.GA3491@localhost.localdomain>
References: <20050220164913.GA14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:17156 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261184AbVCTMcn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 07:32:43 -0500
Content-Disposition: inline
In-Reply-To: <20050220164913.GA14375@helium.tklauser.home>
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

--- linux-2.6.11.orig/drivers/scsi/a100u2w.c	2005-03-02 12:50:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/a100u2w.c	2005-03-20 13:27:54.000000000 +0100
@@ -89,6 +89,7 @@
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -1052,7 +1053,7 @@ static int __devinit inia100_probe_one(s
 
 	if (pci_enable_device(pdev))
 		goto out;
-	if (pci_set_dma_mask(pdev, 0xffffffffULL)) {
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING "Unable to set 32bit DMA "
 				    "on inia100 adapter, ignoring.\n");
 		goto out_disable_device;
