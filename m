From: Maarten Bressers <mbres@gentoo.org>
Subject: Re: [PATCH RESEND] SCSI not showing tray status correctly
Date: Sat, 27 Oct 2007 22:58:30 +0000 (UTC)
Message-ID: <20071027225830.585C8657DB@smtp.gentoo.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:57045 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXJ0W6b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Oct 2007 18:58:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, tasio@tasio.net, dsd@gentoo.org

> This patch is too simplistic.  ide-cd.c:ide_cdrom_drive_status() looks
> to be a reasonable implementation.  However, the worry is that
> GET_EVENT_NOTIFICATION is a MMC command; devices not conforming to MMC
> won't support it.  In theory, they should just return ILLEGAL_REQUEST,
> but USB devices have been known to crash when given commands they don't
> understand.  How widely tested has this been (if it's been in Gentoo
> since 2004, then it's probably widely tested enough)?
>
> James
>
This patch hasn't been tested at all, I'm sorry if I gave you that
impression, it isn't in Gentoo's patches, it's just been brought to our
attention in the bug I linked too.

I created another patch, based on your recommendations, and with a lot of
help from Daniel Drake (dsd@gentoo.org), that's included below. Some
changes are made to test_unit_ready() to be able to pass the sense data
to sr_drive_status(). Currently, sr_do_ioctl() swallows this data and
makes its own interpretations of sense codes, which isn't what we want
here.

Is this what you had in mind? Do you think the possible problems with
USB drives that you mentioned will prevent this patch from going in? 
The patch has only been compile tested right now, we can do some real
testing later, for now I'd just like to get your feedback on it.

Maarten

---

--- a/drivers/scsi/sr_ioctl.c	2007-10-26 22:40:41.000000000 +0200
+++ b/drivers/scsi/sr_ioctl.c	2007-10-27 23:56:16.000000000 +0200
@@ -275,16 +275,21 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 /* ---------------------------------------------------------------------- */
 /* interface to cdrom.c                                                   */
 
-static int test_unit_ready(Scsi_CD *cd)
+static int test_unit_ready(Scsi_CD *cd, struct request_sense *sense)
 {
-	struct packet_command cgc;
+	struct scsi_device *SDev = cd->device;
+	unsigned char cmd[CDROM_PACKET_SIZE] = { GPCMD_TEST_UNIT_READY };
+	int result;
 
-	memset(&cgc, 0, sizeof(struct packet_command));
-	cgc.cmd[0] = GPCMD_TEST_UNIT_READY;
-	cgc.quiet = 1;
-	cgc.data_direction = DMA_NONE;
-	cgc.timeout = IOCTL_TIMEOUT;
-	return sr_do_ioctl(cd, &cgc);
+	if (!scsi_block_when_processing_errors(SDev))
+		return -ENODEV;
+
+	memset(sense, 0, sizeof(*sense));
+	result = scsi_execute(SDev, cmd, DMA_NONE,
+			      NULL, 0, (char *)sense,
+			      IOCTL_TIMEOUT, IOCTL_RETRIES, 0);
+
+	return driver_byte(result);
 }
 
 int sr_tray_move(struct cdrom_device_info *cdi, int pos)
@@ -310,14 +315,41 @@ int sr_lock_door(struct cdrom_device_inf
 
 int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 {
+	struct request_sense sense;
+	struct media_event_desc med;
+
 	if (CDSL_CURRENT != slot) {
 		/* we have no changer support */
 		return -EINVAL;
 	}
-	if (0 == test_unit_ready(cdi->handle))
+	if ((0 == test_unit_ready(cdi->handle, &sense)) || 
+	    sense.sense_key == UNIT_ATTENTION)
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
+	if (sense.sense_key == NOT_READY && sense.asc == 0x04 && sense.ascq == 0x04)
+		return CDS_DISC_OK;
+
+	/*
+	 * If not using Mt Fuji extended media tray reports,
+	 * just return TRAY_OPEN since ATAPI doesn't provide
+	 * any other way to detect this...
+	 */
+	if (sense.sense_key == NOT_READY) {
+		if (sense.asc == 0x3a && sense.ascq == 1)
+			return CDS_NO_DISC;
+		else
+			return CDS_TRAY_OPEN;
+	}
+	return CDS_DRIVE_NOT_READY;
 }
 
 int sr_disk_status(struct cdrom_device_info *cdi)
