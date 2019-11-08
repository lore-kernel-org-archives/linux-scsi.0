Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF26FC6198
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23F8721882
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bzhUH5q2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfKHB5J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:57:09 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12762 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHB5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 20:57:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573178228; x=1604714228;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=/ZBF2Qm6RnCQBQjayUKqcmSbHczeQ3S6vZtk/vBsgZQ=;
  b=bzhUH5q2aftvunqA66NVUFisZ7sDCNmvcxG7p1qCMfHnfaKgb2v+qv7e
   S1JtRhnq9vdAplePBysAkEM8PFMiDPqZgNUFTM+reI3J7LD/y9+VvWqxS
   aN6anOaeDpPDmAPClH4k6XClHGOwaw9goKcQgtLDYZFEfa8lrlCSGuJ9C
   LZ6Yxf9AuGJ+EF+Cbbs1ypfME5f0JhaP9i0HnUV5uPHwBzH/zh02rSn4U
   2H3m8e3c4AV3m2e8+niESFMiPZD9eKf9Uc3+wlxToHcXcpZs9a0M5ICiZ
   +Psnz0y9xpVRRtZWmPmMt7EPnB9ixCF24a/ycpNoR6I+elneqbag4UQeD
   Q==;
IronPort-SDR: Lz/+S4Qb3j3E+/rZhIiPwytmlC9cc2WX5isPyNTlnOKI8djRVcyaz9iWLPUqVES0GbDRHI01AC
 9Pr/epKTUgUKCoR52+PtL/Pd0XkJbX9ExUj0cCtWQEjROoIeme2ibVlLD2+4Q3Xzc7Ym64nFUw
 uak6CbzDFQoC2UHnXNKIq7FQVwHUydGSwNVydtuRWFobavdGn2w7EYo1xSyFVekcwuhwLuH0ZQ
 8I9j4ZNPQYa88L5K3hjXqpfmphonUEyUtSqtNila9uY0kquwXcTd80sy2+4pDlJQnmWBAlfmj/
 07s=
X-IronPort-AV: E=Sophos;i="5.68,279,1569254400"; 
   d="scan'208";a="122437197"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 09:57:07 +0800
IronPort-SDR: 2o+FT+AMRY++2adLn0QN4GQNyUdqghs/ZAOWz2nZ4D5KxvssuZV9NF4kZNpgs5DdJJ5kOsU/9E
 h4wOwOa3+nNl2ZCtiNCbQb94VxX9t1+h75FfSZ4He2ZsYMZKWvbH5APS5OZsCair+M9Nl81wXH
 iBIa/TgpmOOGiFYnVT+iBZPlwFu/xnATT4c9+Dgh4WU5Mj01Dtk/TKlxRYDMIm1Xjj5N18J40V
 B2lq+6Yt7ktwm3tp9wrU0pQv6Pf7MhTeuXAT33jMxgUqvP9XshAQQ1/QF/MsDR216VFI4jX6K3
 9AY5oE8dSXtH6dIBVzAKQP3g
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 17:52:17 -0800
IronPort-SDR: kr5/VwrcP8yZzj4vxGSaX58AWt4Y0XIBpscbpf4VnoVn+egmpoigIllEUBkXIYCD1cImYlODiZ
 g8C+Nd45aBRiX4cf6noKEGG+nI/z+ZDf6qo00fCPiXYYYNMxW2h+NYmssFipj9pIJZyNYItBPD
 /VE6yjmXGBUfpKzK1Cz65/5NNfQ9qhr3maxb1To4K13ZZspuK434rmXVRT5gEmH6xtndFTEFwg
 gmzxaShxISia7XM7WKrb5fQYFupSU+1Rks3wXAQxRlTjH5TnbPpW+DOVLaalFLDWU92lRGFfxU
 vzQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Nov 2019 17:57:06 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 2/9] block: cleanup the !zoned case in blk_revalidate_disk_zones
Date:   Fri,  8 Nov 2019 10:56:55 +0900
Message-Id: <20191108015702.233102-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108015702.233102-1-damien.lemoal@wdc.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

blk_revalidate_disk_zones is never called for non-zoned devices.  Just
return early and warn instead of trying to handle this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-zoned.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index dae787f67019..523a28d7a15c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -520,6 +520,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	sector_t sector = 0;
 	int ret = 0;
 
+	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
+		return -EIO;
+
 	/*
 	 * BIO based queues do not use a scheduler so only q->nr_zones
 	 * needs to be updated so that the sysfs exposed value is correct.
@@ -535,10 +538,8 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	 */
 	noio_flag = memalloc_noio_save();
 
-	if (!blk_queue_is_zoned(q) || !nr_zones) {
-		nr_zones = 0;
+	if (!nr_zones)
 		goto update;
-	}
 
 	/* Allocate bitmaps */
 	ret = -ENOMEM;
-- 
2.23.0

