From: Matthew Wilcox <willy@debian.org>
Subject: sym53c8xx driver 2.1.18
Date: Tue, 9 Sep 2003 02:44:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030909014403.GA18654@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:4992 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263602AbTIIBoF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2003 21:44:05 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.22)
	id 19wXY3-0002ZX-PJ
	for linux-scsi@vger.kernel.org; Tue, 09 Sep 2003 02:44:03 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Yes, there's a lot of changes here.  I've been busy :-P

 - Delete linux/version.h include as it's not necessary
 - Delete compatibility with ncr53c8xx configuration options
 - Convert to C99 initialisers
 - Delete the options: pci_parity, scsi_parity, min_sync, max_wide,
   max_offs, max_lun and pci_fix_up.  Some were unused, some are now
   unused.
 - Delete all the default settings from sym_conf.h that were unused.
 - Delete host_lock abstractions.
 - Replace custom jiffy handling with standard ones.
 - Replace u_long with unsigned long
 - Inline scsi_data_direction()
 - Use ioremap directly instead of indirecting through pci_map_mem.
 - Delete typedefs: bus_addr_t, ucmd_p, vm_offset_t, stcb_p,
   slcb_p, sccb_p, shcb_p, sym_device and sym_slot.
 - Use min() instead of MIN()
 - Use memcpy() instead of bcopy().
 - Delete code dependent on SYM_CONF_PCIQ_BROKEN_INTR as it's never defined.
 - Simplify the locking in sym_eh_handler().
 - Make the eh handlers static.
 - Use ctype.h instead of custom variants.
 - Use SYM_CONF_IOMAPPED and SYM_OPT_NO_BUS_MEMORY_MAPPING in a more
   consistent manner.
 - Remove check_region() and use pci_request_region instead.
 - Mark sym_detach() as __devexit.
 - Move many includes from sym_glue.h to sym_glue.c
 - Stop using Scsi_Cmnd.
 - Stop using ../hosts.h.
 - Simplify *_raw definitions.
 - Move PA-RISC specific code into its own function.

Index: drivers/scsi/sym53c8xx_2/sym53c8xx.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h,v
retrieving revision 1.5
retrieving revision 1.6
diff -u -p -r1.5 -r1.6
--- drivers/scsi/sym53c8xx_2/sym53c8xx.h	8 Sep 2003 21:42:21 -0000	1.5
+++ drivers/scsi/sym53c8xx_2/sym53c8xx.h	8 Sep 2003 22:00:25 -0000	1.6
@@ -53,38 +53,9 @@
 #ifndef SYM53C8XX_H
 #define SYM53C8XX_H
 
-#if !defined(LINUX_VERSION_CODE)
-#include <linux/version.h>
-#endif
 #include <linux/config.h>
 
 /*
- *  Compatibility with ncr53c8xx and sym53c8xx configuration options.
- */
-#ifndef	CONFIG_SCSI_SYM53C8XX_IOMAPPED
-#ifdef	CONFIG_SCSI_NCR53C8XX_IOMAPPED
-#define	CONFIG_SCSI_SYM53C8XX_IOMAPPED		CONFIG_SCSI_NCR53C8XX_IOMAPPED
-#endif
-#endif
-
-#ifndef	CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS
-#ifdef	CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS
-#define	CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS	CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS
-#endif
-#endif
-
-#ifndef	CONFIG_SCSI_SYM53C8XX_MAX_TAGS
-#ifdef	CONFIG_SCSI_NCR53C8XX_MAX_TAGS
-#define	CONFIG_SCSI_SYM53C8XX_MAX_TAGS		CONFIG_SCSI_NCR53C8XX_MAX_TAGS
-#endif
-#endif
-
-/*
- *  Translate kernel configuration parameters
- *  into corresponding driver parameters.
- */
-
-/*
  *  Use normal IO if configured.
  *  Normal IO forced for alpha.
  *  Forced to MMIO for sparc.
@@ -108,9 +79,7 @@
  *  2 : 64 bit addressing when supported by chip,
  *      limited to 16 segments of 4 GB -> 64 GB max.
  */
-#ifdef	CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE
 #define	SYM_CONF_DMA_ADDRESSING_MODE CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE
-#endif
 
 /*
  *  NCR PQS/PDS special device support.
@@ -175,47 +144,24 @@
 #endif
 
 /*
- *  Sync transfer frequency at startup.
- *  Allow up to ULTRA-160. The driver will scale the value 
- *  according to controller capabilities.
- */
-#define	CONFIG_SCSI_SYM53C8XX_DEFAULT_SYNC (9)
-
-/*
  *  Max number of SG entries.
  */
 #define SYM_CONF_MAX_SG		(96)
 
 /*
- *  Max number of LUNs per target.
- */
-#if 1 /* defined CONFIG_SCSI_MULTI_LUN */
-#define	CONFIG_SCSI_SYM53C8XX_MAX_LUN	(16)
-#else
-#define	CONFIG_SCSI_SYM53C8XX_MAX_LUN	(1)
-#endif
-
-/*
  *  Driver setup structure.
  *
  *  This structure is initialized from linux config options.
  *  It can be overridden at boot-up by the boot command line.
  */
 struct sym_driver_setup {
-	u_char	pci_parity;
-	u_char	scsi_parity;
 	u_short	max_tag;
-	u_char	min_sync;
 	u_char	burst_order;
 	u_char	scsi_led;
-	u_char	max_wide;
 	u_char	scsi_diff;
 	u_char	irq_mode;
 	u_char	scsi_bus_check;
 	u_char	host_id;
-	u_char	max_offs;
-	u_char	max_lun;
-	u_char	pci_fix_up;
 
 	u_char	reverse_probe;
 	u_char	verbose;
@@ -226,47 +172,36 @@ struct sym_driver_setup {
 	char	tag_ctrl[100];
 };
 
-#define SYM_SETUP_PCI_PARITY		sym_driver_setup.pci_parity
-#define SYM_SETUP_SCSI_PARITY		sym_driver_setup.scsi_parity
 #define SYM_SETUP_MAX_TAG		sym_driver_setup.max_tag
-#define SYM_SETUP_MIN_SYNC		sym_driver_setup.min_sync
 #define SYM_SETUP_BURST_ORDER		sym_driver_setup.burst_order
 #define SYM_SETUP_SCSI_LED		sym_driver_setup.scsi_led
-#define SYM_SETUP_MAX_WIDE		sym_driver_setup.max_wide
 #define SYM_SETUP_SCSI_DIFF		sym_driver_setup.scsi_diff
 #define SYM_SETUP_IRQ_MODE		sym_driver_setup.irq_mode
 #define SYM_SETUP_SCSI_BUS_CHECK	sym_driver_setup.scsi_bus_check
 #define SYM_SETUP_HOST_ID		sym_driver_setup.host_id
-#define SYM_SETUP_MAX_OFFS		sym_driver_setup.max_offs
-#define SYM_SETUP_MAX_LUN		sym_driver_setup.max_lun
-#define SYM_SETUP_PCI_FIX_UP		sym_driver_setup.pci_fix_up
+
+/* Always enable parity. */
+#define SYM_SETUP_PCI_PARITY		1
+#define SYM_SETUP_SCSI_PARITY		1
 
 /*
  *  Initial setup.
  *
  *  Can be overriden at startup by a command line.
  */
-#define SYM_LINUX_DRIVER_SETUP			\
-{						\
-	1,	/* pci_parity */		\
-	1,	/* scsi_parity */		\
-	CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS,	\
-	CONFIG_SCSI_SYM53C8XX_DEFAULT_SYNC,	\
-	7,	/* burst_order */		\
-	1,	/* scsi_led */			\
-	1,	/* max_wide */			\
-	1,	/* scsi_diff */			\
-	0,	/* irq_mode */			\
-	1,	/* scsi_bus_check */		\
-	7,	/* host_id */			\
-	62,	/* max_offs */			\
-	CONFIG_SCSI_SYM53C8XX_MAX_LUN,		\
-	3,	/* pci_fix_up */		\
-	0,	/* reverse_probe */		\
-	0,	/* verbose */			\
-	0,	/* debug */			\
-	3,	/* settle_delay */		\
-	1,	/* use_nvram */			\
+#define SYM_LINUX_DRIVER_SETUP	{				\
+	.max_tag	= CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS,	\
+	.burst_order	= 7,					\
+	.scsi_led	= 1,					\
+	.scsi_diff	= 1,					\
+	.irq_mode	= 0,					\
+	.scsi_bus_check	= 1,					\
+	.host_id	= 7,					\
+	.reverse_probe	= 0,					\
+	.verbose	= 0,					\
+	.debug		= 0,					\
+	.settle_delay	= 3,					\
+	.use_nvram	= 1,					\
 }
 
 /*
@@ -275,27 +210,19 @@ struct sym_driver_setup {
  *  Override initial setup from boot command line:
  *    sym53c8xx=safe:y
  */
-#define SYM_LINUX_DRIVER_SAFE_SETUP		\
-{						\
-	0,	/* pci_parity */		\
-	0,	/* scsi_parity */		\
-	0,	/* max_tag */			\
-	50,	/* min_sync */			\
-	0,	/* burst_order */		\
-	0,	/* scsi_led */			\
-	1,	/* max_wide */			\
-	1,	/* scsi_diff */			\
-	0,	/* irq_mode */			\
-	2,	/* scsi_bus_check */		\
-	7,	/* host_id */			\
-	15,	/* max_offs */			\
-	1,	/* max_lun */			\
-	0,	/* pci_fix_up */		\
-	0,	/* reverse_probe */		\
-	2,	/* verbose */			\
-	0,	/* debug */			\
-	10,	/* settle_delay */		\
-	1,	/* use_nvram */			\
+#define SYM_LINUX_DRIVER_SAFE_SETUP {				\
+	.max_tag	= 0,					\
+	.burst_order	= 0,					\
+	.scsi_led	= 0,					\
+	.scsi_diff	= 1,					\
+	.irq_mode	= 0,					\
+	.scsi_bus_check	= 2,					\
+	.host_id	= 7,					\
+	.reverse_probe	= 0,					\
+	.verbose	= 2,					\
+	.debug		= 0,					\
+	.settle_delay	= 10,					\
+	.use_nvram	= 1,					\
 }
 
 /*
Index: drivers/scsi/sym53c8xx_2/sym_conf.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_conf.h,v
retrieving revision 1.5
retrieving revision 1.6
diff -u -p -r1.5 -r1.6
--- drivers/scsi/sym53c8xx_2/sym_conf.h	8 Sep 2003 21:42:21 -0000	1.5
+++ drivers/scsi/sym53c8xx_2/sym_conf.h	8 Sep 2003 22:00:25 -0000	1.6
@@ -53,39 +53,7 @@
 #ifndef SYM_CONF_H
 #define SYM_CONF_H
 
-/*-------------------------------------------------------------------
- *  Static configuration.
- *-------------------------------------------------------------------
- */
-
-/*
- *  Also support early NCR 810, 815 and 825 chips.
- */
-#ifndef SYM_CONF_GENERIC_SUPPORT
-#define SYM_CONF_GENERIC_SUPPORT	(1)
-#endif
-
-/*
- *  Use Normal IO instead of MMIO.
- */
-/* #define SYM_CONF_IOMAPPED */
-
-/*
- *  Max tags for a device (logical unit)
- * 	We use a power of 2, (7) means 2<<7=128
- *  Maximum is 8 -> 256 tags
- */
-#ifndef SYM_CONF_MAX_TAG_ORDER
-#define SYM_CONF_MAX_TAG_ORDER	(6)
-#endif
-
-/*
- *  Max number of scatter/gather entries for en IO.
- *  Each entry costs 8 bytes in the internal CCB data structure.
- */
-#ifndef SYM_CONF_MAX_SG
-#define SYM_CONF_MAX_SG		(33)
-#endif
+#include "sym53c8xx.h"
 
 /*
  *  Max number of targets.
@@ -118,13 +86,6 @@
 /* #define SYM_CONF_MAX_START	(PAGE_SIZE/8 - 16) */
 
 /*
- *  Support for NVRAM.
- */
-#ifndef SYM_CONF_NVRAM_SUPPORT
-#define SYM_CONF_NVRAM_SUPPORT		(1)
-#endif
-
-/*
  *  Support for Immediate Arbitration.
  *  Not advised.
  */
@@ -139,148 +100,6 @@
 #endif
 
 /*
- *  How the driver handles DMA addressing of user data.
- *  0 :	32 bit addressing
- *  1 :	40 bit addressing
- *  2 :	64 bit addressing using segment registers
- */
-#ifndef SYM_CONF_DMA_ADDRESSING_MODE
-#define SYM_CONF_DMA_ADDRESSING_MODE	(0)
-#endif
-
-/*-------------------------------------------------------------------
- *  Configuration that could be dynamic if it was possible 
- *  to pass arguments to the driver.
- *-------------------------------------------------------------------
- */
-
-/*
- *  HOST default scsi id.
- */
-#ifndef SYM_SETUP_HOST_ID
-#define SYM_SETUP_HOST_ID	7
-#endif
-
-/*
- *  Max synchronous transfers.
- */
-#ifndef SYM_SETUP_MIN_SYNC
-#define SYM_SETUP_MIN_SYNC	(9)
-#endif
-
-/*
- *  Max wide order.
- */
-#ifndef SYM_SETUP_MAX_WIDE
-#define SYM_SETUP_MAX_WIDE	(1)
-#endif
-
-/*
- *  Max SCSI offset.
- */
-#ifndef SYM_SETUP_MAX_OFFS
-#define SYM_SETUP_MAX_OFFS	(63)
-#endif
-
-/*
- *  Default number of tags.
- */
-#ifndef SYM_SETUP_MAX_TAG
-#define SYM_SETUP_MAX_TAG	(1<<SYM_CONF_MAX_TAG_ORDER)
-#endif
-
-/*
- *  SYMBIOS NVRAM format support.
- */
-#ifndef SYM_SETUP_SYMBIOS_NVRAM
-#define SYM_SETUP_SYMBIOS_NVRAM	(1)
-#endif
-
-/*
- *  TEKRAM NVRAM format support.
- */
-#ifndef SYM_SETUP_TEKRAM_NVRAM
-#define SYM_SETUP_TEKRAM_NVRAM	(1)
-#endif
-
-/*
- *  PCI parity checking.
- *  It should not be an option, but some poor or broken 
- *  PCI-HOST bridges have been reported to make problems 
- *  when this feature is enabled.
- *  Setting this option to 0 tells the driver not to 
- *  enable the checking against PCI parity.
- */
-#ifndef SYM_SETUP_PCI_PARITY
-#define SYM_SETUP_PCI_PARITY	(2)
-#endif
-
-/*
- *  SCSI parity checking.
- */
-#ifndef SYM_SETUP_SCSI_PARITY
-#define SYM_SETUP_SCSI_PARITY	(1)
-#endif
-
-/*
- *  SCSI activity LED.
- */
-#ifndef SYM_SETUP_SCSI_LED
-#define SYM_SETUP_SCSI_LED	(0)
-#endif
-
-/*
- *  SCSI High Voltage Differential support.
- *
- *  HVD/LVD/SE capable controllers (895, 895A, 896, 1010) 
- *  report the actual SCSI BUS mode from the STEST4 IO 
- *  register.
- *
- *  But for HVD/SE only capable chips (825a, 875, 885), 
- *  the driver uses some heuristic to probe against HVD. 
- *  Normally, the chip senses the DIFFSENS signal and 
- *  should switch its BUS transceivers to high impedance 
- *  in situation of the driver having been wrong about 
- *  the actual BUS mode. May-be, the BUS mode probing of 
- *  the driver is safe, but, given that it may be partially 
- *  based on some previous IO register settings, it 
- *  cannot be stated so. Thus, decision has been taken 
- *  to require a user option to be set for the DIFF probing 
- *  to be applied for the 825a, 875 and 885 chips.
- *  
- *  This setup option works as follows:
- *
- *    0  ->  HVD only supported for 895, 895A, 896, 1010.
- *    1  ->  HVD probed  for 825A, 875, 885.
- *    2  ->  HVD assumed for 825A, 875, 885 (not advised).
- */
-#ifndef SYM_SETUP_SCSI_DIFF
-#define SYM_SETUP_SCSI_DIFF	(0)
-#endif
-
-/*
- *  IRQ mode.
- */
-#ifndef SYM_SETUP_IRQ_MODE
-#define SYM_SETUP_IRQ_MODE	(0)
-#endif
-
-/*
- *  Check SCSI BUS signal on reset.
- */
-#ifndef SYM_SETUP_SCSI_BUS_CHECK
-#define SYM_SETUP_SCSI_BUS_CHECK (1)
-#endif
-
-/*
- *  Max burst for PCI (1<<value)
- *  7 means: (1<<7) = 128 DWORDS.
- */
-#ifndef SYM_SETUP_BURST_ORDER
-#define SYM_SETUP_BURST_ORDER	(7)
-#endif
-
-/*
  *  Only relevant if IARB support configured.
  *  - Max number of successive settings of IARB hints.
  *  - Set IARB on arbitration lost.
@@ -307,18 +126,6 @@
  */
 #ifndef SYM_SETUP_MAX_LUN
 #define SYM_SETUP_MAX_LUN	(8)
-#endif
-
-/*
- *  Bits indicating what kind of fix-ups we want.
- *
- *  Bit 0 (1) : cache line size configuration register.
- *  Bit 1 (2) : MWI bit in command register.
- *  Bit 2 (4) : latency timer if seems too low.
- */
-
-#ifndef SYM_SETUP_PCI_FIX_UP
-#define SYM_SETUP_PCI_FIX_UP (3)
 #endif
 
 #endif /* SYM_CONF_H */
Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.29
retrieving revision 1.30
diff -u -p -r1.29 -r1.30
--- drivers/scsi/sym53c8xx_2/sym_glue.c	8 Sep 2003 21:42:21 -0000	1.29
+++ drivers/scsi/sym53c8xx_2/sym_glue.c	8 Sep 2003 22:00:25 -0000	1.30
@@ -51,7 +51,12 @@
  */
 #define SYM_GLUE_C
 
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/spinlock.h>
+#include <scsi/scsi.h>
 #include "sym_glue.h"
 
 #define NAME53C		"sym53c"
@@ -77,23 +82,6 @@ pci_get_base_address(struct pci_dev *pde
 #undef PCI_BAR_OFFSET
 }
 
-#define SYM_INIT_LOCK_HCB(np)		spin_lock_init((np)->s.host->host_lock);
-#define	SYM_LOCK_HCB(np, flags)		\
-			spin_lock_irqsave((np)->s.host->host_lock, flags)
-#define	SYM_UNLOCK_HCB(np, flags)	\
-			spin_unlock_irqrestore((np)->s.host->host_lock, flags)
-
-/*
- *  These simple macros limit expression involving 
- *  kernel time values (jiffies) to some that have 
- *  chance not to be too much incorrect. :-)
- */
-#define ktime_get(o)		(jiffies + (u_long) o)
-#define ktime_exp(b)		((long)(jiffies) - (long)(b) >= 0)
-#define ktime_dif(a, b)		((long)(a) - (long)(b))
-#define ktime_add(a, o)		((a) + (u_long)(o))
-#define ktime_sub(a, o)		((a) - (u_long)(o))
-
 /* This lock protects only the memory allocation/free.  */
 spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
 
@@ -102,7 +90,7 @@ spinlock_t sym53c8xx_lock = SPIN_LOCK_UN
  */
 void *sym_calloc(int size, char *name)
 {
-	u_long flags;
+	unsigned long flags;
 	void *m;
 	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	m = sym_calloc_unlocked(size, name);
@@ -112,7 +100,7 @@ void *sym_calloc(int size, char *name)
 
 void sym_mfree(void *m, int size, char *name)
 {
-	u_long flags;
+	unsigned long flags;
 	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	sym_mfree_unlocked(m, size, name);
 	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
@@ -120,7 +108,7 @@ void sym_mfree(void *m, int size, char *
 
 void *__sym_calloc_dma(m_pool_ident_t dev_dmat, int size, char *name)
 {
-	u_long flags;
+	unsigned long flags;
 	void *m;
 	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	m = __sym_calloc_dma_unlocked(dev_dmat, size, name);
@@ -130,7 +118,7 @@ void *__sym_calloc_dma(m_pool_ident_t de
 
 void __sym_mfree_dma(m_pool_ident_t dev_dmat, void *m, int size, char *name)
 {
-	u_long flags;
+	unsigned long flags;
 	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	__sym_mfree_dma_unlocked(dev_dmat, m, size, name);
 	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
@@ -138,7 +126,7 @@ void __sym_mfree_dma(m_pool_ident_t dev_
 
 m_addr_t __vtobus(m_pool_ident_t dev_dmat, void *m)
 {
-	u_long flags;
+	unsigned long flags;
 	m_addr_t b;
 	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	b = __vtobus_unlocked(dev_dmat, m);
@@ -147,40 +135,13 @@ m_addr_t __vtobus(m_pool_ident_t dev_dma
 }
 
 /*
- *  Map/unmap a PCI memory window.
- */
-#ifndef SYM_OPT_NO_BUS_MEMORY_MAPPING
-static u_long __devinit pci_map_mem(u_long base, u_long size)
-{
-	u_long page_base	= ((u_long) base) & PAGE_MASK;
-	u_long page_offs	= ((u_long) base) - page_base;
-	u_long page_remapped	= (u_long) ioremap(page_base, page_offs+size);
-
-	return page_remapped? (page_remapped + page_offs) : 0UL;
-}
-
-static void __devinit pci_unmap_mem(u_long vaddr, u_long size)
-{
-	if (vaddr)
-		iounmap((void *) (vaddr & PAGE_MASK));
-}
-#endif
-
-#define scsi_data_direction(cmd)	(cmd->sc_data_direction)
-
-/*
  *  Driver host data structure.
  */
 struct host_data {
-     hcb_p ncb;
+	struct sym_hcb *ncb;
 };
 
 /*
- * Some type that fit DMA addresses as seen from BUS.
- */
-typedef dma_addr_t	bus_addr_t;
-
-/*
  *  Used by the eh thread to wait for command completion.
  *  It is allocated on the eh thread stack.
  */
@@ -197,14 +158,12 @@ struct sym_eh_wait {
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
 	SYM_QUEHEAD link_cmdq;	/* Must stay at offset ZERO */
-	bus_addr_t data_mapping;
+	dma_addr_t data_mapping;
 	u_char	data_mapped;
 	struct sym_eh_wait *eh_wait;
 };
 
-typedef struct sym_ucmd *ucmd_p;
-
-#define SYM_UCMD_PTR(cmd)  ((ucmd_p)(&(cmd)->SCp))
+#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
 #define SYM_SCMD_PTR(ucmd) sym_que_entry(ucmd, struct scsi_cmnd, SCp)
 #define SYM_SOFTC_PTR(cmd) (((struct host_data *)cmd->device->host->hostdata)->ncb)
 
@@ -242,9 +201,9 @@ static void __unmap_scsi_data(struct pci
 	SYM_UCMD_PTR(cmd)->data_mapped = 0;
 }
 
-static bus_addr_t __map_scsi_single_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
+static dma_addr_t __map_scsi_single_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
-	bus_addr_t mapping;
+	dma_addr_t mapping;
 	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
 
 	mapping = bus_map_single(pdev, cmd->request_buffer,
@@ -298,14 +257,14 @@ static void __sync_scsi_data(struct pci_
 /*
  *  Complete a pending CAM CCB.
  */
-void sym_xpt_done(hcb_p np, struct scsi_cmnd *ccb)
+void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *ccb)
 {
 	sym_remque(&SYM_UCMD_PTR(ccb)->link_cmdq);
 	unmap_scsi_data(np, ccb);
 	ccb->scsi_done(ccb);
 }
 
-void sym_xpt_done2(hcb_p np, struct scsi_cmnd *ccb, int cam_status)
+void sym_xpt_done2(struct sym_hcb *np, struct scsi_cmnd *ccb, int cam_status)
 {
 	sym_set_cam_status(ccb, cam_status);
 	sym_xpt_done(np, ccb);
@@ -315,31 +274,31 @@ void sym_xpt_done2(hcb_p np, struct scsi
 /*
  *  Print something that identifies the IO.
  */
-void sym_print_addr (ccb_p cp)
+void sym_print_addr(struct sym_ccb *cp)
 {
 	struct scsi_cmnd *cmd = cp->cam_ccb;
 	if (cmd)
 		printf("%s:%d:%d:", sym_name(SYM_SOFTC_PTR(cmd)),
-		       cmd->device->id,cmd->device->lun);
+				cmd->device->id, cmd->device->lun);
 }
 
 /*
  *  Tell the SCSI layer about a BUS RESET.
  */
-void sym_xpt_async_bus_reset(hcb_p np)
+void sym_xpt_async_bus_reset(struct sym_hcb *np)
 {
 	printf_notice("%s: SCSI BUS has been reset.\n", sym_name(np));
-	np->s.settle_time = ktime_get(sym_driver_setup.settle_delay * HZ);
+	np->s.settle_time = jiffies + sym_driver_setup.settle_delay * HZ;
 	np->s.settle_time_valid = 1;
 	if (sym_verbose >= 2)
 		printf_info("%s: command processing suspended for %d seconds\n",
-		            sym_name(np), sym_driver_setup.settle_delay);
+			    sym_name(np), sym_driver_setup.settle_delay);
 }
 
 /*
  *  Tell the SCSI layer about a BUS DEVICE RESET message sent.
  */
-void sym_xpt_async_sent_bdr(hcb_p np, int target)
+void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target)
 {
 	printf_notice("%s: TARGET %d has been reset.\n", sym_name(np), target);
 }
@@ -347,7 +306,7 @@ void sym_xpt_async_sent_bdr(hcb_p np, in
 /*
  *  Tell the SCSI layer about the new transfer parameters.
  */
-void sym_xpt_async_nego_wide(hcb_p np, int target)
+void sym_xpt_async_nego_wide(struct sym_hcb *np, int target)
 {
 	if (sym_verbose < 3)
 		return;
@@ -376,7 +335,7 @@ static int sym_xerr_cam_status(int cam_s
 /*
  *  Build CAM result for a failed or auto-sensed IO.
  */
-void sym_set_cam_result_error(hcb_p np, ccb_p cp, int resid)
+void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 {
 	struct scsi_cmnd *csio = cp->cam_ccb;
 	u_int cam_status, scsi_status, drv_status;
@@ -400,8 +359,9 @@ void sym_set_cam_result_error(hcb_p np, 
 			 *  Bounce back the sense data to user.
 			 */
 			bzero(&csio->sense_buffer, sizeof(csio->sense_buffer));
-			bcopy(cp->sns_bbuf, csio->sense_buffer,
-			      MIN(sizeof(csio->sense_buffer),SYM_SNS_BBUF_LEN));
+			memcpy(csio->sense_buffer, cp->sns_bbuf,
+			      min(sizeof(csio->sense_buffer),
+				  (size_t)SYM_SNS_BBUF_LEN));
 #if 0
 			/*
 			 *  If the device reports a UNIT ATTENTION condition 
@@ -416,11 +376,10 @@ void sym_set_cam_result_error(hcb_p np, 
 							cp->target,cp->lun, -1);
 			}
 #endif
-		}
-		else
+		} else {
 			cam_status = DID_ERROR;
-	}
-	else if (cp->host_status == HS_COMPLETE) 	/* Bad SCSI status */
+		}
+	} else if (cp->host_status == HS_COMPLETE) 	/* Bad SCSI status */
 		cam_status = DID_OK;
 	else if (cp->host_status == HS_SEL_TIMEOUT)	/* Selection timeout */
 		cam_status = DID_NO_CONNECT;
@@ -446,7 +405,7 @@ void sym_set_cam_result_error(hcb_p np, 
 /*
  *  Called on successfull INQUIRY response.
  */
-void sym_sniff_inquiry(hcb_p np, struct scsi_cmnd *cmd, int resid)
+void sym_sniff_inquiry(struct sym_hcb *np, struct scsi_cmnd *cmd, int resid)
 {
 	int retv;
 
@@ -467,7 +426,7 @@ void sym_sniff_inquiry(hcb_p np, struct 
  *  Build the scatter/gather array for an I/O.
  */
 
-static int sym_scatter_no_sglist(hcb_p np, ccb_p cp, struct scsi_cmnd *cmd)
+static int sym_scatter_no_sglist(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd *cmd)
 {
 	struct sym_tblmove *data = &cp->phys.data[SYM_CONF_MAX_SG-1];
 	int segment;
@@ -475,21 +434,21 @@ static int sym_scatter_no_sglist(hcb_p n
 	cp->data_len = cmd->request_bufflen;
 
 	if (cmd->request_bufflen) {
-		bus_addr_t baddr = map_scsi_single_data(np, cmd);
+		dma_addr_t baddr = map_scsi_single_data(np, cmd);
 		if (baddr) {
 			sym_build_sge(np, data, baddr, cmd->request_bufflen);
 			segment = 1;
-		}
-		else
+		} else {
 			segment = -2;
-	}
-	else
+		}
+	} else {
 		segment = 0;
+	}
 
 	return segment;
 }
 
-static int sym_scatter(hcb_p np, ccb_p cp, struct scsi_cmnd *cmd)
+static int sym_scatter(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd *cmd)
 {
 	int segment;
 	int use_sg = (int) cmd->use_sg;
@@ -510,15 +469,15 @@ static int sym_scatter(hcb_p np, ccb_p c
 		data = &cp->phys.data[SYM_CONF_MAX_SG - use_sg];
 
 		for (segment = 0; segment < use_sg; segment++) {
-			bus_addr_t baddr = bus_sg_dma_address(&scatter[segment]);
+			dma_addr_t baddr = bus_sg_dma_address(&scatter[segment]);
 			unsigned int len = bus_sg_dma_len(&scatter[segment]);
 
 			sym_build_sge(np, &data[segment], baddr, len);
 			cp->data_len += len;
 		}
-	}
-	else
+	} else {
 		segment = -2;
+	}
 
 	return segment;
 }
@@ -526,12 +485,12 @@ static int sym_scatter(hcb_p np, ccb_p c
 /*
  *  Queue a SCSI command.
  */
-static int sym_queue_command(hcb_p np, struct scsi_cmnd *ccb)
+static int sym_queue_command(struct sym_hcb *np, struct scsi_cmnd *ccb)
 {
 /*	struct scsi_device        *device    = ccb->device; */
-	tcb_p	tp;
-	lcb_p	lp;
-	ccb_p	cp;
+	struct sym_tcb *tp;
+	struct sym_lcb *lp;
+	struct sym_ccb *cp;
 	int	order;
 
 	/*
@@ -543,7 +502,7 @@ static int sym_queue_command(hcb_p np, s
 	    ccb->device->lun >= SYM_CONF_MAX_LUN) {
 		sym_xpt_done2(np, ccb, CAM_DEV_NOT_THERE);
 		return 0;
-        }
+	}
 
 	/*
 	 *  Retreive the target descriptor.
@@ -584,14 +543,14 @@ static int sym_queue_command(hcb_p np, s
 	cp = sym_get_ccb(np, ccb->device->id, ccb->device->lun, order);
 	if (!cp)
 		return 1;	/* Means resource shortage */
-	(void) sym_queue_scsiio(np, ccb, cp);
+	sym_queue_scsiio(np, ccb, cp);
 	return 0;
 }
 
 /*
  *  Setup buffers and pointers that address the CDB.
  */
-static int __inline sym_setup_cdb(hcb_p np, struct scsi_cmnd *ccb, ccb_p cp)
+static int __inline sym_setup_cdb(struct sym_hcb *np, struct scsi_cmnd *ccb, struct sym_ccb *cp)
 {
 	u32	cmd_ba;
 	int	cmd_len;
@@ -604,7 +563,7 @@ static int __inline sym_setup_cdb(hcb_p 
 		return -1;
 	}
 
-	bcopy(ccb->cmnd, cp->cdb_buf, ccb->cmd_len);
+	memcpy(cp->cdb_buf, ccb->cmnd, ccb->cmd_len);
 	cmd_ba  = CCB_BA (cp, cdb_buf[0]);
 	cmd_len = ccb->cmd_len;
 
@@ -617,11 +576,11 @@ static int __inline sym_setup_cdb(hcb_p 
 /*
  *  Setup pointers that address the data and start the I/O.
  */
-int sym_setup_data_and_start(hcb_p np, struct scsi_cmnd *csio, ccb_p cp)
+int sym_setup_data_and_start(struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp)
 {
 	int dir;
-	tcb_p tp = &np->target[cp->target];
-	lcb_p lp = sym_lp(np, tp, cp->lun);
+	struct sym_tcb *tp = &np->target[cp->target];
+	struct sym_lcb *lp = sym_lp(np, tp, cp->lun);
 
 	/*
 	 *  Build the CDB.
@@ -632,9 +591,9 @@ int sym_setup_data_and_start(hcb_p np, s
 	/*
 	 *  No direction means no data.
 	 */
-	dir = scsi_data_direction(csio);
+	dir = csio->sc_data_direction;
 	if (dir != SCSI_DATA_NONE) {
-		cp->segments = sym_scatter (np, cp, csio);
+		cp->segments = sym_scatter(np, cp, csio);
 		if (cp->segments < 0) {
 			if (cp->segments == -2)
 				sym_set_cam_status(csio, CAM_RESRC_UNAVAIL);
@@ -642,8 +601,7 @@ int sym_setup_data_and_start(hcb_p np, s
 				sym_set_cam_status(csio, CAM_REQ_TOO_BIG);
 			goto out_abort;
 		}
-	}
-	else {
+	} else {
 		cp->data_len = 0;
 		cp->segments = 0;
 	}
@@ -692,18 +650,14 @@ out_abort:
  *  Misused to keep the driver running when
  *  interrupts are not configured correctly.
  */
-static void sym_timer (hcb_p np)
+static void sym_timer(struct sym_hcb *np)
 {
-	u_long	thistime = ktime_get(0);
+	unsigned long thistime = jiffies;
 
 	/*
 	 *  Restart the timer.
 	 */
-#ifdef SYM_CONF_PCIQ_BROKEN_INTR
-	np->s.timer.expires = ktime_get((HZ+99)/100);
-#else
-	np->s.timer.expires = ktime_get(SYM_CONF_TIMER_INTERVAL);
-#endif
+	np->s.timer.expires = thistime + SYM_CONF_TIMER_INTERVAL;
 	add_timer(&np->s.timer);
 
 	/*
@@ -711,7 +665,7 @@ static void sym_timer (hcb_p np)
 	 *  clearing it. Then command processing will be resumed.
 	 */
 	if (np->s.settle_time_valid) {
-		if (ktime_dif(np->s.settle_time, thistime) <= 0){
+		if (time_before_eq(np->s.settle_time, thistime)) {
 			if (sym_verbose >= 2 )
 				printk("%s: command processing resumed\n",
 				       sym_name(np));
@@ -738,31 +692,18 @@ static void sym_timer (hcb_p np)
 	 */
 	sym_wakeup_done(np);
 #endif
-
-#ifdef SYM_CONF_PCIQ_BROKEN_INTR
-	if (INB(nc_istat) & (INTF|SIP|DIP)) {
-
-		/*
-		**	Process pending interrupts.
-		*/
-		if (DEBUG_FLAGS & DEBUG_TINY) printk ("{");
-		sym_interrupt(np);
-		if (DEBUG_FLAGS & DEBUG_TINY) printk ("}");
-	}
-#endif /* SYM_CONF_PCIQ_BROKEN_INTR */
 }
 
 
 /*
  *  PCI BUS error handler.
  */
-void sym_log_bus_error(hcb_p np)
+void sym_log_bus_error(struct sym_hcb *np)
 {
 	u_short pci_sts;
 	pci_read_config_word(np->s.device, PCI_STATUS, &pci_sts);
 	if (pci_sts & 0xf900) {
-		pci_write_config_word(np->s.device, PCI_STATUS,
-		                         pci_sts);
+		pci_write_config_word(np->s.device, PCI_STATUS, pci_sts);
 		printf("%s: PCI STATUS = 0x%04x\n",
 			sym_name(np), pci_sts & 0xf900);
 	}
@@ -772,16 +713,16 @@ void sym_log_bus_error(hcb_p np)
 /*
  *  Requeue awaiting commands.
  */
-static void sym_requeue_awaiting_cmds(hcb_p np)
+static void sym_requeue_awaiting_cmds(struct sym_hcb *np)
 {
 	struct scsi_cmnd *cmd;
-	ucmd_p ucp = SYM_UCMD_PTR(cmd);
+	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
 	SYM_QUEHEAD tmp_cmdq;
 	int sts;
 
 	sym_que_move(&np->s.wait_cmdq, &tmp_cmdq);
 
-	while ((ucp = (ucmd_p) sym_remque_head(&tmp_cmdq)) != 0) {
+	while ((ucp = (struct sym_ucmd *) sym_remque_head(&tmp_cmdq)) != 0) {
 		sym_insque_tail(&ucp->link_cmdq, &np->s.busy_cmdq);
 		cmd = SYM_SCMD_PTR(ucp);
 		sts = sym_queue_command(np, cmd);
@@ -793,33 +734,28 @@ static void sym_requeue_awaiting_cmds(hc
 }
 
 /*
- *  Linux entry point of the queuecommand() function
+ * queuecommand method.  Entered with the host adapter lock held and
+ * interrupts disabled.
  */
-int sym53c8xx_queue_command (struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
+					void (*done)(struct scsi_cmnd *))
 {
-	hcb_p  np  = SYM_SOFTC_PTR(cmd);
-	ucmd_p ucp = SYM_UCMD_PTR(cmd);
+	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
+	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
 	int sts = 0;
-#if 0
-	u_long flags;
-#endif
 
 	cmd->scsi_done     = done;
 	cmd->host_scribble = NULL;
 	memset(ucp, 0, sizeof(*ucp));
 
-#if 0
-	SYM_LOCK_HCB(np, flags);
-#endif
-
 	/*
 	 *  Shorten our settle_time if needed for 
 	 *  this command not to time out.
 	 */
 	if (np->s.settle_time_valid && cmd->timeout_per_command) {
-		u_long tlimit = ktime_get(cmd->timeout_per_command);
-		tlimit = ktime_sub(tlimit, SYM_CONF_TIMER_INTERVAL*2);
-		if (ktime_dif(np->s.settle_time, tlimit) > 0) {
+		unsigned long tlimit = jiffies + cmd->timeout_per_command;
+		tlimit -= SYM_CONF_TIMER_INTERVAL*2;
+		if (time_after(np->s.settle_time, tlimit)) {
 			np->s.settle_time = tlimit;
 		}
 	}
@@ -836,10 +772,6 @@ int sym53c8xx_queue_command (struct scsi
 		sym_insque_tail(&ucp->link_cmdq, &np->s.wait_cmdq);
 	}
 out:
-#if 0
-	SYM_UNLOCK_HCB(np, flags);
-#endif
-
 	return 0;
 }
 
@@ -849,11 +781,11 @@ out:
 static irqreturn_t sym53c8xx_intr(int irq, void *dev_id, struct pt_regs * regs)
 {
 	unsigned long flags;
-	hcb_p np = (hcb_p) dev_id;
+	struct sym_hcb *np = (struct sym_hcb *)dev_id;
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
-	SYM_LOCK_HCB(np, flags);
+	spin_lock_irqsave(np->s.host->host_lock, flags);
 
 	sym_interrupt(np);
 
@@ -863,7 +795,7 @@ static irqreturn_t sym53c8xx_intr(int ir
 	if (!sym_que_empty(&np->s.wait_cmdq) && !np->s.settle_time_valid)
 		sym_requeue_awaiting_cmds(np);
 
-	SYM_UNLOCK_HCB(np, flags);
+	spin_unlock_irqrestore(np->s.host->host_lock, flags);
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("]\n");
 
@@ -875,17 +807,17 @@ static irqreturn_t sym53c8xx_intr(int ir
  */
 static void sym53c8xx_timer(unsigned long npref)
 {
-	hcb_p np = (hcb_p) npref;
+	struct sym_hcb *np = (struct sym_hcb *)npref;
 	unsigned long flags;
 
-	SYM_LOCK_HCB(np, flags);
+	spin_lock_irqsave(np->s.host->host_lock, flags);
 
 	sym_timer(np);
 
 	if (!sym_que_empty(&np->s.wait_cmdq) && !np->s.settle_time_valid)
 		sym_requeue_awaiting_cmds(np);
 
-	SYM_UNLOCK_HCB(np, flags);
+	spin_unlock_irqrestore(np->s.host->host_lock, flags);
 }
 
 
@@ -945,13 +877,12 @@ static void sym_eh_timeout(u_long p) { _
  */
 static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 {
-	hcb_p np = SYM_SOFTC_PTR(cmd);
+	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
 	SYM_QUEHEAD *qp;
 	int to_do = SYM_EH_DO_IGNORE;
 	int sts = -1;
 	struct sym_eh_wait eh, *ep = &eh;
 	char devname[20];
-	unsigned long flags;
 
 	sprintf(devname, "%s:%d:%d", sym_name(np), cmd->device->id, cmd->device->lun);
 
@@ -973,7 +904,7 @@ static int sym_eh_handler(int op, char *
 
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
-		ccb_p cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
+		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
 		if (cp->cam_ccb == cmd) {
 			to_do = SYM_EH_DO_WAIT;
 			goto prepare;
@@ -1039,11 +970,9 @@ finish:
 		ep->timer.data = (u_long)cmd;
 		ep->timed_out = 1;	/* Be pessimistic for once :) */
 		add_timer(&ep->timer);
-		local_save_flags(flags);
-		spin_unlock_irq(cmd->device->host->host_lock);
+		spin_unlock_irq(np->s.host->host_lock);
 		down(&ep->sem);
-		local_irq_restore(flags);
-		spin_lock(cmd->device->host->host_lock);
+		spin_lock_irq(np->s.host->host_lock);
 		if (ep->timed_out)
 			sts = -2;
 	}
@@ -1056,22 +985,22 @@ finish:
 /*
  * Error handlers called from the eh thread (one thread per HBA).
  */
-int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 {
 	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
 }
 
-int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
 }
 
-int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
 	return sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
 }
 
-int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
 	return sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
 }
@@ -1079,11 +1008,10 @@ int sym53c8xx_eh_host_reset_handler(stru
 /*
  *  Tune device queuing depth, according to various limits.
  */
-static void 
-sym_tune_dev_queuing(hcb_p np, int target, int lun, u_short reqtags)
+static void sym_tune_dev_queuing(struct sym_hcb *np, int target, int lun, u_short reqtags)
 {
-	tcb_p	tp = &np->target[target];
-	lcb_p	lp = sym_lp(np, tp, lun);
+	struct sym_tcb *tp = &np->target[target];
+	struct sym_lcb *lp = sym_lp(np, tp, lun);
 	u_short	oldtags;
 
 	if (!lp)
@@ -1117,7 +1045,7 @@ sym_tune_dev_queuing(hcb_p np, int targe
 #define ALL_LUNS	-2
 #define NO_LUN		-1
 
-static int device_queue_depth(hcb_p np, int target, int lun)
+static int device_queue_depth(struct sym_hcb *np, int target, int lun)
 {
 	int c, h, t, u, v;
 	char *p = sym_driver_setup.tag_ctrl;
@@ -1167,13 +1095,12 @@ static int device_queue_depth(hcb_p np, 
 /*
  * Linux entry point for device queue sizing.
  */
-int
-sym53c8xx_slave_configure(struct scsi_device *device)
+static int sym53c8xx_slave_configure(struct scsi_device *device)
 {
 	struct Scsi_Host *host = device->host;
-	hcb_p np;
-	tcb_p tp;
-	lcb_p lp;
+	struct sym_hcb *np;
+	struct sym_tcb *tp;
+	struct sym_lcb *lp;
 	int reqtags, depth_to_use;
 
 	np = ((struct host_data *) host->hostdata)->ncb;
@@ -1229,7 +1156,7 @@ sym53c8xx_slave_configure(struct scsi_de
 /*
  *  Linux entry point for info() function
  */
-const char *sym53c8xx_info (struct Scsi_Host *host)
+static const char *sym53c8xx_info (struct Scsi_Host *host)
 {
 	return sym_driver_name();
 }
@@ -1263,9 +1190,9 @@ struct	sym_usrcmd {
 #define UC_RESETDEV	18
 #define UC_CLEARDEV	19
 
-static void sym_exec_user_command (hcb_p np, struct sym_usrcmd *uc)
+static void sym_exec_user_command (struct sym_hcb *np, struct sym_usrcmd *uc)
 {
-	tcb_p tp;
+	struct sym_tcb *tp;
 	int t, l;
 
 	switch (uc->cmd) {
@@ -1305,8 +1232,7 @@ static void sym_exec_user_command (hcb_p
 					tp->tinfo.goal.width   = 1;
 					tp->tinfo.goal.period = uc->data;
 					tp->tinfo.goal.offset = np->maxoffs_dt;
-				}
-				else {
+				} else {
 					if (uc->data < np->minsync)
 						uc->data = np->minsync;
 					tp->tinfo.goal.options = 0;
@@ -1328,7 +1254,7 @@ static void sym_exec_user_command (hcb_p
 				break;
 			case UC_CLEARDEV:
 				for (l = 0; l < SYM_CONF_MAX_LUN; l++) {
-					lcb_p lp = sym_lp(np, tp, l);
+					struct sym_lcb *lp = sym_lp(np, tp, l);
 					if (lp) lp->to_clear = 1;
 				}
 				np->istat_sem = SEM;
@@ -1343,15 +1269,13 @@ static void sym_exec_user_command (hcb_p
 	}
 }
 
-#define is_digit(c)	((c) >= '0' && (c) <= '9')
 #define digit_to_bin(c)	((c) - '0')
-#define is_space(c)	((c) == ' ' || (c) == '\t')
 
 static int skip_spaces(char *ptr, int len)
 {
 	int cnt, c;
 
-	for (cnt = len; cnt > 0 && (c = *ptr++) && is_space(c); cnt--);
+	for (cnt = len; cnt > 0 && (c = *ptr++) && isspace(c); cnt--);
 
 	return (len - cnt);
 }
@@ -1361,7 +1285,7 @@ static int get_int_arg(char *ptr, int le
 	int	cnt, c;
 	u_long	v;
 
-	for (v = 0, cnt = len; cnt > 0 && (c = *ptr++) && is_digit(c); cnt--) {
+	for (v = 0, cnt = len; cnt > 0 && (c = *ptr++) && isdigit(c); cnt--) {
 		v = (v * 10) + digit_to_bin(c);
 	}
 
@@ -1397,7 +1321,7 @@ static int is_keyword(char *ptr, int len
  * Parse a control command
  */
 
-static int sym_user_command(hcb_p np, char *buffer, int length)
+static int sym_user_command(struct sym_hcb *np, char *buffer, int length)
 {
 	char *ptr	= buffer;
 	int len		= length;
@@ -1525,9 +1449,9 @@ printk("sym_user_command: data=%ld\n", u
 	else {
 		unsigned long flags;
 
-		SYM_LOCK_HCB(np, flags);
+		spin_lock_irqsave(np->s.host->host_lock, flags);
 		sym_exec_user_command (np, uc);
-		SYM_UNLOCK_HCB(np, flags);
+		spin_unlock_irqrestore(np->s.host->host_lock, flags);
 	}
 	return length;
 }
@@ -1583,7 +1507,7 @@ static int copy_info(struct info_str *in
 /*
  *  Copy formatted information into the input buffer.
  */
-static int sym_host_info(hcb_p np, char *ptr, off_t offset, int len)
+static int sym_host_info(struct sym_hcb *np, char *ptr, off_t offset, int len)
 {
 	struct info_str info;
 
@@ -1625,11 +1549,11 @@ static int sym_host_info(hcb_p np, char 
  *  - func = 0 means read  (returns adapter infos)
  *  - func = 1 means write (not yet merget from sym53c8xx)
  */
-static int sym53c8xx_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-			int length, int func)
+static int sym53c8xx_proc_info(struct Scsi_Host *host, char *buffer,
+			char **start, off_t offset, int length, int func)
 {
 	struct host_data *host_data;
-	hcb_p np = 0;
+	struct sym_hcb *np = 0;
 	int retv;
 
 	host_data = (struct host_data *) host->hostdata;
@@ -1643,8 +1567,7 @@ static int sym53c8xx_proc_info(struct Sc
 #else
 		retv = -EINVAL;
 #endif
-	}
-	else {
+	} else {
 		if (start)
 			*start = buffer;
 #ifdef SYM_LINUX_USER_INFO_SUPPORT
@@ -1661,20 +1584,20 @@ static int sym53c8xx_proc_info(struct Sc
 /*
  *	Free controller resources.
  */
-static void sym_free_resources(hcb_p np)
+static void sym_free_resources(struct sym_hcb *np)
 {
 	/*
 	 *  Free O/S specific resources.
 	 */
 	if (np->s.irq)
 		free_irq(np->s.irq, np);
-	if (np->s.io_port)
-		release_region(np->s.io_port, np->s.io_ws);
-#ifndef SYM_OPT_NO_BUS_MEMORY_MAPPING
+#ifndef SYM_CONF_IOMAPPED
 	if (np->s.mmio_va)
-		pci_unmap_mem(np->s.mmio_va, np->s.io_ws);
+		iounmap(np->s.mmio_va);
+#endif
+#ifndef SYM_OPT_NO_BUS_MEMORY_MAPPING
 	if (np->s.ram_va)
-		pci_unmap_mem(np->s.ram_va, np->ram_ws);
+		iounmap(np->s.ram_va);
 #endif
 	/*
 	 *  Free O/S independent resources.
@@ -1687,7 +1610,7 @@ static void sym_free_resources(hcb_p np)
 /*
  *  Ask/tell the system about DMA addressing.
  */
-static int sym_setup_bus_dma_mask(hcb_p np)
+static int sym_setup_bus_dma_mask(struct sym_hcb *np)
 {
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 0
 	if (pci_set_dma_mask(np->s.device, 0xffffffffUL))
@@ -1703,8 +1626,7 @@ static int sym_setup_bus_dma_mask(hcb_p 
 			np->use_dac = 1;
 			printf_info("%s: using 64 bit DMA addressing\n",
 					sym_name(np));
-		}
-		else {
+		} else {
 			if (pci_set_dma_mask(np->s.device, 0xffffffffUL))
 				goto out_err32;
 		}
@@ -1723,19 +1645,19 @@ out_err32:
  *  Host attach and initialisations.
  *
  *  Allocate host data and ncb structure.
- *  Request IO region and remap MMIO region.
+ *  Remap MMIO region.
  *  Do chip initialization.
  *  If all is OK, install interrupt handling and
  *  start the timer daemon.
  */
 static int __devinit 
-sym_attach (struct scsi_host_template *tpnt, int unit, sym_device *dev)
+sym_attach (struct scsi_host_template *tpnt, int unit, struct sym_device *dev)
 {
-        struct host_data *host_data;
-	hcb_p np = 0;
-        struct Scsi_Host *instance = 0;
-	u_long flags = 0;
-	sym_nvram *nvram = dev->nvram;
+	struct host_data *host_data;
+	struct sym_hcb *np = NULL;
+	struct Scsi_Host *instance = NULL;
+	unsigned long flags;
+	struct sym_nvram *nvram = dev->nvram;
 	struct sym_fw *fw;
 
 	printk(KERN_INFO
@@ -1763,8 +1685,9 @@ sym_attach (struct scsi_host_template *t
 	/*
 	 *	Allocate host_data structure
 	 */
-        if (!(instance = scsi_host_alloc(tpnt, sizeof(*host_data))))
-	        goto attach_failed;
+	instance = scsi_host_alloc(tpnt, sizeof(*host_data));
+	if (!instance)
+		goto attach_failed;
 	host_data = (struct host_data *) instance->hostdata;
 
 	/*
@@ -1774,20 +1697,15 @@ sym_attach (struct scsi_host_template *t
 	 *  are to be released on error.
 	 */
 	np = __sym_calloc_dma(dev->pdev, sizeof(*np), "HCB");
-	if (np) {
-		np->s.device = dev->pdev;
-		np->bus_dmat = dev->pdev; /* Result in 1 DMA pool per HBA */
-	}
-	else
+	if (!np)
 		goto attach_failed;
-
+	np->s.device = dev->pdev;
+	np->bus_dmat = dev->pdev; /* Result in 1 DMA pool per HBA */
 	host_data->ncb = np;
 	np->s.host = instance;
 
 	pci_set_drvdata(dev->pdev, np);
 
-	SYM_INIT_LOCK_HCB(np);
-
 	/*
 	 *  Copy some useful infos to the HCB.
 	 */
@@ -1823,22 +1741,15 @@ sym_attach (struct scsi_host_template *t
 	np->s.io_ws	= (np->features & FE_IO256)? 256 : 128;
 
 #ifndef SYM_CONF_IOMAPPED
-	np->s.mmio_va = pci_map_mem(dev->s.base_c, np->s.io_ws);
+	np->s.mmio_va = ioremap(dev->s.base_c, np->s.io_ws);
 	if (!np->s.mmio_va) {
 		printf_err("%s: can't map PCI MMIO region\n", sym_name(np));
 		goto attach_failed;
-	}
-	else if (sym_verbose > 1)
+	} else if (sym_verbose > 1)
 		printf_info("%s: using memory mapped IO\n", sym_name(np));
 #endif /* !defined SYM_CONF_IOMAPPED */
 
-	/*
-	 *  Try to map the controller chip into iospace.
-	 */
-	if (dev->s.io_port) {
-		request_region(dev->s.io_port, np->s.io_ws, NAME53C8XX);
-		np->s.io_port = dev->s.io_port;
-	}
+	np->s.io_port = dev->s.io_port;
 
 	/*
 	 *  Map on-chip RAM if present and supported.
@@ -1852,10 +1763,10 @@ sym_attach (struct scsi_host_template *t
 		else
 			np->ram_ws = 4096;
 #ifndef SYM_OPT_NO_BUS_MEMORY_MAPPING
-		np->s.ram_va = pci_map_mem(dev->s.base_2_c, np->ram_ws);
+		np->s.ram_va = ioremap(dev->s.base_2_c, np->ram_ws);
 		if (!np->s.ram_va) {
 			printf_err("%s: can't map PCI MEMORY region\n",
-			       sym_name(np));
+				sym_name(np));
 			goto attach_failed;
 		}
 #endif
@@ -1885,13 +1796,9 @@ sym_attach (struct scsi_host_template *t
 	 *  After SCSI devices have been opened, we cannot
 	 *  reset the bus safely, so we do it here.
 	 */
-	SYM_LOCK_HCB(np, flags);
-	if (sym_reset_scsi_bus(np, 0)) {
-		printf_err("%s: FATAL ERROR: CHECK SCSI BUS - CABLES, "
-		           "TERMINATION, DEVICE POWER etc.!\n", sym_name(np));
-		SYM_UNLOCK_HCB(np, flags);
-		goto attach_failed;
-	}
+	spin_lock_irqsave(instance->host_lock, flags);
+	if (sym_reset_scsi_bus(np, 0))
+		goto reset_failed;
 
 	/*
 	 *  Initialize some queue headers.
@@ -1934,7 +1841,7 @@ sym_attach (struct scsi_host_template *t
 	instance->sg_tablesize	= SYM_CONF_MAX_SG;
 	instance->max_cmd_len	= 16;
 
-	SYM_UNLOCK_HCB(np, flags);
+	spin_unlock_irqrestore(instance->host_lock, flags);
 
 	/*
 	 *  Now let the generic SCSI driver
@@ -1944,7 +1851,11 @@ sym_attach (struct scsi_host_template *t
 	scsi_scan_host(instance);
 	return 0;
 
-attach_failed:
+ reset_failed:
+	printf_err("%s: FATAL ERROR: CHECK SCSI BUS - CABLES, "
+		   "TERMINATION, DEVICE POWER etc.!\n", sym_name(np));
+	spin_unlock_irqrestore(instance->host_lock, flags);
+ attach_failed:
 	if (!instance)
 		return -1;
 	printf_info("%s: giving up ...\n", sym_name(np));
@@ -1952,7 +1863,7 @@ attach_failed:
 		sym_free_resources(np);
 	scsi_host_put(instance);
 
-        return -1;
+	return -1;
  }
 
 
@@ -1960,11 +1871,8 @@ attach_failed:
  *    Detect and try to read SYMBIOS and TEKRAM NVRAM.
  */
 #if SYM_CONF_NVRAM_SUPPORT
-static void __devinit sym_get_nvram(sym_device *devp, sym_nvram *nvp)
+static void __devinit sym_get_nvram(struct sym_device *devp, struct sym_nvram *nvp)
 {
-	if (!nvp)
-		return;
-
 	devp->nvram = nvp;
 	devp->device_id = devp->chip.device_id;
 	nvp->type = 0;
@@ -1972,28 +1880,25 @@ static void __devinit sym_get_nvram(sym_
 	/*
 	 *  Get access to chip IO registers
 	 */
-#ifdef SYM_CONF_IOMAPPED
-	request_region(devp->s.io_port, 128, NAME53C8XX);
-#else
-	devp->s.mmio_va = pci_map_mem(devp->s.base_c, 128);
+#ifndef SYM_CONF_IOMAPPED
+	devp->s.mmio_va = ioremap(devp->s.base_c, 128);
 	if (!devp->s.mmio_va)
 		return;
 #endif
 
-	/*
-	 *  Try to read SYMBIOS|TEKRAM nvram.
-	 */
-	(void) sym_read_nvram(devp, nvp);
+	sym_read_nvram(devp, nvp);
 
 	/*
 	 *  Release access to chip IO registers
 	 */
-#ifdef SYM_CONF_IOMAPPED
-	release_region(devp->s.io_port, 128);
-#else
-	pci_unmap_mem((u_long) devp->s.mmio_va, 128ul);
+#ifndef SYM_CONF_IOMAPPED
+	iounmap(devp->s.mmio_va);
 #endif
 }
+#else
+static inline void sym_get_nvram(struct sym_device *devp, struct sym_nvram *nvp)
+{
+}
 #endif	/* SYM_CONF_NVRAM_SUPPORT */
 
 /*
@@ -2008,35 +1913,26 @@ char *sym53c8xx = 0;	/* command line pas
 MODULE_PARM(sym53c8xx, "s");
 #endif
 
-#define OPT_PCI_PARITY		1
-#define	OPT_SCSI_PARITY		2
-#define OPT_MAX_TAG		3
-#define OPT_MIN_SYNC		4
-#define OPT_BURST_ORDER		5
-#define OPT_SCSI_LED		6
-#define OPT_MAX_WIDE		7
-#define OPT_SCSI_DIFF		8
-#define OPT_IRQ_MODE		9
-#define OPT_SCSI_BUS_CHECK	10
-#define	OPT_HOST_ID		11
-#define OPT_MAX_OFFS		12
-#define OPT_MAX_LUN		13
-#define OPT_REVERSE_PROBE	14
-#define OPT_VERBOSE		15
-#define OPT_DEBUG		16
-#define OPT_SETTLE_DELAY	17
-#define OPT_USE_NVRAM		18
-#define OPT_EXCLUDE		19
-#define OPT_SAFE_SETUP		20
+#define OPT_MAX_TAG		1
+#define OPT_BURST_ORDER		2
+#define OPT_SCSI_LED		3
+#define OPT_SCSI_DIFF		4
+#define OPT_IRQ_MODE		5
+#define OPT_SCSI_BUS_CHECK	6
+#define	OPT_HOST_ID		7
+#define OPT_REVERSE_PROBE	8
+#define OPT_VERBOSE		9
+#define OPT_DEBUG		10
+#define OPT_SETTLE_DELAY	11
+#define OPT_USE_NVRAM		12
+#define OPT_EXCLUDE		13
+#define OPT_SAFE_SETUP		14
 
 static char setup_token[] __initdata =
-	"mpar:"		"spar:"
-	"tags:"		"sync:"
-	"burst:"	"led:"
-	"wide:"		"diff:"
+	"tags:"		"burst:"
+	"led:"		"diff:"
 	"irqm:"		"buschk:"
-	"hostid:"	"offset:"
-	"luns:"		"revprob:"
+	"hostid:"	"revprob:"
 	"verb:"		"debug:"
 	"settle:"	"nvram:"
 	"excl:"		"safe:"
@@ -2114,18 +2010,12 @@ int __init sym53c8xx_setup(char *str)
 			sym_driver_setup.name = val;\
 			break;
 
-		__SIMPLE_OPTION(PCI_PARITY, pci_parity)
-		__SIMPLE_OPTION(SCSI_PARITY, scsi_parity)
-		__SIMPLE_OPTION(MIN_SYNC, min_sync)
 		__SIMPLE_OPTION(BURST_ORDER, burst_order)
 		__SIMPLE_OPTION(SCSI_LED, scsi_led)
-		__SIMPLE_OPTION(MAX_WIDE, max_wide)
 		__SIMPLE_OPTION(SCSI_DIFF, scsi_diff)
 		__SIMPLE_OPTION(IRQ_MODE, irq_mode)
 		__SIMPLE_OPTION(SCSI_BUS_CHECK, scsi_bus_check)
 		__SIMPLE_OPTION(HOST_ID, host_id)
-		__SIMPLE_OPTION(MAX_OFFS, max_offs)
-		__SIMPLE_OPTION(MAX_LUN, max_lun)
 		__SIMPLE_OPTION(REVERSE_PROBE, reverse_probe)
 		__SIMPLE_OPTION(VERBOSE, verbose)
 		__SIMPLE_OPTION(DEBUG, debug)
@@ -2156,26 +2046,20 @@ __setup("sym53c8xx=", sym53c8xx_setup);
  *  been detected.
  */
 static int __devinit
-sym53c8xx_pci_init(struct pci_dev *pdev, sym_device *device)
+sym53c8xx_pci_init(struct pci_dev *pdev, struct sym_device *device)
 {
-	u_short vendor_id, device_id, status_reg;
-	u_char revision;
-	u_int irq;
+	struct sym_pci_chip *chip;
 	u_long base, base_2; 
 	u_long base_c, base_2_c, io_port; 
 	int i;
-	struct sym_pci_chip *chip;
+	u_short device_id, status_reg;
+	u_char revision;
 
 	/* Choose some short name for this device */
 	sprintf(device->s.inst_name, "sym.%d.%d.%d", pdev->bus->number,
 			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
-	/*
-	 *  Read needed minimal info from the PCI config space.
-	 */
-	vendor_id = pdev->vendor;
 	device_id = pdev->device;
-	irq	  = pdev->irq;
 
 	io_port = pdev->resource[0].start;
 
@@ -2191,7 +2075,7 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 
 	/*
-	 *  If user excluded this chip, donnot initialize it.
+	 *  If user excluded this chip, do not initialize it.
 	 */
 	if (io_port) {
 		for (i = 0 ; i < 8 ; i++) {
@@ -2201,15 +2085,6 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	}
 
 	/*
-	 *  Leave here if another driver attached the chip.
-	 */
-	if (io_port && check_region (io_port, 128)) {
-		printf_info("%s: IO region 0x%lx[0..127] is in use\n",
-		            sym_name(device), (long) io_port);
-		return -1;
-	}
-
-	/*
 	 *  Check if the chip is supported.
 	 */
 	chip = sym_lookup_pci_chip_table(device_id, revision);
@@ -2220,17 +2095,18 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 
 	/*
 	 *  Check if the chip has been assigned resources we need.
+	 *  XXX: can this still happen with Linux 2.6's PCI layer?
 	 */
 #ifdef SYM_CONF_IOMAPPED
 	if (!io_port) {
 		printf_info("%s: IO base address disabled.\n",
-		            sym_name(device));
+			    sym_name(device));
 		return -1;
 	}
 #else
 	if (!base) {
 		printf_info("%s: MMIO base address disabled.\n",
-		            sym_name(device));
+			    sym_name(device));
 		return -1;
 	}
 #endif
@@ -2242,21 +2118,21 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 #if defined(__i386__) && !defined(SYM_OPT_NO_BUS_MEMORY_MAPPING)
 	if (base_2_c) {
 		unsigned int ram_size, ram_val;
-		u_long ram_ptr;
+		void *ram_ptr;
 
 		if (chip->features & FE_RAM8K)
 			ram_size = 8192;
 		else
 			ram_size = 4096;
 
-		ram_ptr = pci_map_mem(base_2_c, ram_size);
+		ram_ptr = ioremap(base_2_c, ram_size);
 		if (ram_ptr) {
 			ram_val = readl_raw(ram_ptr + ram_size - 16);
-			pci_unmap_mem(ram_ptr, ram_size);
+			iounmap(ram_ptr);
 			if (ram_val == 0x52414944) {
 				printf_info("%s: not initializing, "
-				            "driven by RAID controller.\n",
-				            sym_name(device));
+					    "driven by RAID controller.\n",
+					    sym_name(device));
 				return -1;
 			}
 		}
@@ -2267,14 +2143,9 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	 *  Copy the chip description to our device structure, 
 	 *  so we can make it match the actual device and options.
 	 */
-	bcopy(chip, &device->chip, sizeof(device->chip));
+	memcpy(&device->chip, chip, sizeof(device->chip));
 	device->chip.revision_id = revision;
 
-	if (pci_enable_device(pdev))
-		return -1;
-
-	pci_set_master(pdev);
-
 	/*
 	 *  Some features are required to be enabled in order to 
 	 *  work around some chip problems. :) ;)
@@ -2286,6 +2157,7 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 		chip->features	|= (FE_WRIE | FE_CLSE);
 	}
 
+	/* If the chip can do Memory Write Invalidate, enable it */
 	if (chip->features & FE_WRIE) {
 		if (pci_set_mwi(pdev))
 			return -1;
@@ -2323,8 +2195,7 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
 	device->s.base_c	= base_c;
 	device->s.base_2_c	= base_2_c;
 	device->s.io_port	= io_port;
-	device->s.irq		= irq;
-	device->attach_done	= 0;
+	device->s.irq		= pdev->irq;
 
 	return 0;
 }
@@ -2338,7 +2209,7 @@ sym53c8xx_pci_init(struct pci_dev *pdev,
  *  We have to free resources and halt the NCR chip.
  *
  */
-static int sym_detach(hcb_p np)
+static int __devexit sym_detach(struct sym_hcb *np)
 {
 	printk("%s: detaching ...\n", sym_name(np));
 
@@ -2462,32 +2333,46 @@ static int attach_count;
 static int __devinit sym2_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	sym_device sym_dev;
-	sym_nvram nvram;
+	struct sym_device sym_dev;
+	struct sym_nvram nvram;
 
 	memset(&sym_dev, 0, sizeof(sym_dev));
 	memset(&nvram, 0, sizeof(nvram));
 
+	if (pci_enable_device(pdev))
+		return -ENODEV;
+
+	pci_set_master(pdev);
+
+	if (pci_request_regions(pdev, NAME53C8XX))
+		goto disable;
+
 	sym_dev.host_id = SYM_SETUP_HOST_ID;
 	if (sym53c8xx_pci_init(pdev, &sym_dev))
-		return -ENODEV;
+		goto free;
 
-	sym_dev.nvram = &nvram;
-	nvram.type = 0;
-#if SYM_CONF_NVRAM_SUPPORT
 	sym_get_nvram(&sym_dev, &nvram);
-#endif
 
 	if (sym_attach(&sym2_template, attach_count, &sym_dev))
-		return -ENODEV;
+		goto free;
 
 	attach_count++;
 	return 0;
+
+ free:
+	pci_release_regions(pdev);
+ disable:
+	pci_disable_device(pdev);
+	return -ENODEV;
 }
 
 static void __devexit sym2_remove(struct pci_dev *pdev)
 {
 	sym_detach(pci_get_drvdata(pdev));
+
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+
 	attach_count--;
 }
 
Index: drivers/scsi/sym53c8xx_2/sym_glue.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h,v
retrieving revision 1.15
retrieving revision 1.16
diff -u -p -r1.15 -r1.16
--- drivers/scsi/sym53c8xx_2/sym_glue.h	8 Sep 2003 21:42:21 -0000	1.15
+++ drivers/scsi/sym53c8xx_2/sym_glue.h	8 Sep 2003 22:00:25 -0000	1.16
@@ -53,40 +53,22 @@
 #ifndef SYM_GLUE_H
 #define SYM_GLUE_H
 
-#if 0
-#define SYM_CONF_DMA_ADDRESSING_MODE 2
-#endif
-
-#include <asm/dma.h>
-#include <asm/io.h>
-#include <asm/system.h>
-#include <linux/spinlock.h>
+#include <linux/config.h>
 #include <linux/delay.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/errno.h>
+#include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/time.h>
 #include <linux/timer.h>
-#include <linux/stat.h>
-#include <linux/interrupt.h>
-
-#include <linux/blkdev.h>
+#include <linux/types.h>
 
+#include <asm/io.h>
 #ifdef __sparc__
 #  include <asm/irq.h>
 #endif
-#include <linux/init.h>
-
-#include "../scsi.h"
-#include "../hosts.h"
-
-#include <linux/types.h>
 
-typedef	u_long	vm_offset_t;
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include "../scsi.h"		/* XXX: DID_* */
 
 #ifndef bcopy
 #define bcopy(s, d, n)	memcpy((d), (s), (n))
@@ -103,7 +85,6 @@ typedef	u_long	vm_offset_t;
 /*
  *  General driver includes.
  */
-#include "sym53c8xx.h"
 #include "sym_misc.h"
 #include "sym_conf.h"
 #include "sym_defs.h"
@@ -147,16 +128,12 @@ typedef struct sym_tcb *tcb_p;
 typedef struct sym_lcb *lcb_p;
 typedef struct sym_ccb *ccb_p;
 typedef struct sym_hcb *hcb_p;
-typedef struct sym_stcb *stcb_p;
-typedef struct sym_slcb *slcb_p;
-typedef struct sym_sccb *sccb_p;
-typedef struct sym_shcb *shcb_p;
 
 /*
  *  Define a reference to the O/S dependent IO request.
  */
-typedef Scsi_Cmnd *cam_ccb_p;	/* Generic */
-typedef Scsi_Cmnd *cam_scsiio_p;/* SCSI I/O */
+typedef struct scsi_cmnd *cam_ccb_p;	/* Generic */
+typedef struct scsi_cmnd *cam_scsiio_p;/* SCSI I/O */
 
 
 /*
@@ -177,30 +154,17 @@ typedef Scsi_Cmnd *cam_scsiio_p;/* SCSI 
 
 #else	/* little endian */
 
-#if defined(__i386__)	/* i386 implements full FLAT memory/MMIO model */
 #define	inw_raw		inw
 #define	inl_raw		inl
 #define	outw_raw	outw
 #define	outl_raw	outl
-#define readb_raw(a)	(*(volatile unsigned char *) (a))
-#define readw_raw(a)	(*(volatile unsigned short *) (a))
-#define readl_raw(a)	(*(volatile unsigned int *) (a))
-#define writeb_raw(b,a)	((*(volatile unsigned char *) (a)) = (b))
-#define writew_raw(b,a)	((*(volatile unsigned short *) (a)) = (b))
-#define writel_raw(b,a)	((*(volatile unsigned int *) (a)) = (b))
 
-#else	/* Other little-endian */
-#define	inw_raw		inw
-#define	inl_raw		inl
-#define	outw_raw	outw
-#define	outl_raw	outl
 #define	readw_raw	readw
 #define	readl_raw	readl
 #define	writew_raw	writew
 #define	writel_raw	writel
 
-#endif
-#endif
+#endif /* endian */
 
 #ifdef	SYM_CONF_CHIP_BIG_ENDIAN
 #error	"Chips in BIG ENDIAN addressing mode are not (yet) supported"
@@ -421,8 +385,8 @@ struct sym_shcb {
 
 	struct Scsi_Host *host;
 
-	vm_offset_t	mmio_va;	/* MMIO kernel virtual address	*/
-	vm_offset_t	ram_va;		/* RAM  kernel virtual address	*/
+	void *		mmio_va;	/* MMIO kernel virtual address	*/
+	void *		ram_va;		/* RAM  kernel virtual address	*/
 	u_long		io_port;	/* IO port address cookie	*/
 	u_short		io_ws;		/* IO window size		*/
 	int		irq;		/* IRQ number			*/
@@ -446,7 +410,7 @@ struct sym_shcb {
  *  Must resolve the IO macros and sym_name(), when  
  *  used as sub-field 's' of another structure.
  */
-typedef struct {
+struct sym_slot {
 	u_long	base;
 	u_long	base_2;
 	u_long	base_c;
@@ -454,26 +418,23 @@ typedef struct {
 	int	irq;
 /* port and address fields to fit INB, OUTB macros */
 	u_long	io_port;
-	vm_offset_t mmio_va;
+	void *	mmio_va;
 	char	inst_name[16];
-} sym_slot;
-
-typedef struct sym_nvram sym_nvram;
+};
 
-typedef struct {
+struct sym_device {
 	struct pci_dev *pdev;
-	sym_slot  s;
+	struct sym_slot  s;
 	struct sym_pci_chip chip;
-	sym_nvram *nvram;
+	struct sym_nvram *nvram;
 	u_short device_id;
 	u_char host_id;
 #ifdef	SYM_CONF_PQS_PDS_SUPPORT
 	u_char pqs_pds;
 #endif
-	int attach_done;
-} sym_device;
+};
 
-typedef sym_device *sdev_p;
+typedef struct sym_device *sdev_p;
 
 /*
  *  The driver definitions (sym_hipd.h) must know about a 
@@ -545,7 +506,7 @@ m_addr_t __vtobus(m_pool_ident_t dev_dma
  *  Set the status field of a CAM CCB.
  */
 static __inline void 
-sym_set_cam_status(Scsi_Cmnd  *ccb, int status)
+sym_set_cam_status(struct scsi_cmnd *ccb, int status)
 {
 	ccb->result &= ~(0xff  << 16);
 	ccb->result |= (status << 16);
@@ -555,7 +516,7 @@ sym_set_cam_status(Scsi_Cmnd  *ccb, int 
  *  Get the status field of a CAM CCB.
  */
 static __inline int 
-sym_get_cam_status(Scsi_Cmnd  *ccb)
+sym_get_cam_status(struct scsi_cmnd *ccb)
 {
 	return ((ccb->result >> 16) & 0xff);
 }
@@ -584,7 +545,7 @@ void sym_xpt_async_nego_wide(hcb_p np, i
  */
 static __inline void sym_set_cam_result_ok(hcb_p np, ccb_p cp, int resid)
 {
-	Scsi_Cmnd *cmd = cp->cam_ccb;
+	struct scsi_cmnd *cmd = cp->cam_ccb;
 
 	cmd->resid = resid;
 	cmd->result = (((DID_OK) << 16) + ((cp->ssss_status) & 0x7f));
@@ -604,8 +565,6 @@ void sym_xpt_async_bus_reset(hcb_p np);
 void sym_xpt_async_sent_bdr(hcb_p np, int target);
 int  sym_setup_data_and_start (hcb_p np, cam_scsiio_p csio, ccb_p cp);
 void sym_log_bus_error(hcb_p np);
-#ifdef	SYM_OPT_SNIFF_INQUIRY
-void sym_sniff_inquiry(hcb_p np, Scsi_Cmnd *cmd, int resid);
-#endif
+void sym_sniff_inquiry(hcb_p np, struct scsi_cmnd *cmd, int resid);
 
 #endif /* SYM_GLUE_H */
Index: drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.10
diff -u -p -r1.10 sym_hipd.c
--- drivers/scsi/sym53c8xx_2/sym_hipd.c	8 Sep 2003 21:42:21 -0000	1.10
+++ drivers/scsi/sym53c8xx_2/sym_hipd.c	9 Sep 2003 01:42:17 -0000
@@ -50,7 +50,7 @@
  * SUCH DAMAGE.
  */
 
-#define SYM_DRIVER_NAME	"sym-2.1.17a"
+#define SYM_DRIVER_NAME	"sym-2.1.18"
 
 #ifdef __FreeBSD__
 #include <dev/sym/sym_glue.h>
@@ -734,6 +734,41 @@ static void sym_save_initial_setting (hc
 		np->sv_ctest5	= INB(nc_ctest5) & 0x24;
 }
 
+#ifdef CONFIG_PARISC
+static u32 parisc_setup_hcb(hcb_p np, u32 period)
+{
+	unsigned long pdc_period;
+	char scsi_mode;
+	struct hardware_path hwpath;
+
+	/* Host firmware (PDC) keeps a table for crippling SCSI capabilities.
+	 * Many newer machines export one channel of 53c896 chip
+	 * as SE, 50-pin HD.  Also used for Multi-initiator SCSI clusters
+	 * to set the SCSI Initiator ID.
+	 */
+	get_pci_node_path(np->s.device, &hwpath);
+	if (!pdc_get_initiator(&hwpath, &np->myaddr, &pdc_period,
+				&np->maxwide, &scsi_mode))
+		return period;
+
+	printk("scsi_mode = %d, period = %ld\n", scsi_mode, pdc_period);
+
+	if (scsi_mode >= 0) {
+		/* C3000 PDC reports period/mode */
+		SYM_SETUP_SCSI_DIFF = 0;
+		switch(scsi_mode) {
+		case 0:	np->scsi_mode = SMODE_SE; break;
+		case 1:	np->scsi_mode = SMODE_HVD; break;
+		case 2:	np->scsi_mode = SMODE_LVD; break;
+		default:	break;
+		}
+	}
+
+	return (u32) pdc_period;
+}
+#else
+static inline int parisc_setup_hcb(hcb_p np, u32 period) { return period; }
+#endif
 /*
  *  Prepare io register values used by sym_start_up() 
  *  according to selected and supported features.
@@ -744,12 +779,6 @@ static int sym_prepare_setting(hcb_p np,
 	u32	period;
 	int i;
 
-#ifdef CONFIG_PARISC
-	unsigned long pdc_period;
-	char scsi_mode = -1;
-	struct hardware_path hwpath;
-#endif
-
 	/*
 	 *  Wide ?
 	 */
@@ -807,29 +836,7 @@ static int sym_prepare_setting(hcb_p np,
 	 */
 	period = (4 * div_10M[0] + np->clock_khz - 1) / np->clock_khz;
 
-#if defined(CONFIG_PARISC)
-	/* Host firmware (PDC) keeps a table for crippling SCSI capabilities.
-	 * Many newer machines export one channel of 53c896 chip
-	 * as SE, 50-pin HD.  Also used for Multi-initiator SCSI clusters
-	 * to set the SCSI Initiator ID.
-	 */
-	get_pci_node_path(np->s.device, &hwpath);
-	if (pdc_get_initiator(&hwpath, &np->myaddr, &pdc_period, &np->maxwide, &scsi_mode))
-	{
-		if (scsi_mode >= 0) {
-			/* C3000 PDC reports period/mode */
-			SYM_SETUP_SCSI_DIFF = 0;
-			switch(scsi_mode) {
-			case 0:	np->scsi_mode = SMODE_SE; break;
-			case 1:	np->scsi_mode = SMODE_HVD; break;
-			case 2:	np->scsi_mode = SMODE_LVD; break;
-			default:	break;
-			}
-		}
-
-		period = (u32) pdc_period;
-	}
-#endif
+	period = parisc_setup_hcb(np, period);
 
 	if	(period <= 250)		np->minsync = 10;
 	else if	(period <= 303)		np->minsync = 11;
Index: drivers/scsi/sym53c8xx_2/sym_hipd.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h,v
retrieving revision 1.3
retrieving revision 1.4
diff -u -p -r1.3 -r1.4
--- drivers/scsi/sym53c8xx_2/sym_hipd.h	8 Sep 2003 21:42:21 -0000	1.3
+++ drivers/scsi/sym53c8xx_2/sym_hipd.h	8 Sep 2003 22:00:25 -0000	1.4
@@ -129,12 +129,6 @@
 /*
  *  These ones should have been already defined.
  */
-#ifndef offsetof
-#define offsetof(t, m)	((size_t) (&((t *)0)->m))
-#endif
-#ifndef MIN
-#define MIN(a, b) (((a) < (b)) ? (a) : (b))
-#endif
 #ifndef assert
 #define	assert(expression) { \
 	if (!(expression)) { \

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
