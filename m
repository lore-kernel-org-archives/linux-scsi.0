From: Tim Small <tim@seoss.co.uk>
Subject: [PATCH 4/4] Remove ex-BKL lock from ioctl path; fix simultaneous record on >1 drive
Date: Tue, 25 Nov 2014 14:09:22 +0000
Message-ID: <1416924562-16849-5-git-send-email-tim@seoss.co.uk>
References: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay0.allsecuredomains.com ([78.129.187.18]:56638 "EHLO
	relay0.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbaKYOxo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 09:53:44 -0500
In-Reply-To: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
In-Reply-To: <20141121100210.GC8866@infradead.org>
References: <20141121100210.GC8866@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tim@buttersideup.com, Christoph Hellwig <hch@infradead.org>
Cc: Tim Small <tim@seoss.co.uk>, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

Signed-off-by: Tim Small <tim@seoss.co.uk>
---
 drivers/ide/ide-cd.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 0b510ba..946d458 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1656,37 +1656,33 @@ static int idecd_get_spindown(struct cdrom_device_info *cdi, unsigned long arg)
 	return 0;
 }
 
-static int idecd_locked_ioctl(struct block_device *bdev, fmode_t mode,
-			unsigned int cmd, unsigned long arg)
-{
-	struct cdrom_info *info = ide_drv_g(bdev->bd_disk, cdrom_info);
-	int err;
-
-	switch (cmd) {
-	case CDROMSETSPINDOWN:
-		return idecd_set_spindown(&info->devinfo, arg);
-	case CDROMGETSPINDOWN:
-		return idecd_get_spindown(&info->devinfo, arg);
-	default:
-		break;
-	}
-
-	err = generic_ide_ioctl(info->drive, bdev, cmd, arg);
-	if (err == -EINVAL)
-		err = cdrom_ioctl(&info->devinfo, bdev, mode, cmd, arg);
-
-	return err;
-}
-
 static int idecd_ioctl(struct block_device *bdev, fmode_t mode,
 			     unsigned int cmd, unsigned long arg)
 {
+	struct cdrom_info *info;
 	int ret;
 
 	mutex_lock(&ide_cd_mutex);
-	ret = idecd_locked_ioctl(bdev, mode, cmd, arg);
+	info = ide_drv_g(bdev->bd_disk, cdrom_info);
+
+	switch (cmd) {
+	case CDROMSETSPINDOWN:
+		ret = idecd_set_spindown(&info->devinfo, arg);
+		goto outunlock;
+	case CDROMGETSPINDOWN:
+		ret = idecd_get_spindown(&info->devinfo, arg);
+		goto outunlock;
+	}
+
+	ret = generic_ide_ioctl(info->drive, bdev, cmd, arg);
+	if (ret != -EINVAL)
+		goto outunlock;
+
 	mutex_unlock(&ide_cd_mutex);
+	return cdrom_ioctl(&info->devinfo, bdev, mode, cmd, arg);
 
+outunlock:
+	mutex_unlock(&ide_cd_mutex);
 	return ret;
 }
 
-- 
2.1.3

