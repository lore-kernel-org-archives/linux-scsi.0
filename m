From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/2] usb-storage: Add new no_read_capacity_16 quirk
Date: Thu, 13 May 2010 17:27:56 +0200
Message-ID: <1273764476-4204-2-git-send-email-hdegoede@redhat.com>
References: <1273764476-4204-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.versatel.nl ([62.58.50.91]:36444 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756181Ab0EMP0i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2010 11:26:38 -0400
In-Reply-To: <1273764476-4204-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jelledejong@powercraft.nl, Hans de Goede <hdegoede@redhat.com>

Some Rockbox based mp4 players will crash when ever they see a
read_capacity_16 scsi command. So add a new US_FL which tells the
scsi sd driver to not issue any read_capacity_16 scsi commands.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/scsiglue.c     |    4 ++++
 drivers/usb/storage/unusual_devs.h |    3 ++-
 include/linux/usb_usual.h          |    4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 65d31f4..ee70c4b 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -210,6 +210,10 @@ static int slave_configure(struct scsi_device *sdev)
 		if (us->fflags & US_FL_CAPACITY_HEURISTICS)
 			sdev->guess_capacity = 1;
 
+		/* Some devices cannot handle READ_CAPACITY_16 */
+		if (us->fflags & US_FL_NO_READ_CAPACITY_16)
+			sdev->no_read_capacity_16 = 1;
+
 		/* assume SPC3 or latter devices support sense size > 18 */
 		if (sdev->scsi_level > SCSI_SPC_2)
 			us->fflags |= US_FL_SANE_SENSE;
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 56b3c08..e8f10fa 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -877,7 +877,8 @@ UNUSUAL_DEV(  0x071b, 0x3203, 0x0000, 0x0000,
 		"RockChip",
 		"MP3",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_NO_WP_DETECT | US_FL_MAX_SECTORS_64),
+		US_FL_NO_WP_DETECT | US_FL_MAX_SECTORS_64 |
+		US_FL_NO_READ_CAPACITY_16),
 
 /* Reported by Jean-Baptiste Onofre <jb@nanthrax.net>
  * Support the following product :
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index bff51d0..d4ee5b8 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -60,7 +60,9 @@
 	US_FLAG(BAD_SENSE,	0x00020000)			\
 		/* Bad Sense (never more than 18 bytes) */	\
 	US_FLAG(NO_READ_DISC_INFO,	0x00040000)		\
-		/* cannot handle READ_DISC_INFO */
+		/* cannot handle READ_DISC_INFO */		\
+	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
+		/* cannot handle READ_CAPACITY_16 */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
1.7.0.1

