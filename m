From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 15/21] uas: pre_reset and suspend: Fix a few races
Date: Wed, 10 Sep 2014 13:46:45 +0200
Message-ID: <1410349611-17573-16-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

The purpose of uas_pre_reset is to:

1) Stop any new commands from being submitted while an externally triggered
   usb-device-reset is running
2) Wait for any pending commands to finish before allowing the usb-device-reset
   to continue

The purpose of uas_suspend is to:
2) Wait for any pending commands to finish before suspending

This commit fixes races in both paths:

1) For 1) we use scsi_block_requests, but the scsi midlayer calls queuecommand
   without holding any locks, so a queuecommand may already past the midlayer
   scsi_block_requests checks when we call it, add a check to uas_queuecommand
   to fix this

2) For 2) we were waiting for all sense-urbs to complete, there are 2 problems
   with this approach:
a) data-urbs may complete after the sense urb, so we need to check for those
   too
b) if a sense-urb completes with a iu id of READ/WRITE_READY a command is not
   yet done. We submit a new sense-urb immediately in this case, but that
   submit may fail (in which case it will get retried by uas_do_work), if this
   happens the sense_urbs anchor may become empty while the cmnd is not yet
   done

Also unblock requests on timeout, to avoid things getting stuck in that case.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 61 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 55 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 6ee61bd..aaca65b 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -664,6 +664,10 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
+	/* Re-check scsi_block_requests now that we've the host-lock */
+	if (cmnd->device->host->host_self_blocked)
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+
 	spin_lock_irqsave(&devinfo->lock, flags);
 
 	if (devinfo->resetting) {
@@ -991,6 +995,54 @@ set_alt0:
 	return result;
 }
 
+static int uas_cmnd_list_empty(struct uas_dev_info *devinfo)
+{
+	unsigned long flags;
+	int i, r = 1;
+
+	spin_lock_irqsave(&devinfo->lock, flags);
+
+	for (i = 0; i < devinfo->qdepth; i++) {
+		if (devinfo->cmnd[i]) {
+			r = 0; /* Not empty */
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&devinfo->lock, flags);
+
+	return r;
+}
+
+/*
+ * Wait for any pending cmnds to complete, on usb-2 sense_urbs may temporarily
+ * get empty while there still is more work to do due to sense-urbs completing
+ * with a READ/WRITE_READY iu code, so keep waiting until the list gets empty.
+ */
+static int uas_wait_for_pending_cmnds(struct uas_dev_info *devinfo)
+{
+	unsigned long start_time;
+	int r;
+
+	start_time = jiffies;
+	do {
+		flush_work(&devinfo->work);
+
+		r = usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000);
+		if (r == 0)
+			return -ETIME;
+
+		r = usb_wait_anchor_empty_timeout(&devinfo->data_urbs, 500);
+		if (r == 0)
+			return -ETIME;
+
+		if (time_after(jiffies, start_time + 5 * HZ))
+			return -ETIME;
+	} while (!uas_cmnd_list_empty(devinfo));
+
+	return 0;
+}
+
 static int uas_pre_reset(struct usb_interface *intf)
 {
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
@@ -1005,10 +1057,9 @@ static int uas_pre_reset(struct usb_interface *intf)
 	scsi_block_requests(shost);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	/* Wait for any pending requests to complete */
-	flush_work(&devinfo->work);
-	if (usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000) == 0) {
+	if (uas_wait_for_pending_cmnds(devinfo) != 0) {
 		shost_printk(KERN_ERR, shost, "%s: timed out\n", __func__);
+		scsi_unblock_requests(shost);
 		return 1;
 	}
 
@@ -1046,9 +1097,7 @@ static int uas_suspend(struct usb_interface *intf, pm_message_t message)
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
 	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
 
-	/* Wait for any pending requests to complete */
-	flush_work(&devinfo->work);
-	if (usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000) == 0) {
+	if (uas_wait_for_pending_cmnds(devinfo) != 0) {
 		shost_printk(KERN_ERR, shost, "%s: timed out\n", __func__);
 		return -ETIME;
 	}
-- 
2.1.0
