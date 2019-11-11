Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59158C17442
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F5232075B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OTFCa9l+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKKCjn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 21:39:43 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52028 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKKCjn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2019 21:39:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573439983; x=1604975983;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=1sZL6pRQBdfWfCo5BBLxp9YY078NIfK2LTB4YfkymDk=;
  b=OTFCa9l+5SAjVQxVkWOQYuBhAsuVJvlXbvUUBDy0sffA1Ue+diGPUbkJ
   UU0cBnxAXVdRIL7mS9F+vwtnpeqxFL9ofDc/XUuPqdPgNqBCZtraPp+iz
   4KYIleshn79C5sEBCtRgckCZUveYK93El0bqvFktlJCD5VVwJzMpeAy1f
   aCORSrYq35lfisBeKLfYeVzyiVsO2UhWurBxTc2P0VveSvkpTB19zMnQz
   a1pQITLTAJktR7zH+Tw3IWzTgMs+z3tiCzQOQpeO8XiYt0eWXFk5lyEQt
   T9HHDvxE5Xu6vAbCt9tlUAJWyXLYOZfR6iZDJdO7RdTE2lYtOhUHhelI+
   Q==;
IronPort-SDR: 3f9y3Pis3dkngwV7Dt8dWvy0bJFJQhSmwwONiGPRLaNH4cMKzWZPZ+p8Ml6NHBgbnsPFLPRTt/
 x33ImY36eGakydix6NpJbGdZT48lKMkHydTm/0aq7NqrArQkqa6bHsSjWdt+oKimivnJPDBZle
 VFfJ1j4dhfmesUCl4Q8JKHyU02NBAAhUH5Q6/mz86ZPvpNcsAQMbnu6+s+P9XyCnL3erxWS2Mp
 AkxOvNnt+rbopKyRFYIbbLolg/pFkaI61q4tZiz82tK+Y5ytb6TBO7MEYLYIjB5GHL0NN2plY4
 rZY=
X-IronPort-AV: E=Sophos;i="5.68,291,1569254400"; 
   d="scan'208";a="127062980"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 10:39:43 +0800
IronPort-SDR: +eDvJygzmTo7cDZ4RTUTGdPh9/Yz8AVx7Ec98zfVCpzfz+CNWYxzEGOiYHWt9OK3s7+4BTRlmR
 mQTvfkr+eDQKhcE/0Z530H3zy7jwR8aKwMJcC6pmJEdzDI5DEjMcMQbbS4RoaZpjaDK8UXuSM2
 zWJpNkv22K7HUnAlmAD5OVf8rCKMXqi2HhUwOjIOPwaqRq66LsRkuLLBW8Gj26d0ZLFNKNVXBi
 atAy+/OMXSAG80OTZf3/v3UGWw2i5CbJhhWfJ6PY/SHdFnMPe+qLY7pxHZnMymDBQxip0EcdnR
 lxC3UTcqpBCHfKc3RWniyNCV
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 18:34:47 -0800
IronPort-SDR: lRZvIR/O5C0FpMyv+zvFumbYyQBnPVJ1FnoQZqkVLMMooNpJ/0rjTHZmZrD0WyLE2miEIqSrqF
 3qm5nhqw7bx89FHZ+2c0CEbg6mgkTF5Wn9pJmNykmdtz+KiVQd5tZCWpERfIuyJiJNk/psksj5
 5qAfYNqbiGrsIRZhQaWEG3Ew0fTF+bL3Dw2Nz4hvT8fwQI7uGQJemGKVZYXfZ0mV4OJ1xcXCLj
 7bJqos/8t3hXxm7xir3bif0kRptpQdRgHnmsNIx9erUM5fPxVSQHGUpaCqVC2Ud65pA5T2XHA4
 2nE=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Nov 2019 18:39:42 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH v2 6/9] null_blk: clean up report zones
Date:   Mon, 11 Nov 2019 11:39:27 +0900
Message-Id: <20191111023930.638129-7-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191111023930.638129-1-damien.lemoal@wdc.com>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Make the instance name match the method name and define the name to NULL
instead of providing an inline stub, which is rather pointless for a
method call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/block/null_blk.h       | 11 +++--------
 drivers/block/null_blk_main.c  |  2 +-
 drivers/block/null_blk_zoned.c |  4 ++--
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index 93c2a3d403da..9bf56fbab091 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -91,8 +91,8 @@ struct nullb {
 #ifdef CONFIG_BLK_DEV_ZONED
 int null_zone_init(struct nullb_device *dev);
 void null_zone_exit(struct nullb_device *dev);
-int null_zone_report(struct gendisk *disk, sector_t sector,
-		     struct blk_zone *zones, unsigned int *nr_zones);
+int null_report_zones(struct gendisk *disk, sector_t sector,
+		      struct blk_zone *zones, unsigned int *nr_zones);
 blk_status_t null_handle_zoned(struct nullb_cmd *cmd,
 				enum req_opf op, sector_t sector,
 				sector_t nr_sectors);
@@ -105,12 +105,6 @@ static inline int null_zone_init(struct nullb_device *dev)
 	return -EINVAL;
 }
 static inline void null_zone_exit(struct nullb_device *dev) {}
-static inline int null_zone_report(struct gendisk *disk, sector_t sector,
-				   struct blk_zone *zones,
-				   unsigned int *nr_zones)
-{
-	return -EOPNOTSUPP;
-}
 static inline blk_status_t null_handle_zoned(struct nullb_cmd *cmd,
 					     enum req_opf op, sector_t sector,
 					     sector_t nr_sectors)
@@ -123,5 +117,6 @@ static inline size_t null_zone_valid_read_len(struct nullb *nullb,
 {
 	return len;
 }
+#define null_report_zones	NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 #endif /* __NULL_BLK_H */
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 89d385bab45b..2687eb36441c 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1444,7 +1444,7 @@ static void null_config_discard(struct nullb *nullb)
 
 static const struct block_device_operations null_ops = {
 	.owner		= THIS_MODULE,
-	.report_zones	= null_zone_report,
+	.report_zones	= null_report_zones,
 };
 
 static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 02f41a3bc4cb..00696f16664b 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -66,8 +66,8 @@ void null_zone_exit(struct nullb_device *dev)
 	kvfree(dev->zones);
 }
 
-int null_zone_report(struct gendisk *disk, sector_t sector,
-		     struct blk_zone *zones, unsigned int *nr_zones)
+int null_report_zones(struct gendisk *disk, sector_t sector,
+		      struct blk_zone *zones, unsigned int *nr_zones)
 {
 	struct nullb *nullb = disk->private_data;
 	struct nullb_device *dev = nullb->dev;
-- 
2.23.0

