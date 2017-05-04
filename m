From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V4 09/12] hpsa: separate monitor events from rescan worker
Date: Thu, 4 May 2017 17:51:36 -0500
Message-ID: <149393829604.19382.8267269602509905869.stgit@brunhilda>
References: <149393820493.19382.11709906672864416473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0060.outbound.protection.outlook.com ([104.47.37.60]:55360
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752979AbdEDWvs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 18:51:48 -0400
In-Reply-To: <149393820493.19382.11709906672864416473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@microsemi.com>

create new worker thread to monitor controller events
 - both the rescan and event monitor workers can cause a
   rescan to occur however for multipath we have found
   that we need to respond faster than the normal scheduled
   rescan interval for path fail-overs.
 - getting controller events only involves reading a register, but
   the rescan worker can obtain an updated LUN list when there
   is a PTRAID device present.
 - move common code to a separate function.
advantages:
 - detect controller events more frequently.
 - leave rescan thread interval at 30 seconds.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   76 +++++++++++++++++++++++++++++++++++++++------------
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5b0cc0e..2ec9079 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1110,6 +1110,7 @@ static int is_firmware_flash_cmd(u8 *cdb)
  */
 #define HEARTBEAT_SAMPLE_INTERVAL_DURING_FLASH (240 * HZ)
 #define HEARTBEAT_SAMPLE_INTERVAL (30 * HZ)
+#define HPSA_EVENT_MONITOR_INTERVAL (15 * HZ)
 static void dial_down_lockup_detection_during_fw_flash(struct ctlr_info *h,
 		struct CommandList *c)
 {
@@ -8661,15 +8662,10 @@ static int hpsa_luns_changed(struct ctlr_info *h)
 	return rc;
 }
 
-static void hpsa_rescan_ctlr_worker(struct work_struct *work)
+static void hpsa_perform_rescan(struct ctlr_info *h)
 {
+	struct Scsi_Host *sh = NULL;
 	unsigned long flags;
-	struct ctlr_info *h = container_of(to_delayed_work(work),
-					struct ctlr_info, rescan_ctlr_work);
-
-
-	if (h->remove_in_progress)
-		return;
 
 	/*
 	 * Do the scan after the reset
@@ -8682,23 +8678,63 @@ static void hpsa_rescan_ctlr_worker(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(&h->reset_lock, flags);
 
-	if (hpsa_ctlr_needs_rescan(h) || hpsa_offline_devices_ready(h)) {
-		scsi_host_get(h->scsi_host);
+	sh = scsi_host_get(h->scsi_host);
+	if (sh != NULL) {
+		hpsa_scan_start(sh);
+		scsi_host_put(sh);
+		h->drv_req_rescan = 0;
+	}
+}
+
+/*
+ * watch for controller events
+ */
+static void hpsa_event_monitor_worker(struct work_struct *work)
+{
+	struct ctlr_info *h = container_of(to_delayed_work(work),
+					struct ctlr_info, event_monitor_work);
+	unsigned long flags;
+
+	spin_lock_irqsave(&h->lock, flags);
+	if (h->remove_in_progress) {
+		spin_unlock_irqrestore(&h->lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&h->lock, flags);
+
+	if (hpsa_ctlr_needs_rescan(h)) {
 		hpsa_ack_ctlr_events(h);
-		hpsa_scan_start(h->scsi_host);
-		scsi_host_put(h->scsi_host);
+		hpsa_perform_rescan(h);
+	}
+
+	spin_lock_irqsave(&h->lock, flags);
+	if (!h->remove_in_progress)
+		schedule_delayed_work(&h->event_monitor_work,
+					HPSA_EVENT_MONITOR_INTERVAL);
+	spin_unlock_irqrestore(&h->lock, flags);
+}
+
+static void hpsa_rescan_ctlr_worker(struct work_struct *work)
+{
+	unsigned long flags;
+	struct ctlr_info *h = container_of(to_delayed_work(work),
+					struct ctlr_info, rescan_ctlr_work);
+
+	spin_lock_irqsave(&h->lock, flags);
+	if (h->remove_in_progress) {
+		spin_unlock_irqrestore(&h->lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&h->lock, flags);
+
+	if (h->drv_req_rescan || hpsa_offline_devices_ready(h)) {
+		hpsa_perform_rescan(h);
 	} else if (h->discovery_polling) {
 		hpsa_disable_rld_caching(h);
 		if (hpsa_luns_changed(h)) {
-			struct Scsi_Host *sh = NULL;
-
 			dev_info(&h->pdev->dev,
 				"driver discovery polling rescan.\n");
-			sh = scsi_host_get(h->scsi_host);
-			if (sh != NULL) {
-				hpsa_scan_start(sh);
-				scsi_host_put(sh);
-			}
+			hpsa_perform_rescan(h);
 		}
 	}
 	spin_lock_irqsave(&h->lock, flags);
@@ -8964,6 +9000,9 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_DELAYED_WORK(&h->rescan_ctlr_work, hpsa_rescan_ctlr_worker);
 	queue_delayed_work(h->rescan_ctlr_wq, &h->rescan_ctlr_work,
 				h->heartbeat_sample_interval);
+	INIT_DELAYED_WORK(&h->event_monitor_work, hpsa_event_monitor_worker);
+	schedule_delayed_work(&h->event_monitor_work,
+				HPSA_EVENT_MONITOR_INTERVAL);
 	return 0;
 
 clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
@@ -9132,6 +9171,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&h->lock, flags);
 	cancel_delayed_work_sync(&h->monitor_ctlr_work);
 	cancel_delayed_work_sync(&h->rescan_ctlr_work);
+	cancel_delayed_work_sync(&h->event_monitor_work);
 	destroy_workqueue(h->rescan_ctlr_wq);
 	destroy_workqueue(h->resubmit_wq);
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 61dd54a..c9c4927 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -245,6 +245,7 @@ struct ctlr_info {
 	u32 __percpu *lockup_detected;
 	struct delayed_work monitor_ctlr_work;
 	struct delayed_work rescan_ctlr_work;
+	struct delayed_work event_monitor_work;
 	int remove_in_progress;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
 	u8 q[MAX_REPLY_QUEUES];
