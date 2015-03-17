From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 37/42] hpsa: use block layer tag for command allocation
Date: Tue, 17 Mar 2015 15:06:51 -0500
Message-ID: <20150317200651.19856.77450.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42597 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbbCQUIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:08:31 -0400
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id B74036423F
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:08:30 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Rework slave allocation:
  - separate the tagging support setup from the hostdata setup
  - make the hostdata setup act consistently when the lookup fails
  - make the hostdata setup act consistently when the device is not added
  - set up the queue depth consistently across these scenarios
  - if the block layer mq support is not available, explicitly enable and
    activate the SCSI layer tcq support (and do this at allocation-time so
    that the tags will be available for INQUIRY commands)

Tweak slave configuration so that devices which are masked are also
not attached.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  153 +++++++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/hpsa.h |    1 
 2 files changed, 123 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 34c178c..4e34a62 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -44,6 +44,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_dbg.h>
 #include <linux/cciss_ioctl.h>
 #include <linux/string.h>
 #include <linux/bitmap.h>
@@ -212,6 +213,9 @@ static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd,
 
 static void cmd_free(struct ctlr_info *h, struct CommandList *c);
 static struct CommandList *cmd_alloc(struct ctlr_info *h);
+static void cmd_tagged_free(struct ctlr_info *h, struct CommandList *c);
+static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
+					    struct scsi_cmnd *scmd);
 static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, u16 page_code, unsigned char *scsi3addr,
 	int cmd_type);
@@ -2047,11 +2051,17 @@ static void hpsa_cmd_resolve_events(struct ctlr_info *h,
 	}
 }
 
+static void hpsa_cmd_resolve_and_free(struct ctlr_info *h,
+				      struct CommandList *c)
+{
+	hpsa_cmd_resolve_events(h, c);
+	cmd_tagged_free(h, c);
+}
+
 static void hpsa_cmd_free_and_done(struct ctlr_info *h,
 		struct CommandList *c, struct scsi_cmnd *cmd)
 {
-	hpsa_cmd_resolve_events(h, c);
-	cmd_free(h, c);
+	hpsa_cmd_resolve_and_free(h, c);
 	cmd->scsi_done(cmd);
 }
 
@@ -2072,8 +2082,7 @@ static void hpsa_cmd_abort_and_free(struct ctlr_info *h, struct CommandList *c,
 	hpsa_set_scsi_cmd_aborted(cmd);
 	dev_warn(&h->pdev->dev, "CDB %16phN was aborted with status 0x%x\n",
 			 c->Request.CDB, c->err_info->ScsiStatus);
-	hpsa_cmd_resolve_events(h, c);
-	cmd_free(h, c);		/* FIX-ME:  change to cmd_tagged_free(h, c) */
+	hpsa_cmd_resolve_and_free(h, c);
 }
 
 static void process_ioaccel2_completion(struct ctlr_info *h,
@@ -4535,7 +4544,7 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
 	}
 
 	if (hpsa_scatter_gather(h, c, cmd) < 0) { /* Fill SG list */
-		cmd_free(h, c);
+		hpsa_cmd_resolve_and_free(h, c);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	enqueue_cmd_and_start_io(h, c);
@@ -4581,6 +4590,8 @@ static inline void hpsa_cmd_partial_init(struct ctlr_info *h, int index,
 {
 	dma_addr_t cmd_dma_handle = h->cmd_pool_dhandle + index * sizeof(*c);
 
+	BUG_ON(c->cmdindex != index);
+
 	memset(c->Request.CDB, 0, sizeof(c->Request.CDB));
 	memset(c->err_info, 0, sizeof(*c->err_info));
 	c->busaddr = (u32) cmd_dma_handle;
@@ -4675,27 +4686,24 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	/* Get the ptr to our adapter structure out of cmd->host. */
 	h = sdev_to_hba(cmd->device);
+
+	BUG_ON(cmd->request->tag < 0);
+
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
 		cmd->scsi_done(cmd);
 		return 0;
 	}
-	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
 
-	if (unlikely(lockup_detected(h))) {
-		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
-		return 0;
-	}
-	c = cmd_alloc(h);
+	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
 
 	if (unlikely(lockup_detected(h))) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd_free(h, c);
 		cmd->scsi_done(cmd);
 		return 0;
 	}
+	c = cmd_tagged_alloc(h, cmd);
 
 	/*
 	 * Call alternate submit routine for I/O accelerated commands.
@@ -4708,7 +4716,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		if (rc == 0)
 			return 0;
 		if (rc == SCSI_MLQUEUE_HOST_BUSY) {
-			cmd_free(h, c);
+			hpsa_cmd_resolve_and_free(h, c);
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 	}
@@ -4822,15 +4830,23 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 	sh->hostdata[0] = (unsigned long) h;
 	sh->irq = h->intr[h->intr_mode];
 	sh->unique_id = sh->irq;
+	error = scsi_init_shared_tag_map(sh, sh->can_queue);
+	if (error) {
+		dev_err(&h->pdev->dev,
+			"%s: scsi_init_shared_tag_map failed for controller %d\n",
+			__func__, h->ctlr);
+		goto fail_host_put;
+	}
 	error = scsi_add_host(sh, &h->pdev->dev);
-	if (error)
+	if (error) {
+		dev_err(&h->pdev->dev, "%s: scsi_add_host failed for controller %d\n",
+			__func__, h->ctlr);
 		goto fail_host_put;
+	}
 	scsi_scan_host(sh);
 	return 0;
 
  fail_host_put:
-	dev_err(&h->pdev->dev, "%s: scsi_add_host"
-		" failed for controller %d\n", __func__, h->ctlr);
 	scsi_host_put(sh);
 	return error;
  fail:
@@ -4840,6 +4856,23 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 }
 
 /*
+ * The block layer has already gone to the trouble of picking out a unique,
+ * small-integer tag for this request.  We use an offset from that value as
+ * an index to select our command block.  (The offset allows us to reserve the
+ * low-numbered entries for our own uses.)
+ */
+static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
+{
+	int idx = scmd->request->tag;
+
+	if (idx < 0)
+		return idx;
+
+	/* Offset to leave space for internal cmds. */
+	return idx += HPSA_NRESERVED_CMDS;
+}
+
+/*
  * Send a TEST_UNIT_READY command to the specified LUN using the specified
  * reply queue; returns zero if the unit is ready, and non-zero otherwise.
  */
@@ -4979,18 +5012,18 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	/* if controller locked up, we can guarantee command won't complete */
 	if (lockup_detected(h)) {
 		dev_warn(&h->pdev->dev,
-			"scsi %d:%d:%d:%d RESET FAILED, lockup detected\n",
-			h->scsi_host->host_no, dev->bus, dev->target,
-			dev->lun);
+			 "scsi %d:%d:%d:%u cmd %d RESET FAILED, lockup detected\n",
+			 h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
+			 hpsa_get_cmd_index(scsicmd));
 		return FAILED;
 	}
 
 	/* this reset request might be the result of a lockup; check */
 	if (detect_controller_lockup(h)) {
 		dev_warn(&h->pdev->dev,
-			 "scsi %d:%d:%d:%d RESET FAILED, new lockup detected\n",
+			 "scsi %d:%d:%d:%u cmd %d RESET FAILED, new lockup detected\n",
 			 h->scsi_host->host_no, dev->bus, dev->target,
-			 dev->lun);
+			 dev->lun, hpsa_get_cmd_index(scsicmd));
 		return FAILED;
 	}
 
@@ -5442,6 +5475,59 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 }
 
 /*
+ * For operations with an associated SCSI command, a command block is allocated
+ * at init, and managed by cmd_tagged_alloc() and cmd_tagged_free() using the
+ * block request tag as an index into a table of entries.  cmd_tagged_free() is
+ * the complement, although cmd_free() may be called instead.
+ */
+static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
+					    struct scsi_cmnd *scmd)
+{
+	int idx = hpsa_get_cmd_index(scmd);
+	struct CommandList *c = h->cmd_pool + idx;
+	int refcount = 0;
+
+	if (idx < HPSA_NRESERVED_CMDS || idx >= h->nr_cmds) {
+		dev_err(&h->pdev->dev, "Bad block tag: %d not in [%d..%d]\n",
+			idx, HPSA_NRESERVED_CMDS, h->nr_cmds - 1);
+		/* The index value comes from the block layer, so if it's out of
+		 * bounds, it's probably not our bug.
+		 */
+		BUG();
+	}
+
+	refcount = atomic_inc_return(&c->refcount);
+	if (unlikely(!hpsa_is_cmd_idle(c))) {
+		/*
+		 * We expect that the SCSI layer will hand us a unique tag
+		 * value.  Thus, there should never be a collision here between
+		 * two requests...because if the selected command isn't idle
+		 * then someone is going to be very disappointed.
+		 */
+		dev_err(&h->pdev->dev,
+			"tag collision (tag=%d) in cmd_tagged_alloc().\n",
+			idx);
+		if (c->scsi_cmd != NULL)
+			scsi_print_command(c->scsi_cmd);
+		scsi_print_command(scmd);
+	}
+
+	hpsa_cmd_partial_init(h, idx, c);
+	return c;
+}
+
+static void cmd_tagged_free(struct ctlr_info *h, struct CommandList *c)
+{
+	/*
+	 * Release our reference to the block.  We don't need to do anything
+	 * else to free it, because it is accessed by index.  (There's no point
+	 * in checking the result of the decrement, since we cannot guarantee
+	 * that there isn't a concurrent abort which is also accessing it.)
+	 */
+	(void)atomic_dec(&c->refcount);
+}
+
+/*
  * For operations that cannot sleep, a command block is allocated at init,
  * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
  * which ones are free or in use.  Lock must be held when calling this.
@@ -5454,7 +5540,6 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 {
 	struct CommandList *c;
 	int refcount, i;
-	unsigned long offset;
 
 	/*
 	 * There is some *extremely* small but non-zero chance that that
@@ -5466,31 +5551,39 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	 * very unlucky thread might be starved anyway, never able to
 	 * beat the other threads.  In reality, this happens so
 	 * infrequently as to be indistinguishable from never.
+	 *
+	 * Note that we start allocating commands before the SCSI host structure
+	 * is initialized.  Since the search starts at bit zero, this
+	 * all works, since we have at least one command structure available;
+	 * however, it means that the structures with the low indexes have to be
+	 * reserved for driver-initiated requests, while requests from the block
+	 * layer will use the higher indexes.
 	 */
 
-	offset = h->last_allocation; /* benignly racy */
 	for (;;) {
-		i = find_next_zero_bit(h->cmd_pool_bits, h->nr_cmds, offset);
-		if (unlikely(i == h->nr_cmds)) {
-			offset = 0;
+		i = find_first_zero_bit(h->cmd_pool_bits, HPSA_NRESERVED_CMDS);
+		if (unlikely(i >= HPSA_NRESERVED_CMDS))
 			continue;
-		}
 		c = h->cmd_pool + i;
 		refcount = atomic_inc_return(&c->refcount);
 		if (unlikely(refcount > 1)) {
 			cmd_free(h, c); /* already in use */
-			offset = (i + 1) % h->nr_cmds;
 			continue;
 		}
 		set_bit(i & (BITS_PER_LONG - 1),
 			h->cmd_pool_bits + (i / BITS_PER_LONG));
 		break; /* it's ours now. */
 	}
-	h->last_allocation = i; /* benignly racy */
 	hpsa_cmd_partial_init(h, i, c);
 	return c;
 }
 
+/*
+ * This is the complementary operation to cmd_alloc().  Note, however, in some
+ * corner cases it may also be used to free blocks allocated by
+ * cmd_tagged_alloc() in which case the ref-count decrement does the trick and
+ * the clear-bit is harmless.
+ */
 static void cmd_free(struct ctlr_info *h, struct CommandList *c)
 {
 	if (atomic_dec_and_test(&c->refcount)) {
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 3ec8934..2536b67 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -141,7 +141,6 @@ struct ctlr_info {
 	struct CfgTable __iomem *cfgtable;
 	int	interrupts_enabled;
 	int 	max_commands;
-	int last_allocation;
 	atomic_t commands_outstanding;
 #	define PERF_MODE_INT	0
 #	define DOORBELL_INT	1

