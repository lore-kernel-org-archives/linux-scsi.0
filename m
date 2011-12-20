From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] usb/uas: one only one status URB/host on stream-less
 connection
Date: Tue, 20 Dec 2011 16:01:26 +0100
Message-ID: <20111220150126.GA29286@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:53470 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1LTPB1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2011 10:01:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

The status/sense URB is allocated on per-command basis. A read/write
looks the following way on a stream-less connection:

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
- receive statusY, oh I'm done for tag X. Cool call complete and free statusY.
- receive statusX, oh it is a read for tag Y. queue statusY & before we
  queue the read the the following message can be observed:
  |sd 0:0:0:0: [sda] sense urb submission failure
  followed by a second attempt with the same result.

In order to address this problem there only one status URB for each scsi
host (as suggested by Matthew) in case we don't have stream support.
This URB is requeued until the device removed. Nothing changes on stream
based endpoints.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Okay. That is the third patch of my UAS series. The only issue I'm aware
now is the fact that uas does not work on hcds which do not support sgs.
One bug at a time.....

 drivers/usb/storage/uas.c |   71 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index ecf2070..e3b936e 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -99,6 +99,8 @@ struct uas_dev_info {
 	unsigned use_streams:1;
 	unsigned uas_sense_old:1;
 	struct scsi_cmnd *cmnd;
+	/* only used if no stream support is available */
+	struct urb *status_urb;
 };
 
 enum {
@@ -117,6 +119,7 @@ struct uas_cmd_info {
 	unsigned int state;
 	unsigned int stream;
 	struct urb *cmd_urb;
+	/* only used if stream support is available */
 	struct urb *status_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
@@ -180,7 +183,6 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 
 	cmnd->result = sense_iu->status;
 	cmnd->scsi_done(cmnd);
-	usb_free_urb(urb);
 }
 
 static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
@@ -205,7 +207,6 @@ static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
 
 	cmnd->result = sense_iu->status;
 	cmnd->scsi_done(cmnd);
-	usb_free_urb(urb);
 }
 
 static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
@@ -214,7 +215,7 @@ static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	int err;
 
-	cmdinfo->state = direction | SUBMIT_STATUS_URB;
+	cmdinfo->state = direction;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
 	if (err) {
 		spin_lock(&uas_work_lock);
@@ -231,10 +232,12 @@ static void uas_stat_cmplt(struct urb *urb)
 	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
 	struct scsi_cmnd *cmnd;
 	u16 tag;
+	int ret;
 
 	if (urb->status) {
 		dev_err(&urb->dev->dev, "URB BAD STATUS %d\n", urb->status);
-		usb_free_urb(urb);
+		if (devinfo->use_streams)
+			usb_free_urb(urb);
 		return;
 	}
 
@@ -244,7 +247,13 @@ static void uas_stat_cmplt(struct urb *urb)
 	else
 		cmnd = scsi_host_find_tag(shost, tag - 1);
 	if (!cmnd) {
-		usb_free_urb(urb);
+		if (devinfo->use_streams) {
+			usb_free_urb(urb);
+			return;
+		}
+		ret = usb_submit_urb(urb, GFP_ATOMIC);
+		if (ret)
+			dev_err(&urb->dev->dev, "failed submit status urb\n");
 		return;
 	}
 
@@ -270,6 +279,15 @@ static void uas_stat_cmplt(struct urb *urb)
 		scmd_printk(KERN_ERR, cmnd,
 			"Bogus IU (%d) received on status pipe\n", iu->iu_id);
 	}
+
+	if (devinfo->use_streams) {
+		usb_free_urb(urb);
+		return;
+	}
+
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret)
+		dev_err(&urb->dev->dev, "failed submit status urb\n");
 }
 
 static void uas_data_cmplt(struct urb *urb)
@@ -300,7 +318,7 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 }
 
 static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-					struct scsi_cmnd *cmnd, u16 stream_id)
+		struct Scsi_Host *shost, u16 stream_id)
 {
 	struct usb_device *udev = devinfo->udev;
 	struct urb *urb = usb_alloc_urb(0, gfp);
@@ -314,7 +332,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 		goto free;
 
 	usb_fill_bulk_urb(urb, udev, devinfo->status_pipe, iu, sizeof(*iu),
-						uas_stat_cmplt, cmnd->device->host);
+						uas_stat_cmplt, shost);
 	urb->stream_id = stream_id;
 	urb->transfer_flags |= URB_FREE_BUFFER;
  out:
@@ -382,8 +400,8 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 
 	if (cmdinfo->state & ALLOC_STATUS_URB) {
-		cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp, cmnd,
-							  cmdinfo->stream);
+		cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp,
+				cmnd->device->host, cmdinfo->stream);
 		if (!cmdinfo->status_urb)
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		cmdinfo->state &= ~ALLOC_STATUS_URB;
@@ -492,7 +510,8 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	}
 
 	if (!devinfo->use_streams) {
-		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB);
+		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB |
+				ALLOC_STATUS_URB | SUBMIT_STATUS_URB);
 		cmdinfo->stream = 0;
 	}
 
@@ -691,6 +710,29 @@ static void uas_configure_endpoints(struct uas_dev_info *devinfo)
 	}
 }
 
+static int uas_alloc_status_urb(struct uas_dev_info *devinfo,
+		struct Scsi_Host *shost)
+{
+	if (devinfo->use_streams) {
+		devinfo->status_urb = NULL;
+		return 0;
+	}
+
+	devinfo->status_urb = uas_alloc_sense_urb(devinfo, GFP_KERNEL,
+			shost, 0);
+	if (!devinfo->status_urb)
+		goto err_s_urb;
+
+	if (usb_submit_urb(devinfo->status_urb, GFP_KERNEL))
+		goto err_submit_urb;
+
+	return 0;
+err_submit_urb:
+	usb_free_urb(devinfo->status_urb);
+err_s_urb:
+	return -ENOMEM;
+}
+
 static void uas_free_streams(struct uas_dev_info *devinfo)
 {
 	struct usb_device *udev = devinfo->udev;
@@ -745,10 +787,17 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	shost->hostdata[0] = (unsigned long)devinfo;
 
+	result = uas_alloc_status_urb(devinfo, shost);
+	if (result)
+		goto err_alloc_status;
+
 	scsi_scan_host(shost);
 	usb_set_intfdata(intf, shost);
 	return result;
 
+err_alloc_status:
+	scsi_remove_host(shost);
+	shost = NULL;
 deconfig_eps:
 	uas_free_streams(devinfo);
  free:
@@ -776,6 +825,8 @@ static void uas_disconnect(struct usb_interface *intf)
 	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
 
 	scsi_remove_host(shost);
+	usb_kill_urb(devinfo->status_urb);
+	usb_free_urb(devinfo->status_urb);
 	uas_free_streams(devinfo);
 	kfree(devinfo);
 }
-- 
1.7.7.3

