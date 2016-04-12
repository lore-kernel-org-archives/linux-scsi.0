From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] USB: uas: Add a new NO_REPORT_LUNS quirk
Date: Tue, 12 Apr 2016 12:27:09 +0200
Message-ID: <1460456829-20933-2-git-send-email-hdegoede@redhat.com>
References: <1460456829-20933-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460456829-20933-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Webb <djw-8SE8IwxHpK9aa/9Udqfwiw@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add a new NO_REPORT_LUNS quirk and set it for Seagate drives with
an usb-id of: 0bc2:331a, as these will fail to respond to a
REPORT_LUNS command.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reported-and-tested-by: David Webb <djw-8SE8IwxHpK9aa/9Udqfwiw@public.gmane.org>
Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
Changes in v2:
-Document new j quirk in Documentation/kernel-parameters.txt
---
 Documentation/kernel-parameters.txt |  2 ++
 drivers/usb/storage/uas.c           | 14 +++++++++++++-
 drivers/usb/storage/unusual_uas.h   |  7 +++++++
 drivers/usb/storage/usb.c           |  5 ++++-
 include/linux/usb_usual.h           |  2 ++
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ecc74fa..0b3de80 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -4077,6 +4077,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					sector if the number is odd);
 				i = IGNORE_DEVICE (don't bind to this
 					device);
+				j = NO_REPORT_LUNS (don't use report luns
+					command, uas only);
 				l = NOT_LOCKABLE (don't try to lock and
 					unlock ejectable media);
 				m = MAX_SECTORS_64 (don't transfer more
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index b1ec749..16bc679 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -2,7 +2,7 @@
  * USB Attached SCSI
  * Note that this is not the same as the USB Mass Storage driver
  *
- * Copyright Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> for Red Hat, Inc. 2013 - 2014
+ * Copyright Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> for Red Hat, Inc. 2013 - 2016
  * Copyright Matthew Wilcox for Intel Corp, 2010
  * Copyright Sarah Sharp for Intel Corp, 2010
  *
@@ -781,6 +781,17 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 	return SUCCESS;
 }
 
+static int uas_target_alloc(struct scsi_target *starget)
+{
+	struct uas_dev_info *devinfo = (struct uas_dev_info *)
+			dev_to_shost(starget->dev.parent)->hostdata;
+
+	if (devinfo->flags & US_FL_NO_REPORT_LUNS)
+		starget->no_report_luns = 1;
+
+	return 0;
+}
+
 static int uas_slave_alloc(struct scsi_device *sdev)
 {
 	struct uas_dev_info *devinfo =
@@ -831,6 +842,7 @@ static struct scsi_host_template uas_host_template = {
 	.module = THIS_MODULE,
 	.name = "uas",
 	.queuecommand = uas_queuecommand,
+	.target_alloc = uas_target_alloc,
 	.slave_alloc = uas_slave_alloc,
 	.slave_configure = uas_slave_configure,
 	.eh_abort_handler = uas_eh_abort_handler,
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index ccc113e..53341a7 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -64,6 +64,13 @@ UNUSUAL_DEV(0x0bc2, 0x3312, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: David Webb <djw-8SE8IwxHpK9aa/9Udqfwiw@public.gmane.org> */
+UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
+		"Seagate",
+		"Expansion Desk",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_LUNS),
+
 /* Reported-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> */
 UNUSUAL_DEV(0x0bc2, 0x3320, 0x0000, 0x9999,
 		"Seagate",
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 43576ed..9de988a 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -482,7 +482,7 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 			US_FL_NO_READ_DISC_INFO | US_FL_NO_READ_CAPACITY_16 |
 			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
 			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
-			US_FL_MAX_SECTORS_240);
+			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS);
 
 	p = quirks;
 	while (*p) {
@@ -532,6 +532,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 		case 'i':
 			f |= US_FL_IGNORE_DEVICE;
 			break;
+		case 'j':
+			f |= US_FL_NO_REPORT_LUNS;
+			break;
 		case 'l':
 			f |= US_FL_NOT_LOCKABLE;
 			break;
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 7f5f78b..245f57d 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -79,6 +79,8 @@
 		/* Cannot handle MI_REPORT_SUPPORTED_OPERATION_CODES */	\
 	US_FLAG(MAX_SECTORS_240,	0x08000000)		\
 		/* Sets max_sectors to 240 */			\
+	US_FLAG(NO_REPORT_LUNS,	0x10000000)			\
+		/* Cannot handle REPORT_LUNS */			\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
2.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
