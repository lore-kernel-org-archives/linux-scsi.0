From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 07 of 10] scsi: Do not retry a request whose data integrity
	check failed
Date: Wed, 25 Jun 2008 11:22:46 -0400
Message-ID: <3fc00dbcb8b66bbf06ef.1214407366@sermon.lab.mkp.net>
References: <patchbomb.1214407359@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41046 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYFYPZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 11:25:27 -0400
In-Reply-To: <patchbomb.1214407359@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

If initiator or target reject the I/O due to DIF errors there is no
point in retrying.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
2 files changed, 7 insertions(+)
drivers/scsi/scsi_error.c |    3 +++
drivers/scsi/scsi_lib.c   |    4 ++++



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
@@ -945,6 +945,10 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_requeue_command(q, cmd);
 				return;
 			} else {
+				if (sshdr.asc == 0x10) { /* DIF */
+					scsi_print_result(cmd);
+					scsi_print_sense("", cmd);
+				}
 				scsi_end_request(cmd, -EIO, this_count, 1);
 				return;
 			}


