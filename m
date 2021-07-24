Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E966DC432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2E1560EB5
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhGXGko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbhGXGko (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:40:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F38C061575;
        Sat, 24 Jul 2021 00:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=kJXuR7DmZTAkXxamEn0Ydyt3F1es1Axqt7IKkJwFngE=; b=fgfSTMnKsjdFXjxmbYDnL/gltu
        TK+Kqj/YdbyM63qhJ2K2U1vbxQhTcVHlR5yawZBAzY7knNTcPUJo/7CwiTe/GeTWTx3SGnOTpySwD
        evAXIHcD0iK2wb+PNwHTlh+uZiCKMTS5ESdDFvxft8INNfgVIHAJ7GzqTYNXSQiyvbWUbJ4ic8erS
        y181tyD/wS4lDfFd00KpNxdpuSyeQS9Uc/dJdcXCeO+eqvnog42rIJFbF+LPlE8lmYaU5tKI8dFk4
        S/bTPqRTAbKoO+xXyO4EnO/otLdxI6H6UJAFm5fQ735kKZXQF5LDidXDC2o91A5JI5lglkhEoBJb+
        HYB6x54Q==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7Bxp-00C4wu-LC; Sat, 24 Jul 2021 07:20:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 01/24] bsg: remove support for SCSI_IOCTL_SEND_COMMAND
Date:   Sat, 24 Jul 2021 09:20:10 +0200
Message-Id: <20210724072033.1284840-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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

