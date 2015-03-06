From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 21/41] hpsa: do not check cmd_alloc return value - it
 cannnot return NULL
Date: Fri, 06 Mar 2015 17:47:38 -0600
Message-ID: <20150306234738.29973.74596.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37308 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbbCFXtI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:49:08 -0500
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

cmd_alloc can no longer return NULL, so don't check for NULL any more
(which is unreachable code).

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   77 ++++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index aebd9d1..297ccf0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2507,11 +2507,6 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 
 	c = cmd_alloc(h);
 
-	if (c == NULL) {
-		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		return -ENOMEM;
-	}
-
 	if (fill_cmd(c, HPSA_INQUIRY, h, buf, bufsize,
 			page, scsi3addr, TYPE_CMD)) {
 		rc = -1;
@@ -2540,11 +2535,6 @@ static int hpsa_bmic_ctrl_mode_sense(struct ctlr_info *h,
 	struct ErrorInfo *ei;
 
 	c = cmd_alloc(h);
-	if (c == NULL) {			/* trouble... */
-		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		return -ENOMEM;
-	}
-
 	if (fill_cmd(c, BMIC_SENSE_CONTROLLER_PARAMETERS, h, buf, bufsize,
 			page, scsi3addr, TYPE_CMD)) {
 		rc = -1;
@@ -2562,7 +2552,7 @@ static int hpsa_bmic_ctrl_mode_sense(struct ctlr_info *h,
 out:
 	cmd_free(h, c);
 	return rc;
-	}
+}
 
 static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 	u8 reset_type, int reply_queue)
@@ -2573,10 +2563,6 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 
 	c = cmd_alloc(h);
 
-	if (c == NULL) {			/* trouble... */
-		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		return -ENOMEM;
-	}
 
 	/* fill_cmd can't fail here, no data buffer to map. */
 	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0,
@@ -2704,10 +2690,7 @@ static int hpsa_get_raid_map(struct ctlr_info *h,
 	struct ErrorInfo *ei;
 
 	c = cmd_alloc(h);
-	if (c == NULL) {
-		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		return -ENOMEM;
-	}
+
 	if (fill_cmd(c, HPSA_GET_RAID_MAP, h, &this_device->raid_map,
 			sizeof(this_device->raid_map), 0,
 			scsi3addr, TYPE_CMD)) {
@@ -2880,10 +2863,7 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 	struct ErrorInfo *ei;
 
 	c = cmd_alloc(h);
-	if (c == NULL) {			/* trouble... */
-		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		return -1;
-	}
+
 	/* address the controller */
 	memset(scsi3addr, 0, sizeof(scsi3addr));
 	if (fill_cmd(c, logical ? HPSA_REPORT_LOG : HPSA_REPORT_PHYS, h,
@@ -2998,8 +2978,7 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 #define ASCQ_LUN_NOT_READY_INITIALIZING_CMD_REQ 0x02
 
 	c = cmd_alloc(h);
-	if (!c)
-		return 0;
+
 	(void) fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, scsi3addr, TYPE_CMD);
 	rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
 	if (rc) {
@@ -3073,8 +3052,7 @@ static int hpsa_device_supports_aborts(struct ctlr_info *h,
 		return 1;
 
 	c = cmd_alloc(h);
-	if (!c)
-		return -ENOMEM;
+
 	(void) fill_cmd(c, HPSA_ABORT_MSG, h, &tag, 0, 0, scsi3addr, TYPE_MSG);
 	(void) hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
 	/* no unmap needed here because no data xfer. */
@@ -4645,10 +4623,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		return 0;
 	}
 	c = cmd_alloc(h);
-	if (c == NULL) {			/* trouble... */
-		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
+
 	if (unlikely(lockup_detected(h))) {
 		cmd->result = DID_NO_CONNECT << 16;
 		cmd_free(h, c);
@@ -4809,11 +4784,6 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 	struct CommandList *c;
 
 	c = cmd_alloc(h);
-	if (!c) {
-		dev_warn(&h->pdev->dev, "out of memory in "
-			"wait_for_device_to_become_ready.\n");
-		return IO_ERROR;
-	}
 
 	/* Send test unit ready until device ready, or give up. */
 	while (count < HPSA_TUR_RETRY_LIMIT) {
@@ -4976,10 +4946,6 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 	__le32 tagupper, taglower;
 
 	c = cmd_alloc(h);
-	if (c == NULL) {	/* trouble... */
-		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		return -ENOMEM;
-	}
 
 	/* fill_cmd can't fail here, no buffer to map */
 	(void) fill_cmd(c, HPSA_ABORT_MSG, h, &abort->Header.tag,
@@ -5270,6 +5236,8 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
  * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
  * which ones are free or in use.  Lock must be held when calling this.
  * cmd_free() is the complement.
+ * This function never gives up and returns NULL.  If it hangs,
+ * another thread must call cmd_free() to free some tags.
  */
 
 static struct CommandList *cmd_alloc(struct ctlr_info *h)
@@ -5503,10 +5471,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		}
 	}
 	c = cmd_alloc(h);
-	if (c == NULL) {
-		rc = -ENOMEM;
-		goto out_kfree;
-	}
+
 	/* Fill in the command type */
 	c->cmd_type = CMD_IOCTL_PEND;
 	/* Fill in Command Header */
@@ -5640,10 +5605,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		sg_used++;
 	}
 	c = cmd_alloc(h);
-	if (c == NULL) {
-		status = -ENOMEM;
-		goto cleanup1;
-	}
+
 	c->cmd_type = CMD_IOCTL_PEND;
 	c->Header.ReplyQueue = 0;
 	c->Header.SGList = (u8) sg_used;
@@ -5759,14 +5721,13 @@ static int hpsa_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 	}
 }
 
-static int hpsa_send_host_reset(struct ctlr_info *h, unsigned char *scsi3addr,
+static void hpsa_send_host_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 				u8 reset_type)
 {
 	struct CommandList *c;
 
 	c = cmd_alloc(h);
-	if (!c)
-		return -ENOMEM;
+
 	/* fill_cmd can't fail here, no data buffer to map */
 	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0,
 		RAID_CTLR_LUNID, TYPE_MSG);
@@ -5777,7 +5738,7 @@ static int hpsa_send_host_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 	 * the command either.  This is the last command we will send before
 	 * re-initializing everything, so it doesn't matter and won't leak.
 	 */
-	return 0;
+	return;
 }
 
 static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
@@ -7179,11 +7140,7 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 
 static int hpsa_kdump_soft_reset(struct ctlr_info *h)
 {
-	if (hpsa_send_host_reset(h, RAID_CTLR_LUNID,
-		HPSA_RESET_TYPE_CONTROLLER)) {
-		dev_warn(&h->pdev->dev, "Resetting array controller failed.\n");
-		return -EIO;
-	}
+	hpsa_send_host_reset(h, RAID_CTLR_LUNID, HPSA_RESET_TYPE_CONTROLLER);
 
 	dev_info(&h->pdev->dev, "Waiting for board to soft reset.\n");
 	if (hpsa_wait_for_board_state(h->pdev, h->vaddr, BOARD_NOT_READY)) {
@@ -7688,10 +7645,7 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 		return;
 
 	c = cmd_alloc(h);
-	if (!c) {
-		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		goto out_of_memory;
-	}
+
 	if (fill_cmd(c, HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
 		RAID_CTLR_LUNID, TYPE_CMD)) {
 		goto out;
@@ -7705,7 +7659,6 @@ out:
 		dev_warn(&h->pdev->dev,
 			"error flushing cache on controller\n");
 	cmd_free(h, c);
-out_of_memory:
 	kfree(flush_buf);
 }
 

