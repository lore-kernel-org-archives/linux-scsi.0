From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 11/19] drivers/scsi/gdth: Use the DMA_{64, 32}BIT_MASK constants
Date: Sun, 20 Mar 2005 13:52:58 +0100
Message-ID: <20050320125258.GK3491@localhost.localdomain>
References: <20050220170552.GL14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:7 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261171AbVCTMxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 07:53:05 -0500
Content-Disposition: inline
In-Reply-To: <20050220170552.GL14375@helium.tklauser.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: achim_leubner@adaptec.com, linux-scsi@vger.kernel.org

The previous patch did not compile cleanly on all architectures so
here's a fixed one.

Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h when calling
pci_set_dma_mask() or pci_set_consistent_dma_mask()
This patch includes dma-mapping.h explicitly because it caused errors
on some architectures otherwise.
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11.orig/drivers/scsi/gdth.c	2005-03-02 12:50:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/gdth.c	2005-03-20 13:50:36.000000000 +0100
@@ -402,6 +402,7 @@
 #include <linux/blkdev.h>
 #else
 #include <linux/blk.h>
+#include <linux/dma-mapping.h>
 #include "sd.h"
 #endif
 
@@ -4529,15 +4530,15 @@ int __init gdth_detect(Scsi_Host_Templat
             if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat &GDT_64BIT)||
                 /* 64-bit DMA only supported from FW >= x.43 */
                 (!ha->dma64_support)) {
-                if (pci_set_dma_mask(pcistr[ctr].pdev, 0xffffffff)) {
+                if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
                     printk(KERN_WARNING "GDT-PCI %d: Unable to set 32-bit DMA\n", hanum);
                     err = TRUE;
                 }
             } else {
                 shp->max_cmd_len = 16;
-                if (!pci_set_dma_mask(pcistr[ctr].pdev, 0xffffffffffffffffULL)) {
+                if (!pci_set_dma_mask(pcistr[ctr].pdev, DMA_64BIT_MASK)) {
                     printk("GDT-PCI %d: 64-bit DMA enabled\n", hanum);
-                } else if (pci_set_dma_mask(pcistr[ctr].pdev, 0xffffffff)) {
+                } else if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
                     printk(KERN_WARNING "GDT-PCI %d: Unable to set 64/32-bit DMA\n", hanum);
                     err = TRUE;
                 }
