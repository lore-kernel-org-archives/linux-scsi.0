From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 27/33] advansys: convert to use the data buffer accessors
Date: Mon, 16 Jul 2007 11:47:41 +0200
Message-ID: <1184579268182-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9345 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762049AbXGPJsk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:40 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/advansys.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 2b66897..f61a0ee 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -6383,7 +6383,7 @@ asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
          */
         int                     sgcnt;
 	int			use_sg;
-        struct scatterlist      *slp;
+        struct scatterlist      *slp, *sg;
 
 	slp = (struct scatterlist *)scp->request_buffer;
 	use_sg = dma_map_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
@@ -6417,10 +6417,10 @@ asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
         /*
          * Convert scatter-gather list into ASC_SG_HEAD list.
          */
-	for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
-	    asc_sg_head.sg_list[sgcnt].addr = cpu_to_le32(sg_dma_address(slp));
-	    asc_sg_head.sg_list[sgcnt].bytes = cpu_to_le32(sg_dma_len(slp));
-	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(slp), 512));
+	scsi_for_each_sg(scp, sg, use_sg, sgcnt) {
+	    asc_sg_head.sg_list[sgcnt].addr = cpu_to_le32(sg_dma_address(sg));
+	    asc_sg_head.sg_list[sgcnt].bytes = cpu_to_le32(sg_dma_len(sg));
+	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(sg), 512));
         }
     }
 
@@ -6615,7 +6615,7 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp, int
 {
     adv_sgblk_t         *sgblkp;
     ADV_SCSI_REQ_Q      *scsiqp;
-    struct scatterlist  *slp;
+    struct scatterlist  *slp, *sg;
     int                 sg_elem_cnt;
     ADV_SG_BLOCK        *sg_block, *prev_sg_block;
     ADV_PADDR           sg_block_paddr;
@@ -6693,11 +6693,11 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp, int
             }
         }
 
-        for (i = 0; i < NO_OF_SG_PER_BLOCK; i++)
+	scsi_for_each_sg(scp, sg, NO_OF_SG_PER_BLOCK, i)
         {
-	    sg_block->sg_list[i].sg_addr = cpu_to_le32(sg_dma_address(slp));
-	    sg_block->sg_list[i].sg_count = cpu_to_le32(sg_dma_len(slp));
-	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(slp), 512));
+	    sg_block->sg_list[i].sg_addr = cpu_to_le32(sg_dma_address(sg));
+	    sg_block->sg_list[i].sg_count = cpu_to_le32(sg_dma_len(sg));
+	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(sg), 512));
 
             if (--sg_elem_cnt == 0)
             {   /* Last ADV_SG_BLOCK and scatter-gather entry. */
@@ -6705,7 +6705,6 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp, int
                 sg_block->sg_ptr = 0L;    /* Last ADV_SG_BLOCK in list. */
                 return ADV_SUCCESS;
             }
-            slp++;
         }
         sg_block->sg_cnt = NO_OF_SG_PER_BLOCK;
         prev_sg_block = sg_block;
-- 
1.5.3.rc0.90.gbaa79

