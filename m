From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 18/43] hpsa: refactor freeing of resources into more logical
 functions
Date: Sat, 21 Feb 2015 16:19:08 -0600
Message-ID: <20150221221908.21954.81705.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55777 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbbBUWU2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:20:28 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 9DA2A1F4
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:20:27 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

refactor freeing of resources into more logical functions

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  104 +++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 21e3610..e61e4eb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -234,6 +234,8 @@ static void check_ioctl_unit_attention(struct ctlr_info *h,
 static void calc_bucket_map(int *bucket, int num_buckets,
 	int nsgs, int min_blocks, u32 *bucket_map);
 static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h);
+static void hpsa_free_ioaccel1_cmd_and_bft(struct ctlr_info *h);
+static void hpsa_free_ioaccel2_cmd_and_bft(struct ctlr_info *h);
 static inline u32 next_command(struct ctlr_info *h, u8 q);
 static int hpsa_find_cfg_addrs(struct pci_dev *pdev, void __iomem *vaddr,
 			       u32 *cfg_base_addr, u64 *cfg_base_addr_index,
@@ -6938,6 +6940,21 @@ out_disable:
 	return rc;
 }
 
+static void hpsa_free_cmd_pool(struct ctlr_info *h)
+{
+	kfree(h->cmd_pool_bits);
+	if (h->cmd_pool)
+		pci_free_consistent(h->pdev,
+				h->nr_cmds * sizeof(struct CommandList),
+				h->cmd_pool,
+				h->cmd_pool_dhandle);
+	if (h->errinfo_pool)
+		pci_free_consistent(h->pdev,
+				h->nr_cmds * sizeof(struct ErrorInfo),
+				h->errinfo_pool,
+				h->errinfo_pool_dhandle);
+}
+
 static int hpsa_alloc_cmd_pool(struct ctlr_info *h)
 {
 	h->cmd_pool_bits = kzalloc(
@@ -6962,28 +6979,6 @@ clean_up:
 	return -ENOMEM;
 }
 
-static void hpsa_free_cmd_pool(struct ctlr_info *h)
-{
-	kfree(h->cmd_pool_bits);
-	if (h->cmd_pool)
-		pci_free_consistent(h->pdev,
-			    h->nr_cmds * sizeof(struct CommandList),
-			    h->cmd_pool, h->cmd_pool_dhandle);
-	if (h->ioaccel2_cmd_pool)
-		pci_free_consistent(h->pdev,
-			h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
-			h->ioaccel2_cmd_pool, h->ioaccel2_cmd_pool_dhandle);
-	if (h->errinfo_pool)
-		pci_free_consistent(h->pdev,
-			    h->nr_cmds * sizeof(struct ErrorInfo),
-			    h->errinfo_pool,
-			    h->errinfo_pool_dhandle);
-	if (h->ioaccel_cmd_pool)
-		pci_free_consistent(h->pdev,
-			h->nr_cmds * sizeof(struct io_accel1_cmd),
-			h->ioaccel_cmd_pool, h->ioaccel_cmd_pool_dhandle);
-}
-
 static void hpsa_irq_affinity_hints(struct ctlr_info *h)
 {
 	int i, cpu;
@@ -7104,8 +7099,10 @@ static void hpsa_free_reply_queues(struct ctlr_info *h)
 	for (i = 0; i < h->nreply_queues; i++) {
 		if (!h->reply_queue[i].head)
 			continue;
-		pci_free_consistent(h->pdev, h->reply_queue_size,
-			h->reply_queue[i].head, h->reply_queue[i].busaddr);
+		pci_free_consistent(h->pdev,
+					h->reply_queue_size,
+					h->reply_queue[i].head,
+					h->reply_queue[i].busaddr);
 		h->reply_queue[i].head = NULL;
 		h->reply_queue[i].busaddr = 0;
 	}
@@ -7116,9 +7113,10 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 	hpsa_free_irqs(h);
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
-	kfree(h->ioaccel1_blockFetchTable);
-	kfree(h->blockFetchTable);
-	hpsa_free_reply_queues(h);
+	kfree(h->blockFetchTable);		/* perf 2 */
+	hpsa_free_reply_queues(h);		/* perf 1 */
+	hpsa_free_ioaccel1_cmd_and_bft(h);	/* perf 1 */
+	hpsa_free_ioaccel2_cmd_and_bft(h);	/* perf 1 */
 	hpsa_free_cfgtables(h);			/* pci_init 4 */
 	iounmap(h->vaddr);			/* pci_init 3 */
 	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
@@ -7548,6 +7546,8 @@ reinit_after_soft_reset:
 clean4:
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
+	hpsa_free_ioaccel1_cmd_and_bft(h);
+	hpsa_free_ioaccel2_cmd_and_bft(h);
 clean2_and_free_irqs:
 	hpsa_free_irqs(h);
 clean2:
@@ -7649,17 +7649,11 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 
 	hpsa_free_device_info(h);
 	hpsa_free_sg_chain_blocks(h);
-	pci_free_consistent(h->pdev,
-		h->nr_cmds * sizeof(struct CommandList),
-		h->cmd_pool, h->cmd_pool_dhandle);
-	pci_free_consistent(h->pdev,
-		h->nr_cmds * sizeof(struct ErrorInfo),
-		h->errinfo_pool, h->errinfo_pool_dhandle);
-	hpsa_free_reply_queues(h);
-	kfree(h->cmd_pool_bits);
-	kfree(h->blockFetchTable);
-	kfree(h->ioaccel1_blockFetchTable);
-	kfree(h->ioaccel2_blockFetchTable);
+	kfree(h->blockFetchTable);		/* perf 2 */
+	hpsa_free_reply_queues(h);		/* perf 1 */
+	hpsa_free_ioaccel1_cmd_and_bft(h);	/* perf 1 */
+	hpsa_free_ioaccel2_cmd_and_bft(h);	/* perf 1 */
+	hpsa_free_cmd_pool(h);			/* init_one 5 */
 	kfree(h->hba_inquiry_data);
 
 	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
@@ -7906,6 +7900,17 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	return 0;
 }
 
+/* Free ioaccel1 mode command blocks and block fetch table */
+static void hpsa_free_ioaccel1_cmd_and_bft(struct ctlr_info *h)
+{
+	if (h->ioaccel_cmd_pool)
+		pci_free_consistent(h->pdev,
+			h->nr_cmds * sizeof(*h->ioaccel_cmd_pool),
+			h->ioaccel_cmd_pool,
+			h->ioaccel_cmd_pool_dhandle);
+	kfree(h->ioaccel1_blockFetchTable);
+}
+
 /* Allocate ioaccel1 mode command blocks and block fetch table */
 static int hpsa_alloc_ioaccel1_cmd_and_bft(struct ctlr_info *h)
 {
@@ -7938,14 +7943,21 @@ static int hpsa_alloc_ioaccel1_cmd_and_bft(struct ctlr_info *h)
 	return 0;
 
 clean_up:
-	if (h->ioaccel_cmd_pool)
-		pci_free_consistent(h->pdev,
-			h->nr_cmds * sizeof(*h->ioaccel_cmd_pool),
-			h->ioaccel_cmd_pool, h->ioaccel_cmd_pool_dhandle);
-	kfree(h->ioaccel1_blockFetchTable);
+	hpsa_free_ioaccel1_cmd_and_bft(h);
 	return 1;
 }
 
+/* Free ioaccel2 mode command blocks and block fetch table */
+static void hpsa_free_ioaccel2_cmd_and_bft(struct ctlr_info *h)
+{
+	if (h->ioaccel2_cmd_pool)
+		pci_free_consistent(h->pdev,
+			h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
+			h->ioaccel2_cmd_pool,
+			h->ioaccel2_cmd_pool_dhandle);
+	kfree(h->ioaccel2_blockFetchTable);
+}
+
 /* Allocate ioaccel2 mode command blocks and block fetch table */
 static int hpsa_alloc_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 {
@@ -7976,11 +7988,7 @@ static int hpsa_alloc_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 	return 0;
 
 clean_up:
-	if (h->ioaccel2_cmd_pool)
-		pci_free_consistent(h->pdev,
-			h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
-			h->ioaccel2_cmd_pool, h->ioaccel2_cmd_pool_dhandle);
-	kfree(h->ioaccel2_blockFetchTable);
+	hpsa_free_ioaccel2_cmd_and_bft(h);
 	return 1;
 }
 

