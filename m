From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/2] uas: Reduce number of function arguments for uas_alloc_foo functions
Date: Fri,  3 Oct 2014 12:08:56 +0200
Message-ID: <1412330937-22630-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The stream_id and pipe are already present in uas_cmd_info resp uas_dev_info,
so there is no need to pass a copy along.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/usb/storage/uas.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index f62ef61..89b2434 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -412,20 +412,22 @@ static void uas_cmd_cmplt(struct urb *urb)
 }
 
 static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-				      unsigned int pipe, u16 stream_id,
 				      struct scsi_cmnd *cmnd,
 				      enum dma_data_direction dir)
 {
 	struct usb_device *udev = devinfo->udev;
+	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	struct urb *urb = usb_alloc_urb(0, gfp);
 	struct scsi_data_buffer *sdb = (dir == DMA_FROM_DEVICE)
 		? scsi_in(cmnd) : scsi_out(cmnd);
+	unsigned int pipe = (dir == DMA_FROM_DEVICE)
+		? devinfo->data_in_pipe : devinfo->data_out_pipe;
 
 	if (!urb)
 		goto out;
 	usb_fill_bulk_urb(urb, udev, pipe, NULL, sdb->length,
 			  uas_data_cmplt, cmnd);
-	urb->stream_id = stream_id;
+	urb->stream_id = cmdinfo->stream;
 	urb->num_sgs = udev->bus->sg_tablesize ? sdb->table.nents : 0;
 	urb->sg = sdb->table.sgl;
  out:
@@ -433,9 +435,10 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 }
 
 static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-				       struct Scsi_Host *shost, u16 stream_id)
+				       struct scsi_cmnd *cmnd)
 {
 	struct usb_device *udev = devinfo->udev;
+	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	struct urb *urb = usb_alloc_urb(0, gfp);
 	struct sense_iu *iu;
 
@@ -447,8 +450,8 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 		goto free;
 
 	usb_fill_bulk_urb(urb, udev, devinfo->status_pipe, iu, sizeof(*iu),
-						uas_stat_cmplt, shost);
-	urb->stream_id = stream_id;
+			  uas_stat_cmplt, cmnd->device->host);
+	urb->stream_id = cmdinfo->stream;
 	urb->transfer_flags |= URB_FREE_BUFFER;
  out:
 	return urb;
@@ -500,15 +503,13 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
  * daft to me.
  */
 
-static struct urb *uas_submit_sense_urb(struct scsi_cmnd *cmnd,
-					gfp_t gfp, unsigned int stream)
+static struct urb *uas_submit_sense_urb(struct scsi_cmnd *cmnd, gfp_t gfp)
 {
-	struct Scsi_Host *shost = cmnd->device->host;
-	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
+	struct uas_dev_info *devinfo = cmnd->device->hostdata;
 	struct urb *urb;
 	int err;
 
-	urb = uas_alloc_sense_urb(devinfo, gfp, shost, stream);
+	urb = uas_alloc_sense_urb(devinfo, gfp, cmnd);
 	if (!urb)
 		return NULL;
 	usb_anchor_urb(urb, &devinfo->sense_urbs);
@@ -531,7 +532,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 
 	lockdep_assert_held(&devinfo->lock);
 	if (cmdinfo->state & SUBMIT_STATUS_URB) {
-		urb = uas_submit_sense_urb(cmnd, gfp, cmdinfo->stream);
+		urb = uas_submit_sense_urb(cmnd, gfp);
 		if (!urb)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		cmdinfo->state &= ~SUBMIT_STATUS_URB;
@@ -539,8 +540,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 
 	if (cmdinfo->state & ALLOC_DATA_IN_URB) {
 		cmdinfo->data_in_urb = uas_alloc_data_urb(devinfo, gfp,
-					devinfo->data_in_pipe, cmdinfo->stream,
-					cmnd, DMA_FROM_DEVICE);
+							cmnd, DMA_FROM_DEVICE);
 		if (!cmdinfo->data_in_urb)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		cmdinfo->state &= ~ALLOC_DATA_IN_URB;
@@ -560,8 +560,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 
 	if (cmdinfo->state & ALLOC_DATA_OUT_URB) {
 		cmdinfo->data_out_urb = uas_alloc_data_urb(devinfo, gfp,
-					devinfo->data_out_pipe, cmdinfo->stream,
-					cmnd, DMA_TO_DEVICE);
+							cmnd, DMA_TO_DEVICE);
 		if (!cmdinfo->data_out_urb)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		cmdinfo->state &= ~ALLOC_DATA_OUT_URB;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
