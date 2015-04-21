From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 3/3] uas: Set max_sectors_240 quirk for ASM1053 devices
Date: Tue, 21 Apr 2015 11:20:32 +0200
Message-ID: <1429608032-6910-3-git-send-email-hdegoede@redhat.com>
References: <1429608032-6910-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbbDUJUk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 05:20:40 -0400
In-Reply-To: <1429608032-6910-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Steve Bangert <sbangert@frontier.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

Testing has shown that ASM1053 devices do not work properly with transfers
larger than 240 sectors, so set max_sectors to 240 on these.

Cc: stable@vger.kernel.org # 3.16
Reported-by: Steve Bangert <sbangert@frontier.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Steve Bangert <sbangert@frontier.com>
---
Changes in v2:
-Add Cc stable@vger
-Add Tested-by tag
---
 drivers/usb/storage/uas-detect.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 63ae161..f58caa9 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -74,7 +74,7 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 	 * this writing the following versions exist:
 	 * ASM1051 - no uas support version
 	 * ASM1051 - with broken (*) uas support
-	 * ASM1053 - with working uas support
+	 * ASM1053 - with working uas support, but problems with large xfers
 	 * ASM1153 - with working uas support
 	 *
 	 * Devices with these chips re-use a number of device-ids over the
@@ -104,6 +104,9 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 		} else if (usb_ss_max_streams(&eps[1]->ss_ep_comp) == 32) {
 			/* Possibly an ASM1051, disable uas */
 			flags |= US_FL_IGNORE_UAS;
+		} else {
+			/* ASM1053, these have issues with large transfers */
+			flags |= US_FL_MAX_SECTORS_240;
 		}
 	}
 
-- 
2.3.5

