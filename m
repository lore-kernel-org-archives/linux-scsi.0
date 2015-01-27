From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/2] hpsa: use a driver's own workqueue instead of a shared wq
Date: Tue, 27 Jan 2015 17:56:38 +0100
Message-ID: <1422377799-14696-2-git-send-email-thenzl@redhat.com>
References: <1422377799-14696-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652AbbA0Q4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 11:56:45 -0500
In-Reply-To: <1422377799-14696-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, Justin.Lindley@pmcs.com

hpsa driver uses a shared wq, max sleep time in function spent
hpsa_wait_for_clear_event_notify_ack may take up to 40sec
and that is too much for a shared workqueue.
This patch takes the easiest approach and just creates a
driver's own workqueue.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 18 +++++++++++++-----
 drivers/scsi/hpsa.h |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 95d581c454..af32962259 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6822,8 +6822,8 @@ static void hpsa_monitor_ctlr_worker(struct work_struct *work)
 
 	spin_lock_irqsave(&h->lock, flags);
 	if (!h->remove_in_progress)
-		schedule_delayed_work(&h->monitor_ctlr_work,
-				h->heartbeat_sample_interval);
+		queue_delayed_work(h->monitor_wq, &h->monitor_ctlr_work,
+			h->heartbeat_sample_interval);
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
@@ -6888,12 +6888,17 @@ reinit_after_soft_reset:
 		rc = -ENOMEM;
 		goto clean1;
 	}
-
 	h->resubmit_wq = hpsa_create_controller_wq(h, "resubmit");
 	if (!h->resubmit_wq) {
 		rc = -ENOMEM;
 		goto clean1;
 	}
+	h->monitor_wq = hpsa_create_controller_wq(h, "monitor");
+	if (!h->monitor_wq) {
+		rc = -ENOMEM;
+		goto clean1;
+	}
+
 
 	/* Allocate and clear per-cpu variable lockup_detected */
 	h->lockup_detected = alloc_percpu(u32);
@@ -7016,8 +7021,8 @@ reinit_after_soft_reset:
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
 	INIT_DELAYED_WORK(&h->monitor_ctlr_work, hpsa_monitor_ctlr_worker);
-	schedule_delayed_work(&h->monitor_ctlr_work,
-				h->heartbeat_sample_interval);
+	queue_delayed_work(h->monitor_wq, &h->monitor_ctlr_work,
+		h->heartbeat_sample_interval);
 	INIT_DELAYED_WORK(&h->rescan_ctlr_work, hpsa_rescan_ctlr_worker);
 	queue_delayed_work(h->rescan_ctlr_wq, &h->rescan_ctlr_work,
 				h->heartbeat_sample_interval);
@@ -7030,6 +7035,8 @@ clean2_and_free_irqs:
 	hpsa_free_irqs(h);
 clean2:
 clean1:
+	if (h->monitor_wq)
+		destroy_workqueue(h->monitor_wq);
 	if (h->resubmit_wq)
 		destroy_workqueue(h->resubmit_wq);
 	if (h->rescan_ctlr_wq)
@@ -7112,6 +7119,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&h->rescan_ctlr_work);
 	destroy_workqueue(h->rescan_ctlr_wq);
 	destroy_workqueue(h->resubmit_wq);
+	destroy_workqueue(h->monitor_wq);
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 	hpsa_shutdown(pdev);
 	iounmap(h->vaddr);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6577130503..39c720e6f0 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -253,6 +253,7 @@ struct ctlr_info {
 	int	raid_offload_debug;
 	struct workqueue_struct *resubmit_wq;
 	struct workqueue_struct *rescan_ctlr_wq;
+	struct workqueue_struct *monitor_wq;
 };
 
 struct offline_device_entry {
-- 
1.9.3

