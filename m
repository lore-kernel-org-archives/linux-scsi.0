From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 13/24] uas: Drop all references to a scsi_cmnd once it has been aborted
Date: Sat, 13 Sep 2014 12:26:40 +0200
Message-ID: <1410604011-3828-14-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbaIMK1Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:27:16 -0400
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Do not keep references around to a cmnd which is under error handling.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 1781b36..ce2d8fc 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -257,12 +257,11 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	lockdep_assert_held(&devinfo->lock);
 	if (cmdinfo->state & (COMMAND_INFLIGHT |
 			      DATA_IN_URB_INFLIGHT |
-			      DATA_OUT_URB_INFLIGHT))
+			      DATA_OUT_URB_INFLIGHT |
+			      COMMAND_ABORTED))
 		return -EBUSY;
 	WARN_ON_ONCE(cmdinfo->state & COMMAND_COMPLETED);
 	cmdinfo->state |= COMMAND_COMPLETED;
-	if (cmdinfo->state & COMMAND_ABORTED)
-		scmd_printk(KERN_INFO, cmnd, "abort completed\n");
 	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
 	cmnd->scsi_done(cmnd);
 	return 0;
@@ -712,6 +711,47 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 static DEF_SCSI_QCMD(uas_queuecommand)
 
+/*
+ * For now we do not support actually sending an abort to the device, so
+ * this eh always fails. Still we must define it to make sure that we've
+ * dropped all references to the cmnd in question once this function exits.
+ */
+static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
+{
+	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
+	struct urb *data_in_urb = NULL;
+	struct urb *data_out_urb = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&devinfo->lock, flags);
+
+	uas_log_cmd_state(cmnd, __func__);
+
+	/* Ensure that try_complete does not call scsi_done */
+	cmdinfo->state |= COMMAND_ABORTED;
+
+	/* Drop all refs to this cmnd, kill data urbs to break their ref */
+	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
+	if (cmdinfo->state & DATA_IN_URB_INFLIGHT)
+		data_in_urb = usb_get_urb(cmdinfo->data_in_urb);
+	if (cmdinfo->state & DATA_OUT_URB_INFLIGHT)
+		data_out_urb = usb_get_urb(cmdinfo->data_out_urb);
+
+	spin_unlock_irqrestore(&devinfo->lock, flags);
+
+	if (data_in_urb) {
+		usb_kill_urb(data_in_urb);
+		usb_put_urb(data_in_urb);
+	}
+	if (data_out_urb) {
+		usb_kill_urb(data_out_urb);
+		usb_put_urb(data_out_urb);
+	}
+
+	return FAILED;
+}
+
 static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct scsi_device *sdev = cmnd->device;
@@ -793,6 +833,7 @@ static struct scsi_host_template uas_host_template = {
 	.queuecommand = uas_queuecommand,
 	.slave_alloc = uas_slave_alloc,
 	.slave_configure = uas_slave_configure,
+	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_bus_reset_handler = uas_eh_bus_reset_handler,
 	.can_queue = 65536,	/* Is there a limit on the _host_ ? */
 	.this_id = -1,
-- 
2.1.0

