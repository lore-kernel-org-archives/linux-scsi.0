From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1 of 4] scsi: Fix error handling for DIF/DIX
Date: Sun, 04 Jan 2009 03:04:31 -0500
Message-ID: <aed49a42ee27fe814240.1231056271@sermon.lab.mkp.net>
References: <patchbomb.1231056270@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:52464 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbZADIWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2009 03:22:40 -0500
In-Reply-To: <patchbomb.1231056270@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Alan's recent cleanup of the I/O completion code broke DIX error
handling.  Also, we are now using EILSEQ to indicate integrity errors to
the upper layers (as opposed to regular EIO failures).  This allows
filesystems to inspect buffers and decide whether to retry the I/O.
Update scsi_io_completion() accordingly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 8 insertions(+), 1 deletion(-)
drivers/scsi/scsi_lib.c |    9 ++++++++-



diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -963,6 +963,8 @@ void scsi_io_completion(struct scsi_cmnd
 		return;
 	this_count = blk_rq_bytes(req);
 
+	error = -EIO;
+
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the command and see what
@@ -1004,13 +1006,18 @@ void scsi_io_completion(struct scsi_cmnd
 				/* This will issue a new 6-byte command. */
 				cmd->device->use_10_for_rw = 0;
 				action = ACTION_REPREP;
+			} else if (sshdr.asc == 0x10) /* DIX */ {
+				description = "Host Data Integrity Failure";
+				action = ACTION_FAIL;
+				error = -EILSEQ;
 			} else
 				action = ACTION_FAIL;
 			break;
 		case ABORTED_COMMAND:
 			if (sshdr.asc == 0x10) { /* DIF */
+				description = "Target Data Integrity Failure";
 				action = ACTION_FAIL;
-				description = "Data Integrity Failure";
+				error = -EILSEQ;
 			} else
 				action = ACTION_RETRY;
 			break;


