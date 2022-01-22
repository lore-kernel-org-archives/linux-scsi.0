Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6123CC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiAVLMs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:12:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234157AbiAVLMr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:12:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+uWC3JQ3E8TC4lMrDyZZGJvPEZT304AfqmguiNRJ6m4=;
        b=SDG0Y/YEe4VoHevEBgigioJU8mARZ49OXQUMVExR4DSuwbQYtQo4r+KJVno8IFLseWLZvi
        LbAjPkl1UnhdrQzlnhZnSe9HJQK+txS21dv0a3dYmk4lTgj2S1RkvUo+7HgpNDhw3BOZId
        XcEpfC3TvID2NyNMtQU4B4/lfRyS2qY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-BTUij3deM8WgvB4okf_wWQ-1; Sat, 22 Jan 2022 06:12:43 -0500
X-MC-Unique: BTUij3deM8WgvB4okf_wWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1303218397A7;
        Sat, 22 Jan 2022 11:12:42 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40DE27B9DC;
        Sat, 22 Jan 2022 11:12:40 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 11/13] block: move blk_exit_queue into disk_release
Date:   Sat, 22 Jan 2022 19:10:52 +0800
Message-Id: <20220122111054.1126146-12-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There can't be FS IO in disk_release(), so move blk_exit_queue() there.

We still need to freeze queue here since request is freed after bio is
ended, meantime passthrough request relies on scheduler tags too, but
either q->q_usage_counter is in atomic mode, such as scsi, or it has
been drained already, such as most of other drivers, so the added queue
freeze is pretty fast, and RCU grace period isn't supposed to be
involved.

disk can be released before or after queue is cleaned up, and we have to
free scheduler request pool before blk_cleanup_queue returns, meantime
the request pool has to be freed before exiting the scheduler. So move
scheduler pool freeing into both the two functions.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c    |  3 +++
 block/blk-sysfs.c | 16 ----------------
 block/genhd.c     | 39 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d51b0aa2e4e4..72ae9955cf27 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3101,6 +3101,9 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	struct blk_mq_tags *drv_tags;
 	struct page *page;
 
+	if (list_empty(&tags->page_list))
+		return;
+
 	if (blk_mq_is_shared_tags(set->flags))
 		drv_tags = set->shared_tags;
 	else
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 5f14fd333182..e0f29b56e8e2 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -739,20 +739,6 @@ static void blk_free_queue_rcu(struct rcu_head *rcu_head)
 	kmem_cache_free(blk_get_queue_kmem_cache(blk_queue_has_srcu(q)), q);
 }
 
-/* Unconfigure the I/O scheduler and dissociate from the cgroup controller. */
-static void blk_exit_queue(struct request_queue *q)
-{
-	/*
-	 * Since the I/O scheduler exit code may access cgroup information,
-	 * perform I/O scheduler exit before disassociating from the block
-	 * cgroup controller.
-	 */
-	if (q->elevator) {
-		ioc_clear_queue(q);
-		elevator_exit(q);
-	}
-}
-
 /**
  * blk_release_queue - releases all allocated resources of the request_queue
  * @kobj: pointer to a kobject, whose container is a request_queue
@@ -786,8 +772,6 @@ static void blk_release_queue(struct kobject *kobj)
 		blk_stat_remove_callback(q, q->poll_cb);
 	blk_stat_free_callback(q->poll_cb);
 
-	blk_exit_queue(q);
-
 	blk_free_queue_stats(q->stats);
 	kfree(q->poll_stat);
 
diff --git a/block/genhd.c b/block/genhd.c
index a86027619683..f1aef5d13afa 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1085,11 +1085,48 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
+/* Unconfigure the I/O scheduler and dissociate from the cgroup controller. */
+static void blk_exit_queue(struct request_queue *q)
+{
+	/*
+	 * Since the I/O scheduler exit code may access cgroup information,
+	 * perform I/O scheduler exit before disassociating from the block
+	 * cgroup controller.
+	 */
+	if (q->elevator) {
+		ioc_clear_queue(q);
+
+		mutex_lock(&q->sysfs_lock);
+		blk_mq_sched_free_rqs(q);
+		elevator_exit(q);
+		mutex_unlock(&q->sysfs_lock);
+	}
+}
+
 static void disk_release_queue(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 
-	blk_mq_cancel_work_sync(q);
+	if (queue_is_mq(q)) {
+		blk_mq_cancel_work_sync(q);
+
+		/*
+		 * All FS bios have been done, however FS request may not
+		 * be freed yet since we end bio before freeing request,
+		 * meantime passthrough request replies on scheduler tags,
+		 * so queue needs to be frozen here.
+		 *
+		 * Most of drivers release disk after blk_cleanup_queue()
+		 * returns, and SCSI may release disk before calling
+		 * blk_cleanup_queue, but request queue has been in atomic
+		 * mode already, see scsi_disk_release(), so the following
+		 * queue freeze is pretty fast, and RCU grace period isn't
+		 * supposed to be involved.
+		 */
+		blk_mq_freeze_queue(q);
+		blk_exit_queue(q);
+		__blk_mq_unfreeze_queue(q, true);
+	}
 
 	/*
 	 * Remove all references to @q from the block cgroup controller before
-- 
2.31.1

