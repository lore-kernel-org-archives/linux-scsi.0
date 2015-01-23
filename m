From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/2] hpsa: use a driver's own workqueue instead of a shared wq
Date: Fri, 23 Jan 2015 17:16:25 +0100
Message-ID: <1422029786-15046-2-git-send-email-thenzl@redhat.com>
References: <1422029786-15046-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbbAWQQb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 11:16:31 -0500
In-Reply-To: <1422029786-15046-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, Justin.Lindley@pmcs.com

hpsa driver uses a shared wq, max sleep time in function spent
hpsa_wait_for_clear_event_notify_ack may take up to 20sec
and that is too much for a shared workqueue.
This patch takes the easiest approach and just creates a
driver's own workqueue.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 39 +++++++++++++++++++++++++--------------
 drivers/scsi/hpsa.h |  1 +
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 15ef65c25d..909562c09f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6229,6 +6229,12 @@ static int hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 			goto done;
 		/* delay and try again */
 		msleep(MODE_CHANGE_WAIT_INTERVAL);
+
+	/* we allow a timeout under certain conditions,
+	 * so we may return here when a removal is in progress
+	 */
+		if (h->remove_in_progress)
+			return -ENODEV;
 	}
 	return -ENODEV;
 done:
@@ -6790,7 +6796,6 @@ static int hpsa_offline_devices_ready(struct ctlr_info *h)
 
 static void hpsa_monitor_ctlr_worker(struct work_struct *work)
 {
-	unsigned long flags;
 	struct ctlr_info *h = container_of(to_delayed_work(work),
 					struct ctlr_info, monitor_ctlr_work);
 	detect_controller_lockup(h);
@@ -6804,14 +6809,10 @@ static void hpsa_monitor_ctlr_worker(struct work_struct *work)
 		scsi_host_put(h->scsi_host);
 	}
 
-	spin_lock_irqsave(&h->lock, flags);
-	if (h->remove_in_progress) {
-		spin_unlock_irqrestore(&h->lock, flags);
+	if (h->remove_in_progress)
 		return;
-	}
-	schedule_delayed_work(&h->monitor_ctlr_work,
-				h->heartbeat_sample_interval);
-	spin_unlock_irqrestore(&h->lock, flags);
+	queue_delayed_work(h->monitor_ctrl_wq, &h->monitor_ctlr_work,
+		h->heartbeat_sample_interval);
 }
 
 static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
@@ -6820,6 +6821,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ctlr_info *h;
 	int try_soft_reset = 0;
 	unsigned long flags;
+	char wq_name[20];
 
 	if (number_of_controllers == 0)
 		printk(KERN_INFO DRIVER_NAME "\n");
@@ -6983,10 +6985,20 @@ reinit_after_soft_reset:
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
 	INIT_DELAYED_WORK(&h->monitor_ctlr_work, hpsa_monitor_ctlr_worker);
-	schedule_delayed_work(&h->monitor_ctlr_work,
-				h->heartbeat_sample_interval);
+	snprintf(wq_name, sizeof(wq_name), "monitor_%d_hpsa", h->ctlr);
+	h->monitor_ctrl_wq = alloc_ordered_workqueue(wq_name, 0);
+	if (!h->monitor_ctrl_wq) {
+		dev_err(&pdev->dev, "failed to create monitor workqueue\n");
+		goto clean5;
+	}
+	queue_delayed_work(h->monitor_ctrl_wq, &h->monitor_ctlr_work,
+		h->heartbeat_sample_interval);
 	return 0;
 
+clean5:
+	hpsa_unregister_scsi(h);
+	kfree(h->hba_inquiry_data);
+	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 clean4:
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
@@ -7058,7 +7070,6 @@ static void hpsa_free_device_info(struct ctlr_info *h)
 static void hpsa_remove_one(struct pci_dev *pdev)
 {
 	struct ctlr_info *h;
-	unsigned long flags;
 
 	if (pci_get_drvdata(pdev) == NULL) {
 		dev_err(&pdev->dev, "unable to remove device\n");
@@ -7067,10 +7078,10 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	h = pci_get_drvdata(pdev);
 
 	/* Get rid of any controller monitoring work items */
-	spin_lock_irqsave(&h->lock, flags);
 	h->remove_in_progress = 1;
-	cancel_delayed_work(&h->monitor_ctlr_work);
-	spin_unlock_irqrestore(&h->lock, flags);
+	cancel_delayed_work_sync(&h->monitor_ctlr_work);
+	destroy_workqueue(h->monitor_ctrl_wq);
+
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 	hpsa_shutdown(pdev);
 	destroy_workqueue(h->resubmit_wq);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 62c50c3207..bff65d0a7b 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -207,6 +207,7 @@ struct ctlr_info {
 	atomic_t firmware_flash_in_progress;
 	u32 __percpu *lockup_detected;
 	struct delayed_work monitor_ctlr_work;
+	struct workqueue_struct *monitor_ctrl_wq;
 	int remove_in_progress;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
 	u8 q[MAX_REPLY_QUEUES];
-- 
1.9.3

