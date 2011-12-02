From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST sense to be retryable
Date: Fri,  2 Dec 2011 15:31:29 -0500
Message-ID: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab1LBUbi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2011 15:31:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>

Thin provisioned LUNs from multiple array vendors have failed WRITE SAME
(16) w/ UNMAP bit set with ILLEGAL_REQUEST sense.  With additional sense
0x24 and 0x26 respectively.

In both instances the target would always fail the CDB no matter how
many retries were performed (permanent target failure rather than
transient path failure).  This resulted in mkfs.ext4's discard of a
multipath device looping indefinitely while failing paths.

Additional sense 0x20 and 0x21 were included because both represent
TARGET_ERRORs too.  But not all ILLEGAL_REQUEST sense can be treated as
a TARGET_ERROR.

One example where a retry might be desirable is described in SBC-3, in
the "4.18 Model for XOR commands"

"When the device server is not able to accept a new command because
there is not enough space in the buffer, the device server shall
terminate that command with CHECK CONDITION status with the sense key
set to ILLEGAL REQUEST and the additional sense code set to BUFFER
FULL."

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/scsi_error.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index dc6131e..33d3a50 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -366,6 +366,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 			return TARGET_ERROR;
 
 	case ILLEGAL_REQUEST:
+		if (sshdr.asc == 0x20 || /* Invalid command operation code */
+		    sshdr.asc == 0x21 || /* Logical block address out of range */
+		    sshdr.asc == 0x24 || /* Invalid field in cdb */
+		    sshdr.asc == 0x26) { /* Parameter value invalid */
+			return TARGET_ERROR;
+		}
+		return SUCCESS;
+
 	default:
 		return SUCCESS;
 	}
-- 
1.7.4.4

