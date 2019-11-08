Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A756C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DE9021D7F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="V6/4+Ezg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfKHB5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:57:10 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12762 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHB5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 20:57:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573178229; x=1604714229;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=1n0Nb/Nk+xgPczd8to649AuxcaKoknq+zLbCWhS06z4=;
  b=V6/4+EzgJi4jgl+qn8ToudS+njcRrLSYdUfT+hs1azsVQ+HFWq+3MRzT
   jevJx9fsH2ldyyboS/7hd0DVip3gWMw/99b7FN2S/qjM8BXtG16c9ujjZ
   X3/eUDkjc66HEnYVMdyt0e8sN8/tfLA0lToNsTVbm7W56jt6Y1LVE4oxb
   tr5iDPiGlUsPhuAysl9Oi7zxaf3E2wxTCn0ag+nsSZ3tEdbKaCYgpVABH
   3W326K5U35KAcyPWVTXVK7xgbg8KFw7uWyBgFFGE1K0ZXr6qwo/oC297v
   AaJ/qp4wHypWX2YH8xaPIGy3wTdoUADlbusMCdFBweAap16W2AlJ1ugsl
   A==;
IronPort-SDR: i/XOqXHLw6rFuDb3PiSoaS44cgaU4crtb1M06Imp0UQRKruQv/Axft7h6f8iLs2JOuwyDzCLIx
 dmkQCtWyjeZWQ/raSt02YIU8AZNFlpbglcBsPMWUzFYgFhB/y+xsWED4LIB94zJNmJoxwQBiUe
 JqbnCSOpZuImVrSI10oPOZoGmyj9bbVVbnj571GWYUxfhxq5FPDi7FRGLb4Gif93FE+0FB85wg
 fGIefY7ni+Vmlc+ONcFkGGiaQcSCU6UjgwJBXu7472knEyS7l6jjem9HRet5mh2HFpcYRlQROo
 zD4=
X-IronPort-AV: E=Sophos;i="5.68,279,1569254400"; 
   d="scan'208";a="122437202"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 09:57:09 +0800
IronPort-SDR: vraEmljCFHg6vetrR38CYjwwTmUntAfyc8tnGMqwlvUUmMsrqtYW6UCeQlfTTPuW7h+2MKZkHJ
 rNIWyqNlBr7PBsQZxBWa7IOrlpXbaJB22pYy6LfX28v69FD9siq1iG5b9G3fnjNDZThZGBFAQ5
 BN/Z/wvMSRto/s2rR9xFYgnh8s5ivq0k1y5prEnS6ytXBBYXoKylQWAfhR9F3tc2uxTnKmFiYW
 0K3igFPpUDvIj6/rjdm1Z1KmckVgbmfmeeYbGmdKUeAGK/qNgjSEZMQGS0qVKs9FuXSA4uv+YM
 XSQXHJ/wDpNBIa9s6Rr9cT/F
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 17:52:19 -0800
IronPort-SDR: yFxw+3zg+bWdVM0Egku9aB0+avk5K/U+jlSZuFcq5p8pgi+NK086WURpaQvdjC41VqBol0XJfF
 eOWWicAhbCgCgPjJAlEezKks83eHZd1GcNhyOkk6oyQey+NWwxMo+7OyhlDAgo+nwtDRYuu8/5
 0CMRf6E6Dapy5Nb/nR0rvlvfTaX74H1ZSHxAUqlAkNIXCImw/1kvmYL9cHClz1bL0a7sjyZh77
 O0mPWoIbknDb2a01N6G1u7Awsvu03sW3aFNGIcW87UO4xzQsfJY/3e7B2iPDwXmNjpBwIaZ5kX
 FlM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Nov 2019 17:57:08 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 3/9] block: Simplify report zones execution
Date:   Fri,  8 Nov 2019 10:56:56 +0900
Message-Id: <20191108015702.233102-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108015702.233102-1-damien.lemoal@wdc.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All kernel users of blkdev_report_zones() as well as applications use
through ioctl(BLKZONEREPORT) expect to potentially get less zone
descriptors than requested. As such, the use of the internal report
zones command execution loop implemented by blk_report_zones() is
not necessary and can even be harmful to performance by causing the
execution of inefficient small zones report command to service the
reminder of a requested zone array.

This patch removes blk_report_zones(), simplifying the code. Also
remove a now incorrect comment in dm_blk_report_zones().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Javier Gonzalez <javier@javigon.com>
---
 block/blk-zoned.c | 34 +++++-----------------------------
 drivers/md/dm.c   |  6 ------
 2 files changed, 5 insertions(+), 35 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 523a28d7a15c..ea4e086ba00e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -119,31 +119,6 @@ static bool blkdev_report_zone(struct block_device *bdev, struct blk_zone *rep)
 	return true;
 }
 
-static int blk_report_zones(struct gendisk *disk, sector_t sector,
-			    struct blk_zone *zones, unsigned int *nr_zones)
-{
-	struct request_queue *q = disk->queue;
-	unsigned int z = 0, n, nrz = *nr_zones;
-	sector_t capacity = get_capacity(disk);
-	int ret;
-
-	while (z < nrz && sector < capacity) {
-		n = nrz - z;
-		ret = disk->fops->report_zones(disk, sector, &zones[z], &n);
-		if (ret)
-			return ret;
-		if (!n)
-			break;
-		sector += blk_queue_zone_sectors(q) * n;
-		z += n;
-	}
-
-	WARN_ON(z > *nr_zones);
-	*nr_zones = z;
-
-	return 0;
-}
-
 /**
  * blkdev_report_zones - Get zones information
  * @bdev:	Target block device
@@ -164,6 +139,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 			struct blk_zone *zones, unsigned int *nr_zones)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
+	struct gendisk *disk = bdev->bd_disk;
 	unsigned int i, nrz;
 	int ret;
 
@@ -175,7 +151,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 	 * report_zones method. If it does not have one defined, the device
 	 * driver has a bug. So warn about that.
 	 */
-	if (WARN_ON_ONCE(!bdev->bd_disk->fops->report_zones))
+	if (WARN_ON_ONCE(!disk->fops->report_zones))
 		return -EOPNOTSUPP;
 
 	if (!*nr_zones || sector >= bdev->bd_part->nr_sects) {
@@ -185,8 +161,8 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 
 	nrz = min(*nr_zones,
 		  __blkdev_nr_zones(q, bdev->bd_part->nr_sects - sector));
-	ret = blk_report_zones(bdev->bd_disk, get_start_sect(bdev) + sector,
-			       zones, &nrz);
+	ret = disk->fops->report_zones(disk, get_start_sect(bdev) + sector,
+				       zones, &nrz);
 	if (ret)
 		return ret;
 
@@ -561,7 +537,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 
 	while (z < nr_zones) {
 		nrz = min(nr_zones - z, rep_nr_zones);
-		ret = blk_report_zones(disk, sector, zones, &nrz);
+		ret = disk->fops->report_zones(disk, sector, zones, &nrz);
 		if (ret)
 			goto out;
 		if (!nrz)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index bc143c1b2333..89189c29438f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -473,12 +473,6 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 		goto out;
 	}
 
-	/*
-	 * blkdev_report_zones() will loop and call this again to cover all the
-	 * zones of the target, eventually moving on to the next target.
-	 * So there is no need to loop here trying to fill the entire array
-	 * of zones.
-	 */
 	ret = tgt->type->report_zones(tgt, sector, zones, nr_zones);
 
 out:
-- 
2.23.0

