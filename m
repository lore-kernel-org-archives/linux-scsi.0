From: viro@parcelfarce.linux.theplanet.co.uk
Subject: [PATCH] ioremap cleanups in aic7xxx
Date: Thu, 21 Oct 2004 00:57:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020235734.GB23987@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42153 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270522AbUJTX5j
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 19:57:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

	ioremap() is capable of dealing with addresses that are not
page-aligned; no need to duplicate that in driver.
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic79xx_osm.c RC9-bk4-aic-ioremap/drivers/scsi/aic7xxx/aic79xx_osm.c
--- RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic79xx_osm.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-aic-ioremap/drivers/scsi/aic7xxx/aic79xx_osm.c	Wed Oct 20 19:24:38 2004
@@ -2267,11 +2267,7 @@
 			release_region(ahd->bshs[1].ioport, 256);
 		if (ahd->tags[0] == BUS_SPACE_MEMIO
 		 && ahd->bshs[0].maddr != NULL) {
-			u_long base_addr;
-
-			base_addr = (u_long)ahd->bshs[0].maddr;
-			base_addr &= PAGE_MASK;
-			iounmap((void *)base_addr);
+			iounmap(ahd->bshs[0].maddr);
 			release_mem_region(ahd->platform_data->mem_busaddr,
 					   0x1000);
 		}
diff -urN RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic79xx_osm_pci.c RC9-bk4-aic-ioremap/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	Wed Oct 20 19:24:37 2004
+++ RC9-bk4-aic-ioremap/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	Wed Oct 20 19:24:38 2004
@@ -311,7 +311,7 @@
 			       ahd_get_pci_bus(ahd->dev_softc),
 			       ahd_get_pci_slot(ahd->dev_softc),
 			       ahd_get_pci_function(ahd->dev_softc));
-			iounmap((void *)((u_long)maddr & PAGE_MASK));
+			iounmap(maddr);
 			release_mem_region(ahd->platform_data->mem_busaddr,
 					   0x1000);
 			ahd->bshs[0].maddr = NULL;
diff -urN RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic7xxx_osm.c RC9-bk4-aic-ioremap/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic7xxx_osm.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-aic-ioremap/drivers/scsi/aic7xxx/aic7xxx_osm.c	Wed Oct 20 19:24:38 2004
@@ -1932,11 +1932,7 @@
 			release_region(ahc->bsh.ioport, 256);
 		if (ahc->tag == BUS_SPACE_MEMIO
 		 && ahc->bsh.maddr != NULL) {
-			u_long base_addr;
-
-			base_addr = (u_long)ahc->bsh.maddr;
-			base_addr &= PAGE_MASK;
-			iounmap((void *)base_addr);
+			iounmap(ahc->bsh.maddr);
 			release_mem_region(ahc->platform_data->mem_busaddr,
 					   0x1000);
 		}
diff -urN RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c RC9-bk4-aic-ioremap/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Wed Oct 20 19:24:37 2004
+++ RC9-bk4-aic-ioremap/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Wed Oct 20 19:24:38 2004
@@ -329,21 +329,10 @@
 				 uint8_t __iomem **maddr)
 {
 	u_long	start;
-	u_long	base_page;
-	u_long	base_offset;
 	int	error;
 
 	error = 0;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
 	start = pci_resource_start(ahc->dev_softc, 1);
-	base_page = start & PAGE_MASK;
-	base_offset = start - base_page;
-#else
-	start = ahc_pci_read_config(ahc->dev_softc, PCIR_MAPS+4, 4);
-	base_offset = start & PCI_BASE_ADDRESS_MEM_MASK;
-	base_page = base_offset & PAGE_MASK;
-	base_offset -= base_page;
-#endif
 	if (start != 0) {
 		*bus_addr = start;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
@@ -351,14 +340,13 @@
 			error = ENOMEM;
 #endif
 		if (error == 0) {
-			*maddr = ioremap_nocache(base_page, base_offset + 256);
+			*maddr = ioremap_nocache(start, 256);
 			if (*maddr == NULL) {
 				error = ENOMEM;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 				release_mem_region(start, 0x1000);
 #endif
-			} else
-				*maddr += base_offset;
+			}
 		}
 	} else
 		error = ENOMEM;
@@ -399,7 +387,7 @@
 			       ahc_get_pci_bus(ahc->dev_softc),
 			       ahc_get_pci_slot(ahc->dev_softc),
 			       ahc_get_pci_function(ahc->dev_softc));
-			iounmap((void *)((u_long)maddr & PAGE_MASK));
+			iounmap(maddr);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 			release_mem_region(ahc->platform_data->mem_busaddr,
 					   0x1000);
