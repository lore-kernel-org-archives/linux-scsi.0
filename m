From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 23/24] uas: Log error codes when logging errors
Date: Sat, 13 Sep 2014 12:26:50 +0200
Message-ID: <1410604011-3828-24-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 0b3d3a5..1dcaeee 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -750,7 +750,8 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 	usb_unlock_device(udev);
 
 	if (err) {
-		shost_printk(KERN_INFO, sdev->host, "%s FAILED\n", __func__);
+		shost_printk(KERN_INFO, sdev->host, "%s FAILED err %d\n",
+			     __func__, err);
 		return FAILED;
 	}
 
@@ -1020,13 +1021,16 @@ static int uas_post_reset(struct usb_interface *intf)
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
 	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
 	unsigned long flags;
+	int err;
 
 	if (devinfo->shutdown)
 		return 0;
 
-	if (uas_configure_endpoints(devinfo) != 0) {
+	err = uas_configure_endpoints(devinfo);
+	if (err) {
 		shost_printk(KERN_ERR, shost,
-			     "%s: alloc streams error after reset", __func__);
+			     "%s: alloc streams error %d after reset",
+			     __func__, err);
 		return 1;
 	}
 
@@ -1062,10 +1066,13 @@ static int uas_reset_resume(struct usb_interface *intf)
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
 	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
 	unsigned long flags;
+	int err;
 
-	if (uas_configure_endpoints(devinfo) != 0) {
+	err = uas_configure_endpoints(devinfo);
+	if (err) {
 		shost_printk(KERN_ERR, shost,
-			     "%s: alloc streams error after reset", __func__);
+			     "%s: alloc streams error %d after reset",
+			     __func__, err);
 		return -EIO;
 	}
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
