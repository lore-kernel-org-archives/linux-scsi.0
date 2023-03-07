Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487E7C678DB
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 05:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjCGFjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 00:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjCGFjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 00:39:14 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570873B650
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 21:39:12 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PW42S2KkHzKqJn;
        Tue,  7 Mar 2023 13:37:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 13:38:35 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 2/4] scsi: hisi_sas: Add poll support for v3 hw
Date:   Tue, 7 Mar 2023 14:09:13 +0800
Message-ID: <1678169355-76215-3-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
References: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add a module parameter to set how many queues which are used for iopoll,
and also fill the interface mq_poll.
For internal IOs from libsas and libata, we use non-iopoll queue (queue 0)
to deliver and complete them. But for internal abort IOs, just don't send
them for poll queues.

There is still a risk as it only sends internal abort commands to
non-iopoll queue which actually requires sending a internal abort command
to every queue. So make the module parameter as "experimental".

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 18 +++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 71 ++++++++++++++++++++++++++++++----
 3 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6f8a52a..a0eed81 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -207,6 +207,7 @@ struct hisi_sas_cq {
 	int	rd_point;
 	int	id;
 	int	irq_no;
+	spinlock_t poll_lock;
 };
 
 struct hisi_sas_dq {
@@ -484,6 +485,8 @@ struct hisi_hba {
 	struct dentry *debugfs_dump_dentry;
 	struct dentry *debugfs_bist_dentry;
 	struct dentry *debugfs_fifo_dentry;
+
+	int iopoll_q_cnt;
 };
 
 /* Generic HW DMA host memory structures */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8c038cc..628cfbe 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -529,10 +529,21 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 			dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
 			dq = &hisi_hba->dq[dq_index];
 		} else {
-			struct Scsi_Host *shost = hisi_hba->shost;
-			struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
-			int queue = qmap->mq_map[raw_smp_processor_id()];
+			int queue;
+
+			if (hisi_hba->iopoll_q_cnt) {
+				/*
+				 * Use interrupt queue (queue 0) to deliver and complete
+				 * internal IOs of libsas or libata when there is at least
+				 * one iopoll queue
+				 */
+				queue = 0;
+			} else {
+				struct Scsi_Host *shost = hisi_hba->shost;
+				struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 
+				queue = qmap->mq_map[raw_smp_processor_id()];
+			}
 			dq = &hisi_hba->dq[queue];
 		}
 		break;
@@ -2101,6 +2112,7 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 		/* Completion queue structure */
 		cq->id = i;
 		cq->hisi_hba = hisi_hba;
+		spin_lock_init(&cq->poll_lock);
 
 		/* Delivery queue structure */
 		spin_lock_init(&dq->lock);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 835cb87..24282bc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -552,6 +552,11 @@ static int prot_mask;
 module_param(prot_mask, int, 0444);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=0x0 ");
 
+/* the index of iopoll queues are bigger than interrupt queues' */
+static int experimental_iopoll_q_cnt;
+module_param(experimental_iopoll_q_cnt, int, 0444);
+MODULE_PARM_DESC(experimental_iopoll_q_cnt, "number of queues to be used as poll mode, def=0");
+
 static void debugfs_work_handler_v3_hw(struct work_struct *work);
 static void debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba);
 
@@ -2391,18 +2396,20 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 		task->task_done(task);
 }
 
-static void complete_v3_hw(struct hisi_sas_cq *cq)
+static int complete_v3_hw(struct hisi_sas_cq *cq)
 {
 	struct hisi_sas_complete_v3_hdr *complete_queue;
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
 	u32 rd_point, wr_point;
 	int queue = cq->id;
+	int completed;
 
 	rd_point = cq->rd_point;
 	complete_queue = hisi_hba->complete_hdr[queue];
 
 	wr_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_WR_PTR +
 				   (0x14 * queue));
+	completed = (wr_point + HISI_SAS_QUEUE_SLOTS - rd_point) % HISI_SAS_QUEUE_SLOTS;
 
 	while (rd_point != wr_point) {
 		struct hisi_sas_complete_v3_hdr *complete_hdr;
@@ -2450,6 +2457,21 @@ static void complete_v3_hw(struct hisi_sas_cq *cq)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+
+	return completed;
+}
+
+static int queue_complete_v3_hw(struct Scsi_Host *shost, unsigned int queue)
+{
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	struct hisi_sas_cq *cq = &hisi_hba->cq[queue];
+	int completed;
+
+	spin_lock(&cq->poll_lock);
+	completed = complete_v3_hw(cq);
+	spin_unlock(&cq->poll_lock);
+
+	return completed;
 }
 
 static irqreturn_t cq_thread_v3_hw(int irq_no, void *p)
@@ -2481,8 +2503,9 @@ static void hisi_sas_v3_free_vectors(void *data)
 
 static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 {
-	int vectors;
-	int max_msi = HISI_SAS_MSI_COUNT_V3_HW, min_msi;
+	/* Allocate all MSI vectors to avoid re-insertion issue */
+	int max_msi = HISI_SAS_MSI_COUNT_V3_HW;
+	int vectors, min_msi;
 	struct Scsi_Host *shost = hisi_hba->shost;
 	struct pci_dev *pdev = hisi_hba->pci_dev;
 	struct irq_affinity desc = {
@@ -2499,8 +2522,8 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 		return -ENOENT;
 
 
-	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
-	shost->nr_hw_queues = hisi_hba->cq_nvecs;
+	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
+	shost->nr_hw_queues = hisi_hba->cq_nvecs + hisi_hba->iopoll_q_cnt;
 
 	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 	return 0;
@@ -3218,9 +3241,31 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 static void hisi_sas_map_queues(struct Scsi_Host *shost)
 {
 	struct hisi_hba *hisi_hba = shost_priv(shost);
-	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+	struct blk_mq_queue_map *qmap;
+	int i, qoff;
+
+	for (i = 0, qoff = 0; i < shost->nr_maps; i++) {
+		qmap = &shost->tag_set.map[i];
+		if (i == HCTX_TYPE_DEFAULT) {
+			qmap->nr_queues = hisi_hba->cq_nvecs;
+		} else if (i == HCTX_TYPE_POLL) {
+			qmap->nr_queues = hisi_hba->iopoll_q_cnt;
+		} else {
+			qmap->nr_queues = 0;
+			continue;
+		}
 
-	blk_mq_pci_map_queues(qmap, hisi_hba->pci_dev, BASE_VECTORS_V3_HW);
+		/* At least one interrupt hardware queue */
+		if (!qmap->nr_queues)
+			WARN_ON(i == HCTX_TYPE_DEFAULT);
+		qmap->queue_offset = qoff;
+		if (i == HCTX_TYPE_POLL)
+			blk_mq_map_queues(qmap);
+		else
+			blk_mq_pci_map_queues(qmap, hisi_hba->pci_dev,
+					      BASE_VECTORS_V3_HW);
+		qoff += qmap->nr_queues;
+	}
 }
 
 static struct scsi_host_template sht_v3_hw = {
@@ -3252,6 +3297,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 	.host_reset             = hisi_sas_host_reset,
 	.host_tagset		= 1,
+	.mq_poll		= queue_complete_v3_hw,
 };
 
 static const struct hisi_sas_hw hisi_sas_v3_hw = {
@@ -3311,6 +3357,13 @@ hisi_sas_shost_alloc_pci(struct pci_dev *pdev)
 	if (hisi_sas_get_fw_info(hisi_hba) < 0)
 		goto err_out;
 
+	if (experimental_iopoll_q_cnt < 0 ||
+		experimental_iopoll_q_cnt >= hisi_hba->queue_count)
+		dev_err(dev, "iopoll queue count %d cannot exceed or equal 16, using default 0\n",
+			experimental_iopoll_q_cnt);
+	else
+		hisi_hba->iopoll_q_cnt = experimental_iopoll_q_cnt;
+
 	if (hisi_sas_alloc(hisi_hba)) {
 		hisi_sas_free(hisi_hba);
 		goto err_out;
@@ -4866,6 +4919,10 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_cmd_len = 16;
 	shost->can_queue = HISI_SAS_UNRESERVED_IPTT;
 	shost->cmd_per_lun = HISI_SAS_UNRESERVED_IPTT;
+	if (hisi_hba->iopoll_q_cnt)
+		shost->nr_maps = 3;
+	else
+		shost->nr_maps = 1;
 
 	sha->sas_ha_name = DRV_NAME;
 	sha->dev = dev;
-- 
2.8.1

