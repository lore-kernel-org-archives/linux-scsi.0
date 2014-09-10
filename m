From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 12/21] uas: Remove cmnd reference from the cmd urb
Date: Wed, 10 Sep 2014 13:46:42 +0200
Message-ID: <1410349611-17573-13-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaIJLrQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 07:47:16 -0400
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

It is not strictly necessary for the cmd urb to have a reference to the
cmnd, and without this reference it becomes easier to drop all references to
a cmnd on an abort.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index dca09de..1fdcfad 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -425,12 +425,9 @@ out:
 
 static void uas_cmd_cmplt(struct urb *urb)
 {
-	struct scsi_cmnd *cmnd = urb->context;
+	if (urb->status)
+		dev_err(&urb->dev->dev, "cmd cmplt err %d\n", urb->status);
 
-	if (urb->status) {
-		uas_log_cmd_state(cmnd, __func__);
-		scmd_printk(KERN_ERR, cmnd, "cmd cmplt err %d\n", urb->status);
-	}
 	usb_free_urb(urb);
 }
 
@@ -508,7 +505,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	memcpy(iu->cdb, cmnd->cmnd, cmnd->cmd_len);
 
 	usb_fill_bulk_urb(urb, udev, devinfo->cmd_pipe, iu, sizeof(*iu) + len,
-							uas_cmd_cmplt, cmnd);
+							uas_cmd_cmplt, NULL);
 	urb->transfer_flags |= URB_FREE_BUFFER;
  out:
 	return urb;
-- 
2.1.0

