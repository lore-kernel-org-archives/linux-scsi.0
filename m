From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 09/19] drivers/scsi/dpt_i2o: Use the DMA_{64, 32}BIT_MASK constants
Date: Sun, 20 Mar 2005 13:47:11 +0100
Message-ID: <20050320124711.GI3491@localhost.localdomain>
References: <20050220170414.GJ14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:5380 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S262157AbVCTMrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 07:47:14 -0500
Content-Disposition: inline
In-Reply-To: <20050220170414.GJ14375@helium.tklauser.home>
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

--- linux-2.6.11.orig/drivers/scsi/dpt_i2o.c	2005-03-02 12:50:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/dpt_i2o.c	2005-03-20 13:27:54.000000000 +0100
@@ -62,6 +62,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Dri
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/processor.h>	/* for boot_cpu_data */
 #include <asm/pgtable.h>
@@ -881,8 +882,8 @@ static int adpt_install_hba(struct scsi_
 		return -EINVAL;
 	}
 	pci_set_master(pDev);
-	if (pci_set_dma_mask(pDev, 0xffffffffffffffffULL) &&
-	    pci_set_dma_mask(pDev, 0xffffffffULL))
+	if (pci_set_dma_mask(pDev, DMA_64BIT_MASK) &&
+	    pci_set_dma_mask(pDev, DMA_32BIT_MASK))
 		return -EINVAL;
 
 	base_addr0_phys = pci_resource_start(pDev,0);
