From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] hisi_sas: add v2 hw ACPI support
Date: Tue, 31 May 2016 20:38:49 +0800
Message-ID: <1464698331-228732-2-git-send-email-john.garry@huawei.com>
References: <1464698331-228732-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:30455 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbcEaM0B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2016 08:26:01 -0400
In-Reply-To: <1464698331-228732-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

Add support in v2 hw driver for ACPI.

A check on whether an ACPI handle is available for the device is used to
decide on whether to use ACPI reset handler or syscon for hw reset.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 68 +++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index bbe98ec..e933cdc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -721,30 +721,41 @@ static int reset_hw_v2_hw(struct hisi_hba *hisi_hba)
 			return -EIO;
 	}
 
-	/* reset and disable clock*/
-	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg,
-			reset_val);
-	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg + 4,
-			reset_val);
-	msleep(1);
-	regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg, &val);
-	if (reset_val != (val & reset_val)) {
-		dev_err(dev, "SAS reset fail.\n");
-		return -EIO;
-	}
+	if (ACPI_HANDLE(dev)) {
+		acpi_status s;
 
-	/* De-reset and enable clock*/
-	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg + 4,
-			reset_val);
-	regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg,
-			reset_val);
-	msleep(1);
-	regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg,
-			&val);
-	if (val & reset_val) {
-		dev_err(dev, "SAS de-reset fail.\n");
-		return -EIO;
-	}
+		s = acpi_evaluate_object(ACPI_HANDLE(dev), "_RST", NULL, NULL);
+		if (ACPI_FAILURE(s)) {
+			dev_err(dev, "Reset failed\n");
+			return -EIO;
+		}
+	} else if (hisi_hba->ctrl) {
+		/* reset and disable clock*/
+		regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg,
+				reset_val);
+		regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg + 4,
+				reset_val);
+		msleep(1);
+		regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg, &val);
+		if (reset_val != (val & reset_val)) {
+			dev_err(dev, "SAS reset fail.\n");
+			return -EIO;
+		}
+
+		/* De-reset and enable clock*/
+		regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_reset_reg + 4,
+				reset_val);
+		regmap_write(hisi_hba->ctrl, hisi_hba->ctrl_clock_ena_reg,
+				reset_val);
+		msleep(1);
+		regmap_read(hisi_hba->ctrl, hisi_hba->ctrl_reset_sts_reg,
+				&val);
+		if (val & reset_val) {
+			dev_err(dev, "SAS de-reset fail.\n");
+			return -EIO;
+		}
+	} else
+		dev_warn(dev, "no reset method\n");
 
 	return 0;
 }
@@ -752,13 +763,12 @@ static int reset_hw_v2_hw(struct hisi_hba *hisi_hba)
 static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
-	struct device_node *np = dev->of_node;
 	int i;
 
 	/* Global registers init */
 
 	/* Deal with am-max-transmissions quirk */
-	if (of_get_property(np, "hip06-sas-v2-quirk-amt", NULL)) {
+	if (device_property_present(dev, "hip06-sas-v2-quirk-amt")) {
 		hisi_sas_write32(hisi_hba, AM_CFG_MAX_TRANS, 0x2020);
 		hisi_sas_write32(hisi_hba, AM_CFG_SINGLE_PORT_MAX_TRANS,
 				 0x2020);
@@ -2257,12 +2267,20 @@ static const struct of_device_id sas_v2_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sas_v2_of_match);
 
+static const struct acpi_device_id sas_v2_acpi_match[] = {
+	{ "HISI0162", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(acpi, sas_v2_acpi_match);
+
 static struct platform_driver hisi_sas_v2_driver = {
 	.probe = hisi_sas_v2_probe,
 	.remove = hisi_sas_v2_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table = sas_v2_of_match,
+		.acpi_match_table = ACPI_PTR(sas_v2_acpi_match),
 	},
 };
 
-- 
1.9.1

