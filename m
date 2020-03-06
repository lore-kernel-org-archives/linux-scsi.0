Return-Path: <SRS0=edO9=4X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C25C10F00
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 22:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96057206CC
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 22:52:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="ZU68zGSF";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="ZU68zGSF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCFWwJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Mar 2020 17:52:09 -0500
Received: from chalk.uuid.uk ([51.68.227.198]:35564 "EHLO chalk.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgCFWwJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Mar 2020 17:52:09 -0500
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2020 17:52:06 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From;
        bh=8tysQjq6Lh4rgy4QnGUCDR1yabO2x5leChF7QgeoPEo=; b=ZU68zGSFzNhAT2bCygbOg2liE6
        BforBMIAWPh1dsuWbIzqhOqvMNAhdFRS1+r5ARGv/KBwb5Ox6oKMFN++cX/Vs6iIAmdV6dTTWmoMf
        H7q746z8TvkuNdUrRFp41Yp6BYqZe2KfXIVt59DgznI54McaKP2s3HxT5WcKFsc7AcGrjUb1lJjcP
        cqSUVWKZFi8qBootXjoKD0lCvaEdqyO/6uTXaKx0sHGtERezoXU/voy80rZbyodXTHEbV8rdRV1/H
        Dhb5RhucXcUppnHPS4zo6EP4WbAozH+h60YuuGZXw6+p7yBT/8hvKe7xISkujmdZBuN/t08wlcLtt
        Qa7Uk2Yw==;
Received: by chalk.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jALoz-0003fc-7d; Fri, 06 Mar 2020 22:52:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From;
        bh=8tysQjq6Lh4rgy4QnGUCDR1yabO2x5leChF7QgeoPEo=; b=ZU68zGSFzNhAT2bCygbOg2liE6
        BforBMIAWPh1dsuWbIzqhOqvMNAhdFRS1+r5ARGv/KBwb5Ox6oKMFN++cX/Vs6iIAmdV6dTTWmoMf
        H7q746z8TvkuNdUrRFp41Yp6BYqZe2KfXIVt59DgznI54McaKP2s3HxT5WcKFsc7AcGrjUb1lJjcP
        cqSUVWKZFi8qBootXjoKD0lCvaEdqyO/6uTXaKx0sHGtERezoXU/voy80rZbyodXTHEbV8rdRV1/H
        Dhb5RhucXcUppnHPS4zo6EP4WbAozH+h60YuuGZXw6+p7yBT/8hvKe7xISkujmdZBuN/t08wlcLtt
        Qa7Uk2Yw==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jALor-0000DO-NB; Fri, 06 Mar 2020 22:51:55 +0000
From:   Simon Arlott <simon@octiron.net>
Subject: [PATCH] cdrom: Convert per-driver mutexes to per-device mutexes
To:     Jens Axboe <axboe@kernel.dk>, Borislav Petkov <bp@alien8.de>,
        Tim Waugh <tim@cyberelk.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Merlijn B.W. Wajer" <merlijn@archive.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>
Message-ID: <6a92c33f-6766-fccd-57a9-ad39206b53ed@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Fri, 6 Mar 2020 22:51:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All of the users of cdrom_open/cdrom_ioctl/cdrom_release hold a per-driver
mutex while calling these functions. This hurts multi-drive performance
because all ioctls get processed consecutively.

Except for ide-cd ioctls, none of the other drivers need a mutex on
accesses so they can be removed.

Replace all of the per-driver mutexes with a per-device mutex in the
cdrom functions, allowing concurrent ioctls on different cdrom devices.

Add a per-device mutex to idecd_ioctl (which calls generic_ide_ioctl
before cdrom_ioctl).

Signed-off-by: Simon Arlott <simon@octiron.net>
---
This has been discussed previously for sr_mutex:
https://linux-scsi.vger.kernel.narkive.com/JLvupYok/patch-scsi-sr-fix-multi-drive-performance-by-using-per-device-mutexes
https://linux-scsi.vger.kernel.narkive.com/Ai2VaLJ3/sr-sr-mutex-multi-drive-performance-is-bad

There is currently a conflicting patch in next-20200306 that makes the
sr_mutex per-device:
https://lore.kernel.org/linux-scsi/20200218143918.30267-1-merlijn@archive.org/

I've tested this (sr only) with 4 PATA drives and 1 SATA drive on 2
separate IDE controllers (NVIDIA MCP55 and Promise 133 TX2). I've also
got another 3 SATA drives and 2 USB drives that I can test with.
---
 drivers/block/paride/pcd.c | 19 +-------
 drivers/cdrom/cdrom.c      | 96 ++++++++++++++++++++++++++------------
 drivers/cdrom/gdrom.c      | 19 +-------
 drivers/ide/ide-cd.c       | 19 ++++----
 drivers/ide/ide-cd.h       |  2 +
 drivers/scsi/sr.c          | 10 ----
 include/linux/cdrom.h      |  2 +
 7 files changed, 85 insertions(+), 82 deletions(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 117cfc8cd05a..42ef454e089d 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -138,10 +138,8 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV, D_DLY};
 #include <linux/cdrom.h>
 #include <linux/spinlock.h>
 #include <linux/blk-mq.h>
-#include <linux/mutex.h>
 #include <linux/uaccess.h>
 
-static DEFINE_MUTEX(pcd_mutex);
 static DEFINE_SPINLOCK(pcd_lock);
 
 module_param(verbose, int, 0644);
@@ -231,36 +229,23 @@ static void *par_drv;		/* reference of parport driver */
 static int pcd_block_open(struct block_device *bdev, fmode_t mode)
 {
 	struct pcd_unit *cd = bdev->bd_disk->private_data;
-	int ret;
 
 	check_disk_change(bdev);
 
-	mutex_lock(&pcd_mutex);
-	ret = cdrom_open(&cd->info, bdev, mode);
-	mutex_unlock(&pcd_mutex);
-
-	return ret;
+	return cdrom_open(&cd->info, bdev, mode);
 }
 
 static void pcd_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct pcd_unit *cd = disk->private_data;
-	mutex_lock(&pcd_mutex);
 	cdrom_release(&cd->info, mode);
-	mutex_unlock(&pcd_mutex);
 }
 
 static int pcd_block_ioctl(struct block_device *bdev, fmode_t mode,
 				unsigned cmd, unsigned long arg)
 {
 	struct pcd_unit *cd = bdev->bd_disk->private_data;
-	int ret;
-
-	mutex_lock(&pcd_mutex);
-	ret = cdrom_ioctl(&cd->info, bdev, mode, cmd, arg);
-	mutex_unlock(&pcd_mutex);
-
-	return ret;
+	return cdrom_ioctl(&cd->info, bdev, mode, cmd, arg);
 }
 
 static unsigned int pcd_block_check_events(struct gendisk *disk,
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index faca0f346fff..8c48541ba6ac 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -601,6 +601,8 @@ int register_cdrom(struct cdrom_device_info *cdi)
 		cdrom_sysctl_register();
 	}
 
+	mutex_init(&cdi->lock);
+
 	ENSURE(cdo, drive_status, CDC_DRIVE_STATUS);
 	if (cdo->check_events == NULL && cdo->media_changed == NULL)
 		WARN_ON_ONCE(cdo->capability & (CDC_MEDIA_CHANGED | CDC_SELECT_DISC));
@@ -653,6 +655,7 @@ void unregister_cdrom(struct cdrom_device_info *cdi)
 		cdi->exit(cdi);
 
 	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
+	mutex_destroy(&cdi->lock);
 }
 
 int cdrom_get_media_event(struct cdrom_device_info *cdi,
@@ -1159,6 +1162,7 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
 
 	cd_dbg(CD_OPEN, "entering cdrom_open\n");
 
+	mutex_lock(&cdi->lock);
 	/* if this was a O_NONBLOCK open and we should honor the flags,
 	 * do a quick open without drive/disc integrity checks. */
 	cdi->use_count++;
@@ -1186,7 +1190,7 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
 
 	cd_dbg(CD_OPEN, "Use count for \"/dev/%s\" now %d\n",
 	       cdi->name, cdi->use_count);
-	return 0;
+	goto out;
 err_release:
 	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
 		cdi->ops->lock_door(cdi, 0);
@@ -1195,6 +1199,8 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
 	cdi->ops->release(cdi);
 err:
 	cdi->use_count--;
+out:
+	mutex_unlock(&cdi->lock);
 	return ret;
 }
 
@@ -1262,6 +1268,7 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 
 	cd_dbg(CD_CLOSE, "entering cdrom_release\n");
 
+	mutex_lock(&cdi->lock);
 	if (cdi->use_count > 0)
 		cdi->use_count--;
 
@@ -1291,6 +1298,7 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 		    cdi->options & CDO_AUTO_EJECT && CDROM_CAN(CDC_OPEN_TRAY))
 			cdo->tray_move(cdi, 1);
 	}
+	mutex_unlock(&cdi->lock);
 }
 
 static int cdrom_read_mech_status(struct cdrom_device_info *cdi, 
@@ -3355,48 +3363,66 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
+	mutex_lock(&cdi->lock);
 	/*
 	 * Try the generic SCSI command ioctl's first.
 	 */
 	ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
 	if (ret != -ENOTTY)
-		return ret;
+		goto out;
 
 	switch (cmd) {
 	case CDROMMULTISESSION:
-		return cdrom_ioctl_multisession(cdi, argp);
+		ret = cdrom_ioctl_multisession(cdi, argp);
+		goto out;
 	case CDROMEJECT:
-		return cdrom_ioctl_eject(cdi);
+		ret = cdrom_ioctl_eject(cdi);
+		goto out;
 	case CDROMCLOSETRAY:
-		return cdrom_ioctl_closetray(cdi);
+		ret = cdrom_ioctl_closetray(cdi);
+		goto out;
 	case CDROMEJECT_SW:
-		return cdrom_ioctl_eject_sw(cdi, arg);
+		ret = cdrom_ioctl_eject_sw(cdi, arg);
+		goto out;
 	case CDROM_MEDIA_CHANGED:
-		return cdrom_ioctl_media_changed(cdi, arg);
+		ret = cdrom_ioctl_media_changed(cdi, arg);
+		goto out;
 	case CDROM_SET_OPTIONS:
-		return cdrom_ioctl_set_options(cdi, arg);
+		ret = cdrom_ioctl_set_options(cdi, arg);
+		goto out;
 	case CDROM_CLEAR_OPTIONS:
-		return cdrom_ioctl_clear_options(cdi, arg);
+		ret = cdrom_ioctl_clear_options(cdi, arg);
+		goto out;
 	case CDROM_SELECT_SPEED:
-		return cdrom_ioctl_select_speed(cdi, arg);
+		ret = cdrom_ioctl_select_speed(cdi, arg);
+		goto out;
 	case CDROM_SELECT_DISC:
-		return cdrom_ioctl_select_disc(cdi, arg);
+		ret = cdrom_ioctl_select_disc(cdi, arg);
+		goto out;
 	case CDROMRESET:
-		return cdrom_ioctl_reset(cdi, bdev);
+		ret = cdrom_ioctl_reset(cdi, bdev);
+		goto out;
 	case CDROM_LOCKDOOR:
-		return cdrom_ioctl_lock_door(cdi, arg);
+		ret = cdrom_ioctl_lock_door(cdi, arg);
+		goto out;
 	case CDROM_DEBUG:
-		return cdrom_ioctl_debug(cdi, arg);
+		ret = cdrom_ioctl_debug(cdi, arg);
+		goto out;
 	case CDROM_GET_CAPABILITY:
-		return cdrom_ioctl_get_capability(cdi);
+		ret = cdrom_ioctl_get_capability(cdi);
+		goto out;
 	case CDROM_GET_MCN:
-		return cdrom_ioctl_get_mcn(cdi, argp);
+		ret = cdrom_ioctl_get_mcn(cdi, argp);
+		goto out;
 	case CDROM_DRIVE_STATUS:
-		return cdrom_ioctl_drive_status(cdi, arg);
+		ret = cdrom_ioctl_drive_status(cdi, arg);
+		goto out;
 	case CDROM_DISC_STATUS:
-		return cdrom_ioctl_disc_status(cdi);
+		ret = cdrom_ioctl_disc_status(cdi);
+		goto out;
 	case CDROM_CHANGER_NSLOTS:
-		return cdrom_ioctl_changer_nslots(cdi);
+		ret = cdrom_ioctl_changer_nslots(cdi);
+		goto out;
 	}
 
 	/*
@@ -3408,7 +3434,7 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 	if (CDROM_CAN(CDC_GENERIC_PACKET)) {
 		ret = mmc_ioctl(cdi, cmd, arg);
 		if (ret != -ENOTTY)
-			return ret;
+			goto out;
 	}
 
 	/*
@@ -3418,27 +3444,39 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 	 */
 	switch (cmd) {
 	case CDROMSUBCHNL:
-		return cdrom_ioctl_get_subchnl(cdi, argp);
+		ret = cdrom_ioctl_get_subchnl(cdi, argp);
+		goto out;
 	case CDROMREADTOCHDR:
-		return cdrom_ioctl_read_tochdr(cdi, argp);
+		ret = cdrom_ioctl_read_tochdr(cdi, argp);
+		goto out;
 	case CDROMREADTOCENTRY:
-		return cdrom_ioctl_read_tocentry(cdi, argp);
+		ret = cdrom_ioctl_read_tocentry(cdi, argp);
+		goto out;
 	case CDROMPLAYMSF:
-		return cdrom_ioctl_play_msf(cdi, argp);
+		ret = cdrom_ioctl_play_msf(cdi, argp);
+		goto out;
 	case CDROMPLAYTRKIND:
-		return cdrom_ioctl_play_trkind(cdi, argp);
+		ret = cdrom_ioctl_play_trkind(cdi, argp);
+		goto out;
 	case CDROMVOLCTRL:
-		return cdrom_ioctl_volctrl(cdi, argp);
+		ret = cdrom_ioctl_volctrl(cdi, argp);
+		goto out;
 	case CDROMVOLREAD:
-		return cdrom_ioctl_volread(cdi, argp);
+		ret = cdrom_ioctl_volread(cdi, argp);
+		goto out;
 	case CDROMSTART:
 	case CDROMSTOP:
 	case CDROMPAUSE:
 	case CDROMRESUME:
-		return cdrom_ioctl_audioctl(cdi, cmd);
+		ret = cdrom_ioctl_audioctl(cdi, cmd);
+		goto out;
 	}
 
-	return -ENOSYS;
+	ret = -ENOSYS;
+
+out:
+	mutex_unlock(&cdi->lock);
+	return ret;
 }
 
 EXPORT_SYMBOL(cdrom_get_last_written);
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 886b2638c730..e333fe755deb 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -20,7 +20,6 @@
 #include <linux/blk-mq.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
-#include <linux/mutex.h>
 #include <linux/wait.h>
 #include <linux/platform_device.h>
 #include <scsi/scsi.h>
@@ -66,7 +65,6 @@
 
 #define GDROM_DEFAULT_TIMEOUT	(HZ * 7)
 
-static DEFINE_MUTEX(gdrom_mutex);
 static const struct {
 	int sense_key;
 	const char * const text;
@@ -477,21 +475,14 @@ static const struct cdrom_device_ops gdrom_ops = {
 
 static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
 {
-	int ret;
-
 	check_disk_change(bdev);
 
-	mutex_lock(&gdrom_mutex);
-	ret = cdrom_open(gd.cd_info, bdev, mode);
-	mutex_unlock(&gdrom_mutex);
-	return ret;
+	return cdrom_open(gd.cd_info, bdev, mode);
 }
 
 static void gdrom_bdops_release(struct gendisk *disk, fmode_t mode)
 {
-	mutex_lock(&gdrom_mutex);
 	cdrom_release(gd.cd_info, mode);
-	mutex_unlock(&gdrom_mutex);
 }
 
 static unsigned int gdrom_bdops_check_events(struct gendisk *disk,
@@ -503,13 +494,7 @@ static unsigned int gdrom_bdops_check_events(struct gendisk *disk,
 static int gdrom_bdops_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned cmd, unsigned long arg)
 {
-	int ret;
-
-	mutex_lock(&gdrom_mutex);
-	ret = cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
-	mutex_unlock(&gdrom_mutex);
-
-	return ret;
+	return cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
 }
 
 static const struct block_device_operations gdrom_bdops = {
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index dcf8b51b47fd..20c46d67eb38 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -52,7 +52,6 @@
 
 #include "ide-cd.h"
 
-static DEFINE_MUTEX(ide_cd_mutex);
 static DEFINE_MUTEX(idecd_ref_mutex);
 
 static void ide_cd_release(struct device *);
@@ -1586,6 +1585,7 @@ static void ide_cd_release(struct device *dev)
 	drive->prep_rq = NULL;
 	g->private_data = NULL;
 	put_disk(g);
+	mutex_destroy(&info->ioctl_lock);
 	kfree(info);
 }
 
@@ -1614,7 +1614,6 @@ static int idecd_open(struct block_device *bdev, fmode_t mode)
 
 	check_disk_change(bdev);
 
-	mutex_lock(&ide_cd_mutex);
 	info = ide_cd_get(bdev->bd_disk);
 	if (!info)
 		goto out;
@@ -1623,7 +1622,6 @@ static int idecd_open(struct block_device *bdev, fmode_t mode)
 	if (rc < 0)
 		ide_cd_put(info);
 out:
-	mutex_unlock(&ide_cd_mutex);
 	return rc;
 }
 
@@ -1631,11 +1629,9 @@ static void idecd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
 
-	mutex_lock(&ide_cd_mutex);
 	cdrom_release(&info->devinfo, mode);
 
 	ide_cd_put(info);
-	mutex_unlock(&ide_cd_mutex);
 }
 
 static int idecd_set_spindown(struct cdrom_device_info *cdi, unsigned long arg)
@@ -1702,11 +1698,12 @@ static int idecd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 static int idecd_ioctl(struct block_device *bdev, fmode_t mode,
 			     unsigned int cmd, unsigned long arg)
 {
+	struct cdrom_info *info = ide_drv_g(bdev->bd_disk, cdrom_info);
 	int ret;
 
-	mutex_lock(&ide_cd_mutex);
+	mutex_lock(&info->ioctl_lock);
 	ret = idecd_locked_ioctl(bdev, mode, cmd, arg);
-	mutex_unlock(&ide_cd_mutex);
+	mutex_unlock(&info->ioctl_lock);
 
 	return ret;
 }
@@ -1738,11 +1735,12 @@ static int idecd_locked_compat_ioctl(struct block_device *bdev, fmode_t mode,
 static int idecd_compat_ioctl(struct block_device *bdev, fmode_t mode,
 			     unsigned int cmd, unsigned long arg)
 {
+	struct cdrom_info *info = ide_drv_g(bdev->bd_disk, cdrom_info);
 	int ret;
 
-	mutex_lock(&ide_cd_mutex);
+	mutex_lock(&info->ioctl_lock);
 	ret = idecd_locked_compat_ioctl(bdev, mode, cmd, arg);
-	mutex_unlock(&ide_cd_mutex);
+	mutex_unlock(&info->ioctl_lock);
 
 	return ret;
 }
@@ -1804,6 +1802,8 @@ static int ide_cd_probe(ide_drive_t *drive)
 		goto failed;
 	}
 
+	mutex_init(&info->ioctl_lock);
+
 	g = alloc_disk(1 << PARTN_BITS);
 	if (!g)
 		goto out_free_cd;
@@ -1842,6 +1842,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 out_free_disk:
 	put_disk(g);
 out_free_cd:
+	mutex_destroy(&info->ioctl_lock);
 	kfree(info);
 failed:
 	return -ENODEV;
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index a69dc7f61c4d..93af8a8bc91f 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -7,6 +7,7 @@
 #define _IDE_CD_H
 
 #include <linux/cdrom.h>
+#include <linux/mutex.h>
 #include <asm/byteorder.h>
 
 #define IDECD_DEBUG_LOG		0
@@ -78,6 +79,7 @@ struct cdrom_info {
 	struct ide_driver	*driver;
 	struct gendisk		*disk;
 	struct device		dev;
+	struct mutex		ioctl_lock;
 
 	/* Buffer for table of contents.  NULL if we haven't allocated
 	   a TOC buffer for this device yet. */
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0fbb8fe6e521..88b43d8d6863 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -46,7 +46,6 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/blk-pm.h>
-#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/uaccess.h>
@@ -79,7 +78,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
 	 CDC_MRW|CDC_MRW_W|CDC_RAM)
 
-static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt);
@@ -536,9 +534,7 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 	scsi_autopm_get_device(sdev);
 	check_disk_change(bdev);
 
-	mutex_lock(&sr_mutex);
 	ret = cdrom_open(&cd->cdi, bdev, mode);
-	mutex_unlock(&sr_mutex);
 
 	scsi_autopm_put_device(sdev);
 	if (ret)
@@ -551,10 +547,8 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 static void sr_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	mutex_lock(&sr_mutex);
 	cdrom_release(&cd->cdi, mode);
 	scsi_cd_put(cd);
-	mutex_unlock(&sr_mutex);
 }
 
 static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
@@ -565,7 +559,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	mutex_lock(&sr_mutex);
 
 	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
 			(mode & FMODE_NDELAY) != 0);
@@ -595,7 +588,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	scsi_autopm_put_device(sdev);
 
 out:
-	mutex_unlock(&sr_mutex);
 	return ret;
 }
 
@@ -608,7 +600,6 @@ static int sr_block_compat_ioctl(struct block_device *bdev, fmode_t mode, unsign
 	void __user *argp = compat_ptr(arg);
 	int ret;
 
-	mutex_lock(&sr_mutex);
 
 	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
 			(mode & FMODE_NDELAY) != 0);
@@ -638,7 +629,6 @@ static int sr_block_compat_ioctl(struct block_device *bdev, fmode_t mode, unsign
 	scsi_autopm_put_device(sdev);
 
 out:
-	mutex_unlock(&sr_mutex);
 	return ret;
 
 }
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 528271c60018..eb6c4de7006d 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -13,6 +13,7 @@
 
 #include <linux/fs.h>		/* not really needed, later.. */
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <scsi/scsi_common.h>
 #include <uapi/linux/cdrom.h>
 
@@ -41,6 +42,7 @@ struct cdrom_device_info {
 	const struct cdrom_device_ops *ops; /* link to device_ops */
 	struct list_head list;		/* linked list of all device_info */
 	struct gendisk *disk;		/* matching block layer disk */
+	struct mutex lock;
 	void *handle;		        /* driver-dependent data */
 /* specifications */
 	int mask;                       /* mask of capability: disables them */
-- 
2.17.1

-- 
Simon Arlott
