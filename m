Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB1CC55191
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A1021473
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="O0mjTd1m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgDXLhi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:37:38 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:43942 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726865AbgDXLhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 07:37:24 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 80500C0273;
        Fri, 24 Apr 2020 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587728243; bh=uRk0X0rm7KgesI5uQb/AysnrnHYdIYjGBa5Zkq8LlyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=O0mjTd1mSs6M4l65IAYcbH+SNz+WoaPAgpAWfGZFrMBVWlbJRyBYfuFC41Zn7RqsY
         1lW5bCWFEbA8jX/4VyexkZ5W75SKEDvv0m6Hw13nUcnZPg/0HWVjFmXA2uAmKjv+8z
         ASj0Ro7qMVgPug/qEYJbKRXpTMBKZmmc/7TCIrhu3X7SAJl2z7w4mVFcA/G6x2yMTu
         eUP4FE29hegcrc1BDxpJRVzYF71A6/k4y0FQat7rD/rdcQn12rLz+e/2xxMHryxg6l
         jBSjVczTpoQ4OEYx9/i6Ef/Ra3yCS9R+AXiZTnjGlx+ZSNMTSi2WtpYW2Wy5ni6s0T
         OJPDqvKdptgtA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 3B884A0061;
        Fri, 24 Apr 2020 11:37:21 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-scsi@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] scsi: ufs: Rename tc-dwc-g210 -> tc-dwc
Date:   Fri, 24 Apr 2020 13:36:57 +0200
Message-Id: <cfe932136d676b89de1dd99bfa02bef688027203.1587727756.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1587727756.git.Jose.Abreu@synopsys.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1587727756.git.Jose.Abreu@synopsys.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for the addition of new Synopsys Test Chips versions we
remove all G210 mentions in files and Kconfig entries so that we can
re-use the same driver for different Test Chips.

As the PCI ID for these chips is different and as we will have different
DT bindings, there is no reason to add new drivers for them and we can
just re-use the existing ones.

No functional change.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Joao Lima <Joao.Lima@synopsys.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/ufs/Kconfig                           |  4 +-
 drivers/scsi/ufs/Makefile                          |  4 +-
 .../scsi/ufs/{tc-dwc-g210-pci.c => tc-dwc-pci.c}   | 70 +++++++++++-----------
 .../ufs/{tc-dwc-g210-pltfrm.c => tc-dwc-pltfrm.c}  | 37 ++++++------
 drivers/scsi/ufs/{tc-dwc-g210.c => tc-dwc.c}       |  6 +-
 drivers/scsi/ufs/{tc-dwc-g210.h => tc-dwc.h}       |  6 +-
 6 files changed, 64 insertions(+), 63 deletions(-)
 rename drivers/scsi/ufs/{tc-dwc-g210-pci.c => tc-dwc-pci.c} (60%)
 rename drivers/scsi/ufs/{tc-dwc-g210-pltfrm.c => tc-dwc-pltfrm.c} (70%)
 rename drivers/scsi/ufs/{tc-dwc-g210.c => tc-dwc.c} (98%)
 rename drivers/scsi/ufs/{tc-dwc-g210.h => tc-dwc.h} (78%)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e2005aeddc2d..d0b73b1dec18 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -62,7 +62,7 @@ config SCSI_UFSHCD_PCI
 	  If unsure, say N.
 
 config SCSI_UFS_DWC_TC_PCI
-	tristate "DesignWare pci support using a G210 Test Chip"
+	tristate "DesignWare PCI support using a Synopsys Test Chip"
 	depends on SCSI_UFSHCD_PCI
 	---help---
 	  Synopsys Test Chip is a PHY for prototyping purposes.
@@ -89,7 +89,7 @@ config SCSI_UFS_CDNS_PLATFORM
 	  If unsure, say N.
 
 config SCSI_UFS_DWC_TC_PLATFORM
-	tristate "DesignWare platform support using a G210 Test Chip"
+	tristate "DesignWare platform support using a Synopsys Test Chip"
 	depends on SCSI_UFSHCD_PLATFORM
 	---help---
 	  Synopsys Test Chip is a PHY for prototyping purposes.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 94c6c5d7334b..2005307b2934 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # UFSHCD makefile
-obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
-obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
+obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-pci.o ufshcd-dwc.o tc-dwc.o
+obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-pltfrm.o ufshcd-dwc.o tc-dwc.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-pci.c
similarity index 60%
rename from drivers/scsi/ufs/tc-dwc-g210-pci.c
rename to drivers/scsi/ufs/tc-dwc-pci.c
index 67a6a61154b7..aeb11f7f0c91 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-pci.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Synopsys G210 Test Chip driver
+ * Synopsys Test Chip driver
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
@@ -9,7 +9,7 @@
 
 #include "ufshcd.h"
 #include "ufshcd-dwc.h"
-#include "tc-dwc-g210.h"
+#include "tc-dwc.h"
 
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
@@ -23,27 +23,27 @@ static int tc_type = TC_G210_INV;
 module_param(tc_type, int, 0);
 MODULE_PARM_DESC(tc_type, "Test Chip Type (20 = 20-bit, 40 = 40-bit)");
 
-static int tc_dwc_g210_pci_suspend(struct device *dev)
+static int tc_dwc_pci_suspend(struct device *dev)
 {
 	return ufshcd_system_suspend(dev_get_drvdata(dev));
 }
 
-static int tc_dwc_g210_pci_resume(struct device *dev)
+static int tc_dwc_pci_resume(struct device *dev)
 {
 	return ufshcd_system_resume(dev_get_drvdata(dev));
 }
 
-static int tc_dwc_g210_pci_runtime_suspend(struct device *dev)
+static int tc_dwc_pci_runtime_suspend(struct device *dev)
 {
 	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
 }
 
-static int tc_dwc_g210_pci_runtime_resume(struct device *dev)
+static int tc_dwc_pci_runtime_resume(struct device *dev)
 {
 	return ufshcd_runtime_resume(dev_get_drvdata(dev));
 }
 
-static int tc_dwc_g210_pci_runtime_idle(struct device *dev)
+static int tc_dwc_pci_runtime_idle(struct device *dev)
 {
 	return ufshcd_runtime_idle(dev_get_drvdata(dev));
 }
@@ -51,26 +51,26 @@ static int tc_dwc_g210_pci_runtime_idle(struct device *dev)
 /*
  * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
  */
-static struct ufs_hba_variant_ops tc_dwc_g210_pci_hba_vops = {
-	.name                   = "tc-dwc-g210-pci",
+static struct ufs_hba_variant_ops tc_dwc_pci_hba_vops = {
+	.name                   = "tc-dwc-pci",
 	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
 };
 
 /**
- * tc_dwc_g210_pci_shutdown - main function to put the controller in reset state
+ * tc_dwc_pci_shutdown - main function to put the controller in reset state
  * @pdev: pointer to PCI device handle
  */
-static void tc_dwc_g210_pci_shutdown(struct pci_dev *pdev)
+static void tc_dwc_pci_shutdown(struct pci_dev *pdev)
 {
 	ufshcd_shutdown((struct ufs_hba *)pci_get_drvdata(pdev));
 }
 
 /**
- * tc_dwc_g210_pci_remove - de-allocate PCI/SCSI host and host memory space
+ * tc_dwc_pci_remove - de-allocate PCI/SCSI host and host memory space
  *		data structure memory
  * @pdev: pointer to PCI handle
  */
-static void tc_dwc_g210_pci_remove(struct pci_dev *pdev)
+static void tc_dwc_pci_remove(struct pci_dev *pdev)
 {
 	struct ufs_hba *hba = pci_get_drvdata(pdev);
 
@@ -80,14 +80,14 @@ static void tc_dwc_g210_pci_remove(struct pci_dev *pdev)
 }
 
 /**
- * tc_dwc_g210_pci_probe - probe routine of the driver
+ * tc_dwc_pci_probe - probe routine of the driver
  * @pdev: pointer to PCI device handle
  * @id: PCI device id
  *
  * Returns 0 on success, non-zero value on failure
  */
 static int
-tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+tc_dwc_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ufs_hba *hba;
 	void __iomem *mmio_base;
@@ -95,10 +95,10 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Check Test Chip type and set the specific setup routine */
 	if (tc_type == TC_G210_20BIT) {
-		tc_dwc_g210_pci_hba_vops.phy_initialization =
+		tc_dwc_pci_hba_vops.phy_initialization =
 						tc_dwc_g210_config_20_bit;
 	} else if (tc_type == TC_G210_40BIT) {
-		tc_dwc_g210_pci_hba_vops.phy_initialization =
+		tc_dwc_pci_hba_vops.phy_initialization =
 						tc_dwc_g210_config_40_bit;
 	} else {
 		dev_err(&pdev->dev, "test chip version not specified\n");
@@ -127,7 +127,7 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	hba->vops = &tc_dwc_g210_pci_hba_vops;
+	hba->vops = &tc_dwc_pci_hba_vops;
 
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
@@ -142,35 +142,35 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 }
 
-static const struct dev_pm_ops tc_dwc_g210_pci_pm_ops = {
-	.suspend	= tc_dwc_g210_pci_suspend,
-	.resume		= tc_dwc_g210_pci_resume,
-	.runtime_suspend = tc_dwc_g210_pci_runtime_suspend,
-	.runtime_resume  = tc_dwc_g210_pci_runtime_resume,
-	.runtime_idle    = tc_dwc_g210_pci_runtime_idle,
+static const struct dev_pm_ops tc_dwc_pci_pm_ops = {
+	.suspend	 = tc_dwc_pci_suspend,
+	.resume		 = tc_dwc_pci_resume,
+	.runtime_suspend = tc_dwc_pci_runtime_suspend,
+	.runtime_resume  = tc_dwc_pci_runtime_resume,
+	.runtime_idle    = tc_dwc_pci_runtime_idle,
 };
 
-static const struct pci_device_id tc_dwc_g210_pci_tbl[] = {
+static const struct pci_device_id tc_dwc_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ }	/* terminate list */
 };
 
-MODULE_DEVICE_TABLE(pci, tc_dwc_g210_pci_tbl);
+MODULE_DEVICE_TABLE(pci, tc_dwc_pci_tbl);
 
-static struct pci_driver tc_dwc_g210_pci_driver = {
-	.name = "tc-dwc-g210-pci",
-	.id_table = tc_dwc_g210_pci_tbl,
-	.probe = tc_dwc_g210_pci_probe,
-	.remove = tc_dwc_g210_pci_remove,
-	.shutdown = tc_dwc_g210_pci_shutdown,
+static struct pci_driver tc_dwc_pci_driver = {
+	.name = "tc-dwc-pci",
+	.id_table = tc_dwc_pci_tbl,
+	.probe = tc_dwc_pci_probe,
+	.remove = tc_dwc_pci_remove,
+	.shutdown = tc_dwc_pci_shutdown,
 	.driver = {
-		.pm = &tc_dwc_g210_pci_pm_ops
+		.pm = &tc_dwc_pci_pm_ops
 	},
 };
 
-module_pci_driver(tc_dwc_g210_pci_driver);
+module_pci_driver(tc_dwc_pci_driver);
 
 MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
-MODULE_DESCRIPTION("Synopsys Test Chip G210 PCI glue driver");
+MODULE_DESCRIPTION("Synopsys Test Chip PCI glue driver");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/scsi/ufs/tc-dwc-pltfrm.c
similarity index 70%
rename from drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
rename to drivers/scsi/ufs/tc-dwc-pltfrm.c
index a1268e4f44d6..7a561ee21586 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
+++ b/drivers/scsi/ufs/tc-dwc-pltfrm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Synopsys G210 Test Chip driver
+ * Synopsys Test Chip driver
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
@@ -15,7 +15,7 @@
 
 #include "ufshcd-pltfrm.h"
 #include "ufshcd-dwc.h"
-#include "tc-dwc-g210.h"
+#include "tc-dwc.h"
 
 /*
  * UFS DWC specific variant operations
@@ -32,7 +32,7 @@ static struct ufs_hba_variant_ops tc_dwc_g210_40bit_pltfm_hba_vops = {
 	.phy_initialization = tc_dwc_g210_config_40_bit,
 };
 
-static const struct of_device_id tc_dwc_g210_pltfm_match[] = {
+static const struct of_device_id tc_dwc_pltfm_match[] = {
 	{
 		.compatible = "snps,g210-tc-6.00-20bit",
 		.data = &tc_dwc_g210_20bit_pltfm_hba_vops,
@@ -43,21 +43,21 @@ static const struct of_device_id tc_dwc_g210_pltfm_match[] = {
 	},
 	{ },
 };
-MODULE_DEVICE_TABLE(of, tc_dwc_g210_pltfm_match);
+MODULE_DEVICE_TABLE(of, tc_dwc_pltfm_match);
 
 /**
- * tc_dwc_g210_pltfm_probe()
+ * tc_dwc_pltfm_probe()
  * @pdev: pointer to platform device structure
  *
  */
-static int tc_dwc_g210_pltfm_probe(struct platform_device *pdev)
+static int tc_dwc_pltfm_probe(struct platform_device *pdev)
 {
 	int err;
 	const struct of_device_id *of_id;
 	struct ufs_hba_variant_ops *vops;
 	struct device *dev = &pdev->dev;
 
-	of_id = of_match_node(tc_dwc_g210_pltfm_match, dev->of_node);
+	of_id = of_match_node(tc_dwc_pltfm_match, dev->of_node);
 	vops = (struct ufs_hba_variant_ops *)of_id->data;
 
 	/* Perform generic probe */
@@ -69,11 +69,11 @@ static int tc_dwc_g210_pltfm_probe(struct platform_device *pdev)
 }
 
 /**
- * tc_dwc_g210_pltfm_remove()
+ * tc_dwc_pltfm_remove()
  * @pdev: pointer to platform device structure
  *
  */
-static int tc_dwc_g210_pltfm_remove(struct platform_device *pdev)
+static int tc_dwc_pltfm_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
@@ -83,7 +83,7 @@ static int tc_dwc_g210_pltfm_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
+static const struct dev_pm_ops tc_dwc_pltfm_pm_ops = {
 	.suspend	= ufshcd_pltfrm_suspend,
 	.resume		= ufshcd_pltfrm_resume,
 	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
@@ -91,20 +91,21 @@ static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
 	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
 };
 
-static struct platform_driver tc_dwc_g210_pltfm_driver = {
-	.probe		= tc_dwc_g210_pltfm_probe,
-	.remove		= tc_dwc_g210_pltfm_remove,
+static struct platform_driver tc_dwc_pltfm_driver = {
+	.probe		= tc_dwc_pltfm_probe,
+	.remove		= tc_dwc_pltfm_remove,
 	.shutdown = ufshcd_pltfrm_shutdown,
 	.driver		= {
-		.name	= "tc-dwc-g210-pltfm",
-		.pm	= &tc_dwc_g210_pltfm_pm_ops,
-		.of_match_table	= of_match_ptr(tc_dwc_g210_pltfm_match),
+		.name	= "tc-dwc-pltfm",
+		.pm	= &tc_dwc_pltfm_pm_ops,
+		.of_match_table	= of_match_ptr(tc_dwc_pltfm_match),
 	},
 };
 
-module_platform_driver(tc_dwc_g210_pltfm_driver);
+module_platform_driver(tc_dwc_pltfm_driver);
 
 MODULE_ALIAS("platform:tc-dwc-g210-pltfm");
-MODULE_DESCRIPTION("Synopsys Test Chip G210 platform glue driver");
+MODULE_ALIAS("platform:tc-dwc-pltfm");
+MODULE_DESCRIPTION("Synopsys Test Chip platform glue driver");
 MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc.c
similarity index 98%
rename from drivers/scsi/ufs/tc-dwc-g210.c
rename to drivers/scsi/ufs/tc-dwc.c
index f954a68f6b4c..d67b5b4b4b17 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.c
+++ b/drivers/scsi/ufs/tc-dwc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Synopsys G210 Test Chip driver
+ * Synopsys Test Chip driver
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
@@ -12,7 +12,7 @@
 
 #include "ufshcd-dwc.h"
 #include "ufshci-dwc.h"
-#include "tc-dwc-g210.h"
+#include "tc-dwc.h"
 
 /**
  * tc_dwc_g210_setup_40bit_rmmi()
@@ -313,5 +313,5 @@ int tc_dwc_g210_config_20_bit(struct ufs_hba *hba)
 EXPORT_SYMBOL(tc_dwc_g210_config_20_bit);
 
 MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
-MODULE_DESCRIPTION("Synopsys G210 Test Chip driver");
+MODULE_DESCRIPTION("Synopsys Test Chip driver");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/tc-dwc-g210.h b/drivers/scsi/ufs/tc-dwc.h
similarity index 78%
rename from drivers/scsi/ufs/tc-dwc-g210.h
rename to drivers/scsi/ufs/tc-dwc.h
index 5a506da03f4a..e3c28a21a993 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.h
+++ b/drivers/scsi/ufs/tc-dwc.h
@@ -1,14 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Synopsys G210 Test Chip driver
+ * Synopsys Test Chip driver
  *
  * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
  *
  * Authors: Joao Pinto <jpinto@synopsys.com>
  */
 
-#ifndef _TC_DWC_G210_H
-#define _TC_DWC_G210_H
+#ifndef _TC_DWC_H
+#define _TC_DWC_H
 
 int tc_dwc_g210_config_40_bit(struct ufs_hba *hba);
 int tc_dwc_g210_config_20_bit(struct ufs_hba *hba);
-- 
2.7.4

