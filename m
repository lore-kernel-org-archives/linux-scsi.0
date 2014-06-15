From: Joe Perches <joe@perches.com>
Subject: [PATCH -next 16/26] bnx2fc: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:45 -0700
Message-ID: <ee35c91cf0dae28fb60d46d675c7d672dd069eee.1402863905.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 59 +++++++++++++++++-----------------------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c | 51 ++++++++++++++--------------------
 2 files changed, 46 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 512aed3..96f2586 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1854,16 +1854,15 @@ int bnx2fc_setup_task_ctx(struct bnx2fc_hba *hba)
 	 * entries. Hence the limit with one page is 8192 task context
 	 * entries.
 	 */
-	hba->task_ctx_bd_tbl = dma_alloc_coherent(&hba->pcidev->dev,
-						  PAGE_SIZE,
-						  &hba->task_ctx_bd_dma,
-						  GFP_KERNEL);
+	hba->task_ctx_bd_tbl = dma_zalloc_coherent(&hba->pcidev->dev,
+						   PAGE_SIZE,
+						   &hba->task_ctx_bd_dma,
+						   GFP_KERNEL);
 	if (!hba->task_ctx_bd_tbl) {
 		printk(KERN_ERR PFX "unable to allocate task context BDT\n");
 		rc = -1;
 		goto out;
 	}
-	memset(hba->task_ctx_bd_tbl, 0, PAGE_SIZE);
 
 	/*
 	 * Allocate task_ctx which is an array of pointers pointing to
@@ -1892,16 +1891,15 @@ int bnx2fc_setup_task_ctx(struct bnx2fc_hba *hba)
 	task_ctx_bdt = (struct regpair *)hba->task_ctx_bd_tbl;
 	for (i = 0; i < task_ctx_arr_sz; i++) {
 
-		hba->task_ctx[i] = dma_alloc_coherent(&hba->pcidev->dev,
-						      PAGE_SIZE,
-						      &hba->task_ctx_dma[i],
-						      GFP_KERNEL);
+		hba->task_ctx[i] = dma_zalloc_coherent(&hba->pcidev->dev,
+						       PAGE_SIZE,
+						       &hba->task_ctx_dma[i],
+						       GFP_KERNEL);
 		if (!hba->task_ctx[i]) {
 			printk(KERN_ERR PFX "unable to alloc task context\n");
 			rc = -1;
 			goto out3;
 		}
-		memset(hba->task_ctx[i], 0, PAGE_SIZE);
 		addr = (u64)hba->task_ctx_dma[i];
 		task_ctx_bdt->hi = cpu_to_le32((u64)addr >> 32);
 		task_ctx_bdt->lo = cpu_to_le32((u32)addr);
@@ -2031,27 +2029,23 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 
 	for (i = 0; i < segment_count; ++i) {
 		hba->hash_tbl_segments[i] =
-			dma_alloc_coherent(&hba->pcidev->dev,
-					   BNX2FC_HASH_TBL_CHUNK_SIZE,
-					   &dma_segment_array[i],
-					   GFP_KERNEL);
+			dma_zalloc_coherent(&hba->pcidev->dev,
+					    BNX2FC_HASH_TBL_CHUNK_SIZE,
+					    &dma_segment_array[i],
+					    GFP_KERNEL);
 		if (!hba->hash_tbl_segments[i]) {
 			printk(KERN_ERR PFX "hash segment alloc failed\n");
 			goto cleanup_dma;
 		}
-		memset(hba->hash_tbl_segments[i], 0,
-		       BNX2FC_HASH_TBL_CHUNK_SIZE);
 	}
 
-	hba->hash_tbl_pbl = dma_alloc_coherent(&hba->pcidev->dev,
-					       PAGE_SIZE,
-					       &hba->hash_tbl_pbl_dma,
-					       GFP_KERNEL);
+	hba->hash_tbl_pbl = dma_zalloc_coherent(&hba->pcidev->dev, PAGE_SIZE,
+						&hba->hash_tbl_pbl_dma,
+						GFP_KERNEL);
 	if (!hba->hash_tbl_pbl) {
 		printk(KERN_ERR PFX "hash table pbl alloc failed\n");
 		goto cleanup_dma;
 	}
-	memset(hba->hash_tbl_pbl, 0, PAGE_SIZE);
 
 	pbl = hba->hash_tbl_pbl;
 	for (i = 0; i < segment_count; ++i) {
@@ -2108,27 +2102,26 @@ int bnx2fc_setup_fw_resc(struct bnx2fc_hba *hba)
 		return -ENOMEM;
 
 	mem_size = BNX2FC_NUM_MAX_SESS * sizeof(struct regpair);
-	hba->t2_hash_tbl_ptr = dma_alloc_coherent(&hba->pcidev->dev, mem_size,
-						  &hba->t2_hash_tbl_ptr_dma,
-						  GFP_KERNEL);
+	hba->t2_hash_tbl_ptr = dma_zalloc_coherent(&hba->pcidev->dev,
+						   mem_size,
+						   &hba->t2_hash_tbl_ptr_dma,
+						   GFP_KERNEL);
 	if (!hba->t2_hash_tbl_ptr) {
 		printk(KERN_ERR PFX "unable to allocate t2 hash table ptr\n");
 		bnx2fc_free_fw_resc(hba);
 		return -ENOMEM;
 	}
-	memset(hba->t2_hash_tbl_ptr, 0x00, mem_size);
 
 	mem_size = BNX2FC_NUM_MAX_SESS *
 				sizeof(struct fcoe_t2_hash_table_entry);
-	hba->t2_hash_tbl = dma_alloc_coherent(&hba->pcidev->dev, mem_size,
-					      &hba->t2_hash_tbl_dma,
-					      GFP_KERNEL);
+	hba->t2_hash_tbl = dma_zalloc_coherent(&hba->pcidev->dev, mem_size,
+					       &hba->t2_hash_tbl_dma,
+					       GFP_KERNEL);
 	if (!hba->t2_hash_tbl) {
 		printk(KERN_ERR PFX "unable to allocate t2 hash table\n");
 		bnx2fc_free_fw_resc(hba);
 		return -ENOMEM;
 	}
-	memset(hba->t2_hash_tbl, 0x00, mem_size);
 	for (i = 0; i < BNX2FC_NUM_MAX_SESS; i++) {
 		addr = (unsigned long) hba->t2_hash_tbl_dma +
 			 ((i+1) * sizeof(struct fcoe_t2_hash_table_entry));
@@ -2145,16 +2138,14 @@ int bnx2fc_setup_fw_resc(struct bnx2fc_hba *hba)
 		return -ENOMEM;
 	}
 
-	hba->stats_buffer = dma_alloc_coherent(&hba->pcidev->dev,
-					       PAGE_SIZE,
-					       &hba->stats_buf_dma,
-					       GFP_KERNEL);
+	hba->stats_buffer = dma_zalloc_coherent(&hba->pcidev->dev, PAGE_SIZE,
+						&hba->stats_buf_dma,
+						GFP_KERNEL);
 	if (!hba->stats_buffer) {
 		printk(KERN_ERR PFX "unable to alloc Stats Buffer\n");
 		bnx2fc_free_fw_resc(hba);
 		return -ENOMEM;
 	}
-	memset(hba->stats_buffer, 0x00, PAGE_SIZE);
 
 	return 0;
 }
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 6870cf6..76155b8 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -677,56 +677,53 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	tgt->sq_mem_size = (tgt->sq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			   CNIC_PAGE_MASK;
 
-	tgt->sq = dma_alloc_coherent(&hba->pcidev->dev, tgt->sq_mem_size,
-				     &tgt->sq_dma, GFP_KERNEL);
+	tgt->sq = dma_zalloc_coherent(&hba->pcidev->dev, tgt->sq_mem_size,
+				      &tgt->sq_dma, GFP_KERNEL);
 	if (!tgt->sq) {
 		printk(KERN_ERR PFX "unable to allocate SQ memory %d\n",
 			tgt->sq_mem_size);
 		goto mem_alloc_failure;
 	}
-	memset(tgt->sq, 0, tgt->sq_mem_size);
 
 	/* Allocate and map CQ */
 	tgt->cq_mem_size = tgt->max_cqes * BNX2FC_CQ_WQE_SIZE;
 	tgt->cq_mem_size = (tgt->cq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			   CNIC_PAGE_MASK;
 
-	tgt->cq = dma_alloc_coherent(&hba->pcidev->dev, tgt->cq_mem_size,
-				     &tgt->cq_dma, GFP_KERNEL);
+	tgt->cq = dma_zalloc_coherent(&hba->pcidev->dev, tgt->cq_mem_size,
+				      &tgt->cq_dma, GFP_KERNEL);
 	if (!tgt->cq) {
 		printk(KERN_ERR PFX "unable to allocate CQ memory %d\n",
 			tgt->cq_mem_size);
 		goto mem_alloc_failure;
 	}
-	memset(tgt->cq, 0, tgt->cq_mem_size);
 
 	/* Allocate and map RQ and RQ PBL */
 	tgt->rq_mem_size = tgt->max_rqes * BNX2FC_RQ_WQE_SIZE;
 	tgt->rq_mem_size = (tgt->rq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			   CNIC_PAGE_MASK;
 
-	tgt->rq = dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_mem_size,
-					&tgt->rq_dma, GFP_KERNEL);
+	tgt->rq = dma_zalloc_coherent(&hba->pcidev->dev, tgt->rq_mem_size,
+				      &tgt->rq_dma, GFP_KERNEL);
 	if (!tgt->rq) {
 		printk(KERN_ERR PFX "unable to allocate RQ memory %d\n",
 			tgt->rq_mem_size);
 		goto mem_alloc_failure;
 	}
-	memset(tgt->rq, 0, tgt->rq_mem_size);
 
 	tgt->rq_pbl_size = (tgt->rq_mem_size / CNIC_PAGE_SIZE) * sizeof(void *);
 	tgt->rq_pbl_size = (tgt->rq_pbl_size + (CNIC_PAGE_SIZE - 1)) &
 			   CNIC_PAGE_MASK;
 
-	tgt->rq_pbl = dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_pbl_size,
-					 &tgt->rq_pbl_dma, GFP_KERNEL);
+	tgt->rq_pbl = dma_zalloc_coherent(&hba->pcidev->dev,
+					  tgt->rq_pbl_size, &tgt->rq_pbl_dma,
+					  GFP_KERNEL);
 	if (!tgt->rq_pbl) {
 		printk(KERN_ERR PFX "unable to allocate RQ PBL %d\n",
 			tgt->rq_pbl_size);
 		goto mem_alloc_failure;
 	}
 
-	memset(tgt->rq_pbl, 0, tgt->rq_pbl_size);
 	num_pages = tgt->rq_mem_size / CNIC_PAGE_SIZE;
 	page = tgt->rq_dma;
 	pbl = (u32 *)tgt->rq_pbl;
@@ -744,44 +741,41 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	tgt->xferq_mem_size = (tgt->xferq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			       CNIC_PAGE_MASK;
 
-	tgt->xferq = dma_alloc_coherent(&hba->pcidev->dev, tgt->xferq_mem_size,
-					&tgt->xferq_dma, GFP_KERNEL);
+	tgt->xferq = dma_zalloc_coherent(&hba->pcidev->dev, tgt->xferq_mem_size,
+					 &tgt->xferq_dma, GFP_KERNEL);
 	if (!tgt->xferq) {
 		printk(KERN_ERR PFX "unable to allocate XFERQ %d\n",
 			tgt->xferq_mem_size);
 		goto mem_alloc_failure;
 	}
-	memset(tgt->xferq, 0, tgt->xferq_mem_size);
 
 	/* Allocate and map CONFQ & CONFQ PBL */
 	tgt->confq_mem_size = tgt->max_sqes * BNX2FC_CONFQ_WQE_SIZE;
 	tgt->confq_mem_size = (tgt->confq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			       CNIC_PAGE_MASK;
 
-	tgt->confq = dma_alloc_coherent(&hba->pcidev->dev, tgt->confq_mem_size,
-					&tgt->confq_dma, GFP_KERNEL);
+	tgt->confq = dma_zalloc_coherent(&hba->pcidev->dev, tgt->confq_mem_size,
+					 &tgt->confq_dma, GFP_KERNEL);
 	if (!tgt->confq) {
 		printk(KERN_ERR PFX "unable to allocate CONFQ %d\n",
 			tgt->confq_mem_size);
 		goto mem_alloc_failure;
 	}
-	memset(tgt->confq, 0, tgt->confq_mem_size);
 
 	tgt->confq_pbl_size =
 		(tgt->confq_mem_size / CNIC_PAGE_SIZE) * sizeof(void *);
 	tgt->confq_pbl_size =
 		(tgt->confq_pbl_size + (CNIC_PAGE_SIZE - 1)) & CNIC_PAGE_MASK;
 
-	tgt->confq_pbl = dma_alloc_coherent(&hba->pcidev->dev,
-					    tgt->confq_pbl_size,
-					    &tgt->confq_pbl_dma, GFP_KERNEL);
+	tgt->confq_pbl = dma_zalloc_coherent(&hba->pcidev->dev,
+					     tgt->confq_pbl_size,
+					     &tgt->confq_pbl_dma, GFP_KERNEL);
 	if (!tgt->confq_pbl) {
 		printk(KERN_ERR PFX "unable to allocate CONFQ PBL %d\n",
 			tgt->confq_pbl_size);
 		goto mem_alloc_failure;
 	}
 
-	memset(tgt->confq_pbl, 0, tgt->confq_pbl_size);
 	num_pages = tgt->confq_mem_size / CNIC_PAGE_SIZE;
 	page = tgt->confq_dma;
 	pbl = (u32 *)tgt->confq_pbl;
@@ -797,31 +791,28 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	/* Allocate and map ConnDB */
 	tgt->conn_db_mem_size = sizeof(struct fcoe_conn_db);
 
-	tgt->conn_db = dma_alloc_coherent(&hba->pcidev->dev,
-					  tgt->conn_db_mem_size,
-					  &tgt->conn_db_dma, GFP_KERNEL);
+	tgt->conn_db = dma_zalloc_coherent(&hba->pcidev->dev,
+					   tgt->conn_db_mem_size,
+					   &tgt->conn_db_dma, GFP_KERNEL);
 	if (!tgt->conn_db) {
 		printk(KERN_ERR PFX "unable to allocate conn_db %d\n",
 						tgt->conn_db_mem_size);
 		goto mem_alloc_failure;
 	}
-	memset(tgt->conn_db, 0, tgt->conn_db_mem_size);
-
 
 	/* Allocate and map LCQ */
 	tgt->lcq_mem_size = (tgt->max_sqes + 8) * BNX2FC_SQ_WQE_SIZE;
 	tgt->lcq_mem_size = (tgt->lcq_mem_size + (CNIC_PAGE_SIZE - 1)) &
 			     CNIC_PAGE_MASK;
 
-	tgt->lcq = dma_alloc_coherent(&hba->pcidev->dev, tgt->lcq_mem_size,
-				      &tgt->lcq_dma, GFP_KERNEL);
+	tgt->lcq = dma_zalloc_coherent(&hba->pcidev->dev, tgt->lcq_mem_size,
+				       &tgt->lcq_dma, GFP_KERNEL);
 
 	if (!tgt->lcq) {
 		printk(KERN_ERR PFX "unable to allocate lcq %d\n",
 		       tgt->lcq_mem_size);
 		goto mem_alloc_failure;
 	}
-	memset(tgt->lcq, 0, tgt->lcq_mem_size);
 
 	tgt->conn_db->rq_prod = 0x8000;
 
-- 
1.8.1.2.459.gbcd45b4.dirty
