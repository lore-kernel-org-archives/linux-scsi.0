From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] make sym2 scan devices again
Date: Fri, 8 Aug 2003 21:07:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030808190754.GB17983@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:50562 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S271848AbTHHTH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 15:07:59 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

It needs a call to scsi_scan_host to find devices.  Also remove the
superflous scsi_set_device call - scsi_add_host does that for us.


diff -Nru a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Aug  8 11:11:33 2003
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Aug  8 11:11:33 2003
@@ -83,19 +83,6 @@
 void sym_udelay(int us) { udelay(us); }
 void sym_mdelay(int ms) { mdelay(ms); }
 
-/*
- *  SMP threading.
- *
- *  The whole SCSI sub-system under Linux is basically single-threaded.
- *  Everything, including low-level driver interrupt routine, happens 
- *  with the `io_request_lock' held.
- *  The sym53c8xx-1.x drivers series ran their interrupt code using a 
- *  spin mutex per controller. This added complexity without improving 
- *  scalability significantly. the sym-2 driver still use a spinlock 
- *  per controller for safety, but basically runs with the damned 
- *  io_request_lock held.
- */
-
 spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
 
 #define	SYM_LOCK_DRIVER(flags)    spin_lock_irqsave(&sym53c8xx_lock, flags)
@@ -139,8 +126,6 @@
 	SYM_UNLOCK_DRIVER(flags);
 }
 
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
-
 void *__sym_calloc_dma(m_pool_ident_t dev_dmat, int size, char *name)
 {
 	u_long flags;
@@ -169,9 +154,6 @@
 	return b;
 }
 
-#endif	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
-
-
 /*
  *  Map/unmap a PCI memory window.
  */
@@ -193,14 +175,6 @@
 #endif
 
 /*
- *  Used to retrieve the host structure when the 
- *  driver is called from the proc FS.
- */
-static struct Scsi_Host	*first_host = NULL;
-
-#define scsi_data_direction(cmd)	(cmd->sc_data_direction)
-
-/*
  *  Driver host data structure.
  */
 struct host_data {
@@ -208,15 +182,6 @@
 };
 
 /*
- * Some type that fit DMA addresses as seen from BUS.
- */
-#ifndef SYM_LINUX_DYNAMIC_DMA_MAPPING
-typedef u_long		bus_addr_t;
-#else
-typedef dma_addr_t	bus_addr_t;
-#endif
-
-/*
  *  Used by the eh thread to wait for command completion.
  *  It is allocated on the eh thread stack.
  */
@@ -233,10 +198,8 @@
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
 	SYM_QUEHEAD link_cmdq;	/* Must stay at offset ZERO */
-#ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
-	bus_addr_t data_mapping;
+	dma_addr_t data_mapping;
 	u_char	data_mapped;
-#endif
 	struct sym_eh_wait *eh_wait;
 };
 
@@ -250,20 +213,6 @@
  *  Deal with DMA mapping/unmapping.
  */
 
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
 
@@ -301,9 +250,9 @@
 	SYM_UCMD_PTR(cmd)->data_mapped = 0;
 }
 
-static bus_addr_t __map_scsi_single_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
+static dma_addr_t __map_scsi_single_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
-	bus_addr_t mapping;
+	dma_addr_t mapping;
 	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
 
 	mapping = bus_map_single(pdev, cmd->request_buffer,
@@ -345,8 +294,6 @@
 	}
 }
 
-#endif	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
-
 #define unmap_scsi_data(np, cmd)	\
 		__unmap_scsi_data(np->s.device, cmd)
 #define map_scsi_single_data(np, cmd)	\
@@ -536,7 +483,7 @@
 	cp->data_len = cmd->request_bufflen;
 
 	if (cmd->request_bufflen) {
-		bus_addr_t baddr = map_scsi_single_data(np, cmd);
+		dma_addr_t baddr = map_scsi_single_data(np, cmd);
 		if (baddr) {
 			sym_build_sge(np, data, baddr, cmd->request_bufflen);
 			segment = 1;
@@ -571,7 +518,7 @@
 		data = &cp->phys.data[SYM_CONF_MAX_SG - use_sg];
 
 		for (segment = 0; segment < use_sg; segment++) {
-			bus_addr_t baddr = bus_sg_dma_address(&scatter[segment]);
+			dma_addr_t baddr = bus_sg_dma_address(&scatter[segment]);
 			unsigned int len = bus_sg_dma_len(&scatter[segment]);
 
 			sym_build_sge(np, &data[segment], baddr, len);
@@ -693,7 +640,7 @@
 	/*
 	 *  No direction means no data.
 	 */
-	dir = scsi_data_direction(csio);
+	dir = csio->sc_data_direction;
 	if (dir != SCSI_DATA_NONE) {
 		cp->segments = sym_scatter (np, cp, csio);
 		if (cp->segments < 0) {
@@ -1748,7 +1695,6 @@
 /*
  *  Ask/tell the system about DMA addressing.
  */
-#ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
 static int sym_setup_bus_dma_mask(hcb_p np)
 {
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 0
@@ -1780,7 +1726,6 @@
 			sym_name(np));
 	return -1;
 }
-#endif /* SYM_LINUX_DYNAMIC_DMA_MAPPING */
 
 /*
  *  Host attach and initialisations.
@@ -1837,7 +1782,6 @@
 	 *  We keep track in the HCB of all the resources that 
 	 *  are to be released on error.
 	 */
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
 	np = __sym_calloc_dma(dev->pdev, sizeof(*np), "HCB");
 	if (np) {
 		np->s.device = dev->pdev;
@@ -1845,11 +1789,7 @@
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
 
@@ -1883,10 +1823,8 @@
 	/*
 	 *  Ask/tell the system about DMA addressing.
 	 */
-#ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
 	if (sym_setup_bus_dma_mask(np))
 		goto attach_failed;
-#endif
 
 	/*
 	 *  Try to map the controller chip to
@@ -1987,12 +1925,6 @@
 	sym_timer (np);
 
 	/*
-	 *  Done.
-	 */
-        if (!first_host)
-        	first_host = instance;
-
-	/*
 	 *  Fill Linux host instance structure
 	 *  and return success.
 	 */
@@ -2015,17 +1947,17 @@
 
 	SYM_UNLOCK_HCB(np, flags);
 
-	scsi_set_device(instance, &dev->pdev->dev);
-
 	/*
 	 *  Now let the generic SCSI driver
 	 *  look for the SCSI devices on the bus ..
 	 */
-	scsi_add_host(instance, &dev->pdev->dev);
+	scsi_add_host(instance, &dev->pdev->dev); /* XXX: handle failure */
+	scsi_scan_host(instance);
 	return 0;
 
 attach_failed:
-	if (!instance) return -1;
+	if (!instance)
+		return -1;
 	printf_info("%s: giving up ...\n", sym_name(np));
 	if (np)
 		sym_free_resources(np);
diff -Nru a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h	Fri Aug  8 11:11:33 2003
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h	Fri Aug  8 11:11:33 2003
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
@@ -521,17 +514,6 @@
 void *sym_calloc(int size, char *name);
 void sym_mfree(void *m, int size, char *name);
 
-#ifndef	SYM_LINUX_DYNAMIC_DMA_MAPPING
-/*
- *  Simple case.
- *  All the memory assummed DMAable and O/S providing virtual 
- *  to bus physical address translation.
- */
-#define __sym_calloc_dma(pool_id, size, name)	sym_calloc(size, name)
-#define __sym_mfree_dma(pool_id, m, size, name)	sym_mfree(m, size, name)
-#define __vtobus(b, p)				virt_to_bus(p)
-
-#else	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
 /*
  *  Complex case.
  *  We have to provide the driver memory allocator with methods for 
@@ -566,8 +548,6 @@
 void *__sym_calloc_dma(m_pool_ident_t dev_dmat, int size, char *name);
 void __sym_mfree_dma(m_pool_ident_t dev_dmat, void *m, int size, char *name);
 m_addr_t __vtobus(m_pool_ident_t dev_dmat, void *m);
-
-#endif	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
 
 /*
  *  Set the status field of a CAM CCB.
