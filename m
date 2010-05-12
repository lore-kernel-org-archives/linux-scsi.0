From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] scsi/sr: add no_read_disc_info scsi_device flag
Date: Wed, 12 May 2010 16:20:19 +0200
Message-ID: <1273674020-2364-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

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

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/sr.c          |    8 +++++++-
 include/scsi/scsi_device.h |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d6f340f..dcd7069 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -848,10 +848,16 @@ static void get_capabilities(struct scsi_cd *cd)
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

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
