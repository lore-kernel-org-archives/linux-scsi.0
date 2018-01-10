From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] uas: Unblock scsi-requests on failure to alloc streams in post_reset
Date: Wed, 10 Jan 2018 08:13:23 +0100
Message-ID: <20180110071323.3183-1-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

If we return 1 from our post_reset handler, then our disconnect handler
will be called immediately afterwards. Since pre_reset blocks all scsi
requests our disconnect handler will then hang in the scsi_remove_host
call.

This is esp. bad because our disconnect handler hanging for ever also
stops the USB subsys from enumerating any new USB devices, causes commands
like lsusb to hang, etc.

In practice this happens when unplugging some uas devices because the hub
code may see the device as needing a warm-reset and calls usb_reset_device
before seeing the disconnect. In this case uas_configure_endpoints fails
with -ENODEV. We do not want to print an error for this, so this commit
also silences the shost_printk for -ENODEV.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1531966
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: 8d51444cdd06 ("uas: Not being able to alloc streams ... is an error")
Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 5d04c40ee40a..5471422aa1ab 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1077,9 +1077,13 @@ static int uas_post_reset(struct usb_interface *intf)
 
 	err = uas_configure_endpoints(devinfo);
 	if (err) {
-		shost_printk(KERN_ERR, shost,
-			     "%s: alloc streams error %d after reset",
-			     __func__, err);
+		if (err != -ENODEV) {
+			shost_printk(KERN_ERR, shost,
+				     "%s: alloc streams error %d after reset",
+				     __func__, err);
+		}
+		/* So that scsi_remove_host in uas_disconnect does not hang */
+		scsi_unblock_requests(shost);
 		return 1;
 	}
 
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
