From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Print failed commands
Date: Sat, 23 May 2009 11:45:07 -0400
Message-ID: <yq1vdnrg6ws.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:56612 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZEWPpM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 May 2009 11:45:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org


When a request fails we print the sense data but not the actual command
that failed.  Add a printout of the operation + CDB for failed commands.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 30f3275..79ea5be 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -896,6 +896,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			scsi_print_result(cmd);
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
+			scsi_print_command(cmd);
 		}
 		blk_end_request_all(req, -EIO);
 		scsi_next_command(cmd);

