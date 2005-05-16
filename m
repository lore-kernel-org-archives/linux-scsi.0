From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove dma_mask hacks
Date: Mon, 16 May 2005 20:54:12 +0200
Message-ID: <20050516185412.GE16811@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:53644 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261817AbVEPSyP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 14:54:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

pci_alloc_consistent is under 4G by default.  Also simplify the
definition of bus_dmamap_t.


Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-05-16 20:33:19.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-05-16 20:43:32.000000000 +0200
@@ -211,13 +211,11 @@
 	 && ahc_linux_get_memsize() > 0x80000000
 	 && pci_set_dma_mask(pdev, mask_39bit) == 0) {
 		ahc->flags |= AHC_39BIT_ADDRESSING;
-		ahc->platform_data->hw_dma_mask = mask_39bit;
 	} else {
 		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
                 	return (-ENODEV);
 		}
-		ahc->platform_data->hw_dma_mask = DMA_32BIT_MASK;
 	}
 	ahc->dev_softc = pci;
 	error = ahc_pci_config(ahc, entry);
Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-16 20:32:16.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-16 20:48:50.000000000 +0200
@@ -933,37 +933,11 @@
 ahc_dmamem_alloc(struct ahc_softc *ahc, bus_dma_tag_t dmat, void** vaddr,
 		 int flags, bus_dmamap_t *mapp)
 {
-	bus_dmamap_t map;
-
-	map = malloc(sizeof(*map), M_DEVBUF, M_NOWAIT);
-	if (map == NULL)
-		return (ENOMEM);
-	/*
-	 * Although we can dma data above 4GB, our
-	 * "consistent" memory is below 4GB for
-	 * space efficiency reasons (only need a 4byte
-	 * address).  For this reason, we have to reset
-	 * our dma mask when doing allocations.
-	 */
-	if (ahc->dev_softc != NULL)
-		if (pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
-			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
-			kfree(map);
-			return (ENODEV);
-		}
 	*vaddr = pci_alloc_consistent(ahc->dev_softc,
-				      dmat->maxsize, &map->bus_addr);
-	if (ahc->dev_softc != NULL)
-		if (pci_set_dma_mask(ahc->dev_softc,
-				     ahc->platform_data->hw_dma_mask)) {
-			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
-			kfree(map);
-			return (ENODEV);
-		}
+				      dmat->maxsize, mapp);
 	if (*vaddr == NULL)
-		return (ENOMEM);
-	*mapp = map;
-	return(0);
+		return ENOMEM;
+	return 0;
 }
 
 void
@@ -971,7 +945,7 @@
 		void* vaddr, bus_dmamap_t map)
 {
 	pci_free_consistent(ahc->dev_softc, dmat->maxsize,
-			    vaddr, map->bus_addr);
+			    vaddr, map);
 }
 
 int
@@ -985,7 +959,7 @@
 	 */
 	bus_dma_segment_t stack_sg;
 
-	stack_sg.ds_addr = map->bus_addr;
+	stack_sg.ds_addr = map;
 	stack_sg.ds_len = dmat->maxsize;
 	cb(cb_arg, &stack_sg, /*nseg*/1, /*error*/0);
 	return (0);
@@ -994,12 +968,6 @@
 void
 ahc_dmamap_destroy(struct ahc_softc *ahc, bus_dma_tag_t dmat, bus_dmamap_t map)
 {
-	/*
-	 * The map may is NULL in our < 2.3.X implementation.
-	 * Now it's 2.6.5, but just in case...
-	 */
-	BUG_ON(map == NULL);
-	free(map, M_DEVBUF);
 }
 
 int
@@ -1366,7 +1334,6 @@
 	TAILQ_INIT(&ahc->platform_data->completeq);
 	TAILQ_INIT(&ahc->platform_data->device_runq);
 	ahc->platform_data->irq = AHC_LINUX_NOIRQ;
-	ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
 	ahc_lockinit(ahc);
 	init_timer(&ahc->platform_data->completeq_timer);
 	ahc->platform_data->completeq_timer.data = (u_long)ahc;
Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-05-16 20:10:23.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-05-16 20:46:56.000000000 +0200
@@ -178,11 +178,7 @@
 };
 typedef struct ahc_linux_dma_tag* bus_dma_tag_t;
 
-struct ahc_linux_dmamap
-{
-	dma_addr_t	bus_addr;
-};
-typedef struct ahc_linux_dmamap* bus_dmamap_t;
+typedef dma_addr_t bus_dmamap_t;
 
 typedef int bus_dma_filter_t(void*, dma_addr_t);
 typedef void bus_dmamap_callback_t(void *, bus_dma_segment_t *, int, int);
@@ -483,7 +479,6 @@
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
 	uint32_t		 mem_busaddr;	/* Mem Base Addr */
-	uint64_t		 hw_dma_mask;
 	ahc_linux_softc_flags	 flags;
 };
 
