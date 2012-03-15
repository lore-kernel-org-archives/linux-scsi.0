From: Lan Tianyu <tianyu.lan@intel.com>
Subject: [RESEND][PATCH v2] SCSI: Add runtime pm in the sd_check_events()
Date: Thu, 15 Mar 2012 11:11:31 +0800
Message-ID: <1331781091-15891-1-git-send-email-tianyu.lan@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63379 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759659Ab2CODOI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2012 23:14:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org

The sd_check_event() will be called periodly even when the device is in
the suspended status to check media event. The scsi_test_unit_ready() in
the sd_check_event() will issue scsi cmd request. Issuing scsi request when
the device is in the suspeneded status will cause problem. For example, when
a usb flash disk in the suspended status, scsi_test_unit_ready() issues a
scsi request. The request will be returned as failed because the usb device
is not active. The patch adds scsi_autopm_get_device() and scsi_autopm_put_device()
around scsi_test_unit_ready() in the sd_check_event() to resolve such problem.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/scsi/sd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c
+++ linux-2.6/drivers/scsi/sd.c
@@ -1182,9 +1182,14 @@ static unsigned int sd_check_events(stru
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
