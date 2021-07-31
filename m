Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA497C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 07:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FDC160EE6
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 07:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhGaHmG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Jul 2021 03:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhGaHmE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Jul 2021 03:42:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909EEC06175F;
        Sat, 31 Jul 2021 00:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=D7rbFE7+HD8Fryt4KhfgaSvF+RBBhMwtLEMRycxPZjk=; b=JBnZUHwE3uUWh8d/uSXZ0vx1iZ
        xI/iMPRUZyl9/PLdIe0nGdLk449bePBlrc4yrqNtUWAQ1zuxlQMcOwDKsAO1LLgncOFAkEAkBeMlC
        oSc37BmouE/Mx+Irz0/uSZC7y9k3F7hfO8f2gaecyHgI4KUpUFMV6UsActLXhWKt5a5zfnHyz1BxT
        xWPWQV8q5L8/2sQip3MbZPv3V895gDkmhN0EMc70QMnu7WHWWb81GKo9B834th9Sf2/EJbYwc2Bkv
        ouJq3UKiMnUIQ0BIT60JMP8+Frg2TB4doEkCjGsz+I/sZUoIf+qYv5Qbihq8zLMPJytcKw/aFkFM3
        VEd7lbsQ==;
Received: from 213-225-38-220.nat.highway.a1.net ([213.225.38.220] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m9jcI-001V7U-Dr; Sat, 31 Jul 2021 07:41:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] scsi: bsg: fix commands without data transfer in scsi_bsg_sg_io_fn
Date:   Sat, 31 Jul 2021 09:40:26 +0200
Message-Id: <20210731074027.1185545-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210731074027.1185545-1-hch@lst.de>
References: <20210731074027.1185545-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set ret to 0 after the initial permission checks to avoid leaking
-EPERM for commands without data transfer.

Fixes: 75ca56409e5b ("scsi: bsg: Move the whole request execution into the SCSI/transport handlers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index d13a67b82429..81c3853a2a80 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -47,6 +47,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	if (!scsi_cmd_allowed(sreq->cmd, mode))
 		goto out_free_cmd;
 
+	ret = 0;
 	if (hdr->dout_xfer_len) {
 		ret = blk_rq_map_user(rq->q, rq, NULL, uptr64(hdr->dout_xferp),
 				hdr->dout_xfer_len, GFP_KERNEL);
-- 
2.30.2

