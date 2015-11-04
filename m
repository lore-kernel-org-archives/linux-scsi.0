From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 11/27] hpsa: fix physical target reset
Date: Wed, 04 Nov 2015 15:51:02 -0600
Message-ID: <20151104215102.15472.32876.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53444 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030915AbbKDVyz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:54:55 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@pmcs.com>

Set reset type in device_reset_handler to do either
logical unit reset for logical devices, or physical
target reset, for physical devices.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   34 ++++++++++++++++++++++++++++------
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 382cb5d..1607b6d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2737,9 +2737,8 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 
 
 	/* fill_cmd can't fail here, no data buffer to map. */
-	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0,
+	(void) fill_cmd(c, reset_type, h, NULL, 0, 0,
 			scsi3addr, TYPE_MSG);
-	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to LUN reset */
 	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
 	if (rc) {
 		dev_warn(&h->pdev->dev, "Failed to send reset command\n");
@@ -5207,6 +5206,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	int rc;
 	struct ctlr_info *h;
 	struct hpsa_scsi_dev_t *dev;
+	u8 reset_type;
 	char msg[48];
 
 	/* find the controller to which the command to be aborted was sent */
@@ -5245,15 +5245,23 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	if (is_hba_lunid(dev->scsi3addr))
 		return SUCCESS;
 
-	hpsa_show_dev_msg(KERN_WARNING, h, dev, "resetting");
+	if (is_logical_dev_addr_mode(dev->scsi3addr))
+		reset_type = HPSA_DEVICE_RESET_MSG;
+	else
+		reset_type = HPSA_PHYS_TARGET_RESET;
+
+	sprintf(msg, "resetting %s",
+		reset_type == HPSA_DEVICE_RESET_MSG ? "logical " : "physical ");
+	hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 
 	h->reset_in_progress = 1;
 
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = hpsa_do_reset(h, dev, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
+	rc = hpsa_do_reset(h, dev, dev->scsi3addr, reset_type,
 			   DEFAULT_REPLY_QUEUE);
-	snprintf(msg, sizeof(msg), "reset %s",
-		 rc == 0 ? "completed successfully" : "failed");
+	sprintf(msg, "reset %s %s",
+		reset_type == HPSA_DEVICE_RESET_MSG ? "logical " : "physical ",
+		rc == 0 ? "completed successfully" : "failed");
 	hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 	h->reset_in_progress = 0;
 	return rc == 0 ? SUCCESS : FAILED;
@@ -6370,6 +6378,20 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 	} else if (cmd_type == TYPE_MSG) {
 		switch (cmd) {
 
+		case  HPSA_PHYS_TARGET_RESET:
+			c->Request.CDBLen = 16;
+			c->Request.type_attr_dir =
+				TYPE_ATTR_DIR(cmd_type, ATTR_SIMPLE, XFER_NONE);
+			c->Request.Timeout = 0; /* Don't time out */
+			memset(&c->Request.CDB[0], 0, sizeof(c->Request.CDB));
+			c->Request.CDB[0] = HPSA_RESET;
+			c->Request.CDB[1] = HPSA_TARGET_RESET_TYPE;
+			/* Physical target reset needs no control bytes 4-7*/
+			c->Request.CDB[4] = 0x00;
+			c->Request.CDB[5] = 0x00;
+			c->Request.CDB[6] = 0x00;
+			c->Request.CDB[7] = 0x00;
+			break;
 		case  HPSA_DEVICE_RESET_MSG:
 			c->Request.CDBLen = 16;
 			c->Request.type_attr_dir =
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index dc113c1a..04f98eb 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -285,6 +285,7 @@ struct offline_device_entry {
 #define HPSA_RESET_TYPE_BUS 0x01
 #define HPSA_RESET_TYPE_TARGET 0x03
 #define HPSA_RESET_TYPE_LUN 0x04
+#define HPSA_PHYS_TARGET_RESET 0x99 /* not defined by cciss spec */
 #define HPSA_MSG_SEND_RETRY_LIMIT 10
 #define HPSA_MSG_SEND_RETRY_INTERVAL_MSECS (10000)
 

