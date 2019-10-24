Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E42BCA9EBE
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4333121D81
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hPpEsHbB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437820AbfJXGuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 02:50:12 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35887 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437816AbfJXGuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 02:50:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571899812; x=1603435812;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=0RwzibkoRNKSwjPWWwSw61zLqtm+0wYt15Pi27NEjIQ=;
  b=hPpEsHbBjJPbYwbkDGdspHu3Wyq+0YWqFWPSNg3IPWmKvaKCjoIpdN08
   L68OxJ6Jh2bbUPQ9v+81g0H8PYnFtJwB0+9GmR/xBd+Q6moOjMXSfDwvD
   DE7ip62wi9Aga9YUHdpumaSMWspeMnJD9dUh2PIhGOAAqzKQPWou4NXDX
   TXDAYgAIJOWHivUBm6zvhmkH10nNKASlfsoPedMUEdwI17DooQStlFKgf
   BqS2cex4PfLd+JV1VKBf3BHEn8lqbnKo8FEiB8CGWcGIJNr7ORz1F6J9o
   3kY41Ul9yywZASAxNSlsdsMyHODTLui3fWtuCqEBbuU2wvKZckJtBAfhN
   A==;
IronPort-SDR: 33Xm1imwA5nypt/HNOAo/9Atgn1N8qBSxpW2xfv6Uyzr56Bn4zTAcRyYW8WQd82R+We/nwuOya
 iEiZNxHA3i4+QsecbvULjeBmb1Tz2yK6Um9mVwLpUb0SFIZid5nTwnYsk7/PIOl2nHqYCyCjAF
 l8SOQjj6EmNTqV5bo+MAKyk1Qt3gxoZjKZuismfw3oLVvAEy4Ud2RigKYXqWnhAxmg8c1d35jC
 plcbWKNNMF5m6jMo97ls11mR3nRKA7gL+d8a7z8koj/z8F/+2eM1OSvL+V7NPh/a9/yG7MZYCL
 M9k=
X-IronPort-AV: E=Sophos;i="5.68,223,1569254400"; 
   d="scan'208";a="125647244"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2019 14:50:11 +0800
IronPort-SDR: kmLNj8voke2VQ90vZY6cwJW+V7gwjgLP3FkjHALWT2QploNST7OvpdR+ALtAKUCWfTBHdtyXqx
 YXcZBoKrN3g2qSMC/U/WR0F8qH0Em2lKjYNW1ul92P5cqnaSuW1tbPt0uL1PuzCp/n0FF7O3wg
 32S0cNBEDJpogIOV3kyb22kWafB+xHg9drLvTR4ygQJqor3VZJqo2wceCxxBEYxTijW2J2QJXn
 zHkfBriqlnsBfGUtDMDSw9WDnJMrZJxkQu4WyjMHg3Mhzdorj9RzJeiTyL2/EZ64oKFBFOVtvJ
 pyfnn+FzQ+WM0tt0QadqhkjA
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 23:45:45 -0700
IronPort-SDR: 4AH0G2XIbt+AvAxtk3oEXk00PRFzqVbQCuknzEFj0EmBI3QgaUYBstAjsvfT84Up7SsyL0nkm3
 TiT63dkym69hGQsjh+UvwBccUUVwARmOgwuiDEO2dTYSyjwmf1Uygt2NPd5dPixweVA3s7w5Ji
 lTLBAcCCvUky7KOyqb2pARcTsG56Dp7sHB/FE+S69xLo6SNIenl9Wrxgxbk+U8Nm5fPPFTxFM7
 UaLc2j/6hwV9SSKpoboHLskEXb7nwn5Y8MHiVauzanZfTfZgfnnua6SbEgXKNn2o8gR3+fdgJU
 uw8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 23 Oct 2019 23:50:11 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/4] block: Simplify report zones execution
Date:   Thu, 24 Oct 2019 15:50:04 +0900
Message-Id: <20191024065006.8684-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024065006.8684-1-damien.lemoal@wdc.com>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
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
---
 block/blk-zoned.c | 34 +++++-----------------------------
 drivers/md/dm.c   |  6 ------
 2 files changed, 5 insertions(+), 35 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 293891b7068a..43bfd1be0985 100644
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
 
@@ -552,7 +528,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 
 	while (z < nr_zones) {
 		nrz = min(nr_zones - z, rep_nr_zones);
-		ret = blk_report_zones(disk, sector, zones, &nrz);
+		ret = disk->fops->report_zones(disk, sector, zones, &nrz);
 		if (ret)
 			goto out;
 		if (!nrz)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1a5e328c443a..647aa5b0233b 100644
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
2.21.0

