From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/7] sd: use ZERO_PAGE for WRITE_SAME payloads
Date: Mon, 20 Mar 2017 16:43:19 -0400
Message-ID: <20170320204319.12628-8-hch@lst.de>
References: <20170320204319.12628-1-hch@lst.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170320204319.12628-1-hch@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, axboe@kernel.dk
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We're never touching the contents of the page, so save a memory
allocation for these cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c18fe9ff1f8f..af632e350ab4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -756,7 +756,7 @@ static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd)
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 data_len = sdp->sector_size;
 
-	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	rq->special_vec.bv_page = ZERO_PAGE(0);
 	if (!rq->special_vec.bv_page)
 		return BLKPREP_DEFER;
 	rq->special_vec.bv_offset = 0;
@@ -785,7 +785,7 @@ static int sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd, bool unmap)
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 data_len = sdp->sector_size;
 
-	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	rq->special_vec.bv_page = ZERO_PAGE(0);
 	if (!rq->special_vec.bv_page)
 		return BLKPREP_DEFER;
 	rq->special_vec.bv_offset = 0;
@@ -1256,7 +1256,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
-	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
+	if ((rq->rq_flags & RQF_SPECIAL_PAYLOAD) &&
+	    rq->special_vec.bv_page != ZERO_PAGE(0))
 		__free_page(rq->special_vec.bv_page);
 
 	if (SCpnt->cmnd != scsi_req(rq)->cmd) {
-- 
2.11.0

