From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/7] uas: fix sense urb handling
Date: Tue, 19 Jun 2012 09:54:50 +0200
Message-ID: <1340092494-18876-4-git-send-email-kraxel@redhat.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340092494-18876-1-git-send-email-kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Stop reusing sense urbs, just allocate a fresh one each time and free it
when done.

Stop storing a sense urb pointer in the scsi request, all you can do
with it is misusing.  For example requeuing the sense urb, then f*ck it
up by picking the wrong one in case tagged requests don't finish in the
same order you've submitted them.  Also note that (not-yet supported)
task management ops don't have a scsi request in the first place.

Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c |   49 +++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 36279a4..b012738 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -49,7 +49,6 @@ struct uas_dev_info {
 };
 
 enum {
-	ALLOC_STATUS_URB	= (1 << 0),
 	SUBMIT_STATUS_URB	= (1 << 1),
 	ALLOC_DATA_IN_URB	= (1 << 2),
 	SUBMIT_DATA_IN_URB	= (1 << 3),
@@ -64,7 +63,6 @@ struct uas_cmd_info {
 	unsigned int state;
 	unsigned int stream;
 	struct urb *cmd_urb;
-	struct urb *status_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
 	struct list_head list;
@@ -127,7 +125,6 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 
 	cmnd->result = sense_iu->status;
 	cmnd->scsi_done(cmnd);
-	usb_free_urb(urb);
 }
 
 static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
@@ -152,7 +149,6 @@ static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
 
 	cmnd->result = sense_iu->status;
 	cmnd->scsi_done(cmnd);
-	usb_free_urb(urb);
 }
 
 static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
@@ -217,6 +213,7 @@ static void uas_stat_cmplt(struct urb *urb)
 		scmd_printk(KERN_ERR, cmnd,
 			"Bogus IU (%d) received on status pipe\n", iu->iu_id);
 	}
+	usb_free_urb(urb);
 }
 
 static void uas_data_cmplt(struct urb *urb)
@@ -247,7 +244,7 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 }
 
 static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-					struct scsi_cmnd *cmnd, u16 stream_id)
+				       struct Scsi_Host *shost, u16 stream_id)
 {
 	struct usb_device *udev = devinfo->udev;
 	struct urb *urb = usb_alloc_urb(0, gfp);
@@ -261,7 +258,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 		goto free;
 
 	usb_fill_bulk_urb(urb, udev, devinfo->status_pipe, iu, sizeof(*iu),
-						uas_stat_cmplt, cmnd->device->host);
+						uas_stat_cmplt, shost);
 	urb->stream_id = stream_id;
 	urb->transfer_flags |= URB_FREE_BUFFER;
  out:
@@ -317,24 +314,35 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
  * daft to me.
  */
 
-static int uas_submit_urbs(struct scsi_cmnd *cmnd,
-					struct uas_dev_info *devinfo, gfp_t gfp)
+static int uas_submit_sense_urb(struct Scsi_Host *shost,
+				gfp_t gfp, unsigned int stream)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
+	struct urb *urb;
 
-	if (cmdinfo->state & ALLOC_STATUS_URB) {
-		cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp, cmnd,
-							  cmdinfo->stream);
-		if (!cmdinfo->status_urb)
-			return SCSI_MLQUEUE_DEVICE_BUSY;
-		cmdinfo->state &= ~ALLOC_STATUS_URB;
+	urb = uas_alloc_sense_urb(devinfo, gfp, shost, stream);
+	if (!urb)
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+	if (usb_submit_urb(urb, gfp)) {
+		shost_printk(KERN_INFO, shost,
+			     "sense urb submission failure\n");
+		usb_free_urb(urb);
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
+	return 0;
+}
+
+static int uas_submit_urbs(struct scsi_cmnd *cmnd,
+			   struct uas_dev_info *devinfo, gfp_t gfp)
+{
+	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	int err;
 
 	if (cmdinfo->state & SUBMIT_STATUS_URB) {
-		if (usb_submit_urb(cmdinfo->status_urb, gfp)) {
-			scmd_printk(KERN_INFO, cmnd,
-					"sense urb submission failure\n");
-			return SCSI_MLQUEUE_DEVICE_BUSY;
+		err = uas_submit_sense_urb(cmnd->device->host, gfp,
+					   cmdinfo->stream);
+		if (err) {
+			return err;
 		}
 		cmdinfo->state &= ~SUBMIT_STATUS_URB;
 	}
@@ -417,7 +425,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	cmnd->scsi_done = done;
 
-	cmdinfo->state = ALLOC_STATUS_URB | SUBMIT_STATUS_URB |
+	cmdinfo->state = SUBMIT_STATUS_URB |
 			ALLOC_CMD_URB | SUBMIT_CMD_URB;
 
 	switch (cmnd->sc_data_direction) {
@@ -441,7 +449,6 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	if (err) {
 		/* If we did nothing, give up now */
 		if (cmdinfo->state & SUBMIT_STATUS_URB) {
-			usb_free_urb(cmdinfo->status_urb);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		spin_lock(&uas_work_lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
