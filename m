From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 18/19] drivers/scsi/qlogicfc: Use the DMA_{64, 32}BIT_MASK constants
Date: Sun, 20 Mar 2005 14:22:21 +0100
Message-ID: <20050320132221.GR3491@localhost.localdomain>
References: <20050220171244.GS14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:41733 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S262165AbVCTNWY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 08:22:24 -0500
Content-Disposition: inline
In-Reply-To: <20050220171244.GS14375@helium.tklauser.home>
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

--- linux-2.6.11.orig/drivers/scsi/qlogicfc.c	2005-03-02 12:50:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/qlogicfc.c	2005-03-20 13:27:54.000000000 +0100
@@ -61,6 +61,7 @@
 #include <linux/unistd.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include "scsi.h"
@@ -719,8 +720,8 @@ int isp2x00_detect(Scsi_Host_Template * 
 				continue;
 
 			/* Try to configure DMA attributes. */
-			if (pci_set_dma_mask(pdev, 0xffffffffffffffffULL) &&
-			    pci_set_dma_mask(pdev, 0xffffffffULL))
+			if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) &&
+			    pci_set_dma_mask(pdev, DMA_32BIT_MASK))
 					continue;
 
 		        host = scsi_register(tmpt, sizeof(struct isp2x00_hostdata));
