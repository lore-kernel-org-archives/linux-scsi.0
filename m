From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] Fix sense key MEDIUM ERROR processing and retry
Date: Wed, 29 Nov 2006 19:45:23 -0800 (PST)
Message-ID: <893942.63415.qm@web31804.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1842587125-1164858323=:63415"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:12152 "HELO
	web31804.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S967827AbWK3DpY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Nov 2006 22:45:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

--0-1842587125-1164858323=:63415
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

1) If the device reports an uncorrectable MEDIUM ERROR, such
as SK MEDIUM ERROR, ASC UNRECOVERED READ ERR, AMNF DATA
FIELD or RECORD NOT FOUND, then: In scsi_check_sense()
return SUCCESS so as to not retry -- the error is
uncorrectable -- this speeds up total processing time.

2) In scsi_io_completion(), retry if and only if there was
at least one byte completed, i.e. good_bytes != 0.  If
good_bytes == 0, don't try to retry.

Without this patch, SCSI Core gets hung reading sector 0
forever, for example when reading the partition table of a
(newly discovered) device.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/scsi_error.c |    5 +++++
 drivers/scsi/scsi_lib.c   |    3 ++-
 2 files changed, 7 insertions(+), 1 deletions(-)

--0-1842587125-1164858323=:63415
Content-Type: text/plain; name="p1.txt"
Content-Description: 1207600725-p1.txt
Content-Disposition: inline; filename="p1.txt"

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index aff1b0c..011dd32 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -359,6 +359,11 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		return SUCCESS;
 
 	case MEDIUM_ERROR:
+		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
+		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
+		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
+			return SUCCESS;
+		}
 		return NEEDS_RETRY;
 
 	case HARDWARE_ERROR:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8b208b4..c5fa329 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -866,7 +866,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * are leftovers and there is some kind of error
 	 * (result != 0), retry the rest.
 	 */
-	if (scsi_end_request(cmd, 1, good_bytes, !!result) == NULL)
+	if (good_bytes &&
+	    scsi_end_request(cmd, 1, good_bytes, !!result) == NULL)
 		return;
 
 	/* good_bytes = 0, or (inclusive) there were leftovers and
-- 
1.4.4.1.g7a0e


--0-1842587125-1164858323=:63415--
