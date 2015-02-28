From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5 3/4] usb: storage: adjust module reference for scsi host
Date: Sat, 28 Feb 2015 23:16:56 +0900
Message-ID: <1425133017-7216-4-git-send-email-akinobu.mita@gmail.com>
References: <1425133017-7216-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425133017-7216-1-git-send-email-akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

While accessing a unusual usb storage (ums-alauda, ums-cypress, ...),
the module reference count is not incremented.  Because these drivers
allocate scsi hosts with usb_stor_host_template defined in usb-storage
module.  So these drivers always can be unloaded.

This fixes it by passing correct module reference to usb_stor_probe1() so
that .module field in struct Scsi_Host can be adjusted.

Signed-off-by: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
No change from v3

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

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
