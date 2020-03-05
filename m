Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB22C3F2DF
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28B80208CD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgCEL7I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 06:59:08 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727425AbgCEL7I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Mar 2020 06:59:08 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E919BC609428AFABC565;
        Thu,  5 Mar 2020 19:59:04 +0800 (CST)
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
Subject: [PATCH RFC v6 04/10] blk-mq: Facilitate a shared sbitmap per tagset
Date:   Thu, 5 Mar 2020 19:54:34 +0800
Message-ID: <1583409280-158604-5-git-send-email-john.garry@huawei.com>
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

Some SCSI HBAs (such as HPSA, megaraid, mpt3sas, hisi_sas_v3 ..) support
multiple reply queues with single hostwide tags.

In addition, these drivers want to use interrupt assignment in
pci_alloc_irq_vectors(PCI_IRQ_AFFINITY). However, as discussed in [0],
CPU hotplug may cause in-flight IO completion to not be serviced when an
interrupt is shutdown.

To solve that problem, Ming's patchset to drain hctx's should ensure no
IOs are missed in-flight [1].

However, to take advantage of that patchset, we need to map the HBA HW
queues to blk mq hctx's; to do that, we need to expose the HBA HW queues.

In making that transition, the per-SCSI command request tags are no
longer unique per Scsi host - they are just unique per hctx. As such, the
HBA LLDD would have to generate this tag internally, which has a certain
performance overhead.

However another problem is that blk mq assumes the host may accept
(Scsi_host.can_queue * #hw queue) commands. In [2], we removed the Scsi
host busy counter, which would stop the LLDD being sent more than
.can_queue commands; however, we should still ensure that the block layer
does not issue more than .can_queue commands to the Scsi host.

To solve this problem, introduce a shared sbitmap per blk_mq_tag_set,
which may be requested at init time.

New flag BLK_MQ_F_TAG_HCTX_SHARED should be set when requesting the
tagset to indicate whether the shared sbitmap should be used.

Even when BLK_MQ_F_TAG_HCTX_SHARED is set, we still allocate a full set of
tags and requests per hctx; the reason for this is that if we only allocate
tags and requests for a single hctx - like hctx0 - we may break block
drivers which expect a request be associated with a specific hctx, i.e.
not hctx0.

This is based on work originally from Ming Lei in [3] and from Bart's
suggestion in [4].

[0] https://lore.kernel.org/linux-block/alpine.DEB.2.21.1904051331270.1802@nanos.tec.linutronix.de/
[1] https://lore.kernel.org/linux-block/20191014015043.25029-1-ming.lei@redhat.com/
[2] https://lore.kernel.org/linux-scsi/20191025065855.6309-1-ming.lei@redhat.com/
[3] https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/
[4] https://lore.kernel.org/linux-block/ff77beff-5fd9-9f05-12b6-826922bace1f@huawei.com/T/#m3db0a602f095cbcbff27e9c884d6b4ae826144be

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-tag.c     | 36 ++++++++++++++++++++++++++++++++++--
 block/blk-mq-tag.h     | 10 +++++++++-
 block/blk-mq.c         | 28 ++++++++++++++++++++++++++--
 block/blk-mq.h         |  5 +++++
 include/linux/blk-mq.h |  3 +++
 5 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index b153ecf8c5c6..dd704118fe83 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -220,7 +220,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 	 * We can hit rq == NULL here, because the tagging functions
 	 * test and set the bit before assigning ->rqs[].
 	 */
-	if (rq && rq->q == hctx->queue)
+	if (rq && rq->q == hctx->queue && rq->mq_hctx == hctx)
 		return iter_data->fn(hctx, rq, iter_data->data, reserved);
 	return true;
 }
@@ -444,6 +444,7 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
 		     round_robin, node))
 		goto free_bitmap_tags;
 
+	/* We later overwrite these in case of per-set shared sbitmap */
 	tags->bitmap_tags = &tags->__bitmap_tags;
 	tags->breserved_tags = &tags->__breserved_tags;
 
@@ -453,7 +454,32 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
 	return -ENOMEM;
 }
 
-struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
+bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set)
+{
+	unsigned int depth = tag_set->queue_depth - tag_set->reserved_tags;
+	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(tag_set->flags);
+	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
+	int node = tag_set->numa_node;
+
+	if (bt_alloc(&tag_set->__bitmap_tags, depth, round_robin, node))
+		return false;
+	if (bt_alloc(&tag_set->__breserved_tags, tag_set->reserved_tags,
+		     round_robin, node))
+		goto free_bitmap_tags;
+	return true;
+free_bitmap_tags:
+	sbitmap_queue_free(&tag_set->__bitmap_tags);
+	return false;
+}
+
+void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set)
+{
+	sbitmap_queue_free(&tag_set->__bitmap_tags);
+	sbitmap_queue_free(&tag_set->__breserved_tags);
+}
+
+struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
+				     unsigned int total_tags,
 				     unsigned int reserved_tags,
 				     int node, int alloc_policy)
 {
@@ -480,6 +506,7 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 
 void blk_mq_free_tags(struct blk_mq_tags *tags)
 {
+	/* Do not use tags->{bitmap, breserved}_tags */
 	sbitmap_queue_free(&tags->__bitmap_tags);
 	sbitmap_queue_free(&tags->__breserved_tags);
 	kfree(tags);
@@ -538,6 +565,11 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 	return 0;
 }
 
+void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int size)
+{
+	sbitmap_queue_resize(&set->__bitmap_tags, size - set->reserved_tags);
+}
+
 /**
  * blk_mq_unique_tag() - return a tag that is unique queue-wide
  * @rq: request for which to compute a unique tag
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 4f866a39b926..0a57e4f041a9 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -25,7 +25,12 @@ struct blk_mq_tags {
 };
 
 
-extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int reserved_tags, int node, int alloc_policy);
+extern bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set);
+extern void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set);
+extern struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *tag_set,
+					    unsigned int nr_tags,
+					    unsigned int reserved_tags,
+					    int node, int alloc_policy);
 extern void blk_mq_free_tags(struct blk_mq_tags *tags);
 
 extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
@@ -34,6 +39,9 @@ extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
 extern int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 					struct blk_mq_tags **tags,
 					unsigned int depth, bool can_grow);
+extern void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set,
+					     unsigned int size);
+
 extern void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool);
 void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
 		void *priv);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 375f5064c183..d10e24bee7d9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2126,7 +2126,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 
-	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
+	tags = blk_mq_init_tags(set, nr_tags, reserved_tags, node,
 				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
 	if (!tags)
 		return NULL;
@@ -2980,8 +2980,10 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 	return 0;
 
 out_unwind:
-	while (--i >= 0)
+	while (--i >= 0) {
 		blk_mq_free_rq_map(set->tags[i]);
+		set->tags[i] = NULL;
+	}
 
 	return -ENOMEM;
 }
@@ -3147,11 +3149,28 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (ret)
 		goto out_free_mq_map;
 
+	if (blk_mq_is_sbitmap_shared(set)) {
+		if (!blk_mq_init_shared_sbitmap(set)) {
+			ret = -ENOMEM;
+			goto out_free_mq_rq_maps;
+		}
+
+		for (i = 0; i < set->nr_hw_queues; i++) {
+			struct blk_mq_tags *tags = set->tags[i];
+
+			tags->bitmap_tags = &set->__bitmap_tags;
+			tags->breserved_tags = &set->__breserved_tags;
+		}
+	}
+
 	mutex_init(&set->tag_list_lock);
 	INIT_LIST_HEAD(&set->tag_list);
 
 	return 0;
 
+out_free_mq_rq_maps:
+	for (i = 0; i < set->nr_hw_queues; i++)
+		blk_mq_free_rq_map(set->tags[i]);
 out_free_mq_map:
 	for (i = 0; i < set->nr_maps; i++) {
 		kfree(set->map[i].mq_map);
@@ -3170,6 +3189,9 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 	for (i = 0; i < set->nr_hw_queues; i++)
 		blk_mq_free_map_and_requests(set, i);
 
+	if (blk_mq_is_sbitmap_shared(set))
+		blk_mq_exit_shared_sbitmap(set);
+
 	for (j = 0; j < set->nr_maps; j++) {
 		kfree(set->map[j].mq_map);
 		set->map[j].mq_map = NULL;
@@ -3206,6 +3228,8 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		if (!hctx->sched_tags) {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
 							false);
+			if (!ret && blk_mq_is_sbitmap_shared(set))
+				blk_mq_tag_resize_shared_sbitmap(set, nr);
 		} else {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
 							nr, true);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 10bfdfb494fa..dde2d29f0ce5 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -158,6 +158,11 @@ struct blk_mq_alloc_data {
 	struct blk_mq_hw_ctx *hctx;
 };
 
+static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set *tag_set)
+{
+	return tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED;
+}
+
 static inline struct blk_mq_tags *blk_mq_tags_from_data(struct blk_mq_alloc_data *data)
 {
 	if (data->flags & BLK_MQ_REQ_INTERNAL)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ab1618007600..f9db604c3b10 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -245,6 +245,8 @@ struct blk_mq_tag_set {
 	unsigned int		flags;
 	void			*driver_data;
 
+	struct sbitmap_queue	__bitmap_tags;
+	struct sbitmap_queue	__breserved_tags;
 	struct blk_mq_tags	**tags;
 
 	struct mutex		tag_list_lock;
@@ -388,6 +390,7 @@ struct blk_mq_ops {
 enum {
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_TAG_QUEUE_SHARED	= 1 << 1,
+	BLK_MQ_F_TAG_HCTX_SHARED	= 1 << 2,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
 	BLK_MQ_F_NO_SCHED	= 1 << 6,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
-- 
2.17.1

