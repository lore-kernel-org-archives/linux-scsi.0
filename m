From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 27/48] hpsa: use workqueue to resubmit failed ioaccel
 commands
Date: Fri, 23 Jan 2015 16:43:25 -0600
Message-ID: <20150123224325.14919.4991.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:39513 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbbAWWoT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:44:19 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
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
 drivers/scsi/hpsa.c     |   72 ++++++++++++++++++++++++++++++++++-------------
 drivers/scsi/hpsa.h     |    1 +
 drivers/scsi/hpsa_cmd.h |    1 +
 3 files changed, 54 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cc3128f..dcacb29 100644
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
+	queue_work_on(raw_smp_processor_id(), h->resubmit_wq, &c->work);
 }
 
 static void complete_scsi_command(struct CommandList *cp)
@@ -1723,9 +1721,9 @@ static void complete_scsi_command(struct CommandList *cp)
 		if (is_logical_dev_addr_mode(dev->scsi3addr)) {
 			if (ei->CommandStatus == CMD_IOACCEL_DISABLED)
 				dev->offload_enabled = 0;
-			cmd->result = DID_SOFT_ERROR << 16;
-			cmd_free(h, cp);
-			cmd->scsi_done(cmd);
+			INIT_WORK(&cp->work, hpsa_command_resubmit_worker);
+			queue_work_on(raw_smp_processor_id(),
+					h->resubmit_wq, &cp->work);
 			return;
 		}
 	}
@@ -3873,6 +3871,31 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
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
@@ -6396,6 +6419,7 @@ static void fail_all_outstanding_cmds(struct ctlr_info *h)
 	int i;
 	struct CommandList *c = NULL;
 
+	flush_workqueue(h->resubmit_wq); /* ensure all cmds are fully built */
 	for (i = 0; i < h->nr_cmds; i++) {
 		if (!test_bit(i & (BITS_PER_LONG - 1),
 				h->cmd_pool_bits + (i / BITS_PER_LONG)))
@@ -6631,6 +6655,12 @@ reinit_after_soft_reset:
 	spin_lock_init(&h->scan_lock);
 	spin_lock_init(&h->passthru_count_lock);
 
+	h->resubmit_wq = alloc_workqueue("hpsa", WQ_MEM_RECLAIM, 0);
+	if (!h->resubmit_wq) {
+		dev_err(&h->pdev->dev, "Failed to allocate work queue\n");
+		rc = -ENOMEM;
+		goto clean1;
+	}
 	/* Allocate and clear per-cpu variable lockup_detected */
 	h->lockup_detected = alloc_percpu(u32);
 	if (!h->lockup_detected) {
@@ -6763,6 +6793,8 @@ clean2_and_free_irqs:
 	hpsa_free_irqs(h);
 clean2:
 clean1:
+	if (h->resubmit_wq)
+		destroy_workqueue(h->resubmit_wq);
 	if (h->lockup_detected)
 		free_percpu(h->lockup_detected);
 	kfree(h);
@@ -6838,9 +6870,9 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	h->remove_in_progress = 1;
 	cancel_delayed_work(&h->monitor_ctlr_work);
 	spin_unlock_irqrestore(&h->lock, flags);
-
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 	hpsa_shutdown(pdev);
+	destroy_workqueue(h->resubmit_wq);
 	iounmap(h->vaddr);
 	iounmap(h->transtable);
 	iounmap(h->cfgtable);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 06a3e81..a0f4268 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -236,6 +236,7 @@ struct ctlr_info {
 	struct list_head offline_device_list;
 	int	acciopath_status;
 	int	raid_offload_debug;
+	struct workqueue_struct *resubmit_wq;
 };
 
 struct offline_device_entry {
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

