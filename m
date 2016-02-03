From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/3] hisi_sas: add v1 hw ACPI support
Date: Thu, 4 Feb 2016 02:26:09 +0800
Message-ID: <1454523970-118251-3-git-send-email-john.garry@huawei.com>
References: <1454523970-118251-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454523970-118251-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add support in v1 hw driver for ACPI.

A check on whether an ACPI handle is available
for the device is used to decide on whether to
use ACPI reset handler or syscon for hw reset.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 67 ++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 24274f1..55ac703 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -623,31 +623,42 @@ static int reset_hw_v1_hw(struct hisi_hba *hisi_hba)
 			return -EIO;
 	}
 
-	/* Apply reset and disable clock */
-	/* clk disable reg is offset by +4 bytes from clk enable reg */
-	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg,
-		     RESET_VALUE);
-	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg + 4,
-		     RESET_VALUE);
-	msleep(1);
-	regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg, &val);
-	if (RESET_VALUE != (val & RESET_VALUE)) {
-		dev_err(dev, "Reset failed\n");
-		return -EIO;
-	}
+	if (ACPI_HANDLE(dev)) {
+		acpi_status s;
 
-	/* De-reset and enable clock */
-	/* deassert rst reg is offset by +4 bytes from assert reg */
-	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg + 4,
-		     RESET_VALUE);
-	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg,
-		     RESET_VALUE);
-	msleep(1);
-	regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg, &val);
-	if (val & RESET_VALUE) {
-		dev_err(dev, "De-reset failed\n");
-		return -EIO;
-	}
+		s = acpi_evaluate_object(ACPI_HANDLE(dev), "_RST", NULL, NULL);
+		if (ACPI_FAILURE(s)) {
+			dev_err(dev, "Reset failed\n");
+			return -EIO;
+		}
+	} else if (hisi_hba->ctrl) {
+		/* Apply reset and disable clock */
+		/* clk disable reg is offset by +4 bytes from clk enable reg */
+		regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg,
+			     RESET_VALUE);
+		regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg + 4,
+			     RESET_VALUE);
+		msleep(1);
+		regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg, &val);
+		if (RESET_VALUE != (val & RESET_VALUE)) {
+			dev_err(dev, "Reset failed\n");
+			return -EIO;
+		}
+
+		/* De-reset and enable clock */
+		/* deassert rst reg is offset by +4 bytes from assert reg */
+		regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg + 4,
+			     RESET_VALUE);
+		regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg,
+			     RESET_VALUE);
+		msleep(1);
+		regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg, &val);
+		if (val & RESET_VALUE) {
+			dev_err(dev, "De-reset failed\n");
+			return -EIO;
+		}
+	} else
+		dev_warn(dev, "no reset method\n");
 
 	return 0;
 }
@@ -1834,12 +1845,20 @@ static const struct of_device_id sas_v1_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sas_v1_of_match);
 
+static const struct acpi_device_id sas_v1_acpi_match[] = {
+	{ "HISI0161", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(acpi, sas_v1_acpi_match);
+
 static struct platform_driver hisi_sas_v1_driver = {
 	.probe = hisi_sas_v1_probe,
 	.remove = hisi_sas_v1_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table = sas_v1_of_match,
+		.acpi_match_table = ACPI_PTR(sas_v1_acpi_match),
 	},
 };
 
-- 
1.9.1
