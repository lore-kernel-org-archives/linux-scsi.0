From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 07/12] hpsa: cleanup reset handler
Date: Fri, 7 Apr 2017 15:06:27 -0500
Message-ID: <149159558766.15658.11389910379646196354.stgit@brunhilda>
References: <149159483812.15658.615814291766210537.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0049.outbound.protection.outlook.com ([104.47.42.49]:10604
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932199AbdDGUGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 16:06:38 -0400
In-Reply-To: <149159483812.15658.615814291766210537.stgit@brunhilda>
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
 drivers/scsi/hpsa.c |   44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a2852da..a6a37e0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5834,7 +5834,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
  */
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 {
-	int rc;
+	int rc = SUCCESS;
 	struct ctlr_info *h;
 	struct hpsa_scsi_dev_t *dev;
 	u8 reset_type;
@@ -5845,17 +5845,24 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	if (h == NULL) /* paranoia */
 		return FAILED;
 
-	if (lockup_detected(h))
-		return FAILED;
+	h->reset_in_progress = 1;
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
@@ -5863,7 +5870,8 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 			 "cmd %d RESET FAILED, lockup detected",
 			 hpsa_get_cmd_index(scsicmd));
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
-		return FAILED;
+		rc = FAILED;
+		goto return_reset_status;
 	}
 
 	/* this reset request might be the result of a lockup; check */
@@ -5872,12 +5880,15 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
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
@@ -5888,17 +5899,22 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
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
 	h->reset_in_progress = 0;
-	return rc == 0 ? SUCCESS : FAILED;
+	return rc;
 }
 
 static void swizzle_abort_tag(u8 *tag)
