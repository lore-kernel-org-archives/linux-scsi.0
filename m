From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] usb/uas: use scsi_host_find_tag() to find command from a
 tag
Date: Mon, 19 Dec 2011 20:39:55 +0100
Message-ID: <20111219193955.GA2060@linutronix.de>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
 <20111214225331.GA5508@xanatos>
 <4EE9B375.4020606@linutronix.de>
 <20111215211201.GA6482@xanatos>
 <20111216144724.GC19563@linutronix.de>
 <20111216201236.GE19563@linutronix.de>
 <20111216203146.GN14291@linux.intel.com>
 <20111216204241.GA30915@linutronix.de>
 <20111216213628.GA5509@xanatos>
 <1324072059.10429.27.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:49773 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1LSTj7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2011 14:39:59 -0500
Content-Disposition: inline
In-Reply-To: <1324072059.10429.27.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

In "usb/uas: use unique tags for all LUNs" we make sure to create unique
tags across all LUNs. This patch uses scsi_host_find_tag() to obtain the
correct command which is associated with the tag.
The following changes were required:
- don't use sdev->current_cmnd anymore
  Since be can have devices which don't support command tagging we must
  ensure that we can tell the two commands apart. devinfo->cmnd is used
  for this.
- tag number are altered. On SuperSpeed the tag number must match the
  stream number. Therefore we can't use tag and must start at tag 1.
  In case we have untagged commands (atleast the first command and if
  the device does not support tagging) we must be able to distinguish
  between command tag 0 (which becomes 1) and untagged command.
  the following tag numbers are used:
  0: never
  1: for untagged commands (devinfo->cmnd)
  2+: tagged commands.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Sarah this is the second piece. Now it shouldn't be a problem anymore to
get one status URB in case streams are not used.

 drivers/usb/storage/uas.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 4a8c062..ecf2070 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -98,6 +98,7 @@ struct uas_dev_info {
 	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
 	unsigned use_streams:1;
 	unsigned uas_sense_old:1;
+	struct scsi_cmnd *cmnd;
 };
 
 enum {
@@ -178,8 +179,6 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 	}
 
 	cmnd->result = sense_iu->status;
-	if (sdev->current_cmnd)
-		sdev->current_cmnd = NULL;
 	cmnd->scsi_done(cmnd);
 	usb_free_urb(urb);
 }
@@ -205,8 +204,6 @@ static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
 	}
 
 	cmnd->result = sense_iu->status;
-	if (sdev->current_cmnd)
-		sdev->current_cmnd = NULL;
 	cmnd->scsi_done(cmnd);
 	usb_free_urb(urb);
 }
@@ -230,8 +227,8 @@ static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 static void uas_stat_cmplt(struct urb *urb)
 {
 	struct iu *iu = urb->transfer_buffer;
-	struct scsi_device *sdev = urb->context;
-	struct uas_dev_info *devinfo = sdev->hostdata;
+	struct Scsi_Host *shost = urb->context;
+	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
 	struct scsi_cmnd *cmnd;
 	u16 tag;
 
@@ -242,10 +239,10 @@ static void uas_stat_cmplt(struct urb *urb)
 	}
 
 	tag = be16_to_cpup(&iu->tag) - 1;
-	if (sdev->current_cmnd)
-		cmnd = sdev->current_cmnd;
+	if (tag == 0)
+		cmnd = devinfo->cmnd;
 	else
-		cmnd = scsi_find_tag(sdev, tag);
+		cmnd = scsi_host_find_tag(shost, tag - 1);
 	if (!cmnd) {
 		usb_free_urb(urb);
 		return;
@@ -253,6 +250,9 @@ static void uas_stat_cmplt(struct urb *urb)
 
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
+		if (devinfo->cmnd == cmnd)
+			devinfo->cmnd = NULL;
+
 		if (urb->actual_length < 16)
 			devinfo->uas_sense_old = 1;
 		if (devinfo->uas_sense_old)
@@ -314,7 +314,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 		goto free;
 
 	usb_fill_bulk_urb(urb, udev, devinfo->status_pipe, iu, sizeof(*iu),
-						uas_stat_cmplt, cmnd->device);
+						uas_stat_cmplt, cmnd->device->host);
 	urb->stream_id = stream_id;
 	urb->transfer_flags |= URB_FREE_BUFFER;
  out:
@@ -346,7 +346,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 
 	iu->iu_id = IU_ID_COMMAND;
 	if (blk_rq_tagged(cmnd->request))
-		iu->tag = cpu_to_be16(cmnd->request->tag + 1);
+		iu->tag = cpu_to_be16(cmnd->request->tag + 2);
 	else
 		iu->tag = cpu_to_be16(1);
 
@@ -464,13 +464,13 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
-	if (!cmdinfo->status_urb && sdev->current_cmnd)
+	if (devinfo->cmnd)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
 	if (blk_rq_tagged(cmnd->request)) {
-		cmdinfo->stream = cmnd->request->tag + 1;
+		cmdinfo->stream = cmnd->request->tag + 2;
 	} else {
-		sdev->current_cmnd = cmnd;
+		devinfo->cmnd = cmnd;
 		cmdinfo->stream = 1;
 	}
 
@@ -571,7 +571,7 @@ static int uas_slave_configure(struct scsi_device *sdev)
 {
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	scsi_set_tag_type(sdev, MSG_ORDERED_TAG);
-	scsi_activate_tcq(sdev, devinfo->qdepth - 1);
+	scsi_activate_tcq(sdev, devinfo->qdepth - 2);
 	return 0;
 }
 
@@ -639,6 +639,7 @@ static void uas_configure_endpoints(struct uas_dev_info *devinfo)
 	unsigned i, n_endpoints = intf->cur_altsetting->desc.bNumEndpoints;
 
 	devinfo->uas_sense_old = 0;
+	devinfo->cmnd = NULL;
 
 	for (i = 0; i < n_endpoints; i++) {
 		unsigned char *extra = endpoint[i].extra;
@@ -734,7 +735,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	devinfo->udev = udev;
 	uas_configure_endpoints(devinfo);
 
-	result = scsi_init_shared_tag_map(shost, devinfo->qdepth - 1);
+	result = scsi_init_shared_tag_map(shost, devinfo->qdepth - 2);
 	if (result)
 		goto free;
 
-- 
1.7.7.3

