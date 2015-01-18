From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 09/11] usb: storage: adjust module reference for scsi host
Date: Mon, 19 Jan 2015 00:06:07 +0900
Message-ID: <1421593569-5089-10-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64648 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbARPHF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:07:05 -0500
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

The unusual usb storage drivers (ums-alauda, ums-cypress, ...) depend
on usb-storage module.  The module reference of these scsi host is
initialized to usb-storage's one.  Because these drivers use
usb_stor_probe1() which is defined in usb-storage module and calls
scsi_host_alloc().  So these drivers can be unloaded even if the scsi
device is being accessed.

This fixes it by converting usb_stor_probe1() into macro so that these
drivers can pass their correct module reference through
__scsi_host_alloc().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
---
 drivers/usb/storage/scsiglue.c | 3 ---
 drivers/usb/storage/usb.c      | 9 +++++----
 drivers/usb/storage/usb.h      | 7 +++++--
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 0e400f3..04fab36 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -587,9 +587,6 @@ struct scsi_host_template usb_stor_host_template = {
 
 	/* sysfs device attributes */
 	.sdev_attrs =			sysfs_device_attr_list,
-
-	/* module management */
-	.module =			THIS_MODULE
 };
 
 /* To Report "Illegal Request: Invalid Field in CDB */
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index d468d02..768413f0 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -911,10 +911,11 @@ static unsigned int usb_stor_sg_tablesize(struct usb_interface *intf)
 }
 
 /* First part of general USB mass-storage probing */
-int usb_stor_probe1(struct us_data **pus,
+int __usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
-		struct us_unusual_dev *unusual_dev)
+		struct us_unusual_dev *unusual_dev,
+		struct module *owner)
 {
 	struct Scsi_Host *host;
 	struct us_data *us;
@@ -926,7 +927,7 @@ int usb_stor_probe1(struct us_data **pus,
 	 * Ask the SCSI layer to allocate a host structure, with extra
 	 * space at the end for our private us_data structure.
 	 */
-	host = scsi_host_alloc(&usb_stor_host_template, sizeof(*us));
+	host = __scsi_host_alloc(&usb_stor_host_template, sizeof(*us), owner);
 	if (!host) {
 		dev_warn(&intf->dev, "Unable to allocate the scsi host\n");
 		return -ENOMEM;
@@ -969,7 +970,7 @@ BadDevice:
 	release_everything(us);
 	return result;
 }
-EXPORT_SYMBOL_GPL(usb_stor_probe1);
+EXPORT_SYMBOL_GPL(__usb_stor_probe1);
 
 /* Second part of general USB mass-storage probing */
 int usb_stor_probe2(struct us_data *us)
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index 307e339..0cb74ba 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -194,10 +194,13 @@ extern int usb_stor_reset_resume(struct usb_interface *iface);
 extern int usb_stor_pre_reset(struct usb_interface *iface);
 extern int usb_stor_post_reset(struct usb_interface *iface);
 
-extern int usb_stor_probe1(struct us_data **pus,
+extern int __usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
-		struct us_unusual_dev *unusual_dev);
+		struct us_unusual_dev *unusual_dev,
+		struct module *owner);
+#define usb_stor_probe1(pus, intf, id, unusual_dev) \
+	__usb_stor_probe1(pus, intf, id, unusual_dev, THIS_MODULE)
 extern int usb_stor_probe2(struct us_data *us);
 extern void usb_stor_disconnect(struct usb_interface *intf);
 
-- 
1.9.1

