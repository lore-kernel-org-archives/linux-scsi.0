From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 19/24] uas: Drop COMMAND_COMPLETED flag
Date: Sat, 13 Sep 2014 12:26:46 +0200
Message-ID: <1410604011-3828-20-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

It was only used to sanity check against completing the same cmnd twice,
but that is the case we're likely operating on free-ed memory, and doing
sanity checks on free-ed memory is not really helpful.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 652b97b..c6f7870 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -74,9 +74,8 @@ enum {
 	COMMAND_INFLIGHT        = (1 << 8),
 	DATA_IN_URB_INFLIGHT    = (1 << 9),
 	DATA_OUT_URB_INFLIGHT   = (1 << 10),
-	COMMAND_COMPLETED       = (1 << 11),
-	COMMAND_ABORTED         = (1 << 12),
-	IS_IN_WORK_LIST         = (1 << 13),
+	COMMAND_ABORTED         = (1 << 11),
+	IS_IN_WORK_LIST         = (1 << 12),
 };
 
 /* Overrides scsi_pointer */
@@ -232,7 +231,7 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
 
 	scmd_printk(KERN_INFO, cmnd,
-		    "%s tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s%s ",
+		    "%s tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
 		    caller, uas_get_tag(cmnd),
 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
@@ -244,7 +243,6 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 		    (ci->state & COMMAND_INFLIGHT)      ? " CMD"   : "",
 		    (ci->state & DATA_IN_URB_INFLIGHT)  ? " IN"    : "",
 		    (ci->state & DATA_OUT_URB_INFLIGHT) ? " OUT"   : "",
-		    (ci->state & COMMAND_COMPLETED)     ? " done"  : "",
 		    (ci->state & COMMAND_ABORTED)       ? " abort" : "",
 		    (ci->state & IS_IN_WORK_LIST)       ? " work"  : "");
 	scsi_print_command(cmnd);
@@ -280,8 +278,6 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 			      DATA_OUT_URB_INFLIGHT |
 			      COMMAND_ABORTED))
 		return -EBUSY;
-	WARN_ON_ONCE(cmdinfo->state & COMMAND_COMPLETED);
-	cmdinfo->state |= COMMAND_COMPLETED;
 	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
 	uas_free_unsubmitted_urbs(cmnd);
 	cmnd->scsi_done(cmnd);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
