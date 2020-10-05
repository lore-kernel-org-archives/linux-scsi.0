Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8975C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7703C2064C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aSLmtaDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJEIln (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIlm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4977C0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=qwOFgI0tHXMNltyiAq/Y0XAEt/8cpzkQJcZbBFmsZD4=; b=aSLmtaDuZmong8V4Eii25U7SCJ
        CR7femZisyaLxEvpTbANfceYBv5/k5Xx8G3w1m/kc27pUny9zNFF5JZ8CJQujpKWOg9ntEJa44KUf
        6bDcf54RgeKcpNW3szjij2sS2qCWsXLMLfLRk2Sw2/x/dLkQAXqlyqA3ogmpMBsEhGZRVdXUFA/7M
        zH8HMhOjHhQzn37qBJs+NL5XDOgUpn6NcjybWZTwhLnvc811m5CN7x9Z/5A13ZxDzKniV6S0QzkFQ
        EtPtf0j61za6LTpxI7V4nDCfWKp8mI8M+lm0Hv2y6eURaRyNpVqpBuyuyNuCC9hVR+rjk7CBjmKuu
        XIYEMmlQ==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM3x-0000ma-27; Mon, 05 Oct 2020 08:41:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 07/10] scsi: rename scsi_mq_prep_fn to scsi_prepare_cmd
Date:   Mon,  5 Oct 2020 10:41:27 +0200
Message-Id: <20201005084130.143273-8-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The old name is rather confusing now that the the legacy prep_fn is gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3940641052f90b..8420e42d618bb0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1562,7 +1562,7 @@ static unsigned int scsi_mq_inline_sgl_size(struct Scsi_Host *shost)
 		sizeof(struct scatterlist);
 }
 
-static blk_status_t scsi_mq_prep_fn(struct request *req)
+static blk_status_t scsi_prepare_cmd(struct request *req)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	struct scsi_device *sdev = req->q->queuedata;
@@ -1665,7 +1665,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		goto out_dec_target_busy;
 
 	if (!(req->rq_flags & RQF_DONTPREP)) {
-		ret = scsi_mq_prep_fn(req);
+		ret = scsi_prepare_cmd(req);
 		if (ret != BLK_STS_OK)
 			goto out_dec_host_busy;
 		req->rq_flags |= RQF_DONTPREP;
-- 
2.28.0

