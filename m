From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 17/19] drivers/scsi/qla1280: Use the DMA_32BIT_MASK constant
Date: Sun, 20 Mar 2005 14:20:49 +0100
Message-ID: <20050320132049.GQ3491@localhost.localdomain>
References: <20050220171200.GR14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:53776 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S262160AbVCTNU6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 08:20:58 -0500
Content-Disposition: inline
In-Reply-To: <20050220171200.GR14375@helium.tklauser.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

The previous patch did not compile cleanly on all architectures so
here's a fixed one.

Use the DMA_32BIT_MASK constant from dma-mapping.h when calling
pci_set_dma_mask() or pci_set_consistent_dma_mask()
This patch includes dma-mapping.h explicitly because it caused errors
on some architectures otherwise.
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11.orig/drivers/scsi/qla1280.c	2005-03-02 12:50:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/qla1280.c	2005-03-20 13:27:54.000000000 +0100
@@ -345,6 +345,7 @@
 #include <linux/pci_ids.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -4741,7 +4742,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 
 #ifdef QLA_64BIT_PTR
 	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
-		if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
+		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       " suitable DMA mask - aboring\n", ha->host_no);
 			error = -ENODEV;
@@ -4751,7 +4752,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
 			ha->host_no);
 #else
-	if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING "scsi(%li): Unable to set a "
 		       " suitable DMA mask - aboring\n", ha->host_no);
 		error = -ENODEV;
