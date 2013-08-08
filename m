From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v3 1/2] mpt2sas: fix cleanup on controller resource mapping failure
Date: Thu,  8 Aug 2013 16:45:38 -0400
Message-ID: <1375994739-11146-2-git-send-email-joe.lawrence@stratus.com>
References: <1375994739-11146-1-git-send-email-joe.lawrence@stratus.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.17]:52419 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966459Ab3HHUpu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 16:45:50 -0400
In-Reply-To: <1375994739-11146-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sreekanth.Reddy@lsi.com, Joe Lawrence <joe.lawrence@stratus.com>

If mpt2sas_base_map_resources takes an early error path then its
counterpart, mpt2sas_base_free_resources needs to be careful about
cleaning up:

  1 - _base_mask_interrupts and _base_make_ioc_ready require memory
      mapped I/O registers, make sure that this is true.

  2 - _base_free_irq iterates over the adapter's reply_queue_list, so
      move this list head initialization out of _base_enable_msix to
      _scsih_probe so this will always be safe.

  3 - check that the controller PCI device and its BARs have been
      enabled before disabling them.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  | 27 +++++++++++++++++----------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  1 +
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 3ca757d..27ff0f63 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1409,8 +1409,6 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	int i;
 	u8 try_msix = 0;
 
-	INIT_LIST_HEAD(&ioc->reply_queue_list);
-
 	if (msix_disable == -1 || msix_disable == 0)
 		try_msix = 1;
 
@@ -1489,6 +1487,7 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 	if (pci_enable_device_mem(pdev)) {
 		printk(MPT2SAS_WARN_FMT "pci_enable_device_mem: "
 		    "failed\n", ioc->name);
+		ioc->bars = 0;
 		return -ENODEV;
 	}
 
@@ -1497,6 +1496,7 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 	    MPT2SAS_DRIVER_NAME)) {
 		printk(MPT2SAS_WARN_FMT "pci_request_selected_regions: "
 		    "failed\n", ioc->name);
+		ioc->bars = 0;
 		r = -ENODEV;
 		goto out_fail;
 	}
@@ -4229,18 +4229,25 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 	dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
-	_base_mask_interrupts(ioc);
-	ioc->shost_recovery = 1;
-	_base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
-	ioc->shost_recovery = 0;
+	if (ioc->chip_phys && ioc->chip) {
+		_base_mask_interrupts(ioc);
+		ioc->shost_recovery = 1;
+		_base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
+		ioc->shost_recovery = 0;
+	}
+
 	_base_free_irq(ioc);
 	_base_disable_msix(ioc);
-	if (ioc->chip_phys)
+
+	if (ioc->chip_phys && ioc->chip)
 		iounmap(ioc->chip);
 	ioc->chip_phys = 0;
-	pci_release_selected_regions(ioc->pdev, ioc->bars);
-	pci_disable_pcie_error_reporting(pdev);
-	pci_disable_device(pdev);
+
+	if (pci_is_enabled(pdev)) {
+		pci_release_selected_regions(ioc->pdev, ioc->bars);
+		pci_disable_pcie_error_reporting(pdev);
+		pci_disable_device(pdev);
+	}
 	return;
 }
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5100476..389d792 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8175,6 +8175,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->sas_hba.sas_port_list);
 	INIT_LIST_HEAD(&ioc->delayed_tr_list);
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
+	INIT_LIST_HEAD(&ioc->reply_queue_list);
 
 	/* init shost parameters */
 	shost->max_cmd_len = 32;
-- 
1.8.3.1

