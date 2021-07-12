Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE893C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F218610CB
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhGLF5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbhGLF5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:57:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A37C0613DD;
        Sun, 11 Jul 2021 22:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HlcUFEIVbEE+0Mc9Xe9q8VxtXH0SrZnAvqCb53WYPFI=; b=BlG97w4wagxCYjR5kYFZdQgc46
        mFFyOot5tVj6Q6Rr/XBcJ33MHT0ZMI3gkhIoVKtpm5Lve8FypCyf0P42k4IScWDS5SzKlbzWRnpUd
        a/M8C/ZRpHzuP/E74JirDRwX/vKH9gEa+nw7FgeYgeuZ2yACgaqySbwBcB7GmFbHWujmjszzcqOqr
        aZqXgcPF5/nio6bWV5UGZLxbUMOMc7c7b3Di/seQemzHxivUBLMisR+Avmsd9DPKMuFjPl1+u4poK
        VDp1+K9yo7glcii7yCdzjANDyN8SEMF8+3P8bhQ7cIsWji0gYStPxtQIo4rEiR7YKGhwte0gcUsnI
        z4U0pvsw==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2osj-00GvIz-Py; Mon, 12 Jul 2021 05:53:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 12/24] block: add a queue_max_sectors_bytes helper
Date:   Mon, 12 Jul 2021 07:48:04 +0200
Message-Id: <20210712054816.4147559-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
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
index ca7b84452d9d..b46a04a40db4 100644
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
+	int val = min_t(int, q->sg_reserved_size, queue_max_sectors_bytes(q));
 
 	return put_user(val, p);
 }
@@ -94,7 +85,7 @@ static int sg_set_reserved_size(struct request_queue *q, int __user *p)
 	if (size < 0)
 		return -EINVAL;
 
-	q->sg_reserved_size = min(size, max_sectors_bytes(q));
+	q->sg_reserved_size = min(size, queue_max_sectors_bytes(q));
 	return 0;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e2b972a85012..c983cd8ecf98 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1373,6 +1373,11 @@ static inline unsigned int queue_max_sectors(const struct request_queue *q)
 	return q->limits.max_sectors;
 }
 
+static inline int queue_max_sectors_bytes(struct request_queue *q)
+{
+	return min_t(unsigned int, queue_max_sectors(q), INT_MAX >> 9) << 9;
+}
+
 static inline unsigned int queue_max_hw_sectors(const struct request_queue *q)
 {
 	return q->limits.max_hw_sectors;
-- 
2.30.2

