From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 11/17] hpsa: use multiple reply queues
Date: Fri, 20 Apr 2012 10:07:17 -0500
Message-ID: <20120420150717.10596.93707.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Matt Gates <matthew.gates@hp.com>

Smart Arrays can support multiple reply queues onto which command
completions may be deposited.  It can help performance quite a bit
to arrange for command completions to be processed on the same CPU
from which they were submitted to increase the likelihood of cache
hits.

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |  181 ++++++++++++++++++++++++++++++++---------------
 drivers/scsi/hpsa.h     |   40 ++++++----
 drivers/scsi/hpsa_cmd.h |    5 +
 3 files changed, 153 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 96d07d4..29bbf35 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -172,7 +172,7 @@ static void check_ioctl_unit_attention(struct ctlr_info *h,
 static void calc_bucket_map(int *bucket, int num_buckets,
 	int nsgs, int *bucket_map);
 static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h);
-static inline u32 next_command(struct ctlr_info *h);
+static inline u32 next_command(struct ctlr_info *h, u8 q);
 static int __devinit hpsa_find_cfg_addrs(struct pci_dev *pdev,
 	void __iomem *vaddr, u32 *cfg_base_addr, u64 *cfg_base_addr_index,
 	u64 *cfg_offset);
@@ -528,24 +528,25 @@ static inline void addQ(struct list_head *list, struct CommandList *c)
 	list_add_tail(&c->list, list);
 }
 
-static inline u32 next_command(struct ctlr_info *h)
+static inline u32 next_command(struct ctlr_info *h, u8 q)
 {
 	u32 a;
+	struct reply_pool *rq = &h->reply_queue[q];
 
 	if (unlikely(!(h->transMethod & CFGTBL_Trans_Performant)))
-		return h->access.command_completed(h);
+		return h->access.command_completed(h, q);
 
-	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
-		a = *(h->reply_pool_head); /* Next cmd in ring buffer */
-		(h->reply_pool_head)++;
+	if ((rq->head[rq->current_entry] & 1) == rq->wraparound) {
+		a = rq->head[rq->current_entry];
+		rq->current_entry++;
 		h->commands_outstanding--;
 	} else {
 		a = FIFO_EMPTY;
 	}
 	/* Check for wraparound */
-	if (h->reply_pool_head == (h->reply_pool + h->max_commands)) {
-		h->reply_pool_head = h->reply_pool;
-		h->reply_pool_wraparound ^= 1;
+	if (rq->current_entry == h->max_commands) {
+		rq->current_entry = 0;
+		rq->wraparound ^= 1;
 	}
 	return a;
 }
@@ -556,8 +557,12 @@ static inline u32 next_command(struct ctlr_info *h)
  */
 static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
 {
-	if (likely(h->transMethod & CFGTBL_Trans_Performant))
+	if (likely(h->transMethod & CFGTBL_Trans_Performant)) {
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
+		if (likely(h->msix_vector))
+			c->Header.ReplyQueue =
+				smp_processor_id() % h->nreply_queues;
+	}
 }
 
 static void enqueue_cmd_and_start_io(struct ctlr_info *h,
@@ -3315,9 +3320,9 @@ static void start_io(struct ctlr_info *h)
 	}
 }
 
-static inline unsigned long get_next_completion(struct ctlr_info *h)
+static inline unsigned long get_next_completion(struct ctlr_info *h, u8 q)
 {
-	return h->access.command_completed(h);
+	return h->access.command_completed(h, q);
 }
 
 static inline bool interrupt_pending(struct ctlr_info *h)
@@ -3420,9 +3425,20 @@ static int ignore_bogus_interrupt(struct ctlr_info *h)
 	return 1;
 }
 
-static irqreturn_t hpsa_intx_discard_completions(int irq, void *dev_id)
+/*
+ * Convert &h->q[x] (passed to interrupt handlers) back to h.
+ * Relies on (h-q[x] == x) being true for x such that
+ * 0 <= x < MAX_REPLY_QUEUES.
+ */
+static struct ctlr_info *queue_to_hba(u8 *queue)
 {
-	struct ctlr_info *h = dev_id;
+	return container_of((queue - *queue), struct ctlr_info, q[0]);
+}
+
+static irqreturn_t hpsa_intx_discard_completions(int irq, void *queue)
+{
+	struct ctlr_info *h = queue_to_hba(queue);
+	u8 q = *(u8 *) queue;
 	unsigned long flags;
 	u32 raw_tag;
 
@@ -3434,71 +3450,75 @@ static irqreturn_t hpsa_intx_discard_completions(int irq, void *dev_id)
 	spin_lock_irqsave(&h->lock, flags);
 	h->last_intr_timestamp = get_jiffies_64();
 	while (interrupt_pending(h)) {
-		raw_tag = get_next_completion(h);
+		raw_tag = get_next_completion(h, q);
 		while (raw_tag != FIFO_EMPTY)
-			raw_tag = next_command(h);
+			raw_tag = next_command(h, q);
 	}
 	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t hpsa_msix_discard_completions(int irq, void *dev_id)
+static irqreturn_t hpsa_msix_discard_completions(int irq, void *queue)
 {
-	struct ctlr_info *h = dev_id;
+	struct ctlr_info *h = queue_to_hba(queue);
 	unsigned long flags;
 	u32 raw_tag;
+	u8 q = *(u8 *) queue;
 
 	if (ignore_bogus_interrupt(h))
 		return IRQ_NONE;
 
 	spin_lock_irqsave(&h->lock, flags);
+
 	h->last_intr_timestamp = get_jiffies_64();
-	raw_tag = get_next_completion(h);
+	raw_tag = get_next_completion(h, q);
 	while (raw_tag != FIFO_EMPTY)
-		raw_tag = next_command(h);
+		raw_tag = next_command(h, q);
 	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t do_hpsa_intr_intx(int irq, void *dev_id)
+static irqreturn_t do_hpsa_intr_intx(int irq, void *queue)
 {
-	struct ctlr_info *h = dev_id;
+	struct ctlr_info *h = queue_to_hba((u8 *) queue);
 	unsigned long flags;
 	u32 raw_tag;
+	u8 q = *(u8 *) queue;
 
 	if (interrupt_not_for_us(h))
 		return IRQ_NONE;
 	spin_lock_irqsave(&h->lock, flags);
 	h->last_intr_timestamp = get_jiffies_64();
 	while (interrupt_pending(h)) {
-		raw_tag = get_next_completion(h);
+		raw_tag = get_next_completion(h, q);
 		while (raw_tag != FIFO_EMPTY) {
 			if (likely(hpsa_tag_contains_index(raw_tag)))
 				process_indexed_cmd(h, raw_tag);
 			else
 				process_nonindexed_cmd(h, raw_tag);
-			raw_tag = next_command(h);
+			raw_tag = next_command(h, q);
 		}
 	}
 	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t do_hpsa_intr_msi(int irq, void *dev_id)
+static irqreturn_t do_hpsa_intr_msi(int irq, void *queue)
 {
-	struct ctlr_info *h = dev_id;
+	struct ctlr_info *h = queue_to_hba(queue);
 	unsigned long flags;
 	u32 raw_tag;
+	u8 q = *(u8 *) queue;
 
 	spin_lock_irqsave(&h->lock, flags);
 	h->last_intr_timestamp = get_jiffies_64();
-	raw_tag = get_next_completion(h);
+	raw_tag = get_next_completion(h, q);
 	while (raw_tag != FIFO_EMPTY) {
 		if (likely(hpsa_tag_contains_index(raw_tag)))
 			process_indexed_cmd(h, raw_tag);
 		else
 			process_nonindexed_cmd(h, raw_tag);
-		raw_tag = next_command(h);
+		raw_tag = next_command(h, q);
 	}
 	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
@@ -3934,10 +3954,13 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
 {
 #ifdef CONFIG_PCI_MSI
-	int err;
-	struct msix_entry hpsa_msix_entries[4] = { {0, 0}, {0, 1},
-	{0, 2}, {0, 3}
-	};
+	int err, i;
+	struct msix_entry hpsa_msix_entries[MAX_REPLY_QUEUES];
+
+	for (i = 0; i < MAX_REPLY_QUEUES; i++) {
+		hpsa_msix_entries[i].vector = 0;
+		hpsa_msix_entries[i].entry = i;
+	}
 
 	/* Some boards advertise MSI but don't really support it */
 	if ((h->board_id == 0x40700E11) || (h->board_id == 0x40800E11) ||
@@ -3945,12 +3968,11 @@ static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
 		goto default_int_mode;
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
 		dev_info(&h->pdev->dev, "MSIX\n");
-		err = pci_enable_msix(h->pdev, hpsa_msix_entries, 4);
+		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
+						MAX_REPLY_QUEUES);
 		if (!err) {
-			h->intr[0] = hpsa_msix_entries[0].vector;
-			h->intr[1] = hpsa_msix_entries[1].vector;
-			h->intr[2] = hpsa_msix_entries[2].vector;
-			h->intr[3] = hpsa_msix_entries[3].vector;
+			for (i = 0; i < MAX_REPLY_QUEUES; i++)
+				h->intr[i] = hpsa_msix_entries[i].vector;
 			h->msix_vector = 1;
 			return;
 		}
@@ -4370,14 +4392,33 @@ static int hpsa_request_irq(struct ctlr_info *h,
 	irqreturn_t (*msixhandler)(int, void *),
 	irqreturn_t (*intxhandler)(int, void *))
 {
-	int rc;
+	int rc, i;
 
-	if (h->msix_vector || h->msi_vector)
-		rc = request_irq(h->intr[h->intr_mode], msixhandler,
-				0, h->devname, h);
-	else
-		rc = request_irq(h->intr[h->intr_mode], intxhandler,
-				IRQF_SHARED, h->devname, h);
+	/*
+	 * initialize h->q[x] = x so that interrupt handlers know which
+	 * queue to process.
+	 */
+	for (i = 0; i < MAX_REPLY_QUEUES; i++)
+		h->q[i] = (u8) i;
+
+	if (h->intr_mode == PERF_MODE_INT && h->msix_vector) {
+		/* If performant mode and MSI-X, use multiple reply queues */
+		for (i = 0; i < MAX_REPLY_QUEUES; i++)
+			rc = request_irq(h->intr[i], msixhandler,
+					0, h->devname,
+					&h->q[i]);
+	} else {
+		/* Use single reply pool */
+		if (h->msix_vector || h->msi_vector) {
+			rc = request_irq(h->intr[h->intr_mode],
+				msixhandler, 0, h->devname,
+				&h->q[h->intr_mode]);
+		} else {
+			rc = request_irq(h->intr[h->intr_mode],
+				intxhandler, IRQF_SHARED, h->devname,
+				&h->q[h->intr_mode]);
+		}
+	}
 	if (rc) {
 		dev_err(&h->pdev->dev, "unable to get irq %d for %s\n",
 		       h->intr[h->intr_mode], h->devname);
@@ -4410,9 +4451,24 @@ static int __devinit hpsa_kdump_soft_reset(struct ctlr_info *h)
 	return 0;
 }
 
+static void free_irqs(struct ctlr_info *h)
+{
+	int i;
+
+	if (!h->msix_vector || h->intr_mode != PERF_MODE_INT) {
+		/* Single reply queue, only one irq to free */
+		i = h->intr_mode;
+		free_irq(h->intr[i], &h->q[i]);
+		return;
+	}
+
+	for (i = 0; i < MAX_REPLY_QUEUES; i++)
+		free_irq(h->intr[i], &h->q[i]);
+}
+
 static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 {
-	free_irq(h->intr[h->intr_mode], h);
+	free_irqs(h);
 #ifdef CONFIG_PCI_MSI
 	if (h->msix_vector)
 		pci_disable_msix(h->pdev);
@@ -4680,7 +4736,7 @@ reinit_after_soft_reset:
 		spin_lock_irqsave(&h->lock, flags);
 		h->access.set_intr_mask(h, HPSA_INTR_OFF);
 		spin_unlock_irqrestore(&h->lock, flags);
-		free_irq(h->intr[h->intr_mode], h);
+		free_irqs(h);
 		rc = hpsa_request_irq(h, hpsa_msix_discard_completions,
 					hpsa_intx_discard_completions);
 		if (rc) {
@@ -4730,7 +4786,7 @@ reinit_after_soft_reset:
 clean4:
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
-	free_irq(h->intr[h->intr_mode], h);
+	free_irqs(h);
 clean2:
 clean1:
 	kfree(h);
@@ -4773,7 +4829,7 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 	 */
 	hpsa_flush_cache(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-	free_irq(h->intr[h->intr_mode], h);
+	free_irqs(h);
 #ifdef CONFIG_PCI_MSI
 	if (h->msix_vector)
 		pci_disable_msix(h->pdev);
@@ -4913,11 +4969,8 @@ static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h,
 	 * 10 = 6 s/g entry or 24k
 	 */
 
-	h->reply_pool_wraparound = 1; /* spec: init to 1 */
-
 	/* Controller spec: zero out this buffer. */
 	memset(h->reply_pool, 0, h->reply_pool_size);
-	h->reply_pool_head = h->reply_pool;
 
 	bft[7] = SG_ENTRIES_IN_CMD + 4;
 	calc_bucket_map(bft, ARRAY_SIZE(bft),
@@ -4927,12 +4980,19 @@ static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h,
 
 	/* size of controller ring buffer */
 	writel(h->max_commands, &h->transtable->RepQSize);
-	writel(1, &h->transtable->RepQCount);
+	writel(h->nreply_queues, &h->transtable->RepQCount);
 	writel(0, &h->transtable->RepQCtrAddrLow32);
 	writel(0, &h->transtable->RepQCtrAddrHigh32);
-	writel(h->reply_pool_dhandle, &h->transtable->RepQAddr0Low32);
-	writel(0, &h->transtable->RepQAddr0High32);
-	writel(CFGTBL_Trans_Performant | use_short_tags,
+
+	for (i = 0; i < h->nreply_queues; i++) {
+		writel(0, &h->transtable->RepQAddr[i].upper);
+		writel(h->reply_pool_dhandle +
+			(h->max_commands * sizeof(u64) * i),
+			&h->transtable->RepQAddr[i].lower);
+	}
+
+	writel(CFGTBL_Trans_Performant | use_short_tags |
+		CFGTBL_Trans_enable_directed_msix,
 		&(h->cfgtable->HostWrite.TransportRequest));
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
 	hpsa_wait_for_mode_change_ack(h);
@@ -4950,6 +5010,7 @@ static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h,
 static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 {
 	u32 trans_support;
+	int i;
 
 	if (hpsa_simple_mode)
 		return;
@@ -4958,12 +5019,20 @@ static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	if (!(trans_support & PERFORMANT_MODE))
 		return;
 
+	h->nreply_queues = h->msix_vector ? MAX_REPLY_QUEUES : 1;
 	hpsa_get_max_perf_mode_cmds(h);
 	/* Performant mode ring buffer and supporting data structures */
-	h->reply_pool_size = h->max_commands * sizeof(u64);
+	h->reply_pool_size = h->max_commands * sizeof(u64) * h->nreply_queues;
 	h->reply_pool = pci_alloc_consistent(h->pdev, h->reply_pool_size,
 				&(h->reply_pool_dhandle));
 
+	for (i = 0; i < h->nreply_queues; i++) {
+		h->reply_queue[i].head = &h->reply_pool[h->max_commands * i];
+		h->reply_queue[i].size = h->max_commands;
+		h->reply_queue[i].wraparound = 1;  /* spec: init to 1 */
+		h->reply_queue[i].current_entry = 0;
+	}
+
 	/* Need a block fetch table for performant mode */
 	h->blockFetchTable = kmalloc(((SG_ENTRIES_IN_CMD + 1) *
 				sizeof(u32)), GFP_KERNEL);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index d8aa95c..486a7c0 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -34,7 +34,7 @@ struct access_method {
 	void (*set_intr_mask)(struct ctlr_info *h, unsigned long val);
 	unsigned long (*fifo_full)(struct ctlr_info *h);
 	bool (*intr_pending)(struct ctlr_info *h);
-	unsigned long (*command_completed)(struct ctlr_info *h);
+	unsigned long (*command_completed)(struct ctlr_info *h, u8 q);
 };
 
 struct hpsa_scsi_dev_t {
@@ -48,6 +48,13 @@ struct hpsa_scsi_dev_t {
 	unsigned char raid_level;	/* from inquiry page 0xC1 */
 };
 
+struct reply_pool {
+	u64 *head;
+	size_t size;
+	u8 wraparound;
+	u32 current_entry;
+};
+
 struct ctlr_info {
 	int	ctlr;
 	char	devname[8];
@@ -68,7 +75,7 @@ struct ctlr_info {
 #	define DOORBELL_INT	1
 #	define SIMPLE_MODE_INT	2
 #	define MEMQ_MODE_INT	3
-	unsigned int intr[4];
+	unsigned int intr[MAX_REPLY_QUEUES];
 	unsigned int msix_vector;
 	unsigned int msi_vector;
 	int intr_mode; /* either PERF_MODE_INT or SIMPLE_MODE_INT */
@@ -111,13 +118,13 @@ struct ctlr_info {
 	unsigned long transMethod;
 
 	/*
-	 * Performant mode completion buffer
+	 * Performant mode completion buffers
 	 */
 	u64 *reply_pool;
-	dma_addr_t reply_pool_dhandle;
-	u64 *reply_pool_head;
 	size_t reply_pool_size;
-	unsigned char reply_pool_wraparound;
+	struct reply_pool reply_queue[MAX_REPLY_QUEUES];
+	u8 nreply_queues;
+	dma_addr_t reply_pool_dhandle;
 	u32 *blockFetchTable;
 	unsigned char *hba_inquiry_data;
 	u64 last_intr_timestamp;
@@ -125,6 +132,8 @@ struct ctlr_info {
 	u64 last_heartbeat_timestamp;
 	u32 lockup_detected;
 	struct list_head lockup_list;
+	/* Address of h->q[x] is passed to intr handler to know which queue */
+	u8 q[MAX_REPLY_QUEUES];
 	u32 TMFSupportFlags; /* cache what task mgmt funcs are supported. */
 #define HPSATMF_BITS_SUPPORTED  (1 << 0)
 #define HPSATMF_PHYS_LUN_RESET  (1 << 1)
@@ -275,8 +284,9 @@ static void SA5_performant_intr_mask(struct ctlr_info *h, unsigned long val)
 	}
 }
 
-static unsigned long SA5_performant_completed(struct ctlr_info *h)
+static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
 {
+	struct reply_pool *rq = &h->reply_queue[q];
 	unsigned long register_value = FIFO_EMPTY;
 
 	/* msi auto clears the interrupt pending bit. */
@@ -292,19 +302,18 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h)
 		register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
 	}
 
-	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
-		register_value = *(h->reply_pool_head);
-		(h->reply_pool_head)++;
+	if ((rq->head[rq->current_entry] & 1) == rq->wraparound) {
+		register_value = rq->head[rq->current_entry];
+		rq->current_entry++;
 		h->commands_outstanding--;
 	} else {
 		register_value = FIFO_EMPTY;
 	}
 	/* Check for wraparound */
-	if (h->reply_pool_head == (h->reply_pool + h->max_commands)) {
-		h->reply_pool_head = h->reply_pool;
-		h->reply_pool_wraparound ^= 1;
+	if (rq->current_entry == h->max_commands) {
+		rq->current_entry = 0;
+		rq->wraparound ^= 1;
 	}
-
 	return register_value;
 }
 
@@ -324,7 +333,8 @@ static unsigned long SA5_fifo_full(struct ctlr_info *h)
  *   returns value read from hardware.
  *     returns FIFO_EMPTY if there is nothing to read
  */
-static unsigned long SA5_completed(struct ctlr_info *h)
+static unsigned long SA5_completed(struct ctlr_info *h,
+	__attribute__((unused)) u8 q)
 {
 	unsigned long register_value
 		= readl(h->vaddr + SA5_REPLY_PORT_OFFSET);
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 14b56c9..43f1631 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -129,6 +129,7 @@
 #define CFGTBL_Trans_Simple     0x00000002l
 #define CFGTBL_Trans_Performant 0x00000004l
 #define CFGTBL_Trans_use_short_tags 0x20000000l
+#define CFGTBL_Trans_enable_directed_msix (1 << 30)
 
 #define CFGTBL_BusType_Ultra2   0x00000001l
 #define CFGTBL_BusType_Ultra3   0x00000002l
@@ -380,8 +381,8 @@ struct TransTable_struct {
 	u32            RepQCount;
 	u32            RepQCtrAddrLow32;
 	u32            RepQCtrAddrHigh32;
-	u32            RepQAddr0Low32;
-	u32            RepQAddr0High32;
+#define MAX_REPLY_QUEUES 8
+	struct vals32  RepQAddr[MAX_REPLY_QUEUES];
 };
 
 struct hpsa_pci_info {
