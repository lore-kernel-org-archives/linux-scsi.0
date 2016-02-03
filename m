From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] hisi_sas: use Unified Device Properties API
Date: Thu, 4 Feb 2016 02:26:08 +0800
Message-ID: <1454523970-118251-2-git-send-email-john.garry@huawei.com>
References: <1454523970-118251-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454523970-118251-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The hisi_sas driver is required to support both
device tree and ACPI. The scanning of the device
properties now uses the Unified Device Properties
API, which serves both OF and ACPI.

Since syscon is not supported by ACPI, syscon is
only used in the driver when device tree is used.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 41 ++++++++++++++++++-----------------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 9f08c0c..5b8affd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -12,11 +12,13 @@
 #ifndef _HISI_SAS_H_
 #define _HISI_SAS_H_
 
+#include <linux/acpi.h>
 #include <linux/dmapool.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regmap.h>
 #include <scsi/sas_ata.h>
 #include <scsi/libsas.h>
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 406b515..2194917 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1167,7 +1167,6 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	struct hisi_hba *hisi_hba;
 	struct device *dev = &pdev->dev;
 	struct device_node *np = pdev->dev.of_node;
-	struct property *sas_addr_prop;
 
 	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
 	if (!shost)
@@ -1181,27 +1180,34 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 
 	init_timer(&hisi_hba->timer);
 
-	sas_addr_prop = of_find_property(np, "sas-addr", NULL);
-	if (!sas_addr_prop || (sas_addr_prop->length != SAS_ADDR_SIZE))
+	if (device_property_read_u8_array(dev, "sas-addr", hisi_hba->sas_addr,
+					  SAS_ADDR_SIZE))
 		goto err_out;
-	memcpy(hisi_hba->sas_addr, sas_addr_prop->value, SAS_ADDR_SIZE);
 
-	if (of_property_read_u32(np, "ctrl-reset-reg",
-				 &hisi_hba->ctrl_reset_reg))
-		goto err_out;
+	if (np) {
+		hisi_hba->ctrl = syscon_regmap_lookup_by_phandle(np,
+					"hisilicon,sas-syscon");
+		if (IS_ERR(hisi_hba->ctrl))
+			goto err_out;
 
-	if (of_property_read_u32(np, "ctrl-reset-sts-reg",
-				 &hisi_hba->ctrl_reset_sts_reg))
-		goto err_out;
+		if (device_property_read_u32(dev, "ctrl-reset-reg",
+					     &hisi_hba->ctrl_reset_reg))
+			goto err_out;
 
-	if (of_property_read_u32(np, "ctrl-clock-ena-reg",
-				 &hisi_hba->ctrl_clock_ena_reg))
-		goto err_out;
+		if (device_property_read_u32(dev, "ctrl-reset-sts-reg",
+					     &hisi_hba->ctrl_reset_sts_reg))
+			goto err_out;
 
-	if (of_property_read_u32(np, "phy-count", &hisi_hba->n_phy))
+		if (device_property_read_u32(dev, "ctrl-clock-ena-reg",
+					     &hisi_hba->ctrl_clock_ena_reg))
+			goto err_out;
+	}
+
+	if (device_property_read_u32(dev, "phy-count", &hisi_hba->n_phy))
 		goto err_out;
 
-	if (of_property_read_u32(np, "queue-count", &hisi_hba->queue_count))
+	if (device_property_read_u32(dev, "queue-count",
+				     &hisi_hba->queue_count))
 		goto err_out;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1209,11 +1215,6 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	if (IS_ERR(hisi_hba->regs))
 		goto err_out;
 
-	hisi_hba->ctrl = syscon_regmap_lookup_by_phandle(
-				np, "hisilicon,sas-syscon");
-	if (IS_ERR(hisi_hba->ctrl))
-		goto err_out;
-
 	if (hisi_sas_alloc(hisi_hba, shost)) {
 		hisi_sas_free(hisi_hba);
 		goto err_out;
-- 
1.9.1
