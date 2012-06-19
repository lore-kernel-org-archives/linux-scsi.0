From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 6/7] uas: track urbs, kill inflight urbs on disconnect.
Date: Tue, 19 Jun 2012 09:54:53 +0200
Message-ID: <1340092494-18876-7-git-send-email-kraxel@redhat.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab2FSHy6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2012 03:54:58 -0400
In-Reply-To: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>

Use separate anchors for data and sense urbs, which
I think will be useful when implementing error handling.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/uas.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index d8b7bc6..875829a 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -41,6 +41,8 @@ struct sense_iu_old {
 struct uas_dev_info {
 	struct usb_interface *intf;
 	struct usb_device *udev;
+	struct usb_anchor sense_urbs;
+	struct usb_anchor data_urbs;
 	int qdepth;
 	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
 	unsigned use_streams:1;
@@ -396,6 +398,7 @@ static int uas_submit_sense_urb(struct Scsi_Host *shost,
 		usb_free_urb(urb);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
+	usb_anchor_urb(urb, &devinfo->sense_urbs);
 	return 0;
 }
 
@@ -431,6 +434,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_IN_URB;
 		cmdinfo->state |= DATA_IN_URB_INFLIGHT;
+		usb_anchor_urb(cmdinfo->data_in_urb, &devinfo->data_urbs);
 	}
 
 	if (cmdinfo->state & ALLOC_DATA_OUT_URB) {
@@ -450,6 +454,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 		}
 		cmdinfo->state &= ~SUBMIT_DATA_OUT_URB;
 		cmdinfo->state |= DATA_OUT_URB_INFLIGHT;
+		usb_anchor_urb(cmdinfo->data_out_urb, &devinfo->data_urbs);
 	}
 
 	if (cmdinfo->state & ALLOC_CMD_URB) {
@@ -761,6 +766,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	devinfo->intf = intf;
 	devinfo->udev = udev;
+	init_usb_anchor(&devinfo->sense_urbs);
+	init_usb_anchor(&devinfo->data_urbs);
 	uas_configure_endpoints(devinfo);
 
 	result = scsi_init_shared_tag_map(shost, devinfo->qdepth - 2);
@@ -804,6 +811,8 @@ static void uas_disconnect(struct usb_interface *intf)
 	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
 
 	scsi_remove_host(shost);
+	usb_kill_anchored_urbs(&devinfo->sense_urbs);
+	usb_kill_anchored_urbs(&devinfo->data_urbs);
 	uas_free_streams(devinfo);
 	kfree(devinfo);
 }
-- 
1.7.1

