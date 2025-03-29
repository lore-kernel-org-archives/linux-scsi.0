Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3C7487BE;
	Sat, 29 Mar 2025 07:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743233564; cv=none; b=ulBQ3JRdPCpmi33fQrLeflHSOnzkiXKkCsVhIWWosNnStyQYql2QWJLfQuNmTz6uOZvvhvC3QC0TAPoeHe6p3d5knWnogclBi3iKJzFs5C1DsHUp0eecB3EdNvdVIgMplGaK0zjtO1TKG70XoYQjE4IkQCDDufmcmCmjoHvf5vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743233564; c=relaxed/simple;
	bh=BhZftnQ1wswi/4j8ZPgQfJ4TchpivtJRWgTHyO3MqPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RbiXyS3UU+qSgz4+PydZ6xT6NNMM4elbwKezbyJDmJrB0tqzq9KdwKNv1u0MJzFFZy1bIj+iw0Q2gtpQB/AXS0Yp1MKRZAMue5TREoSoUVAlqqpNjc0A8SblgmID6wk6KeVCtNvq+LknEIGrnb9SoTRcmB8ufKixca9IkF8cFpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4ZPptQ2ZcYzHrF0;
	Sat, 29 Mar 2025 15:29:18 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id DA2E614033B;
	Sat, 29 Mar 2025 15:32:36 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Mar 2025 15:32:36 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH 1/5] scsi: hisi_sas: Add host_tagset_enable module param for v3 hw
Date: Sat, 29 Mar 2025 15:32:32 +0800
Message-ID: <20250329073236.2300582-2-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250329073236.2300582-1-liyihang9@huawei.com>
References: <20250329073236.2300582-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf100013.china.huawei.com (7.185.36.179)

From: Xingui Yang <yangxingui@huawei.com>

After driver exposes all HW queues and application submits IO to multiple
queues in parallel, if NCQ and non-NCQ commands are mixed to sata disk,
ata_qc_defer() causes non-NCQ commands to be requeued and possibly repeated
forever. Add host_tagset_enable module parameter to expose multiple queues
for v3 hw.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 10 +++++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 30 ++++++++++++++++++++++++--
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index e17f5d8226bf..f93eefe68ccb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -456,6 +456,7 @@ struct hisi_hba {
 	u32 intr_coal_count;	/* Interrupt count to coalesce */
 
 	int cq_nvecs;
+	unsigned int *reply_map;
 
 	/* bist */
 	enum sas_linkrate debugfs_bist_linkrate;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7a484ad0f9ab..3d2e8ec7f110 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -489,11 +489,12 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	struct asd_sas_port *sas_port = device->port;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	bool internal_abort = sas_is_internal_abort(task);
+	struct request *rq = sas_task_find_rq(task);
 	struct hisi_sas_dq *dq = NULL;
 	struct hisi_sas_port *port;
 	struct hisi_hba *hisi_hba;
 	struct hisi_sas_slot *slot;
-	struct request *rq = NULL;
+	unsigned int dq_index;
 	struct device *dev;
 	int rc;
 
@@ -548,9 +549,10 @@ static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
 				return -ECOMM;
 		}
 
-		rq = sas_task_find_rq(task);
-		if (rq) {
-			unsigned int dq_index;
+		if (hisi_hba->reply_map) {
+			dq_index = hisi_hba->reply_map[raw_smp_processor_id()];
+			dq = &hisi_hba->dq[dq_index];
+		} else if (rq) {
 			u32 blk_tag;
 
 			blk_tag = blk_mq_unique_tag(rq);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 6a0656f3b596..a1f0a59a8c8d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -561,7 +561,12 @@ MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=0x0 ");
 /* the index of iopoll queues are bigger than interrupt queues' */
 static int experimental_iopoll_q_cnt;
 module_param(experimental_iopoll_q_cnt, int, 0444);
-MODULE_PARM_DESC(experimental_iopoll_q_cnt, "number of queues to be used as poll mode, def=0");
+MODULE_PARM_DESC(experimental_iopoll_q_cnt, "number of queues to be used as poll mode, def=0 &\n\t\t"
+		"this parameter is effective only if host_tagset_enable=1");
+
+static bool host_tagset_enable = true;
+module_param(host_tagset_enable, bool, 0444);
+MODULE_PARM_DESC(host_tagset_enable, "shared host tagset enable (0-1), def=1");
 
 static int debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba);
 
@@ -2574,6 +2579,18 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs + hisi_hba->iopoll_q_cnt;
 
+	if (!host_tagset_enable) {
+		shost->host_tagset = 0;
+		shost->nr_hw_queues = 1;
+		hisi_hba->reply_map = devm_kcalloc(&pdev->dev, nr_cpu_ids,
+				sizeof(unsigned int),
+				GFP_KERNEL);
+		if (!hisi_hba->reply_map) {
+			hisi_sas_v3_free_vectors(hisi_hba);
+			return -ENOMEM;
+		}
+	}
+
 	return devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 }
 
@@ -2615,6 +2632,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 		int nr = hisi_sas_intr_conv ? 16 : 16 + i;
 		unsigned long irqflags = hisi_sas_intr_conv ? IRQF_SHARED :
 							      IRQF_ONESHOT;
+		int cpu;
 
 		cq->irq_no = pci_irq_vector(pdev, nr);
 		rc = devm_request_threaded_irq(dev, cq->irq_no,
@@ -2632,6 +2650,9 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			dev_err(dev, "could not get cq%d irq affinity!\n", i);
 			return -ENOENT;
 		}
+		if (!host_tagset_enable)
+			for_each_cpu(cpu, cq->irq_mask)
+				hisi_hba->reply_map[cpu] = i;
 	}
 
 	return 0;
@@ -3318,6 +3339,9 @@ static void hisi_sas_map_queues(struct Scsi_Host *shost)
 	struct blk_mq_queue_map *qmap;
 	int i, qoff;
 
+	if (shost->nr_hw_queues == 1)
+		return;
+
 	for (i = 0, qoff = 0; i < shost->nr_maps; i++) {
 		qmap = &shost->tag_set.map[i];
 		if (i == HCTX_TYPE_DEFAULT) {
@@ -3435,7 +3459,9 @@ hisi_sas_shost_alloc_pci(struct pci_dev *pdev)
 	if (check_fw_info_v3_hw(hisi_hba) < 0)
 		goto err_out;
 
-	if (experimental_iopoll_q_cnt < 0 ||
+	if (!host_tagset_enable)
+		dev_info(dev, "Shared host tag set disabled, iopoll queue cnt uses default 0\n");
+	else if (experimental_iopoll_q_cnt < 0 ||
 		experimental_iopoll_q_cnt >= hisi_hba->queue_count)
 		dev_err(dev, "iopoll queue count %d cannot exceed or equal 16, using default 0\n",
 			experimental_iopoll_q_cnt);
-- 
2.33.0

