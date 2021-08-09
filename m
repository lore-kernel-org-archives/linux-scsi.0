Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98651C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FB1661004
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 14:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhHIOio (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:38:44 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3614 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbhHIOgR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 10:36:17 -0400
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gjz9k5j6mz6CB0X;
        Mon,  9 Aug 2021 22:34:18 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 9 Aug 2021 16:34:48 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 15:34:45 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        <hare@suse.de>, <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 08/11] blk-mq: Add blk_mq_ops.init_request_no_hctx()
Date:   Mon, 9 Aug 2021 22:29:35 +0800
Message-ID: <1628519378-211232-9-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a variant of the init_request function which does not pass a hctx_idx
arg.

This is important for shared sbitmap support, as it needs to be ensured for
introducing shared static rqs that the LLDD cannot think that requests
are associated with a specific HW queue.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq.c         | 15 ++++++++++-----
 include/linux/blk-mq.h |  7 +++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f14cc2705f9b..4d6723cfa582 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2427,13 +2427,15 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 static int blk_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 			       unsigned int hctx_idx, int node)
 {
-	int ret;
+	int ret = 0;
 
-	if (set->ops->init_request) {
+	if (set->ops->init_request)
 		ret = set->ops->init_request(set, rq, hctx_idx, node);
-		if (ret)
-			return ret;
-	}
+	else if (set->ops->init_request_no_hctx)
+		ret = set->ops->init_request_no_hctx(set, rq, node);
+
+	if (ret)
+		return ret;
 
 	WRITE_ONCE(rq->state, MQ_RQ_IDLE);
 	return 0;
@@ -3487,6 +3489,9 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (!set->ops->get_budget ^ !set->ops->put_budget)
 		return -EINVAL;
 
+	if (set->ops->init_request && set->ops->init_request_no_hctx)
+		return -EINVAL;
+
 	if (set->queue_depth > BLK_MQ_MAX_DEPTH) {
 		pr_info("blk-mq: reduced tag depth to %u\n",
 			BLK_MQ_MAX_DEPTH);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 22215db36122..c838b24944c2 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -357,6 +357,13 @@ struct blk_mq_ops {
 	 */
 	int (*init_request)(struct blk_mq_tag_set *set, struct request *,
 			    unsigned int, unsigned int);
+
+	/**
+	 * @init_request: Same as init_request, except no hw queue index is passed
+	 */
+	int (*init_request_no_hctx)(struct blk_mq_tag_set *set, struct request *,
+				    unsigned int);
+
 	/**
 	 * @exit_request: Ditto for exit/teardown.
 	 */
-- 
2.26.2

