From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH resend 1/2] scsi/sr: add no_read_disc_info scsi_device flag
Date: Thu, 17 Jun 2010 12:20:45 +0200
Message-ID: <1276770046-18868-2-git-send-email-hdegoede@redhat.com>
References: <1276770046-18868-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.versatel.nl ([62.58.50.96]:34092 "EHLO smtp5.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab0FQKS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 06:18:28 -0400
In-Reply-To: <1276770046-18868-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Some USB devices emulate a usb-mass-storage attached (scsi) cdrom device,
usually this fake cdrom contains the windows software for the device.
While working on supporting Appotech ax3003 based photoframes, which do
this I discovered that they will go of into lala land when ever they
see a READ_DISC_INFO scsi command.

Thus this patch adds a scsi_device flag (which can then be set by the
usb-storage driver through an unsual-devs entry), to indicate this, and
makes the sr driver honor this flag.

I know this sucks, but as discussed on linux-scsi list there is no other
way to make this device work properly.

Looking at usb traces made under windows, windows never sends a
READ_DISC_INFO during normal interactions with a usb cdrom device. So as
this cdrom emulation thingie becomes more common we might see more of
this problem.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/scsi/sr.c          |    8 +++++++-
 include/scsi/scsi_device.h |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0a90abc..18077b5 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -849,10 +849,16 @@ static void get_capabilities(struct scsi_cd *cd)
 static int sr_packet(struct cdrom_device_info *cdi,
 		struct packet_command *cgc)
 {
+	struct scsi_cd *cd = cdi->handle;
+	struct scsi_device *sdev = cd->device;
+
+	if (cgc->cmd[0] == GPCMD_READ_DISC_INFO && sdev->no_read_disc_info)
+		return -EDRIVE_CANT_DO_THIS;
+
 	if (cgc->timeout <= 0)
 		cgc->timeout = IOCTL_TIMEOUT;
 
-	sr_do_ioctl(cdi->handle, cgc);
+	sr_do_ioctl(cd, cgc);
 
 	return cgc->stat;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d80b6db..e1b2db8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -148,6 +148,7 @@ struct scsi_device {
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
+	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
-- 
1.7.0.1

