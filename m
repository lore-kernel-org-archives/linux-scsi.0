From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/6] mpt2sas: Return the correct sense key for DIF errors
Date: Fri, 13 Jan 2012 17:43:01 -0500
Message-ID: <1326494586-17360-2-git-send-email-martin.petersen@oracle.com>
References: <1326494586-17360-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:40296 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2AMWn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2012 17:43:29 -0500
In-Reply-To: <1326494586-17360-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nagalakshmi.Nandigama@lsi.com

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Only a target device should return ABORTED COMMAND when a PI error is
discovered. The HBA should always set the sense key to ILLEGAL REQUEST.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Nagalakshmi.Nandigama@lsi.com
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 193e33e..16b876d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3736,8 +3736,6 @@ static void
 _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 {
 	u8 ascq;
-	u8 sk;
-	u8 host_byte;
 
 	switch (ioc_status) {
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
@@ -3754,16 +3752,8 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
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
1.7.8.3.21.gab8a7

