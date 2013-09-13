From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 5/6] uas: replace BUG_ON() + WARN_ON() with WARN_ON_ONCE()
Date: Fri, 13 Sep 2013 13:27:14 +0200
Message-ID: <1379071635-30701-6-git-send-email-kraxel@redhat.com>
References: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-usb@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "open list:USB ATTACHED SCSI" <linux-scsi@vger.kernel.org>, "open list:USB MASS STORAGE..." <usb-storage@lists.one-eyed-alien.net>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/uas.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index f049038..046eedf 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -154,7 +154,7 @@ static void uas_abort_work(struct uas_dev_info *devinfo)
 		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
 						      SCp);
 		uas_log_cmd_state(cmnd, __func__);
-		WARN_ON(cmdinfo->state & COMMAND_ABORTED);
+		WARN_ON_ONCE(cmdinfo->state & COMMAND_ABORTED);
 		cmdinfo->state |= COMMAND_ABORTED;
 		cmdinfo->state &= ~IS_IN_WORK_LIST;
 		list_del(&cmdinfo->work);
@@ -169,7 +169,7 @@ static void uas_add_work(struct uas_cmd_info *cmdinfo)
 	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
 	struct uas_dev_info *devinfo = cmnd->device->hostdata;
 
-	WARN_ON(!spin_is_locked(&devinfo->lock));
+	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
 	list_add_tail(&cmdinfo->work, &devinfo->work_list);
 	cmdinfo->state |= IS_IN_WORK_LIST;
 	schedule_work(&devinfo->work);
@@ -187,7 +187,7 @@ static void uas_zap_dead(struct uas_dev_info *devinfo)
 		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
 						      SCp);
 		uas_log_cmd_state(cmnd, __func__);
-		WARN_ON(!(cmdinfo->state & COMMAND_ABORTED));
+		WARN_ON_ONCE(!(cmdinfo->state & COMMAND_ABORTED));
 		/* all urbs are killed, clear inflight bits */
 		cmdinfo->state &= ~(COMMAND_INFLIGHT |
 				    DATA_IN_URB_INFLIGHT |
@@ -271,13 +271,13 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
 
-	WARN_ON(!spin_is_locked(&devinfo->lock));
+	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
 	if (cmdinfo->state & (COMMAND_INFLIGHT |
 			      DATA_IN_URB_INFLIGHT |
 			      DATA_OUT_URB_INFLIGHT |
 			      UNLINK_DATA_URBS))
 		return -EBUSY;
-	BUG_ON(cmdinfo->state & COMMAND_COMPLETED);
+	WARN_ON_ONCE(cmdinfo->state & COMMAND_COMPLETED);
 	cmdinfo->state |= COMMAND_COMPLETED;
 	usb_free_urb(cmdinfo->data_in_urb);
 	usb_free_urb(cmdinfo->data_out_urb);
@@ -398,8 +398,9 @@ static void uas_data_cmplt(struct urb *urb)
 		sdb = scsi_out(cmnd);
 		cmdinfo->state &= ~DATA_OUT_URB_INFLIGHT;
 	}
-	BUG_ON(sdb == NULL);
-	if (urb->status) {
+	if (sdb == NULL) {
+		WARN_ON_ONCE(1);
+	} else if (urb->status) {
 		/* error: no data transfered */
 		sdb->resid = sdb->length;
 	} else {
@@ -573,7 +574,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	int err;
 
-	WARN_ON(!spin_is_locked(&devinfo->lock));
+	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
 	if (cmdinfo->state & SUBMIT_STATUS_URB) {
 		err = uas_submit_sense_urb(cmnd->device->host, gfp,
 					   cmdinfo->stream);
@@ -771,7 +772,7 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 
 	uas_log_cmd_state(cmnd, __func__);
 	spin_lock_irqsave(&devinfo->lock, flags);
-	WARN_ON(cmdinfo->state & COMMAND_ABORTED);
+	WARN_ON_ONCE(cmdinfo->state & COMMAND_ABORTED);
 	cmdinfo->state |= COMMAND_ABORTED;
 	list_add_tail(&cmdinfo->dead, &devinfo->dead_list);
 	if (cmdinfo->state & IS_IN_WORK_LIST) {
-- 
1.8.3.1
