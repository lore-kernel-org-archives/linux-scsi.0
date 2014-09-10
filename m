From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 11/21] uas: Drop inflight list
Date: Wed, 10 Sep 2014 13:46:41 +0200
Message-ID: <1410349611-17573-12-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaIJLrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 07:47:14 -0400
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

We've the same info doubled in both the inflight list and the cmnd array,
drop the list.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index ec6547d..dca09de 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -59,7 +59,6 @@ struct uas_dev_info {
 	struct scsi_cmnd *cmnd[MAX_CMNDS];
 	spinlock_t lock;
 	struct work_struct work;
-	struct list_head inflight_list;
 };
 
 enum {
@@ -85,7 +84,6 @@ struct uas_cmd_info {
 	struct urb *cmd_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
-	struct list_head list;
 };
 
 /* I hate forward declarations, but I actually have a loop */
@@ -101,18 +99,21 @@ static void uas_do_work(struct work_struct *work)
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
@@ -141,14 +142,17 @@ static void uas_add_work(struct uas_cmd_info *cmdinfo)
 static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 {
 	struct uas_cmd_info *cmdinfo;
-	struct uas_cmd_info *temp;
+	struct scsi_cmnd *cmnd;
 	unsigned long flags;
+	int i;
 
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
@@ -256,7 +260,6 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	cmdinfo->state |= COMMAND_COMPLETED;
 	if (cmdinfo->state & COMMAND_ABORTED)
 		scmd_printk(KERN_INFO, cmnd, "abort completed\n");
-	list_del(&cmdinfo->list);
 	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
 	cmnd->scsi_done(cmnd);
 	return 0;
@@ -694,7 +697,6 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	}
 
 	devinfo->cmnd[stream - 1] = cmnd;
-	list_add_tail(&cmdinfo->list, &devinfo->inflight_list);
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 	return 0;
 }
@@ -902,7 +904,6 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	init_usb_anchor(&devinfo->data_urbs);
 	spin_lock_init(&devinfo->lock);
 	INIT_WORK(&devinfo->work, uas_do_work);
-	INIT_LIST_HEAD(&devinfo->inflight_list);
 
 	result = uas_configure_endpoints(devinfo);
 	if (result)
-- 
2.1.0

