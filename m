From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Start cleaning up sym2
Date: Tue, 15 Jul 2003 23:31:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030715223134.GE23808@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:53741 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269826AbTGOWQp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2003 18:16:45 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Gerard Roudier <groudier@free.fr>
Cc: linux-scsi@vger.kernel.org


Start cleaning up the sym2 driver.
 - Remove ifdefs for 2.2/2.3/2.4 support -- if we want to backport this
   driver, we can have a sym_24glue.c or something.
 - Remove own PCI layer abstraction and use Linux's directly.

diff -urpNX build-tools/dontdiff linux-2.5.75/drivers/scsi/sym53c8xx_2/sym_glue.c linux-2.5.75-willy/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linux-2.5.75/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-07-10 14:15:45.000000000 -0600
+++ linux-2.5.75-willy/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-07-15 16:19:01.000000000 -0600
@@ -57,35 +57,6 @@
 #define NAME53C		"sym53c"
 #define NAME53C8XX	"sym53c8xx"
 
-/*
- *  Simple Wrapper to kernel PCI bus interface.
- */
-
-typedef struct pci_dev *pcidev_t;
-#define PCIDEV_NULL		(0)
-#define PciBusNumber(d)		(d)->bus->number
-#define PciDeviceFn(d)		(d)->devfn
-#define PciVendorId(d)		(d)->vendor
-#define PciDeviceId(d)		(d)->device
-#define PciIrqLine(d)		(d)->irq
-
-static u_long __init
-pci_get_base_cookie(struct pci_dev *pdev, int index)
-{
-	u_long base;
-
-#if LINUX_VERSION_CODE > LinuxVersionCode(2,3,12)
-	base = pdev->resource[index].start;
-#else
-	base = pdev->base_address[index];
-#if BITS_PER_LONG > 32
-	if ((base & 0x7) == 0x4)
-		base |= (((u_long)pdev->base_address[++index]) << 32);
-#endif
-#endif
-	return (base & ~0x7ul);
-}
-
 static int __init
 pci_get_base_address(struct pci_dev *pdev, int index, u_long *base)
 {
@@ -95,7 +66,7 @@ pci_get_base_address(struct pci_dev *pde
 	pci_read_config_dword(pdev, PCI_BAR_OFFSET(index), &tmp);
 	*base = tmp;
 	++index;
-	if ((tmp & 0x7) == 0x4) {
+	if ((tmp & 0x7) == PCI_BASE_ADDRESS_MEM_TYPE_64) {
 #if BITS_PER_LONG > 32
 		pci_read_config_dword(pdev, PCI_BAR_OFFSET(index), &tmp);
 		*base |= (((u_long)tmp) << 32);
@@ -106,14 +77,6 @@ pci_get_base_address(struct pci_dev *pde
 #undef PCI_BAR_OFFSET
 }
 
-#if LINUX_VERSION_CODE  < LinuxVersionCode(2,4,0)
-#define pci_enable_device(pdev)		(0)
-#endif
-
-#if LINUX_VERSION_CODE  < LinuxVersionCode(2,4,4)
-#define scsi_set_pci_device(inst, pdev)	do { ;} while (0)
-#endif
-
 /*
  *  Insert a delay in micro-seconds and milli-seconds.
  */
@@ -235,53 +198,8 @@ static void __init pci_unmap_mem(u_long 
  */
 static struct Scsi_Host	*first_host = NULL;
 
-/*
- *  /proc directory entry and proc_info.
- */
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,3,27)
-static struct proc_dir_entry proc_scsi_sym53c8xx = {
-    PROC_SCSI_SYM53C8XX, 9, NAME53C8XX,
-    S_IFDIR | S_IRUGO | S_IXUGO, 2
-};
-#endif
-
-/*
- *  Transfer direction
- *
- *  Until some linux kernel version near 2.3.40, low-level scsi 
- *  drivers were not told about data transfer direction.
- */
-#if LINUX_VERSION_CODE > LinuxVersionCode(2, 3, 40)
-
 #define scsi_data_direction(cmd)	(cmd->sc_data_direction)
 
-#else
-
-static __inline__ int scsi_data_direction(Scsi_Cmnd *cmd)
-{
-	int direction;
-
-	switch((int) cmd->cmnd[0]) {
-	case 0x08:  /*	READ(6)				08 */
-	case 0x28:  /*	READ(10)			28 */
-	case 0xA8:  /*	READ(12)			A8 */
-		direction = SCSI_DATA_READ;
-		break;
-	case 0x0A:  /*	WRITE(6)			0A */
-	case 0x2A:  /*	WRITE(10)			2A */
-	case 0xAA:  /*	WRITE(12)			AA */
-		direction = SCSI_DATA_WRITE;
-		break;
-	default:
-		direction = SCSI_DATA_UNKNOWN;
-		break;
-	}
-
-	return direction;
-}
-
-#endif
-
 /*
  *  Driver host data structure.
  */
@@ -367,7 +285,7 @@ typedef struct sym_ucmd *ucmd_p;
 #define bus_sg_dma_address(sc)	sg_dma_address(sc)
 #define bus_sg_dma_len(sc)	sg_dma_len(sc)
 
-static void __unmap_scsi_data(pcidev_t pdev, Scsi_Cmnd *cmd)
+static void __unmap_scsi_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
 {
 	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
 
@@ -383,7 +301,7 @@ static void __unmap_scsi_data(pcidev_t p
 	SYM_UCMD_PTR(cmd)->data_mapped = 0;
 }
 
-static bus_addr_t __map_scsi_single_data(pcidev_t pdev, Scsi_Cmnd *cmd)
+static bus_addr_t __map_scsi_single_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
 {
 	bus_addr_t mapping;
 	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
@@ -398,7 +316,7 @@ static bus_addr_t __map_scsi_single_data
 	return mapping;
 }
 
-static int __map_scsi_sg_data(pcidev_t pdev, Scsi_Cmnd *cmd)
+static int __map_scsi_sg_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
 {
 	int use_sg;
 	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
@@ -412,7 +330,7 @@ static int __map_scsi_sg_data(pcidev_t p
 	return use_sg;
 }
 
-static void __sync_scsi_data(pcidev_t pdev, Scsi_Cmnd *cmd)
+static void __sync_scsi_data(struct pci_dev *pdev, Scsi_Cmnd *cmd)
 {
 	int dma_dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
 
@@ -581,9 +499,7 @@ void sym_set_cam_result_error(hcb_p np, 
 		 */
 		cam_status = sym_xerr_cam_status(DID_ERROR, cp->xerr_status);
 	}
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,3,99)
 	csio->resid = resid;
-#endif
 	csio->result = (drv_status << 24) + (cam_status << 16) + scsi_status;
 }
 
@@ -841,20 +757,6 @@ static void sym_timer (hcb_p np)
 {
 	u_long	thistime = ktime_get(0);
 
-#if LINUX_VERSION_CODE < LinuxVersionCode(2, 4, 0)
-	/*
-	 *  If release process in progress, let's go
-	 *  Set the release stage from 1 to 2 to synchronize
-	 *  with the release process.
-	 */
-
-	if (np->s.release_stage) {
-		if (np->s.release_stage == 1)
-			np->s.release_stage = 2;
-		return;
-	}
-#endif
-
 	/*
 	 *  Restart the timer.
 	 */
@@ -1146,11 +1048,7 @@ prepare:
 		goto finish;
 		break;
 	case SYM_EH_DO_WAIT:
-#if LINUX_VERSION_CODE > LinuxVersionCode(2,3,0)
 		init_MUTEX_LOCKED(&ep->sem);
-#else
-		ep->sem = MUTEX_LOCKED;
-#endif
 		/* fall through */
 	case SYM_EH_DO_COMPLETE:
 		ep->old_done = cmd->scsi_done;
@@ -1848,10 +1746,6 @@ static void sym_free_resources(hcb_p np)
 #ifdef SYM_LINUX_DYNAMIC_DMA_MAPPING
 static int sym_setup_bus_dma_mask(hcb_p np)
 {
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,4,3)
-	if (!pci_dma_supported(np->s.device, 0xffffffffUL))
-		goto out_err32;
-#else
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 0
 	if (pci_set_dma_mask(np->s.device, 0xffffffffUL))
 		goto out_err32;
@@ -1874,7 +1768,6 @@ static int sym_setup_bus_dma_mask(hcb_p 
 	}
 #undef	PciDmaMask
 #endif
-#endif
 	return 0;
 
 out_err32:
@@ -2101,11 +1994,7 @@ sym_attach (Scsi_Host_Template *tpnt, in
 	instance->max_id	= np->maxwide ? 16 : 8;
 	instance->max_lun	= SYM_CONF_MAX_LUN;
 #ifndef SYM_CONF_IOMAPPED
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,3,29)
 	instance->base		= (unsigned long) np->s.mmio_va;
-#else
-	instance->base		= (char *) np->s.mmio_va;
-#endif
 #endif
 	instance->irq		= np->s.irq;
 	instance->unique_id	= np->s.io_port;
@@ -2115,9 +2004,7 @@ sym_attach (Scsi_Host_Template *tpnt, in
 	instance->cmd_per_lun	= SYM_CONF_MAX_TAG;
 	instance->can_queue	= (SYM_CONF_MAX_START-2);
 	instance->sg_tablesize	= SYM_CONF_MAX_SG;
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,0)
 	instance->max_cmd_len	= 16;
-#endif
 	instance->highmem_io	= 1;
 
 	SYM_UNLOCK_HCB(np, flags);
@@ -2366,11 +2253,9 @@ int __init sym53c8xx_setup(char *str)
 	return 1;
 }
 
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,3,13)
 #ifndef MODULE
 __setup("sym53c8xx=", sym53c8xx_setup);
 #endif
-#endif
 
 #ifdef	SYM_CONF_PQS_PDS_SUPPORT
 /*
@@ -2396,17 +2281,17 @@ static int pqs_bus[SYM_CONF_MAX_PQS_BUS]
 static void __init sym_detect_pqs_pds(void)
 {
 	short index;
-	pcidev_t dev = PCIDEV_NULL;
+	struct pci_dev *dev = NULL;
 
 	for(index=0; index < SYM_CONF_MAX_PQS_BUS; index++) {
 		u_char tmp;
 
 		dev = pci_find_device(0x101a, 0x0009, dev);
-		if (dev == PCIDEV_NULL) {
+		if (dev == NULL) {
 			pqs_bus[index] = -1;
 			break;
 		}
-		printf_info(NAME53C8XX ": NCR PQS/PDS memory controller detected on bus %d\n", PciBusNumber(dev));
+		printf_info(NAME53C8XX ": NCR PQS/PDS memory controller detected on bus %d\n", dev->bus->number);
 		pci_read_config_byte(dev, 0x44, &tmp);
 		/* bit 1: allow individual 875 configuration */
 		tmp |= 0x2;
@@ -2416,7 +2301,7 @@ static void __init sym_detect_pqs_pds(vo
 		tmp |= 0x4;
 		pci_write_config_byte(dev, 0x45, tmp);
 
-		pqs_bus[index] = PciBusNumber(dev);
+		pqs_bus[index] = dev->bus->number;
 	}
 }
 #endif /* SYM_CONF_PQS_PDS_SUPPORT */
@@ -2427,7 +2312,7 @@ static void __init sym_detect_pqs_pds(vo
  *  been detected.
  */
 static int __init
-sym53c8xx_pci_init(Scsi_Host_Template *tpnt, pcidev_t pdev, sym_device *device)
+sym53c8xx_pci_init(Scsi_Host_Template *tpnt, struct pci_dev *pdev, sym_device *device)
 {
 	u_short vendor_id, device_id, command, status_reg;
 	u_char cache_line_size;
@@ -2435,34 +2320,30 @@ sym53c8xx_pci_init(Scsi_Host_Template *t
 	u_char pci_fix_up = SYM_SETUP_PCI_FIX_UP;
 	u_char revision;
 	u_int irq;
-	u_long base, base_2, base_io; 
+	u_long base, base_2; 
 	u_long base_c, base_2_c, io_port; 
 	int i;
 	sym_chip *chip;
 
 	/* Choose some short name for this device */
-	sprintf(device->s.inst_name, "sym.%d.%d.%d",
-		PciBusNumber(pdev),
-		(int) (PciDeviceFn(pdev) & 0xf8) >> 3,
-		(int) (PciDeviceFn(pdev) & 7));
+	sprintf(device->s.inst_name, "sym.%d.%d.%d", pdev->bus->number,
+			PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
 	/*
 	 *  Read needed minimal info from the PCI config space.
 	 */
-	vendor_id = PciVendorId(pdev);
-	device_id = PciDeviceId(pdev);
-	irq	  = PciIrqLine(pdev);
+	vendor_id = pdev->vendor;
+	device_id = pdev->device;
+	irq	  = pdev->irq;
 
-	i = pci_get_base_address(pdev, 0, &base_io);
-	io_port = pci_get_base_cookie(pdev, 0);
+	io_port = pdev->resource[0].start;
 
-	base_c = pci_get_base_cookie(pdev, i);
-	i = pci_get_base_address(pdev, i, &base);
+	base_c = pdev->resource[1].start;
+	i = pci_get_base_address(pdev, 1, &base);
 
-	base_2_c = pci_get_base_cookie(pdev, i);
-	(void) pci_get_base_address(pdev, i, &base_2);
+	base_2_c = pdev->resource[i].start;
+	pci_get_base_address(pdev, i, &base_2);
 
-	io_port &= PCI_BASE_ADDRESS_IO_MASK;
 	base	&= PCI_BASE_ADDRESS_MEM_MASK;
 	base_2	&= PCI_BASE_ADDRESS_MEM_MASK;
 
@@ -2471,9 +2352,9 @@ sym53c8xx_pci_init(Scsi_Host_Template *t
 	/*
 	 *  If user excluded this chip, donnot initialize it.
 	 */
-	if (base_io) {
+	if (io_port) {
 		for (i = 0 ; i < 8 ; i++) {
-			if (sym_driver_setup.excludes[i] == base_io)
+			if (sym_driver_setup.excludes[i] == io_port)
 				return -1;
 		}
 	}
@@ -2635,8 +2516,8 @@ sym53c8xx_pci_init(Scsi_Host_Template *t
 	 *  Initialise device structure with items required by sym_attach.
 	 */
 	device->pdev		= pdev;
-	device->s.bus		= PciBusNumber(pdev);
-	device->s.device_fn	= PciDeviceFn(pdev);
+	device->s.bus		= pdev->bus->number;
+	device->s.device_fn	= pdev->devfn;
 	device->s.base		= base;
 	device->s.base_2	= base_2;
 	device->s.base_c	= base_c;
@@ -2680,7 +2561,7 @@ static u_short sym_chip_ids[] __initdata
  */
 int __init sym53c8xx_detect(Scsi_Host_Template *tpnt)
 {
-	pcidev_t pcidev;
+	struct pci_dev *pcidev;
 	int i, j, chips, hosts, count;
 	int attach_count = 0;
 	sym_device *devtbl, *devp;
@@ -2732,7 +2613,7 @@ if (sym53c8xx)
 #endif
 	j = 0;
 	count = 0;
-	pcidev = PCIDEV_NULL;
+	pcidev = NULL;
 	while (1) {
 		char *msg = "";
 		if (count >= hosts)
@@ -2742,7 +2623,7 @@ if (sym53c8xx)
 		i = sym_driver_setup.reverse_probe ? chips - 1 - j : j;
 		pcidev = pci_find_device(PCI_VENDOR_ID_NCR, sym_chip_ids[i],
 					 pcidev);
-		if (pcidev == PCIDEV_NULL) {
+		if (pcidev == NULL) {
 			++j;
 			continue;
 		}
@@ -2784,7 +2665,7 @@ if (sym53c8xx)
 		 */
 		for(i = 0; i < SYM_CONF_MAX_PQS_BUS && pqs_bus[i] != -1; i++) {
 			u_char tmp;
-			if (pqs_bus[i] == PciBusNumber(pcidev)) {
+			if (pqs_bus[i] == pcidev->bus->number) {
 				pci_read_config_byte(pcidev, 0x84, &tmp);
 				devp->pqs_pds = 1;
 				devp->host_id = tmp;
@@ -2878,32 +2759,7 @@ static int sym_detach(hcb_p np)
 {
 	printk("%s: detaching ...\n", sym_name(np));
 
-	/*
-	 *  Try to delete the timer.
-	 *  In the unlikely situation where this failed,
-	 *  try to synchronize with the timer handler.
-	 */
-#if LINUX_VERSION_CODE < LinuxVersionCode(2, 4, 0)
-	np->s.release_stage = 1;
-	if (!del_timer(&np->s.timer)) {
-		int i = 1000;
-		int k = 1;
-		while (1) {
-			u_long flags;
-			SYM_LOCK_HCB(np, flags);
-			k = np->s.release_stage;
-			SYM_UNLOCK_HCB(np, flags);
-			if (k == 2 || !--i)
-				break;
-			MDELAY(5);
-		}
-		if (!i)
-			printk("%s: failed to kill timer!\n", sym_name(np));
-	}
-	np->s.release_stage = 2;
-#else
-	(void)del_timer_sync(&np->s.timer);
-#endif
+	del_timer_sync(&np->s.timer);
 
 	/*
 	 *  Reset NCR chip.
@@ -2956,11 +2812,7 @@ static Scsi_Host_Template driver_templat
 	.highmem_io		= 1,
 #ifdef SYM_LINUX_PROC_INFO_SUPPORT
 	.proc_info		= sym53c8xx_proc_info,
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,3,27)
-	.proc_dir		= &proc_scsi_sym53c8xx,
-#else
 	.proc_name		= NAME53C8XX,
 #endif
-#endif
 };
 #include "../scsi_module.c"
diff -urpNX build-tools/dontdiff linux-2.5.75/drivers/scsi/sym53c8xx_2/sym_glue.h linux-2.5.75-willy/drivers/scsi/sym53c8xx_2/sym_glue.h
--- linux-2.5.75/drivers/scsi/sym53c8xx_2/sym_glue.h	2003-07-10 14:15:35.000000000 -0600
+++ linux-2.5.75-willy/drivers/scsi/sym53c8xx_2/sym_glue.h	2003-07-15 15:12:35.000000000 -0600
@@ -57,20 +57,10 @@
 #define SYM_CONF_DMA_ADDRESSING_MODE 2
 #endif
 
-#define LinuxVersionCode(v, p, s) (((v)<<16)+((p)<<8)+(s))
-#include <linux/version.h>
-#if	LINUX_VERSION_CODE < LinuxVersionCode(2, 2, 0)
-#error	"This driver requires a kernel version not lower than 2.2.0"
-#endif
-
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/system.h>
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,3,17)
 #include <linux/spinlock.h>
-#else
-#include <asm/spinlock.h>
-#endif
 #include <linux/delay.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
@@ -91,29 +81,11 @@
 #endif
 #include <linux/init.h>
 
-#ifndef	__init
-#define	__init
-#endif
-#ifndef	__initdata
-#define	__initdata
-#endif
-
 #include "../scsi.h"
 #include "../hosts.h"
 
 #include <linux/types.h>
 
-/*
- *  Define BITS_PER_LONG for earlier linux versions.
- */
-#ifndef	BITS_PER_LONG
-#if (~0UL) == 0xffffffffUL
-#define	BITS_PER_LONG	32
-#else
-#define	BITS_PER_LONG	64
-#endif
-#endif
-
 typedef	u_long	vm_offset_t;
 
 #ifndef bcopy
@@ -139,9 +111,7 @@ typedef	u_long	vm_offset_t;
 /*
  * Configuration addendum for Linux.
  */
-#if	LINUX_VERSION_CODE >= LinuxVersionCode(2,3,47)
 #define	SYM_LINUX_DYNAMIC_DMA_MAPPING
-#endif
 
 #define	SYM_CONF_TIMER_INTERVAL		((HZ+1)/2)
 
@@ -472,9 +442,6 @@ struct sym_shcb {
 	u_long		lasttime;
 	u_long		settle_time;	/* Resetting the SCSI BUS	*/
 	u_char		settle_time_valid;
-#if LINUX_VERSION_CODE < LinuxVersionCode(2, 4, 0)
-	u_char		release_stage;	/* Synchronisation on release	*/
-#endif
 };
 
 /*
@@ -647,9 +614,7 @@ static __inline void sym_set_cam_result_
 {
 	Scsi_Cmnd *cmd = cp->cam_ccb;
 
-#if LINUX_VERSION_CODE >= LinuxVersionCode(2,3,99)
 	cmd->resid = resid;
-#endif
 	cmd->result = (((DID_OK) << 16) + ((cp->ssss_status) & 0x7f));
 }
 void sym_set_cam_result_error(hcb_p np, ccb_p cp, int resid);

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
