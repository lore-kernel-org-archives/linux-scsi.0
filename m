Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2DBC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 05:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344355AbiCHFyA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 00:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344180AbiCHFxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 00:53:42 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FA7134;
        Mon,  7 Mar 2022 21:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kr2Ma9+jMQ/2zrqLJVpq3QKcmngw6kqE4xgFwcP/IeM=; b=WXVDpWY6CUoqmn/t0JO0ILrNLY
        Ejs8nEasaFf3yiXIQpetcSMplBG/jBL0OWyXmFUIBRknb/jJmt2u8DZq6GfJ+jXkgvXmuGY7iNzQ5
        or+3MRYULofffkzcUXaY4SP0Tj1mnX8YA+MAaQJVxFYzyZxXaDwtHdy1gjM7u69MRXwSygeUSXH73
        Nug1kS+RQ6FX5hcJjRLZSNlAi5dgWoOK4vsz5kXz5ds/8NA0QhPqi5JEHTRQFdcHJsAMJs3DwoHoC
        +vi6Cb/06BlAWtjFASTxWiwGcYqVnzCu7CnyABOtvaPqlZmx6Nr4Xt6+k/fpIJycLBcvOvAiFbyvP
        n69ph8vg==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRSlu-002iua-Rs; Tue, 08 Mar 2022 05:52:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 13/14] block: do more work in elevator_exit
Date:   Tue,  8 Mar 2022 06:51:59 +0100
Message-Id: <20220308055200.735835-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220308055200.735835-1-hch@lst.de>
References: <20220308055200.735835-1-hch@lst.de>
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

