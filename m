From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill some dead code in sym2
Date: Mon, 25 Aug 2003 15:21:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825132136.GA16634@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:59036 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261705AbTHYNVo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 09:21:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

No need to keep around the non-dma mapping code in 2.6


--- 1.31/drivers/scsi/sym53c8xx_2/sym_glue.c	Wed Aug 13 01:33:45 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon Aug 25 14:53:03 2003
@@ -139,8 +139,6 @@
 	SYM_UNLOCK_DRIVER(flags);
 }
 
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
-
 void *__sym_calloc_dma(m_pool_ident_t dev_dmat, int size, char *name)
 {
 	u_long flags;
@@ -169,9 +167,6 @@
 	return b;
 }
 
-#endif	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
-
-
 /*
  *  Map/unmap a PCI memory window.
  */
@@ -210,11 +199,7 @@
 /*
  * Some type that fit DMA addresses as seen from BUS.
  */
-#ifndef SYM_LINUX_DYNAMIC_DMA_MAPPING
-typedef u_long		bus_addr_t;
-#else
 typedef dma_addr_t	bus_addr_t;
-#endif
 
 /*
  *  Used by the eh thread to wait for command completion.
@@ -233,10 +218,8 @@
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
 	SYM_QUEHEAD link_cmdq;	/* Must stay at offset ZERO */
-#ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
 	bus_addr_t data_mapping;
 	u_char	data_mapped;
-#endif
 	struct sym_eh_wait *eh_wait;
 };
 
@@ -249,39 +232,18 @@
 /*
  *  Deal with DMA mapping/unmapping.
  */
-
-#ifndef SYM_LINUX_DYNAMIC_DMA_MAPPING
-
-/* Linux versions prior to pci bus iommu kernel interface */
-
-#define __unmap_scsi_data(pdev, cmd)	do {; } while (0)
-#define __map_scsi_single_data(pdev, cmd) (__vtobus(pdev,(cmd)->request_buffer))
-#define __map_scsi_sg_data(pdev, cmd)	((cmd)->use_sg)
-#define __sync_scsi_data(pdev, cmd)	do {; } while (0)
-
-#define bus_sg_dma_address(sc)		vtobus((sc)->address)
-#define bus_sg_dma_len(sc)		((sc)->length)
-
-#else /* Linux version with pci bus iommu kernel interface */
-
 #define	bus_unmap_sg(pdev, sgptr, sgcnt, dir)		\
 	pci_unmap_sg(pdev, sgptr, sgcnt, dir)
-
 #define	bus_unmap_single(pdev, mapping, bufptr, dir)	\
 	pci_unmap_single(pdev, mapping, bufptr, dir)
-
 #define	bus_map_single(pdev, bufptr, bufsiz, dir)	\
 	pci_map_single(pdev, bufptr, bufsiz, dir)
- 
 #define	bus_map_sg(pdev, sgptr, sgcnt, dir)		\
 	pci_map_sg(pdev, sgptr, sgcnt, dir)
-
 #define	bus_dma_sync_sg(pdev, sgptr, sgcnt, dir)	\
 	pci_dma_sync_sg(pdev, sgptr, sgcnt, dir)
-
 #define	bus_dma_sync_single(pdev, mapping, bufsiz, dir)	\
 	pci_dma_sync_single(pdev, mapping, bufsiz, dir)
-
 #define bus_sg_dma_address(sc)	sg_dma_address(sc)
 #define bus_sg_dma_len(sc)	sg_dma_len(sc)
 
@@ -345,8 +307,6 @@
 	}
 }
 
-#endif	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
-
 #define unmap_scsi_data(np, cmd)	\
 		__unmap_scsi_data(np->s.device, cmd)
 #define map_scsi_single_data(np, cmd)	\
@@ -1748,7 +1708,6 @@
 /*
  *  Ask/tell the system about DMA addressing.
  */
-#ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
 static int sym_setup_bus_dma_mask(hcb_p np)
 {
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 0
@@ -1780,7 +1739,6 @@
 			sym_name(np));
 	return -1;
 }
-#endif /* SYM_LINUX_DYNAMIC_DMA_MAPPING */
 
 /*
  *  Host attach and initialisations.
@@ -1837,7 +1795,6 @@
 	 *  We keep track in the HCB of all the resources that 
 	 *  are to be released on error.
 	 */
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
 	np = __sym_calloc_dma(dev->pdev, sizeof(*np), "HCB");
 	if (np) {
 		np->s.device = dev->pdev;
@@ -1845,11 +1802,7 @@
 	}
 	else
 		goto attach_failed;
-#else
-	np = sym_calloc_dma(sizeof(*np), "HCB");
-	if (!np)
-		goto attach_failed;
-#endif
+
 	host_data->ncb = np;
 	np->s.host = instance;
 
@@ -1883,10 +1836,8 @@
 	/*
 	 *  Ask/tell the system about DMA addressing.
 	 */
-#ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
 	if (sym_setup_bus_dma_mask(np))
 		goto attach_failed;
-#endif
 
 	/*
 	 *  Try to map the controller chip to
--- 1.11/drivers/scsi/sym53c8xx_2/sym_glue.h	Tue Jul 15 23:12:35 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.h	Mon Aug 25 14:51:50 2003
@@ -111,8 +111,6 @@
 /*
  * Configuration addendum for Linux.
  */
-#define	SYM_LINUX_DYNAMIC_DMA_MAPPING
-
 #define	SYM_CONF_TIMER_INTERVAL		((HZ+1)/2)
 
 #define SYM_OPT_HANDLE_DIR_UNKNOWN
@@ -121,10 +119,7 @@
 #define SYM_OPT_SNIFF_INQUIRY
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #define	SYM_OPT_ANNOUNCE_TRANSFER_RATE
-
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
 #define	SYM_OPT_BUS_DMA_ABSTRACTION
-#endif
 
 /*
  *  Print a message with severity.
@@ -496,9 +491,7 @@
 #ifdef	MODULE
 #define SYM_MEM_FREE_UNUSED	/* Free unused pages immediately */
 #endif
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
 typedef struct pci_dev *m_pool_ident_t;
-#endif
 
 /*
  *  Include driver soft definitions.
@@ -521,19 +514,7 @@
 void *sym_calloc(int size, char *name);
 void sym_mfree(void *m, int size, char *name);
 
-#ifndef	SYM_LINUX_DYNAMIC_DMA_MAPPING
 /*
- *  Simple case.
- *  All the memory assummed DMAable and O/S providing virtual 
- *  to bus physical address translation.
- */
-#define __sym_calloc_dma(pool_id, size, name)	sym_calloc(size, name)
-#define __sym_mfree_dma(pool_id, m, size, name)	sym_mfree(m, size, name)
-#define __vtobus(b, p)				virt_to_bus(p)
-
-#else	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
-/*
- *  Complex case.
  *  We have to provide the driver memory allocator with methods for 
  *  it to maintain virtual to bus physical address translations.
  */
@@ -560,14 +541,11 @@
 }
 
 #define sym_m_create_dma_mem_tag(mp)	(0)
-
 #define sym_m_delete_dma_mem_tag(mp)	do { ; } while (0)
 
 void *__sym_calloc_dma(m_pool_ident_t dev_dmat, int size, char *name);
 void __sym_mfree_dma(m_pool_ident_t dev_dmat, void *m, int size, char *name);
 m_addr_t __vtobus(m_pool_ident_t dev_dmat, void *m);
-
-#endif	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
 
 /*
  *  Set the status field of a CAM CCB.
