From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 16/21] uas: Use streams on upcoming 10Gbps / 3.1 USB
Date: Wed, 10 Sep 2014 13:46:46 +0200
Message-ID: <1410349611-17573-17-git-send-email-hdegoede@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaIJLrX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 07:47:23 -0400
In-Reply-To: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Limit the no-streams case to speeds less then USB_SPEED_SUPER.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index aaca65b..685eb37 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -909,7 +909,7 @@ static int uas_configure_endpoints(struct uas_dev_info *devinfo)
 	devinfo->data_out_pipe = usb_sndbulkpipe(udev,
 					    usb_endpoint_num(&eps[3]->desc));
 
-	if (udev->speed != USB_SPEED_SUPER) {
+	if (udev->speed < USB_SPEED_SUPER) {
 		devinfo->qdepth = 32;
 		devinfo->use_streams = 0;
 	} else {
-- 
2.1.0

