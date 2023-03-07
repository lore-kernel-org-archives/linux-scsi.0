Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3047C6FD1B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 05:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCGFjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 00:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjCGFjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 00:39:15 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02893B864
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 21:39:13 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PW42V3jS7zKqJr;
        Tue,  7 Mar 2023 13:37:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 13:38:35 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 3/4] scsi: hisi_sas: Sync complete queue for poll queue
Date:   Tue, 7 Mar 2023 14:09:14 +0800
Message-ID: <1678169355-76215-4-git-send-email-chenxiang66@hisilicon.com>
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

Currently sync irq to avoid free'ing task before using task in IO
completion. After adding io_uring support, need to do similar for poll
queues.
As the process of CQ entries on poll queue are protected by spinlock
cq->lock, we can use spin_lock() + spin_unlock() on cq->lock to make sure
that CQ entries being processed are processed to completion and then the
complete queue is synced.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 77 +++++++++++++++++++++++++---------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  3 +-
 3 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index a0eed81..3a5fc36 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -660,12 +660,13 @@ extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 extern void hisi_sas_init_mem(struct hisi_hba *hisi_hba);
 extern void hisi_sas_rst_work_handler(struct work_struct *work);
 extern void hisi_sas_sync_rst_work_handler(struct work_struct *work);
-extern void hisi_sas_sync_irqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no);
 extern bool hisi_sas_notify_phy_event(struct hisi_sas_phy *phy,
 				enum hisi_sas_phy_event event);
 extern void hisi_sas_release_tasks(struct hisi_hba *hisi_hba);
 extern u8 hisi_sas_get_prog_phy_linkrate_mask(enum sas_linkrate max);
+extern void hisi_sas_sync_cqs(struct hisi_hba *hisi_hba);
+extern void hisi_sas_sync_poll_cqs(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba);
 extern void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 628cfbe..325d6d6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -683,6 +683,55 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 	return sas_dev;
 }
 
+static void hisi_sas_sync_poll_cq(struct hisi_sas_cq *cq)
+{
+	/* make sure CQ entries being processed are processed to completion */
+	spin_lock(&cq->poll_lock);
+	spin_unlock(&cq->poll_lock);
+}
+
+static bool hisi_sas_queue_is_poll(struct hisi_sas_cq *cq)
+{
+	struct hisi_hba *hisi_hba = cq->hisi_hba;
+
+	if (cq->id < hisi_hba->queue_count - hisi_hba->iopoll_q_cnt)
+		return false;
+	return true;
+}
+
+static void hisi_sas_sync_cq(struct hisi_sas_cq *cq)
+{
+	if (hisi_sas_queue_is_poll(cq))
+		hisi_sas_sync_poll_cq(cq);
+	else
+		synchronize_irq(cq->irq_no);
+}
+
+void hisi_sas_sync_poll_cqs(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+
+		if (hisi_sas_queue_is_poll(cq))
+			hisi_sas_sync_poll_cq(cq);
+	}
+}
+EXPORT_SYMBOL_GPL(hisi_sas_sync_poll_cqs);
+
+void hisi_sas_sync_cqs(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+
+		hisi_sas_sync_cq(cq);
+	}
+}
+EXPORT_SYMBOL_GPL(hisi_sas_sync_cqs);
+
 static void hisi_sas_tmf_aborted(struct sas_task *task)
 {
 	struct hisi_sas_slot *slot = task->lldd_task;
@@ -694,10 +743,10 @@ static void hisi_sas_tmf_aborted(struct sas_task *task)
 		struct hisi_sas_cq *cq =
 			   &hisi_hba->cq[slot->dlvry_queue];
 		/*
-		 * sync irq to avoid free'ing task
+		 * sync irq or poll queue to avoid free'ing task
 		 * before using task in IO completion
 		 */
-		synchronize_irq(cq->irq_no);
+		hisi_sas_sync_cq(cq);
 		slot->task = NULL;
 	}
 }
@@ -1551,11 +1600,11 @@ static int hisi_sas_abort_task(struct sas_task *task)
 
 		if (slot) {
 			/*
-			 * sync irq to avoid free'ing task
+			 * sync irq or poll queue to avoid free'ing task
 			 * before using task in IO completion
 			 */
 			cq = &hisi_hba->cq[slot->dlvry_queue];
-			synchronize_irq(cq->irq_no);
+			hisi_sas_sync_cq(cq);
 		}
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		rc = TMF_RESP_FUNC_COMPLETE;
@@ -1622,10 +1671,10 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		if (((rc < 0) || (rc == TMF_RESP_FUNC_FAILED)) &&
 					task->lldd_task) {
 			/*
-			 * sync irq to avoid free'ing task
+			 * sync irq or poll queue to avoid free'ing task
 			 * before using task in IO completion
 			 */
-			synchronize_irq(cq->irq_no);
+			hisi_sas_sync_cq(cq);
 			slot->task = NULL;
 		}
 	}
@@ -1896,10 +1945,10 @@ static bool hisi_sas_internal_abort_timeout(struct sas_task *task,
 			struct hisi_sas_cq *cq =
 				&hisi_hba->cq[slot->dlvry_queue];
 			/*
-			 * sync irq to avoid free'ing task
+			 * sync irq or poll queue to avoid free'ing task
 			 * before using task in IO completion
 			 */
-			synchronize_irq(cq->irq_no);
+			hisi_sas_sync_cq(cq);
 			slot->task = NULL;
 		}
 
@@ -2003,18 +2052,6 @@ void hisi_sas_phy_bcast(struct hisi_sas_phy *phy)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_phy_bcast);
 
-void hisi_sas_sync_irqs(struct hisi_hba *hisi_hba)
-{
-	int i;
-
-	for (i = 0; i < hisi_hba->cq_nvecs; i++) {
-		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
-
-		synchronize_irq(cq->irq_no);
-	}
-}
-EXPORT_SYMBOL_GPL(hisi_sas_sync_irqs);
-
 int hisi_sas_host_reset(struct Scsi_Host *shost, int reset_type)
 {
 	struct hisi_hba *hisi_hba = shost_priv(shost);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 24282bc..1f6c026 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2657,6 +2657,7 @@ static int disable_host_v3_hw(struct hisi_hba *hisi_hba)
 	int rc;
 
 	interrupt_disable_v3_hw(hisi_hba);
+	hisi_sas_sync_poll_cqs(hisi_hba);
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0x0);
 
 	hisi_sas_stop_phys(hisi_hba);
@@ -3069,7 +3070,7 @@ static void debugfs_snapshot_prepare_v3_hw(struct hisi_hba *hisi_hba)
 
 	wait_cmds_complete_timeout_v3_hw(hisi_hba, 100, 5000);
 
-	hisi_sas_sync_irqs(hisi_hba);
+	hisi_sas_sync_cqs(hisi_hba);
 }
 
 static void debugfs_snapshot_restore_v3_hw(struct hisi_hba *hisi_hba)
-- 
2.8.1

