From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 3/4] usb: storage: adjust module reference for scsi host
Date: Sun, 11 Jan 2015 22:50:05 +0900
Message-ID: <1420984206-22341-4-git-send-email-akinobu.mita@gmail.com>
References: <1420984206-22341-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47532 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbAKNui (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jan 2015 08:50:38 -0500
In-Reply-To: <1420984206-22341-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

While accessing a unusual usb storage (ums-alauda, ums-cypress, ...),
the module reference count is not incremented.  Because these drivers
allocate scsi hosts with usb_stor_host_template defined in usb-storage
module.  So these drivers always can be unloaded.

This fixes it by passing correct module reference to usb_stor_probe1() so
that .module field in struct Scsi_Host can be adjusted.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
---
No change from v2

 drivers/usb/storage/usb.c | 8 +++++---
 drivers/usb/storage/usb.h | 7 +++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index d468d02..3bb2558 100644
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
@@ -937,6 +938,7 @@ int usb_stor_probe1(struct us_data **pus,
 	 */
 	host->max_cmd_len = 16;
 	host->sg_tablesize = usb_stor_sg_tablesize(intf);
+	host->module = owner;
 	*pus = us = host_to_us(host);
 	mutex_init(&(us->dev_mutex));
 	us_set_lock_class(&us->dev_mutex, intf);
@@ -969,7 +971,7 @@ BadDevice:
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

