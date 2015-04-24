From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/22] advansys: Make AscIsrChipHalted() a void function
Date: Fri, 24 Apr 2015 10:32:46 +0200
Message-ID: <1429864377-67002-12-git-send-email-hare@suse.de>
References: <1429864377-67002-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966371AbbDXIdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 04:33:13 -0400
In-Reply-To: <1429864377-67002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

AscIsrChipHalted will only ever return '0', so make it
a void function.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9d78faa..54e8d89 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -6440,7 +6440,7 @@ static void AscSetChipSDTR(PortAddr iop_base, uchar sdtr_data, uchar tid_no)
 	AscPutMCodeSDTRDoneAtID(iop_base, tid_no, sdtr_data);
 }
 
-static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
+static void AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 {
 	EXT_MSG ext_msg;
 	EXT_MSG out_msg;
@@ -6487,14 +6487,14 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 			boardp->sdtr_data[tid_no] = 0;
 		}
 		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
+		return;
 	} else if (int_halt_code == ASC_HALT_ENABLE_ASYN_USE_SYN_FIX) {
 		if (asc_dvc->pci_fix_asyn_xfer & target_id) {
 			AscSetChipSDTR(iop_base, asyn_sdtr, tid_no);
 			boardp->sdtr_data[tid_no] = asyn_sdtr;
 		}
 		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
+		return;
 	} else if (int_halt_code == ASC_HALT_EXTMSG_IN) {
 		AscMemWordCopyPtrFromLram(iop_base,
 					  ASCV_MSGIN_BEG,
@@ -6580,7 +6580,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 						  (ushort)ASC_SCSIQ_B_CNTL),
 					 q_cntl);
 			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-			return (0);
+			return;
 		} else if (ext_msg.msg_type == EXTENDED_MESSAGE &&
 			   ext_msg.msg_req == EXTENDED_WDTR &&
 			   ext_msg.msg_len == MS_WDTR_LEN) {
@@ -6596,7 +6596,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 						  (ushort)ASC_SCSIQ_B_CNTL),
 					 q_cntl);
 			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-			return (0);
+			return;
 		} else {
 
 			ext_msg.msg_type = MESSAGE_REJECT;
@@ -6610,7 +6610,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 						  (ushort)ASC_SCSIQ_B_CNTL),
 					 q_cntl);
 			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-			return (0);
+			return;
 		}
 	} else if (int_halt_code == ASC_HALT_CHK_CONDITION) {
 
@@ -6667,7 +6667,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 		AscWriteLramByte(iop_base, (ushort)ASCV_SCSIBUSY_B, scsi_busy);
 
 		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
+		return;
 	} else if (int_halt_code == ASC_HALT_SDTR_REJECTED) {
 
 		AscMemWordCopyPtrFromLram(iop_base,
@@ -6689,7 +6689,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 				 (ushort)(halt_q_addr +
 					  (ushort)ASC_SCSIQ_B_CNTL), q_cntl);
 		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
+		return;
 	} else if (int_halt_code == ASC_HALT_SS_QUEUE_FULL) {
 
 		scsi_status = AscReadLramByte(iop_base,
@@ -6734,7 +6734,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 			}
 		}
 		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
+		return;
 	}
 #if CC_VERY_LONG_SG_LIST
 	else if (int_halt_code == ASC_HALT_HOST_COPY_SG_LIST_TO_RISC) {
@@ -6890,10 +6890,10 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 		 * after the return.
 		 */
 		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
+		return;
 	}
 #endif /* CC_VERY_LONG_SG_LIST */
-	return (0);
+	return;
 }
 
 /*
@@ -7306,13 +7306,9 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 		AscAckInterrupt(iop_base);
 		int_pending = ASC_TRUE;
 		if ((chipstat & CSW_HALTED) && (ctrl_reg & CC_SINGLE_STEP)) {
-			if (AscIsrChipHalted(asc_dvc) == ASC_ERROR) {
-				goto ISR_REPORT_QDONE_FATAL_ERROR;
-			} else {
-				saved_ctrl_reg &= (uchar)(~CC_HALT);
-			}
+			AscIsrChipHalted(asc_dvc);
+			saved_ctrl_reg &= (uchar)(~CC_HALT);
 		} else {
- ISR_REPORT_QDONE_FATAL_ERROR:
 			if ((asc_dvc->dvc_cntl & ASC_CNTL_INT_MULTI_Q) != 0) {
 				while (((status =
 					 AscIsrQDone(asc_dvc)) & 0x01) != 0) {
-- 
1.8.5.2

