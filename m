From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH] mpt fusion: Enable MSI by default for SAS controllers
Date: Fri, 7 Mar 2008 15:53:21 +0530
Message-ID: <20080307102320.GA20428@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52615 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYCGKb5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Mar 2008 05:31:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com, djwong@us.ibm.com

This patch modifies the driver to enable MSI by default for all SAS chips.

Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 6b6df86..7587413 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -79,7 +79,7 @@ MODULE_VERSION(my_VERSION);
 /*
  *  cmd line parameters
  */
-static int mpt_msi_enable;
+static int mpt_msi_enable = -1;
 module_param(mpt_msi_enable, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable, " MSI Support Enable (default=0)");
 
@@ -1660,6 +1660,11 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->bus_type = SAS;
 	}
 
+	if (ioc->bus_type == SAS && mpt_msi_enable == -1)
+		ioc->msi_enable = 1;
+	else
+		ioc->msi_enable = mpt_msi_enable;
+
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(pdev);
 
@@ -2021,15 +2026,17 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
 		ioc->pci_irq = -1;
 		if (ioc->pcidev->irq) {
-			if (mpt_msi_enable && !pci_enable_msi(ioc->pcidev))
+			if (ioc->msi_enable && !pci_enable_msi(ioc->pcidev))
 				printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n",
 				    ioc->name);
+			else
+				ioc->msi_enable = 0;
 			rc = request_irq(ioc->pcidev->irq, mpt_interrupt,
 			    IRQF_SHARED, ioc->name, ioc);
 			if (rc < 0) {
 				printk(MYIOC_s_ERR_FMT "Unable to allocate "
 				    "interrupt %d!\n", ioc->name, ioc->pcidev->irq);
-				if (mpt_msi_enable)
+				if (ioc->msi_enable)
 					pci_disable_msi(ioc->pcidev);
 				return -EBUSY;
 			}
@@ -2225,7 +2232,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
  out:
 	if ((ret != 0) && irq_allocated) {
 		free_irq(ioc->pci_irq, ioc);
-		if (mpt_msi_enable)
+		if (ioc->msi_enable)
 			pci_disable_msi(ioc->pcidev);
 	}
 	return ret;
@@ -2407,7 +2414,7 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 
 	if (ioc->pci_irq != -1) {
 		free_irq(ioc->pci_irq, ioc);
-		if (mpt_msi_enable)
+		if (ioc->msi_enable)
 			pci_disable_msi(ioc->pcidev);
 		ioc->pci_irq = -1;
 	}
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index caadc68..50c0c17 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -630,6 +630,7 @@ typedef struct _MPT_ADAPTER
 	int			 mtrr_reg;
 	struct pci_dev		*pcidev;	/* struct pci_dev pointer */
 	int			bars;		/* bitmask of BAR's that must be configured */
+	int			msi_enable;
 	u8			__iomem *memmap;	/* mmap address */
 	struct Scsi_Host	*sh;		/* Scsi Host pointer */
 	SpiCfgData		spi_data;	/* Scsi config. data */
