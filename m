From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/7] Revert "usb/uas: one only one status URB/host on stream-less connection"
Date: Tue, 19 Jun 2012 09:54:49 +0200
Message-ID: <1340092494-18876-3-git-send-email-kraxel@redhat.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340092494-18876-1-git-send-email-kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This reverts commit ceb3f91fd53c9fbd7b292fc2754ba4efffeeeedb.

IMO the real bug is assigning status urbs to scsi requests.  First there
is no such link in the non-stream case.  Also there isn't nessesarely a
scsi request in the first place, for example when submitting task
management requests.

This patch just papers over the real bug and introduces different status
urb handling in the stream/non-stream case for no good reason.

Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c |   70 ++++++--------------------------------------
 1 files changed, 10 insertions(+), 60 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index f98ba40..36279a4 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -46,7 +46,6 @@ struct uas_dev_info {
 	unsigned use_streams:1;
 	unsigned uas_sense_old:1;
 	struct scsi_cmnd *cmnd;
-	struct urb *status_urb; /* used only if stream support is available */
 };
 
 enum {
@@ -65,7 +64,6 @@ struct uas_cmd_info {
 	unsigned int state;
 	unsigned int stream;
 	struct urb *cmd_urb;
-	/* status_urb is used only if stream support isn't available */
 	struct urb *status_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
@@ -129,6 +127,7 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 
 	cmnd->result = sense_iu->status;
 	cmnd->scsi_done(cmnd);
+	usb_free_urb(urb);
 }
 
 static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
@@ -153,6 +152,7 @@ static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
 
 	cmnd->result = sense_iu->status;
 	cmnd->scsi_done(cmnd);
+	usb_free_urb(urb);
 }
 
 static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
@@ -161,7 +161,7 @@ static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	int err;
 
-	cmdinfo->state = direction;
+	cmdinfo->state = direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
 	if (err) {
 		spin_lock(&uas_work_lock);
@@ -178,12 +178,10 @@ static void uas_stat_cmplt(struct urb *urb)
 	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
 	struct scsi_cmnd *cmnd;
 	u16 tag;
-	int ret;
 
 	if (urb->status) {
 		dev_err(&urb->dev->dev, "URB BAD STATUS %d\n", urb->status);
-		if (devinfo->use_streams)
-			usb_free_urb(urb);
+		usb_free_urb(urb);
 		return;
 	}
 
@@ -193,13 +191,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	else
 		cmnd = scsi_host_find_tag(shost, tag - 1);
 	if (!cmnd) {
-		if (devinfo->use_streams) {
-			usb_free_urb(urb);
-			return;
-		}
-		ret = usb_submit_urb(urb, GFP_ATOMIC);
-		if (ret)
-			dev_err(&urb->dev->dev, "failed submit status urb\n");
+		usb_free_urb(urb);
 		return;
 	}
 
@@ -225,15 +217,6 @@ static void uas_stat_cmplt(struct urb *urb)
 		scmd_printk(KERN_ERR, cmnd,
 			"Bogus IU (%d) received on status pipe\n", iu->iu_id);
 	}
-
-	if (devinfo->use_streams) {
-		usb_free_urb(urb);
-		return;
-	}
-
-	ret = usb_submit_urb(urb, GFP_ATOMIC);
-	if (ret)
-		dev_err(&urb->dev->dev, "failed submit status urb\n");
 }
 
 static void uas_data_cmplt(struct urb *urb)
@@ -264,7 +247,7 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 }
 
 static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-		struct Scsi_Host *shost, u16 stream_id)
+					struct scsi_cmnd *cmnd, u16 stream_id)
 {
 	struct usb_device *udev = devinfo->udev;
 	struct urb *urb = usb_alloc_urb(0, gfp);
@@ -278,7 +261,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 		goto free;
 
 	usb_fill_bulk_urb(urb, udev, devinfo->status_pipe, iu, sizeof(*iu),
-						uas_stat_cmplt, shost);
+						uas_stat_cmplt, cmnd->device->host);
 	urb->stream_id = stream_id;
 	urb->transfer_flags |= URB_FREE_BUFFER;
  out:
@@ -340,8 +323,8 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 
 	if (cmdinfo->state & ALLOC_STATUS_URB) {
-		cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp,
-				cmnd->device->host, cmdinfo->stream);
+		cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp, cmnd,
+							  cmdinfo->stream);
 		if (!cmdinfo->status_urb)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		cmdinfo->state &= ~ALLOC_STATUS_URB;
@@ -450,8 +433,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	}
 
 	if (!devinfo->use_streams) {
-		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB |
-				ALLOC_STATUS_URB | SUBMIT_STATUS_URB);
+		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB);
 		cmdinfo->stream = 0;
 	}
 
@@ -662,29 +644,6 @@ static void uas_configure_endpoints(struct uas_dev_info *devinfo)
 	}
 }
 
-static int uas_alloc_status_urb(struct uas_dev_info *devinfo,
-		struct Scsi_Host *shost)
-{
-	if (devinfo->use_streams) {
-		devinfo->status_urb = NULL;
-		return 0;
-	}
-
-	devinfo->status_urb = uas_alloc_sense_urb(devinfo, GFP_KERNEL,
-			shost, 0);
-	if (!devinfo->status_urb)
-		goto err_s_urb;
-
-	if (usb_submit_urb(devinfo->status_urb, GFP_KERNEL))
-		goto err_submit_urb;
-
-	return 0;
-err_submit_urb:
-	usb_free_urb(devinfo->status_urb);
-err_s_urb:
-	return -ENOMEM;
-}
-
 static void uas_free_streams(struct uas_dev_info *devinfo)
 {
 	struct usb_device *udev = devinfo->udev;
@@ -739,17 +698,10 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	shost->hostdata[0] = (unsigned long)devinfo;
 
-	result = uas_alloc_status_urb(devinfo, shost);
-	if (result)
-		goto err_alloc_status;
