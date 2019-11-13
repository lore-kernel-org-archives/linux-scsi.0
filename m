Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D37C17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 347AE22466
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKMNk3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:40:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:40684 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726978AbfKMNk3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 08:40:29 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 041A7B6C1A483B587A4F;
        Wed, 13 Nov 2019 21:40:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 13 Nov 2019 21:40:16 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <hare@suse.com>, <bvanassche@acm.org>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC 5/5] scsi: hisi_sas: Switch v3 hw to MQ
Date:   Wed, 13 Nov 2019 21:36:49 +0800
Message-ID: <1573652209-163505-6-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that the block layer provides a shared tag, we can switch the driver
to expose all HW queues.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 43 +++++++------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 85 +++++++++++---------------
 3 files changed, 59 insertions(+), 72 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 233c73e01246..0405602df2a4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -8,6 +8,8 @@
 #define _HISI_SAS_H_
 
 #include <linux/acpi.h>
+#include <linux/blk-mq.h>
+#include <linux/blk-mq-pci.h>
 #include <linux/clk.h>
 #include <linux/debugfs.h>
 #include <linux/dmapool.h>
@@ -431,7 +433,6 @@ struct hisi_hba {
 	u32 intr_coal_count;	/* Interrupt count to coalesce */
 
 	int cq_nvecs;
-	unsigned int *reply_map;
 
 	/* bist */
 	enum sas_linkrate debugfs_bist_linkrate;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 52d5b9afbb18..cca94b296065 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -183,12 +183,13 @@ static void hisi_sas_slot_index_set(struct hisi_hba *hisi_hba, int slot_idx)
 static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 				     struct scsi_cmnd *scsi_cmnd)
 {
-	int index;
 	void *bitmap = hisi_hba->slot_index_tags;
+	struct Scsi_Host *shost = hisi_hba->shost;
 	unsigned long flags;
+	int index;
 
-	if (scsi_cmnd)
-		return scsi_cmnd->request->tag;
+	if (shost->hostt->host_tagset && scsi_cmnd)
+		return scsi_cmnd->request->shared_tag;
 
 	spin_lock_irqsave(&hisi_hba->lock, flags);
 	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
@@ -421,6 +422,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	struct device *dev = hisi_hba->dev;
 	int dlvry_queue_slot, dlvry_queue, rc, slot_idx;
 	int n_elem = 0, n_elem_dif = 0, n_elem_req = 0;
+	struct scsi_cmnd *scmd = NULL;
 	struct hisi_sas_dq *dq;
 	unsigned long flags;
 	int wr_q_index;
@@ -436,10 +438,23 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		return -ECOMM;
 	}
 
-	if (hisi_hba->reply_map) {
-		int cpu = raw_smp_processor_id();
-		unsigned int dq_index = hisi_hba->reply_map[cpu];
+	if (task->uldd_task) {
+		struct ata_queued_cmd *qc;
+
+		if (dev_is_sata(device)) {
+			qc = task->uldd_task;
+			scmd = qc->scsicmd;
+		} else {
+			scmd = task->uldd_task;
+		}
+	}
 
+	if (scmd) {
+		unsigned int dq_index;
+		u32 blk_tag;
+
+		blk_tag = blk_mq_unique_tag(scmd->request);
+		dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
 		*dq_pointer = dq = &hisi_hba->dq[dq_index];
 	} else {
 		*dq_pointer = dq = sas_dev->dq;
@@ -468,21 +483,9 @@ static int hisi_sas_task_prep(struct sas_task *task,
 
 	if (hisi_hba->hw->slot_index_alloc)
 		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
-	else {
-		struct scsi_cmnd *scsi_cmnd = NULL;
-
-		if (task->uldd_task) {
-			struct ata_queued_cmd *qc;
+	else
+		rc = hisi_sas_slot_index_alloc(hisi_hba, scmd);
 
-			if (dev_is_sata(device)) {
-				qc = task->uldd_task;
-				scsi_cmnd = qc->scsicmd;
-			} else {
-				scsi_cmnd = task->uldd_task;
-			}
-		}
-		rc  = hisi_sas_slot_index_alloc(hisi_hba, scsi_cmnd);
-	}
 	if (rc < 0)
 		goto err_out_dif_dma_unmap;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index bf5d5f138437..98f2bd24a23b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2353,66 +2353,35 @@ static irqreturn_t cq_interrupt_v3_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
-static void setup_reply_map_v3_hw(struct hisi_hba *hisi_hba, int nvecs)
+static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 {
-	const struct cpumask *mask;
-	int queue, cpu;
-
-	for (queue = 0; queue < nvecs; queue++) {
-		struct hisi_sas_cq *cq = &hisi_hba->cq[queue];
+	int vectors;
+	int max_msi = HISI_SAS_MSI_COUNT_V3_HW, min_msi;
+	struct Scsi_Host *shost = hisi_hba->shost;
+	struct irq_affinity desc = {
+		.pre_vectors = BASE_VECTORS_V3_HW,
+	};
+
+	min_msi = MIN_AFFINE_VECTORS_V3_HW;
+	vectors = pci_alloc_irq_vectors_affinity(hisi_hba->pci_dev,
+						 min_msi, max_msi,
+						 PCI_IRQ_MSI |
+						 PCI_IRQ_AFFINITY,
+						 &desc);
+	if (vectors < 0)
+		return -ENOENT;
 
-		mask = pci_irq_get_affinity(hisi_hba->pci_dev, queue +
-					    BASE_VECTORS_V3_HW);
-		if (!mask)
-			goto fallback;
-		cq->pci_irq_mask = mask;
-		for_each_cpu(cpu, mask)
-			hisi_hba->reply_map[cpu] = queue;
-	}
-	return;
+	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
+	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
-fallback:
-	for_each_possible_cpu(cpu)
-		hisi_hba->reply_map[cpu] = cpu % hisi_hba->queue_count;
-	/* Don't clean all CQ masks */
+	return 0;
 }
 
 static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
 	struct pci_dev *pdev = hisi_hba->pci_dev;
-	int vectors, rc, i;
-	int max_msi = HISI_SAS_MSI_COUNT_V3_HW, min_msi;
-
-	if (auto_affine_msi_experimental) {
-		struct irq_affinity desc = {
-			.pre_vectors = BASE_VECTORS_V3_HW,
-		};
-
-		min_msi = MIN_AFFINE_VECTORS_V3_HW;
-
-		hisi_hba->reply_map = devm_kcalloc(dev, nr_cpu_ids,
-						   sizeof(unsigned int),
-						   GFP_KERNEL);
-		if (!hisi_hba->reply_map)
-			return -ENOMEM;
-		vectors = pci_alloc_irq_vectors_affinity(hisi_hba->pci_dev,
-							 min_msi, max_msi,
-							 PCI_IRQ_MSI |
-							 PCI_IRQ_AFFINITY,
-							 &desc);
-		if (vectors < 0)
-			return -ENOENT;
-		setup_reply_map_v3_hw(hisi_hba, vectors - BASE_VECTORS_V3_HW);
-	} else {
-		min_msi = max_msi;
-		vectors = pci_alloc_irq_vectors(hisi_hba->pci_dev, min_msi,
-						max_msi, PCI_IRQ_MSI);
-		if (vectors < 0)
-			return vectors;
-	}
-
-	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
+	int rc, i;
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, 1),
 			      int_phy_up_down_bcast_v3_hw, 0,
@@ -3057,6 +3026,15 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 	return 0;
 }
 
+static int hisi_sas_map_queues(struct Scsi_Host *shost)
+{
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+
+	return blk_mq_pci_map_queues(qmap, hisi_hba->pci_dev,
+					     BASE_VECTORS_V3_HW);
+}
+
 static struct scsi_host_template sht_v3_hw = {
 	.name			= DRV_NAME,
 	.module			= THIS_MODULE,
@@ -3065,6 +3043,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.slave_configure	= hisi_sas_slave_configure,
 	.scan_finished		= hisi_sas_scan_finished,
 	.scan_start		= hisi_sas_scan_start,
+	.map_queues		= hisi_sas_map_queues,
 	.change_queue_depth	= sas_change_queue_depth,
 	.bios_param		= sas_bios_param,
 	.this_id		= -1,
@@ -3078,6 +3057,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.shost_attrs		= host_attrs_v3_hw,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
 	.host_reset             = hisi_sas_host_reset,
+	.host_tagset		= 1,
 };
 
 static const struct hisi_sas_hw hisi_sas_v3_hw = {
@@ -3249,6 +3229,9 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (hisi_sas_debugfs_enable)
 		hisi_sas_debugfs_init(hisi_hba);
 
+	rc = interrupt_preinit_v3_hw(hisi_hba);
+	if (rc)
+		goto err_out_ha;
 	rc = scsi_add_host(shost, dev);
 	if (rc)
 		goto err_out_ha;
-- 
2.17.1

