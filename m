From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 08/19] drivers/scsi/BusLogic: Use the DMA_32BIT_MASK constant
Date: Sun, 20 Mar 2005 13:45:45 +0100
Message-ID: <20050320124545.GH3491@localhost.localdomain>
References: <20050220170239.GI14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:48907 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S262153AbVCTMrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 07:47:09 -0500
Content-Disposition: inline
In-Reply-To: <20050220170239.GI14375@helium.tklauser.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: lnz@dandelion.com, linux-scsi@vger.kernel.org

The previous patch did not compile cleanly on all architectures so
here's a fixed one.

Use the DMA_32BIT_MASK constant from dma-mapping.h when calling
pci_set_dma_mask() or pci_set_consistent_dma_mask()
This patch includes dma-mapping.h explicitly because it caused errors
on some architectures otherwise.
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11.orig/drivers/scsi/BusLogic.c	2005-03-02 12:50:38.000000000 +0100
+++ linux-2.6.11/drivers/scsi/BusLogic.c	2005-03-20 13:27:54.000000000 +0100
@@ -41,6 +41,7 @@
 #include <linux/stat.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
 #include <scsi/scsicam.h>
 
 #include <asm/dma.h>
@@ -676,7 +677,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -831,7 +832,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -885,7 +886,7 @@ static int __init BusLogic_InitializeFla
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
