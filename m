From: Jan Kotas <jank@cadence.com>
Subject: [PATCH 2/2] scsi: ufs-cdns: Add support for UFSHCI with M31 PHY
Date: Wed, 27 Mar 2019 14:44:05 +0000
Message-ID: <20190327144405.5716-3-jank@cadence.com>
References: <20190327144405.5716-1-jank@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327144405.5716-1-jank@cadence.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jan Kotas <jank@cadence.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds an additional PHY initialization, required for
M31 PHY when used with Cadence UFS HC.
A new compatible string has been added for this purpose.

Signed-off-by: Jan Kotas <jank@cadence.com>
---
 drivers/scsi/ufs/cdns-pltfrm.c | 77 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index 4a37b4f57..e0c8834df 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -17,7 +17,8 @@
 
 #include "ufshcd-pltfrm.h"
 
-#define CDNS_UFS_REG_HCLKDIV 0xFC
+#define CDNS_UFS_REG_HCLKDIV	0xFC
+#define CDNS_UFS_REG_PHY_XCFGD1	0x113C
 
 /**
  * Sets HCLKDIV register value based on the core_clk
@@ -77,11 +78,69 @@ static int cdns_ufs_setup_clocks(struct ufs_hba *hba, bool on,
 	return cdns_ufs_set_hclkdiv(hba);
 }
 
-static struct ufs_hba_variant_ops cdns_pltfm_hba_vops = {
+/**
+ * cdns_ufs_init - performs additional ufs initialization
+ * @hba: host controller instance
+ *
+ * Returns status of initialization
+ */
+static int cdns_ufs_init(struct ufs_hba *hba)
+{
+	int status = 0;
+
+	if (hba->vops && hba->vops->phy_initialization) {
+		status = hba->vops->phy_initialization(hba);
+		if (status)
+			return status;
+	}
+
+	return status;
+}
+
+/**
+ * cdns_ufs_m31_16nm_phy_initialization - performs m31 phy initialization
+ * @hba: host controller instance
+ *
+ * Always returns 0
+ */
+static int cdns_ufs_m31_16nm_phy_initialization(struct ufs_hba *hba)
+{
+	u32 data;
+
+	/* Increase RX_Advanced_Min_ActivateTime_Capability */
+	data = ufshcd_readl(hba, CDNS_UFS_REG_PHY_XCFGD1);
+	data |= BIT(24);
+	ufshcd_writel(hba, data, CDNS_UFS_REG_PHY_XCFGD1);
+
+	return 0;
+}
+
+static const struct ufs_hba_variant_ops cdns_ufs_pltfm_hba_vops = {
+	.name = "cdns-ufs-pltfm",
+	.setup_clocks = cdns_ufs_setup_clocks,
+};
+
+static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
 	.name = "cdns-ufs-pltfm",
+	.init = cdns_ufs_init,
 	.setup_clocks = cdns_ufs_setup_clocks,
+	.phy_initialization = cdns_ufs_m31_16nm_phy_initialization,
 };
 
+static const struct of_device_id cdns_ufs_of_match[] = {
+	{
+		.compatible = "cdns,ufshc",
+		.data =  &cdns_ufs_pltfm_hba_vops,
+	},
+	{
+		.compatible = "cdns,ufshc-m31-16nm",
+		.data =  &cdns_ufs_m31_16nm_pltfm_hba_vops,
+	},
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, cdns_ufs_of_match);
+
 /**
  * cdns_ufs_pltfrm_probe - probe routine of the driver
  * @pdev: pointer to platform device handle
@@ -91,10 +150,15 @@ static struct ufs_hba_variant_ops cdns_pltfm_hba_vops = {
 static int cdns_ufs_pltfrm_probe(struct platform_device *pdev)
 {
 	int err;
+	const struct of_device_id *of_id;
+	struct ufs_hba_variant_ops *vops;
 	struct device *dev = &pdev->dev;
 
+	of_id = of_match_node(cdns_ufs_of_match, dev->of_node);
+	vops = (struct ufs_hba_variant_ops *)of_id->data;
+
 	/* Perform generic probe */
-	err = ufshcd_pltfrm_init(pdev, &cdns_pltfm_hba_vops);
+	err = ufshcd_pltfrm_init(pdev, vops);
 	if (err)
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
 
@@ -115,13 +179,6 @@ static int cdns_ufs_pltfrm_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id cdns_ufs_of_match[] = {
-	{ .compatible = "cdns,ufshc" },
-	{},
-};
-
-MODULE_DEVICE_TABLE(of, cdns_ufs_of_match);
-
 static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
 	.suspend         = ufshcd_pltfrm_suspend,
 	.resume          = ufshcd_pltfrm_resume,
-- 
2.15.0
