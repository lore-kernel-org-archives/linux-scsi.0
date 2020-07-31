Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A45C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 05:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 375562074B
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 05:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YY90Ds8H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgGaFtd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 01:49:33 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25408 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbgGaFtd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 01:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596174572; x=1627710572;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PnoiWdmPkPoMLu8D6QMUG95wNZBINpCsh5Wx1hqHFvU=;
  b=YY90Ds8Hynt4PQ7rQMRjFxhYWKmu7hp7bUSQZjHem2mb9XXKyIy2a22W
   GtZdY988GFbEIpjYZQfBM/pfqlsFpcIlldJXaUFcLLBT0SI62rZYATWdu
   a5m9SkPqDK0qN4y/d/yaok8Ko/9npTuYy+SdPyIO+br0VkVWT9TMisOId
   fIPi6tHfcBop1U9LLFLEv5EnmtqFxBczT9PIDtyTfzn3MuOtWEwiW0St/
   Jn/F7DH6gpnjhw1YFtJvZYbrcwO0fByHiSXnkbH4FiShmqIEJaHTgMywp
   4IxHdB+d5IoEyScyu6bWp/HUjOalrqsWYfWzJaN23H2xo8nuXZgnqv7rb
   A==;
IronPort-SDR: TWbNZiNY+vuQANmqz8djhDrplT7WFXaA4pkgwhjHuzQIRXaYO6LJnJ+VImwYvWwMe0L+LW7lN4
 tT17ktzlqdJEfir7SRcNze988xuxzpk38lpHc8fok82CoHC6pKzUuDBRB4FZSq62fEk6LL4a4J
 6D9arcHbUTY6g6bKsVKwOa4OmFKtBjTI2vandVvLNp7UCv1GoATtqAMeI2u9LaOVvWvQcvPirM
 NJajmJefwDPIlqnWqm2S5H8eNKGEAwMFYyZjZYmZibmJIyjZEXSY8aJ04+KFardOjIp6YMWtoz
 hyo=
X-IronPort-AV: E=Sophos;i="5.75,417,1589212800"; 
   d="scan'208";a="145063984"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 13:49:32 +0800
IronPort-SDR: hrjCo2iGnmpM/5dd9TnjpPoTNB7/En2kOZdYgnwGJBOBxkk9BdmwA5j+JMQFLfei7+xjWqsh21
 V4yX+GLC77lMiR1GapWNVPhkFd/TEoDJg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 22:36:59 -0700
IronPort-SDR: 20L0FlNcOiTmaZLIBFzleOzfAmkXIZMjASCdrwtF8zYpCzJSQEm897nQ9tB2PrSXrJ1BBSBJ1K
 l0ixuf4DWaGw==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 30 Jul 2020 22:49:31 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] scsi: sd_zbc: Improve zone revalidation
Date:   Fri, 31 Jul 2020 14:49:28 +0900
Message-Id: <20200731054928.668547-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, for zoned disks, since blk_revalidate_disk_zones() requires
the disk capacity to be set already to operate correctly, zones
revalidation can only be done on the second revalidate scan once the
gendisk capacity is set at the end of the first scan. As a result, if
zones revalidation fails, there is no second chance to recover from the
failure and the disk capacity is changed to 0, with the disk left
unusable.

This can be improved by shuffling around code, specifically, by moving
the call to sd_zbc_revalidate_zones() from sd_zbc_read_zones() to the
end of sd_revalidate_disk(), after set_capacity_revalidate_and_notify()
is called to set the gendisk capacity. With this change, if
sd_zbc_revalidate_zones() fails on the first scan, the second scan will
call it again to recover, if possible.

Using the new struct scsi_disk fields rev_nr_zones and rev_zone_blocks,
sd_zbc_revalidate_zones() does actual work only if it detects a change
with the disk zone configuration. This means that for a successful
zones revalidation on the first scan, the second scan will not cause
another heavy full check.

While at it, remove the unecesary "extern" declaration of
sd_zbc_read_zones().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---

Changes from v1:
* Fixed compilation warning (which is not showing up with gcc 10.1...)

 drivers/scsi/sd.c     | 10 ++++-
 drivers/scsi/sd.h     | 11 +++--
 drivers/scsi/sd_zbc.c | 93 ++++++++++++++++++++-----------------------
 3 files changed, 60 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index acde0ca35769..95018e650f2d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2578,8 +2578,6 @@ sd_print_capacity(struct scsi_disk *sdkp,
 		sd_printk(KERN_NOTICE, sdkp,
 			  "%u-byte physical blocks\n",
 			  sdkp->physical_block_size);
-
-	sd_zbc_print_zones(sdkp);
 }
 
 /* called with buffer of length 512 */
@@ -3220,6 +3218,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	sd_config_write_same(sdkp);
 	kfree(buffer);
 
+	/*
+	 * For a zoned drive, revalidating the zones can be done only once
+	 * the gendisk capacity is set. So if this fails, set back the gendisk
+	 * capacity to 0.
+	 */
+	if (sd_zbc_revalidate_zones(sdkp))
+		set_capacity_revalidate_and_notify(disk, 0, false);
+
  out:
 	return 0;
 }
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 27c0f4e9b1d4..4933e7daf17d 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -75,7 +75,9 @@ struct scsi_disk {
 	struct opal_dev *opal_dev;
 #ifdef CONFIG_BLK_DEV_ZONED
 	u32		nr_zones;
+	u32		rev_nr_zones;
 	u32		zone_blocks;
+	u32		rev_zone_blocks;
 	u32		zones_optimal_open;
 	u32		zones_optimal_nonseq;
 	u32		zones_max_open;
@@ -215,8 +217,8 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 
 int sd_zbc_init_disk(struct scsi_disk *sdkp);
 void sd_zbc_release_disk(struct scsi_disk *sdkp);
-extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
-extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
+int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
+int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 					 unsigned char op, bool all);
 unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
@@ -242,7 +244,10 @@ static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
 	return 0;
 }
 
-static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
+static inline int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
+{
+	return 0;
+}
 
 static inline blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 						       unsigned char op,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 35d929b00a0b..fee0815d7e65 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -633,6 +633,23 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
+static void sd_zbc_print_zones(struct scsi_disk *sdkp)
+{
+	if (!sd_is_zoned(sdkp) || !sdkp->capacity)
+		return;
+
+	if (sdkp->capacity & (sdkp->zone_blocks - 1))
+		sd_printk(KERN_NOTICE, sdkp,
+			  "%u zones of %u logical blocks + 1 runt zone\n",
+			  sdkp->nr_zones - 1,
+			  sdkp->zone_blocks);
+	else
+		sd_printk(KERN_NOTICE, sdkp,
+			  "%u zones of %u logical blocks\n",
+			  sdkp->nr_zones,
+			  sdkp->zone_blocks);
+}
+
 static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
@@ -640,36 +657,31 @@ static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
 	swap(sdkp->zones_wp_offset, sdkp->rev_wp_offset);
 }
 
-static int sd_zbc_revalidate_zones(struct scsi_disk *sdkp,
-				   u32 zone_blocks,
-				   unsigned int nr_zones)
+int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 {
 	struct gendisk *disk = sdkp->disk;
+	struct request_queue *q = disk->queue;
+	u32 zone_blocks = sdkp->rev_zone_blocks;
+	unsigned int nr_zones = sdkp->rev_nr_zones;
+	u32 max_append;
 	int ret = 0;
 
+	if (!sd_is_zoned(sdkp))
+		return 0;
+
 	/*
 	 * Make sure revalidate zones are serialized to ensure exclusive
 	 * updates of the scsi disk data.
 	 */
 	mutex_lock(&sdkp->rev_mutex);
 
-	/*
-	 * Revalidate the disk zones to update the device request queue zone
-	 * bitmaps and the zone write pointer offset array. Do this only once
-	 * the device capacity is set on the second revalidate execution for
-	 * disk scan or if something changed when executing a normal revalidate.
-	 */
-	if (sdkp->first_scan) {
-		sdkp->zone_blocks = zone_blocks;
-		sdkp->nr_zones = nr_zones;
-		goto unlock;
-	}
-
 	if (sdkp->zone_blocks == zone_blocks &&
 	    sdkp->nr_zones == nr_zones &&
 	    disk->queue->nr_zones == nr_zones)
 		goto unlock;
 
+	sdkp->zone_blocks = zone_blocks;
+	sdkp->nr_zones = nr_zones;
 	sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_NOIO);
 	if (!sdkp->rev_wp_offset) {
 		ret = -ENOMEM;
@@ -681,6 +693,21 @@ static int sd_zbc_revalidate_zones(struct scsi_disk *sdkp,
 	kvfree(sdkp->rev_wp_offset);
 	sdkp->rev_wp_offset = NULL;
 
+	if (ret) {
+		sdkp->zone_blocks = 0;
+		sdkp->nr_zones = 0;
+		sdkp->capacity = 0;
+		goto unlock;
+	}
+
+	max_append = min_t(u32, logical_to_sectors(sdkp->device, zone_blocks),
+			   q->limits.max_segments << (PAGE_SHIFT - 9));
+	max_append = min_t(u32, max_append, queue_max_hw_sectors(q));
+
+	blk_queue_max_zone_append_sectors(q, max_append);
+
+	sd_zbc_print_zones(sdkp);
+
 unlock:
 	mutex_unlock(&sdkp->rev_mutex);
 
@@ -693,7 +720,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	struct request_queue *q = disk->queue;
 	unsigned int nr_zones;
 	u32 zone_blocks = 0;
-	u32 max_append;
 	int ret;
 
 	if (!sd_is_zoned(sdkp))
@@ -722,22 +748,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	sdkp->device->use_16_for_rw = 1;
 	sdkp->device->use_10_for_rw = 0;
 
-	ret = sd_zbc_revalidate_zones(sdkp, zone_blocks, nr_zones);
-	if (ret)
-		goto err;
-
-	/*
-	 * On the first scan 'chunk_sectors' isn't setup yet, so calling
-	 * blk_queue_max_zone_append_sectors() will result in a WARN(). Defer
-	 * this setting to the second scan.
-	 */
-	if (sdkp->first_scan)
-		return 0;
-
-	max_append = min_t(u32, logical_to_sectors(sdkp->device, zone_blocks),
-			   q->limits.max_segments << (PAGE_SHIFT - 9));
-
-	blk_queue_max_zone_append_sectors(q, max_append);
+	sdkp->rev_nr_zones = nr_zones;
+	sdkp->rev_zone_blocks = zone_blocks;
 
 	return 0;
 
@@ -747,23 +759,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	return ret;
 }
 
-void sd_zbc_print_zones(struct scsi_disk *sdkp)
-{
-	if (!sd_is_zoned(sdkp) || !sdkp->capacity)
-		return;
-
-	if (sdkp->capacity & (sdkp->zone_blocks - 1))
-		sd_printk(KERN_NOTICE, sdkp,
-			  "%u zones of %u logical blocks + 1 runt zone\n",
-			  sdkp->nr_zones - 1,
-			  sdkp->zone_blocks);
-	else
-		sd_printk(KERN_NOTICE, sdkp,
-			  "%u zones of %u logical blocks\n",
-			  sdkp->nr_zones,
-			  sdkp->zone_blocks);
-}
-
 int sd_zbc_init_disk(struct scsi_disk *sdkp)
 {
 	if (!sd_is_zoned(sdkp))
-- 
2.26.2

