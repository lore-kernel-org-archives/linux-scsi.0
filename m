From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 26/48] hpsa: factor out hpsa_ciss_submit function
Date: Fri, 23 Jan 2015 16:43:20 -0600
Message-ID: <20150123224320.14919.9273.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:39420 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbbAWWoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:44:13 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

Factor out the bottom part of the queuecommand function
which is the part that builds commands for submitting down
the "normal' RAID stack path of a Smart Array.

Need to factor this out to improve how commands that
were initially sent down one of the "ioaccellerated"
paths but which have some sort of error condition are
retried down the "normal" path.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  126 +++++++++++++++++++++++++++------------------------
 1 file changed, 67 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 94a82e3..cc3128f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2034,7 +2034,7 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 
 	c = cmd_alloc(h);
 
-	if (c == NULL) {			/* trouble... */
+	if (c == NULL) {
 		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		return -ENOMEM;
 	}
@@ -3807,68 +3807,14 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 						dev->scsi3addr);
 }
 
-/* Running in struct Scsi_Host->host_lock less mode */
-static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
+/* Submit commands down the "normal" RAID stack path */
+static int hpsa_ciss_submit(struct ctlr_info *h,
+	struct CommandList *c, struct scsi_cmnd *cmd,
+	unsigned char scsi3addr[])
 {
-	struct ctlr_info *h;
-	struct hpsa_scsi_dev_t *dev;
-	unsigned char scsi3addr[8];
-	struct CommandList *c;
-	int rc = 0;
-
-	/* Get the ptr to our adapter structure out of cmd->host. */
-	h = sdev_to_hba(cmd->device);
-	dev = cmd->device->hostdata;
-	if (!dev) {
-		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
-		return 0;
-	}
-	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
-
-	if (unlikely(lockup_detected(h))) {
-		cmd->result = DID_ERROR << 16;
-		cmd->scsi_done(cmd);
-		return 0;
-	}
-	c = cmd_alloc(h);
-	if (c == NULL) {			/* trouble... */
-		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
-
-	/* Fill in the command list header */
-	/* save c in case we have to abort it  */
 	cmd->host_scribble = (unsigned char *) c;
-
 	c->cmd_type = CMD_SCSI;
 	c->scsi_cmd = cmd;
-
-	/* Call alternate submit routine for I/O accelerated commands.
-	 * Retries always go down the normal I/O path.
-	 */
-	if (likely(cmd->retries == 0 &&
-		cmd->request->cmd_type == REQ_TYPE_FS &&
-		h->acciopath_status)) {
-		if (dev->offload_enabled) {
-			rc = hpsa_scsi_ioaccel_raid_map(h, c);
-			if (rc == 0)
-				return 0; /* Sent on ioaccel path */
-			if (rc < 0) {   /* scsi_dma_map failed. */
-				cmd_free(h, c);
-				return SCSI_MLQUEUE_HOST_BUSY;
-			}
-		} else if (dev->ioaccel_handle) {
-			rc = hpsa_scsi_ioaccel_direct_map(h, c);
-			if (rc == 0)
-				return 0; /* Sent on direct map path */
-			if (rc < 0) {   /* scsi_dma_map failed. */
-				cmd_free(h, c);
-				return SCSI_MLQUEUE_HOST_BUSY;
-			}
-		}
-	}
-
 	c->Header.ReplyQueue = 0;  /* unused in simple mode */
 	memcpy(&c->Header.LUN.LunAddrBytes[0], &scsi3addr[0], 8);
 	c->Header.tag = cpu_to_le64((c->cmdindex << DIRECT_LOOKUP_SHIFT));
@@ -3927,6 +3873,68 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	return 0;
 }
 
+/* Running in struct Scsi_Host->host_lock less mode */
+static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
+{
+	struct ctlr_info *h;
+	struct hpsa_scsi_dev_t *dev;
+	unsigned char scsi3addr[8];
+	struct CommandList *c;
+	int rc = 0;
+
+	/* Get the ptr to our adapter structure out of cmd->host. */
+	h = sdev_to_hba(cmd->device);
+	dev = cmd->device->hostdata;
+	if (!dev) {
+		cmd->result = DID_NO_CONNECT << 16;
+		cmd->scsi_done(cmd);
+		return 0;
+	}
+	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
+
+	if (unlikely(lockup_detected(h))) {
+		cmd->result = DID_ERROR << 16;
+		cmd->scsi_done(cmd);
+		return 0;
+	}
+	c = cmd_alloc(h);
+	if (c == NULL) {			/* trouble... */
+		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	/* Call alternate submit routine for I/O accelerated commands.
+	 * Retries always go down the normal I/O path.
+	 */
+	if (likely(cmd->retries == 0 &&
+		cmd->request->cmd_type == REQ_TYPE_FS &&
+		h->acciopath_status)) {
+
+		cmd->host_scribble = (unsigned char *) c;
+		c->cmd_type = CMD_SCSI;
+		c->scsi_cmd = cmd;
+
+		if (dev->offload_enabled) {
+			rc = hpsa_scsi_ioaccel_raid_map(h, c);
+			if (rc == 0)
+				return 0; /* Sent on ioaccel path */
+			if (rc < 0) {   /* scsi_dma_map failed. */
+				cmd_free(h, c);
+				return SCSI_MLQUEUE_HOST_BUSY;
+			}
+		} else if (dev->ioaccel_handle) {
+			rc = hpsa_scsi_ioaccel_direct_map(h, c);
+			if (rc == 0)
+				return 0; /* Sent on direct map path */
+			if (rc < 0) {   /* scsi_dma_map failed. */
+				cmd_free(h, c);
+				return SCSI_MLQUEUE_HOST_BUSY;
+			}
+		}
+	}
+	return hpsa_ciss_submit(h, c, cmd, scsi3addr);
+}
+
 static int do_not_scan_if_controller_locked_up(struct ctlr_info *h)
 {
 	unsigned long flags;

