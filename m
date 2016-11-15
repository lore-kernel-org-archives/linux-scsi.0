From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2] hpsa: correct logical resets
Date: Tue, 15 Nov 2016 14:45:32 -0600
Message-ID: <147924273290.3204.4516045603924193508.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0087.outbound.protection.outlook.com ([104.47.42.87]:36032
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932389AbcKOUpo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 15:45:44 -0500
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
 drivers/scsi/hpsa.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b924f6a..5156cde 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -276,6 +276,9 @@ static int hpsa_find_cfg_addrs(struct pci_dev *pdev, void __iomem *vaddr,
 static int hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 				    unsigned long *memory_bar);
 static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id);
+static int wait_for_device_to_become_ready(struct ctlr_info *h,
+					   unsigned char lunaddr[],
+					   int reply_queue);
 static int hpsa_wait_for_board_state(struct pci_dev *pdev, void __iomem *vaddr,
 				     int wait_for_ready);
 static inline void finish_cmd(struct CommandList *c);
@@ -2540,7 +2543,7 @@ static void complete_scsi_command(struct CommandList *cp)
 
 	if ((unlikely(hpsa_is_pending_event(cp)))) {
 		if (cp->reset_pending)
-			return hpsa_cmd_resolve_and_free(h, cp);
+			return hpsa_cmd_free_and_done(h, cp, cmd);
 		if (cp->abort_pending)
 			return hpsa_cmd_abort_and_free(h, cp, cmd);
 	}
@@ -3079,6 +3082,8 @@ static int hpsa_do_reset(struct ctlr_info *h, struct hpsa_scsi_dev_t *dev,
 
 	if (unlikely(rc))
 		atomic_set(&dev->reset_cmds_out, 0);
+	else
+		wait_for_device_to_become_ready(h, scsi3addr, 0);
 
 	mutex_unlock(&h->reset_mutex);
 	return rc;
@@ -5563,6 +5568,14 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
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
@@ -8599,6 +8612,14 @@ static void hpsa_rescan_ctlr_worker(struct work_struct *work)
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

