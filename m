Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB316C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 20:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF6B2054F
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 20:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfLKUum (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 15:50:42 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:56963 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfLKUum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 15:50:42 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MLz7f-1iNCZv1Qiv-00HtOe; Wed, 11 Dec 2019 21:50:18 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 18/24] compat_ioctl: move cdrom commands into cdrom.c
Date:   Wed, 11 Dec 2019 21:42:52 +0100
Message-Id: <20191211204306.1207817-19-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191211204306.1207817-1-arnd@arndb.de>
References: <20191211204306.1207817-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:YCC/4Cjm3aDYhGrVvv4vw+/A3W06RkJIX2vxsyaBWOwABLnpSY0
 RA84rLENvr6GZ+SZrzgiGodaxTM+m2zHv3jC9nZ8PvrEgP8TU/0gCkO5D18uiAal4+0hFFX
 jiegrBrTxABAqlc+aLlM3EscQFWgbVf0ARY6eFMRjNjOwndlfTuEaI40MMv7h4v9UeeEbxl
 VP6Uq+ZvyoT7YYcZT9kjw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9xEE4g5+y1E=:Hp3/3rN4TA2XdTQ/ZzXAp4
 glzcY9TOBSffEXTuRYc+dcmHJcrbZ1Ab3/tuAZkfYu333ipdoJTFtSo6lNpNhw4crqPOdVqLN
 j9YyG25B9AFvowzc7CnNFLuuqoLimhcP6XpF1yHYBHGh34IxMThn6VFzdR4l4Lj2zPKRVhKCJ
 E6L5QZwADcGrpq1Eu6dULOLqU+3oSDvKHt7UtiqrTqi0edht+RxPSyuy0nF/EkBdC+5fJTech
 U/Snv0uPIaKE5ctkJC+gqh3DhM85vd0t9PGFy4sHDKTQ88N/QPnkQ4QoFBJrCXhqeir6Rrrn+
 L+2DLl4DYXaFjcQlPqiCtgYajpR+LyzAszZFeETOEpCXJo9uozCMFOfvyfksQiXPwtDn1Q5v5
 l3zsAgiBHMMR23H6Uzwtn8SuWQIUMlG0t65UDQIHn76EMu6r0ivfx0cUl8arB23+ejKyMJ6XR
 Y1MdzkFHwTGMi+MWNVyRY7yBkVPza6h6wBE0pfZitdd5ELziQbA3T9rgS1p51eZjee7DDQ2yT
 szzl3/5Nwbjtl+fKDwLeQM2uFkYNM9WzpWLsZ2c1jYYyxc32w7sKepB3Fp5V0vcqXOEZ/pSNT
 xnBnq0oxtC9mG+cLRI8JJIBoLbC446PHO/nRGNPYeY6LqswkFVXZE8Uli3sMNgocJEaVlBvdv
 jY71lV/obi6/1Gk6bhSftJ1ztMGw4ePxgEnfVBDoBN/IA4nqbwy7QXtjeUuOPqlg9iPlqtWvW
 BFruKHq0q3mTkhQyuAnYIFqeKBPLawr7DdtOXL/Br/Bq/JqZIdyLWjxKCRtaO+zhINgjy/W/O
 8HA4p80/KqA6pkRfIkbE2l7kclxzRZMo7EoNUuEaZuD+1w1OMvLgmE+5jejt0zE1D0ehy166M
 1XyCth261VtdB0xAEmow==
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
 drivers/ide/ide-cd.c       | 36 ++++++++++++++++++++++++++++++
 drivers/scsi/sr.c          | 10 +++------
 5 files changed, 45 insertions(+), 52 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index cf136bc2c9fc..7cb534d6e767 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -159,42 +159,6 @@ static int compat_blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
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
@@ -210,15 +174,6 @@ static int compat_blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
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
index 9d117936bee1..2de6e8ace957 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -25,6 +25,7 @@
 
 #define IDECD_VERSION "5.00"
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -1710,6 +1711,38 @@ static int idecd_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+static int idecd_locked_compat_ioctl(struct block_device *bdev, fmode_t mode,
+			unsigned int cmd, unsigned long arg)
+{
+	struct cdrom_info *info = ide_drv_g(bdev->bd_disk, cdrom_info);
+	int err;
+
+	switch (cmd) {
+	case CDROMSETSPINDOWN:
+		return idecd_set_spindown(&info->devinfo, arg);
+	case CDROMGETSPINDOWN:
+		return idecd_get_spindown(&info->devinfo, arg);
+	default:
+		break;
+	}
+
+	return cdrom_ioctl(&info->devinfo, bdev, mode, cmd,
+			   (unsigned long)compat_ptr(arg));
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
@@ -1732,6 +1765,9 @@ static const struct block_device_operations idecd_ops = {
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
index 6033a886c42c..0fbb8fe6e521 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -628,13 +628,9 @@ static int sr_block_compat_ioctl(struct block_device *bdev, fmode_t mode, unsign
 		goto put;
 	}
 
-	/*
-	 * CDROM ioctls are handled in the block layer, but
-	 * do the scsi blk ioctls here.
-	 */
-	ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
-	if (ret != -ENOTTY)
-		return ret;
+	ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, (unsigned long)argp);
+	if (ret != -ENOSYS)
+		goto put;
 
 	ret = scsi_compat_ioctl(sdev, cmd, argp);
 
-- 
2.20.0

