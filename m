From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH] hpsa: correct logical resets
Date: Thu, 10 Nov 2016 15:42:54 -0600
Message-ID: <147881417483.804.10756927186886954941.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0058.outbound.protection.outlook.com ([104.47.34.58]:10145
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934051AbcKJVnf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 16:43:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

- driver was not calling done in some cases which causes
  the volume to be offlined.
- avoid doing rescan during a reset.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0b6eb5a..a296537 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -300,6 +300,10 @@ static bool hpsa_cmd_dev_match(struct ctlr_info *h, struct CommandList *c,
 			       struct hpsa_scsi_dev_t *dev,
 			       unsigned char *scsi3addr);
 
+static int wait_for_device_to_become_ready(struct ctlr_info *h,
+					   unsigned char lunaddr[],
+					   int reply_queue);
+
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 {
 	unsigned long *priv = shost_priv(sdev->host);
@@ -2540,7 +2544,7 @@ static void complete_scsi_command(struct CommandList *cp)
 
 	if ((unlikely(hpsa_is_pending_event(cp)))) {
 		if (cp->reset_pending)
-			return hpsa_cmd_resolve_and_free(h, cp);
+			return hpsa_cmd_free_and_done(h, cp, cmd);
 		if (cp->abort_pending)
 			return hpsa_cmd_abort_and_free(h, cp, cmd);
 	}
@@ -3079,6 +3083,8 @@ static int hpsa_do_reset(struct ctlr_info *h, struct hpsa_scsi_dev_t *dev,
 
 	if (unlikely(rc))
 		atomic_set(&dev->reset_cmds_out, 0);
+	else
+		wait_for_device_to_become_ready(h, scsi3addr, 0);
 
 	mutex_unlock(&h->reset_mutex);
 	return rc;
@@ -5563,6 +5569,14 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	if (unlikely(lockup_detected(h)))
 		return hpsa_scan_complete(h);
 
+	/*
+	 * Do the scan after a reset completion
+	 */
+	if (h->reset_in_progress) {
+		h->drv_req_rescan = 1;
+		return;
+	}
+
 	hpsa_update_scsi_devices(h);
 
 	hpsa_scan_complete(h);
@@ -8641,6 +8655,14 @@ static void hpsa_rescan_ctlr_worker(struct work_struct *work)
 	if (h->remove_in_progress)
 		return;
 
+	/*
+	 * Do the scan after the reset
+	 */
+	if (h->reset_in_progress) {
+		h->drv_req_rescan = 1;
+		return;
+	}
+
 	if (hpsa_ctlr_needs_rescan(h) || hpsa_offline_devices_ready(h)) {
 		scsi_host_get(h->scsi_host);
 		hpsa_ack_ctlr_events(h);

