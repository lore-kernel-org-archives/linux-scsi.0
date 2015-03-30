From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 04/20] [SCSI] mpt3sas: Remove redundancy code while freeing the controller resources.
Date: Mon, 30 Mar 2015 19:25:07 +0530
Message-ID: <1427723723-12676-5-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Removed the redundancy code while freeing the controller resources.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 57 +++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ce57320..32b86bf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1798,6 +1798,36 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
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
@@ -1925,14 +1955,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
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
 
@@ -4667,8 +4690,6 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 void
 mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct pci_dev *pdev = ioc->pdev;
-
 	dexitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
 
@@ -4679,21 +4700,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
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
