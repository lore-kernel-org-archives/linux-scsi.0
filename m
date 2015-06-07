From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v3 4/4] scsi: ufs: probe and init of variant driver from the platform device
Date: Sun,  7 Jun 2015 19:27:04 +0300
Message-ID: <1433694425-23478-5-git-send-email-ygardi@codeaurora.org>
References: <1433694425-23478-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52319 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbFGQ1r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2015 12:27:47 -0400
In-Reply-To: <1433694425-23478-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, akinobu.mita@gmail.com, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, pebolle@tiscali.nl, gbroner@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Dolev Raviv <draviv@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>

It does so by adding the following changes:
1. Introducing SCSI_UFS_QCOM as a platform device. Its probe
   function registers a set of vops to its driver_data.
2. Adding an optional device tree sub-node, under SCSI_UFSHCD_PLATFORM.
   Now, the probe function of SCSI_UFSHCD_PLATFORM invokes the probe
   function of its sub-node (if it exists), by calling
   of_platform_populate(). It ensures that vops are set, and ready to
   be used, by the time the UFSHCD driver starts its initialization
   procedure.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  8 ++++
 drivers/scsi/ufs/ufs-qcom.c                        | 41 +++++++++++++++++++-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   | 45 +++++++++++++++-------
 3 files changed, 80 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 5357919..e2f3058 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -55,3 +55,11 @@ Example:
 		clock-names = "core_clk", "ref_clk", "iface_clk";
 		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>;
 	};
+
+This is an example to a variant sub-node of ufshc:
+	ufs_variant {
+		compatible = "qcom,ufs_variant";
+	};
+
+This sub-node holds various specific information that is not defined in the
+standard and that may differ between platforms.
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6671a8e..4391f1e 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1016,6 +1016,45 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.suspend		= ufs_qcom_suspend,
 	.resume			= ufs_qcom_resume,
 };
-EXPORT_SYMBOL(ufs_hba_qcom_vops);
+
+/**
+ * ufs_qcom_probe - probe routine of the driver
+ * @pdev: pointer to Platform device handle
+ *
+ * Always return 0
+ */
+static int ufs_qcom_probe(struct platform_device *pdev)
+{
+	dev_set_drvdata(&pdev->dev, (void *)&ufs_hba_qcom_vops);
+	return 0;
+}
+
+/**
+ * ufs_qcom_remove - set driver_data of the device to NULL
+ * @pdev: pointer to platform device handle
+ *
+ * Always return 0
+ */
+static int ufs_qcom_remove(struct platform_device *pdev)
+{
+	dev_set_drvdata(&pdev->dev, NULL);
+	return 0;
+}
+
+static const struct of_device_id ufs_qcom_of_match[] = {
+	{ .compatible = "qcom,ufs_variant"},
+	{},
+};
+
+static struct platform_driver ufs_qcom_pltform = {
+	.probe	= ufs_qcom_probe,
+	.remove	= ufs_qcom_remove,
+	.driver	= {
+		.name	= "ufs_qcom",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ufs_qcom_of_match),
+	},
+};
+module_platform_driver(ufs_qcom_pltform);
 
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 7db9564..a3f0a61 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -36,22 +36,11 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 
 #include "ufshcd.h"
 
 static const struct of_device_id ufs_of_match[];
-static struct ufs_hba_variant_ops *get_variant_ops(struct device *dev)
-{
-	if (dev->of_node) {
-		const struct of_device_id *match;
-
-		match = of_match_node(ufs_of_match, dev->of_node);
-		if (match)
-			return (struct ufs_hba_variant_ops *)match->data;
-	}
-
-	return NULL;
-}
 
 static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 {
@@ -300,6 +289,9 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 	struct resource *mem_res;
 	int irq, err;
 	struct device *dev = &pdev->dev;
+	struct device_node *node = pdev->dev.of_node;
+	struct device_node *ufs_variant_node;
+	struct platform_device *ufs_variant_pdev;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mmio_base = devm_ioremap_resource(dev, mem_res);
@@ -321,7 +313,23 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	hba->vops = get_variant_ops(&pdev->dev);
+	err = of_platform_populate(node, NULL, NULL, &pdev->dev);
+	if (err)
+		dev_err(&pdev->dev,
+			"%s: of_platform_populate() failed\n", __func__);
+
+	ufs_variant_node = of_get_next_available_child(node, NULL);
+
+	if (!ufs_variant_node) {
+		dev_dbg(&pdev->dev, "failed to find ufs_variant_node child\n");
+	} else {
+		ufs_variant_pdev = of_find_device_by_node(ufs_variant_node);
+
+		if (ufs_variant_pdev) {
+			__module_get(ufs_variant_pdev->dev.driver->owner);
+			hba->vops = dev_get_drvdata(&ufs_variant_pdev->dev);
+		}
+	}
 
 	err = ufshcd_parse_clock_info(hba);
 	if (err) {
@@ -365,9 +373,20 @@ out:
 static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+	struct device_node *node = pdev->dev.of_node;
+	struct device_node *ufs_variant_node;
+	struct platform_device *ufs_variant_pdev;
+
+	ufs_variant_node = of_get_next_available_child(node, NULL);
+
+	if (!ufs_variant_node)
+		dev_dbg(&pdev->dev, "no ufs_variant_node found\n");
+	else
+		ufs_variant_pdev = of_find_device_by_node(ufs_variant_node);
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
+	module_put(ufs_variant_pdev->dev.driver->owner);
 	return 0;
 }
 
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
