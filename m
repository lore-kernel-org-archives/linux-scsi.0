From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 4/9] scsi: ufs: Add runtime PM support for UFS host controller driver
Date: Sun, 28 Jul 2013 22:40:32 +0530
Message-ID: <1375031437-10206-5-git-send-email-santoshsy@gmail.com>
References: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64171 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3G1RMO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jul 2013 13:12:14 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb10so4510113pad.37
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jul 2013 10:12:14 -0700 (PDT)
In-Reply-To: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Santosh Y <santoshsy@gmail.com>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

Add runtime PM helpers to suspend/resume UFS controller at runtime.
Enable runtime PM by default for pci and platform drivers as the
initialized hardware can suspend if it is not used after bootup.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 48be39a..57ea9dd 100644
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
@@ -71,8 +72,45 @@ static int ufshcd_pci_resume(struct pci_dev *pdev)
 
 	return -ENOSYS;
 }
+#else
+#define ufshcd_pci_suspend	NULL
+#define ufshcd_pci_resume	NULL
 #endif /* CONFIG_PM */
 
+#ifdef CONFIG_PM_RUNTIME
+static int ufshcd_pci_runtime_suspend(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_suspend(hba);
+}
+static int ufshcd_pci_runtime_resume(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_resume(hba);
+}
+static int ufshcd_pci_runtime_idle(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
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
@@ -91,6 +129,9 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 {
 	struct ufs_hba *hba = pci_get_drvdata(pdev);
 
+	pm_runtime_forbid(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
+
 	disable_irq(pdev->irq);
 	ufshcd_remove(hba);
 	pci_release_regions(pdev);
@@ -168,6 +209,8 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	pci_set_drvdata(pdev, hba);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
 
 	return 0;
 
@@ -182,6 +225,14 @@ out_error:
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
@@ -195,10 +246,9 @@ static struct pci_driver ufshcd_pci_driver = {
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
index c42db40..cc957fc 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -34,6 +34,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 
 #include "ufshcd.h"
 
@@ -87,6 +88,40 @@ static int ufshcd_pltfrm_resume(struct device *dev)
 #define ufshcd_pltfrm_resume	NULL
 #endif
 
+#ifdef CONFIG_PM_RUNTIME
+static int ufshcd_pltfrm_runtime_suspend(struct device *dev)
+{
+	struct ufs_hba *hba =  dev_get_drvdata(dev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_suspend(hba);
+}
+static int ufshcd_pltfrm_runtime_resume(struct device *dev)
+{
+	struct ufs_hba *hba =  dev_get_drvdata(dev);
+
+	if (!hba)
+		return 0;
+
+	return ufshcd_runtime_resume(hba);
+}
+static int ufshcd_pltfrm_runtime_idle(struct device *dev)
+{
+	struct ufs_hba *hba =  dev_get_drvdata(dev);
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
@@ -122,14 +157,20 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	err = ufshcd_init(dev, &hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Intialization failed\n");
-		goto out;
+		goto out_disable_rpm;
 	}
 
 	platform_set_drvdata(pdev, hba);
 
+out_disable_rpm:
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 out:
 	return err;
 }
@@ -144,6 +185,8 @@ static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
+	pm_runtime_get_sync(&(pdev)->dev);
+
 	disable_irq(hba->irq);
 	ufshcd_remove(hba);
 	return 0;
@@ -157,6 +200,9 @@ static const struct of_device_id ufs_of_match[] = {
 static const struct dev_pm_ops ufshcd_dev_pm_ops = {
 	.suspend	= ufshcd_pltfrm_suspend,
 	.resume		= ufshcd_pltfrm_resume,
+	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
+	.runtime_resume  = ufshcd_pltfrm_runtime_resume,
+	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
 };
 
 static struct platform_driver ufshcd_pltfrm_driver = {
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4267246..1f2caa0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2169,6 +2169,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	u32 status = 0;
 	hba = container_of(work, struct ufs_hba, eeh_work);
 
+	pm_runtime_get_sync(hba->dev);
 	err = ufshcd_get_ee_status(hba, &status);
 	if (err) {
 		dev_err(hba->dev, "%s: failed to get exception status %d\n",
@@ -2184,6 +2185,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 					__func__, err);
 	}
 out:
+	pm_runtime_put_sync(hba->dev);
 	return;
 }
 
@@ -2196,9 +2198,11 @@ static void ufshcd_fatal_err_handler(struct work_struct *work)
 	struct ufs_hba *hba;
 	hba = container_of(work, struct ufs_hba, feh_workq);
 
+	pm_runtime_get_sync(hba->dev);
 	/* check if reset is already in progress */
 	if (hba->ufshcd_state != UFSHCD_STATE_RESET)
 		ufshcd_do_reset(hba);
+	pm_runtime_put_sync(hba->dev);
 }
 
 /**
@@ -2500,6 +2504,7 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
 	ufshcd_force_reset_auto_bkops(hba);
 	scsi_scan_host(hba->host);
+	pm_runtime_put_sync(hba->dev);
 out:
 	return;
 }
@@ -2721,6 +2726,9 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 
 	*hba_handle = hba;
 
+	/* Hold auto suspend until async scan completes */
+	pm_runtime_get_sync(dev);
+
 	async_schedule(ufshcd_async_scan, hba);
 
 	return 0;
-- 
1.8.3.1

