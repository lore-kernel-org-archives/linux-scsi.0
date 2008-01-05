From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] sr: update to follow tray status correctly
Date: Sat, 05 Jan 2008 10:39:51 -0600
Message-ID: <1199551191.3399.29.camel@localhost.localdomain>
References: <20071027225830.585C8657DB@smtp.gentoo.org>
	 <1193801523.3321.138.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52840 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766AbYAEQj5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 11:39:57 -0500
In-Reply-To: <1193801523.3321.138.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maarten Bressers <mbres@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, tasio@hierro.tasio.net, dsd@gentoo.org

It's been a while with no status on this one, so I corrected the patch
based on my original input.  The attached is what I think is the best
way of doing this (I've replaced the home grown test_unit_ready routine
with the SCSI one and updated some of the sense check conditions).

It seems to work for me.

James

---

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 57b5263..8f31b41 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -67,8 +67,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 
 #define SR_DISKS	256
 
-#define MAX_RETRIES	3
-#define SR_TIMEOUT	(30 * HZ)
 #define SR_CAPABILITIES \
 	(CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_SPEED| \
 	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 0d04e28..81fbc0b 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -20,6 +20,9 @@
 #include <linux/genhd.h>
 #include <linux/kref.h>
 
+#define MAX_RETRIES	3
+#define SR_TIMEOUT	(30 * HZ)
+
 struct scsi_device;
 
 /* The CDROM is fairly slow, so we need a little extra time */
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index e1589f9..d5cebff 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -275,18 +275,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 /* ---------------------------------------------------------------------- */
 /* interface to cdrom.c                                                   */
 
-static int test_unit_ready(Scsi_CD *cd)
-{
-	struct packet_command cgc;
-
-	memset(&cgc, 0, sizeof(struct packet_command));
-	cgc.cmd[0] = GPCMD_TEST_UNIT_READY;
-	cgc.quiet = 1;
-	cgc.data_direction = DMA_NONE;
-	cgc.timeout = IOCTL_TIMEOUT;
-	return sr_do_ioctl(cd, &cgc);
-}
-
 int sr_tray_move(struct cdrom_device_info *cdi, int pos)
 {
 	Scsi_CD *cd = cdi->handle;
@@ -310,14 +298,46 @@ int sr_lock_door(struct cdrom_device_info *cdi, int lock)
 
 int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 {
+	struct scsi_cd *cd = cdi->handle;
+	struct scsi_sense_hdr sshdr;
+	struct media_event_desc med;
+
 	if (CDSL_CURRENT != slot) {
 		/* we have no changer support */
 		return -EINVAL;
 	}
-	if (0 == test_unit_ready(cdi->handle))
+	if (0 == scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES,
+				      &sshdr))
 		return CDS_DISC_OK;
 
-	return CDS_TRAY_OPEN;
+	if (!cdrom_get_media_event(cdi, &med)) {
+		if (med.media_present)
+			return CDS_DISC_OK;
+		else if (med.door_open)
+			return CDS_TRAY_OPEN;
+		else
+			return CDS_NO_DISC;
+	}
+
+	/*
+	 * 0x04 is format in progress .. but there must be a disc present!
+	 */
+	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
+		return CDS_DISC_OK;
+
+	/*
+	 * If not using Mt Fuji extended media tray reports,
+	 * just return TRAY_OPEN since ATAPI doesn't provide
+	 * any other way to detect this...
+	 */
+	if (scsi_sense_valid(&sshdr) &&
+	    /* 0x3a is medium not present */
+	    sshdr.asc == 0x3a)
+		return CDS_NO_DISC;
+	else
+		return CDS_TRAY_OPEN;
+
+	return CDS_DRIVE_NOT_READY;
 }
 
 int sr_disk_status(struct cdrom_device_info *cdi)


