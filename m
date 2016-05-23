From: tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] uas: leave can_queue as MAX_CMNDS if device reports larger qdepth
Date: Tue, 24 May 2016 00:02:43 +0800
Message-ID: <574329ae.c726620a.60f3.ffffd14b@mx.google.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level") made
qdepth limit set in host template (`.can_queue = MAX_CMNDS`) useless.

Instead of removing the template limit, now we only change limit according
to the qdepth reported by the device if it is smaller than MAX_CMNDS.

Signed-off-by: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 4d49fce..d7790e6 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -972,7 +972,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 * 1 tag is reserved for untagged commands +
 	 * 1 tag to avoid off by one errors in some bridge firmwares
 	 */
-	shost->can_queue = devinfo->qdepth - 2;
+	if (devinfo->qdepth - 2 < MAX_CMNDS)
+		shost->can_queue = devinfo->qdepth - 2;
 
 	usb_set_intfdata(intf, shost);
 	result = scsi_add_host(shost, &intf->dev);
-- 
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
