Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D7AC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 17:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiB0RXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 12:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiB0RXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 12:23:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B395B1E3;
        Sun, 27 Feb 2022 09:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kUzycC9K9fsPTd/sxe/S3aq/1ZdpTJdGU3r+NLtSIt0=; b=bqK8sjCVFhWAD1kEOW3oJkm9Bo
        v0bz0VL3vSrYkEcIlokCghHD63ngZktTNfOfMIT3xK40PLGnoMLVvgWiggAvQcALcC2qJPQsTtKPL
        q3YhKWxdy78zcPMc4VKI6mlNENxG+/R6HPoBKhs3NtUcfWKLm1/aR6si00zOiLxHl7967UNYzobyX
        B/sk092FhdE26R7r9Tl1ptwrAl5W8uIC2Gzr04FQ1NWZzcrTl4+QGT93WYxE61D7PeLMt/SY+1WOo
        LRMiueLvURPlocQJcN6w215PDWHuJB4Cv6VjbBlSPQqdW8hcGcL2Bdae0n9pDgzMEMkEncluMQxMd
        m15DlTdA==;
Received: from 91-118-163-82.static.upcbusiness.at ([91.118.163.82] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nONFS-009s54-CU; Sun, 27 Feb 2022 17:22:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 11/14] block: move q_usage_counter release into blk_queue_release
Date:   Sun, 27 Feb 2022 18:21:41 +0100
Message-Id: <20220227172144.508118-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220227172144.508118-1-hch@lst.de>
References: <20220227172144.508118-1-hch@lst.de>
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
index b2f2c65774812..a8c59913dd78d 100644
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
index 5f723d2ff8948..4ea22169b5186 100644
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

