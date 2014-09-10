From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 19/21] uas: Drop COMMAND_COMPLETED flag
Date: Wed, 10 Sep 2014 13:46:49 +0200
Message-ID: <1410349611-17573-20-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

It was only used to sanity check against completing the same cmnd twice,
but that is the case we're likely operating on free-ed memory, and doing
sanity checks on free-ed memory is not really helpful.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 220f4c7..e8d2bf1 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -72,9 +72,8 @@ enum {
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
@@ -229,7 +228,7 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
 
 	scmd_printk(KERN_INFO, cmnd,
-		    "%s tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s%s ",
+		    "%s tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
 		    caller, uas_get_tag(cmnd),
 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
@@ -241,7 +240,6 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 		    (ci->state & COMMAND_INFLIGHT)      ? " CMD"   : "",
 		    (ci->state & DATA_IN_URB_INFLIGHT)  ? " IN"    : "",
 		    (ci->state & DATA_OUT_URB_INFLIGHT) ? " OUT"   : "",
-		    (ci->state & COMMAND_COMPLETED)     ? " done"  : "",
 		    (ci->state & COMMAND_ABORTED)       ? " abort" : "",
 		    (ci->state & IS_IN_WORK_LIST)       ? " work"  : "");
 	scsi_print_command(cmnd);
@@ -277,8 +275,6 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
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
