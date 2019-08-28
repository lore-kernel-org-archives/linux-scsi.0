Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DD8C3A5A7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FB8C214DA
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PJ9M+Eei"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfH1C3w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 22:29:52 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27195 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfH1C3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 22:29:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566959391; x=1598495391;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=zD6IYX5E4kT9Lcea1baEsf6zJZ2xUVtyiirh9rFfybM=;
  b=PJ9M+EeiMLnqJ9NiEb53rdztmwrqMRRmk9GH7qtzlMles8al6IVOoSxa
   7St1g7xAzzgJDAP72wysymLy6IsjYTY1Y8pUXtOOWMbJxYMOcTtML+k0J
   3altWXzzBYvq/xudL1EVvTTtONbsBOgVw3oE4AnOr87KPqdWS3awtcRXr
   VRjemKb/55Q5JbnIfnp04tpKTq+lU4SyJTZ/m6JDeYSgSm+HonVJoXNEq
   SlkpxAOkjcrcVT/mDH1hKcLT9Co8xEgZtmKjWzLwj+q32Lo0QzbTDxnCU
   W0kItkXe9U9VjpPGRkes+UHT3JbwLi5Kj9iX2KhHea/ABv80/pwVMyKWc
   g==;
IronPort-SDR: sghL1eSXiCy93niXk9bpstWSUBaEIkXv4cgAns8MoxZFZkxaMgSZgB5T9AV9q6lYXYsiGNaSVM
 XYH1+WifJhoM5T/T9mKRPDqbQtyq/L5WPkFLv508FJoG7xZDRAh7G4B4t61RJO1xtoeLmYByMr
 +sw3A/v0Kjlu++wbz57vIzAeyb3/TQnkzadkXmgHKqdqoit4ZgyYc1onz7pfETUhWN1OIcLsrd
 DO2j1aUDtWSZj8QMJUdCzqwckmrfg+MNGaT3cMzrVXc3Bd6TVQ8eypmsjC94XbQqi7nQtrpEca
 Qrc=
X-IronPort-AV: E=Sophos;i="5.64,439,1559491200"; 
   d="scan'208";a="223475482"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 10:29:50 +0800
IronPort-SDR: s9qVa7hiucnjq6hfQ0K965jxFryaUHYbXPxIumbpwrFoDlkOit+pXOu8Uc3fs8WpentZSXbqb+
 G9ImWq34ptXYD2jcxSM3tTJvkLpuWjsSJoRIFASs9BkLZswCRY17fFXKqo13GI1UJKOizgAb28
 XRE42kR8ik24GwAYSeyOs4r9KNUKMKOGqIL0MqYF1Jdz1kSXfAAKTaQzWsiZp8XSDm0tp9IRTY
 vYrCLHAQCpw4vmZ9NCvZNF7BghM1O2YLw7K9USiqjUdoLfBT9MIqWWC98DiWfuB5GxToPnNjac
 PtKVfXBIxfmbufDs73ZllM5I
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 19:27:01 -0700
IronPort-SDR: MXJsheLImXE2Er/AEAjD0h0/GT3MygN1doH0yjuJPq3SUVMiA3K1p/DoyaXS2DIVAplvVUbGqH
 /2ttyqPWLRxnc19vYqAtE+nzwWakMRice8mCUyrDnVwivURnxuuxOkX4eMDsi37Y1yDbL9khVs
 mhVhRHB0xTX6uItHMCe3pT0zWcN/DGDpLD1XJ5IcHMVBeToV+0Fvjddy7Mx45cuT1HR4bTADom
 UfKEFaSzCDRywhw2o+7xcYWRCX13BjumXxyRCHqUbRcMgBpsOAgqe2/UOGfQLNECkHkW+w+kdf
 VA4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Aug 2019 19:29:50 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 2/7] block: Change elevator_init_mq() to always succeed
Date:   Wed, 28 Aug 2019 11:29:42 +0900
Message-Id: <20190828022947.23364-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828022947.23364-1-damien.lemoal@wdc.com>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
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
---
 block/blk-mq.c   |  8 +-------
 block/blk.h      |  2 +-
 block/elevator.c | 23 ++++++++++++-----------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index de3aeafe48eb..0c9b1f403db8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2833,8 +2833,6 @@ static unsigned int nr_hw_queues(struct blk_mq_tag_set *set)
 struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 						  struct request_queue *q)
 {
-	int ret = -ENOMEM;
-
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
 
@@ -2895,14 +2893,10 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
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
index ab4d50c0ed43..06b70981a054 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -642,34 +642,35 @@ static inline bool elv_support_iosched(struct request_queue *q)
 
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

