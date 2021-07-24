Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661EEC4320A
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4850960E8F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhGXGqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbhGXGqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:46:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B353C061575;
        Sat, 24 Jul 2021 00:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=H9uzoU2ATNZydqZDeqebhb7eMfI7+M6vHRCWP/kLgUY=; b=Nn2BHAvZ5ABLCqbio18GpLIsh4
        RSVZpaBkZuRw36HRplGoyfmJnobQ1+Gq4ifeXOC44l+o8iEXYBT8g4tBkZkxsRLjs+G9UcRzZR+Dx
        VxT9M5UiwFxtd8G3ZG0+CBqXJKZD+YjzDwTISZNE5Zv4KrChxHdYkJ0PgVd9swAVaODpz3qCiN+hY
        EahSuk4Kpk7REOjWEKMjI/BKcxtFccwd7c0AgdEHTO91SJXyDHyvQHXXWoQVpOBXJRpbqD/yo+XwU
        7obcnxyIfoYVJnB27gz8FqJ89GRIz5N4+Liub00PVzzp07T2k3dGkYmfHX9stx5LDcIfF7kDyp60s
        v/GJem3Q==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7C1e-00C5Es-GX; Sat, 24 Jul 2021 07:24:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 13/24] bsg: decouple from scsi_cmd_ioctl
Date:   Sat, 24 Jul 2021 09:20:22 +0200
Message-Id: <20210724072033.1284840-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Decouple bsg from scsi_cmd_ioctl.  This requires a small amount of
code duplication, but will allow moving ll SCSI ioctl handling into
SCSI midlayer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bsg.c        | 24 ++++++++++++++++++++++--
 block/scsi_ioctl.c | 16 ----------------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 79b42c5cafeb..38dd434636d8 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -351,7 +351,10 @@ static int bsg_set_command_q(struct bsg_device *bd, int __user *uarg)
 static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct bsg_device *bd = file->private_data;
+	struct request_queue *q = bd->queue;
 	void __user *uarg = (void __user *) arg;
+	int __user *intp = uarg;
+	int val;
 
 	switch (cmd) {
 	/*
@@ -366,16 +369,33 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	 * SCSI/sg ioctls
 	 */
 	case SG_GET_VERSION_NUM:
+		return put_user(30527, intp);
 	case SCSI_IOCTL_GET_IDLUN:
+		return put_user(0, intp);
 	case SCSI_IOCTL_GET_BUS_NUMBER:
+		return put_user(0, intp);
 	case SG_SET_TIMEOUT:
+		if (get_user(val, intp))
+			return -EFAULT;
+		q->sg_timeout = clock_t_to_jiffies(val);
+		return 0;
 	case SG_GET_TIMEOUT:
+		return jiffies_to_clock_t(q->sg_timeout);
 	case SG_GET_RESERVED_SIZE:
+		return put_user(min(q->sg_reserved_size, queue_max_bytes(q)),
+			 	intp);
 	case SG_SET_RESERVED_SIZE:
+		if (get_user(val, intp))
+			return -EFAULT;
+		if (val < 0)
+			return -EINVAL;
+		q->sg_reserved_size =
+			min_t(unsigned int, val, queue_max_bytes(q));
+		return 0;
 	case SG_EMULATED_HOST:
-		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);
+		return put_user(1, intp);
 	case SG_IO:
-		return bsg_sg_io(bd->queue, file->f_mode, uarg);
+		return bsg_sg_io(q, file->f_mode, uarg);
 	case SCSI_IOCTL_SEND_COMMAND:
 		pr_warn_ratelimited("%s: calling unsupported SCSI_IOCTL_SEND_COMMAND\n",
 				current->comm);
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index c3871529e283..b875feb8d6bd 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -43,16 +43,6 @@ static int sg_get_version(int __user *p)
 	return put_user(sg_version_num, p);
 }
 
-static int scsi_get_idlun(struct request_queue *q, int __user *p)
-{
-	return put_user(0, p);
-}
-
-static int scsi_get_bus(struct request_queue *q, int __user *p)
-{
-	return put_user(0, p);
-}
-
 static int sg_get_timeout(struct request_queue *q)
 {
 	return jiffies_to_clock_t(q->sg_timeout);
@@ -769,12 +759,6 @@ int scsi_cmd_ioctl(struct request_queue *q, struct gendisk *bd_disk, fmode_t mod
 		case SG_GET_VERSION_NUM:
 			err = sg_get_version(arg);
 			break;
-		case SCSI_IOCTL_GET_IDLUN:
-			err = scsi_get_idlun(q, arg);
-			break;
-		case SCSI_IOCTL_GET_BUS_NUMBER:
-			err = scsi_get_bus(q, arg);
-			break;
 		case SG_SET_TIMEOUT:
 			err = sg_set_timeout(q, arg);
 			break;
-- 
2.30.2

