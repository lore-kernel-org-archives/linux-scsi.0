Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D93C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF17B610CC
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhGLFzs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhGLFzs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:55:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0601C0613DD;
        Sun, 11 Jul 2021 22:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HzWyPz4teTBG8ua4v37F1g8cLsKRrQ80n47QdpU5Sj8=; b=ZLIu8MmJm/ueVQFJUKqhXaq9Me
        22ULlXvJRbRbc1o4o6xpsap0dRpAkatD/I2krZ51HGW0xhKi7upAHbAcfes9jWLV0q7MfdbNj1dvl
        t0r1eQT3fbXT585zJBevo9G+YxY4OdOJGXb1AsN4+eA8ER7is/bYTMokZ2ybqDcy1ONLc9Hgb8FsB
        Fe1+wxDbLxIir+E7G09G8wrd4JTaeUQ7Qgy0egwqlXV9SWsCPe6sytMBm5/Z5TO4KwMLv3cIct+sR
        Mx1CONkkjvL0BSgfoE/aWfP9J/Y6hDcSt0ARKX1vPBIReILoFOLv0q9/KgOgLTpICJ9wWuI19S/hR
        jz4rqT4Q==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ore-00GvEn-1g; Mon, 12 Jul 2021 05:52:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 09/24] scsi_ioctl: remove scsi_cmd_blk_ioctl
Date:   Mon, 12 Jul 2021 07:48:01 +0200
Message-Id: <20210712054816.4147559-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Open code scsi_cmd_blk_ioctl in its two callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c     | 13 -------------
 drivers/scsi/sd.c      |  5 ++++-
 drivers/scsi/sr.c      |  8 ++++++--
 include/linux/blkdev.h |  2 --
 4 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index d247431a6853..f8138438c56f 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -854,19 +854,6 @@ int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
 }
 EXPORT_SYMBOL(scsi_verify_blk_ioctl);
 
-int scsi_cmd_blk_ioctl(struct block_device *bd, fmode_t mode,
-		       unsigned int cmd, void __user *arg)
-{
-	int ret;
-
-	ret = scsi_verify_blk_ioctl(bd, cmd);
-	if (ret < 0)
-		return ret;
-
-	return scsi_cmd_ioctl(bd->bd_disk->queue, bd->bd_disk, mode, cmd, arg);
-}
-EXPORT_SYMBOL(scsi_cmd_blk_ioctl);
-
 /**
  * scsi_req_init - initialize certain fields of a scsi_request structure
  * @req: Pointer to a scsi_request structure.
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1c9dbdaaef22..ca918b0047fa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1586,7 +1586,10 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 		break;
 	default:
-		error = scsi_cmd_blk_ioctl(bdev, mode, cmd, p);
+		error = scsi_verify_blk_ioctl(bdev, cmd);
+		if (error < 0)
+			return error;
+		error = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, p);
 		if (error != -ENOTTY)
 			return error;
 	}
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7948416f40d5..b903e54c57fd 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -556,7 +556,8 @@ static void sr_block_release(struct gendisk *disk, fmode_t mode)
 static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			  unsigned long arg)
 {
-	struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
+	struct gendisk *disk = bdev->bd_disk;
+	struct scsi_cd *cd = scsi_cd(disk);
 	struct scsi_device *sdev = cd->device;
 	void __user *argp = (void __user *)arg;
 	int ret;
@@ -579,7 +580,10 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 		break;
 	default:
-		ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
+		ret = scsi_verify_blk_ioctl(bdev, cmd);
+		if (ret < 0)
+			goto put;
+		ret = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, argp);
 		if (ret != -ENOTTY)
 			goto put;
 		ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3177181c4326..19aa3d5429c0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -889,8 +889,6 @@ extern blk_status_t blk_insert_cloned_request(struct request_queue *q,
 int blk_rq_append_bio(struct request *rq, struct bio *bio);
 extern void blk_queue_split(struct bio **);
 extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
-extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
-			      unsigned int, void __user *);
 extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			  unsigned int, void __user *);
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
-- 
2.30.2

