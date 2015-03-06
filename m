From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 18/41] hpsa: refactor freeing of resources into more
 logical functions
Date: Fri, 06 Mar 2015 17:47:23 -0600
Message-ID: <20150306234722.29973.16998.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:40829 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbbCFXsw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:48:52 -0500
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
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
index d40fc65..6d3402a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -235,6 +235,8 @@ static void check_ioctl_unit_attention(struct ctlr_info *h,
 static void calc_bucket_map(int *bucket, int num_buckets,
 	int nsgs, int min_blocks, u32 *bucket_map);
 static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h);
+static void hpsa_free_ioaccel1_cmd_and_bft(struct ctlr_info *h);
+static void hpsa_free_ioaccel2_cmd_and_bft(struct ctlr_info *h);
 static inline u32 next_command(struct ctlr_info *h, u8 q);
 static int hpsa_find_cfg_addrs(struct pci_dev *pdev, void __iomem *vaddr,
 			       u32 *cfg_base_addr, u64 *cfg_base_addr_index,
@@ -6929,6 +6931,21 @@ out_disable:
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
@@ -6953,28 +6970,6 @@ clean_up:
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
@@ -7095,8 +7090,10 @@ static void hpsa_free_reply_queues(struct ctlr_info *h)
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
@@ -7107,9 +7104,10 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
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
@@ -7540,6 +7538,8 @@ reinit_after_soft_reset:
 clean4:
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
+	hpsa_free_ioaccel1_cmd_and_bft(h);
+	hpsa_free_ioaccel2_cmd_and_bft(h);
 clean2_and_free_irqs:
 	hpsa_free_irqs(h);
 clean2:
@@ -7641,17 +7641,11 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 
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
@@ -7898,6 +7892,17 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
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
@@ -7930,14 +7935,21 @@ static int hpsa_alloc_ioaccel1_cmd_and_bft(struct ctlr_info *h)
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
@@ -7968,11 +7980,7 @@ static int hpsa_alloc_ioaccel2_cmd_and_bft(struct ctlr_info *h)
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
 

