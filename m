From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 27/42] hpsa: use helper routines for finishing commands
Date: Tue, 17 Mar 2015 15:04:50 -0500
Message-ID: <20150317200450.19856.77364.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42530 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbbCQUGa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:06:30 -0400
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 0477A60B30
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:06:30 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

cleanup command completions

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   78 ++++++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e9642dd..b0949f7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2010,6 +2010,19 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 	return retry;	/* retry on raid path? */
 }
 
+static void hpsa_cmd_free_and_done(struct ctlr_info *h,
+		struct CommandList *c, struct scsi_cmnd *cmd)
+{
+	cmd_free(h, c);
+	cmd->scsi_done(cmd);
+}
+
+static void hpsa_retry_cmd(struct ctlr_info *h, struct CommandList *c)
+{
+	INIT_WORK(&c->work, hpsa_command_resubmit_worker);
+	queue_work_on(raw_smp_processor_id(), h->resubmit_wq, &c->work);
+}
+
 static void process_ioaccel2_completion(struct ctlr_info *h,
 		struct CommandList *c, struct scsi_cmnd *cmd,
 		struct hpsa_scsi_dev_t *dev)
@@ -2018,13 +2031,11 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 
 	/* check for good status */
 	if (likely(c2->error_data.serv_response == 0 &&
-			c2->error_data.status == 0)) {
-		cmd_free(h, c);
-		cmd->scsi_done(cmd);
-		return;
-	}
+			c2->error_data.status == 0))
+		return hpsa_cmd_free_and_done(h, c, cmd);
 
-	/* Any RAID offload error results in retry which will use
+	/*
+	 * Any RAID offload error results in retry which will use
 	 * the normal I/O path so the controller can handle whatever's
 	 * wrong.
 	 */
@@ -2034,19 +2045,14 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 		if (c2->error_data.status ==
 			IOACCEL2_STATUS_SR_IOACCEL_DISABLED)
 			dev->offload_enabled = 0;
-		goto retry_cmd;
+
+		return hpsa_retry_cmd(h, c);
 	}
 
 	if (handle_ioaccel_mode2_error(h, c, cmd, c2))
-		goto retry_cmd;
-
-	cmd_free(h, c);
-	cmd->scsi_done(cmd);
-	return;
+		return hpsa_retry_cmd(h, c);
 
-retry_cmd:
-	INIT_WORK(&c->work, hpsa_command_resubmit_worker);
-	queue_work_on(raw_smp_processor_id(), h->resubmit_wq, &c->work);
+	return hpsa_cmd_free_and_done(h, c, cmd);
 }
 
 /* Returns 0 on success, < 0 otherwise. */
@@ -2119,22 +2125,15 @@ static void complete_scsi_command(struct CommandList *cp)
 	if (unlikely(ei->CommandStatus == CMD_CTLR_LOCKUP)) {
 		/* DID_NO_CONNECT will prevent a retry */
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd_free(h, cp);
-		cmd->scsi_done(cmd);
-		return;
+		return hpsa_cmd_free_and_done(h, cp, cmd);
 	}
 
 	if (cp->cmd_type == CMD_IOACCEL2)
 		return process_ioaccel2_completion(h, cp, cmd, dev);
 
 	scsi_set_resid(cmd, ei->ResidualCnt);
-	if (ei->CommandStatus == 0) {
-		if (cp->cmd_type == CMD_IOACCEL1)
-			atomic_dec(&cp->phys_disk->ioaccel_cmds_out);
-		cmd_free(h, cp);
-		cmd->scsi_done(cmd);
-		return;
-	}
+	if (ei->CommandStatus == 0)
+		return hpsa_cmd_free_and_done(h, cp, cmd);
 
 	/* For I/O accelerator commands, copy over some fields to the normal
 	 * CISS header used below for error handling.
@@ -2156,10 +2155,7 @@ static void complete_scsi_command(struct CommandList *cp)
 		if (is_logical_dev_addr_mode(dev->scsi3addr)) {
 			if (ei->CommandStatus == CMD_IOACCEL_DISABLED)
 				dev->offload_enabled = 0;
-			INIT_WORK(&cp->work, hpsa_command_resubmit_worker);
-			queue_work_on(raw_smp_processor_id(),
-					h->resubmit_wq, &cp->work);
-			return;
+			return hpsa_retry_cmd(h, cp);
 		}
 	}
 
@@ -2290,8 +2286,8 @@ static void complete_scsi_command(struct CommandList *cp)
 		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
 				cp, ei->CommandStatus);
 	}
-	cmd_free(h, cp);
-	cmd->scsi_done(cmd);
+
+	return hpsa_cmd_free_and_done(h, cp, cmd);
 }
 
 static void hpsa_pci_unmap(struct pci_dev *pdev,
@@ -4544,16 +4540,13 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 {
 	struct scsi_cmnd *cmd;
 	struct hpsa_scsi_dev_t *dev;
-	struct CommandList *c =
-			container_of(work, struct CommandList, work);
+	struct CommandList *c = container_of(work, struct CommandList, work);
 
 	cmd = c->scsi_cmd;
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd_free(c->h, c);
-		cmd->scsi_done(cmd);
-		return;
+		return hpsa_cmd_free_and_done(c->h, c, cmd);
 	}
 	if (c->cmd_type == CMD_IOACCEL2) {
 		struct ctlr_info *h = c->h;
@@ -4572,12 +4565,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 				 * then get SCSI_MLQUEUE_HOST_BUSY.
 				 */
 				cmd->result = DID_IMM_RETRY << 16;
-				cmd->scsi_done(cmd);
-				cmd_free(h, c);	/* FIX-ME:  on merge, change
-						 * to cmd_tagged_free() and
-						 * ultimately to
-						 * hpsa_cmd_free_and_done(). */
-				return;
+				return hpsa_cmd_free_and_done(h, c, cmd);
 			}
 			/* else, fall thru and resubmit down CISS path */
 		}
@@ -4641,9 +4629,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		if (rc == 0)
 			return 0;
 		if (rc == SCSI_MLQUEUE_HOST_BUSY) {
-			cmd_free(h, c);	/* FIX-ME:  on merge, change to
-					 * cmd_tagged_free(), and ultimately
-					 * to hpsa_cmd_resolve_and_free(). */
+			cmd_free(h, c);
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 	}
@@ -7761,8 +7747,6 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 	struct CommandList *c;
 	int rc;
 
-	/* Don't bother trying to flush the cache if locked up */
-	/* FIXME not necessary if do_simple_cmd does the check */
 	if (unlikely(lockup_detected(h)))
 		return;
 	flush_buf = kzalloc(4, GFP_KERNEL);

