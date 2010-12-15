From: matthew@wil.cx
Subject: [PATCH 4/5] uas: Ensure we only bind to a UAS interface
Date: Wed, 15 Dec 2010 15:44:05 -0500
Message-ID: <1292445846-12101-4-git-send-email-matthew@wil.cx>
References: <20101215204147.GA1263@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:25445 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755443Ab0LOUyY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2010 15:54:24 -0500
In-Reply-To: <20101215204147.GA1263@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

From: Matthew Wilcox <matthew@wil.cx>

While all existing UAS devices use alternate interface 1, this is not
guaranteed, and it has caused confusion with people trying to bind the
uas driver to non-uas devices.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/usb/storage/uas.c |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index f82787f..0ebe7f6 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -581,6 +581,34 @@ static struct usb_device_id uas_usb_ids[] = {
 };
 MODULE_DEVICE_TABLE(usb, uas_usb_ids);
 
+static int uas_is_interface(struct usb_host_interface *intf)
+{
+	return (intf->desc.bInterfaceClass == USB_CLASS_MASS_STORAGE &&
+		intf->desc.bInterfaceSubClass == USB_SC_SCSI &&
+		intf->desc.bInterfaceProtocol == USB_PR_UAS);
+}
+
+static int uas_switch_interface(struct usb_device *udev,
+						struct usb_interface *intf)
+{
+	int i;
+
+	if (uas_is_interface(intf->cur_altsetting))
+		return 0;
+
+	for (i = 0; i < intf->num_altsetting; i++) {
+		struct usb_host_interface *alt = &intf->altsetting[i];
+		if (alt == intf->cur_altsetting)
+			continue;
+		if (uas_is_interface(alt))
+			return usb_set_interface(udev,
+						alt->desc.bInterfaceNumber,
+						alt->desc.bAlternateSetting);
+	}
+
+	return -ENODEV;
+}
+
 static void uas_configure_endpoints(struct uas_dev_info *devinfo)
 {
 	struct usb_host_endpoint *eps[4] = { };
@@ -654,13 +682,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct uas_dev_info *devinfo;
 	struct usb_device *udev = interface_to_usbdev(intf);
 
-	if (id->bInterfaceProtocol == 0x50) {
-		int ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
-/* XXX: Shouldn't assume that 1 is the alternative we want */
-		int ret = usb_set_interface(udev, ifnum, 1);
-		if (ret)
-			return -ENODEV;
-	}
+	if (uas_switch_interface(udev, intf))
+		return -ENODEV;
 
 	devinfo = kmalloc(sizeof(struct uas_dev_info), GFP_KERNEL);
 	if (!devinfo)
-- 
1.7.2.3

