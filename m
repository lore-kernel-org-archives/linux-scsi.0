From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] sym2 patchset
Date: Sat, 30 Aug 2003 20:08:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030830190851.GO13467@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:58009 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262024AbTH3TIx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Aug 2003 15:08:53 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.22)
	id 19tB5f-0003q7-Tu
	for linux-scsi@vger.kernel.org; Sat, 30 Aug 2003 20:08:51 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


A big pile of sym2-related changes.  I have most of them split apart in
CVS, so I can submit them as individual patches if anyone's interested.

Changelog:
 - Use pci_set_mwi() instead of trying to do it ourselves.
 - Rename PCI_ID_LSI53C1010 to 1010_33 and PCI_ID_LSI53C1010_2 to 1010_66.
 - Turn sym_udelay and sym_mdelay into macros.
 - Move the definition of sym53c8xx_lock near the functions that call it
   and remove the macros that wrapper it.
 - SYM_LINUX_DYNAMIC_DMA_MAPPING is always defined.  (Christoph Hellwig)
 - Remove first_host (Christoph Hellwig)
 - Support for hp C3000 (Grant Grundler)
 - Switch to using pci_name()
 - Remove the #if 0'd code from the pci_driver conversion.
 - Remove the sym_chip typedef.
 - Remove the pcifix option.
 - Remove a redundant printk on driver initialisation.
 - Use rmb() for __READ_BARRIER and wmb() for __WRITE_BARRIER
 - Increment the version to 2.1.17a.

Index: drivers/scsi/sym53c8xx_2/sym_conf.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h,v
retrieving revision 1.1
retrieving revision 1.2
diff -u -p -r1.1 -r1.2
--- drivers/scsi/sym53c8xx_2/sym_conf.h	29 Jul 2003 17:01:31 -0000	1.1
+++ drivers/scsi/sym53c8xx_2/sym_conf.h	26 Aug 2003 21:24:19 -0000	1.2
@@ -131,11 +131,6 @@
 /* #define SYM_CONF_IARB_SUPPORT */
 
 /*
- *  Support for some PCI fix-ups (or assumed so).
- */
-#define SYM_CONF_PCI_FIX_UP
-
-/*
  *  Number of lists for the optimization of the IO timeout handling.
  *  Not used under FreeBSD and Linux.
  */
Index: drivers/scsi/sym53c8xx_2/sym_defs.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_defs.h,v
retrieving revision 1.1
retrieving revision 1.2
diff -u -p -r1.1 -r1.2
--- drivers/scsi/sym53c8xx_2/sym_defs.h	29 Jul 2003 17:01:31 -0000	1.1
+++ drivers/scsi/sym53c8xx_2/sym_defs.h	25 Aug 2003 20:18:24 -0000	1.2
@@ -74,8 +74,8 @@
 #define PCI_ID_SYM53C896	0xb
 #define PCI_ID_SYM53C895A	0x12
 #define PCI_ID_SYM53C875A	0x13
-#define PCI_ID_LSI53C1010	0x20
-#define PCI_ID_LSI53C1010_2	0x21
+#define PCI_ID_LSI53C1010_33	0x20
+#define PCI_ID_LSI53C1010_66	0x21
 #define PCI_ID_LSI53C1510D	0xa
 
 /*
Index: drivers/scsi/sym53c8xx_2/sym_fw.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c,v
retrieving revision 1.1
retrieving revision 1.2
diff -u -p -r1.1 -r1.2
--- drivers/scsi/sym53c8xx_2/sym_fw.c	29 Jul 2003 17:01:31 -0000	1.1
+++ drivers/scsi/sym53c8xx_2/sym_fw.c	25 Aug 2003 20:18:24 -0000	1.2
@@ -270,13 +270,13 @@ sym_fw2_patch(hcb_p np)
 	 *  Remove a couple of work-arounds specific to C1010 if 
 	 *  they are not desirable. See `sym_fw2.h' for more details.
 	 */
-	if (!(np->device_id == PCI_ID_LSI53C1010_2 &&
+	if (!(np->device_id == PCI_ID_LSI53C1010_66 &&
 	      np->revision_id < 0x1 &&
 	      np->pciclk_khz < 60000)) {
 		scripta0->datao_phase[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->datao_phase[1] = cpu_to_scr(0);
 	}
-	if (!(np->device_id == PCI_ID_LSI53C1010 &&
+	if (!(np->device_id == PCI_ID_LSI53C1010_33 &&
 	      /* np->revision_id < 0xff */ 1)) {
 		scripta0->sel_done[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->sel_done[1] = cpu_to_scr(0);
Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.3
retrieving revision 1.9
diff -u -p -r1.3 -r1.9
--- drivers/scsi/sym53c8xx_2/sym_glue.c	23 Aug 2003 02:47:03 -0000	1.3
+++ drivers/scsi/sym53c8xx_2/sym_glue.c	29 Aug 2003 19:52:05 -0000	1.9
@@ -77,30 +77,6 @@ pci_get_base_address(struct pci_dev *pde
 #undef PCI_BAR_OFFSET
 }
 
-/*
- *  Insert a delay in micro-seconds and milli-seconds.
- */
-void sym_udelay(int us) { udelay(us); }
-void sym_mdelay(int ms) { mdelay(ms); }
-
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
-spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
-
-#define	SYM_LOCK_DRIVER(flags)    spin_lock_irqsave(&sym53c8xx_lock, flags)
-#define	SYM_UNLOCK_DRIVER(flags)  spin_unlock_irqrestore(&sym53c8xx_lock,flags)
-
 #define SYM_INIT_LOCK_HCB(np)		spin_lock_init((np)->s.host->host_lock);
 #define	SYM_LOCK_HCB(np, flags)		\
 			spin_lock_irqsave((np)->s.host->host_lock, flags)
@@ -118,6 +94,9 @@ spinlock_t sym53c8xx_lock = SPIN_LOCK_UN
 #define ktime_add(a, o)		((a) + (u_long)(o))
 #define ktime_sub(a, o)		((a) - (u_long)(o))
 
+/* This lock protects only the memory allocation/free.  */
+spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
+
 /*
  *  Wrappers to the generic memory allocator.
  */
@@ -125,53 +104,48 @@ void *sym_calloc(int size, char *name)
 {
 	u_long flags;
 	void *m;
-	SYM_LOCK_DRIVER(flags);
+	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	m = sym_calloc_unlocked(size, name);
-	SYM_UNLOCK_DRIVER(flags);
+	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
 	return m;
 }
 
 void sym_mfree(void *m, int size, char *name)
 {
 	u_long flags;
-	SYM_LOCK_DRIVER(flags);
+	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	sym_mfree_unlocked(m, size, name);
-	SYM_UNLOCK_DRIVER(flags);
+	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
 }
 
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
-
 void *__sym_calloc_dma(m_pool_ident_t dev_dmat, int size, char *name)
 {
 	u_long flags;
 	void *m;
-	SYM_LOCK_DRIVER(flags);
+	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	m = __sym_calloc_dma_unlocked(dev_dmat, size, name);
-	SYM_UNLOCK_DRIVER(flags);
+	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
 	return m;
 }
 
 void __sym_mfree_dma(m_pool_ident_t dev_dmat, void *m, int size, char *name)
 {
 	u_long flags;
-	SYM_LOCK_DRIVER(flags);
+	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	__sym_mfree_dma_unlocked(dev_dmat, m, size, name);
-	SYM_UNLOCK_DRIVER(flags);
+	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
 }
 
 m_addr_t __vtobus(m_pool_ident_t dev_dmat, void *m)
 {
 	u_long flags;
 	m_addr_t b;
-	SYM_LOCK_DRIVER(flags);
+	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	b = __vtobus_unlocked(dev_dmat, m);
-	SYM_UNLOCK_DRIVER(flags);
+	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
 	return b;
 }
 
-#endif	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
-
-
 /*
  *  Map/unmap a PCI memory window.
  */
@@ -192,12 +166,6 @@ static void __init pci_unmap_mem(u_long 
 }
 #endif
 
-/*
- *  Used to retrieve the host structure when the 
- *  driver is called from the proc FS.
- */
-static struct Scsi_Host	*first_host = NULL;
-
 #define scsi_data_direction(cmd)	(cmd->sc_data_direction)
 
 /*
@@ -210,11 +178,7 @@ struct host_data {
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
@@ -233,10 +197,8 @@ struct sym_eh_wait {
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
 	SYM_QUEHEAD link_cmdq;	/* Must stay at offset ZERO */
-#ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
 	bus_addr_t data_mapping;
 	u_char	data_mapped;
-#endif
 	struct sym_eh_wait *eh_wait;
 };
 
@@ -249,39 +211,18 @@ typedef struct sym_ucmd *ucmd_p;
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
 
@@ -345,8 +286,6 @@ static void __sync_scsi_data(struct pci_
 	}
 }
 
-#endif	/* SYM_LINUX_DYNAMIC_DMA_MAPPING */
-
 #define unmap_scsi_data(np, cmd)	\
 		__unmap_scsi_data(np->s.device, cmd)
 #define map_scsi_single_data(np, cmd)	\
@@ -1656,13 +1595,13 @@ static int sym_host_info(hcb_p np, char 
 	copy_info(&info, "Chip " NAME53C "%s, device id 0x%x, "
 			 "revision id 0x%x\n",
 			 np->s.chip_name, np->device_id, np->revision_id);
-	copy_info(&info, "On PCI bus %d, device %d, function %d, "
+	copy_info(&info, "At PCI address %s, "
 #ifdef __sparc__
 		"IRQ %s\n",
 #else
 		"IRQ %d\n",
 #endif
-		np->s.bus, (np->s.device_fn & 0xf8) >> 3, np->s.device_fn & 7,
+		pci_name(np->s.device),
 #ifdef __sparc__
 		__irq_itoa(np->s.irq));
 #else
@@ -1748,7 +1687,6 @@ static void sym_free_resources(hcb_p np)
 /*
  *  Ask/tell the system about DMA addressing.
  */
-#ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
 static int sym_setup_bus_dma_mask(hcb_p np)
 {
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 0
@@ -1780,7 +1718,6 @@ out_err32:
 			sym_name(np));
 	return -1;
 }
-#endif /* SYM_LINUX_DYNAMIC_DMA_MAPPING */
 
 /*
  *  Host attach and initialisations.
@@ -1802,15 +1739,14 @@ sym_attach (struct scsi_host_template *t
 	struct sym_fw *fw;
 
 	printk(KERN_INFO
-		"sym%d: <%s> rev 0x%x on pci bus %d device %d function %d "
+		"sym%d: <%s> rev 0x%x at pci %s "
 #ifdef __sparc__
 		"irq %s\n",
 #else
 		"irq %d\n",
 #endif
 		unit, dev->chip.name, dev->chip.revision_id,
-		dev->s.bus, (dev->s.device_fn & 0xf8) >> 3,
-		dev->s.device_fn & 7,
+		pci_name(dev->pdev),
 #ifdef __sparc__
 		__irq_itoa(dev->s.irq));
 #else
@@ -1837,7 +1773,6 @@ sym_attach (struct scsi_host_template *t
 	 *  We keep track in the HCB of all the resources that 
 	 *  are to be released on error.
 	 */
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
 	np = __sym_calloc_dma(dev->pdev, sizeof(*np), "HCB");
 	if (np) {
 		np->s.device = dev->pdev;
@@ -1845,11 +1780,6 @@ sym_attach (struct scsi_host_template *t
 	}
 	else
 		goto attach_failed;
-#else
-	np = sym_calloc_dma(sizeof(*np), "HCB");
-	if (!np)
-		goto attach_failed;
-#endif
 	host_data->ncb = np;
 	np->s.host = instance;
 
@@ -1866,8 +1796,6 @@ sym_attach (struct scsi_host_template *t
 	np->s.unit	= unit;
 	np->device_id	= dev->chip.device_id;
 	np->revision_id	= dev->chip.revision_id;
-	np->s.bus	= dev->s.bus;
-	np->s.device_fn	= dev->s.device_fn;
 	np->features	= dev->chip.features;
 	np->clock_divn	= dev->chip.nr_divisor;
 	np->maxoffs	= dev->chip.offset_max;
@@ -1883,10 +1811,8 @@ sym_attach (struct scsi_host_template *t
 	/*
 	 *  Ask/tell the system about DMA addressing.
 	 */
-#ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
 	if (sym_setup_bus_dma_mask(np))
 		goto attach_failed;
-#endif
 
 	/*
 	 *  Try to map the controller chip to
@@ -1987,12 +1913,6 @@ sym_attach (struct scsi_host_template *t
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
@@ -2087,37 +2007,6 @@ char *sym53c8xx = 0;	/* command line pas
 MODULE_PARM(sym53c8xx, "s");
 #endif
 
-static void __init sym53c8xx_print_driver_setup(void)
-{
-	printf_info (NAME53C8XX ": setup="
-		"mpar:%d,spar:%d,tags:%d,sync:%d,burst:%d,"
-		"led:%d,wide:%d,diff:%d,irqm:%d, buschk:%d\n",
-		sym_driver_setup.pci_parity,
-		sym_driver_setup.scsi_parity,
-		sym_driver_setup.max_tag,
-		sym_driver_setup.min_sync,
-		sym_driver_setup.burst_order,
-		sym_driver_setup.scsi_led,
-		sym_driver_setup.max_wide,
-		sym_driver_setup.scsi_diff,
-		sym_driver_setup.irq_mode,
-		sym_driver_setup.scsi_bus_check);
-	printf_info (NAME53C8XX ": setup="
-		"hostid:%d,offs:%d,luns:%d,pcifix:%d,revprob:%d,"
-		"verb:%d,debug:0x%x,setlle_delay:%d\n",
-		sym_driver_setup.host_id,
-		sym_driver_setup.max_offs,
-		sym_driver_setup.max_lun,
-		sym_driver_setup.pci_fix_up,
-		sym_driver_setup.reverse_probe,
-		sym_driver_setup.verbose,
-		sym_driver_setup.debug,
-		sym_driver_setup.settle_delay);
-#ifdef DEBUG_2_0_X
-MDELAY(5000);
-#endif
-};
-
 #define OPT_PCI_PARITY		1
 #define	OPT_SCSI_PARITY		2
 #define OPT_MAX_TAG		3
@@ -2131,15 +2020,13 @@ MDELAY(5000);
 #define	OPT_HOST_ID		11
 #define OPT_MAX_OFFS		12
 #define OPT_MAX_LUN		13
-#define OPT_PCI_FIX_UP		14
-
-#define OPT_REVERSE_PROBE	15
-#define OPT_VERBOSE		16
-#define OPT_DEBUG		17
-#define OPT_SETTLE_DELAY	18
-#define OPT_USE_NVRAM		19
-#define OPT_EXCLUDE		20
-#define OPT_SAFE_SETUP		21
+#define OPT_REVERSE_PROBE	14
+#define OPT_VERBOSE		15
+#define OPT_DEBUG		16
+#define OPT_SETTLE_DELAY	17
+#define OPT_USE_NVRAM		18
+#define OPT_EXCLUDE		19
+#define OPT_SAFE_SETUP		20
 
 static char setup_token[] __initdata =
 	"mpar:"		"spar:"
@@ -2148,11 +2035,10 @@ static char setup_token[] __initdata =
 	"wide:"		"diff:"
 	"irqm:"		"buschk:"
 	"hostid:"	"offset:"
-	"luns:"		"pcifix:"
-	"revprob:"	"verb:"
-	"debug:"	"settle:"
-	"nvram:"	"excl:"
-	"safe:"
+	"luns:"		"revprob:"
+	"verb:"		"debug:"
+	"settle:"	"nvram:"
+	"excl:"		"safe:"
 	;
 
 #ifdef MODULE
@@ -2239,7 +2125,6 @@ int __init sym53c8xx_setup(char *str)
 		__SIMPLE_OPTION(HOST_ID, host_id)
 		__SIMPLE_OPTION(MAX_OFFS, max_offs)
 		__SIMPLE_OPTION(MAX_LUN, max_lun)
-		__SIMPLE_OPTION(PCI_FIX_UP, pci_fix_up)
 		__SIMPLE_OPTION(REVERSE_PROBE, reverse_probe)
 		__SIMPLE_OPTION(VERBOSE, verbose)
 		__SIMPLE_OPTION(DEBUG, debug)
@@ -2272,16 +2157,13 @@ __setup("sym53c8xx=", sym53c8xx_setup);
 static int __init
 sym53c8xx_pci_init(struct pci_dev *pdev, sym_device *device)
 {
-	u_short vendor_id, device_id, command, status_reg;
-	u_char cache_line_size;
-	u_char suggested_cache_line_size = 0;
-	u_char pci_fix_up = SYM_SETUP_PCI_FIX_UP;
+	u_short vendor_id, device_id, status_reg;
 	u_char revision;
 	u_int irq;
 	u_long base, base_2; 
 	u_long base_c, base_2_c, io_port; 
 	int i;
-	sym_chip *chip;
+	struct sym_pci_chip *chip;
 
 	/* Choose some short name for this device */
 	sprintf(device->s.inst_name, "sym.%d.%d.%d", pdev->bus->number,
@@ -2393,25 +2275,6 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	pci_set_master(pdev);
 
 	/*
-	 *  Read additionnal info from the configuration space.
-	 */
-	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE,	&cache_line_size);
-
-	/*
-	 *  If cache line size is not configured, suggest
-	 *  a value for well known CPUs.
-	 */
-#if defined(__i386__) && !defined(MODULE)
-	if (!cache_line_size && boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
-		switch(boot_cpu_data.x86) {
-		case 4:	suggested_cache_line_size = 4;   break;
-		case 6: if (boot_cpu_data.x86_model > 8) break;
-		case 5:	suggested_cache_line_size = 8;   break;
-		}
-	}
-#endif	/* __i386__ */
-
-	/*
 	 *  Some features are required to be enabled in order to 
 	 *  work around some chip problems. :) ;)
 	 *  (ITEM 12 of a DEL about the 896 I haven't yet).
@@ -2420,31 +2283,12 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	 */
 	if (device_id == PCI_DEVICE_ID_NCR_53C896 && revision < 0x4) {
 		chip->features	|= (FE_WRIE | FE_CLSE);
-		pci_fix_up	|=  3;	/* Force appropriate PCI fix-up */
 	}
 
-#ifdef	SYM_CONF_PCI_FIX_UP
-	/*
-	 *  Try to fix up PCI config according to wished features.
-	 */
-	if ((pci_fix_up & 1) && (chip->features & FE_CLSE) && 
-	    !cache_line_size && suggested_cache_line_size) {
-		cache_line_size = suggested_cache_line_size;
-		pci_write_config_byte(pdev,
-				      PCI_CACHE_LINE_SIZE, cache_line_size);
-		printf_info("%s: PCI_CACHE_LINE_SIZE set to %d.\n",
-		            sym_name(device), cache_line_size);
-	}
-
-	pci_read_config_word(pdev, PCI_COMMAND,	&command);
-	if ((pci_fix_up & 2) && cache_line_size &&
-	    (chip->features & FE_WRIE) && !(command & PCI_COMMAND_INVALIDATE)) {
-		printf_info("%s: setting PCI_COMMAND_INVALIDATE.\n",
-		            sym_name(device));
-		command |= PCI_COMMAND_INVALIDATE;
-		pci_write_config_word(pdev, PCI_COMMAND, command);
+	if (chip->features & FE_WRIE) {
+		if (pci_set_mwi(pdev))
+			return -1;
 	}
-#endif	/* SYM_CONF_PCI_FIX_UP */
 
 	/*
 	 *  Work around for errant bit in 895A. The 66Mhz
@@ -2461,8 +2305,7 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	if (chip->features & FE_66MHZ) {
 		if (!(status_reg & PCI_STATUS_66MHZ))
 			chip->features &= ~FE_66MHZ;
-	}
-	else {
+	} else {
 		if (status_reg & PCI_STATUS_66MHZ) {
 			status_reg = PCI_STATUS_66MHZ;
 			pci_write_config_word(pdev, PCI_STATUS, status_reg);
@@ -2474,8 +2317,6 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	 *  Initialise device structure with items required by sym_attach.
 	 */
 	device->pdev		= pdev;
-	device->s.bus		= pdev->bus->number;
-	device->s.device_fn	= pdev->devfn;
 	device->s.base		= base;
 	device->s.base_2	= base_2;
 	device->s.base_c	= base_c;
@@ -2487,203 +2328,6 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	return 0;
 }
 
-#if 0
-/*
- *  Detect all 53c8xx hosts and then attach them.
- *
- *  If we are using NVRAM, once all hosts are detected, we need to 
- *  check any NVRAM for boot order in case detect and boot order 
- *  differ and attach them using the order in the NVRAM.
- *
- *  If no NVRAM is found or data appears invalid attach boards in 
- *  the order they are detected.
- */
-int __init sym53c8xx_detect(struct scsi_host_template *tpnt)
-{
-	struct pci_dev *pcidev;
-	int i, j, chips, hosts, count;
-	int attach_count = 0;
-	sym_device *devtbl, *devp;
-	sym_nvram  nvram;
-#if SYM_CONF_NVRAM_SUPPORT
-	sym_nvram  nvram0, *nvp;
-#endif
-
-	/*
-	 *    Initialize driver general stuff.
-	 */
-#ifdef SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT
-#ifdef MODULE
-if (sym53c8xx)
-	sym53c8xx_setup(sym53c8xx);
-#endif
-#ifdef SYM_LINUX_DEBUG_CONTROL_SUPPORT
-	sym_debug_flags = sym_driver_setup.debug;
-#endif
-	if (boot_verbose >= 2)
-		sym53c8xx_print_driver_setup();
-#endif /* SYM_LINUX_BOOT_COMMAND_LINE_SUPPORT */
-
-	/*
-	 *  Allocate the device table since we donnot want to 
-	 *  overflow the kernel stack.
-	 *  1 x 4K PAGE is enough for more than 40 devices for i386.
-	 */
-	devtbl = sym_calloc(PAGE_SIZE, "DEVTBL");
-	if (!devtbl)
-		return 0;
-
-	/*
-	 *  Detect all NCR PQS/PDS memory controllers.
-	 */
-#ifdef	SYM_CONF_PQS_PDS_SUPPORT
-	sym_detect_pqs_pds();
-#endif
-
-	/* 
-	 *  Detect all 53c8xx hosts.
-	 *  Save the first Symbios NVRAM content if any 
-	 *  for the boot order.
-	 */
-	chips	= sizeof(sym_chip_ids)	/ sizeof(sym_chip_ids[0]);
-	hosts	= PAGE_SIZE		/ sizeof(*devtbl);
-#if SYM_CONF_NVRAM_SUPPORT
-	nvp = (sym_driver_setup.use_nvram & 0x1) ? &nvram0 : 0;
-#endif
-	j = 0;
-	count = 0;
-	pcidev = NULL;
-	while (1) {
-		char *msg = "";
-		if (count >= hosts)
-			break;
-		if (j >= chips)
-			break;
-		i = sym_driver_setup.reverse_probe ? chips - 1 - j : j;
-		pcidev = pci_find_device(PCI_VENDOR_ID_NCR, sym_chip_ids[i],
-					 pcidev);
-		if (pcidev == NULL) {
-			++j;
-			continue;
-		}
-		/* This one is guaranteed by AC to do nothing :-) */
-		if (pci_enable_device(pcidev))
-			continue;
-		devp = &devtbl[count];
-		devp->host_id = SYM_SETUP_HOST_ID;
-		if (sym53c8xx_pci_init(pcidev, devp)) {
-			continue;
-		}
-		++count;
-#if SYM_CONF_NVRAM_SUPPORT
-		if (nvp) {
-			sym_get_nvram(devp, nvp);
-			switch(nvp->type) {
-			case SYM_SYMBIOS_NVRAM:
-				/*
-				 *   Switch to the other nvram buffer, so that 
-				 *   nvram0 will contain the first Symbios 
-				 *   format NVRAM content with boot order.
-				 */
-				nvp = &nvram;
-				msg = "with Symbios NVRAM";
-				break;
-			case SYM_TEKRAM_NVRAM:
-				msg = "with Tekram NVRAM";
-				break;
-			}
-		}
-#endif
-#ifdef	SYM_CONF_PQS_PDS_SUPPORT
-		/*
-		 *  Match the BUS number for PQS/PDS devices.
-		 *  Read the SCSI ID from a special register mapped
-		 *  into the configuration space of the individual
-		 *  875s.  This register is set up by the PQS bios
-		 */
-		for(i = 0; i < SYM_CONF_MAX_PQS_BUS && pqs_bus[i] != -1; i++) {
-			u_char tmp;
-			if (pqs_bus[i] == pcidev->bus->number) {
-				pci_read_config_byte(pcidev, 0x84, &tmp);
-				devp->pqs_pds = 1;
-				devp->host_id = tmp;
-				break;
-			}
-		}
-		if (devp->pqs_pds)
-			msg = "(NCR PQS/PDS)";
-#endif
-		if (boot_verbose)
-			printf_info("%s: 53c%s detected %s\n",
-			            sym_name(devp), devp->chip.name, msg);
-	}
-
-	/*
-	 *  If we have found a SYMBIOS NVRAM, use first the NVRAM boot 
-	 *  sequence as device boot order.
-	 *  check devices in the boot record against devices detected. 
-	 *  attach devices if we find a match. boot table records that 
-	 *  do not match any detected devices will be ignored. 
-	 *  devices that do not match any boot table will not be attached
-	 *  here but will attempt to be attached during the device table 
-	 *  rescan.
-	 */
-#if SYM_CONF_NVRAM_SUPPORT
-	if (!nvp || nvram0.type != SYM_SYMBIOS_NVRAM)
-		goto next;
-	for (i = 0; i < 4; i++) {
-		Symbios_host *h = &nvram0.data.Symbios.host[i];
-		for (j = 0 ; j < count ; j++) {
-			devp = &devtbl[j];
-			if (h->device_fn != devp->s.device_fn ||
-			    h->bus_nr	 != devp->s.bus	 ||
-			    h->device_id != devp->chip.device_id)
-				continue;
-			if (devp->attach_done)
-				continue;
-			if (h->flags & SYMBIOS_INIT_SCAN_AT_BOOT) {
-				sym_get_nvram(devp, nvp);
-				if (!sym_attach (tpnt, attach_count, devp))
-					attach_count++;
-			}
-			else if (!(sym_driver_setup.use_nvram & 0x80))
-				printf_info(
-				      "%s: 53c%s state OFF thus not attached\n",
-				      sym_name(devp), devp->chip.name);
-			else
-				continue;
-
-			devp->attach_done = 1;
-			break;
-		}
-	}
-next:
-#endif
-
-	/* 
-	 *  Rescan device list to make sure all boards attached.
-	 *  Devices without boot records will not be attached yet
-	 *  so try to attach them here.
-	 */
-	for (i= 0; i < count; i++) {
-		devp = &devtbl[i];
-		if (!devp->attach_done) {
-			devp->nvram = &nvram;
-			nvram.type = 0;
-#if SYM_CONF_NVRAM_SUPPORT
-			sym_get_nvram(devp, nvp);
-#endif
-			if (!sym_attach (tpnt, attach_count, devp))
-				attach_count++;
-		}
-	}
-
-	sym_mfree(devtbl, PAGE_SIZE, "DEVTBL");
-
-	return attach_count;
-}
-#endif
-
 
 /*
  *  Linux release module stuff.
@@ -2717,15 +2361,6 @@ static int sym_detach(hcb_p np)
 	return 1;
 }
 
-#if 0
-int sym53c8xx_release(struct Scsi_Host *host)
-{
-     sym_detach(((struct host_data *) host->hostdata)->ncb);
-
-     return 0;
-}
-#endif
-
 MODULE_LICENSE("Dual BSD/GPL");
 
 /*
@@ -2734,10 +2369,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 static struct scsi_host_template sym2_template = {
 	.module			= THIS_MODULE,
 	.name			= "sym53c8xx",
-#if 0
-	.detect			= sym53c8xx_detect,
-	.release		= sym53c8xx_release,
-#endif
 	.info			= sym53c8xx_info, 
 	.queuecommand		= sym53c8xx_queue_command,
 	.slave_configure	= sym53c8xx_slave_configure,
@@ -2839,7 +2470,6 @@ static int __devinit sym2_probe(struct p
 	sym_dev.host_id = SYM_SETUP_HOST_ID;
 	if (sym53c8xx_pci_init(pdev, &sym_dev))
 		return -ENODEV;
-	printk(KERN_INFO "%s: 53c%s detected\n", sym_name(&sym_dev), sym_dev.chip.name);
 
 	sym_dev.nvram = &nvram;
 	nvram.type = 0;
Index: drivers/scsi/sym53c8xx_2/sym_glue.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h,v
retrieving revision 1.3
retrieving revision 1.6
diff -u -p -r1.3 -r1.6
--- drivers/scsi/sym53c8xx_2/sym_glue.h	23 Aug 2003 02:47:03 -0000	1.3
+++ drivers/scsi/sym53c8xx_2/sym_glue.h	29 Aug 2003 19:49:00 -0000	1.6
@@ -111,8 +111,6 @@ typedef	u_long	vm_offset_t;
 /*
  * Configuration addendum for Linux.
  */
-#define	SYM_LINUX_DYNAMIC_DMA_MAPPING
-
 #define	SYM_CONF_TIMER_INTERVAL		((HZ+1)/2)
 
 #define SYM_OPT_HANDLE_DIR_UNKNOWN
@@ -121,10 +119,7 @@ typedef	u_long	vm_offset_t;
 #define SYM_OPT_SNIFF_INQUIRY
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #define	SYM_OPT_ANNOUNCE_TRANSFER_RATE
-
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
 #define	SYM_OPT_BUS_DMA_ABSTRACTION
-#endif
 
 /*
  *  Print a message with severity.
@@ -142,8 +137,8 @@ typedef	u_long	vm_offset_t;
 /*
  *  Insert a delay in micro-seconds and milli-seconds.
  */
-void sym_udelay(int us);
-void sym_mdelay(int ms);
+#define sym_udelay(us)	udelay(us)
+#define sym_mdelay(ms)	mdelay(ms)
 
 /*
  *  Let the compiler know about driver data structure names.
@@ -426,9 +421,6 @@ struct sym_shcb {
 
 	struct Scsi_Host *host;
 
-	u_char		bus;		/* PCI BUS number		*/
-	u_char		device_fn;	/* PCI BUS device and function	*/
-
 	vm_offset_t	mmio_va;	/* MMIO kernel virtual address	*/
 	vm_offset_t	ram_va;		/* RAM  kernel virtual address	*/
 	u_long		io_port;	/* IO port address cookie	*/
@@ -455,8 +447,6 @@ struct sym_shcb {
  *  used as sub-field 's' of another structure.
  */
 typedef struct {
-	int	bus;
-	u_char	device_fn;
 	u_long	base;
 	u_long	base_2;
 	u_long	base_c;
@@ -469,12 +459,11 @@ typedef struct {
 } sym_slot;
 
 typedef struct sym_nvram sym_nvram;
-typedef struct sym_pci_chip sym_chip;
 
 typedef struct {
 	struct pci_dev *pdev;
 	sym_slot  s;
-	sym_chip  chip;
+	struct sym_pci_chip chip;
 	sym_nvram *nvram;
 	u_short device_id;
 	u_char host_id;
@@ -496,9 +485,7 @@ typedef u_long m_addr_t;	/* Enough bits 
 #ifdef	MODULE
 #define SYM_MEM_FREE_UNUSED	/* Free unused pages immediately */
 #endif
-#ifdef	SYM_LINUX_DYNAMIC_DMA_MAPPING
 typedef struct pci_dev *m_pool_ident_t;
-#endif
 
 /*
  *  Include driver soft definitions.
@@ -521,19 +508,7 @@ typedef struct pci_dev *m_pool_ident_t;
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
@@ -560,14 +535,11 @@ static __inline void sym_m_free_dma_mem_
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
Index: drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.5
retrieving revision 1.8
diff -u -p -r1.5 -r1.8
--- drivers/scsi/sym53c8xx_2/sym_hipd.c	23 Aug 2003 02:47:03 -0000	1.5
+++ drivers/scsi/sym53c8xx_2/sym_hipd.c	29 Aug 2003 19:26:31 -0000	1.8
@@ -50,7 +50,7 @@
  * SUCH DAMAGE.
  */
 
-#define SYM_DRIVER_NAME	"sym-2.1.16a"
+#define SYM_DRIVER_NAME	"sym-2.1.17a"
 
 #ifdef __FreeBSD__
 #include <dev/sym/sym_glue.h>
@@ -289,7 +289,7 @@ int sym_reset_scsi_bus(hcb_p np, int ena
 		((INW(nc_sbdl) & 0xff00) << 10) |	/* d15-8    */
 		INB(nc_sbcl);	/* req ack bsy sel atn msg cd io    */
 
-	if (!(np->features & FE_WIDE))
+	if (!np->maxwide)
 		term &= 0x3ffff;
 
 	if (term != (2<<7)) {
@@ -744,6 +744,12 @@ static int sym_prepare_setting(hcb_p np,
 	u32	period;
 	int i;
 
+#ifdef CONFIG_PARISC
+	unsigned long pdc_period;
+	char scsi_mode = -1;
+	struct hardware_path hwpath;
+#endif
+
 	/*
 	 *  Wide ?
 	 */
@@ -800,6 +806,31 @@ static int sym_prepare_setting(hcb_p np,
 	 * Btw, 'period' is in tenths of nanoseconds.
 	 */
 	period = (4 * div_10M[0] + np->clock_khz - 1) / np->clock_khz;
+
+#if defined(CONFIG_PARISC)
+	/* Host firmware (PDC) keeps a table for crippling SCSI capabilities.
+	 * Many newer machines export one channel of 53c896 chip
+	 * as SE, 50-pin HD.  Also used for Multi-initiator SCSI clusters
+	 * to set the SCSI Initiator ID.
+	 */
+	get_pci_node_path(np->s.device, &hwpath);
+	if (pdc_get_initiator(&hwpath, &np->myaddr, &pdc_period, &np->maxwide, &scsi_mode))
+	{
+		if (scsi_mode >= 0) {
+			/* C3000 PDC reports period/mode */
+			SYM_SETUP_SCSI_DIFF = 0;
+			switch(scsi_mode) {
+			case 0:	np->scsi_mode = SMODE_SE; break;
+			case 1:	np->scsi_mode = SMODE_HVD; break;
+			case 2:	np->scsi_mode = SMODE_LVD; break;
+			default:	break;
+			}
+		}
+
+		period = (u32) pdc_period;
+	}
+#endif
+
 	if	(period <= 250)		np->minsync = 10;
 	else if	(period <= 303)		np->minsync = 11;
 	else if	(period <= 500)		np->minsync = 12;
@@ -862,7 +893,7 @@ static int sym_prepare_setting(hcb_p np,
 	 *  In dual channel mode, contention occurs if internal cycles
 	 *  are used. Disable internal cycles.
 	 */
-	if (np->device_id == PCI_ID_LSI53C1010 &&
+	if (np->device_id == PCI_ID_LSI53C1010_33 &&
 	    np->revision_id < 0x1)
 		np->rv_ccntl0	|=  DILS;
 
@@ -1362,17 +1393,17 @@ static struct sym_pci_chip sym_pci_dev_t
  FE_WIDE|FE_ULTRA|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ}
  ,
- {PCI_ID_LSI53C1010, 0x00, "1010-33", 6, 31, 7, 8,
+ {PCI_ID_LSI53C1010_33, 0x00, "1010-33", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
  FE_C10}
  ,
- {PCI_ID_LSI53C1010, 0xff, "1010-33", 6, 31, 7, 8,
+ {PCI_ID_LSI53C1010_33, 0xff, "1010-33", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
  FE_C10|FE_U3EN}
  ,
- {PCI_ID_LSI53C1010_2, 0xff, "1010-66", 6, 31, 7, 8,
+ {PCI_ID_LSI53C1010_66, 0xff, "1010-66", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_66MHZ|FE_CRC|
  FE_C10|FE_U3EN}
@@ -1809,7 +1840,7 @@ void sym_start_up (hcb_p np, int reason)
 	/*
 	 *  For now, disable AIP generation on C1010-66.
 	 */
-	if (np->device_id == PCI_ID_LSI53C1010_2)
+	if (np->device_id == PCI_ID_LSI53C1010_66)
 		OUTB (nc_aipcntl1, DISAIP);
 
 	/*
@@ -1819,7 +1850,7 @@ void sym_start_up (hcb_p np, int reason)
 	 *  that from SCRIPTS for each selection/reselection, but 
 	 *  I just don't want. :)
 	 */
-	if (np->device_id == PCI_ID_LSI53C1010 &&
+	if (np->device_id == PCI_ID_LSI53C1010_33 &&
 	    np->revision_id < 1)
 		OUTB (nc_stest1, INB(nc_stest1) | 0x30);
 
Index: drivers/scsi/sym53c8xx_2/sym_misc.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_misc.h,v
retrieving revision 1.1
retrieving revision 1.2
diff -u -p -r1.1 -r1.2
--- drivers/scsi/sym53c8xx_2/sym_misc.h	29 Jul 2003 17:01:31 -0000	1.1
+++ drivers/scsi/sym53c8xx_2/sym_misc.h	25 Aug 2003 16:14:32 -0000	1.2
@@ -77,23 +77,8 @@
  *  should be enough).
  */
 
-#if	defined	__i386__
-#define __READ_BARRIER()	\
-		__asm__ volatile("lock; addl $0,0(%%esp)": : :"memory")
-#define __WRITE_BARRIER()	__asm__ volatile ("": : :"memory")
-#elif	defined	__powerpc__
-#define __READ_BARRIER()	__asm__ volatile("eieio; sync" : : : "memory")
-#define __WRITE_BARRIER()	__asm__ volatile("eieio; sync" : : : "memory")
-#elif	defined	__ia64__
-#define __READ_BARRIER()	__asm__ volatile("mf.a; mf" : : : "memory")
-#define __WRITE_BARRIER()	__asm__ volatile("mf.a; mf" : : : "memory")
-#elif	defined	__alpha__
-#define __READ_BARRIER()	__asm__ volatile("mb": : :"memory")
-#define __WRITE_BARRIER()	__asm__ volatile("mb": : :"memory")
-#else
-#define __READ_BARRIER()	mb()
-#define __WRITE_BARRIER()	mb()
-#endif
+#define __READ_BARRIER()	rmb()
+#define __WRITE_BARRIER()	wmb()
 
 #ifndef MEMORY_READ_BARRIER
 #define MEMORY_READ_BARRIER()	__READ_BARRIER()

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
