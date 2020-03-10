Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805FEC10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5623C215A4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgCJQb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:31:57 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727075AbgCJQao (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:44 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EE4AD346438384E4A2EA;
        Wed, 11 Mar 2020 00:30:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:24 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 03/24] blk-mq: Implement blk_mq_rq_is_reserved()
Date:   Wed, 11 Mar 2020 00:25:29 +0800
Message-ID: <1583857550-12049-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Add function to check if a blk-mq request is from the reserved pool

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq.c         | 13 +++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d92088dec6c3..603c60a1956c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -269,6 +269,19 @@ static inline bool blk_mq_need_time_stamp(struct request *rq)
 	return (rq->rq_flags & (RQF_IO_STAT | RQF_STATS)) || rq->q->elevator;
 }
 
+/**
+ * blk_mq_rq_is_reserved - Check if a request has a reserved tag
+ *
+ * @rq: Request to check
+ */
+bool blk_mq_rq_is_reserved(struct request *rq)
+{
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
+
+	return blk_mq_tag_is_reserved(hctx->tags, rq->tag);
+}
+EXPORT_SYMBOL_GPL(blk_mq_rq_is_reserved);
+
 static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 		unsigned int tag, unsigned int op, u64 alloc_time_ns)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 11cfd6470b1a..8bdc35ac4a63 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -548,6 +548,8 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 	return rq + 1;
 }
 
+bool blk_mq_rq_is_reserved(struct request *rq);
+
 #define queue_for_each_hw_ctx(q, hctx, i)				\
 	for ((i) = 0; (i) < (q)->nr_hw_queues &&			\
 	     ({ hctx = (q)->queue_hw_ctx[i]; 1; }); (i)++)
-- 
2.17.1

