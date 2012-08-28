From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/5] mpt2sas: Return the correct sense key for DIF errors
Date: Tue, 28 Aug 2012 14:29:36 -0400
Message-ID: <1346178577-28628-4-git-send-email-martin.petersen@oracle.com>
References: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:30893 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2H1SaN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 14:30:13 -0400
In-Reply-To: <1346178577-28628-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nagalakshmi.Nandigama@lsi.com, Eric.Moore@lsi.com

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Only a target device should return ABORTED COMMAND when a PI error is
discovered. The HBA should always set the sense key to ILLEGAL REQUEST.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Nagalakshmi.Nandigama@lsi.com
Cc: Eric.Moore@lsi.com
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 7d774c5..bfda0ec 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3772,8 +3772,6 @@ static void
 _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 {
 	u8 ascq;
-	u8 sk;
-	u8 host_byte;
 
 	switch (ioc_status) {
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
@@ -3790,16 +3788,8 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 		break;
 	}
 
-	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
-		sk = ILLEGAL_REQUEST;
-		host_byte = DID_ABORT;
-	} else {
-		sk = ABORTED_COMMAND;
-		host_byte = DID_OK;
-	}
-
-	scsi_build_sense_buffer(0, scmd->sense_buffer, sk, 0x10, ascq);
-	scmd->result = DRIVER_SENSE << 24 | (host_byte << 16) |
+	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST, 0x10, ascq);
+	scmd->result = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
 	    SAM_STAT_CHECK_CONDITION;
 }
 
-- 
1.7.7.6

