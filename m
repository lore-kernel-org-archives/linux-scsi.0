Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9279BC10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CBDD24685
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XsbUXEC5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgCJJrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:18 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26501 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJJrS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833642; x=1615369642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wPs97aMDNDoq0Oy8HEWbeiY8f8p0e2xRgSLjwRsz5sA=;
  b=XsbUXEC5LZXEAWaeITWoR7WWqWDA9JDcyUmXkGrCiBGVQW6ISxhA8j3R
   lK0KiHVXkhYz7uOPUbV/q2sPBD/HwPC1Tk6CoJRL2Ny/8YCxG0YRU93yx
   QUtjymMNO7Y/GqpilJp9E+kujjPY7CbFHY6n3tLdwdVwWgR70yXXafUji
   FQL1ugooCqTd8JhD1T1pffjnHeUmc8EKz41bsvthaBslhukci3fk1xybr
   bq3WgD/MVXxU+b9076dAX5436/+FmgrICStAUUM5SnB7ONmShQgVha8hz
   SWrU768GxupGmFTDmQiQCiTeS8ZpH+REd7Pc8M+rQ4uLTsvrmWduoCn80
   w==;
IronPort-SDR: Y/zk6cOsIk9w/x3Vbf67R02YbeOxNYuE1J1oGdODs3lasrM7cAcOxSsSXSNogcdYb0b94AMzyK
 N15ZtuF2l5Nk9vQTu8c/YGww33OjWKEw6TZQ/qsh4XCX2pQ5VePrxzF9jn8h+Lzz89nG0+KtHx
 xI7w1nAx2CfqL5L8nDaxgmyZUGIPs1LI+uPBaRzCOriOeKv+SMMELtoOwLvZA0r/DIfEjmt+p4
 Cv4FgCFeoNjE2z9+Qcv7Mid4gyI+61zcOUZt0fYCAeb402QVylVeD4P5AZfiS5+xBV+CmJzAJ/
 aT0=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082785"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:22 +0800
IronPort-SDR: 8Q463pSCRvLdQs9EnsRpz1jaY3JEmR/WUoRZjC+ND3mRjF247ZTl1j8Gs64tZ+KZdCUy4i1OT5
 9FeFDHX6VihDO1mmB+RncE2fH8NyN7Od6D1uF7ycImcNjd46DFOQg1+3zd7n2X1bc64vbxnpKi
 7sD1f5rjvTcznoBoVovFtfSCrlfQBjcDq8kSd2AmmM/KQt/vljZGooCV0pOmwSidjCwiGsDXxD
 fM+EHRMwI2aQfDFX/nHWgWfJIaOAZ2hue7aUSA2i4HT0A1aVsUMCuzq9mqW+r8W7NQFNA16NPY
 xxLasjzoLLbpP7EwUNS2U054
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:38:58 -0700
IronPort-SDR: sxD0Vgtf+SdqB0iX93mUGed1Tiu37buXt3gdpbh4DzuirIojrXpIoTeTSA5zr7Fo/3XQumfCzs
 GzBchO4u+s5Y3yw9pSV9clDirQVPehwZwvYQ2byBv2CRYV6VpKes916NECqvY4s5IhMsy+zUbs
 WZfp8Q9d5s1QVKOQdx/PfK6cHImfCkslycnzMQm4K6voByjUPvQ6WLlDtDm664NwcvSh6ACTdL
 f+UqZzM+pWNEscU/vKGGjilV9XaM5RrFWwMTfex63DA1pZ9CpRz3BcnkcZSjqIqA+wYSxNG5wv
 fp0=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:17 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 04/11] null_blk: Support REQ_OP_ZONE_APPEND
Date:   Tue, 10 Mar 2020 18:46:46 +0900
Message-Id: <20200310094653.33257-5-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

Support REQ_OP_ZONE_APPEND requests for zone mode null_blk devices.
Use the internally tracked zone write pointer position as the write
position.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/block/null_blk_main.c  |  9 ++++++---
 drivers/block/null_blk_zoned.c | 21 ++++++++++++++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 133060431dbd..62869431f2cf 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1575,15 +1575,18 @@ static int null_gendisk_register(struct nullb *nullb)
 
 #ifdef CONFIG_BLK_DEV_ZONED
 	if (nullb->dev->zoned) {
-		if (queue_is_mq(nullb->q)) {
+		struct request_queue *q = nullb->q;
+
+		if (queue_is_mq(q)) {
 			int ret = blk_revalidate_disk_zones(disk);
 			if (ret)
 				return ret;
 		} else {
-			blk_queue_chunk_sectors(nullb->q,
+			blk_queue_chunk_sectors(q,
 					nullb->dev->zone_size_sects);
-			nullb->q->nr_zones = blkdev_nr_zones(disk);
+			q->nr_zones = blkdev_nr_zones(disk);
 		}
+		blk_queue_max_zone_append_sectors(q, q->limits.max_hw_sectors);
 	}
 #endif
 
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index ed34785dd64b..ed9c4cde68f3 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -116,7 +116,7 @@ size_t null_zone_valid_read_len(struct nullb *nullb,
 }
 
 static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
-		     unsigned int nr_sectors)
+		     		    unsigned int nr_sectors, bool append)
 {
 	struct nullb_device *dev = cmd->nq->dev;
 	unsigned int zno = null_zone_no(dev, sector);
@@ -131,7 +131,20 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	case BLK_ZONE_COND_IMP_OPEN:
 	case BLK_ZONE_COND_EXP_OPEN:
 	case BLK_ZONE_COND_CLOSED:
-		/* Writes must be at the write pointer position */
+		/*
+		 * Regular writes must be at the write pointer position.
+		 * Zone append writes are automatically issued at the write
+		 * pointer and the position returned using the request or BIO
+		 * sector.
+		 */
+		if (append) {
+			sector = zone->wp;
+			if (cmd->bio)
+				cmd->bio->bi_iter.bi_sector = sector;
+			else
+				cmd->rq->__sector = sector;
+		}
+
 		if (sector != zone->wp)
 			return BLK_STS_IOERR;
 
@@ -211,7 +224,9 @@ blk_status_t null_handle_zoned(struct nullb_cmd *cmd, enum req_opf op,
 {
 	switch (op) {
 	case REQ_OP_WRITE:
-		return null_zone_write(cmd, sector, nr_sectors);
+		return null_zone_write(cmd, sector, nr_sectors, false);
+	case REQ_OP_ZONE_APPEND:
+		return null_zone_write(cmd, sector, nr_sectors, true);
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
-- 
2.24.1

