From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 07/12] hpsa: cleanup reset handler
Date: Fri, 28 Apr 2017 13:20:28 -0500
Message-ID: <149340362829.4102.17902813963900092821.stgit@brunhilda>
References: <149340349509.4102.15752249884898695693.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0064.outbound.protection.outlook.com ([104.47.32.64]:28817
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1426577AbdD1SUo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 14:20:44 -0400
In-Reply-To: <149340349509.4102.15752249884898695693.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

 - mark device state sooner.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   59 +++++++++++++++++++++++++++++++++++++++------------
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a2852da..71f32e9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1859,10 +1859,13 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	 * A reset can cause a device status to change
 	 * re-schedule the scan to see what happened.
 	 */
+	spin_lock_irqsave(&h->reset_lock, flags);
 	if (h->reset_in_progress) {
+		spin_unlock_irqrestore(&h->reset_lock, flags);
 		h->drv_req_rescan = 1;
 		return;
 	}
+	spin_unlock_irqrestore(&h->reset_lock, flags);
 
 	added = kzalloc(sizeof(*added) * HPSA_MAX_DEVICES, GFP_KERNEL);
 	removed = kzalloc(sizeof(*removed) * HPSA_MAX_DEVICES, GFP_KERNEL);
@@ -5618,11 +5621,14 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	/*
 	 * Do the scan after a reset completion
 	 */
+	spin_lock_irqsave(&h->reset_lock, flags);
 	if (h->reset_in_progress) {
+		spin_unlock_irqrestore(&h->reset_lock, flags);
 		h->drv_req_rescan = 1;
 		hpsa_scan_complete(h);
 		return;
 	}
+	spin_unlock_irqrestore(&h->reset_lock, flags);
 
 	hpsa_update_scsi_devices(h);
 
@@ -5834,28 +5840,38 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
  */
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 {
-	int rc;
+	int rc = SUCCESS;
 	struct ctlr_info *h;
 	struct hpsa_scsi_dev_t *dev;
 	u8 reset_type;
 	char msg[48];
+	unsigned long flags;
 
 	/* find the controller to which the command to be aborted was sent */
 	h = sdev_to_hba(scsicmd->device);
 	if (h == NULL) /* paranoia */
 		return FAILED;
 
-	if (lockup_detected(h))
-		return FAILED;
+	spin_lock_irqsave(&h->reset_lock, flags);
+	h->reset_in_progress = 1;
+	spin_unlock_irqrestore(&h->reset_lock, flags);
+
+	if (lockup_detected(h)) {
+		rc = FAILED;
+		goto return_reset_status;
+	}
 
 	dev = scsicmd->device->hostdata;
 	if (!dev) {
 		dev_err(&h->pdev->dev, "%s: device lookup failed\n", __func__);
-		return FAILED;
+		rc = FAILED;
+		goto return_reset_status;
 	}
 
-	if (dev->devtype == TYPE_ENCLOSURE)
-		return SUCCESS;
+	if (dev->devtype == TYPE_ENCLOSURE) {
+		rc = SUCCESS;
+		goto return_reset_status;
+	}
 
 	/* if controller locked up, we can guarantee command won't complete */
 	if (lockup_detected(h)) {
@@ -5863,7 +5879,8 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 			 "cmd %d RESET FAILED, lockup detected",
 			 hpsa_get_cmd_index(scsicmd));
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
-		return FAILED;
+		rc = FAILED;
+		goto return_reset_status;
 	}
 
 	/* this reset request might be the result of a lockup; check */
@@ -5872,12 +5889,15 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 			 "cmd %d RESET FAILED, new lockup detected",
 			 hpsa_get_cmd_index(scsicmd));
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
-		return FAILED;
+		rc = FAILED;
+		goto return_reset_status;
 	}
 
 	/* Do not attempt on controller */
-	if (is_hba_lunid(dev->scsi3addr))
-		return SUCCESS;
+	if (is_hba_lunid(dev->scsi3addr)) {
+		rc = SUCCESS;
+		goto return_reset_status;
+	}
 
 	if (is_logical_dev_addr_mode(dev->scsi3addr))
 		reset_type = HPSA_DEVICE_RESET_MSG;
@@ -5888,17 +5908,24 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 		reset_type == HPSA_DEVICE_RESET_MSG ? "logical " : "physical ");
 	hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 
-	h->reset_in_progress = 1;
-
 	/* send a reset to the SCSI LUN which the command was sent to */
 	rc = hpsa_do_reset(h, dev, dev->scsi3addr, reset_type,
 			   DEFAULT_REPLY_QUEUE);
+	if (rc == 0)
+		rc = SUCCESS;
+	else
+		rc = FAILED;
+
 	sprintf(msg, "reset %s %s",
 		reset_type == HPSA_DEVICE_RESET_MSG ? "logical " : "physical ",
-		rc == 0 ? "completed successfully" : "failed");
+		rc == SUCCESS ? "completed successfully" : "failed");
 	hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
+
+return_reset_status:
+	spin_lock_irqsave(&h->reset_lock, flags);
 	h->reset_in_progress = 0;
-	return rc == 0 ? SUCCESS : FAILED;
+	spin_unlock_irqrestore(&h->reset_lock, flags);
+	return rc;
 }
 
 static void swizzle_abort_tag(u8 *tag)
@@ -8649,10 +8676,13 @@ static void hpsa_rescan_ctlr_worker(struct work_struct *work)
 	/*
 	 * Do the scan after the reset
 	 */
+	spin_lock_irqsave(&h->reset_lock, flags);
 	if (h->reset_in_progress) {
+		spin_unlock_irqrestore(&h->reset_lock, flags);
 		h->drv_req_rescan = 1;
 		return;
 	}
+	spin_unlock_irqrestore(&h->reset_lock, flags);
 
 	if (hpsa_ctlr_needs_rescan(h) || hpsa_offline_devices_ready(h)) {
 		scsi_host_get(h->scsi_host);
@@ -8759,6 +8789,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	spin_lock_init(&h->lock);
 	spin_lock_init(&h->offline_device_lock);
 	spin_lock_init(&h->scan_lock);
+	spin_lock_init(&h->reset_lock);
 	atomic_set(&h->passthru_cmds_avail, HPSA_MAX_CONCURRENT_PASSTHRUS);
 	atomic_set(&h->abort_cmds_available, HPSA_CMDS_RESERVED_FOR_ABORTS);
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6f04f2a..5352664 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -301,6 +301,7 @@ struct ctlr_info {
 	struct mutex reset_mutex;
 	u8 reset_in_progress;
 	struct hpsa_sas_node *sas_host;
+	spinlock_t reset_lock;
 };
 
 struct offline_device_entry {
