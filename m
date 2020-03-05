Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE17CC3F2DD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8DFF20848
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgCEL7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 06:59:10 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11172 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727420AbgCEL7J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Mar 2020 06:59:09 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 20A5B1FA4245235C30CE;
        Thu,  5 Mar 2020 19:59:05 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 19:58:54 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.de>, <don.brace@microsemi.com>,
        <sumit.saxena@broadcom.com>, <hch@infradead.org>,
        <kashyap.desai@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <chenxiang66@hisilicon.com>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v6 05/10] blk-mq: Add support in hctx_tags_bitmap_show() for a shared sbitmap
Date:   Thu, 5 Mar 2020 19:54:35 +0800
Message-ID: <1583409280-158604-6-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since a set-wide shared tag sbitmap may be used, it is no longer valid to
examine the per-hctx tagset for getting the active requests for a hctx
(when a shared sbitmap is used).

As such, add support for the shared sbitmap by using an intermediate
sbitmap per hctx, iterating all active tags for the specific hctx in the
shared sbitmap.

Originally-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-debugfs.c | 57 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index fca87470e267..5c0db0309ebb 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -474,20 +474,73 @@ static int hctx_tags_show(void *data, struct seq_file *m)
 	return res;
 }
 
+struct hctx_sb_data {
+	struct sbitmap		*sb;	/* output bitmap */
+	struct blk_mq_hw_ctx	*hctx;	/* input hctx */
+};
+
+static bool hctx_filter_fn(struct blk_mq_hw_ctx *hctx, struct request *req,
+			   void *priv, bool reserved)
+{
+	struct hctx_sb_data *hctx_sb_data = priv;
+
+	if (hctx == hctx_sb_data->hctx)
+		sbitmap_set_bit(hctx_sb_data->sb, req->tag);
+
+	return true;
+}
+
+static void hctx_filter_sb(struct sbitmap *sb, struct blk_mq_hw_ctx *hctx)
+{
+	struct hctx_sb_data hctx_sb_data = { .sb = sb, .hctx = hctx };
+
+	blk_mq_queue_tag_busy_iter(hctx->queue, hctx_filter_fn, &hctx_sb_data);
+}
+
 static int hctx_tags_bitmap_show(void *data, struct seq_file *m)
 {
 	struct blk_mq_hw_ctx *hctx = data;
 	struct request_queue *q = hctx->queue;
+	struct blk_mq_tag_set *set = q->tag_set;
+	struct sbitmap shared_sb, *sb;
+	bool shared_sbitmap;
 	int res;
 
+	if (!set)
+		return 0;
+
+	shared_sbitmap = blk_mq_is_sbitmap_shared(set);
+
+	if (shared_sbitmap) {
+		/*
+		 * We could use the allocated sbitmap for that hctx here, but
+		 * that would mean that we would need to clean it prior to use.
+		 */
+		res = sbitmap_init_node(&shared_sb,
+					set->__bitmap_tags.sb.depth,
+					set->__bitmap_tags.sb.shift,
+					GFP_KERNEL, NUMA_NO_NODE);
+		if (res)
+			return res;
+		sb = &shared_sb;
+	} else {
+		sb = &hctx->tags->bitmap_tags->sb;
+	}
+
 	res = mutex_lock_interruptible(&q->sysfs_lock);
 	if (res)
 		goto out;
-	if (hctx->tags)
-		sbitmap_bitmap_show(&hctx->tags->bitmap_tags->sb, m);
+	if (hctx->tags) {
+		if (shared_sbitmap)
+			hctx_filter_sb(sb, hctx);
+		sbitmap_bitmap_show(sb, m);
+	}
+
 	mutex_unlock(&q->sysfs_lock);
 
 out:
+	if (shared_sbitmap)
+		sbitmap_free(&shared_sb);
 	return res;
 }
 
-- 
2.17.1

