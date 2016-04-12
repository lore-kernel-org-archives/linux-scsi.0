From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 1/2] USB: uas: Limit qdepth at the scsi-host level
Date: Tue, 12 Apr 2016 12:27:08 +0200
Message-ID: <1460456829-20933-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932898AbcDLK1R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2016 06:27:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Webb <djw@noc.ac.uk>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Commit 64d513ac31bd ("scsi: use host wide tags by default") causes
the SCSI core to queue more commands then we can handle on devices with
multiple LUNs, limit the queue depth at the scsi-host level instead of
per slave to fix this.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1315013
Cc: stable@vger.kernel.org # 4.4.x and 4.5.x
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Fix some spelling issues in the commit message and in a comment
---
 drivers/usb/storage/uas.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 13e4cc3..b1ec749 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -824,7 +824,6 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_BROKEN_FUA)
 		sdev->broken_fua = 1;
 
-	scsi_change_queue_depth(sdev, devinfo->qdepth - 2);
 	return 0;
 }
 
@@ -956,6 +955,12 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	if (result)
 		goto set_alt0;
 
+	/*
+	 * 1 tag is reserved for untagged commands +
+	 * 1 tag to avoid off by one errors in some bridge firmwares
+	 */
+	shost->can_queue = devinfo->qdepth - 2;
+
 	usb_set_intfdata(intf, shost);
 	result = scsi_add_host(shost, &intf->dev);
 	if (result)
-- 
2.7.3

