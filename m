From: domen@coderock.org
Subject: [patch 1/1] drivers/scsi/: Use the DMA_32BIT_MASK constant
Date: Fri, 08 Apr 2005 09:53:21 +0200
Message-ID: <20050408075321.84CC21F3A4@trashy.coderock.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:36832 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262744AbVDHHyB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2005 03:54:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, tklauser@nuerscht.ch



The previous patch did not compile cleanly on all architectures so
here's a fixed one.

Use the DMA_32BIT_MASK constant from dma-mapping.h when calling
pci_set_dma_mask() or pci_set_consistent_dma_mask()
This patch includes dma-mapping.h explicitly because it caused errors
on some architectures otherwise.
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 drivers/scsi/sata_vsc.c                        |    0 
 kj-domen/drivers/scsi/BusLogic.c               |    7 ++++---
 kj-domen/drivers/scsi/a100u2w.c                |    3 ++-
 kj-domen/drivers/scsi/aacraid/aachba.c         |    9 +++++----
 kj-domen/drivers/scsi/aacraid/linit.c          |    7 ++++---
 kj-domen/drivers/scsi/aic7xxx/aic79xx_osm.c    |    3 ++-
 kj-domen/drivers/scsi/aic7xxx/aic7xxx_osm.c    |    3 ++-
 kj-domen/drivers/scsi/atp870u.c                |    3 ++-
 kj-domen/drivers/scsi/dpt_i2o.c                |    5 +++--
 kj-domen/drivers/scsi/eata.c                   |    3 ++-
 kj-domen/drivers/scsi/gdth.c                   |    7 ++++---
 kj-domen/drivers/scsi/initio.c                 |    3 ++-
 kj-domen/drivers/scsi/ips.c                    |    5 +++--
 kj-domen/drivers/scsi/megaraid.c               |    7 ++++---
 kj-domen/drivers/scsi/megaraid/megaraid_mbox.c |    5 +++--
 kj-domen/drivers/scsi/nsp32.c                  |    3 ++-
 kj-domen/drivers/scsi/qla1280.c                |    5 +++--
 kj-domen/drivers/scsi/qlogicfc.c               |    5 +++--
 18 files changed, 50 insertions(+), 33 deletions(-)

diff -puN drivers/scsi/BusLogic.c~dma_mask-drivers_scsi drivers/scsi/BusLogic.c
--- kj/drivers/scsi/BusLogic.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/BusLogic.c	2005-04-05 12:57:47.000000000 +0200
@@ -41,6 +41,7 @@
 #include <linux/stat.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
 #include <scsi/scsicam.h>
 
 #include <asm/dma.h>
@@ -676,7 +677,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -831,7 +832,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -885,7 +886,7 @@ static int __init BusLogic_InitializeFla
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
diff -puN drivers/scsi/a100u2w.c~dma_mask-drivers_scsi drivers/scsi/a100u2w.c
--- kj/drivers/scsi/a100u2w.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/a100u2w.c	2005-04-05 12:57:47.000000000 +0200
@@ -89,6 +89,7 @@
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -1052,7 +1053,7 @@ static int __devinit inia100_probe_one(s
 
 	if (pci_enable_device(pdev))
 		goto out;
-	if (pci_set_dma_mask(pdev, 0xffffffffULL)) {
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING "Unable to set 32bit DMA "
 				    "on inia100 adapter, ignoring.\n");
 		goto out_disable_device;
diff -puN drivers/scsi/aacraid/aachba.c~dma_mask-drivers_scsi drivers/scsi/aacraid/aachba.c
--- kj/drivers/scsi/aacraid/aachba.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/aacraid/aachba.c	2005-04-05 12:57:47.000000000 +0200
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/completion.h>
 #include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
@@ -692,12 +693,12 @@ int aac_get_adapter_info(struct aac_dev*
 		dev->dac_support = (dacmode!=0);
 	}
 	if(dev->dac_support != 0) {
-		if (!pci_set_dma_mask(dev->pdev, 0xFFFFFFFFFFFFFFFFULL) &&
-			!pci_set_consistent_dma_mask(dev->pdev, 0xFFFFFFFFFFFFFFFFULL)) {
+		if (!pci_set_dma_mask(dev->pdev, DMA_64BIT_MASK) &&
+			!pci_set_consistent_dma_mask(dev->pdev, DMA_64BIT_MASK)) {
 			printk(KERN_INFO"%s%d: 64 Bit DAC enabled\n",
 				dev->name, dev->id);
-		} else if (!pci_set_dma_mask(dev->pdev, 0xFFFFFFFFULL) &&
-			!pci_set_consistent_dma_mask(dev->pdev, 0xFFFFFFFFULL)) {
+		} else if (!pci_set_dma_mask(dev->pdev, DMA_32BIT_MASK) &&
+			!pci_set_consistent_dma_mask(dev->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_INFO"%s%d: DMA mask set failed, 64 Bit DAC disabled\n",
 				dev->name, dev->id);
 			dev->dac_support = 0;
diff -puN drivers/scsi/aacraid/linit.c~dma_mask-drivers_scsi drivers/scsi/aacraid/linit.c
--- kj/drivers/scsi/aacraid/linit.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/aacraid/linit.c	2005-04-05 12:57:47.000000000 +0200
@@ -46,6 +46,7 @@
 #include <linux/ioctl32.h>
 #include <linux/delay.h>
 #include <linux/smp_lock.h>
+#include <linux/dma-mapping.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
@@ -582,8 +583,8 @@ static int __devinit aac_probe_one(struc
 	if (pci_enable_device(pdev))
 		goto out;
 
-	if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL) || 
-			pci_set_consistent_dma_mask(pdev, 0xFFFFFFFFULL))
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
+			pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK))
 		goto out;
 	/*
 	 * If the quirk31 bit is set, the adapter needs adapter
@@ -626,7 +627,7 @@ static int __devinit aac_probe_one(struc
 	 * address space.
 	 */
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
-		if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK))
 			goto out_free_fibs;
 
 	aac_get_adapter_info(aac);
diff -puN drivers/scsi/ahci.c~dma_mask-drivers_scsi drivers/scsi/ahci.c
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~dma_mask-drivers_scsi drivers/scsi/aic7xxx/aic79xx_osm.c
--- kj/drivers/scsi/aic7xxx/aic79xx_osm.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-04-05 12:57:47.000000000 +0200
@@ -60,6 +60,7 @@
 
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/delay.h>	/* For ssleep/msleep */
+#include <linux/dma-mapping.h>
 
 /*
  * Lock protecting manipulation of the ahd softc list.
@@ -1706,7 +1707,7 @@ ahd_dmamem_alloc(struct ahd_softc *ahd, 
 	 * our dma mask when doing allocations.
 	 */
 	if (ahd->dev_softc != NULL)
-		if (pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(ahd->dev_softc, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
 			kfree(map);
 			return (ENODEV);
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~dma_mask-drivers_scsi drivers/scsi/aic7xxx/aic7xxx_osm.c
--- kj/drivers/scsi/aic7xxx/aic7xxx_osm.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-04-05 12:57:47.000000000 +0200
@@ -138,6 +138,7 @@
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/blkdev.h>		/* For block_size() */
 #include <linux/delay.h>	/* For ssleep/msleep */
+#include <linux/dma-mapping.h>
 
 /*
  * Lock protecting manipulation of the ahc softc list.
@@ -1361,7 +1362,7 @@ ahc_dmamem_alloc(struct ahc_softc *ahc, 
 	 * our dma mask when doing allocations.
 	 */
 	if (ahc->dev_softc != NULL)
-		if (pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(ahc->dev_softc, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
 			kfree(map);
 			return (ENODEV);
diff -puN drivers/scsi/atp870u.c~dma_mask-drivers_scsi drivers/scsi/atp870u.c
--- kj/drivers/scsi/atp870u.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/atp870u.c	2005-04-05 12:57:47.000000000 +0200
@@ -28,6 +28,7 @@
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
 #include <asm/system.h>
 #include <asm/io.h>
 
@@ -2630,7 +2631,7 @@ static int atp870u_probe(struct pci_dev 
 	if (pci_enable_device(pdev))
 		return -EIO;
 
-        if (!pci_set_dma_mask(pdev, 0xFFFFFFFFUL)) {
+	if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
                 printk(KERN_INFO "atp870u: use 32bit DMA mask.\n");
         } else {
                 printk(KERN_ERR "atp870u: DMA mask required but not available.\n");
diff -puN drivers/scsi/dpt_i2o.c~dma_mask-drivers_scsi drivers/scsi/dpt_i2o.c
--- kj/drivers/scsi/dpt_i2o.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/dpt_i2o.c	2005-04-05 12:57:47.000000000 +0200
@@ -62,6 +62,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Dri
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/processor.h>	/* for boot_cpu_data */
 #include <asm/pgtable.h>
@@ -881,8 +882,8 @@ static int adpt_install_hba(struct scsi_
 		return -EINVAL;
 	}
 	pci_set_master(pDev);
-	if (pci_set_dma_mask(pDev, 0xffffffffffffffffULL) &&
-	    pci_set_dma_mask(pDev, 0xffffffffULL))
+	if (pci_set_dma_mask(pDev, DMA_64BIT_MASK) &&
+	    pci_set_dma_mask(pDev, DMA_32BIT_MASK))
 		return -EINVAL;
 
 	base_addr0_phys = pci_resource_start(pDev,0);
diff -puN drivers/scsi/eata.c~dma_mask-drivers_scsi drivers/scsi/eata.c
--- kj/drivers/scsi/eata.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/eata.c	2005-04-05 12:57:47.000000000 +0200
@@ -490,6 +490,7 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
 #include <asm/byteorder.h>
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -1430,7 +1431,7 @@ static int port_detect(unsigned long por
 
 	if (ha->pdev) {
 		pci_set_master(ha->pdev);
-		if (pci_set_dma_mask(ha->pdev, 0xffffffff))
+		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK))
 			printk("%s: warning, pci_set_dma_mask failed.\n",
 			       ha->board_name);
 	}
diff -puN drivers/scsi/gdth.c~dma_mask-drivers_scsi drivers/scsi/gdth.c
--- kj/drivers/scsi/gdth.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/gdth.c	2005-04-05 12:57:47.000000000 +0200
@@ -402,6 +402,7 @@
 #include <linux/blkdev.h>
 #else
 #include <linux/blk.h>
+#include <linux/dma-mapping.h>
 #include "sd.h"
 #endif
 
@@ -4529,15 +4530,15 @@ int __init gdth_detect(Scsi_Host_Templat
             if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat &GDT_64BIT)||
                 /* 64-bit DMA only supported from FW >= x.43 */
                 (!ha->dma64_support)) {
-                if (pci_set_dma_mask(pcistr[ctr].pdev, 0xffffffff)) {
+                if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
                     printk(KERN_WARNING "GDT-PCI %d: Unable to set 32-bit DMA\n", hanum);
                     err = TRUE;
                 }
             } else {
                 shp->max_cmd_len = 16;
-                if (!pci_set_dma_mask(pcistr[ctr].pdev, 0xffffffffffffffffULL)) {
+                if (!pci_set_dma_mask(pcistr[ctr].pdev, DMA_64BIT_MASK)) {
                     printk("GDT-PCI %d: 64-bit DMA enabled\n", hanum);
-                } else if (pci_set_dma_mask(pcistr[ctr].pdev, 0xffffffff)) {
+                } else if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
                     printk(KERN_WARNING "GDT-PCI %d: Unable to set 64/32-bit DMA\n", hanum);
                     err = TRUE;
                 }
diff -puN drivers/scsi/initio.c~dma_mask-drivers_scsi drivers/scsi/initio.c
--- kj/drivers/scsi/initio.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/initio.c	2005-04-05 12:57:47.000000000 +0200
@@ -127,6 +127,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
+#include <linux/dma-mapping.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
@@ -2793,7 +2794,7 @@ static int tul_NewReturnNumberOfAdapters
 			if (((dRegValue & 0xFF00) >> 8) == 0xFF)
 				dRegValue = 0;
 			wBIOS = (wBIOS << 8) + ((UWORD) ((dRegValue & 0xFF00) >> 8));
-			if (pci_set_dma_mask(pDev, 0xffffffff)) {
+			if (pci_set_dma_mask(pDev, DMA_32BIT_MASK)) {
 				printk(KERN_WARNING 
 				       "i91u: Could not set 32 bit DMA mask\n");
 				continue;
diff -puN drivers/scsi/ips.c~dma_mask-drivers_scsi drivers/scsi/ips.c
--- kj/drivers/scsi/ips.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/ips.c	2005-04-05 12:57:47.000000000 +0200
@@ -176,6 +176,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/types.h>
+#include <linux/dma-mapping.h>
 
 #include <scsi/sg.h>
 
@@ -7288,10 +7289,10 @@ ips_init_phase1(struct pci_dev *pci_dev,
 	 * are guaranteed to be < 4G.
 	 */
 	if (IPS_ENABLE_DMA64 && IPS_HAS_ENH_SGLIST(ha) &&
-	    !pci_set_dma_mask(ha->pcidev, 0xffffffffffffffffULL)) {
+	    !pci_set_dma_mask(ha->pcidev, DMA_64BIT_MASK)) {
 		(ha)->flags |= IPS_HA_ENH_SG;
 	} else {
-		if (pci_set_dma_mask(ha->pcidev, 0xffffffffULL) != 0) {
+		if (pci_set_dma_mask(ha->pcidev, DMA_32BIT_MASK) != 0) {
 			printk(KERN_WARNING "Unable to set DMA Mask\n");
 			return ips_abort_init(ha, index);
 		}
diff -puN drivers/scsi/megaraid.c~dma_mask-drivers_scsi drivers/scsi/megaraid.c
--- kj/drivers/scsi/megaraid.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/megaraid.c	2005-04-05 12:57:47.000000000 +0200
@@ -43,6 +43,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/dma-mapping.h>
 #include <scsi/scsicam.h>
 
 #include "scsi.h"
@@ -2060,7 +2061,7 @@ make_local_pdev(adapter_t *adapter, stru
 
 	memcpy(*pdev, adapter->dev, sizeof(struct pci_dev));
 
-	if( pci_set_dma_mask(*pdev, 0xffffffff) != 0 ) {
+	if( pci_set_dma_mask(*pdev, DMA_32BIT_MASK) != 0 ) {
 		kfree(*pdev);
 		return -1;
 	}
@@ -4854,10 +4855,10 @@ megaraid_probe_one(struct pci_dev *pdev,
 
 	/* Set the Mode of addressing to 64 bit if we can */
 	if ((adapter->flag & BOARD_64BIT) && (sizeof(dma_addr_t) == 8)) {
-		pci_set_dma_mask(pdev, 0xffffffffffffffffULL);
+		pci_set_dma_mask(pdev, DMA_64BIT_MASK);
 		adapter->has_64bit_addr = 1;
 	} else  {
-		pci_set_dma_mask(pdev, 0xffffffff);
+		pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 		adapter->has_64bit_addr = 0;
 	}
 		
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~dma_mask-drivers_scsi drivers/scsi/megaraid/megaraid_mbox.c
--- kj/drivers/scsi/megaraid/megaraid_mbox.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/megaraid/megaraid_mbox.c	2005-04-05 12:57:47.000000000 +0200
@@ -69,6 +69,7 @@
  * For history of changes, see Documentation/ChangeLog.megaraid
  */
 
+#include <linux/dma-mapping.h>
 #include "megaraid_mbox.h"
 
 static int megaraid_init(void);
@@ -619,7 +620,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 
 	// Setup the default DMA mask. This would be changed later on
 	// depending on hardware capabilities
-	if (pci_set_dma_mask(adapter->pdev, 0xFFFFFFFF) != 0) {
+	if (pci_set_dma_mask(adapter->pdev, DMA_32BIT_MASK) != 0) {
 
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: pci_set_dma_mask failed:%d\n", __LINE__));
@@ -1031,7 +1032,7 @@ megaraid_init_mbox(adapter_t *adapter)
 
 	// Set the DMA mask to 64-bit. All supported controllers as capable of
 	// DMA in this range
-	if (pci_set_dma_mask(adapter->pdev, 0xFFFFFFFFFFFFFFFFULL) != 0) {
+	if (pci_set_dma_mask(adapter->pdev, DMA_64BIT_MASK) != 0) {
 
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: could not set DMA mask for 64-bit.\n"));
diff -puN drivers/scsi/nsp32.c~dma_mask-drivers_scsi drivers/scsi/nsp32.c
--- kj/drivers/scsi/nsp32.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/nsp32.c	2005-04-05 12:57:47.000000000 +0200
@@ -38,6 +38,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/dma.h>
 #include <asm/system.h>
@@ -2779,7 +2780,7 @@ static int nsp32_detect(Scsi_Host_Templa
 	/*
 	 * setup DMA 
 	 */
-	if (pci_set_dma_mask(PCIDEV, 0xffffffffUL) != 0) {
+	if (pci_set_dma_mask(PCIDEV, DMA_32BIT_MASK) != 0) {
 		nsp32_msg (KERN_ERR, "failed to set PCI DMA mask");
 		goto scsi_unregister;
 	}
diff -puN drivers/scsi/qla1280.c~dma_mask-drivers_scsi drivers/scsi/qla1280.c
--- kj/drivers/scsi/qla1280.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/qla1280.c	2005-04-05 12:57:47.000000000 +0200
@@ -348,6 +348,7 @@
 #include <linux/pci_ids.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -4625,7 +4626,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 
 #ifdef QLA_64BIT_PTR
 	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
-		if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
+		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       " suitable DMA mask - aboring\n", ha->host_no);
 			error = -ENODEV;
@@ -4635,7 +4636,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
 			ha->host_no);
 #else
-	if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING "scsi(%li): Unable to set a "
 		       " suitable DMA mask - aboring\n", ha->host_no);
 		error = -ENODEV;
diff -puN drivers/scsi/qlogicfc.c~dma_mask-drivers_scsi drivers/scsi/qlogicfc.c
--- kj/drivers/scsi/qlogicfc.c~dma_mask-drivers_scsi	2005-04-05 12:57:47.000000000 +0200
+++ kj-domen/drivers/scsi/qlogicfc.c	2005-04-05 12:57:47.000000000 +0200
@@ -61,6 +61,7 @@
 #include <linux/unistd.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include "scsi.h"
@@ -737,8 +738,8 @@ static int isp2x00_detect(Scsi_Host_Temp
 				continue;
 
 			/* Try to configure DMA attributes. */
-			if (pci_set_dma_mask(pdev, 0xffffffffffffffffULL) &&
-			    pci_set_dma_mask(pdev, 0xffffffffULL))
+			if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) &&
+			    pci_set_dma_mask(pdev, DMA_32BIT_MASK))
 					continue;
 
 		        host = scsi_register(tmpt, sizeof(struct isp2x00_hostdata));
diff -puN drivers/scsi/sata_vsc.c~dma_mask-drivers_scsi drivers/scsi/sata_vsc.c
_
