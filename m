From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] uas: Limit qdepth at the scsi-host level
Date: Sat, 19 Mar 2016 09:59:12 +0100
Message-ID: <1458377952-12567-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbcCSI7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2016 04:59:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Commit 64d513ac31bd ("scsi: use host wide tags by default") causes
the scsi-core to queue more cmnds then we can handle on devices with
multiple LUNs, limit the qdepth at the scsi-host level instead of
per slave to fix this.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1315013
Cc: stable@vger.kernel.org # 4.4.x and 4.5.x
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index c90a7e4..b5cb7ab 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -800,7 +800,6 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_BROKEN_FUA)
 		sdev->broken_fua = 1;
 
-	scsi_change_queue_depth(sdev, devinfo->qdepth - 2);
 	return 0;
 }
 
@@ -932,6 +931,12 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	if (result)
 		goto set_alt0;
 
+	/*
+	 * 1 tag is reserved for untagged commands +
+	 * 1 tag to avoid of by one errors in some bridge firmwares
+	 */
+	shost->can_queue = devinfo->qdepth - 2;
+
 	usb_set_intfdata(intf, shost);
 	result = scsi_add_host(shost, &intf->dev);
 	if (result)
-- 
2.7.3

