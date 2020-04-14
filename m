Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FB2C2BB85
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0AD206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jqPt05Z8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406834AbgDNHmr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 03:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406823AbgDNHmn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 03:42:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D32C0A3BE2;
        Tue, 14 Apr 2020 00:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ntNsFq7cgy8U6I7hRIN4P7odFKtpBsZoSKP2UJOeTXE=; b=jqPt05Z84OoY5cs9gziz5W7lY5
        P949RxM7wbvW2DN6icQ3b6cW4fUzOhW3PwcOAvCvNlcqVTHYKziXFTyiU3hpA0tO7hjR+yjs+jHtD
        3Bw/dBGeQ5fst719zqxrq4301BA0sslpJ0JZ6LG8/VZldnp73ttnO4AbMbzcJOy+5JyzpPuR2wR0A
        kFnW4Bczq4PuDJH57T0/vb+DVPIBhVvJd9ZJnGHjzIYmPQX6ljjtKNMZt1rnRevbjO/VdWYYUryMO
        crkZ/r7sjoo/cTQmDPD0Z25/AV+glK7xplXsmUM3OXiOSX+6NkoUb208fC12cnTwXCllF8zLA+Xmj
        3wFEDfCg==;
Received: from [2001:4bb8:180:384b:4c21:af7:dd95:e552] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOGDS-0007Bm-5g; Tue, 14 Apr 2020 07:42:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 5/5] block: move dma_pad handling from blk_rq_map_sg into the callers
Date:   Tue, 14 Apr 2020 09:42:25 +0200
Message-Id: <20200414074225.332324-6-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414074225.332324-1-hch@lst.de>
References: <20200414074225.332324-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are only two callers of blk_rq_map_sg/__blk_rq_map_sg that set
the dma_pad value in the queue.  Move the handling into those callers
instead of burdening the common code, and move the ->extra_len field
from struct request to struct scsi_cmnd.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c          |  1 -
 block/blk-merge.c         |  8 --------
 block/blk-mq.c            |  1 -
 drivers/ata/libata-scsi.c |  2 +-
 drivers/ide/ide-io.c      |  7 +++++--
 drivers/scsi/scsi_lib.c   | 10 +++++++++-
 include/linux/blkdev.h    |  2 --
 include/scsi/scsi_cmnd.h  |  1 +
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7e4a1da0715e..311596d5dbc4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1638,7 +1638,6 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
 	rq->ioprio = rq_src->ioprio;
-	rq->extra_len = rq_src->extra_len;
 
 	return 0;
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 25f5a5e00ee6..c49eb3bdd0be 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -531,14 +531,6 @@ int __blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	else if (rq->bio)
 		nsegs = __blk_bios_map_sg(q, rq->bio, sglist, last_sg);
 
-	if (blk_rq_bytes(rq) && (blk_rq_bytes(rq) & q->dma_pad_mask)) {
-		unsigned int pad_len =
-			(q->dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
-
-		(*last_sg)->length += pad_len;
-		rq->extra_len += pad_len;
-	}
-
 	if (*last_sg)
 		sg_mark_end(*last_sg);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 28ad7e1e850b..983773214ee3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -318,7 +318,6 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->nr_integrity_segments = 0;
 #endif
 	/* tag was already set */
-	rq->extra_len = 0;
 	WRITE_ONCE(rq->deadline, 0);
 
 	rq->timeout = 0;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index feb13b8f93d7..435781a16875 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -649,7 +649,7 @@ static void ata_qc_set_pc_nbytes(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
 
-	qc->extrabytes = scmd->request->extra_len;
+	qc->extrabytes = scmd->extra_len;
 	qc->nbytes = scsi_bufflen(scmd) + qc->extrabytes;
 }
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index b137f27a34d5..c31f1d2b3b07 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -233,10 +233,13 @@ static ide_startstop_t do_special(ide_drive_t *drive)
 void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *sg = hwif->sg_table, *last_sg = NULL;
 	struct request *rq = cmd->rq;
 
-	cmd->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
+	cmd->sg_nents = __blk_rq_map_sg(drive->queue, rq, sg, &last_sg);
+	if (blk_rq_bytes(rq) && (blk_rq_bytes(rq) & rq->q->dma_pad_mask))
+		last_sg->length +=
+			(rq->q->dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
 }
 EXPORT_SYMBOL_GPL(ide_map_sg);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b561c6dbda6b..8396b9f56dc7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1030,13 +1030,21 @@ blk_status_t scsi_init_io(struct scsi_cmnd *cmd)
 	 */
 	count = __blk_rq_map_sg(rq->q, rq, cmd->sdb.table.sgl, &last_sg);
 
+	if (blk_rq_bytes(rq) & rq->q->dma_pad_mask) {
+		unsigned int pad_len =
+			(rq->q->dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
+
+		last_sg->length += pad_len;
+		cmd->extra_len += pad_len;
+	}
+
 	if (need_drain) {
 		sg_unmark_end(last_sg);
 		last_sg = sg_next(last_sg);
 		sg_set_buf(last_sg, sdev->dma_drain_buf, sdev->dma_drain_len);
 		sg_mark_end(last_sg);
 
-		rq->extra_len += sdev->dma_drain_len;
+		cmd->extra_len += sdev->dma_drain_len;
 		count++;
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8e4726bce498..f00bd4042295 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -224,8 +224,6 @@ struct request {
 	unsigned short write_hint;
 	unsigned short ioprio;
 
-	unsigned int extra_len;	/* length of alignment and padding */
-
 	enum mq_rq_state state;
 	refcount_t ref;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 80ac89e47b47..f93c0b800790 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -142,6 +142,7 @@ struct scsi_cmnd {
 	unsigned long state;	/* Command completion state */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
+	unsigned int extra_len;	/* length of alignment and padding */
 };
 
 /*
-- 
2.25.1

