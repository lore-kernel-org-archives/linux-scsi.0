From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 22/24] uas: Cleanup uas_log_cmd_state usage
Date: Sat, 13 Sep 2014 12:26:49 +0200
Message-ID: <1410604011-3828-23-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaIMK13 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:27:29 -0400
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Instead of doing:

uas_log_cmd_state(cmnd, __func__)
scmd_printk(KERN_ERR, cmnd, "error doing foo %d\n", err)

On error, resulting in 2 log calls for a single error, make uas_log_cmd_state
take a status code, and change calls like the above to:

uas_log_cmd_state(cmnd, "error doing foo", err)

Also change various sanity checks (which should never trigger) from:
"scmd_printk(KERN_ERR, cmnd, "sanity foo failed\n")" to calling the new
uas_log_cmd_state(), so that when they do trigger we get more info.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 52 +++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index a77c5e0..0b3d3a5 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -78,7 +78,8 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 static void uas_do_work(struct work_struct *work);
 static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller);
 static void uas_free_streams(struct uas_dev_info *devinfo);
-static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller);
+static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *prefix,
+				int status);
 
 static void uas_do_work(struct work_struct *work)
 {
@@ -139,7 +140,7 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 
 		cmnd = devinfo->cmnd[i];
 		cmdinfo = (void *)&cmnd->SCp;
-		uas_log_cmd_state(cmnd, __func__);
+		uas_log_cmd_state(cmnd, __func__, 0);
 		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
 		cmdinfo->state &= ~COMMAND_INFLIGHT;
 		cmnd->result = result << 16;
@@ -188,13 +189,14 @@ static int uas_get_tag(struct scsi_cmnd *cmnd)
 	return tag;
 }
 
-static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
+static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *prefix,
+			      int status)
 {
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
 
 	scmd_printk(KERN_INFO, cmnd,
-		    "%s tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
-		    caller, uas_get_tag(cmnd),
+		    "%s %d tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
+		    prefix, status, uas_get_tag(cmnd),
 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
 		    (ci->state & SUBMIT_DATA_IN_URB)    ? " s-in"  : "",
@@ -295,7 +297,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	cmdinfo = (void *)&cmnd->SCp;
 
 	if (!(cmdinfo->state & COMMAND_INFLIGHT)) {
-		scmd_printk(KERN_ERR, cmnd, "unexpected status cmplt\n");
+		uas_log_cmd_state(cmnd, "unexpected status cmplt", 0);
 		goto out;
 	}
 
@@ -313,7 +315,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	case IU_ID_READ_READY:
 		if (!cmdinfo->data_in_urb ||
 				(cmdinfo->state & DATA_IN_URB_INFLIGHT)) {
-			scmd_printk(KERN_ERR, cmnd, "unexpected read rdy\n");
+			uas_log_cmd_state(cmnd, "unexpected read rdy", 0);
 			break;
 		}
 		uas_xfer_data(urb, cmnd, SUBMIT_DATA_IN_URB);
@@ -321,14 +323,13 @@ static void uas_stat_cmplt(struct urb *urb)
 	case IU_ID_WRITE_READY:
 		if (!cmdinfo->data_out_urb ||
 				(cmdinfo->state & DATA_OUT_URB_INFLIGHT)) {
-			scmd_printk(KERN_ERR, cmnd, "unexpected write rdy\n");
+			uas_log_cmd_state(cmnd, "unexpected write rdy", 0);
 			break;
 		}
 		uas_xfer_data(urb, cmnd, SUBMIT_DATA_OUT_URB);
 		break;
 	default:
-		scmd_printk(KERN_ERR, cmnd,
-			"Bogus IU (%d) received on status pipe\n", iu->iu_id);
+		uas_log_cmd_state(cmnd, "bogus IU", iu->iu_id);
 	}
 out:
 	usb_free_urb(urb);
@@ -374,17 +375,13 @@ static void uas_data_cmplt(struct urb *urb)
 
 	/* Data urbs should not complete before the cmd urb is submitted */
 	if (cmdinfo->state & SUBMIT_CMD_URB) {
-		scmd_printk(KERN_ERR, cmnd, "unexpected data cmplt\n");
+		uas_log_cmd_state(cmnd, "unexpected data cmplt", 0);
 		goto out;
 	}
 
 	if (urb->status) {
-		if (urb->status != -ENOENT && urb->status != -ECONNRESET) {
-			uas_log_cmd_state(cmnd, __func__);
-			scmd_printk(KERN_ERR, cmnd,
-				"data cmplt err %d stream %d\n",
-				urb->status, urb->stream_id);
-		}
+		if (urb->status != -ENOENT && urb->status != -ECONNRESET)
+			uas_log_cmd_state(cmnd, "data cmplt err", urb->status);
 		/* error: no data transfered */
 		sdb->resid = sdb->length;
 	} else {
@@ -508,10 +505,7 @@ static struct urb *uas_submit_sense_urb(struct scsi_cmnd *cmnd,
 	err = usb_submit_urb(urb, gfp);
 	if (err) {
 		usb_unanchor_urb(urb);
-		uas_log_cmd_state(cmnd, __func__);
-		shost_printk(KERN_INFO, shost,
-			     "sense urb submission error %d stream %d\n",
-			     err, stream);
+		uas_log_cmd_state(cmnd, "sense submit err", err);
 		usb_free_urb(urb);
 		return NULL;
 	}
@@ -547,10 +541,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 		err = usb_submit_urb(cmdinfo->data_in_urb, gfp);
 		if (err) {
 			usb_unanchor_urb(cmdinfo->data_in_urb);
-			uas_log_cmd_state(cmnd, __func__);
-			scmd_printk(KERN_INFO, cmnd,
-				"data in urb submission error %d stream %d\n",
-				err, cmdinfo->data_in_urb->stream_id);
+			uas_log_cmd_state(cmnd, "data in submit err", err);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_IN_URB;
@@ -571,10 +562,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 		err = usb_submit_urb(cmdinfo->data_out_urb, gfp);
 		if (err) {
 			usb_unanchor_urb(cmdinfo->data_out_urb);
-			uas_log_cmd_state(cmnd, __func__);
-			scmd_printk(KERN_INFO, cmnd,
-				"data out urb submission error %d stream %d\n",
-				err, cmdinfo->data_out_urb->stream_id);
+			uas_log_cmd_state(cmnd, "data out submit err", err);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_OUT_URB;
@@ -593,9 +581,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 		err = usb_submit_urb(cmdinfo->cmd_urb, gfp);
 		if (err) {
 			usb_unanchor_urb(cmdinfo->cmd_urb);
-			uas_log_cmd_state(cmnd, __func__);
-			scmd_printk(KERN_INFO, cmnd,
-				    "cmd urb submission error %d\n", err);
+			uas_log_cmd_state(cmnd, "cmd submit err", err);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		cmdinfo->cmd_urb = NULL;
@@ -701,7 +687,7 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 
 	spin_lock_irqsave(&devinfo->lock, flags);
 
-	uas_log_cmd_state(cmnd, __func__);
+	uas_log_cmd_state(cmnd, __func__, 0);
 
 	/* Ensure that try_complete does not call scsi_done */
 	cmdinfo->state |= COMMAND_ABORTED;
-- 
2.1.0

