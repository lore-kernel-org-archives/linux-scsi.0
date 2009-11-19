From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Always pass result and sense on request completion
Date: Thu, 19 Nov 2009 13:24:54 +0100
Message-ID: <20091119122454.71A7D3A174@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZKSMYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 07:24:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org


Currently we're passing the SCSI result and sense
code only for BLK_PC commands. However, some
instances up the stack might be interested
in them, too. So we can as well pass the
result and a possible sense code with every
request.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cc0a06f..10aa084 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -722,23 +722,19 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
 
-	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
-		req->errors = result;
-		if (result) {
-			if (sense_valid && req->sense) {
-				/*
-				 * SG_IO wants current and deferred errors
-				 */
-				int len = 8 + cmd->sense_buffer[7];
+	req->errors = result;
+	if (sense_valid && req->sense) {
+		int len = 8 + cmd->sense_buffer[7];
+
+		if (len > SCSI_SENSE_BUFFERSIZE)
+			len = SCSI_SENSE_BUFFERSIZE;
+		memcpy(req->sense, cmd->sense_buffer,  len);
+		req->sense_len = len;
+	}
 
-				if (len > SCSI_SENSE_BUFFERSIZE)
-					len = SCSI_SENSE_BUFFERSIZE;
-				memcpy(req->sense, cmd->sense_buffer,  len);
-				req->sense_len = len;
-			}
-			if (!sense_deferred)
-				error = -EIO;
-		}
+	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
+		if ((result) && (!sense_deferred))
+			error = -EIO;
 
 		req->resid_len = scsi_get_resid(cmd);
 
-- 
1.5.3.2

