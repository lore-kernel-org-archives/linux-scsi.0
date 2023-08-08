Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9034C001DE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 16:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbjHHQJ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 12:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbjHHQIL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 12:08:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72662D74
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 08:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691509537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3+EnSRWzHYRgAwaPfCvnjx1xuC05RKXl9LNASqVbR8A=;
        b=GUk9nE2rk0+gzS9M01TAarR+gCYwrich9dRn+rGMDfI+OBqt6ou5n8oETVWB03Tl/or+uD
        UbU+hk9hnZnc3e3JPxdiZM1VLujQes2zCwLwQCehtryR8hhaKVY6tmBt33fSqrlxYH6xll
        UdfvZaM9Xl0qpyfE5zEVJ9oQmWNF1U4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-u2FxbA53OHqCOhATeSOWcQ-1; Tue, 08 Aug 2023 06:43:37 -0400
X-MC-Unique: u2FxbA53OHqCOhATeSOWcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB4BC8007CE;
        Tue,  8 Aug 2023 10:43:36 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1547A140E962;
        Tue,  8 Aug 2023 10:43:35 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 14/14] blk-mq: add helpers for treating kdump kernel
Date:   Tue,  8 Aug 2023 18:42:39 +0800
Message-Id: <20230808104239.146085-15-ming.lei@redhat.com>
In-Reply-To: <20230808104239.146085-1-ming.lei@redhat.com>
References: <20230808104239.146085-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clean up code a bit by adding helpers for treating kdump kernel
specially.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 617d6f849a7b..afa51df2f0d3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -147,6 +147,8 @@ EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait);
  * driver has to take blk-mq max supported nr_hw_queues into account
  * when figuring out nr_hw_queues from hardware info, for avoiding
  * inconsistency between driver and blk-mq.
+ *
+ * Limit to single queue in case of kdump kernel
  */
 unsigned int blk_mq_max_nr_hw_queues(void)
 {
@@ -4370,7 +4372,7 @@ static void blk_mq_update_queue_map(struct blk_mq_tag_set *set)
 	if (set->nr_maps == 1)
 		set->map[HCTX_TYPE_DEFAULT].nr_queues = set->nr_hw_queues;
 
-	if (set->ops->map_queues && !is_kdump_kernel()) {
+	if (set->ops->map_queues) {
 		int i;
 
 		/*
@@ -4420,6 +4422,22 @@ static int blk_mq_realloc_tag_set_tags(struct blk_mq_tag_set *set,
 	return 0;
 }
 
+/* Limit to single map in case of kdump kernel */
+static unsigned int blk_mq_max_nr_maps(void)
+{
+	if (is_kdump_kernel())
+		return 1;
+	return HCTX_MAX_TYPES;
+}
+
+/* Limit to 64 in case of kdump kernel */
+static unsigned int blk_mq_max_depth(void)
+{
+	if (is_kdump_kernel())
+		return 64;
+	return BLK_MQ_MAX_DEPTH;
+}
+
 /*
  * Alloc a tag set to be associated with one or more request queues.
  * May fail with EINVAL for various error conditions. May adjust the
@@ -4456,16 +4474,13 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	else if (set->nr_maps > HCTX_MAX_TYPES)
 		return -EINVAL;
 
-	/*
-	 * If a crashdump is active, then we are potentially in a very
-	 * memory constrained environment. Limit us to 1 queue and
-	 * 64 tags to prevent using too much memory.
-	 */
-	if (is_kdump_kernel()) {
-		set->nr_hw_queues = 1;
-		set->nr_maps = 1;
-		set->queue_depth = min(64U, set->queue_depth);
-	}
+	if (set->nr_hw_queues > blk_mq_max_nr_hw_queues())
+		set->nr_hw_queues = blk_mq_max_nr_hw_queues();
+	if (set->nr_maps > blk_mq_max_nr_maps())
+		set->nr_maps = blk_mq_max_nr_maps();
+	if (set->queue_depth > blk_mq_max_depth())
+		set->queue_depth = blk_mq_max_depth();
+
 	/*
 	 * There is no use for more h/w queues than cpus if we just have
 	 * a single map
@@ -4495,7 +4510,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 						  GFP_KERNEL, set->numa_node);
 		if (!set->map[i].mq_map)
 			goto out_free_mq_map;
-		set->map[i].nr_queues = is_kdump_kernel() ? 1 : set->nr_hw_queues;
+		set->map[i].nr_queues = set->nr_hw_queues;
 	}
 
 	blk_mq_update_queue_map(set);
-- 
2.40.1

