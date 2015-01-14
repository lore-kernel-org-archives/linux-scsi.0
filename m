From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 27/48] hpsa: use workqueue to resubmit failed ioaccel
 commands
Date: Wed, 14 Jan 2015 16:02:00 -0600
Message-ID: <20150114220200.21325.96174.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37533 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbbANWCq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:02:46 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Instead of kicking the commands all the way back to the mid
layer, use a work queue.  This enables having a mechanism for
the driver to be able to resubmit the commands down the "normal"
raid path without turning off the ioaccel feature entirely
whenever an error is encountered on the ioaccel path, and
prevent excessive rescanning of devices.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |   60 ++++++++++++++++++++++++++++++++---------------
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cc3128f..c1166a5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -248,6 +248,7 @@ static void hpsa_flush_cache(struct ctlr_info *h);
 static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
 	struct CommandList *c, u32 ioaccel_handle, u8 *cdb, int cdb_len,
 	u8 *scsi3addr);
+static void hpsa_command_resubmit_worker(struct work_struct *work);
 
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 {
@@ -1619,7 +1620,6 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 		struct hpsa_scsi_dev_t *dev)
 {
 	struct io_accel2_cmd *c2 = &h->ioaccel2_cmd_pool[c->cmdindex];
-	int raid_retry = 0;
 
 	/* check for good status */
 	if (likely(c2->error_data.serv_response == 0 &&
@@ -1636,24 +1636,22 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 	if (is_logical_dev_addr_mode(dev->scsi3addr) &&
 		c2->error_data.serv_response ==
 			IOACCEL2_SERV_RESPONSE_FAILURE) {
-		dev->offload_enabled = 0;
-		cmd->result = DID_SOFT_ERROR << 16;
-		cmd_free(h, c);
-		cmd->scsi_done(cmd);
-		return;
-	}
-	raid_retry = handle_ioaccel_mode2_error(h, c, cmd, c2);
-	/* If error found, disable Smart Path,
-	 * force a retry on the standard path.
-	 */
-	if (raid_retry) {
-		dev_warn(&h->pdev->dev, "%s: Retrying on standard path.\n",
-			"HP SSD Smart Path");
-		dev->offload_enabled = 0; /* Disable Smart Path */
-		cmd->result = DID_SOFT_ERROR << 16;
+		if (c2->error_data.status ==
+			IOACCEL2_STATUS_SR_IOACCEL_DISABLED)
+			dev->offload_enabled = 0;
+		goto retry_cmd;
 	}
+
+	if (handle_ioaccel_mode2_error(h, c, cmd, c2))
+		goto retry_cmd;
+
 	cmd_free(h, c);
 	cmd->scsi_done(cmd);
+	return;
+
+retry_cmd:
+	INIT_WORK(&c->work, hpsa_command_resubmit_worker);
+	schedule_work_on(raw_smp_processor_id(), &c->work);
 }
 
 static void complete_scsi_command(struct CommandList *cp)
@@ -1723,9 +1721,8 @@ static void complete_scsi_command(struct CommandList *cp)
 		if (is_logical_dev_addr_mode(dev->scsi3addr)) {
 			if (ei->CommandStatus == CMD_IOACCEL_DISABLED)
 				dev->offload_enabled = 0;
-			cmd->result = DID_SOFT_ERROR << 16;
-			cmd_free(h, cp);
-			cmd->scsi_done(cmd);
+			INIT_WORK(&cp->work, hpsa_command_resubmit_worker);
+			schedule_work_on(raw_smp_processor_id(), &cp->work);
 			return;
 		}
 	}
@@ -3873,6 +3870,31 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
 	return 0;
 }
 
+static void hpsa_command_resubmit_worker(struct work_struct *work)
+{
+	struct scsi_cmnd *cmd;
+	struct hpsa_scsi_dev_t *dev;
+	struct CommandList *c =
+			container_of(work, struct CommandList, work);
+
+	cmd = c->scsi_cmd;
+	dev = cmd->device->hostdata;
+	if (!dev) {
+		cmd->result = DID_NO_CONNECT << 16;
+		cmd->scsi_done(cmd);
+		return;
+	}
+	if (hpsa_ciss_submit(c->h, c, cmd, dev->scsi3addr)) {
+		/*
+		 * If we get here, it means dma mapping failed. Try
+		 * again via scsi mid layer, which will then get
+		 * SCSI_MLQUEUE_HOST_BUSY.
+		 */
+		cmd->result = DID_IMM_RETRY << 16;
+		cmd->scsi_done(cmd);
+	}
+}
+
 /* Running in struct Scsi_Host->host_lock less mode */
 static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 {
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index d78e666..3f2f0af 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -404,6 +404,7 @@ struct CommandList {
 	long			   cmdindex;
 	struct completion *waiting;
 	void   *scsi_cmd;
+	struct work_struct work;
 } __aligned(COMMANDLIST_ALIGNMENT);
 
 /* Max S/G elements in I/O accelerator command */

