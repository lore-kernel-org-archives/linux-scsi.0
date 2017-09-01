From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 2/2] scsi: sd: Use sectors_to_logical()
Date: Fri,  1 Sep 2017 10:07:29 +0900
Message-ID: <20170901010729.16524-3-damien.lemoal@wdc.com>
References: <20170901010729.16524-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62917 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdIABJs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 21:09:48 -0400
In-Reply-To: <20170901010729.16524-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>

Replace open coded conversions.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e7d1eed4afa7..84fab90fe2cb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -738,8 +738,8 @@ static int sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdp = cmd->device;
 	struct request *rq = cmd->request;
-	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
-	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	u64 sector = sectors_to_logical(sdp, blk_rq_pos(rq));
+	u32 nr_sectors = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	unsigned int data_len = 24;
 	char *buf;
 
@@ -772,8 +772,8 @@ static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd, bool unmap)
 {
 	struct scsi_device *sdp = cmd->device;
 	struct request *rq = cmd->request;
-	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
-	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	u64 sector = sectors_to_logical(sdp, blk_rq_pos(rq));
+	u32 nr_sectors = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
 	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
@@ -802,8 +802,8 @@ static int sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd, bool unmap)
 {
 	struct scsi_device *sdp = cmd->device;
 	struct request *rq = cmd->request;
-	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
-	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	u64 sector = sectors_to_logical(sdp, blk_rq_pos(rq));
+	u32 nr_sectors = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
 	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
@@ -833,8 +833,8 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 	struct request *rq = cmd->request;
 	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
-	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
-	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	u64 sector = sectors_to_logical(sdp, blk_rq_pos(rq));
+	u32 nr_sectors = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	int ret;
 
 	if (!(rq->cmd_flags & REQ_NOUNMAP)) {
-- 
2.13.5
