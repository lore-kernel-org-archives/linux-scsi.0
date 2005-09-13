From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] gdth: use dma_addr_t properly
Date: Tue, 13 Sep 2005 19:55:16 +0200
Message-ID: <20050913175516.GA25746@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:12760 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964945AbVIMRz2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 13:55:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: achim_leubner@adaptec.com
Cc: linux-scsi@vger.kernel.org

bus address returned from pci_alloc_consistant or pci_map_* should
be stored in dma_addr_t variables.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/gdth.h
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.h	2005-09-11 18:12:24.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth.h	2005-09-11 18:14:51.000000000 +0200
@@ -872,17 +872,17 @@
     ulong32             brd_phys;               /* slot number/BIOS address */
     gdt6c_plx_regs      *plx;                   /* PLX regs (new PCI contr.) */
     gdth_cmd_str        *pccb;                  /* address command structure */
-    ulong32             ccb_phys;               /* phys. address */
+    dma_addr_t          ccb_phys;               /* phys. address */
 #ifdef INT_COAL
     gdth_coal_status    *coal_stat;             /* buffer for coalescing int.*/
-    ulong64             coal_stat_phys;         /* phys. address */
+    dma_addr_t          coal_stat_phys;         /* phys. address */
 #endif
     char                *pscratch;              /* scratch (DMA) buffer */
-    ulong64             scratch_phys;           /* phys. address */
+    dma_addr_t          scratch_phys;           /* phys. address */
     unchar              scratch_busy;           /* in use? */
     unchar              dma64_support;          /* 64-bit DMA supported? */
     gdth_msg_str        *pmsg;                  /* message buffer */
-    ulong64             msg_phys;               /* phys. address */
+    dma_addr_t          msg_phys;               /* phys. address */
     unchar              scan_mode;              /* current scan mode */
     unchar              irq;                    /* IRQ */
     unchar              drq;                    /* DRQ (ISA controllers) */
