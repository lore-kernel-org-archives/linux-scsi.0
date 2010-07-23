From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH resend 3/4] scsi/sd: Add a no_read_capacity_16 scsi_device flag
Date: Fri, 23 Jul 2010 10:52:53 +0200
Message-ID: <1279875174-2905-3-git-send-email-hdegoede@redhat.com>
References: <1279875174-2905-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab0GWItu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 04:49:50 -0400
In-Reply-To: <1279875174-2905-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

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

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
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

