Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D298BC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA34610A6
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhGLFwY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhGLFwY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:52:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB9DC0613DD;
        Sun, 11 Jul 2021 22:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=dvdOli7bHP6e1Fc2m33L44pY6SEtvudI3oLWJkO8ZwM=; b=Zdc6PZWxKzFNa23fGQQ8d/WXx+
        o/0dBhTGIDoh3lrhnZbjOfAft7h5OxHHPl71F8xYfDTkrZlDSjl9VIxtj2I92c46gui/lUWlQIyOJ
        DVs00TM0+7HjKxgxpHjpFPRXaKBui3ycdYjPe8aJ/2sVTRQhWr0qUqaAtj/zyPVLkNhpDu44oUtUi
        xuRk7sUeC60EIQ26q+vAlMhY1NJZFISvu/+4s78o+Eau/gSPrGztxhtr8QlRZQ9yqxzf7dpHjWe6n
        +pvAYwSLiMmbY8yRt3Hcs8hUh3sOu3OF1k6pmKvpWF41xy/Q1jWuwZ/ukHwhaty5uusJ1Dsst49R1
        211lhwcw==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ooB-00Gv0r-4X; Mon, 12 Jul 2021 05:48:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 02/24] sr: consolidate compat ioctl handling
Date:   Mon, 12 Jul 2021 07:47:54 +0200
Message-Id: <20210712054816.4147559-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Merge the native and compat ioctl handlers into a single one using
in_compat_syscall().

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr.c | 64 +++++++----------------------------------------
 1 file changed, 9 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 94c254e9012e..b34f06924659 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -577,68 +577,24 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	switch (cmd) {
 	case SCSI_IOCTL_GET_IDLUN:
 	case SCSI_IOCTL_GET_BUS_NUMBER:
-		ret = scsi_ioctl(sdev, cmd, argp);
-		goto put;
+		break;
+	default:
+		ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
+		if (ret != -ENOSYS)
+			goto put;
 	}
 
-	ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
-	if (ret != -ENOSYS)
-		goto put;
-
-	ret = scsi_ioctl(sdev, cmd, argp);
-
-put:
-	scsi_autopm_put_device(sdev);
-
-out:
-	mutex_unlock(&cd->lock);
-	return ret;
-}
-
-#ifdef CONFIG_COMPAT
-static int sr_block_compat_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
-			  unsigned long arg)
-{
-	struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
-	struct scsi_device *sdev = cd->device;
-	void __user *argp = compat_ptr(arg);
-	int ret;
-
-	mutex_lock(&cd->lock);
-
-	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
-			(mode & FMODE_NDELAY) != 0);
-	if (ret)
-		goto out;
-
-	scsi_autopm_get_device(sdev);
-
-	/*
-	 * Send SCSI addressing ioctls directly to mid level, send other
-	 * ioctls to cdrom/block level.
-	 */
-	switch (cmd) {
-	case SCSI_IOCTL_GET_IDLUN:
-	case SCSI_IOCTL_GET_BUS_NUMBER:
+	if (in_compat_syscall())
 		ret = scsi_compat_ioctl(sdev, cmd, argp);
-		goto put;
-	}
-
-	ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, (unsigned long)argp);
-	if (ret != -ENOSYS)
-		goto put;
-
-	ret = scsi_compat_ioctl(sdev, cmd, argp);
+	else
+		ret = scsi_ioctl(sdev, cmd, argp);
 
 put:
 	scsi_autopm_put_device(sdev);
-
 out:
 	mutex_unlock(&cd->lock);
 	return ret;
-
 }
-#endif
 
 static unsigned int sr_block_check_events(struct gendisk *disk,
 					  unsigned int clearing)
@@ -663,9 +619,7 @@ static const struct block_device_operations sr_bdops =
 	.open		= sr_block_open,
 	.release	= sr_block_release,
 	.ioctl		= sr_block_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= sr_block_compat_ioctl,
-#endif
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.check_events	= sr_block_check_events,
 };
 
-- 
2.30.2

