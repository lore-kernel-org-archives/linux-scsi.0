Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F181C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2688611EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbhI1F14 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 01:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbhI1F1z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 01:27:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B436C061575;
        Mon, 27 Sep 2021 22:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Fg9zkzzu4KVvRbLOFkk4nmQGWrPy6n9KxyhFjSduIWY=; b=fdueShyo+EmYyRylOi6R6VikiD
        +00FDuBSjiY54of57E4tnerAEtJ9eIEOTUol+0RmkbEE9vJ5eDDTlYKBPsxTc+9AbLAjrnQ6vZzI9
        HHJGVHmJG97IMmu8qX+4DQMxTX1pOVuZP8Z3YeSpvUn3WiRMiORwt5pzDrVxE/uOGZJdhgu5Bt0Tm
        yX6Q7E8b3wyfrDulCzfs06YvRAR1di9AvnC+NSpJEJyYIIMD8esd3n1tLRIAdif1gIWkxM1Ls+nZp
        ylPWCf3NT64wuwhNLT1W6ISb/pmGujN2qs/hZXT9EG2k5ctDPNE7gi4DTNAKqVD3KuSpWCTcYumTR
        p2JItAkw==;
Received: from p4fdb05cb.dip0.t-ipconnect.de ([79.219.5.203] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mV5bl-00AWDX-HD; Tue, 28 Sep 2021 05:24:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 5/5] scsi: remove the gendisk argument to scsi_ioctl
Date:   Tue, 28 Sep 2021 07:22:11 +0200
Message-Id: <20210928052211.112801-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928052211.112801-1-hch@lst.de>
References: <20210928052211.112801-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that blk_execute_rq does not take a gendisk argument there is no need
to pass it through the scsi_ioctl callchain either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c         |  2 +-
 drivers/scsi/scsi_ioctl.c | 39 +++++++++++++++------------------------
 drivers/scsi/sd.c         |  2 +-
 drivers/scsi/sg.c         |  4 ++--
 drivers/scsi/sr.c         |  5 ++---
 drivers/scsi/st.c         |  2 +-
 include/scsi/scsi_ioctl.h |  4 ++--
 7 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 27012908b5861..6fa300daa31ea 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -877,7 +877,7 @@ static long ch_ioctl(struct file *file,
 	}
 
 	default:
-		return scsi_ioctl(ch->device, NULL, file->f_mode, cmd, argp);
+		return scsi_ioctl(ch->device, file->f_mode, cmd, argp);
 
 	}
 }
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 4a93f2c1d1afb..77201af00f670 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -406,8 +406,7 @@ static int scsi_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	return ret;
 }
 
-static int sg_io(struct scsi_device *sdev, struct gendisk *disk,
-		struct sg_io_hdr *hdr, fmode_t mode)
+static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 {
 	unsigned long start_time;
 	ssize_t ret = 0;
@@ -497,19 +496,12 @@ static int sg_io(struct scsi_device *sdev, struct gendisk *disk,
 /**
  * sg_scsi_ioctl  --  handle deprecated SCSI_IOCTL_SEND_COMMAND ioctl
  * @q:		request queue to send scsi commands down
- * @disk:	gendisk to operate on (option)
  * @mode:	mode used to open the file through which the ioctl has been
  *		submitted
  * @sic:	userspace structure describing the command to perform
  *
  * Send down the scsi command described by @sic to the device below
- * the request queue @q.  If @file is non-NULL it's used to perform
- * fine-grained permission checks that allow users to send down
- * non-destructive SCSI commands.  If the caller has a struct gendisk
- * available it should be passed in as @disk to allow the low level
- * driver to use the information contained in it.  A non-NULL @disk
- * is only allowed if the caller knows that the low level driver doesn't
- * need it (e.g. in the scsi subsystem).
+ * the request queue @q.
  *
  * Notes:
  *   -  This interface is deprecated - users should use the SG_IO
@@ -528,8 +520,8 @@ static int sg_io(struct scsi_device *sdev, struct gendisk *disk,
  *      Positive numbers returned are the compacted SCSI error codes (4
  *      bytes in one int) where the lowest byte is the SCSI status.
  */
-static int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk,
-		fmode_t mode, struct scsi_ioctl_command __user *sic)
+static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
+		struct scsi_ioctl_command __user *sic)
 {
 	enum { OMAX_SB_LEN = 16 };	/* For backward compatibility */
 	struct request *rq;
@@ -804,8 +796,8 @@ static int scsi_put_cdrom_generic_arg(const struct cdrom_generic_command *cgc,
 	return 0;
 }
 
-static int scsi_cdrom_send_packet(struct scsi_device *sdev, struct gendisk *disk,
-		fmode_t mode, void __user *arg)
+static int scsi_cdrom_send_packet(struct scsi_device *sdev, fmode_t mode,
+		void __user *arg)
 {
 	struct cdrom_generic_command cgc;
 	struct sg_io_hdr hdr;
@@ -845,7 +837,7 @@ static int scsi_cdrom_send_packet(struct scsi_device *sdev, struct gendisk *disk
 	hdr.cmdp = ((struct cdrom_generic_command __user *) arg)->cmd;
 	hdr.cmd_len = sizeof(cgc.cmd);
 
-	err = sg_io(sdev, disk, &hdr, mode);
+	err = sg_io(sdev, &hdr, mode);
 	if (err == -EFAULT)
 		return -EFAULT;
 
@@ -860,8 +852,8 @@ static int scsi_cdrom_send_packet(struct scsi_device *sdev, struct gendisk *disk
 	return err;
 }
 
-static int scsi_ioctl_sg_io(struct scsi_device *sdev, struct gendisk *disk,
-		fmode_t mode, void __user *argp)
+static int scsi_ioctl_sg_io(struct scsi_device *sdev, fmode_t mode,
+		void __user *argp)
 {
 	struct sg_io_hdr hdr;
 	int error;
@@ -869,7 +861,7 @@ static int scsi_ioctl_sg_io(struct scsi_device *sdev, struct gendisk *disk,
 	error = get_sg_io_hdr(&hdr, argp);
 	if (error)
 		return error;
-	error = sg_io(sdev, disk, &hdr, mode);
+	error = sg_io(sdev, &hdr, mode);
 	if (error == -EFAULT)
 		return error;
 	if (put_sg_io_hdr(&hdr, argp))
@@ -880,7 +872,6 @@ static int scsi_ioctl_sg_io(struct scsi_device *sdev, struct gendisk *disk,
 /**
  * scsi_ioctl - Dispatch ioctl to scsi device
  * @sdev: scsi device receiving ioctl
- * @disk: disk receiving the ioctl
  * @mode: mode the block/char device is opened with
  * @cmd: which ioctl is it
  * @arg: data associated with ioctl
@@ -889,8 +880,8 @@ static int scsi_ioctl_sg_io(struct scsi_device *sdev, struct gendisk *disk,
  * does not take a major/minor number as the dev field.  Rather, it takes
  * a pointer to a &struct scsi_device.
  */
-int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
-		int cmd, void __user *arg)
+int scsi_ioctl(struct scsi_device *sdev, fmode_t mode, int cmd,
+		void __user *arg)
 {
 	struct request_queue *q = sdev->request_queue;
 	struct scsi_sense_hdr sense_hdr;
@@ -925,11 +916,11 @@ int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
 	case SG_EMULATED_HOST:
 		return sg_emulated_host(q, arg);
 	case SG_IO:
-		return scsi_ioctl_sg_io(sdev, disk, mode, arg);
+		return scsi_ioctl_sg_io(sdev, mode, arg);
 	case SCSI_IOCTL_SEND_COMMAND:
-		return sg_scsi_ioctl(q, disk, mode, arg);
+		return sg_scsi_ioctl(q, mode, arg);
 	case CDROM_SEND_PACKET:
-		return scsi_cdrom_send_packet(sdev, disk, mode, arg);
+		return scsi_cdrom_send_packet(sdev, mode, arg);
 	case CDROMCLOSETRAY:
 		return scsi_send_start_stop(sdev, 3);
 	case CDROMEJECT:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b6846e1fc97fd..171e098f3816e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1574,7 +1574,7 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 
 	if (is_sed_ioctl(cmd))
 		return sed_ioctl(sdkp->opal_dev, cmd, p);
-	return scsi_ioctl(sdp, disk, mode, cmd, p);
+	return scsi_ioctl(sdp, mode, cmd, p);
 }
 
 static void set_media_not_present(struct scsi_disk *sdkp)
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 24196ea7e0d76..d2c9035443d9f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1109,7 +1109,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 	case SCSI_IOCTL_SEND_COMMAND:
 		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
-		return scsi_ioctl(sdp->device, NULL, filp->f_mode, cmd_in, p);
+		return scsi_ioctl(sdp->device, filp->f_mode, cmd_in, p);
 	case SG_SET_DEBUG:
 		result = get_user(val, ip);
 		if (result)
@@ -1165,7 +1165,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	ret = sg_ioctl_common(filp, sdp, sfp, cmd_in, p);
 	if (ret != -ENOIOCTLCMD)
 		return ret;
-	return scsi_ioctl(sdp->device, NULL, filp->f_mode, cmd_in, p);
+	return scsi_ioctl(sdp->device, filp->f_mode, cmd_in, p);
 }
 
 static __poll_t
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index eddb153a536d7..73ac5ad368234 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -561,8 +561,7 @@ static void sr_block_release(struct gendisk *disk, fmode_t mode)
 static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			  unsigned long arg)
 {
-	struct gendisk *disk = bdev->bd_disk;
-	struct scsi_cd *cd = scsi_cd(disk);
+	struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
 	struct scsi_device *sdev = cd->device;
 	void __user *argp = (void __user *)arg;
 	int ret;
@@ -584,7 +583,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		if (ret != -ENOSYS)
 			goto put;
 	}
-	ret = scsi_ioctl(sdev, disk, mode, cmd, argp);
+	ret = scsi_ioctl(sdev, mode, cmd, argp);
 
 put:
 	scsi_autopm_put_device(sdev);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1d2855fe5faf8..8c87cb9395699 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3829,7 +3829,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		break;
 	}
 
-	retval = scsi_ioctl(STp->device, NULL, file->f_mode, cmd_in, p);
+	retval = scsi_ioctl(STp->device, file->f_mode, cmd_in, p);
 	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) {
 		/* unload */
 		STp->rew_at_close = 0;
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index d2cb9aeaf1f16..beac64e38b874 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -45,8 +45,8 @@ typedef struct scsi_fctargaddress {
 
 int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
 		int cmd, bool ndelay);
-int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
-		int cmd, void __user *arg);
+int scsi_ioctl(struct scsi_device *sdev, fmode_t mode, int cmd,
+		void __user *arg);
 int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user *argp);
 int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp);
 bool scsi_cmd_allowed(unsigned char *cmd, fmode_t mode);
-- 
2.30.2

