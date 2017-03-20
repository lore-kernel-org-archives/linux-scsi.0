From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] sd: support multi-range TRIM for ATA disks
Date: Mon, 20 Mar 2017 16:43:18 -0400
Message-ID: <20170320204319.12628-7-hch@lst.de>
References: <20170320204319.12628-1-hch@lst.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170320204319.12628-1-hch@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, axboe@kernel.dk
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Almost the same scheme as the older multi-range support for NVMe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cc8684818305..c18fe9ff1f8f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -643,7 +643,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
-	unsigned int max_blocks = 0;
+	unsigned int max_blocks = 0, max_ranges = 0, max_range_size = 0;
 
 	q->limits.discard_zeroes_data = 0;
 
@@ -698,13 +698,19 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 
 	case SD_LBP_ATA_TRIM:
-		max_blocks = 65535 * (512 / sizeof(__le64));
+		max_ranges = 512 / sizeof(__le64);
+		max_range_size = USHRT_MAX;
+		max_blocks = max_ranges * max_range_size;
 		if (sdkp->device->ata_trim_zeroes_data)
 			q->limits.discard_zeroes_data = 1;
 		break;
 	}
 
 	blk_queue_max_discard_sectors(q, max_blocks * (logical_block_size >> 9));
+	if (max_ranges)
+		blk_queue_max_discard_segments(q, max_ranges);
+	if (max_range_size)
+		blk_queue_max_discard_segment_size(q, max_range_size);
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 }
 
@@ -805,9 +811,9 @@ static int sd_setup_ata_trim_cmnd(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdp = cmd->device;
 	struct request *rq = cmd->request;
-	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
-	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
-	u32 data_len = sdp->sector_size, i;
+	u32 sector_shift = ilog2(sdp->sector_size);
+	u32 data_len = sdp->sector_size, i = 0;
+	struct bio *bio;
 	__le64 *buf;
 
 	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
@@ -826,14 +832,21 @@ static int sd_setup_ata_trim_cmnd(struct scsi_cmnd *cmd)
 	cmd->cmnd[8] = data_len;
 
 	buf = page_address(rq->special_vec.bv_page);
-	for (i = 0; i < (data_len >> 3); i++) {
-		u64 n = min(nr_sectors, 0xffffu);
+	__rq_for_each_bio(bio, rq) {
+		u64 sector = bio->bi_iter.bi_sector >> (sector_shift - 9);
+		u32 nr_sectors = bio->bi_iter.bi_size >> sector_shift;
 
-		buf[i] = cpu_to_le64(sector | (n << 48));
-		if (nr_sectors <= 0xffff)
-			break;
-		sector += 0xffff;
-		nr_sectors -= 0xffff;
+		do {
+			u64 n = min(nr_sectors, 0xffffu);
+
+			buf[i] = cpu_to_le64(sector | (n << 48));
+			if (nr_sectors <= 0xffff)
+				break;
+			sector += 0xffff;
+			nr_sectors -= 0xffff;
+			i++;
+
+		} while (!WARN_ON_ONCE(i >= data_len >> 3));
 	}
 
 	cmd->allowed = SD_MAX_RETRIES;
-- 
2.11.0

