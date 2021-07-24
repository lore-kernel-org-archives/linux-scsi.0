Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9E0C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D86FE60E8F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhGXGof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbhGXGof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:44:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8981DC061575;
        Sat, 24 Jul 2021 00:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nTdPfIEbTdMMZPHTanTgc3kT6vC2LE57mN25L3fFFJ4=; b=sbernqGs7gzAjO4dlxPo1E+c6n
        WX/jpBigWG8h6Ulc/Yua1vmCa4rvlRLjwmWSY4icGjE/C/8IhVLK7FWi8x5ciE9eoHI2Wr5jCKtkQ
        2V+YOnjOa9UIC6FoPnl3I1nl4aj4ZbVn2AyufqlOws+ey2c+zscuD35Blt8pPsS+YH4igEYPvlfPd
        2kgHPMVM8An12Q5svBQQSIbRdDIpg3rjpzY2drJZbCGM23GFL2wfTQMKsYdGG3bABCVeHIYQlm9sf
        4ixgl+2VB4Ixa9k8vNswE6mWdurwLAGizQJIX0CaQbeAK/LOvhBsr1HM+qAN7uyQGnzrC3xrSqty0
        G2bhj/qg==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7C1D-00C5D7-Vt; Sat, 24 Jul 2021 07:24:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 12/24] block: add a queue_max_sectors_bytes helper
Date:   Sat, 24 Jul 2021 09:20:21 +0200
Message-Id: <20210724072033.1284840-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return the max_sectors value in bytes.  Lifted from scsi_ioctl.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c     | 13 ++-----------
 include/linux/blkdev.h |  5 +++++
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index ca7b84452d9d..c3871529e283 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -68,18 +68,9 @@ static int sg_set_timeout(struct request_queue *q, int __user *p)
 	return err;
 }
 
-static int max_sectors_bytes(struct request_queue *q)
-{
-	unsigned int max_sectors = queue_max_sectors(q);
-
-	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
-
-	return max_sectors << 9;
-}
-
 static int sg_get_reserved_size(struct request_queue *q, int __user *p)
 {
-	int val = min_t(int, q->sg_reserved_size, max_sectors_bytes(q));
+	int val = min(q->sg_reserved_size, queue_max_bytes(q));
 
 	return put_user(val, p);
 }
@@ -94,7 +85,7 @@ static int sg_set_reserved_size(struct request_queue *q, int __user *p)
 	if (size < 0)
 		return -EINVAL;
 
-	q->sg_reserved_size = min(size, max_sectors_bytes(q));
+	q->sg_reserved_size = min_t(unsigned int, size, queue_max_bytes(q));
 	return 0;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e2b972a85012..9971796819ef 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1373,6 +1373,11 @@ static inline unsigned int queue_max_sectors(const struct request_queue *q)
 	return q->limits.max_sectors;
 }
 
+static inline unsigned int queue_max_bytes(struct request_queue *q)
+{
+	return min_t(unsigned int, queue_max_sectors(q), INT_MAX >> 9) << 9;
+}
+
 static inline unsigned int queue_max_hw_sectors(const struct request_queue *q)
 {
 	return q->limits.max_hw_sectors;
-- 
2.30.2

