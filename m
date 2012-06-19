From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 4/7] uas: keep track of command state, finish scsi cmd when really done.
Date: Tue, 19 Jun 2012 09:54:51 +0200
Message-ID: <1340092494-18876-5-git-send-email-kraxel@redhat.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab2FSHy5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2012 03:54:57 -0400
In-Reply-To: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>

Set state bits after submitting data urbs & command urbs, so we know
what is in flight.  Clear data bits when the data urb is finished, clear
command bit when we see the status urb for the command.  Finish the scsi
command after running both status and data completion handlers for the
command.

Add a cmd status logging function for debugging purposes.  Hook it into
the error handler, so we see in the log what status a command is in
which the scsi layer wants cancel.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/uas.c |   86 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index b012738..b589b2e 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -56,6 +56,10 @@ enum {
 	SUBMIT_DATA_OUT_URB	= (1 << 5),
 	ALLOC_CMD_URB		= (1 << 6),
 	SUBMIT_CMD_URB		= (1 << 7),
+	COMMAND_INFLIGHT        = (1 << 8),
+	DATA_IN_URB_INFLIGHT    = (1 << 9),
+	DATA_OUT_URB_INFLIGHT   = (1 << 10),
+	COMMAND_COMPLETED       = (1 << 11),
 };
 
 /* Overrides scsi_pointer */
@@ -124,7 +128,6 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 	}
 
 	cmnd->result = sense_iu->status;
-	cmnd->scsi_done(cmnd);
 }
 
 static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
@@ -148,16 +151,51 @@ static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
 	}
 
 	cmnd->result = sense_iu->status;
+}
+
+static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *caller)
+{
+	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
+
+	scmd_printk(KERN_INFO, cmnd, "%s %p tag %d, inflight:"
+		    "%s%s%s%s%s%s%s%s%s%s%s\n",
+		    caller, cmnd, cmnd->request->tag,
+		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
+		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
+		    (ci->state & SUBMIT_DATA_IN_URB)    ? " s-in"  : "",
+		    (ci->state & ALLOC_DATA_OUT_URB)    ? " a-out" : "",
+		    (ci->state & SUBMIT_DATA_OUT_URB)   ? " s-out" : "",
+		    (ci->state & ALLOC_CMD_URB)         ? " a-cmd" : "",
+		    (ci->state & SUBMIT_CMD_URB)        ? " s-cmd" : "",
+		    (ci->state & COMMAND_INFLIGHT)      ? " CMD"   : "",
+		    (ci->state & DATA_IN_URB_INFLIGHT)  ? " IN"    : "",
+		    (ci->state & DATA_OUT_URB_INFLIGHT) ? " OUT"   : "",
+		    (ci->state & COMMAND_COMPLETED)     ? " done"  : "");
+}
+
+static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
+{
+	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+
+	if (cmdinfo->state & (COMMAND_INFLIGHT |
+			      DATA_IN_URB_INFLIGHT |
+			      DATA_OUT_URB_INFLIGHT))
+		return -EBUSY;
+	BUG_ON(cmdinfo->state & COMMAND_COMPLETED);
+	cmdinfo->state |= COMMAND_COMPLETED;
+	usb_free_urb(cmdinfo->data_in_urb);
+	usb_free_urb(cmdinfo->data_out_urb);
 	cmnd->scsi_done(cmnd);
+	return 0;
 }
 
 static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
-							unsigned direction)
+			  unsigned direction)
 {
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	int err;
 
-	cmdinfo->state = direction | SUBMIT_STATUS_URB;
+	cmdinfo->state |= direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
 	if (err) {
 		spin_lock(&uas_work_lock);
@@ -173,6 +211,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	struct Scsi_Host *shost = urb->context;
 	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
 	struct scsi_cmnd *cmnd;
+	struct uas_cmd_info *cmdinfo;
 	u16 tag;
 
 	if (urb->status) {
@@ -190,6 +229,7 @@ static void uas_stat_cmplt(struct urb *urb)
 		usb_free_urb(urb);
 		return;
 	}
+	cmdinfo = (void *)&cmnd->SCp;
 
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
@@ -202,6 +242,8 @@ static void uas_stat_cmplt(struct urb *urb)
 			uas_sense_old(urb, cmnd);
 		else
 			uas_sense(urb, cmnd);
+		cmdinfo->state &= ~COMMAND_INFLIGHT;
+		uas_try_complete(cmnd, __func__);
 		break;
 	case IU_ID_READ_READY:
 		uas_xfer_data(urb, cmnd, SUBMIT_DATA_IN_URB);
@@ -218,23 +260,36 @@ static void uas_stat_cmplt(struct urb *urb)
 
 static void uas_data_cmplt(struct urb *urb)
 {
-	struct scsi_data_buffer *sdb = urb->context;
+	struct scsi_cmnd *cmnd = urb->context;
+	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct scsi_data_buffer *sdb = NULL;
+
+	if (cmdinfo->data_in_urb == urb) {
+		sdb = scsi_in(cmnd);
+		cmdinfo->state &= ~DATA_IN_URB_INFLIGHT;
+	} else if (cmdinfo->data_out_urb == urb) {
+		sdb = scsi_out(cmnd);
+		cmdinfo->state &= ~DATA_OUT_URB_INFLIGHT;
+	}
+	BUG_ON(sdb == NULL);
 	sdb->resid = sdb->length - urb->actual_length;
-	usb_free_urb(urb);
+	uas_try_complete(cmnd, __func__);
 }
 
 static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-				unsigned int pipe, u16 stream_id,
-				struct scsi_data_buffer *sdb,
-				enum dma_data_direction dir)
+				      unsigned int pipe, u16 stream_id,
+				      struct scsi_cmnd *cmnd,
+				      enum dma_data_direction dir)
 {
 	struct usb_device *udev = devinfo->udev;
 	struct urb *urb = usb_alloc_urb(0, gfp);
+	struct scsi_data_buffer *sdb = (dir == DMA_FROM_DEVICE)
+		? scsi_in(cmnd) : scsi_out(cmnd);
 
 	if (!urb)
 		goto out;
-	usb_fill_bulk_urb(urb, udev, pipe, NULL, sdb->length, uas_data_cmplt,
-									sdb);
+	usb_fill_bulk_urb(urb, udev, pipe, NULL, sdb->length,
+			  uas_data_cmplt, cmnd);
 	if (devinfo->use_streams)
 		urb->stream_id = stream_id;
 	urb->num_sgs = udev->bus->sg_tablesize ? sdb->table.nents : 0;
@@ -350,7 +405,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 	if (cmdinfo->state & ALLOC_DATA_IN_URB) {
 		cmdinfo->data_in_urb = uas_alloc_data_urb(devinfo, gfp,
 					devinfo->data_in_pipe, cmdinfo->stream,
-					scsi_in(cmnd), DMA_FROM_DEVICE);
+					cmnd, DMA_FROM_DEVICE);
 		if (!cmdinfo->data_in_urb)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		cmdinfo->state &= ~ALLOC_DATA_IN_URB;
@@ -363,12 +418,13 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_IN_URB;
+		cmdinfo->state |= DATA_IN_URB_INFLIGHT;
 	}
 
 	if (cmdinfo->state & ALLOC_DATA_OUT_URB) {
 		cmdinfo->data_out_urb = uas_alloc_data_urb(devinfo, gfp,
 					devinfo->data_out_pipe, cmdinfo->stream,
-					scsi_out(cmnd), DMA_TO_DEVICE);
+					cmnd, DMA_TO_DEVICE);
 		if (!cmdinfo->data_out_urb)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		cmdinfo->state &= ~ALLOC_DATA_OUT_URB;
@@ -381,6 +437,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_OUT_URB;
+		cmdinfo->state |= DATA_OUT_URB_INFLIGHT;
 	}
 
 	if (cmdinfo->state & ALLOC_CMD_URB) {
@@ -398,6 +455,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		cmdinfo->state &= ~SUBMIT_CMD_URB;
+		cmdinfo->state |= COMMAND_INFLIGHT;
 	}
 
 	return 0;
@@ -464,9 +522,7 @@ static DEF_SCSI_QCMD(uas_queuecommand)
 
 static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 {
-	struct scsi_device *sdev = cmnd->device;
-	sdev_printk(KERN_INFO, sdev, "%s tag %d\n", __func__,
-							cmnd->request->tag);
+	uas_log_cmd_state(cmnd, __func__);
 
 /* XXX: Send ABORT TASK Task Management command */
 	return FAILED;
-- 
1.7.1

