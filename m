From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 9/9] cciss: Fix problem with scatter gather elements in the
	scsi half of the driver
Date: Fri, 26 Feb 2010 16:01:53 -0600
Message-ID: <20100226220153.11979.27131.stgit@beardog.cce.hp.com>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20481 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966424Ab0BZV6m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 16:58:42 -0500
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: Fix problem with scatter gather elements in the scsi half of the driver
When support for more than 31 scatter gather elements was added to the block
half of the driver, the SCSI half of the driver was not addressed, and the bump
from 31 to 32 scatter gather elements in the command block itself (not chained)
actually broke the SCSI half of the driver, so that any transfer requiring 32
scatter gather elements wouldn't work.  This fix also increases the max transfer
size and size of the scatter gather table to the limit supported by the controller

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss_scsi.c |   85 +++++++++++++++++++++++++++++++-------------
 1 files changed, 59 insertions(+), 26 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 6dc15b6..e1d0e2c 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -84,7 +84,6 @@ static struct scsi_host_template cciss_driver_template = {
 	.queuecommand		= cciss_scsi_queue_command,
 	.can_queue		= SCSI_CCISS_CAN_QUEUE,
 	.this_id		= 7,
-	.sg_tablesize		= MAXSGENTRIES,
 	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
 	/* Can't have eh_bus_reset_handler or eh_host_reset_handler for cciss */
@@ -94,13 +93,14 @@ static struct scsi_host_template cciss_driver_template = {
 
 #pragma pack(1)
 
-#define SCSI_PAD_32 4
-#define SCSI_PAD_64 4
+#define SCSI_PAD_32 0
+#define SCSI_PAD_64 0
 
 struct cciss_scsi_cmd_stack_elem_t {
 	CommandList_struct cmd;
 	ErrorInfo_struct Err;
 	__u32 busaddr;
+	int cmdindex;
 	u8 pad[IS_32_BIT * SCSI_PAD_32 + IS_64_BIT * SCSI_PAD_64];
 };
 
@@ -122,6 +122,7 @@ struct cciss_scsi_cmd_stack_t {
 struct cciss_scsi_adapter_data_t {
 	struct Scsi_Host *scsi_host;
 	struct cciss_scsi_cmd_stack_t cmd_stack;
+	SGDescriptor_struct **cmd_sg_list;
 	int registered;
 	spinlock_t lock; // to protect ccissscsi[ctlr]; 
 };
@@ -156,6 +157,7 @@ scsi_cmd_alloc(ctlr_info_t *h)
 	memset(&c->Err, 0, sizeof(c->Err));
 	/* set physical addr of cmd and addr of scsi parameters */
 	c->cmd.busaddr = c->busaddr; 
+	c->cmd.cmdindex = c->cmdindex;
 	/* (__u32) (stk->cmd_pool_handle + 
 		(sizeof(struct cciss_scsi_cmd_stack_elem_t)*stk->top)); */
 
@@ -201,6 +203,11 @@ scsi_cmd_stack_setup(int ctlr, struct cciss_scsi_adapter_data_t *sa)
 	struct cciss_scsi_cmd_stack_t *stk;
 	size_t size;
 
+	sa->cmd_sg_list = cciss_allocate_sg_chain_blocks(hba[ctlr],
+		hba[ctlr]->chainsize, CMD_STACK_SIZE);
+	if (!sa->cmd_sg_list && hba[ctlr]->chainsize > 0)
+		return -ENOMEM;
+
 	stk = &sa->cmd_stack; 
 	size = sizeof(struct cciss_scsi_cmd_stack_elem_t) * CMD_STACK_SIZE;
 
@@ -211,14 +218,16 @@ scsi_cmd_stack_setup(int ctlr, struct cciss_scsi_adapter_data_t *sa)
 		pci_alloc_consistent(hba[ctlr]->pdev, size, &stk->cmd_pool_handle);
 
 	if (stk->pool == NULL) {
-		printk("stk->pool is null\n");
-		return -1;
+		cciss_free_sg_chain_blocks(sa->cmd_sg_list, CMD_STACK_SIZE);
+		sa->cmd_sg_list = NULL;
+		return -ENOMEM;
 	}
 
 	for (i=0; i<CMD_STACK_SIZE; i++) {
 		stk->elem[i] = &stk->pool[i];
 		stk->elem[i]->busaddr = (__u32) (stk->cmd_pool_handle + 
 			(sizeof(struct cciss_scsi_cmd_stack_elem_t) * i));
+		stk->elem[i]->cmdindex = i;
 	}
 	stk->top = CMD_STACK_SIZE-1;
 	return 0;
@@ -243,6 +252,7 @@ scsi_cmd_stack_free(int ctlr)
 
 	pci_free_consistent(hba[ctlr]->pdev, size, stk->pool, stk->cmd_pool_handle);
 	stk->pool = NULL;
+	cciss_free_sg_chain_blocks(sa->cmd_sg_list, CMD_STACK_SIZE);
 }
 
 #if 0
@@ -726,6 +736,8 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 	ctlr = hba[cp->ctlr];
 
 	scsi_dma_unmap(cmd);
+	if (cp->Header.SGTotal > ctlr->max_cmd_sgentries)
+		cciss_unmap_sg_chain_block(ctlr, cp);
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
@@ -848,6 +860,7 @@ cciss_scsi_detect(int ctlr)
 	sh->io_port = 0;	// good enough?  FIXME, 
 	sh->n_io_port = 0;	// I don't think we use these two...
 	sh->this_id = SELF_SCSI_ID;  
+	sh->sg_tablesize = hba[ctlr]->maxsgentries;
 
 	((struct cciss_scsi_adapter_data_t *) 
 		hba[ctlr]->scsi_ctlr)->scsi_host = sh;
@@ -1365,34 +1378,54 @@ cciss_scsi_proc_info(struct Scsi_Host *sh,
    dma mapping  and fills in the scatter gather entries of the 
    cciss command, cp. */
 
-static void
-cciss_scatter_gather(struct pci_dev *pdev, 
-		CommandList_struct *cp,	
-		struct scsi_cmnd *cmd)
+static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *cp,
+	struct scsi_cmnd *cmd)
 {
 	unsigned int len;
 	struct scatterlist *sg;
 	__u64 addr64;
-	int use_sg, i;
-
-	BUG_ON(scsi_sg_count(cmd) > MAXSGENTRIES);
-
-	use_sg = scsi_dma_map(cmd);
-	if (use_sg) {	/* not too many addrs? */
-		scsi_for_each_sg(cmd, sg, use_sg, i) {
+	int request_nsgs, i, chained, sg_index;
+	struct cciss_scsi_adapter_data_t *sa = h->scsi_ctlr;
+	SGDescriptor_struct *curr_sg;
+
+	BUG_ON(scsi_sg_count(cmd) > h->maxsgentries);
+
+	chained = 0;
+	sg_index = 0;
+	curr_sg = cp->SG;
+	request_nsgs = scsi_dma_map(cmd);
+	if (request_nsgs) {
+		scsi_for_each_sg(cmd, sg, request_nsgs, i) {
+			if (sg_index + 1 == h->max_cmd_sgentries &&
+				!chained && request_nsgs - i > 1) {
+				chained = 1;
+				sg_index = 0;
+				curr_sg = sa->cmd_sg_list[cp->cmdindex];
+			}
 			addr64 = (__u64) sg_dma_address(sg);
 			len  = sg_dma_len(sg);
-			cp->SG[i].Addr.lower =
-				(__u32) (addr64 & (__u64) 0x00000000FFFFFFFF);
-			cp->SG[i].Addr.upper =
-				(__u32) ((addr64 >> 32) & (__u64) 0x00000000FFFFFFFF);
-			cp->SG[i].Len = len;
-			cp->SG[i].Ext = 0;  // we are not chaining
+			curr_sg[sg_index].Addr.lower =
+				(__u32) (addr64 & 0x0FFFFFFFFULL);
+			curr_sg[sg_index].Addr.upper =
+				(__u32) ((addr64 >> 32) & 0x0FFFFFFFFULL);
+			curr_sg[sg_index].Len = len;
+			curr_sg[sg_index].Ext = 0;
+			++sg_index;
 		}
+		if (chained)
+			cciss_map_sg_chain_block(h, cp,
+				sa->cmd_sg_list[cp->cmdindex],
+				(request_nsgs - (h->max_cmd_sgentries - 1)) *
+					sizeof(SGDescriptor_struct));
 	}
-
-	cp->Header.SGList = (__u8) use_sg;   /* no. SGs contig in this cmd */
-	cp->Header.SGTotal = (__u16) use_sg; /* total sgs in this cmd list */
+	/* track how many SG entries we are using */
+	if (request_nsgs > h->maxSG)
+		h->maxSG = request_nsgs;
+	cp->Header.SGTotal = (__u8) request_nsgs + chained;
+	if (request_nsgs > h->max_cmd_sgentries)
+		cp->Header.SGList = h->max_cmd_sgentries;
+	else
+		cp->Header.SGList = cp->Header.SGTotal;
 	return;
 }
 
@@ -1490,7 +1523,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		BUG();
 		break;
 	}
-	cciss_scatter_gather(c->pdev, cp, cmd);
+	cciss_scatter_gather(c, cp, cmd);
 
 	/* Put the request on the tail of the request queue */
 

