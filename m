From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 4/9] cciss: simplify scatter gather code
Date: Fri, 26 Feb 2010 16:01:27 -0600
Message-ID: <20100226220127.11979.29389.stgit@beardog.cce.hp.com>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38225 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966373Ab0BZV6R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 16:58:17 -0500
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: simplify scatter gather code.
Instead of allocating an array of pointers to a structure
containing an SGDescriptor structure, and two other elements
that aren't really used, just allocate SGDescriptor structs.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   43 +++++++++++++++----------------------------
 drivers/block/cciss.h |    8 +-------
 2 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index eddb916..adc517c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -257,7 +257,7 @@ static inline void removeQ(CommandList_struct *c)
 	hlist_del_init(&c->list);
 }
 
-static void cciss_free_sg_chain_blocks(struct Cmd_sg_list **cmd_sg_list,
+static void cciss_free_sg_chain_blocks(SGDescriptor_struct **cmd_sg_list,
 	int nr_cmds)
 {
 	int i;
@@ -265,20 +265,17 @@ static void cciss_free_sg_chain_blocks(struct Cmd_sg_list **cmd_sg_list,
 	if (!cmd_sg_list)
 		return;
 	for (i = 0; i < nr_cmds; i++) {
-		if (cmd_sg_list[i]) {
-			kfree(cmd_sg_list[i]->sgchain);
-			kfree(cmd_sg_list[i]);
-			cmd_sg_list[i] = NULL;
-		}
+		kfree(cmd_sg_list[i]);
+		cmd_sg_list[i] = NULL;
 	}
 	kfree(cmd_sg_list);
 }
 
-static struct Cmd_sg_list **cciss_allocate_sg_chain_blocks(ctlr_info_t *h,
-	int chainsize, int nr_cmds)
+static SGDescriptor_struct **cciss_allocate_sg_chain_blocks(
+	ctlr_info_t *h, int chainsize, int nr_cmds)
 {
 	int j;
-	struct Cmd_sg_list **cmd_sg_list;
+	SGDescriptor_struct **cmd_sg_list;
 
 	if (chainsize <= 0)
 		return NULL;
@@ -289,16 +286,10 @@ static struct Cmd_sg_list **cciss_allocate_sg_chain_blocks(ctlr_info_t *h,
 
 	/* Build up chain blocks for each command */
 	for (j = 0; j < nr_cmds; j++) {
-		cmd_sg_list[j] = kmalloc(sizeof(*cmd_sg_list[j]), GFP_KERNEL);
-		if (!cmd_sg_list[j]) {
-			dev_err(&h->pdev->dev, "Cannot get memory "
-				"for chain block.\n");
-			goto clean;
-		}
 		/* Need a block of chainsized s/g elements. */
-		cmd_sg_list[j]->sgchain = kmalloc((chainsize *
-			sizeof(SGDescriptor_struct)), GFP_KERNEL);
-		if (!cmd_sg_list[j]->sgchain) {
+		cmd_sg_list[j] = kmalloc((chainsize *
+			sizeof(*cmd_sg_list[j])), GFP_KERNEL);
+		if (!cmd_sg_list[j]) {
 			dev_err(&h->pdev->dev, "Cannot get memory "
 				"for s/g chains.\n");
 			goto clean;
@@ -1731,7 +1722,7 @@ static void cciss_softirq_done(struct request *rq)
 			pci_unmap_single(h->pdev, temp64.val,
 						cmd->SG[i].Len, ddir);
 			/* Point to the next block */
-			curr_sg = h->cmd_sg_list[cmd->cmdindex]->sgchain;
+			curr_sg = h->cmd_sg_list[cmd->cmdindex];
 			sg_index = 0;
 		}
 		temp64.val32.lower = curr_sg[sg_index].Addr.lower;
@@ -3206,7 +3197,7 @@ static void do_cciss_request(struct request_queue *q)
 			curr_sg[sg_index].Ext = CCISS_SG_CHAIN;
 
 			/* Point to next chain block. */
-			curr_sg = h->cmd_sg_list[c->cmdindex]->sgchain;
+			curr_sg = h->cmd_sg_list[c->cmdindex];
 			sg_index = 0;
 			chained = 1;
 		}
@@ -3223,6 +3214,7 @@ static void do_cciss_request(struct request_queue *q)
 
 	if (chained) {
 		int len;
+		dma_addr_t dma_addr;
 		curr_sg = c->SG;
 		sg_index = h->max_cmd_sgentries - 1;
 		len = curr_sg[sg_index].Len;
@@ -3231,16 +3223,11 @@ static void do_cciss_request(struct request_queue *q)
 		 * block with address of next chain block.
 		 */
 		temp64.val = pci_map_single(h->pdev,
-					h->cmd_sg_list[c->cmdindex]->sgchain,
-					len, dir);
-
-		h->cmd_sg_list[c->cmdindex]->sg_chain_dma = temp64.val;
+					h->cmd_sg_list[c->cmdindex], len, dir);
+		dma_addr = temp64.val;
 		curr_sg[sg_index].Addr.lower = temp64.val32.lower;
 		curr_sg[sg_index].Addr.upper = temp64.val32.upper;
-
-		pci_dma_sync_single_for_device(h->pdev,
-				h->cmd_sg_list[c->cmdindex]->sg_chain_dma,
-				len, dir);
+		pci_dma_sync_single_for_device(h->pdev, dma_addr, len, dir);
 	}
 
 	/* track how many SG entries we are using */
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 2b07bda..ac454fd 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -55,12 +55,6 @@ typedef struct _drive_info_struct
 	char device_initialized;     /* indicates whether dev is initialized */
 } drive_info_struct;
 
-struct Cmd_sg_list {
-	SGDescriptor_struct	*sgchain;
-	dma_addr_t		sg_chain_dma;
-	int			chain_block_size;
-};
-
 struct ctlr_info
 {
 	int	ctlr;
@@ -89,7 +83,7 @@ struct ctlr_info
 	int	maxsgentries;
 	int	chainsize;
 	int	max_cmd_sgentries;
-	struct Cmd_sg_list **cmd_sg_list;
+	SGDescriptor_struct **cmd_sg_list;
 
 #	define DOORBELL_INT	0
 #	define PERF_MODE_INT	1

