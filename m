From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 24/48] hpsa: do not queue commands internally in driver
Date: Fri, 23 Jan 2015 16:43:09 -0600
Message-ID: <20150123224309.14919.3720.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:39311 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbAWWoD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:44:03 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

By not doing maintaining a list of queued commands, we can eliminate some spin
locking in the main i/o path and gain significant improvement in IOPS.  Remove
the queuing code and the code that calls it; remove now-unused interrupt code;
remove DIRECT_LOOKUP_BIT.

Now that the passthru commands share the same command pool as
the main i/o path, and the total size of the pool is less than
or equal to the number of commands that will fit in the hardware
fifo, there is no need to check to see if we are exceeding the
hardware fifo's depth.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  306 +++++------------------------------------------
 drivers/scsi/hpsa.h     |   17 ---
 drivers/scsi/hpsa_cmd.h |   10 --
 3 files changed, 38 insertions(+), 295 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 26e3e5b..70f07af 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -196,8 +196,6 @@ static int number_of_controllers;
 static irqreturn_t do_hpsa_intr_intx(int irq, void *dev_id);
 static irqreturn_t do_hpsa_intr_msi(int irq, void *dev_id);
 static int hpsa_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
-static void lock_and_start_io(struct ctlr_info *h);
-static void start_io(struct ctlr_info *h, unsigned long *flags);
 
 #ifdef CONFIG_COMPAT
 static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd,
@@ -689,13 +687,6 @@ static struct scsi_host_template hpsa_driver_template = {
 	.no_write_same = 1,
 };
 
-
-/* Enqueuing and dequeuing functions for cmdlists. */
-static inline void addQ(struct list_head *list, struct CommandList *c)
-{
-	list_add_tail(&c->list, list);
-}
-
 static inline u32 next_command(struct ctlr_info *h, u8 q)
 {
 	u32 a;
@@ -829,8 +820,6 @@ static void dial_up_lockup_detection_on_fw_flash_complete(struct ctlr_info *h,
 static void enqueue_cmd_and_start_io(struct ctlr_info *h,
 	struct CommandList *c)
 {
-	unsigned long flags;
-
 	switch (c->cmd_type) {
 	case CMD_IOACCEL1:
 		set_ioaccel1_performant_mode(h, c);
@@ -842,18 +831,8 @@ static void enqueue_cmd_and_start_io(struct ctlr_info *h,
 		set_performant_mode(h, c);
 	}
 	dial_down_lockup_detection_during_fw_flash(h, c);
-	spin_lock_irqsave(&h->lock, flags);
-	addQ(&h->reqQ, c);
-	h->Qdepth++;
-	start_io(h, &flags);
-	spin_unlock_irqrestore(&h->lock, flags);
-}
-
-static inline void removeQ(struct CommandList *c)
-{
-	if (WARN_ON(list_empty(&c->list)))
-		return;
-	list_del_init(&c->list);
+	atomic_inc(&h->commands_outstanding);
+	h->access.submit_command(h, c);
 }
 
 static inline int is_hba_lunid(unsigned char scsi3addr[])
@@ -3449,8 +3428,7 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 	set_encrypt_ioaccel2(h, c, cp);
 
 	cp->scsi_nexus = cpu_to_le32(ioaccel_handle);
-	cp->Tag = cpu_to_le32(c->cmdindex << DIRECT_LOOKUP_SHIFT |
-				DIRECT_LOOKUP_BIT);
+	cp->Tag = cpu_to_le32(c->cmdindex << DIRECT_LOOKUP_SHIFT);
 	memcpy(cp->cdb, cdb, sizeof(cp->cdb));
 
 	/* fill in sg elements */
@@ -3831,10 +3809,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 						dev->scsi3addr);
 }
 
-/*
- * Running in struct Scsi_Host->host_lock less mode using LLD internal
- * struct ctlr_info *h->lock w/ spin_lock_irqsave() protection.
- */
+/* Running in struct Scsi_Host->host_lock less mode */
 static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 {
 	struct ctlr_info *h;
@@ -3898,8 +3873,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	c->Header.ReplyQueue = 0;  /* unused in simple mode */
 	memcpy(&c->Header.LUN.LunAddrBytes[0], &scsi3addr[0], 8);
-	c->Header.tag = cpu_to_le64((c->cmdindex << DIRECT_LOOKUP_SHIFT) |
-					DIRECT_LOOKUP_BIT);
+	c->Header.tag = cpu_to_le64((c->cmdindex << DIRECT_LOOKUP_SHIFT));
 
 	/* Fill in the request block... */
 
@@ -4264,56 +4238,6 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 	return rc;
 }
 
-/*
- * hpsa_find_cmd_in_queue
- *
- * Used to determine whether a command (find) is still present
- * in queue_head.   Optionally excludes the last element of queue_head.
- *
- * This is used to avoid unnecessary aborts.  Commands in h->reqQ have
- * not yet been submitted, and so can be aborted by the driver without
- * sending an abort to the hardware.
- *
- * Returns pointer to command if found in queue, NULL otherwise.
- */
-static struct CommandList *hpsa_find_cmd_in_queue(struct ctlr_info *h,
-			struct scsi_cmnd *find, struct list_head *queue_head)
-{
-	unsigned long flags;
-	struct CommandList *c = NULL;	/* ptr into cmpQ */
-
-	if (!find)
-		return NULL;
-	spin_lock_irqsave(&h->lock, flags);
-	list_for_each_entry(c, queue_head, list) {
-		if (c->scsi_cmd == NULL) /* e.g.: passthru ioctl */
-			continue;
-		if (c->scsi_cmd == find) {
-			spin_unlock_irqrestore(&h->lock, flags);
-			return c;
-		}
-	}
-	spin_unlock_irqrestore(&h->lock, flags);
-	return NULL;
-}
-
-static struct CommandList *hpsa_find_cmd_in_queue_by_tag(struct ctlr_info *h,
-					u8 *tag, struct list_head *queue_head)
-{
-	unsigned long flags;
-	struct CommandList *c;
-
-	spin_lock_irqsave(&h->lock, flags);
-	list_for_each_entry(c, queue_head, list) {
-		if (memcmp(&c->Header.tag, tag, 8) != 0)
-			continue;
-		spin_unlock_irqrestore(&h->lock, flags);
-		return c;
-	}
-	spin_unlock_irqrestore(&h->lock, flags);
-	return NULL;
-}
-
 /* ioaccel2 path firmware cannot handle abort task requests.
  * Change abort requests to physical target reset, and send to the
  * address of the physical disk used for the ioaccel 2 command.
@@ -4400,10 +4324,6 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 static int hpsa_send_abort_both_ways(struct ctlr_info *h,
 	unsigned char *scsi3addr, struct CommandList *abort)
 {
-	u8 swizzled_tag[8];
-	struct CommandList *c;
-	int rc = 0, rc2 = 0;
-
 	/* ioccelerator mode 2 commands should be aborted via the
 	 * accelerated path, since RAID path is unaware of these commands,
 	 * but underlying firmware can't handle abort TMF.
@@ -4412,27 +4332,8 @@ static int hpsa_send_abort_both_ways(struct ctlr_info *h,
 	if (abort->cmd_type == CMD_IOACCEL2)
 		return hpsa_send_reset_as_abort_ioaccel2(h, scsi3addr, abort);
 
-	/* we do not expect to find the swizzled tag in our queue, but
-	 * check anyway just to be sure the assumptions which make this
-	 * the case haven't become wrong.
-	 */
-	memcpy(swizzled_tag, &abort->Request.CDB[4], 8);
-	swizzle_abort_tag(swizzled_tag);
-	c = hpsa_find_cmd_in_queue_by_tag(h, swizzled_tag, &h->cmpQ);
-	if (c != NULL) {
-		dev_warn(&h->pdev->dev, "Unexpectedly found byte-swapped tag in completion queue.\n");
-		return hpsa_send_abort(h, scsi3addr, abort, 0);
-	}
-	rc = hpsa_send_abort(h, scsi3addr, abort, 0);
-
-	/* if the command is still in our queue, we can't conclude that it was
-	 * aborted (it might have just completed normally) but in any case
-	 * we don't need to try to abort it another way.
-	 */
-	c = hpsa_find_cmd_in_queue(h, abort->scsi_cmd, &h->cmpQ);
-	if (c)
-		rc2 = hpsa_send_abort(h, scsi3addr, abort, 1);
-	return rc && rc2;
+	return hpsa_send_abort(h, scsi3addr, abort, 0) &&
+			hpsa_send_abort(h, scsi3addr, abort, 1);
 }
 
 /* Send an abort for the specified command.
@@ -4446,7 +4347,6 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	struct ctlr_info *h;
 	struct hpsa_scsi_dev_t *dev;
 	struct CommandList *abort; /* pointer to command to be aborted */
-	struct CommandList *found;
 	struct scsi_cmnd *as;	/* ptr to scsi cmd inside aborted command. */
 	char msg[256];		/* For debug messaging. */
 	int ml = 0;
@@ -4492,28 +4392,6 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	dev_dbg(&h->pdev->dev, "%s\n", msg);
 	dev_warn(&h->pdev->dev, "Abort request on C%d:B%d:T%d:L%d\n",
 		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
-
-	/* Search reqQ to See if command is queued but not submitted,
-	 * if so, complete the command with aborted status and remove
-	 * it from the reqQ.
-	 */
-	found = hpsa_find_cmd_in_queue(h, sc, &h->reqQ);
-	if (found) {
-		found->err_info->CommandStatus = CMD_ABORTED;
-		finish_cmd(found);
-		dev_info(&h->pdev->dev, "%s Request SUCCEEDED (driver queue).\n",
-				msg);
-		return SUCCESS;
-	}
-
-	/* not in reqQ, if also not in cmpQ, must have already completed */
-	found = hpsa_find_cmd_in_queue(h, sc, &h->cmpQ);
-	if (!found)  {
-		dev_dbg(&h->pdev->dev, "%s Request SUCCEEDED (not known to driver).\n",
-				msg);
-		return SUCCESS;
-	}
-
 	/*
 	 * Command is in flight, or possibly already completed
 	 * by the firmware (but not to the scsi mid layer) but we can't
@@ -4536,10 +4414,12 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 */
 #define ABORT_COMPLETE_WAIT_SECS 30
 	for (i = 0; i < ABORT_COMPLETE_WAIT_SECS * 10; i++) {
-		found = hpsa_find_cmd_in_queue(h, sc, &h->cmpQ);
-		if (!found)
+		if (test_bit(abort->cmdindex & (BITS_PER_LONG - 1),
+				h->cmd_pool_bits +
+				(abort->cmdindex / BITS_PER_LONG)))
+			msleep(100);
+		else
 			return SUCCESS;
-		msleep(100);
 	}
 	dev_warn(&h->pdev->dev, "%s FAILED. Aborted command has not completed after %d seconds.\n",
 		msg, ABORT_COMPLETE_WAIT_SECS);
@@ -4588,8 +4468,8 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 
 	c = h->cmd_pool + i;
 	memset(c, 0, sizeof(*c));
-	cmd_dma_handle = h->cmd_pool_dhandle
-	    + i * sizeof(*c);
+	c->Header.tag = cpu_to_le64((u64) i << DIRECT_LOOKUP_SHIFT);
+	cmd_dma_handle = h->cmd_pool_dhandle + i * sizeof(*c);
 	c->err_info = h->errinfo_pool + i;
 	memset(c->err_info, 0, sizeof(*c->err_info));
 	err_dma_handle = h->errinfo_pool_dhandle
@@ -4597,7 +4477,6 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 
 	c->cmdindex = i;
 
-	INIT_LIST_HEAD(&c->list);
 	c->busaddr = (u32) cmd_dma_handle;
 	temp64.val = (u64) err_dma_handle;
 	c->ErrDesc.Addr = cpu_to_le64(err_dma_handle);
@@ -4811,8 +4690,6 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		c->Header.SGTotal = cpu_to_le16(0);
 	}
 	memcpy(&c->Header.LUN, &iocommand.LUN_info, sizeof(c->Header.LUN));
-	/* use the kernel address the cmd block for tag */
-	c->Header.tag = cpu_to_le64(c->busaddr);
 
 	/* Fill in Request block */
 	memcpy(&c->Request, &iocommand.Request,
@@ -4941,7 +4818,6 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	c->Header.SGList = (u8) sg_used;
 	c->Header.SGTotal = cpu_to_le16(sg_used);
 	memcpy(&c->Header.LUN, &ioc->LUN_info, sizeof(c->Header.LUN));
-	c->Header.tag = cpu_to_le64(c->busaddr);
 	memcpy(&c->Request, &ioc->Request, sizeof(c->Request));
 	if (ioc->buf_size > 0) {
 		int i;
@@ -5114,7 +4990,6 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 		c->Header.SGList = 0;
 		c->Header.SGTotal = cpu_to_le16(0);
 	}
-	c->Header.tag = cpu_to_le64(c->busaddr);
 	memcpy(c->Header.LUN.LunAddrBytes, scsi3addr, 8);
 
 	if (cmd_type == TYPE_CMD) {
@@ -5272,47 +5147,6 @@ static void __iomem *remap_pci_mem(ulong base, ulong size)
 	return page_remapped ? (page_remapped + page_offs) : NULL;
 }
 
-/* Takes cmds off the submission queue and sends them to the hardware,
- * then puts them on the queue of cmds waiting for completion.
- * Assumes h->lock is held
- */
-static void start_io(struct ctlr_info *h, unsigned long *flags)
-{
-	struct CommandList *c;
-
-	while (!list_empty(&h->reqQ)) {
-		c = list_entry(h->reqQ.next, struct CommandList, list);
-		/* can't do anything if fifo is full */
-		if ((h->access.fifo_full(h))) {
-			h->fifo_recently_full = 1;
-			dev_warn(&h->pdev->dev, "fifo full\n");
-			break;
-		}
-		h->fifo_recently_full = 0;
-
-		/* Get the first entry from the Request Q */
-		removeQ(c);
-		h->Qdepth--;
-
-		/* Put job onto the completed Q */
-		addQ(&h->cmpQ, c);
-		atomic_inc(&h->commands_outstanding);
-		spin_unlock_irqrestore(&h->lock, *flags);
-		/* Tell the controller execute command */
-		h->access.submit_command(h, c);
-		spin_lock_irqsave(&h->lock, *flags);
-	}
-}
-
-static void lock_and_start_io(struct ctlr_info *h)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&h->lock, flags);
-	start_io(h, &flags);
-	spin_unlock_irqrestore(&h->lock, flags);
-}
-
 static inline unsigned long get_next_completion(struct ctlr_info *h, u8 q)
 {
 	return h->access.command_completed(h, q);
@@ -5341,53 +5175,12 @@ static inline int bad_tag(struct ctlr_info *h, u32 tag_index,
 
 static inline void finish_cmd(struct CommandList *c)
 {
-	unsigned long flags;
-	int io_may_be_stalled = 0;
-	struct ctlr_info *h = c->h;
-	int count;
-
-	spin_lock_irqsave(&h->lock, flags);
-	removeQ(c);
-
-	/*
-	 * Check for possibly stalled i/o.
-	 *
-	 * If a fifo_full condition is encountered, requests will back up
-	 * in h->reqQ.  This queue is only emptied out by start_io which is
-	 * only called when a new i/o request comes in.  If no i/o's are
-	 * forthcoming, the i/o's in h->reqQ can get stuck.  So we call
-	 * start_io from here if we detect such a danger.
-	 *
-	 * Normally, we shouldn't hit this case, but pounding on the
-	 * CCISS_PASSTHRU ioctl can provoke it.  Only call start_io if
-	 * commands_outstanding is low.  We want to avoid calling
-	 * start_io from in here as much as possible, and esp. don't
-	 * want to get in a cycle where we call start_io every time
-	 * through here.
-	 */
-	count = atomic_read(&h->commands_outstanding);
-	spin_unlock_irqrestore(&h->lock, flags);
-	if (unlikely(h->fifo_recently_full) && count < 5)
-		io_may_be_stalled = 1;
-
 	dial_up_lockup_detection_on_fw_flash_complete(c->h, c);
 	if (likely(c->cmd_type == CMD_IOACCEL1 || c->cmd_type == CMD_SCSI
 			|| c->cmd_type == CMD_IOACCEL2))
 		complete_scsi_command(c);
 	else if (c->cmd_type == CMD_IOCTL_PEND)
 		complete(c->waiting);
-	if (unlikely(io_may_be_stalled))
-		lock_and_start_io(h);
-}
-
-static inline u32 hpsa_tag_contains_index(u32 tag)
-{
-	return tag & DIRECT_LOOKUP_BIT;
-}
-
-static inline u32 hpsa_tag_to_index(u32 tag)
-{
-	return tag >> DIRECT_LOOKUP_SHIFT;
 }
 
 
@@ -5407,34 +5200,13 @@ static inline void process_indexed_cmd(struct ctlr_info *h,
 	u32 tag_index;
 	struct CommandList *c;
 
-	tag_index = hpsa_tag_to_index(raw_tag);
+	tag_index = raw_tag >> DIRECT_LOOKUP_SHIFT;
 	if (!bad_tag(h, tag_index, raw_tag)) {
 		c = h->cmd_pool + tag_index;
 		finish_cmd(c);
 	}
 }
 
-/* process completion of a non-indexed command */
-static inline void process_nonindexed_cmd(struct ctlr_info *h,
-	u32 raw_tag)
-{
-	u32 tag;
-	struct CommandList *c = NULL;
-	unsigned long flags;
-
-	tag = hpsa_tag_discard_error_bits(h, raw_tag);
-	spin_lock_irqsave(&h->lock, flags);
-	list_for_each_entry(c, &h->cmpQ, list) {
-		if ((c->busaddr & 0xFFFFFFE0) == (tag & 0xFFFFFFE0)) {
-			spin_unlock_irqrestore(&h->lock, flags);
-			finish_cmd(c);
-			return;
-		}
-	}
-	spin_unlock_irqrestore(&h->lock, flags);
-	bad_tag(h, h->nr_cmds + 1, raw_tag);
-}
-
 /* Some controllers, like p400, will give us one interrupt
  * after a soft reset, even if we turned interrupts off.
  * Only need to check for this in the hpsa_xxx_discard_completions
@@ -5512,10 +5284,7 @@ static irqreturn_t do_hpsa_intr_intx(int irq, void *queue)
 	while (interrupt_pending(h)) {
 		raw_tag = get_next_completion(h, q);
 		while (raw_tag != FIFO_EMPTY) {
-			if (likely(hpsa_tag_contains_index(raw_tag)))
-				process_indexed_cmd(h, raw_tag);
-			else
-				process_nonindexed_cmd(h, raw_tag);
+			process_indexed_cmd(h, raw_tag);
 			raw_tag = next_command(h, q);
 		}
 	}
@@ -5531,10 +5300,7 @@ static irqreturn_t do_hpsa_intr_msi(int irq, void *queue)
 	h->last_intr_timestamp = get_jiffies_64();
 	raw_tag = get_next_completion(h, q);
 	while (raw_tag != FIFO_EMPTY) {
-		if (likely(hpsa_tag_contains_index(raw_tag)))
-			process_indexed_cmd(h, raw_tag);
-		else
-			process_nonindexed_cmd(h, raw_tag);
+		process_indexed_cmd(h, raw_tag);
 		raw_tag = next_command(h, q);
 	}
 	return IRQ_HANDLED;
@@ -6619,14 +6385,16 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 }
 
 /* Called when controller lockup detected. */
-static void fail_all_cmds_on_list(struct ctlr_info *h, struct list_head *list)
+static void fail_all_outstanding_cmds(struct ctlr_info *h)
 {
+	int i;
 	struct CommandList *c = NULL;
 
-	assert_spin_locked(&h->lock);
-	/* Mark all outstanding commands as failed and complete them. */
-	while (!list_empty(list)) {
-		c = list_entry(list->next, struct CommandList, list);
+	for (i = 0; i < h->nr_cmds; i++) {
+		if (!test_bit(i & (BITS_PER_LONG - 1),
+				h->cmd_pool_bits + (i / BITS_PER_LONG)))
+			continue;
+		c = h->cmd_pool + i;
 		c->err_info->CommandStatus = CMD_HARDWARE_ERR;
 		finish_cmd(c);
 	}
@@ -6666,8 +6434,7 @@ static void controller_lockup_detected(struct ctlr_info *h)
 			lockup_detected);
 	pci_disable_device(h->pdev);
 	spin_lock_irqsave(&h->lock, flags);
-	fail_all_cmds_on_list(h, &h->cmpQ);
-	fail_all_cmds_on_list(h, &h->reqQ);
+	fail_all_outstanding_cmds(h);
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
@@ -6859,8 +6626,6 @@ reinit_after_soft_reset:
 
 	h->pdev = pdev;
 	h->intr_mode = hpsa_simple_mode ? SIMPLE_MODE_INT : PERF_MODE_INT;
-	INIT_LIST_HEAD(&h->cmpQ);
-	INIT_LIST_HEAD(&h->reqQ);
 	INIT_LIST_HEAD(&h->offline_device_list);
 	spin_lock_init(&h->lock);
 	spin_lock_init(&h->offline_device_lock);
@@ -7296,8 +7061,7 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 			cp->timeout_sec = 0;
 			cp->ReplyQueue = 0;
 			cp->tag =
-				cpu_to_le64((i << DIRECT_LOOKUP_SHIFT) |
-						DIRECT_LOOKUP_BIT);
+				cpu_to_le64((i << DIRECT_LOOKUP_SHIFT));
 			cp->host_addr =
 				cpu_to_le64(h->ioaccel_cmd_pool_dhandle +
 					(i * sizeof(struct io_accel1_cmd)));
@@ -7472,19 +7236,19 @@ static int is_accelerated_cmd(struct CommandList *c)
 static void hpsa_drain_accel_commands(struct ctlr_info *h)
 {
 	struct CommandList *c = NULL;
-	unsigned long flags;
-	int accel_cmds_out;
+	int i, accel_cmds_out;
 
-	do { /* wait for all outstanding commands to drain out */
+	do { /* wait for all outstanding ioaccel commands to drain out */
 		accel_cmds_out = 0;
-		spin_lock_irqsave(&h->lock, flags);
-		list_for_each_entry(c, &h->cmpQ, list)
-			accel_cmds_out += is_accelerated_cmd(c);
-		list_for_each_entry(c, &h->reqQ, list)
+		for (i = 0; i < h->nr_cmds; i++) {
+			if (!test_bit(i & (BITS_PER_LONG - 1),
+					h->cmd_pool_bits + (i / BITS_PER_LONG)))
+				continue;
+			c = h->cmd_pool + i;
 			accel_cmds_out += is_accelerated_cmd(c);
-		spin_unlock_irqrestore(&h->lock, flags);
+		}
 		if (accel_cmds_out <= 0)
-			break;
+				break;
 		msleep(100);
 	} while (1);
 }
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 06c9e43..e7d7eaa 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -32,7 +32,6 @@ struct access_method {
 	void (*submit_command)(struct ctlr_info *h,
 		struct CommandList *c);
 	void (*set_intr_mask)(struct ctlr_info *h, unsigned long val);
-	unsigned long (*fifo_full)(struct ctlr_info *h);
 	bool (*intr_pending)(struct ctlr_info *h);
 	unsigned long (*command_completed)(struct ctlr_info *h, u8 q);
 };
@@ -133,8 +132,6 @@ struct ctlr_info {
 	char hba_mode_enabled;
 
 	/* queue and queue Info */
-	struct list_head reqQ;
-	struct list_head cmpQ;
 	unsigned int Qdepth;
 	unsigned int maxSG;
 	spinlock_t lock;
@@ -197,7 +194,6 @@ struct ctlr_info {
 	u32 __percpu *lockup_detected;
 	struct delayed_work monitor_ctlr_work;
 	int remove_in_progress;
-	u32 fifo_recently_full;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
 	u8 q[MAX_REPLY_QUEUES];
 	u32 TMFSupportFlags; /* cache what task mgmt funcs are supported. */
@@ -428,14 +424,6 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
 }
 
 /*
- *  Returns true if fifo is full.
- *
- */
-static unsigned long SA5_fifo_full(struct ctlr_info *h)
-{
-	return atomic_read(&h->commands_outstanding) >= h->max_commands;
-}
-/*
  *   returns value read from hardware.
  *     returns FIFO_EMPTY if there is nothing to read
  */
@@ -527,7 +515,6 @@ static unsigned long SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
 static struct access_method SA5_access = {
 	SA5_submit_command,
 	SA5_intr_mask,
-	SA5_fifo_full,
 	SA5_intr_pending,
 	SA5_completed,
 };
@@ -535,7 +522,6 @@ static struct access_method SA5_access = {
 static struct access_method SA5_ioaccel_mode1_access = {
 	SA5_submit_command,
 	SA5_performant_intr_mask,
-	SA5_fifo_full,
 	SA5_ioaccel_mode1_intr_pending,
 	SA5_ioaccel_mode1_completed,
 };
@@ -543,7 +529,6 @@ static struct access_method SA5_ioaccel_mode1_access = {
 static struct access_method SA5_ioaccel_mode2_access = {
 	SA5_submit_command_ioaccel2,
 	SA5_performant_intr_mask,
-	SA5_fifo_full,
 	SA5_performant_intr_pending,
 	SA5_performant_completed,
 };
@@ -551,7 +536,6 @@ static struct access_method SA5_ioaccel_mode2_access = {
 static struct access_method SA5_performant_access = {
 	SA5_submit_command,
 	SA5_performant_intr_mask,
-	SA5_fifo_full,
 	SA5_performant_intr_pending,
 	SA5_performant_completed,
 };
@@ -559,7 +543,6 @@ static struct access_method SA5_performant_access = {
 static struct access_method SA5_performant_access_no_read = {
 	SA5_submit_command_no_read,
 	SA5_performant_intr_mask,
-	SA5_fifo_full,
 	SA5_performant_intr_pending,
 	SA5_performant_completed,
 };
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 9bae50c..d78e666 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -375,22 +375,19 @@ struct ErrorInfo {
 #define CMD_IOACCEL1	0x04
 #define CMD_IOACCEL2	0x05
 
-#define DIRECT_LOOKUP_SHIFT 5
-#define DIRECT_LOOKUP_BIT 0x10
+#define DIRECT_LOOKUP_SHIFT 4
 #define DIRECT_LOOKUP_MASK (~((1 << DIRECT_LOOKUP_SHIFT) - 1))
 
 #define HPSA_ERROR_BIT          0x02
 struct ctlr_info; /* defined in hpsa.h */
-/* The size of this structure needs to be divisible by 32
- * on all architectures because low 5 bits of the addresses
+/* The size of this structure needs to be divisible by 128
+ * on all architectures.  The low 4 bits of the addresses
  * are used as follows:
  *
  * bit 0: to device, used to indicate "performant mode" command
  *        from device, indidcates error status.
  * bit 1-3: to device, indicates block fetch table entry for
  *          reducing DMA in fetching commands from host memory.
- * bit 4: used to indicate whether tag is "direct lookup" (index),
- *        or a bus address.
  */
 
 #define COMMANDLIST_ALIGNMENT 128
@@ -405,7 +402,6 @@ struct CommandList {
 	struct ctlr_info	   *h;
 	int			   cmd_type;
 	long			   cmdindex;
-	struct list_head list;
 	struct completion *waiting;
 	void   *scsi_cmd;
 } __aligned(COMMANDLIST_ALIGNMENT);

