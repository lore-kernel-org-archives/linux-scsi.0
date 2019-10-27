Return-Path: <SRS0=OYiK=YU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845C9CA9EBD
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5998E21726
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dsD+X/oM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfJ0OF4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:05:56 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11568 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfJ0OF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2019 10:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572185228; x=1603721228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xfbf+XHAwLMZYdtqHBXL4n+euc8kSDDPQNshVy1NEdY=;
  b=dsD+X/oMJHetNYpn4kzh1bTtvEBtLEJqXDbRWRqse1lEU2q1kHRv2/am
   mBjnGnBNQUrB8/E1OH8CbBkPR9rBZnIE6k0A8cD+yOcVVNit8TKTUhuAw
   C4zIHPAeLTwNqhy6WwjD/yrEg0fETL4golRFvEmDyInHkGxcVl2vsBRW4
   85HzXoGz1C1McxC0A5uZFaH5ztL3QWXJDiltJIfJ6QANZOywrTVPFyWLw
   PVKo2hVWVsKOOwMzFVvH1an774MLbG9XVbVHtxQwd/saKI3l1L/11myoG
   /Sc75dTdIsntDPWtiemUJMzVfaKoSfUnrUFwDgbdjJzHqJxdLmubQzCID
   Q==;
IronPort-SDR: 7a1FdYvaZkl1G1RMitxs5/FQNhqv4+ufyK0EhFa7/b68h5Z5q8ejpFbiPjgZprsYzT9nu1f1RG
 aV5ncuQPm0kGPCZlw0gHY4C2qPQxSqFd8RSc0sgUyE8T3MFWS4bJYomUJCOWkDliAsIRiL/Sw5
 4yJfUCq9KIJcPvITfCbYZ9qo3ILMSNpP+SqCT79184a/IekARsAFRi40uVpxlePs01OHh4TRj8
 XxWfvuVIGikquWaOJiJ5CaAccOtBgWx0cXGzQcHO9sQ4iUEhWNC8VNJSfe5x2PY7NP1KjKnhtV
 OnA=
X-IronPort-AV: E=Sophos;i="5.68,236,1569254400"; 
   d="scan'208";a="222578537"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2019 22:07:08 +0800
IronPort-SDR: nd8ntmMyc0winhfzjgXDDHT/8HSMN1A3Zy5LxIC/62WYC3VegY+HyBh04vdg0pyFunLqvUW+PR
 eYF1vJpXp9nQs0KwRy6YYHrp5p10Fd94dMt933Q5dFr+1SiH8nz/2L7GOmOmbhZsWsiCLO/wgq
 +p7KRPgJwlPYCkFW/wPMvRhlhkXcF1kh5eeBipnHwBrdsW+bJ0lUKEkhBRAu+bW/DmsuQDgjUO
 oy2MkY3WOBqgWA49wIg9Gp6vodQmR3X/coQK0RsfHQhIvZZsZTjQvnQRtt7ZyWAIHhW7gH2I6E
 2umX93Q3sJag3OFLglGxt70P
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 07:01:19 -0700
IronPort-SDR: 2YCBqSRDcWASCl8YStSibU0PXrCLarn1VLq9+3nOA39lnDeEgKmjffRs2FSLIdBt78B6g289Y+
 4H/Kzpq2H96aNY2aPyxHEYRl6ePMHPqZ7cySs7eQ6fxx1skDkE7z2v0bDvbGp4/FuGBTWAw4aK
 NU0bmCoQbWs8QW4qLu31wFfBFJzIB3fGED0OTfdwTb02nWewnAkkdWnAMvsrc/h6GsCQwSs6j8
 kFQRz5XJaBP/OUQy9IJZfENs78yPLPaKK9vkrWUkoNeun+zShcID70uSObMwfyXRXCKKoyu8bT
 nMA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Oct 2019 07:05:54 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/8] block: Simplify REQ_OP_ZONE_RESET_ALL handling
Date:   Sun, 27 Oct 2019 23:05:43 +0900
Message-Id: <20191027140549.26272-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191027140549.26272-1-damien.lemoal@wdc.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need for the function __blkdev_reset_all_zones() as
REQ_OP_ZONE_RESET_ALL can be handled directly in blkdev_reset_zones()
bio loop with an early break from the loop. This patch removes this
function and modifies blkdev_reset_zones(), simplifying the code.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-zoned.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7fe376eede86..14785011e798 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -202,32 +202,14 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(blkdev_report_zones);
 
-/*
- * Special case of zone reset operation to reset all zones in one command,
- * useful for applications like mkfs.
- */
-static int __blkdev_reset_all_zones(struct block_device *bdev, gfp_t gfp_mask)
-{
-	struct bio *bio = bio_alloc(gfp_mask, 0);
-	int ret;
-
-	/* across the zones operations, don't need any sectors */
-	bio_set_dev(bio, bdev);
-	bio_set_op_attrs(bio, REQ_OP_ZONE_RESET_ALL, 0);
-
-	ret = submit_bio_wait(bio);
-	bio_put(bio);
-
-	return ret;
-}
-
 static inline bool blkdev_allow_reset_all_zones(struct block_device *bdev,
+						sector_t sector,
 						sector_t nr_sectors)
 {
 	if (!blk_queue_zone_resetall(bdev_get_queue(bdev)))
 		return false;
 
-	if (nr_sectors != part_nr_sects_read(bdev->bd_part))
+	if (sector || nr_sectors != part_nr_sects_read(bdev->bd_part))
 		return false;
 	/*
 	 * REQ_OP_ZONE_RESET_ALL can be executed only if the block device is
@@ -270,9 +252,6 @@ int blkdev_reset_zones(struct block_device *bdev,
 		/* Out of range */
 		return -EINVAL;
 
-	if (blkdev_allow_reset_all_zones(bdev, nr_sectors))
-		return  __blkdev_reset_all_zones(bdev, gfp_mask);
-
 	/* Check alignment (handle eventual smaller last zone) */
 	zone_sectors = blk_queue_zone_sectors(q);
 	if (sector & (zone_sectors - 1))
@@ -283,17 +262,24 @@ int blkdev_reset_zones(struct block_device *bdev,
 		return -EINVAL;
 
 	while (sector < end_sector) {
-
 		bio = blk_next_bio(bio, 0, gfp_mask);
-		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);
-		bio_set_op_attrs(bio, REQ_OP_ZONE_RESET, 0);
 
+		/*
+		 * Special case for the zone reset operation that reset all
+		 * zones, this is useful for applications like mkfs.
+		 */
+		if (blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
+			bio->bi_opf = REQ_OP_ZONE_RESET_ALL;
+			break;
+		}
+
+		bio->bi_opf = REQ_OP_ZONE_RESET;
+		bio->bi_iter.bi_sector = sector;
 		sector += zone_sectors;
 
 		/* This may take a while, so be nice to others */
 		cond_resched();
-
 	}
 
 	ret = submit_bio_wait(bio);
-- 
2.21.0

