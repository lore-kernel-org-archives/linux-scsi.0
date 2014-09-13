From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 14/24] uas: Fix memleak of non-submitted urbs
Date: Sat, 13 Sep 2014 12:26:41 +0200
Message-ID: <1410604011-3828-15-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbaIMK1S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:27:18 -0400
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Not all urbs we've allocated are necessarily also submitted, non-submitted
urbs will not be free-ed by their completion handler. So we need to free
them manually.

There are 2 scenarios where this can happen:

1) We have failed to submit some urbs at abort / disconnect
2) When running over usb-2 we may have never tried to submit the data urbs
   when completing the scsi cmnd, because we never got a READ/WRITE_READY iu

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index ce2d8fc..fca8775 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -249,6 +249,25 @@ static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
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
@@ -263,6 +282,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	WARN_ON_ONCE(cmdinfo->state & COMMAND_COMPLETED);
 	cmdinfo->state |= COMMAND_COMPLETED;
 	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
+	uas_free_unsubmitted_urbs(cmnd);
 	cmnd->scsi_done(cmnd);
 	return 0;
 }
@@ -738,6 +758,8 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 	if (cmdinfo->state & DATA_OUT_URB_INFLIGHT)
 		data_out_urb = usb_get_urb(cmdinfo->data_out_urb);
 
+	uas_free_unsubmitted_urbs(cmnd);
+
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 
 	if (data_in_urb) {
-- 
2.1.0

