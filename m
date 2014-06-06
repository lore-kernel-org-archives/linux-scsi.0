From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH V2] scsi_lib: removes ambiguous "Unhandled error code" messages.
Date: Fri,  6 Jun 2014 10:10:35 +0200
Message-ID: <1402042235-7246-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaFFILC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2014 04:11:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org

During IO with fabric faults, one generally sees several "Unhandled error
code" messages in the syslog as shown below:

sd 4:0:6:2: [sdbw] Unhandled error code
sd 4:0:6:2: [sdbw] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 4:0:6:2: [sdbw] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sdbw, sector 0

This comes from scsi_io_completion (in scsi_lib.c) while handling error
codes other than DID_RESET or not deferred sense keys i.e. this is
actually handled by the SCSI mid layer. But what gets displayed here is
"Unhandled error code" which is quite misleading as it indicates
something that is not addressed by the mid layer.

This patch removes "Unhandled error code" and replaces "Unhandled sense code"
with "Failing command with sense code:".


Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/scsi_lib.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9db097a..b3c25cd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -955,14 +955,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			action = ACTION_FAIL;
 			break;
 		default:
-			description = "Unhandled sense code";
+			description = "Failing command with sense code:";
 			action = ACTION_FAIL;
 			break;
 		}
-	} else {
-		description = "Unhandled error code";
+	} else
 		action = ACTION_FAIL;
-	}
 
 	if (action != ACTION_FAIL &&
 	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
-- 
Maurizio Lombardi

