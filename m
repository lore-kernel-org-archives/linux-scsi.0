Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC80BC2D0ED
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 04:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6EBF2082D
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 04:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ClZBIZsW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCZEaP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 00:30:15 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:36885 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgCZEaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 00:30:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585197015; x=1616733015;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KV/hnNXy/seSr+oqIs6il7YudIWELGAA3Fw3OJ9umqM=;
  b=ClZBIZsWmZKhizyOmkyUtC9OWPw0+8B2HgBqsoQ4CtkvQRWw5lAODWbu
   NUcCYOdqhEYjGQyQAWS2gp90JAOSnK8lsd5JTl9gslPQ5mP1QGPOt0hdx
   TlXOYmjr/dwOmNDKWblrCzo/OTAb1/WQf4ROPju18mskcgigPb5P4vZVb
   gkIHOYLCV5xUyPF1tTPZoVyfJCe1n9L9K5YS2KTN90fYn/tfzzR9Lzsb+
   oOfsu17RjxmW+W5dbIzskC4YQZ4DDgUpLg7WeqN5kkWOZfcNrgxY5E4kw
   0aic/NwlXILowcV/fFGKIcAbQ/7yHlb4IP+z4VkoYmcGtwSBN16ZycMAo
   w==;
IronPort-SDR: 5LQYUgch/V9IhVGioafhJK4hYGFN5IYF2EMbg7Z5TiJzesaRMu7wUPqImS3Ux5hhPwgN6vljyC
 6tDPb23pRzmspi+FV2om75xLLYx7OiAy1AqLvlY6K6wl2Hw2g98p5AHXexTwkuoD7UYQCpVkzM
 dzDjC5pYxgIQc2YfZsl+2YjMbycIL7Szj4j83GD6G4e6FwfrMulV8PvZ2pM6t+JIPETaixGhHC
 iprShneJfcbID7w0IY0dyvt3JaO7yzTDg27jmleIafe9rTBo/hv6Bwl4dtAdJCOYwKu3URGtY6
 7U4=
X-IronPort-AV: E=Sophos;i="5.72,307,1580745600"; 
   d="scan'208";a="133965177"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Mar 2020 12:30:14 +0800
IronPort-SDR: YjalrKEOmHtt5K0Bk4BTiHSXpmprZTerpsYMjbAQUWmNIdt9ucBeomEOr4DyO28xrDb0M3rY3s
 0XZhbeTUOKFLvgYmSKpRBSABVlUt+/wBDuvmL/EjlycI+ZlrZP1k2o4v9l611zw+m43eTyoH7j
 LX2PHqmUkM/xKN/pV1sPfFhXp6u0I0LuE8inSCUb1k5o6SLt9fKdoZu2VMEmpoFP8O+0zmMNmF
 AzeZXFD7fpNAfpBs+B36vL1wynIZB9IXCqmS2Fp3RYnQvc/iACdLRPxtc+Etu3EojmGwx0WKMw
 HzkPoShXSUA2viEhTIbt6EVb
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 21:21:50 -0700
IronPort-SDR: DfE2TXr3NKj2hsS2lTFIBsYvbc81RlUhib6SNSyifpYRXDB1IbDG5AugH/q280dfON6mjUan25
 B5scOY2rv2gSIyg+g7EELZroFboyRu6YxUO09tmXUaT1mLr9IjKhsqazBf885339+BJVyGH/Eq
 ymq7eiQS93huKpXwPMhEE2Dgt0iBaCGxr296ldB6xZd5nYVKpzdk1ucodKZeJaQ4+QIomBZgjZ
 CAaItX3eXf16PGLaumQLRnBac/6h6qaP8LJNsW8hllcnB+LFhWav71eTkC7axIOkjmMoqAkTnp
 nSc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 25 Mar 2020 21:30:14 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] block: all zones zone management operations
Date:   Thu, 26 Mar 2020 13:30:12 +0900
Message-Id: <20200326043012.600187-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Similarly to the zone write pointer reset operation (REQ_OP_ZONE_RESET),
the zone open, close and finish operations can operate on all zones of a
ZBC or ZAC SMR disk by setting the all bit of the command. Compared to a
loop issuing a request for every zone of the device, the device based
processing of an all zone operation is several orders of magnitude
faster.

While resetting all zones of a device was already supported with
REQ_OP_ZONE_RESET_ALL, a similar implementation for the open, close and
finish operations would introduce 3 more request types and complicate
the code. To avoid this, the REQ_ALL_ZONES request flag is introduced to
indicate that a zone management operation request (REQ_OP_ZONE_RESET,
REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE or REQ_OP_ZONE_FINISH) must operate
on all zones of the target device. This allows removing entirely the
special processing for REQ_OP_ZONE_RESET_ALL.

Since an all zone management operation can only be executed if the
block device represents a physical device, the request queue flag
QUEUE_FLAG_ZONE_RESETALLi is renamed as QUEUE_FLAG_ALL_ZONES_MGMT to
allow device drivers to indicate that the device can accept all zones
zone management requests.

THe scsi sd_zbc code is modified accordingly to allow setting the
all bit in ZBC_OUT commands. The null_blk driver is also modified to
add processing for the open all, close all and finish all operations.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-core.c               |   5 -
 block/blk-zoned.c              |  34 +++----
 drivers/block/null_blk_main.c  |   2 +-
 drivers/block/null_blk_zoned.c | 162 +++++++++++++++++++++++++--------
 drivers/scsi/sd.c              |  13 +--
 drivers/scsi/sd.h              |   5 +-
 drivers/scsi/sd_zbc.c          |  10 +-
 include/linux/blk_types.h      |  14 +--
 include/linux/blkdev.h         |   6 +-
 9 files changed, 162 insertions(+), 89 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 60dc9552ef8d..ef0c437e8f43 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -131,7 +131,6 @@ static const char *const blk_op_name[] = {
 	REQ_OP_NAME(DISCARD),
 	REQ_OP_NAME(SECURE_ERASE),
 	REQ_OP_NAME(ZONE_RESET),
-	REQ_OP_NAME(ZONE_RESET_ALL),
 	REQ_OP_NAME(ZONE_OPEN),
 	REQ_OP_NAME(ZONE_CLOSE),
 	REQ_OP_NAME(ZONE_FINISH),
@@ -944,10 +943,6 @@ generic_make_request_checks(struct bio *bio)
 		if (!blk_queue_is_zoned(q))
 			goto not_supported;
 		break;
-	case REQ_OP_ZONE_RESET_ALL:
-		if (!blk_queue_is_zoned(q) || !blk_queue_zone_resetall(q))
-			goto not_supported;
-		break;
 	case REQ_OP_WRITE_ZEROES:
 		if (!q->limits.max_write_zeroes_sectors)
 			goto not_supported;
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 05741c6f618b..c0b883ed5fdf 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -123,16 +123,16 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(blkdev_report_zones);
 
-static inline bool blkdev_allow_reset_all_zones(struct block_device *bdev,
-						sector_t sector,
-						sector_t nr_sectors)
+static inline bool blkdev_do_all_zones_mgmt(struct block_device *bdev,
+					    sector_t sector,
+					    sector_t nr_sectors)
 {
-	if (!blk_queue_zone_resetall(bdev_get_queue(bdev)))
+	if (!blk_queue_all_zones_mgmt(bdev_get_queue(bdev)))
 		return false;
 
 	/*
-	 * REQ_OP_ZONE_RESET_ALL can be executed only if the number of sectors
-	 * of the applicable zone range is the entire disk.
+	 * Zone management operations can be executed on all zones only if the
+	 * number of sectors of the applicable zone range is the entire disk.
 	 */
 	return !sector && nr_sectors == get_capacity(bdev->bd_disk);
 }
@@ -162,6 +162,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	sector_t capacity = get_capacity(bdev->bd_disk);
 	sector_t end_sector = sector + nr_sectors;
 	struct bio *bio = NULL;
+	bool all_zones_mgmt;
 	int ret;
 
 	if (!blk_queue_is_zoned(q))
@@ -184,22 +185,21 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
 		return -EINVAL;
 
-	while (sector < end_sector) {
-		bio = blk_next_bio(bio, 0, gfp_mask);
-		bio_set_dev(bio, bdev);
+	all_zones_mgmt = blkdev_do_all_zones_mgmt(bdev, sector, nr_sectors);
 
+	while (sector < end_sector) {
 		/*
-		 * Special case for the zone reset operation that reset all
-		 * zones, this is useful for applications like mkfs.
+		 * There is no point in retrying failed zone management
+		 * requests so fail them fast.
 		 */
-		if (op == REQ_OP_ZONE_RESET &&
-		    blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
-			bio->bi_opf = REQ_OP_ZONE_RESET_ALL;
+		bio = blk_next_bio(bio, 0, gfp_mask);
+		bio_set_dev(bio, bdev);
+		bio->bi_opf = op | REQ_SYNC | REQ_FAILFAST_DEV;
+		bio->bi_iter.bi_sector = sector;
+		if (all_zones_mgmt) {
+			bio->bi_opf |= REQ_ALL_ZONES;
 			break;
 		}
-
-		bio->bi_opf = op | REQ_SYNC;
-		bio->bi_iter.bi_sector = sector;
 		sector += zone_sectors;
 
 		/* This may take a while, so be nice to others */
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 133060431dbd..6665f905169a 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1746,7 +1746,7 @@ static int null_add_dev(struct nullb_device *dev)
 			goto out_cleanup_blk_queue;
 
 		nullb->q->limits.zoned = BLK_ZONED_HM;
-		blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, nullb->q);
+		blk_queue_flag_set(QUEUE_FLAG_ALL_ZONES_MGMT, nullb->q);
 		blk_queue_required_elevator_features(nullb->q,
 						ELEVATOR_F_ZBD_SEQ_WRITE);
 	}
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index ed34785dd64b..43b01d58d366 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -151,59 +151,142 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	return BLK_STS_OK;
 }
 
+static inline void __null_zone_reset(struct blk_zone *zone)
+{
+	zone->cond = BLK_ZONE_COND_EMPTY;
+	zone->wp = zone->start;
+}
+
+static blk_status_t null_zone_reset(struct nullb_device *dev,
+				    struct blk_zone *zone, bool all)
+{
+	if (all) {
+		int i;
+
+		/* Reset all sequential zones */
+		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++)
+			__null_zone_reset(&zone[i]);
+		return BLK_STS_OK;
+	}
+
+	__null_zone_reset(zone);
+
+	return BLK_STS_OK;
+}
+
+static inline void __null_zone_open(struct blk_zone *zone)
+{
+	zone->cond = BLK_ZONE_COND_EXP_OPEN;
+}
+
+static blk_status_t null_zone_open(struct nullb_device *dev,
+				   struct blk_zone *zone, bool all)
+{
+	if (all) {
+		int i;
+
+		/* Explicitly open all non-full zones */
+		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
+			if (zone->cond != BLK_ZONE_COND_FULL)
+				__null_zone_open(&zone[i]);
+		}
+		return BLK_STS_OK;
+	}
+
+	if (zone->cond == BLK_ZONE_COND_FULL)
+		return BLK_STS_IOERR;
+
+	__null_zone_open(zone);
+
+	return BLK_STS_OK;
+}
+
+static inline void __null_zone_close(struct blk_zone *zone)
+{
+	if (zone->wp == zone->start)
+		zone->cond = BLK_ZONE_COND_EMPTY;
+	else
+		zone->cond = BLK_ZONE_COND_CLOSED;
+}
+
+static blk_status_t null_zone_close(struct nullb_device *dev,
+				    struct blk_zone *zone, bool all)
+{
+	if (all) {
+		int i;
+
+		/* Close all non-full zones */
+		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
+			if (zone->cond != BLK_ZONE_COND_FULL)
+				__null_zone_close(&zone[i]);
+		}
+		return BLK_STS_OK;
+	}
+
+	if (zone->cond == BLK_ZONE_COND_FULL)
+		return BLK_STS_IOERR;
+
+	__null_zone_close(zone);
+
+	return BLK_STS_OK;
+}
+
+static inline void __null_zone_finish(struct blk_zone *zone)
+{
+	zone->cond = BLK_ZONE_COND_FULL;
+	zone->wp = zone->start + zone->len;
+}
+
+static blk_status_t null_zone_finish(struct nullb_device *dev,
+				     struct blk_zone *zone, bool all)
+{
+	if (all) {
+		int i;
+
+		/* Finish all open (implicit and explicit) and closed zones */
+		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
+			if (zone->cond != BLK_ZONE_COND_EMPTY)
+				__null_zone_finish(&zone[i]);
+		}
+		return BLK_STS_OK;
+	}
+
+	__null_zone_finish(zone);
+
+	return BLK_STS_OK;
+}
+
 static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 				   sector_t sector)
 {
 	struct nullb_device *dev = cmd->nq->dev;
 	struct blk_zone *zone = &dev->zones[null_zone_no(dev, sector)];
-	size_t i;
+	bool all;
+
+	if (cmd->bio)
+		all = cmd->bio->bi_opf & REQ_ALL_ZONES;
+	else
+		all = cmd->rq->cmd_flags & REQ_ALL_ZONES;
+
+	/*
+	 * Conventional zones are ignored for an all zones management operation
+	 * but they cannot be targeted for a single zone operation.
+	 */
+	if (!all && zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return BLK_STS_IOERR;
 
 	switch (op) {
-	case REQ_OP_ZONE_RESET_ALL:
-		for (i = 0; i < dev->nr_zones; i++) {
-			if (zone[i].type == BLK_ZONE_TYPE_CONVENTIONAL)
-				continue;
-			zone[i].cond = BLK_ZONE_COND_EMPTY;
-			zone[i].wp = zone[i].start;
-		}
-		break;
 	case REQ_OP_ZONE_RESET:
-		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-			return BLK_STS_IOERR;
-
-		zone->cond = BLK_ZONE_COND_EMPTY;
-		zone->wp = zone->start;
-		break;
+		return null_zone_reset(dev, zone, all);
 	case REQ_OP_ZONE_OPEN:
-		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-			return BLK_STS_IOERR;
-		if (zone->cond == BLK_ZONE_COND_FULL)
-			return BLK_STS_IOERR;
-
-		zone->cond = BLK_ZONE_COND_EXP_OPEN;
-		break;
+		return null_zone_open(dev, zone, all);
 	case REQ_OP_ZONE_CLOSE:
-		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-			return BLK_STS_IOERR;
-		if (zone->cond == BLK_ZONE_COND_FULL)
-			return BLK_STS_IOERR;
-
-		if (zone->wp == zone->start)
-			zone->cond = BLK_ZONE_COND_EMPTY;
-		else
-			zone->cond = BLK_ZONE_COND_CLOSED;
-		break;
+		return null_zone_close(dev, zone, all);
 	case REQ_OP_ZONE_FINISH:
-		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-			return BLK_STS_IOERR;
-
-		zone->cond = BLK_ZONE_COND_FULL;
-		zone->wp = zone->start + zone->len;
-		break;
+		return null_zone_finish(dev, zone, all);
 	default:
 		return BLK_STS_NOTSUPP;
 	}
-	return BLK_STS_OK;
 }
 
 blk_status_t null_handle_zoned(struct nullb_cmd *cmd, enum req_opf op,
@@ -213,7 +296,6 @@ blk_status_t null_handle_zoned(struct nullb_cmd *cmd, enum req_opf op,
 	case REQ_OP_WRITE:
 		return null_zone_write(cmd, sector, nr_sectors);
 	case REQ_OP_ZONE_RESET:
-	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8ca9299ffd36..9fc4ebd64752 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1289,17 +1289,13 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 	case REQ_OP_WRITE:
 		return sd_setup_read_write_cmnd(cmd);
 	case REQ_OP_ZONE_RESET:
-		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_RESET_WRITE_POINTER,
-						   false);
-	case REQ_OP_ZONE_RESET_ALL:
-		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_RESET_WRITE_POINTER,
-						   true);
+		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_RESET_WRITE_POINTER);
 	case REQ_OP_ZONE_OPEN:
-		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_OPEN_ZONE, false);
+		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_OPEN_ZONE);
 	case REQ_OP_ZONE_CLOSE:
-		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_CLOSE_ZONE, false);
+		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_CLOSE_ZONE);
 	case REQ_OP_ZONE_FINISH:
-		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_FINISH_ZONE, false);
+		return sd_zbc_setup_zone_mgmt_cmnd(cmd, ZO_FINISH_ZONE);
 	default:
 		WARN_ON_ONCE(1);
 		return BLK_STS_NOTSUPP;
@@ -1964,7 +1960,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE_SAME:
 	case REQ_OP_ZONE_RESET:
-	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 50fff0bf8c8e..17bca569f68d 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -210,7 +210,7 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
-					 unsigned char op, bool all);
+					 unsigned char op);
 extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 			    struct scsi_sense_hdr *sshdr);
 int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
@@ -227,8 +227,7 @@ static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
 static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
 
 static inline blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
-						       unsigned char op,
-						       bool all)
+						       unsigned char op)
 {
 	return BLK_STS_TARGET;
 }
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index f45c22b09726..23099d37f78e 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -214,18 +214,18 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
  *			can be RESET WRITE POINTER, OPEN, CLOSE or FINISH.
  * @cmd: the command to setup
  * @op: Operation to be performed
- * @all: All zones control
  *
- * Called from sd_init_command() for REQ_OP_ZONE_RESET, REQ_OP_ZONE_RESET_ALL,
- * REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE or REQ_OP_ZONE_FINISH requests.
+ * Called from sd_init_command() for REQ_OP_ZONE_RESET, REQ_OP_ZONE_OPEN,
+ * REQ_OP_ZONE_CLOSE or REQ_OP_ZONE_FINISH requests.
  */
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
-					 unsigned char op, bool all)
+					 unsigned char op)
 {
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	sector_t block = sectors_to_logical(sdkp->device, sector);
+	bool all = rq->cmd_flags & REQ_ALL_ZONES;
 
 	if (!sd_is_zoned(sdkp))
 		/* Not a zoned device */
@@ -407,7 +407,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 		goto err;
 
 	/* The drive satisfies the kernel restrictions: set it up */
-	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, sdkp->disk->queue);
+	blk_queue_flag_set(QUEUE_FLAG_ALL_ZONES_MGMT, sdkp->disk->queue);
 	blk_queue_required_elevator_features(sdkp->disk->queue,
 					     ELEVATOR_F_ZBD_SEQ_WRITE);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 70254ae11769..48a464724500 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -286,8 +286,6 @@ enum req_opf {
 	REQ_OP_ZONE_RESET	= 6,
 	/* write the same sector many times */
 	REQ_OP_WRITE_SAME	= 7,
-	/* reset all the zone present on the device */
-	REQ_OP_ZONE_RESET_ALL	= 8,
 	/* write the zero filled sector many times */
 	REQ_OP_WRITE_ZEROES	= 9,
 	/* Open a zone */
@@ -338,6 +336,12 @@ enum req_flag_bits {
 
 	__REQ_HIPRI,
 
+	/*
+	 * For REQ_OP_ZONE_[RESET|OPEN|CLOSE|FINISH]: tell the driver that
+	 * the request operation must target all zones.
+	 */
+	__REQ_ALL_ZONES,
+
 	/* for driver use */
 	__REQ_DRV,
 	__REQ_SWAP,		/* swapping request. */
@@ -363,6 +367,7 @@ enum req_flag_bits {
 
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
 #define REQ_HIPRI		(1ULL << __REQ_HIPRI)
+#define REQ_ALL_ZONES		(1ULL << __REQ_ALL_ZONES)
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
 #define REQ_SWAP		(1ULL << __REQ_SWAP)
@@ -425,10 +430,7 @@ static inline bool op_is_discard(unsigned int op)
 }
 
 /*
- * Check if a bio or request operation is a zone management operation, with
- * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special case
- * due to its different handling in the block layer and device response in
- * case of command failure.
+ * Check if a bio or request operation is a zone management operation.
  */
 static inline bool op_is_zone_mgmt(enum req_opf op)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f629d40c645c..3ef3bd6df579 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -610,7 +610,7 @@ struct request_queue {
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 23	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED	24	/* queue has been quiesced */
 #define QUEUE_FLAG_PCI_P2PDMA	25	/* device supports PCI p2p requests */
-#define QUEUE_FLAG_ZONE_RESETALL 26	/* supports Zone Reset All */
+#define QUEUE_FLAG_ALL_ZONES_MGMT 26	/* device supports all zones zone mgmt */
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
@@ -631,8 +631,8 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
-#define blk_queue_zone_resetall(q)	\
-	test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
+#define blk_queue_all_zones_mgmt(q)	\
+	test_bit(QUEUE_FLAG_ALL_ZONES_MGMT, &(q)->queue_flags)
 #define blk_queue_secure_erase(q) \
 	(test_bit(QUEUE_FLAG_SECERASE, &(q)->queue_flags))
 #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
-- 
2.25.1

