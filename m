From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] scsi: hisi_sas: service v2 hw CQ ISR with tasklet
Date: Tue, 3 Jan 2017 20:24:48 +0800
Message-ID: <1483446290-185084-2-git-send-email-john.garry@huawei.com>
References: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hanjun.guo@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently the all the slot processing for the completion
queue is done in ISR context. It is judged that the slot
processing can take a long time, especially when a SATA
NCQ completes (upto 32 slots).

So, as a solution, defer the bulk of the ISR processing
to tasklet context. Each CQ will have its down tasklet.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index c0cd505..9216dea 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -95,6 +95,7 @@ struct hisi_sas_port {
 
 struct hisi_sas_cq {
 	struct hisi_hba *hisi_hba;
+	struct tasklet_struct tasklet;
 	int	rd_point;
 	int	id;
 };
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b934aec..e506260 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2481,20 +2481,17 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
+static void cq_tasklet_v2_hw(unsigned long val)
 {
-	struct hisi_sas_cq *cq = p;
+	struct hisi_sas_cq *cq = (struct hisi_sas_cq *)val;
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_itct *itct;
 	struct hisi_sas_complete_v2_hdr *complete_queue;
-	u32 irq_value, rd_point = cq->rd_point, wr_point, dev_id;
+	u32 rd_point = cq->rd_point, wr_point, dev_id;
 	int queue = cq->id;
 
 	complete_queue = hisi_hba->complete_hdr[queue];
-	irq_value = hisi_sas_read32(hisi_hba, OQ_INT_SRC);
-
-	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
 
 	wr_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_WR_PTR +
 				   (0x14 * queue));
@@ -2545,6 +2542,18 @@ static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+}
+
+static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
+{
+	struct hisi_sas_cq *cq = p;
+	struct hisi_hba *hisi_hba = cq->hisi_hba;
+	int queue = cq->id;
+
+	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
+
+	tasklet_schedule(&cq->tasklet);
+
 	return IRQ_HANDLED;
 }
 
@@ -2726,6 +2735,8 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		int idx = i + 96; /* First cq interrupt is irq96 */
+		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+		struct tasklet_struct *t = &cq->tasklet;
 
 		irq = irq_map[idx];
 		if (!irq) {
@@ -2742,6 +2753,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 				irq, rc);
 			return -ENOENT;
 		}
+		tasklet_init(t, cq_tasklet_v2_hw, (unsigned long)cq);
 	}
 
 	return 0;
-- 
1.9.1
