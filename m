Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EC0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiBVOQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbiBVOQH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:16:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BA9160FC1;
        Tue, 22 Feb 2022 06:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/oZms4Ueduq1vWse5YhN9vwTDn8y1v6JN8SEYnWuMV8=; b=f2czph3An+CXnxDjTVH+TsaSIP
        gfqWTPMjFt3b9YNGrM12/JKCe8kXE2XQou06LNYProG9oeQN7VLiAbsZdtpCrAoAtvS0WiM1EhPzN
        NVEIAOIuJUZ7w8NdusKcKh1pDaZIqraEG1ARVE340ptyiuszJAod3yccoML+0ejP6o/LtxPN2fe2F
        0YJPX6mcOmqDnCg0jZhFMPTAA94LE15WldzaUyh2YjAoyN3lw/B4qSiRFxCjf04Y9NeLQRjSuu0bB
        jzkbyjeCw0U3HOgqCnT7cH2JIU7Vb/g3wW6Be1RUIZrpNjMHJuvlWZdU4qHg+LaIh5ezP8oaN9TEi
        snrZdJnQ==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVwr-009qSn-8n; Tue, 22 Feb 2022 14:15:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 12/12] block: move rq_qos_exit() into disk_release()
Date:   Tue, 22 Feb 2022 15:14:50 +0100
Message-Id: <20220222141450.591193-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222141450.591193-1-hch@lst.de>
References: <20220222141450.591193-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

There can't be FS IO in disk_release(), so it is safe to move rq_qos_exit()
there.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/genhd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 40edff4331758..33d61bc10addc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -627,7 +627,6 @@ void del_gendisk(struct gendisk *disk)
 
 	blk_mq_freeze_queue_wait(q);
 
-	rq_qos_exit(q);
 	blk_sync_queue(q);
 	blk_flush_integrity();
 	/*
@@ -1114,7 +1113,7 @@ static void blk_mq_release_queue(struct request_queue *q)
 		elevator_exit(q);
 		mutex_unlock(&q->sysfs_lock);
 	}
-
+	rq_qos_exit(q);
 	__blk_mq_unfreeze_queue(q, true);
 }
 
-- 
2.30.2

