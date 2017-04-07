From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 09/12] hpsa: separate monitor events from heartbeat worker
Date: Fri, 7 Apr 2017 15:06:40 -0500
Message-ID: <149159560000.15658.13539404380272805930.stgit@brunhilda>
References: <149159483812.15658.615814291766210537.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0063.outbound.protection.outlook.com ([104.47.36.63]:5792
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932199AbdDGUGp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 16:06:45 -0400
In-Reply-To: <149159483812.15658.615814291766210537.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@microsemi.com>

create new worker thread to monitor controller events
 - detect controller events more frequently.
 - leave heartbeat check at 30 seconds.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   32 ++++++++++++++++++++++++++++++--
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 40a87f9..50f7c09 100644
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
@@ -8650,6 +8651,29 @@ static int hpsa_luns_changed(struct ctlr_info *h)
 	return rc;
 }
 
+/*
+ * watch for controller events
+ */
+static void hpsa_event_monitor_worker(struct work_struct *work)
+{
+	struct ctlr_info *h = container_of(to_delayed_work(work),
+	struct ctlr_info, event_monitor_work);
+
+	if (h->remove_in_progress)
+		return;
+
+	if (hpsa_ctlr_needs_rescan(h)) {
+		scsi_host_get(h->scsi_host);
+		hpsa_ack_ctlr_events(h);
+		hpsa_scan_start(h->scsi_host);
+		scsi_host_put(h->scsi_host);
+	}
+
+	if (!h->remove_in_progress)
+		schedule_delayed_work(&h->event_monitor_work,
+					HPSA_EVENT_MONITOR_INTERVAL);
+}
+
 static void hpsa_rescan_ctlr_worker(struct work_struct *work)
 {
 	unsigned long flags;
@@ -8668,9 +8692,9 @@ static void hpsa_rescan_ctlr_worker(struct work_struct *work)
 		return;
 	}
 
-	if (hpsa_ctlr_needs_rescan(h) || hpsa_offline_devices_ready(h)) {
+	if (h->drv_req_rescan || hpsa_offline_devices_ready(h)) {
+		h->drv_req_rescan = 0;
 		scsi_host_get(h->scsi_host);
-		hpsa_ack_ctlr_events(h);
 		hpsa_scan_start(h->scsi_host);
 		scsi_host_put(h->scsi_host);
 	} else if (h->discovery_polling) {
@@ -8949,6 +8973,9 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_DELAYED_WORK(&h->rescan_ctlr_work, hpsa_rescan_ctlr_worker);
 	queue_delayed_work(h->rescan_ctlr_wq, &h->rescan_ctlr_work,
 				h->heartbeat_sample_interval);
+	INIT_DELAYED_WORK(&h->event_monitor_work, hpsa_event_monitor_worker);
+	schedule_delayed_work(&h->event_monitor_work,
+				HPSA_EVENT_MONITOR_INTERVAL);
 	return 0;
 
 clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
@@ -9117,6 +9144,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&h->lock, flags);
 	cancel_delayed_work_sync(&h->monitor_ctlr_work);
 	cancel_delayed_work_sync(&h->rescan_ctlr_work);
+	cancel_delayed_work_sync(&h->event_monitor_work);
 	destroy_workqueue(h->rescan_ctlr_wq);
 	destroy_workqueue(h->resubmit_wq);
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 99539c0..3c22ac1 100644
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
