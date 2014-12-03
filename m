From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/12] advansys: Remove 'TRUE' and 'FALSE' definitions
Date: Wed,  3 Dec 2014 12:45:02 +0100
Message-ID: <1417607105-85455-10-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbaLCLpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:10 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Use 'bool' type instead.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 79 ++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 364f3f8..42e9dc6 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -78,13 +78,6 @@
 
 typedef unsigned char uchar;
 
-#ifndef TRUE
-#define TRUE     (1)
-#endif
-#ifndef FALSE
-#define FALSE    (0)
-#endif
-
 #define ERR      (-1)
 #define UW_ERR   (uint)(0xFFFF)
 #define isodd_word(val)   ((((uint)val) & (uint)0x0001) != 0)
@@ -556,7 +549,7 @@ typedef struct asc_dvc_var {
 	dma_addr_t overrun_dma;
 	uchar scsi_reset_wait;
 	uchar chip_no;
-	char is_in_int;
+	bool is_in_int;
 	uchar max_total_qng;
 	uchar cur_total_qng;
 	uchar in_critical_cnt;
@@ -3771,7 +3764,7 @@ static int AscStartChip(PortAddr iop_base)
 	return (1);
 }
 
-static int AscStopChip(PortAddr iop_base)
+static bool AscStopChip(PortAddr iop_base)
 {
 	uchar cc_val;
 
@@ -3782,9 +3775,9 @@ static int AscStopChip(PortAddr iop_base)
 	AscSetChipIH(iop_base, INS_HALT);
 	AscSetChipIH(iop_base, INS_RFLAG_WTM);
 	if ((AscGetChipStatus(iop_base) & CSW_HALTED) == 0) {
-		return (0);
+		return false;
 	}
-	return (1);
+	return true;
 }
 
 static bool AscIsChipHalted(PortAddr iop_base)
@@ -6481,7 +6474,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 	EXT_MSG ext_msg;
 	EXT_MSG out_msg;
 	ushort halt_q_addr;
-	int sdtr_accept;
+	bool sdtr_accept;
 	ushort int_halt_code;
 	ASC_SCSI_BIT_ID_TYPE scsi_busy;
 	ASC_SCSI_BIT_ID_TYPE target_id;
@@ -6540,10 +6533,10 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 		if (ext_msg.msg_type == EXTENDED_MESSAGE &&
 		    ext_msg.msg_req == EXTENDED_SDTR &&
 		    ext_msg.msg_len == MS_SDTR_LEN) {
-			sdtr_accept = TRUE;
+			sdtr_accept = true;
 			if ((ext_msg.req_ack_offset > ASC_SYN_MAX_OFFSET)) {
 
-				sdtr_accept = FALSE;
+				sdtr_accept = false;
 				ext_msg.req_ack_offset = ASC_SYN_MAX_OFFSET;
 			}
 			if ((ext_msg.xfer_period <
@@ -6551,7 +6544,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 			    || (ext_msg.xfer_period >
 				asc_dvc->sdtr_period_tbl[asc_dvc->
 							 max_sdtr_index])) {
-				sdtr_accept = FALSE;
+				sdtr_accept = false;
 				ext_msg.xfer_period =
 				    asc_dvc->sdtr_period_tbl[asc_dvc->
 							     min_sdtr_index];
@@ -7136,7 +7129,7 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 	uchar cur_target_qng;
 	ASC_QDONE_INFO scsiq_buf;
 	ASC_QDONE_INFO *scsiq;
-	int false_overrun;
+	bool false_overrun;
 
 	iop_base = asc_dvc->iop_base;
 	n_q_used = 1;
@@ -7218,7 +7211,11 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 		    ((scsiq->q_status & QS_ABORTED) != 0)) {
 			return (0x11);
 		} else if (scsiq->q_status == QS_DONE) {
-			false_overrun = FALSE;
+			/*
+			 * This is also curious.
+			 * false_overrun will _always_ be set to 'false'
+			 */
+			false_overrun = false;
 			if (scsiq->extra_bytes != 0) {
 				scsiq->remain_bytes += scsiq->extra_bytes;
 			}
@@ -7291,23 +7288,23 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 	uchar host_flag;
 
 	iop_base = asc_dvc->iop_base;
-	int_pending = FALSE;
+	int_pending = ASC_FALSE;
 
 	if (AscIsIntPending(iop_base) == 0)
 		return int_pending;
 
 	if ((asc_dvc->init_state & ASC_INIT_STATE_END_LOAD_MC) == 0) {
-		return ERR;
+		return ASC_ERROR;
 	}
 	if (asc_dvc->in_critical_cnt != 0) {
 		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_ISR_ON_CRITICAL);
-		return ERR;
+		return ASC_ERROR;
 	}
 	if (asc_dvc->is_in_int) {
 		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_ISR_RE_ENTRY);
-		return ERR;
+		return ASC_ERROR;
 	}
-	asc_dvc->is_in_int = TRUE;
+	asc_dvc->is_in_int = true;
 	ctrl_reg = AscGetChipControl(iop_base);
 	saved_ctrl_reg = ctrl_reg & (~(CC_SCSI_RESET | CC_CHIP_RESET |
 				       CC_SINGLE_STEP | CC_DIAG | CC_TEST));
@@ -7315,7 +7312,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 	if (chipstat & CSW_SCSI_RESET_LATCH) {
 		if (!(asc_dvc->bus_type & (ASC_IS_VL | ASC_IS_EISA))) {
 			int i = 10;
-			int_pending = TRUE;
+			int_pending = ADV_TRUE;
 			asc_dvc->sdtr_done = 0;
 			saved_ctrl_reg &= (uchar)(~CC_HALT);
 			while ((AscGetChipStatus(iop_base) &
@@ -7337,7 +7334,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 			 (uchar)(host_flag | (uchar)ASC_HOST_FLAG_IN_ISR));
 	if ((chipstat & CSW_INT_PENDING) || (int_pending)) {
 		AscAckInterrupt(iop_base);
-		int_pending = TRUE;
+		int_pending = ADV_TRUE;
 		if ((chipstat & CSW_HALTED) && (ctrl_reg & CC_SINGLE_STEP)) {
 			if (AscIsrChipHalted(asc_dvc) == ERR) {
 				goto ISR_REPORT_QDONE_FATAL_ERROR;
@@ -7359,13 +7356,13 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 				} while (status == 0x11);
 			}
 			if ((status & 0x80) != 0)
-				int_pending = ERR;
+				int_pending = ASC_ERROR;
 		}
 	}
 	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B, host_flag);
 	AscSetChipLramAddr(iop_base, saved_ram_addr);
 	AscSetChipControl(iop_base, saved_ctrl_reg);
-	asc_dvc->is_in_int = FALSE;
+	asc_dvc->is_in_int = false;
 	return int_pending;
 }
 
@@ -8457,7 +8454,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	PortAddr iop_base;
 	int sta;
 	int n_q_required;
-	int disable_syn_offset_one_fix;
+	bool disable_syn_offset_one_fix;
 	int i;
 	u32 addr;
 	ushort sg_entry_cnt = 0;
@@ -8522,7 +8519,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 		sg_entry_cnt_minus_one = sg_entry_cnt - 1;
 	}
 	scsi_cmd = scsiq->cdbptr[0];
-	disable_syn_offset_one_fix = FALSE;
+	disable_syn_offset_one_fix = false;
 	if ((asc_dvc->pci_fix_asyn_xfer & scsiq->q1.target_id) &&
 	    !(asc_dvc->pci_fix_asyn_xfer_always & scsiq->q1.target_id)) {
 		if (scsiq->q1.cntl & QC_SG_HEAD) {
@@ -8536,7 +8533,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 		}
 		if (data_cnt != 0UL) {
 			if (data_cnt < 512UL) {
-				disable_syn_offset_one_fix = TRUE;
+				disable_syn_offset_one_fix = true;
 			} else {
 				for (i = 0; i < ASC_SYN_OFFSET_ONE_DISABLE_LIST;
 				     i++) {
@@ -8547,7 +8544,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 					}
 					if (scsi_cmd == disable_cmd) {
 						disable_syn_offset_one_fix =
-						    TRUE;
+						    true;
 						break;
 					}
 				}
@@ -9092,7 +9089,7 @@ static ushort AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	/* asc_dvc->init_state initialized in AscInitGetConfig(). */
 	asc_dvc->sdtr_done = 0;
 	asc_dvc->cur_total_qng = 0;
-	asc_dvc->is_in_int = 0;
+	asc_dvc->is_in_int = false;
 	asc_dvc->in_critical_cnt = 0;
 	asc_dvc->last_q_shortage = 0;
 	asc_dvc->use_tagged_qng = 0;
@@ -9272,7 +9269,7 @@ static int AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
 	int retry;
 
 	retry = 0;
-	while (TRUE) {
+	while (true) {
 		AscSetChipEEPData(iop_base, data_reg);
 		mdelay(1);
 		read_back = AscGetChipEEPData(iop_base);
@@ -9408,7 +9405,7 @@ static int AscSetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf,
 	int n_error;
 
 	retry = 0;
-	while (TRUE) {
+	while (true) {
 		if ((n_error = AscSetEEPConfigOnce(iop_base, cfg_buf,
 						   bus_type)) == 0) {
 			break;
@@ -9435,7 +9432,7 @@ static ushort AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 	warn_code = 0;
 	AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0x00FE);
 	AscStopQueueExe(iop_base);
-	if ((AscStopChip(iop_base) == FALSE) ||
+	if ((AscStopChip(iop_base)) ||
 	    (AscGetChipScsiCtrl(iop_base) != 0)) {
 		asc_dvc->init_state |= ASC_INIT_RESET_SCSI_DONE;
 		AscResetChipAndScsiBus(asc_dvc);
@@ -11127,7 +11124,7 @@ static struct scsi_host_template advansys_template = {
 	 * must be set. The flag will be cleared in advansys_board_found
 	 * for non-ISA adapters.
 	 */
-	.unchecked_isa_dma = 1,
+	.unchecked_isa_dma = true,
 	/*
 	 * All adapters controlled by this driver are capable of large
 	 * scatter-gather lists. According to the mid-level SCSI documentation
@@ -11303,28 +11300,28 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 		switch (asc_dvc_varp->bus_type) {
 #ifdef CONFIG_ISA
 		case ASC_IS_ISA:
-			shost->unchecked_isa_dma = TRUE;
+			shost->unchecked_isa_dma = true;
 			share_irq = 0;
 			break;
 		case ASC_IS_VL:
-			shost->unchecked_isa_dma = FALSE;
+			shost->unchecked_isa_dma = false;
 			share_irq = 0;
 			break;
 		case ASC_IS_EISA:
-			shost->unchecked_isa_dma = FALSE;
+			shost->unchecked_isa_dma = false;
 			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_ISA */
 #ifdef CONFIG_PCI
 		case ASC_IS_PCI:
-			shost->unchecked_isa_dma = FALSE;
+			shost->unchecked_isa_dma = false;
 			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_PCI */
 		default:
 			shost_printk(KERN_ERR, shost, "unknown adapter type: "
 					"%d\n", asc_dvc_varp->bus_type);
-			shost->unchecked_isa_dma = TRUE;
+			shost->unchecked_isa_dma = false;
 			share_irq = 0;
 			break;
 		}
@@ -11343,7 +11340,7 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 		 * For Wide boards set PCI information before calling
 		 * AdvInitGetConfig().
 		 */
-		shost->unchecked_isa_dma = FALSE;
+		shost->unchecked_isa_dma = false;
 		share_irq = IRQF_SHARED;
 		ASC_DBG(2, "AdvInitGetConfig()\n");
 
-- 
1.8.5.2

