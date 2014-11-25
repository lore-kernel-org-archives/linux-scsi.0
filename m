From: Tim Small <tim@seoss.co.uk>
Subject: [PATCH 1/4] enable cdrom_ioctl() to be called without holding ex-BKL mutexes
Date: Tue, 25 Nov 2014 14:09:19 +0000
Message-ID: <1416924562-16849-2-git-send-email-tim@seoss.co.uk>
References: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay0.allsecuredomains.com ([78.129.187.18]:59741 "EHLO
	relay0.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbaKYOxl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 09:53:41 -0500
In-Reply-To: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
In-Reply-To: <20141121100210.GC8866@infradead.org>
References: <20141121100210.GC8866@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tim@buttersideup.com, Christoph Hellwig <hch@infradead.org>
Cc: Tim Small <tim@seoss.co.uk>, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

Signed-off-by: Tim Small <tim@seoss.co.uk>
---
 drivers/cdrom/cdrom.c | 86 +++++++++++++++++++++++++++++++++++----------------
 include/linux/cdrom.h |  1 +
 2 files changed, 60 insertions(+), 27 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 5d28a45..c39bef1 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -633,6 +633,8 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	if (!cdo->generic_packet)
 		cdo->generic_packet = cdrom_dummy_generic_packet;
 
+	mutex_init(&cdi->ioctl_mutex);
+
 	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	mutex_lock(&cdrom_mutex);
 	list_add(&cdi->list, &cdrom_list);
@@ -3315,41 +3317,60 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 	if (ret != -ENOTTY)
 		return ret;
 
+	mutex_lock(&cdi->ioctl_mutex);
+
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
@@ -3361,7 +3382,7 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 	if (CDROM_CAN(CDC_GENERIC_PACKET)) {
 		ret = mmc_ioctl(cdi, cmd, arg);
 		if (ret != -ENOTTY)
-			return ret;
+			goto out;
 	}
 
 	/*
@@ -3371,27 +3392,38 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
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
+out:
+	mutex_unlock(&cdi->ioctl_mutex);
+	return ret;
 }
 
 EXPORT_SYMBOL(cdrom_get_last_written);
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 8609d57..954e659 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -40,6 +40,7 @@ struct cdrom_device_info {
 	struct list_head list;		/* linked list of all device_info */
 	struct gendisk *disk;		/* matching block layer disk */
 	void *handle;		        /* driver-dependent data */
+	struct mutex ioctl_mutex;	/* cdrom_ioctl_* not all thread safe */
 /* specifications */
 	int mask;                       /* mask of capability: disables them */
 	int speed;			/* maximum speed for reading data */
-- 
2.1.3

