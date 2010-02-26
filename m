From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 6/9] cciss: factor out scatter gather chain block mapping code
Date: Fri, 26 Feb 2010 16:01:37 -0600
Message-ID: <20100226220137.11979.64414.stgit@beardog.cce.hp.com>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:6780 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966401Ab0BZV61 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 16:58:27 -0500
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: factor out scatter gather chain block mapping code
Rationale is I want to use this code from the scsi half of the
driver.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   63 ++++++++++++++++++++++++++-----------------------
 1 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index c0d794c..9e3af30 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -301,6 +301,35 @@ clean:
 	return NULL;
 }
 
+static void cciss_unmap_sg_chain_block(ctlr_info_t *h, CommandList_struct *c)
+{
+	SGDescriptor_struct *chain_sg;
+	u64bit temp64;
+
+	if (c->Header.SGTotal <= h->max_cmd_sgentries)
+		return;
+
+	chain_sg = &c->SG[h->max_cmd_sgentries - 1];
+	temp64.val32.lower = chain_sg->Addr.lower;
+	temp64.val32.upper = chain_sg->Addr.upper;
+	pci_unmap_single(h->pdev, temp64.val, chain_sg->Len, PCI_DMA_TODEVICE);
+}
+
+static void cciss_map_sg_chain_block(ctlr_info_t *h, CommandList_struct *c,
+	SGDescriptor_struct *chain_block, int len)
+{
+	SGDescriptor_struct *chain_sg;
+	u64bit temp64;
+
+	chain_sg = &c->SG[h->max_cmd_sgentries - 1];
+	chain_sg->Ext = CCISS_SG_CHAIN;
+	chain_sg->Len = len;
+	temp64.val = pci_map_single(h->pdev, chain_block, len,
+				PCI_DMA_TODEVICE);
+	chain_sg->Addr.lower = temp64.val32.lower;
+	chain_sg->Addr.upper = temp64.val32.upper;
+}
+
 #include "cciss_scsi.c"		/* For SCSI tape support */
 
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
@@ -1715,10 +1744,7 @@ static void cciss_softirq_done(struct request *rq)
 	/* unmap the DMA mapping for all the scatter gather elements */
 	for (i = 0; i < cmd->Header.SGList; i++) {
 		if (curr_sg[sg_index].Ext == CCISS_SG_CHAIN) {
-			temp64.val32.lower = cmd->SG[i].Addr.lower;
-			temp64.val32.upper = cmd->SG[i].Addr.upper;
-			pci_unmap_single(h->pdev, temp64.val,
-				cmd->SG[i].Len, PCI_DMA_TODEVICE);
+			cciss_unmap_sg_chain_block(h, cmd);
 			/* Point to the next block */
 			curr_sg = h->cmd_sg_list[cmd->cmdindex];
 			sg_index = 0;
@@ -3122,7 +3148,6 @@ static void do_cciss_request(struct request_queue *q)
 	SGDescriptor_struct *curr_sg;
 	drive_info_struct *drv;
 	int i, dir;
-	int nseg = 0;
 	int sg_index = 0;
 	int chained = 0;
 
@@ -3189,11 +3214,6 @@ static void do_cciss_request(struct request_queue *q)
 	for (i = 0; i < seg; i++) {
 		if (((sg_index+1) == (h->max_cmd_sgentries)) &&
 			!chained && ((seg - i) > 1)) {
-			nseg = seg - i;
-			curr_sg[sg_index].Len = (nseg) *
-					sizeof(SGDescriptor_struct);
-			curr_sg[sg_index].Ext = CCISS_SG_CHAIN;
-
 			/* Point to next chain block. */
 			curr_sg = h->cmd_sg_list[c->cmdindex];
 			sg_index = 0;
@@ -3206,27 +3226,12 @@ static void do_cciss_request(struct request_queue *q)
 		curr_sg[sg_index].Addr.lower = temp64.val32.lower;
 		curr_sg[sg_index].Addr.upper = temp64.val32.upper;
 		curr_sg[sg_index].Ext = 0;  /* we are not chaining */
-
 		++sg_index;
 	}
-
-	if (chained) {
-		int len;
-		dma_addr_t dma_addr;
-		curr_sg = c->SG;
-		sg_index = h->max_cmd_sgentries - 1;
-		len = curr_sg[sg_index].Len;
-		/* Setup pointer to next chain block.
-		 * Fill out last element in current chain
-		 * block with address of next chain block.
-		 */
-		temp64.val = pci_map_single(h->pdev,
-					h->cmd_sg_list[c->cmdindex], len,
-					PCI_DMA_TODEVICE);
-		dma_addr = temp64.val;
-		curr_sg[sg_index].Addr.lower = temp64.val32.lower;
-		curr_sg[sg_index].Addr.upper = temp64.val32.upper;
-	}
+	if (chained)
+		cciss_map_sg_chain_block(h, c, h->cmd_sg_list[c->cmdindex],
+			(seg - (h->max_cmd_sgentries - 1)) *
+				sizeof(SGDescriptor_struct));
 
 	/* track how many SG entries we are using */
 	if (seg > h->maxSG)

