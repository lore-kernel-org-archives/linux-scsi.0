Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FEDC17444
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 190D32067B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dJQfEhdH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfKKCji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 21:39:38 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52028 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfKKCji (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2019 21:39:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573439978; x=1604975978;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=QRNHYLozP3GBLyGc1aFL68IZ/69XtP6zwGS2IDkAHaY=;
  b=dJQfEhdHOq/y5/aYuP0jIFQIDfvi3elNjNTEk5DyJBp43ptXnAjzL6ji
   qznCoxmGUdg8pc9qZ5T/l9FU84zcgs3nmLEqOtD+IKUjRCIL6POhOFvWU
   orXoHbD2WMg3kl7R6J+6/GYtDQ1r56oyL799hIHX+jI4051zRcDOb/Uud
   PY8CVb7XFh1cPYlhdhGgG+/xgLMylevfnSEkpHfaAdU3k0Q/hJZ9FYJ7r
   IAdjRbTyiJc3zJVUmv25jzJWTJBy1kAj4szG2xa4XuIAunXtNJWryYT9S
   UoI7hZ+JgkkOYphKY42IiHwe9yXqS/xcuYWA/vTjCwrkzjShZy+///xKG
   A==;
IronPort-SDR: DBklDDLOkUcFRgJZlxSJoEj1M3fM71k1kQ8l6gQ0Ei8kV9irBljfumGMZTuMlR/+eMG6hcN10u
 V6KOH3qOic0cwtTDjmldyVeg3m0PVnlm3xQVevw29ywU0Hj7ofcA58Ls/ZmJLg/DisUCSUdgh+
 1PDmq7ow2yHasJ3k9MJzLUY0Xcghhvs6GQ1quzO/iKSkIO+0HN/y6SkYc0EeWftRzswduoqT9S
 Hsfajh9fZK4+S/YR53h3RXyN9x+IL9FbNty7IZ2EG/q33oRiHzN4UW3Hy3TmuH4FOHdSXmYYsz
 GpM=
X-IronPort-AV: E=Sophos;i="5.68,291,1569254400"; 
   d="scan'208";a="127062969"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 10:39:38 +0800
IronPort-SDR: BVGV3M1Cved4n3R2g5F0upfTSEN+g8XrL8L4PwKwx+CGYjliVzH3BvnC4IreUXaJMyLmShszou
 6NnY2yqAtoAiwET3k9AsIppva2Xqm/+Z9mDUZAmB/1lr227xRqaOwS+Av5qFkGRZ1oiLMrefnx
 +jTpwTd2Tc+k8VKj6iZq4ChB3ZmtV6+j3KsLhACphp0Cawz1UUeKx2FqfA7DzaF6Z1pGivrIyG
 +eOqw7rPk4RMjOwcpeICy8BfeB+d4B007KIuOnOEiQRPRf1qjDJ8adajApfki6XVx4HTN/b1dq
 haLsEenxaUjzl7xLQEVNXxC/
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 18:34:42 -0800
IronPort-SDR: B7knMz2tWWR9ca5USo3tzOeizXPdpEdpYWZVz/33KQ3Z8OzM5F5QnkhkDX7m62qSoCaUftzU4U
 Ic50Gu4JEc65YJv4JYwZ1lCiiz1pqlSQ0sKjQmt5ikknSprgnHkfp9D94Xt2SSx26F7aoun6WP
 CMTTDptq7Fg6197WwXyztPcBBjm9g2USjNPoxAmAi6qrZYvZ4in8tT5OdbsDUQ7lTGSMXdmTxg
 a73cB4IB07UsLASMGju6BzMJEHA5aRzX3qgEfvR2Sm6aBqIzMJz8OIyO/iLbqp0pdj10DTVD1c
 uhg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Nov 2019 18:39:37 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH v2 3/9] block: Simplify report zones execution
Date:   Mon, 11 Nov 2019 11:39:24 +0900
Message-Id: <20191111023930.638129-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191111023930.638129-1-damien.lemoal@wdc.com>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

