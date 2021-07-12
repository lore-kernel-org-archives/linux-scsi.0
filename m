Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1DFC07E9C
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0826A610D0
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhGLGB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 02:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhGLGB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 02:01:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C4AC0613DD;
        Sun, 11 Jul 2021 22:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=JOsODCqoo9fHS4NEiD3ZPc0Q5qmmVeEfB1CTg83R1Sw=; b=jE0QWPvjvmdVlCd4CEAfQsY/up
        QZO8fCUWM/wK5f1qsf5UEiuxjZDnouQD2gpcaN0TrmsDS1CHjqdbscy3cAQOruzYt9U8oCLxcOqoT
        NSkZ9EYsQk6YAcIKORgkkvNByccOM0YmKmwlB87VxLFqff9LmJ45oU5Pk552PO0WShYAXTsqGRkwV
        c8QJuwmhiHQ6tAbp3mJ0H899IwFFgcx3t0G4rjrYBc58tMLj9XpfN/+0FidYv9xUU+sYB4B+Wsxjb
        TbTMQ3g7yK7yXw7GLWIt2H6q5WGthhLwMnZOaLZn/wGevBRDqKP9PEM5/1X7s66W/DYDQ+QKNBbWs
        58uO1E7Q==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2owm-00GvcP-DR; Mon, 12 Jul 2021 05:57:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 23/24] scsi: factor SG_IO handling into a helper
Date:   Mon, 12 Jul 2021 07:48:15 +0200
Message-Id: <20210712054816.4147559-24-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split the SG_IO handler from the main scsi_ioctl routine.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_ioctl.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 634cf62ec6fd..2492c628fd38 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -858,6 +858,23 @@ static int scsi_cdrom_send_packet(struct request_queue *q,
 	return err;
 }
 
+static int scsi_ioctl_sg_io(struct request_queue *q, struct gendisk *disk,
+		fmode_t mode, void __user *argp)
+{
+	struct sg_io_hdr hdr;
+	int error;
+
+	error = get_sg_io_hdr(&hdr, argp);
+	if (error)
+		return error;
+	error = sg_io(q, disk, &hdr, mode);
+	if (error == -EFAULT)
+		return error;
+	if (put_sg_io_hdr(&hdr, argp))
+		return -EFAULT;
+	return 0;
+}
+
 /**
  * scsi_ioctl - Dispatch ioctl to scsi device
  * @sdev: scsi device receiving ioctl
@@ -875,7 +892,6 @@ int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
 {
 	struct request_queue *q = sdev->request_queue;
 	struct scsi_sense_hdr sense_hdr;
-	int error;
 
 	/* Check for deprecated ioctls ... all the ioctls which don't
 	 * follow the new unique numbering scheme are deprecated */
@@ -906,21 +922,8 @@ int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
 		return sg_set_reserved_size(q, arg);
 	case SG_EMULATED_HOST:
 		return sg_emulated_host(q, arg);
-	case SG_IO: {
-		struct sg_io_hdr hdr;
-
-		error = get_sg_io_hdr(&hdr, arg);
-		if (error)
-			return error;
-
-		error = sg_io(q, disk, &hdr, mode);
-		if (error == -EFAULT)
-			return error;
-
-		if (put_sg_io_hdr(&hdr, arg))
-			return -EFAULT;
-		return 0;
-	}
+	case SG_IO:
+		return scsi_ioctl_sg_io(q, disk, mode, arg);
 	case SCSI_IOCTL_SEND_COMMAND:
 		return sg_scsi_ioctl(q, disk, mode, arg);
 	case CDROM_SEND_PACKET:
-- 
2.30.2

