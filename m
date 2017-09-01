From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 6/8] scsi: sd_zbc: Limit zone write locking to sequential zones
Date: Fri,  1 Sep 2017 20:36:29 +0900
Message-ID: <20170901113631.12323-7-damien.lemoal@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:59497 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdIALip (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2017 07:38:45 -0400
In-Reply-To: <20170901113631.12323-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Zoned block devices have no write constraints for conventional zones
so write locking of conventional zones is not necessary and can hurt
performance. To avoid this, introduce the seq_zones bitmap to indicate
if a zone is a sequential one. Use this information to allow any write
to be issued to conventional zones, locking only sequential zones.

As the zone bitmap allocation for seq_zones is identical to the zones
write lock bitmap, introduce the helper sd_zbc_alloc_zone_bitmap().
Using this helper, wait for the disk capacity and number of zones to
stabilize on the second revalidation pass to allocate and initialize
the bitmaps.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.h     |   1 +
 drivers/scsi/sd_zbc.c | 113 ++++++++++++++++++++++++++++++++++++++++++--------
 drivers/scsi/sd_zbc.h |   9 ++++
 3 files changed, 106 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5940390d30f3..761d3fbf72ef 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -77,6 +77,7 @@ struct scsi_disk {
 	unsigned int	zone_blocks;
 	unsigned int	zone_shift;
 	unsigned long	*zones_wlock;
+	unsigned long	*seq_zones;
 	unsigned int	zones_optimal_open;
 	unsigned int	zones_optimal_nonseq;
 	unsigned int	zones_max_open;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 0e6b5f5d14e7..3a9feadcc133 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -246,7 +246,7 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	sector_t zone_sectors = sd_zbc_zone_sectors(sdkp);
-	unsigned int zno = sd_zbc_zone_no(sdkp, sector);
+	unsigned int zno;
 
 	/*
 	 * Note: Checks of the alignment of the write command on
@@ -254,21 +254,20 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	 */
 
 	/* Do not allow zone boundaries crossing on host-managed drives */
-	if (blk_queue_zoned_model(sdkp->disk->queue) == BLK_ZONED_HM &&
+	if (blk_queue_zoned_model(rq->q) == BLK_ZONED_HM &&
 	    (sector & (zone_sectors - 1)) + blk_rq_sectors(rq) > zone_sectors)
 		return BLKPREP_KILL;
 
 	/*
-	 * Do not issue more than one write at a time per
-	 * zone. This solves write ordering problems due to
-	 * the unlocking of the request queue in the dispatch
-	 * path in the non scsi-mq case. For scsi-mq, this
-	 * also avoids potential write reordering when multiple
-	 * threads running on different CPUs write to the same
-	 * zone (with a synchronized sequential pattern).
+	 * There is no write constraint on conventional zones, but do not issue
+	 * more than one write at a time per sequential zone. This avoids write
+	 * ordering problems due to the unlocking of the request queue in the
+	 * dispatch path of the non scsi-mq (legacy) case.
 	 */
-	if (sdkp->zones_wlock &&
-	    test_and_set_bit(zno, sdkp->zones_wlock))
+	zno = sd_zbc_zone_no(sdkp, sector);
+	if (!test_bit(zno, sdkp->seq_zones))
+		return BLKPREP_OK;
+	if (test_and_set_bit(zno, sdkp->zones_wlock))
 		return BLKPREP_DEFER;
 
 	WARN_ON_ONCE(cmd->flags & SCMD_ZONE_WRITE_LOCK);
@@ -286,8 +285,9 @@ void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 
-	if (sdkp->zones_wlock && cmd->flags & SCMD_ZONE_WRITE_LOCK) {
+	if (cmd->flags & SCMD_ZONE_WRITE_LOCK) {
 		unsigned int zno = sd_zbc_zone_no(sdkp, blk_rq_pos(rq));
+
 		WARN_ON_ONCE(!test_bit(zno, sdkp->zones_wlock));
 		cmd->flags &= ~SCMD_ZONE_WRITE_LOCK;
 		clear_bit_unlock(zno, sdkp->zones_wlock);
@@ -510,8 +510,67 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	return 0;
 }
 
+/*
+ * Initialize the sequential zone bitmap to allow identifying sequential zones.
+ */
+static int sd_zbc_setup_seq_zones(struct scsi_disk *sdkp)
+{
+	unsigned long *seq_zones;
+	sector_t block = 0;
+	unsigned char *buf;
+	unsigned char *rec;
+	unsigned int buf_len;
+	unsigned int list_length;
+	unsigned int n = 0;
+	int ret = -ENOMEM;
+
+	/* Allocate zone type bitmap */
+	seq_zones = sd_zbc_alloc_zone_bitmap(sdkp);
+	if (!seq_zones)
+		return -ENOMEM;
+
+	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	while (block < sdkp->capacity) {
+
+		ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, block);
+		if (ret)
+			goto out;
+
+		/* Parse reported zone descriptors */
+		list_length = get_unaligned_be32(&buf[0]) + 64;
+		rec = buf + 64;
+		buf_len = min(list_length, SD_ZBC_BUF_SIZE);
+		while (rec < buf + buf_len) {
+			if ((rec[0] & 0x0f) != ZBC_ZONE_TYPE_CONV)
+				set_bit(n, seq_zones);
+			block += get_unaligned_be64(&rec[8]);
+			rec += 64;
+			n++;
+		}
+
+	}
+
+	if (n != sdkp->nr_zones)
+		ret = -EIO;
+
+out:
+	kfree(buf);
+	if (ret) {
+		kfree(seq_zones);
+		return ret;
+	}
+
+	sdkp->seq_zones = seq_zones;
+
+	return 0;
+}
+
 static int sd_zbc_setup(struct scsi_disk *sdkp)
 {
+	int ret;
 
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw = 1;
@@ -523,17 +582,37 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	sdkp->nr_zones =
 		round_up(sdkp->capacity, sdkp->zone_blocks) >> sdkp->zone_shift;
 
+	/*
+	 * Wait for the disk capacity to stabilize before
+	 * initializing zone related information.
+	 */
+	if (sdkp->first_scan)
+		return 0;
+
 	if (!sdkp->zones_wlock) {
-		sdkp->zones_wlock = kcalloc(BITS_TO_LONGS(sdkp->nr_zones),
-					    sizeof(unsigned long),
-					    GFP_KERNEL);
+		sdkp->zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
 		if (!sdkp->zones_wlock)
 			return -ENOMEM;
 	}
 
+	if (!sdkp->seq_zones) {
+		ret = sd_zbc_setup_seq_zones(sdkp);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
+static void sd_zbc_cleanup(struct scsi_disk *sdkp)
+{
+	kfree(sdkp->seq_zones);
+	sdkp->seq_zones = NULL;
+
+	kfree(sdkp->zones_wlock);
+	sdkp->zones_wlock = NULL;
+}
+
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 {
 	int ret;
@@ -585,14 +664,14 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 
 err:
 	sdkp->capacity = 0;
+	sd_zbc_cleanup(sdkp);
 
 	return ret;
 }
 
 void sd_zbc_remove(struct scsi_disk *sdkp)
 {
-	kfree(sdkp->zones_wlock);
-	sdkp->zones_wlock = NULL;
+	sd_zbc_cleanup(sdkp);
 }
 
 void sd_zbc_print_zones(struct scsi_disk *sdkp)
diff --git a/drivers/scsi/sd_zbc.h b/drivers/scsi/sd_zbc.h
index c120672d56d6..bf2126e96ded 100644
--- a/drivers/scsi/sd_zbc.h
+++ b/drivers/scsi/sd_zbc.h
@@ -24,6 +24,15 @@ static inline unsigned int sd_zbc_zone_no(struct scsi_disk *sdkp,
 	return sectors_to_logical(sdkp->device, sector) >> sdkp->zone_shift;
 }
 
+static inline unsigned long *sd_zbc_alloc_zone_bitmap(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+
+	return kzalloc_node(BITS_TO_LONGS(sdkp->nr_zones)
+			    * sizeof(unsigned long),
+			    GFP_KERNEL, q->node);
+}
+
 extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 extern void sd_zbc_remove(struct scsi_disk *sdkp);
 extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
-- 
2.13.5
