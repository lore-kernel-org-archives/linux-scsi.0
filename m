From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] usb-storage: Add new no_read_disc_info quirk
Date: Wed, 12 May 2010 16:20:20 +0200
Message-ID: <1273674020-2364-2-git-send-email-hdegoede@redhat.com>
References: <1273674020-2364-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1273674020-2364-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Appotech ax3003 (the larger brother of the ax203) based devices are even
more buggy then the ax203. They will go of into lala land when ever they
see a READ_DISC_INFO scsi command. So add a new US_FL which tells the
scsi sr driver to not issue any READ_DISC_INFO scsi commands.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/scsiglue.c     |    4 ++++
 drivers/usb/storage/unusual_devs.h |    5 +++++
 include/linux/usb_usual.h          |    4 +++-
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 4cc0355..65d31f4 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -254,6 +254,10 @@ static int slave_configure(struct scsi_device *sdev)
 		 * or to force 192-byte transfer lengths for MODE SENSE.
 		 * But they do need to use MODE SENSE(10). */
 		sdev->use_10_for_ms = 1;
+
+		/* Some (fake) usb cdrom devices don't like READ_DISC_INFO */
+		if (us->fflags & US_FL_NO_READ_DISC_INFO)
+			sdev->no_read_disc_info = 1;
 	}
 
 	/* The CB and CBI transports have no way to pass LUN values
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 391ccc8..56b3c08 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1872,6 +1872,11 @@ UNUSUAL_DEV( 0x1908, 0x1320, 0x0000, 0x0000,
 		"Photo Frame",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_BAD_SENSE ),
+UNUSUAL_DEV( 0x1908, 0x3335, 0x0200, 0x0200,
+		"BUILDWIN",
+		"Photo Frame",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_NO_READ_DISC_INFO ),
 
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index a4b947e..bff51d0 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -58,7 +58,9 @@
 	US_FLAG(CAPACITY_OK,	0x00010000)			\
 		/* READ CAPACITY response is correct */		\
 	US_FLAG(BAD_SENSE,	0x00020000)			\
-		/* Bad Sense (never more than 18 bytes) */
+		/* Bad Sense (never more than 18 bytes) */	\
+	US_FLAG(NO_READ_DISC_INFO,	0x00040000)		\
+		/* cannot handle READ_DISC_INFO */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
1.7.0.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
