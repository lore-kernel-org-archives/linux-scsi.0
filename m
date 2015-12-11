From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2] hisi_sas: use platform_get_irq()
Date: Fri, 11 Dec 2015 20:03:21 +0800
Message-ID: <1449835401-200442-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, robh@kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

It is preferred that drivers use platform_get_irq()
instead of irq_of_parse_and_map(), so replace.

Signed-off-by: John Garry <john.garry@huawei.com>
Acked-by: Rob Herring <robh@kernel.org>

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 30a9ab9..5af2e41 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -16,7 +16,6 @@
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <scsi/libsas.h>
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 0ed2f92..d543811 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1673,19 +1673,16 @@ static irq_handler_t fatal_interrupts[HISI_SAS_MAX_QUEUES] = {
 
 static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 {
-	struct device *dev = &hisi_hba->pdev->dev;
-	struct device_node *np = dev->of_node;
+	struct platform_device *pdev = hisi_hba->pdev;
+	struct device *dev = &pdev->dev;
 	int i, j, irq, rc, idx;
 
-	if (!np)
-		return -ENOENT;
-
 	for (i = 0; i < hisi_hba->n_phy; i++) {
 		struct hisi_sas_phy *phy = &hisi_hba->phy[i];
 
 		idx = i * HISI_SAS_PHY_INT_NR;
 		for (j = 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
-			irq = irq_of_parse_and_map(np, idx);
+			irq = platform_get_irq(pdev, idx);
 			if (!irq) {
 				dev_err(dev,
 					"irq init: fail map phy interrupt %d\n",
@@ -1706,7 +1703,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 
 	idx = hisi_hba->n_phy * HISI_SAS_PHY_INT_NR;
 	for (i = 0; i < hisi_hba->queue_count; i++, idx++) {
-		irq = irq_of_parse_and_map(np, idx);
+		irq = platform_get_irq(pdev, idx);
 		if (!irq) {
 			dev_err(dev, "irq init: could not map cq interrupt %d\n",
 				idx);
@@ -1724,7 +1721,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 
 	idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + hisi_hba->queue_count;
 	for (i = 0; i < HISI_SAS_FATAL_INT_NR; i++, idx++) {
-		irq = irq_of_parse_and_map(np, idx);
+		irq = platform_get_irq(pdev, idx);
 		if (!irq) {
 			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
 				idx);
-- 
1.9.1
