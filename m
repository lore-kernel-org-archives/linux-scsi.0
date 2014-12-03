From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/12] advansys: Use dma_pool for sg elements
Date: Wed,  3 Dec 2014 12:44:59 +0100
Message-ID: <1417607105-85455-7-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbaLCLpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:10 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 102 ++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index c5395b5..0aea820 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1820,10 +1820,10 @@ typedef struct asc_sg_block {
 	uchar reserved2;
 	uchar reserved3;
 	uchar sg_cnt;		/* Valid entries in block. */
-	ADV_PADDR sg_ptr;	/* Pointer to next sg block. */
+	__le32 sg_ptr;	/* Pointer to next sg block. */
 	struct {
-		ADV_PADDR sg_addr;	/* SG element address. */
-		ADV_DCNT sg_count;	/* SG element count. */
+		__le32 sg_addr;	/* SG element address. */
+		__le32 sg_count;	/* SG element count. */
 	} sg_list[NO_OF_SG_PER_BLOCK];
 } ADV_SG_BLOCK;
 
@@ -1888,7 +1888,7 @@ typedef struct adv_scsi_req_q {
  */
 typedef struct adv_sgblk {
 	ADV_SG_BLOCK sg_block;	/* Sgblock structure. */
-	uchar align[32];	/* Sgblock structure padding. */
+	dma_addr_t sg_addr;	/* Physical address */
 	struct adv_sgblk *next_sgblkp;	/* Next scatter-gather structure. */
 } adv_sgblk_t;
 
@@ -2382,7 +2382,7 @@ struct asc_board {
 	adv_req_t *adv_reqp;	/* Request structures. */
 	dma_addr_t adv_reqp_addr;
 	size_t adv_reqp_size;
-	adv_sgblk_t *adv_sgblkp;	/* Scatter-gather structures. */
+	struct dma_pool *adv_sgblk_pool;	/* Scatter-gather structures. */
 	ushort bios_signature;	/* BIOS Signature. */
 	ushort bios_version;	/* BIOS Version. */
 	ushort bios_codeseg;	/* BIOS Code Segment. */
@@ -2674,6 +2674,7 @@ static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
 {
 	int sg_blk_cnt;
 	struct asc_sg_block *sg_ptr;
+	adv_sgblk_t *sgblkp;
 
 	printk("ADV_SCSI_REQ_Q at addr 0x%lx\n", (ulong)q);
 
@@ -2700,21 +2701,15 @@ static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
 
 	/* Display the request's ADV_SG_BLOCK structures. */
 	if (q->sg_list_ptr != NULL) {
+		sgblkp = container_of(q->sg_list_ptr, adv_sgblk_t, sg_block);
 		sg_blk_cnt = 0;
-		while (1) {
-			/*
-			 * 'sg_ptr' is a physical address. Convert it to a virtual
-			 * address by indexing 'sg_blk_cnt' into the virtual address
-			 * array 'sg_list_ptr'.
-			 *
-			 * XXX - Assumes all SG physical blocks are virtually contiguous.
-			 */
-			sg_ptr =
-			    &(((ADV_SG_BLOCK *)(q->sg_list_ptr))[sg_blk_cnt]);
+		while (sgblkp) {
+			sg_ptr = &sgblkp->sg_block;
 			asc_prt_adv_sgblock(sg_blk_cnt, sg_ptr);
 			if (sg_ptr->sg_ptr == 0) {
 				break;
 			}
+			sgblkp = sgblkp->next_sgblkp;
 			sg_blk_cnt++;
 		}
 	}
@@ -6237,9 +6232,8 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 		/* Remove 'sgblkp' from the request list. */
 		reqp->sgblkp = sgblkp->next_sgblkp;
 
-		/* Add 'sgblkp' to the board free list. */
-		sgblkp->next_sgblkp = boardp->adv_sgblkp;
-		boardp->adv_sgblkp = sgblkp;
+		dma_pool_free(boardp->adv_sgblk_pool, sgblkp,
+			      sgblkp->sg_addr);
 	}
 
 	ASC_DBG(1, "done\n");
@@ -7935,15 +7929,16 @@ static int
 adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp,
 	       ADV_SCSI_REQ_Q *scsiqp, struct scsi_cmnd *scp, int use_sg)
 {
-	adv_sgblk_t *sgblkp;
+	adv_sgblk_t *sgblkp, *prev_sgblkp;
 	struct scatterlist *slp;
 	int sg_elem_cnt;
 	ADV_SG_BLOCK *sg_block, *prev_sg_block;
-	ADV_PADDR sg_block_paddr;
+	dma_addr_t sgblk_paddr;
 	int i;
 
 	slp = scsi_sglist(scp);
 	sg_elem_cnt = use_sg;
+	prev_sgblkp = NULL;
 	prev_sg_block = NULL;
 	reqp->sgblkp = NULL;
 
@@ -7953,7 +7948,9 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp,
 		 * list. One 'adv_sgblk_t' structure holds NO_OF_SG_PER_BLOCK
 		 * (15) scatter-gather elements.
 		 */
-		if ((sgblkp = boardp->adv_sgblkp) == NULL) {
+		sgblkp = dma_pool_alloc(boardp->adv_sgblk_pool, GFP_KERNEL,
+					&sgblk_paddr);
+		if (!sgblkp) {
 			ASC_DBG(1, "no free adv_sgblk_t\n");
 			ASC_STATS(scp->device->host, adv_build_nosg);
 
@@ -7964,24 +7961,16 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp,
 			while ((sgblkp = reqp->sgblkp) != NULL) {
 				/* Remove 'sgblkp' from the request list. */
 				reqp->sgblkp = sgblkp->next_sgblkp;
-
-				/* Add 'sgblkp' to the board free list. */
-				sgblkp->next_sgblkp = boardp->adv_sgblkp;
-				boardp->adv_sgblkp = sgblkp;
+				sgblkp->next_sgblkp = NULL;
+				dma_pool_free(boardp->adv_sgblk_pool, sgblkp,
+					      sgblkp->sg_addr);
 			}
 			return ASC_BUSY;
 		}
-
 		/* Complete 'adv_sgblk_t' board allocation. */
-		boardp->adv_sgblkp = sgblkp->next_sgblkp;
+		sgblkp->sg_addr = sgblk_paddr;
 		sgblkp->next_sgblkp = NULL;
-
-		/*
-		 * Get 8 byte aligned virtual and physical addresses
-		 * for the allocated ADV_SG_BLOCK structure.
-		 */
-		sg_block = (ADV_SG_BLOCK *)ADV_8BALIGN(&sgblkp->sg_block);
-		sg_block_paddr = virt_to_bus(sg_block);
+		sg_block = &sgblkp->sg_block;
 
 		/*
 		 * Check if this is the first 'adv_sgblk_t' for the
@@ -7996,17 +7985,16 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp,
 			 * address pointers.
 			 */
 			scsiqp->sg_list_ptr = sg_block;
-			scsiqp->sg_real_addr = cpu_to_le32(sg_block_paddr);
+			scsiqp->sg_real_addr = cpu_to_le32(sgblk_paddr);
 		} else {
 			/* Request's second or later scatter-gather block. */
-			sgblkp->next_sgblkp = reqp->sgblkp;
-			reqp->sgblkp = sgblkp;
+			prev_sgblkp->next_sgblkp = reqp->sgblkp;
 
 			/*
 			 * Point the previous ADV_SG_BLOCK structure to
 			 * the newly allocated ADV_SG_BLOCK structure.
 			 */
-			prev_sg_block->sg_ptr = cpu_to_le32(sg_block_paddr);
+			prev_sg_block->sg_ptr = cpu_to_le32(sgblk_paddr);
 		}
 
 		for (i = 0; i < NO_OF_SG_PER_BLOCK; i++) {
@@ -8017,15 +8005,19 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp,
 			ASC_STATS_ADD(scp->device->host, xfer_sect,
 				      DIV_ROUND_UP(sg_dma_len(slp), 512));
 
-			if (--sg_elem_cnt == 0) {	/* Last ADV_SG_BLOCK and scatter-gather entry. */
+			if (--sg_elem_cnt == 0) {
+				/*
+				 * Last ADV_SG_BLOCK and scatter-gather entry.
+				 */
 				sg_block->sg_cnt = i + 1;
-				sg_block->sg_ptr = 0L;	/* Last ADV_SG_BLOCK in list. */
+				sg_block->sg_ptr = 0L; /* Last ADV_SG_BLOCK in list. */
 				return ADV_SUCCESS;
 			}
 			slp++;
 		}
 		sg_block->sg_cnt = NO_OF_SG_PER_BLOCK;
 		prev_sg_block = sg_block;
+		prev_sgblkp = sgblkp;
 	}
 }
 
@@ -11193,8 +11185,7 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 {
 	struct asc_board *board = shost_priv(shost);
 	struct adv_dvc_var *adv_dvc = &board->dvc_var.adv_dvc_var;
-	int sg_cnt = 0;
-	adv_sgblk_t *sgp;
+	size_t sgblk_pool_size;
 	int warn_code, err_code;
 
 	/*
@@ -11231,22 +11222,14 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 	 * Allocate up to ADV_TOT_SG_BLOCK request structures for
 	 * the Wide board. Each structure is about 136 bytes.
 	 */
-	board->adv_sgblkp = NULL;
-	for (sg_cnt = 0; sg_cnt < ADV_TOT_SG_BLOCK; sg_cnt++) {
-		sgp = kmalloc(sizeof(adv_sgblk_t), GFP_KERNEL);
-
-		if (!sgp)
-			break;
-
-		sgp->next_sgblkp = board->adv_sgblkp;
-		board->adv_sgblkp = sgp;
-
-	}
+	sgblk_pool_size = sizeof(adv_sgblk_t) * ADV_TOT_SG_BLOCK;
+	board->adv_sgblk_pool = dma_pool_create("adv_sgblk", board->dev,
+						sgblk_pool_size, 32, 0);
 
-	ASC_DBG(1, "sg_cnt %d * %lu = %lu bytes\n", sg_cnt, sizeof(adv_sgblk_t),
-		 sizeof(adv_sgblk_t) * sg_cnt);
+	ASC_DBG(1, "sg_cnt %d * %lu = %lu bytes\n", ADV_TOT_SG_BLOCK,
+		sizeof(adv_sgblk_t), sgblk_pool_size);
 
-	if (!board->adv_sgblkp)
+	if (!board->adv_sgblk_pool)
 		goto kmalloc_failed;
 
 	if (adv_dvc->chip_type == ADV_CHIP_ASC3550) {
@@ -11289,10 +11272,9 @@ static void advansys_wide_free_mem(struct asc_board *board)
 				  board->adv_reqp, board->adv_reqp_addr);
 		board->adv_reqp = NULL;
 	}
-	while (board->adv_sgblkp) {
-		adv_sgblk_t *sgp = board->adv_sgblkp;
-		board->adv_sgblkp = sgp->next_sgblkp;
-		kfree(sgp);
+	if (board->adv_sgblk_pool) {
+		dma_pool_destroy(board->adv_sgblk_pool);
+		board->adv_sgblk_pool = NULL;
 	}
 }
 
-- 
1.8.5.2

