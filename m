Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E822C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbiBVOQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiBVOQG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:16:06 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5560C16042F;
        Tue, 22 Feb 2022 06:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zhzu44foxAoMY/9Zruev6wh1VGPwTUQHrNtzGpuv0YU=; b=SQswsD6iWVmDKcjrjQwnjpx8ne
        eeE0ik4H9Ibmr0ayfFK12cRyj4kLQhmQVHEfPsoMhcanvQqLX1N0r1fi0qNNg2QFMyZa5affWm2WE
        T8/INXnVasdIZTysZng2lRjpSPQ2MsVJUjUfXoDakHXhbFeFOX9ufor+xMXyqp/xEd5aMNkIoERUf
        ZIqInXsPIJ7aa/44yNhRYzKnTf33Xb0L5haaZ909lLwirrQcOW1RcnNeAlrXXxvijxqfLTJCJSYSv
        cBKYBRhUAo/NaHeBGTiDucxQUpeX8v5tttmKygn1FeNqnWJlz50GS+afKelOiawiKvzz+hacyKOV0
        r0RHMhBg==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVwo-009qPs-IE; Tue, 22 Feb 2022 14:15:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 11/12] block: do more work in elevator_exit
Date:   Tue, 22 Feb 2022 15:14:49 +0100
Message-Id: <20220222141450.591193-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222141450.591193-1-hch@lst.de>
References: <20220222141450.591193-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the calls to ioc_clear_queue and blk_mq_sched_free_rqs into
elevator_exit.  Except for one call where we know we can't have io_cq
structures yet these always go together, and that extra call in an
error path is harmless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/elevator.c | 7 +++----
 block/genhd.c    | 3 ---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 6847ab6e7aa50..4664cae50da86 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -192,6 +192,9 @@ void elevator_exit(struct request_queue *q)
 {
 	struct elevator_queue *e = q->elevator;
 
+	ioc_clear_queue(q);
+	blk_mq_sched_free_rqs(q);
+
 	mutex_lock(&e->sysfs_lock);
 	blk_mq_exit_sched(q, e);
 	mutex_unlock(&e->sysfs_lock);
@@ -595,9 +598,6 @@ int elevator_switch_mq(struct request_queue *q,
 	if (q->elevator) {
 		if (q->elevator->registered)
 			elv_unregister_queue(q);
-
-		ioc_clear_queue(q);
-		blk_mq_sched_free_rqs(q);
 		elevator_exit(q);
 	}
 
@@ -608,7 +608,6 @@ int elevator_switch_mq(struct request_queue *q,
 	if (new_e) {
 		ret = elv_register_queue(q, true);
 		if (ret) {
-			blk_mq_sched_free_rqs(q);
 			elevator_exit(q);
 			goto out;
 		}
diff --git a/block/genhd.c b/block/genhd.c
index 40ef013382872..40edff4331758 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1110,10 +1110,7 @@ static void blk_mq_release_queue(struct request_queue *q)
 	 * cgroup controller.
 	 */
 	if (q->elevator) {
-		ioc_clear_queue(q);
-
 		mutex_lock(&q->sysfs_lock);
-		blk_mq_sched_free_rqs(q);
 		elevator_exit(q);
 		mutex_unlock(&q->sysfs_lock);
 	}
-- 
2.30.2

