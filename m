Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30017C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 17:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiB0RXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 12:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiB0RXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 12:23:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276E16148;
        Sun, 27 Feb 2022 09:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=40T2eRd6WJMwARe66Igm1SoO2XYt9YKlA2cpAQh0JX4=; b=rFmGLUdCmElostVNOug6yFj246
        UGFKl5mVTHSuDXd7WabLIGuyYAsjCnPe2U8PoVlMtEMexfRKQd+3+M4I6zr85hlFGmRj/LihesF2z
        GI6lbTNGw87OtWGMExtI7H6oAtleQRu1UYE6J6XdqaMPbUyh5jNYau0IrmgYHTKDX2P+1y0m4lYSZ
        mc5aIjGUugd/CXbBiTYIy6OFEh2TvbMpv9Cq0XnzLTN87yIt9rem0rdK33WLPq9j2bfhGceTHcmov
        B1pgNxwqpijtJrik22MT5wE48nD2+I0y6fD95EWcMwXp+pRTm1rQ2MdW1BELUHbp1ceMMfrf+iFGd
        +/ARIecw==;
Received: from 91-118-163-82.static.upcbusiness.at ([91.118.163.82] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nONFa-009s7m-Ly; Sun, 27 Feb 2022 17:22:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 14/14] block: move rq_qos_exit() into disk_release()
Date:   Sun, 27 Feb 2022 18:21:44 +0100
Message-Id: <20220227172144.508118-15-hch@lst.de>
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

There can't be FS IO in disk_release(), so it is safe to move rq_qos_exit()
there.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/genhd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5368ec88e485f..d78910ef0c893 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -629,7 +629,6 @@ void del_gendisk(struct gendisk *disk)
 	blk_mq_freeze_queue_wait(q);
 
 	blk_throtl_cancel_bios(disk->queue);
-	rq_qos_exit(q);
 	blk_sync_queue(q);
 	blk_flush_integrity();
 	/*
@@ -1121,7 +1120,7 @@ static void disk_release_mq(struct request_queue *q)
 		elevator_exit(q);
 		mutex_unlock(&q->sysfs_lock);
 	}
-
+	rq_qos_exit(q);
 	__blk_mq_unfreeze_queue(q, true);
 }
 
-- 
2.30.2

