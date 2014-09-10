From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/21] uas: Fix resetting flag handling
Date: Wed, 10 Sep 2014 13:46:33 +0200
Message-ID: <1410349611-17573-4-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

- Make sure we always hold the lock when setting / checking resetting
- Check resetting before checking urb->status
- Add missing check for resetting to uas_data_cmplt
- Add missing check for resetting to uas_do_work

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 49 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 307658d..4f745a3 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -127,6 +127,10 @@ static void uas_do_work(struct work_struct *work)
 	int err;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
+
+	if (devinfo->resetting)
+		goto out;
+
 	list_for_each_entry(cmdinfo, &devinfo->inflight_list, list) {
 		struct scsi_pointer *scp = (void *)cmdinfo;
 		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
@@ -141,6 +145,7 @@ static void uas_do_work(struct work_struct *work)
 		else
 			schedule_work(&devinfo->work);
 	}
+out:
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
 
@@ -320,6 +325,11 @@ static void uas_stat_cmplt(struct urb *urb)
 	unsigned long flags;
 	u16 tag;
 
+	spin_lock_irqsave(&devinfo->lock, flags);
+
+	if (devinfo->resetting)
+		goto out;
+
 	if (urb->status) {
 		if (urb->status == -ENOENT) {
 			dev_err(&urb->dev->dev, "stat urb: killed, stream %d\n",
@@ -328,27 +338,17 @@ static void uas_stat_cmplt(struct urb *urb)
 			dev_err(&urb->dev->dev, "stat urb: status %d\n",
 				urb->status);
 		}
-		usb_free_urb(urb);
-		return;
-	}
-
-	if (devinfo->resetting) {
-		usb_free_urb(urb);
-		return;
+		goto out;
 	}
 
-	spin_lock_irqsave(&devinfo->lock, flags);
 	tag = be16_to_cpup(&iu->tag) - 1;
 	if (tag == 0)
 		cmnd = devinfo->cmnd;
 	else
 		cmnd = scsi_host_find_tag(shost, tag - 1);
 
-	if (!cmnd) {
-		usb_free_urb(urb);
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		return;
-	}
+	if (!cmnd)
+		goto out;
 
 	cmdinfo = (void *)&cmnd->SCp;
 	switch (iu->iu_id) {
@@ -389,6 +389,7 @@ static void uas_stat_cmplt(struct urb *urb)
 		scmd_printk(KERN_ERR, cmnd,
 			"Bogus IU (%d) received on status pipe\n", iu->iu_id);
 	}
+out:
 	usb_free_urb(urb);
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
@@ -402,6 +403,7 @@ static void uas_data_cmplt(struct urb *urb)
 	unsigned long flags;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
+
 	if (cmdinfo->data_in_urb == urb) {
 		sdb = scsi_in(cmnd);
 		cmdinfo->state &= ~DATA_IN_URB_INFLIGHT;
@@ -411,7 +413,13 @@ static void uas_data_cmplt(struct urb *urb)
 	}
 	if (sdb == NULL) {
 		WARN_ON_ONCE(1);
-	} else if (urb->status) {
+		goto out;
+	}
+
+	if (devinfo->resetting)
+		goto out;
+
+	if (urb->status) {
 		if (urb->status != -ECONNRESET) {
 			uas_log_cmd_state(cmnd, __func__);
 			scmd_printk(KERN_ERR, cmnd,
@@ -424,6 +432,7 @@ static void uas_data_cmplt(struct urb *urb)
 		sdb->resid = sdb->length - urb->actual_length;
 	}
 	uas_try_complete(cmnd, __func__);
+out:
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
 
@@ -721,6 +730,7 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 	struct scsi_device *sdev = cmnd->device;
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	struct usb_device *udev = devinfo->udev;
+	unsigned long flags;
 	int err;
 
 	err = usb_lock_device_for_reset(udev, devinfo->intf);
@@ -731,14 +741,21 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 	}
 
 	shost_printk(KERN_INFO, sdev->host, "%s start\n", __func__);
+
+	spin_lock_irqsave(&devinfo->lock, flags);
 	devinfo->resetting = 1;
+	spin_unlock_irqrestore(&devinfo->lock, flags);
+
 	uas_abort_inflight(devinfo, DID_RESET, __func__);
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
 	uas_zap_dead(devinfo);
 	err = usb_reset_device(udev);
+
+	spin_lock_irqsave(&devinfo->lock, flags);
 	devinfo->resetting = 0;
+	spin_unlock_irqrestore(&devinfo->lock, flags);
 
 	usb_unlock_device(udev);
 
@@ -1032,8 +1049,12 @@ static void uas_disconnect(struct usb_interface *intf)
 {
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
 	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
+	unsigned long flags;
 
+	spin_lock_irqsave(&devinfo->lock, flags);
 	devinfo->resetting = 1;
+	spin_unlock_irqrestore(&devinfo->lock, flags);
+
 	cancel_work_sync(&devinfo->work);
 	uas_abort_inflight(devinfo, DID_NO_CONNECT, __func__);
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
