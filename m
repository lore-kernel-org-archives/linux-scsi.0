From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 10/19] drivers/scsi/eata: Use the DMA_32BIT_MASK constant
Date: Sun, 20 Mar 2005 13:49:24 +0100
Message-ID: <20050320124924.GJ3491@localhost.localdomain>
References: <20050220170503.GK14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:23055 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S262158AbVCTMtc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 07:49:32 -0500
Content-Disposition: inline
In-Reply-To: <20050220170503.GK14375@helium.tklauser.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: linux-eata@i-connect.net, linux-scsi@vger.kernel.org

The previous patch did not compile cleanly on all architectures so
here's a fixed one.

Use the DMA_32BIT_MASK constant from dma-mapping.h when calling
pci_set_dma_mask() or pci_set_consistent_dma_mask()
This patch includes dma-mapping.h explicitly because it caused errors
on some architectures otherwise.
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11.orig/drivers/scsi/eata.c	2005-03-02 12:50:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/eata.c	2005-03-20 13:27:54.000000000 +0100
@@ -490,6 +490,7 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
 #include <asm/byteorder.h>
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -1430,7 +1431,7 @@ static int port_detect(unsigned long por
 
 	if (ha->pdev) {
 		pci_set_master(ha->pdev);
-		if (pci_set_dma_mask(ha->pdev, 0xffffffff))
+		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK))
 			printk("%s: warning, pci_set_dma_mask failed.\n",
 			       ha->board_name);
 	}
