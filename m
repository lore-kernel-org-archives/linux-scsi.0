Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B1EC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E54F060EB0
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbhGXGx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbhGXGx0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:53:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2414C061575;
        Sat, 24 Jul 2021 00:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1o20UjFSCu9RCRpp605CiAvWXYDEYwYFj5Eisgb7ePc=; b=rQvsUJVEXcuN+74mISix86T7hQ
        aDF/GYxg0eV18S5Ljwx7i2XPH8ndwmebtb4T8gEsn41rOMes+M7fEf3Oi2GpuSyumLaYvwmCHm6aY
        /zjH+PdURsgfU/rlig31mMrCHNzg24cPgyexYEjg9lNRKo5FKXYbXvffRDpe1TbFqeQy/VgkM1er2
        dVetYAXIhUYmyxQUn9HHjzJNKGRGFwAIMANKt21y5rQWEEH2LTKk+CtjlB++3mHW+o0/NeTcyevTN
        BRaMn1CLVl6CfBOP5B/3HMgxRFRpbcvpjccecXfLscN22JAyQwIkQ4HtG+1Lvsrc7ovM/EwP7FCSB
        nn9OdtqA==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7C9j-00C5dR-LW; Sat, 24 Jul 2021 07:33:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 24/24] scsi: unexport sg_scsi_ioctl
Date:   Sat, 24 Jul 2021 09:20:33 +0200
Message-Id: <20210724072033.1284840-25-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
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
index dd07ebe6d366..ae880814b548 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -530,8 +530,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
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
@@ -643,7 +643,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
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

