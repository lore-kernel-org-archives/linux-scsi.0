Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9E5C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 05:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344390AbiCHFyH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 00:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344388AbiCHFxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 00:53:42 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4524C2D;
        Mon,  7 Mar 2022 21:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3yB2XsyLKYaJ70QzihkaDUnfu7i+Z20pSW9GReQZ4mo=; b=NgbX3854/TcBPXU6tCmJXwC+8I
        ReGuzC4h+br/bV1ckqOQ5fYuI81HZLOm8GUc7NQHM5m09B7EKhOsJmzVsKMkEknlU0VCFcUJLbTJ0
        KlCYRJ4IRDD8gRNhQSu1JopKzBAjytBEy2K7ylEbLcAuSRBFw/dxJpvXV7P6ZuTfuRp/kx4pEdYQI
        qqj4u3IbzC8zkLOkNjxK4FYnCRYpicwK5PNV1PDfRQPUzHeKHKQqBwPCqzMNsjY/IZwoI3nupiUjl
        eaaFH/qhis65UEkD1C7Ug68ahqVnlmQvre9hllHc1QPOnryuJgDHKgDppn01DDZIpbHQjTMlQoiqd
        WJt27MLA==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRSlx-002ivg-DI; Tue, 08 Mar 2022 05:52:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 14/14] block: move rq_qos_exit() into disk_release()
Date:   Tue,  8 Mar 2022 06:52:00 +0100
Message-Id: <20220308055200.735835-15-hch@lst.de>
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

Keep all teardown of file system I/O related functionality in one place.
There can't be file system I/O in disk_release(), so it is safe to move
rq_qos_exit() there.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 857e0a54da7dd..56f66c6fee943 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -627,7 +627,6 @@ void del_gendisk(struct gendisk *disk)
 
 	blk_mq_freeze_queue_wait(q);
 
-	rq_qos_exit(q);
 	blk_sync_queue(q);
 	blk_flush_integrity();
 	/*
@@ -1119,7 +1118,7 @@ static void disk_release_mq(struct request_queue *q)
 		elevator_exit(q);
 		mutex_unlock(&q->sysfs_lock);
 	}
-
+	rq_qos_exit(q);
 	__blk_mq_unfreeze_queue(q, true);
 }
 
-- 
2.30.2

