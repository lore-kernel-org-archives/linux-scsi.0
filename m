From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 12/19] drivers/scsi/initio: Use the DMA_32BIT_MASK constant
Date: Sun, 20 Mar 2005 14:08:12 +0100
Message-ID: <20050320130812.GL3491@localhost.localdomain>
References: <20050220170652.GM14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:45577 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261197AbVCTNIQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 08:08:16 -0500
Content-Disposition: inline
In-Reply-To: <20050220170652.GM14375@helium.tklauser.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org

The previous patch did not compile cleanly on all architectures so
here's a fixed one.

Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h when calling
pci_set_dma_mask() or pci_set_consistent_dma_mask()
This patch includes dma-mapping.h explicitly because it caused errors
on some architectures otherwise.
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11.orig/drivers/scsi/initio.c	2005-03-02 12:50:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/initio.c	2005-03-20 14:06:32.000000000 +0100
@@ -127,6 +127,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
+#include <linux/dma-mapping.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
@@ -2793,7 +2794,7 @@ static int tul_NewReturnNumberOfAdapters
 			if (((dRegValue & 0xFF00) >> 8) == 0xFF)
 				dRegValue = 0;
 			wBIOS = (wBIOS << 8) + ((UWORD) ((dRegValue & 0xFF00) >> 8));
-			if (pci_set_dma_mask(pDev, 0xffffffff)) {
+			if (pci_set_dma_mask(pDev, DMA_32BIT_MASK)) {
 				printk(KERN_WARNING 
 				       "i91u: Could not set 32 bit DMA mask\n");
 				continue;
