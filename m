From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH] scsi: ufs: export the helper functions for vender probe/remove
Date: Mon, 09 Sep 2013 20:51:49 +0900
Message-ID: <000b01cead52$f7dea450$e79becf0$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56197 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3IILvv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 07:51:51 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU00ENYWXZD0M0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 09 Sep 2013 20:51:50 +0900 (KST)
In-reply-to: 
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Santosh Y' <santoshsy@gmail.com>, 'Vinayak Holikatti' <vinholikatti@gmail.com>, "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>

This change provides the common routines for driver's probe/remove.
Especially host driver including specific operations can invoke the
initial routine at the own probing phase and pass its operations to
ufshcd's common part.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c |   49 +++++++++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd-pltfrm.h |   19 ++++++++++++++
 2 files changed, 55 insertions(+), 13 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.h

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 9c94052..4900597 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -38,6 +38,7 @@
 #include <linux/of.h>
 
 #include "ufshcd.h"
+#include "ufshcd-pltfrm.h"
 
 static const struct of_device_id ufs_of_match[];
 static struct ufs_hba_variant_ops *get_variant_ops(struct device *dev)
@@ -137,12 +138,13 @@ static int ufshcd_pltfrm_runtime_idle(struct device *dev)
 #endif /* CONFIG_PM_RUNTIME */
 
 /**
- * ufshcd_pltfrm_probe - probe routine of the driver
+ * ufshcd_pltfrm_init - common routine for the driver's initialization
  * @pdev: pointer to Platform device handle
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int ufshcd_pltfrm_probe(struct platform_device *pdev)
+int ufshcd_pltfrm_init(struct platform_device *pdev,
+		       const struct ufs_hba_variant_ops *vops)
 {
 	struct ufs_hba *hba;
 	void __iomem *mmio_base;
@@ -166,14 +168,13 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 
 	err = ufshcd_alloc_host(dev, &hba);
 	if (err) {
-		dev_err(&pdev->dev, "Allocation failed\n");
+		dev_err(dev, "Allocation failed\n");
 		goto out;
 	}
 
-	hba->vops = get_variant_ops(&pdev->dev);
-
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
+	hba->vops = vops;
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
@@ -186,24 +187,46 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 	return 0;
 
 out_disable_rpm:
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
 
 /**
- * ufshcd_pltfrm_remove - remove platform driver routine
+ * ufshcd_pltfrm_exit - common routine for the driver's exit
  * @pdev: pointer to platform device handle
- *
- * Returns 0 on success, non-zero value on failure
  */
-static int ufshcd_pltfrm_remove(struct platform_device *pdev)
+void ufshcd_pltfrm_exit(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
+}
+EXPORT_SYMBOL_GPL(ufshcd_pltfrm_exit);
+
+/**
+ * ufshcd_pltfrm_probe - probe the platform driver
+ * @pdev: pointer to Platform device handle
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_pltfrm_probe(struct platform_device *pdev)
+{
+	return ufshcd_pltfrm_init(pdev, get_variant_ops(&pdev->dev));
+}
+
+/**
+ * ufshcd_pltfrm_remove - remove the platform driver
+ * @pdev: pointer to platform device handle
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_pltfrm_remove(struct platform_device *pdev)
+{
+	ufshcd_pltfrm_exit(pdev);
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.h b/drivers/scsi/ufs/ufshcd-pltfrm.h
new file mode 100644
index 0000000..6adab05
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.h
@@ -0,0 +1,19 @@
+/*
+ * Universal Flash Storage Host controller Platform bus based glue driver
+ *
+ * Copyright (C) 2013, Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * at your option) any later version.
+ */
+
+#ifndef _UFSHCD_PLTFRM_H_
+#define _UFSHCD_PLTFRM_H_
+
+extern int ufshcd_pltfrm_init(struct platform_device *pdev,
+			      const struct ufs_hba_variant_ops *vops);
+extern void ufshcd_pltfrm_exit(struct platform_device *pdev);
+
+#endif /* _UFSHCD_PLTFRM_H_ */
-- 
1.7.0.4


