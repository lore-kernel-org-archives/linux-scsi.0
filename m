From: John Garry <john.garry@huawei.com>
Subject: [PATCH 01/15] hisi_sas: save completion queue read pointer
Date: Tue, 6 Sep 2016 23:36:11 +0800
Message-ID: <1473176185-217808-2-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Optimise by saving an avoidable read in the cq
interrupt.
The queue read pointer will only be updated
by software, so don't bother re-reading
what was already written in the previous interrupt.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 6 ++----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 5 ++---
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index ca55ec2..9410335 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -94,6 +94,7 @@ struct hisi_sas_port {
 
 struct hisi_sas_cq {
 	struct hisi_hba *hisi_hba;
+	int	rd_point;
 	int	id;
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 1abbc2e..3b31b20 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1565,14 +1565,11 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 	struct hisi_sas_complete_v1_hdr *complete_queue =
 			(struct hisi_sas_complete_v1_hdr *)
 			hisi_hba->complete_hdr[queue];
-	u32 irq_value, rd_point, wr_point;
+	u32 irq_value, rd_point = cq->rd_point, wr_point;
 
 	irq_value = hisi_sas_read32(hisi_hba, OQ_INT_SRC);
 
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
-
-	rd_point = hisi_sas_read32(hisi_hba,
-			COMPL_Q_0_RD_PTR + (0x14 * queue));
 	wr_point = hisi_sas_read32(hisi_hba,
 			COMPL_Q_0_WR_PTR + (0x14 * queue));
 
@@ -1600,6 +1597,7 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 	}
 
 	/* update rd_point */
+	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
 
 	return IRQ_HANDLED;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index bf9b693..11006c9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2049,7 +2049,7 @@ static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_itct *itct;
 	struct hisi_sas_complete_v2_hdr *complete_queue;
-	u32 irq_value, rd_point, wr_point, dev_id;
+	u32 irq_value, rd_point = cq->rd_point, wr_point, dev_id;
 	int queue = cq->id;
 
 	complete_queue = hisi_hba->complete_hdr[queue];
@@ -2057,8 +2057,6 @@ static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
 
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
 
-	rd_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_RD_PTR +
-				   (0x14 * queue));
 	wr_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_WR_PTR +
 				   (0x14 * queue));
 
@@ -2106,6 +2104,7 @@ static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
 	}
 
 	/* update rd_point */
+	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
 	return IRQ_HANDLED;
 }
-- 
1.9.1
