From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 09/13] hpsa: use atomics for commands_outstanding
Date: Fri, 14 Nov 2014 17:27:09 -0600
Message-ID: <20141114232709.20808.6934.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:58595 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422945AbaKNXZe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:25:34 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <stephenmcameron@gmail.com>

Use atomics for commands_outstanding instead of protecting with spin locks.

Signed-off-by: Don Brace <don.brace@pmcs.com>
Signed-off-by: Stephen M. Cameron <stephenmcameron@gmail.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
---
 drivers/scsi/hpsa.c |   26 +++++++++-----------------
 drivers/scsi/hpsa.h |   27 +++++++--------------------
 2 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 95c34a5..c9554e6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -394,7 +394,8 @@ static ssize_t host_show_commands_outstanding(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ctlr_info *h = shost_to_hba(shost);
 
-	return snprintf(buf, 20, "%d\n", h->commands_outstanding);
+	return snprintf(buf, 20, "%d\n",
+			atomic_read(&h->commands_outstanding));
 }
 
 static ssize_t host_show_transport_mode(struct device *dev,
@@ -700,7 +701,6 @@ static inline u32 next_command(struct ctlr_info *h, u8 q)
 {
 	u32 a;
 	struct reply_queue_buffer *rq = &h->reply_queue[q];
-	unsigned long flags;
 
 	if (h->transMethod & CFGTBL_Trans_io_accel1)
 		return h->access.command_completed(h, q);
@@ -711,9 +711,7 @@ static inline u32 next_command(struct ctlr_info *h, u8 q)
 	if ((rq->head[rq->current_entry] & 1) == rq->wraparound) {
 		a = rq->head[rq->current_entry];
 		rq->current_entry++;
-		spin_lock_irqsave(&h->lock, flags);
-		h->commands_outstanding--;
-		spin_unlock_irqrestore(&h->lock, flags);
+		atomic_dec(&h->commands_outstanding);
 	} else {
 		a = FIFO_EMPTY;
 	}
@@ -5445,15 +5443,9 @@ static void start_io(struct ctlr_info *h, unsigned long *flags)
 
 		/* Put job onto the completed Q */
 		addQ(&h->cmpQ, c);
-
-		/* Must increment commands_outstanding before unlocking
-		 * and submitting to avoid race checking for fifo full
-		 * condition.
-		 */
-		h->commands_outstanding++;
-
-		/* Tell the controller execute command */
+		atomic_inc(&h->commands_outstanding);
 		spin_unlock_irqrestore(&h->lock, *flags);
+		/* Tell the controller execute command */
 		h->access.submit_command(h, c);
 		spin_lock_irqsave(&h->lock, *flags);
 	}
@@ -5499,6 +5491,7 @@ static inline void finish_cmd(struct CommandList *c)
 	unsigned long flags;
 	int io_may_be_stalled = 0;
 	struct ctlr_info *h = c->h;
+	int count;
 
 	spin_lock_irqsave(&h->lock, flags);
 	removeQ(c);
@@ -5519,11 +5512,10 @@ static inline void finish_cmd(struct CommandList *c)
 	 * want to get in a cycle where we call start_io every time
 	 * through here.
 	 */
-	if (unlikely(h->fifo_recently_full) &&
-		h->commands_outstanding < 5)
-		io_may_be_stalled = 1;
-
+	count = atomic_read(&h->commands_outstanding);
 	spin_unlock_irqrestore(&h->lock, flags);
+	if (unlikely(h->fifo_recently_full) && count < 5)
+		io_may_be_stalled = 1;
 
 	dial_up_lockup_detection_on_fw_flash_complete(c->h, c);
 	if (likely(c->cmd_type == CMD_IOACCEL1 || c->cmd_type == CMD_SCSI
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 80fa9a9..8e06d9e 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -118,7 +118,7 @@ struct ctlr_info {
 	struct CfgTable __iomem *cfgtable;
 	int	interrupts_enabled;
 	int 	max_commands;
-	int	commands_outstanding;
+	atomic_t commands_outstanding;
 #	define PERF_MODE_INT	0
 #	define DOORBELL_INT	1
 #	define SIMPLE_MODE_INT	2
@@ -395,7 +395,7 @@ static void SA5_performant_intr_mask(struct ctlr_info *h, unsigned long val)
 static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
 {
 	struct reply_queue_buffer *rq = &h->reply_queue[q];
-	unsigned long flags, register_value = FIFO_EMPTY;
+	unsigned long register_value = FIFO_EMPTY;
 
 	/* msi auto clears the interrupt pending bit. */
 	if (!(h->msi_vector || h->msix_vector)) {
@@ -413,9 +413,7 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
 	if ((rq->head[rq->current_entry] & 1) == rq->wraparound) {
 		register_value = rq->head[rq->current_entry];
 		rq->current_entry++;
-		spin_lock_irqsave(&h->lock, flags);
-		h->commands_outstanding--;
-		spin_unlock_irqrestore(&h->lock, flags);
+		atomic_dec(&h->commands_outstanding);
 	} else {
 		register_value = FIFO_EMPTY;
 	}
@@ -433,11 +431,7 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
  */
 static unsigned long SA5_fifo_full(struct ctlr_info *h)
 {
-	if (h->commands_outstanding >= h->max_commands)
-		return 1;
-	else
-		return 0;
-
+	return atomic_read(&h->commands_outstanding) >= h->max_commands;
 }
 /*
  *   returns value read from hardware.
@@ -448,13 +442,9 @@ static unsigned long SA5_completed(struct ctlr_info *h,
 {
 	unsigned long register_value
 		= readl(h->vaddr + SA5_REPLY_PORT_OFFSET);
-	unsigned long flags;
 
-	if (register_value != FIFO_EMPTY) {
-		spin_lock_irqsave(&h->lock, flags);
-		h->commands_outstanding--;
-		spin_unlock_irqrestore(&h->lock, flags);
-	}
+	if (register_value != FIFO_EMPTY)
+		atomic_dec(&h->commands_outstanding);
 
 #ifdef HPSA_DEBUG
 	if (register_value != FIFO_EMPTY)
@@ -510,7 +500,6 @@ static unsigned long SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
 {
 	u64 register_value;
 	struct reply_queue_buffer *rq = &h->reply_queue[q];
-	unsigned long flags;
 
 	BUG_ON(q >= h->nreply_queues);
 
@@ -528,9 +517,7 @@ static unsigned long SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
 		wmb();
 		writel((q << 24) | rq->current_entry, h->vaddr +
 				IOACCEL_MODE1_CONSUMER_INDEX);
-		spin_lock_irqsave(&h->lock, flags);
-		h->commands_outstanding--;
-		spin_unlock_irqrestore(&h->lock, flags);
+		atomic_dec(&h->commands_outstanding);
 	}
 	return (unsigned long) register_value;
 }

