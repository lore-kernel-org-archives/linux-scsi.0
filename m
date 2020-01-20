Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD99C33CB8
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64726217F4
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgATM06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 07:26:58 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9220 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728863AbgATM06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 07:26:58 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D057F3807D1B9FD2D331;
        Mon, 20 Jan 2020 20:26:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 20:26:43 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 1/7] scsi: hisi_sas: use threaded irq to process CQ interrupts
Date:   Mon, 20 Jan 2020 20:22:31 +0800
Message-ID: <1579522957-4393-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1579522957-4393-1-git-send-email-john.garry@huawei.com>
References: <1579522957-4393-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently IRQ_EFFECTIVE_AFF_MASK is enabled for ARM_GIC and ARM_GIC3,
so it only allows a single target CPU in the affinity mask to process
interrupts and also interrupt thread, and the performance of using
threaded irq is almost the same as tasklet. But if the config is not
enabled, the interrupt thread will be allowed all the CPUs in the
affinity mask. At that situation it promotes much on the performance
(about 20%).

Note: IRQ_EFFECTIVE_AFF_MASK is configured differently for different
architecture chip, and it seems to be better to make it be configured
easily.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 22 +++++++++----------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 26 +++++++++-------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 30 ++++++++++++--------------
 4 files changed, 37 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 233c73e01246..838549b19f86 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -181,9 +181,9 @@ struct hisi_sas_port {
 struct hisi_sas_cq {
 	struct hisi_hba *hisi_hba;
 	const struct cpumask *pci_irq_mask;
-	struct tasklet_struct tasklet;
 	int	rd_point;
 	int	id;
+	int	irq_no;
 };
 
 struct hisi_sas_dq {
@@ -627,7 +627,7 @@ extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 extern void hisi_sas_init_mem(struct hisi_hba *hisi_hba);
 extern void hisi_sas_rst_work_handler(struct work_struct *work);
 extern void hisi_sas_sync_rst_work_handler(struct work_struct *work);
-extern void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba);
+extern void hisi_sas_sync_irqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no);
 extern bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
 				enum hisi_sas_phy_event event);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 03588ec3c394..c653cce2644a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1233,10 +1233,10 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 					struct hisi_sas_cq *cq =
 					       &hisi_hba->cq[slot->dlvry_queue];
 					/*
-					 * flush tasklet to avoid free'ing task
+					 * sync irq to avoid free'ing task
 					 * before using task in IO completion
 					 */
-					tasklet_kill(&cq->tasklet);
+					synchronize_irq(cq->irq_no);
 					slot->task = NULL;
 				}
 
@@ -1626,11 +1626,11 @@ static int hisi_sas_abort_task(struct sas_task *task)
 
 		if (slot) {
 			/*
-			 * flush tasklet to avoid free'ing task
+			 * sync irq to avoid free'ing task
 			 * before using task in IO completion
 			 */
 			cq = &hisi_hba->cq[slot->dlvry_queue];
-			tasklet_kill(&cq->tasklet);
+			synchronize_irq(cq->irq_no);
 		}
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		rc = TMF_RESP_FUNC_COMPLETE;
@@ -1694,10 +1694,10 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		if (((rc < 0) || (rc == TMF_RESP_FUNC_FAILED)) &&
 					task->lldd_task) {
 			/*
-			 * flush tasklet to avoid free'ing task
+			 * sync irq to avoid free'ing task
 			 * before using task in IO completion
 			 */
-			tasklet_kill(&cq->tasklet);
+			synchronize_irq(cq->irq_no);
 			slot->task = NULL;
 		}
 	}
@@ -2076,10 +2076,10 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 				struct hisi_sas_cq *cq =
 					&hisi_hba->cq[slot->dlvry_queue];
 				/*
-				 * flush tasklet to avoid free'ing task
+				 * sync irq to avoid free'ing task
 				 * before using task in IO completion
 				 */
-				tasklet_kill(&cq->tasklet);
+				synchronize_irq(cq->irq_no);
 				slot->task = NULL;
 			}
 			dev_err(dev, "internal task abort: timeout and not done.\n");
@@ -2225,17 +2225,17 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_phy_down);
 
-void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba)
+void hisi_sas_sync_irqs(struct hisi_hba *hisi_hba)
 {
 	int i;
 
 	for (i = 0; i < hisi_hba->cq_nvecs; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
 
-		tasklet_kill(&cq->tasklet);
+		synchronize_irq(cq->irq_no);
 	}
 }
-EXPORT_SYMBOL_GPL(hisi_sas_kill_tasklets);
+EXPORT_SYMBOL_GPL(hisi_sas_sync_irqs);
 
 int hisi_sas_host_reset(struct Scsi_Host *shost, int reset_type)
 {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 545eaff5f3ee..a0e05a118f2c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3111,9 +3111,9 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
-static void cq_tasklet_v2_hw(unsigned long val)
+static irqreturn_t  cq_thread_v2_hw(int irq_no, void *p)
 {
-	struct hisi_sas_cq *cq = (struct hisi_sas_cq *)val;
+	struct hisi_sas_cq *cq = p;
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_itct *itct;
@@ -3181,6 +3181,8 @@ static void cq_tasklet_v2_hw(unsigned long val)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
@@ -3191,9 +3193,7 @@ static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
 
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
 
-	tasklet_schedule(&cq->tasklet);
-
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
 }
 
 static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
@@ -3360,18 +3360,18 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 
 	for (queue_no = 0; queue_no < hisi_hba->queue_count; queue_no++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[queue_no];
-		struct tasklet_struct *t = &cq->tasklet;
 
-		irq = irq_map[queue_no + 96];
-		rc = devm_request_irq(dev, irq, cq_interrupt_v2_hw, 0,
-				      DRV_NAME " cq", cq);
+		cq->irq_no = irq_map[queue_no + 96];
+		rc = devm_request_threaded_irq(dev, cq->irq_no,
+					       cq_interrupt_v2_hw,
+					       cq_thread_v2_hw, IRQF_ONESHOT,
+					       DRV_NAME " cq", cq);
 		if (rc) {
 			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
 				irq, rc);
 			rc = -ENOENT;
 			goto err_out;
 		}
-		tasklet_init(t, cq_tasklet_v2_hw, (unsigned long)cq);
 	}
 
 	hisi_hba->cq_nvecs = hisi_hba->queue_count;
@@ -3432,7 +3432,6 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 
 	interrupt_disable_v2_hw(hisi_hba);
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0x0);
-	hisi_sas_kill_tasklets(hisi_hba);
 
 	hisi_sas_stop_phys(hisi_hba);
 
@@ -3606,11 +3605,6 @@ static int hisi_sas_v2_probe(struct platform_device *pdev)
 
 static int hisi_sas_v2_remove(struct platform_device *pdev)
 {
-	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
-	struct hisi_hba *hisi_hba = sha->lldd_ha;
-
-	hisi_sas_kill_tasklets(hisi_hba);
-
 	return hisi_sas_remove(pdev);
 }
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index fa05e612d85a..34a3781a2a85 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2299,9 +2299,9 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	return sts;
 }
 
-static void cq_tasklet_v3_hw(unsigned long val)
+static irqreturn_t  cq_thread_v3_hw(int irq_no, void *p)
 {
-	struct hisi_sas_cq *cq = (struct hisi_sas_cq *)val;
+	struct hisi_sas_cq *cq = p;
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
 	struct hisi_sas_slot *slot;
 	struct hisi_sas_complete_v3_hdr *complete_queue;
@@ -2338,6 +2338,8 @@ static void cq_tasklet_v3_hw(unsigned long val)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t cq_interrupt_v3_hw(int irq_no, void *p)
@@ -2348,9 +2350,7 @@ static irqreturn_t cq_interrupt_v3_hw(int irq_no, void *p)
 
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
 
-	tasklet_schedule(&cq->tasklet);
-
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
 }
 
 static void setup_reply_map_v3_hw(struct hisi_hba *hisi_hba, int nvecs)
@@ -2441,15 +2441,17 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 		goto free_irq_vectors;
 	}
 
-	/* Init tasklets for cq only */
 	for (i = 0; i < hisi_hba->cq_nvecs; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
-		struct tasklet_struct *t = &cq->tasklet;
 		int nr = hisi_sas_intr_conv ? 16 : 16 + i;
-		unsigned long irqflags = hisi_sas_intr_conv ? IRQF_SHARED : 0;
-
-		rc = devm_request_irq(dev, pci_irq_vector(pdev, nr),
-				      cq_interrupt_v3_hw, irqflags,
+		unsigned long irqflags = hisi_sas_intr_conv ? IRQF_SHARED :
+							      IRQF_ONESHOT;
+
+		cq->irq_no = pci_irq_vector(pdev, nr);
+		rc = devm_request_threaded_irq(dev, cq->irq_no,
+				      cq_interrupt_v3_hw,
+				      cq_thread_v3_hw,
+				      irqflags,
 				      DRV_NAME " cq", cq);
 		if (rc) {
 			dev_err(dev, "could not request cq%d interrupt, rc=%d\n",
@@ -2457,8 +2459,6 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto free_irq_vectors;
 		}
-
-		tasklet_init(t, cq_tasklet_v3_hw, (unsigned long)cq);
 	}
 
 	return 0;
@@ -2534,7 +2534,6 @@ static int disable_host_v3_hw(struct hisi_hba *hisi_hba)
 
 	interrupt_disable_v3_hw(hisi_hba);
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0x0);
-	hisi_sas_kill_tasklets(hisi_hba);
 
 	hisi_sas_stop_phys(hisi_hba);
 
@@ -2910,7 +2909,7 @@ static void debugfs_snapshot_prepare_v3_hw(struct hisi_hba *hisi_hba)
 
 	wait_cmds_complete_timeout_v3_hw(hisi_hba, 100, 5000);
 
-	hisi_sas_kill_tasklets(hisi_hba);
+	hisi_sas_sync_irqs(hisi_hba);
 }
 
 static void debugfs_snapshot_restore_v3_hw(struct hisi_hba *hisi_hba)
@@ -3312,7 +3311,6 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	sas_remove_host(sha->core.shost);
 
 	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
-	hisi_sas_kill_tasklets(hisi_hba);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	hisi_sas_free(hisi_hba);
-- 
2.17.1

