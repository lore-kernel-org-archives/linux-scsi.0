Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40864CA9EBB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C2521A4A
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502805AbfJXOZD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:25:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:32906 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409403AbfJXOYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:24:55 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 55BE0C3025B729EED883;
        Thu, 24 Oct 2019 22:24:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:24:41 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <hare@suse.com>,
        <ming.lei@redhat.com>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH 6/6] scsi: hisi_sas: Expose multiple hw queues for v3 as experimental
Date:   Thu, 24 Oct 2019 22:21:21 +0800
Message-ID: <1571926881-75524-7-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
References: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since we're not ready to expose mutliple queues to the upper layer always
due to CPU hotplug issue, add a new interim experimental command line
option to support it.

We still need to keep supporting auto_affine_msi_experimental, since
people are now replying the performance it provides, even though it is
unsafe.

If auto_affine_msi_experimental and expose_mq_experimental are both set,
then auto_affine_msi_experimental takes preference.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 55 ++++++++++++++++----------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 51 +++++++++++++++++++++---
 3 files changed, 83 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 4eb8f1c53f78..884f2426d753 100644
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
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 53802c1cc1d0..c8c96a46acfd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -389,9 +389,11 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_cmd_hdr	*cmd_hdr_base;
 	struct asd_sas_port *sas_port = device->port;
+	struct Scsi_Host *shost = hisi_hba->shost;
 	struct device *dev = hisi_hba->dev;
 	int dlvry_queue_slot, dlvry_queue, rc, slot_idx;
 	int n_elem = 0, n_elem_dif = 0, n_elem_req = 0;
+	struct scsi_cmnd *scmd = NULL;
 	struct hisi_sas_dq *dq;
 	unsigned long flags;
 	int wr_q_index;
@@ -407,13 +409,38 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		return -ECOMM;
 	}
 
-	if (hisi_hba->reply_map) {
-		int cpu = raw_smp_processor_id();
-		unsigned int dq_index = hisi_hba->reply_map[cpu];
+	if (task->uldd_task) {
+		struct ata_queued_cmd *qc;
 
-		*dq_pointer = dq = &hisi_hba->dq[dq_index];
-	} else {
+		if (dev_is_sata(device)) {
+			qc = task->uldd_task;
+			scmd = qc->scsicmd;
+		} else {
+			scmd = task->uldd_task;
+		}
+	}
+
+	/* We have to move to just a single mode: expose multiple queues */
+	if (!hisi_hba->reply_map && !shost->nr_hw_queues) {
 		*dq_pointer = dq = sas_dev->dq;
+	} else {
+		if (hisi_hba->reply_map) {
+			int cpu = raw_smp_processor_id();
+			unsigned int dq_index = hisi_hba->reply_map[cpu];
+
+			*dq_pointer = dq = &hisi_hba->dq[dq_index];
+		} else {
+			if (scmd) {
+				unsigned int dq_index;
+				u32 blk_tag;
+
+				blk_tag = blk_mq_unique_tag(scmd->request);
+				dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
+				*dq_pointer = dq = &hisi_hba->dq[dq_index];
+			} else {
+				*dq_pointer = dq = sas_dev->dq;
+			}
+		}
 	}
 
 	port = to_hisi_sas_port(sas_port);
@@ -438,22 +465,10 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	}
 
 	if (hisi_hba->hw->slot_index_alloc)
-		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device, NULL);
-	else {
-		struct scsi_cmnd *scsi_cmnd = NULL;
-
-		if (task->uldd_task) {
-			struct ata_queued_cmd *qc;
+		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device, scmd);
+	else
+		rc = hisi_sas_slot_index_alloc(hisi_hba, scmd);
 
-			if (dev_is_sata(device)) {
-				qc = task->uldd_task;
-				scsi_cmnd = qc->scsicmd;
-			} else {
-				scsi_cmnd = task->uldd_task;
-			}
-		}
-		rc = hisi_sas_slot_index_alloc(hisi_hba, scsi_cmnd);
-	}
 	if (rc < 0)
 		goto err_out_dif_dma_unmap;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 29119d0b27a7..03ba0416f910 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -512,6 +512,11 @@ module_param(auto_affine_msi_experimental, bool, 0444);
 MODULE_PARM_DESC(auto_affine_msi_experimental, "Enable auto-affinity of MSI IRQs as experimental:\n"
 		 "default is off");
 
+static bool expose_mq_experimental;
+module_param(expose_mq_experimental, bool, 0444);
+MODULE_PARM_DESC(expose_mq_experimental, "Expose multiple hw queues to upper layer as experimental:\n"
+		 "default is off");
+
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 {
 	void __iomem *regs = hisi_hba->regs + off;
@@ -558,6 +563,11 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
 
 static int bitmaps_alloc_v3_hw(struct hisi_hba *hisi_hba)
 {
+	if (expose_mq_experimental)
+		return sbitmap_init_node(&hisi_hba->slot_index_tags,
+					 HISI_SAS_MAX_COMMANDS, -1,
+					 GFP_KERNEL,
+					 dev_to_node(hisi_hba->dev));
 	return sbitmap_init_node(&hisi_hba->slot_index_tags,
 				 HISI_SAS_UNRESERVED_IPTT, -1,
 				 GFP_KERNEL, dev_to_node(hisi_hba->dev));
@@ -570,6 +580,10 @@ static int slot_index_alloc_v3_hw(struct hisi_hba *hisi_hba,
 	struct sbitmap *slot_index_tags = &hisi_hba->slot_index_tags;
 	int index;
 
+	if (expose_mq_experimental)
+		return sbitmap_get(slot_index_tags,
+				   hisi_hba->sbitmap_alloc_hint, false);
+
 	if (scmd)
 		return scmd->request->tag;
 
@@ -583,7 +597,10 @@ static void slot_index_free_v3_hw(struct hisi_hba *hisi_hba, int slot_idx)
 {
 	struct sbitmap *slot_index_tags = &hisi_hba->slot_index_tags;
 
-	if (slot_idx >= HISI_SAS_UNRESERVED_IPTT)
+	if (expose_mq_experimental) {
+		sbitmap_clear_bit(slot_index_tags, slot_idx);
+		hisi_hba->sbitmap_alloc_hint = slot_idx;
+	} else if (slot_idx >= HISI_SAS_UNRESERVED_IPTT)
 		sbitmap_clear_bit(slot_index_tags,
 				  slot_idx - HISI_SAS_UNRESERVED_IPTT);
 }
@@ -2414,8 +2431,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	struct device *dev = hisi_hba->dev;
 	int vectors;
 	int max_msi = HISI_SAS_MSI_COUNT_V3_HW, min_msi;
+	struct Scsi_Host *shost = hisi_hba->shost;
 
-	if (auto_affine_msi_experimental) {
+	if (auto_affine_msi_experimental || expose_mq_experimental) {
 		struct irq_affinity desc = {
 			.pre_vectors = BASE_VECTORS_V3_HW,
 		};
@@ -2434,7 +2452,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 							 &desc);
 		if (vectors < 0)
 			return -ENOENT;
-		setup_reply_map_v3_hw(hisi_hba, vectors - BASE_VECTORS_V3_HW);
+		if (auto_affine_msi_experimental)
+			setup_reply_map_v3_hw(hisi_hba,
+					      vectors - BASE_VECTORS_V3_HW);
 	} else {
 		min_msi = max_msi;
 		vectors = pci_alloc_irq_vectors(hisi_hba->pci_dev, min_msi,
@@ -2444,6 +2464,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	}
 
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
+	if (expose_mq_experimental)
+		shost->nr_hw_queues = hisi_hba->cq_nvecs;
+
 	return 0;
 }
 
@@ -3096,6 +3119,17 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 	return 0;
 }
 
+static int hisi_sas_map_queues(struct Scsi_Host *shost)
+{
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+
+	if (expose_mq_experimental)
+		return blk_mq_pci_map_queues(qmap, hisi_hba->pci_dev,
+					     BASE_VECTORS_V3_HW);
+	return blk_mq_map_queues(qmap);
+}
+
 static struct scsi_host_template sht_v3_hw = {
 	.name			= DRV_NAME,
 	.module			= THIS_MODULE,
@@ -3104,6 +3138,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.slave_configure	= hisi_sas_slave_configure,
 	.scan_finished		= hisi_sas_scan_finished,
 	.scan_start		= hisi_sas_scan_start,
+	.map_queues		= hisi_sas_map_queues,
 	.change_queue_depth	= sas_change_queue_depth,
 	.bios_param		= sas_bios_param,
 	.this_id		= -1,
@@ -3265,8 +3300,14 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_lun = ~0;
 	shost->max_channel = 1;
 	shost->max_cmd_len = 16;
-	shost->can_queue = HISI_SAS_UNRESERVED_IPTT;
-	shost->cmd_per_lun = HISI_SAS_UNRESERVED_IPTT;
+
+	if (expose_mq_experimental) {
+		shost->can_queue = HISI_SAS_MAX_COMMANDS;
+		shost->cmd_per_lun = HISI_SAS_MAX_COMMANDS;
+	} else {
+		shost->can_queue = HISI_SAS_UNRESERVED_IPTT;
+		shost->cmd_per_lun = HISI_SAS_UNRESERVED_IPTT;
+	}
 
 	sha->sas_ha_name = DRV_NAME;
 	sha->dev = dev;
-- 
2.17.1

