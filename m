From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 1/3] uas: Allow uas_use_uas_driver to return usb-storage flags
Date: Tue, 21 Apr 2015 11:20:30 +0200
Message-ID: <1429608032-6910-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Steve Bangert <sbangert@frontier.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

uas_use_uas_driver may set some US_FL_foo flags during detection, currently
these are stored in a local variable and then throw away, but these may be
of interest to the caller, so add an extra parameter to (optionally) return
the detected flags, and use this in the uas driver.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Add Cc stable@vger
---
 drivers/usb/storage/uas-detect.h | 6 +++++-
 drivers/usb/storage/uas.c        | 6 +++---
 drivers/usb/storage/usb.c        | 2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 9893d69..63ae161 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -51,7 +51,8 @@ static int uas_find_endpoints(struct usb_host_interface *alt,
 }
 
 static int uas_use_uas_driver(struct usb_interface *intf,
-			      const struct usb_device_id *id)
+			      const struct usb_device_id *id,
+			      unsigned long *flags_ret)
 {
 	struct usb_host_endpoint *eps[4] = { };
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -132,5 +133,8 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 		return 0;
 	}
 
+	if (flags_ret)
+		*flags_ret = flags;
+
 	return 1;
 }
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 6cdabdc..c6109c1 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -887,8 +887,9 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct Scsi_Host *shost = NULL;
 	struct uas_dev_info *devinfo;
 	struct usb_device *udev = interface_to_usbdev(intf);
+	unsigned long dev_flags;
 
-	if (!uas_use_uas_driver(intf, id))
+	if (!uas_use_uas_driver(intf, id, &dev_flags))
 		return -ENODEV;
 
 	if (uas_switch_interface(udev, intf))
@@ -910,8 +911,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	devinfo->udev = udev;
 	devinfo->resetting = 0;
 	devinfo->shutdown = 0;
-	devinfo->flags = id->driver_info;
-	usb_stor_adjust_quirks(udev, &devinfo->flags);
+	devinfo->flags = dev_flags;
 	init_usb_anchor(&devinfo->cmd_urbs);
 	init_usb_anchor(&devinfo->sense_urbs);
 	init_usb_anchor(&devinfo->data_urbs);
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 5600c33..db6f6b5 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -1080,7 +1080,7 @@ static int storage_probe(struct usb_interface *intf,
 
 	/* If uas is enabled and this device can do uas then ignore it. */
 #if IS_ENABLED(CONFIG_USB_UAS)
-	if (uas_use_uas_driver(intf, id))
+	if (uas_use_uas_driver(intf, id, NULL))
 		return -ENXIO;
 #endif
 
-- 
2.3.5
