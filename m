From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v3] uas: Make uas work with blk-mq
Date: Sun, 12 Oct 2014 12:19:40 +0200
Message-ID: <1413109180-10522-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaJLKUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Oct 2014 06:20:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Christoph Hellwig <hch@infradead.org>

With uas over usb-3 the tags inside the uas iu-s must match the usb-3 stream
ids, and those go from 1 - qdepth.

Before blk-mq calling scsi_activate_tcq(sdev, qdepth) guaranteed that we would
only get cmnd->request->tag from 0 - (qdepth - 1), and we used those as
uas-tags / stream-ids.

With blk-mq however we are guaranteed to never get more then qdepth commands
queued at the same time, but the cmnd->request->tag values may be much larger,
which breaks uas.

This commit fixes this by generating uas tags in the 1 - qdepth range ourselves
instead of using cmnd->request->tag.

While touching all involved code anyways also rename the uas_cmd_info stream
field to uas_tag, because when using uas over usb-2 streams are not used.

Cc: Christoph Hellwig <hch@infradead.org>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>

--
Changes in v2:
-Remove ".disable_blk_mq = true" from uas_host_template
Changes in v3:
-Rebased on top of Linus' current master branch
---
 drivers/usb/storage/uas.c | 64 +++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 41 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 89b2434..004ebc1 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -66,7 +66,7 @@ enum {
 /* Overrides scsi_pointer */
 struct uas_cmd_info {
 	unsigned int state;
-	unsigned int stream;
+	unsigned int uas_tag;
 	struct urb *cmd_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
@@ -173,30 +173,15 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 	cmnd->result = sense_iu->status;
 }
 
-/*
- * scsi-tags go from 0 - (nr_tags - 1), uas tags need to match stream-ids,
- * which go from 1 - nr_streams. And we use 1 for untagged commands.
- */
-static int uas_get_tag(struct scsi_cmnd *cmnd)
-{
-	int tag;
-
-	if (blk_rq_tagged(cmnd->request))
-		tag = cmnd->request->tag + 2;
-	else
-		tag = 1;
-
-	return tag;
-}
-
 static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *prefix,
 			      int status)
 {
 	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 
 	scmd_printk(KERN_INFO, cmnd,
-		    "%s %d tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
-		    prefix, status, uas_get_tag(cmnd),
+		    "%s %d uas-tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
+		    prefix, status, cmdinfo->uas_tag,
 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
 		    (ci->state & SUBMIT_DATA_IN_URB)    ? " s-in"  : "",
@@ -242,7 +227,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 			      DATA_OUT_URB_INFLIGHT |
 			      COMMAND_ABORTED))
 		return -EBUSY;
-	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
+	devinfo->cmnd[cmdinfo->uas_tag - 1] = NULL;
 	uas_free_unsubmitted_urbs(cmnd);
 	cmnd->scsi_done(cmnd);
 	return 0;
@@ -289,7 +274,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	idx = be16_to_cpup(&iu->tag) - 1;
 	if (idx >= MAX_CMNDS || !devinfo->cmnd[idx]) {
 		dev_err(&urb->dev->dev,
-			"stat urb: no pending cmd for tag %d\n", idx + 1);
+			"stat urb: no pending cmd for uas-tag %d\n", idx + 1);
 		goto out;
 	}
 
@@ -427,7 +412,8 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 		goto out;
 	usb_fill_bulk_urb(urb, udev, pipe, NULL, sdb->length,
 			  uas_data_cmplt, cmnd);
-	urb->stream_id = cmdinfo->stream;
+	if (devinfo->use_streams)
+		urb->stream_id = cmdinfo->uas_tag;
 	urb->num_sgs = udev->bus->sg_tablesize ? sdb->table.nents : 0;
 	urb->sg = sdb->table.sgl;
  out:
@@ -451,7 +437,8 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 
 	usb_fill_bulk_urb(urb, udev, devinfo->status_pipe, iu, sizeof(*iu),
 			  uas_stat_cmplt, cmnd->device->host);
-	urb->stream_id = cmdinfo->stream;
+	if (devinfo->use_streams)
+		urb->stream_id = cmdinfo->uas_tag;
 	urb->transfer_flags |= URB_FREE_BUFFER;
  out:
 	return urb;
@@ -465,6 +452,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 {
 	struct usb_device *udev = devinfo->udev;
 	struct scsi_device *sdev = cmnd->device;
+	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	struct urb *urb = usb_alloc_urb(0, gfp);
 	struct command_iu *iu;
 	int len;
@@ -481,7 +469,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 		goto free;
 
 	iu->iu_id = IU_ID_COMMAND;
-	iu->tag = cpu_to_be16(uas_get_tag(cmnd));
+	iu->tag = cpu_to_be16(cmdinfo->uas_tag);
 	iu->prio_attr = UAS_SIMPLE_TAG;
 	iu->len = len;
 	int_to_scsilun(sdev->lun, &iu->lun);
@@ -608,8 +596,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	unsigned long flags;
-	unsigned int stream;
-	int err;
+	int idx, err;
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
@@ -635,8 +622,12 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		return 0;
 	}
 
-	stream = uas_get_tag(cmnd);
-	if (devinfo->cmnd[stream - 1]) {
+	/* Find a free uas-tag */
+	for (idx = 0; idx < devinfo->qdepth; idx++) {
+		if (!devinfo->cmnd[idx])
+			break;
+	}
+	if (idx == devinfo->qdepth) {
 		spin_unlock_irqrestore(&devinfo->lock, flags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
@@ -644,7 +635,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	cmnd->scsi_done = done;
 
 	memset(cmdinfo, 0, sizeof(*cmdinfo));
-	cmdinfo->stream = stream;
+	cmdinfo->uas_tag = idx + 1; /* uas-tag == usb-stream-id, so 1 based */
 	cmdinfo->state = SUBMIT_STATUS_URB | ALLOC_CMD_URB | SUBMIT_CMD_URB;
 
 	switch (cmnd->sc_data_direction) {
@@ -659,10 +650,8 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		break;
 	}
 
-	if (!devinfo->use_streams) {
+	if (!devinfo->use_streams)
 		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB);
-		cmdinfo->stream = 0;
-	}
 
 	err = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
 	if (err) {
@@ -674,7 +663,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		uas_add_work(cmdinfo);
 	}
 
-	devinfo->cmnd[stream - 1] = cmnd;
+	devinfo->cmnd[idx] = cmnd;
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 	return 0;
 }
@@ -702,7 +691,7 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 	cmdinfo->state |= COMMAND_ABORTED;
 
 	/* Drop all refs to this cmnd, kill data urbs to break their ref */
-	devinfo->cmnd[uas_get_tag(cmnd) - 1] = NULL;
+	devinfo->cmnd[cmdinfo->uas_tag - 1] = NULL;
 	if (cmdinfo->state & DATA_IN_URB_INFLIGHT)
 		data_in_urb = usb_get_urb(cmdinfo->data_in_urb);
 	if (cmdinfo->state & DATA_OUT_URB_INFLIGHT)
@@ -818,13 +807,6 @@ static struct scsi_host_template uas_host_template = {
 	.cmd_per_lun = 1,	/* until we override it */
 	.skip_settle_delay = 1,
 	.ordered_tag = 1,
-
-	/*
-	 * The uas drivers expects tags not to be bigger than the maximum
-	 * per-device queue depth, which is not true with the blk-mq tag
-	 * allocator.
-	 */
-	.disable_blk_mq = true,
 };
 
 #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
-- 
2.1.0

