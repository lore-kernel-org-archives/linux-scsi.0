From: domen@coderock.org
Subject: [patch 10/11] drivers/scsi/: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 06 Mar 2005 23:27:20 +0100
Message-ID: <20050306222721.1E3391F208@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:3503 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261541AbVCFW20 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:28:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, tklauser@nuerscht.ch


Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h
when calling pci_set_dma_mask() or pci_set_consistent_dma_mask()
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

[Merged multiple patches, I can send split ones if desired -domen]

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/BusLogic.c               |    6 +++---
 kj-domen/drivers/scsi/a100u2w.c                |    2 +-
 kj-domen/drivers/scsi/aacraid/aachba.c         |    8 ++++----
 kj-domen/drivers/scsi/aacraid/linit.c          |    6 +++---
 kj-domen/drivers/scsi/aic7xxx/aic79xx_osm.c    |    2 +-
 kj-domen/drivers/scsi/aic7xxx/aic7xxx_osm.c    |    2 +-
 kj-domen/drivers/scsi/atp870u.c                |    2 +-
 kj-domen/drivers/scsi/dpt_i2o.c                |    4 ++--
 kj-domen/drivers/scsi/eata.c                   |    2 +-
 kj-domen/drivers/scsi/gdth.c                   |    6 +++---
 kj-domen/drivers/scsi/initio.c                 |    2 +-
 kj-domen/drivers/scsi/ips.c                    |    4 ++--
 kj-domen/drivers/scsi/megaraid.c               |    6 +++---
 kj-domen/drivers/scsi/megaraid/megaraid_mbox.c |    4 ++--
 kj-domen/drivers/scsi/nsp32.c                  |    2 +-
 kj-domen/drivers/scsi/qla1280.c                |    4 ++--
 kj-domen/drivers/scsi/qlogicfc.c               |    4 ++--
 17 files changed, 33 insertions(+), 33 deletions(-)

diff -puN drivers/scsi/BusLogic.c~dma_mask-drivers_scsi drivers/scsi/BusLogic.c
--- kj/drivers/scsi/BusLogic.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/BusLogic.c	2005-03-05 16:13:22.000000000 +0100
@@ -676,7 +676,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -831,7 +831,7 @@ static int __init BusLogic_InitializeMul
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
@@ -885,7 +885,7 @@ static int __init BusLogic_InitializeFla
 		if (pci_enable_device(PCI_Device))
 			continue;
 
-		if (pci_set_dma_mask(PCI_Device, (u64) 0xffffffff))
+		if (pci_set_dma_mask(PCI_Device, DMA_32BIT_MASK))
 			continue;
 
 		Bus = PCI_Device->bus->number;
diff -puN drivers/scsi/a100u2w.c~dma_mask-drivers_scsi drivers/scsi/a100u2w.c
--- kj/drivers/scsi/a100u2w.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/a100u2w.c	2005-03-05 16:13:22.000000000 +0100
@@ -1052,7 +1052,7 @@ static int __devinit inia100_probe_one(s
 
 	if (pci_enable_device(pdev))
 		goto out;
-	if (pci_set_dma_mask(pdev, 0xffffffffULL)) {
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING "Unable to set 32bit DMA "
 				    "on inia100 adapter, ignoring.\n");
 		goto out_disable_device;
diff -puN drivers/scsi/aacraid/aachba.c~dma_mask-drivers_scsi drivers/scsi/aacraid/aachba.c
--- kj/drivers/scsi/aacraid/aachba.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/aacraid/aachba.c	2005-03-05 16:13:22.000000000 +0100
@@ -687,12 +687,12 @@ int aac_get_adapter_info(struct aac_dev*
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
--- kj/drivers/scsi/aacraid/linit.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/aacraid/linit.c	2005-03-05 16:13:22.000000000 +0100
@@ -545,8 +545,8 @@ static int __devinit aac_probe_one(struc
 	if (pci_enable_device(pdev))
 		goto out;
 
-	if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL) || 
-			pci_set_consistent_dma_mask(pdev, 0xFFFFFFFFULL))
+	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) || 
+			pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK))
 		goto out;
 	/*
 	 * If the quirk31 bit is set, the adapter needs adapter
@@ -589,7 +589,7 @@ static int __devinit aac_probe_one(struc
 	 * address space.
 	 */
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
-		if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK))
 			goto out_free_fibs;
 
 	aac_get_adapter_info(aac);
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~dma_mask-drivers_scsi drivers/scsi/aic7xxx/aic79xx_osm.c
--- kj/drivers/scsi/aic7xxx/aic79xx_osm.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-03-05 16:13:22.000000000 +0100
@@ -1706,7 +1706,7 @@ ahd_dmamem_alloc(struct ahd_softc *ahd, 
 	 * our dma mask when doing allocations.
 	 */
 	if (ahd->dev_softc != NULL)
-		if (pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(ahd->dev_softc, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
 			kfree(map);
 			return (ENODEV);
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~dma_mask-drivers_scsi drivers/scsi/aic7xxx/aic7xxx_osm.c
--- kj/drivers/scsi/aic7xxx/aic7xxx_osm.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-03-05 16:13:22.000000000 +0100
@@ -1361,7 +1361,7 @@ ahc_dmamem_alloc(struct ahc_softc *ahc, 
 	 * our dma mask when doing allocations.
 	 */
 	if (ahc->dev_softc != NULL)
-		if (pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(ahc->dev_softc, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
 			kfree(map);
 			return (ENODEV);
diff -puN drivers/scsi/atp870u.c~dma_mask-drivers_scsi drivers/scsi/atp870u.c
--- kj/drivers/scsi/atp870u.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/atp870u.c	2005-03-05 16:13:22.000000000 +0100
@@ -2287,7 +2287,7 @@ static int atp870u_probe(struct pci_dev 
 	if (pci_enable_device(dev))
 		return -EIO;
 
-	if (pci_set_dma_mask(dev, 0xFFFFFFFFUL)) {
+	if (pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
 		printk(KERN_ERR "atp870u: 32bit DMA mask required but not available.\n");
 		return -EIO;
 	}
diff -puN drivers/scsi/dpt_i2o.c~dma_mask-drivers_scsi drivers/scsi/dpt_i2o.c
--- kj/drivers/scsi/dpt_i2o.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/dpt_i2o.c	2005-03-05 16:13:22.000000000 +0100
@@ -881,8 +881,8 @@ static int adpt_install_hba(struct scsi_
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
--- kj/drivers/scsi/eata.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/eata.c	2005-03-05 16:13:22.000000000 +0100
@@ -1430,7 +1430,7 @@ static int port_detect(unsigned long por
 
 	if (ha->pdev) {
 		pci_set_master(ha->pdev);
-		if (pci_set_dma_mask(ha->pdev, 0xffffffff))
+		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK))
 			printk("%s: warning, pci_set_dma_mask failed.\n",
 			       ha->board_name);
 	}
diff -puN drivers/scsi/gdth.c~dma_mask-drivers_scsi drivers/scsi/gdth.c
--- kj/drivers/scsi/gdth.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/gdth.c	2005-03-05 16:13:22.000000000 +0100
@@ -4529,15 +4529,15 @@ int __init gdth_detect(Scsi_Host_Templat
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
--- kj/drivers/scsi/initio.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/initio.c	2005-03-05 16:13:22.000000000 +0100
@@ -2793,7 +2793,7 @@ static int tul_NewReturnNumberOfAdapters
 			if (((dRegValue & 0xFF00) >> 8) == 0xFF)
 				dRegValue = 0;
 			wBIOS = (wBIOS << 8) + ((UWORD) ((dRegValue & 0xFF00) >> 8));
-			if (pci_set_dma_mask(pDev, 0xffffffff)) {
+			if (pci_set_dma_mask(pDev, DMA_32BIT_MASK)) {
 				printk(KERN_WARNING 
 				       "i91u: Could not set 32 bit DMA mask\n");
 				continue;
diff -puN drivers/scsi/ips.c~dma_mask-drivers_scsi drivers/scsi/ips.c
--- kj/drivers/scsi/ips.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/ips.c	2005-03-05 16:13:22.000000000 +0100
@@ -7290,10 +7290,10 @@ ips_init_phase1(struct pci_dev *pci_dev,
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
--- kj/drivers/scsi/megaraid.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/megaraid.c	2005-03-05 16:13:22.000000000 +0100
@@ -2060,7 +2060,7 @@ make_local_pdev(adapter_t *adapter, stru
 
 	memcpy(*pdev, adapter->dev, sizeof(struct pci_dev));
 
-	if( pci_set_dma_mask(*pdev, 0xffffffff) != 0 ) {
+	if( pci_set_dma_mask(*pdev, DMA_32BIT_MASK) != 0 ) {
 		kfree(*pdev);
 		return -1;
 	}
@@ -4854,10 +4854,10 @@ megaraid_probe_one(struct pci_dev *pdev,
 
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
--- kj/drivers/scsi/megaraid/megaraid_mbox.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/megaraid/megaraid_mbox.c	2005-03-05 16:13:22.000000000 +0100
@@ -619,7 +619,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 
 	// Setup the default DMA mask. This would be changed later on
 	// depending on hardware capabilities
-	if (pci_set_dma_mask(adapter->pdev, 0xFFFFFFFF) != 0) {
+	if (pci_set_dma_mask(adapter->pdev, DMA_32BIT_MASK) != 0) {
 
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: pci_set_dma_mask failed:%d\n", __LINE__));
@@ -1031,7 +1031,7 @@ megaraid_init_mbox(adapter_t *adapter)
 
 	// Set the DMA mask to 64-bit. All supported controllers as capable of
 	// DMA in this range
-	if (pci_set_dma_mask(adapter->pdev, 0xFFFFFFFFFFFFFFFFULL) != 0) {
+	if (pci_set_dma_mask(adapter->pdev, DMA_64BIT_MASK) != 0) {
 
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: could not set DMA mask for 64-bit.\n"));
diff -puN drivers/scsi/nsp32.c~dma_mask-drivers_scsi drivers/scsi/nsp32.c
--- kj/drivers/scsi/nsp32.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/nsp32.c	2005-03-05 16:13:22.000000000 +0100
@@ -2779,7 +2779,7 @@ static int nsp32_detect(Scsi_Host_Templa
 	/*
 	 * setup DMA 
 	 */
-	if (pci_set_dma_mask(PCIDEV, 0xffffffffUL) != 0) {
+	if (pci_set_dma_mask(PCIDEV, DMA_32BIT_MASK) != 0) {
 		nsp32_msg (KERN_ERR, "failed to set PCI DMA mask");
 		goto scsi_unregister;
 	}
diff -puN drivers/scsi/qla1280.c~dma_mask-drivers_scsi drivers/scsi/qla1280.c
--- kj/drivers/scsi/qla1280.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/qla1280.c	2005-03-05 16:13:22.000000000 +0100
@@ -4741,7 +4741,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 
 #ifdef QLA_64BIT_PTR
 	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
-		if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
+		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       " suitable DMA mask - aboring\n", ha->host_no);
 			error = -ENODEV;
@@ -4751,7 +4751,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
 			ha->host_no);
 #else
-	if (pci_set_dma_mask(ha->pdev, 0xffffffff)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING "scsi(%li): Unable to set a "
 		       " suitable DMA mask - aboring\n", ha->host_no);
 		error = -ENODEV;
diff -puN drivers/scsi/qlogicfc.c~dma_mask-drivers_scsi drivers/scsi/qlogicfc.c
--- kj/drivers/scsi/qlogicfc.c~dma_mask-drivers_scsi	2005-03-05 16:13:22.000000000 +0100
+++ kj-domen/drivers/scsi/qlogicfc.c	2005-03-05 16:13:22.000000000 +0100
@@ -719,8 +719,8 @@ int isp2x00_detect(Scsi_Host_Template * 
 				continue;
 
 			/* Try to configure DMA attributes. */
-			if (pci_set_dma_mask(pdev, 0xffffffffffffffffULL) &&
-			    pci_set_dma_mask(pdev, 0xffffffffULL))
+			if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) &&
+			    pci_set_dma_mask(pdev, DMA_32BIT_MASK))
 					continue;
 
 		        host = scsi_register(tmpt, sizeof(struct isp2x00_hostdata));
_
