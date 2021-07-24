Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C5AC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB7A60E8F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhGXGnl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbhGXGnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:43:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C35C061575;
        Sat, 24 Jul 2021 00:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=qA5AVEckjlp0uAOqGEQLdSPZfbde2E/thIYJSYmY6Yo=; b=r573B2leMFXX6GmOGVu7kR8dMo
        ymL5nUSsxzqCwW0Le6TP9c91VM4fALa0MXUq3buNQvw8J0q7zrbvsh7vXmWnNoaxJKL8Y0ie53Ljt
        8klFDIU/W16Hc2cYoKo4f5fXrRTXJDgScow3K0uKbBmEgJddSCPf7aSUMqAp5yC2b4ndamvgqiQc/
        eNHjge1vnj0y4oVOl75Ab6s10WxBRhqYiivZV0LkT7pdb0RU0KyaP5fqd2Ubr1tilgymrjwMFQEqk
        D7/X5cWFmnxpUTUS/7sTb6QXp4HDGfGCPj3YIfzzv3sjDCpK7W2p7FhZKjhlGw+MW6qqoB9ffa/gV
        wf1gaAHA==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7C0Y-00C59v-0O; Sat, 24 Jul 2021 07:23:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 10/24] scsi_ioctl: remove scsi_verify_blk_ioctl
Date:   Sat, 24 Jul 2021 09:20:19 +0200
Message-Id: <20210724072033.1284840-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just verify that the device is no a partition or the caller has admin
privіleges at the beginning of the sr ioctl method manually and open
code the trivial check for sd as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c     | 12 ------------
 drivers/scsi/sd.c      |  8 ++------
 drivers/scsi/sr.c      |  6 +++---
 include/linux/blkdev.h |  1 -
 4 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index f8138438c56f..ca7b84452d9d 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -842,18 +842,6 @@ int scsi_cmd_ioctl(struct request_queue *q, struct gendisk *bd_disk, fmode_t mod
 }
 EXPORT_SYMBOL(scsi_cmd_ioctl);
 
-int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
-{
-	if (bd && !bdev_is_partition(bd))
-		return 0;
-
-	if (capable(CAP_SYS_RAWIO))
-		return 0;
-
-	return -ENOIOCTLCMD;
-}
-EXPORT_SYMBOL(scsi_verify_blk_ioctl);
-
 /**
  * scsi_req_init - initialize certain fields of a scsi_request structure
  * @req: Pointer to a scsi_request structure.
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 72099d3892f0..78025acad6e3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1554,9 +1554,8 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp, "sd_ioctl: disk=%s, "
 				    "cmd=0x%x\n", disk->disk_name, cmd));
 
-	error = scsi_verify_blk_ioctl(bdev, cmd);
-	if (error < 0)
-		return error;
+	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
+		return -ENOIOCTLCMD;
 
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
@@ -1582,9 +1581,6 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 		break;
 	default:
-		error = scsi_verify_blk_ioctl(bdev, cmd);
-		if (error < 0)
-			return error;
 		error = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, p);
 		if (error != -ENOTTY)
 			return error;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index b903e54c57fd..e6eadba4d638 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -562,6 +562,9 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
+	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
+		return -ENOIOCTLCMD;
+
 	mutex_lock(&cd->lock);
 
 	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
@@ -580,9 +583,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 		break;
 	default:
-		ret = scsi_verify_blk_ioctl(bdev, cmd);
-		if (ret < 0)
-			goto put;
 		ret = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, argp);
 		if (ret != -ENOTTY)
 			goto put;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 19aa3d5429c0..e2b972a85012 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -888,7 +888,6 @@ extern blk_status_t blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 int blk_rq_append_bio(struct request *rq, struct bio *bio);
 extern void blk_queue_split(struct bio **);
-extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			  unsigned int, void __user *);
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
-- 
2.30.2

