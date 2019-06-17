From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] scsi: ufs-qcom: Add support for platforms booting ACPI
Date: Mon, 17 Jun 2019 12:54:54 +0100
Message-ID: <20190617115454.3226-1-lee.jones@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agross@kernel.org, david.brown@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, jlhugo@gmail.com, bjorn.andersson@linaro.org, Lee Jones <lee.jones@linaro.org>
List-Id: linux-scsi@vger.kernel.org

New Qualcomm AArch64 based laptops are now available which use UFS
as their primary data storage medium.  These devices are supplied
with ACPI support out of the box.  This patch ensures the Qualcomm
UFS driver will be bound when the "QCOM24A5" H/W device is
advertised as present.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 3aeadb14aae1..364af6a63e35 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -12,6 +12,7 @@
  *
  */
 
+#include <linux/acpi.h>
 #include <linux/time.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -164,6 +165,9 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	int err = 0;
 	struct device *dev = host->hba->dev;
 
+	if (has_acpi_companion(dev))
+		return 0;
+
 	err = ufs_qcom_host_clk_get(dev, "rx_lane0_sync_clk",
 					&host->rx_l0_sync_clk, false);
 	if (err)
@@ -1208,9 +1212,13 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 			__func__, err);
 		goto out_variant_clear;
 	} else if (IS_ERR(host->generic_phy)) {
-		err = PTR_ERR(host->generic_phy);
-		dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
-		goto out_variant_clear;
+		if (has_acpi_companion(dev)) {
+			host->generic_phy = NULL;
+		} else {
+			err = PTR_ERR(host->generic_phy);
+			dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
+			goto out_variant_clear;
+		}
 	}
 
 	err = ufs_qcom_bus_register(host);
@@ -1680,6 +1688,14 @@ static const struct of_device_id ufs_qcom_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ufs_qcom_of_match);
 
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id ufs_qcom_acpi_match[] = {
+	{ "QCOM24A5" },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, ufs_qcom_acpi_match);
+#endif
+
 static const struct dev_pm_ops ufs_qcom_pm_ops = {
 	.suspend	= ufshcd_pltfrm_suspend,
 	.resume		= ufshcd_pltfrm_resume,
@@ -1696,6 +1712,7 @@ static struct platform_driver ufs_qcom_pltform = {
 		.name	= "ufshcd-qcom",
 		.pm	= &ufs_qcom_pm_ops,
 		.of_match_table = of_match_ptr(ufs_qcom_of_match),
+		.acpi_match_table = ACPI_PTR(ufs_qcom_acpi_match),
 	},
 };
 module_platform_driver(ufs_qcom_pltform);
-- 
2.17.1
