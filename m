Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CD9C43217
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 16:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240565AbiCDQFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 11:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240608AbiCDQFK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 11:05:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2FC1BD980;
        Fri,  4 Mar 2022 08:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qZ373vrWVSskyrYukiiLGShHHR44DA0hpvLVfZU9ACk=; b=mzC9wG3dqa+kKPAYPPADxy8z+9
        NwdCS1DErOb462RvdO63abF+BAIdqDATB2xywqjeoh0ty7r/5epg6aoShEz3mLfzQ8zcE/ZgVi+xG
        0m39JSQD0y9br0xSo6fV++XvMdBmubLrFWOzwDN/ywRJgJAM51MRY8VQaclnbjP019RuTPF3pvloN
        IT947xGeo2ismdJDJCzbrt8hDuKJo0zXWjf1Qc64PMbHCrZufQ5IxA7ihT6WyAG91bGWzMpDD1qOr
        8xsqmKQT7BWRf7WW+bt34pOneC//yZDlb0IBUubZciMVA5YpE7Sn2dizuit3a09dJTYZvUMohcskT
        r4q5/xqA==;
Received: from [2001:4bb8:180:5296:7360:567:acd5:aaa2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQAPZ-00Au7z-4k; Fri, 04 Mar 2022 16:04:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 11/14] block: move q_usage_counter release into blk_queue_release
Date:   Fri,  4 Mar 2022 17:03:28 +0100
Message-Id: <20220304160331.399757-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220304160331.399757-1-hch@lst.de>
References: <20220304160331.399757-1-hch@lst.de>
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

