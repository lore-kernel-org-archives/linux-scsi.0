Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED4FC2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 15:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C53F92072C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 15:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgABPDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 10:03:24 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:38279 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgABPDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 10:03:24 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MJVY8-1j2VY31jlw-00Jvad; Thu, 02 Jan 2020 16:02:43 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        zhengbin <zhengbin13@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Martin Wilck <mwilck@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v3 16/22] compat_ioctl: move cdrom commands into cdrom.c
Date:   Thu,  2 Jan 2020 15:55:34 +0100
Message-Id: <20200102145552.1853992-17-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20200102145552.1853992-1-arnd@arndb.de>
References: <20200102145552.1853992-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7HaNj+kg58AHuRufCpul7Uhfs08N+yeTpHJHjVcGayfYtYbvyK/
 gPTfC9V0RX3Kh4qb5P9bESSKsqBmuS0QZeYKIFmBoCnu4tTgTjLk3R7+WbBhFt6kV0hxyY1
 Jjso1mB8Kaykxnvjsdrvi8LSF+OW82GA9NtdSACP+37KgJ7QT2UD809QOiI7czN3j4kP3HW
 XNp6J1m4r7jDQV/3WWS8A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:RE0c2PHyQfE=:ClFbXwEaGJkU0KS/r5Q+A/
 eIyf/Q6YAnGOp2uglCpr1u8m4djz9Ezo7M8lfXZ1Kg3xgQPQzOJhpGFnt9P0YCX3nT9qrX4W8
 tlXHEFsPDv2DsL+cOG4sAMD967fnicQYTji5yMEaK6LumDsyY+xMYC2a3B6kutmnkNKPiRzCM
 zaPzRGn7e7HrMwnK3BMGsWVwL8lzRHASVgNR5XKek8F20wSy0eQTxjSj20yBeMJgXGsh+OU5x
 aq7mYPxjrfQ34xawfAu3KHqlUebDGTX+fynFCRevnt5qFTIRMwC+48R50tKww1X9mAQabEaDs
 E6ka36s8cMLPWxcR7pgkL2aQSx9oGtRu0hwypIGVG93TG1KkrbJV4E5z+KwG6lTm/zOfoh9aF
 +2OxEW9FBlYephcGDutuk/+GR7ayUQ1/56jNOEGWiG94c9P2QnP5Q8uk1mdaXVFT3ovqoQNms
 eXsj1Cfm1HNZ4tQqYAXv/GcJa5LeDDNkbhJ6ESY+EyhvQClTB9DWGvLD04PlBwU/trVTFCOzP
 LGvljnJCQ8F8r0NKAe+QbqqFTD+AiwkJdcSbYSBefw04iyfZDNCO/3+XzmEXmbLXBCO7AUEwE
 hI6VWJXUwiMbWU6FPx/Xjf+khPFgqfnzcgLz1HnIL9BQAGcRfvpk0Zw6ljhQ+kceZSE6qDBxd
 BOhpcRRhweV57XZuxM9hfBINBXLSoMbDx1GSc55/4u520SxrvdqUbua79ZkZbzxlCnFMdlgDg
 d9zBaW7QINy13zc3lQbL6gW+FWUx8ZRHcJ3jTzQ3dOzpGh+U0JSbR16iXJsXfitJse6nvi2i1
 QE6YyBQ0OOHbYPxKe315VC8j5h7TkmQYHNDJkxgMKjCbIDRJBbL1bxRFwVbiRjbuTXZOFJuTw
 N8FS7F4VdCsxqBkQwDWA==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need for the special cases for the cdrom ioctls any more now,
so make sure that each cdrom driver has a .compat_ioctl() callback and
calls cdrom_compat_ioctl() directly there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/compat_ioctl.c       | 45 --------------------------------------
 drivers/block/paride/pcd.c |  3 +++
 drivers/cdrom/gdrom.c      |  3 +++
 drivers/ide/ide-cd.c       | 37 +++++++++++++++++++++++++++++++
 drivers/scsi/sr.c          |  8 ++-----
 5 files changed, 45 insertions(+), 51 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 91a5dcf6e36c..e1c5d07b09e5 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -160,42 +160,6 @@ static int compat_blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
 	case HDIO_DRIVE_CMD:
 	/* 0x330 is reserved -- it used to be HDIO_GETGEO_BIG */
 	case 0x330:
-	/* CDROM stuff */
-	case CDROMPAUSE:
-	case CDROMRESUME:
-	case CDROMPLAYMSF:
-	case CDROMPLAYTRKIND:
-	case CDROMREADTOCHDR:
-	case CDROMREADTOCENTRY:
-	case CDROMSTOP:
-	case CDROMSTART:
-	case CDROMEJECT:
-	case CDROMVOLCTRL:
-	case CDROMSUBCHNL:
-	case CDROMMULTISESSION:
-	case CDROM_GET_MCN:
-	case CDROMRESET:
-	case CDROMVOLREAD:
-	case CDROMSEEK:
-	case CDROMPLAYBLK:
-	case CDROMCLOSETRAY:
-	case CDROM_DISC_STATUS:
-	case CDROM_CHANGER_NSLOTS:
-	case CDROM_GET_CAPABILITY:
-	case CDROM_SEND_PACKET:
-	/* Ignore cdrom.h about these next 5 ioctls, they absolutely do
-	 * not take a struct cdrom_read, instead they take a struct cdrom_msf
-	 * which is compatible.
-	 */
-	case CDROMREADMODE2:
-	case CDROMREADMODE1:
-	case CDROMREADRAW:
-	case CDROMREADCOOKED:
-	case CDROMREADALL:
-	/* DVD ioctls */
-	case DVD_READ_STRUCT:
-	case DVD_WRITE_STRUCT:
-	case DVD_AUTH:
 		arg = (unsigned long)compat_ptr(arg);
 	/* These intepret arg as an unsigned long, not as a pointer,
 	 * so we must not do compat_ptr() conversion. */
@@ -211,15 +175,6 @@ static int compat_blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
 	case HDIO_SET_ACOUSTIC:
 	case HDIO_SET_BUSSTATE:
 	case HDIO_SET_ADDRESS:
-	case CDROMEJECT_SW:
-	case CDROM_SET_OPTIONS:
-	case CDROM_CLEAR_OPTIONS:
-	case CDROM_SELECT_SPEED:
-	case CDROM_SELECT_DISC:
-	case CDROM_MEDIA_CHANGED:
-	case CDROM_DRIVE_STATUS:
-	case CDROM_LOCKDOOR:
-	case CDROM_DEBUG:
 		break;
 	default:
 		/* unknown ioctl number */
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 636bfea2de6f..117cfc8cd05a 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -275,6 +275,9 @@ static const struct block_device_operations pcd_bdops = {
 	.open		= pcd_block_open,
 	.release	= pcd_block_release,
 	.ioctl		= pcd_block_ioctl,
+#ifdef CONFIG_COMPAT
+	.ioctl		= blkdev_compat_ptr_ioctl,
+#endif
 	.check_events	= pcd_block_check_events,
 };
 
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 5b21dc421c94..886b2638c730 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -518,6 +518,9 @@ static const struct block_device_operations gdrom_bdops = {
 	.release		= gdrom_bdops_release,
 	.check_events		= gdrom_bdops_check_events,
 	.ioctl			= gdrom_bdops_ioctl,
+#ifdef CONFIG_COMPAT
+	.ioctl			= blkdev_compat_ptr_ioctl,
+#endif
 };
 
 static irqreturn_t gdrom_command_interrupt(int irq, void *dev_id)
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 9d117936bee1..e09b949a7c46 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -25,6 +25,7 @@
 
 #define IDECD_VERSION "5.00"
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -1710,6 +1711,39 @@ static int idecd_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+static int idecd_locked_compat_ioctl(struct block_device *bdev, fmode_t mode,
+			unsigned int cmd, unsigned long arg)
+{
+	struct cdrom_info *info = ide_drv_g(bdev->bd_disk, cdrom_info);
+	void __user *argp = compat_ptr(arg);
+	int err;
+
+	switch (cmd) {
+	case CDROMSETSPINDOWN:
+		return idecd_set_spindown(&info->devinfo, (unsigned long)argp);
+	case CDROMGETSPINDOWN:
+		return idecd_get_spindown(&info->devinfo, (unsigned long)argp);
+	default:
+		break;
+	}
+
+	return cdrom_ioctl(&info->devinfo, bdev, mode, cmd,
+			   (unsigned long)argp);
+}
+
+static int idecd_compat_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	mutex_lock(&ide_cd_mutex);
+	ret = idecd_locked_compat_ioctl(bdev, mode, cmd, arg);
+	mutex_unlock(&ide_cd_mutex);
+
+	return ret;
+}
+#endif
 
 static unsigned int idecd_check_events(struct gendisk *disk,
 				       unsigned int clearing)
@@ -1732,6 +1766,9 @@ static const struct block_device_operations idecd_ops = {
 	.open			= idecd_open,
 	.release		= idecd_release,
 	.ioctl			= idecd_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= idecd_compat_ioctl,
+#endif
 	.check_events		= idecd_check_events,
 	.revalidate_disk	= idecd_revalidate_disk
 };
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index f1e7aab00ce3..0fbb8fe6e521 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -628,12 +628,8 @@ static int sr_block_compat_ioctl(struct block_device *bdev, fmode_t mode, unsign
 		goto put;
 	}
 
-	/*
-	 * CDROM ioctls are handled in the block layer, but
-	 * do the scsi blk ioctls here.
-	 */
-	ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
-	if (ret != -ENOTTY)
+	ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, (unsigned long)argp);
+	if (ret != -ENOSYS)
 		goto put;
 
 	ret = scsi_compat_ioctl(sdev, cmd, argp);
-- 
2.20.0

