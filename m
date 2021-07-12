Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4EEC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C156E610A6
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhGLF6G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhGLF6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:58:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4954AC0613DD;
        Sun, 11 Jul 2021 22:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=F4G+fDWiB9RFsl1l009XKqDHQx8vaGg8A2qOsUiKMzo=; b=Hg7DZpsrKy4syd9qjB2iPlUryI
        PQcQUxprF7sX3y7Aej2F0iavPDcPXnEqBw5i3JMe4oY4WT069nr6oCOf6dezwVKBS9Fgw4Sxr8aob
        WN0g6ByV6mchXK+xav+pLjJcwEry9Ul0gTnJrEjOIwJcPGfDVueLmXMAa+9SvD1VBS3b/tpYh4uKn
        vKOWTo/LncmI4NRhAtjpUUhs/6WwPcx2h43QqaTTWwoEdhNLAi1M/nS2fyYv2PCeAXJdMJAa8pfZU
        PZPSCeHtfyw9Q+0ZIZJQ2at/k87F2/vMrhNlpoEOOM++LGsUn9P+FBKda+wOdqADINJJ147Tgegl5
        lKoChiUg==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2otu-00GvON-EC; Mon, 12 Jul 2021 05:54:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 15/24] scsi_ioctl: remove scsi_req_init
Date:   Mon, 12 Jul 2021 07:48:07 +0200
Message-Id: <20210712054816.4147559-16-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
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
index 006da3e829a2..76fbe5287876 100644
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
index c9a91a52e637..4914b01e8e59 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1082,8 +1082,13 @@ EXPORT_SYMBOL(scsi_alloc_sgtables);
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

