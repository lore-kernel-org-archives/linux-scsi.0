From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH resend 1/2] scsi/sd: Add a no_read_capacity_16 scsi_device flag
Date: Fri, 18 Jun 2010 14:38:29 +0200
Message-ID: <1276864710-2370-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-l3A5Bk7waGM@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

I know I know, I seem to have a nack for digging up buggy usb devices
which don't work with Linux, and I'm crazy enough to try to make them
work. So this time a friend of mine asked me to get an mp4 player (an
mp3 player which can play videos on a small screen) to work with Linux.

It is based on the well known rockbox chipset for which we already have
an unusual devs entries to work around some of its bugs. But this model
comes with an additional twist.

This model chokes on read_capacity_16 calls. Now normally we don't make
those calls, but this model comes with an sdcard slot and when there
is no card in there (and shipped from the factory there is none), it
reports a size of 0. However this time the programmers actually
got the read_capacity_10 response right! So they substract one from
the size as stored internally in the mp3 player before reporting it back,
resulting in an answer of ... 0xffffffff sectors, causing sd.c to
try a read_capacity_16, on which the device crashes.

This patch adds a flag to scsi_device to indicate that a a device cannot
handle read_capacity_16, and when this flag is set if a device reports
an lba of 0xffffffff as answer to a read_capacity_10, assumes it tries
to report a size of 0.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/sd.c          |   12 ++++++++++++
 include/scsi/scsi_device.h |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8802e48..1ad339b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1450,6 +1450,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	unsigned long long lba;
 	unsigned sector_size;
 
+	if (sdp->no_read_capacity_16)
+		return -EINVAL;
+
 	do {
 		memset(cmd, 0, 16);
 		cmd[0] = SERVICE_ACTION_IN;
@@ -1578,6 +1581,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	sector_size = get_unaligned_be32(&buffer[4]);
 	lba = get_unaligned_be32(&buffer[0]);
 
+	if (sdp->no_read_capacity_16 && (lba == 0xffffffff)) {
+		/* Some buggy (usb cardreader) devices return an lba of
+		   0xffffffff when the want to report a size of 0 (with
+		   which they really mean no media is present) */
+		sdkp->capacity = 0;
+		sdkp->hw_sector_size = sector_size;
+		return sector_size;
+	}
+
 	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e1b2db8..02bbbe5 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -149,6 +149,7 @@ struct scsi_device {
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
+	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
-- 
1.7.0.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
