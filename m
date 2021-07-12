Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0C2C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF423610CA
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhGLFxD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhGLFxC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:53:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D57C0613DD;
        Sun, 11 Jul 2021 22:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=4mN6Xp8Qg20X7Ti3uX8gM1MxGdmBtReZWfD0oHyK2hc=; b=pEADPyk+uVGwBgH/SzID7Ibii/
        41ZjSPYHT10Wywo+Kl3rxEBkqV/jmR/mPoQzlg9W3kPW5DAxksw3h1PEjaYdE0cmDmJP8C6jKB3/o
        Hp3/heuFWespsagw2AHl0SbCeh0cgxUAS+VtWlhhoIbhZkNUEk7wXWSzeorPgVEbxoqUmvoV/0BnH
        dPbKvhxJZkw1rJ2bak6fLHoPOpcUdcg55GRDkjpoDOftKt53gLpR1MjxBAq77emjwUspUKW4kz/te
        rQ2wHnmf/BjXpBa95XKsz+sDxLPESc4SesecOgnO+Ms/+X1wVDCtoGMhm+pRzbf8Tl1zhC7hzcVkn
        EO1Jp76w==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ooZ-00Gv2h-A4; Mon, 12 Jul 2021 05:49:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 03/24] sd: consolidate compat ioctl handling
Date:   Mon, 12 Jul 2021 07:47:55 +0200
Message-Id: <20210712054816.4147559-4-hch@lst.de>
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
in_compat_syscall(), and also simplify the calling conventions
by mergin sd_ioctl_common into sd_ioctl.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 63 ++++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6d2d63629a90..f470daf76155 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1533,11 +1533,11 @@ static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 }
 
 /**
- *	sd_ioctl_common - process an ioctl
+ *	sd_ioctl - process an ioctl
  *	@bdev: target block device
  *	@mode: FMODE_* mask
  *	@cmd: ioctl command number
- *	@p: this is third argument given to ioctl(2) system call.
+ *	@arg: this is third argument given to ioctl(2) system call.
  *	Often contains a pointer.
  *
  *	Returns 0 if successful (some ioctls return positive numbers on
@@ -1546,12 +1546,13 @@ static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
  *	Note: most ioctls are forward onto the block subsystem or further
  *	down in the scsi subsystem.
  **/
-static int sd_ioctl_common(struct block_device *bdev, fmode_t mode,
-			   unsigned int cmd, void __user *p)
+static int sd_ioctl(struct block_device *bdev, fmode_t mode,
+		    unsigned int cmd, unsigned long arg)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
+	void __user *p = (void __user *)arg;
 	int error;
     
 	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp, "sd_ioctl: disk=%s, "
@@ -1570,7 +1571,7 @@ static int sd_ioctl_common(struct block_device *bdev, fmode_t mode,
 	error = scsi_ioctl_block_when_processing_errors(sdp, cmd,
 			(mode & FMODE_NDELAY) != 0);
 	if (error)
-		goto out;
+		return error;
 
 	if (is_sed_ioctl(cmd))
 		return sed_ioctl(sdkp->opal_dev, cmd, p);
@@ -1581,16 +1582,18 @@ static int sd_ioctl_common(struct block_device *bdev, fmode_t mode,
 	 * resolved.
 	 */
 	switch (cmd) {
-		case SCSI_IOCTL_GET_IDLUN:
-		case SCSI_IOCTL_GET_BUS_NUMBER:
-			error = scsi_ioctl(sdp, cmd, p);
-			break;
-		default:
-			error = scsi_cmd_blk_ioctl(bdev, mode, cmd, p);
-			break;
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+		break;
+	default:
+		error = scsi_cmd_blk_ioctl(bdev, mode, cmd, p);
+		if (error != -ENOTTY)
+			return error;
 	}
-out:
-	return error;
+
+	if (in_compat_syscall())
+		return scsi_compat_ioctl(sdp, cmd, p);
+	return scsi_ioctl(sdp, cmd, p);
 }
 
 static void set_media_not_present(struct scsi_disk *sdkp)
@@ -1773,34 +1776,6 @@ static void sd_rescan(struct device *dev)
 	sd_revalidate_disk(sdkp->disk);
 }
 
-static int sd_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned int cmd, unsigned long arg)
-{
-	void __user *p = (void __user *)arg;
-	int ret;
-
-	ret = sd_ioctl_common(bdev, mode, cmd, p);
-	if (ret != -ENOTTY)
-		return ret;
-
-	return scsi_ioctl(scsi_disk(bdev->bd_disk)->device, cmd, p);
-}
-
-#ifdef CONFIG_COMPAT
-static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
-			   unsigned int cmd, unsigned long arg)
-{
-	void __user *p = compat_ptr(arg);
-	int ret;
-
-	ret = sd_ioctl_common(bdev, mode, cmd, p);
-	if (ret != -ENOTTY)
-		return ret;
-
-	return scsi_compat_ioctl(scsi_disk(bdev->bd_disk)->device, cmd, p);
-}
-#endif
-
 static char sd_pr_type(enum pr_type type)
 {
 	switch (type) {
@@ -1901,9 +1876,7 @@ static const struct block_device_operations sd_fops = {
 	.release		= sd_release,
 	.ioctl			= sd_ioctl,
 	.getgeo			= sd_getgeo,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl		= sd_compat_ioctl,
-#endif
+	.compat_ioctl		= blkdev_compat_ptr_ioctl,
 	.check_events		= sd_check_events,
 	.unlock_native_capacity	= sd_unlock_native_capacity,
 	.report_zones		= sd_zbc_report_zones,
-- 
2.30.2

