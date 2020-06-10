Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E07C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B3D2070B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgFJRdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 13:33:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5809 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726713AbgFJRdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 13:33:35 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 142185FA3A0285FBF2DE;
        Thu, 11 Jun 2020 01:33:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 11 Jun 2020 01:33:19 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>, <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v7 07/12] blk-mq: Add support in hctx_tags_bitmap_show() for a shared sbitmap
Date:   Thu, 11 Jun 2020 01:29:14 +0800
Message-ID: <1591810159-240929-8-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.de> #earlier version
Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-debugfs.c | 62 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 05b4be0c03d9..4da7e54adf3b 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -495,6 +495,67 @@ static int hctx_tags_show(void *data, struct seq_file *m)
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
+static int hctx_tags_shared_sbitmap_bitmap_show(void *data, struct seq_file *m)
+{
+	struct blk_mq_hw_ctx *hctx = data;
+	struct request_queue *q = hctx->queue;
+	struct blk_mq_tag_set *set = q->tag_set;
+	struct sbitmap shared_sb, *sb;
+	int res;
+
+	if (!set)
+		return 0;
+
+	/*
+	 * We could use the allocated sbitmap for that hctx here, but
+	 * that would mean that we would need to clean it prior to use.
+	 */
+	res = sbitmap_init_node(&shared_sb,
+				set->__bitmap_tags.sb.depth,
+				set->__bitmap_tags.sb.shift,
+				GFP_KERNEL, NUMA_NO_NODE);
+	if (res)
+		return res;
+	sb = &shared_sb;
+
+	res = mutex_lock_interruptible(&q->sysfs_lock);
+	if (res)
+		goto out;
+	if (hctx->tags) {
+		hctx_filter_sb(sb, hctx);
+		sbitmap_bitmap_show(sb, m);
+	}
+
+	mutex_unlock(&q->sysfs_lock);
+
+out:
+	sbitmap_free(&shared_sb);
+	return res;
+}
+
 static int hctx_tags_bitmap_show(void *data, struct seq_file *m)
 {
 	struct blk_mq_hw_ctx *hctx = data;
@@ -823,6 +884,7 @@ static const struct blk_mq_debugfs_attr blk_mq_debugfs_hctx_shared_sbitmap_attrs
 	{"busy", 0400, hctx_busy_show},
 	{"ctx_map", 0400, hctx_ctx_map_show},
 	{"tags", 0400, hctx_tags_show},
+	{"tags_bitmap", 0400, hctx_tags_shared_sbitmap_bitmap_show},
 	{"sched_tags", 0400, hctx_sched_tags_show},
 	{"sched_tags_bitmap", 0400, hctx_sched_tags_bitmap_show},
 	{"io_poll", 0600, hctx_io_poll_show, hctx_io_poll_write},
-- 
2.26.2

