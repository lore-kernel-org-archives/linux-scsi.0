Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DF3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 05:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiCHFxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 00:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343956AbiCHFxg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 00:53:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E365F96;
        Mon,  7 Mar 2022 21:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=KZb1inv74NTrTRQmzFEzSuJr4DVlkAB47aKNlYQ78Qs=; b=2QhWyG44aH0uGRkcMJ5tsUeJoB
        QCasa2Z8e2o9LG9tpzmkENWsff327eZUt7tE1p5ltfoL0dxtqNOI1FyzhVRSRYQlGX9yG1US1uy2s
        zkRazfaCwyLgisBD1cdXnbrRQqr/pThnedaRQt9m4JPfL538VQpsWJkQczJeZx7b0mKWbCvSdA+Z9
        AxXJFl6XzFM6EPY64lqZr29rExjg7fuLSUV5xOL6f4ZNvbK9TwPWABNXLCHQRMveAnZ0NWggOdwco
        tYmoNKLgATIByKZgU5Wgpwj5Ze5Cd+Ee3ZGidoVpS9WtR8vQgPgNI4VBsIazt2KoMwPFk/Ja2camM
        zKC/KQCA==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRSlp-002isb-Jr; Tue, 08 Mar 2022 05:52:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 11/14] block: move q_usage_counter release into blk_queue_release
Date:   Tue,  8 Mar 2022 06:51:57 +0100
Message-Id: <20220308055200.735835-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220308055200.735835-1-hch@lst.de>
References: <20220308055200.735835-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

After blk_cleanup_queue() returns, disk may not be released yet, so
probably bio may still be submitted and ->q_usage_counter may be
touched, so far this way seems safe, but not good from API's viewpoint.

Move the release q_usage_counter into blk_queue_release().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c  | 2 --
 block/blk-sysfs.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3fa2f08d3750b..a97918d107a01 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -342,8 +342,6 @@ void blk_cleanup_queue(struct request_queue *q)
 		blk_mq_sched_free_rqs(q);
 	mutex_unlock(&q->sysfs_lock);
 
-	percpu_ref_exit(&q->q_usage_counter);
-
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 220085109d7f0..af5a6d86073f1 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -780,6 +780,8 @@ static void blk_release_queue(struct kobject *kobj)
 
 	might_sleep();
 
+	percpu_ref_exit(&q->q_usage_counter);
+
 	if (q->poll_stat)
 		blk_stat_remove_callback(q, q->poll_cb);
 	blk_stat_free_callback(q->poll_cb);
-- 
2.30.2

