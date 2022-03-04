Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D68C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 16:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbiCDQFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 11:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240578AbiCDQFK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 11:05:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBAF1C6EF2;
        Fri,  4 Mar 2022 08:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kr2Ma9+jMQ/2zrqLJVpq3QKcmngw6kqE4xgFwcP/IeM=; b=ITHWXpu8l5Ax5XPEUAGTIBI28V
        K7vOYhOGY3ps7d6HutUi1H3yWE7ND/PclcLQfCKRgzaCPaFINrcMHOpy2p+ZErih7db3cyg6wI8vn
        Edvl9MjZboI7ndJzkLEMx9JkHrjdQGlpkLXO80JoVkwlVpRVni8thGlL71PrMeIyNWaMYs1SDsFv9
        QhQFDSMA8GDCB69l4/5MptvVTsP7DyauLRTF88D0Hyi8gwQgTeIsqFAXl0nrRs+d6mHHHgKHJ+Ma9
        pOSOXJ5rs8iiesiFKjFgXNs4fikYu59l8GZbjOTFIDOvL5nhv3hWnppO/Sq+A1dpOBEDKoC74/yh2
        XIomeUMQ==;
Received: from [2001:4bb8:180:5296:7360:567:acd5:aaa2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQAPf-00AuBM-Tu; Fri, 04 Mar 2022 16:04:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 13/14] block: do more work in elevator_exit
Date:   Fri,  4 Mar 2022 17:03:30 +0100
Message-Id: <20220304160331.399757-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220304160331.399757-1-hch@lst.de>
References: <20220304160331.399757-1-hch@lst.de>
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
 block/elevator.c | 6 +++---
 block/genhd.c    | 3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index a842e4b8ebc66..20a4e7c7c7745 100644
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
@@ -596,8 +599,6 @@ int elevator_switch_mq(struct request_queue *q,
 
 	if (q->elevator) {
 		elv_unregister_queue(q);
-		ioc_clear_queue(q);
-		blk_mq_sched_free_rqs(q);
 		elevator_exit(q);
 	}
 
@@ -608,7 +609,6 @@ int elevator_switch_mq(struct request_queue *q,
 	if (new_e) {
 		ret = elv_register_queue(q, true);
 		if (ret) {
-			blk_mq_sched_free_rqs(q);
 			elevator_exit(q);
 			goto out;
 		}
diff --git a/block/genhd.c b/block/genhd.c
index 73705a749ea92..857e0a54da7dd 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1115,10 +1115,7 @@ static void disk_release_mq(struct request_queue *q)
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

