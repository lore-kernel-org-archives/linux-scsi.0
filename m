From: John Garry <john.garry@huawei.com>
Subject: [PATCH 02/15] hisi_sas: save delivery queue write pointer
Date: Tue, 6 Sep 2016 23:36:12 +0800
Message-ID: <1473176185-217808-3-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:47477 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935723AbcIFPXw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2016 11:23:52 -0400
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

Optimise by saving an avoidable read in the
get_free_slot function.
The delivery queue write pointer will only be
updated by software, so don't bother re-reading
what was already written in the previous call
to start_delivery function.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  7 +++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  5 +++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 12 +++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  9 ++++++---
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 9410335..72c9852 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -98,6 +98,12 @@ struct hisi_sas_cq {
 	int	id;
 };
 
+struct hisi_sas_dq {
+	struct hisi_hba *hisi_hba;
+	int	wr_point;
+	int	id;
+};
+
 struct hisi_sas_device {
 	enum sas_device_type	dev_type;
 	struct hisi_hba		*hisi_hba;
@@ -194,6 +200,7 @@ struct hisi_hba {
 	struct Scsi_Host *shost;
 
 	struct hisi_sas_cq cq[HISI_SAS_MAX_QUEUES];
+	struct hisi_sas_dq dq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_phy phy[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 85c73d3..5d56576 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1239,11 +1239,16 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+		struct hisi_sas_dq *dq = &hisi_hba->dq[i];
 
 		/* Completion queue structure */
 		cq->id = i;
 		cq->hisi_hba = hisi_hba;
 
+		/* Delivery queue structure */
+		dq->id = i;
+		dq->hisi_hba = hisi_hba;
+
 		/* Delivery queue */
 		s = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
 		hisi_hba->cmd_hdr[i] = dma_alloc_coherent(dev, s,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 3b31b20..b537464 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -875,12 +875,13 @@ static int get_wideport_bitmap_v1_hw(struct hisi_hba *hisi_hba, int port_id)
 static int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, int *q, int *s)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
+	struct hisi_sas_dq *dq;
 	u32 r, w;
 	int queue = hisi_hba->queue;
 
 	while (1) {
-		w = hisi_sas_read32_relaxed(hisi_hba,
-				    DLVRY_Q_0_WR_PTR + (queue * 0x14));
+		dq = &hisi_hba->dq[queue];
+		w = dq->wr_point;
 		r = hisi_sas_read32_relaxed(hisi_hba,
 				    DLVRY_Q_0_RD_PTR + (queue * 0x14));
 		if (r == (w+1) % HISI_SAS_QUEUE_SLOTS) {
@@ -903,10 +904,11 @@ static void start_delivery_v1_hw(struct hisi_hba *hisi_hba)
 {
 	int dlvry_queue = hisi_hba->slot_prep->dlvry_queue;
 	int dlvry_queue_slot = hisi_hba->slot_prep->dlvry_queue_slot;
+	struct hisi_sas_dq *dq = &hisi_hba->dq[dlvry_queue];
 
-	hisi_sas_write32(hisi_hba,
-			 DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14),
-			 ++dlvry_queue_slot % HISI_SAS_QUEUE_SLOTS);
+	dq->wr_point = ++dlvry_queue_slot % HISI_SAS_QUEUE_SLOTS;
+	hisi_sas_write32(hisi_hba, DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14),
+			 dq->wr_point);
 }
 
 static int prep_prd_sge_v1_hw(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 11006c9..e0c124b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1023,12 +1023,13 @@ static int get_wideport_bitmap_v2_hw(struct hisi_hba *hisi_hba, int port_id)
 static int get_free_slot_v2_hw(struct hisi_hba *hisi_hba, int *q, int *s)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
+	struct hisi_sas_dq *dq;
 	u32 r, w;
 	int queue = hisi_hba->queue;
 
 	while (1) {
-		w = hisi_sas_read32_relaxed(hisi_hba,
-					    DLVRY_Q_0_WR_PTR + (queue * 0x14));
+		dq = &hisi_hba->dq[queue];
+		w = dq->wr_point;
 		r = hisi_sas_read32_relaxed(hisi_hba,
 					    DLVRY_Q_0_RD_PTR + (queue * 0x14));
 		if (r == (w+1) % HISI_SAS_QUEUE_SLOTS) {
@@ -1051,9 +1052,11 @@ static void start_delivery_v2_hw(struct hisi_hba *hisi_hba)
 {
 	int dlvry_queue = hisi_hba->slot_prep->dlvry_queue;
 	int dlvry_queue_slot = hisi_hba->slot_prep->dlvry_queue_slot;
+	struct hisi_sas_dq *dq = &hisi_hba->dq[dlvry_queue];
 
+	dq->wr_point = ++dlvry_queue_slot % HISI_SAS_QUEUE_SLOTS;
 	hisi_sas_write32(hisi_hba, DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14),
-			 ++dlvry_queue_slot % HISI_SAS_QUEUE_SLOTS);
+			 dq->wr_point);
 }
 
 static int prep_prd_sge_v2_hw(struct hisi_hba *hisi_hba,
-- 
1.9.1

