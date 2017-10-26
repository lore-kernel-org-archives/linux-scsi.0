From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2.2] sd: Micro-optimize READ / WRITE CDB encoding
Date: Thu, 26 Oct 2017 01:06:03 -0400
Message-ID: <20171026050603.14856-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38957 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbdJZFGN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Oct 2017 01:06:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart.VanAssche@wdc.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hch@lst.de, hare@suse.com, jthumshirn@suse.de

The sd_setup_read_write_cmnd() function is on the "fast path" for
block system access to SCSI devices (logical units). Rewrite this
function to improve speed and readability.

version 2.2:
 - remove empty branch from condition (review comment)
 - remove redundant log message
 - introduce lb_size variable for the device's Logical Block size
 - define the const variable sect_sz as the block layer's implicit
   sector size of 512 bytes

version 2.1:
 - use put_unaligned_be family of functions to save lots of shifts
 - improve the scaling code when lb_size > 512 bytes
 - use variable names containing "sect" for block system quantities
   which have implicit 512 byte sector size. Use "lba" and
   "num_blks" after optional scaling to match the logical block
   address and number of logical blocks of the SCSI device being
   accessed
 - use local variables to hold values that were previously calculated
   more than once

The first version of this patch was written by Bart Van Assche.
This patch is based on lk 4.14.0-rc6 .

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sd.c | 218 +++++++++++++++++++++++-------------------------------
 1 file changed, 93 insertions(+), 125 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d175c5c5ccf8..a28dd62f828f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1004,11 +1004,18 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	struct scsi_device *sdp = SCpnt->device;
 	struct gendisk *disk = rq->rq_disk;
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	sector_t block = blk_rq_pos(rq);
-	sector_t threshold;
-	unsigned int this_count = blk_rq_sectors(rq);
+	unsigned int num_sects = blk_rq_sectors(rq);
+	unsigned int num_blks;
 	unsigned int dif, dix;
-	bool zoned_write = sd_is_zoned(sdkp) && rq_data_dir(rq) == WRITE;
+	const unsigned int sect_sz = 512;	/* implicit in block layer */
+	unsigned int lb_size;
+	sector_t sect_addr = blk_rq_pos(rq);
+	sector_t sect_after = sect_addr + num_sects;
+	sector_t total_sects = get_capacity(disk);
+	sector_t lba;
+	bool is_write = (rq_data_dir(rq) == WRITE);
+	bool have_fua = !!(rq->cmd_flags & REQ_FUA);
+	bool zoned_write = sd_is_zoned(sdkp) && is_write;
 	int ret;
 	unsigned char protect;
 
@@ -1019,7 +1026,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	}
 
 	ret = scsi_init_io(SCpnt);
-	if (ret != BLKPREP_OK)
+	if (unlikely(ret != BLKPREP_OK))
 		goto out;
 	WARN_ON_ONCE(SCpnt != rq->special);
 
@@ -1029,20 +1036,22 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 
 	SCSI_LOG_HLQUEUE(1,
 		scmd_printk(KERN_INFO, SCpnt,
-			"%s: block=%llu, count=%d\n",
-			__func__, (unsigned long long)block, this_count));
+			"%s: sector=%llu, num_sects=%d\n",
+			__func__, (unsigned long long)sect_addr, num_sects));
 
-	if (!sdp || !scsi_device_online(sdp) ||
-	    block + blk_rq_sectors(rq) > get_capacity(disk)) {
+	if (unlikely(!(sdp && scsi_device_online(sdp) &&
+		       (sect_after <= total_sects)))) {
+		/* either device offline or access does fit on medium */
 		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
 						"Finishing %u sectors\n",
-						blk_rq_sectors(rq)));
+						num_sects));
 		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
 						"Retry with 0x%p\n", SCpnt));
 		goto out;
 	}
+	lb_size = sdp->sector_size;
 
-	if (sdp->changed) {
+	if (unlikely(sdp->changed)) {
 		/*
 		 * quietly refuse to do anything to a changed disc until 
 		 * the changed bit has been reset
@@ -1055,22 +1064,20 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	 * Some SD card readers can't handle multi-sector accesses which touch
 	 * the last one or two hardware sectors.  Split accesses as needed.
 	 */
-	threshold = get_capacity(disk) - SD_LAST_BUGGY_SECTORS *
-		(sdp->sector_size / 512);
-
-	if (unlikely(sdp->last_sector_bug && block + this_count > threshold)) {
-		if (block < threshold) {
-			/* Access up to the threshold but not beyond */
-			this_count = threshold - block;
-		} else {
-			/* Access only a single hardware sector */
-			this_count = sdp->sector_size / 512;
-		}
+	if (unlikely(sdp->last_sector_bug)) {
+		sector_t threshold_sect = total_sects -
+			    (SD_LAST_BUGGY_SECTORS * (lb_size / sect_sz));
+
+		if (unlikely(sect_after > threshold_sect))
+			num_sects = (sect_addr < threshold_sect) ?
+						(threshold_sect - sect_addr) :
+						(lb_size / sect_sz);
+			/* If LBA less than threshold then access up to the
+			 * threshold but not beyond; otherwise access only
+			 * a single hardware sector.
+			 */
 	}
 
-	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
-					(unsigned long long)block));
-
 	/*
 	 * If we have a 1K hardware sectorsize, prevent access to single
 	 * 512 byte sectors.  In theory we could handle this - in fact
@@ -1080,66 +1087,48 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	 * with the cdrom, since it is read-only.  For performance
 	 * reasons, the filesystems should be able to handle this
 	 * and not force the scsi disk driver to use bounce buffers
-	 * for this.
+	 * for this. Assume lb_size >= 512 bytes and a power of 2.
 	 */
-	if (sdp->sector_size == 1024) {
-		if ((block & 1) || (blk_rq_sectors(rq) & 1)) {
+	if (lb_size > sect_sz) {
+		if ((sect_addr | num_sects) & (lb_size / sect_sz - 1)) {
 			scmd_printk(KERN_ERR, SCpnt,
-				    "Bad block number requested\n");
+				    "Bad sector requested: address = %llu, num_sects = %u, sector size = %u bytes\n",
+				    sect_addr + 0ULL, num_sects, lb_size);
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
+			int shift = ilog2(lb_size / sect_sz);
+
+			lba = sect_addr >> shift;
+			num_blks = num_sects >> shift;
 		}
+	} else {	/* So logical block and sector sizes are 512 bytes */
+		lba = sect_addr;
+		num_blks = num_sects;
 	}
-	if (rq_data_dir(rq) == WRITE) {
-		SCpnt->cmnd[0] = WRITE_6;
 
+	if (is_write) {
 		if (blk_integrity_rq(rq))
 			sd_dif_prepare(SCpnt);
-
-	} else if (rq_data_dir(rq) == READ) {
-		SCpnt->cmnd[0] = READ_6;
-	} else {
+	} else if (unlikely(rq_data_dir(rq) != READ)) {
 		scmd_printk(KERN_ERR, SCpnt, "Unknown command %d\n", req_op(rq));
 		goto out;
 	}
 
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
 					"%s %d/%u 512 byte blocks.\n",
-					(rq_data_dir(rq) == WRITE) ?
-					"writing" : "reading", this_count,
-					blk_rq_sectors(rq)));
+					is_write ?  "writing" : "reading",
+					num_blks, num_sects));
 
 	dix = scsi_prot_sg_count(SCpnt);
-	dif = scsi_host_dif_capable(SCpnt->device->host, sdkp->protection_type);
+	dif = scsi_host_dif_capable(sdp->host, sdkp->protection_type);
 
-	if (dif || dix)
+	if (unlikely(dif || dix))
 		protect = sd_setup_protect_cmnd(SCpnt, dix, dif);
 	else
 		protect = 0;
 
-	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
+	if (unlikely(protect &&
+		     sdkp->protection_type == T10_PI_TYPE2_PROTECTION)) {
 		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
 
 		if (unlikely(SCpnt->cmnd == NULL)) {
@@ -1151,60 +1140,40 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 		memset(SCpnt->cmnd, 0, SCpnt->cmd_len);
 		SCpnt->cmnd[0] = VARIABLE_LENGTH_CMD;
 		SCpnt->cmnd[7] = 0x18;
-		SCpnt->cmnd[9] = (rq_data_dir(rq) == READ) ? READ_32 : WRITE_32;
-		SCpnt->cmnd[10] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
-
-		/* LBA */
-		SCpnt->cmnd[12] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
-		SCpnt->cmnd[13] = sizeof(block) > 4 ? (unsigned char) (block >> 48) & 0xff : 0;
-		SCpnt->cmnd[14] = sizeof(block) > 4 ? (unsigned char) (block >> 40) & 0xff : 0;
-		SCpnt->cmnd[15] = sizeof(block) > 4 ? (unsigned char) (block >> 32) & 0xff : 0;
-		SCpnt->cmnd[16] = (unsigned char) (block >> 24) & 0xff;
-		SCpnt->cmnd[17] = (unsigned char) (block >> 16) & 0xff;
-		SCpnt->cmnd[18] = (unsigned char) (block >> 8) & 0xff;
-		SCpnt->cmnd[19] = (unsigned char) block & 0xff;
-
-		/* Expected Indirect LBA */
-		SCpnt->cmnd[20] = (unsigned char) (block >> 24) & 0xff;
-		SCpnt->cmnd[21] = (unsigned char) (block >> 16) & 0xff;
-		SCpnt->cmnd[22] = (unsigned char) (block >> 8) & 0xff;
-		SCpnt->cmnd[23] = (unsigned char) block & 0xff;
-
-		/* Transfer length */
-		SCpnt->cmnd[28] = (unsigned char) (this_count >> 24) & 0xff;
-		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
-		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
-		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
-	} else if (sdp->use_16_for_rw || (this_count > 0xffff)) {
-		SCpnt->cmnd[0] += READ_16 - READ_6;
-		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
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
-		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
-	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
-		   scsi_device_protection(SCpnt->device) ||
-		   SCpnt->device->use_10_for_rw) {
-		SCpnt->cmnd[0] += READ_10 - READ_6;
-		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
-		SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
-		SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
-		SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
-		SCpnt->cmnd[5] = (unsigned char) block & 0xff;
-		SCpnt->cmnd[6] = SCpnt->cmnd[9] = 0;
-		SCpnt->cmnd[7] = (unsigned char) (this_count >> 8) & 0xff;
-		SCpnt->cmnd[8] = (unsigned char) this_count & 0xff;
+		SCpnt->cmnd[9] = is_write ? WRITE_32 : READ_32;
+		SCpnt->cmnd[10] = protect;
+		if (unlikely(have_fua))
+			SCpnt->cmnd[10] |= 0x8;
+		put_unaligned_be64(lba, SCpnt->cmnd + 12);
+
+		/* Expected initial LB reference tag: lower 4 bytes of LBA */
+		put_unaligned_be32(lba, SCpnt->cmnd + 20);
+		/* Leave Expected LB application tag and LB application tag
+		 * mask zeroed
+		 */
+
+		put_unaligned_be32(num_blks, SCpnt->cmnd + 28);
+	} else if (sdp->use_16_for_rw || unlikely(num_blks > 0xffff)) {
+		SCpnt->cmnd[0] = is_write ? WRITE_16 : READ_16;
+		SCpnt->cmnd[1] = protect;
+		if (unlikely(have_fua))
+			SCpnt->cmnd[1] |= 0x8;
+		put_unaligned_be64(lba, SCpnt->cmnd + 2);
+		put_unaligned_be32(num_blks, SCpnt->cmnd + 10);
+		SCpnt->cmnd[14] = 0;
+		SCpnt->cmnd[15] = 0;
+	} else if (sdp->use_10_for_rw || (num_blks > 0xff) ||
+		   (lba > 0x1fffff) || scsi_device_protection(sdp)) {
+		SCpnt->cmnd[0] = is_write ? WRITE_10 : READ_10;
+		SCpnt->cmnd[1] = protect;
+		if (unlikely(have_fua))
+			SCpnt->cmnd[1] |= 0x8;
+		put_unaligned_be32(lba, SCpnt->cmnd + 2);
+		SCpnt->cmnd[6] = 0;
+		put_unaligned_be16(num_blks, SCpnt->cmnd + 7);
+		SCpnt->cmnd[9] = 0;
 	} else {
-		if (unlikely(rq->cmd_flags & REQ_FUA)) {
+		if (unlikely(have_fua)) {
 			/*
 			 * This happens only if this drive failed
 			 * 10byte rw command with ILLEGAL_REQUEST
@@ -1215,22 +1184,21 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 				    "FUA write on READ/WRITE(6) drive\n");
 			goto out;
 		}
-
-		SCpnt->cmnd[1] |= (unsigned char) ((block >> 16) & 0x1f);
-		SCpnt->cmnd[2] = (unsigned char) ((block >> 8) & 0xff);
-		SCpnt->cmnd[3] = (unsigned char) block & 0xff;
-		SCpnt->cmnd[4] = (unsigned char) this_count;
+		/* rely on lba <= 0x1fffff so cmnd[1] will be zeroed */
+		put_unaligned_be32(lba, SCpnt->cmnd + 0);
+		SCpnt->cmnd[0] = is_write ? WRITE_6 : READ_6;
+		SCpnt->cmnd[4] = (unsigned char) num_blks;
 		SCpnt->cmnd[5] = 0;
 	}
-	SCpnt->sdb.length = this_count * sdp->sector_size;
+	SCpnt->sdb.length = num_blks * lb_size;
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
 	 * host adapter, it's safe to assume that we can at least transfer
 	 * this many bytes between each connect / disconnect.
 	 */
-	SCpnt->transfersize = sdp->sector_size;
-	SCpnt->underflow = this_count << 9;
+	SCpnt->transfersize = lb_size;
+	SCpnt->underflow = num_blks << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
 
 	/*
@@ -1239,7 +1207,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	 */
 	ret = BLKPREP_OK;
  out:
-	if (zoned_write && ret != BLKPREP_OK)
+	if (zoned_write && unlikely(ret != BLKPREP_OK))
 		sd_zbc_write_unlock_zone(SCpnt);
 
 	return ret;
-- 
2.14.1
