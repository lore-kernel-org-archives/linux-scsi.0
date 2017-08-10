From: John Garry <john.garry@huawei.com>
Subject: [PATCH 07/19] scsi: hisi_sas: add irq and tasklet cleanup in v2 hw
Date: Fri, 11 Aug 2017 00:09:32 +0800
Message-ID: <1502381384-219889-8-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

This patch adds support to clean-up allocated IRQs and
kill tasklets when probe fails and for driver removal.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 96 +++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index bcbc16e..9eea0b4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3290,97 +3290,92 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 {
 	struct platform_device *pdev = hisi_hba->platform_dev;
 	struct device *dev = &pdev->dev;
-	int i, irq, rc, irq_map[128];
-
+	int irq, rc, irq_map[128];
+	int i, phy_no, fatal_no, queue_no, k;
 
 	for (i = 0; i < 128; i++)
 		irq_map[i] = platform_get_irq(pdev, i);
 
 	for (i = 0; i < HISI_SAS_PHY_INT_NR; i++) {
-		int idx = i;
-
-		irq = irq_map[idx + 1]; /* Phy up/down is irq1 */
-		if (!irq) {
-			dev_err(dev, "irq init: fail map phy interrupt %d\n",
-				idx);
-			return -ENOENT;
-		}
-
+		irq = irq_map[i + 1]; /* Phy up/down is irq1 */
 		rc = devm_request_irq(dev, irq, phy_interrupts[i], 0,
 				      DRV_NAME " phy", hisi_hba);
 		if (rc) {
 			dev_err(dev, "irq init: could not request "
 				"phy interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			rc = -ENOENT;
+			goto free_phy_int_irqs;
 		}
 	}
 
-	for (i = 0; i < hisi_hba->n_phy; i++) {
-		struct hisi_sas_phy *phy = &hisi_hba->phy[i];
-		int idx = i + 72; /* First SATA interrupt is irq72 */
-
-		irq = irq_map[idx];
-		if (!irq) {
-			dev_err(dev, "irq init: fail map phy interrupt %d\n",
-				idx);
-			return -ENOENT;
-		}
+	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
+		struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 
+		irq = irq_map[phy_no + 72];
 		rc = devm_request_irq(dev, irq, sata_int_v2_hw, 0,
 				      DRV_NAME " sata", phy);
 		if (rc) {
 			dev_err(dev, "irq init: could not request "
 				"sata interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			rc = -ENOENT;
+			goto free_sata_int_irqs;
 		}
 	}
 
-	for (i = 0; i < HISI_SAS_FATAL_INT_NR; i++) {
-		int idx = i;
-
-		irq = irq_map[idx + 81];
-		if (!irq) {
-			dev_err(dev, "irq init: fail map fatal interrupt %d\n",
-				idx);
-			return -ENOENT;
-		}
-
-		rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
+	for (fatal_no = 0; fatal_no < HISI_SAS_FATAL_INT_NR; fatal_no++) {
+		irq = irq_map[fatal_no + 81];
+		rc = devm_request_irq(dev, irq, fatal_interrupts[fatal_no], 0,
 				      DRV_NAME " fatal", hisi_hba);
 		if (rc) {
 			dev_err(dev,
 				"irq init: could not request fatal interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			rc = -ENOENT;
+			goto free_fatal_int_irqs;
 		}
 	}
 
-	for (i = 0; i < hisi_hba->queue_count; i++) {
-		int idx = i + 96; /* First cq interrupt is irq96 */
-		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+	for (queue_no = 0; queue_no < hisi_hba->queue_count; queue_no++) {
+		struct hisi_sas_cq *cq = &hisi_hba->cq[queue_no];
 		struct tasklet_struct *t = &cq->tasklet;
 
-		irq = irq_map[idx];
-		if (!irq) {
-			dev_err(dev,
-				"irq init: could not map cq interrupt %d\n",
-				idx);
-			return -ENOENT;
-		}
+		irq = irq_map[queue_no + 96];
 		rc = devm_request_irq(dev, irq, cq_interrupt_v2_hw, 0,
-				      DRV_NAME " cq", &hisi_hba->cq[i]);
+				      DRV_NAME " cq", cq);
 		if (rc) {
 			dev_err(dev,
 				"irq init: could not request cq interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			rc = -ENOENT;
+			goto free_cq_int_irqs;
 		}
 		tasklet_init(t, cq_tasklet_v2_hw, (unsigned long)cq);
 	}
 
 	return 0;
+
+free_cq_int_irqs:
+	for (k = 0; k < queue_no; k++) {
+		struct hisi_sas_cq *cq = &hisi_hba->cq[k];
+
+		free_irq(irq_map[k + 96], cq);
+		tasklet_kill(&cq->tasklet);
+	}
+free_fatal_int_irqs:
+	for (k = 0; k < fatal_no; k++)
+		free_irq(irq_map[k + 81], hisi_hba);
+free_sata_int_irqs:
+	for (k = 0; k < phy_no; k++) {
+		struct hisi_sas_phy *phy = &hisi_hba->phy[k];
+
+		free_irq(irq_map[k + 72], phy);
+	}
+free_phy_int_irqs:
+	for (k = 0; k < i; k++)
+		free_irq(irq_map[k + 1], hisi_hba);
+	return rc;
 }
 
 static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
@@ -3518,10 +3513,17 @@ static int hisi_sas_v2_remove(struct platform_device *pdev)
 {
 	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	int i;
 
 	if (timer_pending(&hisi_hba->timer))
 		del_timer(&hisi_hba->timer);
 
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+
+		tasklet_kill(&cq->tasklet);
+	}
+
 	return hisi_sas_remove(pdev);
 }
 
-- 
1.9.1
