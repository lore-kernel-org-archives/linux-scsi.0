From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 3/5] uas: rename work list lock + list field
Date: Tue,  3 Sep 2013 15:46:43 +0200
Message-ID: <1378216005-10326-4-git-send-email-kraxel@redhat.com>
References: <1378216005-10326-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378216005-10326-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-usb@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "open list:USB ATTACHED SCSI" <linux-scsi@vger.kernel.org>, "open list:USB MASS STORAGE..." <usb-storage@lists.one-eyed-alien.net>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch prepares for the addition of another list and renames the
work list lock and the list_head field in struct uas_cmd_info.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/uas.c | 50 +++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index fc08ee9..db09bda 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -77,7 +77,7 @@ struct uas_cmd_info {
 	struct urb *cmd_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
-	struct list_head list;
+	struct list_head work;
 };
 
 /* I hate forward declarations, but I actually have a loop */
@@ -89,7 +89,7 @@ static void uas_configure_endpoints(struct uas_dev_info *devinfo);
 static void uas_free_streams(struct uas_dev_info *devinfo);
 
 static DECLARE_WORK(uas_work, uas_do_work);
-static DEFINE_SPINLOCK(uas_work_lock);
+static DEFINE_SPINLOCK(uas_lists_lock);
 static LIST_HEAD(uas_work_list);
 
 static void uas_unlink_data_urbs(struct uas_dev_info *devinfo,
@@ -124,11 +124,11 @@ static void uas_do_work(struct work_struct *work)
 	unsigned long flags;
 	int err;
 
-	spin_lock_irq(&uas_work_lock);
+	spin_lock_irq(&uas_lists_lock);
 	list_replace_init(&uas_work_list, &list);
-	spin_unlock_irq(&uas_work_lock);
+	spin_unlock_irq(&uas_lists_lock);
 
-	list_for_each_entry_safe(cmdinfo, temp, &list, list) {
+	list_for_each_entry_safe(cmdinfo, temp, &list, work) {
 		struct scsi_pointer *scp = (void *)cmdinfo;
 		struct scsi_cmnd *cmnd = container_of(scp,
 							struct scsi_cmnd, SCp);
@@ -139,10 +139,10 @@ static void uas_do_work(struct work_struct *work)
 			cmdinfo->state &= ~IS_IN_WORK_LIST;
 		spin_unlock_irqrestore(&devinfo->lock, flags);
 		if (err) {
-			list_del(&cmdinfo->list);
-			spin_lock_irq(&uas_work_lock);
-			list_add_tail(&cmdinfo->list, &uas_work_list);
-			spin_unlock_irq(&uas_work_lock);
+			list_del(&cmdinfo->work);
+			spin_lock_irq(&uas_lists_lock);
+			list_add_tail(&cmdinfo->work, &uas_work_list);
+			spin_unlock_irq(&uas_lists_lock);
 			schedule_work(&uas_work);
 		}
 	}
@@ -155,12 +155,12 @@ static void uas_abort_work(struct uas_dev_info *devinfo)
 	struct list_head list;
 	unsigned long flags;
 
-	spin_lock_irq(&uas_work_lock);
+	spin_lock_irq(&uas_lists_lock);
 	list_replace_init(&uas_work_list, &list);
-	spin_unlock_irq(&uas_work_lock);
+	spin_unlock_irq(&uas_lists_lock);
 
 	spin_lock_irqsave(&devinfo->lock, flags);
-	list_for_each_entry_safe(cmdinfo, temp, &list, list) {
+	list_for_each_entry_safe(cmdinfo, temp, &list, work) {
 		struct scsi_pointer *scp = (void *)cmdinfo;
 		struct scsi_cmnd *cmnd = container_of(scp,
 							struct scsi_cmnd, SCp);
@@ -178,10 +178,10 @@ static void uas_abort_work(struct uas_dev_info *devinfo)
 			uas_try_complete(cmnd, __func__);
 		} else {
 			/* not our uas device, relink into list */
-			list_del(&cmdinfo->list);
-			spin_lock_irq(&uas_work_lock);
-			list_add_tail(&cmdinfo->list, &uas_work_list);
-			spin_unlock_irq(&uas_work_lock);
+			list_del(&cmdinfo->work);
+			spin_lock_irq(&uas_lists_lock);
+			list_add_tail(&cmdinfo->work, &uas_work_list);
+			spin_unlock_irq(&uas_lists_lock);
 		}
 	}
 	spin_unlock_irqrestore(&devinfo->lock, flags);
@@ -288,10 +288,10 @@ static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 	cmdinfo->state |= direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
 	if (err) {
-		spin_lock(&uas_work_lock);
-		list_add_tail(&cmdinfo->list, &uas_work_list);
+		spin_lock(&uas_lists_lock);
+		list_add_tail(&cmdinfo->work, &uas_work_list);
 		cmdinfo->state |= IS_IN_WORK_LIST;
-		spin_unlock(&uas_work_lock);
+		spin_unlock(&uas_lists_lock);
 		schedule_work(&uas_work);
 	}
 }
@@ -694,10 +694,10 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 			spin_unlock_irqrestore(&devinfo->lock, flags);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
-		spin_lock(&uas_work_lock);
-		list_add_tail(&cmdinfo->list, &uas_work_list);
+		spin_lock(&uas_lists_lock);
+		list_add_tail(&cmdinfo->work, &uas_work_list);
 		cmdinfo->state |= IS_IN_WORK_LIST;
-		spin_unlock(&uas_work_lock);
+		spin_unlock(&uas_lists_lock);
 		schedule_work(&uas_work);
 	}
 
@@ -764,10 +764,10 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 	spin_lock_irqsave(&devinfo->lock, flags);
 	cmdinfo->state |= COMMAND_ABORTED;
 	if (cmdinfo->state & IS_IN_WORK_LIST) {
-		spin_lock(&uas_work_lock);
-		list_del(&cmdinfo->list);
+		spin_lock(&uas_lists_lock);
+		list_del(&cmdinfo->work);
 		cmdinfo->state &= ~IS_IN_WORK_LIST;
-		spin_unlock(&uas_work_lock);
+		spin_unlock(&uas_lists_lock);
 	}
 	if (cmdinfo->state & COMMAND_INFLIGHT) {
 		spin_unlock_irqrestore(&devinfo->lock, flags);
-- 
1.8.3.1
