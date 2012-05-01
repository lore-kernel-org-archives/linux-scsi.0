From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 13/17] hpsa: refine interrupt handler locking for greater
	concurrency
Date: Tue, 01 May 2012 11:43:11 -0500
Message-ID: <20120501164311.11705.61999.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Matt Gates <matthew.gates@hp.com>

Use spinlocks with finer granularity in the submission and
completion paths to allow concurrent execution for multiple
reply queues.  In particular, do not hold a spin lock while
submitting a request to the device, nor during most of the
interrupt handler.

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   61 +++++++++++++++++++++++++++++++++------------------
 drivers/scsi/hpsa.h |   13 +++++++----
 2 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 620e50a..cf2f60e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -533,6 +533,7 @@ static inline u32 next_command(struct ctlr_info *h, u8 q)
 {
 	u32 a;
 	struct reply_pool *rq = &h->reply_queue[q];
+	unsigned long flags;
 
 	if (unlikely(!(h->transMethod & CFGTBL_Trans_Performant)))
 		return h->access.command_completed(h, q);
@@ -540,7 +541,9 @@ static inline u32 next_command(struct ctlr_info *h, u8 q)
 	if ((rq->head[rq->current_entry] & 1) == rq->wraparound) {
 		a = rq->head[rq->current_entry];
 		rq->current_entry++;
+		spin_lock_irqsave(&h->lock, flags);
 		h->commands_outstanding--;
+		spin_unlock_irqrestore(&h->lock, flags);
 	} else {
 		a = FIFO_EMPTY;
 	}
@@ -575,8 +578,8 @@ static void enqueue_cmd_and_start_io(struct ctlr_info *h,
 	spin_lock_irqsave(&h->lock, flags);
 	addQ(&h->reqQ, c);
 	h->Qdepth++;
-	start_io(h);
 	spin_unlock_irqrestore(&h->lock, flags);
+	start_io(h);
 }
 
 static inline void removeQ(struct CommandList *c)
@@ -2091,9 +2094,8 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 		done(cmd);
 		return 0;
 	}
-	/* Need a lock as this is being allocated from the pool */
-	c = cmd_alloc(h);
 	spin_unlock_irqrestore(&h->lock, flags);
+	c = cmd_alloc(h);
 	if (c == NULL) {			/* trouble... */
 		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -2627,14 +2629,21 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	int i;
 	union u64bit temp64;
 	dma_addr_t cmd_dma_handle, err_dma_handle;
+	unsigned long flags;
 
+	spin_lock_irqsave(&h->lock, flags);
 	do {
 		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
-		if (i == h->nr_cmds)
+		if (i == h->nr_cmds) {
+			spin_unlock_irqrestore(&h->lock, flags);
 			return NULL;
+		}
 	} while (test_and_set_bit
 		 (i & (BITS_PER_LONG - 1),
 		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
+	h->nr_allocs++;
+	spin_unlock_irqrestore(&h->lock, flags);
+
 	c = h->cmd_pool + i;
 	memset(c, 0, sizeof(*c));
 	cmd_dma_handle = h->cmd_pool_dhandle
@@ -2643,7 +2652,6 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	memset(c->err_info, 0, sizeof(*c->err_info));
 	err_dma_handle = h->errinfo_pool_dhandle
 	    + i * sizeof(*c->err_info);
-	h->nr_allocs++;
 
 	c->cmdindex = i;
 
@@ -2699,11 +2707,14 @@ static struct CommandList *cmd_special_alloc(struct ctlr_info *h)
 static void cmd_free(struct ctlr_info *h, struct CommandList *c)
 {
 	int i;
+	unsigned long flags;
 
 	i = c - h->cmd_pool;
+	spin_lock_irqsave(&h->lock, flags);
 	clear_bit(i & (BITS_PER_LONG - 1),
 		  h->cmd_pool_bits + (i / BITS_PER_LONG));
 	h->nr_frees++;
+	spin_unlock_irqrestore(&h->lock, flags);
 }
 
 static void cmd_special_free(struct ctlr_info *h, struct CommandList *c)
@@ -3307,7 +3318,9 @@ static void __iomem *remap_pci_mem(ulong base, ulong size)
 static void start_io(struct ctlr_info *h)
 {
 	struct CommandList *c;
+	unsigned long flags;
 
+	spin_lock_irqsave(&h->lock, flags);
 	while (!list_empty(&h->reqQ)) {
 		c = list_entry(h->reqQ.next, struct CommandList, list);
 		/* can't do anything if fifo is full */
@@ -3320,12 +3333,23 @@ static void start_io(struct ctlr_info *h)
 		removeQ(c);
 		h->Qdepth--;
 
-		/* Tell the controller execute command */
-		h->access.submit_command(h, c);
-
 		/* Put job onto the completed Q */
 		addQ(&h->cmpQ, c);
+
+		/* Must increment commands_outstanding before unlocking
+		 * and submitting to avoid race checking for fifo full
+		 * condition.
+		 */
+		h->commands_outstanding++;
+		if (h->commands_outstanding > h->max_outstanding)
+			h->max_outstanding = h->commands_outstanding;
+
+		/* Tell the controller execute command */
+		spin_unlock_irqrestore(&h->lock, flags);
+		h->access.submit_command(h, c);
+		spin_lock_irqsave(&h->lock, flags);
 	}
+	spin_unlock_irqrestore(&h->lock, flags);
 }
 
 static inline unsigned long get_next_completion(struct ctlr_info *h, u8 q)
@@ -3356,7 +3380,11 @@ static inline int bad_tag(struct ctlr_info *h, u32 tag_index,
 
 static inline void finish_cmd(struct CommandList *c)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&c->h->lock, flags);
 	removeQ(c);
+	spin_unlock_irqrestore(&c->h->lock, flags);
 	if (likely(c->cmd_type == CMD_SCSI))
 		complete_scsi_command(c);
 	else if (c->cmd_type == CMD_IOCTL_PEND)
@@ -3403,14 +3431,18 @@ static inline void process_nonindexed_cmd(struct ctlr_info *h,
 {
 	u32 tag;
 	struct CommandList *c = NULL;
+	unsigned long flags;
 
 	tag = hpsa_tag_discard_error_bits(h, raw_tag);
+	spin_lock_irqsave(&h->lock, flags);
 	list_for_each_entry(c, &h->cmpQ, list) {
 		if ((c->busaddr & 0xFFFFFFE0) == (tag & 0xFFFFFFE0)) {
+			spin_unlock_irqrestore(&h->lock, flags);
 			finish_cmd(c);
 			return;
 		}
 	}
+	spin_unlock_irqrestore(&h->lock, flags);
 	bad_tag(h, h->nr_cmds + 1, raw_tag);
 }
 
@@ -3447,7 +3479,6 @@ static irqreturn_t hpsa_intx_discard_completions(int irq, void *queue)
 {
 	struct ctlr_info *h = queue_to_hba(queue);
 	u8 q = *(u8 *) queue;
-	unsigned long flags;
 	u32 raw_tag;
 
 	if (ignore_bogus_interrupt(h))
@@ -3455,47 +3486,39 @@ static irqreturn_t hpsa_intx_discard_completions(int irq, void *queue)
 
 	if (interrupt_not_for_us(h))
 		return IRQ_NONE;
-	spin_lock_irqsave(&h->lock, flags);
 	h->last_intr_timestamp = get_jiffies_64();
 	while (interrupt_pending(h)) {
 		raw_tag = get_next_completion(h, q);
 		while (raw_tag != FIFO_EMPTY)
 			raw_tag = next_command(h, q);
 	}
-	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t hpsa_msix_discard_completions(int irq, void *queue)
 {
 	struct ctlr_info *h = queue_to_hba(queue);
-	unsigned long flags;
 	u32 raw_tag;
 	u8 q = *(u8 *) queue;
 
 	if (ignore_bogus_interrupt(h))
 		return IRQ_NONE;
 
-	spin_lock_irqsave(&h->lock, flags);
-
 	h->last_intr_timestamp = get_jiffies_64();
 	raw_tag = get_next_completion(h, q);
 	while (raw_tag != FIFO_EMPTY)
 		raw_tag = next_command(h, q);
-	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t do_hpsa_intr_intx(int irq, void *queue)
 {
 	struct ctlr_info *h = queue_to_hba((u8 *) queue);
-	unsigned long flags;
 	u32 raw_tag;
 	u8 q = *(u8 *) queue;
 
 	if (interrupt_not_for_us(h))
 		return IRQ_NONE;
-	spin_lock_irqsave(&h->lock, flags);
 	h->last_intr_timestamp = get_jiffies_64();
 	while (interrupt_pending(h)) {
 		raw_tag = get_next_completion(h, q);
@@ -3507,18 +3530,15 @@ static irqreturn_t do_hpsa_intr_intx(int irq, void *queue)
 			raw_tag = next_command(h, q);
 		}
 	}
-	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t do_hpsa_intr_msi(int irq, void *queue)
 {
 	struct ctlr_info *h = queue_to_hba(queue);
-	unsigned long flags;
 	u32 raw_tag;
 	u8 q = *(u8 *) queue;
 
-	spin_lock_irqsave(&h->lock, flags);
 	h->last_intr_timestamp = get_jiffies_64();
 	raw_tag = get_next_completion(h, q);
 	while (raw_tag != FIFO_EMPTY) {
@@ -3528,7 +3548,6 @@ static irqreturn_t do_hpsa_intr_msi(int irq, void *queue)
 			process_nonindexed_cmd(h, raw_tag);
 		raw_tag = next_command(h, q);
 	}
-	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 486a7c0..79c36aa 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -246,9 +246,6 @@ static void SA5_submit_command(struct ctlr_info *h,
 		c->Header.Tag.lower);
 	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
-	h->commands_outstanding++;
-	if (h->commands_outstanding > h->max_outstanding)
-		h->max_outstanding = h->commands_outstanding;
 }
 
 /*
@@ -287,7 +284,7 @@ static void SA5_performant_intr_mask(struct ctlr_info *h, unsigned long val)
 static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
 {
 	struct reply_pool *rq = &h->reply_queue[q];
-	unsigned long register_value = FIFO_EMPTY;
+	unsigned long flags, register_value = FIFO_EMPTY;
 
 	/* msi auto clears the interrupt pending bit. */
 	if (!(h->msi_vector || h->msix_vector)) {
@@ -305,7 +302,9 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
 	if ((rq->head[rq->current_entry] & 1) == rq->wraparound) {
 		register_value = rq->head[rq->current_entry];
 		rq->current_entry++;
+		spin_lock_irqsave(&h->lock, flags);
 		h->commands_outstanding--;
+		spin_unlock_irqrestore(&h->lock, flags);
 	} else {
 		register_value = FIFO_EMPTY;
 	}
@@ -338,9 +337,13 @@ static unsigned long SA5_completed(struct ctlr_info *h,
 {
 	unsigned long register_value
 		= readl(h->vaddr + SA5_REPLY_PORT_OFFSET);
+	unsigned long flags;
 
-	if (register_value != FIFO_EMPTY)
+	if (register_value != FIFO_EMPTY) {
+		spin_lock_irqsave(&h->lock, flags);
 		h->commands_outstanding--;
+		spin_unlock_irqrestore(&h->lock, flags);
+	}
 
 #ifdef HPSA_DEBUG
 	if (register_value != FIFO_EMPTY)
