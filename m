From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/9] sd: Implement new RESET_WP provisioning mode
Date: Mon,  4 Apr 2016 12:00:15 +0200
Message-ID: <1459764020-126038-5-git-send-email-hare@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbcDDKAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 06:00:44 -0400
In-Reply-To: <1459764020-126038-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

We can map the RESET WRITE POINTER command onto a 'discard'
request.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 52 +++++++++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/sd.h |  1 +
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 74637fd..9220c66 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -369,6 +369,7 @@ static const char *lbp_mode[] = {
 	[SD_LBP_WS16]		= "writesame_16",
 	[SD_LBP_WS10]		= "writesame_10",
 	[SD_LBP_ZERO]		= "writesame_zero",
+	[SD_ZBC_RESET_WP]	= "reset_wp",
 	[SD_LBP_DISABLE]	= "disabled",
 };
 
@@ -391,6 +392,13 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	if (sdkp->zoned == 1) {
+		if (!strncmp(buf, lbp_mode[SD_ZBC_RESET_WP], 20)) {
+			sd_config_discard(sdkp, SD_ZBC_RESET_WP);
+			return count;
+		}
+		return -EINVAL;
+	}
 	if (sdp->type != TYPE_DISK)
 		return -EINVAL;
 
@@ -683,6 +691,12 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		q->limits.discard_zeroes_data = sdkp->lbprz;
 		break;
 
+	case SD_ZBC_RESET_WP:
+		max_blocks = min_not_zero(sdkp->max_unmap_blocks,
+					  (u32)SD_MAX_WS16_BLOCKS);
+		q->limits.discard_zeroes_data = 1;
+		break;
+
 	case SD_LBP_ZERO:
 		max_blocks = min_not_zero(sdkp->max_ws_blocks,
 					  (u32)SD_MAX_WS10_BLOCKS);
@@ -711,16 +725,18 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	unsigned int nr_sectors = blk_rq_sectors(rq);
 	unsigned int nr_bytes = blk_rq_bytes(rq);
 	unsigned int len;
-	int ret;
+	int ret = 0;
 	char *buf;
-	struct page *page;
+	struct page *page = NULL;
 
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
 
-	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
-	if (!page)
-		return BLKPREP_DEFER;
+	if (sdkp->provisioning_mode != SD_ZBC_RESET_WP) {
+		page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+		if (!page)
+			return BLKPREP_DEFER;
+	}
 
 	switch (sdkp->provisioning_mode) {
 	case SD_LBP_UNMAP:
@@ -760,6 +776,16 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		len = sdkp->device->sector_size;
 		break;
 
+	case SD_ZBC_RESET_WP:
+		cmd->cmd_len = 16;
+		cmd->cmnd[0] = ZBC_OUT;
+		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
+		put_unaligned_be64(sector, &cmd->cmnd[2]);
+		/* Reset Write Pointer doesn't have a payload */
+		len = 0;
+		cmd->sc_data_direction = DMA_NONE;
+		break;
+
 	default:
 		ret = BLKPREP_INVALID;
 		goto out;
@@ -779,12 +805,14 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	 * discarded on disk. This allows us to report completion on the full
 	 * amount of blocks described by the request.
 	 */
-	blk_add_request_payload(rq, page, len);
-	ret = scsi_init_io(cmd);
+	if (len) {
+		blk_add_request_payload(rq, page, len);
+		ret = scsi_init_io(cmd);
+	}
 	rq->__data_len = nr_bytes;
 
 out:
-	if (ret != BLKPREP_OK)
+	if (page && ret != BLKPREP_OK)
 		__free_page(page);
 	return ret;
 }
@@ -1151,7 +1179,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (rq->cmd_flags & REQ_DISCARD &&
+	    rq->completion_data)
 		__free_page(rq->completion_data);
 
 	if (SCpnt->cmnd != rq->cmd) {
@@ -1768,6 +1797,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	int sense_deferred = 0;
 	unsigned char op = SCpnt->cmnd[0];
 	unsigned char unmap = SCpnt->cmnd[1] & 8;
+	unsigned char sa = SCpnt->cmnd[1] & 0xf;
 
 	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME) {
 		if (!result) {
@@ -1819,6 +1849,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			case UNMAP:
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 				break;
+			case ZBC_OUT:
+				if (sa == ZO_RESET_WRITE_POINTER)
+					sd_config_discard(sdkp, SD_LBP_DISABLE);
+				break;
 			case WRITE_SAME_16:
 			case WRITE_SAME:
 				if (unmap)
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index ab1696d..5debd49 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -56,6 +56,7 @@ enum {
 	SD_LBP_WS16,		/* Use WRITE SAME(16) with UNMAP bit */
 	SD_LBP_WS10,		/* Use WRITE SAME(10) with UNMAP bit */
 	SD_LBP_ZERO,		/* Use WRITE SAME(10) with zero payload */
+	SD_ZBC_RESET_WP,	/* Use RESET WRITE POINTER */
 	SD_LBP_DISABLE,		/* Discard disabled due to failed cmd */
 };
 
-- 
1.8.5.6

