Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D405AC11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B950561405
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhGBPLO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 11:11:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232171AbhGBPLO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 11:11:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625238521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjnTyKQduxkSckGYa3hOK0cjgWLepuCwX86Qpy9cFnY=;
        b=RCnsKgHHzSWGL3Ns+H0EQDIQXM3pli8CNWIRageFrS9P40FFKof9CD+UElxUJO3LKA1kr4
        tJwMISsYrKIh4mVZFpqVp4BO5m21WLDkmtLfRnx8zHbqP6UtelHFLL53vgMNqa2wnHRS8B
        /5+DTsP99pi7tn7yezRuG+6CWRBqP4U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-cSv2aTFnOuSdCDpeOf_r2w-1; Fri, 02 Jul 2021 11:08:40 -0400
X-MC-Unique: cSv2aTFnOuSdCDpeOf_r2w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A584802C89;
        Fri,  2 Jul 2021 15:08:38 +0000 (UTC)
Received: from localhost (ovpn-12-40.pek2.redhat.com [10.72.12.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C26671001281;
        Fri,  2 Jul 2021 15:08:33 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 6/6] blk-mq: don't deactivate hctx if managed irq isn't used
Date:   Fri,  2 Jul 2021 23:05:55 +0800
Message-Id: <20210702150555.2401722-7-ming.lei@redhat.com>
In-Reply-To: <20210702150555.2401722-1-ming.lei@redhat.com>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No need to deactivate one hctx if managed irq isn't used because
non-managed irq can be migrated to online cpus.

So we don't need to register cpu hotplug handler for
CPUHP_AP_BLK_MQ_ONLINE if managed irq isn't used.

Given BLK_MQ_F_MANAGED_IRQ is more generic and straightforward, it covers
!BLK_MQ_F_STACKING perfectly because managed irq is only used in
underlying controller, so remove BLK_MQ_F_STACKING.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-debugfs.c | 1 -
 block/blk-mq.c         | 4 ++--
 drivers/block/loop.c   | 2 +-
 drivers/md/dm-rq.c     | 2 +-
 include/linux/blk-mq.h | 5 -----
 5 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 17f57af3a4d6..3641a16c2910 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -245,7 +245,6 @@ static const char *const hctx_flag_name[] = {
 	HCTX_FLAG_NAME(TAG_QUEUE_SHARED),
 	HCTX_FLAG_NAME(BLOCKING),
 	HCTX_FLAG_NAME(NO_SCHED),
-	HCTX_FLAG_NAME(STACKING),
 	HCTX_FLAG_NAME(TAG_HCTX_SHARED),
 	HCTX_FLAG_NAME(MANAGED_IRQ),
 };
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1d45d2922ca7..e672ebd93342 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2636,7 +2636,7 @@ static int blk_mq_hctx_notify_dead(unsigned int cpu, struct hlist_node *node)
 
 static void blk_mq_remove_cpuhp(struct blk_mq_hw_ctx *hctx)
 {
-	if (!(hctx->flags & BLK_MQ_F_STACKING))
+	if (hctx->flags & BLK_MQ_F_MANAGED_IRQ)
 		cpuhp_state_remove_instance_nocalls(CPUHP_AP_BLK_MQ_ONLINE,
 						    &hctx->cpuhp_online);
 	cpuhp_state_remove_instance_nocalls(CPUHP_BLK_MQ_DEAD,
@@ -2731,7 +2731,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
 {
 	hctx->queue_num = hctx_idx;
 
-	if (!(hctx->flags & BLK_MQ_F_STACKING))
+	if (hctx->flags & BLK_MQ_F_MANAGED_IRQ)
 		cpuhp_state_add_instance_nocalls(CPUHP_AP_BLK_MQ_ONLINE,
 				&hctx->cpuhp_online);
 	cpuhp_state_add_instance_nocalls(CPUHP_BLK_MQ_DEAD, &hctx->cpuhp_dead);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cc0e8c39a48b..02509bc54242 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2268,7 +2268,7 @@ static int loop_add(struct loop_device **l, int i)
 	lo->tag_set.queue_depth = 128;
 	lo->tag_set.numa_node = NUMA_NO_NODE;
 	lo->tag_set.cmd_size = sizeof(struct loop_cmd);
-	lo->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_STACKING;
+	lo->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	lo->tag_set.driver_data = lo;
 
 	err = blk_mq_alloc_tag_set(&lo->tag_set);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 0dbd48cbdff9..294d4858c067 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -540,7 +540,7 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	md->tag_set->ops = &dm_mq_ops;
 	md->tag_set->queue_depth = dm_get_blk_mq_queue_depth();
 	md->tag_set->numa_node = md->numa_node_id;
-	md->tag_set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_STACKING;
+	md->tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
 	md->tag_set->nr_hw_queues = dm_get_blk_mq_nr_hw_queues();
 	md->tag_set->driver_data = md;
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 62fc0393cc3a..d75ab9fd64fc 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -397,11 +397,6 @@ struct blk_mq_ops {
 enum {
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_TAG_QUEUE_SHARED = 1 << 1,
-	/*
-	 * Set when this device requires underlying blk-mq device for
-	 * completing IO:
-	 */
-	BLK_MQ_F_STACKING	= 1 << 2,
 	BLK_MQ_F_TAG_HCTX_SHARED = 1 << 3,
 	BLK_MQ_F_MANAGED_IRQ	= 1 << 4,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
-- 
2.31.1

