Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665C3C433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505AE2070B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgFJRdn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 13:33:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5811 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726651AbgFJRdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 13:33:35 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 26B5DDBF4E63B636A098;
        Thu, 11 Jun 2020 01:33:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 11 Jun 2020 01:33:18 +0800
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
Subject: [PATCH RFC v7 04/12] blk-mq: Facilitate a shared sbitmap per tagset
Date:   Thu, 11 Jun 2020 01:29:11 +0800
Message-ID: <1591810159-240929-5-git-send-email-john.garry@huawei.com>
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

Some SCSI HBAs (such as HPSA, megaraid, mpt3sas, hisi_sas_v3 ..) support
multiple reply queues with single hostwide tags.

In addition, these drivers want to use interrupt assignment in
pci_alloc_irq_vectors(PCI_IRQ_AFFINITY). However, as discussed in [0],
CPU hotplug may cause in-flight IO completion to not be serviced when an
interrupt is shutdown. That problem is solved in commit bf0beec0607d
("blk-mq: drain I/O when all CPUs in a hctx are offline").

However, to take advantage of that blk-mq feature, the HBA HW queuess are
required to be mapped to that of the blk-mq hctx's; to do that, the HBA HW queues
need to be exposed to the upper layer.

In making that transition, the per-SCSI command request tags are no
longer unique per Scsi host - they are just unique per hctx. As such, the
HBA LLDD would have to generate this tag internally, which has a certain
performance overhead.

However another problem is that blk-mq assumes the host may accept
(Scsi_host.can_queue * #hw queue) commands. In commit 6eb045e092ef ("scsi:
 core: avoid host-wide host_busy counter for scsi_mq"), the Scsi host busy
counter was removed, which would stop the LLDD being sent more than
.can_queue commands; however, it should still be ensured that the block
layer does not issue more than .can_queue commands to the Scsi host.

To solve this problem, introduce a shared sbitmap per blk_mq_tag_set,
which may be requested at init time.

New flag BLK_MQ_F_TAG_HCTX_SHARED should be set when requesting the
tagset to indicate whether the shared sbitmap should be used.

Even when BLK_MQ_F_TAG_HCTX_SHARED is set, a full set of tags and requests
are still allocated per hctx; the reason for this is that if tags and
requests were only allocated for a single hctx - like hctx0 - it may break
block drivers which expect a request be associated with a specific hctx,
i.e. not always hctx0. This will introduce extra memory usage.

This change is based on work originally from Ming Lei in [1] and from
Bart's suggestion in [2].

[0] https://lore.kernel.org/linux-block/alpine.DEB.2.21.1904051331270.1802@nanos.tec.linutronix.de/
[1] https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/
[2] https://lore.kernel.org/linux-block/ff77beff-5fd9-9f05-12b6-826922bace1f@huawei.com/T/#m3db0a602f095cbcbff27e9c884d6b4ae826144be

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-mq-tag.c     | 39 +++++++++++++++++++++++++++++++++++++--
 block/blk-mq-tag.h     | 10 +++++++++-
 block/blk-mq.c         | 24 +++++++++++++++++++++++-
 block/blk-mq.h         |  5 +++++
 include/linux/blk-mq.h |  6 ++++++
 5 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index be39db3c88d7..92843e3e1a2a 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -228,7 +228,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 	 * We can hit rq == NULL here, because the tagging functions
 	 * test and set the bit before assigning ->rqs[].
 	 */
-	if (rq && rq->q == hctx->queue)
+	if (rq && rq->q == hctx->queue && rq->mq_hctx == hctx)
 		return iter_data->fn(hctx, rq, iter_data->data, reserved);
 	return true;
 }
@@ -466,6 +466,7 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
 		     round_robin, node))
 		goto free_bitmap_tags;
 
+	/* We later overwrite these in case of per-set shared sbitmap */
 	tags->bitmap_tags = &tags->__bitmap_tags;
 	tags->breserved_tags = &tags->__breserved_tags;
 
@@ -475,7 +476,32 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
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
@@ -502,6 +528,10 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 
 void blk_mq_free_tags(struct blk_mq_tags *tags)
 {
+	/*
+	 * Do not free tags->{bitmap, breserved}_tags, as this may point to
+	 * shared sbitmap
+	 */
 	sbitmap_queue_free(&tags->__bitmap_tags);
 	sbitmap_queue_free(&tags->__breserved_tags);
 	kfree(tags);
@@ -560,6 +590,11 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
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
index cebf7a4b280a..cf39dd13a24d 100644
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
index 90b645c3092c..77120dd4e4d5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2229,7 +2229,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 
-	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
+	tags = blk_mq_init_tags(set, nr_tags, reserved_tags, node,
 				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
 	if (!tags)
 		return NULL;
@@ -3349,11 +3349,28 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
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
@@ -3372,6 +3389,9 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 	for (i = 0; i < set->nr_hw_queues; i++)
 		blk_mq_free_map_and_requests(set, i);
 
+	if (blk_mq_is_sbitmap_shared(set))
+		blk_mq_exit_shared_sbitmap(set);
+
 	for (j = 0; j < set->nr_maps; j++) {
 		kfree(set->map[j].mq_map);
 		set->map[j].mq_map = NULL;
@@ -3408,6 +3428,8 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		if (!hctx->sched_tags) {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
 							false);
+			if (!ret && blk_mq_is_sbitmap_shared(set))
+				blk_mq_tag_resize_shared_sbitmap(set, nr);
 		} else {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
 							nr, true);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index a139b0631817..1a283c707215 100644
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
index 233209e8030d..7b31cdb92a71 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -231,6 +231,9 @@ enum hctx_type {
  * @flags:	   Zero or more BLK_MQ_F_* flags.
  * @driver_data:   Pointer to data owned by the block driver that created this
  *		   tag set.
+ * @__bitmap_tags: A shared tags sbitmap, used over all hctx's
+ * @__breserved_tags:
+ *		   A shared reserved tags sbitmap, used over all hctx's
  * @tags:	   Tag sets. One tag set per hardware queue. Has @nr_hw_queues
  *		   elements.
  * @tag_list_lock: Serializes tag_list accesses.
@@ -250,6 +253,8 @@ struct blk_mq_tag_set {
 	unsigned int		flags;
 	void			*driver_data;
 
+	struct sbitmap_queue	__bitmap_tags;
+	struct sbitmap_queue	__breserved_tags;
 	struct blk_mq_tags	**tags;
 
 	struct mutex		tag_list_lock;
@@ -398,6 +403,7 @@ enum {
 	 * completing IO:
 	 */
 	BLK_MQ_F_STACKING	= 1 << 2,
+	BLK_MQ_F_TAG_HCTX_SHARED = 1 << 3,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
 	BLK_MQ_F_NO_SCHED	= 1 << 6,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
-- 
2.26.2

