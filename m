From: viro@parcelfarce.linux.theplanet.co.uk
Subject: [PATCH] aac7xxx iomem annotations
Date: Thu, 21 Oct 2004 00:56:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020235614.GA23987@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:33705 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270590AbUJTX4P
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 19:56:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

aic7xxx annotations - trivial part
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-3w-9xxx/drivers/scsi/aic7xxx/aic79xx_osm.h RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic79xx_osm.h
--- RC9-bk4-3w-9xxx/drivers/scsi/aic7xxx/aic79xx_osm.h	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic79xx_osm.h	Wed Oct 20 19:24:37 2004
@@ -145,7 +145,7 @@
 
 typedef union {
 	u_long		  ioport;
-	volatile uint8_t *maddr;
+	volatile uint8_t __iomem *maddr;
 } bus_space_handle_t;
 
 typedef struct bus_dma_segment
diff -urN RC9-bk4-3w-9xxx/drivers/scsi/aic7xxx/aic79xx_osm_pci.c RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- RC9-bk4-3w-9xxx/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	Wed Oct 20 19:24:37 2004
@@ -49,7 +49,7 @@
 						 u_long *base, u_long *base2);
 static int	ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
 						 u_long *bus_addr,
-						 uint8_t **maddr);
+						 uint8_t __iomem **maddr);
 static void	ahd_linux_pci_dev_remove(struct pci_dev *pdev);
 
 /* Define the macro locally since it's different for different class of chips.
@@ -245,7 +245,7 @@
 static int
 ahd_linux_pci_reserve_mem_region(struct ahd_softc *ahd,
 				 u_long *bus_addr,
-				 uint8_t **maddr)
+				 uint8_t __iomem **maddr)
 {
 	u_long	start;
 	u_long	base_page;
@@ -284,7 +284,7 @@
 {
 	uint32_t command;
 	u_long	 base;
-	uint8_t	*maddr;
+	uint8_t	__iomem *maddr;
 	int	 error;
 
 	/*
diff -urN RC9-bk4-3w-9xxx/drivers/scsi/aic7xxx/aic7xxx_osm.h RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic7xxx_osm.h
--- RC9-bk4-3w-9xxx/drivers/scsi/aic7xxx/aic7xxx_osm.h	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic7xxx_osm.h	Wed Oct 20 19:24:37 2004
@@ -157,7 +157,7 @@
 
 typedef union {
 	u_long		  ioport;
-	volatile uint8_t *maddr;
+	volatile uint8_t __iomem *maddr;
 } bus_space_handle_t;
 
 typedef struct bus_dma_segment
diff -urN RC9-bk4-3w-9xxx/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- RC9-bk4-3w-9xxx/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Wed Oct 20 10:56:03 2004
+++ RC9-bk4-aic-trivial/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Wed Oct 20 19:24:37 2004
@@ -54,7 +54,7 @@
 						u_long *base);
 static int	ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 						 u_long *bus_addr,
-						 uint8_t **maddr);
+						 uint8_t __iomem **maddr);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
 static void	ahc_linux_pci_dev_remove(struct pci_dev *pdev);
 
@@ -326,7 +326,7 @@
 static int
 ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 				 u_long *bus_addr,
-				 uint8_t **maddr)
+				 uint8_t __iomem **maddr)
 {
 	u_long	start;
 	u_long	base_page;
@@ -370,7 +370,7 @@
 {
 	uint32_t command;
 	u_long	 base;
-	uint8_t	*maddr;
+	uint8_t	__iomem *maddr;
 	int	 error;
 
 	/*
