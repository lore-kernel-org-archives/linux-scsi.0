Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C64C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92E5610CA
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhGLF7v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhGLF7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:59:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB66C0613DD;
        Sun, 11 Jul 2021 22:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=G6A/HZOHN22SJdoajPXdE7IHzw0ngJYBDcqnIwaTNaM=; b=EV3mbhQA5twbYT5ZS5iSdagFQT
        rpeYzKr4a0ZGP8JJkIOmJkwsTbVcvFaGpWhmi0h4V2lV0p4+gR+wf8chEjYIJ/r0KsVTZrbY1KV/m
        +KDhHdMl9IKCwnblZajPuR7rr0HfQPBBIHA1uIH11n1XsbnWdZkB6LyoDuGb5Q0yNB9e6XNVQWvmQ
        xpWxHznp7V/QR++HTeucenKJRjmvYsFXR1URozLCs3WyYQgw7HoyJ2sSLQsmiFOdDrIA/7mjHYHgU
        TbRv0ZBtu2itx4bkBUUuwPZ1Xq+nc9q6UkFTl97dmcOzgXB00FVqIT3F4YB091PTc7DwJD9WGW9x7
        xWuZlDKg==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ove-00GvWH-41; Mon, 12 Jul 2021 05:56:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 20/24] scsi: remove a very misleading comment
Date:   Mon, 12 Jul 2021 07:48:12 +0200
Message-Id: <20210712054816.4147559-21-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the comment above ioctl_internal_command, which doesn't
document this function at all.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_ioctl.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index a70ddc1eb313..3d4311a78383 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -64,29 +64,6 @@ static int ioctl_probe(struct Scsi_Host *host, void __user *buffer)
 	return 1;
 }
 
-/*
-
- * The SCSI_IOCTL_SEND_COMMAND ioctl sends a command out to the SCSI host.
- * The IOCTL_NORMAL_TIMEOUT and NORMAL_RETRIES  variables are used.  
- * 
- * dev is the SCSI device struct ptr, *(int *) arg is the length of the
- * input data, if any, not including the command string & counts, 
- * *((int *)arg + 1) is the output buffer size in bytes.
- * 
- * *(char *) ((int *) arg)[2] the actual command byte.   
- * 
- * Note that if more than MAX_BUF bytes are requested to be transferred,
- * the ioctl will fail with error EINVAL.
- * 
- * This size *does not* include the initial lengths that were passed.
- * 
- * The SCSI command is read from the memory location immediately after the
- * length words, and the input data is right after the command.  The SCSI
- * routines know the command size based on the opcode decode.  
- * 
- * The output area is then filled in starting from the command byte. 
- */
-
 static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 				  int timeout, int retries)
 {
-- 
2.30.2

