From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 09/21] uas: Simplify reset / disconnect handling
Date: Wed, 10 Sep 2014 13:46:39 +0200
Message-ID: <1410349611-17573-10-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaIJLrK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 07:47:10 -0400
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Drop the whole dance with first moving cmnds to a dead-list. The resetting
flag ensures that no new cmds / urbs will be submitted, and that any urb
completions are short-circuited without trying to complete the scsi cmnd.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 43 ++++++-------------------------------------
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 4c7d337..bba5498 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -60,7 +60,6 @@ struct uas_dev_info {
 	spinlock_t lock;
 	struct work_struct work;
 	struct list_head inflight_list;
-	struct list_head dead_list;
 };
 
 enum {
@@ -128,35 +127,6 @@ out:
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
 
-static void uas_mark_cmd_dead(struct uas_dev_info *devinfo,
-			      struct uas_cmd_info *cmdinfo,
-			      int result, const char *caller)
-{
-	struct scsi_pointer *scp = (void *)cmdinfo;
-	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
-
-	uas_log_cmd_state(cmnd, caller);
-	lockdep_assert_held(&devinfo->lock);
-	WARN_ON_ONCE(cmdinfo->state & COMMAND_ABORTED);
-	cmdinfo->state |= COMMAND_ABORTED;
-	cmdinfo->state &= ~IS_IN_WORK_LIST;
-	cmnd->result = result << 16;
-	list_move_tail(&cmdinfo->list, &devinfo->dead_list);
-}
-
-static void uas_abort_inflight(struct uas_dev_info *devinfo, int result,
-			       const char *caller)
-{
-	struct uas_cmd_info *cmdinfo;
-	struct uas_cmd_info *temp;
-	unsigned long flags;
-
-	spin_lock_irqsave(&devinfo->lock, flags);
-	list_for_each_entry_safe(cmdinfo, temp, &devinfo->inflight_list, list)
-		uas_mark_cmd_dead(devinfo, cmdinfo, result, caller);
-	spin_unlock_irqrestore(&devinfo->lock, flags);
-}
-
 static void uas_add_work(struct uas_cmd_info *cmdinfo)
 {
 	struct scsi_pointer *scp = (void *)cmdinfo;
@@ -168,7 +138,7 @@ static void uas_add_work(struct uas_cmd_info *cmdinfo)
 	schedule_work(&devinfo->work);
 }
 
-static void uas_zap_dead(struct uas_dev_info *devinfo)
+static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 {
 	struct uas_cmd_info *cmdinfo;
 	struct uas_cmd_info *temp;
@@ -180,11 +150,11 @@ static void uas_zap_dead(struct uas_dev_info *devinfo)
 		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
 						      SCp);
 		uas_log_cmd_state(cmnd, __func__);
-		WARN_ON_ONCE(!(cmdinfo->state & COMMAND_ABORTED));
 		/* all urbs are killed, clear inflight bits */
 		cmdinfo->state &= ~(COMMAND_INFLIGHT |
 				    DATA_IN_URB_INFLIGHT |
 				    DATA_OUT_URB_INFLIGHT);
+		cmnd->result = result << 16;
 		uas_try_complete(cmnd, __func__);
 	}
 	spin_unlock_irqrestore(&devinfo->lock, flags);
@@ -754,11 +724,11 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 	devinfo->resetting = 1;
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 
-	uas_abort_inflight(devinfo, DID_RESET, __func__);
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
-	uas_zap_dead(devinfo);
+	uas_zap_pending(devinfo, DID_RESET);
+
 	err = usb_reset_device(udev);
 
 	spin_lock_irqsave(&devinfo->lock, flags);
@@ -935,7 +905,6 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	spin_lock_init(&devinfo->lock);
 	INIT_WORK(&devinfo->work, uas_do_work);
 	INIT_LIST_HEAD(&devinfo->inflight_list);
-	INIT_LIST_HEAD(&devinfo->dead_list);
 
 	result = uas_configure_endpoints(devinfo);
 	if (result)
@@ -1063,11 +1032,11 @@ static void uas_disconnect(struct usb_interface *intf)
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 
 	cancel_work_sync(&devinfo->work);
-	uas_abort_inflight(devinfo, DID_NO_CONNECT, __func__);
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
-	uas_zap_dead(devinfo);
+	uas_zap_pending(devinfo, DID_NO_CONNECT);
+
 	scsi_remove_host(shost);
 	uas_free_streams(devinfo);
 	scsi_host_put(shost);
-- 
2.1.0

