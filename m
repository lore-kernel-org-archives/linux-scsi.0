From: Sanjeev Sharma <sanjeev_sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3] uas: replace WARN_ON_ONCE() with lockdep_assert_held()
Date: Tue, 12 Aug 2014 12:10:21 +0530
Message-ID: <1407825621-23322-1-git-send-email-sanjeev_sharma@mentor.com>
References: <yes>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yes>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sanjeev Sharma <sanjeev_sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Sanjeev Sharma <Sanjeev_Sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

on some architecture spin_is_locked() always return false in
uniprocessor configuration and therefore it would be advise
to replace with lockdep_assert_held().

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
---
Changes in v3:
 incorporated review comment suggested by Greg

 drivers/usb/storage/uas.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 3f42785..05b2d8e 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -154,7 +154,7 @@ static void uas_mark_cmd_dead(struct uas_dev_info *devinfo,
 	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
 
 	uas_log_cmd_state(cmnd, caller);
-	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
+	lockdep_assert_held(&devinfo->lock);
 	WARN_ON_ONCE(cmdinfo->state & COMMAND_ABORTED);
 	cmdinfo->state |= COMMAND_ABORTED;
 	cmdinfo->state &= ~IS_IN_WORK_LIST;
@@ -181,7 +181,7 @@ static void uas_add_work(struct uas_cmd_info *cmdinfo)
 	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
 	struct uas_dev_info *devinfo = cmnd->device->hostdata;
 
-	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
+	lockdep_assert_held(&devinfo->lock);
 	cmdinfo->state |= IS_IN_WORK_LIST;
 	schedule_work(&devinfo->work);
 }
@@ -283,7 +283,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
 
-	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
+	lockdep_assert_held(&devinfo->lock);
 	if (cmdinfo->state & (COMMAND_INFLIGHT |
 			      DATA_IN_URB_INFLIGHT |
 			      DATA_OUT_URB_INFLIGHT |
@@ -622,7 +622,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 	struct urb *urb;
 	int err;
 
-	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
+	lockdep_assert_held(&devinfo->lock);
 	if (cmdinfo->state & SUBMIT_STATUS_URB) {
 		urb = uas_submit_sense_urb(cmnd, gfp, cmdinfo->stream);
 		if (!urb)
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
