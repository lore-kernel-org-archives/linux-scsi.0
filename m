From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/2] usb/uas: fix support on HS (device with command tagging)
Date: Wed, 14 Dec 2011 19:47:52 +0100
Message-ID: <1323888472-21035-3-git-send-email-bigeasy@linutronix.de>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:34281 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab1LNSrM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2011 13:47:12 -0500
In-Reply-To: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The status/sense URB is allocated on per-command basis. A read/write
looks the following way on HS:

- send cmd tag X, queue status
- receive status, oh it is a read for tag X. queue status & read
- receive read
- receive status, oh I'm done for tag X. Cool call complete and free
  status urb.

This block repeats itself 1:1 for further commands and looks great so
far. Lets take a look now what happens if we do allow multiple commands:

- send cmd tag X, queue statusX (belongs to the command with the X tag)
- send cmd tag Y, queue statusY (belongs to the command with the Y tag)
- receive statusX, oh it is a read for tag X. queue statusX & a read
- receive read
- receive statusY, oh I'm done for tag X. Cool call complete and free
  statusY.
- receive statusX, oh it is a read for tag Y. queue statusY & before we
  queue the read the the following message can be observed:
  |sd 0:0:0:0: [sda] sense urb submission failure
  followed by a second attempt with the same result.

To fix this problem, I removed status URB from the command struct so it
is no longer part of it. We free it once we done with the command.
During an error condition (we never receive a status answer from the
device) the URB is lost. This is no different compared to what we do
now. Once we close the endpoint the status urb should be removed and
cleaned up.

With this patch things work for me on HS-UASP with command tagging and
multiple commands at a time.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/storage/uas.c |   56 +++++++++++++++++++++------------------------
 1 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 97f969c..37a7028 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -101,8 +101,7 @@ struct uas_dev_info {
 };
 
 enum {
-	ALLOC_STATUS_URB	= (1 << 0),
-	SUBMIT_STATUS_URB	= (1 << 1),
+	SUBMIT_STATUS_URB	= (1 << 0),
 	ALLOC_DATA_IN_URB	= (1 << 2),
 	SUBMIT_DATA_IN_URB	= (1 << 3),
 	ALLOC_DATA_OUT_URB	= (1 << 4),
@@ -116,7 +115,6 @@ struct uas_cmd_info {
 	unsigned int state;
 	unsigned int stream;
 	struct urb *cmd_urb;
-	struct urb *status_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
 	struct list_head list;
@@ -208,6 +206,7 @@ static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	int err;
 
+	usb_free_urb(urb);
 	cmdinfo->state = direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
 	if (err) {
@@ -291,29 +290,35 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	return urb;
 }
 
-static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-					struct scsi_cmnd *cmnd, u16 stream_id)
+static int uas_submit_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
+		struct scsi_cmnd *cmnd, u16 stream_id)
 {
 	struct usb_device *udev = devinfo->udev;
-	struct urb *urb = usb_alloc_urb(0, gfp);
+	struct urb *urb;
 	struct sense_iu *iu;
+	int ret;
 
+	urb = usb_alloc_urb(0, gfp);
 	if (!urb)
-		goto out;
+		return -ENOMEM;
 
+	ret = -ENOMEM;
 	iu = kzalloc(sizeof(*iu), gfp);
 	if (!iu)
-		goto free;
+		goto out;
 
 	usb_fill_bulk_urb(urb, udev, devinfo->status_pipe, iu, sizeof(*iu),
-						uas_stat_cmplt, cmnd->device);
+			uas_stat_cmplt, cmnd->device);
 	urb->stream_id = stream_id;
 	urb->transfer_flags |= URB_FREE_BUFFER;
- out:
-	return urb;
- free:
+
+	ret = usb_submit_urb(urb, gfp);
+	if (ret)
+		goto out;
+	return 0;
+out:
 	usb_free_urb(urb);
-	return NULL;
+	return ret;
 }
 
 static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
@@ -369,20 +374,13 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 {
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 
-	if (cmdinfo->state & ALLOC_STATUS_URB) {
-		cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp, cmnd,
-							  cmdinfo->stream);
-		if (!cmdinfo->status_urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
-		cmdinfo->state &= ~ALLOC_STATUS_URB;
-	}
-
 	if (cmdinfo->state & SUBMIT_STATUS_URB) {
-		if (usb_submit_urb(cmdinfo->status_urb, gfp)) {
-			scmd_printk(KERN_INFO, cmnd,
-					"sense urb submission failure\n");
+		int ret;
+
+		ret = uas_submit_sense_urb(devinfo, gfp, cmnd,
+				cmdinfo->stream);
+		if (ret)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
-		}
 		cmdinfo->state &= ~SUBMIT_STATUS_URB;
 	}
 
@@ -464,8 +462,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	cmnd->scsi_done = done;
 
-	cmdinfo->state = ALLOC_STATUS_URB | SUBMIT_STATUS_URB |
-			ALLOC_CMD_URB | SUBMIT_CMD_URB;
+	cmdinfo->state = SUBMIT_STATUS_URB | ALLOC_CMD_URB | SUBMIT_CMD_URB;
 
 	switch (cmnd->sc_data_direction) {
 	case DMA_FROM_DEVICE:
@@ -485,10 +482,9 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	err = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
 	if (err) {
 		/* If we did nothing, give up now */
-		if (cmdinfo->state & SUBMIT_STATUS_URB) {
-			usb_free_urb(cmdinfo->status_urb);
+		if (cmdinfo->state & SUBMIT_STATUS_URB)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
-		}
+
 		spin_lock(&uas_work_lock);
 		list_add_tail(&cmdinfo->list, &uas_work_list);
 		spin_unlock(&uas_work_lock);
-- 
1.7.7.3

