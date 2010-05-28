From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/6] cciss: clean up interrupt handler
Date: Fri, 28 May 2010 14:58:51 -0500
Message-ID: <20100528195851.GA6989@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:23564 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab0E1TyP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 15:54:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, Steve Cameron <scameron@beardog.cce.hp.com>

Patch 2 of 6
cciss: simplify interrupt handler code

This patch simplifies the interrupt handler code to more closely match hpsa
and to hopefully make it easier to follow.

From: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/block/cciss.c |  236 +++++++++++++++++++++++++++++--------------------
 1 files changed, 141 insertions(+), 95 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6db790c..cae6a13 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -167,7 +167,8 @@ static DEFINE_MUTEX(scan_mutex);
 static LIST_HEAD(scan_q);
 
 static void do_cciss_request(struct request_queue *q);
-static irqreturn_t do_cciss_intr(int irq, void *dev_id);
+static irqreturn_t do_cciss_intx(int irq, void *dev_id);
+static irqreturn_t do_cciss_msix_intr(int irq, void *dev_id);
 static int cciss_open(struct block_device *bdev, fmode_t mode);
 static int cciss_release(struct gendisk *disk, fmode_t mode);
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
@@ -197,7 +198,6 @@ static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c,
 	int attempt_retry);
 static int process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c);
 
-static void fail_all_cmds(unsigned long ctlr);
 static int add_to_scan_list(struct ctlr_info *h);
 static int scan_thread(void *data);
 static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
@@ -3124,6 +3124,34 @@ after_error_processing:
 	blk_complete_request(cmd->rq);
 }
 
+static inline u32 cciss_tag_contains_index(u32 tag)
+{
+#define DIRECT_LOOKUP_BIT 0x04
+	return tag & DIRECT_LOOKUP_BIT;
+}
+
+static inline u32 cciss_tag_to_index(u32 tag)
+{
+#define DIRECT_LOOKUP_SHIFT 3
+	return tag >> DIRECT_LOOKUP_SHIFT;
+}
+
+static inline u32 cciss_tag_discard_error_bits(u32 tag)
+{
+#define CCISS_ERROR_BITS 0x03
+	return tag & ~CCISS_ERROR_BITS;
+}
+
+static inline void cciss_mark_tag_indexed(u32 *tag)
+{
+	*tag |= DIRECT_LOOKUP_BIT;
+}
+
+static inline void cciss_set_tag_index(u32 *tag, u32 index)
+{
+	*tag |= (index << DIRECT_LOOKUP_SHIFT);
+}
+
 /*
  * Get a request and submit it to the controller.
  */
@@ -3172,8 +3200,8 @@ static void do_cciss_request(struct request_queue *q)
 	/* got command from pool, so use the command block index instead */
 	/* for direct lookups. */
 	/* The first 2 bits are reserved for controller error reporting. */
-	c->Header.Tag.lower = (c->cmdindex << 3);
-	c->Header.Tag.lower |= 0x04;	/* flag for direct lookup. */
+	cciss_set_tag_index(&c->Header.Tag.lower, c->cmdindex);
+	cciss_mark_tag_indexed(&c->Header.Tag.lower);
 	memcpy(&c->Header.LUN, drv->LunID, sizeof(drv->LunID));
 	c->Request.CDBLen = 10;	/* 12 byte commands not in FW yet; */
 	c->Request.Type.Type = TYPE_CMD;	/* It is a command. */
@@ -3306,15 +3334,73 @@ static inline int interrupt_pending(ctlr_info_t *h)
 static inline long interrupt_not_for_us(ctlr_info_t *h)
 {
 	return (((h->access.intr_pending(h) == 0) ||
-		 (h->interrupts_enabled == 0)));
+		(h->interrupts_enabled == 0)));
 }
 
-static irqreturn_t do_cciss_intr(int irq, void *dev_id)
+static inline int bad_tag(ctlr_info_t *h, u32 tag_index,
+			u32 raw_tag)
 {
-	ctlr_info_t *h = dev_id;
+	if (unlikely(tag_index >= h->nr_cmds)) {
+		dev_warn(&h->pdev->dev, "bad tag 0x%08x ignored.\n", raw_tag);
+		return 1;
+	}
+	return 0;
+}
+
+static inline void finish_cmd(ctlr_info_t *h, CommandList_struct *c,
+				u32 raw_tag)
+{
+	removeQ(c);
+	if (likely(c->cmd_type == CMD_RWREQ))
+		complete_command(h, c, 0);
+	else if (c->cmd_type == CMD_IOCTL_PEND)
+		complete(c->waiting);
+#ifdef CONFIG_CISS_SCSI_TAPE
+	else if (c->cmd_type == CMD_SCSI)
+		complete_scsi_command(c, 0, raw_tag);
+#endif
+}
+
+/* process completion of an indexed ("direct lookup") command */
+static inline u32 process_indexed_cmd(ctlr_info_t *h, u32 raw_tag)
+{
+	u32 tag_index;
 	CommandList_struct *c;
+
+	tag_index = cciss_tag_to_index(raw_tag);
+	if (bad_tag(h, tag_index, raw_tag))
+		return get_next_completion(h);
+	c = h->cmd_pool + tag_index;
+	finish_cmd(h, c, raw_tag);
+	return get_next_completion(h);
+}
+
+/* process completion of a non-indexed command */
+static inline u32 process_nonindexed_cmd(ctlr_info_t *h, u32 raw_tag)
+{
+	u32 tag;
+	CommandList_struct *c = NULL;
+	struct hlist_node *tmp;
+	__u32 busaddr_masked, tag_masked;
+
+	tag = cciss_tag_discard_error_bits(raw_tag);
+	hlist_for_each_entry(c, tmp, &h->cmpQ, list) {
+		busaddr_masked = cciss_tag_discard_error_bits(c->busaddr);
+		tag_masked = cciss_tag_discard_error_bits(tag);
+		if (busaddr_masked == tag_masked) {
+			finish_cmd(h, c, raw_tag);
+			return get_next_completion(h);
+		}
+	}
+	bad_tag(h, h->nr_cmds + 1, raw_tag);
+	return get_next_completion(h);
+}
+
+static irqreturn_t do_cciss_intx(int irq, void *dev_id)
+{
+	ctlr_info_t *h = dev_id;
 	unsigned long flags;
-	__u32 a, a1, a2;
+	u32 raw_tag;
 
 	if (interrupt_not_for_us(h))
 		return IRQ_NONE;
@@ -3324,50 +3410,41 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 	 */
 	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 	while (interrupt_pending(h)) {
-		while ((a = get_next_completion(h)) != FIFO_EMPTY) {
-			a1 = a;
-			if ((a & 0x04)) {
-				a2 = (a >> 3);
-				if (a2 >= h->nr_cmds) {
-					printk(KERN_WARNING
-					       "cciss: controller cciss%d failed, stopping.\n",
-					       h->ctlr);
-					spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
-					fail_all_cmds(h->ctlr);
-					return IRQ_HANDLED;
-				}
+		raw_tag = get_next_completion(h);
+		while (raw_tag != FIFO_EMPTY) {
+			if (cciss_tag_contains_index(raw_tag))
+				raw_tag = process_indexed_cmd(h, raw_tag);
+			else
+				raw_tag = process_nonindexed_cmd(h, raw_tag);
+		}
+	}
 
-				c = h->cmd_pool + a2;
-				a = c->busaddr;
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	return IRQ_HANDLED;
+}
 
-			} else {
-				struct hlist_node *tmp;
+/* Add a second interrupt handler for MSI/MSI-X mode. In this mode we never
+ * check the interrupt pending register because it is not set.
+ */
+static irqreturn_t do_cciss_msix_intr(int irq, void *dev_id)
+{
+	ctlr_info_t *h = dev_id;
+	unsigned long flags;
+	u32 raw_tag;
 
-				a &= ~3;
-				c = NULL;
-				hlist_for_each_entry(c, tmp, &h->cmpQ, list) {
-					if (c->busaddr == a)
-						break;
-				}
-			}
-			/*
-			 * If we've found the command, take it off the
-			 * completion Q and free it
-			 */
-			if (c && c->busaddr == a) {
-				removeQ(c);
-				if (c->cmd_type == CMD_RWREQ) {
-					complete_command(h, c, 0);
-				} else if (c->cmd_type == CMD_IOCTL_PEND) {
-					complete(c->waiting);
-				}
-#				ifdef CONFIG_CISS_SCSI_TAPE
-				else if (c->cmd_type == CMD_SCSI)
-					complete_scsi_command(c, 0, a1);
-#				endif
-				continue;
-			}
-		}
+	if (interrupt_not_for_us(h))
+		return IRQ_NONE;
+	/*
+	 * If there are completed commands in the completion queue,
+	 * we had better do something about it.
+	 */
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	raw_tag = get_next_completion(h);
+	while (raw_tag != FIFO_EMPTY) {
+		if (cciss_tag_contains_index(raw_tag))
+			raw_tag = process_indexed_cmd(h, raw_tag);
+		else
+			raw_tag = process_nonindexed_cmd(h, raw_tag);
 	}
 
 	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
@@ -4230,11 +4307,21 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 
 	/* make sure the board interrupts are off */
 	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_OFF);
-	if (request_irq(hba[i]->intr[SIMPLE_MODE_INT], do_cciss_intr,
-			IRQF_DISABLED | IRQF_SHARED, hba[i]->devname, hba[i])) {
-		printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
-		       hba[i]->intr[SIMPLE_MODE_INT], hba[i]->devname);
-		goto clean2;
+	if (hba[i]->msi_vector || hba[i]->msix_vector) {
+		if (request_irq(hba[i]->intr[SIMPLE_MODE_INT],
+				do_cciss_msix_intr,
+				IRQF_DISABLED, hba[i]->devname, hba[i])) {
+			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
+			       hba[i]->intr[SIMPLE_MODE_INT], hba[i]->devname);
+			goto clean2;
+		}
+	} else {
+		if (request_irq(hba[i]->intr[SIMPLE_MODE_INT], do_cciss_intx,
+				IRQF_DISABLED, hba[i]->devname, hba[i])) {
+			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
+			       hba[i]->intr[SIMPLE_MODE_INT], hba[i]->devname);
+			goto clean2;
+		}
 	}
 
 	printk(KERN_INFO "%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
@@ -4534,46 +4621,5 @@ static void __exit cciss_cleanup(void)
 	bus_unregister(&cciss_bus_type);
 }
 
-static void fail_all_cmds(unsigned long ctlr)
-{
-	/* If we get here, the board is apparently dead. */
-	ctlr_info_t *h = hba[ctlr];
-	CommandList_struct *c;
-	unsigned long flags;
-
-	printk(KERN_WARNING "cciss%d: controller not responding.\n", h->ctlr);
-	h->alive = 0;		/* the controller apparently died... */
-
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-
-	pci_disable_device(h->pdev);	/* Make sure it is really dead. */
-
-	/* move everything off the request queue onto the completed queue */
-	while (!hlist_empty(&h->reqQ)) {
-		c = hlist_entry(h->reqQ.first, CommandList_struct, list);
-		removeQ(c);
-		h->Qdepth--;
-		addQ(&h->cmpQ, c);
-	}
-
-	/* Now, fail everything on the completed queue with a HW error */
-	while (!hlist_empty(&h->cmpQ)) {
-		c = hlist_entry(h->cmpQ.first, CommandList_struct, list);
-		removeQ(c);
-		if (c->cmd_type != CMD_MSG_STALE)
-			c->err_info->CommandStatus = CMD_HARDWARE_ERR;
-		if (c->cmd_type == CMD_RWREQ) {
-			complete_command(h, c, 0);
-		} else if (c->cmd_type == CMD_IOCTL_PEND)
-			complete(c->waiting);
-#ifdef CONFIG_CISS_SCSI_TAPE
-		else if (c->cmd_type == CMD_SCSI)
-			complete_scsi_command(c, 0, 0);
-#endif
-	}
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-	return;
-}
-
 module_init(cciss_init);
 module_exit(cciss_cleanup);
