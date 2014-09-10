From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/21] uas: Fix memleak of non-submitted urbs
Date: Wed, 10 Sep 2014 13:46:44 +0200
Message-ID: <1410349611-17573-15-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Not all urbs we've allocated are necessarily also submitted, non-submitted
urbs will not be free-ed by their completion handler. So we need to free
them manually.

There are 2 scenarios where this can happen:

1) We have failed to submit some urbs at abort / disconnect
2) When running over usb-2 we may have never tried to submit the data urbs
   when completing the scsi cmnd, because we never got a READ/WRITE_READY iu

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 75ce40c..6ee61bd 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -246,6 +246,25 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 		    (ci->state & IS_IN_WORK_LIST)       ? " work"  : "");
 }
 
+static void uas_free_unsubmitted_urbs(struct scsi_cmnd *cmnd)
+{
+	struct uas_cmd_info *cmdinfo;
+
+	if (!cmnd)
+		return;
+
+	cmdinfo = (void *)&cmnd->SCp;
+
+	if (cmdinfo->state & SUBMIT_CMD_URB)
+		usb_free_urb(cmdinfo->cmd_urb);
+
+	/* data urbs may have never gotten their submit flag set */
+	if (!(cmdinfo->state & DATA_IN_URB_INFLIGHT))
+		usb_free_urb(cmdinfo->data_in_urb);
+	if (!(cmdinfo->state & DATA_OUT_URB_INFLIGHT))
+		usb_free_urb(cmdinfo->data_out_urb);
+}
+
 static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 {
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
@@ -260,6 +279,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	WARN_ON_ONCE(cmdinfo->state & COMMAND_COMPLETED);
 	cmdinfo->state |= COMMAND_COMPLETED;
 	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
+	uas_free_unsubmitted_urbs(cmnd);
 	cmnd->scsi_done(cmnd);
 	return 0;
 }
@@ -726,6 +746,8 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 	if (cmdinfo->state & DATA_OUT_URB_INFLIGHT)
 		data_out_urb = usb_get_urb(cmdinfo->data_out_urb);
 
+	uas_free_unsubmitted_urbs(cmnd);
+
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 
 	if (data_in_urb) {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
