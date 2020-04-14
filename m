Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F54C3815B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A4B206B6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X0Bk9CN4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406855AbgDNHnH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 03:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406817AbgDNHmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 03:42:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBBAC0A3BDC;
        Tue, 14 Apr 2020 00:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Yiy8HJ7iOwaoJyA/zpGe+vmz7/rFgb15yfB26Pd2AAk=; b=X0Bk9CN4NH773w+2a78oEd4rpM
        +SL28rISDg+cfceSGsopIatlo+81L/abpNwJFwf9YrLCSNGEzEub+xkHzeVD+UDVDn8eLlUsUSBrj
        yVSIZ5VNqA3oA71Owh6jvyttZtNpF8yQjQgAhLvtAiRe2rYNCaXTryqxGrfu+ejtKWAoy0q5Of2c4
        hDp5gXxZ8nspHvoxjVwAzbHo4Mbrw2UXXct68Y6fPXJ+8asYsWLdrYKYlDN//PKOT5V18iEoI2WA0
        IrXK8UoGAFxi4yBG6kShibj4MTEtQMCEIJYli7xeGBpflqG/LFN5p+zxkZGegbCwkid4XVyvgzaLq
        jO47Xg3Q==;
Received: from [2001:4bb8:180:384b:4c21:af7:dd95:e552] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOGDM-00079P-Az; Tue, 14 Apr 2020 07:42:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 3/5] scsi: merge scsi_init_sgtable into scsi_init_io
Date:   Tue, 14 Apr 2020 09:42:23 +0200
Message-Id: <20200414074225.332324-4-hch@lst.de>
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

scsi_init_io is the only caller of scsi_init_sgtable.  Merge the two
function to make upcoming changes a little easier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 46 ++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 47835c4b4ee0..274dd3ffa66b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -978,30 +978,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		scsi_io_completion_action(cmd, result);
 }
 
-static blk_status_t scsi_init_sgtable(struct request *req,
-		struct scsi_data_buffer *sdb)
-{
-	int count;
-
-	/*
-	 * If sg table allocation fails, requeue request later.
-	 */
-	if (unlikely(sg_alloc_table_chained(&sdb->table,
-			blk_rq_nr_phys_segments(req), sdb->table.sgl,
-			SCSI_INLINE_SG_CNT)))
-		return BLK_STS_RESOURCE;
-
-	/* 
-	 * Next, walk the list, and fill in the addresses and sizes of
-	 * each segment.
-	 */
-	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
-	BUG_ON(count > sdb->table.nents);
-	sdb->table.nents = count;
-	sdb->length = blk_rq_payload_bytes(req);
-	return BLK_STS_OK;
-}
-
 /*
  * Function:    scsi_init_io()
  *
@@ -1017,17 +993,31 @@ blk_status_t scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
 	blk_status_t ret;
+	int count;
 
 	if (WARN_ON_ONCE(!blk_rq_nr_phys_segments(rq)))
 		return BLK_STS_IOERR;
 
-	ret = scsi_init_sgtable(rq, &cmd->sdb);
-	if (ret)
-		return ret;
+	/*
+	 * If sg table allocation fails, requeue request later.
+	 */
+	if (unlikely(sg_alloc_table_chained(&cmd->sdb.table,
+			blk_rq_nr_phys_segments(rq), cmd->sdb.table.sgl,
+			SCSI_INLINE_SG_CNT)))
+		return BLK_STS_RESOURCE;
+
+	/*
+	 * Next, walk the list, and fill in the addresses and sizes of
+	 * each segment.
+	 */
+	count = blk_rq_map_sg(rq->q, rq, cmd->sdb.table.sgl);
+	BUG_ON(count > cmd->sdb.table.nents);
+	cmd->sdb.table.nents = count;
+	cmd->sdb.length = blk_rq_payload_bytes(rq);
 
 	if (blk_integrity_rq(rq)) {
 		struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
-		int ivecs, count;
+		int ivecs;
 
 		if (WARN_ON_ONCE(!prot_sdb)) {
 			/*
-- 
2.25.1

