Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4B7CA9EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B66220856
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jIgxTWS5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437822AbfJXGuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 02:50:14 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35887 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437821AbfJXGuN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 02:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571899813; x=1603435813;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=R1Qm33pEVN/AJ0iDXdmsbE07Vz0VTveY/T36E7t8obs=;
  b=jIgxTWS5h38jJM6dHCeh1d6TqX6t0ovtUk7dxi7N+Aoln7es8y4HJDDy
   Jo7otumitGIlrI7JHpyU+ZBk8LPNR66iX54CykyEHGoOZSEF2YNqBTtv+
   ZZ9lUzsALRwYFQhCF57E8uwjrYibZ0lU4SzufuyqEHRTXx4m3gfn71KcC
   F4igoEcRlgWOvTsmIE+cRHcLBctQHmm03Q0kq26kTod/2qlKXrqD0Ce8a
   GROyZ5pSBMDLWYpPHG74ktUSVTRiwunz9Ey5SQy/Zs+4MSv93ujgLjf+s
   QMlvGPZYifCXzo8fE7gKnfpVO3u/7dZuGLWUke6SXrGcoPDvIoEwhJCYD
   A==;
IronPort-SDR: yJz+YZeLiQvZ/EjTS/TP3PEmp0hLMgA0k8tu5ftDjsxUhvWzq04bmHykw8ThrJM+GH2/FD78y8
 omZsSt0qiI8ueW+bamRVrBfeEL1GmKZdNoYv8k58ZgGuvTSoPGbVu8dZ7zjYNVlGOoZ2kkrfu8
 2iCKs6BM4DHsP3lHXjLAL6K4ZOXVYi+xXzJQdvzpB5BGXZM7R+WYNFBItb5u0AflY2W7DbWAtx
 QzWat8+BH7h1Sa4FGOSzYPKd3+fWRaf15TkeQTzuGKtik3SVcesmNQ1WE8/w0W+nkfwT08AFCs
 yxY=
X-IronPort-AV: E=Sophos;i="5.68,223,1569254400"; 
   d="scan'208";a="125647246"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2019 14:50:13 +0800
IronPort-SDR: 2AUXhh3SrSU69LS6nlV4b3R41i8ip2gPn0GYnrK35eulgLliwehwuxL34VgjylmeJSIiu6rD3u
 WYmjLzAn9KFXh4HaLSMYY/TwFy8eCycqXLBHIn+0ZW0d7Ae83WJQxJ3zX7M8l6i/cpqdoKEMls
 fLuKydPYnoi/Yd5a9d94hswJNBt4iBV5IIrk6vtSOkFBNaUImdnDAjVrqMFKigR/Z3GYAcjUU5
 s9YwBVBCnBXKsL/5RBpNXHmtAVCqfKEdDOvtTQO4/OyW3/bvTBwp3hYBBrmdm0VMJ5xv1eTgiW
 vSwvKZ3dP9qVrjQwJ05rzy2H
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 23:45:46 -0700
IronPort-SDR: 5azAjCD8cigXjOKs7Cl/rQN3Se/Js4dOohO58A9YRUR7oU2C34dRyIKoIkMLOwzMGv3OgccKdQ
 Ow05qDClyYr2irGim1KnasuuCnjpLX/gaWdseLr7ejPXUFotxh49/qZaQ+WU2xVP8BmNpDW2RM
 IMyFGkxZOH1wKMCW2zq2RNMGguAvEOeb+snjm0nMFI7+rvJnTgZ0PszBQAwAIJIzMEraoEEhO6
 9ZEwMEs+iUDeWtNNCHtv2F9ZA3nUreX1HvAYX9c4EUye+OjW4+VNes9knPmRRUFzgvODo1+KaG
 GzM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 23 Oct 2019 23:50:12 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/4] block: Introduce report zones queue limits
Date:   Thu, 24 Oct 2019 15:50:05 +0900
Message-Id: <20191024065006.8684-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024065006.8684-1-damien.lemoal@wdc.com>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for a generic report zones command buffer allocation to
the block layer, introduce three new request queue limits describing the
device zone descriptor size (zone_descriptor_size limit), the needed
granularity of the report zones command buffer size
(zones_report_granularity limit) and the maximum size of a report zone
command (max_zones_report_size limit).

For scsi, set these values respectively to 64 bytes, SECTOR_SIZE and
the maximum transfer size used for regular read/write commands limited
by the maximum number of pages (segments) that the hardware can map.
This removes the need for the "magic" limit implemented with the macro
SD_ZBC_REPORT_MAX_ZONES.

For the null_blk driver and dm targets, the default value of 0 is used
for these limits, indicating that these zoned devices do not need a
buffer for the execution of report zones.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-settings.c   |  3 +++
 drivers/scsi/sd_zbc.c  | 48 +++++++++++++++++++++---------------------
 include/linux/blkdev.h |  4 ++++
 3 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 5f6dcc7a47bd..674cfc428334 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -53,6 +53,9 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->discard_granularity = 0;
 	lim->discard_alignment = 0;
 	lim->discard_misaligned = 0;
+	lim->zone_descriptor_size = 0;
+	lim->zones_report_granularity = 0;
+	lim->max_zones_report_size = 0;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index fbec99db6124..8dc96f4ea920 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -104,11 +104,6 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
-/*
- * Maximum number of zones to get with one report zones command.
- */
-#define SD_ZBC_REPORT_MAX_ZONES		8192U
-
 /**
  * Allocate a buffer for report zones reply.
  * @sdkp: The target disk
@@ -129,21 +124,8 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	size_t bufsize;
 	void *buf;
 
-	/*
-	 * Report zone buffer size should be at most 64B times the number of
-	 * zones requested plus the 64B reply header, but should be at least
-	 * SECTOR_SIZE for ATA devices.
-	 * Make sure that this size does not exceed the hardware capabilities.
-	 * Furthermore, since the report zone command cannot be split, make
-	 * sure that the allocated buffer can always be mapped by limiting the
-	 * number of pages allocated to the HBA max segments limit.
-	 */
-	nr_zones = min(nr_zones, SD_ZBC_REPORT_MAX_ZONES);
-	bufsize = roundup((nr_zones + 1) * 64, 512);
-	bufsize = min_t(size_t, bufsize,
-			queue_max_hw_sectors(q) << SECTOR_SHIFT);
-	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
-
+	bufsize = min_t(size_t, roundup(nr_zones * 64, SECTOR_SIZE),
+			q->limits.max_zones_report_size);
 	buf = vzalloc(bufsize);
 	if (buf)
 		*buflen = bufsize;
@@ -398,6 +380,8 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, unsigned char *buf,
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 {
 	struct gendisk *disk = sdkp->disk;
+	struct request_queue *q = disk->queue;
+	unsigned int max_zones_report_size;
 	unsigned int nr_zones;
 	u32 zone_blocks = 0;
 	int ret;
@@ -423,13 +407,29 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 		goto err;
 
 	/* The drive satisfies the kernel restrictions: set it up */
-	blk_queue_chunk_sectors(sdkp->disk->queue,
+	blk_queue_chunk_sectors(q,
 			logical_to_sectors(sdkp->device, zone_blocks));
-	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, sdkp->disk->queue);
-	blk_queue_required_elevator_features(sdkp->disk->queue,
-					     ELEVATOR_F_ZBD_SEQ_WRITE);
+	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
+	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
+	/*
+	 * Zone descriptors are 64 bytes. A report zone buffer size should be
+	 * at most 64B times the number of zones of the device plus a 64B reply
+	 * header and should be at least be SECTOR_SIZE bytes for ATA devices.
+	 * Make sure that this maximum buffer size does not exceed the hardware
+	 * capabilities in terms of maximum data transfer size. Furthermore,
+	 * make sure that the allocated buffer can always be mapped by limiting
+	 * the number of pages of the buffer to the device max segments limit.
+	 */
+	q->limits.zone_descriptor_size = 64;
+	q->limits.zones_report_granularity = SECTOR_SIZE;
+	max_zones_report_size = min(roundup((nr_zones + 1) * 64, SECTOR_SIZE),
+				    queue_max_hw_sectors(q) << SECTOR_SHIFT);
+	q->limits.max_zones_report_size =
+		min(max_zones_report_size,
+		    (unsigned int)queue_max_segments(q) << PAGE_SHIFT);
+
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw = 1;
 	sdkp->device->use_10_for_rw = 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f3ea78b0c91c..1c76d71fc232 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -338,6 +338,10 @@ struct queue_limits {
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
+	unsigned int		zone_descriptor_size;
+	unsigned int		zones_report_granularity;
+	unsigned int		max_zones_report_size;
+
 	unsigned short		logical_block_size;
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
-- 
2.21.0

