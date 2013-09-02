From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 4/5] uas: add dead request list
Date: Mon,  2 Sep 2013 13:25:28 +0200
Message-ID: <1378121129-32594-5-git-send-email-kraxel@redhat.com>
References: <1378121129-32594-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378121129-32594-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-usb@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "open list:USB ATTACHED SCSI" <linux-scsi@vger.kernel.org>, "open list:USB MASS STORAGE..." <usb-storage@lists.one-eyed-alien.net>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds a new list where all requests which are canceled are
added to, so we don't loose them.  Then, after killing all inflight
urbs on bus reset (and disconnect) we'll walk over the list and clean
them up.

Without this we can end up with aborted requests lingering around in
case of status pipe transfer errors.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/uas.c | 69 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index a63972a..9dfb8f9 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -78,6 +78,7 @@ struct uas_cmd_info {
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
 	struct list_head work;
+	struct list_head dead;
 };
 
 /* I hate forward declarations, but I actually have a loop */
@@ -87,10 +88,12 @@ static void uas_do_work(struct work_struct *work);
 static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller);
 static void uas_configure_endpoints(struct uas_dev_info *devinfo);
 static void uas_free_streams(struct uas_dev_info *devinfo);
+static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller);
 
 static DECLARE_WORK(uas_work, uas_do_work);
 static DEFINE_SPINLOCK(uas_lists_lock);
 static LIST_HEAD(uas_work_list);
+static LIST_HEAD(uas_dead_list);
 
 static void uas_unlink_data_urbs(struct uas_dev_info *devinfo,
 				 struct uas_cmd_info *cmdinfo)
@@ -167,15 +170,13 @@ static void uas_abort_work(struct uas_dev_info *devinfo)
 		struct uas_dev_info *di = (void *)cmnd->device->hostdata;
 
 		if (di == devinfo) {
+			uas_log_cmd_state(cmnd, __func__);
+			BUG_ON(cmdinfo->state & COMMAND_ABORTED);
 			cmdinfo->state |= COMMAND_ABORTED;
+			spin_lock_irq(&uas_lists_lock);
+			list_add_tail(&cmdinfo->dead, &uas_dead_list);
+			spin_unlock_irq(&uas_lists_lock);
 			cmdinfo->state &= ~IS_IN_WORK_LIST;
-			if (devinfo->resetting) {
-				/* uas_stat_cmplt() will not do that
-				 * when a device reset is in
-				 * progress */
-				cmdinfo->state &= ~COMMAND_INFLIGHT;
-			}
-			uas_try_complete(cmnd, __func__);
 		} else {
 			/* not our uas device, relink into list */
 			list_del(&cmdinfo->work);
@@ -187,6 +188,43 @@ static void uas_abort_work(struct uas_dev_info *devinfo)
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
 
+static void uas_zap_dead(struct uas_dev_info *devinfo)
+{
+	struct uas_cmd_info *cmdinfo;
+	struct uas_cmd_info *temp;
+	struct list_head list;
+	unsigned long flags;
+
+	spin_lock_irq(&uas_lists_lock);
+	list_replace_init(&uas_dead_list, &list);
+	spin_unlock_irq(&uas_lists_lock);
+
+	spin_lock_irqsave(&devinfo->lock, flags);
+	list_for_each_entry_safe(cmdinfo, temp, &list, dead) {
+		struct scsi_pointer *scp = (void *)cmdinfo;
+		struct scsi_cmnd *cmnd = container_of(scp,
+							struct scsi_cmnd, SCp);
+		struct uas_dev_info *di = (void *)cmnd->device->hostdata;
+
+		if (di == devinfo) {
+			uas_log_cmd_state(cmnd, __func__);
+			BUG_ON(!(cmdinfo->state & COMMAND_ABORTED));
+			/* all urbs are killed, clear inflight bits */
+			cmdinfo->state &= ~(COMMAND_INFLIGHT |
+					    DATA_IN_URB_INFLIGHT |
+					    DATA_OUT_URB_INFLIGHT);
+			uas_try_complete(cmnd, __func__);
+		} else {
+			/* not our uas device, relink into list */
+			list_del(&cmdinfo->dead);
+			spin_lock_irq(&uas_lists_lock);
+			list_add_tail(&cmdinfo->dead, &uas_dead_list);
+			spin_unlock_irq(&uas_lists_lock);
+		}
+	}
+	spin_unlock_irqrestore(&devinfo->lock, flags);
+}
+
 static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 {
 	struct sense_iu *sense_iu = urb->transfer_buffer;
@@ -274,6 +312,9 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	if (cmdinfo->state & COMMAND_ABORTED) {
 		scmd_printk(KERN_INFO, cmnd, "abort completed\n");
 		cmnd->result = DID_ABORT << 16;
+		spin_lock_irq(&uas_lists_lock);
+		list_del(&cmdinfo->dead);
+		spin_unlock_irq(&uas_lists_lock);
 	}
 	cmnd->scsi_done(cmnd);
 	return 0;
@@ -307,7 +348,12 @@ static void uas_stat_cmplt(struct urb *urb)
 	u16 tag;
 
 	if (urb->status) {
-		dev_err(&urb->dev->dev, "URB BAD STATUS %d\n", urb->status);
+		if (urb->status == -ENOENT) {
+			dev_err(&urb->dev->dev, "stat urb: killed (stream %d\n",
+				urb->stream_id);
+		} else {
+			dev_err(&urb->dev->dev, "stat urb: status %d\n", urb->status);
+		}
 		usb_free_urb(urb);
 		return;
 	}
@@ -762,7 +808,11 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 
 	uas_log_cmd_state(cmnd, __func__);
 	spin_lock_irqsave(&devinfo->lock, flags);
+	BUG_ON(cmdinfo->state & COMMAND_ABORTED);
 	cmdinfo->state |= COMMAND_ABORTED;
+	spin_lock_irq(&uas_lists_lock);
+	list_add_tail(&cmdinfo->dead, &uas_dead_list);
+	spin_unlock_irq(&uas_lists_lock);
 	if (cmdinfo->state & IS_IN_WORK_LIST) {
 		spin_lock(&uas_lists_lock);
 		list_del(&cmdinfo->work);
@@ -797,11 +847,13 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 	struct usb_device *udev = devinfo->udev;
 	int err;
 
+	shost_printk(KERN_INFO, sdev->host, "%s start\n", __func__);
 	devinfo->resetting = 1;
 	uas_abort_work(devinfo);
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
+	uas_zap_dead(devinfo);
 	uas_free_streams(devinfo);
 	err = usb_reset_device(udev);
 	if (!err) {
@@ -1055,6 +1107,7 @@ static void uas_disconnect(struct usb_interface *intf)
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
+	uas_zap_dead(devinfo);
 	scsi_remove_host(shost);
 	uas_free_streams(devinfo);
 	kfree(devinfo);
-- 
1.8.3.1
