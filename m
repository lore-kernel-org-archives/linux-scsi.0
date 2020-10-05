Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE5BC4727D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 390552064C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m+y1Adbc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgJEIlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIlq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98503C0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=j2ulpXvRV7rOIE5hH+Ev1iO0S//3dvCeaSPy6TCN+qE=; b=m+y1AdbcRZFIpN+mfD4iMPQ8K4
        PetvSQGnOYq+xhcatH31YfvXM8fUuBuM6FYKzuTFPeJsJ/BOLLerzThPMil7DGaYkxpz01nfYdUEX
        kbBqBWClqoNsFeRc/YKzbCkCnjI6fJGo/GtOERwhdZf2oOOFlyTnfwvQ6rRTWsyHcA6F3WT7dNRO9
        LSElnFbjV40xRv4CHLkBCot4AwNuf4xDp4y9lqJJ1/VuUlK/6zBe5ZtEuPCXXABHAvpqJMyxPxEpy
        HZ5FYPT741LhTH9ztNIINjR+X0cEZyPUpjwPxM10Ci0dFAuVDoqYyOyGIsKRFp1dtdI0PMX9KrwZk
        GZe31rhw==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM41-0000nJ-0V; Mon, 05 Oct 2020 08:41:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 10/10] scsi: only start the request just before dispatching
Date:   Mon,  5 Oct 2020 10:41:30 +0200
Message-Id: <20201005084130.143273-11-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has no change in behavior, but improves the accounting a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7b88d8cf975d5..f0254f913b3e3f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1548,8 +1548,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 			(struct scatterlist *)(cmd->prot_sdb + 1);
 	}
 
-	blk_mq_start_request(req);
-
 	/*
 	 * Special handling for passthrough commands, which don't go to the ULP
 	 * at all:
@@ -1649,7 +1647,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		req->rq_flags |= RQF_DONTPREP;
 	} else {
 		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
-		blk_mq_start_request(req);
 	}
 
 	cmd->flags &= SCMD_PRESERVED_FLAGS;
@@ -1662,6 +1659,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->scsi_done = scsi_mq_done;
 
+	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
-- 
2.28.0

