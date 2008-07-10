From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4 of 6] scsi: Do not retry a request whose data integrity
	check failed
Date: Wed, 09 Jul 2008 22:48:06 -0400
Message-ID: <a9b55bdcfa1c013eb265.1215658086@sermon.lab.mkp.net>
References: <patchbomb.1215658082@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:58726 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbYGJCwB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 22:52:01 -0400
In-Reply-To: <patchbomb.1215658082@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

If initiator or target reject the I/O due to DIF errors there is no
point in retrying.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
2 files changed, 10 insertions(+), 4 deletions(-)
drivers/scsi/scsi_error.c |    3 +++
drivers/scsi/scsi_lib.c   |   11 +++++++----



diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -333,6 +333,9 @@ static int scsi_check_sense(struct scsi_
 		return /* soft_error */ SUCCESS;
 
 	case ABORTED_COMMAND:
+		if (sshdr.asc == 0x10) /* DIF */
+			return SUCCESS;
+
 		return NEEDS_RETRY;
 	case NOT_READY:
 	case UNIT_ATTENTION:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -941,11 +941,14 @@ void scsi_io_completion(struct scsi_cmnd
 				 * 6-byte command.
 				 */
 				scsi_requeue_command(q, cmd);
-				return;
-			} else {
+			} else if (sshdr.asc == 0x10) /* DIX */
+				scsi_end_request(cmd, -EIO, good_bytes, 0);
+			else
 				scsi_end_request(cmd, -EIO, this_count, 1);
-				return;
-			}
+			return;
+		case ABORTED_COMMAND:
+			if (sshdr.asc == 0x10) /* DIF */
+				scsi_end_request(cmd, -EIO, good_bytes, 0);
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming


