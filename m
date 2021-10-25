Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98170C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C35460F6F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhJYHIP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhJYHIL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 03:08:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96555C061227;
        Mon, 25 Oct 2021 00:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1gi0qVAm+qkt2mbLEiTzlbbK6ZsI65IzSMEXe7xFrkY=; b=BgBp4T7JLtyxfyv392/W+R71A/
        cMtT0R4jqXTtGvYfadZmcQlPK1IkzZU5Lm7MOgO+LgabQnApNtAwE+q6v97lYLa33pUSBm8TQ+OW7
        K/DoT45IwBR15vqRRGALfJGnmmY74iV/vWlOI3dfaIESE5xR83lTp9vU0yvbnRNqwsx3tBHl8mDPn
        K4+lrJUjlQ6eq3d+SFpEN/MpVu/hfpCV3eVgBEiPN4UjxI5M6zCGV7K5HIpIcXOwEKvAcbtelm+0D
        lyM50QDoG9MJsdU2+zwLVepIyJS2z1W6UHF4geo/trBsLzfaUBgMjDBgWirLA0j+Me2KgBQIa+slJ
        qn2YpiiA==;
Received: from [2001:4bb8:184:6dcb:6093:467a:cccc:351c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meu3F-00FUYp-6y; Mon, 25 Oct 2021 07:05:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 10/12] block: move blk_dump_rq_flags to blk-mq.c
Date:   Mon, 25 Oct 2021 09:05:15 +0200
Message-Id: <20211025070517.1548584-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025070517.1548584-1-hch@lst.de>
References: <20211025070517.1548584-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_dump_rq_flags deals with a request, so move it to blk-mq.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 14 --------------
 block/blk-mq.c   | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5ca47d25a2ef2..9547a75e7a7aa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -217,20 +217,6 @@ void blk_print_req_error(struct request *req, blk_status_t status)
 		IOPRIO_PRIO_CLASS(req->ioprio));
 }
 
-void blk_dump_rq_flags(struct request *rq, char *msg)
-{
-	printk(KERN_INFO "%s: dev %s: flags=%llx\n", msg,
-		rq->rq_disk ? rq->rq_disk->disk_name : "?",
-		(unsigned long long) rq->cmd_flags);
-
-	printk(KERN_INFO "  sector %llu, nr/cnr %u/%u\n",
-	       (unsigned long long)blk_rq_pos(rq),
-	       blk_rq_sectors(rq), blk_rq_cur_sectors(rq));
-	printk(KERN_INFO "  bio %p, biotail %p, len %u\n",
-	       rq->bio, rq->biotail, blk_rq_bytes(rq));
-}
-EXPORT_SYMBOL(blk_dump_rq_flags);
-
 /**
  * blk_sync_queue - cancel any pending callbacks on a queue
  * @q: the queue
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7df80c4da3777..425cd134ac358 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -648,6 +648,20 @@ void blk_mq_free_plug_rqs(struct blk_plug *plug)
 	}
 }
 
+void blk_dump_rq_flags(struct request *rq, char *msg)
+{
+	printk(KERN_INFO "%s: dev %s: flags=%llx\n", msg,
+		rq->rq_disk ? rq->rq_disk->disk_name : "?",
+		(unsigned long long) rq->cmd_flags);
+
+	printk(KERN_INFO "  sector %llu, nr/cnr %u/%u\n",
+	       (unsigned long long)blk_rq_pos(rq),
+	       blk_rq_sectors(rq), blk_rq_cur_sectors(rq));
+	printk(KERN_INFO "  bio %p, biotail %p, len %u\n",
+	       rq->bio, rq->biotail, blk_rq_bytes(rq));
+}
+EXPORT_SYMBOL(blk_dump_rq_flags);
+
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, blk_status_t error)
 {
-- 
2.30.2

