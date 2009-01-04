From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4 of 4] sd: Correctly handle 6-byte commands with DIX
Date: Sun, 04 Jan 2009 03:04:34 -0500
Message-ID: <8676e77c49d4bc933338.1231056274@sermon.lab.mkp.net>
References: <patchbomb.1231056270@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:52474 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZADIWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2009 03:22:41 -0500
In-Reply-To: <patchbomb.1231056270@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

DIF does not work with 6-byte commands so we previously ignored those
commands when preparing a request.  However, DIX does not need
RDPROTECT/WRPROTECT to be set and 6-byte commands are consequently
perfectly valid in host-only mode.

This patch fixes a problem where we would set the wrong DIX operation
when issuing commands to a legacy disk.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 4 insertions(+)
drivers/scsi/sd_dif.c |    4 ++++



diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -374,7 +374,10 @@ void sd_dif_op(struct scsi_cmnd *scmd, u
 	else
 		csum_convert = 0;
 
+	BUG_ON(dif && (scmd->cmnd[0] == READ_6 || scmd->cmnd[0] == WRITE_6));
+
 	switch (scmd->cmnd[0]) {
+	case READ_6:
 	case READ_10:
 	case READ_12:
 	case READ_16:
@@ -390,6 +393,7 @@ void sd_dif_op(struct scsi_cmnd *scmd, u
 
 		break;
 
+	case WRITE_6:
 	case WRITE_10:
 	case WRITE_12:
 	case WRITE_16:


