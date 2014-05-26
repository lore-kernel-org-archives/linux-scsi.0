From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] scsi_lib: replace ambiguous "Unhandled error code" messages.
Date: Mon, 26 May 2014 12:13:24 +0200
Message-ID: <1401099204-18050-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaEZKNv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 May 2014 06:13:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, James.Bottomley@HansenPartnership.com

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

This patch replaces "Unhandled error code" with "Extended error description
not available".

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9db097a..f2a1e13 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -955,12 +955,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			action = ACTION_FAIL;
 			break;
 		default:
-			description = "Unhandled sense code";
+			description = "Extended sense code description not available";
 			action = ACTION_FAIL;
 			break;
 		}
 	} else {
-		description = "Unhandled error code";
+		description = "Extended error code description not available";
 		action = ACTION_FAIL;
 	}
 
-- 
Maurizio Lombardi

