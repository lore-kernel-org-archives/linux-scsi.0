From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] zalon & ncr53c8xx cleanups
Date: Thu, 11 Sep 2003 19:11:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030911181135.GN21596@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:8379 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261441AbTIKSLg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 14:11:36 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: parisc-linux@parisc-linux.org, linux-scsi@vger.kernel.org


I don't actually have a zalon machine to test these on, but they seem
right to me, and compile fine.

Some cleanups for ncr53c8xx & zalon:

 - Inline zalon.h into zalon.c
 - Rationalise (a little) ncr53c8xx.c's includes
 - Remove all the version checks
 - Stop using remap_pci_mem & unmap_pci_mem & delete their definitions.
 - Use mb() instead of custom inline asm for MEMORY_BARRIER.

Index: drivers/scsi/ncr53c8xx.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/ncr53c8xx.c,v
retrieving revision 1.4
diff -u -p -r1.4 ncr53c8xx.c
--- drivers/scsi/ncr53c8xx.c	8 Sep 2003 21:42:20 -0000	1.4
+++ drivers/scsi/ncr53c8xx.c	11 Sep 2003 18:04:23 -0000
@@ -115,64 +115,32 @@
 **==========================================================
 */
 
-#include <linux/version.h>
-
-#include <linux/module.h>
-#include <asm/dma.h>
-#include <asm/io.h>
-#include <asm/system.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,17)
-#include <linux/spinlock.h>
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
-#include <asm/spinlock.h>
-#endif
+#include <linux/blkdev.h>
 #include <linux/delay.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/errno.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/string.h>
-#include <linux/mm.h>
 #include <linux/ioport.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/spinlock.h>
+#include <linux/stat.h>
+#include <linux/string.h>
 #include <linux/time.h>
 #include <linux/timer.h>
-#include <linux/stat.h>
-
-#include <linux/blkdev.h>
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,35)
-#include <linux/init.h>
-#endif
-
-#ifndef	__init
-#define	__init
-#endif
-#ifndef	__initdata
-#define	__initdata
-#endif
+#include <linux/types.h>
 
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,1,92)
-#include <linux/bios32.h>
-#endif
+#include <asm/dma.h>
+#include <asm/io.h>
+#include <asm/system.h>
 
 #include "scsi.h"
 #include "hosts.h"
 
-#include <linux/types.h>
-
-/*
-**	Define BITS_PER_LONG for earlier linux versions.
-*/
-#ifndef	BITS_PER_LONG
-#if (~0UL) == 0xffffffffUL
-#define	BITS_PER_LONG	32
-#else
-#define	BITS_PER_LONG	64
-#endif
-#endif
-
 #include "ncr53c8xx.h"
 
 /*
@@ -1028,9 +996,7 @@ struct ncb {
 					/*  when lcb is not allocated.	*/
 	Scsi_Cmnd	*done_list;	/* Commands waiting for done()  */
 					/* callback to be invoked.      */ 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,93)
 	spinlock_t	smp_lock;	/* Lock for SMP threading       */
-#endif
 
 	/*----------------------------------------------------------------
 	**	Chip and controller indentification.
@@ -3739,7 +3705,7 @@ ncr_attach (Scsi_Host_Template *tpnt, in
 	if(device->slot.base_v)
 		np->vaddr = device->slot.base_v;
 	else
-		np->vaddr = remap_pci_mem(device->slot.base_c, (u_long) 128);
+		np->vaddr = (unsigned long)ioremap(device->slot.base_c, 128);
 
 	if (!np->vaddr) {
 		printk(KERN_ERR
@@ -3809,11 +3775,7 @@ ncr_attach (Scsi_Host_Template *tpnt, in
 	instance->max_id	= np->maxwide ? 16 : 8;
 	instance->max_lun	= SCSI_NCR_MAX_LUN;
 #ifndef SCSI_NCR_IOMAPPED
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,29)
 	instance->base		= (unsigned long) np->reg;
-#else
-	instance->base		= (char *) np->reg;
-#endif
 #endif
 	instance->irq		= device->slot.irq;
 	instance->unique_id	= device->slot.io_port;
@@ -9199,28 +9161,13 @@ printk("ncr53c8xx_proc_info: hostno=%d, 
 
 /*==========================================================
 **
-**	/proc directory entry.
-**
-**==========================================================
-*/
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,27)
-static struct proc_dir_entry proc_scsi_ncr53c8xx = {
-    PROC_SCSI_NCR53C8XX, 9, NAME53C8XX,
-    S_IFDIR | S_IRUGO | S_IXUGO, 2
-};
-#endif
-
-/*==========================================================
-**
 **	Boot command line.
 **
 **==========================================================
 */
 #ifdef	MODULE
 char *ncr53c8xx = 0;	/* command line passed by insmod */
-# if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,30)
 MODULE_PARM(ncr53c8xx, "s");
-# endif
 #endif
 
 int __init ncr53c8xx_setup(char *str)
@@ -9228,10 +9175,8 @@ int __init ncr53c8xx_setup(char *str)
 	return sym53c8xx__setup(str);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,13)
 #ifndef MODULE
 __setup("ncr53c8xx=", ncr53c8xx_setup);
-#endif
 #endif
 
 /*===================================================================
Index: drivers/scsi/sym53c8xx_comm.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_comm.h,v
retrieving revision 1.1
diff -u -p -r1.1 sym53c8xx_comm.h
--- drivers/scsi/sym53c8xx_comm.h	29 Jul 2003 17:01:30 -0000	1.1
+++ drivers/scsi/sym53c8xx_comm.h	11 Sep 2003 18:03:22 -0000
@@ -74,9 +74,7 @@
 **==========================================================
 */
 
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,3,47)
 #define SCSI_NCR_DYNAMIC_DMA_MAPPING
-#endif
 
 /*==========================================================
 **
@@ -262,8 +260,6 @@ static inline struct xpt_quehead *xpt_re
 **==========================================================
 */
 
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,2,0)
-
 typedef struct pci_dev *pcidev_t;
 typedef struct device *device_t;
 #define PCIDEV_NULL		(0)
@@ -276,17 +272,7 @@ typedef struct device *device_t;
 static u_long __init
 pci_get_base_cookie(struct pci_dev *pdev, int index)
 {
-	u_long base;
-
-#if LINUX_VERSION_CODE > LinuxVersionCode(2,3,12)
-	base = pdev->resource[index].start;
-#else
-	base = pdev->base_address[index];
-#if BITS_PER_LONG > 32
-	if ((base & 0x7) == 0x4)
-		*base |= (((u_long)pdev->base_address[++index]) << 32);
-#endif
-#endif
+	u_long base = pdev->resource[index].start;
 	return (base & ~0x7ul);
 }
 
@@ -310,102 +296,6 @@ pci_get_base_address(struct pci_dev *pde
 #undef PCI_BAR_OFFSET
 }
 
-#else	/* Incomplete emulation of current PCI code for pre-2.2 kernels */
-
-typedef unsigned int pcidev_t;
-typedef unsinged int device_t;
-#define PCIDEV_NULL		(~0u)
-#define PciBusNumber(d)		((d)>>8)
-#define PciDeviceFn(d)		((d)&0xff)
-#define __PciDev(busn, devfn)	(((busn)<<8)+(devfn))
-
-#define pci_read_config_byte(d, w, v) \
-	pcibios_read_config_byte(PciBusNumber(d), PciDeviceFn(d), w, v)
-#define pci_read_config_word(d, w, v) \
-	pcibios_read_config_word(PciBusNumber(d), PciDeviceFn(d), w, v)
-#define pci_read_config_dword(d, w, v) \
-	pcibios_read_config_dword(PciBusNumber(d), PciDeviceFn(d), w, v)
-
-#define pci_write_config_byte(d, w, v) \
-	pcibios_write_config_byte(PciBusNumber(d), PciDeviceFn(d), w, v)
-#define pci_write_config_word(d, w, v) \
-	pcibios_write_config_word(PciBusNumber(d), PciDeviceFn(d), w, v)
-#define pci_write_config_dword(d, w, v) \
-	pcibios_write_config_dword(PciBusNumber(d), PciDeviceFn(d), w, v)
-
-static pcidev_t __init
-pci_find_device(unsigned int vendor, unsigned int device, pcidev_t prev)
-{
-	static unsigned short pci_index;
-	int retv;
-	unsigned char bus_number, device_fn;
-
-	if (prev == PCIDEV_NULL)
-		pci_index = 0;
-	else
-		++pci_index;
-	retv = pcibios_find_device (vendor, device, pci_index,
-				    &bus_number, &device_fn);
-	return retv ? PCIDEV_NULL : __PciDev(bus_number, device_fn);
-}
-
-static u_short __init PciVendorId(pcidev_t dev)
-{
-	u_short vendor_id;
-	pci_read_config_word(dev, PCI_VENDOR_ID, &vendor_id);
-	return vendor_id;
-}
-
-static u_short __init PciDeviceId(pcidev_t dev)
-{
-	u_short device_id;
-	pci_read_config_word(dev, PCI_DEVICE_ID, &device_id);
-	return device_id;
-}
-
-static u_int __init PciIrqLine(pcidev_t dev)
-{
-	u_char irq;
-	pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
-	return irq;
-}
-
-static int __init 
-pci_get_base_address(pcidev_t dev, int offset, u_long *base)
-{
-	u_int32 tmp;
-	
-	pci_read_config_dword(dev, PCI_BASE_ADDRESS_0 + offset, &tmp);
-	*base = tmp;
-	offset += sizeof(u_int32);
-	if ((tmp & 0x7) == 0x4) {
-#if BITS_PER_LONG > 32
-		pci_read_config_dword(dev, PCI_BASE_ADDRESS_0 + offset, &tmp);
-		*base |= (((u_long)tmp) << 32);
-#endif
-		offset += sizeof(u_int32);
-	}
-	return offset;
-}
-static u_long __init
-pci_get_base_cookie(struct pci_dev *pdev, int offset)
-{
-	u_long base;
-
-	(void) pci_get_base_address(dev, offset, &base);
-
-	return base;
-}
-
-#endif	/* LINUX_VERSION_CODE >= LinuxVersionCode(2,2,0) */
-
-/* Does not make sense in earlier kernels */
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,4,0)
-#define pci_enable_device(pdev)		(0)
-#endif
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,4,4)
-#define	scsi_set_pci_device(inst, pdev)	(0)
-#endif
 
 /*==========================================================
 **
@@ -428,7 +318,6 @@ pci_get_base_cookie(struct pci_dev *pdev
 **==========================================================
 */
 
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,1,93)
 spinlock_t DRIVER_SMP_LOCK = SPIN_LOCK_UNLOCKED;
 #define	NCR_LOCK_DRIVER(flags)     spin_lock_irqsave(&DRIVER_SMP_LOCK, flags)
 #define	NCR_UNLOCK_DRIVER(flags)   \
@@ -443,20 +332,6 @@ spinlock_t DRIVER_SMP_LOCK = SPIN_LOCK_U
 #define	NCR_UNLOCK_SCSI_DONE(host, flags) \
 		spin_unlock_irqrestore(((host)->host_lock), flags)
 
-#else
-
-#define	NCR_LOCK_DRIVER(flags)     do { save_flags(flags); cli(); } while (0)
-#define	NCR_UNLOCK_DRIVER(flags)   do { restore_flags(flags); } while (0)
-
-#define	NCR_INIT_LOCK_NCB(np)      do { } while (0)
-#define	NCR_LOCK_NCB(np, flags)    do { save_flags(flags); cli(); } while (0)
-#define	NCR_UNLOCK_NCB(np, flags)  do { restore_flags(flags); } while (0)
-
-#define	NCR_LOCK_SCSI_DONE(host, flags)    do {;} while (0)
-#define	NCR_UNLOCK_SCSI_DONE(host, flags)  do {;} while (0)
-
-#endif
-
 /*==========================================================
 **
 **	Memory mapped IO
@@ -472,37 +347,11 @@ spinlock_t DRIVER_SMP_LOCK = SPIN_LOCK_U
 **==========================================================
 */
 
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,1,0)
-#define ioremap vremap
-#define iounmap vfree
-#endif
-
 #ifdef __sparc__
-#  include <asm/irq.h>
-#  define memcpy_to_pci(a, b, c)	memcpy_toio((a), (b), (c))
-#elif defined(__alpha__)
-#  define memcpy_to_pci(a, b, c)	memcpy_toio((a), (b), (c))
-#else	/* others */
-#  define memcpy_to_pci(a, b, c)	memcpy_toio((a), (b), (c))
+#include <asm/irq.h>
 #endif
 
-#ifndef SCSI_NCR_PCI_MEM_NOT_SUPPORTED
-static u_long __init remap_pci_mem(u_long base, u_long size)
-{
-	u_long page_base	= ((u_long) base) & PAGE_MASK;
-	u_long page_offs	= ((u_long) base) - page_base;
-	u_long page_remapped	= (u_long) ioremap(page_base, page_offs+size);
-
-	return page_remapped? (page_remapped + page_offs) : 0UL;
-}
-
-static void __init unmap_pci_mem(u_long vaddr, u_long size)
-{
-	if (vaddr)
-		iounmap((void *) (vaddr & PAGE_MASK));
-}
-
-#endif /* not def SCSI_NCR_PCI_MEM_NOT_SUPPORTED */
+#define memcpy_to_pci(a, b, c)	memcpy_toio((a), (b), (c))
 
 /*==========================================================
 **
@@ -518,13 +367,8 @@ static void __init unmap_pci_mem(u_long 
 **==========================================================
 */
 
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,1,105)
 #define UDELAY udelay
 #define MDELAY mdelay
-#else
-static void UDELAY(long us) { udelay(us); }
-static void MDELAY(long ms) { while (ms--) UDELAY(1000); }
-#endif
 
 /*==========================================================
 **
@@ -544,11 +388,7 @@ static void MDELAY(long ms) { while (ms-
 **==========================================================
 */
 
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,1,0)
 #define __GetFreePages(flags, order) __get_free_pages(flags, order)
-#else
-#define __GetFreePages(flags, order) __get_free_pages(flags, order, 0)
-#endif
 
 #define MEMO_SHIFT	4	/* 16 bytes minimum memory chunk */
 #if PAGE_SIZE >= 8192
@@ -2253,39 +2093,11 @@ sym53c8xx_pci_init(Scsi_Host_Template *t
 		command |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
 		pci_write_config_word(pdev, PCI_COMMAND, command);
 	}
-
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,2,0)
-	if ( is_prep ) {
-		if (io_port >= 0x10000000) {
-			printk(NAME53C8XX ": reallocating io_port (Wacky IBM)");
-			io_port = (io_port & 0x00FFFFFF) | 0x01000000;
-			pci_write_config_dword(pdev,
-					       PCI_BASE_ADDRESS_0, io_port);
-		}
-		if (base >= 0x10000000) {
-			printk(NAME53C8XX ": reallocating base (Wacky IBM)");
-			base = (base & 0x00FFFFFF) | 0x01000000;
-			pci_write_config_dword(pdev,
-					       PCI_BASE_ADDRESS_1, base);
-		}
-		if (base_2 >= 0x10000000) {
-			printk(NAME53C8XX ": reallocating base2 (Wacky IBM)");
-			base_2 = (base_2 & 0x00FFFFFF) | 0x01000000;
-			pci_write_config_dword(pdev,
-					       PCI_BASE_ADDRESS_2, base_2);
-		}
-	}
-#endif
 #endif	/* __powerpc__ */
 
 #if defined(__i386__) && !defined(MODULE)
 	if (!cache_line_size) {
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,1,75)
-		extern char x86;
-		switch(x86) {
-#else
 		switch(boot_cpu_data.x86) {
-#endif
 		case 4:	suggested_cache_line_size = 4; break;
 		case 6:
 		case 5:	suggested_cache_line_size = 8; break;
Index: drivers/scsi/sym53c8xx_defs.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_defs.h,v
retrieving revision 1.2
diff -u -p -r1.2 sym53c8xx_defs.h
--- drivers/scsi/sym53c8xx_defs.h	25 Aug 2003 19:49:06 -0000	1.2
+++ drivers/scsi/sym53c8xx_defs.h	11 Sep 2003 14:45:54 -0000
@@ -68,13 +68,8 @@
 **	Check supported Linux versions
 */
 
-#if !defined(LINUX_VERSION_CODE)
-#include <linux/version.h>
-#endif
 #include <linux/config.h>
 
-#define LinuxVersionCode(v, p, s) (((v)<<16)+((p)<<8)+(s))
-
 /*
  * NCR PQS/PDS special device support.
  */
@@ -183,11 +178,6 @@
 #define	SCSI_NCR_IOMAPPED
 #elif defined(__alpha__)
 #define	SCSI_NCR_IOMAPPED
-#elif defined(__powerpc__)
-#if LINUX_VERSION_CODE <= LinuxVersionCode(2,4,3)
-#define	SCSI_NCR_IOMAPPED
-#define SCSI_NCR_PCI_MEM_NOT_SUPPORTED
-#endif
 #endif
 
 /*
@@ -363,10 +353,6 @@
 
 #ifdef	__BIG_ENDIAN
 
-#if	LINUX_VERSION_CODE < LinuxVersionCode(2,1,0)
-#error	"BIG ENDIAN byte ordering needs kernel version >= 2.1.0"
-#endif
-
 #define	inw_l2b		inw
 #define	inl_l2b		inl
 #define	outw_b2l	outw
@@ -437,18 +423,9 @@
  *  Other architectures implement a weaker ordering that 
  *  requires memory barriers (and also IO barriers when they 
  *  make sense) to be used.
- *  We want to be paranoid for ppc and ia64. :)
  */
 
-#if	defined(__i386__) || defined(__x86_64__)
-#define MEMORY_BARRIER()	do { ; } while(0)
-#elif	defined	__powerpc__
-#define MEMORY_BARRIER()	__asm__ volatile("eieio; sync" : : : "memory")
-#elif	defined	__ia64__
-#define MEMORY_BARRIER()	__asm__ volatile("mf.a; mf" : : : "memory")
-#else
 #define MEMORY_BARRIER()	mb()
-#endif
 
 
 /*
Index: drivers/scsi/zalon.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/zalon.c,v
retrieving revision 1.3
diff -u -p -r1.3 zalon.c
--- drivers/scsi/zalon.c	23 Aug 2003 02:47:01 -0000	1.3
+++ drivers/scsi/zalon.c	11 Sep 2003 17:46:12 -0000
@@ -13,6 +13,8 @@
 #include <linux/config.h>
 #include <linux/module.h>
 
+#include <scsi/scsicam.h>
+
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/irq.h>
@@ -26,11 +28,27 @@
 
 #include "ncr53c8xx.h"
 
-#include "zalon.h"
-
 MODULE_AUTHOR("Richard Hirst");
 MODULE_DESCRIPTION("Bluefish/Zalon 720 SCSI Driver");
 MODULE_LICENSE("GPL");
+
+#define GSC_SCSI_ZALON_OFFSET 0x800
+
+#define IO_MODULE_EIM		(1*4)
+#define IO_MODULE_DC_ADATA	(2*4)
+#define IO_MODULE_II_CDATA	(3*4)
+#define IO_MODULE_IO_COMMAND	(12*4)
+#define IO_MODULE_IO_STATUS	(13*4)
+
+#define IOSTATUS_RY             0x40
+#define IOSTATUS_FE             0x80
+#define IOIIDATA_SMINT5L        0x40000000
+#define IOIIDATA_MINT5EN        0x20000000
+#define IOIIDATA_PACKEN         0x10000000
+#define IOIIDATA_PREFETCHEN     0x08000000
+#define IOIIDATA_IOII           0x00000020
+
+#define CMD_RESET		5
 
 static ncr_chip zalon720_chip __initdata = {
 	.device_id =	PSEUDO_720_ID,
Index: drivers/scsi/zalon.h
===================================================================
RCS file: drivers/scsi/zalon.h
diff -N drivers/scsi/zalon.h
--- drivers/scsi/zalon.h	29 Jul 2003 17:01:30 -0000	1.1
+++ /dev/null	1 Jan 1970 00:00:00 -0000
@@ -1,25 +0,0 @@
-#ifndef ZALON7XX_H
-#define ZALON7XX_H
-
-#include <linux/types.h>
-#include <scsi/scsicam.h>
-
-#define GSC_SCSI_ZALON_OFFSET 0x800
-
-#define IO_MODULE_EIM		(1*4)
-#define IO_MODULE_DC_ADATA	(2*4)
-#define IO_MODULE_II_CDATA	(3*4)
-#define IO_MODULE_IO_COMMAND	(12*4)
-#define IO_MODULE_IO_STATUS	(13*4)
-
-#define IOSTATUS_RY             0x40
-#define IOSTATUS_FE             0x80
-#define IOIIDATA_SMINT5L        0x40000000
-#define IOIIDATA_MINT5EN        0x20000000
-#define IOIIDATA_PACKEN         0x10000000
-#define IOIIDATA_PREFETCHEN     0x08000000
-#define IOIIDATA_IOII           0x00000020
-
-#define CMD_RESET		5
-
-#endif /* ZALON7XX_H */

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
