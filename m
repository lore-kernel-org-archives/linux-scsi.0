From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 48/48] hpsa: Use local workqueues instead of system
 workqueues
Date: Fri, 23 Jan 2015 16:45:17 -0600
Message-ID: <20150123224517.14919.28023.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:35918 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbAWWqL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:46:11 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Suggested-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
Reviewed-by: Kevin Barnett <Kevin.Barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   68 +++++++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/hpsa.h |    2 ++
 2 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 15ef65c..95d581c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6787,14 +6787,14 @@ static int hpsa_offline_devices_ready(struct ctlr_info *h)
 	return 0;
 }
 
-
-static void hpsa_monitor_ctlr_worker(struct work_struct *work)
+static void hpsa_rescan_ctlr_worker(struct work_struct *work)
 {
 	unsigned long flags;
 	struct ctlr_info *h = container_of(to_delayed_work(work),
-					struct ctlr_info, monitor_ctlr_work);
-	detect_controller_lockup(h);
-	if (lockup_detected(h))
+					struct ctlr_info, rescan_ctlr_work);
+
+
+	if (h->remove_in_progress)
 		return;
 
 	if (hpsa_ctlr_needs_rescan(h) || hpsa_offline_devices_ready(h)) {
@@ -6803,17 +6803,44 @@ static void hpsa_monitor_ctlr_worker(struct work_struct *work)
 		hpsa_scan_start(h->scsi_host);
 		scsi_host_put(h->scsi_host);
 	}
-
 	spin_lock_irqsave(&h->lock, flags);
-	if (h->remove_in_progress) {
-		spin_unlock_irqrestore(&h->lock, flags);
+	if (!h->remove_in_progress)
+		queue_delayed_work(h->rescan_ctlr_wq, &h->rescan_ctlr_work,
+				h->heartbeat_sample_interval);
+	spin_unlock_irqrestore(&h->lock, flags);
+}
+
+static void hpsa_monitor_ctlr_worker(struct work_struct *work)
+{
+	unsigned long flags;
+	struct ctlr_info *h = container_of(to_delayed_work(work),
+					struct ctlr_info, monitor_ctlr_work);
+
+	detect_controller_lockup(h);
+	if (lockup_detected(h))
 		return;
-	}
-	schedule_delayed_work(&h->monitor_ctlr_work,
+
+	spin_lock_irqsave(&h->lock, flags);
+	if (!h->remove_in_progress)
+		schedule_delayed_work(&h->monitor_ctlr_work,
 				h->heartbeat_sample_interval);
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
+static struct workqueue_struct *hpsa_create_controller_wq(struct ctlr_info *h,
+						char *name)
+{
+	struct workqueue_struct *wq = NULL;
+	char wq_name[20];
+
+	snprintf(wq_name, sizeof(wq_name), "%s_%d_hpsa", name, h->ctlr);
+	wq = alloc_ordered_workqueue(wq_name, 0);
+	if (!wq)
+		dev_err(&h->pdev->dev, "failed to create %s workqueue\n", name);
+
+	return wq;
+}
+
 static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int dac, rc;
@@ -6856,12 +6883,18 @@ reinit_after_soft_reset:
 	spin_lock_init(&h->scan_lock);
 	atomic_set(&h->passthru_cmds_avail, HPSA_MAX_CONCURRENT_PASSTHRUS);
 
-	h->resubmit_wq = alloc_workqueue("hpsa", WQ_MEM_RECLAIM, 0);
+	h->rescan_ctlr_wq = hpsa_create_controller_wq(h, "rescan");
+	if (!h->rescan_ctlr_wq) {
+		rc = -ENOMEM;
+		goto clean1;
+	}
+
+	h->resubmit_wq = hpsa_create_controller_wq(h, "resubmit");
 	if (!h->resubmit_wq) {
-		dev_err(&h->pdev->dev, "Failed to allocate work queue\n");
 		rc = -ENOMEM;
 		goto clean1;
 	}
+
 	/* Allocate and clear per-cpu variable lockup_detected */
 	h->lockup_detected = alloc_percpu(u32);
 	if (!h->lockup_detected) {
@@ -6985,6 +7018,9 @@ reinit_after_soft_reset:
 	INIT_DELAYED_WORK(&h->monitor_ctlr_work, hpsa_monitor_ctlr_worker);
 	schedule_delayed_work(&h->monitor_ctlr_work,
 				h->heartbeat_sample_interval);
+	INIT_DELAYED_WORK(&h->rescan_ctlr_work, hpsa_rescan_ctlr_worker);
+	queue_delayed_work(h->rescan_ctlr_wq, &h->rescan_ctlr_work,
+				h->heartbeat_sample_interval);
 	return 0;
 
 clean4:
@@ -6996,6 +7032,8 @@ clean2:
 clean1:
 	if (h->resubmit_wq)
 		destroy_workqueue(h->resubmit_wq);
+	if (h->rescan_ctlr_wq)
+		destroy_workqueue(h->rescan_ctlr_wq);
 	if (h->lockup_detected)
 		free_percpu(h->lockup_detected);
 	kfree(h);
@@ -7069,11 +7107,13 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	/* Get rid of any controller monitoring work items */
 	spin_lock_irqsave(&h->lock, flags);
 	h->remove_in_progress = 1;
-	cancel_delayed_work(&h->monitor_ctlr_work);
 	spin_unlock_irqrestore(&h->lock, flags);
+	cancel_delayed_work_sync(&h->monitor_ctlr_work);
+	cancel_delayed_work_sync(&h->rescan_ctlr_work);
+	destroy_workqueue(h->rescan_ctlr_wq);
+	destroy_workqueue(h->resubmit_wq);
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 	hpsa_shutdown(pdev);
-	destroy_workqueue(h->resubmit_wq);
 	iounmap(h->vaddr);
 	iounmap(h->transtable);
 	iounmap(h->cfgtable);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 62c50c3..6577130 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -207,6 +207,7 @@ struct ctlr_info {
 	atomic_t firmware_flash_in_progress;
 	u32 __percpu *lockup_detected;
 	struct delayed_work monitor_ctlr_work;
+	struct delayed_work rescan_ctlr_work;
 	int remove_in_progress;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
 	u8 q[MAX_REPLY_QUEUES];
@@ -251,6 +252,7 @@ struct ctlr_info {
 	int	acciopath_status;
 	int	raid_offload_debug;
 	struct workqueue_struct *resubmit_wq;
+	struct workqueue_struct *rescan_ctlr_wq;
 };
 
 struct offline_device_entry {

