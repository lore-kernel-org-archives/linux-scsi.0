Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151FAC3A5A8
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1C96214DA
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nA7KfzWE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfH1C3v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 22:29:51 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27195 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfH1C3u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 22:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566959390; x=1598495390;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Jnx10mJxJJVLtKURaXUM0JtZUxRwO0n/yri+8mElRJo=;
  b=nA7KfzWE8YY8+MnO0CW/MTuHR7Wy4KjabOl4UKOBgYXMWsNHcv/pWO1W
   e5l4ON8MhzIFoknC2/5iVHsuWdAg3hII48iPG2QzEw9IqDwoNi+3di3D8
   m4gVb8w4nlby84nD9XNiTMKABubVzytUe1vXKN1AROYyaw7bLW6MKdPO0
   EdV+jdRbG3/3eSuv5YZGCRUW506/V1NbkaM+amMyYUKcmmv3HcVHpciMt
   AW2wBELsIB7qJl4RFfWspSDjiiZs5YywP+oKkKlURdtE0rDZgxIOYRdv+
   rukylCDU7qixtdQCjrLtJ9xu20SSecRYmZf3f0x3im3t7azezkkxtbkta
   w==;
IronPort-SDR: WROYpWo7uKVV/aAeKy1F8COZfYqL+2ufX4JPlBlGTqTG4ELcirxB1WT4L7syUCPd13iCxsXKP/
 /RwBFRO8RZThFP6m/5A4ILyOm306/TkzYAL7u2oApsXKS70KRpO+AGvYJIhasaE5SuqW8kWde5
 IvpCJumXnr5I8aeWzBsPvuwDgz8X/MpcLQXN8NfW/Vh8iELflAtQJx9UrvuNGkEaan6AqHhN6t
 4HHEMYOHZUB0tsN9UaPB74wl0Og7nFMhEO6bLClQhIT3bltPmWdV8KIUM0xEnJ1IDxcNbFWDb2
 qoI=
X-IronPort-AV: E=Sophos;i="5.64,439,1559491200"; 
   d="scan'208";a="223475480"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 10:29:49 +0800
IronPort-SDR: 3x3KY+foa19leborgWL98+XMABuHuYZpt2Q3zQVvlPqkw0RfdogqvCKrAAwXkCUfyTTbufglwn
 CNzVYy2WWp+8CDafb6DqpqYB24l3hYvAcPyp3QAz+IV+NrH1CqtSu4/sb7SXSPiSn3m2jj3E03
 zBDkQCnxFVRhDBS/wzsmWzff4AudBThkR9jWSKgYCFDYYsAkngasm3YOurp087UASCmOfAx9mA
 b01auV1Je6LASJvHYiD70sCAyvHWgm7v32YxxnqLpCBk6w47C0TKAW44gWKvxIP+7PILvMz/qz
 AGhCigvwJ7JoRYlPikkCMbnB
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 19:27:00 -0700
IronPort-SDR: PUtsaQcfH4jRh+wiP72a432piAVR+WZPm/FSKMdYHNSlJf9WdxA8CqGw7M7rnqibsoHYGJ5SNr
 Xl2jd4h9cW2TcphycbLwt2Qn3SkIxYIoMhzZv5/Q77sUsg/xgHA+gIqhAb4PnOzT9oUFiGisTz
 rmRvQNhbaCFLyEAnybTXCW+nbiexUwYGKGIrOa+70iJGTLuzJRX8Qkng4xRvcKWcq7AYYQsQu5
 Pxh7iSlXrn8QMs4s8ZxdQVtS0VqiT8Bd7wk9L/aKhtdUIvT3MPNYza73NThg5hUUriX+aNwl52
 x8A=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Aug 2019 19:29:49 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 1/7] block: Cleanup elevator_init_mq() use
Date:   Wed, 28 Aug 2019 11:29:41 +0900
Message-Id: <20190828022947.23364-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828022947.23364-1-damien.lemoal@wdc.com>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
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
---
 block/blk-mq.c   |  8 +++-----
 block/elevator.c | 23 +++++++++++++----------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f6620a30752e..de3aeafe48eb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2895,11 +2895,9 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
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
index 4781c4205a5d..ab4d50c0ed43 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -633,16 +633,26 @@ int elevator_switch_mq(struct request_queue *q,
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
 
@@ -720,13 +730,6 @@ static int __elevator_change(struct request_queue *q, const char *name)
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

