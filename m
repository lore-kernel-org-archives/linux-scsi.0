From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic79xx: remove some dead code
Date: Mon, 15 Aug 2005 13:27:39 +0200
Message-ID: <20050815112739.GA17458@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:20686 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932669AbVHOL1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 07:27:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

remove some dead cruft, as done already in aic7xxx


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.h	2005-08-13 14:37:53.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h	2005-08-13 14:50:08.000000000 +0200
@@ -254,39 +254,8 @@
 /***************************** SMP support ************************************/
 #include <linux/spinlock.h>
 
-#define AHD_SCSI_HAS_HOST_LOCK 1
-
 #define AIC79XX_DRIVER_VERSION "1.3.11"
 
-/**************************** Front End Queues ********************************/
-/*
- * Data structure used to cast the Linux struct scsi_cmnd to something
- * that allows us to use the queue macros.  The linux structure has
- * plenty of space to hold the links fields as required by the queue
- * macros, but the queue macors require them to have the correct type.
- */
-struct ahd_cmd_internal {
-	/* Area owned by the Linux scsi layer. */
-	uint8_t	private[offsetof(struct scsi_cmnd, SCp.Status)];
-	union {
-		STAILQ_ENTRY(ahd_cmd)	ste;
-		LIST_ENTRY(ahd_cmd)	le;
-		TAILQ_ENTRY(ahd_cmd)	tqe;
-	} links;
-	uint32_t			end;
-};
-
-struct ahd_cmd {
-	union {
-		struct ahd_cmd_internal	icmd;
-		struct scsi_cmnd	scsi_cmd;
-	} un;
-};
-
-#define acmd_icmd(cmd) ((cmd)->un.icmd)
-#define acmd_scsi_cmd(cmd) ((cmd)->un.scsi_cmd)
-#define acmd_links un.icmd.links
-
 /*************************** Device Data Structures ***************************/
 /*
  * A per probed device structure used to deal with some error recovery
@@ -297,13 +266,10 @@
  */
 
 typedef enum {
-	AHD_DEV_UNCONFIGURED	 = 0x01,
 	AHD_DEV_FREEZE_TIL_EMPTY = 0x02, /* Freeze queue until active == 0 */
-	AHD_DEV_TIMER_ACTIVE	 = 0x04, /* Our timer is active */
 	AHD_DEV_Q_BASIC		 = 0x10, /* Allow basic device queuing */
 	AHD_DEV_Q_TAGGED	 = 0x20, /* Allow full SCSI2 command queueing */
 	AHD_DEV_PERIODIC_OTAG	 = 0x40, /* Send OTAG to prevent starvation */
-	AHD_DEV_SLAVE_CONFIGURED = 0x80	 /* slave_configure() has been called */
 } ahd_linux_dev_flags;
 
 struct ahd_linux_target;
@@ -432,7 +398,6 @@
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
 	uint32_t		 mem_busaddr;	/* Mem Base Addr */
-	uint64_t		 hw_dma_mask;
 #define	AHD_SCB_UP_EH_SEM 0x1
 	uint32_t		 flags;
 };
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2005-08-13 14:37:53.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2005-08-13 14:50:08.000000000 +0200
@@ -177,15 +177,12 @@
 		if (memsize >= 0x8000000000ULL
 	 	 && pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0) {
 			ahd->flags |= AHD_64BIT_ADDRESSING;
-			ahd->platform_data->hw_dma_mask = DMA_64BIT_MASK;
 		} else if (memsize > 0x80000000
 			&& pci_set_dma_mask(pdev, mask_39bit) == 0) {
 			ahd->flags |= AHD_39BIT_ADDRESSING;
-			ahd->platform_data->hw_dma_mask = mask_39bit;
 		}
 	} else {
 		pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-		ahd->platform_data->hw_dma_mask = DMA_32BIT_MASK;
 	}
 	ahd->dev_softc = pci;
 	error = ahd_pci_config(ahd, entry);
