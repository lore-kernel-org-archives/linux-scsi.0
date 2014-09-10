From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/21] uas: Simplify unlink of data urbs on error
Date: Wed, 10 Sep 2014 13:46:37 +0200
Message-ID: <1410349611-17573-8-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

There is no need for all the trickery with dropping the lock, we can
simply reference the urbs while we hold the lock to ensure the urbs don't
disappear beneath us, and do the actual unlink (+ unreference) after we've
dropped the lock.

This also fixes a race where we may loose of cmnd ownership to the scsi
midlayer without holding the lock due to the midlayer re-claiming ownership
through an abort (which will be handled by a future patch in this series).

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 48 ++++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 1ef59b0..b91b5e9 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -76,8 +76,7 @@ enum {
 	DATA_OUT_URB_INFLIGHT   = (1 << 10),
 	COMMAND_COMPLETED       = (1 << 11),
 	COMMAND_ABORTED         = (1 << 12),
-	UNLINK_DATA_URBS        = (1 << 13),
-	IS_IN_WORK_LIST         = (1 << 14),
+	IS_IN_WORK_LIST         = (1 << 13),
 };
 
 /* Overrides scsi_pointer */
@@ -98,28 +97,6 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller);
 static void uas_free_streams(struct uas_dev_info *devinfo);
 static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller);
 
-/* Must be called with devinfo->lock held, will temporary unlock the lock */
-static void uas_unlink_data_urbs(struct uas_dev_info *devinfo,
-				 struct uas_cmd_info *cmdinfo,
-				 unsigned long *lock_flags)
-{
-	/*
-	 * The UNLINK_DATA_URBS flag makes sure uas_try_complete
-	 * (called by urb completion) doesn't release cmdinfo
-	 * underneath us.
-	 */
-	cmdinfo->state |= UNLINK_DATA_URBS;
-	spin_unlock_irqrestore(&devinfo->lock, *lock_flags);
-
-	if (cmdinfo->data_in_urb)
-		usb_unlink_urb(cmdinfo->data_in_urb);
-	if (cmdinfo->data_out_urb)
-		usb_unlink_urb(cmdinfo->data_out_urb);
-
-	spin_lock_irqsave(&devinfo->lock, *lock_flags);
-	cmdinfo->state &= ~UNLINK_DATA_URBS;
-}
-
 static void uas_do_work(struct work_struct *work)
 {
 	struct uas_dev_info *devinfo =
@@ -279,8 +256,8 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 {
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
 
-	scmd_printk(KERN_INFO, cmnd, "%s %p tag %d, inflight:"
-		    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
+	scmd_printk(KERN_INFO, cmnd,
+		    "%s %p tag %d, inflight:%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 		    caller, cmnd, uas_get_tag(cmnd),
 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
@@ -294,7 +271,6 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 		    (ci->state & DATA_OUT_URB_INFLIGHT) ? " OUT"   : "",
 		    (ci->state & COMMAND_COMPLETED)     ? " done"  : "",
 		    (ci->state & COMMAND_ABORTED)       ? " abort" : "",
-		    (ci->state & UNLINK_DATA_URBS)      ? " unlink": "",
 		    (ci->state & IS_IN_WORK_LIST)       ? " work"  : "");
 }
 
@@ -306,8 +282,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	lockdep_assert_held(&devinfo->lock);
 	if (cmdinfo->state & (COMMAND_INFLIGHT |
 			      DATA_IN_URB_INFLIGHT |
-			      DATA_OUT_URB_INFLIGHT |
-			      UNLINK_DATA_URBS))
+			      DATA_OUT_URB_INFLIGHT))
 		return -EBUSY;
 	WARN_ON_ONCE(cmdinfo->state & COMMAND_COMPLETED);
 	cmdinfo->state |= COMMAND_COMPLETED;
@@ -339,6 +314,8 @@ static void uas_stat_cmplt(struct urb *urb)
 	struct iu *iu = urb->transfer_buffer;
 	struct Scsi_Host *shost = urb->context;
 	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
+	struct urb *data_in_urb = NULL;
+	struct urb *data_out_urb = NULL;
 	struct scsi_cmnd *cmnd;
 	struct uas_cmd_info *cmdinfo;
 	unsigned long flags;
@@ -385,7 +362,8 @@ static void uas_stat_cmplt(struct urb *urb)
 			uas_sense(urb, cmnd);
 		if (cmnd->result != 0) {
 			/* cancel data transfers on error */
-			uas_unlink_data_urbs(devinfo, cmdinfo, &flags);
+			data_in_urb = usb_get_urb(cmdinfo->data_in_urb);
+			data_out_urb = usb_get_urb(cmdinfo->data_out_urb);
 		}
 		cmdinfo->state &= ~COMMAND_INFLIGHT;
 		uas_try_complete(cmnd, __func__);
@@ -413,6 +391,16 @@ static void uas_stat_cmplt(struct urb *urb)
 out:
 	usb_free_urb(urb);
 	spin_unlock_irqrestore(&devinfo->lock, flags);
+
+	/* Unlinking of data urbs must be done without holding the lock */
+	if (data_in_urb) {
+		usb_unlink_urb(data_in_urb);
+		usb_put_urb(data_in_urb);
+	}
+	if (data_out_urb) {
+		usb_unlink_urb(data_out_urb);
+		usb_put_urb(data_out_urb);
+	}
 }
 
 static void uas_data_cmplt(struct urb *urb)
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
