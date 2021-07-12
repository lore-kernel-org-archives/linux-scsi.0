Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B2FC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F6A66108B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhGLF4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbhGLF4t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:56:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F551C0613DD;
        Sun, 11 Jul 2021 22:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ojR1pCjWYmU/Vk9lmNCkBTXWb4DNeTZ8QXwLrevgSmw=; b=dQeTlkDqGpIAbbalVmCntDK6JZ
        +VwOHBWo2QQKJQ04qerdBHqfUvNqQrq9kuq6MNmfKHEDNp/yNooJ2qS+nCryRr5OPefoUc1oiyBxd
        4Kf7LM0mG9D11kfBV7xzP9d9dy4GAr+gmtTwumB/eSlzB4bWWgCvaXEiSpLwZ3xU8g5dqGTcZApWg
        E6NhLn75ER4fAKU0VGnSyfByD/SeCVz/AdRwMhP2manErtic9kSzGpN4IzzqSFG2bJOR9EPBB1+oD
        pGwZqC2NkfCLxH/EDEKLrGeNbMaHt0Vft/pMJ7z5+3Dy0qmU6FcpR81GHoRmKP/V9WRuwwlJA/Dne
        6GIKldZw==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2osL-00GvHz-RP; Mon, 12 Jul 2021 05:53:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 11/24] scsi: call scsi_cmd_ioctl from scsi_ioctl
Date:   Mon, 12 Jul 2021 07:48:03 +0200
Message-Id: <20210712054816.4147559-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ensure SCSI ULD only have to call a single ioctl helper.  This also adds
a bunch of missing ioctls to the ch driver, and removes the need for a
duplicate implementation of  SCSI_IOCTL_SEND_COMMAND command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c         |  2 +-
 drivers/scsi/scsi_ioctl.c | 17 ++++++++++++-----
 drivers/scsi/sd.c         | 18 +-----------------
 drivers/scsi/sg.c         |  2 +-
 drivers/scsi/sr.c         | 16 ++--------------
 drivers/scsi/st.c         | 10 +---------
 include/scsi/scsi_ioctl.h |  4 +++-
 7 files changed, 21 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 87df8cd880e0..159ab7ccaf7b 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -877,7 +877,7 @@ static long ch_ioctl(struct file *file,
 	}
 
 	default:
-		return scsi_ioctl(ch->device, cmd, argp);
+		return scsi_ioctl(ch->device, NULL, file->f_mode, cmd, argp);
 
 	}
 }
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 7b2e3cc85e66..7739575b5229 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -192,6 +192,8 @@ static int scsi_ioctl_get_pci(struct scsi_device *sdev, void __user *arg)
 /**
  * scsi_ioctl - Dispatch ioctl to scsi device
  * @sdev: scsi device receiving ioctl
+ * @disk: disk receiving the ioctl
+ * @mode: mode the block/char device is opened with
  * @cmd: which ioctl is it
  * @arg: data associated with ioctl
  *
@@ -199,10 +201,13 @@ static int scsi_ioctl_get_pci(struct scsi_device *sdev, void __user *arg)
  * does not take a major/minor number as the dev field.  Rather, it takes
  * a pointer to a &struct scsi_device.
  */
-int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
+		int cmd, void __user *arg)
 {
+	struct request_queue *q = sdev->request_queue;
 	char scsi_cmd[MAX_COMMAND_SIZE];
 	struct scsi_sense_hdr sense_hdr;
+	int error;
 
 	/* Check for deprecated ioctls ... all the ioctls which don't
 	 * follow the new unique numbering scheme are deprecated */
@@ -220,6 +225,12 @@ int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 		break;
 	}
 
+	if (cmd != SCSI_IOCTL_GET_IDLUN && cmd != SCSI_IOCTL_GET_BUS_NUMBER) {
+		error = scsi_cmd_ioctl(q, disk, mode, cmd, arg);
+		if (error != -ENOTTY)
+			return error;
+	}
+
 	switch (cmd) {
 	case SCSI_IOCTL_GET_IDLUN: {
 		struct scsi_idlun v = {
@@ -237,10 +248,6 @@ int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 		return put_user(sdev->host->host_no, (int __user *)arg);
 	case SCSI_IOCTL_PROBE_HOST:
 		return ioctl_probe(sdev->host, arg);
-	case SCSI_IOCTL_SEND_COMMAND:
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		return sg_scsi_ioctl(sdev->request_queue, NULL, 0, arg);
 	case SCSI_IOCTL_DOORLOCK:
 		return scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	case SCSI_IOCTL_DOORUNLOCK:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7c0b15cd8a0f..73388113559e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1574,23 +1574,7 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 
 	if (is_sed_ioctl(cmd))
 		return sed_ioctl(sdkp->opal_dev, cmd, p);
-
-	/*
-	 * Send SCSI addressing ioctls directly to mid level, send other
-	 * ioctls to block level and then onto mid level if they can't be
-	 * resolved.
-	 */
-	switch (cmd) {
-	case SCSI_IOCTL_GET_IDLUN:
-	case SCSI_IOCTL_GET_BUS_NUMBER:
-		break;
-	default:
-		error = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, p);
-		if (error != -ENOTTY)
-			return error;
-	}
-
-	return scsi_ioctl(sdp, cmd, p);
+	return scsi_ioctl(sdp, disk, mode, cmd, p);
 }
 
 static void set_media_not_present(struct scsi_disk *sdkp)
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c3562c2d0dca..6cb1e4b6eac2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1165,7 +1165,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	ret = sg_ioctl_common(filp, sdp, sfp, cmd_in, p);
 	if (ret != -ENOIOCTLCMD)
 		return ret;
-	return scsi_ioctl(sdp->device, cmd_in, p);
+	return scsi_ioctl(sdp->device, NULL, filp->f_mode, cmd_in, p);
 }
 
 static __poll_t
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e6eadba4d638..b98e77fe700b 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -574,24 +574,12 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 	scsi_autopm_get_device(sdev);
 
-	/*
-	 * Send SCSI addressing ioctls directly to mid level, send other
-	 * ioctls to cdrom/block level.
-	 */
-	switch (cmd) {
-	case SCSI_IOCTL_GET_IDLUN:
-	case SCSI_IOCTL_GET_BUS_NUMBER:
-		break;
-	default:
-		ret = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, argp);
-		if (ret != -ENOTTY)
-			goto put;
+	if (ret != CDROMCLOSETRAY && ret != CDROMEJECT) {
 		ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
 		if (ret != -ENOSYS)
 			goto put;
 	}
-
-	ret = scsi_ioctl(sdev, cmd, argp);
+	ret = scsi_ioctl(sdev, disk, mode, cmd, argp);
 
 put:
 	scsi_autopm_put_device(sdev);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9274f665bc0f..2d1b0594af69 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3823,24 +3823,16 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	mutex_unlock(&STp->lock);
 
 	switch (cmd_in) {
-	case SCSI_IOCTL_GET_IDLUN:
-	case SCSI_IOCTL_GET_BUS_NUMBER:
-		break;
 	case SG_IO:
 	case SCSI_IOCTL_SEND_COMMAND:
 	case CDROM_SEND_PACKET:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
-		fallthrough;
 	default:
-		retval = scsi_cmd_ioctl(STp->disk->queue, STp->disk,
-					file->f_mode, cmd_in, p);
-		if (retval != -ENOTTY)
-			return retval;
 		break;
 	}
 
-	retval = scsi_ioctl(STp->device, cmd_in, p);
+	retval = scsi_ioctl(STp->device, STp->disk, file->f_mode, cmd_in, p);
 	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) {
 		/* unload */
 		STp->rew_at_close = 0;
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index cdb3ba3451e7..defbe8084eb8 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -18,6 +18,7 @@
 
 #ifdef __KERNEL__
 
+struct gendisk;
 struct scsi_device;
 
 /*
@@ -43,7 +44,8 @@ typedef struct scsi_fctargaddress {
 
 int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
 		int cmd, bool ndelay);
-extern int scsi_ioctl(struct scsi_device *, int, void __user *);
+int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
+		int cmd, void __user *arg);
 
 #endif /* __KERNEL__ */
 #endif /* _SCSI_IOCTL_H */
-- 
2.30.2

