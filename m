Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D6C2D249A;
	Fri, 22 Aug 2025 07:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849599; cv=none; b=G95TitsEWIYREBGNEi+zpO2gCa0WIz7Z/gVweD+U48G8+JrysK8xP1+SxTvfdAZ71XYXeKXmThdHoswlaH4Q8V+wF2sXTpj6/9P/ZPpuKll2WYWkBY/T2hKPq3itdqRUorJUzWKmAN8zV739V2ejWxLepZsbZs+YkzRkcwN4lcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849599; c=relaxed/simple;
	bh=ctM+YoZw4/ZxbDDzVBuf5gyabHtTS0tWuMfb+jMkbDk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khHa+QA46ANh2GLXM+byH2/PGHTuvy22/D/NcPkppZ7bPATbP5+XAcKZXKl7o4rL+evmq2d+UJGk4+HdibuUkI3Je4AorbE5kM0C6lCpGMBsiW2uSx9zOfXd84BH/4uv/z09R3jH1vI02EMuYPDnsVZ1Lohkl9jOTka2VsbWe7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c7Xb15W7Gz2Dc4D;
	Fri, 22 Aug 2025 15:57:01 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id D3D3E140258;
	Fri, 22 Aug 2025 15:59:52 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 15:59:52 +0800
From: Yihang Li <liyihang9@h-partners.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH 1/4] scsi: hisi_sas: Use tasklet to process CQ interrupts
Date: Fri, 22 Aug 2025 15:59:48 +0800
Message-ID: <20250822075951.2051639-2-liyihang9@h-partners.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250822075951.2051639-1-liyihang9@h-partners.com>
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemh200005.china.huawei.com (7.202.181.112)

Since commit 81f338e9709d ("scsi: hisi_sas: use threaded irq to process
CQ interrupts") hisi_sas driver has been using threaded irq to process CQ
interrupts. However, we found that when the CPU handling the interrupt
thread is occupied by other high-priority processes, the interrupt thread
will not be scheduled. This results in the response of IO commands issued
through the hisi_sas driver not being effectively processed, triggering
the timeout mechanism at the SCSI layer and leading to the SCSI error
handler being invoked.

We believe that the method of handling CQ interrupts through threaded irq
will inevitably encounter this issue, where the CPU bound to the interrupt
thread cannot be scheduled to handle other processes/threads when occupied
by high-priority processes or tasks. Therefore, we have reverted the
interrupt handling in the hisi_sas driver back to tasklet.

Signed-off-by: Yihang Li <liyihang9@h-partners.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 16 ++++++------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 36 ++++++++++++++++----------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 27 ++++++++++---------
 4 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 1323ed8aa717..493a1b2124d1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -214,9 +214,9 @@ struct hisi_sas_port {
 struct hisi_sas_cq {
 	struct hisi_hba *hisi_hba;
 	const struct cpumask *irq_mask;
+	struct tasklet_struct tasklet;
 	int	rd_point;
 	int	id;
-	int	irq_no;
 	spinlock_t poll_lock;
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 30a9c6612651..693198b7027e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -740,7 +740,7 @@ static void hisi_sas_sync_cq(struct hisi_sas_cq *cq)
 	if (hisi_sas_queue_is_poll(cq))
 		hisi_sas_sync_poll_cq(cq);
 	else
-		synchronize_irq(cq->irq_no);
+		tasklet_kill(&cq->tasklet);
 }
 
 void hisi_sas_sync_poll_cqs(struct hisi_hba *hisi_hba)
@@ -779,7 +779,7 @@ static void hisi_sas_tmf_aborted(struct sas_task *task)
 		struct hisi_sas_cq *cq =
 			   &hisi_hba->cq[slot->dlvry_queue];
 		/*
-		 * sync irq or poll queue to avoid free'ing task
+		 * flush tasklet or poll queue to avoid free'ing task
 		 * before using task in IO completion
 		 */
 		hisi_sas_sync_cq(cq);
@@ -1705,8 +1705,8 @@ static int hisi_sas_abort_task(struct sas_task *task)
 
 		if (slot) {
 			/*
-			 * sync irq or poll queue to avoid free'ing task
-			 * before using task in IO completion
+			 * flush tasklet or poll queue to avoid free'ing
+			 * task before using task in IO completion
 			 */
 			cq = &hisi_hba->cq[slot->dlvry_queue];
 			hisi_sas_sync_cq(cq);
@@ -1779,8 +1779,8 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		if (((rc < 0) || (rc == TMF_RESP_FUNC_FAILED)) &&
 					task->lldd_task) {
 			/*
-			 * sync irq or poll queue to avoid free'ing task
-			 * before using task in IO completion
+			 * flush tasklet or poll queue to avoid free'ing
+			 * task before using task in IO completion
 			 */
 			hisi_sas_sync_cq(cq);
 			slot->task = NULL;
@@ -2042,8 +2042,8 @@ static bool hisi_sas_internal_abort_timeout(struct sas_task *task,
 			struct hisi_sas_cq *cq =
 				&hisi_hba->cq[slot->dlvry_queue];
 			/*
-			 * sync irq or poll queue to avoid free'ing task
-			 * before using task in IO completion
+			 * flush tasklet or poll queue to avoid free'ing
+			 * task before using task in IO completion
 			 */
 			hisi_sas_sync_cq(cq);
 			slot->task = NULL;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f3516a0611dd..4c7d026a44a8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3110,9 +3110,9 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t cq_thread_v2_hw(int irq_no, void *p)
+static void cq_tasklet_v2_hw(unsigned long val)
 {
-	struct hisi_sas_cq *cq = p;
+	struct hisi_sas_cq *cq = (struct hisi_sas_cq *)val;
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_itct *itct;
@@ -3180,8 +3180,6 @@ static irqreturn_t cq_thread_v2_hw(int irq_no, void *p)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
-
-	return IRQ_HANDLED;
 }
 
 static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
@@ -3191,8 +3189,9 @@ static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
 	int queue = cq->id;
 
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
+	tasklet_schedule(&cq->tasklet);
 
-	return IRQ_WAKE_THREAD;
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
@@ -3373,19 +3372,20 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 
 	for (queue_no = 0; queue_no < hisi_hba->cq_nvecs; queue_no++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[queue_no];
+		struct tasklet_struct *t = &cq->tasklet;
 
-		cq->irq_no = hisi_hba->irq_map[queue_no + 96];
-		rc = devm_request_threaded_irq(dev, cq->irq_no,
-					       cq_interrupt_v2_hw,
-					       cq_thread_v2_hw, IRQF_ONESHOT,
-					       DRV_NAME " cq", cq);
+		irq = hisi_hba->irq_map[queue_no + 96];
+		rc = devm_request_irq(dev, irq, cq_interrupt_v2_hw, 0,
+				      DRV_NAME " cq", cq);
 		if (rc) {
 			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
-					cq->irq_no, rc);
+					irq, rc);
 			rc = -ENOENT;
 			goto err_out;
 		}
-		cq->irq_mask = irq_get_affinity_mask(cq->irq_no);
+
+		cq->irq_mask = irq_get_affinity_mask(irq);
+		tasklet_init(t, cq_tasklet_v2_hw, (unsigned long)cq);
 	}
 err_out:
 	return rc;
@@ -3443,6 +3443,7 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 
 	interrupt_disable_v2_hw(hisi_hba);
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0x0);
+	hisi_sas_sync_cqs(hisi_hba);
 
 	hisi_sas_stop_phys(hisi_hba);
 
@@ -3635,6 +3636,15 @@ static int hisi_sas_v2_probe(struct platform_device *pdev)
 	return hisi_sas_probe(pdev, &hisi_sas_v2_hw);
 }
 
+static void hisi_sas_v2_remove(struct platform_device *pdev)
+{
+	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
+	struct hisi_hba *hisi_hba = sha->lldd_ha;
+
+	hisi_sas_sync_cqs(hisi_hba);
+	hisi_sas_remove(pdev);
+}
+
 static const struct of_device_id sas_v2_of_match[] = {
 	{ .compatible = "hisilicon,hip06-sas-v2",},
 	{ .compatible = "hisilicon,hip07-sas-v2",},
@@ -3651,7 +3661,7 @@ MODULE_DEVICE_TABLE(acpi, sas_v2_acpi_match);
 
 static struct platform_driver hisi_sas_v2_driver = {
 	.probe = hisi_sas_v2_probe,
-	.remove = hisi_sas_remove,
+	.remove = hisi_sas_v2_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table = sas_v2_of_match,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2f9e01717ef3..2778ebe117bb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2569,13 +2569,11 @@ static int queue_complete_v3_hw(struct Scsi_Host *shost, unsigned int queue)
 	return completed;
 }
 
-static irqreturn_t cq_thread_v3_hw(int irq_no, void *p)
+static void cq_tasklet_v3_hw(unsigned long val)
 {
-	struct hisi_sas_cq *cq = p;
+	struct hisi_sas_cq *cq = (struct hisi_sas_cq *)val;
 
 	complete_v3_hw(cq);
-
-	return IRQ_HANDLED;
 }
 
 static irqreturn_t cq_interrupt_v3_hw(int irq_no, void *p)
@@ -2585,8 +2583,9 @@ static irqreturn_t cq_interrupt_v3_hw(int irq_no, void *p)
 	int queue = cq->id;
 
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
+	tasklet_schedule(&cq->tasklet);
 
-	return IRQ_WAKE_THREAD;
+	return IRQ_HANDLED;
 }
 
 static void hisi_sas_v3_free_vectors(void *data)
@@ -2657,16 +2656,13 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 
 	for (i = 0; i < hisi_hba->cq_nvecs; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+		struct tasklet_struct *t = &cq->tasklet;
 		int nr = hisi_sas_intr_conv ? BASE_VECTORS_V3_HW :
 					      BASE_VECTORS_V3_HW + i;
-		unsigned long irqflags = hisi_sas_intr_conv ? IRQF_SHARED :
-							      IRQF_ONESHOT;
-
-		cq->irq_no = pci_irq_vector(pdev, nr);
-		rc = devm_request_threaded_irq(dev, cq->irq_no,
-				      cq_interrupt_v3_hw,
-				      cq_thread_v3_hw,
-				      irqflags,
+		unsigned long irqflags = hisi_sas_intr_conv ? IRQF_SHARED : 0;
+
+		rc = devm_request_irq(dev, pci_irq_vector(pdev, nr),
+				      cq_interrupt_v3_hw, irqflags,
 				      DRV_NAME " cq", cq);
 		if (rc) {
 			dev_err(dev, "could not request cq%d interrupt, rc=%d\n",
@@ -2678,6 +2674,8 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			dev_err(dev, "could not get cq%d irq affinity!\n", i);
 			return -ENOENT;
 		}
+
+		tasklet_init(t, cq_tasklet_v3_hw, (unsigned long)cq);
 	}
 
 	return 0;
@@ -2750,8 +2748,8 @@ static int disable_host_v3_hw(struct hisi_hba *hisi_hba)
 	u32 status, reg_val;
 	int rc;
 
-	hisi_sas_sync_poll_cqs(hisi_hba);
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0x0);
+	hisi_sas_sync_cqs(hisi_hba);
 
 	hisi_sas_stop_phys(hisi_hba);
 
@@ -5100,6 +5098,7 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	sas_remove_host(shost);
 
 	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
+	hisi_sas_sync_cqs(hisi_hba);
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
 }
-- 
2.33.0

