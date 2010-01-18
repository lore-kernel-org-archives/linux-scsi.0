From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Combine DIF/DIX error handling
Date: Mon, 18 Jan 2010 18:43:18 -0500
Message-ID: <yq11vhnt1wp.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:47110 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0ARXo6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2010 18:44:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de


DIF and DIX errors are handled identically at this point.  Collapse the
switch cases into one and let scsi_io_completion print result and sense
data.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ad15c2e..f1687df 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1196,19 +1196,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		SCpnt->result = 0;
 		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		break;
-	case ABORTED_COMMAND:
-		if (sshdr.asc == 0x10) { /* DIF: Disk detected corruption */
-			scsi_print_result(SCpnt);
-			scsi_print_sense("sd", SCpnt);
+	case ABORTED_COMMAND: /* DIF: Target detected corruption */
+	case ILLEGAL_REQUEST: /* DIX: Host detected corruption */
+		if (sshdr.asc == 0x10)
 			good_bytes = sd_completed_bytes(SCpnt);
-		}
-		break;
-	case ILLEGAL_REQUEST:
-		if (sshdr.asc == 0x10) { /* DIX: HBA detected corruption */
-			scsi_print_result(SCpnt);
-			scsi_print_sense("sd", SCpnt);
-			good_bytes = sd_completed_bytes(SCpnt);
-		}
 		break;
 	default:
 		break;
