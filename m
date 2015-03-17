From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 12/42] hpsa: factor out hpsa_ioaccel_submit function
Date: Tue, 17 Mar 2015 15:03:30 -0500
Message-ID: <20150317200330.19856.51323.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:59073 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbbCQUFK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:05:10 -0400
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

clean up command submission

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   91 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 66 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 76865df..813f3c8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4408,6 +4408,33 @@ static inline void hpsa_cmd_partial_init(struct ctlr_info *h, int index,
 	c->busaddr = (u32) cmd_dma_handle;
 }
 
+static int hpsa_ioaccel_submit(struct ctlr_info *h,
+		struct CommandList *c, struct scsi_cmnd *cmd,
+		unsigned char *scsi3addr)
+{
+	struct hpsa_scsi_dev_t *dev = cmd->device->hostdata;
+	int rc = IO_ACCEL_INELIGIBLE;
+
+	cmd->host_scribble = (unsigned char *) c;
+
+	if (dev->offload_enabled) {
+		hpsa_cmd_init(h, c->cmdindex, c);
+		c->cmd_type = CMD_SCSI;
+		c->scsi_cmd = cmd;
+		rc = hpsa_scsi_ioaccel_raid_map(h, c);
+		if (rc < 0)     /* scsi_dma_map failed. */
+			rc = SCSI_MLQUEUE_HOST_BUSY;
+	} else if (dev->ioaccel_handle) {
+		hpsa_cmd_init(h, c->cmdindex, c);
+		c->cmd_type = CMD_SCSI;
+		c->scsi_cmd = cmd;
+		rc = hpsa_scsi_ioaccel_direct_map(h, c);
+		if (rc < 0)     /* scsi_dma_map failed. */
+			rc = SCSI_MLQUEUE_HOST_BUSY;
+	}
+	return rc;
+}
+
 static void hpsa_command_resubmit_worker(struct work_struct *work)
 {
 	struct scsi_cmnd *cmd;
@@ -4419,15 +4446,46 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
+		cmd_free(c->h, c);
 		cmd->scsi_done(cmd);
 		return;
 	}
+	if (c->cmd_type == CMD_IOACCEL2) {
+		struct ctlr_info *h = c->h;
+		struct io_accel2_cmd *c2 = &h->ioaccel2_cmd_pool[c->cmdindex];
+		int rc;
+
+		if (c2->error_data.serv_response ==
+				IOACCEL2_STATUS_SR_TASK_COMP_SET_FULL) {
+			rc = hpsa_ioaccel_submit(h, c, cmd, dev->scsi3addr);
+			if (rc == 0)
+				return;
+			if (rc == SCSI_MLQUEUE_HOST_BUSY) {
+				/*
+				 * If we get here, it means dma mapping failed.
+				 * Try again via scsi mid layer, which will
+				 * then get SCSI_MLQUEUE_HOST_BUSY.
+				 */
+				cmd->result = DID_IMM_RETRY << 16;
+				cmd->scsi_done(cmd);
+				cmd_free(h, c);	/* FIX-ME:  on merge, change
+						 * to cmd_tagged_free() and
+						 * ultimately to
+						 * hpsa_cmd_free_and_done(). */
+				return;
+			}
+			/* else, fall thru and resubmit down CISS path */
+		}
+	}
 	hpsa_cmd_partial_init(c->h, c->cmdindex, c);
 	if (hpsa_ciss_submit(c->h, c, cmd, dev->scsi3addr)) {
 		/*
 		 * If we get here, it means dma mapping failed. Try
 		 * again via scsi mid layer, which will then get
 		 * SCSI_MLQUEUE_HOST_BUSY.
+		 *
+		 * hpsa_ciss_submit will have already freed c
+		 * if it encountered a dma mapping failure.
 		 */
 		cmd->result = DID_IMM_RETRY << 16;
 		cmd->scsi_done(cmd);
@@ -4477,31 +4535,14 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	if (likely(cmd->retries == 0 &&
 		cmd->request->cmd_type == REQ_TYPE_FS &&
 		h->acciopath_status)) {
-
-		cmd->host_scribble = (unsigned char *) c;
-
-		if (dev->offload_enabled) {
-			hpsa_cmd_init(h, c->cmdindex, c);
-			c->cmd_type = CMD_SCSI;
-			c->scsi_cmd = cmd;
-			rc = hpsa_scsi_ioaccel_raid_map(h, c);
-			if (rc == 0)
-				return 0; /* Sent on ioaccel path */
-			if (rc < 0) {   /* scsi_dma_map failed. */
-				cmd_free(h, c);
-				return SCSI_MLQUEUE_HOST_BUSY;
-			}
-		} else if (dev->ioaccel_handle) {
-			hpsa_cmd_init(h, c->cmdindex, c);
-			c->cmd_type = CMD_SCSI;
-			c->scsi_cmd = cmd;
-			rc = hpsa_scsi_ioaccel_direct_map(h, c);
-			if (rc == 0)
-				return 0; /* Sent on direct map path */
-			if (rc < 0) {   /* scsi_dma_map failed. */
-				cmd_free(h, c);
-				return SCSI_MLQUEUE_HOST_BUSY;
-			}
+		rc = hpsa_ioaccel_submit(h, c, cmd, scsi3addr);
+		if (rc == 0)
+			return 0;
+		if (rc == SCSI_MLQUEUE_HOST_BUSY) {
+			cmd_free(h, c);	/* FIX-ME:  on merge, change to
+					 * cmd_tagged_free(), and ultimately
+					 * to hpsa_cmd_resolve_and_free(). */
+			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 	}
 	return hpsa_ciss_submit(h, c, cmd, scsi3addr);

