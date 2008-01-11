From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 1/3]: IO resource allocation using pci_request_selected_regions API
Date: Fri, 11 Jan 2008 14:33:30 +0530
Message-ID: <20080111090330.GA4161@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55840 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbYAKJHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 04:07:15 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m0B94Vul007750
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jan 2008 01:04:31 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

This patch modifies the IO resource allocation behavior of FUSION driver. 
By using the pci_select_bars and pci_request_selected_regions API
The IORESOURCE_IO will be requested only when the driver needs the IO resource.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 52fb216..9476ad2 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1470,9 +1470,6 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (mpt_debug_level)
 		printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
 
-	if (pci_enable_device(pdev))
-		return r;
-
 	ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
@@ -1482,6 +1479,20 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->id = mpt_ids++;
 	sprintf(ioc->name, "ioc%d", ioc->id);
 
+	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	if (pci_enable_device_bars(pdev, ioc->bars)) {
+		kfree(ioc);
+		printk(MYIOC_s_ERR_FMT "pci_enable_device_bars() with MEM "
+		    "failed\n",ioc->name);
+ 		return r;
+	}
+	if (pci_request_selected_regions(pdev, ioc->bars, "mpt")) {
+		kfree(ioc);
+		printk(MYIOC_s_ERR_FMT "pci_request_selected_regions() with "
+		    "MEM failed\n",ioc->name);
+		return r;
+	}
+
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": mpt_adapter_install\n", ioc->name));
 
 	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
@@ -1791,6 +1802,7 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
 	pci_disable_device(pdev);
+	pci_release_selected_regions(pdev, ioc->bars);
 	pci_set_power_state(pdev, device_state);
 
 	return 0;
@@ -1807,7 +1819,6 @@ mpt_resume(struct pci_dev *pdev)
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	u32 device_state = pdev->current_state;
 	int recovery_state;
-	int err;
 
 	printk(MYIOC_s_INFO_FMT
 	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
@@ -1815,9 +1826,15 @@ mpt_resume(struct pci_dev *pdev)
 
 	pci_set_power_state(pdev, 0);
 	pci_restore_state(pdev);
-	err = pci_enable_device(pdev);
-	if (err)
-		return err;
+	if (ioc->facts.Flags & MPI_IOCFACTS_FLAGS_FW_DOWNLOAD_BOOT)
+	    ioc->bars = pci_select_bars(ioc->pcidev, IORESOURCE_MEM |
+	    IORESOURCE_IO);
+	else
+		ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	if (pci_enable_device_bars(pdev, ioc->bars))
+		return 0;
+	if (pci_request_selected_regions(pdev, ioc->bars, "mpt"))
+		return 0;
 
 	/* enable interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
@@ -1878,6 +1895,7 @@ mpt_signal_reset(u8 index, MPT_ADAPTER *ioc, int reset_phase)
  *		-2 if READY but IOCFacts Failed
  *		-3 if READY but PrimeIOCFifos Failed
  *		-4 if READY but IOCInit Failed
+ *		-5 if failed to enable_device_bars and/or request_selected_regions
  */
 static int
 mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
@@ -1976,6 +1994,18 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 		}
 	}
 
+	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP) &&
+	    (ioc->facts.Flags & MPI_IOCFACTS_FLAGS_FW_DOWNLOAD_BOOT)) {
+		pci_release_selected_regions(ioc->pcidev, ioc->bars);
+		ioc->bars = pci_select_bars(ioc->pcidev, IORESOURCE_MEM |
+		    IORESOURCE_IO);
+		if (pci_enable_device_bars(ioc->pcidev, ioc->bars))
+			return -5;
+		if (pci_request_selected_regions(ioc->pcidev, ioc->bars,
+			"mpt"))
+			return -5;
+	}
+
 	/*
 	 * Device is reset now. It must have de-asserted the interrupt line
 	 * (if it was asserted) and it should be safe to register for the
@@ -2385,6 +2415,9 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 		ioc->memmap = NULL;
 	}
 
+	pci_disable_device(ioc->pcidev);
+	pci_release_selected_regions(ioc->pcidev, ioc->bars);
+
 #if defined(CONFIG_MTRR) && 0
 	if (ioc->mtrr_reg > 0) {
 		mtrr_del(ioc->mtrr_reg, 0, 0);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index d7682e0..4031c15 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -629,6 +629,7 @@ typedef struct _MPT_ADAPTER
 	dma_addr_t		HostPageBuffer_dma;
 	int			 mtrr_reg;
 	struct pci_dev		*pcidev;	/* struct pci_dev pointer */
+	int			bars;	/* bitmask of BAR's that must be configured */
 	u8			__iomem *memmap;	/* mmap address */
 	struct Scsi_Host	*sh;		/* Scsi Host pointer */
 	SpiCfgData		spi_data;	/* Scsi config. data */
 
