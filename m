From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 04/20] [SCSI] mpt3sas: Remove redundancy code  while freeing the controller resources.
Date: Tue, 30 Jun 2015 12:24:50 +0530
Message-ID: <1435647306-36956-5-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33361 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbbF3Gzm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 02:55:42 -0400
Received: by pacws9 with SMTP id ws9so714378pac.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 23:55:41 -0700 (PDT)
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Removed the redundancy code while freeing the controller resources.

Changes in v2:
	Patch version change only.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 57 +++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0410cc5..bf2d7dc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1813,6 +1813,36 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
+ * mpt3sas_base_unmap_resources - free controller resources
+ * @ioc: per adapter object
+ */
+void
+mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct pci_dev *pdev = ioc->pdev;
+
+	dexitprintk(ioc, printk(MPT3SAS_FMT "%s\n",
+		ioc->name, __func__));
+
+	_base_free_irq(ioc);
+	_base_disable_msix(ioc);
+
+	if (ioc->msix96_vector)
+		kfree(ioc->replyPostRegisterIndex);
+
+	if (ioc->chip_phys) {
+		iounmap(ioc->chip);
+		ioc->chip_phys = 0;
+	}
+
+	if (pci_is_enabled(pdev)) {
+		pci_release_selected_regions(ioc->pdev, ioc->bars);
+		pci_disable_pcie_error_reporting(pdev);
+		pci_disable_device(pdev);
+	}
+}
+
+/**
  * mpt3sas_base_map_resources - map in controller resources (io/irq/memap)
  * @ioc: per adapter object
  *
@@ -1945,14 +1975,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	return 0;
 
  out_fail:
-	if (ioc->chip_phys)
-		iounmap(ioc->chip);
-	ioc->chip_phys = 0;
-	pci_release_selected_regions(ioc->pdev, ioc->bars);
-	pci_disable_pcie_error_reporting(pdev);
-	pci_disable_device(pdev);
-	if (ioc->msix96_vector)
-		kfree(ioc->replyPostRegisterIndex);
+	mpt3sas_base_unmap_resources(ioc);
 	return r;
 }
 
@@ -4689,8 +4712,6 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 void
 mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct pci_dev *pdev = ioc->pdev;
-
 	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
 
@@ -4701,21 +4722,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 		ioc->shost_recovery = 0;
 	}
 
-	_base_free_irq(ioc);
-	_base_disable_msix(ioc);
-
-	if (ioc->msix96_vector)
-		kfree(ioc->replyPostRegisterIndex);
-
-	if (ioc->chip_phys && ioc->chip)
-		iounmap(ioc->chip);
-	ioc->chip_phys = 0;
-
-	if (pci_is_enabled(pdev)) {
-		pci_release_selected_regions(ioc->pdev, ioc->bars);
-		pci_disable_pcie_error_reporting(pdev);
-		pci_disable_device(pdev);
-	}
+	mpt3sas_base_unmap_resources(ioc);
 	return;
 }
 
-- 
2.0.2

