Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FEFC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D3F860E8F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhGXGt0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbhGXGtN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:49:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126D0C061575;
        Sat, 24 Jul 2021 00:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HjThuS297yDJUJjbNASILBq2yyyAt/TIA9+tfwISQ7I=; b=R8F8GZupSqE50J5Hytv5oHSKdp
        N5oGfQPjiB0HgBWfAGqtoVXqjoFKPiZeRuNa8dmnK7axob904ozmVJL4PTLsfhMkIIL50qdoorSPO
        MnUjmUzTqD6Rk6Sp3xwmFT5/zYmvcg7o7ZwtYy2S2xp1fZTwRfg32/tk7bBFMvP0rawboKtXPEFDu
        k0HHRrHrW1dmtK2SB7aP9qIn3Nau+No5sOuShF4YQT3+MCx8pCt1B8tR+H5F7heTt/6wwXCbqgHG9
        u6m7Yqv00+F6RkGHdJtFTK9ZX4xDhOpB4B7IDwJClK1UNQ/x/PkSNj68EMZkP88f34M8D5WlaMwC5
        eSgQmukA==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7C4n-00C5Nr-6x; Sat, 24 Jul 2021 07:28:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 15/24] scsi_ioctl: remove scsi_req_init
Date:   Sat, 24 Jul 2021 09:20:24 +0200
Message-Id: <20210724072033.1284840-16-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Merge scsi_req_init into its only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c          | 15 ---------------
 drivers/scsi/scsi_lib.c     |  7 ++++++-
 include/scsi/scsi_request.h |  2 --
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index b875feb8d6bd..4d214f9ac8d0 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -817,21 +817,6 @@ int scsi_cmd_ioctl(struct request_queue *q, struct gendisk *bd_disk, fmode_t mod
 }
 EXPORT_SYMBOL(scsi_cmd_ioctl);
 
-/**
- * scsi_req_init - initialize certain fields of a scsi_request structure
- * @req: Pointer to a scsi_request structure.
- * Initializes .__cmd[], .cmd, .cmd_len and .sense_len but no other members
- * of struct scsi_request.
- */
-void scsi_req_init(struct scsi_request *req)
-{
-	memset(req->__cmd, 0, sizeof(req->__cmd));
-	req->cmd = req->__cmd;
-	req->cmd_len = BLK_MAX_CDB;
-	req->sense_len = 0;
-}
-EXPORT_SYMBOL(scsi_req_init);
-
 static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7456a26aef51..77578b221a71 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1083,8 +1083,13 @@ EXPORT_SYMBOL(scsi_alloc_sgtables);
 static void scsi_initialize_rq(struct request *rq)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+	struct scsi_request *req = &cmd->req;
+
+	memset(req->__cmd, 0, sizeof(req->__cmd));
+	req->cmd = req->__cmd;
+	req->cmd_len = BLK_MAX_CDB;
+	req->sense_len = 0;
 
-	scsi_req_init(&cmd->req);
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
index b06f28c74908..9129b23e12bc 100644
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -28,6 +28,4 @@ static inline void scsi_req_free_cmd(struct scsi_request *req)
 		kfree(req->cmd);
 }
 
-void scsi_req_init(struct scsi_request *req);
-
 #endif /* _SCSI_SCSI_REQUEST_H */
-- 
2.30.2

