From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 20/23] advansys: Remove library-style callback routines
Date: Mon, 30 Jul 2007 10:57:05 -0600
Message-ID: <11858146282735-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx> <11858146281790-git-send-email-matthew@wil.cx> <11858146281215-git-send-email-matthew@wil.cx> <11858146282469-git-send-email-matthew@wil.cx> <11858146281137-git-send-email-matthew@wil.cx> <11858146282332-git-send-email-matthew@wil.cx> <11858146283924-git-send-email-matthew@wil.cx> <1185814628436-git-send-email-matthew@wil.cx> <11858146281677-git-send-email-matthew@wil.cx> <11858146282603-git-send-email-matthew@wil.cx> <11858146281750-git-send-email-matthew@wil.cx> <11858146282891-git-send-email-matthew@wil.cx> <11858146284113-git-send-email-matthew@wil.cx> <11858146281160-git-send-email-matthew@wil.cx> <1
 1858146283502-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:59961 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936956AbXG3Q5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:12 -0400
In-Reply-To: <11858146283502-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Convert adv_isr_callback, adv_async_callback and asc_isr_callback into
direct calls.  Remove the unused asc_exe_callback.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   50 +++++++---------------------------------------
 1 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 73d974a..310b926 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1404,17 +1404,12 @@ typedef struct asc_dvc_cfg {
 
 struct asc_dvc_var;		/* Forward Declaration. */
 
-typedef void (*ASC_ISR_CALLBACK) (struct asc_dvc_var *, ASC_QDONE_INFO *);
-typedef int (*ASC_EXE_CALLBACK) (struct asc_dvc_var *, ASC_SCSI_Q *);
-
 typedef struct asc_dvc_var {
 	PortAddr iop_base;
 	ushort err_code;
 	ushort dvc_cntl;
 	ushort bug_fix_cntl;
 	ushort bus_type;
-	ASC_ISR_CALLBACK isr_callback;
-	ASC_EXE_CALLBACK exe_callback;
 	ASC_SCSI_BIT_ID_TYPE init_sdtr;
 	ASC_SCSI_BIT_ID_TYPE sdtr_done;
 	ASC_SCSI_BIT_ID_TYPE use_tagged_qng;
@@ -2830,12 +2825,6 @@ typedef struct adv_dvc_cfg {
 struct adv_dvc_var;
 struct adv_scsi_req_q;
 
-typedef void (*ADV_ISR_CALLBACK)
- (struct adv_dvc_var *, struct adv_scsi_req_q *);
-
-typedef void (*ADV_ASYNC_CALLBACK)
- (struct adv_dvc_var *, uchar);
-
 /*
  * Adapter operation variable structure.
  *
@@ -2852,8 +2841,6 @@ typedef struct adv_dvc_var {
 	AdvPortAddr iop_base;	/* I/O port address */
 	ushort err_code;	/* fatal error code */
 	ushort bios_ctrl;	/* BIOS control word, EEPROM word 12 */
-	ADV_ISR_CALLBACK isr_callback;
-	ADV_ASYNC_CALLBACK async_callback;
 	ushort wdtr_able;	/* try WDTR for a device */
 	ushort sdtr_able;	/* try SDTR for a device */
 	ushort ultra_able;	/* try SDTR Ultra speed for a device */
@@ -3671,9 +3658,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *);
 static int asc_build_req(asc_board_t *, struct scsi_cmnd *);
 static int adv_build_req(asc_board_t *, struct scsi_cmnd *, ADV_SCSI_REQ_Q **);
 static int adv_get_sglist(asc_board_t *, adv_req_t *, struct scsi_cmnd *, int);
-static void asc_isr_callback(ASC_DVC_VAR *, ASC_QDONE_INFO *);
-static void adv_isr_callback(ADV_DVC_VAR *, ADV_SCSI_REQ_Q *);
-static void adv_async_callback(ADV_DVC_VAR *, uchar);
 static void asc_enqueue(asc_queue_t *, REQP, int);
 static REQP asc_dequeue(asc_queue_t *, int);
 static REQP asc_dequeue_list(asc_queue_t *, REQP *, int);
@@ -7624,9 +7608,8 @@ static void asc_prt_asc_dvc_var(ASC_DVC_VAR *h)
 	printk(" iop_base 0x%x, err_code 0x%x, dvc_cntl 0x%x, bug_fix_cntl "
 	       "%d,\n", h->iop_base, h->err_code, h->dvc_cntl, h->bug_fix_cntl);
 
-	printk(" bus_type %d, isr_callback 0x%p, exe_callback 0x%p, "
-	       "init_sdtr 0x%x,\n", h->bus_type, h->isr_callback,
-	       h->exe_callback, (unsigned)h->init_sdtr);
+	printk(" bus_type %d, init_sdtr 0x%x,\n", h->bus_type,
+		(unsigned)h->init_sdtr);
 
 	printk(" sdtr_done 0x%x, use_tagged_qng 0x%x, unit_not_ready 0x%x, "
 	       "chip_no 0x%x,\n", (unsigned)h->sdtr_done,
@@ -8631,10 +8614,8 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 	ASC_QDONE_INFO scsiq_buf;
 	ASC_QDONE_INFO *scsiq;
 	int false_overrun;
-	ASC_ISR_CALLBACK asc_isr_callback;
 
 	iop_base = asc_dvc->iop_base;
-	asc_isr_callback = asc_dvc->isr_callback;
 	n_q_used = 1;
 	scsiq = (ASC_QDONE_INFO *)&scsiq_buf;
 	done_q_tail = (uchar)AscGetVarDoneQTail(iop_base);
@@ -8746,7 +8727,7 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 				}
 			}
 			if ((scsiq->cntl & QC_NO_CALLBACK) == 0) {
-				(*asc_isr_callback) (asc_dvc, scsiq);
+				asc_isr_callback(asc_dvc, scsiq);
 			} else {
 				if ((AscReadLramByte(iop_base,
 						     (ushort)(q_addr + (ushort)
@@ -8764,7 +8745,7 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 			AscSetLibErrorCode(asc_dvc, ASCQ_ERR_Q_STATUS);
  FATAL_ERR_QDONE:
 			if ((scsiq->cntl & QC_NO_CALLBACK) == 0) {
-				(*asc_isr_callback) (asc_dvc, scsiq);
+				asc_isr_callback(asc_dvc, scsiq);
 			}
 			return (0x80);
 		}
@@ -8790,9 +8771,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 		return int_pending;
 	}
 
-	if (((asc_dvc->init_state & ASC_INIT_STATE_END_LOAD_MC) == 0)
-	    || (asc_dvc->isr_callback == 0)
-	    ) {
+	if ((asc_dvc->init_state & ASC_INIT_STATE_END_LOAD_MC) == 0) {
 		return (ERR);
 	}
 	if (asc_dvc->in_critical_cnt != 0) {
@@ -9191,7 +9170,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	int disable_syn_offset_one_fix;
 	int i;
 	ASC_PADDR addr;
-	ASC_EXE_CALLBACK asc_exe_callback;
 	ushort sg_entry_cnt = 0;
 	ushort sg_entry_cnt_minus_one = 0;
 	uchar target_ix;
@@ -9205,7 +9183,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 
 	iop_base = asc_dvc->iop_base;
 	sg_head = scsiq->sg_head;
-	asc_exe_callback = asc_dvc->exe_callback;
 	if (asc_dvc->err_code != 0)
 		return (ERR);
 	if (scsiq == (ASC_SCSI_Q *)0L) {
@@ -9366,9 +9343,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 			     AscSendScsiQueue(asc_dvc, scsiq,
 					      n_q_required)) == 1) {
 				asc_dvc->in_critical_cnt--;
-				if (asc_exe_callback != 0) {
-					(*asc_exe_callback) (asc_dvc, scsiq);
-				}
 				DvcLeaveCritical(last_int_level);
 				return (sta);
 			}
@@ -9414,9 +9388,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 			if ((sta = AscSendScsiQueue(asc_dvc, scsiq,
 						    n_q_required)) == 1) {
 				asc_dvc->in_critical_cnt--;
-				if (asc_exe_callback != 0) {
-					(*asc_exe_callback) (asc_dvc, scsiq);
-				}
 				DvcLeaveCritical(last_int_level);
 				return (sta);
 			}
@@ -16745,7 +16716,7 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 
 	/*
 	 * Notify the driver of an asynchronous microcode condition by
-	 * calling the ADV_DVC_VAR.async_callback function. The function
+	 * calling the adv_async_callback function. The function
 	 * is passed the microcode ASC_MC_INTRB_CODE byte value.
 	 */
 	if (int_stat & ADV_INTR_STATUS_INTRB) {
@@ -16767,9 +16738,7 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 			}
 		}
 
-		if (asc_dvc->async_callback != 0) {
-			(*asc_dvc->async_callback) (asc_dvc, intrb_code);
-		}
+		adv_async_callback(asc_dvc, intrb_code);
 	}
 
 	/*
@@ -16827,7 +16796,7 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		 * the ADV_SCSI_REQ_Q pointer to its callback function.
 		 */
 		scsiq->a_flag |= ADV_SCSIQ_DONE;
-		(*asc_dvc->isr_callback) (asc_dvc, scsiq);
+		adv_isr_callback(asc_dvc, scsiq);
 		/*
 		 * Note: After the driver callback function is called, 'scsiq'
 		 * can no longer be referenced.
@@ -17097,15 +17066,12 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		asc_dvc_varp->cfg = &boardp->dvc_cfg.asc_dvc_cfg;
 		asc_dvc_varp->cfg->overrun_buf = &overrun_buf[0];
 		asc_dvc_varp->iop_base = iop;
-		asc_dvc_varp->isr_callback = asc_isr_callback;
 	} else {
 #ifdef CONFIG_PCI
 		ASC_DBG(1, "advansys_board_found: wide board\n");
 		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
 		adv_dvc_varp->drv_ptr = boardp;
 		adv_dvc_varp->cfg = &boardp->dvc_cfg.adv_dvc_cfg;
-		adv_dvc_varp->isr_callback = adv_isr_callback;
-		adv_dvc_varp->async_callback = adv_async_callback;
 		if (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW) {
 			ASC_DBG(1, "advansys_board_found: ASC-3550\n");
 			adv_dvc_varp->chip_type = ADV_CHIP_ASC3550;
-- 
1.4.4.4

