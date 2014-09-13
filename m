From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 11/24] uas: Drop inflight list
Date: Sat, 13 Sep 2014 12:26:38 +0200
Message-ID: <1410604011-3828-12-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

We've the same info doubled in both the inflight list and the cmnd array,
drop the list.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 85bbc1d..36c42b8 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -61,7 +61,6 @@ struct uas_dev_info {
 	struct scsi_cmnd *cmnd[MAX_CMNDS];
 	spinlock_t lock;
 	struct work_struct work;
-	struct list_head inflight_list;
 };
 
 enum {
@@ -87,7 +86,6 @@ struct uas_cmd_info {
 	struct urb *cmd_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
-	struct list_head list;
 };
 
 /* I hate forward declarations, but I actually have a loop */
@@ -103,18 +101,21 @@ static void uas_do_work(struct work_struct *work)
 	struct uas_dev_info *devinfo =
 		container_of(work, struct uas_dev_info, work);
 	struct uas_cmd_info *cmdinfo;
+	struct scsi_cmnd *cmnd;
 	unsigned long flags;
-	int err;
+	int i, err;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
 
 	if (devinfo->resetting)
 		goto out;
 
-	list_for_each_entry(cmdinfo, &devinfo->inflight_list, list) {
-		struct scsi_pointer *scp = (void *)cmdinfo;
-		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
-						      SCp);
+	for (i = 0; i < devinfo->qdepth; i++) {
+		if (!devinfo->cmnd[i])
+			continue;
+
+		cmnd = devinfo->cmnd[i];
+		cmdinfo = (void *)&cmnd->SCp;
 
 		if (!(cmdinfo->state & IS_IN_WORK_LIST))
 			continue;
@@ -143,15 +144,17 @@ static void uas_add_work(struct uas_cmd_info *cmdinfo)
 static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 {
 	struct uas_cmd_info *cmdinfo;
-	struct uas_cmd_info *temp;
+	struct scsi_cmnd *cmnd;
 	unsigned long flags;
-	int err;
+	int i, err;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
-	list_for_each_entry_safe(cmdinfo, temp, &devinfo->dead_list, list) {
-		struct scsi_pointer *scp = (void *)cmdinfo;
-		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
-						      SCp);
+	for (i = 0; i < devinfo->qdepth; i++) {
+		if (!devinfo->cmnd[i])
+			continue;
+
+		cmnd = devinfo->cmnd[i];
+		cmdinfo = (void *)&cmnd->SCp;
 		uas_log_cmd_state(cmnd, __func__);
 		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
 		cmdinfo->state &= ~COMMAND_INFLIGHT;
@@ -260,7 +263,6 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	cmdinfo->state |= COMMAND_COMPLETED;
 	if (cmdinfo->state & COMMAND_ABORTED)
 		scmd_printk(KERN_INFO, cmnd, "abort completed\n");
-	list_del(&cmdinfo->list);
 	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
 	cmnd->scsi_done(cmnd);
 	return 0;
@@ -707,7 +709,6 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	}
 
 	devinfo->cmnd[stream - 1] = cmnd;
-	list_add_tail(&cmdinfo->list, &devinfo->inflight_list);
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 	return 0;
 }
@@ -917,7 +918,6 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	init_usb_anchor(&devinfo->data_urbs);
 	spin_lock_init(&devinfo->lock);
 	INIT_WORK(&devinfo->work, uas_do_work);
-	INIT_LIST_HEAD(&devinfo->inflight_list);
 
 	result = uas_configure_endpoints(devinfo);
 	if (result)
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
