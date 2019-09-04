Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9362EC3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AB1122CEA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hb4hSmXJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbfIDInB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:43:01 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39226 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfIDInA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 04:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567586580; x=1599122580;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=4es099Tzn+1lybmV19FyhcM0o6YKAGlTweyIXLI8G2M=;
  b=hb4hSmXJAI9v2SzUejVrhUQjNeH/jUdAUo40zmTe614Ubg6sH0AH0WNO
   FcHhpgKMKgQgpqIZjQufFO4IBCfNpVntvVPCY0hllEFZ0BJuLF7z1l1eb
   N6K6kEWaHKjzzt9oy+RillbY3j03dMN4BfDjAZdnZabkIpuxI/zUmOEcI
   bIluRo7ZrI2DX/Js0oJuPwBr2IMUxnXIpR4OQ5gXeGhmrHGP5EH5leAek
   v+fKte/AirgrEWqMdyv53Ixo7ZDPGrMo7jg27OJWirLwelzrbGzY0wmSv
   SMUcsm+GfbakXD6NkM9UoXjkiAeFEYC7ECIcDSc5djozn1lhPtWugTJFG
   g==;
IronPort-SDR: ujBneVbbV2b/88zzuzswt699GYI82j7GOb1XgHm5WFrBIZ57X+1ZX44fCsrhVrXNmWtbbHRoy4
 9w9R/GUG3WVIzov93Iry4sR3gfAIGj24Kc9Id9dd0z0V59iQ4fA8UALA/uKkRJc1HGnTpClGcE
 iyyyVMUgGBAd3BOTNeT+NOsCYorVi6Qu414u4RuO5secEX5FBn0z/b0jksbnCqrKw1C67r9J/x
 7HQWu+32xTvPRp5myO6wl2eBEVe7sswTLLjNAE87SQbSs2LxjtxSkSMY3WY5a6RzCzjnH+qBSx
 zas=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="117374678"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 16:42:50 +0800
IronPort-SDR: LjYDXfPL4bwqTodKbRL9BsVQg0G6x40IGBdzr13cgXI/zWsiQfsLC9YcQKltrwRw+AZrCCx/wb
 Ig6dG3Mbegh8VIHXPk3vFs1HCnJkzk/Vr5mf+gqm6/4o0IaM7hKVWsrDN1YdYEZl/qHAhTyx4l
 C+mJyrb6X3oUZ4UXffZ1hM7ghT+k72Q22MQBL7yqfRU94rgK/3x7uaUzOnUOESMDYwNlb2RTW6
 1KhDuBl99OXZTtXtgnBGrhyC2Bh00NcrGOm6VVUbSA5Ml4+xkwANh82/RXl/TFhBRPSbhPe2RC
 dh3hdto/b6ffkZ8ihc6ADNVk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 01:39:49 -0700
IronPort-SDR: AaNK2TxyhgB647U85QFUVTisRiGpWXWtLYtEPE5FZP9ppSsE23o0k7/HNBpaS2Sd7Elji6lraP
 MczZhOupjkvfMngI+hKkHloMNyhzwmMuX20OHV1Z9nYYmXdEfBHSjCFKrWMlpTY8idn13ss0/4
 pazxnawPEskWLr3xdZtdF4fBLodyf2nuPL6ZBqBjL8o5OTNLnxLqpIHclnPbZXmpLQLNqyQaQt
 ZoJAT8DcgF2nvt6YtBPyFWgvJS4aJc+6jAmwubYHbYp/ysCOsVCrXchfz5mspZYk7mxAQNdWEV
 V2g=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Sep 2019 01:42:49 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 2/7] block: Change elevator_init_mq() to always succeed
Date:   Wed,  4 Sep 2019 17:42:42 +0900
Message-Id: <20190904084247.23338-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904084247.23338-1-damien.lemoal@wdc.com>
References: <20190904084247.23338-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the default elevator chosen is mq-deadline, elevator_init_mq() may
return an error if mq-deadline initialization fails, leading to
blk_mq_init_allocated_queue() returning an error, which in turn will
cause the block device initialization to fail and the device not being
exposed.

Instead of taking such extreme measure, handle mq-deadline
initialization failures in the same manner as when mq-deadline is not
available (no module to load), that is, default to the "none" scheduler.
With this change, elevator_init_mq() return type can be changed to void.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c   |  8 +-------
 block/blk.h      |  2 +-
 block/elevator.c | 23 ++++++++++++-----------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 13923630e00a..ee4caf0c0807 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2842,8 +2842,6 @@ static unsigned int nr_hw_queues(struct blk_mq_tag_set *set)
 struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 						  struct request_queue *q)
 {
-	int ret = -ENOMEM;
-
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
 
@@ -2904,14 +2902,10 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
 
-	ret = elevator_init_mq(q);
-	if (ret)
-		goto err_tag_set;
+	elevator_init_mq(q);
 
 	return q;
 
-err_tag_set:
-	blk_mq_del_queue_tag_set(q);
 err_hctxs:
 	kfree(q->queue_hw_ctx);
 	q->nr_hw_queues = 0;
diff --git a/block/blk.h b/block/blk.h
index e4619fc5c99a..ed347f7a97b1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -184,7 +184,7 @@ void blk_account_io_done(struct request *req, u64 now);
 
 void blk_insert_flush(struct request *rq);
 
-int elevator_init_mq(struct request_queue *q);
+void elevator_init_mq(struct request_queue *q);
 int elevator_switch_mq(struct request_queue *q,
 			      struct elevator_type *new_e);
 void __elevator_exit(struct request_queue *, struct elevator_queue *);
diff --git a/block/elevator.c b/block/elevator.c
index 4721834815bb..2944c129760c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -628,34 +628,35 @@ static inline bool elv_support_iosched(struct request_queue *q)
 
 /*
  * For blk-mq devices supporting IO scheduling, we default to using mq-deadline,
- * if available, for single queue devices. If deadline isn't available OR we
- * have multiple queues, default to "none".
+ * if available, for single queue devices. If deadline isn't available OR
+ * deadline initialization fails OR we have multiple queues, default to "none".
  */
-int elevator_init_mq(struct request_queue *q)
+void elevator_init_mq(struct request_queue *q)
 {
 	struct elevator_type *e;
-	int err = 0;
+	int err;
 
 	if (!elv_support_iosched(q))
-		return 0;
+		return;
 
 	if (q->nr_hw_queues != 1)
-		return 0;
+		return;
 
 	WARN_ON_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags));
 
 	if (unlikely(q->elevator))
-		goto out;
+		return;
 
 	e = elevator_get(q, "mq-deadline", false);
 	if (!e)
-		goto out;
+		return;
 
 	err = blk_mq_init_sched(q, e);
-	if (err)
+	if (err) {
+		pr_warn("\"%s\" elevator initialization failed, "
+			"falling back to \"none\"\n", e->elevator_name);
 		elevator_put(e);
-out:
-	return err;
+	}
 }
 
 
-- 
2.21.0

