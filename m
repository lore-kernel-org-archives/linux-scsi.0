From: Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 1/1] SCSI: Add rumtime pm in the sd_check_events()
Date: Mon, 20 Feb 2012 16:49:20 +0800
Message-ID: <1329727760-6467-1-git-send-email-tianyu.lan@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18991 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab2BTIuj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 03:50:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
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
 drivers/scsi/sd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c691fb5..7913bd1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1183,8 +1183,14 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 	if (scsi_block_when_processing_errors(sdp)) {
 		sshdr  = kzalloc(sizeof(*sshdr), GFP_KERNEL);
+
+		retval = scsi_autopm_get_device(sdp);
+		if (retval)
+			goto out;
+
 		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
 					      sshdr);
+		scsi_autopm_put_device(sdp);
 	}
 
 	/* failed to execute TUR, assume media not present */
-- 
1.7.6.rc2.8.g28eb

