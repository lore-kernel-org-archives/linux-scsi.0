From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] sd: Micro-optimize READ / WRITE CDB encoding
Date: Tue, 17 Oct 2017 14:03:52 -0700
Message-ID: <20171017210352.19580-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:55073 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757470AbdJQVG5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 17:06:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Only compute 'threshold' if .last_sector_bug has been set. Reduce
the number of branches that has to be taken to check the starting
LBA and transfer length alignment. Optimize the encoding of the
READ(10), WRITE(10), READ(16), WRITE(16), READ(32) and WRITE(32)
CDB encoding.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sd.c | 102 +++++++++++++++---------------------------------------
 1 file changed, 28 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 67b50baa943c..83284a8fa2cd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1025,7 +1025,6 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	struct gendisk *disk = rq->rq_disk;
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	sector_t block = blk_rq_pos(rq);
-	sector_t threshold;
 	unsigned int this_count = blk_rq_sectors(rq);
 	unsigned int dif, dix;
 	bool zoned_write = sd_is_zoned(sdkp) && rq_data_dir(rq) == WRITE;
@@ -1071,20 +1070,22 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 		goto out;
 	}
 
-	/*
-	 * Some SD card readers can't handle multi-sector accesses which touch
-	 * the last one or two hardware sectors.  Split accesses as needed.
-	 */
-	threshold = get_capacity(disk) - SD_LAST_BUGGY_SECTORS *
-		(sdp->sector_size / 512);
+	if (unlikely(sdp->last_sector_bug)) {
+		sector_t threshold;
 
-	if (unlikely(sdp->last_sector_bug && block + this_count > threshold)) {
-		if (block < threshold) {
-			/* Access up to the threshold but not beyond */
-			this_count = threshold - block;
-		} else {
+		/*
+		 * Some SD card readers can't handle multi-sector accesses
+		 * which touch the last one or two hardware sectors.  Split
+		 * accesses as needed.
+		 */
+		threshold = get_capacity(disk) - SD_LAST_BUGGY_SECTORS *
+			(sdp->sector_size / 512);
+		if (block >= threshold) {
 			/* Access only a single hardware sector */
 			this_count = sdp->sector_size / 512;
+		} else if (block + this_count > threshold) {
+			/* Access up to the threshold but not beyond */
+			this_count = threshold - block;
 		}
 	}
 
@@ -1102,34 +1103,17 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	 * and not force the scsi disk driver to use bounce buffers
 	 * for this.
 	 */
-	if (sdp->sector_size == 1024) {
-		if ((block & 1) || (blk_rq_sectors(rq) & 1)) {
+	if (sdp->sector_size != 512) {
+		if ((block | this_count) & (sdp->sector_size / 512 - 1)) {
 			scmd_printk(KERN_ERR, SCpnt,
-				    "Bad block number requested\n");
+				    "Bad block number requested: block number = %llu, sector count = %u, sector size = %u bytes\n",
+				    block + 0ULL, this_count, sdp->sector_size);
 			goto out;
 		} else {
-			block = block >> 1;
-			this_count = this_count >> 1;
-		}
-	}
-	if (sdp->sector_size == 2048) {
-		if ((block & 3) || (blk_rq_sectors(rq) & 3)) {
-			scmd_printk(KERN_ERR, SCpnt,
-				    "Bad block number requested\n");
-			goto out;
-		} else {
-			block = block >> 2;
-			this_count = this_count >> 2;
-		}
-	}
-	if (sdp->sector_size == 4096) {
-		if ((block & 7) || (blk_rq_sectors(rq) & 7)) {
-			scmd_printk(KERN_ERR, SCpnt,
-				    "Bad block number requested\n");
-			goto out;
-		} else {
-			block = block >> 3;
-			this_count = this_count >> 3;
+			int shift = ilog2(sdp->sector_size / 512);
+
+			block = block >> shift;
+			this_count = this_count >> shift;
 		}
 	}
 	if (rq_data_dir(rq) == WRITE) {
@@ -1173,56 +1157,26 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 		SCpnt->cmnd[7] = 0x18;
 		SCpnt->cmnd[9] = (rq_data_dir(rq) == READ) ? READ_32 : WRITE_32;
 		SCpnt->cmnd[10] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
-
 		/* LBA */
-		SCpnt->cmnd[12] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
-		SCpnt->cmnd[13] = sizeof(block) > 4 ? (unsigned char) (block >> 48) & 0xff : 0;
-		SCpnt->cmnd[14] = sizeof(block) > 4 ? (unsigned char) (block >> 40) & 0xff : 0;
-		SCpnt->cmnd[15] = sizeof(block) > 4 ? (unsigned char) (block >> 32) & 0xff : 0;
-		SCpnt->cmnd[16] = (unsigned char) (block >> 24) & 0xff;
-		SCpnt->cmnd[17] = (unsigned char) (block >> 16) & 0xff;
-		SCpnt->cmnd[18] = (unsigned char) (block >> 8) & 0xff;
-		SCpnt->cmnd[19] = (unsigned char) block & 0xff;
-
+		put_unaligned_be64(block, &SCpnt->cmnd[12]);
 		/* Expected Indirect LBA */
-		SCpnt->cmnd[20] = (unsigned char) (block >> 24) & 0xff;
-		SCpnt->cmnd[21] = (unsigned char) (block >> 16) & 0xff;
-		SCpnt->cmnd[22] = (unsigned char) (block >> 8) & 0xff;
-		SCpnt->cmnd[23] = (unsigned char) block & 0xff;
-
+		put_unaligned_be32(block, &SCpnt->cmnd[20]);
 		/* Transfer length */
-		SCpnt->cmnd[28] = (unsigned char) (this_count >> 24) & 0xff;
-		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
-		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
-		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
+		put_unaligned_be32(this_count, &SCpnt->cmnd[28]);
 	} else if (sdp->use_16_for_rw || (this_count > 0xffff)) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
-		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
-		SCpnt->cmnd[3] = sizeof(block) > 4 ? (unsigned char) (block >> 48) & 0xff : 0;
-		SCpnt->cmnd[4] = sizeof(block) > 4 ? (unsigned char) (block >> 40) & 0xff : 0;
-		SCpnt->cmnd[5] = sizeof(block) > 4 ? (unsigned char) (block >> 32) & 0xff : 0;
-		SCpnt->cmnd[6] = (unsigned char) (block >> 24) & 0xff;
-		SCpnt->cmnd[7] = (unsigned char) (block >> 16) & 0xff;
-		SCpnt->cmnd[8] = (unsigned char) (block >> 8) & 0xff;
-		SCpnt->cmnd[9] = (unsigned char) block & 0xff;
-		SCpnt->cmnd[10] = (unsigned char) (this_count >> 24) & 0xff;
-		SCpnt->cmnd[11] = (unsigned char) (this_count >> 16) & 0xff;
-		SCpnt->cmnd[12] = (unsigned char) (this_count >> 8) & 0xff;
-		SCpnt->cmnd[13] = (unsigned char) this_count & 0xff;
+		put_unaligned_be64(block, &SCpnt->cmnd[2]);
+		put_unaligned_be32(this_count, &SCpnt->cmnd[10]);
 		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
 	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
 		   scsi_device_protection(SCpnt->device) ||
 		   SCpnt->device->use_10_for_rw) {
 		SCpnt->cmnd[0] += READ_10 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
-		SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
-		SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
-		SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
-		SCpnt->cmnd[5] = (unsigned char) block & 0xff;
+		put_unaligned_be32(block, &SCpnt->cmnd[2]);
 		SCpnt->cmnd[6] = SCpnt->cmnd[9] = 0;
-		SCpnt->cmnd[7] = (unsigned char) (this_count >> 8) & 0xff;
-		SCpnt->cmnd[8] = (unsigned char) this_count & 0xff;
+		put_unaligned_be16(this_count, &SCpnt->cmnd[7]);
 	} else {
 		if (unlikely(rq->cmd_flags & REQ_FUA)) {
 			/*
-- 
2.14.2
