From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 20/24] uas: Remove support for old sense ui as used in pre-production hardware
Date: Sat, 13 Sep 2014 12:26:47 +0200
Message-ID: <1410604011-3828-21-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaIMK11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:27:27 -0400
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

I've access to a number of different uas devices now, and none of them use
old style sense urbs. The only case where these code-paths trigger is with
the asm1051 and there they do the wrong thing, as the asm1051 sends 8 bytes
status iu-s when it does not have any sense data, but uses new style
sense iu-s regardless, as can be seen for scsi cmnds where there is sense
data.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 47 +----------------------------------------------
 1 file changed, 1 insertion(+), 46 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index c6f7870..cbd4312 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -32,20 +32,6 @@
 
 #define MAX_CMNDS 256
 
-/*
- * The r00-r01c specs define this version of the SENSE IU data structure.
- * It's still in use by several different firmware releases.
- */
-struct sense_iu_old {
-	__u8 iu_id;
-	__u8 rsvd1;
-	__be16 tag;
-	__be16 len;
-	__u8 status;
-	__u8 service_response;
-	__u8 sense[SCSI_SENSE_BUFFERSIZE];
-};
-
 struct uas_dev_info {
 	struct usb_interface *intf;
 	struct usb_device *udev;
@@ -56,7 +42,6 @@ struct uas_dev_info {
 	int qdepth, resetting;
 	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
 	unsigned use_streams:1;
-	unsigned uas_sense_old:1;
 	unsigned shutdown:1;
 	struct scsi_cmnd *cmnd[MAX_CMNDS];
 	spinlock_t lock;
@@ -187,29 +172,6 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 	cmnd->result = sense_iu->status;
 }
 
-static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
-{
-	struct sense_iu_old *sense_iu = urb->transfer_buffer;
-	struct scsi_device *sdev = cmnd->device;
-
-	if (urb->actual_length > 8) {
-		unsigned len = be16_to_cpup(&sense_iu->len) - 2;
-		if (len + 8 != urb->actual_length) {
-			int newlen = min(len + 8, urb->actual_length) - 8;
-			if (newlen < 0)
-				newlen = 0;
-			sdev_printk(KERN_INFO, sdev, "%s: urb length %d "
-				"disagrees with IU sense data length %d, "
-				"using %d bytes of sense data\n", __func__,
-					urb->actual_length, len, newlen);
-			len = newlen;
-		}
-		memcpy(cmnd->sense_buffer, sense_iu->sense, len);
-	}
-
-	cmnd->result = sense_iu->status;
-}
-
 /*
  * scsi-tags go from 0 - (nr_tags - 1), uas tags need to match stream-ids,
  * which go from 1 - nr_streams. And we use 1 for untagged commands.
@@ -339,12 +301,7 @@ static void uas_stat_cmplt(struct urb *urb)
 
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
-		if (urb->actual_length < 16)
-			devinfo->uas_sense_old = 1;
-		if (devinfo->uas_sense_old)
-			uas_sense_old(urb, cmnd);
-		else
-			uas_sense(urb, cmnd);
+		uas_sense(urb, cmnd);
 		if (cmnd->result != 0) {
 			/* cancel data transfers on error */
 			data_in_urb = usb_get_urb(cmdinfo->data_in_urb);
@@ -900,8 +857,6 @@ static int uas_configure_endpoints(struct uas_dev_info *devinfo)
 	struct usb_device *udev = devinfo->udev;
 	int r;
 
-	devinfo->uas_sense_old = 0;
-
 	r = uas_find_endpoints(devinfo->intf->cur_altsetting, eps);
 	if (r)
 		return r;
-- 
2.1.0

