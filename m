Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0846C3A5AA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 986D222CF5
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AizpY/OO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfIDInA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:43:00 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39226 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfIDInA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 04:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567586580; x=1599122580;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=qtVWwALxJeFLEm5MyqWAjj8rH1FAELNGevTMV0H6ZXk=;
  b=AizpY/OOU8V8qroDZC9GAQzE+WZtQ2M+tXozw/tcoUCcjjEvM66kOJZ3
   4/4fPKb490e3G6M3ExnuFRPnKmyyIoqNeeiImyY08xjU8NgcKCaHo+B/c
   0CblYZX1MBLAR92aoZo5Lg6rgkSDUnCcEXS+U0ZsPTFi7vgH9WYSH3bCB
   cEpxloSKZEyzn07UKoNb01MdVdQ37+IMc/CecHNiuKPmXX705UaDavUPF
   fH1GGlqFf19H+d+JVkXyZyM/CLFIAGrlXbWe7PwNAKRJ271UQcVE14fv0
   umTTwjTLg2ULVHXyrZZ5x512ajhKmmuILMCMNwJ10tjl+EhtaHFQRnmm1
   w==;
IronPort-SDR: uz3MnwZ/a4iJzBgHgEgg0QK6lb4s6zDdmv7N+of/QB7SNHeFxZMMTFU4wD4ULt8wRiPWUsLKby
 hCa+yI95Yl9laDnkP8jzGkcIx4yElxauCymtpGZA8IvwLUNUrLsMSpXtmYJaiETWfvGId9Ds4j
 K+EhiI26vR8e3vWJNj+rFLWnkmL+AXKGUhxvGTv4FirANlf07a4+uGh3OOx6n0Ar9Ro/a+PT8R
 rjtk9FRLnwn3PAzh/Pa5qix77eNSVuEBBW+QJs3AZS5MGWw7iUFBSMnrmTdF2WCe9EIpqCVwCA
 s/Q=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="117374677"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 16:42:49 +0800
IronPort-SDR: 0oSNPKM9hyUH+YHT3/k3dveijA7Vmp7C7+x6ZeBbBGq/iU5cwAoiFVohtHt8jinvcPIrF3hJKC
 kJIx3TiD6f6cccCsdlqAFRODLUSmO87g7BaZwPTJxTKRTDCC6BX9yi0GvVMg9N6DmyaXCp3e2G
 P8sV5cuudbCOYwaOoZF+EEoybCYwdGE/SOOQBfcRRwlUXTbIAfUIBTBl4W9XIPOXpEmuRkzJ1s
 gBxj91DlETJ+atVty7885UHeNqMiniMyefHwxEJsMJdPd3u/qDf4WsvLPgapLTHelC3CrFQWlc
 I+o7sOE3iWJmKycJ1tdssluE
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 01:39:48 -0700
IronPort-SDR: zyRqs9lkXoQT6UkPn9rQ6bjsnr3ldKkUQUxQyEkHJnbV/4PPb4wMp0RwKU/eJdxBuTxC87FXot
 PGkXHd4b7B1cu1tfk66bWDzDfhsJw7ur6ciapl1EejYilbkD0eOjF1MyvYnrop/TbKB57ncI92
 la80YatRJJowklS9vv9jeE595tEZWkxSs6iNTZE/Sspvnx75YOfZ0f/9VSCjlGvIBJUW1JBCxb
 gHJkTQkDWlP7KoNrXso0C2MvEwjzLrjP8BQy4s9LLU8e1ls5bp4x8e+//5QGanid4RzA7twmpM
 wAM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Sep 2019 01:42:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 1/7] block: Cleanup elevator_init_mq() use
Date:   Wed,  4 Sep 2019 17:42:41 +0900
Message-Id: <20190904084247.23338-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904084247.23338-1-damien.lemoal@wdc.com>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of checking a queue tag_set BLK_MQ_F_NO_SCHED flag before
calling elevator_init_mq() to make sure that the queue supports IO
scheduling, use the elevator.c function elv_support_iosched() in
elevator_init_mq(). This does not introduce any functional change but
ensure that elevator_init_mq() does the right thing based on the queue
settings.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c   |  8 +++-----
 block/elevator.c | 23 +++++++++++++----------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b622029b19ea..13923630e00a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2904,11 +2904,9 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
 
-	if (!(set->flags & BLK_MQ_F_NO_SCHED)) {
-		ret = elevator_init_mq(q);
-		if (ret)
-			goto err_tag_set;
-	}
+	ret = elevator_init_mq(q);
+	if (ret)
+		goto err_tag_set;
 
 	return q;
 
diff --git a/block/elevator.c b/block/elevator.c
index 86100de88883..4721834815bb 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -619,16 +619,26 @@ int elevator_switch_mq(struct request_queue *q,
 	return ret;
 }
 
+static inline bool elv_support_iosched(struct request_queue *q)
+{
+	if (q->tag_set && (q->tag_set->flags & BLK_MQ_F_NO_SCHED))
+		return false;
+	return true;
+}
+
 /*
- * For blk-mq devices, we default to using mq-deadline, if available, for single
- * queue devices.  If deadline isn't available OR we have multiple queues,
- * default to "none".
+ * For blk-mq devices supporting IO scheduling, we default to using mq-deadline,
+ * if available, for single queue devices. If deadline isn't available OR we
+ * have multiple queues, default to "none".
  */
 int elevator_init_mq(struct request_queue *q)
 {
 	struct elevator_type *e;
 	int err = 0;
 
+	if (!elv_support_iosched(q))
+		return 0;
+
 	if (q->nr_hw_queues != 1)
 		return 0;
 
@@ -706,13 +716,6 @@ static int __elevator_change(struct request_queue *q, const char *name)
 	return elevator_switch(q, e);
 }
 
-static inline bool elv_support_iosched(struct request_queue *q)
-{
-	if (q->tag_set && (q->tag_set->flags & BLK_MQ_F_NO_SCHED))
-		return false;
-	return true;
-}
-
 ssize_t elv_iosched_store(struct request_queue *q, const char *name,
 			  size_t count)
 {
-- 
2.21.0

