From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 13/22] advansys: Remove some custom wrappers
Date: Sun,  9 Sep 2007 08:56:38 -0600
Message-ID: <1189349807287-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43109 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbXIIO4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:50 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

 - Replace ASC_ASSERT() with BUG_ON().
   In a few places, get rid of the assertion altogether -- the ensuing
   crash will tell us all we need to know.  Use BUG() where it fits better
   than BUG_ON().  Also fix a fencepost error in advansys_proc_info().
 - Replace DvcSleepMilliSecond with mdelay.
   Despite its name using 'sleep', the implementation was a delay.
   I've marked some places with XXX where we should probably be using
   msleep instead.  They need to be audited to be sure we can sleep in
   that context.
 - Replace DvcDelayMicroSecond with udelay.
 - Replace DvcDelayNanoSecond with udelay too.
   All callers were multiples of 1000.
 - Remove DvcEnterCritical and DvcLeaveCritical.
   These functions are no-ops, and as the comments said, the spinlock
   protects the critical sections.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  213 +++++++++++------------------------------------
 1 files changed, 49 insertions(+), 164 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 60a9188..9c5d37d 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -70,9 +70,6 @@
  */
 #warning this driver is still not properly converted to the DMA API
 
-/* Enable driver assertions. */
-#define ADVANSYS_ASSERT
-
 /* Enable driver /proc statistics. */
 #define ADVANSYS_STATS
 
@@ -1121,10 +1118,6 @@ static uchar AscGetChipScsiCtrl(PortAddr);
 static uchar AscGetChipVersion(PortAddr, ushort);
 static ASC_DCNT AscLoadMicroCode(PortAddr, ushort, uchar *, ushort);
 static void AscToggleIRQAct(PortAddr);
-static inline ulong DvcEnterCritical(void);
-static inline void DvcLeaveCritical(ulong);
-static void DvcSleepMilliSecond(ASC_DCNT);
-static void DvcDelayNanoSecond(ASC_DVC_VAR *, ASC_DCNT);
 static void DvcPutScsiQ(PortAddr, ushort, uchar *, int);
 static void DvcGetQinfo(PortAddr, ushort, uchar *, int);
 static ushort AscInitAsc1000Driver(ASC_DVC_VAR *);
@@ -2226,15 +2219,8 @@ typedef struct adv_scsi_req_q {
 
 #define ADV_HOST_SCSI_BUS_RESET      0x80	/* Host Initiated SCSI Bus Reset. */
 
-/*
- * Device drivers must define the following functions.
- */
-static inline ulong DvcEnterCritical(void);
-static inline void DvcLeaveCritical(ulong);
-static void DvcSleepMilliSecond(ADV_DCNT);
 static ADV_PADDR DvcGetPhyAddr(ADV_DVC_VAR *, ADV_SCSI_REQ_Q *,
 			       uchar *, ASC_SDCNT *, int);
-static void DvcDelayMicroSecond(ADV_DVC_VAR *, ushort);
 
 /*
  * Adv Library functions available to drivers.
@@ -2670,24 +2656,6 @@ do { \
         ASC_DBG_PRT_HEX((lvl), "INQUIRY", (uchar *) (inq), (len));
 #endif /* ADVANSYS_DEBUG */
 
-#ifndef ADVANSYS_ASSERT
-#define ASC_ASSERT(a)
-#else /* ADVANSYS_ASSERT */
-
-#define ASC_ASSERT(a) \
-    { \
-        if (!(a)) { \
-            printk("ASC_ASSERT() Failure: file %s, line %d\n", \
-                __FILE__, __LINE__); \
-        } \
-    }
-
-#endif /* ADVANSYS_ASSERT */
-
-/*
- * --- Driver Structures
- */
-
 #ifdef ADVANSYS_STATS
 
 /* Per board statistics structure */
@@ -2949,7 +2917,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	if (ASC_WIDE_BOARD(boardp)) {
 		cp = boardp->prtbuf;
 		cplen = asc_prt_adv_bios(shost, cp, ASC_PRTBUF_SIZE);
-		ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
+		BUG_ON(cplen >= ASC_PRTBUF_SIZE);
 		cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
 				  cplen);
 		totcnt += cnt;
@@ -2967,7 +2935,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 */
 	cp = boardp->prtbuf;
 	cplen = asc_prt_board_devices(shost, cp, ASC_PRTBUF_SIZE);
-	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
 	leftlen -= cnt;
@@ -2987,7 +2955,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	} else {
 		cplen = asc_prt_adv_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
 	}
-	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
 	leftlen -= cnt;
@@ -3003,7 +2971,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 */
 	cp = boardp->prtbuf;
 	cplen = asc_prt_driver_conf(shost, cp, ASC_PRTBUF_SIZE);
-	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
 	leftlen -= cnt;
@@ -3020,7 +2988,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 */
 	cp = boardp->prtbuf;
 	cplen = asc_prt_board_stats(shost, cp, ASC_PRTBUF_SIZE);
-	ASC_ASSERT(cplen <= ASC_PRTBUF_SIZE);
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
 	leftlen -= cnt;
@@ -3042,7 +3010,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	} else {
 		cplen = asc_prt_adv_board_info(shost, cp, ASC_PRTBUF_SIZE);
 	}
-	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
 	leftlen -= cnt;
@@ -3139,7 +3107,7 @@ static const char *advansys_info(struct Scsi_Host *shost)
 			ASC_VERSION, widename, (ulong)adv_dvc_varp->iop_base,
 			(ulong)adv_dvc_varp->iop_base + boardp->asc_n_io_port - 1, shost->irq);
 	}
-	ASC_ASSERT(strlen(info) < ASC_INFO_SIZE);
+	BUG_ON(strlen(info) >= ASC_INFO_SIZE);
 	ASC_DBG(1, "advansys_info: end\n");
 	return info;
 }
@@ -4201,7 +4169,6 @@ adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 				 * Point the previous ADV_SG_BLOCK structure to
 				 * the newly allocated ADV_SG_BLOCK structure.
 				 */
-				ASC_ASSERT(prev_sg_block != NULL);
 				prev_sg_block->sg_ptr =
 				    cpu_to_le32(sg_block_paddr);
 			}
@@ -4262,7 +4229,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	ASC_DBG1(1, "asc_isr_callback: shost 0x%lx\n", (ulong)shost);
 
 	boardp = ASC_BOARDP(shost);
-	ASC_ASSERT(asc_dvc_varp == &boardp->dvc_var.asc_dvc_var);
+	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
 
 	/*
 	 * 'qdonep' contains the command's ending status.
@@ -4408,7 +4375,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	ASC_DBG1(1, "adv_isr_callback: shost 0x%lx\n", (ulong)shost);
 
 	boardp = ASC_BOARDP(shost);
-	ASC_ASSERT(adv_dvc_varp == &boardp->dvc_var.adv_dvc_var);
+	BUG_ON(adv_dvc_varp != &boardp->dvc_var.adv_dvc_var);
 
 	/*
 	 * 'done_status' contains the command's ending status.
@@ -5738,7 +5705,7 @@ static int asc_prt_line(char *buf, int buflen, char *fmt, ...)
 
 	va_start(args, fmt);
 	ret = vsprintf(s, fmt, args);
-	ASC_ASSERT(ret < ASC_PRTLINE_SIZE);
+	BUG_ON(ret >= ASC_PRTLINE_SIZE);
 	if (buf == NULL) {
 		(void)printk(s);
 		ret = 0;
@@ -5756,36 +5723,6 @@ static int asc_prt_line(char *buf, int buflen, char *fmt, ...)
  */
 
 /*
- * Delay for 'n' milliseconds. Don't use the 'jiffies'
- * global variable which is incremented once every 5 ms
- * from a timer interrupt, because this function may be
- * called when interrupts are disabled.
- */
-static void DvcSleepMilliSecond(ADV_DCNT n)
-{
-	ASC_DBG1(4, "DvcSleepMilliSecond: %lu\n", (ulong)n);
-	mdelay(n);
-}
-
-/*
- * Currently and inline noop but leave as a placeholder.
- * Leave DvcEnterCritical() as a noop placeholder.
- */
-static inline ulong DvcEnterCritical(void)
-{
-	return 0;
-}
-
-/*
- * Critical sections are all protected by the board spinlock.
- * Leave DvcLeaveCritical() as a noop placeholder.
- */
-static inline void DvcLeaveCritical(ulong flags)
-{
-	return;
-}
-
-/*
  * void
  * DvcPutScsiQ(PortAddr iop_base, ushort s_addr, uchar *outbuf, int words)
  *
@@ -6317,10 +6254,9 @@ static void asc_prt_adv_sgblock(int sgblockno, ADV_SG_BLOCK *b)
 	       (ulong)b, sgblockno);
 	printk("  sg_cnt %u, sg_ptr 0x%lx\n",
 	       b->sg_cnt, (ulong)le32_to_cpu(b->sg_ptr));
-	ASC_ASSERT(b->sg_cnt <= NO_OF_SG_PER_BLOCK);
-	if (b->sg_ptr != 0) {
-		ASC_ASSERT(b->sg_cnt == NO_OF_SG_PER_BLOCK);
-	}
+	BUG_ON(b->sg_cnt > NO_OF_SG_PER_BLOCK);
+	if (b->sg_ptr != 0)
+		BUG_ON(b->sg_cnt != NO_OF_SG_PER_BLOCK);
 	for (i = 0; i < b->sg_cnt; i++) {
 		printk("  [%u]: sg_addr 0x%lx, sg_count 0x%lx\n",
 		       i, (ulong)b->sg_list[i].sg_addr,
@@ -6590,7 +6526,7 @@ static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
 	uchar scsi_status;
 	asc_board_t *boardp;
 
-	ASC_ASSERT(asc_dvc->drv_ptr != NULL);
+	BUG_ON(!asc_dvc->drv_ptr);
 	boardp = asc_dvc->drv_ptr;
 
 	iop_base = asc_dvc->iop_base;
@@ -7199,7 +7135,7 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 					AscSetChipControl(iop_base,
 							  (uchar)(CC_SCSI_RESET
 								  | CC_HALT));
-					DvcDelayNanoSecond(asc_dvc, 60000);
+					udelay(60);
 					AscSetChipControl(iop_base, CC_HALT);
 					AscSetChipStatus(iop_base,
 							 CIW_CLR_SCSI_RESET_INT);
@@ -7276,7 +7212,7 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
 			saved_ctrl_reg &= (uchar)(~CC_HALT);
 			while ((AscGetChipStatus(iop_base) &
 				CSW_SCSI_RESET_ACTIVE) && (i-- > 0)) {
-				DvcSleepMilliSecond(100);
+				mdelay(100);
 			}
 			AscSetChipControl(iop_base, (CC_CHIP_RESET | CC_HALT));
 			AscSetChipControl(iop_base, CC_HALT);
@@ -7549,7 +7485,6 @@ static uchar _syn_offset_one_disable_cmd[ASC_SYN_OFFSET_ONE_DISABLE_LIST] = {
 static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 {
 	PortAddr iop_base;
-	ulong last_int_level;
 	int sta;
 	int n_q_required;
 	int disable_syn_offset_one_fix;
@@ -7593,9 +7528,7 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 			scsiq->q1.cntl |= (QC_MSG_OUT | QC_URGENT);
 		}
 	}
-	last_int_level = DvcEnterCritical();
 	if (asc_dvc->in_critical_cnt != 0) {
-		DvcLeaveCritical(last_int_level);
 		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_CRITICAL_RE_ENTRY);
 		return (ERR);
 	}
@@ -7603,13 +7536,11 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	if ((scsiq->q1.cntl & QC_SG_HEAD) != 0) {
 		if ((sg_entry_cnt = sg_head->entry_cnt) == 0) {
 			asc_dvc->in_critical_cnt--;
-			DvcLeaveCritical(last_int_level);
 			return (ERR);
 		}
 #if !CC_VERY_LONG_SG_LIST
 		if (sg_entry_cnt > ASC_MAX_SG_LIST) {
 			asc_dvc->in_critical_cnt--;
-			DvcLeaveCritical(last_int_level);
 			return (ERR);
 		}
 #endif /* !CC_VERY_LONG_SG_LIST */
@@ -7724,7 +7655,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 			     AscSendScsiQueue(asc_dvc, scsiq,
 					      n_q_required)) == 1) {
 				asc_dvc->in_critical_cnt--;
-				DvcLeaveCritical(last_int_level);
 				return (sta);
 			}
 		}
@@ -7769,13 +7699,11 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 			if ((sta = AscSendScsiQueue(asc_dvc, scsiq,
 						    n_q_required)) == 1) {
 				asc_dvc->in_critical_cnt--;
-				DvcLeaveCritical(last_int_level);
 				return (sta);
 			}
 		}
 	}
 	asc_dvc->in_critical_cnt--;
-	DvcLeaveCritical(last_int_level);
 	return (sta);
 }
 
@@ -8308,7 +8236,7 @@ static int AscHostReqRiscHalt(PortAddr iop_base)
 			sta = 1;
 			break;
 		}
-		DvcSleepMilliSecond(100);
+		mdelay(100);
 	} while (count++ < 20);
 	AscWriteLramByte(iop_base, ASCV_STOP_CODE_B, saved_stop_code);
 	return (sta);
@@ -8326,22 +8254,12 @@ static int AscStopQueueExe(PortAddr iop_base)
 			    ASC_STOP_ACK_RISC_STOP) {
 				return (1);
 			}
-			DvcSleepMilliSecond(100);
+			mdelay(100);
 		} while (count++ < 20);
 	}
 	return (0);
 }
 
-static void DvcDelayMicroSecond(ADV_DVC_VAR *asc_dvc, ushort micro_sec)
-{
-	udelay(micro_sec);
-}
-
-static void DvcDelayNanoSecond(ASC_DVC_VAR *asc_dvc, ASC_DCNT nano_sec)
-{
-	udelay((nano_sec + 999) / 1000);
-}
-
 static int AscStartChip(PortAddr iop_base)
 {
 	AscSetChipControl(iop_base, 0);
@@ -8460,16 +8378,16 @@ static int AscResetChipAndScsiBus(ASC_DVC_VAR *asc_dvc)
 	iop_base = asc_dvc->iop_base;
 	while ((AscGetChipStatus(iop_base) & CSW_SCSI_RESET_ACTIVE)
 	       && (i-- > 0)) {
-		DvcSleepMilliSecond(100);
+		mdelay(100);
 	}
 	AscStopChip(iop_base);
 	AscSetChipControl(iop_base, CC_CHIP_RESET | CC_SCSI_RESET | CC_HALT);
-	DvcDelayNanoSecond(asc_dvc, 60000);
+	udelay(60);
 	AscSetChipIH(iop_base, INS_RFLAG_WTM);
 	AscSetChipIH(iop_base, INS_HALT);
 	AscSetChipControl(iop_base, CC_CHIP_RESET | CC_HALT);
 	AscSetChipControl(iop_base, CC_HALT);
-	DvcSleepMilliSecond(200);
+	mdelay(200);
 	AscSetChipStatus(iop_base, CIW_CLR_SCSI_RESET_INT);
 	AscSetChipStatus(iop_base, 0);
 	return (AscIsChipHalted(iop_base));
@@ -8711,8 +8629,7 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 	if ((asc_dvc->dvc_cntl & ASC_CNTL_RESET_SCSI) &&
 	    !(asc_dvc->init_state & ASC_INIT_RESET_SCSI_DONE)) {
 		AscResetChipAndScsiBus(asc_dvc);
-		DvcSleepMilliSecond((ASC_DCNT)
-				    ((ushort)asc_dvc->scsi_reset_wait * 1000));
+		mdelay(asc_dvc->scsi_reset_wait * 1000); /* XXX: msleep? */
 	}
 	asc_dvc->init_state |= ASC_INIT_STATE_BEG_LOAD_MC;
 	if (asc_dvc->err_code != 0)
@@ -8869,8 +8786,7 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 	    (AscGetChipScsiCtrl(iop_base) != 0)) {
 		asc_dvc->init_state |= ASC_INIT_RESET_SCSI_DONE;
 		AscResetChipAndScsiBus(asc_dvc);
-		DvcSleepMilliSecond((ASC_DCNT)
-				    ((ushort)asc_dvc->scsi_reset_wait * 1000));
+		mdelay(asc_dvc->scsi_reset_wait * 1000); /* XXX: msleep? */
 	}
 	if (AscIsChipHalted(iop_base) == FALSE) {
 		asc_dvc->err_code |= ASC_IERR_START_STOP_CHIP;
@@ -9084,7 +9000,7 @@ static int __devinit AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
 	saved_word = AscReadLramWord(iop_base, q_addr);
 	AscSetChipLramAddr(iop_base, q_addr);
 	AscSetChipLramData(iop_base, 0x55AA);
-	DvcSleepMilliSecond(10);
+	mdelay(10);
 	AscSetChipLramAddr(iop_base, q_addr);
 	if (AscGetChipLramData(iop_base) == 0x55AA) {
 		sta = 1;
@@ -9101,7 +9017,7 @@ static int __devinit AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
 	retry = 0;
 	while (TRUE) {
 		AscSetChipEEPCmd(iop_base, cmd_reg);
-		DvcSleepMilliSecond(1);
+		mdelay(1);
 		read_back = AscGetChipEEPCmd(iop_base);
 		if (read_back == cmd_reg) {
 			return (1);
@@ -9120,7 +9036,7 @@ static int __devinit AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
 	retry = 0;
 	while (TRUE) {
 		AscSetChipEEPData(iop_base, data_reg);
-		DvcSleepMilliSecond(1);
+		mdelay(1);
 		read_back = AscGetChipEEPData(iop_base);
 		if (read_back == data_reg) {
 			return (1);
@@ -9133,13 +9049,13 @@ static int __devinit AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
 
 static void __devinit AscWaitEEPRead(void)
 {
-	DvcSleepMilliSecond(1);
+	mdelay(1);
 	return;
 }
 
 static void __devinit AscWaitEEPWrite(void)
 {
-	DvcSleepMilliSecond(20);
+	mdelay(20);
 	return;
 }
 
@@ -11364,7 +11280,7 @@ AdvInitGetConfig(struct pci_dev *pdev, asc_board_t *boardp)
 		 */
 		AdvWriteWordRegister(iop_base, IOPW_CTRL_REG,
 				     ADV_CTRL_REG_CMD_RESET);
-		DvcSleepMilliSecond(100);
+		mdelay(100);
 		AdvWriteWordRegister(iop_base, IOPW_CTRL_REG,
 				     ADV_CTRL_REG_CMD_WR_IO_REG);
 
@@ -12048,7 +11964,7 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	 */
 	for (i = 0; i < 2; i++) {
 		AdvWriteByteRegister(iop_base, IOPB_RAM_BIST, PRE_TEST_MODE);
-		DvcSleepMilliSecond(10);	/* Wait for 10ms before reading back. */
+		mdelay(10);	/* Wait for 10ms before reading back. */
 		byte = AdvReadByteRegister(iop_base, IOPB_RAM_BIST);
 		if ((byte & RAM_TEST_DONE) == 0
 		    || (byte & 0x0F) != PRE_TEST_VALUE) {
@@ -12057,7 +11973,7 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 		}
 
 		AdvWriteByteRegister(iop_base, IOPB_RAM_BIST, NORMAL_MODE);
-		DvcSleepMilliSecond(10);	/* Wait for 10ms before reading back. */
+		mdelay(10);	/* Wait for 10ms before reading back. */
 		if (AdvReadByteRegister(iop_base, IOPB_RAM_BIST)
 		    != NORMAL_VALUE) {
 			asc_dvc->err_code = ASC_IERR_BIST_PRE_TEST;
@@ -12073,7 +11989,7 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	 * err_code, and return an error.
 	 */
 	AdvWriteByteRegister(iop_base, IOPB_RAM_BIST, RAM_TEST_MODE);
-	DvcSleepMilliSecond(10);	/* Wait for 10ms before checking status. */
+	mdelay(10);	/* Wait for 10ms before checking status. */
 
 	byte = AdvReadByteRegister(iop_base, IOPB_RAM_BIST);
 	if ((byte & RAM_TEST_DONE) == 0 || (byte & RAM_TEST_STATUS) != 0) {
@@ -12529,7 +12445,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	 */
 	for (i = 0; i < 2; i++) {
 		AdvWriteByteRegister(iop_base, IOPB_RAM_BIST, PRE_TEST_MODE);
-		DvcSleepMilliSecond(10);	/* Wait for 10ms before reading back. */
+		mdelay(10);	/* Wait for 10ms before reading back. */
 		byte = AdvReadByteRegister(iop_base, IOPB_RAM_BIST);
 		if ((byte & RAM_TEST_DONE) == 0
 		    || (byte & 0x0F) != PRE_TEST_VALUE) {
@@ -12538,7 +12454,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 		}
 
 		AdvWriteByteRegister(iop_base, IOPB_RAM_BIST, NORMAL_MODE);
-		DvcSleepMilliSecond(10);	/* Wait for 10ms before reading back. */
+		mdelay(10);	/* Wait for 10ms before reading back. */
 		if (AdvReadByteRegister(iop_base, IOPB_RAM_BIST)
 		    != NORMAL_VALUE) {
 			asc_dvc->err_code = ASC_IERR_BIST_PRE_TEST;
@@ -12554,7 +12470,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	 * err_code, and return an error.
 	 */
 	AdvWriteByteRegister(iop_base, IOPB_RAM_BIST, RAM_TEST_MODE);
-	DvcSleepMilliSecond(10);	/* Wait for 10ms before checking status. */
+	mdelay(10);	/* Wait for 10ms before checking status. */
 
 	byte = AdvReadByteRegister(iop_base, IOPB_RAM_BIST);
 	if ((byte & RAM_TEST_DONE) == 0 || (byte & RAM_TEST_STATUS) != 0) {
@@ -13645,12 +13561,11 @@ static void __devinit AdvWaitEEPCmd(AdvPortAddr iop_base)
 		    ASC_EEP_CMD_DONE) {
 			break;
 		}
-		DvcSleepMilliSecond(1);
+		mdelay(1);
 	}
 	if ((AdvReadWordRegister(iop_base, IOPW_EE_CMD) & ASC_EEP_CMD_DONE) ==
-	    0) {
-		ASC_ASSERT(0);
-	}
+	    0)
+		BUG();
 	return;
 }
 
@@ -13688,7 +13603,7 @@ AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
 				     ASC_EEP_CMD_WRITE | addr);
 		AdvWaitEEPCmd(iop_base);
-		DvcSleepMilliSecond(ADV_EEP_DELAY_MS);
+		mdelay(ADV_EEP_DELAY_MS);
 	}
 
 	/*
@@ -13756,7 +13671,7 @@ AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
 				     ASC_EEP_CMD_WRITE | addr);
 		AdvWaitEEPCmd(iop_base);
-		DvcSleepMilliSecond(ADV_EEP_DELAY_MS);
+		mdelay(ADV_EEP_DELAY_MS);
 	}
 
 	/*
@@ -13824,7 +13739,7 @@ AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
 				     ASC_EEP_CMD_WRITE | addr);
 		AdvWaitEEPCmd(iop_base);
-		DvcSleepMilliSecond(ADV_EEP_DELAY_MS);
+		mdelay(ADV_EEP_DELAY_MS);
 	}
 
 	/*
@@ -13882,14 +13797,11 @@ AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
  */
 static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 {
-	ulong last_int_level;
 	AdvPortAddr iop_base;
 	ADV_DCNT req_size;
 	ADV_PADDR req_paddr;
 	ADV_CARR_T *new_carrp;
 
-	ASC_ASSERT(scsiq != NULL);	/* 'scsiq' should never be NULL. */
-
 	/*
 	 * The ADV_SCSI_REQ_Q 'target_id' field should never exceed ADV_MAX_TID.
 	 */
@@ -13901,14 +13813,11 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 
 	iop_base = asc_dvc->iop_base;
 
-	last_int_level = DvcEnterCritical();
-
 	/*
 	 * Allocate a carrier ensuring at least one carrier always
 	 * remains on the freelist and initialize fields.
 	 */
 	if ((new_carrp = asc_dvc->carr_freelist) == NULL) {
-		DvcLeaveCritical(last_int_level);
 		return ADV_BUSY;
 	}
 	asc_dvc->carr_freelist = (ADV_CARR_T *)
@@ -13931,8 +13840,8 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 	req_paddr = DvcGetPhyAddr(asc_dvc, scsiq, (uchar *)scsiq,
 				  (ADV_SDCNT *)&req_size, ADV_IS_SCSIQ_FLAG);
 
-	ASC_ASSERT(ADV_32BALIGN(req_paddr) == req_paddr);
-	ASC_ASSERT(req_size >= sizeof(ADV_SCSI_REQ_Q));
+	BUG_ON(req_paddr & 31);
+	BUG_ON(req_size < sizeof(ADV_SCSI_REQ_Q));
 
 	/* Wait for assertion before making little-endian */
 	req_paddr = cpu_to_le32(req_paddr);
@@ -13991,8 +13900,6 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 				      le32_to_cpu(new_carrp->carr_pa));
 	}
 
-	DvcLeaveCritical(last_int_level);
-
 	return ADV_SUCCESS;
 }
 
@@ -14024,7 +13931,7 @@ static int AdvResetSB(ADV_DVC_VAR *asc_dvc)
 	 * The hold time delay is done on the host because the RISC has no
 	 * microsecond accurate timer.
 	 */
-	DvcDelayMicroSecond(asc_dvc, (ushort)ASC_SCSI_RESET_HOLD_TIME_US);
+	udelay(ASC_SCSI_RESET_HOLD_TIME_US);
 
 	/*
 	 * Send the SCSI Bus Reset end idle command which de-asserts
@@ -14035,7 +13942,7 @@ static int AdvResetSB(ADV_DVC_VAR *asc_dvc)
 		return status;
 	}
 
-	DvcSleepMilliSecond((ADV_DCNT)asc_dvc->scsi_reset_wait * 1000);
+	mdelay(asc_dvc->scsi_reset_wait * 1000);	/* XXX: msleep? */
 
 	return status;
 }
@@ -14086,7 +13993,7 @@ static int AdvResetChipAndSB(ADV_DVC_VAR *asc_dvc)
 	 */
 	AdvWriteWordRegister(iop_base, IOPW_RISC_CSR, ADV_RISC_CSR_STOP);
 	AdvWriteWordRegister(iop_base, IOPW_CTRL_REG, ADV_CTRL_REG_CMD_RESET);
-	DvcSleepMilliSecond(100);
+	mdelay(100);
 	AdvWriteWordRegister(iop_base, IOPW_CTRL_REG,
 			     ADV_CTRL_REG_CMD_WR_IO_REG);
 
@@ -14158,11 +14065,8 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 	ushort target_bit;
 	ADV_CARR_T *free_carrp;
 	ADV_VADDR irq_next_vpa;
-	int flags;
 	ADV_SCSI_REQ_Q *scsiq;
 
-	flags = DvcEnterCritical();
-
 	iop_base = asc_dvc->iop_base;
 
 	/* Reading the register clears the interrupt. */
@@ -14170,7 +14074,6 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 
 	if ((int_stat & (ADV_INTR_STATUS_INTRA | ADV_INTR_STATUS_INTRB |
 			 ADV_INTR_STATUS_INTRC)) == 0) {
-		DvcLeaveCritical(flags);
 		return ADV_FALSE;
 	}
 
@@ -14243,7 +14146,6 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		asc_dvc->carr_freelist = free_carrp;
 		asc_dvc->carr_pending_cnt--;
 
-		ASC_ASSERT(scsiq != NULL);
 		target_bit = ADV_TID_TO_TIDMASK(scsiq->target_id);
 
 		/*
@@ -14264,18 +14166,7 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		 * Fall through and continue processing other completed
 		 * requests...
 		 */
-
-		/*
-		 * Disable interrupts again in case the driver inadvertently
-		 * enabled interrupts in its callback function.
-		 *
-		 * The DvcEnterCritical() return value is ignored, because
-		 * the 'flags' saved when AdvISR() was first entered will be
-		 * used to restore the interrupt flag on exit.
-		 */
-		(void)DvcEnterCritical();
 	}
-	DvcLeaveCritical(flags);
 	return ADV_TRUE;
 }
 
@@ -14297,13 +14188,10 @@ static int
 AdvSendIdleCmd(ADV_DVC_VAR *asc_dvc,
 	       ushort idle_cmd, ADV_DCNT idle_cmd_parameter)
 {
-	ulong last_int_level;
 	int result;
 	ADV_DCNT i, j;
 	AdvPortAddr iop_base;
 
-	last_int_level = DvcEnterCritical();
-
 	iop_base = asc_dvc->iop_base;
 
 	/*
@@ -14343,16 +14231,13 @@ AdvSendIdleCmd(ADV_DVC_VAR *asc_dvc,
 		for (j = 0; j < SCSI_US_PER_MSEC; j++) {
 			AdvReadWordLram(iop_base, ASC_MC_IDLE_CMD_STATUS,
 					result);
-			if (result != 0) {
-				DvcLeaveCritical(last_int_level);
+			if (result != 0)
 				return result;
-			}
-			DvcDelayMicroSecond(asc_dvc, (ushort)1);
+			udelay(1);
 		}
 	}
 
-	ASC_ASSERT(0);		/* The idle command should never timeout. */
-	DvcLeaveCritical(last_int_level);
+	BUG();		/* The idle command should never timeout. */
 	return ADV_ERROR;
 }
 
-- 
1.5.2.4

