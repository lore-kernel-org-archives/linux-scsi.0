Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC281C3A5AC
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E8672080C
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZYF35tSy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731137AbfIEE3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:29:04 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62199 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731095AbfIEE3E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 00:29:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567657743; x=1599193743;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=qtVWwALxJeFLEm5MyqWAjj8rH1FAELNGevTMV0H6ZXk=;
  b=ZYF35tSyqR3gegwj/p9MfvUXIdUN2cFEl4e5Ave/KxfJinH0giZBjfaJ
   nTNZKn2+X5/HpdeMIbb3KGSwPcBkgS6jvScXVbCn3DhbeyLVC9Pr9vRqP
   +r91afhD8UcVMvbqm3bOqWZCpUrHtr8wfWdm6S6pgQA5V/cPPnyCI3QYd
   LAoer56jvTEU4+zJOez+SdAA8mc0au7D0tI3L3aaHBk+LlYT/7ZOrld6I
   0xTG+YQLtNcVECK/wTdRKvH7eGG9y+aDhc5k8FNT8L8P8IpDpiG52wuY6
   dTfzHACurKT1lQIF+Gi60olepYVRJgRLpY5qLJoMnyL61v28oEh2zk8v/
   A==;
IronPort-SDR: 09150fBcQvlfxkvSqFX3sn1FZgzQ/leVTjSXFieLou7P4nbQ+UyUmu17jk1GjbaLcJ6LbmtHlw
 UUVSIHXgZgfCWKRCBIAARdbyDwaPNJ/RRrg4d7qF0GGvcP5DwKCmXsUWH5BJmZNztHZiVkb3F1
 eqJn4xZDNtiMYtoYimay5g7Yg2N1PhJiu8kCCZuhwt6RrjMYY6EfLAmIEHs/VilN8Eowv4Xwdx
 Cg7UEITzTGeTP7X7qDKGQYALl0TQ/RCpPJ1+Gz7WknDPlyuXyuL2Jf3alk4S7Mwmv6nSVL7s7m
 uYc=
X-IronPort-AV: E=Sophos;i="5.64,469,1559491200"; 
   d="scan'208";a="224233069"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 12:29:03 +0800
IronPort-SDR: f3W0iS3aGjsD1MzllTfijdIA04QC2dd1DU0quxT6y57RBQKCY+lwI4vq9IEvNLt+eC1za6Su2m
 USslcH2l4pJkl7i7R0swZy2mZLvaOHTGgOqde6kSGRsVHBocRNOwG9DawMCiwXd3u9qHkrrnN+
 buGvyNIFiKofab6lAF7zmkpfovy/QXkaZPT1LOQjHrum7LAnn37bUSF6mNcGWoqrIbRuBpnC7j
 yksfx2QqjC2wB5g+ZHfExDOZjR8JwDcKIGaN6vLx6wE1XAXjvEnTRd/YrMh2G2IMZ0UT6bWT/I
 J44SeRRYC9eR+O+sQ6a7banb
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 21:26:00 -0700
IronPort-SDR: v4B8gCMzULr//ZLaNoU6WtXqF1j6Ep8cTKQbUMXFdawALoDILK0oa5WjDMcJ0KDuN5sLnF6aqV
 47qJExAYV1U6EDdunktcB7yHfTULJQbkq8wtXoOrKzqPgHkwwkLmcTRaT0XcDerEE9HQRsFk7x
 uTSTBvgXBablfbsVyQjz/QGB3CvqzXZiiLSIHQHMSv4JUfIJlxNxMedKPkfz4R/OQid9pYVrvl
 oBh8zRmljOkTgkv714QLjKWK1fiJTzH6QgC34KzPh/VWitKSimdnldf8vLN3qB3NjOLZJTsvGU
 erU=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 04 Sep 2019 21:29:03 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 1/7] block: Cleanup elevator_init_mq() use
Date:   Thu,  5 Sep 2019 13:28:55 +0900
Message-Id: <20190905042901.5830-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905042901.5830-1-damien.lemoal@wdc.com>
References: <20190905042901.5830-1-damien.lemoal@wdc.com>
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

