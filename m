From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V2 2/2] scsi: ufs: Add runtime PM helpers for UFS host driver
Date: Fri, 28 Jun 2013 23:46:43 +0530
Message-ID: <1372443403-21830-3-git-send-email-sthumma@codeaurora.org>
References: <1372443403-21830-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1372443403-21830-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add runtime PM helpers to suspend/resume the UFS controller
device at runtime.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd-pci.c    |   60 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd-pltfrm.c |   41 ++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 64d36eb..f669e9a2 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -35,6 +35,7 @@
 
 #include "ufshcd.h"
 #include <linux/pci.h>
+#include <linux/pm_runtime.h>
 
 #ifdef CONFIG_PM
 /**
@@ -44,7 +45,7 @@
  *
  * Returns -ENOSYS
  */
-static int ufshcd_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int ufshcd_pci_suspend(struct device *dev)
 {
 	/*
 	 * TODO:
@@ -61,7 +62,7 @@ static int ufshcd_pci_suspend(struct pci_dev *pdev, pm_message_t state)
  *
  * Returns -ENOSYS
  */
-static int ufshcd_pci_resume(struct pci_dev *pdev)
+static int ufshcd_pci_resume(struct device *dev)
 {
 	/*
 	 * TODO:
@@ -71,8 +72,48 @@ static int ufshcd_pci_resume(struct pci_dev *pdev)
 
 	return -ENOSYS;
 }
+#else
+#define ufshcd_pci_suspend	NULL
+#define ufshcd_pci_resume	NULL
 #endif /* CONFIG_PM */
 
+#ifdef CONFIG_PM_RUNTIME
+static int ufshcd_pci_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_suspend(hba);
+}
+static int ufshcd_pci_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_resume(hba);
+}
+static int ufshcd_pci_runtime_idle(struct device *dev)
+{
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct ufs_hba *hba = pci_get_drvdata(pdev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_idle(hba);
+}
+#else /* !CONFIG_PM_RUNTIME */
+#define ufshcd_pci_runtime_suspend	NULL
+#define ufshcd_pci_runtime_resume	NULL
+#define ufshcd_pci_runtime_idle	NULL
+#endif /* CONFIG_PM_RUNTIME */
+
 /**
  * ufshcd_pci_shutdown - main function to put the controller in reset state
  * @pdev: pointer to PCI device handle
@@ -156,6 +197,14 @@ out_error:
 	return err;
 }
 
+static const struct dev_pm_ops ufshcd_pci_pm_ops = {
+	.suspend	= ufshcd_pci_suspend,
+	.resume		= ufshcd_pci_resume,
+	.runtime_suspend = ufshcd_pci_runtime_suspend,
+	.runtime_resume  = ufshcd_pci_runtime_resume,
+	.runtime_idle    = ufshcd_pci_runtime_idle,
+};
+
 static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_tbl) = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ }	/* terminate list */
@@ -169,10 +218,9 @@ static struct pci_driver ufshcd_pci_driver = {
 	.probe = ufshcd_pci_probe,
 	.remove = ufshcd_pci_remove,
 	.shutdown = ufshcd_pci_shutdown,
-#ifdef CONFIG_PM
-	.suspend = ufshcd_pci_suspend,
-	.resume = ufshcd_pci_resume,
-#endif
+	.driver = {
+		.pm = &ufshcd_pci_pm_ops
+	},
 };
 
 module_pci_driver(ufshcd_pci_driver);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index c42db40..7541054 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -34,6 +34,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 
 #include "ufshcd.h"
 
@@ -87,6 +88,43 @@ static int ufshcd_pltfrm_resume(struct device *dev)
 #define ufshcd_pltfrm_resume	NULL
 #endif
 
+#ifdef CONFIG_PM_RUNTIME
+static int ufshcd_pltfrm_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_suspend(hba);
+}
+static int ufshcd_pltfrm_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_resume(hba);
+}
+static int ufshcd_pltfrm_runtime_idle(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_idle(hba);
+}
+#else /* !CONFIG_PM_RUNTIME */
+#define ufshcd_pltfrm_runtime_suspend	NULL
+#define ufshcd_pltfrm_runtime_resume	NULL
+#define ufshcd_pltfrm_runtime_idle	NULL
+#endif /* CONFIG_PM_RUNTIME */
+
 /**
  * ufshcd_pltfrm_probe - probe routine of the driver
  * @pdev: pointer to Platform device handle
@@ -157,6 +195,9 @@ static const struct of_device_id ufs_of_match[] = {
 static const struct dev_pm_ops ufshcd_dev_pm_ops = {
 	.suspend	= ufshcd_pltfrm_suspend,
 	.resume		= ufshcd_pltfrm_resume,
+	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
+	.runtime_resume  = ufshcd_pltfrm_runtime_resume,
+	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
 };
 
 static struct platform_driver ufshcd_pltfrm_driver = {
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
