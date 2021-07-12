Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56621C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30B7F6101D
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhGLGCD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 02:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhGLGCD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 02:02:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BFCC0613DD;
        Sun, 11 Jul 2021 22:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=S6KqZsCf1nAFCvGGUaqcH4vcppwFZbWTX55tGzGo+4E=; b=NmDg0gR0ai9Aww/SnX95jHbrVV
        Tg8c7GvKXoSHyIAkt9eH9iIerMlAmPwlrcc9OZW/1OA6OPdMJEehTurq6gim0Q5v29GLSUXGbR6vc
        6c1DeCW+W3rsTGY5qgahjSEMv/bQboypjSbtvE1DyLYaTSwAG6mpQGzDVuzltjJ0CTpkoUBEYJfvX
        DAwmYlyBJX7WBnFmefT9B/mQ+qFXne/eXgyTZd7/fYYeiaqAe/REXbF8ffD0lA7ZXok/r4PiiKrDZ
        vNZqjN8QYcGwiTP8MvKz1WRxjzNfFQGUUG4ju4ikfFPDqsymCX8EjjJVNW/e13cWIjsH+7YVTaYAc
        aN/bzWbw==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2oxM-00GvgI-Sw; Mon, 12 Jul 2021 05:58:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 24/24] scsi: unexport sg_scsi_ioctl
Date:   Mon, 12 Jul 2021 07:48:16 +0200
Message-Id: <20210712054816.4147559-25-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just call scsi_ioctl in sg as that has the same effect.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_ioctl.c | 5 ++---
 drivers/scsi/sg.c         | 2 +-
 include/scsi/scsi_ioctl.h | 2 --
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 2492c628fd38..2cbbd49760f8 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -524,8 +524,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
  *      Positive numbers returned are the compacted SCSI error codes (4
  *      bytes in one int) where the lowest byte is the SCSI status.
  */
-int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
-		struct scsi_ioctl_command __user *sic)
+static int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk,
+		fmode_t mode, struct scsi_ioctl_command __user *sic)
 {
 	enum { OMAX_SB_LEN = 16 };	/* For backward compatibility */
 	struct request *rq;
@@ -637,7 +637,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(sg_scsi_ioctl);
 
 int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp)
 {
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c86fa4476334..9be76deea242 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1109,7 +1109,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 	case SCSI_IOCTL_SEND_COMMAND:
 		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
-		return sg_scsi_ioctl(sdp->device->request_queue, NULL, filp->f_mode, p);
+		return scsi_ioctl(sdp->device, NULL, filp->f_mode, cmd_in, p);
 	case SG_SET_DEBUG:
 		result = get_user(val, ip);
 		if (result)
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index b3918fded464..d2cb9aeaf1f1 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -47,8 +47,6 @@ int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
 		int cmd, bool ndelay);
 int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
 		int cmd, void __user *arg);
-int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
-			 struct scsi_ioctl_command __user *argp);
 int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user *argp);
 int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp);
 bool scsi_cmd_allowed(unsigned char *cmd, fmode_t mode);
-- 
2.30.2

