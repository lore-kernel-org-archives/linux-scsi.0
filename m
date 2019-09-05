Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D40DC3A5A5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75AF722CF5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="b2ivoE6J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387555AbfIEJvu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 05:51:50 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25315 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730769AbfIEJvu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 05:51:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567677110; x=1599213110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qtVWwALxJeFLEm5MyqWAjj8rH1FAELNGevTMV0H6ZXk=;
  b=b2ivoE6JWhfGnOHr6d/xSlb2ccAcj4qRm5YjFWn/Wzpa0Hfo6t0AzXUP
   niPghRlWYmLaKllGY5KDQzIVVphYtDPo4pRuDCzXOrpyc6g9kUojmstuC
   7qNX1r3wQDJ8IQ1B1jx7rc2qgffY/JVP11yJrtWiZa12Q/9CXwvo2h0NV
   5GEUuCcVN2f401Ad7MgVYaeSbw0OnnvWBnd9QPFB0wjm2aV0deh4iRr/j
   Ucft3Ar/j1HQ8D+iY3DCeX9ezo9ARgSTnlh11ko9k1JKz2d+3et12Luyi
   SIngGnMCXC8p4zhiBpuMbRIjsQMkcp4/ZUbA2TL79dYoR8wLAkoHXhweR
   Q==;
IronPort-SDR: PmhJRti+Y36/IaUsPv4EGRFoRFBnFzHFQS60LQTWdTXSx1CDaQR7n3GdzEHp09bO7VkYJbr7ZX
 FCt6d08B5VCenzpgtOh3oyGcV0Bnae7Qk3kbAzIN4ewfEtnjynzd/OkHR78j2ryDVZXgXdB9vw
 0lPqWR7XTGuq42Z0IOD32J32DBZbAlQM2s+R1Vne5CBBW3ei5P9+/cBzWFgpbcK9RARPxU4EN1
 ddP+t4l2KhxLVUhFdtPWiDV2wLEbhIiKVyDTrRQSd+OEEW5r/wretX762h14UISYW4xHldDBCC
 gvs=
X-IronPort-AV: E=Sophos;i="5.64,470,1559491200"; 
   d="scan'208";a="119106244"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 17:51:39 +0800
IronPort-SDR: vNc6YPislMAS9M09vn3uaRzkNH1KfwKVXjDMEbYFgbiMOZtOZfJDna4a2SkuSsr5aLicJ/as7t
 sxApaOHEOLAiVuSmsNi+iHdtJoj4HVMibbcBI2Omo6CJUre8UdzbQKO4dHJBxbgkM3KBKt9ccg
 qGGFDbRnzicV3TUD0nyOb8g0ZHC/vSp4CwlbR6Pk+NVWaL9syi1Sf67DF/prskP3h4zun3M0fb
 eS8uSocXJBC/7/te5zrIp9WnLDz7cHmX+Ml3KfSSGEVgzDIDnLv+s+OaGmdGUemG/iND6u8Hkl
 107s/UapZFCOY8f5eIu5WFWf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 02:48:34 -0700
IronPort-SDR: a1602K9Xn5CMGYi4tWl9GfmJctXCTvgg9oOLhQh2hZXPZidyOEm0kgYUMAP7D5yngTAM/SXCXo
 R8TNXefFDNmQMEFZMjt1vvGY6smMg5m2ZEac3gi/nEdfdlRvKIY3XHzSrUcrZyvZz0Hk0/TNTF
 usVvTu1I5y5EdpIQEHMvHPCjQYboeyqZiy0sXeIKs7KDA5lKLsD/8/d3wH5yE0wdxa/VXdHALY
 kDdW38JPIFKQnssywVfp67mCEjcL0+SGTETYQJ83aU4f/FEWPLZ/ze+rbE5ilanMkz3xWMvhKB
 AF0=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2019 02:51:38 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v5 1/7] block: Cleanup elevator_init_mq() use
Date:   Thu,  5 Sep 2019 18:51:29 +0900
Message-Id: <20190905095135.26026-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
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

