Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93EEC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 07:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A946460F35
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 07:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhGaHmi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Jul 2021 03:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhGaHmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Jul 2021 03:42:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E7FC06175F;
        Sat, 31 Jul 2021 00:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=rlo3QB3I2AB7Bz2AwleEutVkwfwO0IMbz3hVgybva0w=; b=vzYN3YNjjUh9jaXpMLFTKHaAC9
        ZvXQpev6s4QxZ5L8n+eybYJ1XZwrMoQ7oT+LOZVpVmbyf9mkema7TOL+3cmNcUNJYulDa9DpJFuij
        uaeCg4k5tEemBubRrn5QizCUkiWjg37DopwKebPGqJkY+uKF//HSpFMfNik+jnCUbUXHtdxvlHU9g
        yaKpQo/mWFv/R/5lPRRF4vI7xfolXHOXvy/54vV8V8Zm/3QbXTZu4zLquV1zM5tCH2kNQoVVYU41B
        uIM3htMQS5zOP6YOyS+UnmgJh2IKk5oMwVXrKARlVx4eVRQI65GcZxQnk/WJPXxP0ED5rvSYZLkRo
        s+yZ1G1w==;
Received: from 213-225-38-220.nat.highway.a1.net ([213.225.38.220] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m9jco-001V93-4z; Sat, 31 Jul 2021 07:41:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] bsg-lib: fix commands without data transfer in bsg_transport_sg_io_fn
Date:   Sat, 31 Jul 2021 09:40:27 +0200
Message-Id: <20210731074027.1185545-3-hch@lst.de>
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

Fixes: 75ca56409e5b ("scsi: bsg: Move the whole request execution into the SCSI/transport
handlers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bsg-lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 239ebf747141..ccb98276c964 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -72,6 +72,7 @@ static int bsg_transport_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		job->bidi_bio = NULL;
 	}
 
+	ret = 0;
 	if (hdr->dout_xfer_len) {
 		ret = blk_rq_map_user(rq->q, rq, NULL, uptr64(hdr->dout_xferp),
 				hdr->dout_xfer_len, GFP_KERNEL);
-- 
2.30.2

