From: Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH V2] SCSI: Add runtime pm in the sd_check_events()
Date: Tue, 21 Feb 2012 09:34:46 +0800
Message-ID: <1329788086-17820-1-git-send-email-tianyu.lan@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab2BUBfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 20:35:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org

The sd_check_event() will be called periodly even when the device is in
the suspended status to check media event. The scsi_test_unit_ready() in
the sd_check_event() will issue scsi cmd request. Issuing scsi request when
the device is in the suspeneded status will cause problem. For example, when
a usb flash disk in the suspended status, scsi_test_unit_ready() issues a
scsi request. The request will be returned as failed because the usb device
is not active. The patch adds scsi_autopm_get_device() and scsi_autopm_put_device()
around scsi_test_unit_ready() in the sd_check_event() to resolve such problem.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/scsi/sd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c691fb5..2d18aa9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1182,9 +1182,14 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	retval = -ENODEV;
 
 	if (scsi_block_when_processing_errors(sdp)) {
+		retval = scsi_autopm_get_device(sdp);
+		if (retval)
+			goto out;
+
 		sshdr  = kzalloc(sizeof(*sshdr), GFP_KERNEL);
 		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
 					      sshdr);
+		scsi_autopm_put_device(sdp);
 	}
 
 	/* failed to execute TUR, assume media not present */
-- 
1.7.6.rc2.8.g28eb

