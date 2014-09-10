From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 18/21] uas: Use scsi_print_command
Date: Wed, 10 Sep 2014 13:46:48 +0200
Message-ID: <1410349611-17573-19-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaIJLr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 07:47:26 -0400
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Use scsi_print_command to print commands during errors, rather then printing
the rather meaningless pointer to the command.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 46b8788..220f4c7 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -229,8 +229,8 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
 
 	scmd_printk(KERN_INFO, cmnd,
-		    "%s %p tag %d, inflight:%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
-		    caller, cmnd, uas_get_tag(cmnd),
+		    "%s tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s%s ",
+		    caller, uas_get_tag(cmnd),
 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
 		    (ci->state & SUBMIT_DATA_IN_URB)    ? " s-in"  : "",
@@ -244,6 +244,7 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
 		    (ci->state & COMMAND_COMPLETED)     ? " done"  : "",
 		    (ci->state & COMMAND_ABORTED)       ? " abort" : "",
 		    (ci->state & IS_IN_WORK_LIST)       ? " work"  : "");
+	scsi_print_command(cmnd);
 }
 
 static void uas_free_unsubmitted_urbs(struct scsi_cmnd *cmnd)
-- 
2.1.0

