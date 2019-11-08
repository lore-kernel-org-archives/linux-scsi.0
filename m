Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68627FC6197
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DF2821D7F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZPZGjH4r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfKHB5O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:57:14 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12762 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHB5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 20:57:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573178233; x=1604714233;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=AMZ3oDljW0ETvg0Z4TqXZPyAsm4/Qkok9Q6cJKELkD8=;
  b=ZPZGjH4rpilySAMLjvXs48sJNOe1XLaoRWvCtBV2WFb4ckD2EbimIxow
   2NpZBOGZrNGBySIxqQKYDSTY4aHB4Z25Ef6YGJuvcBB58VxA3jHWis63d
   TuRte7yedJryNQ6f0Xs901rAM6ReTngYQAhghY4tll09vn/QZOSlZwACG
   w9ekhJZ6IW0toc2qwGCPZsueusNDr/fHcMbrSYY+jZeFQzxfLu3QIjxkg
   JiTRr8y5MQKDCLYlPId5p3dGmOEgnyoncwA8DIY9rHuWd//WYdcOE7aRE
   9HNuX+GqGAByzv6kkqrJq1LlWQkV64+9tALa7yDeFZlmSLXOckoaHGXgD
   w==;
IronPort-SDR: kWG8/vJN1dH+m0NZlbi1+iPHtrQJI86bNp7d4qanmF33KhIiKudf0wD0Ee04Xq0Cctp+6kdFoJ
 zS90zqQ3loc8MuytJtoqZaQP3bV+SmcD4DgdP9NtuwAxqO0une6vwS5RRL1qFXJNVDorrCFKdN
 CFsfDRYv4BBXx3p8F625S7T8MatG+a0yYFNi6LwPbZQIGthYeTJ7QCWC2gkEnS2quDxWjDNSb7
 pYyp4UUsyDgE1/uSrPyo3qUlYux/U2Y90V2SuSKY1d486uqbbAzLtmUlZxz67FqmGq6lQe6Dub
 n8c=
X-IronPort-AV: E=Sophos;i="5.68,279,1569254400"; 
   d="scan'208";a="122437211"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 09:57:12 +0800
IronPort-SDR: BEhY5Ziy8zzOb+9nkakv9D2MOuYu69F+XmtyDKZuIBzxg+u6PlJ61ccZBNcWaSm9l0wwiDbHox
 Bn7Y0TJQC2jsWhupjx7bdu/vsPm8KvO4Z1ha/oGeJdfAvd3S0YWrbDMAFJzNZ1T+7PpvEcpL+1
 euw4dcrkt52dU5Be4GqlAHv0avDCQWmnp4k0yL7VYsEh1UQFy17AFneNFvthWFgrIYqh1D9Sm9
 e95sZNHiqjcuIHsIsKMwMV4om2oY54HKzokqvOl98PB20CQWF2K5944HqV2i9hNJmu8HLQysCg
 3vDO99nw11Etr3mPC60asXuN
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 17:52:22 -0800
IronPort-SDR: /Xjyz0Kh14ySCVzU34mSIqRZ1vmBqP7OykM734wRo0hJHoWbQl2cEq/vf0qS824wFLvW00p5vf
 PZLEgpFmBNiK5oMRHvYMoeyHmyyiWyjp0VrTjomF+AqgIPuJfUrcw1kmRXge5eooanwHAKO4IY
 T9In0tczmRSv5+EmJCYTmPgB0DbOrbL6kGLpmjJuXIVs1VgtPkWuiB+mrft01tqF5b3E6Zj4bV
 c52ECmRgUnXqJoIC0jok0oWJsRjy4xW4cW5BFz4d9xdZv5RfLXxwPoMO3fbGNvRISnnAqDp/oT
 E1Y=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Nov 2019 17:57:11 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 5/9] null_blk: clean up the block device operations
Date:   Fri,  8 Nov 2019 10:56:58 +0900
Message-Id: <20191108015702.233102-6-damien.lemoal@wdc.com>
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

Remove the pointless stub open and release methods, give the operations
vector a slightly less confusing name, and use normal alignment for the
assignment operators.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/block/null_blk_main.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 40a64bdd8ea7..89d385bab45b 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1442,20 +1442,9 @@ static void null_config_discard(struct nullb *nullb)
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, nullb->q);
 }
 
-static int null_open(struct block_device *bdev, fmode_t mode)
-{
-	return 0;
-}
-
-static void null_release(struct gendisk *disk, fmode_t mode)
-{
-}
-
-static const struct block_device_operations null_fops = {
-	.owner =	THIS_MODULE,
-	.open =		null_open,
-	.release =	null_release,
-	.report_zones =	null_zone_report,
+static const struct block_device_operations null_ops = {
+	.owner		= THIS_MODULE,
+	.report_zones	= null_zone_report,
 };
 
 static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
@@ -1556,7 +1545,7 @@ static int null_gendisk_register(struct nullb *nullb)
 	disk->flags |= GENHD_FL_EXT_DEVT | GENHD_FL_SUPPRESS_PARTITION_INFO;
 	disk->major		= null_major;
 	disk->first_minor	= nullb->index;
-	disk->fops		= &null_fops;
+	disk->fops		= &null_ops;
 	disk->private_data	= nullb;
 	disk->queue		= nullb->q;
 	strncpy(disk->disk_name, nullb->disk_name, DISK_NAME_LEN);
-- 
2.23.0

