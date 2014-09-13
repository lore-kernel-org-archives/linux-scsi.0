From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 06/24] uas: Check against unexpected completions
Date: Sat, 13 Sep 2014 12:26:33 +0200
Message-ID: <1410604011-3828-7-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbaIMK1E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:27:04 -0400
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

The status urb should not complete before the command has been submitted, nor
should we get a second status urb for the same tag after a IU_ID_STATUS.

Data urbs should not complete before the command has been submitted, but may
complete after the IU_ID_STATUS.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index b58d133..8614ddf 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -371,6 +371,12 @@ static void uas_stat_cmplt(struct urb *urb)
 
 	cmnd = devinfo->cmnd[idx];
 	cmdinfo = (void *)&cmnd->SCp;
+
+	if (!(cmdinfo->state & COMMAND_INFLIGHT)) {
+		scmd_printk(KERN_ERR, cmnd, "unexpected status cmplt\n");
+		goto out;
+	}
+
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
 		if (urb->actual_length < 16)
@@ -436,6 +442,12 @@ static void uas_data_cmplt(struct urb *urb)
 	if (devinfo->resetting)
 		goto out;
 
+	/* Data urbs should not complete before the cmd urb is submitted */
+	if (cmdinfo->state & SUBMIT_CMD_URB) {
+		scmd_printk(KERN_ERR, cmnd, "unexpected data cmplt\n");
+		goto out;
+	}
+
 	if (urb->status) {
 		if (urb->status != -ECONNRESET) {
 			uas_log_cmd_state(cmnd, __func__);
-- 
2.1.0

