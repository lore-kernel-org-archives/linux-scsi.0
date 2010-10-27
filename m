From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
Date: Wed, 27 Oct 2010 13:22:22 -0700 (PDT)
Message-ID: <628096.54960.qm@web31807.mail.mud.yahoo.com>
Reply-To: ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

"Be conservative in what you send, liberal in what
you accept." -- In the spirit of this adage, don't
send Command IUs with randomly filled in data in
the reserved fields. (Yes, this shows up on the
wire.)

Signed-off-by: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
---
 drivers/usb/storage/uas.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2054b1e..17e1820 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -294,7 +294,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	if (!urb)
 		goto out;
 
-	iu = kmalloc(sizeof(*iu), gfp);
+	iu = kzalloc(sizeof(*iu), gfp);
 	if (!iu)
 		goto free;
 
@@ -325,7 +325,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	if (len < 0)
 		len = 0;
 	len = ALIGN(len, 4);
-	iu = kmalloc(sizeof(*iu) + len, gfp);
+	iu = kzalloc(sizeof(*iu) + len, gfp);
 	if (!iu)
 		goto free;
 
@@ -660,7 +660,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 			return -ENODEV;
 	}
 
-	devinfo = kmalloc(sizeof(struct uas_dev_info), GFP_KERNEL);
+	devinfo = kzalloc(sizeof(struct uas_dev_info), GFP_KERNEL);
 	if (!devinfo)
 		return -ENOMEM;
 
-- 
1.7.0.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
