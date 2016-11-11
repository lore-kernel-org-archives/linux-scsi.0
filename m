From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] hpsa: scsi-mq support
Date: Fri, 11 Nov 2016 16:46:34 +0100
Message-ID: <1478879194-32529-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55723 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932954AbcKKPqj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 10:46:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

This patch enables full scsi-mq support for the hpsa driver.
Due to some reports of performance regressions this patch
also adds a parameter 'use_blk_mq' which can be used to
disable multiqueue support if required.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 64 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0df0e04..ef4e81a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -91,6 +91,9 @@
 MODULE_PARM_DESC(hpsa_simple_mode,
 	"Use 'simple mode' rather than 'performant mode'");
 
+bool use_blk_mq = true;
+module_param(use_blk_mq, bool, 0);
+
 /* define the PCI info for the cards we can control */
 static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
@@ -1137,12 +1140,13 @@ static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
 	}
 }
 
-static void enqueue_cmd_and_start_io(struct ctlr_info *h, struct CommandList *c)
+static void enqueue_cmd_and_start_io(struct ctlr_info *h,
+				     struct CommandList *c, int reply_queue)
 {
 	if (unlikely(hpsa_is_pending_event(c)))
 		return finish_cmd(c);
 
-	__enqueue_cmd_and_start_io(h, c, DEFAULT_REPLY_QUEUE);
+	__enqueue_cmd_and_start_io(h, c, reply_queue);
 }
 
 static inline int is_hba_lunid(unsigned char scsi3addr[])
@@ -4614,6 +4618,7 @@ static int hpsa_scsi_ioaccel1_queue_command(struct ctlr_info *h,
 	int use_sg, i;
 	struct SGDescriptor *curr_sg;
 	u32 control = IOACCEL1_CONTROL_SIMPLEQUEUE;
+	int reply_queue = DEFAULT_REPLY_QUEUE;
 
 	/* TODO: implement chaining support */
 	if (scsi_sg_count(cmd) > h->ioaccel_maxsg) {
@@ -4683,8 +4688,12 @@ static int hpsa_scsi_ioaccel1_queue_command(struct ctlr_info *h,
 	cp->control = cpu_to_le32(control);
 	memcpy(cp->CDB, cdb, cdb_len);
 	memcpy(cp->CISS_LUN, scsi3addr, 8);
+	if (shost_use_blk_mq(cmd->device->host)) {
+		u32 blk_tag = blk_mq_unique_tag(cmd->request);
+		reply_queue = blk_mq_unique_tag_to_hwq(blk_tag);
+	}
 	/* Tag was already set at init time. */
-	enqueue_cmd_and_start_io(h, c);
+	enqueue_cmd_and_start_io(h, c, reply_queue);
 	return 0;
 }
 
@@ -4778,6 +4787,7 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 	u64 addr64;
 	u32 len;
 	u32 total_len = 0;
+	int reply_queue = DEFAULT_REPLY_QUEUE;
 
 	if (!cmd->device)
 		return -1;
@@ -4882,7 +4892,11 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 	} else
 		cp->sg_count = (u8) use_sg;
 
-	enqueue_cmd_and_start_io(h, c);
+	if (shost_use_blk_mq(cmd->device->host)) {
+		u32 blk_tag = blk_mq_unique_tag(cmd->request);
+		reply_queue = blk_mq_unique_tag_to_hwq(blk_tag);
+	}
+	enqueue_cmd_and_start_io(h, c, reply_queue);
 	return 0;
 }
 
@@ -5284,6 +5298,8 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
 	struct CommandList *c, struct scsi_cmnd *cmd,
 	unsigned char scsi3addr[])
 {
+	int reply_queue = DEFAULT_REPLY_QUEUE;
+
 	cmd->host_scribble = (unsigned char *) c;
 	c->cmd_type = CMD_SCSI;
 	c->scsi_cmd = cmd;
@@ -5339,7 +5355,11 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
 		hpsa_cmd_resolve_and_free(h, c);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
-	enqueue_cmd_and_start_io(h, c);
+	if (shost_use_blk_mq(cmd->device->host)) {
+		u32 blk_tag = blk_mq_unique_tag(cmd->request);
+		reply_queue = blk_mq_unique_tag_to_hwq(blk_tag);
+	}
+	enqueue_cmd_and_start_io(h, c, reply_queue);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
 	return 0;
 }
@@ -5642,13 +5662,23 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 static int hpsa_scsi_add_host(struct ctlr_info *h)
 {
 	int rv;
+	struct Scsi_Host *sh = h->scsi_host;
 
-	rv = scsi_add_host(h->scsi_host, &h->pdev->dev);
+	if (h->intr_mode == PERF_MODE_INT && h->msix_vectors > 0)
+		sh->nr_hw_queues = h->msix_vectors;
+	else
+		sh->nr_hw_queues = 1;
+
+	if (use_blk_mq) {
+		sh->can_queue = sh->can_queue / sh->nr_hw_queues;
+		sh->use_blk_mq = 1;
+	}
+	rv = scsi_add_host(sh, &h->pdev->dev);
 	if (rv) {
 		dev_err(&h->pdev->dev, "scsi_add_host failed\n");
 		return rv;
 	}
-	scsi_scan_host(h->scsi_host);
+	scsi_scan_host(sh);
 	return 0;
 }
 
@@ -5658,10 +5688,20 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
  * an index to select our command block.  (The offset allows us to reserve the
  * low-numbered entries for our own uses.)
  */
-static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
+static int hpsa_get_cmd_index(struct ctlr_info *h, struct scsi_cmnd *scmd)
 {
 	int idx = scmd->request->tag;
 
+	if (shost_use_blk_mq(scmd->device->host)) {
+		u32 blk_tag = blk_mq_unique_tag(scmd->request);
+		u16 hwq = blk_mq_unique_tag_to_hwq(blk_tag);
+		u16 tag = blk_mq_unique_tag_to_tag(blk_tag);
+		int msix_vectors, hwq_size;
+
+		msix_vectors = h->msix_vectors > 0 ? h->msix_vectors : 1;
+		hwq_size = (h->nr_cmds - HPSA_NRESERVED_CMDS) / msix_vectors;
+		idx = (hwq * hwq_size) + tag;
+	}
 	if (idx < 0)
 		return idx;
 
@@ -5811,7 +5851,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	if (lockup_detected(h)) {
 		snprintf(msg, sizeof(msg),
 			 "cmd %d RESET FAILED, lockup detected",
-			 hpsa_get_cmd_index(scsicmd));
+			 hpsa_get_cmd_index(h, scsicmd));
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 		return FAILED;
 	}
@@ -5820,7 +5860,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	if (detect_controller_lockup(h)) {
 		snprintf(msg, sizeof(msg),
 			 "cmd %d RESET FAILED, new lockup detected",
-			 hpsa_get_cmd_index(scsicmd));
+			 hpsa_get_cmd_index(h, scsicmd));
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 		return FAILED;
 	}
@@ -6293,7 +6333,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
 					    struct scsi_cmnd *scmd)
 {
-	int idx = hpsa_get_cmd_index(scmd);
+	int idx = hpsa_get_cmd_index(h, scmd);
 	struct CommandList *c = h->cmd_pool + idx;
 
 	if (idx < HPSA_NRESERVED_CMDS || idx >= h->nr_cmds) {
@@ -6857,7 +6897,7 @@ static void hpsa_send_host_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 		RAID_CTLR_LUNID, TYPE_MSG);
 	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to target reset */
 	c->waiting = NULL;
-	enqueue_cmd_and_start_io(h, c);
+	enqueue_cmd_and_start_io(h, c, DEFAULT_REPLY_QUEUE);
 	/* Don't wait for completion, the reset won't complete.  Don't free
 	 * the command either.  This is the last command we will send before
 	 * re-initializing everything, so it doesn't matter and won't leak.
-- 
1.8.5.6

