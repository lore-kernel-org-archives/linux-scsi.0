From: Adrian Bunk <bunk@fs.tum.de>
Subject: 2.5.73: integer constants in sym53c8xx_2/sym_glue.c too big for int
Date: Tue, 24 Jun 2003 20:07:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030624180710.GY3710@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: Gerard Roudier <groudier@free.fr>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The patch below postfixes a constant in sym53c8xx_2/sym_glue.c with ULL,
on 32 bit archs this constant is too big for an int.

The other problem is the PciDmaMask #if SYM_CONF_DMA_ADDRESSING_MODE == 1:
Are the _ten_ "f"'s intended (making the constant bigger than the size 
of an int on 32 bit archs)?

cu
Adrian

--- linux-2.5.73-not-full/drivers/scsi/sym53c8xx_2/sym_glue.c.old	2003-06-24 19:53:04.000000000 +0200
+++ linux-2.5.73-not-full/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-06-24 19:56:01.000000000 +0200
@@ -1863,7 +1863,7 @@
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 1
 #define	PciDmaMask	0xffffffffff
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 2
-#define	PciDmaMask	0xffffffffffffffff
+#define	PciDmaMask	0xffffffffffffffffULL
 #endif
 	if (np->features & FE_DAC) {
 		if (!pci_set_dma_mask(np->s.device, PciDmaMask)) {
