From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/6] cciss: enqueue and submit io
Date: Fri, 28 May 2010 14:54:44 -0500
Message-ID: <20100528195444.GA6855@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, Steve Cameron <scameron@beardog.cce.hp.com>
List-Id: linux-scsi@vger.kernel.org

Patch 1/6
This patch cleans up some code where we subit our io. The same 5 lines
appeared several times. Also helps for a following patch.

From: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/block/cciss.c |   38 +++++++++++++++-----------------------
 1 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 51ceaee..6db790c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -257,6 +257,17 @@ static inline void removeQ(CommandList_struct *c)
 	hlist_del_init(&c->list);
 }
 
+static void enqueue_cmd_and_start_io(ctlr_info_t *h,
+	CommandList_struct *c)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&h->lock, flags);
+	addQ(&h->reqQ, c);
+	h->Qdepth++;
+	start_io(h);
+	spin_unlock_irqrestore(&h->lock, flags);
+}
+
 static void cciss_free_sg_chain_blocks(SGDescriptor_struct **cmd_sg_list,
 	int nr_cmds)
 {
@@ -1377,7 +1388,6 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			CommandList_struct *c;
 			char *buff = NULL;
 			u64bit temp64;
-			unsigned long flags;
 			DECLARE_COMPLETION_ONSTACK(wait);
 
 			if (!arg)
@@ -1449,13 +1459,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			}
 			c->waiting = &wait;
 
-			/* Put the request on the tail of the request queue */
-			spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-			addQ(&host->reqQ, c);
-			host->Qdepth++;
-			start_io(host);
-			spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-
+			enqueue_cmd_and_start_io(host, c);
 			wait_for_completion(&wait);
 
 			/* unlock the buffers from DMA */
@@ -1495,7 +1499,6 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned char **buff = NULL;
 			int *buff_size = NULL;
 			u64bit temp64;
-			unsigned long flags;
 			BYTE sg_used = 0;
 			int status = 0;
 			int i;
@@ -1602,12 +1605,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 				}
 			}
 			c->waiting = &wait;
-			/* Put the request on the tail of the request queue */
-			spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-			addQ(&host->reqQ, c);
-			host->Qdepth++;
-			start_io(host);
-			spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+			enqueue_cmd_and_start_io(host, c);
 			wait_for_completion(&wait);
 			/* unlock the buffers from DMA */
 			for (i = 0; i < sg_used; i++) {
@@ -1729,8 +1727,8 @@ static void cciss_softirq_done(struct request *rq)
 	CommandList_struct *cmd = rq->completion_data;
 	ctlr_info_t *h = hba[cmd->ctlr];
 	SGDescriptor_struct *curr_sg = cmd->SG;
-	unsigned long flags;
 	u64bit temp64;
+	unsigned long flags;
 	int i, ddir;
 	int sg_index = 0;
 
@@ -2679,17 +2677,11 @@ static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c,
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	u64bit buff_dma_handle;
-	unsigned long flags;
 	int return_status = IO_OK;
 
 resend_cmd2:
 	c->waiting = &wait;
-	/* Put the request on the tail of the queue and send it */
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
-	addQ(&h->reqQ, c);
-	h->Qdepth++;
-	start_io(h);
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	enqueue_cmd_and_start_io(h, c);
 
 	wait_for_completion(&wait);
 
