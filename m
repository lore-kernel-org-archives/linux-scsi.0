Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1E3C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78FE764DDA
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhA1EuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:50:07 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21969 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhA1EuD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:50:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611809403; x=1643345403;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YobZghyNsgskNB+fC+I1GvLwxiefgtnuuC0Tcp7ryyI=;
  b=NNTAQ9tVBPqmkVeHutbFLdWmYEhd+TpmV8QKOmLbeBaE4F2mwp2rCXwn
   oGNhv+bcKkxPO5oZisyWkMN0GEBYJknDySg3ohiyn7Ym7fXsdfEX4rlvw
   SW1VwUyPlSxjMJ01R2M2aGmbHqknzvaa8rZnvYVVMxlFyF+NalLhXhO1E
   kKiQlirxkmfr+8l85gGNPtbqGyetFbyL57m1NhrMAkDwkgtrtiHJKuGaO
   8lpmmhUydylkbyRYKNsMo/eIDtgDjQupmwphwacSJmhTwEejXBHAgWu4C
   XU3s764F7TKEW0zNmz1c6TEhdeg6UHFDoim1Mj6C9nqpRhatFq+s8dA3R
   Q==;
IronPort-SDR: SaF8XR6C8U22TQ9035EkOg5imG2DYaliY5mYa3nnIFVHxz0+Q7T2ELNvVK66DRHdldlof3lRpK
 RU0ic4/kUlcoph7aRc1E8kJOJxCcZ0ffBWV/Knlt5g397+t2BQMojRqvi0qs18ojuT1MqXXlOt
 kqg3teILg7k28hpYMrRBVN/K+ZzsA1Qcis0v5UxMss8QQNlQHq9Cf8Jo6dKc399M3l89DlAD9R
 UIlU5qVT76Pna9eV3anYYZ6uUi3kE/KesLBta2KNm7qMjPUv/Rga8Bv1t9+u16+X/WQT6o4Mow
 2JM=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158509132"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 12:47:40 +0800
IronPort-SDR: SiSp3TYuXQEqH998FV4e83lTSZORVJYnRuTe/2nVj5VA8quS5iiLLy6K1HL5cQqk3QG6rg7Ip1
 /YbmPepJRGezJO9Ccxgxbpnsqq+TpNrG2Q1ECotU2Od0hhZakOWXflK96P5Elimnqw3mSxjj73
 rqpUdk0a9o9xtKPBTq1XHi2MLEa+QrcpiTTtkZIn1Z7o+yKGHIQ1TbbpRQfg8AIGWwtgYPFL3H
 JdTvNZP6HvFUlVPopHRFAjIkgn/MLwIU4tctqloqc1WtFgXffLxQio7816IviHA6fFQq+ID2sW
 xDH7JOh0pdq5gqfXpLjMKm0m
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 20:29:59 -0800
IronPort-SDR: 9RcohAp9AMgU5B7rQIxsmbG4uch5GxDip1QD1xSnMBIuPmFlTmbHioiPbNRL2EDa/fBYDWBb08
 f9Q4NGR3usz6Ez9dTU6cRvCiM/DaUVDZz55/Dq2niCiGulwBXt9Q5eJjpwoF9ZRmGKkECu7Fly
 wUG9p3+HrZa0On4ZF0ntny/L7BWLJKixVz/R5j4b1xwAe4delg5B2v9/Yv4AbKTaM+FnN9KZMi
 9C1jqkMK2sq/P8NliAxdm6KzkwU9IMtTQK5eYWvsLALI9vUiWJuk6i8f5306kiBEX3ElOf2Wlk
 3iQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 20:47:39 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 3/8] nullb: use blk_queue_set_zoned() to setup zoned devices
Date:   Thu, 28 Jan 2021 13:47:28 +0900
Message-Id: <20210128044733.503606-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128044733.503606-1-damien.lemoal@wdc.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use blk_queue_set_zoned() to set a nullb device zone model instead of
directly assigning the device queue zoned limit. This initialization of
the devicve zoned model as well as the setup of the queue flag
QUEUE_FLAG_ZONE_RESETALL and of the device queue elevator feature are
moved from null_init_zoned_dev() to null_register_zoned_dev() so that
the initialization of the queue limits is done when the gendisk of the
nullb device is available.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/block/null_blk/zoned.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 148b871f263b..78cae8703dcf 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -146,10 +146,6 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 		sector += dev->zone_size_sects;
 	}
 
-	q->limits.zoned = BLK_ZONED_HM;
-	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
-
 	return 0;
 }
 
@@ -158,6 +154,10 @@ int null_register_zoned_dev(struct nullb *nullb)
 	struct nullb_device *dev = nullb->dev;
 	struct request_queue *q = nullb->q;
 
+	blk_queue_set_zoned(nullb->disk, BLK_ZONED_HM);
+	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
+	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
+
 	if (queue_is_mq(q)) {
 		int ret = blk_revalidate_disk_zones(nullb->disk, NULL);
 
-- 
2.29.2

