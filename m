Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E06BC07E9C
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75E4860FED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhGLFvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhGLFvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:51:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F5FC0613DD;
        Sun, 11 Jul 2021 22:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=IKKnxa/Oq9Kk/PFow00UNMAUOz8NjDo9zSAQ/mZKJcs=; b=lEMttiSq+en8wcG1vs55djcWyJ
        B/hSx5zz5pfpHJtpRvooXCnVHUCqx+N6UrW8cxaLwbDFyUqyxaYQ55+5sPVlujzCxrFKgxCWx4NM2
        BtaGPHgrZsJgG0rb8o1YPYRaS7ggShbwKe4aecLqpsmep2jwjO7rBifSG3mImcD3XSV5PKsQ2iCIR
        aIoixdeI8CoYTuQkagYuz1HYvoTDGLJ3SDgEG93lRa3eDkN6mVrJTnOp47jlBWnu34/XZkQWmIU9x
        /UgFS6CJPU9Q1mgRtk8oe0pR/wf9i/s0fcfMVNlOVfJV/vssRUaOum3jwJh2ZKBCAb51P1DOE6CDN
        xEl1fYPA==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ony-00Gv0U-Kp; Mon, 12 Jul 2021 05:48:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 01/24] bsg: remove support for SCSI_IOCTL_SEND_COMMAND
Date:   Mon, 12 Jul 2021 07:47:53 +0200
Message-Id: <20210712054816.4147559-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI_IOCTL_SEND_COMMAND has been deprecated longer than bsg exists
and has been warning for just as long.  More importantly it harcodes
SCSI CDBs and thus will do the wrong thing on non-scsi bsg nodes.

Fixes: aa387cc89567 ("block: add bsg helper library")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bsg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bsg.c b/block/bsg.c
index 1f196563ae6c..79b42c5cafeb 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -373,10 +373,13 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case SG_GET_RESERVED_SIZE:
 	case SG_SET_RESERVED_SIZE:
 	case SG_EMULATED_HOST:
-	case SCSI_IOCTL_SEND_COMMAND:
 		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);
 	case SG_IO:
 		return bsg_sg_io(bd->queue, file->f_mode, uarg);
+	case SCSI_IOCTL_SEND_COMMAND:
+		pr_warn_ratelimited("%s: calling unsupported SCSI_IOCTL_SEND_COMMAND\n",
+				current->comm);
+		return -EINVAL;
 	default:
 		return -ENOTTY;
 	}
-- 
2.30.2

