From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 01/17] advansys: Eliminate prototypes
Date: Sun, 16 Sep 2007 09:37:32 -0600
Message-ID: <11899570681895-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:50483 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXIPPhn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:37:43 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Rearrange a lot of the functions in the file to get rid of all the forward
declarations.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |12273 +++++++++++++++++++++++------------------------
 1 files changed, 6043 insertions(+), 6230 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 0303fc7..4f047cc 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -878,7 +878,6 @@ typedef struct asceep_config {
 #define ASC_1000_ID0W_FIX  0x00C1
 #define ASC_1000_ID1B      0x25
 #define ASC_EISA_REV_IOP_MASK  (0x0C83)
-#define ASC_EISA_PID_IOP_MASK  (0x0C80)
 #define ASC_EISA_CFG_IOP_MASK  (0x0C86)
 #define ASC_GET_EISA_SLOT(iop)  (PortAddr)((iop) & 0xF000)
 #define INS_HALTINT        (ushort)0x6281
@@ -903,10 +902,10 @@ typedef struct asc_mc_saved {
 #define AscGetRiscVarDoneQTail(port)        AscReadLramByte((port), ASCV_DONENEXT_B)
 #define AscPutRiscVarFreeQHead(port, val)   AscWriteLramByte((port), ASCV_NEXTRDY_B, val)
 #define AscPutRiscVarDoneQTail(port, val)   AscWriteLramByte((port), ASCV_DONENEXT_B, val)
-#define AscPutMCodeSDTRDoneAtID(port, id, data)  AscWriteLramByte((port), (ushort)((ushort)ASCV_SDTR_DONE_BEG+(ushort)id), (data));
-#define AscGetMCodeSDTRDoneAtID(port, id)        AscReadLramByte((port), (ushort)((ushort)ASCV_SDTR_DONE_BEG+(ushort)id));
-#define AscPutMCodeInitSDTRAtID(port, id, data)  AscWriteLramByte((port), (ushort)((ushort)ASCV_SDTR_DATA_BEG+(ushort)id), data);
-#define AscGetMCodeInitSDTRAtID(port, id)        AscReadLramByte((port), (ushort)((ushort)ASCV_SDTR_DATA_BEG+(ushort)id));
+#define AscPutMCodeSDTRDoneAtID(port, id, data)  AscWriteLramByte((port), (ushort)((ushort)ASCV_SDTR_DONE_BEG+(ushort)id), (data))
+#define AscGetMCodeSDTRDoneAtID(port, id)        AscReadLramByte((port), (ushort)((ushort)ASCV_SDTR_DONE_BEG+(ushort)id))
+#define AscPutMCodeInitSDTRAtID(port, id, data)  AscWriteLramByte((port), (ushort)((ushort)ASCV_SDTR_DATA_BEG+(ushort)id), data)
+#define AscGetMCodeInitSDTRAtID(port, id)        AscReadLramByte((port), (ushort)((ushort)ASCV_SDTR_DATA_BEG+(ushort)id))
 #define AscSynIndexToPeriod(index)        (uchar)(asc_dvc->sdtr_period_tbl[ (index) ])
 #define AscGetChipSignatureByte(port)     (uchar)inp((port)+IOP_SIG_BYTE)
 #define AscGetChipSignatureWord(port)     (ushort)inpw((port)+IOP_SIG_WORD)
@@ -962,83 +961,6 @@ typedef struct asc_mc_saved {
 #define AscReadChipDvcID(port)            (uchar)inp((port)+IOP_REG_ID)
 #define AscWriteChipDvcID(port, data)     outp((port)+IOP_REG_ID, data)
 
-static int AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg);
-static int AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg);
-static void AscWaitEEPRead(void);
-static void AscWaitEEPWrite(void);
-static ushort AscReadEEPWord(PortAddr, uchar);
-static ushort AscWriteEEPWord(PortAddr, uchar, ushort);
-static ushort AscGetEEPConfig(PortAddr, ASCEEP_CONFIG *, ushort);
-static int AscSetEEPConfigOnce(PortAddr, ASCEEP_CONFIG *, ushort);
-static int AscSetEEPConfig(PortAddr, ASCEEP_CONFIG *, ushort);
-static int AscStartChip(PortAddr);
-static int AscStopChip(PortAddr);
-static void AscSetChipIH(PortAddr, ushort);
-static int AscIsChipHalted(PortAddr);
-static void AscAckInterrupt(PortAddr);
-static void AscDisableInterrupt(PortAddr);
-static void AscEnableInterrupt(PortAddr);
-static void AscSetBank(PortAddr, uchar);
-static int AscResetChipAndScsiBus(ASC_DVC_VAR *);
-#ifdef CONFIG_ISA
-static uchar AscGetIsaDmaSpeed(PortAddr);
-#endif /* CONFIG_ISA */
-static uchar AscReadLramByte(PortAddr, ushort);
-static ushort AscReadLramWord(PortAddr, ushort);
-#if CC_VERY_LONG_SG_LIST
-static ASC_DCNT AscReadLramDWord(PortAddr, ushort);
-#endif /* CC_VERY_LONG_SG_LIST */
-static void AscWriteLramWord(PortAddr, ushort, ushort);
-static void AscWriteLramByte(PortAddr, ushort, uchar);
-static ASC_DCNT AscMemSumLramWord(PortAddr, ushort, int);
-static void AscMemWordSetLram(PortAddr, ushort, ushort, int);
-static void AscMemWordCopyPtrToLram(PortAddr, ushort, uchar *, int);
-static void AscMemDWordCopyPtrToLram(PortAddr, ushort, uchar *, int);
-static void AscMemWordCopyPtrFromLram(PortAddr, ushort, uchar *, int);
-static ushort AscInitAscDvcVar(ASC_DVC_VAR *);
-static ushort AscInitFromEEP(ASC_DVC_VAR *);
-static ushort AscInitMicroCodeVar(ASC_DVC_VAR *);
-static int AscTestExternalLram(ASC_DVC_VAR *);
-static uchar AscMsgOutSDTR(ASC_DVC_VAR *, uchar, uchar);
-static uchar AscCalSDTRData(ASC_DVC_VAR *, uchar, uchar);
-static void AscSetChipSDTR(PortAddr, uchar, uchar);
-static uchar AscGetSynPeriodIndex(ASC_DVC_VAR *, uchar);
-static uchar AscAllocFreeQueue(PortAddr, uchar);
-static uchar AscAllocMultipleFreeQueue(PortAddr, uchar, uchar);
-static int AscHostReqRiscHalt(PortAddr);
-static int AscStopQueueExe(PortAddr);
-static int AscSendScsiQueue(ASC_DVC_VAR *,
-			    ASC_SCSI_Q *scsiq, uchar n_q_required);
-static int AscPutReadyQueue(ASC_DVC_VAR *, ASC_SCSI_Q *, uchar);
-static int AscPutReadySgListQueue(ASC_DVC_VAR *, ASC_SCSI_Q *, uchar);
-static int AscSetChipSynRegAtID(PortAddr, uchar, uchar);
-static int AscSetRunChipSynRegAtID(PortAddr, uchar, uchar);
-static ushort AscInitLram(ASC_DVC_VAR *);
-static int AscSetLibErrorCode(ASC_DVC_VAR *, ushort);
-static int AscIsrChipHalted(ASC_DVC_VAR *);
-static uchar _AscCopyLramScsiDoneQ(PortAddr, ushort,
-				   ASC_QDONE_INFO *, ASC_DCNT);
-static int AscIsrQDone(ASC_DVC_VAR *);
-#ifdef CONFIG_ISA
-static ushort AscGetEisaChipCfg(PortAddr);
-#endif /* CONFIG_ISA */
-static uchar AscGetChipScsiCtrl(PortAddr);
-static uchar AscGetChipVersion(PortAddr, ushort);
-static ASC_DCNT AscLoadMicroCode(PortAddr, ushort, uchar *, ushort);
-static void AscToggleIRQAct(PortAddr);
-static void DvcPutScsiQ(PortAddr, ushort, uchar *, int);
-static void DvcGetQinfo(PortAddr, ushort, uchar *, int);
-static ushort AscInitAsc1000Driver(ASC_DVC_VAR *);
-static void AscAsyncFix(ASC_DVC_VAR *, struct scsi_device *);
-static int AscExeScsiQueue(ASC_DVC_VAR *, ASC_SCSI_Q *);
-static int AscISR(ASC_DVC_VAR *);
-static uint AscGetNumOfFreeQueue(ASC_DVC_VAR *, uchar, uchar);
-static int AscSgListToQueue(int);
-#ifdef CONFIG_ISA
-static void AscEnableIsaDma(uchar);
-#endif /* CONFIG_ISA */
-static const char *advansys_info(struct Scsi_Host *shost);
-
 #define ADV_LIB_VERSION_MAJOR  5
 #define ADV_LIB_VERSION_MINOR  14
 
@@ -2109,36 +2031,6 @@ typedef struct adv_scsi_req_q {
 
 #define ADV_HOST_SCSI_BUS_RESET      0x80	/* Host Initiated SCSI Bus Reset. */
 
-static ADV_PADDR DvcGetPhyAddr(ADV_DVC_VAR *, ADV_SCSI_REQ_Q *,
-			       uchar *, ASC_SDCNT *, int);
-
-/*
- * Adv Library functions available to drivers.
- */
-static int AdvExeScsiQueue(ADV_DVC_VAR *, ADV_SCSI_REQ_Q *);
-static int AdvISR(ADV_DVC_VAR *);
-static int AdvInitAsc3550Driver(ADV_DVC_VAR *);
-static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *);
-static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *);
-static int AdvResetChipAndSB(ADV_DVC_VAR *);
-static int AdvResetSB(ADV_DVC_VAR *asc_dvc);
-
-/*
- * Internal Adv Library functions.
- */
-static int AdvSendIdleCmd(ADV_DVC_VAR *, ushort, ADV_DCNT);
-static int AdvInitFrom3550EEP(ADV_DVC_VAR *);
-static int AdvInitFrom38C0800EEP(ADV_DVC_VAR *);
-static int AdvInitFrom38C1600EEP(ADV_DVC_VAR *);
-static ushort AdvGet3550EEPConfig(AdvPortAddr, ADVEEP_3550_CONFIG *);
-static void AdvSet3550EEPConfig(AdvPortAddr, ADVEEP_3550_CONFIG *);
-static ushort AdvGet38C0800EEPConfig(AdvPortAddr, ADVEEP_38C0800_CONFIG *);
-static void AdvSet38C0800EEPConfig(AdvPortAddr, ADVEEP_38C0800_CONFIG *);
-static ushort AdvGet38C1600EEPConfig(AdvPortAddr, ADVEEP_38C1600_CONFIG *);
-static void AdvSet38C1600EEPConfig(AdvPortAddr, ADVEEP_38C1600_CONFIG *);
-static void AdvWaitEEPCmd(AdvPortAddr);
-static ushort AdvReadEEPWord(AdvPortAddr, int);
-
 /* Read byte from a register. */
 #define AdvReadByteRegister(iop_base, reg_off) \
      (ADV_MEM_READB((iop_base) + (reg_off)))
@@ -2676,1717 +2568,489 @@ static ASC_SG_HEAD asc_sg_head = { 0 };
 
 #ifdef ADVANSYS_DEBUG
 static int asc_dbglvl = 3;
-#endif /* ADVANSYS_DEBUG */
-
-static int advansys_slave_configure(struct scsi_device *);
-static int asc_execute_scsi_cmnd(struct scsi_cmnd *);
-static int asc_build_req(asc_board_t *, struct scsi_cmnd *);
-static int adv_build_req(asc_board_t *, struct scsi_cmnd *, ADV_SCSI_REQ_Q **);
-static int adv_get_sglist(asc_board_t *, adv_req_t *, struct scsi_cmnd *, int);
-#ifdef CONFIG_PROC_FS
-static int asc_proc_copy(off_t, off_t, char *, int, char *, int);
-static int asc_prt_board_devices(struct Scsi_Host *, char *, int);
-static int asc_prt_adv_bios(struct Scsi_Host *, char *, int);
-static int asc_get_eeprom_string(ushort *serialnum, uchar *cp);
-static int asc_prt_asc_board_eeprom(struct Scsi_Host *, char *, int);
-static int asc_prt_adv_board_eeprom(struct Scsi_Host *, char *, int);
-static int asc_prt_driver_conf(struct Scsi_Host *, char *, int);
-static int asc_prt_asc_board_info(struct Scsi_Host *, char *, int);
-static int asc_prt_adv_board_info(struct Scsi_Host *, char *, int);
-static int asc_prt_line(char *, int, char *fmt, ...);
-#endif /* CONFIG_PROC_FS */
 
-/* Statistics function prototypes. */
-#ifdef ADVANSYS_STATS
-#ifdef CONFIG_PROC_FS
-static int asc_prt_board_stats(struct Scsi_Host *, char *, int);
-#endif /* CONFIG_PROC_FS */
-#endif /* ADVANSYS_STATS */
-
-/* Debug function prototypes. */
-#ifdef ADVANSYS_DEBUG
-static void asc_prt_scsi_host(struct Scsi_Host *);
-static void asc_prt_scsi_cmnd(struct scsi_cmnd *);
-static void asc_prt_asc_dvc_cfg(ASC_DVC_CFG *);
-static void asc_prt_asc_dvc_var(ASC_DVC_VAR *);
-static void asc_prt_asc_scsi_q(ASC_SCSI_Q *);
-static void asc_prt_asc_qdone_info(ASC_QDONE_INFO *);
-static void asc_prt_adv_dvc_cfg(ADV_DVC_CFG *);
-static void asc_prt_adv_dvc_var(ADV_DVC_VAR *);
-static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *);
-static void asc_prt_adv_sgblock(int, ADV_SG_BLOCK *);
-static void asc_prt_hex(char *f, uchar *, int);
-#endif /* ADVANSYS_DEBUG */
-
-#ifdef CONFIG_PROC_FS
 /*
- * advansys_proc_info() - /proc/scsi/advansys/{0,1,2,3,...}
- *
- * *buffer: I/O buffer
- * **start: if inout == FALSE pointer into buffer where user read should start
- * offset: current offset into a /proc/scsi/advansys/[0...] file
- * length: length of buffer
- * hostno: Scsi_Host host_no
- * inout: TRUE - user is writing; FALSE - user is reading
- *
- * Return the number of bytes read from or written to a
- * /proc/scsi/advansys/[0...] file.
- *
- * Note: This function uses the per board buffer 'prtbuf' which is
- * allocated when the board is initialized in advansys_detect(). The
- * buffer is ASC_PRTBUF_SIZE bytes. The function asc_proc_copy() is
- * used to write to the buffer. The way asc_proc_copy() is written
- * if 'prtbuf' is too small it will not be overwritten. Instead the
- * user just won't get all the available statistics.
+ * asc_prt_scsi_host()
  */
-static int
-advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
-		   off_t offset, int length, int inout)
+static void asc_prt_scsi_host(struct Scsi_Host *s)
 {
 	asc_board_t *boardp;
-	char *cp;
-	int cplen;
-	int cnt;
-	int totcnt;
-	int leftlen;
-	char *curbuf;
-	off_t advoffset;
-
-	ASC_DBG(1, "advansys_proc_info: begin\n");
-
-	/*
-	 * User write not supported.
-	 */
-	if (inout == TRUE) {
-		return (-ENOSYS);
-	}
-
-	/*
-	 * User read of /proc/scsi/advansys/[0...] file.
-	 */
-
-	boardp = ASC_BOARDP(shost);
-
-	/* Copy read data starting at the beginning of the buffer. */
-	*start = buffer;
-	curbuf = buffer;
-	advoffset = 0;
-	totcnt = 0;
-	leftlen = length;
-
-	/*
-	 * Get board configuration information.
-	 *
-	 * advansys_info() returns the board string from its own static buffer.
-	 */
-	cp = (char *)advansys_info(shost);
-	strcat(cp, "\n");
-	cplen = strlen(cp);
-	/* Copy board information. */
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
 
-	/*
-	 * Display Wide Board BIOS Information.
-	 */
-	if (ASC_WIDE_BOARD(boardp)) {
-		cp = boardp->prtbuf;
-		cplen = asc_prt_adv_bios(shost, cp, ASC_PRTBUF_SIZE);
-		BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-		cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
-				  cplen);
-		totcnt += cnt;
-		leftlen -= cnt;
-		if (leftlen == 0) {
-			ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-			return totcnt;
-		}
-		advoffset += cplen;
-		curbuf += cnt;
-	}
+	boardp = ASC_BOARDP(s);
 
-	/*
-	 * Display driver information for each device attached to the board.
-	 */
-	cp = boardp->prtbuf;
-	cplen = asc_prt_board_devices(shost, cp, ASC_PRTBUF_SIZE);
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
+	printk("Scsi_Host at addr 0x%lx\n", (ulong)s);
+	printk(" host_busy %u, host_no %d, last_reset %d,\n",
+	       s->host_busy, s->host_no, (unsigned)s->last_reset);
 
-	/*
-	 * Display EEPROM configuration for the board.
-	 */
-	cp = boardp->prtbuf;
-	if (ASC_NARROW_BOARD(boardp)) {
-		cplen = asc_prt_asc_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
-	} else {
-		cplen = asc_prt_adv_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
-	}
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
+	printk(" base 0x%lx, io_port 0x%lx, irq 0x%x,\n",
+	       (ulong)s->base, (ulong)s->io_port, s->irq);
 
-	/*
-	 * Display driver configuration and information for the board.
-	 */
-	cp = boardp->prtbuf;
-	cplen = asc_prt_driver_conf(shost, cp, ASC_PRTBUF_SIZE);
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
+	printk(" dma_channel %d, this_id %d, can_queue %d,\n",
+	       s->dma_channel, s->this_id, s->can_queue);
 
-#ifdef ADVANSYS_STATS
-	/*
-	 * Display driver statistics for the board.
-	 */
-	cp = boardp->prtbuf;
-	cplen = asc_prt_board_stats(shost, cp, ASC_PRTBUF_SIZE);
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-		return totcnt;
-	}
-	advoffset += cplen;
-	curbuf += cnt;
-#endif /* ADVANSYS_STATS */
+	printk(" cmd_per_lun %d, sg_tablesize %d, unchecked_isa_dma %d\n",
+	       s->cmd_per_lun, s->sg_tablesize, s->unchecked_isa_dma);
 
-	/*
-	 * Display Asc Library dynamic configuration information
-	 * for the board.
-	 */
-	cp = boardp->prtbuf;
 	if (ASC_NARROW_BOARD(boardp)) {
-		cplen = asc_prt_asc_board_info(shost, cp, ASC_PRTBUF_SIZE);
+		asc_prt_asc_dvc_var(&ASC_BOARDP(s)->dvc_var.asc_dvc_var);
+		asc_prt_asc_dvc_cfg(&ASC_BOARDP(s)->dvc_cfg.asc_dvc_cfg);
 	} else {
-		cplen = asc_prt_adv_board_info(shost, cp, ASC_PRTBUF_SIZE);
-	}
-	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
-	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-	totcnt += cnt;
-	leftlen -= cnt;
-	if (leftlen == 0) {
-		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-		return totcnt;
+		asc_prt_adv_dvc_var(&ASC_BOARDP(s)->dvc_var.adv_dvc_var);
+		asc_prt_adv_dvc_cfg(&ASC_BOARDP(s)->dvc_cfg.adv_dvc_cfg);
 	}
-	advoffset += cplen;
-	curbuf += cnt;
-
-	ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-
-	return totcnt;
 }
-#endif /* CONFIG_PROC_FS */
 
 /*
- * advansys_info()
- *
- * Return suitable for printing on the console with the argument
- * adapter's configuration information.
- *
- * Note: The information line should not exceed ASC_INFO_SIZE bytes,
- * otherwise the static 'info' array will be overrun.
+ * asc_prt_scsi_cmnd()
  */
-static const char *advansys_info(struct Scsi_Host *shost)
-{
-	static char info[ASC_INFO_SIZE];
-	asc_board_t *boardp;
-	ASC_DVC_VAR *asc_dvc_varp;
-	ADV_DVC_VAR *adv_dvc_varp;
-	char *busname;
-	char *widename = NULL;
-
-	boardp = ASC_BOARDP(shost);
-	if (ASC_NARROW_BOARD(boardp)) {
-		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
-		ASC_DBG(1, "advansys_info: begin\n");
-		if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
-			if ((asc_dvc_varp->bus_type & ASC_IS_ISAPNP) ==
-			    ASC_IS_ISAPNP) {
-				busname = "ISA PnP";
-			} else {
-				busname = "ISA";
-			}
-			sprintf(info,
-				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X, DMA 0x%X",
-				ASC_VERSION, busname,
-				(ulong)shost->io_port,
-				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
-				shost->irq, shost->dma_channel);
-		} else {
-			if (asc_dvc_varp->bus_type & ASC_IS_VL) {
-				busname = "VL";
-			} else if (asc_dvc_varp->bus_type & ASC_IS_EISA) {
-				busname = "EISA";
-			} else if (asc_dvc_varp->bus_type & ASC_IS_PCI) {
-				if ((asc_dvc_varp->bus_type & ASC_IS_PCI_ULTRA)
-				    == ASC_IS_PCI_ULTRA) {
-					busname = "PCI Ultra";
-				} else {
-					busname = "PCI";
-				}
-			} else {
-				busname = "?";
-				ASC_PRINT2("advansys_info: board %d: unknown "
-					   "bus type %d\n", boardp->id,
-					   asc_dvc_varp->bus_type);
-			}
-			sprintf(info,
-				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X",
-				ASC_VERSION, busname, (ulong)shost->io_port,
-				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
-				shost->irq);
-		}
-	} else {
-		/*
-		 * Wide Adapter Information
-		 *
-		 * Memory-mapped I/O is used instead of I/O space to access
-		 * the adapter, but display the I/O Port range. The Memory
-		 * I/O address is displayed through the driver /proc file.
-		 */
-		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
-		if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-			widename = "Ultra-Wide";
-		} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
-			widename = "Ultra2-Wide";
-		} else {
-			widename = "Ultra3-Wide";
-		}
-		sprintf(info,
-			"AdvanSys SCSI %s: PCI %s: PCIMEM 0x%lX-0x%lX, IRQ 0x%X",
-			ASC_VERSION, widename, (ulong)adv_dvc_varp->iop_base,
-			(ulong)adv_dvc_varp->iop_base + boardp->asc_n_io_port - 1, shost->irq);
-	}
-	BUG_ON(strlen(info) >= ASC_INFO_SIZE);
-	ASC_DBG(1, "advansys_info: end\n");
-	return info;
-}
-
-static void asc_scsi_done(struct scsi_cmnd *scp)
+static void asc_prt_scsi_cmnd(struct scsi_cmnd *s)
 {
-	struct asc_board *boardp = ASC_BOARDP(scp->device->host);
+	printk("struct scsi_cmnd at addr 0x%lx\n", (ulong)s);
 
-	if (scp->use_sg)
-		dma_unmap_sg(boardp->dev,
-			     (struct scatterlist *)scp->request_buffer,
-			     scp->use_sg, scp->sc_data_direction);
-	else if (scp->request_bufflen)
-		dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
-				 scp->request_bufflen, scp->sc_data_direction);
+	printk(" host 0x%lx, device 0x%lx, target %u, lun %u, channel %u,\n",
+	       (ulong)s->device->host, (ulong)s->device, s->device->id,
+	       s->device->lun, s->device->channel);
 
-	ASC_STATS(scp->device->host, done);
+	asc_prt_hex(" CDB", s->cmnd, s->cmd_len);
 
-	scp->scsi_done(scp);
-}
+	printk("sc_data_direction %u, resid %d\n",
+	       s->sc_data_direction, s->resid);
 
-/*
- * advansys_queuecommand() - interrupt-driven I/O entrypoint.
- *
- * This function always returns 0. Command return status is saved
- * in the 'scp' result field.
- */
-static int
-advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
-{
-	struct Scsi_Host *shost = scp->device->host;
-	asc_board_t *boardp = ASC_BOARDP(shost);
-	unsigned long flags;
-	int asc_res, result = 0;
+	printk(" use_sg %u, sglist_len %u\n", s->use_sg, s->sglist_len);
 
-	ASC_STATS(shost, queuecommand);
-	scp->scsi_done = done;
+	printk(" serial_number 0x%x, retries %d, allowed %d\n",
+	       (unsigned)s->serial_number, s->retries, s->allowed);
 
-	/*
-	 * host_lock taken by mid-level prior to call, but need
-	 * to protect against own ISR
-	 */
-	spin_lock_irqsave(&boardp->lock, flags);
-	asc_res = asc_execute_scsi_cmnd(scp);
-	spin_unlock_irqrestore(&boardp->lock, flags);
+	printk(" timeout_per_command %d\n", s->timeout_per_command);
 
-	switch (asc_res) {
-	case ASC_NOERROR:
-		break;
-	case ASC_BUSY:
-		result = SCSI_MLQUEUE_HOST_BUSY;
-		break;
-	case ASC_ERROR:
-	default:
-		asc_scsi_done(scp);
-		break;
-	}
+	printk(" scsi_done 0x%p, done 0x%p, host_scribble 0x%p, result 0x%x\n",
+		s->scsi_done, s->done, s->host_scribble, s->result);
 
-	return result;
+	printk(" tag %u, pid %u\n", (unsigned)s->tag, (unsigned)s->pid);
 }
 
 /*
- * advansys_reset()
- *
- * Reset the bus associated with the command 'scp'.
- *
- * This function runs its own thread. Interrupts must be blocked but
- * sleeping is allowed and no locking other than for host structures is
- * required. Returns SUCCESS or FAILED.
+ * asc_prt_asc_dvc_var()
  */
-static int advansys_reset(struct scsi_cmnd *scp)
+static void asc_prt_asc_dvc_var(ASC_DVC_VAR *h)
 {
-	struct Scsi_Host *shost;
-	asc_board_t *boardp;
-	ASC_DVC_VAR *asc_dvc_varp;
-	ADV_DVC_VAR *adv_dvc_varp;
-	ulong flags;
-	int status;
-	int ret = SUCCESS;
-
-	ASC_DBG1(1, "advansys_reset: 0x%lx\n", (ulong)scp);
-
-#ifdef ADVANSYS_STATS
-	if (scp->device->host != NULL) {
-		ASC_STATS(scp->device->host, reset);
-	}
-#endif /* ADVANSYS_STATS */
-
-	if ((shost = scp->device->host) == NULL) {
-		scp->result = HOST_BYTE(DID_ERROR);
-		return FAILED;
-	}
-
-	boardp = ASC_BOARDP(shost);
-
-	ASC_PRINT1("advansys_reset: board %d: SCSI bus reset started...\n",
-		   boardp->id);
-	/*
-	 * Check for re-entrancy.
-	 */
-	spin_lock_irqsave(&boardp->lock, flags);
-	if (boardp->flags & ASC_HOST_IN_RESET) {
-		spin_unlock_irqrestore(&boardp->lock, flags);
-		return FAILED;
-	}
-	boardp->flags |= ASC_HOST_IN_RESET;
-	spin_unlock_irqrestore(&boardp->lock, flags);
-
-	if (ASC_NARROW_BOARD(boardp)) {
-		/*
-		 * Narrow Board
-		 */
-		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
-
-		/*
-		 * Reset the chip and SCSI bus.
-		 */
-		ASC_DBG(1, "advansys_reset: before AscInitAsc1000Driver()\n");
-		status = AscInitAsc1000Driver(asc_dvc_varp);
-
-		/* Refer to ASC_IERR_* defintions for meaning of 'err_code'. */
-		if (asc_dvc_varp->err_code) {
-			ASC_PRINT2("advansys_reset: board %d: SCSI bus reset "
-				   "error: 0x%x\n", boardp->id,
-				   asc_dvc_varp->err_code);
-			ret = FAILED;
-		} else if (status) {
-			ASC_PRINT2("advansys_reset: board %d: SCSI bus reset "
-				   "warning: 0x%x\n", boardp->id, status);
-		} else {
-			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
-				   "successful.\n", boardp->id);
-		}
-
-		ASC_DBG(1, "advansys_reset: after AscInitAsc1000Driver()\n");
-		spin_lock_irqsave(&boardp->lock, flags);
-
-	} else {
-		/*
-		 * Wide Board
-		 *
-		 * If the suggest reset bus flags are set, then reset the bus.
-		 * Otherwise only reset the device.
-		 */
-		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
+	printk("ASC_DVC_VAR at addr 0x%lx\n", (ulong)h);
 
-		/*
-		 * Reset the target's SCSI bus.
-		 */
-		ASC_DBG(1, "advansys_reset: before AdvResetChipAndSB()\n");
-		switch (AdvResetChipAndSB(adv_dvc_varp)) {
-		case ASC_TRUE:
-			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
-				   "successful.\n", boardp->id);
-			break;
-		case ASC_FALSE:
-		default:
-			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
-				   "error.\n", boardp->id);
-			ret = FAILED;
-			break;
-		}
-		spin_lock_irqsave(&boardp->lock, flags);
-		(void)AdvISR(adv_dvc_varp);
-	}
-	/* Board lock is held. */
+	printk(" iop_base 0x%x, err_code 0x%x, dvc_cntl 0x%x, bug_fix_cntl "
+	       "%d,\n", h->iop_base, h->err_code, h->dvc_cntl, h->bug_fix_cntl);
 
-	/* Save the time of the most recently completed reset. */
-	boardp->last_reset = jiffies;
+	printk(" bus_type %d, init_sdtr 0x%x,\n", h->bus_type,
+		(unsigned)h->init_sdtr);
 
-	/* Clear reset flag. */
-	boardp->flags &= ~ASC_HOST_IN_RESET;
-	spin_unlock_irqrestore(&boardp->lock, flags);
+	printk(" sdtr_done 0x%x, use_tagged_qng 0x%x, unit_not_ready 0x%x, "
+	       "chip_no 0x%x,\n", (unsigned)h->sdtr_done,
+	       (unsigned)h->use_tagged_qng, (unsigned)h->unit_not_ready,
+	       (unsigned)h->chip_no);
 
-	ASC_DBG1(1, "advansys_reset: ret %d\n", ret);
+	printk(" queue_full_or_busy 0x%x, start_motor 0x%x, scsi_reset_wait "
+	       "%u,\n", (unsigned)h->queue_full_or_busy,
+	       (unsigned)h->start_motor, (unsigned)h->scsi_reset_wait);
 
-	return ret;
-}
+	printk(" is_in_int %u, max_total_qng %u, cur_total_qng %u, "
+	       "in_critical_cnt %u,\n", (unsigned)h->is_in_int,
+	       (unsigned)h->max_total_qng, (unsigned)h->cur_total_qng,
+	       (unsigned)h->in_critical_cnt);
 
-/*
- * advansys_biosparam()
- *
- * Translate disk drive geometry if the "BIOS greater than 1 GB"
- * support is enabled for a drive.
- *
- * ip (information pointer) is an int array with the following definition:
- * ip[0]: heads
- * ip[1]: sectors
- * ip[2]: cylinders
- */
-static int
-advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
-		   sector_t capacity, int ip[])
-{
-	asc_board_t *boardp;
+	printk(" last_q_shortage %u, init_state 0x%x, no_scam 0x%x, "
+	       "pci_fix_asyn_xfer 0x%x,\n", (unsigned)h->last_q_shortage,
+	       (unsigned)h->init_state, (unsigned)h->no_scam,
+	       (unsigned)h->pci_fix_asyn_xfer);
 
-	ASC_DBG(1, "advansys_biosparam: begin\n");
-	ASC_STATS(sdev->host, biosparam);
-	boardp = ASC_BOARDP(sdev->host);
-	if (ASC_NARROW_BOARD(boardp)) {
-		if ((boardp->dvc_var.asc_dvc_var.dvc_cntl &
-		     ASC_CNTL_BIOS_GT_1GB) && capacity > 0x200000) {
-			ip[0] = 255;
-			ip[1] = 63;
-		} else {
-			ip[0] = 64;
-			ip[1] = 32;
-		}
-	} else {
-		if ((boardp->dvc_var.adv_dvc_var.bios_ctrl &
-		     BIOS_CTRL_EXTENDED_XLAT) && capacity > 0x200000) {
-			ip[0] = 255;
-			ip[1] = 63;
-		} else {
-			ip[0] = 64;
-			ip[1] = 32;
-		}
-	}
-	ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
-	ASC_DBG(1, "advansys_biosparam: end\n");
-	return 0;
+	printk(" cfg 0x%lx, irq_no 0x%x\n", (ulong)h->cfg, (unsigned)h->irq_no);
 }
 
-static struct scsi_host_template advansys_template = {
-	.proc_name = DRV_NAME,
-#ifdef CONFIG_PROC_FS
-	.proc_info = advansys_proc_info,
-#endif
-	.name = DRV_NAME,
-	.info = advansys_info,
-	.queuecommand = advansys_queuecommand,
-	.eh_bus_reset_handler = advansys_reset,
-	.bios_param = advansys_biosparam,
-	.slave_configure = advansys_slave_configure,
-	/*
-	 * Because the driver may control an ISA adapter 'unchecked_isa_dma'
-	 * must be set. The flag will be cleared in advansys_board_found
-	 * for non-ISA adapters.
-	 */
-	.unchecked_isa_dma = 1,
-	/*
-	 * All adapters controlled by this driver are capable of large
-	 * scatter-gather lists. According to the mid-level SCSI documentation
-	 * this obviates any performance gain provided by setting
-	 * 'use_clustering'. But empirically while CPU utilization is increased
-	 * by enabling clustering, I/O throughput increases as well.
-	 */
-	.use_clustering = ENABLE_CLUSTERING,
-};
-
 /*
- * First-level interrupt handler.
- *
- * 'dev_id' is a pointer to the interrupting adapter's Scsi_Host.
+ * asc_prt_asc_dvc_cfg()
  */
-static irqreturn_t advansys_interrupt(int irq, void *dev_id)
-{
-	unsigned long flags;
-	struct Scsi_Host *shost = dev_id;
-	asc_board_t *boardp = ASC_BOARDP(shost);
-	irqreturn_t result = IRQ_NONE;
-
-	ASC_DBG1(2, "advansys_interrupt: boardp 0x%p\n", boardp);
-	spin_lock_irqsave(&boardp->lock, flags);
-	if (ASC_NARROW_BOARD(boardp)) {
-		if (AscIsIntPending(shost->io_port)) {
-			result = IRQ_HANDLED;
-			ASC_STATS(shost, interrupt);
-			ASC_DBG(1, "advansys_interrupt: before AscISR()\n");
-			AscISR(&boardp->dvc_var.asc_dvc_var);
-		}
-	} else {
-		ASC_DBG(1, "advansys_interrupt: before AdvISR()\n");
-		if (AdvISR(&boardp->dvc_var.adv_dvc_var)) {
-			result = IRQ_HANDLED;
-			ASC_STATS(shost, interrupt);
-		}
-	}
-	spin_unlock_irqrestore(&boardp->lock, flags);
-
-	ASC_DBG(1, "advansys_interrupt: end\n");
-	return result;
-}
-
-static void
-advansys_narrow_slave_configure(struct scsi_device *sdev, ASC_DVC_VAR *asc_dvc)
+static void asc_prt_asc_dvc_cfg(ASC_DVC_CFG *h)
 {
-	ASC_SCSI_BIT_ID_TYPE tid_bit = 1 << sdev->id;
-	ASC_SCSI_BIT_ID_TYPE orig_use_tagged_qng = asc_dvc->use_tagged_qng;
-
-	if (sdev->lun == 0) {
-		ASC_SCSI_BIT_ID_TYPE orig_init_sdtr = asc_dvc->init_sdtr;
-		if ((asc_dvc->cfg->sdtr_enable & tid_bit) && sdev->sdtr) {
-			asc_dvc->init_sdtr |= tid_bit;
-		} else {
-			asc_dvc->init_sdtr &= ~tid_bit;
-		}
-
-		if (orig_init_sdtr != asc_dvc->init_sdtr)
-			AscAsyncFix(asc_dvc, sdev);
-	}
-
-	if (sdev->tagged_supported) {
-		if (asc_dvc->cfg->cmd_qng_enabled & tid_bit) {
-			if (sdev->lun == 0) {
-				asc_dvc->cfg->can_tagged_qng |= tid_bit;
-				asc_dvc->use_tagged_qng |= tid_bit;
-			}
-			scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
-						asc_dvc->max_dvc_qng[sdev->id]);
-		}
-	} else {
-		if (sdev->lun == 0) {
-			asc_dvc->cfg->can_tagged_qng &= ~tid_bit;
-			asc_dvc->use_tagged_qng &= ~tid_bit;
-		}
-		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
-	}
-
-	if ((sdev->lun == 0) &&
-	    (orig_use_tagged_qng != asc_dvc->use_tagged_qng)) {
-		AscWriteLramByte(asc_dvc->iop_base, ASCV_DISC_ENABLE_B,
-				 asc_dvc->cfg->disc_enable);
-		AscWriteLramByte(asc_dvc->iop_base, ASCV_USE_TAGGED_QNG_B,
-				 asc_dvc->use_tagged_qng);
-		AscWriteLramByte(asc_dvc->iop_base, ASCV_CAN_TAGGED_QNG_B,
-				 asc_dvc->cfg->can_tagged_qng);
+	printk("ASC_DVC_CFG at addr 0x%lx\n", (ulong)h);
 
-		asc_dvc->max_dvc_qng[sdev->id] =
-					asc_dvc->cfg->max_tag_qng[sdev->id];
-		AscWriteLramByte(asc_dvc->iop_base,
-				 (ushort)(ASCV_MAX_DVC_QNG_BEG + sdev->id),
-				 asc_dvc->max_dvc_qng[sdev->id]);
-	}
-}
+	printk(" can_tagged_qng 0x%x, cmd_qng_enabled 0x%x,\n",
+	       h->can_tagged_qng, h->cmd_qng_enabled);
+	printk(" disc_enable 0x%x, sdtr_enable 0x%x,\n",
+	       h->disc_enable, h->sdtr_enable);
 
-/*
- * Wide Transfers
- *
- * If the EEPROM enabled WDTR for the device and the device supports wide
- * bus (16 bit) transfers, then turn on the device's 'wdtr_able' bit and
- * write the new value to the microcode.
- */
-static void
-advansys_wide_enable_wdtr(AdvPortAddr iop_base, unsigned short tidmask)
-{
-	unsigned short cfg_word;
-	AdvReadWordLram(iop_base, ASC_MC_WDTR_ABLE, cfg_word);
-	if ((cfg_word & tidmask) != 0)
-		return;
+	printk
+	    (" chip_scsi_id %d, isa_dma_speed %d, isa_dma_channel %d, chip_version %d,\n",
+	     h->chip_scsi_id, h->isa_dma_speed, h->isa_dma_channel,
+	     h->chip_version);
 
-	cfg_word |= tidmask;
-	AdvWriteWordLram(iop_base, ASC_MC_WDTR_ABLE, cfg_word);
+	printk
+	    (" pci_device_id %d, lib_serial_no %u, lib_version %u, mcode_date 0x%x,\n",
+	     to_pci_dev(h->dev)->device, h->lib_serial_no, h->lib_version,
+	     h->mcode_date);
 
-	/*
-	 * Clear the microcode SDTR and WDTR negotiation done indicators for
-	 * the target to cause it to negotiate with the new setting set above.
-	 * WDTR when accepted causes the target to enter asynchronous mode, so
-	 * SDTR must be negotiated.
-	 */
-	AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
-	cfg_word &= ~tidmask;
-	AdvWriteWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
-	AdvReadWordLram(iop_base, ASC_MC_WDTR_DONE, cfg_word);
-	cfg_word &= ~tidmask;
-	AdvWriteWordLram(iop_base, ASC_MC_WDTR_DONE, cfg_word);
+	printk(" mcode_version %d, overrun_buf 0x%lx\n",
+	       h->mcode_version, (ulong)h->overrun_buf);
 }
 
 /*
- * Synchronous Transfers
- *
- * If the EEPROM enabled SDTR for the device and the device
- * supports synchronous transfers, then turn on the device's
- * 'sdtr_able' bit. Write the new value to the microcode.
+ * asc_prt_asc_scsi_q()
  */
-static void
-advansys_wide_enable_sdtr(AdvPortAddr iop_base, unsigned short tidmask)
+static void asc_prt_asc_scsi_q(ASC_SCSI_Q *q)
 {
-	unsigned short cfg_word;
-	AdvReadWordLram(iop_base, ASC_MC_SDTR_ABLE, cfg_word);
-	if ((cfg_word & tidmask) != 0)
-		return;
-
-	cfg_word |= tidmask;
-	AdvWriteWordLram(iop_base, ASC_MC_SDTR_ABLE, cfg_word);
-
-	/*
-	 * Clear the microcode "SDTR negotiation" done indicator for the
-	 * target to cause it to negotiate with the new setting set above.
-	 */
-	AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
-	cfg_word &= ~tidmask;
-	AdvWriteWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
-}
+	ASC_SG_HEAD *sgp;
+	int i;
 
-/*
- * PPR (Parallel Protocol Request) Capable
- *
- * If the device supports DT mode, then it must be PPR capable.
- * The PPR message will be used in place of the SDTR and WDTR
- * messages to negotiate synchronous speed and offset, transfer
- * width, and protocol options.
- */
-static void advansys_wide_enable_ppr(ADV_DVC_VAR *adv_dvc,
-				AdvPortAddr iop_base, unsigned short tidmask)
-{
-	AdvReadWordLram(iop_base, ASC_MC_PPR_ABLE, adv_dvc->ppr_able);
-	adv_dvc->ppr_able |= tidmask;
-	AdvWriteWordLram(iop_base, ASC_MC_PPR_ABLE, adv_dvc->ppr_able);
-}
+	printk("ASC_SCSI_Q at addr 0x%lx\n", (ulong)q);
 
-static void
-advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
-{
-	AdvPortAddr iop_base = adv_dvc->iop_base;
-	unsigned short tidmask = 1 << sdev->id;
+	printk
+	    (" target_ix 0x%x, target_lun %u, srb_ptr 0x%lx, tag_code 0x%x,\n",
+	     q->q2.target_ix, q->q1.target_lun, (ulong)q->q2.srb_ptr,
+	     q->q2.tag_code);
 
-	if (sdev->lun == 0) {
-		/*
-		 * Handle WDTR, SDTR, and Tag Queuing. If the feature
-		 * is enabled in the EEPROM and the device supports the
-		 * feature, then enable it in the microcode.
-		 */
+	printk
+	    (" data_addr 0x%lx, data_cnt %lu, sense_addr 0x%lx, sense_len %u,\n",
+	     (ulong)le32_to_cpu(q->q1.data_addr),
+	     (ulong)le32_to_cpu(q->q1.data_cnt),
+	     (ulong)le32_to_cpu(q->q1.sense_addr), q->q1.sense_len);
 
-		if ((adv_dvc->wdtr_able & tidmask) && sdev->wdtr)
-			advansys_wide_enable_wdtr(iop_base, tidmask);
-		if ((adv_dvc->sdtr_able & tidmask) && sdev->sdtr)
-			advansys_wide_enable_sdtr(iop_base, tidmask);
-		if (adv_dvc->chip_type == ADV_CHIP_ASC38C1600 && sdev->ppr)
-			advansys_wide_enable_ppr(adv_dvc, iop_base, tidmask);
+	printk(" cdbptr 0x%lx, cdb_len %u, sg_head 0x%lx, sg_queue_cnt %u\n",
+	       (ulong)q->cdbptr, q->q2.cdb_len,
+	       (ulong)q->sg_head, q->q1.sg_queue_cnt);
 
-		/*
-		 * Tag Queuing is disabled for the BIOS which runs in polled
-		 * mode and would see no benefit from Tag Queuing. Also by
-		 * disabling Tag Queuing in the BIOS devices with Tag Queuing
-		 * bugs will at least work with the BIOS.
-		 */
-		if ((adv_dvc->tagqng_able & tidmask) &&
-		    sdev->tagged_supported) {
-			unsigned short cfg_word;
-			AdvReadWordLram(iop_base, ASC_MC_TAGQNG_ABLE, cfg_word);
-			cfg_word |= tidmask;
-			AdvWriteWordLram(iop_base, ASC_MC_TAGQNG_ABLE,
-					 cfg_word);
-			AdvWriteByteLram(iop_base,
-					 ASC_MC_NUMBER_OF_MAX_CMD + sdev->id,
-					 adv_dvc->max_dvc_qng);
+	if (q->sg_head) {
+		sgp = q->sg_head;
+		printk("ASC_SG_HEAD at addr 0x%lx\n", (ulong)sgp);
+		printk(" entry_cnt %u, queue_cnt %u\n", sgp->entry_cnt,
+		       sgp->queue_cnt);
+		for (i = 0; i < sgp->entry_cnt; i++) {
+			printk(" [%u]: addr 0x%lx, bytes %lu\n",
+			       i, (ulong)le32_to_cpu(sgp->sg_list[i].addr),
+			       (ulong)le32_to_cpu(sgp->sg_list[i].bytes));
 		}
-	}
 
-	if ((adv_dvc->tagqng_able & tidmask) && sdev->tagged_supported) {
-		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
-					adv_dvc->max_dvc_qng);
-	} else {
-		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 	}
 }
 
 /*
- * Set the number of commands to queue per device for the
- * specified host adapter.
+ * asc_prt_asc_qdone_info()
  */
-static int advansys_slave_configure(struct scsi_device *sdev)
+static void asc_prt_asc_qdone_info(ASC_QDONE_INFO *q)
 {
-	asc_board_t *boardp = ASC_BOARDP(sdev->host);
-	boardp->flags |= ASC_SELECT_QUEUE_DEPTHS;
-
-	/*
-	 * Save a pointer to the sdev and set its initial/maximum
-	 * queue depth.  Only save the pointer for a lun0 dev though.
-	 */
-	if (sdev->lun == 0)
-		boardp->device[sdev->id] = sdev;
-
-	if (ASC_NARROW_BOARD(boardp))
-		advansys_narrow_slave_configure(sdev,
-						&boardp->dvc_var.asc_dvc_var);
-	else
-		advansys_wide_slave_configure(sdev,
-						&boardp->dvc_var.adv_dvc_var);
-
-	return 0;
+	printk("ASC_QDONE_INFO at addr 0x%lx\n", (ulong)q);
+	printk(" srb_ptr 0x%lx, target_ix %u, cdb_len %u, tag_code %u,\n",
+	       (ulong)q->d2.srb_ptr, q->d2.target_ix, q->d2.cdb_len,
+	       q->d2.tag_code);
+	printk
+	    (" done_stat 0x%x, host_stat 0x%x, scsi_stat 0x%x, scsi_msg 0x%x\n",
+	     q->d3.done_stat, q->d3.host_stat, q->d3.scsi_stat, q->d3.scsi_msg);
 }
 
 /*
- * Execute a single 'Scsi_Cmnd'.
- *
- * The function 'done' is called when the request has been completed.
- *
- * Scsi_Cmnd:
- *
- *  host - board controlling device
- *  device - device to send command
- *  target - target of device
- *  lun - lun of device
- *  cmd_len - length of SCSI CDB
- *  cmnd - buffer for SCSI 8, 10, or 12 byte CDB
- *  use_sg - if non-zero indicates scatter-gather request with use_sg elements
- *
- *  if (use_sg == 0) {
- *    request_buffer - buffer address for request
- *    request_bufflen - length of request buffer
- *  } else {
- *    request_buffer - pointer to scatterlist structure
- *  }
- *
- *  sense_buffer - sense command buffer
- *
- *  result (4 bytes of an int):
- *    Byte Meaning
- *    0 SCSI Status Byte Code
- *    1 SCSI One Byte Message Code
- *    2 Host Error Code
- *    3 Mid-Level Error Code
- *
- *  host driver fields:
- *    SCp - Scsi_Pointer used for command processing status
- *    scsi_done - used to save caller's done function
- *    host_scribble - used for pointer to another struct scsi_cmnd
- *
- * If this function returns ASC_NOERROR the request will be completed
- * from the interrupt handler.
- *
- * If this function returns ASC_ERROR the host error code has been set,
- * and the called must call asc_scsi_done.
+ * asc_prt_adv_dvc_var()
  *
- * If ASC_BUSY is returned the request will be returned to the midlayer
- * and re-tried later.
+ * Display an ADV_DVC_VAR structure.
  */
-static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
+static void asc_prt_adv_dvc_var(ADV_DVC_VAR *h)
 {
-	asc_board_t *boardp;
-	ASC_DVC_VAR *asc_dvc_varp;
-	ADV_DVC_VAR *adv_dvc_varp;
-	ADV_SCSI_REQ_Q *adv_scsiqp;
-	struct scsi_device *device;
-	int ret;
-
-	ASC_DBG2(1, "asc_execute_scsi_cmnd: scp 0x%lx, done 0x%lx\n",
-		 (ulong)scp, (ulong)scp->scsi_done);
-
-	boardp = ASC_BOARDP(scp->device->host);
-	device = boardp->device[scp->device->id];
+	printk(" ADV_DVC_VAR at addr 0x%lx\n", (ulong)h);
 
-	if (ASC_NARROW_BOARD(boardp)) {
-		/*
-		 * Build and execute Narrow Board request.
-		 */
+	printk("  iop_base 0x%lx, err_code 0x%x, ultra_able 0x%x\n",
+	       (ulong)h->iop_base, h->err_code, (unsigned)h->ultra_able);
 
-		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
+	printk("  isr_callback 0x%lx, sdtr_able 0x%x, wdtr_able 0x%x\n",
+	       (ulong)h->isr_callback, (unsigned)h->sdtr_able,
+	       (unsigned)h->wdtr_able);
 
-		/*
-		 * Build Asc Library request structure using the
-		 * global structures 'asc_scsi_req' and 'asc_sg_head'.
-		 *
-		 * If an error is returned, then the request has been
-		 * queued on the board done queue. It will be completed
-		 * by the caller.
-		 *
-		 * asc_build_req() can not return ASC_BUSY.
-		 */
-		if (asc_build_req(boardp, scp) == ASC_ERROR) {
-			ASC_STATS(scp->device->host, build_error);
-			return ASC_ERROR;
-		}
+	printk("  start_motor 0x%x, scsi_reset_wait 0x%x, irq_no 0x%x,\n",
+	       (unsigned)h->start_motor,
+	       (unsigned)h->scsi_reset_wait, (unsigned)h->irq_no);
 
-		switch (ret = AscExeScsiQueue(asc_dvc_varp, &asc_scsi_q)) {
-		case ASC_NOERROR:
-			ASC_STATS(scp->device->host, exe_noerror);
-			/*
-			 * Increment monotonically increasing per device
-			 * successful request counter. Wrapping doesn't matter.
-			 */
-			boardp->reqcnt[scp->device->id]++;
-			ASC_DBG(1, "asc_execute_scsi_cmnd: AscExeScsiQueue(), "
-				"ASC_NOERROR\n");
-			break;
-		case ASC_BUSY:
-			ASC_STATS(scp->device->host, exe_busy);
-			break;
-		case ASC_ERROR:
-			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
-				"AscExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
-				boardp->id, asc_dvc_varp->err_code);
-			ASC_STATS(scp->device->host, exe_error);
-			scp->result = HOST_BYTE(DID_ERROR);
-			break;
-		default:
-			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
-				"AscExeScsiQueue() unknown, err_code 0x%x\n",
-				boardp->id, asc_dvc_varp->err_code);
-			ASC_STATS(scp->device->host, exe_unknown);
-			scp->result = HOST_BYTE(DID_ERROR);
-			break;
-		}
-	} else {
-		/*
-		 * Build and execute Wide Board request.
-		 */
-		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
+	printk("  max_host_qng %u, max_dvc_qng %u, carr_freelist 0x%lxn\n",
+	       (unsigned)h->max_host_qng, (unsigned)h->max_dvc_qng,
+	       (ulong)h->carr_freelist);
 
-		/*
-		 * Build and get a pointer to an Adv Library request structure.
-		 *
-		 * If the request is successfully built then send it below,
-		 * otherwise return with an error.
-		 */
-		switch (adv_build_req(boardp, scp, &adv_scsiqp)) {
-		case ASC_NOERROR:
-			ASC_DBG(3, "asc_execute_scsi_cmnd: adv_build_req "
-				"ASC_NOERROR\n");
-			break;
-		case ASC_BUSY:
-			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
-				"ASC_BUSY\n");
-			/*
-			 * The asc_stats fields 'adv_build_noreq' and
-			 * 'adv_build_nosg' count wide board busy conditions.
-			 * They are updated in adv_build_req and
-			 * adv_get_sglist, respectively.
-			 */
-			return ASC_BUSY;
-		case ASC_ERROR:
-		default:
-			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
-				"ASC_ERROR\n");
-			ASC_STATS(scp->device->host, build_error);
-			return ASC_ERROR;
-		}
+	printk("  icq_sp 0x%lx, irq_sp 0x%lx\n",
+	       (ulong)h->icq_sp, (ulong)h->irq_sp);
 
-		switch (ret = AdvExeScsiQueue(adv_dvc_varp, adv_scsiqp)) {
-		case ASC_NOERROR:
-			ASC_STATS(scp->device->host, exe_noerror);
-			/*
-			 * Increment monotonically increasing per device
-			 * successful request counter. Wrapping doesn't matter.
-			 */
-			boardp->reqcnt[scp->device->id]++;
-			ASC_DBG(1, "asc_execute_scsi_cmnd: AdvExeScsiQueue(), "
-				"ASC_NOERROR\n");
-			break;
-		case ASC_BUSY:
-			ASC_STATS(scp->device->host, exe_busy);
-			break;
-		case ASC_ERROR:
-			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
-				"AdvExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
-				boardp->id, adv_dvc_varp->err_code);
-			ASC_STATS(scp->device->host, exe_error);
-			scp->result = HOST_BYTE(DID_ERROR);
-			break;
-		default:
-			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
-				"AdvExeScsiQueue() unknown, err_code 0x%x\n",
-				boardp->id, adv_dvc_varp->err_code);
-			ASC_STATS(scp->device->host, exe_unknown);
-			scp->result = HOST_BYTE(DID_ERROR);
-			break;
-		}
-	}
+	printk("  no_scam 0x%x, tagqng_able 0x%x\n",
+	       (unsigned)h->no_scam, (unsigned)h->tagqng_able);
 
-	ASC_DBG(1, "asc_execute_scsi_cmnd: end\n");
-	return ret;
+	printk("  chip_scsi_id 0x%x, cfg 0x%lx\n",
+	       (unsigned)h->chip_scsi_id, (ulong)h->cfg);
 }
 
 /*
- * Build a request structure for the Asc Library (Narrow Board).
- *
- * The global structures 'asc_scsi_q' and 'asc_sg_head' are
- * used to build the request.
+ * asc_prt_adv_dvc_cfg()
  *
- * If an error occurs, then return ASC_ERROR.
+ * Display an ADV_DVC_CFG structure.
  */
-static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
+static void asc_prt_adv_dvc_cfg(ADV_DVC_CFG *h)
 {
-	/*
-	 * Mutually exclusive access is required to 'asc_scsi_q' and
-	 * 'asc_sg_head' until after the request is started.
-	 */
-	memset(&asc_scsi_q, 0, sizeof(ASC_SCSI_Q));
-
-	/*
-	 * Point the ASC_SCSI_Q to the 'struct scsi_cmnd'.
-	 */
-	asc_scsi_q.q2.srb_ptr = ASC_VADDR_TO_U32(scp);
-
-	/*
-	 * Build the ASC_SCSI_Q request.
-	 */
-	asc_scsi_q.cdbptr = &scp->cmnd[0];
-	asc_scsi_q.q2.cdb_len = scp->cmd_len;
-	asc_scsi_q.q1.target_id = ASC_TID_TO_TARGET_ID(scp->device->id);
-	asc_scsi_q.q1.target_lun = scp->device->lun;
-	asc_scsi_q.q2.target_ix =
-	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
-	asc_scsi_q.q1.sense_addr =
-	    cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
-	asc_scsi_q.q1.sense_len = sizeof(scp->sense_buffer);
-
-	/*
-	 * If there are any outstanding requests for the current target,
-	 * then every 255th request send an ORDERED request. This heuristic
-	 * tries to retain the benefit of request sorting while preventing
-	 * request starvation. 255 is the max number of tags or pending commands
-	 * a device may have outstanding.
-	 *
-	 * The request count is incremented below for every successfully
-	 * started request.
-	 *
-	 */
-	if ((boardp->dvc_var.asc_dvc_var.cur_dvc_qng[scp->device->id] > 0) &&
-	    (boardp->reqcnt[scp->device->id] % 255) == 0) {
-		asc_scsi_q.q2.tag_code = MSG_ORDERED_TAG;
-	} else {
-		asc_scsi_q.q2.tag_code = MSG_SIMPLE_TAG;
-	}
-
-	/*
-	 * Build ASC_SCSI_Q for a contiguous buffer or a scatter-gather
-	 * buffer command.
-	 */
-	if (scp->use_sg == 0) {
-		/*
-		 * CDB request of single contiguous buffer.
-		 */
-		ASC_STATS(scp->device->host, cont_cnt);
-		scp->SCp.dma_handle = scp->request_bufflen ?
-		    dma_map_single(boardp->dev, scp->request_buffer,
-				   scp->request_bufflen,
-				   scp->sc_data_direction) : 0;
-		asc_scsi_q.q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
-		asc_scsi_q.q1.data_cnt = cpu_to_le32(scp->request_bufflen);
-		ASC_STATS_ADD(scp->device->host, cont_xfer,
-			      ASC_CEILING(scp->request_bufflen, 512));
-		asc_scsi_q.q1.sg_queue_cnt = 0;
-		asc_scsi_q.sg_head = NULL;
-	} else {
-		/*
-		 * CDB scatter-gather request list.
-		 */
-		int sgcnt;
-		int use_sg;
-		struct scatterlist *slp;
-
-		slp = (struct scatterlist *)scp->request_buffer;
-		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
-				    scp->sc_data_direction);
-
-		if (use_sg > scp->device->host->sg_tablesize) {
-			ASC_PRINT3("asc_build_req: board %d: use_sg %d > "
-				   "sg_tablesize %d\n", boardp->id, use_sg,
-				   scp->device->host->sg_tablesize);
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
-			scp->result = HOST_BYTE(DID_ERROR);
-			return ASC_ERROR;
-		}
-
-		ASC_STATS(scp->device->host, sg_cnt);
-
-		/*
-		 * Use global ASC_SG_HEAD structure and set the ASC_SCSI_Q
-		 * structure to point to it.
-		 */
-		memset(&asc_sg_head, 0, sizeof(ASC_SG_HEAD));
+	printk(" ADV_DVC_CFG at addr 0x%lx\n", (ulong)h);
 
-		asc_scsi_q.q1.cntl |= QC_SG_HEAD;
-		asc_scsi_q.sg_head = &asc_sg_head;
-		asc_scsi_q.q1.data_cnt = 0;
-		asc_scsi_q.q1.data_addr = 0;
-		/* This is a byte value, otherwise it would need to be swapped. */
-		asc_sg_head.entry_cnt = asc_scsi_q.q1.sg_queue_cnt = use_sg;
-		ASC_STATS_ADD(scp->device->host, sg_elem,
-			      asc_sg_head.entry_cnt);
+	printk("  disc_enable 0x%x, termination 0x%x\n",
+	       h->disc_enable, h->termination);
 
-		/*
-		 * Convert scatter-gather list into ASC_SG_HEAD list.
-		 */
-		for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
-			asc_sg_head.sg_list[sgcnt].addr =
-			    cpu_to_le32(sg_dma_address(slp));
-			asc_sg_head.sg_list[sgcnt].bytes =
-			    cpu_to_le32(sg_dma_len(slp));
-			ASC_STATS_ADD(scp->device->host, sg_xfer,
-				      ASC_CEILING(sg_dma_len(slp), 512));
-		}
-	}
+	printk("  chip_version 0x%x, mcode_date 0x%x\n",
+	       h->chip_version, h->mcode_date);
 
-	ASC_DBG_PRT_ASC_SCSI_Q(2, &asc_scsi_q);
-	ASC_DBG_PRT_CDB(1, scp->cmnd, scp->cmd_len);
+	printk("  mcode_version 0x%x, pci_device_id 0x%x, lib_version %u\n",
+	       h->mcode_version, to_pci_dev(h->dev)->device, h->lib_version);
 
-	return ASC_NOERROR;
+	printk("  control_flag 0x%x\n", h->control_flag);
 }
 
 /*
- * Build a request structure for the Adv Library (Wide Board).
- *
- * If an adv_req_t can not be allocated to issue the request,
- * then return ASC_BUSY. If an error occurs, then return ASC_ERROR.
+ * asc_prt_adv_scsi_req_q()
  *
- * Multi-byte fields in the ASC_SCSI_REQ_Q that are used by the
- * microcode for DMA addresses or math operations are byte swapped
- * to little-endian order.
+ * Display an ADV_SCSI_REQ_Q structure.
  */
-static int
-adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
-	      ADV_SCSI_REQ_Q **adv_scsiqpp)
+static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
 {
-	adv_req_t *reqp;
-	ADV_SCSI_REQ_Q *scsiqp;
-	int i;
-	int ret;
-
-	/*
-	 * Allocate an adv_req_t structure from the board to execute
-	 * the command.
-	 */
-	if (boardp->adv_reqp == NULL) {
-		ASC_DBG(1, "adv_build_req: no free adv_req_t\n");
-		ASC_STATS(scp->device->host, adv_build_noreq);
-		return ASC_BUSY;
-	} else {
-		reqp = boardp->adv_reqp;
-		boardp->adv_reqp = reqp->next_reqp;
-		reqp->next_reqp = NULL;
-	}
-
-	/*
-	 * Get 32-byte aligned ADV_SCSI_REQ_Q and ADV_SG_BLOCK pointers.
-	 */
-	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
-
-	/*
-	 * Initialize the structure.
-	 */
-	scsiqp->cntl = scsiqp->scsi_cntl = scsiqp->done_status = 0;
-
-	/*
-	 * Set the ADV_SCSI_REQ_Q 'srb_ptr' to point to the adv_req_t structure.
-	 */
-	scsiqp->srb_ptr = ASC_VADDR_TO_U32(reqp);
-
-	/*
-	 * Set the adv_req_t 'cmndp' to point to the struct scsi_cmnd structure.
-	 */
-	reqp->cmndp = scp;
-
-	/*
-	 * Build the ADV_SCSI_REQ_Q request.
-	 */
-
-	/* Set CDB length and copy it to the request structure.  */
-	scsiqp->cdb_len = scp->cmd_len;
-	/* Copy first 12 CDB bytes to cdb[]. */
-	for (i = 0; i < scp->cmd_len && i < 12; i++) {
-		scsiqp->cdb[i] = scp->cmnd[i];
-	}
-	/* Copy last 4 CDB bytes, if present, to cdb16[]. */
-	for (; i < scp->cmd_len; i++) {
-		scsiqp->cdb16[i - 12] = scp->cmnd[i];
-	}
-
-	scsiqp->target_id = scp->device->id;
-	scsiqp->target_lun = scp->device->lun;
-
-	scsiqp->sense_addr = cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
-	scsiqp->sense_len = sizeof(scp->sense_buffer);
+	int sg_blk_cnt;
+	struct asc_sg_block *sg_ptr;
 
-	/*
-	 * Build ADV_SCSI_REQ_Q for a contiguous buffer or a scatter-gather
-	 * buffer command.
-	 */
+	printk("ADV_SCSI_REQ_Q at addr 0x%lx\n", (ulong)q);
 
-	scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
-	scsiqp->vdata_addr = scp->request_buffer;
-	scsiqp->data_addr = cpu_to_le32(virt_to_bus(scp->request_buffer));
+	printk("  target_id %u, target_lun %u, srb_ptr 0x%lx, a_flag 0x%x\n",
+	       q->target_id, q->target_lun, (ulong)q->srb_ptr, q->a_flag);
 
-	if (scp->use_sg == 0) {
-		/*
-		 * CDB request of single contiguous buffer.
-		 */
-		reqp->sgblkp = NULL;
-		scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
-		if (scp->request_bufflen) {
-			scsiqp->vdata_addr = scp->request_buffer;
-			scp->SCp.dma_handle =
-			    dma_map_single(boardp->dev, scp->request_buffer,
-					   scp->request_bufflen,
-					   scp->sc_data_direction);
-		} else {
-			scsiqp->vdata_addr = NULL;
-			scp->SCp.dma_handle = 0;
-		}
-		scsiqp->data_addr = cpu_to_le32(scp->SCp.dma_handle);
-		scsiqp->sg_list_ptr = NULL;
-		scsiqp->sg_real_addr = 0;
-		ASC_STATS(scp->device->host, cont_cnt);
-		ASC_STATS_ADD(scp->device->host, cont_xfer,
-			      ASC_CEILING(scp->request_bufflen, 512));
-	} else {
-		/*
-		 * CDB scatter-gather request list.
-		 */
-		struct scatterlist *slp;
-		int use_sg;
+	printk("  cntl 0x%x, data_addr 0x%lx, vdata_addr 0x%lx\n",
+	       q->cntl, (ulong)le32_to_cpu(q->data_addr), (ulong)q->vdata_addr);
 
-		slp = (struct scatterlist *)scp->request_buffer;
-		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
-				    scp->sc_data_direction);
+	printk("  data_cnt %lu, sense_addr 0x%lx, sense_len %u,\n",
+	       (ulong)le32_to_cpu(q->data_cnt),
+	       (ulong)le32_to_cpu(q->sense_addr), q->sense_len);
 
-		if (use_sg > ADV_MAX_SG_LIST) {
-			ASC_PRINT3("adv_build_req: board %d: use_sg %d > "
-				   "ADV_MAX_SG_LIST %d\n", boardp->id, use_sg,
-				   scp->device->host->sg_tablesize);
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
-			scp->result = HOST_BYTE(DID_ERROR);
+	printk
+	    ("  cdb_len %u, done_status 0x%x, host_status 0x%x, scsi_status 0x%x\n",
+	     q->cdb_len, q->done_status, q->host_status, q->scsi_status);
 
-			/*
-			 * Free the 'adv_req_t' structure by adding it back
-			 * to the board free list.
-			 */
-			reqp->next_reqp = boardp->adv_reqp;
-			boardp->adv_reqp = reqp;
+	printk("  sg_working_ix 0x%x, target_cmd %u\n",
+	       q->sg_working_ix, q->target_cmd);
 
-			return ASC_ERROR;
-		}
+	printk("  scsiq_rptr 0x%lx, sg_real_addr 0x%lx, sg_list_ptr 0x%lx\n",
+	       (ulong)le32_to_cpu(q->scsiq_rptr),
+	       (ulong)le32_to_cpu(q->sg_real_addr), (ulong)q->sg_list_ptr);
 
-		ret = adv_get_sglist(boardp, reqp, scp, use_sg);
-		if (ret != ADV_SUCCESS) {
+	/* Display the request's ADV_SG_BLOCK structures. */
+	if (q->sg_list_ptr != NULL) {
+		sg_blk_cnt = 0;
+		while (1) {
 			/*
-			 * Free the adv_req_t structure by adding it back to
-			 * the board free list.
+			 * 'sg_ptr' is a physical address. Convert it to a virtual
+			 * address by indexing 'sg_blk_cnt' into the virtual address
+			 * array 'sg_list_ptr'.
+			 *
+			 * XXX - Assumes all SG physical blocks are virtually contiguous.
 			 */
-			reqp->next_reqp = boardp->adv_reqp;
-			boardp->adv_reqp = reqp;
-
-			return ret;
+			sg_ptr =
+			    &(((ADV_SG_BLOCK *)(q->sg_list_ptr))[sg_blk_cnt]);
+			asc_prt_adv_sgblock(sg_blk_cnt, sg_ptr);
+			if (sg_ptr->sg_ptr == 0) {
+				break;
+			}
+			sg_blk_cnt++;
 		}
-
-		ASC_STATS(scp->device->host, sg_cnt);
-		ASC_STATS_ADD(scp->device->host, sg_elem, use_sg);
 	}
-
-	ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
-	ASC_DBG_PRT_CDB(1, scp->cmnd, scp->cmd_len);
-
-	*adv_scsiqpp = scsiqp;
-
-	return ASC_NOERROR;
 }
 
 /*
- * Build scatter-gather list for Adv Library (Wide Board).
- *
- * Additional ADV_SG_BLOCK structures will need to be allocated
- * if the total number of scatter-gather elements exceeds
- * NO_OF_SG_PER_BLOCK (15). The ADV_SG_BLOCK structures are
- * assumed to be physically contiguous.
+ * asc_prt_adv_sgblock()
  *
- * Return:
- *      ADV_SUCCESS(1) - SG List successfully created
- *      ADV_ERROR(-1) - SG List creation failed
+ * Display an ADV_SG_BLOCK structure.
  */
-static int
-adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
-	       int use_sg)
+static void asc_prt_adv_sgblock(int sgblockno, ADV_SG_BLOCK *b)
 {
-	adv_sgblk_t *sgblkp;
-	ADV_SCSI_REQ_Q *scsiqp;
-	struct scatterlist *slp;
-	int sg_elem_cnt;
-	ADV_SG_BLOCK *sg_block, *prev_sg_block;
-	ADV_PADDR sg_block_paddr;
 	int i;
 
-	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
-	slp = (struct scatterlist *)scp->request_buffer;
-	sg_elem_cnt = use_sg;
-	prev_sg_block = NULL;
-	reqp->sgblkp = NULL;
-
-	for (;;) {
-		/*
-		 * Allocate a 'adv_sgblk_t' structure from the board free
-		 * list. One 'adv_sgblk_t' structure holds NO_OF_SG_PER_BLOCK
-		 * (15) scatter-gather elements.
-		 */
-		if ((sgblkp = boardp->adv_sgblkp) == NULL) {
-			ASC_DBG(1, "adv_get_sglist: no free adv_sgblk_t\n");
-			ASC_STATS(scp->device->host, adv_build_nosg);
-
-			/*
-			 * Allocation failed. Free 'adv_sgblk_t' structures
-			 * already allocated for the request.
-			 */
-			while ((sgblkp = reqp->sgblkp) != NULL) {
-				/* Remove 'sgblkp' from the request list. */
-				reqp->sgblkp = sgblkp->next_sgblkp;
-
-				/* Add 'sgblkp' to the board free list. */
-				sgblkp->next_sgblkp = boardp->adv_sgblkp;
-				boardp->adv_sgblkp = sgblkp;
-			}
-			return ASC_BUSY;
-		}
-
-		/* Complete 'adv_sgblk_t' board allocation. */
-		boardp->adv_sgblkp = sgblkp->next_sgblkp;
-		sgblkp->next_sgblkp = NULL;
-
-		/*
-		 * Get 8 byte aligned virtual and physical addresses
-		 * for the allocated ADV_SG_BLOCK structure.
-		 */
-		sg_block = (ADV_SG_BLOCK *)ADV_8BALIGN(&sgblkp->sg_block);
-		sg_block_paddr = virt_to_bus(sg_block);
-
-		/*
-		 * Check if this is the first 'adv_sgblk_t' for the
-		 * request.
-		 */
-		if (reqp->sgblkp == NULL) {
-			/* Request's first scatter-gather block. */
-			reqp->sgblkp = sgblkp;
-
-			/*
-			 * Set ADV_SCSI_REQ_T ADV_SG_BLOCK virtual and physical
-			 * address pointers.
-			 */
-			scsiqp->sg_list_ptr = sg_block;
-			scsiqp->sg_real_addr = cpu_to_le32(sg_block_paddr);
-		} else {
-			/* Request's second or later scatter-gather block. */
-			sgblkp->next_sgblkp = reqp->sgblkp;
-			reqp->sgblkp = sgblkp;
-
-			/*
-			 * Point the previous ADV_SG_BLOCK structure to
-			 * the newly allocated ADV_SG_BLOCK structure.
-			 */
-			prev_sg_block->sg_ptr = cpu_to_le32(sg_block_paddr);
-		}
-
-		for (i = 0; i < NO_OF_SG_PER_BLOCK; i++) {
-			sg_block->sg_list[i].sg_addr =
-					cpu_to_le32(sg_dma_address(slp));
-			sg_block->sg_list[i].sg_count =
-					cpu_to_le32(sg_dma_len(slp));
-			ASC_STATS_ADD(scp->device->host, sg_xfer,
-				      ASC_CEILING(sg_dma_len(slp), 512));
-
-			if (--sg_elem_cnt == 0) {	/* Last ADV_SG_BLOCK and scatter-gather entry. */
-				sg_block->sg_cnt = i + 1;
-				sg_block->sg_ptr = 0L;	/* Last ADV_SG_BLOCK in list. */
-				return ADV_SUCCESS;
-			}
-			slp++;
-		}
-		sg_block->sg_cnt = NO_OF_SG_PER_BLOCK;
-		prev_sg_block = sg_block;
+	printk(" ASC_SG_BLOCK at addr 0x%lx (sgblockno %d)\n",
+	       (ulong)b, sgblockno);
+	printk("  sg_cnt %u, sg_ptr 0x%lx\n",
+	       b->sg_cnt, (ulong)le32_to_cpu(b->sg_ptr));
+	BUG_ON(b->sg_cnt > NO_OF_SG_PER_BLOCK);
+	if (b->sg_ptr != 0)
+		BUG_ON(b->sg_cnt != NO_OF_SG_PER_BLOCK);
+	for (i = 0; i < b->sg_cnt; i++) {
+		printk("  [%u]: sg_addr 0x%lx, sg_count 0x%lx\n",
+		       i, (ulong)b->sg_list[i].sg_addr,
+		       (ulong)b->sg_list[i].sg_count);
 	}
 }
 
 /*
- * asc_isr_callback() - Second Level Interrupt Handler called by AscISR().
+ * asc_prt_hex()
  *
- * Interrupt callback function for the Narrow SCSI Asc Library.
+ * Print hexadecimal output in 4 byte groupings 32 bytes
+ * or 8 double-words per line.
  */
-static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
+static void asc_prt_hex(char *f, uchar *s, int l)
 {
-	asc_board_t *boardp;
-	struct scsi_cmnd *scp;
-	struct Scsi_Host *shost;
-
-	ASC_DBG2(1, "asc_isr_callback: asc_dvc_varp 0x%lx, qdonep 0x%lx\n",
-		 (ulong)asc_dvc_varp, (ulong)qdonep);
-	ASC_DBG_PRT_ASC_QDONE_INFO(2, qdonep);
-
-	/*
-	 * Get the struct scsi_cmnd structure and Scsi_Host structure for the
-	 * command that has been completed.
-	 */
-	scp = (struct scsi_cmnd *)ASC_U32_TO_VADDR(qdonep->d2.srb_ptr);
-	ASC_DBG1(1, "asc_isr_callback: scp 0x%lx\n", (ulong)scp);
-
-	if (scp == NULL) {
-		ASC_PRINT("asc_isr_callback: scp is NULL\n");
-		return;
-	}
-	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
-
-	shost = scp->device->host;
-	ASC_STATS(shost, callback);
-	ASC_DBG1(1, "asc_isr_callback: shost 0x%lx\n", (ulong)shost);
+	int i;
+	int j;
+	int k;
+	int m;
 
-	boardp = ASC_BOARDP(shost);
-	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
+	printk("%s: (%d bytes)\n", f, l);
 
-	/*
-	 * 'qdonep' contains the command's ending status.
-	 */
-	switch (qdonep->d3.done_stat) {
-	case QD_NO_ERROR:
-		ASC_DBG(2, "asc_isr_callback: QD_NO_ERROR\n");
-		scp->result = 0;
+	for (i = 0; i < l; i += 32) {
 
-		/*
-		 * Check for an underrun condition.
-		 *
-		 * If there was no error and an underrun condition, then
-		 * return the number of underrun bytes.
-		 */
-		if (scp->request_bufflen != 0 && qdonep->remain_bytes != 0 &&
-		    qdonep->remain_bytes <= scp->request_bufflen) {
-			ASC_DBG1(1,
-				 "asc_isr_callback: underrun condition %u bytes\n",
-				 (unsigned)qdonep->remain_bytes);
-			scp->resid = qdonep->remain_bytes;
+		/* Display a maximum of 8 double-words per line. */
+		if ((k = (l - i) / 4) >= 8) {
+			k = 8;
+			m = 0;
+		} else {
+			m = (l - i) % 4;
 		}
-		break;
 
-	case QD_WITH_ERROR:
-		ASC_DBG(2, "asc_isr_callback: QD_WITH_ERROR\n");
-		switch (qdonep->d3.host_stat) {
-		case QHSTA_NO_ERROR:
-			if (qdonep->d3.scsi_stat == SAM_STAT_CHECK_CONDITION) {
-				ASC_DBG(2,
-					"asc_isr_callback: SAM_STAT_CHECK_CONDITION\n");
-				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
-						  sizeof(scp->sense_buffer));
-				/*
-				 * Note: The 'status_byte()' macro used by
-				 * target drivers defined in scsi.h shifts the
-				 * status byte returned by host drivers right
-				 * by 1 bit.  This is why target drivers also
-				 * use right shifted status byte definitions.
-				 * For instance target drivers use
-				 * CHECK_CONDITION, defined to 0x1, instead of
-				 * the SCSI defined check condition value of
-				 * 0x2. Host drivers are supposed to return
-				 * the status byte as it is defined by SCSI.
-				 */
-				scp->result = DRIVER_BYTE(DRIVER_SENSE) |
-				    STATUS_BYTE(qdonep->d3.scsi_stat);
-			} else {
-				scp->result = STATUS_BYTE(qdonep->d3.scsi_stat);
-			}
-			break;
+		for (j = 0; j < k; j++) {
+			printk(" %2.2X%2.2X%2.2X%2.2X",
+			       (unsigned)s[i + (j * 4)],
+			       (unsigned)s[i + (j * 4) + 1],
+			       (unsigned)s[i + (j * 4) + 2],
+			       (unsigned)s[i + (j * 4) + 3]);
+		}
 
+		switch (m) {
+		case 0:
 		default:
-			/* QHSTA error occurred */
-			ASC_DBG1(1, "asc_isr_callback: host_stat 0x%x\n",
-				 qdonep->d3.host_stat);
-			scp->result = HOST_BYTE(DID_BAD_TARGET);
+			break;
+		case 1:
+			printk(" %2.2X", (unsigned)s[i + (j * 4)]);
+			break;
+		case 2:
+			printk(" %2.2X%2.2X",
+			       (unsigned)s[i + (j * 4)],
+			       (unsigned)s[i + (j * 4) + 1]);
+			break;
+		case 3:
+			printk(" %2.2X%2.2X%2.2X",
+			       (unsigned)s[i + (j * 4) + 1],
+			       (unsigned)s[i + (j * 4) + 2],
+			       (unsigned)s[i + (j * 4) + 3]);
 			break;
 		}
-		break;
-
-	case QD_ABORTED_BY_HOST:
-		ASC_DBG(1, "asc_isr_callback: QD_ABORTED_BY_HOST\n");
-		scp->result =
-		    HOST_BYTE(DID_ABORT) | MSG_BYTE(qdonep->d3.
-						    scsi_msg) |
-		    STATUS_BYTE(qdonep->d3.scsi_stat);
-		break;
-
-	default:
-		ASC_DBG1(1, "asc_isr_callback: done_stat 0x%x\n",
-			 qdonep->d3.done_stat);
-		scp->result =
-		    HOST_BYTE(DID_ERROR) | MSG_BYTE(qdonep->d3.
-						    scsi_msg) |
-		    STATUS_BYTE(qdonep->d3.scsi_stat);
-		break;
-	}
 
-	/*
-	 * If the 'init_tidmask' bit isn't already set for the target and the
-	 * current request finished normally, then set the bit for the target
-	 * to indicate that a device is present.
-	 */
-	if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scp->device->id)) == 0 &&
-	    qdonep->d3.done_stat == QD_NO_ERROR &&
-	    qdonep->d3.host_stat == QHSTA_NO_ERROR) {
-		boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
+		printk("\n");
 	}
-
-	asc_scsi_done(scp);
-
-	return;
 }
+#endif /* ADVANSYS_DEBUG */
 
 /*
- * adv_isr_callback() - Second Level Interrupt Handler called by AdvISR().
+ * advansys_info()
  *
- * Callback function for the Wide SCSI Adv Library.
+ * Return suitable for printing on the console with the argument
+ * adapter's configuration information.
+ *
+ * Note: The information line should not exceed ASC_INFO_SIZE bytes,
+ * otherwise the static 'info' array will be overrun.
  */
-static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
+static const char *advansys_info(struct Scsi_Host *shost)
 {
+	static char info[ASC_INFO_SIZE];
 	asc_board_t *boardp;
-	adv_req_t *reqp;
-	adv_sgblk_t *sgblkp;
-	struct scsi_cmnd *scp;
-	struct Scsi_Host *shost;
-	ADV_DCNT resid_cnt;
-
-	ASC_DBG2(1, "adv_isr_callback: adv_dvc_varp 0x%lx, scsiqp 0x%lx\n",
-		 (ulong)adv_dvc_varp, (ulong)scsiqp);
-	ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
-
-	/*
-	 * Get the adv_req_t structure for the command that has been
-	 * completed. The adv_req_t structure actually contains the
-	 * completed ADV_SCSI_REQ_Q structure.
-	 */
-	reqp = (adv_req_t *)ADV_U32_TO_VADDR(scsiqp->srb_ptr);
-	ASC_DBG1(1, "adv_isr_callback: reqp 0x%lx\n", (ulong)reqp);
-	if (reqp == NULL) {
-		ASC_PRINT("adv_isr_callback: reqp is NULL\n");
-		return;
-	}
-
-	/*
-	 * Get the struct scsi_cmnd structure and Scsi_Host structure for the
-	 * command that has been completed.
-	 *
-	 * Note: The adv_req_t request structure and adv_sgblk_t structure,
-	 * if any, are dropped, because a board structure pointer can not be
-	 * determined.
-	 */
-	scp = reqp->cmndp;
-	ASC_DBG1(1, "adv_isr_callback: scp 0x%lx\n", (ulong)scp);
-	if (scp == NULL) {
-		ASC_PRINT
-		    ("adv_isr_callback: scp is NULL; adv_req_t dropped.\n");
-		return;
-	}
-	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
-
-	shost = scp->device->host;
-	ASC_STATS(shost, callback);
-	ASC_DBG1(1, "adv_isr_callback: shost 0x%lx\n", (ulong)shost);
+	ASC_DVC_VAR *asc_dvc_varp;
+	ADV_DVC_VAR *adv_dvc_varp;
+	char *busname;
+	char *widename = NULL;
 
 	boardp = ASC_BOARDP(shost);
-	BUG_ON(adv_dvc_varp != &boardp->dvc_var.adv_dvc_var);
-
-	/*
-	 * 'done_status' contains the command's ending status.
-	 */
-	switch (scsiqp->done_status) {
-	case QD_NO_ERROR:
-		ASC_DBG(2, "adv_isr_callback: QD_NO_ERROR\n");
-		scp->result = 0;
-
+	if (ASC_NARROW_BOARD(boardp)) {
+		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
+		ASC_DBG(1, "advansys_info: begin\n");
+		if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
+			if ((asc_dvc_varp->bus_type & ASC_IS_ISAPNP) ==
+			    ASC_IS_ISAPNP) {
+				busname = "ISA PnP";
+			} else {
+				busname = "ISA";
+			}
+			sprintf(info,
+				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X, DMA 0x%X",
+				ASC_VERSION, busname,
+				(ulong)shost->io_port,
+				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
+				shost->irq, shost->dma_channel);
+		} else {
+			if (asc_dvc_varp->bus_type & ASC_IS_VL) {
+				busname = "VL";
+			} else if (asc_dvc_varp->bus_type & ASC_IS_EISA) {
+				busname = "EISA";
+			} else if (asc_dvc_varp->bus_type & ASC_IS_PCI) {
+				if ((asc_dvc_varp->bus_type & ASC_IS_PCI_ULTRA)
+				    == ASC_IS_PCI_ULTRA) {
+					busname = "PCI Ultra";
+				} else {
+					busname = "PCI";
+				}
+			} else {
+				busname = "?";
+				ASC_PRINT2("advansys_info: board %d: unknown "
+					   "bus type %d\n", boardp->id,
+					   asc_dvc_varp->bus_type);
+			}
+			sprintf(info,
+				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X",
+				ASC_VERSION, busname, (ulong)shost->io_port,
+				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
+				shost->irq);
+		}
+	} else {
 		/*
-		 * Check for an underrun condition.
+		 * Wide Adapter Information
 		 *
-		 * If there was no error and an underrun condition, then
-		 * then return the number of underrun bytes.
+		 * Memory-mapped I/O is used instead of I/O space to access
+		 * the adapter, but display the I/O Port range. The Memory
+		 * I/O address is displayed through the driver /proc file.
 		 */
-		resid_cnt = le32_to_cpu(scsiqp->data_cnt);
-		if (scp->request_bufflen != 0 && resid_cnt != 0 &&
-		    resid_cnt <= scp->request_bufflen) {
-			ASC_DBG1(1,
-				 "adv_isr_callback: underrun condition %lu bytes\n",
-				 (ulong)resid_cnt);
-			scp->resid = resid_cnt;
-		}
-		break;
-
-	case QD_WITH_ERROR:
-		ASC_DBG(2, "adv_isr_callback: QD_WITH_ERROR\n");
-		switch (scsiqp->host_status) {
-		case QHSTA_NO_ERROR:
-			if (scsiqp->scsi_status == SAM_STAT_CHECK_CONDITION) {
-				ASC_DBG(2,
-					"adv_isr_callback: SAM_STAT_CHECK_CONDITION\n");
-				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
-						  sizeof(scp->sense_buffer));
-				/*
-				 * Note: The 'status_byte()' macro used by
-				 * target drivers defined in scsi.h shifts the
-				 * status byte returned by host drivers right
-				 * by 1 bit.  This is why target drivers also
-				 * use right shifted status byte definitions.
-				 * For instance target drivers use
-				 * CHECK_CONDITION, defined to 0x1, instead of
-				 * the SCSI defined check condition value of
-				 * 0x2. Host drivers are supposed to return
-				 * the status byte as it is defined by SCSI.
-				 */
-				scp->result = DRIVER_BYTE(DRIVER_SENSE) |
-				    STATUS_BYTE(scsiqp->scsi_status);
-			} else {
-				scp->result = STATUS_BYTE(scsiqp->scsi_status);
-			}
-			break;
-
-		default:
-			/* Some other QHSTA error occurred. */
-			ASC_DBG1(1, "adv_isr_callback: host_status 0x%x\n",
-				 scsiqp->host_status);
-			scp->result = HOST_BYTE(DID_BAD_TARGET);
-			break;
+		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
+		if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
+			widename = "Ultra-Wide";
+		} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
+			widename = "Ultra2-Wide";
+		} else {
+			widename = "Ultra3-Wide";
 		}
-		break;
-
-	case QD_ABORTED_BY_HOST:
-		ASC_DBG(1, "adv_isr_callback: QD_ABORTED_BY_HOST\n");
-		scp->result =
-		    HOST_BYTE(DID_ABORT) | STATUS_BYTE(scsiqp->scsi_status);
-		break;
-
-	default:
-		ASC_DBG1(1, "adv_isr_callback: done_status 0x%x\n",
-			 scsiqp->done_status);
-		scp->result =
-		    HOST_BYTE(DID_ERROR) | STATUS_BYTE(scsiqp->scsi_status);
-		break;
-	}
-
-	/*
-	 * If the 'init_tidmask' bit isn't already set for the target and the
-	 * current request finished normally, then set the bit for the target
-	 * to indicate that a device is present.
-	 */
-	if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scp->device->id)) == 0 &&
-	    scsiqp->done_status == QD_NO_ERROR &&
-	    scsiqp->host_status == QHSTA_NO_ERROR) {
-		boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
-	}
-
-	asc_scsi_done(scp);
-
-	/*
-	 * Free all 'adv_sgblk_t' structures allocated for the request.
-	 */
-	while ((sgblkp = reqp->sgblkp) != NULL) {
-		/* Remove 'sgblkp' from the request list. */
-		reqp->sgblkp = sgblkp->next_sgblkp;
-
-		/* Add 'sgblkp' to the board free list. */
-		sgblkp->next_sgblkp = boardp->adv_sgblkp;
-		boardp->adv_sgblkp = sgblkp;
+		sprintf(info,
+			"AdvanSys SCSI %s: PCI %s: PCIMEM 0x%lX-0x%lX, IRQ 0x%X",
+			ASC_VERSION, widename, (ulong)adv_dvc_varp->iop_base,
+			(ulong)adv_dvc_varp->iop_base + boardp->asc_n_io_port - 1, shost->irq);
 	}
-
-	/*
-	 * Free the adv_req_t structure used with the command by adding
-	 * it back to the board free list.
-	 */
-	reqp->next_reqp = boardp->adv_reqp;
-	boardp->adv_reqp = reqp;
-
-	ASC_DBG(1, "adv_isr_callback: done\n");
-
-	return;
+	BUG_ON(strlen(info) >= ASC_INFO_SIZE);
+	ASC_DBG(1, "advansys_info: end\n");
+	return info;
 }
 
+#ifdef CONFIG_PROC_FS
 /*
- * adv_async_callback() - Adv Library asynchronous event callback function.
+ * asc_prt_line()
+ *
+ * If 'cp' is NULL print to the console, otherwise print to a buffer.
+ *
+ * Return 0 if printing to the console, otherwise return the number of
+ * bytes written to the buffer.
+ *
+ * Note: If any single line is greater than ASC_PRTLINE_SIZE bytes the stack
+ * will be corrupted. 's[]' is defined to be ASC_PRTLINE_SIZE bytes.
  */
-static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
+static int asc_prt_line(char *buf, int buflen, char *fmt, ...)
 {
-	switch (code) {
-	case ADV_ASYNC_SCSI_BUS_RESET_DET:
-		/*
-		 * The firmware detected a SCSI Bus reset.
-		 */
-		ASC_DBG(0,
-			"adv_async_callback: ADV_ASYNC_SCSI_BUS_RESET_DET\n");
-		break;
-
-	case ADV_ASYNC_RDMA_FAILURE:
-		/*
-		 * Handle RDMA failure by resetting the SCSI Bus and
-		 * possibly the chip if it is unresponsive. Log the error
-		 * with a unique code.
-		 */
-		ASC_DBG(0, "adv_async_callback: ADV_ASYNC_RDMA_FAILURE\n");
-		AdvResetChipAndSB(adv_dvc_varp);
-		break;
-
-	case ADV_HOST_SCSI_BUS_RESET:
-		/*
-		 * Host generated SCSI bus reset occurred.
-		 */
-		ASC_DBG(0, "adv_async_callback: ADV_HOST_SCSI_BUS_RESET\n");
-		break;
+	va_list args;
+	int ret;
+	char s[ASC_PRTLINE_SIZE];
 
-	default:
-		ASC_DBG1(0, "DvcAsyncCallBack: unknown code 0x%x\n", code);
-		break;
+	va_start(args, fmt);
+	ret = vsprintf(s, fmt, args);
+	BUG_ON(ret >= ASC_PRTLINE_SIZE);
+	if (buf == NULL) {
+		(void)printk(s);
+		ret = 0;
+	} else {
+		ret = min(buflen, ret);
+		memcpy(buf, s, ret);
 	}
+	va_end(args);
+	return ret;
 }
 
-#ifdef CONFIG_PROC_FS
 /*
  * asc_prt_board_devices()
  *
@@ -5548,159 +4212,7 @@ asc_proc_copy(off_t advoffset, off_t offset, char *curbuf, int leftlen,
 	return cnt;
 }
 
-/*
- * asc_prt_line()
- *
- * If 'cp' is NULL print to the console, otherwise print to a buffer.
- *
- * Return 0 if printing to the console, otherwise return the number of
- * bytes written to the buffer.
- *
- * Note: If any single line is greater than ASC_PRTLINE_SIZE bytes the stack
- * will be corrupted. 's[]' is defined to be ASC_PRTLINE_SIZE bytes.
- */
-static int asc_prt_line(char *buf, int buflen, char *fmt, ...)
-{
-	va_list args;
-	int ret;
-	char s[ASC_PRTLINE_SIZE];
-
-	va_start(args, fmt);
-	ret = vsprintf(s, fmt, args);
-	BUG_ON(ret >= ASC_PRTLINE_SIZE);
-	if (buf == NULL) {
-		(void)printk(s);
-		ret = 0;
-	} else {
-		ret = min(buflen, ret);
-		memcpy(buf, s, ret);
-	}
-	va_end(args);
-	return ret;
-}
-#endif /* CONFIG_PROC_FS */
-
-/*
- * void
- * DvcPutScsiQ(PortAddr iop_base, ushort s_addr, uchar *outbuf, int words)
- *
- * Calling/Exit State:
- *    none
- *
- * Description:
- *     Output an ASC_SCSI_Q structure to the chip
- */
-static void
-DvcPutScsiQ(PortAddr iop_base, ushort s_addr, uchar *outbuf, int words)
-{
-	int i;
-
-	ASC_DBG_PRT_HEX(2, "DvcPutScsiQ", outbuf, 2 * words);
-	AscSetChipLramAddr(iop_base, s_addr);
-	for (i = 0; i < 2 * words; i += 2) {
-		if (i == 4 || i == 20) {
-			continue;
-		}
-		outpw(iop_base + IOP_RAM_DATA,
-		      ((ushort)outbuf[i + 1] << 8) | outbuf[i]);
-	}
-}
-
-/*
- * void
- * DvcGetQinfo(PortAddr iop_base, ushort s_addr, uchar *inbuf, int words)
- *
- * Calling/Exit State:
- *    none
- *
- * Description:
- *     Input an ASC_QDONE_INFO structure from the chip
- */
-static void
-DvcGetQinfo(PortAddr iop_base, ushort s_addr, uchar *inbuf, int words)
-{
-	int i;
-	ushort word;
-
-	AscSetChipLramAddr(iop_base, s_addr);
-	for (i = 0; i < 2 * words; i += 2) {
-		if (i == 10) {
-			continue;
-		}
-		word = inpw(iop_base + IOP_RAM_DATA);
-		inbuf[i] = word & 0xff;
-		inbuf[i + 1] = (word >> 8) & 0xff;
-	}
-	ASC_DBG_PRT_HEX(2, "DvcGetQinfo", inbuf, 2 * words);
-}
-
-/*
- * Return the BIOS address of the adapter at the specified
- * I/O port and with the specified bus type.
- */
-static unsigned short __devinit
-AscGetChipBiosAddress(PortAddr iop_base, unsigned short bus_type)
-{
-	unsigned short cfg_lsw;
-	unsigned short bios_addr;
-
-	/*
-	 * The PCI BIOS is re-located by the motherboard BIOS. Because
-	 * of this the driver can not determine where a PCI BIOS is
-	 * loaded and executes.
-	 */
-	if (bus_type & ASC_IS_PCI)
-		return 0;
-
-#ifdef CONFIG_ISA
-	if ((bus_type & ASC_IS_EISA) != 0) {
-		cfg_lsw = AscGetEisaChipCfg(iop_base);
-		cfg_lsw &= 0x000F;
-		bios_addr = ASC_BIOS_MIN_ADDR + cfg_lsw * ASC_BIOS_BANK_SIZE;
-		return bios_addr;
-	}
-#endif /* CONFIG_ISA */
-
-	cfg_lsw = AscGetChipCfgLsw(iop_base);
-
-	/*
-	 *  ISA PnP uses the top bit as the 32K BIOS flag
-	 */
-	if (bus_type == ASC_IS_ISAPNP)
-		cfg_lsw &= 0x7FFF;
-	bios_addr = ASC_BIOS_MIN_ADDR + (cfg_lsw >> 12) * ASC_BIOS_BANK_SIZE;
-	return bios_addr;
-}
-
-/*
- * DvcGetPhyAddr()
- *
- * Return the physical address of 'vaddr' and set '*lenp' to the
- * number of physically contiguous bytes that follow 'vaddr'.
- * 'flag' indicates the type of structure whose physical address
- * is being translated.
- *
- * Note: Because Linux currently doesn't page the kernel and all
- * kernel buffers are physically contiguous, leave '*lenp' unchanged.
- */
-ADV_PADDR
-DvcGetPhyAddr(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq,
-	      uchar *vaddr, ADV_SDCNT *lenp, int flag)
-{
-	ADV_PADDR paddr;
-
-	paddr = virt_to_bus(vaddr);
-
-	ASC_DBG4(4,
-		 "DvcGetPhyAddr: vaddr 0x%lx, lenp 0x%lx *lenp %lu, paddr 0x%lx\n",
-		 (ulong)vaddr, (ulong)lenp, (ulong)*((ulong *)lenp),
-		 (ulong)paddr);
-
-	return paddr;
-}
-
 #ifdef ADVANSYS_STATS
-#ifdef CONFIG_PROC_FS
 /*
  * asc_prt_board_stats()
  *
@@ -5803,420 +4315,543 @@ static int asc_prt_board_stats(struct Scsi_Host *shost, char *cp, int cplen)
 
 	return totlen;
 }
-#endif /* CONFIG_PROC_FS */
 #endif /* ADVANSYS_STATS */
 
-#ifdef ADVANSYS_DEBUG
 /*
- * asc_prt_scsi_host()
+ * advansys_proc_info() - /proc/scsi/advansys/{0,1,2,3,...}
+ *
+ * *buffer: I/O buffer
+ * **start: if inout == FALSE pointer into buffer where user read should start
+ * offset: current offset into a /proc/scsi/advansys/[0...] file
+ * length: length of buffer
+ * hostno: Scsi_Host host_no
+ * inout: TRUE - user is writing; FALSE - user is reading
+ *
+ * Return the number of bytes read from or written to a
+ * /proc/scsi/advansys/[0...] file.
+ *
+ * Note: This function uses the per board buffer 'prtbuf' which is
+ * allocated when the board is initialized in advansys_detect(). The
+ * buffer is ASC_PRTBUF_SIZE bytes. The function asc_proc_copy() is
+ * used to write to the buffer. The way asc_proc_copy() is written
+ * if 'prtbuf' is too small it will not be overwritten. Instead the
+ * user just won't get all the available statistics.
  */
-static void asc_prt_scsi_host(struct Scsi_Host *s)
+static int
+advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
+		   off_t offset, int length, int inout)
 {
 	asc_board_t *boardp;
+	char *cp;
+	int cplen;
+	int cnt;
+	int totcnt;
+	int leftlen;
+	char *curbuf;
+	off_t advoffset;
 
-	boardp = ASC_BOARDP(s);
+	ASC_DBG(1, "advansys_proc_info: begin\n");
 
-	printk("Scsi_Host at addr 0x%lx\n", (ulong)s);
-	printk(" host_busy %u, host_no %d, last_reset %d,\n",
-	       s->host_busy, s->host_no, (unsigned)s->last_reset);
+	/*
+	 * User write not supported.
+	 */
+	if (inout == TRUE) {
+		return (-ENOSYS);
+	}
 
-	printk(" base 0x%lx, io_port 0x%lx, irq 0x%x,\n",
-	       (ulong)s->base, (ulong)s->io_port, s->irq);
+	/*
+	 * User read of /proc/scsi/advansys/[0...] file.
+	 */
 
-	printk(" dma_channel %d, this_id %d, can_queue %d,\n",
-	       s->dma_channel, s->this_id, s->can_queue);
+	boardp = ASC_BOARDP(shost);
 
-	printk(" cmd_per_lun %d, sg_tablesize %d, unchecked_isa_dma %d\n",
-	       s->cmd_per_lun, s->sg_tablesize, s->unchecked_isa_dma);
+	/* Copy read data starting at the beginning of the buffer. */
+	*start = buffer;
+	curbuf = buffer;
+	advoffset = 0;
+	totcnt = 0;
+	leftlen = length;
 
-	if (ASC_NARROW_BOARD(boardp)) {
-		asc_prt_asc_dvc_var(&ASC_BOARDP(s)->dvc_var.asc_dvc_var);
-		asc_prt_asc_dvc_cfg(&ASC_BOARDP(s)->dvc_cfg.asc_dvc_cfg);
-	} else {
-		asc_prt_adv_dvc_var(&ASC_BOARDP(s)->dvc_var.adv_dvc_var);
-		asc_prt_adv_dvc_cfg(&ASC_BOARDP(s)->dvc_cfg.adv_dvc_cfg);
+	/*
+	 * Get board configuration information.
+	 *
+	 * advansys_info() returns the board string from its own static buffer.
+	 */
+	cp = (char *)advansys_info(shost);
+	strcat(cp, "\n");
+	cplen = strlen(cp);
+	/* Copy board information. */
+	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
+	totcnt += cnt;
+	leftlen -= cnt;
+	if (leftlen == 0) {
+		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		return totcnt;
 	}
-}
-
-/*
- * asc_prt_scsi_cmnd()
- */
-static void asc_prt_scsi_cmnd(struct scsi_cmnd *s)
-{
-	printk("struct scsi_cmnd at addr 0x%lx\n", (ulong)s);
+	advoffset += cplen;
+	curbuf += cnt;
 
-	printk(" host 0x%lx, device 0x%lx, target %u, lun %u, channel %u,\n",
-	       (ulong)s->device->host, (ulong)s->device, s->device->id,
-	       s->device->lun, s->device->channel);
+	/*
+	 * Display Wide Board BIOS Information.
+	 */
+	if (ASC_WIDE_BOARD(boardp)) {
+		cp = boardp->prtbuf;
+		cplen = asc_prt_adv_bios(shost, cp, ASC_PRTBUF_SIZE);
+		BUG_ON(cplen >= ASC_PRTBUF_SIZE);
+		cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
+				  cplen);
+		totcnt += cnt;
+		leftlen -= cnt;
+		if (leftlen == 0) {
+			ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+			return totcnt;
+		}
+		advoffset += cplen;
+		curbuf += cnt;
+	}
 
-	asc_prt_hex(" CDB", s->cmnd, s->cmd_len);
+	/*
+	 * Display driver information for each device attached to the board.
+	 */
+	cp = boardp->prtbuf;
+	cplen = asc_prt_board_devices(shost, cp, ASC_PRTBUF_SIZE);
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
+	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
+	totcnt += cnt;
+	leftlen -= cnt;
+	if (leftlen == 0) {
+		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		return totcnt;
+	}
+	advoffset += cplen;
+	curbuf += cnt;
 
-	printk("sc_data_direction %u, resid %d\n",
-	       s->sc_data_direction, s->resid);
+	/*
+	 * Display EEPROM configuration for the board.
+	 */
+	cp = boardp->prtbuf;
+	if (ASC_NARROW_BOARD(boardp)) {
+		cplen = asc_prt_asc_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
+	} else {
+		cplen = asc_prt_adv_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
+	}
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
+	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
+	totcnt += cnt;
+	leftlen -= cnt;
+	if (leftlen == 0) {
+		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		return totcnt;
+	}
+	advoffset += cplen;
+	curbuf += cnt;
 
-	printk(" use_sg %u, sglist_len %u\n", s->use_sg, s->sglist_len);
+	/*
+	 * Display driver configuration and information for the board.
+	 */
+	cp = boardp->prtbuf;
+	cplen = asc_prt_driver_conf(shost, cp, ASC_PRTBUF_SIZE);
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
+	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
+	totcnt += cnt;
+	leftlen -= cnt;
+	if (leftlen == 0) {
+		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		return totcnt;
+	}
+	advoffset += cplen;
+	curbuf += cnt;
 
-	printk(" serial_number 0x%x, retries %d, allowed %d\n",
-	       (unsigned)s->serial_number, s->retries, s->allowed);
+#ifdef ADVANSYS_STATS
+	/*
+	 * Display driver statistics for the board.
+	 */
+	cp = boardp->prtbuf;
+	cplen = asc_prt_board_stats(shost, cp, ASC_PRTBUF_SIZE);
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
+	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
+	totcnt += cnt;
+	leftlen -= cnt;
+	if (leftlen == 0) {
+		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		return totcnt;
+	}
+	advoffset += cplen;
+	curbuf += cnt;
+#endif /* ADVANSYS_STATS */
 
-	printk(" timeout_per_command %d\n", s->timeout_per_command);
+	/*
+	 * Display Asc Library dynamic configuration information
+	 * for the board.
+	 */
+	cp = boardp->prtbuf;
+	if (ASC_NARROW_BOARD(boardp)) {
+		cplen = asc_prt_asc_board_info(shost, cp, ASC_PRTBUF_SIZE);
+	} else {
+		cplen = asc_prt_adv_board_info(shost, cp, ASC_PRTBUF_SIZE);
+	}
+	BUG_ON(cplen >= ASC_PRTBUF_SIZE);
+	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
+	totcnt += cnt;
+	leftlen -= cnt;
+	if (leftlen == 0) {
+		ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
+		return totcnt;
+	}
+	advoffset += cplen;
+	curbuf += cnt;
 
-	printk(" scsi_done 0x%p, done 0x%p, host_scribble 0x%p, result 0x%x\n",
-		s->scsi_done, s->done, s->host_scribble, s->result);
+	ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
 
-	printk(" tag %u, pid %u\n", (unsigned)s->tag, (unsigned)s->pid);
+	return totcnt;
 }
+#endif /* CONFIG_PROC_FS */
 
-/*
- * asc_prt_asc_dvc_var()
- */
-static void asc_prt_asc_dvc_var(ASC_DVC_VAR *h)
+static void asc_scsi_done(struct scsi_cmnd *scp)
 {
-	printk("ASC_DVC_VAR at addr 0x%lx\n", (ulong)h);
-
-	printk(" iop_base 0x%x, err_code 0x%x, dvc_cntl 0x%x, bug_fix_cntl "
-	       "%d,\n", h->iop_base, h->err_code, h->dvc_cntl, h->bug_fix_cntl);
-
-	printk(" bus_type %d, init_sdtr 0x%x,\n", h->bus_type,
-		(unsigned)h->init_sdtr);
+	struct asc_board *boardp = ASC_BOARDP(scp->device->host);
 
-	printk(" sdtr_done 0x%x, use_tagged_qng 0x%x, unit_not_ready 0x%x, "
-	       "chip_no 0x%x,\n", (unsigned)h->sdtr_done,
-	       (unsigned)h->use_tagged_qng, (unsigned)h->unit_not_ready,
-	       (unsigned)h->chip_no);
+	if (scp->use_sg)
+		dma_unmap_sg(boardp->dev,
+			     (struct scatterlist *)scp->request_buffer,
+			     scp->use_sg, scp->sc_data_direction);
+	else if (scp->request_bufflen)
+		dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
+				 scp->request_bufflen, scp->sc_data_direction);
 
-	printk(" queue_full_or_busy 0x%x, start_motor 0x%x, scsi_reset_wait "
-	       "%u,\n", (unsigned)h->queue_full_or_busy,
-	       (unsigned)h->start_motor, (unsigned)h->scsi_reset_wait);
+	ASC_STATS(scp->device->host, done);
 
-	printk(" is_in_int %u, max_total_qng %u, cur_total_qng %u, "
-	       "in_critical_cnt %u,\n", (unsigned)h->is_in_int,
-	       (unsigned)h->max_total_qng, (unsigned)h->cur_total_qng,
-	       (unsigned)h->in_critical_cnt);
+	scp->scsi_done(scp);
+}
 
-	printk(" last_q_shortage %u, init_state 0x%x, no_scam 0x%x, "
-	       "pci_fix_asyn_xfer 0x%x,\n", (unsigned)h->last_q_shortage,
-	       (unsigned)h->init_state, (unsigned)h->no_scam,
-	       (unsigned)h->pci_fix_asyn_xfer);
+static void AscSetBank(PortAddr iop_base, uchar bank)
+{
+	uchar val;
 
-	printk(" cfg 0x%lx, irq_no 0x%x\n", (ulong)h->cfg, (unsigned)h->irq_no);
+	val = AscGetChipControl(iop_base) &
+	    (~
+	     (CC_SINGLE_STEP | CC_TEST | CC_DIAG | CC_SCSI_RESET |
+	      CC_CHIP_RESET));
+	if (bank == 1) {
+		val |= CC_BANK_ONE;
+	} else if (bank == 2) {
+		val |= CC_DIAG | CC_BANK_ONE;
+	} else {
+		val &= ~CC_BANK_ONE;
+	}
+	AscSetChipControl(iop_base, val);
+	return;
 }
 
-/*
- * asc_prt_asc_dvc_cfg()
- */
-static void asc_prt_asc_dvc_cfg(ASC_DVC_CFG *h)
+static void AscSetChipIH(PortAddr iop_base, ushort ins_code)
 {
-	printk("ASC_DVC_CFG at addr 0x%lx\n", (ulong)h);
-
-	printk(" can_tagged_qng 0x%x, cmd_qng_enabled 0x%x,\n",
-	       h->can_tagged_qng, h->cmd_qng_enabled);
-	printk(" disc_enable 0x%x, sdtr_enable 0x%x,\n",
-	       h->disc_enable, h->sdtr_enable);
+	AscSetBank(iop_base, 1);
+	AscWriteChipIH(iop_base, ins_code);
+	AscSetBank(iop_base, 0);
+	return;
+}
 
-	printk
-	    (" chip_scsi_id %d, isa_dma_speed %d, isa_dma_channel %d, chip_version %d,\n",
-	     h->chip_scsi_id, h->isa_dma_speed, h->isa_dma_channel,
-	     h->chip_version);
+static int AscStartChip(PortAddr iop_base)
+{
+	AscSetChipControl(iop_base, 0);
+	if ((AscGetChipStatus(iop_base) & CSW_HALTED) != 0) {
+		return (0);
+	}
+	return (1);
+}
 
-	printk
-	    (" pci_device_id %d, lib_serial_no %u, lib_version %u, mcode_date 0x%x,\n",
-	     to_pci_dev(h->dev)->device, h->lib_serial_no, h->lib_version,
-	     h->mcode_date);
+static int AscStopChip(PortAddr iop_base)
+{
+	uchar cc_val;
 
-	printk(" mcode_version %d, overrun_buf 0x%lx\n",
-	       h->mcode_version, (ulong)h->overrun_buf);
+	cc_val =
+	    AscGetChipControl(iop_base) &
+	    (~(CC_SINGLE_STEP | CC_TEST | CC_DIAG));
+	AscSetChipControl(iop_base, (uchar)(cc_val | CC_HALT));
+	AscSetChipIH(iop_base, INS_HALT);
+	AscSetChipIH(iop_base, INS_RFLAG_WTM);
+	if ((AscGetChipStatus(iop_base) & CSW_HALTED) == 0) {
+		return (0);
+	}
+	return (1);
 }
 
-/*
- * asc_prt_asc_scsi_q()
- */
-static void asc_prt_asc_scsi_q(ASC_SCSI_Q *q)
+static int AscIsChipHalted(PortAddr iop_base)
 {
-	ASC_SG_HEAD *sgp;
-	int i;
-
-	printk("ASC_SCSI_Q at addr 0x%lx\n", (ulong)q);
+	if ((AscGetChipStatus(iop_base) & CSW_HALTED) != 0) {
+		if ((AscGetChipControl(iop_base) & CC_HALT) != 0) {
+			return (1);
+		}
+	}
+	return (0);
+}
 
-	printk
-	    (" target_ix 0x%x, target_lun %u, srb_ptr 0x%lx, tag_code 0x%x,\n",
-	     q->q2.target_ix, q->q1.target_lun, (ulong)q->q2.srb_ptr,
-	     q->q2.tag_code);
+static int AscResetChipAndScsiBus(ASC_DVC_VAR *asc_dvc)
+{
+	PortAddr iop_base;
+	int i = 10;
 
-	printk
-	    (" data_addr 0x%lx, data_cnt %lu, sense_addr 0x%lx, sense_len %u,\n",
-	     (ulong)le32_to_cpu(q->q1.data_addr),
-	     (ulong)le32_to_cpu(q->q1.data_cnt),
-	     (ulong)le32_to_cpu(q->q1.sense_addr), q->q1.sense_len);
+	iop_base = asc_dvc->iop_base;
+	while ((AscGetChipStatus(iop_base) & CSW_SCSI_RESET_ACTIVE)
+	       && (i-- > 0)) {
+		mdelay(100);
+	}
+	AscStopChip(iop_base);
+	AscSetChipControl(iop_base, CC_CHIP_RESET | CC_SCSI_RESET | CC_HALT);
+	udelay(60);
+	AscSetChipIH(iop_base, INS_RFLAG_WTM);
+	AscSetChipIH(iop_base, INS_HALT);
+	AscSetChipControl(iop_base, CC_CHIP_RESET | CC_HALT);
+	AscSetChipControl(iop_base, CC_HALT);
+	mdelay(200);
+	AscSetChipStatus(iop_base, CIW_CLR_SCSI_RESET_INT);
+	AscSetChipStatus(iop_base, 0);
+	return (AscIsChipHalted(iop_base));
+}
 
-	printk(" cdbptr 0x%lx, cdb_len %u, sg_head 0x%lx, sg_queue_cnt %u\n",
-	       (ulong)q->cdbptr, q->q2.cdb_len,
-	       (ulong)q->sg_head, q->q1.sg_queue_cnt);
+static int AscFindSignature(PortAddr iop_base)
+{
+	ushort sig_word;
 
-	if (q->sg_head) {
-		sgp = q->sg_head;
-		printk("ASC_SG_HEAD at addr 0x%lx\n", (ulong)sgp);
-		printk(" entry_cnt %u, queue_cnt %u\n", sgp->entry_cnt,
-		       sgp->queue_cnt);
-		for (i = 0; i < sgp->entry_cnt; i++) {
-			printk(" [%u]: addr 0x%lx, bytes %lu\n",
-			       i, (ulong)le32_to_cpu(sgp->sg_list[i].addr),
-			       (ulong)le32_to_cpu(sgp->sg_list[i].bytes));
+	ASC_DBG2(1, "AscFindSignature: AscGetChipSignatureByte(0x%x) 0x%x\n",
+		 iop_base, AscGetChipSignatureByte(iop_base));
+	if (AscGetChipSignatureByte(iop_base) == (uchar)ASC_1000_ID1B) {
+		ASC_DBG2(1,
+			 "AscFindSignature: AscGetChipSignatureWord(0x%x) 0x%x\n",
+			 iop_base, AscGetChipSignatureWord(iop_base));
+		sig_word = AscGetChipSignatureWord(iop_base);
+		if ((sig_word == (ushort)ASC_1000_ID0W) ||
+		    (sig_word == (ushort)ASC_1000_ID0W_FIX)) {
+			return (1);
 		}
-
 	}
+	return (0);
 }
 
-/*
- * asc_prt_asc_qdone_info()
- */
-static void asc_prt_asc_qdone_info(ASC_QDONE_INFO *q)
+static void AscEnableInterrupt(PortAddr iop_base)
 {
-	printk("ASC_QDONE_INFO at addr 0x%lx\n", (ulong)q);
-	printk(" srb_ptr 0x%lx, target_ix %u, cdb_len %u, tag_code %u,\n",
-	       (ulong)q->d2.srb_ptr, q->d2.target_ix, q->d2.cdb_len,
-	       q->d2.tag_code);
-	printk
-	    (" done_stat 0x%x, host_stat 0x%x, scsi_stat 0x%x, scsi_msg 0x%x\n",
-	     q->d3.done_stat, q->d3.host_stat, q->d3.scsi_stat, q->d3.scsi_msg);
+	ushort cfg;
+
+	cfg = AscGetChipCfgLsw(iop_base);
+	AscSetChipCfgLsw(iop_base, cfg | ASC_CFG0_HOST_INT_ON);
+	return;
 }
 
-/*
- * asc_prt_adv_dvc_var()
- *
- * Display an ADV_DVC_VAR structure.
- */
-static void asc_prt_adv_dvc_var(ADV_DVC_VAR *h)
+static void AscDisableInterrupt(PortAddr iop_base)
 {
-	printk(" ADV_DVC_VAR at addr 0x%lx\n", (ulong)h);
+	ushort cfg;
 
-	printk("  iop_base 0x%lx, err_code 0x%x, ultra_able 0x%x\n",
-	       (ulong)h->iop_base, h->err_code, (unsigned)h->ultra_able);
+	cfg = AscGetChipCfgLsw(iop_base);
+	AscSetChipCfgLsw(iop_base, cfg & (~ASC_CFG0_HOST_INT_ON));
+	return;
+}
 
-	printk("  isr_callback 0x%lx, sdtr_able 0x%x, wdtr_able 0x%x\n",
-	       (ulong)h->isr_callback, (unsigned)h->sdtr_able,
-	       (unsigned)h->wdtr_able);
+static uchar AscReadLramByte(PortAddr iop_base, ushort addr)
+{
+	unsigned char byte_data;
+	unsigned short word_data;
 
-	printk("  start_motor 0x%x, scsi_reset_wait 0x%x, irq_no 0x%x,\n",
-	       (unsigned)h->start_motor,
-	       (unsigned)h->scsi_reset_wait, (unsigned)h->irq_no);
+	if (isodd_word(addr)) {
+		AscSetChipLramAddr(iop_base, addr - 1);
+		word_data = AscGetChipLramData(iop_base);
+		byte_data = (word_data >> 8) & 0xFF;
+	} else {
+		AscSetChipLramAddr(iop_base, addr);
+		word_data = AscGetChipLramData(iop_base);
+		byte_data = word_data & 0xFF;
+	}
+	return byte_data;
+}
 
-	printk("  max_host_qng %u, max_dvc_qng %u, carr_freelist 0x%lxn\n",
-	       (unsigned)h->max_host_qng, (unsigned)h->max_dvc_qng,
-	       (ulong)h->carr_freelist);
+static ushort AscReadLramWord(PortAddr iop_base, ushort addr)
+{
+	ushort word_data;
 
-	printk("  icq_sp 0x%lx, irq_sp 0x%lx\n",
-	       (ulong)h->icq_sp, (ulong)h->irq_sp);
+	AscSetChipLramAddr(iop_base, addr);
+	word_data = AscGetChipLramData(iop_base);
+	return (word_data);
+}
 
-	printk("  no_scam 0x%x, tagqng_able 0x%x\n",
-	       (unsigned)h->no_scam, (unsigned)h->tagqng_able);
+#if CC_VERY_LONG_SG_LIST
+static ASC_DCNT AscReadLramDWord(PortAddr iop_base, ushort addr)
+{
+	ushort val_low, val_high;
+	ASC_DCNT dword_data;
 
-	printk("  chip_scsi_id 0x%x, cfg 0x%lx\n",
-	       (unsigned)h->chip_scsi_id, (ulong)h->cfg);
+	AscSetChipLramAddr(iop_base, addr);
+	val_low = AscGetChipLramData(iop_base);
+	val_high = AscGetChipLramData(iop_base);
+	dword_data = ((ASC_DCNT) val_high << 16) | (ASC_DCNT) val_low;
+	return (dword_data);
 }
+#endif /* CC_VERY_LONG_SG_LIST */
 
-/*
- * asc_prt_adv_dvc_cfg()
- *
- * Display an ADV_DVC_CFG structure.
- */
-static void asc_prt_adv_dvc_cfg(ADV_DVC_CFG *h)
+static void
+AscMemWordSetLram(PortAddr iop_base, ushort s_addr, ushort set_wval, int words)
 {
-	printk(" ADV_DVC_CFG at addr 0x%lx\n", (ulong)h);
+	int i;
 
-	printk("  disc_enable 0x%x, termination 0x%x\n",
-	       h->disc_enable, h->termination);
+	AscSetChipLramAddr(iop_base, s_addr);
+	for (i = 0; i < words; i++) {
+		AscSetChipLramData(iop_base, set_wval);
+	}
+}
 
-	printk("  chip_version 0x%x, mcode_date 0x%x\n",
-	       h->chip_version, h->mcode_date);
+static void AscWriteLramWord(PortAddr iop_base, ushort addr, ushort word_val)
+{
+	AscSetChipLramAddr(iop_base, addr);
+	AscSetChipLramData(iop_base, word_val);
+	return;
+}
 
-	printk("  mcode_version 0x%x, pci_device_id 0x%x, lib_version %u\n",
-	       h->mcode_version, to_pci_dev(h->dev)->device, h->lib_version);
+static void AscWriteLramByte(PortAddr iop_base, ushort addr, uchar byte_val)
+{
+	ushort word_data;
 
-	printk("  control_flag 0x%x\n", h->control_flag);
+	if (isodd_word(addr)) {
+		addr--;
+		word_data = AscReadLramWord(iop_base, addr);
+		word_data &= 0x00FF;
+		word_data |= (((ushort)byte_val << 8) & 0xFF00);
+	} else {
+		word_data = AscReadLramWord(iop_base, addr);
+		word_data &= 0xFF00;
+		word_data |= ((ushort)byte_val & 0x00FF);
+	}
+	AscWriteLramWord(iop_base, addr, word_data);
+	return;
 }
 
 /*
- * asc_prt_adv_scsi_req_q()
+ * Copy 2 bytes to LRAM.
  *
- * Display an ADV_SCSI_REQ_Q structure.
+ * The source data is assumed to be in little-endian order in memory
+ * and is maintained in little-endian order when written to LRAM.
  */
-static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
+static void
+AscMemWordCopyPtrToLram(PortAddr iop_base,
+			ushort s_addr, uchar *s_buffer, int words)
 {
-	int sg_blk_cnt;
-	struct asc_sg_block *sg_ptr;
-
-	printk("ADV_SCSI_REQ_Q at addr 0x%lx\n", (ulong)q);
-
-	printk("  target_id %u, target_lun %u, srb_ptr 0x%lx, a_flag 0x%x\n",
-	       q->target_id, q->target_lun, (ulong)q->srb_ptr, q->a_flag);
-
-	printk("  cntl 0x%x, data_addr 0x%lx, vdata_addr 0x%lx\n",
-	       q->cntl, (ulong)le32_to_cpu(q->data_addr), (ulong)q->vdata_addr);
-
-	printk("  data_cnt %lu, sense_addr 0x%lx, sense_len %u,\n",
-	       (ulong)le32_to_cpu(q->data_cnt),
-	       (ulong)le32_to_cpu(q->sense_addr), q->sense_len);
-
-	printk
-	    ("  cdb_len %u, done_status 0x%x, host_status 0x%x, scsi_status 0x%x\n",
-	     q->cdb_len, q->done_status, q->host_status, q->scsi_status);
-
-	printk("  sg_working_ix 0x%x, target_cmd %u\n",
-	       q->sg_working_ix, q->target_cmd);
-
-	printk("  scsiq_rptr 0x%lx, sg_real_addr 0x%lx, sg_list_ptr 0x%lx\n",
-	       (ulong)le32_to_cpu(q->scsiq_rptr),
-	       (ulong)le32_to_cpu(q->sg_real_addr), (ulong)q->sg_list_ptr);
+	int i;
 
-	/* Display the request's ADV_SG_BLOCK structures. */
-	if (q->sg_list_ptr != NULL) {
-		sg_blk_cnt = 0;
-		while (1) {
-			/*
-			 * 'sg_ptr' is a physical address. Convert it to a virtual
-			 * address by indexing 'sg_blk_cnt' into the virtual address
-			 * array 'sg_list_ptr'.
-			 *
-			 * XXX - Assumes all SG physical blocks are virtually contiguous.
-			 */
-			sg_ptr =
-			    &(((ADV_SG_BLOCK *)(q->sg_list_ptr))[sg_blk_cnt]);
-			asc_prt_adv_sgblock(sg_blk_cnt, sg_ptr);
-			if (sg_ptr->sg_ptr == 0) {
-				break;
-			}
-			sg_blk_cnt++;
-		}
+	AscSetChipLramAddr(iop_base, s_addr);
+	for (i = 0; i < 2 * words; i += 2) {
+		/*
+		 * On a little-endian system the second argument below
+		 * produces a little-endian ushort which is written to
+		 * LRAM in little-endian order. On a big-endian system
+		 * the second argument produces a big-endian ushort which
+		 * is "transparently" byte-swapped by outpw() and written
+		 * in little-endian order to LRAM.
+		 */
+		outpw(iop_base + IOP_RAM_DATA,
+		      ((ushort)s_buffer[i + 1] << 8) | s_buffer[i]);
 	}
+	return;
 }
 
 /*
- * asc_prt_adv_sgblock()
+ * Copy 4 bytes to LRAM.
  *
- * Display an ADV_SG_BLOCK structure.
+ * The source data is assumed to be in little-endian order in memory
+ * and is maintained in little-endian order when writen to LRAM.
  */
-static void asc_prt_adv_sgblock(int sgblockno, ADV_SG_BLOCK *b)
+static void
+AscMemDWordCopyPtrToLram(PortAddr iop_base,
+			 ushort s_addr, uchar *s_buffer, int dwords)
 {
 	int i;
 
-	printk(" ASC_SG_BLOCK at addr 0x%lx (sgblockno %d)\n",
-	       (ulong)b, sgblockno);
-	printk("  sg_cnt %u, sg_ptr 0x%lx\n",
-	       b->sg_cnt, (ulong)le32_to_cpu(b->sg_ptr));
-	BUG_ON(b->sg_cnt > NO_OF_SG_PER_BLOCK);
-	if (b->sg_ptr != 0)
-		BUG_ON(b->sg_cnt != NO_OF_SG_PER_BLOCK);
-	for (i = 0; i < b->sg_cnt; i++) {
-		printk("  [%u]: sg_addr 0x%lx, sg_count 0x%lx\n",
-		       i, (ulong)b->sg_list[i].sg_addr,
-		       (ulong)b->sg_list[i].sg_count);
+	AscSetChipLramAddr(iop_base, s_addr);
+	for (i = 0; i < 4 * dwords; i += 4) {
+		outpw(iop_base + IOP_RAM_DATA, ((ushort)s_buffer[i + 1] << 8) | s_buffer[i]);	/* LSW */
+		outpw(iop_base + IOP_RAM_DATA, ((ushort)s_buffer[i + 3] << 8) | s_buffer[i + 2]);	/* MSW */
 	}
+	return;
 }
 
 /*
- * asc_prt_hex()
+ * Copy 2 bytes from LRAM.
  *
- * Print hexadecimal output in 4 byte groupings 32 bytes
- * or 8 double-words per line.
+ * The source data is assumed to be in little-endian order in LRAM
+ * and is maintained in little-endian order when written to memory.
  */
-static void asc_prt_hex(char *f, uchar *s, int l)
+static void
+AscMemWordCopyPtrFromLram(PortAddr iop_base,
+			  ushort s_addr, uchar *d_buffer, int words)
 {
 	int i;
-	int j;
-	int k;
-	int m;
-
-	printk("%s: (%d bytes)\n", f, l);
-
-	for (i = 0; i < l; i += 32) {
-
-		/* Display a maximum of 8 double-words per line. */
-		if ((k = (l - i) / 4) >= 8) {
-			k = 8;
-			m = 0;
-		} else {
-			m = (l - i) % 4;
-		}
-
-		for (j = 0; j < k; j++) {
-			printk(" %2.2X%2.2X%2.2X%2.2X",
-			       (unsigned)s[i + (j * 4)],
-			       (unsigned)s[i + (j * 4) + 1],
-			       (unsigned)s[i + (j * 4) + 2],
-			       (unsigned)s[i + (j * 4) + 3]);
-		}
-
-		switch (m) {
-		case 0:
-		default:
-			break;
-		case 1:
-			printk(" %2.2X", (unsigned)s[i + (j * 4)]);
-			break;
-		case 2:
-			printk(" %2.2X%2.2X",
-			       (unsigned)s[i + (j * 4)],
-			       (unsigned)s[i + (j * 4) + 1]);
-			break;
-		case 3:
-			printk(" %2.2X%2.2X%2.2X",
-			       (unsigned)s[i + (j * 4) + 1],
-			       (unsigned)s[i + (j * 4) + 2],
-			       (unsigned)s[i + (j * 4) + 3]);
-			break;
-		}
+	ushort word;
 
-		printk("\n");
+	AscSetChipLramAddr(iop_base, s_addr);
+	for (i = 0; i < 2 * words; i += 2) {
+		word = inpw(iop_base + IOP_RAM_DATA);
+		d_buffer[i] = word & 0xff;
+		d_buffer[i + 1] = (word >> 8) & 0xff;
 	}
-}
-#endif /* ADVANSYS_DEBUG */
-
-static ushort __devinit AscGetEisaChipCfg(PortAddr iop_base)
-{
-	PortAddr eisa_cfg_iop;
-
-	eisa_cfg_iop = (PortAddr) ASC_GET_EISA_SLOT(iop_base) |
-	    (PortAddr) (ASC_EISA_CFG_IOP_MASK);
-	return (inpw(eisa_cfg_iop));
+	return;
 }
 
-static uchar __devinit AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
+static ASC_DCNT AscMemSumLramWord(PortAddr iop_base, ushort s_addr, int words)
 {
-	ushort cfg_lsw;
+	ASC_DCNT sum;
+	int i;
 
-	if (AscGetChipScsiID(iop_base) == new_host_id) {
-		return (new_host_id);
+	sum = 0L;
+	for (i = 0; i < words; i++, s_addr += 2) {
+		sum += AscReadLramWord(iop_base, s_addr);
 	}
-	cfg_lsw = AscGetChipCfgLsw(iop_base);
-	cfg_lsw &= 0xF8FF;
-	cfg_lsw |= (ushort)((new_host_id & ASC_MAX_TID) << 8);
-	AscSetChipCfgLsw(iop_base, cfg_lsw);
-	return (AscGetChipScsiID(iop_base));
+	return (sum);
 }
 
-static unsigned char __devinit AscGetChipScsiCtrl(PortAddr iop_base)
+static ushort AscInitLram(ASC_DVC_VAR *asc_dvc)
 {
-	unsigned char sc;
-
-	AscSetBank(iop_base, 1);
-	sc = inp(iop_base + IOP_REG_SC);
-	AscSetBank(iop_base, 0);
-	return sc;
-}
+	uchar i;
+	ushort s_addr;
+	PortAddr iop_base;
+	ushort warn_code;
 
-static unsigned char __devinit
-AscGetChipVersion(PortAddr iop_base, unsigned short bus_type)
-{
-	if (bus_type & ASC_IS_EISA) {
-		PortAddr eisa_iop;
-		unsigned char revision;
-		eisa_iop = (PortAddr) ASC_GET_EISA_SLOT(iop_base) |
-		    (PortAddr) ASC_EISA_REV_IOP_MASK;
-		revision = inp(eisa_iop);
-		return ASC_CHIP_MIN_VER_EISA - 1 + revision;
+	iop_base = asc_dvc->iop_base;
+	warn_code = 0;
+	AscMemWordSetLram(iop_base, ASC_QADR_BEG, 0,
+			  (ushort)(((int)(asc_dvc->max_total_qng + 2 + 1) *
+				    64) >> 1));
+	i = ASC_MIN_ACTIVE_QNO;
+	s_addr = ASC_QADR_BEG + ASC_QBLK_SIZE;
+	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_FWD),
+			 (uchar)(i + 1));
+	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_BWD),
+			 (uchar)(asc_dvc->max_total_qng));
+	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_QNO),
+			 (uchar)i);
+	i++;
+	s_addr += ASC_QBLK_SIZE;
+	for (; i < asc_dvc->max_total_qng; i++, s_addr += ASC_QBLK_SIZE) {
+		AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_FWD),
+				 (uchar)(i + 1));
+		AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_BWD),
+				 (uchar)(i - 1));
+		AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_QNO),
+				 (uchar)i);
 	}
-	return AscGetChipVerNo(iop_base);
+	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_FWD),
+			 (uchar)ASC_QLINK_END);
+	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_BWD),
+			 (uchar)(asc_dvc->max_total_qng - 1));
+	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_QNO),
+			 (uchar)asc_dvc->max_total_qng);
+	i++;
+	s_addr += ASC_QBLK_SIZE;
+	for (; i <= (uchar)(asc_dvc->max_total_qng + 3);
+	     i++, s_addr += ASC_QBLK_SIZE) {
+		AscWriteLramByte(iop_base,
+				 (ushort)(s_addr + (ushort)ASC_SCSIQ_B_FWD), i);
+		AscWriteLramByte(iop_base,
+				 (ushort)(s_addr + (ushort)ASC_SCSIQ_B_BWD), i);
+		AscWriteLramByte(iop_base,
+				 (ushort)(s_addr + (ushort)ASC_SCSIQ_B_QNO), i);
+	}
+	return warn_code;
 }
 
 static ASC_DCNT
@@ -6247,865 +4882,6 @@ AscLoadMicroCode(PortAddr iop_base,
 	return (chksum);
 }
 
-static int AscFindSignature(PortAddr iop_base)
-{
-	ushort sig_word;
-
-	ASC_DBG2(1, "AscFindSignature: AscGetChipSignatureByte(0x%x) 0x%x\n",
-		 iop_base, AscGetChipSignatureByte(iop_base));
-	if (AscGetChipSignatureByte(iop_base) == (uchar)ASC_1000_ID1B) {
-		ASC_DBG2(1,
-			 "AscFindSignature: AscGetChipSignatureWord(0x%x) 0x%x\n",
-			 iop_base, AscGetChipSignatureWord(iop_base));
-		sig_word = AscGetChipSignatureWord(iop_base);
-		if ((sig_word == (ushort)ASC_1000_ID0W) ||
-		    (sig_word == (ushort)ASC_1000_ID0W_FIX)) {
-			return (1);
-		}
-	}
-	return (0);
-}
-
-static void __devinit AscToggleIRQAct(PortAddr iop_base)
-{
-	AscSetChipStatus(iop_base, CIW_IRQ_ACT);
-	AscSetChipStatus(iop_base, 0);
-	return;
-}
-
-static uchar __devinit AscGetChipIRQ(PortAddr iop_base, ushort bus_type)
-{
-	ushort cfg_lsw;
-	uchar chip_irq;
-
-	if ((bus_type & ASC_IS_EISA) != 0) {
-		cfg_lsw = AscGetEisaChipCfg(iop_base);
-		chip_irq = (uchar)(((cfg_lsw >> 8) & 0x07) + 10);
-		if ((chip_irq == 13) || (chip_irq > 15)) {
-			return (0);
-		}
-		return (chip_irq);
-	}
-	if ((bus_type & ASC_IS_VL) != 0) {
-		cfg_lsw = AscGetChipCfgLsw(iop_base);
-		chip_irq = (uchar)(((cfg_lsw >> 2) & 0x07));
-		if ((chip_irq == 0) || (chip_irq == 4) || (chip_irq == 7)) {
-			return (0);
-		}
-		return ((uchar)(chip_irq + (ASC_MIN_IRQ_NO - 1)));
-	}
-	cfg_lsw = AscGetChipCfgLsw(iop_base);
-	chip_irq = (uchar)(((cfg_lsw >> 2) & 0x03));
-	if (chip_irq == 3)
-		chip_irq += (uchar)2;
-	return ((uchar)(chip_irq + ASC_MIN_IRQ_NO));
-}
-
-static uchar __devinit
-AscSetChipIRQ(PortAddr iop_base, uchar irq_no, ushort bus_type)
-{
-	ushort cfg_lsw;
-
-	if ((bus_type & ASC_IS_VL) != 0) {
-		if (irq_no != 0) {
-			if ((irq_no < ASC_MIN_IRQ_NO)
-			    || (irq_no > ASC_MAX_IRQ_NO)) {
-				irq_no = 0;
-			} else {
-				irq_no -= (uchar)((ASC_MIN_IRQ_NO - 1));
-			}
-		}
-		cfg_lsw = (ushort)(AscGetChipCfgLsw(iop_base) & 0xFFE3);
-		cfg_lsw |= (ushort)0x0010;
-		AscSetChipCfgLsw(iop_base, cfg_lsw);
-		AscToggleIRQAct(iop_base);
-		cfg_lsw = (ushort)(AscGetChipCfgLsw(iop_base) & 0xFFE0);
-		cfg_lsw |= (ushort)((irq_no & 0x07) << 2);
-		AscSetChipCfgLsw(iop_base, cfg_lsw);
-		AscToggleIRQAct(iop_base);
-		return (AscGetChipIRQ(iop_base, bus_type));
-	}
-	if ((bus_type & (ASC_IS_ISA)) != 0) {
-		if (irq_no == 15)
-			irq_no -= (uchar)2;
-		irq_no -= (uchar)ASC_MIN_IRQ_NO;
-		cfg_lsw = (ushort)(AscGetChipCfgLsw(iop_base) & 0xFFF3);
-		cfg_lsw |= (ushort)((irq_no & 0x03) << 2);
-		AscSetChipCfgLsw(iop_base, cfg_lsw);
-		return (AscGetChipIRQ(iop_base, bus_type));
-	}
-	return (0);
-}
-
-#ifdef CONFIG_ISA
-static void __devinit AscEnableIsaDma(uchar dma_channel)
-{
-	if (dma_channel < 4) {
-		outp(0x000B, (ushort)(0xC0 | dma_channel));
-		outp(0x000A, dma_channel);
-	} else if (dma_channel < 8) {
-		outp(0x00D6, (ushort)(0xC0 | (dma_channel - 4)));
-		outp(0x00D4, (ushort)(dma_channel - 4));
-	}
-	return;
-}
-#endif /* CONFIG_ISA */
-
-static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
-{
-	EXT_MSG ext_msg;
-	EXT_MSG out_msg;
-	ushort halt_q_addr;
-	int sdtr_accept;
-	ushort int_halt_code;
-	ASC_SCSI_BIT_ID_TYPE scsi_busy;
-	ASC_SCSI_BIT_ID_TYPE target_id;
-	PortAddr iop_base;
-	uchar tag_code;
-	uchar q_status;
-	uchar halt_qp;
-	uchar sdtr_data;
-	uchar target_ix;
-	uchar q_cntl, tid_no;
-	uchar cur_dvc_qng;
-	uchar asyn_sdtr;
-	uchar scsi_status;
-	asc_board_t *boardp;
-
-	BUG_ON(!asc_dvc->drv_ptr);
-	boardp = asc_dvc->drv_ptr;
-
-	iop_base = asc_dvc->iop_base;
-	int_halt_code = AscReadLramWord(iop_base, ASCV_HALTCODE_W);
-
-	halt_qp = AscReadLramByte(iop_base, ASCV_CURCDB_B);
-	halt_q_addr = ASC_QNO_TO_QADDR(halt_qp);
-	target_ix = AscReadLramByte(iop_base,
-				    (ushort)(halt_q_addr +
-					     (ushort)ASC_SCSIQ_B_TARGET_IX));
-	q_cntl = AscReadLramByte(iop_base,
-			    (ushort)(halt_q_addr + (ushort)ASC_SCSIQ_B_CNTL));
-	tid_no = ASC_TIX_TO_TID(target_ix);
-	target_id = (uchar)ASC_TID_TO_TARGET_ID(tid_no);
-	if (asc_dvc->pci_fix_asyn_xfer & target_id) {
-		asyn_sdtr = ASYN_SDTR_DATA_FIX_PCI_REV_AB;
-	} else {
-		asyn_sdtr = 0;
-	}
-	if (int_halt_code == ASC_HALT_DISABLE_ASYN_USE_SYN_FIX) {
-		if (asc_dvc->pci_fix_asyn_xfer & target_id) {
-			AscSetChipSDTR(iop_base, 0, tid_no);
-			boardp->sdtr_data[tid_no] = 0;
-		}
-		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
-	} else if (int_halt_code == ASC_HALT_ENABLE_ASYN_USE_SYN_FIX) {
-		if (asc_dvc->pci_fix_asyn_xfer & target_id) {
-			AscSetChipSDTR(iop_base, asyn_sdtr, tid_no);
-			boardp->sdtr_data[tid_no] = asyn_sdtr;
-		}
-		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
-	} else if (int_halt_code == ASC_HALT_EXTMSG_IN) {
-		AscMemWordCopyPtrFromLram(iop_base,
-					  ASCV_MSGIN_BEG,
-					  (uchar *)&ext_msg,
-					  sizeof(EXT_MSG) >> 1);
-
-		if (ext_msg.msg_type == EXTENDED_MESSAGE &&
-		    ext_msg.msg_req == EXTENDED_SDTR &&
-		    ext_msg.msg_len == MS_SDTR_LEN) {
-			sdtr_accept = TRUE;
-			if ((ext_msg.req_ack_offset > ASC_SYN_MAX_OFFSET)) {
-
-				sdtr_accept = FALSE;
-				ext_msg.req_ack_offset = ASC_SYN_MAX_OFFSET;
-			}
-			if ((ext_msg.xfer_period <
-			     asc_dvc->sdtr_period_tbl[asc_dvc->
-						      host_init_sdtr_index])
-			    || (ext_msg.xfer_period >
-				asc_dvc->sdtr_period_tbl[asc_dvc->
-							 max_sdtr_index])) {
-				sdtr_accept = FALSE;
-				ext_msg.xfer_period =
-				    asc_dvc->sdtr_period_tbl[asc_dvc->
-							     host_init_sdtr_index];
-			}
-			if (sdtr_accept) {
-				sdtr_data =
-				    AscCalSDTRData(asc_dvc, ext_msg.xfer_period,
-						   ext_msg.req_ack_offset);
-				if ((sdtr_data == 0xFF)) {
-
-					q_cntl |= QC_MSG_OUT;
-					asc_dvc->init_sdtr &= ~target_id;
-					asc_dvc->sdtr_done &= ~target_id;
-					AscSetChipSDTR(iop_base, asyn_sdtr,
-						       tid_no);
-					boardp->sdtr_data[tid_no] = asyn_sdtr;
-				}
-			}
-			if (ext_msg.req_ack_offset == 0) {
-
-				q_cntl &= ~QC_MSG_OUT;
-				asc_dvc->init_sdtr &= ~target_id;
-				asc_dvc->sdtr_done &= ~target_id;
-				AscSetChipSDTR(iop_base, asyn_sdtr, tid_no);
-			} else {
-				if (sdtr_accept && (q_cntl & QC_MSG_OUT)) {
-
-					q_cntl &= ~QC_MSG_OUT;
-					asc_dvc->sdtr_done |= target_id;
-					asc_dvc->init_sdtr |= target_id;
-					asc_dvc->pci_fix_asyn_xfer &=
-					    ~target_id;
-					sdtr_data =
-					    AscCalSDTRData(asc_dvc,
-							   ext_msg.xfer_period,
-							   ext_msg.
-							   req_ack_offset);
-					AscSetChipSDTR(iop_base, sdtr_data,
-						       tid_no);
-					boardp->sdtr_data[tid_no] = sdtr_data;
-				} else {
-
-					q_cntl |= QC_MSG_OUT;
-					AscMsgOutSDTR(asc_dvc,
-						      ext_msg.xfer_period,
-						      ext_msg.req_ack_offset);
-					asc_dvc->pci_fix_asyn_xfer &=
-					    ~target_id;
-					sdtr_data =
-					    AscCalSDTRData(asc_dvc,
-							   ext_msg.xfer_period,
-							   ext_msg.
-							   req_ack_offset);
-					AscSetChipSDTR(iop_base, sdtr_data,
-						       tid_no);
-					boardp->sdtr_data[tid_no] = sdtr_data;
-					asc_dvc->sdtr_done |= target_id;
-					asc_dvc->init_sdtr |= target_id;
-				}
-			}
-
-			AscWriteLramByte(iop_base,
-					 (ushort)(halt_q_addr +
-						  (ushort)ASC_SCSIQ_B_CNTL),
-					 q_cntl);
-			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-			return (0);
-		} else if (ext_msg.msg_type == EXTENDED_MESSAGE &&
-			   ext_msg.msg_req == EXTENDED_WDTR &&
-			   ext_msg.msg_len == MS_WDTR_LEN) {
-
-			ext_msg.wdtr_width = 0;
-			AscMemWordCopyPtrToLram(iop_base,
-						ASCV_MSGOUT_BEG,
-						(uchar *)&ext_msg,
-						sizeof(EXT_MSG) >> 1);
-			q_cntl |= QC_MSG_OUT;
-			AscWriteLramByte(iop_base,
-					 (ushort)(halt_q_addr +
-						  (ushort)ASC_SCSIQ_B_CNTL),
-					 q_cntl);
-			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-			return (0);
-		} else {
-
-			ext_msg.msg_type = MESSAGE_REJECT;
-			AscMemWordCopyPtrToLram(iop_base,
-						ASCV_MSGOUT_BEG,
-						(uchar *)&ext_msg,
-						sizeof(EXT_MSG) >> 1);
-			q_cntl |= QC_MSG_OUT;
-			AscWriteLramByte(iop_base,
-					 (ushort)(halt_q_addr +
-						  (ushort)ASC_SCSIQ_B_CNTL),
-					 q_cntl);
-			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-			return (0);
-		}
-	} else if (int_halt_code == ASC_HALT_CHK_CONDITION) {
-
-		q_cntl |= QC_REQ_SENSE;
-
-		if ((asc_dvc->init_sdtr & target_id) != 0) {
-
-			asc_dvc->sdtr_done &= ~target_id;
-
-			sdtr_data = AscGetMCodeInitSDTRAtID(iop_base, tid_no);
-			q_cntl |= QC_MSG_OUT;
-			AscMsgOutSDTR(asc_dvc,
-				      asc_dvc->
-				      sdtr_period_tbl[(sdtr_data >> 4) &
-						      (uchar)(asc_dvc->
-							      max_sdtr_index -
-							      1)],
-				      (uchar)(sdtr_data & (uchar)
-					      ASC_SYN_MAX_OFFSET));
-		}
-
-		AscWriteLramByte(iop_base,
-				 (ushort)(halt_q_addr +
-					  (ushort)ASC_SCSIQ_B_CNTL), q_cntl);
-
-		tag_code = AscReadLramByte(iop_base,
-					   (ushort)(halt_q_addr + (ushort)
-						    ASC_SCSIQ_B_TAG_CODE));
-		tag_code &= 0xDC;
-		if ((asc_dvc->pci_fix_asyn_xfer & target_id)
-		    && !(asc_dvc->pci_fix_asyn_xfer_always & target_id)
-		    ) {
-
-			tag_code |= (ASC_TAG_FLAG_DISABLE_DISCONNECT
-				     | ASC_TAG_FLAG_DISABLE_ASYN_USE_SYN_FIX);
-
-		}
-		AscWriteLramByte(iop_base,
-				 (ushort)(halt_q_addr +
-					  (ushort)ASC_SCSIQ_B_TAG_CODE),
-				 tag_code);
-
-		q_status = AscReadLramByte(iop_base,
-					   (ushort)(halt_q_addr + (ushort)
-						    ASC_SCSIQ_B_STATUS));
-		q_status |= (QS_READY | QS_BUSY);
-		AscWriteLramByte(iop_base,
-				 (ushort)(halt_q_addr +
-					  (ushort)ASC_SCSIQ_B_STATUS),
-				 q_status);
-
-		scsi_busy = AscReadLramByte(iop_base, (ushort)ASCV_SCSIBUSY_B);
-		scsi_busy &= ~target_id;
-		AscWriteLramByte(iop_base, (ushort)ASCV_SCSIBUSY_B, scsi_busy);
-
-		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
-	} else if (int_halt_code == ASC_HALT_SDTR_REJECTED) {
-
-		AscMemWordCopyPtrFromLram(iop_base,
-					  ASCV_MSGOUT_BEG,
-					  (uchar *)&out_msg,
-					  sizeof(EXT_MSG) >> 1);
-
-		if ((out_msg.msg_type == EXTENDED_MESSAGE) &&
-		    (out_msg.msg_len == MS_SDTR_LEN) &&
-		    (out_msg.msg_req == EXTENDED_SDTR)) {
-
-			asc_dvc->init_sdtr &= ~target_id;
-			asc_dvc->sdtr_done &= ~target_id;
-			AscSetChipSDTR(iop_base, asyn_sdtr, tid_no);
-			boardp->sdtr_data[tid_no] = asyn_sdtr;
-		}
-		q_cntl &= ~QC_MSG_OUT;
-		AscWriteLramByte(iop_base,
-				 (ushort)(halt_q_addr +
-					  (ushort)ASC_SCSIQ_B_CNTL), q_cntl);
-		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
-	} else if (int_halt_code == ASC_HALT_SS_QUEUE_FULL) {
-
-		scsi_status = AscReadLramByte(iop_base,
-					      (ushort)((ushort)halt_q_addr +
-						       (ushort)
-						       ASC_SCSIQ_SCSI_STATUS));
-		cur_dvc_qng =
-		    AscReadLramByte(iop_base,
-				    (ushort)((ushort)ASC_QADR_BEG +
-					     (ushort)target_ix));
-		if ((cur_dvc_qng > 0) && (asc_dvc->cur_dvc_qng[tid_no] > 0)) {
-
-			scsi_busy = AscReadLramByte(iop_base,
-						    (ushort)ASCV_SCSIBUSY_B);
-			scsi_busy |= target_id;
-			AscWriteLramByte(iop_base,
-					 (ushort)ASCV_SCSIBUSY_B, scsi_busy);
-			asc_dvc->queue_full_or_busy |= target_id;
-
-			if (scsi_status == SAM_STAT_TASK_SET_FULL) {
-				if (cur_dvc_qng > ASC_MIN_TAGGED_CMD) {
-					cur_dvc_qng -= 1;
-					asc_dvc->max_dvc_qng[tid_no] =
-					    cur_dvc_qng;
-
-					AscWriteLramByte(iop_base,
-							 (ushort)((ushort)
-								  ASCV_MAX_DVC_QNG_BEG
-								  + (ushort)
-								  tid_no),
-							 cur_dvc_qng);
-
-					/*
-					 * Set the device queue depth to the
-					 * number of active requests when the
-					 * QUEUE FULL condition was encountered.
-					 */
-					boardp->queue_full |= target_id;
-					boardp->queue_full_cnt[tid_no] =
-					    cur_dvc_qng;
-				}
-			}
-		}
-		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
-	}
-#if CC_VERY_LONG_SG_LIST
-	else if (int_halt_code == ASC_HALT_HOST_COPY_SG_LIST_TO_RISC) {
-		uchar q_no;
-		ushort q_addr;
-		uchar sg_wk_q_no;
-		uchar first_sg_wk_q_no;
-		ASC_SCSI_Q *scsiq;	/* Ptr to driver request. */
-		ASC_SG_HEAD *sg_head;	/* Ptr to driver SG request. */
-		ASC_SG_LIST_Q scsi_sg_q;	/* Structure written to queue. */
-		ushort sg_list_dwords;
-		ushort sg_entry_cnt;
-		uchar next_qp;
-		int i;
-
-		q_no = AscReadLramByte(iop_base, (ushort)ASCV_REQ_SG_LIST_QP);
-		if (q_no == ASC_QLINK_END)
-			return 0;
-
-		q_addr = ASC_QNO_TO_QADDR(q_no);
-
-		/*
-		 * Convert the request's SRB pointer to a host ASC_SCSI_REQ
-		 * structure pointer using a macro provided by the driver.
-		 * The ASC_SCSI_REQ pointer provides a pointer to the
-		 * host ASC_SG_HEAD structure.
-		 */
-		/* Read request's SRB pointer. */
-		scsiq = (ASC_SCSI_Q *)
-		    ASC_SRB2SCSIQ(ASC_U32_TO_VADDR(AscReadLramDWord(iop_base,
-								    (ushort)
-								    (q_addr +
-								     ASC_SCSIQ_D_SRBPTR))));
-
-		/*
-		 * Get request's first and working SG queue.
-		 */
-		sg_wk_q_no = AscReadLramByte(iop_base,
-					     (ushort)(q_addr +
-						      ASC_SCSIQ_B_SG_WK_QP));
-
-		first_sg_wk_q_no = AscReadLramByte(iop_base,
-						   (ushort)(q_addr +
-							    ASC_SCSIQ_B_FIRST_SG_WK_QP));
-
-		/*
-		 * Reset request's working SG queue back to the
-		 * first SG queue.
-		 */
-		AscWriteLramByte(iop_base,
-				 (ushort)(q_addr +
-					  (ushort)ASC_SCSIQ_B_SG_WK_QP),
-				 first_sg_wk_q_no);
-
-		sg_head = scsiq->sg_head;
-
-		/*
-		 * Set sg_entry_cnt to the number of SG elements
-		 * that will be completed on this interrupt.
-		 *
-		 * Note: The allocated SG queues contain ASC_MAX_SG_LIST - 1
-		 * SG elements. The data_cnt and data_addr fields which
-		 * add 1 to the SG element capacity are not used when
-		 * restarting SG handling after a halt.
-		 */
-		if (scsiq->remain_sg_entry_cnt > (ASC_MAX_SG_LIST - 1)) {
-			sg_entry_cnt = ASC_MAX_SG_LIST - 1;
-
-			/*
-			 * Keep track of remaining number of SG elements that
-			 * will need to be handled on the next interrupt.
-			 */
-			scsiq->remain_sg_entry_cnt -= (ASC_MAX_SG_LIST - 1);
-		} else {
-			sg_entry_cnt = scsiq->remain_sg_entry_cnt;
-			scsiq->remain_sg_entry_cnt = 0;
-		}
-
-		/*
-		 * Copy SG elements into the list of allocated SG queues.
-		 *
-		 * Last index completed is saved in scsiq->next_sg_index.
-		 */
-		next_qp = first_sg_wk_q_no;
-		q_addr = ASC_QNO_TO_QADDR(next_qp);
-		scsi_sg_q.sg_head_qp = q_no;
-		scsi_sg_q.cntl = QCSG_SG_XFER_LIST;
-		for (i = 0; i < sg_head->queue_cnt; i++) {
-			scsi_sg_q.seq_no = i + 1;
-			if (sg_entry_cnt > ASC_SG_LIST_PER_Q) {
-				sg_list_dwords = (uchar)(ASC_SG_LIST_PER_Q * 2);
-				sg_entry_cnt -= ASC_SG_LIST_PER_Q;
-				/*
-				 * After very first SG queue RISC FW uses next
-				 * SG queue first element then checks sg_list_cnt
-				 * against zero and then decrements, so set
-				 * sg_list_cnt 1 less than number of SG elements
-				 * in each SG queue.
-				 */
-				scsi_sg_q.sg_list_cnt = ASC_SG_LIST_PER_Q - 1;
-				scsi_sg_q.sg_cur_list_cnt =
-				    ASC_SG_LIST_PER_Q - 1;
-			} else {
-				/*
-				 * This is the last SG queue in the list of
-				 * allocated SG queues. If there are more
-				 * SG elements than will fit in the allocated
-				 * queues, then set the QCSG_SG_XFER_MORE flag.
-				 */
-				if (scsiq->remain_sg_entry_cnt != 0) {
-					scsi_sg_q.cntl |= QCSG_SG_XFER_MORE;
-				} else {
-					scsi_sg_q.cntl |= QCSG_SG_XFER_END;
-				}
-				/* equals sg_entry_cnt * 2 */
-				sg_list_dwords = sg_entry_cnt << 1;
-				scsi_sg_q.sg_list_cnt = sg_entry_cnt - 1;
-				scsi_sg_q.sg_cur_list_cnt = sg_entry_cnt - 1;
-				sg_entry_cnt = 0;
-			}
-
-			scsi_sg_q.q_no = next_qp;
-			AscMemWordCopyPtrToLram(iop_base,
-						q_addr + ASC_SCSIQ_SGHD_CPY_BEG,
-						(uchar *)&scsi_sg_q,
-						sizeof(ASC_SG_LIST_Q) >> 1);
-
-			AscMemDWordCopyPtrToLram(iop_base,
-						 q_addr + ASC_SGQ_LIST_BEG,
-						 (uchar *)&sg_head->
-						 sg_list[scsiq->next_sg_index],
-						 sg_list_dwords);
-
-			scsiq->next_sg_index += ASC_SG_LIST_PER_Q;
-
-			/*
-			 * If the just completed SG queue contained the
-			 * last SG element, then no more SG queues need
-			 * to be written.
-			 */
-			if (scsi_sg_q.cntl & QCSG_SG_XFER_END) {
-				break;
-			}
-
-			next_qp = AscReadLramByte(iop_base,
-						  (ushort)(q_addr +
-							   ASC_SCSIQ_B_FWD));
-			q_addr = ASC_QNO_TO_QADDR(next_qp);
-		}
-
-		/*
-		 * Clear the halt condition so the RISC will be restarted
-		 * after the return.
-		 */
-		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-		return (0);
-	}
-#endif /* CC_VERY_LONG_SG_LIST */
-	return (0);
-}
-
-static uchar
-_AscCopyLramScsiDoneQ(PortAddr iop_base,
-		      ushort q_addr,
-		      ASC_QDONE_INFO *scsiq, ASC_DCNT max_dma_count)
-{
-	ushort _val;
-	uchar sg_queue_cnt;
-
-	DvcGetQinfo(iop_base,
-		    q_addr + ASC_SCSIQ_DONE_INFO_BEG,
-		    (uchar *)scsiq,
-		    (sizeof(ASC_SCSIQ_2) + sizeof(ASC_SCSIQ_3)) / 2);
-
-	_val = AscReadLramWord(iop_base,
-			       (ushort)(q_addr + (ushort)ASC_SCSIQ_B_STATUS));
-	scsiq->q_status = (uchar)_val;
-	scsiq->q_no = (uchar)(_val >> 8);
-	_val = AscReadLramWord(iop_base,
-			       (ushort)(q_addr + (ushort)ASC_SCSIQ_B_CNTL));
-	scsiq->cntl = (uchar)_val;
-	sg_queue_cnt = (uchar)(_val >> 8);
-	_val = AscReadLramWord(iop_base,
-			       (ushort)(q_addr +
-					(ushort)ASC_SCSIQ_B_SENSE_LEN));
-	scsiq->sense_len = (uchar)_val;
-	scsiq->extra_bytes = (uchar)(_val >> 8);
-
-	/*
-	 * Read high word of remain bytes from alternate location.
-	 */
-	scsiq->remain_bytes = (((ADV_DCNT)AscReadLramWord(iop_base,
-							  (ushort)(q_addr +
-								   (ushort)
-								   ASC_SCSIQ_W_ALT_DC1)))
-			       << 16);
-	/*
-	 * Read low word of remain bytes from original location.
-	 */
-	scsiq->remain_bytes += AscReadLramWord(iop_base,
-					       (ushort)(q_addr + (ushort)
-							ASC_SCSIQ_DW_REMAIN_XFER_CNT));
-
-	scsiq->remain_bytes &= max_dma_count;
-	return (sg_queue_cnt);
-}
-
-static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
-{
-	uchar next_qp;
-	uchar n_q_used;
-	uchar sg_list_qp;
-	uchar sg_queue_cnt;
-	uchar q_cnt;
-	uchar done_q_tail;
-	uchar tid_no;
-	ASC_SCSI_BIT_ID_TYPE scsi_busy;
-	ASC_SCSI_BIT_ID_TYPE target_id;
-	PortAddr iop_base;
-	ushort q_addr;
-	ushort sg_q_addr;
-	uchar cur_target_qng;
-	ASC_QDONE_INFO scsiq_buf;
-	ASC_QDONE_INFO *scsiq;
-	int false_overrun;
-
-	iop_base = asc_dvc->iop_base;
-	n_q_used = 1;
-	scsiq = (ASC_QDONE_INFO *)&scsiq_buf;
-	done_q_tail = (uchar)AscGetVarDoneQTail(iop_base);
-	q_addr = ASC_QNO_TO_QADDR(done_q_tail);
-	next_qp = AscReadLramByte(iop_base,
-				  (ushort)(q_addr + (ushort)ASC_SCSIQ_B_FWD));
-	if (next_qp != ASC_QLINK_END) {
-		AscPutVarDoneQTail(iop_base, next_qp);
-		q_addr = ASC_QNO_TO_QADDR(next_qp);
-		sg_queue_cnt = _AscCopyLramScsiDoneQ(iop_base, q_addr, scsiq,
-						     asc_dvc->max_dma_count);
-		AscWriteLramByte(iop_base,
-				 (ushort)(q_addr +
-					  (ushort)ASC_SCSIQ_B_STATUS),
-				 (uchar)(scsiq->
-					 q_status & (uchar)~(QS_READY |
-							     QS_ABORTED)));
-		tid_no = ASC_TIX_TO_TID(scsiq->d2.target_ix);
-		target_id = ASC_TIX_TO_TARGET_ID(scsiq->d2.target_ix);
-		if ((scsiq->cntl & QC_SG_HEAD) != 0) {
-			sg_q_addr = q_addr;
-			sg_list_qp = next_qp;
-			for (q_cnt = 0; q_cnt < sg_queue_cnt; q_cnt++) {
-				sg_list_qp = AscReadLramByte(iop_base,
-							     (ushort)(sg_q_addr
-								      + (ushort)
-								      ASC_SCSIQ_B_FWD));
-				sg_q_addr = ASC_QNO_TO_QADDR(sg_list_qp);
-				if (sg_list_qp == ASC_QLINK_END) {
-					AscSetLibErrorCode(asc_dvc,
-							   ASCQ_ERR_SG_Q_LINKS);
-					scsiq->d3.done_stat = QD_WITH_ERROR;
-					scsiq->d3.host_stat =
-					    QHSTA_D_QDONE_SG_LIST_CORRUPTED;
-					goto FATAL_ERR_QDONE;
-				}
-				AscWriteLramByte(iop_base,
-						 (ushort)(sg_q_addr + (ushort)
-							  ASC_SCSIQ_B_STATUS),
-						 QS_FREE);
-			}
-			n_q_used = sg_queue_cnt + 1;
-			AscPutVarDoneQTail(iop_base, sg_list_qp);
-		}
-		if (asc_dvc->queue_full_or_busy & target_id) {
-			cur_target_qng = AscReadLramByte(iop_base,
-							 (ushort)((ushort)
-								  ASC_QADR_BEG
-								  + (ushort)
-								  scsiq->d2.
-								  target_ix));
-			if (cur_target_qng < asc_dvc->max_dvc_qng[tid_no]) {
-				scsi_busy = AscReadLramByte(iop_base, (ushort)
-							    ASCV_SCSIBUSY_B);
-				scsi_busy &= ~target_id;
-				AscWriteLramByte(iop_base,
-						 (ushort)ASCV_SCSIBUSY_B,
-						 scsi_busy);
-				asc_dvc->queue_full_or_busy &= ~target_id;
-			}
-		}
-		if (asc_dvc->cur_total_qng >= n_q_used) {
-			asc_dvc->cur_total_qng -= n_q_used;
-			if (asc_dvc->cur_dvc_qng[tid_no] != 0) {
-				asc_dvc->cur_dvc_qng[tid_no]--;
-			}
-		} else {
-			AscSetLibErrorCode(asc_dvc, ASCQ_ERR_CUR_QNG);
-			scsiq->d3.done_stat = QD_WITH_ERROR;
-			goto FATAL_ERR_QDONE;
-		}
-		if ((scsiq->d2.srb_ptr == 0UL) ||
-		    ((scsiq->q_status & QS_ABORTED) != 0)) {
-			return (0x11);
-		} else if (scsiq->q_status == QS_DONE) {
-			false_overrun = FALSE;
-			if (scsiq->extra_bytes != 0) {
-				scsiq->remain_bytes +=
-				    (ADV_DCNT)scsiq->extra_bytes;
-			}
-			if (scsiq->d3.done_stat == QD_WITH_ERROR) {
-				if (scsiq->d3.host_stat ==
-				    QHSTA_M_DATA_OVER_RUN) {
-					if ((scsiq->
-					     cntl & (QC_DATA_IN | QC_DATA_OUT))
-					    == 0) {
-						scsiq->d3.done_stat =
-						    QD_NO_ERROR;
-						scsiq->d3.host_stat =
-						    QHSTA_NO_ERROR;
-					} else if (false_overrun) {
-						scsiq->d3.done_stat =
-						    QD_NO_ERROR;
-						scsiq->d3.host_stat =
-						    QHSTA_NO_ERROR;
-					}
-				} else if (scsiq->d3.host_stat ==
-					   QHSTA_M_HUNG_REQ_SCSI_BUS_RESET) {
-					AscStopChip(iop_base);
-					AscSetChipControl(iop_base,
-							  (uchar)(CC_SCSI_RESET
-								  | CC_HALT));
-					udelay(60);
-					AscSetChipControl(iop_base, CC_HALT);
-					AscSetChipStatus(iop_base,
-							 CIW_CLR_SCSI_RESET_INT);
-					AscSetChipStatus(iop_base, 0);
-					AscSetChipControl(iop_base, 0);
-				}
-			}
-			if ((scsiq->cntl & QC_NO_CALLBACK) == 0) {
-				asc_isr_callback(asc_dvc, scsiq);
-			} else {
-				if ((AscReadLramByte(iop_base,
-						     (ushort)(q_addr + (ushort)
-							      ASC_SCSIQ_CDB_BEG))
-				     == START_STOP)) {
-					asc_dvc->unit_not_ready &= ~target_id;
-					if (scsiq->d3.done_stat != QD_NO_ERROR) {
-						asc_dvc->start_motor &=
-						    ~target_id;
-					}
-				}
-			}
-			return (1);
-		} else {
-			AscSetLibErrorCode(asc_dvc, ASCQ_ERR_Q_STATUS);
- FATAL_ERR_QDONE:
-			if ((scsiq->cntl & QC_NO_CALLBACK) == 0) {
-				asc_isr_callback(asc_dvc, scsiq);
-			}
-			return (0x80);
-		}
-	}
-	return (0);
-}
-
-static int AscISR(ASC_DVC_VAR *asc_dvc)
-{
-	ASC_CS_TYPE chipstat;
-	PortAddr iop_base;
-	ushort saved_ram_addr;
-	uchar ctrl_reg;
-	uchar saved_ctrl_reg;
-	int int_pending;
-	int status;
-	uchar host_flag;
-
-	iop_base = asc_dvc->iop_base;
-	int_pending = FALSE;
-
-	if (AscIsIntPending(iop_base) == 0) {
-		return int_pending;
-	}
-
-	if ((asc_dvc->init_state & ASC_INIT_STATE_END_LOAD_MC) == 0) {
-		return (ERR);
-	}
-	if (asc_dvc->in_critical_cnt != 0) {
-		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_ISR_ON_CRITICAL);
-		return (ERR);
-	}
-	if (asc_dvc->is_in_int) {
-		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_ISR_RE_ENTRY);
-		return (ERR);
-	}
-	asc_dvc->is_in_int = TRUE;
-	ctrl_reg = AscGetChipControl(iop_base);
-	saved_ctrl_reg = ctrl_reg & (~(CC_SCSI_RESET | CC_CHIP_RESET |
-				       CC_SINGLE_STEP | CC_DIAG | CC_TEST));
-	chipstat = AscGetChipStatus(iop_base);
-	if (chipstat & CSW_SCSI_RESET_LATCH) {
-		if (!(asc_dvc->bus_type & (ASC_IS_VL | ASC_IS_EISA))) {
-			int i = 10;
-			int_pending = TRUE;
-			asc_dvc->sdtr_done = 0;
-			saved_ctrl_reg &= (uchar)(~CC_HALT);
-			while ((AscGetChipStatus(iop_base) &
-				CSW_SCSI_RESET_ACTIVE) && (i-- > 0)) {
-				mdelay(100);
-			}
-			AscSetChipControl(iop_base, (CC_CHIP_RESET | CC_HALT));
-			AscSetChipControl(iop_base, CC_HALT);
-			AscSetChipStatus(iop_base, CIW_CLR_SCSI_RESET_INT);
-			AscSetChipStatus(iop_base, 0);
-			chipstat = AscGetChipStatus(iop_base);
-		}
-	}
-	saved_ram_addr = AscGetChipLramAddr(iop_base);
-	host_flag = AscReadLramByte(iop_base,
-				    ASCV_HOST_FLAG_B) &
-	    (uchar)(~ASC_HOST_FLAG_IN_ISR);
-	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B,
-			 (uchar)(host_flag | (uchar)ASC_HOST_FLAG_IN_ISR));
-	if ((chipstat & CSW_INT_PENDING)
-	    || (int_pending)
-	    ) {
-		AscAckInterrupt(iop_base);
-		int_pending = TRUE;
-		if ((chipstat & CSW_HALTED) && (ctrl_reg & CC_SINGLE_STEP)) {
-			if (AscIsrChipHalted(asc_dvc) == ERR) {
-				goto ISR_REPORT_QDONE_FATAL_ERROR;
-			} else {
-				saved_ctrl_reg &= (uchar)(~CC_HALT);
-			}
-		} else {
- ISR_REPORT_QDONE_FATAL_ERROR:
-			if ((asc_dvc->dvc_cntl & ASC_CNTL_INT_MULTI_Q) != 0) {
-				while (((status =
-					 AscIsrQDone(asc_dvc)) & 0x01) != 0) {
-				}
-			} else {
-				do {
-					if ((status =
-					     AscIsrQDone(asc_dvc)) == 1) {
-						break;
-					}
-				} while (status == 0x11);
-			}
-			if ((status & 0x80) != 0)
-				int_pending = ERR;
-		}
-	}
-	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B, host_flag);
-	AscSetChipLramAddr(iop_base, saved_ram_addr);
-	AscSetChipControl(iop_base, saved_ctrl_reg);
-	asc_dvc->is_in_int = FALSE;
-	return (int_pending);
-}
-
 /* Microcode buffer is kept after initialization for error recovery. */
 static uchar _asc_mcode_buf[] = {
 	0x01, 0x03, 0x01, 0x19, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -7302,1977 +5078,9 @@ static uchar _asc_mcode_buf[] = {
 	0xF8, 0x88, 0x11, 0x23, 0xA1, 0x01, 0x04, 0x23, 0xA0, 0x01, 0xE6, 0x84,
 };
 
-static ushort _asc_mcode_size = sizeof(_asc_mcode_buf);
+static unsigned short _asc_mcode_size = sizeof(_asc_mcode_buf);
 static ADV_DCNT _asc_mcode_chksum = 0x012C453FUL;
 
-#define ASC_SYN_OFFSET_ONE_DISABLE_LIST  16
-static uchar _syn_offset_one_disable_cmd[ASC_SYN_OFFSET_ONE_DISABLE_LIST] = {
-	INQUIRY,
-	REQUEST_SENSE,
-	READ_CAPACITY,
-	READ_TOC,
-	MODE_SELECT,
-	MODE_SENSE,
-	MODE_SELECT_10,
-	MODE_SENSE_10,
-	0xFF,
-	0xFF,
-	0xFF,
-	0xFF,
-	0xFF,
-	0xFF,
-	0xFF,
-	0xFF
-};
-
-static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
-{
-	PortAddr iop_base;
-	int sta;
-	int n_q_required;
-	int disable_syn_offset_one_fix;
-	int i;
-	ASC_PADDR addr;
-	ushort sg_entry_cnt = 0;
-	ushort sg_entry_cnt_minus_one = 0;
-	uchar target_ix;
-	uchar tid_no;
-	uchar sdtr_data;
-	uchar extra_bytes;
-	uchar scsi_cmd;
-	uchar disable_cmd;
-	ASC_SG_HEAD *sg_head;
-	ASC_DCNT data_cnt;
-
-	iop_base = asc_dvc->iop_base;
-	sg_head = scsiq->sg_head;
-	if (asc_dvc->err_code != 0)
-		return (ERR);
-	scsiq->q1.q_no = 0;
-	if ((scsiq->q2.tag_code & ASC_TAG_FLAG_EXTRA_BYTES) == 0) {
-		scsiq->q1.extra_bytes = 0;
-	}
-	sta = 0;
-	target_ix = scsiq->q2.target_ix;
-	tid_no = ASC_TIX_TO_TID(target_ix);
-	n_q_required = 1;
-	if (scsiq->cdbptr[0] == REQUEST_SENSE) {
-		if ((asc_dvc->init_sdtr & scsiq->q1.target_id) != 0) {
-			asc_dvc->sdtr_done &= ~scsiq->q1.target_id;
-			sdtr_data = AscGetMCodeInitSDTRAtID(iop_base, tid_no);
-			AscMsgOutSDTR(asc_dvc,
-				      asc_dvc->
-				      sdtr_period_tbl[(sdtr_data >> 4) &
-						      (uchar)(asc_dvc->
-							      max_sdtr_index -
-							      1)],
-				      (uchar)(sdtr_data & (uchar)
-					      ASC_SYN_MAX_OFFSET));
-			scsiq->q1.cntl |= (QC_MSG_OUT | QC_URGENT);
-		}
-	}
-	if (asc_dvc->in_critical_cnt != 0) {
-		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_CRITICAL_RE_ENTRY);
-		return (ERR);
-	}
-	asc_dvc->in_critical_cnt++;
-	if ((scsiq->q1.cntl & QC_SG_HEAD) != 0) {
-		if ((sg_entry_cnt = sg_head->entry_cnt) == 0) {
-			asc_dvc->in_critical_cnt--;
-			return (ERR);
-		}
-#if !CC_VERY_LONG_SG_LIST
-		if (sg_entry_cnt > ASC_MAX_SG_LIST) {
-			asc_dvc->in_critical_cnt--;
-			return (ERR);
-		}
-#endif /* !CC_VERY_LONG_SG_LIST */
-		if (sg_entry_cnt == 1) {
-			scsiq->q1.data_addr =
-			    (ADV_PADDR)sg_head->sg_list[0].addr;
-			scsiq->q1.data_cnt =
-			    (ADV_DCNT)sg_head->sg_list[0].bytes;
-			scsiq->q1.cntl &= ~(QC_SG_HEAD | QC_SG_SWAP_QUEUE);
-		}
-		sg_entry_cnt_minus_one = sg_entry_cnt - 1;
-	}
-	scsi_cmd = scsiq->cdbptr[0];
-	disable_syn_offset_one_fix = FALSE;
-	if ((asc_dvc->pci_fix_asyn_xfer & scsiq->q1.target_id) &&
-	    !(asc_dvc->pci_fix_asyn_xfer_always & scsiq->q1.target_id)) {
-		if (scsiq->q1.cntl & QC_SG_HEAD) {
-			data_cnt = 0;
-			for (i = 0; i < sg_entry_cnt; i++) {
-				data_cnt +=
-				    (ADV_DCNT)le32_to_cpu(sg_head->sg_list[i].
-							  bytes);
-			}
-		} else {
-			data_cnt = le32_to_cpu(scsiq->q1.data_cnt);
-		}
-		if (data_cnt != 0UL) {
-			if (data_cnt < 512UL) {
-				disable_syn_offset_one_fix = TRUE;
-			} else {
-				for (i = 0; i < ASC_SYN_OFFSET_ONE_DISABLE_LIST;
-				     i++) {
-					disable_cmd =
-					    _syn_offset_one_disable_cmd[i];
-					if (disable_cmd == 0xFF) {
-						break;
-					}
-					if (scsi_cmd == disable_cmd) {
-						disable_syn_offset_one_fix =
-						    TRUE;
-						break;
-					}
-				}
-			}
-		}
-	}
-	if (disable_syn_offset_one_fix) {
-		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
-		scsiq->q2.tag_code |= (ASC_TAG_FLAG_DISABLE_ASYN_USE_SYN_FIX |
-				       ASC_TAG_FLAG_DISABLE_DISCONNECT);
-	} else {
-		scsiq->q2.tag_code &= 0x27;
-	}
-	if ((scsiq->q1.cntl & QC_SG_HEAD) != 0) {
-		if (asc_dvc->bug_fix_cntl) {
-			if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_IF_NOT_DWB) {
-				if ((scsi_cmd == READ_6) ||
-				    (scsi_cmd == READ_10)) {
-					addr =
-					    (ADV_PADDR)le32_to_cpu(sg_head->
-								   sg_list
-								   [sg_entry_cnt_minus_one].
-								   addr) +
-					    (ADV_DCNT)le32_to_cpu(sg_head->
-								  sg_list
-								  [sg_entry_cnt_minus_one].
-								  bytes);
-					extra_bytes =
-					    (uchar)((ushort)addr & 0x0003);
-					if ((extra_bytes != 0)
-					    &&
-					    ((scsiq->q2.
-					      tag_code &
-					      ASC_TAG_FLAG_EXTRA_BYTES)
-					     == 0)) {
-						scsiq->q2.tag_code |=
-						    ASC_TAG_FLAG_EXTRA_BYTES;
-						scsiq->q1.extra_bytes =
-						    extra_bytes;
-						data_cnt =
-						    le32_to_cpu(sg_head->
-								sg_list
-								[sg_entry_cnt_minus_one].
-								bytes);
-						data_cnt -=
-						    (ASC_DCNT) extra_bytes;
-						sg_head->
-						    sg_list
-						    [sg_entry_cnt_minus_one].
-						    bytes =
-						    cpu_to_le32(data_cnt);
-					}
-				}
-			}
-		}
-		sg_head->entry_to_copy = sg_head->entry_cnt;
-#if CC_VERY_LONG_SG_LIST
-		/*
-		 * Set the sg_entry_cnt to the maximum possible. The rest of
-		 * the SG elements will be copied when the RISC completes the
-		 * SG elements that fit and halts.
-		 */
-		if (sg_entry_cnt > ASC_MAX_SG_LIST) {
-			sg_entry_cnt = ASC_MAX_SG_LIST;
-		}
-#endif /* CC_VERY_LONG_SG_LIST */
-		n_q_required = AscSgListToQueue(sg_entry_cnt);
-		if ((AscGetNumOfFreeQueue(asc_dvc, target_ix, n_q_required) >=
-		     (uint) n_q_required)
-		    || ((scsiq->q1.cntl & QC_URGENT) != 0)) {
-			if ((sta =
-			     AscSendScsiQueue(asc_dvc, scsiq,
-					      n_q_required)) == 1) {
-				asc_dvc->in_critical_cnt--;
-				return (sta);
-			}
-		}
-	} else {
-		if (asc_dvc->bug_fix_cntl) {
-			if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_IF_NOT_DWB) {
-				if ((scsi_cmd == READ_6) ||
-				    (scsi_cmd == READ_10)) {
-					addr =
-					    le32_to_cpu(scsiq->q1.data_addr) +
-					    le32_to_cpu(scsiq->q1.data_cnt);
-					extra_bytes =
-					    (uchar)((ushort)addr & 0x0003);
-					if ((extra_bytes != 0)
-					    &&
-					    ((scsiq->q2.
-					      tag_code &
-					      ASC_TAG_FLAG_EXTRA_BYTES)
-					     == 0)) {
-						data_cnt =
-						    le32_to_cpu(scsiq->q1.
-								data_cnt);
-						if (((ushort)data_cnt & 0x01FF)
-						    == 0) {
-							scsiq->q2.tag_code |=
-							    ASC_TAG_FLAG_EXTRA_BYTES;
-							data_cnt -= (ASC_DCNT)
-							    extra_bytes;
-							scsiq->q1.data_cnt =
-							    cpu_to_le32
-							    (data_cnt);
-							scsiq->q1.extra_bytes =
-							    extra_bytes;
-						}
-					}
-				}
-			}
-		}
-		n_q_required = 1;
-		if ((AscGetNumOfFreeQueue(asc_dvc, target_ix, 1) >= 1) ||
-		    ((scsiq->q1.cntl & QC_URGENT) != 0)) {
-			if ((sta = AscSendScsiQueue(asc_dvc, scsiq,
-						    n_q_required)) == 1) {
-				asc_dvc->in_critical_cnt--;
-				return (sta);
-			}
-		}
-	}
-	asc_dvc->in_critical_cnt--;
-	return (sta);
-}
-
-static int
-AscSendScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar n_q_required)
-{
-	PortAddr iop_base;
-	uchar free_q_head;
-	uchar next_qp;
-	uchar tid_no;
-	uchar target_ix;
-	int sta;
-
-	iop_base = asc_dvc->iop_base;
-	target_ix = scsiq->q2.target_ix;
-	tid_no = ASC_TIX_TO_TID(target_ix);
-	sta = 0;
-	free_q_head = (uchar)AscGetVarFreeQHead(iop_base);
-	if (n_q_required > 1) {
-		next_qp = AscAllocMultipleFreeQueue(iop_base, free_q_head,
-						    (uchar)n_q_required);
-		if (next_qp != ASC_QLINK_END) {
-			asc_dvc->last_q_shortage = 0;
-			scsiq->sg_head->queue_cnt = n_q_required - 1;
-			scsiq->q1.q_no = free_q_head;
-			sta = AscPutReadySgListQueue(asc_dvc, scsiq,
-						     free_q_head);
-		}
-	} else if (n_q_required == 1) {
-		next_qp = AscAllocFreeQueue(iop_base, free_q_head);
-		if (next_qp != ASC_QLINK_END) {
-			scsiq->q1.q_no = free_q_head;
-			sta = AscPutReadyQueue(asc_dvc, scsiq, free_q_head);
-		}
-	}
-	if (sta == 1) {
-		AscPutVarFreeQHead(iop_base, next_qp);
-		asc_dvc->cur_total_qng += (uchar)(n_q_required);
-		asc_dvc->cur_dvc_qng[tid_no]++;
-	}
-	return sta;
-}
-
-static int AscSgListToQueue(int sg_list)
-{
-	int n_sg_list_qs;
-
-	n_sg_list_qs = ((sg_list - 1) / ASC_SG_LIST_PER_Q);
-	if (((sg_list - 1) % ASC_SG_LIST_PER_Q) != 0)
-		n_sg_list_qs++;
-	return (n_sg_list_qs + 1);
-}
-
-static uint
-AscGetNumOfFreeQueue(ASC_DVC_VAR *asc_dvc, uchar target_ix, uchar n_qs)
-{
-	uint cur_used_qs;
-	uint cur_free_qs;
-	ASC_SCSI_BIT_ID_TYPE target_id;
-	uchar tid_no;
-
-	target_id = ASC_TIX_TO_TARGET_ID(target_ix);
-	tid_no = ASC_TIX_TO_TID(target_ix);
-	if ((asc_dvc->unit_not_ready & target_id) ||
-	    (asc_dvc->queue_full_or_busy & target_id)) {
-		return (0);
-	}
-	if (n_qs == 1) {
-		cur_used_qs = (uint) asc_dvc->cur_total_qng +
-		    (uint) asc_dvc->last_q_shortage + (uint) ASC_MIN_FREE_Q;
-	} else {
-		cur_used_qs = (uint) asc_dvc->cur_total_qng +
-		    (uint) ASC_MIN_FREE_Q;
-	}
-	if ((uint) (cur_used_qs + n_qs) <= (uint) asc_dvc->max_total_qng) {
-		cur_free_qs = (uint) asc_dvc->max_total_qng - cur_used_qs;
-		if (asc_dvc->cur_dvc_qng[tid_no] >=
-		    asc_dvc->max_dvc_qng[tid_no]) {
-			return (0);
-		}
-		return (cur_free_qs);
-	}
-	if (n_qs > 1) {
-		if ((n_qs > asc_dvc->last_q_shortage)
-		    && (n_qs <= (asc_dvc->max_total_qng - ASC_MIN_FREE_Q))) {
-			asc_dvc->last_q_shortage = n_qs;
-		}
-	}
-	return (0);
-}
-
-static int AscPutReadyQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
-{
-	ushort q_addr;
-	uchar tid_no;
-	uchar sdtr_data;
-	uchar syn_period_ix;
-	uchar syn_offset;
-	PortAddr iop_base;
-
-	iop_base = asc_dvc->iop_base;
-	if (((asc_dvc->init_sdtr & scsiq->q1.target_id) != 0) &&
-	    ((asc_dvc->sdtr_done & scsiq->q1.target_id) == 0)) {
-		tid_no = ASC_TIX_TO_TID(scsiq->q2.target_ix);
-		sdtr_data = AscGetMCodeInitSDTRAtID(iop_base, tid_no);
-		syn_period_ix =
-		    (sdtr_data >> 4) & (asc_dvc->max_sdtr_index - 1);
-		syn_offset = sdtr_data & ASC_SYN_MAX_OFFSET;
-		AscMsgOutSDTR(asc_dvc,
-			      asc_dvc->sdtr_period_tbl[syn_period_ix],
-			      syn_offset);
-		scsiq->q1.cntl |= QC_MSG_OUT;
-	}
-	q_addr = ASC_QNO_TO_QADDR(q_no);
-	if ((scsiq->q1.target_id & asc_dvc->use_tagged_qng) == 0) {
-		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
-	}
-	scsiq->q1.status = QS_FREE;
-	AscMemWordCopyPtrToLram(iop_base,
-				q_addr + ASC_SCSIQ_CDB_BEG,
-				(uchar *)scsiq->cdbptr, scsiq->q2.cdb_len >> 1);
-
-	DvcPutScsiQ(iop_base,
-		    q_addr + ASC_SCSIQ_CPY_BEG,
-		    (uchar *)&scsiq->q1.cntl,
-		    ((sizeof(ASC_SCSIQ_1) + sizeof(ASC_SCSIQ_2)) / 2) - 1);
-	AscWriteLramWord(iop_base,
-			 (ushort)(q_addr + (ushort)ASC_SCSIQ_B_STATUS),
-			 (ushort)(((ushort)scsiq->q1.
-				   q_no << 8) | (ushort)QS_READY));
-	return (1);
-}
-
-static int
-AscPutReadySgListQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
-{
-	int sta;
-	int i;
-	ASC_SG_HEAD *sg_head;
-	ASC_SG_LIST_Q scsi_sg_q;
-	ASC_DCNT saved_data_addr;
-	ASC_DCNT saved_data_cnt;
-	PortAddr iop_base;
-	ushort sg_list_dwords;
-	ushort sg_index;
-	ushort sg_entry_cnt;
-	ushort q_addr;
-	uchar next_qp;
-
-	iop_base = asc_dvc->iop_base;
-	sg_head = scsiq->sg_head;
-	saved_data_addr = scsiq->q1.data_addr;
-	saved_data_cnt = scsiq->q1.data_cnt;
-	scsiq->q1.data_addr = (ASC_PADDR) sg_head->sg_list[0].addr;
-	scsiq->q1.data_cnt = (ASC_DCNT) sg_head->sg_list[0].bytes;
-#if CC_VERY_LONG_SG_LIST
-	/*
-	 * If sg_head->entry_cnt is greater than ASC_MAX_SG_LIST
-	 * then not all SG elements will fit in the allocated queues.
-	 * The rest of the SG elements will be copied when the RISC
-	 * completes the SG elements that fit and halts.
-	 */
-	if (sg_head->entry_cnt > ASC_MAX_SG_LIST) {
-		/*
-		 * Set sg_entry_cnt to be the number of SG elements that
-		 * will fit in the allocated SG queues. It is minus 1, because
-		 * the first SG element is handled above. ASC_MAX_SG_LIST is
-		 * already inflated by 1 to account for this. For example it
-		 * may be 50 which is 1 + 7 queues * 7 SG elements.
-		 */
-		sg_entry_cnt = ASC_MAX_SG_LIST - 1;
-
-		/*
-		 * Keep track of remaining number of SG elements that will
-		 * need to be handled from a_isr.c.
-		 */
-		scsiq->remain_sg_entry_cnt =
-		    sg_head->entry_cnt - ASC_MAX_SG_LIST;
-	} else {
-#endif /* CC_VERY_LONG_SG_LIST */
-		/*
-		 * Set sg_entry_cnt to be the number of SG elements that
-		 * will fit in the allocated SG queues. It is minus 1, because
-		 * the first SG element is handled above.
-		 */
-		sg_entry_cnt = sg_head->entry_cnt - 1;
-#if CC_VERY_LONG_SG_LIST
-	}
-#endif /* CC_VERY_LONG_SG_LIST */
-	if (sg_entry_cnt != 0) {
-		scsiq->q1.cntl |= QC_SG_HEAD;
-		q_addr = ASC_QNO_TO_QADDR(q_no);
-		sg_index = 1;
-		scsiq->q1.sg_queue_cnt = sg_head->queue_cnt;
-		scsi_sg_q.sg_head_qp = q_no;
-		scsi_sg_q.cntl = QCSG_SG_XFER_LIST;
-		for (i = 0; i < sg_head->queue_cnt; i++) {
-			scsi_sg_q.seq_no = i + 1;
-			if (sg_entry_cnt > ASC_SG_LIST_PER_Q) {
-				sg_list_dwords = (uchar)(ASC_SG_LIST_PER_Q * 2);
-				sg_entry_cnt -= ASC_SG_LIST_PER_Q;
-				if (i == 0) {
-					scsi_sg_q.sg_list_cnt =
-					    ASC_SG_LIST_PER_Q;
-					scsi_sg_q.sg_cur_list_cnt =
-					    ASC_SG_LIST_PER_Q;
-				} else {
-					scsi_sg_q.sg_list_cnt =
-					    ASC_SG_LIST_PER_Q - 1;
-					scsi_sg_q.sg_cur_list_cnt =
-					    ASC_SG_LIST_PER_Q - 1;
-				}
-			} else {
-#if CC_VERY_LONG_SG_LIST
-				/*
-				 * This is the last SG queue in the list of
-				 * allocated SG queues. If there are more
-				 * SG elements than will fit in the allocated
-				 * queues, then set the QCSG_SG_XFER_MORE flag.
-				 */
-				if (sg_head->entry_cnt > ASC_MAX_SG_LIST) {
-					scsi_sg_q.cntl |= QCSG_SG_XFER_MORE;
-				} else {
-#endif /* CC_VERY_LONG_SG_LIST */
-					scsi_sg_q.cntl |= QCSG_SG_XFER_END;
-#if CC_VERY_LONG_SG_LIST
-				}
-#endif /* CC_VERY_LONG_SG_LIST */
-				sg_list_dwords = sg_entry_cnt << 1;
-				if (i == 0) {
-					scsi_sg_q.sg_list_cnt = sg_entry_cnt;
-					scsi_sg_q.sg_cur_list_cnt =
-					    sg_entry_cnt;
-				} else {
-					scsi_sg_q.sg_list_cnt =
-					    sg_entry_cnt - 1;
-					scsi_sg_q.sg_cur_list_cnt =
-					    sg_entry_cnt - 1;
-				}
-				sg_entry_cnt = 0;
-			}
-			next_qp = AscReadLramByte(iop_base,
-						  (ushort)(q_addr +
-							   ASC_SCSIQ_B_FWD));
-			scsi_sg_q.q_no = next_qp;
-			q_addr = ASC_QNO_TO_QADDR(next_qp);
-			AscMemWordCopyPtrToLram(iop_base,
-						q_addr + ASC_SCSIQ_SGHD_CPY_BEG,
-						(uchar *)&scsi_sg_q,
-						sizeof(ASC_SG_LIST_Q) >> 1);
-			AscMemDWordCopyPtrToLram(iop_base,
-						 q_addr + ASC_SGQ_LIST_BEG,
-						 (uchar *)&sg_head->
-						 sg_list[sg_index],
-						 sg_list_dwords);
-			sg_index += ASC_SG_LIST_PER_Q;
-			scsiq->next_sg_index = sg_index;
-		}
-	} else {
-		scsiq->q1.cntl &= ~QC_SG_HEAD;
-	}
-	sta = AscPutReadyQueue(asc_dvc, scsiq, q_no);
-	scsiq->q1.data_addr = saved_data_addr;
-	scsiq->q1.data_cnt = saved_data_cnt;
-	return (sta);
-}
-
-static int
-AscSetRunChipSynRegAtID(PortAddr iop_base, uchar tid_no, uchar sdtr_data)
-{
-	int sta = FALSE;
-
-	if (AscHostReqRiscHalt(iop_base)) {
-		sta = AscSetChipSynRegAtID(iop_base, tid_no, sdtr_data);
-		AscStartChip(iop_base);
-		return (sta);
-	}
-	return (sta);
-}
-
-static int AscSetChipSynRegAtID(PortAddr iop_base, uchar id, uchar sdtr_data)
-{
-	ASC_SCSI_BIT_ID_TYPE org_id;
-	int i;
-	int sta = TRUE;
-
-	AscSetBank(iop_base, 1);
-	org_id = AscReadChipDvcID(iop_base);
-	for (i = 0; i <= ASC_MAX_TID; i++) {
-		if (org_id == (0x01 << i))
-			break;
-	}
-	org_id = (ASC_SCSI_BIT_ID_TYPE) i;
-	AscWriteChipDvcID(iop_base, id);
-	if (AscReadChipDvcID(iop_base) == (0x01 << id)) {
-		AscSetBank(iop_base, 0);
-		AscSetChipSyn(iop_base, sdtr_data);
-		if (AscGetChipSyn(iop_base) != sdtr_data) {
-			sta = FALSE;
-		}
-	} else {
-		sta = FALSE;
-	}
-	AscSetBank(iop_base, 1);
-	AscWriteChipDvcID(iop_base, org_id);
-	AscSetBank(iop_base, 0);
-	return (sta);
-}
-
-static ushort AscInitLram(ASC_DVC_VAR *asc_dvc)
-{
-	uchar i;
-	ushort s_addr;
-	PortAddr iop_base;
-	ushort warn_code;
-
-	iop_base = asc_dvc->iop_base;
-	warn_code = 0;
-	AscMemWordSetLram(iop_base, ASC_QADR_BEG, 0,
-			  (ushort)(((int)(asc_dvc->max_total_qng + 2 + 1) *
-				    64) >> 1)
-	    );
-	i = ASC_MIN_ACTIVE_QNO;
-	s_addr = ASC_QADR_BEG + ASC_QBLK_SIZE;
-	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_FWD),
-			 (uchar)(i + 1));
-	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_BWD),
-			 (uchar)(asc_dvc->max_total_qng));
-	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_QNO),
-			 (uchar)i);
-	i++;
-	s_addr += ASC_QBLK_SIZE;
-	for (; i < asc_dvc->max_total_qng; i++, s_addr += ASC_QBLK_SIZE) {
-		AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_FWD),
-				 (uchar)(i + 1));
-		AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_BWD),
-				 (uchar)(i - 1));
-		AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_QNO),
-				 (uchar)i);
-	}
-	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_FWD),
-			 (uchar)ASC_QLINK_END);
-	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_BWD),
-			 (uchar)(asc_dvc->max_total_qng - 1));
-	AscWriteLramByte(iop_base, (ushort)(s_addr + ASC_SCSIQ_B_QNO),
-			 (uchar)asc_dvc->max_total_qng);
-	i++;
-	s_addr += ASC_QBLK_SIZE;
-	for (; i <= (uchar)(asc_dvc->max_total_qng + 3);
-	     i++, s_addr += ASC_QBLK_SIZE) {
-		AscWriteLramByte(iop_base,
-				 (ushort)(s_addr + (ushort)ASC_SCSIQ_B_FWD), i);
-		AscWriteLramByte(iop_base,
-				 (ushort)(s_addr + (ushort)ASC_SCSIQ_B_BWD), i);
-		AscWriteLramByte(iop_base,
-				 (ushort)(s_addr + (ushort)ASC_SCSIQ_B_QNO), i);
-	}
-	return (warn_code);
-}
-
-static void AscInitQLinkVar(ASC_DVC_VAR *asc_dvc)
-{
-	PortAddr iop_base;
-	int i;
-	ushort lram_addr;
-
-	iop_base = asc_dvc->iop_base;
-	AscPutRiscVarFreeQHead(iop_base, 1);
-	AscPutRiscVarDoneQTail(iop_base, asc_dvc->max_total_qng);
-	AscPutVarFreeQHead(iop_base, 1);
-	AscPutVarDoneQTail(iop_base, asc_dvc->max_total_qng);
-	AscWriteLramByte(iop_base, ASCV_BUSY_QHEAD_B,
-			 (uchar)((int)asc_dvc->max_total_qng + 1));
-	AscWriteLramByte(iop_base, ASCV_DISC1_QHEAD_B,
-			 (uchar)((int)asc_dvc->max_total_qng + 2));
-	AscWriteLramByte(iop_base, (ushort)ASCV_TOTAL_READY_Q_B,
-			 asc_dvc->max_total_qng);
-	AscWriteLramWord(iop_base, ASCV_ASCDVC_ERR_CODE_W, 0);
-	AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
-	AscWriteLramByte(iop_base, ASCV_STOP_CODE_B, 0);
-	AscWriteLramByte(iop_base, ASCV_SCSIBUSY_B, 0);
-	AscWriteLramByte(iop_base, ASCV_WTM_FLAG_B, 0);
-	AscPutQDoneInProgress(iop_base, 0);
-	lram_addr = ASC_QADR_BEG;
-	for (i = 0; i < 32; i++, lram_addr += 2) {
-		AscWriteLramWord(iop_base, lram_addr, 0);
-	}
-}
-
-static int AscSetLibErrorCode(ASC_DVC_VAR *asc_dvc, ushort err_code)
-{
-	if (asc_dvc->err_code == 0) {
-		asc_dvc->err_code = err_code;
-		AscWriteLramWord(asc_dvc->iop_base, ASCV_ASCDVC_ERR_CODE_W,
-				 err_code);
-	}
-	return (err_code);
-}
-
-static uchar
-AscMsgOutSDTR(ASC_DVC_VAR *asc_dvc, uchar sdtr_period, uchar sdtr_offset)
-{
-	EXT_MSG sdtr_buf;
-	uchar sdtr_period_index;
-	PortAddr iop_base;
-
-	iop_base = asc_dvc->iop_base;
-	sdtr_buf.msg_type = EXTENDED_MESSAGE;
-	sdtr_buf.msg_len = MS_SDTR_LEN;
-	sdtr_buf.msg_req = EXTENDED_SDTR;
-	sdtr_buf.xfer_period = sdtr_period;
-	sdtr_offset &= ASC_SYN_MAX_OFFSET;
-	sdtr_buf.req_ack_offset = sdtr_offset;
-	if ((sdtr_period_index =
-	     AscGetSynPeriodIndex(asc_dvc, sdtr_period)) <=
-	    asc_dvc->max_sdtr_index) {
-		AscMemWordCopyPtrToLram(iop_base,
-					ASCV_MSGOUT_BEG,
-					(uchar *)&sdtr_buf,
-					sizeof(EXT_MSG) >> 1);
-		return ((sdtr_period_index << 4) | sdtr_offset);
-	} else {
-
-		sdtr_buf.req_ack_offset = 0;
-		AscMemWordCopyPtrToLram(iop_base,
-					ASCV_MSGOUT_BEG,
-					(uchar *)&sdtr_buf,
-					sizeof(EXT_MSG) >> 1);
-		return (0);
-	}
-}
-
-static uchar
-AscCalSDTRData(ASC_DVC_VAR *asc_dvc, uchar sdtr_period, uchar syn_offset)
-{
-	uchar byte;
-	uchar sdtr_period_ix;
-
-	sdtr_period_ix = AscGetSynPeriodIndex(asc_dvc, sdtr_period);
-	if ((sdtr_period_ix > asc_dvc->max_sdtr_index)
-	    ) {
-		return (0xFF);
-	}
-	byte = (sdtr_period_ix << 4) | (syn_offset & ASC_SYN_MAX_OFFSET);
-	return (byte);
-}
-
-static void AscSetChipSDTR(PortAddr iop_base, uchar sdtr_data, uchar tid_no)
-{
-	AscSetChipSynRegAtID(iop_base, tid_no, sdtr_data);
-	AscPutMCodeSDTRDoneAtID(iop_base, tid_no, sdtr_data);
-	return;
-}
-
-static uchar AscGetSynPeriodIndex(ASC_DVC_VAR *asc_dvc, uchar syn_time)
-{
-	uchar *period_table;
-	int max_index;
-	int min_index;
-	int i;
-
-	period_table = asc_dvc->sdtr_period_tbl;
-	max_index = (int)asc_dvc->max_sdtr_index;
-	min_index = (int)asc_dvc->host_init_sdtr_index;
-	if ((syn_time <= period_table[max_index])) {
-		for (i = min_index; i < (max_index - 1); i++) {
-			if (syn_time <= period_table[i]) {
-				return ((uchar)i);
-			}
-		}
-		return ((uchar)max_index);
-	} else {
-		return ((uchar)(max_index + 1));
-	}
-}
-
-static uchar AscAllocFreeQueue(PortAddr iop_base, uchar free_q_head)
-{
-	ushort q_addr;
-	uchar next_qp;
-	uchar q_status;
-
-	q_addr = ASC_QNO_TO_QADDR(free_q_head);
-	q_status = (uchar)AscReadLramByte(iop_base,
-					  (ushort)(q_addr +
-						   ASC_SCSIQ_B_STATUS));
-	next_qp = AscReadLramByte(iop_base, (ushort)(q_addr + ASC_SCSIQ_B_FWD));
-	if (((q_status & QS_READY) == 0) && (next_qp != ASC_QLINK_END)) {
-		return (next_qp);
-	}
-	return (ASC_QLINK_END);
-}
-
-static uchar
-AscAllocMultipleFreeQueue(PortAddr iop_base, uchar free_q_head, uchar n_free_q)
-{
-	uchar i;
-
-	for (i = 0; i < n_free_q; i++) {
-		if ((free_q_head = AscAllocFreeQueue(iop_base, free_q_head))
-		    == ASC_QLINK_END) {
-			return (ASC_QLINK_END);
-		}
-	}
-	return (free_q_head);
-}
-
-static int AscHostReqRiscHalt(PortAddr iop_base)
-{
-	int count = 0;
-	int sta = 0;
-	uchar saved_stop_code;
-
-	if (AscIsChipHalted(iop_base))
-		return (1);
-	saved_stop_code = AscReadLramByte(iop_base, ASCV_STOP_CODE_B);
-	AscWriteLramByte(iop_base, ASCV_STOP_CODE_B,
-			 ASC_STOP_HOST_REQ_RISC_HALT | ASC_STOP_REQ_RISC_STOP);
-	do {
-		if (AscIsChipHalted(iop_base)) {
-			sta = 1;
-			break;
-		}
-		mdelay(100);
-	} while (count++ < 20);
-	AscWriteLramByte(iop_base, ASCV_STOP_CODE_B, saved_stop_code);
-	return (sta);
-}
-
-static int AscStopQueueExe(PortAddr iop_base)
-{
-	int count = 0;
-
-	if (AscReadLramByte(iop_base, ASCV_STOP_CODE_B) == 0) {
-		AscWriteLramByte(iop_base, ASCV_STOP_CODE_B,
-				 ASC_STOP_REQ_RISC_STOP);
-		do {
-			if (AscReadLramByte(iop_base, ASCV_STOP_CODE_B) &
-			    ASC_STOP_ACK_RISC_STOP) {
-				return (1);
-			}
-			mdelay(100);
-		} while (count++ < 20);
-	}
-	return (0);
-}
-
-static int AscStartChip(PortAddr iop_base)
-{
-	AscSetChipControl(iop_base, 0);
-	if ((AscGetChipStatus(iop_base) & CSW_HALTED) != 0) {
-		return (0);
-	}
-	return (1);
-}
-
-static int AscStopChip(PortAddr iop_base)
-{
-	uchar cc_val;
-
-	cc_val =
-	    AscGetChipControl(iop_base) &
-	    (~(CC_SINGLE_STEP | CC_TEST | CC_DIAG));
-	AscSetChipControl(iop_base, (uchar)(cc_val | CC_HALT));
-	AscSetChipIH(iop_base, INS_HALT);
-	AscSetChipIH(iop_base, INS_RFLAG_WTM);
-	if ((AscGetChipStatus(iop_base) & CSW_HALTED) == 0) {
-		return (0);
-	}
-	return (1);
-}
-
-static int AscIsChipHalted(PortAddr iop_base)
-{
-	if ((AscGetChipStatus(iop_base) & CSW_HALTED) != 0) {
-		if ((AscGetChipControl(iop_base) & CC_HALT) != 0) {
-			return (1);
-		}
-	}
-	return (0);
-}
-
-static void AscSetChipIH(PortAddr iop_base, ushort ins_code)
-{
-	AscSetBank(iop_base, 1);
-	AscWriteChipIH(iop_base, ins_code);
-	AscSetBank(iop_base, 0);
-	return;
-}
-
-static void AscAckInterrupt(PortAddr iop_base)
-{
-	uchar host_flag;
-	uchar risc_flag;
-	ushort loop;
-
-	loop = 0;
-	do {
-		risc_flag = AscReadLramByte(iop_base, ASCV_RISC_FLAG_B);
-		if (loop++ > 0x7FFF) {
-			break;
-		}
-	} while ((risc_flag & ASC_RISC_FLAG_GEN_INT) != 0);
-	host_flag =
-	    AscReadLramByte(iop_base,
-			    ASCV_HOST_FLAG_B) & (~ASC_HOST_FLAG_ACK_INT);
-	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B,
-			 (uchar)(host_flag | ASC_HOST_FLAG_ACK_INT));
-	AscSetChipStatus(iop_base, CIW_INT_ACK);
-	loop = 0;
-	while (AscGetChipStatus(iop_base) & CSW_INT_PENDING) {
-		AscSetChipStatus(iop_base, CIW_INT_ACK);
-		if (loop++ > 3) {
-			break;
-		}
-	}
-	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B, host_flag);
-	return;
-}
-
-static void AscDisableInterrupt(PortAddr iop_base)
-{
-	ushort cfg;
-
-	cfg = AscGetChipCfgLsw(iop_base);
-	AscSetChipCfgLsw(iop_base, cfg & (~ASC_CFG0_HOST_INT_ON));
-	return;
-}
-
-static void AscEnableInterrupt(PortAddr iop_base)
-{
-	ushort cfg;
-
-	cfg = AscGetChipCfgLsw(iop_base);
-	AscSetChipCfgLsw(iop_base, cfg | ASC_CFG0_HOST_INT_ON);
-	return;
-}
-
-static void AscSetBank(PortAddr iop_base, uchar bank)
-{
-	uchar val;
-
-	val = AscGetChipControl(iop_base) &
-	    (~
-	     (CC_SINGLE_STEP | CC_TEST | CC_DIAG | CC_SCSI_RESET |
-	      CC_CHIP_RESET));
-	if (bank == 1) {
-		val |= CC_BANK_ONE;
-	} else if (bank == 2) {
-		val |= CC_DIAG | CC_BANK_ONE;
-	} else {
-		val &= ~CC_BANK_ONE;
-	}
-	AscSetChipControl(iop_base, val);
-	return;
-}
-
-static int AscResetChipAndScsiBus(ASC_DVC_VAR *asc_dvc)
-{
-	PortAddr iop_base;
-	int i = 10;
-
-	iop_base = asc_dvc->iop_base;
-	while ((AscGetChipStatus(iop_base) & CSW_SCSI_RESET_ACTIVE)
-	       && (i-- > 0)) {
-		mdelay(100);
-	}
-	AscStopChip(iop_base);
-	AscSetChipControl(iop_base, CC_CHIP_RESET | CC_SCSI_RESET | CC_HALT);
-	udelay(60);
-	AscSetChipIH(iop_base, INS_RFLAG_WTM);
-	AscSetChipIH(iop_base, INS_HALT);
-	AscSetChipControl(iop_base, CC_CHIP_RESET | CC_HALT);
-	AscSetChipControl(iop_base, CC_HALT);
-	mdelay(200);
-	AscSetChipStatus(iop_base, CIW_CLR_SCSI_RESET_INT);
-	AscSetChipStatus(iop_base, 0);
-	return (AscIsChipHalted(iop_base));
-}
-
-static ASC_DCNT __devinit AscGetMaxDmaCount(ushort bus_type)
-{
-	if (bus_type & ASC_IS_ISA)
-		return ASC_MAX_ISA_DMA_COUNT;
-	else if (bus_type & (ASC_IS_EISA | ASC_IS_VL))
-		return ASC_MAX_VL_DMA_COUNT;
-	return ASC_MAX_PCI_DMA_COUNT;
-}
-
-#ifdef CONFIG_ISA
-static ushort __devinit AscGetIsaDmaChannel(PortAddr iop_base)
-{
-	ushort channel;
-
-	channel = AscGetChipCfgLsw(iop_base) & 0x0003;
-	if (channel == 0x03)
-		return (0);
-	else if (channel == 0x00)
-		return (7);
-	return (channel + 4);
-}
-
-static ushort __devinit AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channel)
-{
-	ushort cfg_lsw;
-	uchar value;
-
-	if ((dma_channel >= 5) && (dma_channel <= 7)) {
-		if (dma_channel == 7)
-			value = 0x00;
-		else
-			value = dma_channel - 4;
-		cfg_lsw = AscGetChipCfgLsw(iop_base) & 0xFFFC;
-		cfg_lsw |= value;
-		AscSetChipCfgLsw(iop_base, cfg_lsw);
-		return (AscGetIsaDmaChannel(iop_base));
-	}
-	return (0);
-}
-
-static uchar __devinit AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
-{
-	speed_value &= 0x07;
-	AscSetBank(iop_base, 1);
-	AscWriteChipDmaSpeed(iop_base, speed_value);
-	AscSetBank(iop_base, 0);
-	return (AscGetIsaDmaSpeed(iop_base));
-}
-
-static uchar __devinit AscGetIsaDmaSpeed(PortAddr iop_base)
-{
-	uchar speed_value;
-
-	AscSetBank(iop_base, 1);
-	speed_value = AscReadChipDmaSpeed(iop_base);
-	speed_value &= 0x07;
-	AscSetBank(iop_base, 0);
-	return (speed_value);
-}
-#endif /* CONFIG_ISA */
-
-static int __devinit AscInitGetConfig(asc_board_t *boardp)
-{
-	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
-	unsigned short warn_code = 0;
-
-	asc_dvc->init_state = ASC_INIT_STATE_BEG_GET_CFG;
-	if (asc_dvc->err_code != 0)
-		return asc_dvc->err_code;
-
-	if (AscFindSignature(asc_dvc->iop_base)) {
-		warn_code |= AscInitAscDvcVar(asc_dvc);
-		warn_code |= AscInitFromEEP(asc_dvc);
-		asc_dvc->init_state |= ASC_INIT_STATE_END_GET_CFG;
-		if (asc_dvc->scsi_reset_wait > ASC_MAX_SCSI_RESET_WAIT)
-			asc_dvc->scsi_reset_wait = ASC_MAX_SCSI_RESET_WAIT;
-	} else {
-		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
-	}
-
-	switch (warn_code) {
-	case 0:	/* No error */
-		break;
-	case ASC_WARN_IO_PORT_ROTATE:
-		ASC_PRINT1("AscInitGetConfig: board %d: I/O port address "
-			   "modified\n", boardp->id);
-		break;
-	case ASC_WARN_AUTO_CONFIG:
-		ASC_PRINT1("AscInitGetConfig: board %d: I/O port increment "
-			   "switch enabled\n", boardp->id);
-		break;
-	case ASC_WARN_EEPROM_CHKSUM:
-		ASC_PRINT1("AscInitGetConfig: board %d: EEPROM checksum "
-			   "error\n", boardp->id);
-		break;
-	case ASC_WARN_IRQ_MODIFIED:
-		ASC_PRINT1("AscInitGetConfig: board %d: IRQ modified\n",
-			   boardp->id);
-		break;
-	case ASC_WARN_CMD_QNG_CONFLICT:
-		ASC_PRINT1("AscInitGetConfig: board %d: tag queuing enabled "
-			   "w/o disconnects\n", boardp->id);
-		break;
-	default:
-		ASC_PRINT2("AscInitGetConfig: board %d: unknown warning: "
-			   "0x%x\n", boardp->id, warn_code);
-		break;
-	}
-
-	if (asc_dvc->err_code != 0) {
-		ASC_PRINT3("AscInitGetConfig: board %d error: init_state 0x%x, "
-			   "err_code 0x%x\n", boardp->id, asc_dvc->init_state,
-			   asc_dvc->err_code);
-	}
-
-	return asc_dvc->err_code;
-}
-
-static int __devinit AscInitSetConfig(struct pci_dev *pdev, asc_board_t *boardp)
-{
-	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
-	PortAddr iop_base = asc_dvc->iop_base;
-	unsigned short cfg_msw;
-	unsigned short warn_code = 0;
-
-	asc_dvc->init_state |= ASC_INIT_STATE_BEG_SET_CFG;
-	if (asc_dvc->err_code != 0)
-		return asc_dvc->err_code;
-	if (!AscFindSignature(asc_dvc->iop_base)) {
-		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
-		return asc_dvc->err_code;
-	}
-
-	cfg_msw = AscGetChipCfgMsw(iop_base);
-	if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {
-		cfg_msw &= ~ASC_CFG_MSW_CLR_MASK;
-		warn_code |= ASC_WARN_CFG_MSW_RECOVER;
-		AscSetChipCfgMsw(iop_base, cfg_msw);
-	}
-	if ((asc_dvc->cfg->cmd_qng_enabled & asc_dvc->cfg->disc_enable) !=
-	    asc_dvc->cfg->cmd_qng_enabled) {
-		asc_dvc->cfg->disc_enable = asc_dvc->cfg->cmd_qng_enabled;
-		warn_code |= ASC_WARN_CMD_QNG_CONFLICT;
-	}
-	if (AscGetChipStatus(iop_base) & CSW_AUTO_CONFIG) {
-		warn_code |= ASC_WARN_AUTO_CONFIG;
-	}
-	if ((asc_dvc->bus_type & (ASC_IS_ISA | ASC_IS_VL)) != 0) {
-		if (AscSetChipIRQ(iop_base, asc_dvc->irq_no, asc_dvc->bus_type)
-		    != asc_dvc->irq_no) {
-			asc_dvc->err_code |= ASC_IERR_SET_IRQ_NO;
-		}
-	}
-#ifdef CONFIG_PCI
-	if (asc_dvc->bus_type & ASC_IS_PCI) {
-		cfg_msw &= 0xFFC0;
-		AscSetChipCfgMsw(iop_base, cfg_msw);
-		if ((asc_dvc->bus_type & ASC_IS_PCI_ULTRA) == ASC_IS_PCI_ULTRA) {
-		} else {
-			if ((pdev->device == PCI_DEVICE_ID_ASP_1200A) ||
-			    (pdev->device == PCI_DEVICE_ID_ASP_ABP940)) {
-				asc_dvc->bug_fix_cntl |= ASC_BUG_FIX_IF_NOT_DWB;
-				asc_dvc->bug_fix_cntl |=
-				    ASC_BUG_FIX_ASYN_USE_SYN;
-			}
-		}
-	} else
-#endif /* CONFIG_PCI */
-	if (asc_dvc->bus_type == ASC_IS_ISAPNP) {
-		if (AscGetChipVersion(iop_base, asc_dvc->bus_type)
-		    == ASC_CHIP_VER_ASYN_BUG) {
-			asc_dvc->bug_fix_cntl |= ASC_BUG_FIX_ASYN_USE_SYN;
-		}
-	}
-	if (AscSetChipScsiID(iop_base, asc_dvc->cfg->chip_scsi_id) !=
-	    asc_dvc->cfg->chip_scsi_id) {
-		asc_dvc->err_code |= ASC_IERR_SET_SCSI_ID;
-	}
-#ifdef CONFIG_ISA
-	if (asc_dvc->bus_type & ASC_IS_ISA) {
-		AscSetIsaDmaChannel(iop_base, asc_dvc->cfg->isa_dma_channel);
-		AscSetIsaDmaSpeed(iop_base, asc_dvc->cfg->isa_dma_speed);
-	}
-#endif /* CONFIG_ISA */
-
-	asc_dvc->init_state |= ASC_INIT_STATE_END_SET_CFG;
-
-	switch (warn_code) {
-	case 0:	/* No error. */
-		break;
-	case ASC_WARN_IO_PORT_ROTATE:
-		ASC_PRINT1("AscInitSetConfig: board %d: I/O port address "
-			   "modified\n", boardp->id);
-		break;
-	case ASC_WARN_AUTO_CONFIG:
-		ASC_PRINT1("AscInitSetConfig: board %d: I/O port increment "
-			   "switch enabled\n", boardp->id);
-		break;
-	case ASC_WARN_EEPROM_CHKSUM:
-		ASC_PRINT1("AscInitSetConfig: board %d: EEPROM checksum "
-			   "error\n", boardp->id);
-		break;
-	case ASC_WARN_IRQ_MODIFIED:
-		ASC_PRINT1("AscInitSetConfig: board %d: IRQ modified\n",
-			   boardp->id);
-		break;
-	case ASC_WARN_CMD_QNG_CONFLICT:
-		ASC_PRINT1("AscInitSetConfig: board %d: tag queuing w/o "
-			   "disconnects\n",
-		     boardp->id);
-		break;
-	default:
-		ASC_PRINT2("AscInitSetConfig: board %d: unknown warning: "
-			   "0x%x\n", boardp->id, warn_code);
-		break;
-	}
-
-	if (asc_dvc->err_code != 0) {
-		ASC_PRINT3("AscInitSetConfig: board %d error: init_state 0x%x, "
-			   "err_code 0x%x\n", boardp->id, asc_dvc->init_state,
-			   asc_dvc->err_code);
-	}
-
-	return asc_dvc->err_code;
-}
-
-static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
-{
-	ushort warn_code;
-	PortAddr iop_base;
-
-	iop_base = asc_dvc->iop_base;
-	warn_code = 0;
-	if ((asc_dvc->dvc_cntl & ASC_CNTL_RESET_SCSI) &&
-	    !(asc_dvc->init_state & ASC_INIT_RESET_SCSI_DONE)) {
-		AscResetChipAndScsiBus(asc_dvc);
-		mdelay(asc_dvc->scsi_reset_wait * 1000); /* XXX: msleep? */
-	}
-	asc_dvc->init_state |= ASC_INIT_STATE_BEG_LOAD_MC;
-	if (asc_dvc->err_code != 0)
-		return (UW_ERR);
-	if (!AscFindSignature(asc_dvc->iop_base)) {
-		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
-		return (warn_code);
-	}
-	AscDisableInterrupt(iop_base);
-	warn_code |= AscInitLram(asc_dvc);
-	if (asc_dvc->err_code != 0)
-		return (UW_ERR);
-	ASC_DBG1(1, "AscInitAsc1000Driver: _asc_mcode_chksum 0x%lx\n",
-		 (ulong)_asc_mcode_chksum);
-	if (AscLoadMicroCode(iop_base, 0, _asc_mcode_buf,
-			     _asc_mcode_size) != _asc_mcode_chksum) {
-		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
-		return (warn_code);
-	}
-	warn_code |= AscInitMicroCodeVar(asc_dvc);
-	asc_dvc->init_state |= ASC_INIT_STATE_END_LOAD_MC;
-	AscEnableInterrupt(iop_base);
-	return (warn_code);
-}
-
-static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
-{
-	int i;
-	PortAddr iop_base;
-	ushort warn_code;
-	uchar chip_version;
-
-	iop_base = asc_dvc->iop_base;
-	warn_code = 0;
-	asc_dvc->err_code = 0;
-	if ((asc_dvc->bus_type &
-	     (ASC_IS_ISA | ASC_IS_PCI | ASC_IS_EISA | ASC_IS_VL)) == 0) {
-		asc_dvc->err_code |= ASC_IERR_NO_BUS_TYPE;
-	}
-	AscSetChipControl(iop_base, CC_HALT);
-	AscSetChipStatus(iop_base, 0);
-	asc_dvc->bug_fix_cntl = 0;
-	asc_dvc->pci_fix_asyn_xfer = 0;
-	asc_dvc->pci_fix_asyn_xfer_always = 0;
-	/* asc_dvc->init_state initalized in AscInitGetConfig(). */
-	asc_dvc->sdtr_done = 0;
-	asc_dvc->cur_total_qng = 0;
-	asc_dvc->is_in_int = 0;
-	asc_dvc->in_critical_cnt = 0;
-	asc_dvc->last_q_shortage = 0;
-	asc_dvc->use_tagged_qng = 0;
-	asc_dvc->no_scam = 0;
-	asc_dvc->unit_not_ready = 0;
-	asc_dvc->queue_full_or_busy = 0;
-	asc_dvc->redo_scam = 0;
-	asc_dvc->res2 = 0;
-	asc_dvc->host_init_sdtr_index = 0;
-	asc_dvc->cfg->can_tagged_qng = 0;
-	asc_dvc->cfg->cmd_qng_enabled = 0;
-	asc_dvc->dvc_cntl = ASC_DEF_DVC_CNTL;
-	asc_dvc->init_sdtr = 0;
-	asc_dvc->max_total_qng = ASC_DEF_MAX_TOTAL_QNG;
-	asc_dvc->scsi_reset_wait = 3;
-	asc_dvc->start_motor = ASC_SCSI_WIDTH_BIT_SET;
-	asc_dvc->max_dma_count = AscGetMaxDmaCount(asc_dvc->bus_type);
-	asc_dvc->cfg->sdtr_enable = ASC_SCSI_WIDTH_BIT_SET;
-	asc_dvc->cfg->disc_enable = ASC_SCSI_WIDTH_BIT_SET;
-	asc_dvc->cfg->chip_scsi_id = ASC_DEF_CHIP_SCSI_ID;
-	asc_dvc->cfg->lib_serial_no = ASC_LIB_SERIAL_NUMBER;
-	asc_dvc->cfg->lib_version = (ASC_LIB_VERSION_MAJOR << 8) |
-	    ASC_LIB_VERSION_MINOR;
-	chip_version = AscGetChipVersion(iop_base, asc_dvc->bus_type);
-	asc_dvc->cfg->chip_version = chip_version;
-	asc_dvc->sdtr_period_tbl[0] = SYN_XFER_NS_0;
-	asc_dvc->sdtr_period_tbl[1] = SYN_XFER_NS_1;
-	asc_dvc->sdtr_period_tbl[2] = SYN_XFER_NS_2;
-	asc_dvc->sdtr_period_tbl[3] = SYN_XFER_NS_3;
-	asc_dvc->sdtr_period_tbl[4] = SYN_XFER_NS_4;
-	asc_dvc->sdtr_period_tbl[5] = SYN_XFER_NS_5;
-	asc_dvc->sdtr_period_tbl[6] = SYN_XFER_NS_6;
-	asc_dvc->sdtr_period_tbl[7] = SYN_XFER_NS_7;
-	asc_dvc->max_sdtr_index = 7;
-	if ((asc_dvc->bus_type & ASC_IS_PCI) &&
-	    (chip_version >= ASC_CHIP_VER_PCI_ULTRA_3150)) {
-		asc_dvc->bus_type = ASC_IS_PCI_ULTRA;
-		asc_dvc->sdtr_period_tbl[0] = SYN_ULTRA_XFER_NS_0;
-		asc_dvc->sdtr_period_tbl[1] = SYN_ULTRA_XFER_NS_1;
-		asc_dvc->sdtr_period_tbl[2] = SYN_ULTRA_XFER_NS_2;
-		asc_dvc->sdtr_period_tbl[3] = SYN_ULTRA_XFER_NS_3;
-		asc_dvc->sdtr_period_tbl[4] = SYN_ULTRA_XFER_NS_4;
-		asc_dvc->sdtr_period_tbl[5] = SYN_ULTRA_XFER_NS_5;
-		asc_dvc->sdtr_period_tbl[6] = SYN_ULTRA_XFER_NS_6;
-		asc_dvc->sdtr_period_tbl[7] = SYN_ULTRA_XFER_NS_7;
-		asc_dvc->sdtr_period_tbl[8] = SYN_ULTRA_XFER_NS_8;
-		asc_dvc->sdtr_period_tbl[9] = SYN_ULTRA_XFER_NS_9;
-		asc_dvc->sdtr_period_tbl[10] = SYN_ULTRA_XFER_NS_10;
-		asc_dvc->sdtr_period_tbl[11] = SYN_ULTRA_XFER_NS_11;
-		asc_dvc->sdtr_period_tbl[12] = SYN_ULTRA_XFER_NS_12;
-		asc_dvc->sdtr_period_tbl[13] = SYN_ULTRA_XFER_NS_13;
-		asc_dvc->sdtr_period_tbl[14] = SYN_ULTRA_XFER_NS_14;
-		asc_dvc->sdtr_period_tbl[15] = SYN_ULTRA_XFER_NS_15;
-		asc_dvc->max_sdtr_index = 15;
-		if (chip_version == ASC_CHIP_VER_PCI_ULTRA_3150) {
-			AscSetExtraControl(iop_base,
-					   (SEC_ACTIVE_NEGATE | SEC_SLEW_RATE));
-		} else if (chip_version >= ASC_CHIP_VER_PCI_ULTRA_3050) {
-			AscSetExtraControl(iop_base,
-					   (SEC_ACTIVE_NEGATE |
-					    SEC_ENABLE_FILTER));
-		}
-	}
-	if (asc_dvc->bus_type == ASC_IS_PCI) {
-		AscSetExtraControl(iop_base,
-				   (SEC_ACTIVE_NEGATE | SEC_SLEW_RATE));
-	}
-
-	asc_dvc->cfg->isa_dma_speed = ASC_DEF_ISA_DMA_SPEED;
-#ifdef CONFIG_ISA
-	if ((asc_dvc->bus_type & ASC_IS_ISA) != 0) {
-		if (chip_version >= ASC_CHIP_MIN_VER_ISA_PNP) {
-			AscSetChipIFC(iop_base, IFC_INIT_DEFAULT);
-			asc_dvc->bus_type = ASC_IS_ISAPNP;
-		}
-		asc_dvc->cfg->isa_dma_channel =
-		    (uchar)AscGetIsaDmaChannel(iop_base);
-	}
-#endif /* CONFIG_ISA */
-	for (i = 0; i <= ASC_MAX_TID; i++) {
-		asc_dvc->cur_dvc_qng[i] = 0;
-		asc_dvc->max_dvc_qng[i] = ASC_MAX_SCSI1_QNG;
-		asc_dvc->scsiq_busy_head[i] = (ASC_SCSI_Q *)0L;
-		asc_dvc->scsiq_busy_tail[i] = (ASC_SCSI_Q *)0L;
-		asc_dvc->cfg->max_tag_qng[i] = ASC_MAX_INRAM_TAG_QNG;
-	}
-	return (warn_code);
-}
-
-static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
-{
-	ASCEEP_CONFIG eep_config_buf;
-	ASCEEP_CONFIG *eep_config;
-	PortAddr iop_base;
-	ushort chksum;
-	ushort warn_code;
-	ushort cfg_msw, cfg_lsw;
-	int i;
-	int write_eep = 0;
-
-	iop_base = asc_dvc->iop_base;
-	warn_code = 0;
-	AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0x00FE);
-	AscStopQueueExe(iop_base);
-	if ((AscStopChip(iop_base) == FALSE) ||
-	    (AscGetChipScsiCtrl(iop_base) != 0)) {
-		asc_dvc->init_state |= ASC_INIT_RESET_SCSI_DONE;
-		AscResetChipAndScsiBus(asc_dvc);
-		mdelay(asc_dvc->scsi_reset_wait * 1000); /* XXX: msleep? */
-	}
-	if (AscIsChipHalted(iop_base) == FALSE) {
-		asc_dvc->err_code |= ASC_IERR_START_STOP_CHIP;
-		return (warn_code);
-	}
-	AscSetPCAddr(iop_base, ASC_MCODE_START_ADDR);
-	if (AscGetPCAddr(iop_base) != ASC_MCODE_START_ADDR) {
-		asc_dvc->err_code |= ASC_IERR_SET_PC_ADDR;
-		return (warn_code);
-	}
-	eep_config = (ASCEEP_CONFIG *)&eep_config_buf;
-	cfg_msw = AscGetChipCfgMsw(iop_base);
-	cfg_lsw = AscGetChipCfgLsw(iop_base);
-	if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {
-		cfg_msw &= ~ASC_CFG_MSW_CLR_MASK;
-		warn_code |= ASC_WARN_CFG_MSW_RECOVER;
-		AscSetChipCfgMsw(iop_base, cfg_msw);
-	}
-	chksum = AscGetEEPConfig(iop_base, eep_config, asc_dvc->bus_type);
-	ASC_DBG1(1, "AscInitFromEEP: chksum 0x%x\n", chksum);
-	if (chksum == 0) {
-		chksum = 0xaa55;
-	}
-	if (AscGetChipStatus(iop_base) & CSW_AUTO_CONFIG) {
-		warn_code |= ASC_WARN_AUTO_CONFIG;
-		if (asc_dvc->cfg->chip_version == 3) {
-			if (eep_config->cfg_lsw != cfg_lsw) {
-				warn_code |= ASC_WARN_EEPROM_RECOVER;
-				eep_config->cfg_lsw =
-				    AscGetChipCfgLsw(iop_base);
-			}
-			if (eep_config->cfg_msw != cfg_msw) {
-				warn_code |= ASC_WARN_EEPROM_RECOVER;
-				eep_config->cfg_msw =
-				    AscGetChipCfgMsw(iop_base);
-			}
-		}
-	}
-	eep_config->cfg_msw &= ~ASC_CFG_MSW_CLR_MASK;
-	eep_config->cfg_lsw |= ASC_CFG0_HOST_INT_ON;
-	ASC_DBG1(1, "AscInitFromEEP: eep_config->chksum 0x%x\n",
-		 eep_config->chksum);
-	if (chksum != eep_config->chksum) {
-		if (AscGetChipVersion(iop_base, asc_dvc->bus_type) ==
-		    ASC_CHIP_VER_PCI_ULTRA_3050) {
-			ASC_DBG(1,
-				"AscInitFromEEP: chksum error ignored; EEPROM-less board\n");
-			eep_config->init_sdtr = 0xFF;
-			eep_config->disc_enable = 0xFF;
-			eep_config->start_motor = 0xFF;
-			eep_config->use_cmd_qng = 0;
-			eep_config->max_total_qng = 0xF0;
-			eep_config->max_tag_qng = 0x20;
-			eep_config->cntl = 0xBFFF;
-			ASC_EEP_SET_CHIP_ID(eep_config, 7);
-			eep_config->no_scam = 0;
-			eep_config->adapter_info[0] = 0;
-			eep_config->adapter_info[1] = 0;
-			eep_config->adapter_info[2] = 0;
-			eep_config->adapter_info[3] = 0;
-			eep_config->adapter_info[4] = 0;
-			/* Indicate EEPROM-less board. */
-			eep_config->adapter_info[5] = 0xBB;
-		} else {
-			ASC_PRINT
-			    ("AscInitFromEEP: EEPROM checksum error; Will try to re-write EEPROM.\n");
-			write_eep = 1;
-			warn_code |= ASC_WARN_EEPROM_CHKSUM;
-		}
-	}
-	asc_dvc->cfg->sdtr_enable = eep_config->init_sdtr;
-	asc_dvc->cfg->disc_enable = eep_config->disc_enable;
-	asc_dvc->cfg->cmd_qng_enabled = eep_config->use_cmd_qng;
-	asc_dvc->cfg->isa_dma_speed = ASC_EEP_GET_DMA_SPD(eep_config);
-	asc_dvc->start_motor = eep_config->start_motor;
-	asc_dvc->dvc_cntl = eep_config->cntl;
-	asc_dvc->no_scam = eep_config->no_scam;
-	asc_dvc->cfg->adapter_info[0] = eep_config->adapter_info[0];
-	asc_dvc->cfg->adapter_info[1] = eep_config->adapter_info[1];
-	asc_dvc->cfg->adapter_info[2] = eep_config->adapter_info[2];
-	asc_dvc->cfg->adapter_info[3] = eep_config->adapter_info[3];
-	asc_dvc->cfg->adapter_info[4] = eep_config->adapter_info[4];
-	asc_dvc->cfg->adapter_info[5] = eep_config->adapter_info[5];
-	if (!AscTestExternalLram(asc_dvc)) {
-		if (((asc_dvc->bus_type & ASC_IS_PCI_ULTRA) ==
-		     ASC_IS_PCI_ULTRA)) {
-			eep_config->max_total_qng =
-			    ASC_MAX_PCI_ULTRA_INRAM_TOTAL_QNG;
-			eep_config->max_tag_qng =
-			    ASC_MAX_PCI_ULTRA_INRAM_TAG_QNG;
-		} else {
-			eep_config->cfg_msw |= 0x0800;
-			cfg_msw |= 0x0800;
-			AscSetChipCfgMsw(iop_base, cfg_msw);
-			eep_config->max_total_qng = ASC_MAX_PCI_INRAM_TOTAL_QNG;
-			eep_config->max_tag_qng = ASC_MAX_INRAM_TAG_QNG;
-		}
-	} else {
-	}
-	if (eep_config->max_total_qng < ASC_MIN_TOTAL_QNG) {
-		eep_config->max_total_qng = ASC_MIN_TOTAL_QNG;
-	}
-	if (eep_config->max_total_qng > ASC_MAX_TOTAL_QNG) {
-		eep_config->max_total_qng = ASC_MAX_TOTAL_QNG;
-	}
-	if (eep_config->max_tag_qng > eep_config->max_total_qng) {
-		eep_config->max_tag_qng = eep_config->max_total_qng;
-	}
-	if (eep_config->max_tag_qng < ASC_MIN_TAG_Q_PER_DVC) {
-		eep_config->max_tag_qng = ASC_MIN_TAG_Q_PER_DVC;
-	}
-	asc_dvc->max_total_qng = eep_config->max_total_qng;
-	if ((eep_config->use_cmd_qng & eep_config->disc_enable) !=
-	    eep_config->use_cmd_qng) {
-		eep_config->disc_enable = eep_config->use_cmd_qng;
-		warn_code |= ASC_WARN_CMD_QNG_CONFLICT;
-	}
-	if (asc_dvc->bus_type & (ASC_IS_ISA | ASC_IS_VL | ASC_IS_EISA)) {
-		asc_dvc->irq_no = AscGetChipIRQ(iop_base, asc_dvc->bus_type);
-	}
-	ASC_EEP_SET_CHIP_ID(eep_config,
-			    ASC_EEP_GET_CHIP_ID(eep_config) & ASC_MAX_TID);
-	asc_dvc->cfg->chip_scsi_id = ASC_EEP_GET_CHIP_ID(eep_config);
-	if (((asc_dvc->bus_type & ASC_IS_PCI_ULTRA) == ASC_IS_PCI_ULTRA) &&
-	    !(asc_dvc->dvc_cntl & ASC_CNTL_SDTR_ENABLE_ULTRA)) {
-		asc_dvc->host_init_sdtr_index = ASC_SDTR_ULTRA_PCI_10MB_INDEX;
-	}
-
-	for (i = 0; i <= ASC_MAX_TID; i++) {
-		asc_dvc->dos_int13_table[i] = eep_config->dos_int13_table[i];
-		asc_dvc->cfg->max_tag_qng[i] = eep_config->max_tag_qng;
-		asc_dvc->cfg->sdtr_period_offset[i] =
-		    (uchar)(ASC_DEF_SDTR_OFFSET |
-			    (asc_dvc->host_init_sdtr_index << 4));
-	}
-	eep_config->cfg_msw = AscGetChipCfgMsw(iop_base);
-	if (write_eep) {
-		if ((i =
-		     AscSetEEPConfig(iop_base, eep_config,
-				     asc_dvc->bus_type)) != 0) {
-			ASC_PRINT1
-			    ("AscInitFromEEP: Failed to re-write EEPROM with %d errors.\n",
-			     i);
-		} else {
-			ASC_PRINT
-			    ("AscInitFromEEP: Successfully re-wrote EEPROM.\n");
-		}
-	}
-	return (warn_code);
-}
-
-static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
-{
-	int i;
-	ushort warn_code;
-	PortAddr iop_base;
-	ASC_PADDR phy_addr;
-	ASC_DCNT phy_size;
-
-	iop_base = asc_dvc->iop_base;
-	warn_code = 0;
-	for (i = 0; i <= ASC_MAX_TID; i++) {
-		AscPutMCodeInitSDTRAtID(iop_base, i,
-					asc_dvc->cfg->sdtr_period_offset[i]
-		    );
-	}
-
-	AscInitQLinkVar(asc_dvc);
-	AscWriteLramByte(iop_base, ASCV_DISC_ENABLE_B,
-			 asc_dvc->cfg->disc_enable);
-	AscWriteLramByte(iop_base, ASCV_HOSTSCSI_ID_B,
-			 ASC_TID_TO_TARGET_ID(asc_dvc->cfg->chip_scsi_id));
-
-	/* Align overrun buffer on an 8 byte boundary. */
-	phy_addr = virt_to_bus(asc_dvc->cfg->overrun_buf);
-	phy_addr = cpu_to_le32((phy_addr + 7) & ~0x7);
-	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_PADDR_D,
-				 (uchar *)&phy_addr, 1);
-	phy_size = cpu_to_le32(ASC_OVERRUN_BSIZE - 8);
-	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_BSIZE_D,
-				 (uchar *)&phy_size, 1);
-
-	asc_dvc->cfg->mcode_date =
-	    AscReadLramWord(iop_base, (ushort)ASCV_MC_DATE_W);
-	asc_dvc->cfg->mcode_version =
-	    AscReadLramWord(iop_base, (ushort)ASCV_MC_VER_W);
-
-	AscSetPCAddr(iop_base, ASC_MCODE_START_ADDR);
-	if (AscGetPCAddr(iop_base) != ASC_MCODE_START_ADDR) {
-		asc_dvc->err_code |= ASC_IERR_SET_PC_ADDR;
-		return (warn_code);
-	}
-	if (AscStartChip(iop_base) != 1) {
-		asc_dvc->err_code |= ASC_IERR_START_STOP_CHIP;
-		return (warn_code);
-	}
-
-	return (warn_code);
-}
-
-static int __devinit AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
-{
-	PortAddr iop_base;
-	ushort q_addr;
-	ushort saved_word;
-	int sta;
-
-	iop_base = asc_dvc->iop_base;
-	sta = 0;
-	q_addr = ASC_QNO_TO_QADDR(241);
-	saved_word = AscReadLramWord(iop_base, q_addr);
-	AscSetChipLramAddr(iop_base, q_addr);
-	AscSetChipLramData(iop_base, 0x55AA);
-	mdelay(10);
-	AscSetChipLramAddr(iop_base, q_addr);
-	if (AscGetChipLramData(iop_base) == 0x55AA) {
-		sta = 1;
-		AscWriteLramWord(iop_base, q_addr, saved_word);
-	}
-	return (sta);
-}
-
-static int __devinit AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
-{
-	uchar read_back;
-	int retry;
-
-	retry = 0;
-	while (TRUE) {
-		AscSetChipEEPCmd(iop_base, cmd_reg);
-		mdelay(1);
-		read_back = AscGetChipEEPCmd(iop_base);
-		if (read_back == cmd_reg) {
-			return (1);
-		}
-		if (retry++ > ASC_EEP_MAX_RETRY) {
-			return (0);
-		}
-	}
-}
-
-static int __devinit AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
-{
-	ushort read_back;
-	int retry;
-
-	retry = 0;
-	while (TRUE) {
-		AscSetChipEEPData(iop_base, data_reg);
-		mdelay(1);
-		read_back = AscGetChipEEPData(iop_base);
-		if (read_back == data_reg) {
-			return (1);
-		}
-		if (retry++ > ASC_EEP_MAX_RETRY) {
-			return (0);
-		}
-	}
-}
-
-static void __devinit AscWaitEEPRead(void)
-{
-	mdelay(1);
-	return;
-}
-
-static void __devinit AscWaitEEPWrite(void)
-{
-	mdelay(20);
-	return;
-}
-
-static ushort __devinit AscReadEEPWord(PortAddr iop_base, uchar addr)
-{
-	ushort read_wval;
-	uchar cmd_reg;
-
-	AscWriteEEPCmdReg(iop_base, ASC_EEP_CMD_WRITE_DISABLE);
-	AscWaitEEPRead();
-	cmd_reg = addr | ASC_EEP_CMD_READ;
-	AscWriteEEPCmdReg(iop_base, cmd_reg);
-	AscWaitEEPRead();
-	read_wval = AscGetChipEEPData(iop_base);
-	AscWaitEEPRead();
-	return (read_wval);
-}
-
-static ushort __devinit
-AscWriteEEPWord(PortAddr iop_base, uchar addr, ushort word_val)
-{
-	ushort read_wval;
-
-	read_wval = AscReadEEPWord(iop_base, addr);
-	if (read_wval != word_val) {
-		AscWriteEEPCmdReg(iop_base, ASC_EEP_CMD_WRITE_ABLE);
-		AscWaitEEPRead();
-		AscWriteEEPDataReg(iop_base, word_val);
-		AscWaitEEPRead();
-		AscWriteEEPCmdReg(iop_base,
-				  (uchar)((uchar)ASC_EEP_CMD_WRITE | addr));
-		AscWaitEEPWrite();
-		AscWriteEEPCmdReg(iop_base, ASC_EEP_CMD_WRITE_DISABLE);
-		AscWaitEEPRead();
-		return (AscReadEEPWord(iop_base, addr));
-	}
-	return (read_wval);
-}
-
-static ushort __devinit
-AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
-{
-	ushort wval;
-	ushort sum;
-	ushort *wbuf;
-	int cfg_beg;
-	int cfg_end;
-	int uchar_end_in_config = ASC_EEP_MAX_DVC_ADDR - 2;
-	int s_addr;
-
-	wbuf = (ushort *)cfg_buf;
-	sum = 0;
-	/* Read two config words; Byte-swapping done by AscReadEEPWord(). */
-	for (s_addr = 0; s_addr < 2; s_addr++, wbuf++) {
-		*wbuf = AscReadEEPWord(iop_base, (uchar)s_addr);
-		sum += *wbuf;
-	}
-	if (bus_type & ASC_IS_VL) {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG_VL;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR_VL;
-	} else {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR;
-	}
-	for (s_addr = cfg_beg; s_addr <= (cfg_end - 1); s_addr++, wbuf++) {
-		wval = AscReadEEPWord(iop_base, (uchar)s_addr);
-		if (s_addr <= uchar_end_in_config) {
-			/*
-			 * Swap all char fields - must unswap bytes already swapped
-			 * by AscReadEEPWord().
-			 */
-			*wbuf = le16_to_cpu(wval);
-		} else {
-			/* Don't swap word field at the end - cntl field. */
-			*wbuf = wval;
-		}
-		sum += wval;	/* Checksum treats all EEPROM data as words. */
-	}
-	/*
-	 * Read the checksum word which will be compared against 'sum'
-	 * by the caller. Word field already swapped.
-	 */
-	*wbuf = AscReadEEPWord(iop_base, (uchar)s_addr);
-	return (sum);
-}
-
-static int __devinit
-AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
-{
-	int n_error;
-	ushort *wbuf;
-	ushort word;
-	ushort sum;
-	int s_addr;
-	int cfg_beg;
-	int cfg_end;
-	int uchar_end_in_config = ASC_EEP_MAX_DVC_ADDR - 2;
-
-	wbuf = (ushort *)cfg_buf;
-	n_error = 0;
-	sum = 0;
-	/* Write two config words; AscWriteEEPWord() will swap bytes. */
-	for (s_addr = 0; s_addr < 2; s_addr++, wbuf++) {
-		sum += *wbuf;
-		if (*wbuf != AscWriteEEPWord(iop_base, (uchar)s_addr, *wbuf)) {
-			n_error++;
-		}
-	}
-	if (bus_type & ASC_IS_VL) {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG_VL;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR_VL;
-	} else {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR;
-	}
-	for (s_addr = cfg_beg; s_addr <= (cfg_end - 1); s_addr++, wbuf++) {
-		if (s_addr <= uchar_end_in_config) {
-			/*
-			 * This is a char field. Swap char fields before they are
-			 * swapped again by AscWriteEEPWord().
-			 */
-			word = cpu_to_le16(*wbuf);
-			if (word !=
-			    AscWriteEEPWord(iop_base, (uchar)s_addr, word)) {
-				n_error++;
-			}
-		} else {
-			/* Don't swap word field at the end - cntl field. */
-			if (*wbuf !=
-			    AscWriteEEPWord(iop_base, (uchar)s_addr, *wbuf)) {
-				n_error++;
-			}
-		}
-		sum += *wbuf;	/* Checksum calculated from word values. */
-	}
-	/* Write checksum word. It will be swapped by AscWriteEEPWord(). */
-	*wbuf = sum;
-	if (sum != AscWriteEEPWord(iop_base, (uchar)s_addr, sum)) {
-		n_error++;
-	}
-
-	/* Read EEPROM back again. */
-	wbuf = (ushort *)cfg_buf;
-	/*
-	 * Read two config words; Byte-swapping done by AscReadEEPWord().
-	 */
-	for (s_addr = 0; s_addr < 2; s_addr++, wbuf++) {
-		if (*wbuf != AscReadEEPWord(iop_base, (uchar)s_addr)) {
-			n_error++;
-		}
-	}
-	if (bus_type & ASC_IS_VL) {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG_VL;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR_VL;
-	} else {
-		cfg_beg = ASC_EEP_DVC_CFG_BEG;
-		cfg_end = ASC_EEP_MAX_DVC_ADDR;
-	}
-	for (s_addr = cfg_beg; s_addr <= (cfg_end - 1); s_addr++, wbuf++) {
-		if (s_addr <= uchar_end_in_config) {
-			/*
-			 * Swap all char fields. Must unswap bytes already swapped
-			 * by AscReadEEPWord().
-			 */
-			word =
-			    le16_to_cpu(AscReadEEPWord
-					(iop_base, (uchar)s_addr));
-		} else {
-			/* Don't swap word field at the end - cntl field. */
-			word = AscReadEEPWord(iop_base, (uchar)s_addr);
-		}
-		if (*wbuf != word) {
-			n_error++;
-		}
-	}
-	/* Read checksum; Byte swapping not needed. */
-	if (AscReadEEPWord(iop_base, (uchar)s_addr) != sum) {
-		n_error++;
-	}
-	return (n_error);
-}
-
-static int __devinit
-AscSetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
-{
-	int retry;
-	int n_error;
-
-	retry = 0;
-	while (TRUE) {
-		if ((n_error = AscSetEEPConfigOnce(iop_base, cfg_buf,
-						   bus_type)) == 0) {
-			break;
-		}
-		if (++retry > ASC_EEP_MAX_RETRY) {
-			break;
-		}
-	}
-	return (n_error);
-}
-
-static void AscAsyncFix(ASC_DVC_VAR *asc_dvc, struct scsi_device *sdev)
-{
-	char type = sdev->type;
-	ASC_SCSI_BIT_ID_TYPE tid_bits = 1 << sdev->id;
-
-	if (!(asc_dvc->bug_fix_cntl & ASC_BUG_FIX_ASYN_USE_SYN))
-		return;
-	if (asc_dvc->init_sdtr & tid_bits)
-		return;
-
-	if ((type == TYPE_ROM) && (strncmp(sdev->vendor, "HP ", 3) == 0))
-		asc_dvc->pci_fix_asyn_xfer_always |= tid_bits;
-
-	asc_dvc->pci_fix_asyn_xfer |= tid_bits;
-	if ((type == TYPE_PROCESSOR) || (type == TYPE_SCANNER) ||
-	    (type == TYPE_ROM) || (type == TYPE_TAPE))
-		asc_dvc->pci_fix_asyn_xfer &= ~tid_bits;
-
-	if (asc_dvc->pci_fix_asyn_xfer & tid_bits)
-		AscSetRunChipSynRegAtID(asc_dvc->iop_base, sdev->id,
-					ASYN_SDTR_DATA_FIX_PCI_REV_AB);
-}
-
-static uchar AscReadLramByte(PortAddr iop_base, ushort addr)
-{
-	uchar byte_data;
-	ushort word_data;
-
-	if (isodd_word(addr)) {
-		AscSetChipLramAddr(iop_base, addr - 1);
-		word_data = AscGetChipLramData(iop_base);
-		byte_data = (uchar)((word_data >> 8) & 0xFF);
-	} else {
-		AscSetChipLramAddr(iop_base, addr);
-		word_data = AscGetChipLramData(iop_base);
-		byte_data = (uchar)(word_data & 0xFF);
-	}
-	return (byte_data);
-}
-
-static ushort AscReadLramWord(PortAddr iop_base, ushort addr)
-{
-	ushort word_data;
-
-	AscSetChipLramAddr(iop_base, addr);
-	word_data = AscGetChipLramData(iop_base);
-	return (word_data);
-}
-
-#if CC_VERY_LONG_SG_LIST
-static ASC_DCNT AscReadLramDWord(PortAddr iop_base, ushort addr)
-{
-	ushort val_low, val_high;
-	ASC_DCNT dword_data;
-
-	AscSetChipLramAddr(iop_base, addr);
-	val_low = AscGetChipLramData(iop_base);
-	val_high = AscGetChipLramData(iop_base);
-	dword_data = ((ASC_DCNT) val_high << 16) | (ASC_DCNT) val_low;
-	return (dword_data);
-}
-#endif /* CC_VERY_LONG_SG_LIST */
-
-static void AscWriteLramWord(PortAddr iop_base, ushort addr, ushort word_val)
-{
-	AscSetChipLramAddr(iop_base, addr);
-	AscSetChipLramData(iop_base, word_val);
-	return;
-}
-
-static void AscWriteLramByte(PortAddr iop_base, ushort addr, uchar byte_val)
-{
-	ushort word_data;
-
-	if (isodd_word(addr)) {
-		addr--;
-		word_data = AscReadLramWord(iop_base, addr);
-		word_data &= 0x00FF;
-		word_data |= (((ushort)byte_val << 8) & 0xFF00);
-	} else {
-		word_data = AscReadLramWord(iop_base, addr);
-		word_data &= 0xFF00;
-		word_data |= ((ushort)byte_val & 0x00FF);
-	}
-	AscWriteLramWord(iop_base, addr, word_data);
-	return;
-}
-
-/*
- * Copy 2 bytes to LRAM.
- *
- * The source data is assumed to be in little-endian order in memory
- * and is maintained in little-endian order when written to LRAM.
- */
-static void
-AscMemWordCopyPtrToLram(PortAddr iop_base,
-			ushort s_addr, uchar *s_buffer, int words)
-{
-	int i;
-
-	AscSetChipLramAddr(iop_base, s_addr);
-	for (i = 0; i < 2 * words; i += 2) {
-		/*
-		 * On a little-endian system the second argument below
-		 * produces a little-endian ushort which is written to
-		 * LRAM in little-endian order. On a big-endian system
-		 * the second argument produces a big-endian ushort which
-		 * is "transparently" byte-swapped by outpw() and written
-		 * in little-endian order to LRAM.
-		 */
-		outpw(iop_base + IOP_RAM_DATA,
-		      ((ushort)s_buffer[i + 1] << 8) | s_buffer[i]);
-	}
-	return;
-}
-
-/*
- * Copy 4 bytes to LRAM.
- *
- * The source data is assumed to be in little-endian order in memory
- * and is maintained in little-endian order when writen to LRAM.
- */
-static void
-AscMemDWordCopyPtrToLram(PortAddr iop_base,
-			 ushort s_addr, uchar *s_buffer, int dwords)
-{
-	int i;
-
-	AscSetChipLramAddr(iop_base, s_addr);
-	for (i = 0; i < 4 * dwords; i += 4) {
-		outpw(iop_base + IOP_RAM_DATA, ((ushort)s_buffer[i + 1] << 8) | s_buffer[i]);	/* LSW */
-		outpw(iop_base + IOP_RAM_DATA, ((ushort)s_buffer[i + 3] << 8) | s_buffer[i + 2]);	/* MSW */
-	}
-	return;
-}
-
-/*
- * Copy 2 bytes from LRAM.
- *
- * The source data is assumed to be in little-endian order in LRAM
- * and is maintained in little-endian order when written to memory.
- */
-static void
-AscMemWordCopyPtrFromLram(PortAddr iop_base,
-			  ushort s_addr, uchar *d_buffer, int words)
-{
-	int i;
-	ushort word;
-
-	AscSetChipLramAddr(iop_base, s_addr);
-	for (i = 0; i < 2 * words; i += 2) {
-		word = inpw(iop_base + IOP_RAM_DATA);
-		d_buffer[i] = word & 0xff;
-		d_buffer[i + 1] = (word >> 8) & 0xff;
-	}
-	return;
-}
-
-static ASC_DCNT AscMemSumLramWord(PortAddr iop_base, ushort s_addr, int words)
-{
-	ASC_DCNT sum;
-	int i;
-
-	sum = 0L;
-	for (i = 0; i < words; i++, s_addr += 2) {
-		sum += AscReadLramWord(iop_base, s_addr);
-	}
-	return (sum);
-}
-
-static void
-AscMemWordSetLram(PortAddr iop_base, ushort s_addr, ushort set_wval, int words)
-{
-	int i;
-
-	AscSetChipLramAddr(iop_base, s_addr);
-	for (i = 0; i < words; i++) {
-		AscSetChipLramData(iop_base, set_wval);
-	}
-	return;
-}
-
 /* Microcode buffer is kept after initialization for error recovery. */
 static unsigned char _adv_asc3550_buf[] = {
 	0x00, 0x00, 0x00, 0xf2, 0x00, 0xf0, 0x00, 0x16, 0x18, 0xe4, 0x00, 0xfc,
@@ -10686,451 +6494,213 @@ static unsigned char _adv_asc38C1600_buf[] = {
 static unsigned short _adv_asc38C1600_size = sizeof(_adv_asc38C1600_buf);	/* 0x1673 */
 static ADV_DCNT _adv_asc38C1600_chksum = 0x0604EF77UL;	/* Expanded little-endian checksum. */
 
-/*
- * EEPROM Configuration.
- *
- * All drivers should use this structure to set the default EEPROM
- * configuration. The BIOS now uses this structure when it is built.
- * Additional structure information can be found in a_condor.h where
- * the structure is defined.
- *
- * The *_Field_IsChar structs are needed to correct for endianness.
- * These values are read from the board 16 bits at a time directly
- * into the structs. Because some fields are char, the values will be
- * in the wrong order. The *_Field_IsChar tells when to flip the
- * bytes. Data read and written to PCI memory is automatically swapped
- * on big-endian platforms so char fields read as words are actually being
- * unswapped on big-endian platforms.
- */
-static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __devinitdata = {
-	ADV_EEPROM_BIOS_ENABLE,	/* cfg_lsw */
-	0x0000,			/* cfg_msw */
-	0xFFFF,			/* disc_enable */
-	0xFFFF,			/* wdtr_able */
-	0xFFFF,			/* sdtr_able */
-	0xFFFF,			/* start_motor */
-	0xFFFF,			/* tagqng_able */
-	0xFFFF,			/* bios_scan */
-	0,			/* scam_tolerant */
-	7,			/* adapter_scsi_id */
-	0,			/* bios_boot_delay */
-	3,			/* scsi_reset_delay */
-	0,			/* bios_id_lun */
-	0,			/* termination */
-	0,			/* reserved1 */
-	0xFFE7,			/* bios_ctrl */
-	0xFFFF,			/* ultra_able */
-	0,			/* reserved2 */
-	ASC_DEF_MAX_HOST_QNG,	/* max_host_qng */
-	ASC_DEF_MAX_DVC_QNG,	/* max_dvc_qng */
-	0,			/* dvc_cntl */
-	0,			/* bug_fix */
-	0,			/* serial_number_word1 */
-	0,			/* serial_number_word2 */
-	0,			/* serial_number_word3 */
-	0,			/* check_sum */
-	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
-	,			/* oem_name[16] */
-	0,			/* dvc_err_code */
-	0,			/* adv_err_code */
-	0,			/* adv_err_addr */
-	0,			/* saved_dvc_err_code */
-	0,			/* saved_adv_err_code */
-	0,			/* saved_adv_err_addr */
-	0			/* num_of_err */
-};
+static void AscInitQLinkVar(ASC_DVC_VAR *asc_dvc)
+{
+	PortAddr iop_base;
+	int i;
+	ushort lram_addr;
 
-static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __devinitdata = {
-	0,			/* cfg_lsw */
-	0,			/* cfg_msw */
-	0,			/* -disc_enable */
-	0,			/* wdtr_able */
-	0,			/* sdtr_able */
-	0,			/* start_motor */
-	0,			/* tagqng_able */
-	0,			/* bios_scan */
-	0,			/* scam_tolerant */
-	1,			/* adapter_scsi_id */
-	1,			/* bios_boot_delay */
-	1,			/* scsi_reset_delay */
-	1,			/* bios_id_lun */
-	1,			/* termination */
-	1,			/* reserved1 */
-	0,			/* bios_ctrl */
-	0,			/* ultra_able */
-	0,			/* reserved2 */
-	1,			/* max_host_qng */
-	1,			/* max_dvc_qng */
-	0,			/* dvc_cntl */
-	0,			/* bug_fix */
-	0,			/* serial_number_word1 */
-	0,			/* serial_number_word2 */
-	0,			/* serial_number_word3 */
-	0,			/* check_sum */
-	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
-	,			/* oem_name[16] */
-	0,			/* dvc_err_code */
-	0,			/* adv_err_code */
-	0,			/* adv_err_addr */
-	0,			/* saved_dvc_err_code */
-	0,			/* saved_adv_err_code */
-	0,			/* saved_adv_err_addr */
-	0			/* num_of_err */
-};
+	iop_base = asc_dvc->iop_base;
+	AscPutRiscVarFreeQHead(iop_base, 1);
+	AscPutRiscVarDoneQTail(iop_base, asc_dvc->max_total_qng);
+	AscPutVarFreeQHead(iop_base, 1);
+	AscPutVarDoneQTail(iop_base, asc_dvc->max_total_qng);
+	AscWriteLramByte(iop_base, ASCV_BUSY_QHEAD_B,
+			 (uchar)((int)asc_dvc->max_total_qng + 1));
+	AscWriteLramByte(iop_base, ASCV_DISC1_QHEAD_B,
+			 (uchar)((int)asc_dvc->max_total_qng + 2));
+	AscWriteLramByte(iop_base, (ushort)ASCV_TOTAL_READY_Q_B,
+			 asc_dvc->max_total_qng);
+	AscWriteLramWord(iop_base, ASCV_ASCDVC_ERR_CODE_W, 0);
+	AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+	AscWriteLramByte(iop_base, ASCV_STOP_CODE_B, 0);
+	AscWriteLramByte(iop_base, ASCV_SCSIBUSY_B, 0);
+	AscWriteLramByte(iop_base, ASCV_WTM_FLAG_B, 0);
+	AscPutQDoneInProgress(iop_base, 0);
+	lram_addr = ASC_QADR_BEG;
+	for (i = 0; i < 32; i++, lram_addr += 2) {
+		AscWriteLramWord(iop_base, lram_addr, 0);
+	}
+}
 
-static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __devinitdata = {
-	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
-	0x0000,			/* 01 cfg_msw */
-	0xFFFF,			/* 02 disc_enable */
-	0xFFFF,			/* 03 wdtr_able */
-	0x4444,			/* 04 sdtr_speed1 */
-	0xFFFF,			/* 05 start_motor */
-	0xFFFF,			/* 06 tagqng_able */
-	0xFFFF,			/* 07 bios_scan */
-	0,			/* 08 scam_tolerant */
-	7,			/* 09 adapter_scsi_id */
-	0,			/*    bios_boot_delay */
-	3,			/* 10 scsi_reset_delay */
-	0,			/*    bios_id_lun */
-	0,			/* 11 termination_se */
-	0,			/*    termination_lvd */
-	0xFFE7,			/* 12 bios_ctrl */
-	0x4444,			/* 13 sdtr_speed2 */
-	0x4444,			/* 14 sdtr_speed3 */
-	ASC_DEF_MAX_HOST_QNG,	/* 15 max_host_qng */
-	ASC_DEF_MAX_DVC_QNG,	/*    max_dvc_qng */
-	0,			/* 16 dvc_cntl */
-	0x4444,			/* 17 sdtr_speed4 */
-	0,			/* 18 serial_number_word1 */
-	0,			/* 19 serial_number_word2 */
-	0,			/* 20 serial_number_word3 */
-	0,			/* 21 check_sum */
-	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
-	,			/* 22-29 oem_name[16] */
-	0,			/* 30 dvc_err_code */
-	0,			/* 31 adv_err_code */
-	0,			/* 32 adv_err_addr */
-	0,			/* 33 saved_dvc_err_code */
-	0,			/* 34 saved_adv_err_code */
-	0,			/* 35 saved_adv_err_addr */
-	0,			/* 36 reserved */
-	0,			/* 37 reserved */
-	0,			/* 38 reserved */
-	0,			/* 39 reserved */
-	0,			/* 40 reserved */
-	0,			/* 41 reserved */
-	0,			/* 42 reserved */
-	0,			/* 43 reserved */
-	0,			/* 44 reserved */
-	0,			/* 45 reserved */
-	0,			/* 46 reserved */
-	0,			/* 47 reserved */
-	0,			/* 48 reserved */
-	0,			/* 49 reserved */
-	0,			/* 50 reserved */
-	0,			/* 51 reserved */
-	0,			/* 52 reserved */
-	0,			/* 53 reserved */
-	0,			/* 54 reserved */
-	0,			/* 55 reserved */
-	0,			/* 56 cisptr_lsw */
-	0,			/* 57 cisprt_msw */
-	PCI_VENDOR_ID_ASP,	/* 58 subsysvid */
-	PCI_DEVICE_ID_38C0800_REV1,	/* 59 subsysid */
-	0,			/* 60 reserved */
-	0,			/* 61 reserved */
-	0,			/* 62 reserved */
-	0			/* 63 reserved */
-};
+static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
+{
+	int i;
+	ushort warn_code;
+	PortAddr iop_base;
+	ASC_PADDR phy_addr;
+	ASC_DCNT phy_size;
 
-static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __devinitdata = {
-	0,			/* 00 cfg_lsw */
-	0,			/* 01 cfg_msw */
-	0,			/* 02 disc_enable */
-	0,			/* 03 wdtr_able */
-	0,			/* 04 sdtr_speed1 */
-	0,			/* 05 start_motor */
-	0,			/* 06 tagqng_able */
-	0,			/* 07 bios_scan */
-	0,			/* 08 scam_tolerant */
-	1,			/* 09 adapter_scsi_id */
-	1,			/*    bios_boot_delay */
-	1,			/* 10 scsi_reset_delay */
-	1,			/*    bios_id_lun */
-	1,			/* 11 termination_se */
-	1,			/*    termination_lvd */
-	0,			/* 12 bios_ctrl */
-	0,			/* 13 sdtr_speed2 */
-	0,			/* 14 sdtr_speed3 */
-	1,			/* 15 max_host_qng */
-	1,			/*    max_dvc_qng */
-	0,			/* 16 dvc_cntl */
-	0,			/* 17 sdtr_speed4 */
-	0,			/* 18 serial_number_word1 */
-	0,			/* 19 serial_number_word2 */
-	0,			/* 20 serial_number_word3 */
-	0,			/* 21 check_sum */
-	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
-	,			/* 22-29 oem_name[16] */
-	0,			/* 30 dvc_err_code */
-	0,			/* 31 adv_err_code */
-	0,			/* 32 adv_err_addr */
-	0,			/* 33 saved_dvc_err_code */
-	0,			/* 34 saved_adv_err_code */
-	0,			/* 35 saved_adv_err_addr */
-	0,			/* 36 reserved */
-	0,			/* 37 reserved */
-	0,			/* 38 reserved */
-	0,			/* 39 reserved */
-	0,			/* 40 reserved */
-	0,			/* 41 reserved */
-	0,			/* 42 reserved */
-	0,			/* 43 reserved */
-	0,			/* 44 reserved */
-	0,			/* 45 reserved */
-	0,			/* 46 reserved */
-	0,			/* 47 reserved */
-	0,			/* 48 reserved */
-	0,			/* 49 reserved */
-	0,			/* 50 reserved */
-	0,			/* 51 reserved */
-	0,			/* 52 reserved */
-	0,			/* 53 reserved */
-	0,			/* 54 reserved */
-	0,			/* 55 reserved */
-	0,			/* 56 cisptr_lsw */
-	0,			/* 57 cisprt_msw */
-	0,			/* 58 subsysvid */
-	0,			/* 59 subsysid */
-	0,			/* 60 reserved */
-	0,			/* 61 reserved */
-	0,			/* 62 reserved */
-	0			/* 63 reserved */
-};
+	iop_base = asc_dvc->iop_base;
+	warn_code = 0;
+	for (i = 0; i <= ASC_MAX_TID; i++) {
+		AscPutMCodeInitSDTRAtID(iop_base, i,
+					asc_dvc->cfg->sdtr_period_offset[i]);
+	}
 
-static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __devinitdata = {
-	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
-	0x0000,			/* 01 cfg_msw */
-	0xFFFF,			/* 02 disc_enable */
-	0xFFFF,			/* 03 wdtr_able */
-	0x5555,			/* 04 sdtr_speed1 */
-	0xFFFF,			/* 05 start_motor */
-	0xFFFF,			/* 06 tagqng_able */
-	0xFFFF,			/* 07 bios_scan */
-	0,			/* 08 scam_tolerant */
-	7,			/* 09 adapter_scsi_id */
-	0,			/*    bios_boot_delay */
-	3,			/* 10 scsi_reset_delay */
-	0,			/*    bios_id_lun */
-	0,			/* 11 termination_se */
-	0,			/*    termination_lvd */
-	0xFFE7,			/* 12 bios_ctrl */
-	0x5555,			/* 13 sdtr_speed2 */
-	0x5555,			/* 14 sdtr_speed3 */
-	ASC_DEF_MAX_HOST_QNG,	/* 15 max_host_qng */
-	ASC_DEF_MAX_DVC_QNG,	/*    max_dvc_qng */
-	0,			/* 16 dvc_cntl */
-	0x5555,			/* 17 sdtr_speed4 */
-	0,			/* 18 serial_number_word1 */
-	0,			/* 19 serial_number_word2 */
-	0,			/* 20 serial_number_word3 */
-	0,			/* 21 check_sum */
-	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
-	,			/* 22-29 oem_name[16] */
-	0,			/* 30 dvc_err_code */
-	0,			/* 31 adv_err_code */
-	0,			/* 32 adv_err_addr */
-	0,			/* 33 saved_dvc_err_code */
-	0,			/* 34 saved_adv_err_code */
-	0,			/* 35 saved_adv_err_addr */
-	0,			/* 36 reserved */
-	0,			/* 37 reserved */
-	0,			/* 38 reserved */
-	0,			/* 39 reserved */
-	0,			/* 40 reserved */
-	0,			/* 41 reserved */
-	0,			/* 42 reserved */
-	0,			/* 43 reserved */
-	0,			/* 44 reserved */
-	0,			/* 45 reserved */
-	0,			/* 46 reserved */
-	0,			/* 47 reserved */
-	0,			/* 48 reserved */
-	0,			/* 49 reserved */
-	0,			/* 50 reserved */
-	0,			/* 51 reserved */
-	0,			/* 52 reserved */
-	0,			/* 53 reserved */
-	0,			/* 54 reserved */
-	0,			/* 55 reserved */
-	0,			/* 56 cisptr_lsw */
-	0,			/* 57 cisprt_msw */
-	PCI_VENDOR_ID_ASP,	/* 58 subsysvid */
-	PCI_DEVICE_ID_38C1600_REV1,	/* 59 subsysid */
-	0,			/* 60 reserved */
-	0,			/* 61 reserved */
-	0,			/* 62 reserved */
-	0			/* 63 reserved */
-};
+	AscInitQLinkVar(asc_dvc);
+	AscWriteLramByte(iop_base, ASCV_DISC_ENABLE_B,
+			 asc_dvc->cfg->disc_enable);
+	AscWriteLramByte(iop_base, ASCV_HOSTSCSI_ID_B,
+			 ASC_TID_TO_TARGET_ID(asc_dvc->cfg->chip_scsi_id));
 
-static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __devinitdata = {
-	0,			/* 00 cfg_lsw */
-	0,			/* 01 cfg_msw */
-	0,			/* 02 disc_enable */
-	0,			/* 03 wdtr_able */
-	0,			/* 04 sdtr_speed1 */
-	0,			/* 05 start_motor */
-	0,			/* 06 tagqng_able */
-	0,			/* 07 bios_scan */
-	0,			/* 08 scam_tolerant */
-	1,			/* 09 adapter_scsi_id */
-	1,			/*    bios_boot_delay */
-	1,			/* 10 scsi_reset_delay */
-	1,			/*    bios_id_lun */
-	1,			/* 11 termination_se */
-	1,			/*    termination_lvd */
-	0,			/* 12 bios_ctrl */
-	0,			/* 13 sdtr_speed2 */
-	0,			/* 14 sdtr_speed3 */
-	1,			/* 15 max_host_qng */
-	1,			/*    max_dvc_qng */
-	0,			/* 16 dvc_cntl */
-	0,			/* 17 sdtr_speed4 */
-	0,			/* 18 serial_number_word1 */
-	0,			/* 19 serial_number_word2 */
-	0,			/* 20 serial_number_word3 */
-	0,			/* 21 check_sum */
-	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
-	,			/* 22-29 oem_name[16] */
-	0,			/* 30 dvc_err_code */
-	0,			/* 31 adv_err_code */
-	0,			/* 32 adv_err_addr */
-	0,			/* 33 saved_dvc_err_code */
-	0,			/* 34 saved_adv_err_code */
-	0,			/* 35 saved_adv_err_addr */
-	0,			/* 36 reserved */
-	0,			/* 37 reserved */
-	0,			/* 38 reserved */
-	0,			/* 39 reserved */
-	0,			/* 40 reserved */
-	0,			/* 41 reserved */
-	0,			/* 42 reserved */
-	0,			/* 43 reserved */
-	0,			/* 44 reserved */
-	0,			/* 45 reserved */
-	0,			/* 46 reserved */
-	0,			/* 47 reserved */
-	0,			/* 48 reserved */
-	0,			/* 49 reserved */
-	0,			/* 50 reserved */
-	0,			/* 51 reserved */
-	0,			/* 52 reserved */
-	0,			/* 53 reserved */
-	0,			/* 54 reserved */
-	0,			/* 55 reserved */
-	0,			/* 56 cisptr_lsw */
-	0,			/* 57 cisprt_msw */
-	0,			/* 58 subsysvid */
-	0,			/* 59 subsysid */
-	0,			/* 60 reserved */
-	0,			/* 61 reserved */
-	0,			/* 62 reserved */
-	0			/* 63 reserved */
-};
+	/* Align overrun buffer on an 8 byte boundary. */
+	phy_addr = virt_to_bus(asc_dvc->cfg->overrun_buf);
+	phy_addr = cpu_to_le32((phy_addr + 7) & ~0x7);
+	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_PADDR_D,
+				 (uchar *)&phy_addr, 1);
+	phy_size = cpu_to_le32(ASC_OVERRUN_BSIZE - 8);
+	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_BSIZE_D,
+				 (uchar *)&phy_size, 1);
+
+	asc_dvc->cfg->mcode_date =
+	    AscReadLramWord(iop_base, (ushort)ASCV_MC_DATE_W);
+	asc_dvc->cfg->mcode_version =
+	    AscReadLramWord(iop_base, (ushort)ASCV_MC_VER_W);
+
+	AscSetPCAddr(iop_base, ASC_MCODE_START_ADDR);
+	if (AscGetPCAddr(iop_base) != ASC_MCODE_START_ADDR) {
+		asc_dvc->err_code |= ASC_IERR_SET_PC_ADDR;
+		return warn_code;
+	}
+	if (AscStartChip(iop_base) != 1) {
+		asc_dvc->err_code |= ASC_IERR_START_STOP_CHIP;
+		return warn_code;
+	}
+
+	return warn_code;
+}
+
+static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
+{
+	ushort warn_code;
+	PortAddr iop_base;
+
+	iop_base = asc_dvc->iop_base;
+	warn_code = 0;
+	if ((asc_dvc->dvc_cntl & ASC_CNTL_RESET_SCSI) &&
+	    !(asc_dvc->init_state & ASC_INIT_RESET_SCSI_DONE)) {
+		AscResetChipAndScsiBus(asc_dvc);
+		mdelay(asc_dvc->scsi_reset_wait * 1000); /* XXX: msleep? */
+	}
+	asc_dvc->init_state |= ASC_INIT_STATE_BEG_LOAD_MC;
+	if (asc_dvc->err_code != 0)
+		return UW_ERR;
+	if (!AscFindSignature(asc_dvc->iop_base)) {
+		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
+		return warn_code;
+	}
+	AscDisableInterrupt(iop_base);
+	warn_code |= AscInitLram(asc_dvc);
+	if (asc_dvc->err_code != 0)
+		return UW_ERR;
+	ASC_DBG1(1, "AscInitAsc1000Driver: _asc_mcode_chksum 0x%lx\n",
+		 (ulong)_asc_mcode_chksum);
+	if (AscLoadMicroCode(iop_base, 0, _asc_mcode_buf,
+			     _asc_mcode_size) != _asc_mcode_chksum) {
+		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
+		return warn_code;
+	}
+	warn_code |= AscInitMicroCodeVar(asc_dvc);
+	asc_dvc->init_state |= ASC_INIT_STATE_END_LOAD_MC;
+	AscEnableInterrupt(iop_base);
+	return warn_code;
+}
 
-#ifdef CONFIG_PCI
 /*
- * Initialize the ADV_DVC_VAR structure.
+ * Load the Microcode
  *
- * On failure set the ADV_DVC_VAR field 'err_code' and return ADV_ERROR.
+ * Write the microcode image to RISC memory starting at address 0.
  *
- * For a non-fatal error return a warning code. If there are no warnings
- * then 0 is returned.
+ * The microcode is stored compressed in the following format:
+ *
+ *  254 word (508 byte) table indexed by byte code followed
+ *  by the following byte codes:
+ *
+ *    1-Byte Code:
+ *      00: Emit word 0 in table.
+ *      01: Emit word 1 in table.
+ *      .
+ *      FD: Emit word 253 in table.
+ *
+ *    Multi-Byte Code:
+ *      FE WW WW: (3 byte code) Word to emit is the next word WW WW.
+ *      FF BB WW WW: (4 byte code) Emit BB count times next word WW WW.
+ *
+ * Returns 0 or an error if the checksum doesn't match
  */
-static int __devinit
-AdvInitGetConfig(struct pci_dev *pdev, asc_board_t *boardp)
+static int AdvLoadMicrocode(AdvPortAddr iop_base, unsigned char *buf, int size,
+			    int memsize, int chksum)
 {
-	ADV_DVC_VAR *asc_dvc = &boardp->dvc_var.adv_dvc_var;
-	unsigned short warn_code = 0;
-	AdvPortAddr iop_base = asc_dvc->iop_base;
-	u16 cmd;
-	int status;
+	int i, j, end, len = 0;
+	ADV_DCNT sum;
 
-	asc_dvc->err_code = 0;
+	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
 
-	/*
-	 * Save the state of the PCI Configuration Command Register
-	 * "Parity Error Response Control" Bit. If the bit is clear (0),
-	 * in AdvInitAsc3550/38C0800Driver() tell the microcode to ignore
-	 * DMA parity errors.
-	 */
-	asc_dvc->cfg->control_flag = 0;
-	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
-	if ((cmd & PCI_COMMAND_PARITY) == 0)
-		asc_dvc->cfg->control_flag |= CONTROL_FLAG_IGNORE_PERR;
+	for (i = 253 * 2; i < size; i++) {
+		if (buf[i] == 0xff) {
+			unsigned short word = (buf[i + 3] << 8) | buf[i + 2];
+			for (j = 0; j < buf[i + 1]; j++) {
+				AdvWriteWordAutoIncLram(iop_base, word);
+				len += 2;
+			}
+			i += 3;
+		} else if (buf[i] == 0xfe) {
+			unsigned short word = (buf[i + 2] << 8) | buf[i + 1];
+			AdvWriteWordAutoIncLram(iop_base, word);
+			i += 2;
+			len += 2;
+		} else {
+			unsigned char off = buf[i] * 2;
+			unsigned short word = (buf[off + 1] << 8) | buf[off];
+			AdvWriteWordAutoIncLram(iop_base, word);
+			len += 2;
+		}
+	}
 
-	asc_dvc->cfg->lib_version = (ADV_LIB_VERSION_MAJOR << 8) |
-	    ADV_LIB_VERSION_MINOR;
-	asc_dvc->cfg->chip_version =
-	    AdvGetChipVersion(iop_base, asc_dvc->bus_type);
+	end = len;
 
-	ASC_DBG2(1, "AdvInitGetConfig: iopb_chip_id_1: 0x%x 0x%x\n",
-		 (ushort)AdvReadByteRegister(iop_base, IOPB_CHIP_ID_1),
-		 (ushort)ADV_CHIP_ID_BYTE);
+	while (len < memsize) {
+		AdvWriteWordAutoIncLram(iop_base, 0);
+		len += 2;
+	}
 
-	ASC_DBG2(1, "AdvInitGetConfig: iopw_chip_id_0: 0x%x 0x%x\n",
-		 (ushort)AdvReadWordRegister(iop_base, IOPW_CHIP_ID_0),
-		 (ushort)ADV_CHIP_ID_WORD);
+	/* Verify the microcode checksum. */
+	sum = 0;
+	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
 
-	/*
-	 * Reset the chip to start and allow register writes.
-	 */
-	if (AdvFindSignature(iop_base) == 0) {
-		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
-		return ADV_ERROR;
-	} else {
-		/*
-		 * The caller must set 'chip_type' to a valid setting.
-		 */
-		if (asc_dvc->chip_type != ADV_CHIP_ASC3550 &&
-		    asc_dvc->chip_type != ADV_CHIP_ASC38C0800 &&
-		    asc_dvc->chip_type != ADV_CHIP_ASC38C1600) {
-			asc_dvc->err_code |= ASC_IERR_BAD_CHIPTYPE;
-			return ADV_ERROR;
-		}
+	for (len = 0; len < end; len += 2) {
+		sum += AdvReadWordAutoIncLram(iop_base);
+	}
 
-		/*
-		 * Reset Chip.
-		 */
-		AdvWriteWordRegister(iop_base, IOPW_CTRL_REG,
-				     ADV_CTRL_REG_CMD_RESET);
-		mdelay(100);
-		AdvWriteWordRegister(iop_base, IOPW_CTRL_REG,
-				     ADV_CTRL_REG_CMD_WR_IO_REG);
+	if (sum != chksum)
+		return ASC_IERR_MCODE_CHKSUM;
 
-		if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
-			status = AdvInitFrom38C1600EEP(asc_dvc);
-		} else if (asc_dvc->chip_type == ADV_CHIP_ASC38C0800) {
-			status = AdvInitFrom38C0800EEP(asc_dvc);
-		} else {
-			status = AdvInitFrom3550EEP(asc_dvc);
-		}
-		warn_code |= status;
-	}
+	return 0;
+}
 
-	if (warn_code != 0) {
-		ASC_PRINT2("AdvInitGetConfig: board %d: warning: 0x%x\n",
-			   boardp->id, warn_code);
-	}
+/*
+ * DvcGetPhyAddr()
+ *
+ * Return the physical address of 'vaddr' and set '*lenp' to the
+ * number of physically contiguous bytes that follow 'vaddr'.
+ * 'flag' indicates the type of structure whose physical address
+ * is being translated.
+ *
+ * Note: Because Linux currently doesn't page the kernel and all
+ * kernel buffers are physically contiguous, leave '*lenp' unchanged.
+ */
+ADV_PADDR
+DvcGetPhyAddr(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq,
+	      uchar *vaddr, ADV_SDCNT *lenp, int flag)
+{
+	ADV_PADDR paddr = virt_to_bus(vaddr);
 
-	if (asc_dvc->err_code) {
-		ASC_PRINT2("AdvInitGetConfig: board %d error: err_code 0x%x\n",
-		     boardp->id, asc_dvc->err_code);
-	}
+	ASC_DBG4(4, "DvcGetPhyAddr: vaddr 0x%p, lenp 0x%p *lenp %lu, paddr 0x%lx\n",
+		 vaddr, lenp, (ulong)*((ulong *)lenp), (ulong)paddr);
 
-	return asc_dvc->err_code;
+	return paddr;
 }
-#endif
 
 static void AdvBuildCarrierFreelist(struct adv_dvc_var *asc_dvc)
 {
@@ -11183,75 +6753,117 @@ static void AdvBuildCarrierFreelist(struct adv_dvc_var *asc_dvc)
 }
 
 /*
- * Load the Microcode
- *
- * Write the microcode image to RISC memory starting at address 0.
- *
- * The microcode is stored compressed in the following format:
- *
- *  254 word (508 byte) table indexed by byte code followed
- *  by the following byte codes:
+ * Send an idle command to the chip and wait for completion.
  *
- *    1-Byte Code:
- *      00: Emit word 0 in table.
- *      01: Emit word 1 in table.
- *      .
- *      FD: Emit word 253 in table.
+ * Command completion is polled for once per microsecond.
  *
- *    Multi-Byte Code:
- *      FE WW WW: (3 byte code) Word to emit is the next word WW WW.
- *      FF BB WW WW: (4 byte code) Emit BB count times next word WW WW.
+ * The function can be called from anywhere including an interrupt handler.
+ * But the function is not re-entrant, so it uses the DvcEnter/LeaveCritical()
+ * functions to prevent reentrancy.
  *
- * Returns 0 or an error if the checksum doesn't match
+ * Return Values:
+ *   ADV_TRUE - command completed successfully
+ *   ADV_FALSE - command failed
+ *   ADV_ERROR - command timed out
  */
-static int AdvLoadMicrocode(AdvPortAddr iop_base, unsigned char *buf, int size,
-			    int memsize, int chksum)
+static int
+AdvSendIdleCmd(ADV_DVC_VAR *asc_dvc,
+	       ushort idle_cmd, ADV_DCNT idle_cmd_parameter)
 {
-	int i, j, end, len = 0;
-	ADV_DCNT sum;
+	int result;
+	ADV_DCNT i, j;
+	AdvPortAddr iop_base;
 
-	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
+	iop_base = asc_dvc->iop_base;
 
-	for (i = 253 * 2; i < size; i++) {
-		if (buf[i] == 0xff) {
-			unsigned short word = (buf[i + 3] << 8) | buf[i + 2];
-			for (j = 0; j < buf[i + 1]; j++) {
-				AdvWriteWordAutoIncLram(iop_base, word);
-				len += 2;
-			}
-			i += 3;
-		} else if (buf[i] == 0xfe) {
-			unsigned short word = (buf[i + 2] << 8) | buf[i + 1];
-			AdvWriteWordAutoIncLram(iop_base, word);
-			i += 2;
-			len += 2;
-		} else {
-			unsigned char off = buf[i] * 2;
-			unsigned short word = (buf[off + 1] << 8) | buf[off];
-			AdvWriteWordAutoIncLram(iop_base, word);
-			len += 2;
+	/*
+	 * Clear the idle command status which is set by the microcode
+	 * to a non-zero value to indicate when the command is completed.
+	 * The non-zero result is one of the IDLE_CMD_STATUS_* values
+	 */
+	AdvWriteWordLram(iop_base, ASC_MC_IDLE_CMD_STATUS, (ushort)0);
+
+	/*
+	 * Write the idle command value after the idle command parameter
+	 * has been written to avoid a race condition. If the order is not
+	 * followed, the microcode may process the idle command before the
+	 * parameters have been written to LRAM.
+	 */
+	AdvWriteDWordLramNoSwap(iop_base, ASC_MC_IDLE_CMD_PARAMETER,
+				cpu_to_le32(idle_cmd_parameter));
+	AdvWriteWordLram(iop_base, ASC_MC_IDLE_CMD, idle_cmd);
+
+	/*
+	 * Tickle the RISC to tell it to process the idle command.
+	 */
+	AdvWriteByteRegister(iop_base, IOPB_TICKLE, ADV_TICKLE_B);
+	if (asc_dvc->chip_type == ADV_CHIP_ASC3550) {
+		/*
+		 * Clear the tickle value. In the ASC-3550 the RISC flag
+		 * command 'clr_tickle_b' does not work unless the host
+		 * value is cleared.
+		 */
+		AdvWriteByteRegister(iop_base, IOPB_TICKLE, ADV_TICKLE_NOP);
+	}
+
+	/* Wait for up to 100 millisecond for the idle command to timeout. */
+	for (i = 0; i < SCSI_WAIT_100_MSEC; i++) {
+		/* Poll once each microsecond for command completion. */
+		for (j = 0; j < SCSI_US_PER_MSEC; j++) {
+			AdvReadWordLram(iop_base, ASC_MC_IDLE_CMD_STATUS,
+					result);
+			if (result != 0)
+				return result;
+			udelay(1);
 		}
 	}
 
-	end = len;
+	BUG();		/* The idle command should never timeout. */
+	return ADV_ERROR;
+}
 
-	while (len < memsize) {
-		AdvWriteWordAutoIncLram(iop_base, 0);
-		len += 2;
+/*
+ * Reset SCSI Bus and purge all outstanding requests.
+ *
+ * Return Value:
+ *      ADV_TRUE(1) -   All requests are purged and SCSI Bus is reset.
+ *      ADV_FALSE(0) -  Microcode command failed.
+ *      ADV_ERROR(-1) - Microcode command timed-out. Microcode or IC
+ *                      may be hung which requires driver recovery.
+ */
+static int AdvResetSB(ADV_DVC_VAR *asc_dvc)
+{
+	int status;
+
+	/*
+	 * Send the SCSI Bus Reset idle start idle command which asserts
+	 * the SCSI Bus Reset signal.
+	 */
+	status = AdvSendIdleCmd(asc_dvc, (ushort)IDLE_CMD_SCSI_RESET_START, 0L);
+	if (status != ADV_TRUE) {
+		return status;
 	}
 
-	/* Verify the microcode checksum. */
-	sum = 0;
-	AdvWriteWordRegister(iop_base, IOPW_RAM_ADDR, 0);
+	/*
+	 * Delay for the specified SCSI Bus Reset hold time.
+	 *
+	 * The hold time delay is done on the host because the RISC has no
+	 * microsecond accurate timer.
+	 */
+	udelay(ASC_SCSI_RESET_HOLD_TIME_US);
 
-	for (len = 0; len < end; len += 2) {
-		sum += AdvReadWordAutoIncLram(iop_base);
+	/*
+	 * Send the SCSI Bus Reset end idle command which de-asserts
+	 * the SCSI Bus Reset signal and purges any pending requests.
+	 */
+	status = AdvSendIdleCmd(asc_dvc, (ushort)IDLE_CMD_SCSI_RESET_END, 0L);
+	if (status != ADV_TRUE) {
+		return status;
 	}
 
-	if (sum != chksum)
-		return ASC_IERR_MCODE_CHKSUM;
+	mdelay(asc_dvc->scsi_reset_wait * 1000);	/* XXX: msleep? */
 
-	return 0;
+	return status;
 }
 
 /*
@@ -12661,6 +8273,4917 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 }
 
 /*
+ * Reset chip and SCSI Bus.
+ *
+ * Return Value:
+ *      ADV_TRUE(1) -   Chip re-initialization and SCSI Bus Reset successful.
+ *      ADV_FALSE(0) -  Chip re-initialization and SCSI Bus Reset failure.
+ */
+static int AdvResetChipAndSB(ADV_DVC_VAR *asc_dvc)
+{
+	int status;
+	ushort wdtr_able, sdtr_able, tagqng_able;
+	ushort ppr_able = 0;
+	uchar tid, max_cmd[ADV_MAX_TID + 1];
+	AdvPortAddr iop_base;
+	ushort bios_sig;
+
+	iop_base = asc_dvc->iop_base;
+
+	/*
+	 * Save current per TID negotiated values.
+	 */
+	AdvReadWordLram(iop_base, ASC_MC_WDTR_ABLE, wdtr_able);
+	AdvReadWordLram(iop_base, ASC_MC_SDTR_ABLE, sdtr_able);
+	if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
+		AdvReadWordLram(iop_base, ASC_MC_PPR_ABLE, ppr_able);
+	}
+	AdvReadWordLram(iop_base, ASC_MC_TAGQNG_ABLE, tagqng_able);
+	for (tid = 0; tid <= ADV_MAX_TID; tid++) {
+		AdvReadByteLram(iop_base, ASC_MC_NUMBER_OF_MAX_CMD + tid,
+				max_cmd[tid]);
+	}
+
+	/*
+	 * Force the AdvInitAsc3550/38C0800Driver() function to
+	 * perform a SCSI Bus Reset by clearing the BIOS signature word.
+	 * The initialization functions assumes a SCSI Bus Reset is not
+	 * needed if the BIOS signature word is present.
+	 */
+	AdvReadWordLram(iop_base, ASC_MC_BIOS_SIGNATURE, bios_sig);
+	AdvWriteWordLram(iop_base, ASC_MC_BIOS_SIGNATURE, 0);
+
+	/*
+	 * Stop chip and reset it.
+	 */
+	AdvWriteWordRegister(iop_base, IOPW_RISC_CSR, ADV_RISC_CSR_STOP);
+	AdvWriteWordRegister(iop_base, IOPW_CTRL_REG, ADV_CTRL_REG_CMD_RESET);
+	mdelay(100);
+	AdvWriteWordRegister(iop_base, IOPW_CTRL_REG,
+			     ADV_CTRL_REG_CMD_WR_IO_REG);
+
+	/*
+	 * Reset Adv Library error code, if any, and try
+	 * re-initializing the chip.
+	 */
+	asc_dvc->err_code = 0;
+	if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
+		status = AdvInitAsc38C1600Driver(asc_dvc);
+	} else if (asc_dvc->chip_type == ADV_CHIP_ASC38C0800) {
+		status = AdvInitAsc38C0800Driver(asc_dvc);
+	} else {
+		status = AdvInitAsc3550Driver(asc_dvc);
+	}
+
+	/* Translate initialization return value to status value. */
+	if (status == 0) {
+		status = ADV_TRUE;
+	} else {
+		status = ADV_FALSE;
+	}
+
+	/*
+	 * Restore the BIOS signature word.
+	 */
+	AdvWriteWordLram(iop_base, ASC_MC_BIOS_SIGNATURE, bios_sig);
+
+	/*
+	 * Restore per TID negotiated values.
+	 */
+	AdvWriteWordLram(iop_base, ASC_MC_WDTR_ABLE, wdtr_able);
+	AdvWriteWordLram(iop_base, ASC_MC_SDTR_ABLE, sdtr_able);
+	if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
+		AdvWriteWordLram(iop_base, ASC_MC_PPR_ABLE, ppr_able);
+	}
+	AdvWriteWordLram(iop_base, ASC_MC_TAGQNG_ABLE, tagqng_able);
+	for (tid = 0; tid <= ADV_MAX_TID; tid++) {
+		AdvWriteByteLram(iop_base, ASC_MC_NUMBER_OF_MAX_CMD + tid,
+				 max_cmd[tid]);
+	}
+
+	return status;
+}
+
+/*
+ * adv_async_callback() - Adv Library asynchronous event callback function.
+ */
+static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
+{
+	switch (code) {
+	case ADV_ASYNC_SCSI_BUS_RESET_DET:
+		/*
+		 * The firmware detected a SCSI Bus reset.
+		 */
+		ASC_DBG(0,
+			"adv_async_callback: ADV_ASYNC_SCSI_BUS_RESET_DET\n");
+		break;
+
+	case ADV_ASYNC_RDMA_FAILURE:
+		/*
+		 * Handle RDMA failure by resetting the SCSI Bus and
+		 * possibly the chip if it is unresponsive. Log the error
+		 * with a unique code.
+		 */
+		ASC_DBG(0, "adv_async_callback: ADV_ASYNC_RDMA_FAILURE\n");
+		AdvResetChipAndSB(adv_dvc_varp);
+		break;
+
+	case ADV_HOST_SCSI_BUS_RESET:
+		/*
+		 * Host generated SCSI bus reset occurred.
+		 */
+		ASC_DBG(0, "adv_async_callback: ADV_HOST_SCSI_BUS_RESET\n");
+		break;
+
+	default:
+		ASC_DBG1(0, "DvcAsyncCallBack: unknown code 0x%x\n", code);
+		break;
+	}
+}
+
+/*
+ * adv_isr_callback() - Second Level Interrupt Handler called by AdvISR().
+ *
+ * Callback function for the Wide SCSI Adv Library.
+ */
+static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
+{
+	asc_board_t *boardp;
+	adv_req_t *reqp;
+	adv_sgblk_t *sgblkp;
+	struct scsi_cmnd *scp;
+	struct Scsi_Host *shost;
+	ADV_DCNT resid_cnt;
+
+	ASC_DBG2(1, "adv_isr_callback: adv_dvc_varp 0x%lx, scsiqp 0x%lx\n",
+		 (ulong)adv_dvc_varp, (ulong)scsiqp);
+	ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
+
+	/*
+	 * Get the adv_req_t structure for the command that has been
+	 * completed. The adv_req_t structure actually contains the
+	 * completed ADV_SCSI_REQ_Q structure.
+	 */
+	reqp = (adv_req_t *)ADV_U32_TO_VADDR(scsiqp->srb_ptr);
+	ASC_DBG1(1, "adv_isr_callback: reqp 0x%lx\n", (ulong)reqp);
+	if (reqp == NULL) {
+		ASC_PRINT("adv_isr_callback: reqp is NULL\n");
+		return;
+	}
+
+	/*
+	 * Get the struct scsi_cmnd structure and Scsi_Host structure for the
+	 * command that has been completed.
+	 *
+	 * Note: The adv_req_t request structure and adv_sgblk_t structure,
+	 * if any, are dropped, because a board structure pointer can not be
+	 * determined.
+	 */
+	scp = reqp->cmndp;
+	ASC_DBG1(1, "adv_isr_callback: scp 0x%lx\n", (ulong)scp);
+	if (scp == NULL) {
+		ASC_PRINT
+		    ("adv_isr_callback: scp is NULL; adv_req_t dropped.\n");
+		return;
+	}
+	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
+
+	shost = scp->device->host;
+	ASC_STATS(shost, callback);
+	ASC_DBG1(1, "adv_isr_callback: shost 0x%lx\n", (ulong)shost);
+
+	boardp = ASC_BOARDP(shost);
+	BUG_ON(adv_dvc_varp != &boardp->dvc_var.adv_dvc_var);
+
+	/*
+	 * 'done_status' contains the command's ending status.
+	 */
+	switch (scsiqp->done_status) {
+	case QD_NO_ERROR:
+		ASC_DBG(2, "adv_isr_callback: QD_NO_ERROR\n");
+		scp->result = 0;
+
+		/*
+		 * Check for an underrun condition.
+		 *
+		 * If there was no error and an underrun condition, then
+		 * then return the number of underrun bytes.
+		 */
+		resid_cnt = le32_to_cpu(scsiqp->data_cnt);
+		if (scp->request_bufflen != 0 && resid_cnt != 0 &&
+		    resid_cnt <= scp->request_bufflen) {
+			ASC_DBG1(1,
+				 "adv_isr_callback: underrun condition %lu bytes\n",
+				 (ulong)resid_cnt);
+			scp->resid = resid_cnt;
+		}
+		break;
+
+	case QD_WITH_ERROR:
+		ASC_DBG(2, "adv_isr_callback: QD_WITH_ERROR\n");
+		switch (scsiqp->host_status) {
+		case QHSTA_NO_ERROR:
+			if (scsiqp->scsi_status == SAM_STAT_CHECK_CONDITION) {
+				ASC_DBG(2,
+					"adv_isr_callback: SAM_STAT_CHECK_CONDITION\n");
+				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
+						  sizeof(scp->sense_buffer));
+				/*
+				 * Note: The 'status_byte()' macro used by
+				 * target drivers defined in scsi.h shifts the
+				 * status byte returned by host drivers right
+				 * by 1 bit.  This is why target drivers also
+				 * use right shifted status byte definitions.
+				 * For instance target drivers use
+				 * CHECK_CONDITION, defined to 0x1, instead of
+				 * the SCSI defined check condition value of
+				 * 0x2. Host drivers are supposed to return
+				 * the status byte as it is defined by SCSI.
+				 */
+				scp->result = DRIVER_BYTE(DRIVER_SENSE) |
+				    STATUS_BYTE(scsiqp->scsi_status);
+			} else {
+				scp->result = STATUS_BYTE(scsiqp->scsi_status);
+			}
+			break;
+
+		default:
+			/* Some other QHSTA error occurred. */
+			ASC_DBG1(1, "adv_isr_callback: host_status 0x%x\n",
+				 scsiqp->host_status);
+			scp->result = HOST_BYTE(DID_BAD_TARGET);
+			break;
+		}
+		break;
+
+	case QD_ABORTED_BY_HOST:
+		ASC_DBG(1, "adv_isr_callback: QD_ABORTED_BY_HOST\n");
+		scp->result =
+		    HOST_BYTE(DID_ABORT) | STATUS_BYTE(scsiqp->scsi_status);
+		break;
+
+	default:
+		ASC_DBG1(1, "adv_isr_callback: done_status 0x%x\n",
+			 scsiqp->done_status);
+		scp->result =
+		    HOST_BYTE(DID_ERROR) | STATUS_BYTE(scsiqp->scsi_status);
+		break;
+	}
+
+	/*
+	 * If the 'init_tidmask' bit isn't already set for the target and the
+	 * current request finished normally, then set the bit for the target
+	 * to indicate that a device is present.
+	 */
+	if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scp->device->id)) == 0 &&
+	    scsiqp->done_status == QD_NO_ERROR &&
+	    scsiqp->host_status == QHSTA_NO_ERROR) {
+		boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
+	}
+
+	asc_scsi_done(scp);
+
+	/*
+	 * Free all 'adv_sgblk_t' structures allocated for the request.
+	 */
+	while ((sgblkp = reqp->sgblkp) != NULL) {
+		/* Remove 'sgblkp' from the request list. */
+		reqp->sgblkp = sgblkp->next_sgblkp;
+
+		/* Add 'sgblkp' to the board free list. */
+		sgblkp->next_sgblkp = boardp->adv_sgblkp;
+		boardp->adv_sgblkp = sgblkp;
+	}
+
+	/*
+	 * Free the adv_req_t structure used with the command by adding
+	 * it back to the board free list.
+	 */
+	reqp->next_reqp = boardp->adv_reqp;
+	boardp->adv_reqp = reqp;
+
+	ASC_DBG(1, "adv_isr_callback: done\n");
+
+	return;
+}
+
+/*
+ * Adv Library Interrupt Service Routine
+ *
+ *  This function is called by a driver's interrupt service routine.
+ *  The function disables and re-enables interrupts.
+ *
+ *  When a microcode idle command is completed, the ADV_DVC_VAR
+ *  'idle_cmd_done' field is set to ADV_TRUE.
+ *
+ *  Note: AdvISR() can be called when interrupts are disabled or even
+ *  when there is no hardware interrupt condition present. It will
+ *  always check for completed idle commands and microcode requests.
+ *  This is an important feature that shouldn't be changed because it
+ *  allows commands to be completed from polling mode loops.
+ *
+ * Return:
+ *   ADV_TRUE(1) - interrupt was pending
+ *   ADV_FALSE(0) - no interrupt was pending
+ */
+static int AdvISR(ADV_DVC_VAR *asc_dvc)
+{
+	AdvPortAddr iop_base;
+	uchar int_stat;
+	ushort target_bit;
+	ADV_CARR_T *free_carrp;
+	ADV_VADDR irq_next_vpa;
+	ADV_SCSI_REQ_Q *scsiq;
+
+	iop_base = asc_dvc->iop_base;
+
+	/* Reading the register clears the interrupt. */
+	int_stat = AdvReadByteRegister(iop_base, IOPB_INTR_STATUS_REG);
+
+	if ((int_stat & (ADV_INTR_STATUS_INTRA | ADV_INTR_STATUS_INTRB |
+			 ADV_INTR_STATUS_INTRC)) == 0) {
+		return ADV_FALSE;
+	}
+
+	/*
+	 * Notify the driver of an asynchronous microcode condition by
+	 * calling the adv_async_callback function. The function
+	 * is passed the microcode ASC_MC_INTRB_CODE byte value.
+	 */
+	if (int_stat & ADV_INTR_STATUS_INTRB) {
+		uchar intrb_code;
+
+		AdvReadByteLram(iop_base, ASC_MC_INTRB_CODE, intrb_code);
+
+		if (asc_dvc->chip_type == ADV_CHIP_ASC3550 ||
+		    asc_dvc->chip_type == ADV_CHIP_ASC38C0800) {
+			if (intrb_code == ADV_ASYNC_CARRIER_READY_FAILURE &&
+			    asc_dvc->carr_pending_cnt != 0) {
+				AdvWriteByteRegister(iop_base, IOPB_TICKLE,
+						     ADV_TICKLE_A);
+				if (asc_dvc->chip_type == ADV_CHIP_ASC3550) {
+					AdvWriteByteRegister(iop_base,
+							     IOPB_TICKLE,
+							     ADV_TICKLE_NOP);
+				}
+			}
+		}
+
+		adv_async_callback(asc_dvc, intrb_code);
+	}
+
+	/*
+	 * Check if the IRQ stopper carrier contains a completed request.
+	 */
+	while (((irq_next_vpa =
+		 le32_to_cpu(asc_dvc->irq_sp->next_vpa)) & ASC_RQ_DONE) != 0) {
+		/*
+		 * Get a pointer to the newly completed ADV_SCSI_REQ_Q structure.
+		 * The RISC will have set 'areq_vpa' to a virtual address.
+		 *
+		 * The firmware will have copied the ASC_SCSI_REQ_Q.scsiq_ptr
+		 * field to the carrier ADV_CARR_T.areq_vpa field. The conversion
+		 * below complements the conversion of ASC_SCSI_REQ_Q.scsiq_ptr'
+		 * in AdvExeScsiQueue().
+		 */
+		scsiq = (ADV_SCSI_REQ_Q *)
+		    ADV_U32_TO_VADDR(le32_to_cpu(asc_dvc->irq_sp->areq_vpa));
+
+		/*
+		 * Request finished with good status and the queue was not
+		 * DMAed to host memory by the firmware. Set all status fields
+		 * to indicate good status.
+		 */
+		if ((irq_next_vpa & ASC_RQ_GOOD) != 0) {
+			scsiq->done_status = QD_NO_ERROR;
+			scsiq->host_status = scsiq->scsi_status = 0;
+			scsiq->data_cnt = 0L;
+		}
+
+		/*
+		 * Advance the stopper pointer to the next carrier
+		 * ignoring the lower four bits. Free the previous
+		 * stopper carrier.
+		 */
+		free_carrp = asc_dvc->irq_sp;
+		asc_dvc->irq_sp = (ADV_CARR_T *)
+		    ADV_U32_TO_VADDR(ASC_GET_CARRP(irq_next_vpa));
+
+		free_carrp->next_vpa =
+		    cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->carr_freelist));
+		asc_dvc->carr_freelist = free_carrp;
+		asc_dvc->carr_pending_cnt--;
+
+		target_bit = ADV_TID_TO_TIDMASK(scsiq->target_id);
+
+		/*
+		 * Clear request microcode control flag.
+		 */
+		scsiq->cntl = 0;
+
+		/*
+		 * Notify the driver of the completed request by passing
+		 * the ADV_SCSI_REQ_Q pointer to its callback function.
+		 */
+		scsiq->a_flag |= ADV_SCSIQ_DONE;
+		adv_isr_callback(asc_dvc, scsiq);
+		/*
+		 * Note: After the driver callback function is called, 'scsiq'
+		 * can no longer be referenced.
+		 *
+		 * Fall through and continue processing other completed
+		 * requests...
+		 */
+	}
+	return ADV_TRUE;
+}
+
+static int AscSetLibErrorCode(ASC_DVC_VAR *asc_dvc, ushort err_code)
+{
+	if (asc_dvc->err_code == 0) {
+		asc_dvc->err_code = err_code;
+		AscWriteLramWord(asc_dvc->iop_base, ASCV_ASCDVC_ERR_CODE_W,
+				 err_code);
+	}
+	return err_code;
+}
+
+static void AscAckInterrupt(PortAddr iop_base)
+{
+	uchar host_flag;
+	uchar risc_flag;
+	ushort loop;
+
+	loop = 0;
+	do {
+		risc_flag = AscReadLramByte(iop_base, ASCV_RISC_FLAG_B);
+		if (loop++ > 0x7FFF) {
+			break;
+		}
+	} while ((risc_flag & ASC_RISC_FLAG_GEN_INT) != 0);
+	host_flag =
+	    AscReadLramByte(iop_base,
+			    ASCV_HOST_FLAG_B) & (~ASC_HOST_FLAG_ACK_INT);
+	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B,
+			 (uchar)(host_flag | ASC_HOST_FLAG_ACK_INT));
+	AscSetChipStatus(iop_base, CIW_INT_ACK);
+	loop = 0;
+	while (AscGetChipStatus(iop_base) & CSW_INT_PENDING) {
+		AscSetChipStatus(iop_base, CIW_INT_ACK);
+		if (loop++ > 3) {
+			break;
+		}
+	}
+	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B, host_flag);
+	return;
+}
+
+static uchar AscGetSynPeriodIndex(ASC_DVC_VAR *asc_dvc, uchar syn_time)
+{
+	uchar *period_table;
+	int max_index;
+	int min_index;
+	int i;
+
+	period_table = asc_dvc->sdtr_period_tbl;
+	max_index = (int)asc_dvc->max_sdtr_index;
+	min_index = (int)asc_dvc->host_init_sdtr_index;
+	if ((syn_time <= period_table[max_index])) {
+		for (i = min_index; i < (max_index - 1); i++) {
+			if (syn_time <= period_table[i]) {
+				return (uchar)i;
+			}
+		}
+		return (uchar)max_index;
+	} else {
+		return (uchar)(max_index + 1);
+	}
+}
+
+static uchar
+AscMsgOutSDTR(ASC_DVC_VAR *asc_dvc, uchar sdtr_period, uchar sdtr_offset)
+{
+	EXT_MSG sdtr_buf;
+	uchar sdtr_period_index;
+	PortAddr iop_base;
+
+	iop_base = asc_dvc->iop_base;
+	sdtr_buf.msg_type = EXTENDED_MESSAGE;
+	sdtr_buf.msg_len = MS_SDTR_LEN;
+	sdtr_buf.msg_req = EXTENDED_SDTR;
+	sdtr_buf.xfer_period = sdtr_period;
+	sdtr_offset &= ASC_SYN_MAX_OFFSET;
+	sdtr_buf.req_ack_offset = sdtr_offset;
+	sdtr_period_index = AscGetSynPeriodIndex(asc_dvc, sdtr_period);
+	if (sdtr_period_index <= asc_dvc->max_sdtr_index) {
+		AscMemWordCopyPtrToLram(iop_base, ASCV_MSGOUT_BEG,
+					(uchar *)&sdtr_buf,
+					sizeof(EXT_MSG) >> 1);
+		return ((sdtr_period_index << 4) | sdtr_offset);
+	} else {
+		sdtr_buf.req_ack_offset = 0;
+		AscMemWordCopyPtrToLram(iop_base, ASCV_MSGOUT_BEG,
+					(uchar *)&sdtr_buf,
+					sizeof(EXT_MSG) >> 1);
+		return 0;
+	}
+}
+
+static uchar
+AscCalSDTRData(ASC_DVC_VAR *asc_dvc, uchar sdtr_period, uchar syn_offset)
+{
+	uchar byte;
+	uchar sdtr_period_ix;
+
+	sdtr_period_ix = AscGetSynPeriodIndex(asc_dvc, sdtr_period);
+	if (sdtr_period_ix > asc_dvc->max_sdtr_index) {
+		return 0xFF;
+	}
+	byte = (sdtr_period_ix << 4) | (syn_offset & ASC_SYN_MAX_OFFSET);
+	return byte;
+}
+
+static int AscSetChipSynRegAtID(PortAddr iop_base, uchar id, uchar sdtr_data)
+{
+	ASC_SCSI_BIT_ID_TYPE org_id;
+	int i;
+	int sta = TRUE;
+
+	AscSetBank(iop_base, 1);
+	org_id = AscReadChipDvcID(iop_base);
+	for (i = 0; i <= ASC_MAX_TID; i++) {
+		if (org_id == (0x01 << i))
+			break;
+	}
+	org_id = (ASC_SCSI_BIT_ID_TYPE) i;
+	AscWriteChipDvcID(iop_base, id);
+	if (AscReadChipDvcID(iop_base) == (0x01 << id)) {
+		AscSetBank(iop_base, 0);
+		AscSetChipSyn(iop_base, sdtr_data);
+		if (AscGetChipSyn(iop_base) != sdtr_data) {
+			sta = FALSE;
+		}
+	} else {
+		sta = FALSE;
+	}
+	AscSetBank(iop_base, 1);
+	AscWriteChipDvcID(iop_base, org_id);
+	AscSetBank(iop_base, 0);
+	return (sta);
+}
+
+static void AscSetChipSDTR(PortAddr iop_base, uchar sdtr_data, uchar tid_no)
+{
+	AscSetChipSynRegAtID(iop_base, tid_no, sdtr_data);
+	AscPutMCodeSDTRDoneAtID(iop_base, tid_no, sdtr_data);
+}
+
+static int AscIsrChipHalted(ASC_DVC_VAR *asc_dvc)
+{
+	EXT_MSG ext_msg;
+	EXT_MSG out_msg;
+	ushort halt_q_addr;
+	int sdtr_accept;
+	ushort int_halt_code;
+	ASC_SCSI_BIT_ID_TYPE scsi_busy;
+	ASC_SCSI_BIT_ID_TYPE target_id;
+	PortAddr iop_base;
+	uchar tag_code;
+	uchar q_status;
+	uchar halt_qp;
+	uchar sdtr_data;
+	uchar target_ix;
+	uchar q_cntl, tid_no;
+	uchar cur_dvc_qng;
+	uchar asyn_sdtr;
+	uchar scsi_status;
+	asc_board_t *boardp;
+
+	BUG_ON(!asc_dvc->drv_ptr);
+	boardp = asc_dvc->drv_ptr;
+
+	iop_base = asc_dvc->iop_base;
+	int_halt_code = AscReadLramWord(iop_base, ASCV_HALTCODE_W);
+
+	halt_qp = AscReadLramByte(iop_base, ASCV_CURCDB_B);
+	halt_q_addr = ASC_QNO_TO_QADDR(halt_qp);
+	target_ix = AscReadLramByte(iop_base,
+				    (ushort)(halt_q_addr +
+					     (ushort)ASC_SCSIQ_B_TARGET_IX));
+	q_cntl = AscReadLramByte(iop_base,
+			    (ushort)(halt_q_addr + (ushort)ASC_SCSIQ_B_CNTL));
+	tid_no = ASC_TIX_TO_TID(target_ix);
+	target_id = (uchar)ASC_TID_TO_TARGET_ID(tid_no);
+	if (asc_dvc->pci_fix_asyn_xfer & target_id) {
+		asyn_sdtr = ASYN_SDTR_DATA_FIX_PCI_REV_AB;
+	} else {
+		asyn_sdtr = 0;
+	}
+	if (int_halt_code == ASC_HALT_DISABLE_ASYN_USE_SYN_FIX) {
+		if (asc_dvc->pci_fix_asyn_xfer & target_id) {
+			AscSetChipSDTR(iop_base, 0, tid_no);
+			boardp->sdtr_data[tid_no] = 0;
+		}
+		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+		return (0);
+	} else if (int_halt_code == ASC_HALT_ENABLE_ASYN_USE_SYN_FIX) {
+		if (asc_dvc->pci_fix_asyn_xfer & target_id) {
+			AscSetChipSDTR(iop_base, asyn_sdtr, tid_no);
+			boardp->sdtr_data[tid_no] = asyn_sdtr;
+		}
+		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+		return (0);
+	} else if (int_halt_code == ASC_HALT_EXTMSG_IN) {
+		AscMemWordCopyPtrFromLram(iop_base,
+					  ASCV_MSGIN_BEG,
+					  (uchar *)&ext_msg,
+					  sizeof(EXT_MSG) >> 1);
+
+		if (ext_msg.msg_type == EXTENDED_MESSAGE &&
+		    ext_msg.msg_req == EXTENDED_SDTR &&
+		    ext_msg.msg_len == MS_SDTR_LEN) {
+			sdtr_accept = TRUE;
+			if ((ext_msg.req_ack_offset > ASC_SYN_MAX_OFFSET)) {
+
+				sdtr_accept = FALSE;
+				ext_msg.req_ack_offset = ASC_SYN_MAX_OFFSET;
+			}
+			if ((ext_msg.xfer_period <
+			     asc_dvc->sdtr_period_tbl[asc_dvc->
+						      host_init_sdtr_index])
+			    || (ext_msg.xfer_period >
+				asc_dvc->sdtr_period_tbl[asc_dvc->
+							 max_sdtr_index])) {
+				sdtr_accept = FALSE;
+				ext_msg.xfer_period =
+				    asc_dvc->sdtr_period_tbl[asc_dvc->
+							     host_init_sdtr_index];
+			}
+			if (sdtr_accept) {
+				sdtr_data =
+				    AscCalSDTRData(asc_dvc, ext_msg.xfer_period,
+						   ext_msg.req_ack_offset);
+				if ((sdtr_data == 0xFF)) {
+
+					q_cntl |= QC_MSG_OUT;
+					asc_dvc->init_sdtr &= ~target_id;
+					asc_dvc->sdtr_done &= ~target_id;
+					AscSetChipSDTR(iop_base, asyn_sdtr,
+						       tid_no);
+					boardp->sdtr_data[tid_no] = asyn_sdtr;
+				}
+			}
+			if (ext_msg.req_ack_offset == 0) {
+
+				q_cntl &= ~QC_MSG_OUT;
+				asc_dvc->init_sdtr &= ~target_id;
+				asc_dvc->sdtr_done &= ~target_id;
+				AscSetChipSDTR(iop_base, asyn_sdtr, tid_no);
+			} else {
+				if (sdtr_accept && (q_cntl & QC_MSG_OUT)) {
+
+					q_cntl &= ~QC_MSG_OUT;
+					asc_dvc->sdtr_done |= target_id;
+					asc_dvc->init_sdtr |= target_id;
+					asc_dvc->pci_fix_asyn_xfer &=
+					    ~target_id;
+					sdtr_data =
+					    AscCalSDTRData(asc_dvc,
+							   ext_msg.xfer_period,
+							   ext_msg.
+							   req_ack_offset);
+					AscSetChipSDTR(iop_base, sdtr_data,
+						       tid_no);
+					boardp->sdtr_data[tid_no] = sdtr_data;
+				} else {
+
+					q_cntl |= QC_MSG_OUT;
+					AscMsgOutSDTR(asc_dvc,
+						      ext_msg.xfer_period,
+						      ext_msg.req_ack_offset);
+					asc_dvc->pci_fix_asyn_xfer &=
+					    ~target_id;
+					sdtr_data =
+					    AscCalSDTRData(asc_dvc,
+							   ext_msg.xfer_period,
+							   ext_msg.
+							   req_ack_offset);
+					AscSetChipSDTR(iop_base, sdtr_data,
+						       tid_no);
+					boardp->sdtr_data[tid_no] = sdtr_data;
+					asc_dvc->sdtr_done |= target_id;
+					asc_dvc->init_sdtr |= target_id;
+				}
+			}
+
+			AscWriteLramByte(iop_base,
+					 (ushort)(halt_q_addr +
+						  (ushort)ASC_SCSIQ_B_CNTL),
+					 q_cntl);
+			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+			return (0);
+		} else if (ext_msg.msg_type == EXTENDED_MESSAGE &&
+			   ext_msg.msg_req == EXTENDED_WDTR &&
+			   ext_msg.msg_len == MS_WDTR_LEN) {
+
+			ext_msg.wdtr_width = 0;
+			AscMemWordCopyPtrToLram(iop_base,
+						ASCV_MSGOUT_BEG,
+						(uchar *)&ext_msg,
+						sizeof(EXT_MSG) >> 1);
+			q_cntl |= QC_MSG_OUT;
+			AscWriteLramByte(iop_base,
+					 (ushort)(halt_q_addr +
+						  (ushort)ASC_SCSIQ_B_CNTL),
+					 q_cntl);
+			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+			return (0);
+		} else {
+
+			ext_msg.msg_type = MESSAGE_REJECT;
+			AscMemWordCopyPtrToLram(iop_base,
+						ASCV_MSGOUT_BEG,
+						(uchar *)&ext_msg,
+						sizeof(EXT_MSG) >> 1);
+			q_cntl |= QC_MSG_OUT;
+			AscWriteLramByte(iop_base,
+					 (ushort)(halt_q_addr +
+						  (ushort)ASC_SCSIQ_B_CNTL),
+					 q_cntl);
+			AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+			return (0);
+		}
+	} else if (int_halt_code == ASC_HALT_CHK_CONDITION) {
+
+		q_cntl |= QC_REQ_SENSE;
+
+		if ((asc_dvc->init_sdtr & target_id) != 0) {
+
+			asc_dvc->sdtr_done &= ~target_id;
+
+			sdtr_data = AscGetMCodeInitSDTRAtID(iop_base, tid_no);
+			q_cntl |= QC_MSG_OUT;
+			AscMsgOutSDTR(asc_dvc,
+				      asc_dvc->
+				      sdtr_period_tbl[(sdtr_data >> 4) &
+						      (uchar)(asc_dvc->
+							      max_sdtr_index -
+							      1)],
+				      (uchar)(sdtr_data & (uchar)
+					      ASC_SYN_MAX_OFFSET));
+		}
+
+		AscWriteLramByte(iop_base,
+				 (ushort)(halt_q_addr +
+					  (ushort)ASC_SCSIQ_B_CNTL), q_cntl);
+
+		tag_code = AscReadLramByte(iop_base,
+					   (ushort)(halt_q_addr + (ushort)
+						    ASC_SCSIQ_B_TAG_CODE));
+		tag_code &= 0xDC;
+		if ((asc_dvc->pci_fix_asyn_xfer & target_id)
+		    && !(asc_dvc->pci_fix_asyn_xfer_always & target_id)
+		    ) {
+
+			tag_code |= (ASC_TAG_FLAG_DISABLE_DISCONNECT
+				     | ASC_TAG_FLAG_DISABLE_ASYN_USE_SYN_FIX);
+
+		}
+		AscWriteLramByte(iop_base,
+				 (ushort)(halt_q_addr +
+					  (ushort)ASC_SCSIQ_B_TAG_CODE),
+				 tag_code);
+
+		q_status = AscReadLramByte(iop_base,
+					   (ushort)(halt_q_addr + (ushort)
+						    ASC_SCSIQ_B_STATUS));
+		q_status |= (QS_READY | QS_BUSY);
+		AscWriteLramByte(iop_base,
+				 (ushort)(halt_q_addr +
+					  (ushort)ASC_SCSIQ_B_STATUS),
+				 q_status);
+
+		scsi_busy = AscReadLramByte(iop_base, (ushort)ASCV_SCSIBUSY_B);
+		scsi_busy &= ~target_id;
+		AscWriteLramByte(iop_base, (ushort)ASCV_SCSIBUSY_B, scsi_busy);
+
+		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+		return (0);
+	} else if (int_halt_code == ASC_HALT_SDTR_REJECTED) {
+
+		AscMemWordCopyPtrFromLram(iop_base,
+					  ASCV_MSGOUT_BEG,
+					  (uchar *)&out_msg,
+					  sizeof(EXT_MSG) >> 1);
+
+		if ((out_msg.msg_type == EXTENDED_MESSAGE) &&
+		    (out_msg.msg_len == MS_SDTR_LEN) &&
+		    (out_msg.msg_req == EXTENDED_SDTR)) {
+
+			asc_dvc->init_sdtr &= ~target_id;
+			asc_dvc->sdtr_done &= ~target_id;
+			AscSetChipSDTR(iop_base, asyn_sdtr, tid_no);
+			boardp->sdtr_data[tid_no] = asyn_sdtr;
+		}
+		q_cntl &= ~QC_MSG_OUT;
+		AscWriteLramByte(iop_base,
+				 (ushort)(halt_q_addr +
+					  (ushort)ASC_SCSIQ_B_CNTL), q_cntl);
+		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+		return (0);
+	} else if (int_halt_code == ASC_HALT_SS_QUEUE_FULL) {
+
+		scsi_status = AscReadLramByte(iop_base,
+					      (ushort)((ushort)halt_q_addr +
+						       (ushort)
+						       ASC_SCSIQ_SCSI_STATUS));
+		cur_dvc_qng =
+		    AscReadLramByte(iop_base,
+				    (ushort)((ushort)ASC_QADR_BEG +
+					     (ushort)target_ix));
+		if ((cur_dvc_qng > 0) && (asc_dvc->cur_dvc_qng[tid_no] > 0)) {
+
+			scsi_busy = AscReadLramByte(iop_base,
+						    (ushort)ASCV_SCSIBUSY_B);
+			scsi_busy |= target_id;
+			AscWriteLramByte(iop_base,
+					 (ushort)ASCV_SCSIBUSY_B, scsi_busy);
+			asc_dvc->queue_full_or_busy |= target_id;
+
+			if (scsi_status == SAM_STAT_TASK_SET_FULL) {
+				if (cur_dvc_qng > ASC_MIN_TAGGED_CMD) {
+					cur_dvc_qng -= 1;
+					asc_dvc->max_dvc_qng[tid_no] =
+					    cur_dvc_qng;
+
+					AscWriteLramByte(iop_base,
+							 (ushort)((ushort)
+								  ASCV_MAX_DVC_QNG_BEG
+								  + (ushort)
+								  tid_no),
+							 cur_dvc_qng);
+
+					/*
+					 * Set the device queue depth to the
+					 * number of active requests when the
+					 * QUEUE FULL condition was encountered.
+					 */
+					boardp->queue_full |= target_id;
+					boardp->queue_full_cnt[tid_no] =
+					    cur_dvc_qng;
+				}
+			}
+		}
+		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+		return (0);
+	}
+#if CC_VERY_LONG_SG_LIST
+	else if (int_halt_code == ASC_HALT_HOST_COPY_SG_LIST_TO_RISC) {
+		uchar q_no;
+		ushort q_addr;
+		uchar sg_wk_q_no;
+		uchar first_sg_wk_q_no;
+		ASC_SCSI_Q *scsiq;	/* Ptr to driver request. */
+		ASC_SG_HEAD *sg_head;	/* Ptr to driver SG request. */
+		ASC_SG_LIST_Q scsi_sg_q;	/* Structure written to queue. */
+		ushort sg_list_dwords;
+		ushort sg_entry_cnt;
+		uchar next_qp;
+		int i;
+
+		q_no = AscReadLramByte(iop_base, (ushort)ASCV_REQ_SG_LIST_QP);
+		if (q_no == ASC_QLINK_END)
+			return 0;
+
+		q_addr = ASC_QNO_TO_QADDR(q_no);
+
+		/*
+		 * Convert the request's SRB pointer to a host ASC_SCSI_REQ
+		 * structure pointer using a macro provided by the driver.
+		 * The ASC_SCSI_REQ pointer provides a pointer to the
+		 * host ASC_SG_HEAD structure.
+		 */
+		/* Read request's SRB pointer. */
+		scsiq = (ASC_SCSI_Q *)
+		    ASC_SRB2SCSIQ(ASC_U32_TO_VADDR(AscReadLramDWord(iop_base,
+								    (ushort)
+								    (q_addr +
+								     ASC_SCSIQ_D_SRBPTR))));
+
+		/*
+		 * Get request's first and working SG queue.
+		 */
+		sg_wk_q_no = AscReadLramByte(iop_base,
+					     (ushort)(q_addr +
+						      ASC_SCSIQ_B_SG_WK_QP));
+
+		first_sg_wk_q_no = AscReadLramByte(iop_base,
+						   (ushort)(q_addr +
+							    ASC_SCSIQ_B_FIRST_SG_WK_QP));
+
+		/*
+		 * Reset request's working SG queue back to the
+		 * first SG queue.
+		 */
+		AscWriteLramByte(iop_base,
+				 (ushort)(q_addr +
+					  (ushort)ASC_SCSIQ_B_SG_WK_QP),
+				 first_sg_wk_q_no);
+
+		sg_head = scsiq->sg_head;
+
+		/*
+		 * Set sg_entry_cnt to the number of SG elements
+		 * that will be completed on this interrupt.
+		 *
+		 * Note: The allocated SG queues contain ASC_MAX_SG_LIST - 1
+		 * SG elements. The data_cnt and data_addr fields which
+		 * add 1 to the SG element capacity are not used when
+		 * restarting SG handling after a halt.
+		 */
+		if (scsiq->remain_sg_entry_cnt > (ASC_MAX_SG_LIST - 1)) {
+			sg_entry_cnt = ASC_MAX_SG_LIST - 1;
+
+			/*
+			 * Keep track of remaining number of SG elements that
+			 * will need to be handled on the next interrupt.
+			 */
+			scsiq->remain_sg_entry_cnt -= (ASC_MAX_SG_LIST - 1);
+		} else {
+			sg_entry_cnt = scsiq->remain_sg_entry_cnt;
+			scsiq->remain_sg_entry_cnt = 0;
+		}
+
+		/*
+		 * Copy SG elements into the list of allocated SG queues.
+		 *
+		 * Last index completed is saved in scsiq->next_sg_index.
+		 */
+		next_qp = first_sg_wk_q_no;
+		q_addr = ASC_QNO_TO_QADDR(next_qp);
+		scsi_sg_q.sg_head_qp = q_no;
+		scsi_sg_q.cntl = QCSG_SG_XFER_LIST;
+		for (i = 0; i < sg_head->queue_cnt; i++) {
+			scsi_sg_q.seq_no = i + 1;
+			if (sg_entry_cnt > ASC_SG_LIST_PER_Q) {
+				sg_list_dwords = (uchar)(ASC_SG_LIST_PER_Q * 2);
+				sg_entry_cnt -= ASC_SG_LIST_PER_Q;
+				/*
+				 * After very first SG queue RISC FW uses next
+				 * SG queue first element then checks sg_list_cnt
+				 * against zero and then decrements, so set
+				 * sg_list_cnt 1 less than number of SG elements
+				 * in each SG queue.
+				 */
+				scsi_sg_q.sg_list_cnt = ASC_SG_LIST_PER_Q - 1;
+				scsi_sg_q.sg_cur_list_cnt =
+				    ASC_SG_LIST_PER_Q - 1;
+			} else {
+				/*
+				 * This is the last SG queue in the list of
+				 * allocated SG queues. If there are more
+				 * SG elements than will fit in the allocated
+				 * queues, then set the QCSG_SG_XFER_MORE flag.
+				 */
+				if (scsiq->remain_sg_entry_cnt != 0) {
+					scsi_sg_q.cntl |= QCSG_SG_XFER_MORE;
+				} else {
+					scsi_sg_q.cntl |= QCSG_SG_XFER_END;
+				}
+				/* equals sg_entry_cnt * 2 */
+				sg_list_dwords = sg_entry_cnt << 1;
+				scsi_sg_q.sg_list_cnt = sg_entry_cnt - 1;
+				scsi_sg_q.sg_cur_list_cnt = sg_entry_cnt - 1;
+				sg_entry_cnt = 0;
+			}
+
+			scsi_sg_q.q_no = next_qp;
+			AscMemWordCopyPtrToLram(iop_base,
+						q_addr + ASC_SCSIQ_SGHD_CPY_BEG,
+						(uchar *)&scsi_sg_q,
+						sizeof(ASC_SG_LIST_Q) >> 1);
+
+			AscMemDWordCopyPtrToLram(iop_base,
+						 q_addr + ASC_SGQ_LIST_BEG,
+						 (uchar *)&sg_head->
+						 sg_list[scsiq->next_sg_index],
+						 sg_list_dwords);
+
+			scsiq->next_sg_index += ASC_SG_LIST_PER_Q;
+
+			/*
+			 * If the just completed SG queue contained the
+			 * last SG element, then no more SG queues need
+			 * to be written.
+			 */
+			if (scsi_sg_q.cntl & QCSG_SG_XFER_END) {
+				break;
+			}
+
+			next_qp = AscReadLramByte(iop_base,
+						  (ushort)(q_addr +
+							   ASC_SCSIQ_B_FWD));
+			q_addr = ASC_QNO_TO_QADDR(next_qp);
+		}
+
+		/*
+		 * Clear the halt condition so the RISC will be restarted
+		 * after the return.
+		 */
+		AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0);
+		return (0);
+	}
+#endif /* CC_VERY_LONG_SG_LIST */
+	return (0);
+}
+
+/*
+ * void
+ * DvcGetQinfo(PortAddr iop_base, ushort s_addr, uchar *inbuf, int words)
+ *
+ * Calling/Exit State:
+ *    none
+ *
+ * Description:
+ *     Input an ASC_QDONE_INFO structure from the chip
+ */
+static void
+DvcGetQinfo(PortAddr iop_base, ushort s_addr, uchar *inbuf, int words)
+{
+	int i;
+	ushort word;
+
+	AscSetChipLramAddr(iop_base, s_addr);
+	for (i = 0; i < 2 * words; i += 2) {
+		if (i == 10) {
+			continue;
+		}
+		word = inpw(iop_base + IOP_RAM_DATA);
+		inbuf[i] = word & 0xff;
+		inbuf[i + 1] = (word >> 8) & 0xff;
+	}
+	ASC_DBG_PRT_HEX(2, "DvcGetQinfo", inbuf, 2 * words);
+}
+
+static uchar
+_AscCopyLramScsiDoneQ(PortAddr iop_base,
+		      ushort q_addr,
+		      ASC_QDONE_INFO *scsiq, ASC_DCNT max_dma_count)
+{
+	ushort _val;
+	uchar sg_queue_cnt;
+
+	DvcGetQinfo(iop_base,
+		    q_addr + ASC_SCSIQ_DONE_INFO_BEG,
+		    (uchar *)scsiq,
+		    (sizeof(ASC_SCSIQ_2) + sizeof(ASC_SCSIQ_3)) / 2);
+
+	_val = AscReadLramWord(iop_base,
+			       (ushort)(q_addr + (ushort)ASC_SCSIQ_B_STATUS));
+	scsiq->q_status = (uchar)_val;
+	scsiq->q_no = (uchar)(_val >> 8);
+	_val = AscReadLramWord(iop_base,
+			       (ushort)(q_addr + (ushort)ASC_SCSIQ_B_CNTL));
+	scsiq->cntl = (uchar)_val;
+	sg_queue_cnt = (uchar)(_val >> 8);
+	_val = AscReadLramWord(iop_base,
+			       (ushort)(q_addr +
+					(ushort)ASC_SCSIQ_B_SENSE_LEN));
+	scsiq->sense_len = (uchar)_val;
+	scsiq->extra_bytes = (uchar)(_val >> 8);
+
+	/*
+	 * Read high word of remain bytes from alternate location.
+	 */
+	scsiq->remain_bytes = (((ADV_DCNT)AscReadLramWord(iop_base,
+							  (ushort)(q_addr +
+								   (ushort)
+								   ASC_SCSIQ_W_ALT_DC1)))
+			       << 16);
+	/*
+	 * Read low word of remain bytes from original location.
+	 */
+	scsiq->remain_bytes += AscReadLramWord(iop_base,
+					       (ushort)(q_addr + (ushort)
+							ASC_SCSIQ_DW_REMAIN_XFER_CNT));
+
+	scsiq->remain_bytes &= max_dma_count;
+	return sg_queue_cnt;
+}
+
+/*
+ * asc_isr_callback() - Second Level Interrupt Handler called by AscISR().
+ *
+ * Interrupt callback function for the Narrow SCSI Asc Library.
+ */
+static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
+{
+	asc_board_t *boardp;
+	struct scsi_cmnd *scp;
+	struct Scsi_Host *shost;
+
+	ASC_DBG2(1, "asc_isr_callback: asc_dvc_varp 0x%lx, qdonep 0x%lx\n",
+		 (ulong)asc_dvc_varp, (ulong)qdonep);
+	ASC_DBG_PRT_ASC_QDONE_INFO(2, qdonep);
+
+	/*
+	 * Get the struct scsi_cmnd structure and Scsi_Host structure for the
+	 * command that has been completed.
+	 */
+	scp = (struct scsi_cmnd *)ASC_U32_TO_VADDR(qdonep->d2.srb_ptr);
+	ASC_DBG1(1, "asc_isr_callback: scp 0x%lx\n", (ulong)scp);
+
+	if (scp == NULL) {
+		ASC_PRINT("asc_isr_callback: scp is NULL\n");
+		return;
+	}
+	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
+
+	shost = scp->device->host;
+	ASC_STATS(shost, callback);
+	ASC_DBG1(1, "asc_isr_callback: shost 0x%lx\n", (ulong)shost);
+
+	boardp = ASC_BOARDP(shost);
+	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
+
+	/*
+	 * 'qdonep' contains the command's ending status.
+	 */
+	switch (qdonep->d3.done_stat) {
+	case QD_NO_ERROR:
+		ASC_DBG(2, "asc_isr_callback: QD_NO_ERROR\n");
+		scp->result = 0;
+
+		/*
+		 * Check for an underrun condition.
+		 *
+		 * If there was no error and an underrun condition, then
+		 * return the number of underrun bytes.
+		 */
+		if (scp->request_bufflen != 0 && qdonep->remain_bytes != 0 &&
+		    qdonep->remain_bytes <= scp->request_bufflen) {
+			ASC_DBG1(1,
+				 "asc_isr_callback: underrun condition %u bytes\n",
+				 (unsigned)qdonep->remain_bytes);
+			scp->resid = qdonep->remain_bytes;
+		}
+		break;
+
+	case QD_WITH_ERROR:
+		ASC_DBG(2, "asc_isr_callback: QD_WITH_ERROR\n");
+		switch (qdonep->d3.host_stat) {
+		case QHSTA_NO_ERROR:
+			if (qdonep->d3.scsi_stat == SAM_STAT_CHECK_CONDITION) {
+				ASC_DBG(2,
+					"asc_isr_callback: SAM_STAT_CHECK_CONDITION\n");
+				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
+						  sizeof(scp->sense_buffer));
+				/*
+				 * Note: The 'status_byte()' macro used by
+				 * target drivers defined in scsi.h shifts the
+				 * status byte returned by host drivers right
+				 * by 1 bit.  This is why target drivers also
+				 * use right shifted status byte definitions.
+				 * For instance target drivers use
+				 * CHECK_CONDITION, defined to 0x1, instead of
+				 * the SCSI defined check condition value of
+				 * 0x2. Host drivers are supposed to return
+				 * the status byte as it is defined by SCSI.
+				 */
+				scp->result = DRIVER_BYTE(DRIVER_SENSE) |
+				    STATUS_BYTE(qdonep->d3.scsi_stat);
+			} else {
+				scp->result = STATUS_BYTE(qdonep->d3.scsi_stat);
+			}
+			break;
+
+		default:
+			/* QHSTA error occurred */
+			ASC_DBG1(1, "asc_isr_callback: host_stat 0x%x\n",
+				 qdonep->d3.host_stat);
+			scp->result = HOST_BYTE(DID_BAD_TARGET);
+			break;
+		}
+		break;
+
+	case QD_ABORTED_BY_HOST:
+		ASC_DBG(1, "asc_isr_callback: QD_ABORTED_BY_HOST\n");
+		scp->result =
+		    HOST_BYTE(DID_ABORT) | MSG_BYTE(qdonep->d3.
+						    scsi_msg) |
+		    STATUS_BYTE(qdonep->d3.scsi_stat);
+		break;
+
+	default:
+		ASC_DBG1(1, "asc_isr_callback: done_stat 0x%x\n",
+			 qdonep->d3.done_stat);
+		scp->result =
+		    HOST_BYTE(DID_ERROR) | MSG_BYTE(qdonep->d3.
+						    scsi_msg) |
+		    STATUS_BYTE(qdonep->d3.scsi_stat);
+		break;
+	}
+
+	/*
+	 * If the 'init_tidmask' bit isn't already set for the target and the
+	 * current request finished normally, then set the bit for the target
+	 * to indicate that a device is present.
+	 */
+	if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scp->device->id)) == 0 &&
+	    qdonep->d3.done_stat == QD_NO_ERROR &&
+	    qdonep->d3.host_stat == QHSTA_NO_ERROR) {
+		boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
+	}
+
+	asc_scsi_done(scp);
+
+	return;
+}
+
+static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
+{
+	uchar next_qp;
+	uchar n_q_used;
+	uchar sg_list_qp;
+	uchar sg_queue_cnt;
+	uchar q_cnt;
+	uchar done_q_tail;
+	uchar tid_no;
+	ASC_SCSI_BIT_ID_TYPE scsi_busy;
+	ASC_SCSI_BIT_ID_TYPE target_id;
+	PortAddr iop_base;
+	ushort q_addr;
+	ushort sg_q_addr;
+	uchar cur_target_qng;
+	ASC_QDONE_INFO scsiq_buf;
+	ASC_QDONE_INFO *scsiq;
+	int false_overrun;
+
+	iop_base = asc_dvc->iop_base;
+	n_q_used = 1;
+	scsiq = (ASC_QDONE_INFO *)&scsiq_buf;
+	done_q_tail = (uchar)AscGetVarDoneQTail(iop_base);
+	q_addr = ASC_QNO_TO_QADDR(done_q_tail);
+	next_qp = AscReadLramByte(iop_base,
+				  (ushort)(q_addr + (ushort)ASC_SCSIQ_B_FWD));
+	if (next_qp != ASC_QLINK_END) {
+		AscPutVarDoneQTail(iop_base, next_qp);
+		q_addr = ASC_QNO_TO_QADDR(next_qp);
+		sg_queue_cnt = _AscCopyLramScsiDoneQ(iop_base, q_addr, scsiq,
+						     asc_dvc->max_dma_count);
+		AscWriteLramByte(iop_base,
+				 (ushort)(q_addr +
+					  (ushort)ASC_SCSIQ_B_STATUS),
+				 (uchar)(scsiq->
+					 q_status & (uchar)~(QS_READY |
+							     QS_ABORTED)));
+		tid_no = ASC_TIX_TO_TID(scsiq->d2.target_ix);
+		target_id = ASC_TIX_TO_TARGET_ID(scsiq->d2.target_ix);
+		if ((scsiq->cntl & QC_SG_HEAD) != 0) {
+			sg_q_addr = q_addr;
+			sg_list_qp = next_qp;
+			for (q_cnt = 0; q_cnt < sg_queue_cnt; q_cnt++) {
+				sg_list_qp = AscReadLramByte(iop_base,
+							     (ushort)(sg_q_addr
+								      + (ushort)
+								      ASC_SCSIQ_B_FWD));
+				sg_q_addr = ASC_QNO_TO_QADDR(sg_list_qp);
+				if (sg_list_qp == ASC_QLINK_END) {
+					AscSetLibErrorCode(asc_dvc,
+							   ASCQ_ERR_SG_Q_LINKS);
+					scsiq->d3.done_stat = QD_WITH_ERROR;
+					scsiq->d3.host_stat =
+					    QHSTA_D_QDONE_SG_LIST_CORRUPTED;
+					goto FATAL_ERR_QDONE;
+				}
+				AscWriteLramByte(iop_base,
+						 (ushort)(sg_q_addr + (ushort)
+							  ASC_SCSIQ_B_STATUS),
+						 QS_FREE);
+			}
+			n_q_used = sg_queue_cnt + 1;
+			AscPutVarDoneQTail(iop_base, sg_list_qp);
+		}
+		if (asc_dvc->queue_full_or_busy & target_id) {
+			cur_target_qng = AscReadLramByte(iop_base,
+							 (ushort)((ushort)
+								  ASC_QADR_BEG
+								  + (ushort)
+								  scsiq->d2.
+								  target_ix));
+			if (cur_target_qng < asc_dvc->max_dvc_qng[tid_no]) {
+				scsi_busy = AscReadLramByte(iop_base, (ushort)
+							    ASCV_SCSIBUSY_B);
+				scsi_busy &= ~target_id;
+				AscWriteLramByte(iop_base,
+						 (ushort)ASCV_SCSIBUSY_B,
+						 scsi_busy);
+				asc_dvc->queue_full_or_busy &= ~target_id;
+			}
+		}
+		if (asc_dvc->cur_total_qng >= n_q_used) {
+			asc_dvc->cur_total_qng -= n_q_used;
+			if (asc_dvc->cur_dvc_qng[tid_no] != 0) {
+				asc_dvc->cur_dvc_qng[tid_no]--;
+			}
+		} else {
+			AscSetLibErrorCode(asc_dvc, ASCQ_ERR_CUR_QNG);
+			scsiq->d3.done_stat = QD_WITH_ERROR;
+			goto FATAL_ERR_QDONE;
+		}
+		if ((scsiq->d2.srb_ptr == 0UL) ||
+		    ((scsiq->q_status & QS_ABORTED) != 0)) {
+			return (0x11);
+		} else if (scsiq->q_status == QS_DONE) {
+			false_overrun = FALSE;
+			if (scsiq->extra_bytes != 0) {
+				scsiq->remain_bytes +=
+				    (ADV_DCNT)scsiq->extra_bytes;
+			}
+			if (scsiq->d3.done_stat == QD_WITH_ERROR) {
+				if (scsiq->d3.host_stat ==
+				    QHSTA_M_DATA_OVER_RUN) {
+					if ((scsiq->
+					     cntl & (QC_DATA_IN | QC_DATA_OUT))
+					    == 0) {
+						scsiq->d3.done_stat =
+						    QD_NO_ERROR;
+						scsiq->d3.host_stat =
+						    QHSTA_NO_ERROR;
+					} else if (false_overrun) {
+						scsiq->d3.done_stat =
+						    QD_NO_ERROR;
+						scsiq->d3.host_stat =
+						    QHSTA_NO_ERROR;
+					}
+				} else if (scsiq->d3.host_stat ==
+					   QHSTA_M_HUNG_REQ_SCSI_BUS_RESET) {
+					AscStopChip(iop_base);
+					AscSetChipControl(iop_base,
+							  (uchar)(CC_SCSI_RESET
+								  | CC_HALT));
+					udelay(60);
+					AscSetChipControl(iop_base, CC_HALT);
+					AscSetChipStatus(iop_base,
+							 CIW_CLR_SCSI_RESET_INT);
+					AscSetChipStatus(iop_base, 0);
+					AscSetChipControl(iop_base, 0);
+				}
+			}
+			if ((scsiq->cntl & QC_NO_CALLBACK) == 0) {
+				asc_isr_callback(asc_dvc, scsiq);
+			} else {
+				if ((AscReadLramByte(iop_base,
+						     (ushort)(q_addr + (ushort)
+							      ASC_SCSIQ_CDB_BEG))
+				     == START_STOP)) {
+					asc_dvc->unit_not_ready &= ~target_id;
+					if (scsiq->d3.done_stat != QD_NO_ERROR) {
+						asc_dvc->start_motor &=
+						    ~target_id;
+					}
+				}
+			}
+			return (1);
+		} else {
+			AscSetLibErrorCode(asc_dvc, ASCQ_ERR_Q_STATUS);
+ FATAL_ERR_QDONE:
+			if ((scsiq->cntl & QC_NO_CALLBACK) == 0) {
+				asc_isr_callback(asc_dvc, scsiq);
+			}
+			return (0x80);
+		}
+	}
+	return (0);
+}
+
+static int AscISR(ASC_DVC_VAR *asc_dvc)
+{
+	ASC_CS_TYPE chipstat;
+	PortAddr iop_base;
+	ushort saved_ram_addr;
+	uchar ctrl_reg;
+	uchar saved_ctrl_reg;
+	int int_pending;
+	int status;
+	uchar host_flag;
+
+	iop_base = asc_dvc->iop_base;
+	int_pending = FALSE;
+
+	if (AscIsIntPending(iop_base) == 0)
+		return int_pending;
+
+	if ((asc_dvc->init_state & ASC_INIT_STATE_END_LOAD_MC) == 0) {
+		return ERR;
+	}
+	if (asc_dvc->in_critical_cnt != 0) {
+		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_ISR_ON_CRITICAL);
+		return ERR;
+	}
+	if (asc_dvc->is_in_int) {
+		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_ISR_RE_ENTRY);
+		return ERR;
+	}
+	asc_dvc->is_in_int = TRUE;
+	ctrl_reg = AscGetChipControl(iop_base);
+	saved_ctrl_reg = ctrl_reg & (~(CC_SCSI_RESET | CC_CHIP_RESET |
+				       CC_SINGLE_STEP | CC_DIAG | CC_TEST));
+	chipstat = AscGetChipStatus(iop_base);
+	if (chipstat & CSW_SCSI_RESET_LATCH) {
+		if (!(asc_dvc->bus_type & (ASC_IS_VL | ASC_IS_EISA))) {
+			int i = 10;
+			int_pending = TRUE;
+			asc_dvc->sdtr_done = 0;
+			saved_ctrl_reg &= (uchar)(~CC_HALT);
+			while ((AscGetChipStatus(iop_base) &
+				CSW_SCSI_RESET_ACTIVE) && (i-- > 0)) {
+				mdelay(100);
+			}
+			AscSetChipControl(iop_base, (CC_CHIP_RESET | CC_HALT));
+			AscSetChipControl(iop_base, CC_HALT);
+			AscSetChipStatus(iop_base, CIW_CLR_SCSI_RESET_INT);
+			AscSetChipStatus(iop_base, 0);
+			chipstat = AscGetChipStatus(iop_base);
+		}
+	}
+	saved_ram_addr = AscGetChipLramAddr(iop_base);
+	host_flag = AscReadLramByte(iop_base,
+				    ASCV_HOST_FLAG_B) &
+	    (uchar)(~ASC_HOST_FLAG_IN_ISR);
+	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B,
+			 (uchar)(host_flag | (uchar)ASC_HOST_FLAG_IN_ISR));
+	if ((chipstat & CSW_INT_PENDING) || (int_pending)) {
+		AscAckInterrupt(iop_base);
+		int_pending = TRUE;
+		if ((chipstat & CSW_HALTED) && (ctrl_reg & CC_SINGLE_STEP)) {
+			if (AscIsrChipHalted(asc_dvc) == ERR) {
+				goto ISR_REPORT_QDONE_FATAL_ERROR;
+			} else {
+				saved_ctrl_reg &= (uchar)(~CC_HALT);
+			}
+		} else {
+ ISR_REPORT_QDONE_FATAL_ERROR:
+			if ((asc_dvc->dvc_cntl & ASC_CNTL_INT_MULTI_Q) != 0) {
+				while (((status =
+					 AscIsrQDone(asc_dvc)) & 0x01) != 0) {
+				}
+			} else {
+				do {
+					if ((status =
+					     AscIsrQDone(asc_dvc)) == 1) {
+						break;
+					}
+				} while (status == 0x11);
+			}
+			if ((status & 0x80) != 0)
+				int_pending = ERR;
+		}
+	}
+	AscWriteLramByte(iop_base, ASCV_HOST_FLAG_B, host_flag);
+	AscSetChipLramAddr(iop_base, saved_ram_addr);
+	AscSetChipControl(iop_base, saved_ctrl_reg);
+	asc_dvc->is_in_int = FALSE;
+	return int_pending;
+}
+
+/*
+ * advansys_reset()
+ *
+ * Reset the bus associated with the command 'scp'.
+ *
+ * This function runs its own thread. Interrupts must be blocked but
+ * sleeping is allowed and no locking other than for host structures is
+ * required. Returns SUCCESS or FAILED.
+ */
+static int advansys_reset(struct scsi_cmnd *scp)
+{
+	struct Scsi_Host *shost;
+	asc_board_t *boardp;
+	ASC_DVC_VAR *asc_dvc_varp;
+	ADV_DVC_VAR *adv_dvc_varp;
+	ulong flags;
+	int status;
+	int ret = SUCCESS;
+
+	ASC_DBG1(1, "advansys_reset: 0x%lx\n", (ulong)scp);
+
+#ifdef ADVANSYS_STATS
+	if (scp->device->host != NULL) {
+		ASC_STATS(scp->device->host, reset);
+	}
+#endif /* ADVANSYS_STATS */
+
+	if ((shost = scp->device->host) == NULL) {
+		scp->result = HOST_BYTE(DID_ERROR);
+		return FAILED;
+	}
+
+	boardp = ASC_BOARDP(shost);
+
+	ASC_PRINT1("advansys_reset: board %d: SCSI bus reset started...\n",
+		   boardp->id);
+	/*
+	 * Check for re-entrancy.
+	 */
+	spin_lock_irqsave(&boardp->lock, flags);
+	if (boardp->flags & ASC_HOST_IN_RESET) {
+		spin_unlock_irqrestore(&boardp->lock, flags);
+		return FAILED;
+	}
+	boardp->flags |= ASC_HOST_IN_RESET;
+	spin_unlock_irqrestore(&boardp->lock, flags);
+
+	if (ASC_NARROW_BOARD(boardp)) {
+		/*
+		 * Narrow Board
+		 */
+		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
+
+		/*
+		 * Reset the chip and SCSI bus.
+		 */
+		ASC_DBG(1, "advansys_reset: before AscInitAsc1000Driver()\n");
+		status = AscInitAsc1000Driver(asc_dvc_varp);
+
+		/* Refer to ASC_IERR_* defintions for meaning of 'err_code'. */
+		if (asc_dvc_varp->err_code) {
+			ASC_PRINT2("advansys_reset: board %d: SCSI bus reset "
+				   "error: 0x%x\n", boardp->id,
+				   asc_dvc_varp->err_code);
+			ret = FAILED;
+		} else if (status) {
+			ASC_PRINT2("advansys_reset: board %d: SCSI bus reset "
+				   "warning: 0x%x\n", boardp->id, status);
+		} else {
+			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
+				   "successful.\n", boardp->id);
+		}
+
+		ASC_DBG(1, "advansys_reset: after AscInitAsc1000Driver()\n");
+		spin_lock_irqsave(&boardp->lock, flags);
+
+	} else {
+		/*
+		 * Wide Board
+		 *
+		 * If the suggest reset bus flags are set, then reset the bus.
+		 * Otherwise only reset the device.
+		 */
+		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
+
+		/*
+		 * Reset the target's SCSI bus.
+		 */
+		ASC_DBG(1, "advansys_reset: before AdvResetChipAndSB()\n");
+		switch (AdvResetChipAndSB(adv_dvc_varp)) {
+		case ASC_TRUE:
+			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
+				   "successful.\n", boardp->id);
+			break;
+		case ASC_FALSE:
+		default:
+			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
+				   "error.\n", boardp->id);
+			ret = FAILED;
+			break;
+		}
+		spin_lock_irqsave(&boardp->lock, flags);
+		AdvISR(adv_dvc_varp);
+	}
+	/* Board lock is held. */
+
+	/* Save the time of the most recently completed reset. */
+	boardp->last_reset = jiffies;
+
+	/* Clear reset flag. */
+	boardp->flags &= ~ASC_HOST_IN_RESET;
+	spin_unlock_irqrestore(&boardp->lock, flags);
+
+	ASC_DBG1(1, "advansys_reset: ret %d\n", ret);
+
+	return ret;
+}
+
+/*
+ * advansys_biosparam()
+ *
+ * Translate disk drive geometry if the "BIOS greater than 1 GB"
+ * support is enabled for a drive.
+ *
+ * ip (information pointer) is an int array with the following definition:
+ * ip[0]: heads
+ * ip[1]: sectors
+ * ip[2]: cylinders
+ */
+static int
+advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
+		   sector_t capacity, int ip[])
+{
+	asc_board_t *boardp;
+
+	ASC_DBG(1, "advansys_biosparam: begin\n");
+	ASC_STATS(sdev->host, biosparam);
+	boardp = ASC_BOARDP(sdev->host);
+	if (ASC_NARROW_BOARD(boardp)) {
+		if ((boardp->dvc_var.asc_dvc_var.dvc_cntl &
+		     ASC_CNTL_BIOS_GT_1GB) && capacity > 0x200000) {
+			ip[0] = 255;
+			ip[1] = 63;
+		} else {
+			ip[0] = 64;
+			ip[1] = 32;
+		}
+	} else {
+		if ((boardp->dvc_var.adv_dvc_var.bios_ctrl &
+		     BIOS_CTRL_EXTENDED_XLAT) && capacity > 0x200000) {
+			ip[0] = 255;
+			ip[1] = 63;
+		} else {
+			ip[0] = 64;
+			ip[1] = 32;
+		}
+	}
+	ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
+	ASC_DBG(1, "advansys_biosparam: end\n");
+	return 0;
+}
+
+/*
+ * First-level interrupt handler.
+ *
+ * 'dev_id' is a pointer to the interrupting adapter's Scsi_Host.
+ */
+static irqreturn_t advansys_interrupt(int irq, void *dev_id)
+{
+	unsigned long flags;
+	struct Scsi_Host *shost = dev_id;
+	asc_board_t *boardp = ASC_BOARDP(shost);
+	irqreturn_t result = IRQ_NONE;
+
+	ASC_DBG1(2, "advansys_interrupt: boardp 0x%p\n", boardp);
+	spin_lock_irqsave(&boardp->lock, flags);
+	if (ASC_NARROW_BOARD(boardp)) {
+		if (AscIsIntPending(shost->io_port)) {
+			result = IRQ_HANDLED;
+			ASC_STATS(shost, interrupt);
+			ASC_DBG(1, "advansys_interrupt: before AscISR()\n");
+			AscISR(&boardp->dvc_var.asc_dvc_var);
+		}
+	} else {
+		ASC_DBG(1, "advansys_interrupt: before AdvISR()\n");
+		if (AdvISR(&boardp->dvc_var.adv_dvc_var)) {
+			result = IRQ_HANDLED;
+			ASC_STATS(shost, interrupt);
+		}
+	}
+	spin_unlock_irqrestore(&boardp->lock, flags);
+
+	ASC_DBG(1, "advansys_interrupt: end\n");
+	return result;
+}
+
+static int AscHostReqRiscHalt(PortAddr iop_base)
+{
+	int count = 0;
+	int sta = 0;
+	uchar saved_stop_code;
+
+	if (AscIsChipHalted(iop_base))
+		return (1);
+	saved_stop_code = AscReadLramByte(iop_base, ASCV_STOP_CODE_B);
+	AscWriteLramByte(iop_base, ASCV_STOP_CODE_B,
+			 ASC_STOP_HOST_REQ_RISC_HALT | ASC_STOP_REQ_RISC_STOP);
+	do {
+		if (AscIsChipHalted(iop_base)) {
+			sta = 1;
+			break;
+		}
+		mdelay(100);
+	} while (count++ < 20);
+	AscWriteLramByte(iop_base, ASCV_STOP_CODE_B, saved_stop_code);
+	return (sta);
+}
+
+static int
+AscSetRunChipSynRegAtID(PortAddr iop_base, uchar tid_no, uchar sdtr_data)
+{
+	int sta = FALSE;
+
+	if (AscHostReqRiscHalt(iop_base)) {
+		sta = AscSetChipSynRegAtID(iop_base, tid_no, sdtr_data);
+		AscStartChip(iop_base);
+	}
+	return sta;
+}
+
+static void AscAsyncFix(ASC_DVC_VAR *asc_dvc, struct scsi_device *sdev)
+{
+	char type = sdev->type;
+	ASC_SCSI_BIT_ID_TYPE tid_bits = 1 << sdev->id;
+
+	if (!(asc_dvc->bug_fix_cntl & ASC_BUG_FIX_ASYN_USE_SYN))
+		return;
+	if (asc_dvc->init_sdtr & tid_bits)
+		return;
+
+	if ((type == TYPE_ROM) && (strncmp(sdev->vendor, "HP ", 3) == 0))
+		asc_dvc->pci_fix_asyn_xfer_always |= tid_bits;
+
+	asc_dvc->pci_fix_asyn_xfer |= tid_bits;
+	if ((type == TYPE_PROCESSOR) || (type == TYPE_SCANNER) ||
+	    (type == TYPE_ROM) || (type == TYPE_TAPE))
+		asc_dvc->pci_fix_asyn_xfer &= ~tid_bits;
+
+	if (asc_dvc->pci_fix_asyn_xfer & tid_bits)
+		AscSetRunChipSynRegAtID(asc_dvc->iop_base, sdev->id,
+					ASYN_SDTR_DATA_FIX_PCI_REV_AB);
+}
+
+static void
+advansys_narrow_slave_configure(struct scsi_device *sdev, ASC_DVC_VAR *asc_dvc)
+{
+	ASC_SCSI_BIT_ID_TYPE tid_bit = 1 << sdev->id;
+	ASC_SCSI_BIT_ID_TYPE orig_use_tagged_qng = asc_dvc->use_tagged_qng;
+
+	if (sdev->lun == 0) {
+		ASC_SCSI_BIT_ID_TYPE orig_init_sdtr = asc_dvc->init_sdtr;
+		if ((asc_dvc->cfg->sdtr_enable & tid_bit) && sdev->sdtr) {
+			asc_dvc->init_sdtr |= tid_bit;
+		} else {
+			asc_dvc->init_sdtr &= ~tid_bit;
+		}
+
+		if (orig_init_sdtr != asc_dvc->init_sdtr)
+			AscAsyncFix(asc_dvc, sdev);
+	}
+
+	if (sdev->tagged_supported) {
+		if (asc_dvc->cfg->cmd_qng_enabled & tid_bit) {
+			if (sdev->lun == 0) {
+				asc_dvc->cfg->can_tagged_qng |= tid_bit;
+				asc_dvc->use_tagged_qng |= tid_bit;
+			}
+			scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
+						asc_dvc->max_dvc_qng[sdev->id]);
+		}
+	} else {
+		if (sdev->lun == 0) {
+			asc_dvc->cfg->can_tagged_qng &= ~tid_bit;
+			asc_dvc->use_tagged_qng &= ~tid_bit;
+		}
+		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
+	}
+
+	if ((sdev->lun == 0) &&
+	    (orig_use_tagged_qng != asc_dvc->use_tagged_qng)) {
+		AscWriteLramByte(asc_dvc->iop_base, ASCV_DISC_ENABLE_B,
+				 asc_dvc->cfg->disc_enable);
+		AscWriteLramByte(asc_dvc->iop_base, ASCV_USE_TAGGED_QNG_B,
+				 asc_dvc->use_tagged_qng);
+		AscWriteLramByte(asc_dvc->iop_base, ASCV_CAN_TAGGED_QNG_B,
+				 asc_dvc->cfg->can_tagged_qng);
+
+		asc_dvc->max_dvc_qng[sdev->id] =
+					asc_dvc->cfg->max_tag_qng[sdev->id];
+		AscWriteLramByte(asc_dvc->iop_base,
+				 (ushort)(ASCV_MAX_DVC_QNG_BEG + sdev->id),
+				 asc_dvc->max_dvc_qng[sdev->id]);
+	}
+}
+
+/*
+ * Wide Transfers
+ *
+ * If the EEPROM enabled WDTR for the device and the device supports wide
+ * bus (16 bit) transfers, then turn on the device's 'wdtr_able' bit and
+ * write the new value to the microcode.
+ */
+static void
+advansys_wide_enable_wdtr(AdvPortAddr iop_base, unsigned short tidmask)
+{
+	unsigned short cfg_word;
+	AdvReadWordLram(iop_base, ASC_MC_WDTR_ABLE, cfg_word);
+	if ((cfg_word & tidmask) != 0)
+		return;
+
+	cfg_word |= tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_WDTR_ABLE, cfg_word);
+
+	/*
+	 * Clear the microcode SDTR and WDTR negotiation done indicators for
+	 * the target to cause it to negotiate with the new setting set above.
+	 * WDTR when accepted causes the target to enter asynchronous mode, so
+	 * SDTR must be negotiated.
+	 */
+	AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
+	cfg_word &= ~tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
+	AdvReadWordLram(iop_base, ASC_MC_WDTR_DONE, cfg_word);
+	cfg_word &= ~tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_WDTR_DONE, cfg_word);
+}
+
+/*
+ * Synchronous Transfers
+ *
+ * If the EEPROM enabled SDTR for the device and the device
+ * supports synchronous transfers, then turn on the device's
+ * 'sdtr_able' bit. Write the new value to the microcode.
+ */
+static void
+advansys_wide_enable_sdtr(AdvPortAddr iop_base, unsigned short tidmask)
+{
+	unsigned short cfg_word;
+	AdvReadWordLram(iop_base, ASC_MC_SDTR_ABLE, cfg_word);
+	if ((cfg_word & tidmask) != 0)
+		return;
+
+	cfg_word |= tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_SDTR_ABLE, cfg_word);
+
+	/*
+	 * Clear the microcode "SDTR negotiation" done indicator for the
+	 * target to cause it to negotiate with the new setting set above.
+	 */
+	AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
+	cfg_word &= ~tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_SDTR_DONE, cfg_word);
+}
+
+/*
+ * PPR (Parallel Protocol Request) Capable
+ *
+ * If the device supports DT mode, then it must be PPR capable.
+ * The PPR message will be used in place of the SDTR and WDTR
+ * messages to negotiate synchronous speed and offset, transfer
+ * width, and protocol options.
+ */
+static void advansys_wide_enable_ppr(ADV_DVC_VAR *adv_dvc,
+				AdvPortAddr iop_base, unsigned short tidmask)
+{
+	AdvReadWordLram(iop_base, ASC_MC_PPR_ABLE, adv_dvc->ppr_able);
+	adv_dvc->ppr_able |= tidmask;
+	AdvWriteWordLram(iop_base, ASC_MC_PPR_ABLE, adv_dvc->ppr_able);
+}
+
+static void
+advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
+{
+	AdvPortAddr iop_base = adv_dvc->iop_base;
+	unsigned short tidmask = 1 << sdev->id;
+
+	if (sdev->lun == 0) {
+		/*
+		 * Handle WDTR, SDTR, and Tag Queuing. If the feature
+		 * is enabled in the EEPROM and the device supports the
+		 * feature, then enable it in the microcode.
+		 */
+
+		if ((adv_dvc->wdtr_able & tidmask) && sdev->wdtr)
+			advansys_wide_enable_wdtr(iop_base, tidmask);
+		if ((adv_dvc->sdtr_able & tidmask) && sdev->sdtr)
+			advansys_wide_enable_sdtr(iop_base, tidmask);
+		if (adv_dvc->chip_type == ADV_CHIP_ASC38C1600 && sdev->ppr)
+			advansys_wide_enable_ppr(adv_dvc, iop_base, tidmask);
+
+		/*
+		 * Tag Queuing is disabled for the BIOS which runs in polled
+		 * mode and would see no benefit from Tag Queuing. Also by
+		 * disabling Tag Queuing in the BIOS devices with Tag Queuing
+		 * bugs will at least work with the BIOS.
+		 */
+		if ((adv_dvc->tagqng_able & tidmask) &&
+		    sdev->tagged_supported) {
+			unsigned short cfg_word;
+			AdvReadWordLram(iop_base, ASC_MC_TAGQNG_ABLE, cfg_word);
+			cfg_word |= tidmask;
+			AdvWriteWordLram(iop_base, ASC_MC_TAGQNG_ABLE,
+					 cfg_word);
+			AdvWriteByteLram(iop_base,
+					 ASC_MC_NUMBER_OF_MAX_CMD + sdev->id,
+					 adv_dvc->max_dvc_qng);
+		}
+	}
+
+	if ((adv_dvc->tagqng_able & tidmask) && sdev->tagged_supported) {
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
+					adv_dvc->max_dvc_qng);
+	} else {
+		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
+	}
+}
+
+/*
+ * Set the number of commands to queue per device for the
+ * specified host adapter.
+ */
+static int advansys_slave_configure(struct scsi_device *sdev)
+{
+	asc_board_t *boardp = ASC_BOARDP(sdev->host);
+	boardp->flags |= ASC_SELECT_QUEUE_DEPTHS;
+
+	/*
+	 * Save a pointer to the sdev and set its initial/maximum
+	 * queue depth.  Only save the pointer for a lun0 dev though.
+	 */
+	if (sdev->lun == 0)
+		boardp->device[sdev->id] = sdev;
+
+	if (ASC_NARROW_BOARD(boardp))
+		advansys_narrow_slave_configure(sdev,
+						&boardp->dvc_var.asc_dvc_var);
+	else
+		advansys_wide_slave_configure(sdev,
+						&boardp->dvc_var.adv_dvc_var);
+
+	return 0;
+}
+
+/*
+ * Build a request structure for the Asc Library (Narrow Board).
+ *
+ * The global structures 'asc_scsi_q' and 'asc_sg_head' are
+ * used to build the request.
+ *
+ * If an error occurs, then return ASC_ERROR.
+ */
+static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
+{
+	/*
+	 * Mutually exclusive access is required to 'asc_scsi_q' and
+	 * 'asc_sg_head' until after the request is started.
+	 */
+	memset(&asc_scsi_q, 0, sizeof(ASC_SCSI_Q));
+
+	/*
+	 * Point the ASC_SCSI_Q to the 'struct scsi_cmnd'.
+	 */
+	asc_scsi_q.q2.srb_ptr = ASC_VADDR_TO_U32(scp);
+
+	/*
+	 * Build the ASC_SCSI_Q request.
+	 */
+	asc_scsi_q.cdbptr = &scp->cmnd[0];
+	asc_scsi_q.q2.cdb_len = scp->cmd_len;
+	asc_scsi_q.q1.target_id = ASC_TID_TO_TARGET_ID(scp->device->id);
+	asc_scsi_q.q1.target_lun = scp->device->lun;
+	asc_scsi_q.q2.target_ix =
+	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
+	asc_scsi_q.q1.sense_addr =
+	    cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
+	asc_scsi_q.q1.sense_len = sizeof(scp->sense_buffer);
+
+	/*
+	 * If there are any outstanding requests for the current target,
+	 * then every 255th request send an ORDERED request. This heuristic
+	 * tries to retain the benefit of request sorting while preventing
+	 * request starvation. 255 is the max number of tags or pending commands
+	 * a device may have outstanding.
+	 *
+	 * The request count is incremented below for every successfully
+	 * started request.
+	 *
+	 */
+	if ((boardp->dvc_var.asc_dvc_var.cur_dvc_qng[scp->device->id] > 0) &&
+	    (boardp->reqcnt[scp->device->id] % 255) == 0) {
+		asc_scsi_q.q2.tag_code = MSG_ORDERED_TAG;
+	} else {
+		asc_scsi_q.q2.tag_code = MSG_SIMPLE_TAG;
+	}
+
+	/*
+	 * Build ASC_SCSI_Q for a contiguous buffer or a scatter-gather
+	 * buffer command.
+	 */
+	if (scp->use_sg == 0) {
+		/*
+		 * CDB request of single contiguous buffer.
+		 */
+		ASC_STATS(scp->device->host, cont_cnt);
+		scp->SCp.dma_handle = scp->request_bufflen ?
+		    dma_map_single(boardp->dev, scp->request_buffer,
+				   scp->request_bufflen,
+				   scp->sc_data_direction) : 0;
+		asc_scsi_q.q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
+		asc_scsi_q.q1.data_cnt = cpu_to_le32(scp->request_bufflen);
+		ASC_STATS_ADD(scp->device->host, cont_xfer,
+			      ASC_CEILING(scp->request_bufflen, 512));
+		asc_scsi_q.q1.sg_queue_cnt = 0;
+		asc_scsi_q.sg_head = NULL;
+	} else {
+		/*
+		 * CDB scatter-gather request list.
+		 */
+		int sgcnt;
+		int use_sg;
+		struct scatterlist *slp;
+
+		slp = (struct scatterlist *)scp->request_buffer;
+		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
+				    scp->sc_data_direction);
+
+		if (use_sg > scp->device->host->sg_tablesize) {
+			ASC_PRINT3("asc_build_req: board %d: use_sg %d > "
+				   "sg_tablesize %d\n", boardp->id, use_sg,
+				   scp->device->host->sg_tablesize);
+			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
+				     scp->sc_data_direction);
+			scp->result = HOST_BYTE(DID_ERROR);
+			return ASC_ERROR;
+		}
+
+		ASC_STATS(scp->device->host, sg_cnt);
+
+		/*
+		 * Use global ASC_SG_HEAD structure and set the ASC_SCSI_Q
+		 * structure to point to it.
+		 */
+		memset(&asc_sg_head, 0, sizeof(ASC_SG_HEAD));
+
+		asc_scsi_q.q1.cntl |= QC_SG_HEAD;
+		asc_scsi_q.sg_head = &asc_sg_head;
+		asc_scsi_q.q1.data_cnt = 0;
+		asc_scsi_q.q1.data_addr = 0;
+		/* This is a byte value, otherwise it would need to be swapped. */
+		asc_sg_head.entry_cnt = asc_scsi_q.q1.sg_queue_cnt = use_sg;
+		ASC_STATS_ADD(scp->device->host, sg_elem,
+			      asc_sg_head.entry_cnt);
+
+		/*
+		 * Convert scatter-gather list into ASC_SG_HEAD list.
+		 */
+		for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
+			asc_sg_head.sg_list[sgcnt].addr =
+			    cpu_to_le32(sg_dma_address(slp));
+			asc_sg_head.sg_list[sgcnt].bytes =
+			    cpu_to_le32(sg_dma_len(slp));
+			ASC_STATS_ADD(scp->device->host, sg_xfer,
+				      ASC_CEILING(sg_dma_len(slp), 512));
+		}
+	}
+
+	ASC_DBG_PRT_ASC_SCSI_Q(2, &asc_scsi_q);
+	ASC_DBG_PRT_CDB(1, scp->cmnd, scp->cmd_len);
+
+	return ASC_NOERROR;
+}
+
+/*
+ * Build scatter-gather list for Adv Library (Wide Board).
+ *
+ * Additional ADV_SG_BLOCK structures will need to be allocated
+ * if the total number of scatter-gather elements exceeds
+ * NO_OF_SG_PER_BLOCK (15). The ADV_SG_BLOCK structures are
+ * assumed to be physically contiguous.
+ *
+ * Return:
+ *      ADV_SUCCESS(1) - SG List successfully created
+ *      ADV_ERROR(-1) - SG List creation failed
+ */
+static int
+adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
+	       int use_sg)
+{
+	adv_sgblk_t *sgblkp;
+	ADV_SCSI_REQ_Q *scsiqp;
+	struct scatterlist *slp;
+	int sg_elem_cnt;
+	ADV_SG_BLOCK *sg_block, *prev_sg_block;
+	ADV_PADDR sg_block_paddr;
+	int i;
+
+	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
+	slp = (struct scatterlist *)scp->request_buffer;
+	sg_elem_cnt = use_sg;
+	prev_sg_block = NULL;
+	reqp->sgblkp = NULL;
+
+	for (;;) {
+		/*
+		 * Allocate a 'adv_sgblk_t' structure from the board free
+		 * list. One 'adv_sgblk_t' structure holds NO_OF_SG_PER_BLOCK
+		 * (15) scatter-gather elements.
+		 */
+		if ((sgblkp = boardp->adv_sgblkp) == NULL) {
+			ASC_DBG(1, "adv_get_sglist: no free adv_sgblk_t\n");
+			ASC_STATS(scp->device->host, adv_build_nosg);
+
+			/*
+			 * Allocation failed. Free 'adv_sgblk_t' structures
+			 * already allocated for the request.
+			 */
+			while ((sgblkp = reqp->sgblkp) != NULL) {
+				/* Remove 'sgblkp' from the request list. */
+				reqp->sgblkp = sgblkp->next_sgblkp;
+
+				/* Add 'sgblkp' to the board free list. */
+				sgblkp->next_sgblkp = boardp->adv_sgblkp;
+				boardp->adv_sgblkp = sgblkp;
+			}
+			return ASC_BUSY;
+		}
+
+		/* Complete 'adv_sgblk_t' board allocation. */
+		boardp->adv_sgblkp = sgblkp->next_sgblkp;
+		sgblkp->next_sgblkp = NULL;
+
+		/*
+		 * Get 8 byte aligned virtual and physical addresses
+		 * for the allocated ADV_SG_BLOCK structure.
+		 */
+		sg_block = (ADV_SG_BLOCK *)ADV_8BALIGN(&sgblkp->sg_block);
+		sg_block_paddr = virt_to_bus(sg_block);
+
+		/*
+		 * Check if this is the first 'adv_sgblk_t' for the
+		 * request.
+		 */
+		if (reqp->sgblkp == NULL) {
+			/* Request's first scatter-gather block. */
+			reqp->sgblkp = sgblkp;
+
+			/*
+			 * Set ADV_SCSI_REQ_T ADV_SG_BLOCK virtual and physical
+			 * address pointers.
+			 */
+			scsiqp->sg_list_ptr = sg_block;
+			scsiqp->sg_real_addr = cpu_to_le32(sg_block_paddr);
+		} else {
+			/* Request's second or later scatter-gather block. */
+			sgblkp->next_sgblkp = reqp->sgblkp;
+			reqp->sgblkp = sgblkp;
+
+			/*
+			 * Point the previous ADV_SG_BLOCK structure to
+			 * the newly allocated ADV_SG_BLOCK structure.
+			 */
+			prev_sg_block->sg_ptr = cpu_to_le32(sg_block_paddr);
+		}
+
+		for (i = 0; i < NO_OF_SG_PER_BLOCK; i++) {
+			sg_block->sg_list[i].sg_addr =
+					cpu_to_le32(sg_dma_address(slp));
+			sg_block->sg_list[i].sg_count =
+					cpu_to_le32(sg_dma_len(slp));
+			ASC_STATS_ADD(scp->device->host, sg_xfer,
+				      ASC_CEILING(sg_dma_len(slp), 512));
+
+			if (--sg_elem_cnt == 0) {	/* Last ADV_SG_BLOCK and scatter-gather entry. */
+				sg_block->sg_cnt = i + 1;
+				sg_block->sg_ptr = 0L;	/* Last ADV_SG_BLOCK in list. */
+				return ADV_SUCCESS;
+			}
+			slp++;
+		}
+		sg_block->sg_cnt = NO_OF_SG_PER_BLOCK;
+		prev_sg_block = sg_block;
+	}
+}
+
+/*
+ * Build a request structure for the Adv Library (Wide Board).
+ *
+ * If an adv_req_t can not be allocated to issue the request,
+ * then return ASC_BUSY. If an error occurs, then return ASC_ERROR.
+ *
+ * Multi-byte fields in the ASC_SCSI_REQ_Q that are used by the
+ * microcode for DMA addresses or math operations are byte swapped
+ * to little-endian order.
+ */
+static int
+adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
+	      ADV_SCSI_REQ_Q **adv_scsiqpp)
+{
+	adv_req_t *reqp;
+	ADV_SCSI_REQ_Q *scsiqp;
+	int i;
+	int ret;
+
+	/*
+	 * Allocate an adv_req_t structure from the board to execute
+	 * the command.
+	 */
+	if (boardp->adv_reqp == NULL) {
+		ASC_DBG(1, "adv_build_req: no free adv_req_t\n");
+		ASC_STATS(scp->device->host, adv_build_noreq);
+		return ASC_BUSY;
+	} else {
+		reqp = boardp->adv_reqp;
+		boardp->adv_reqp = reqp->next_reqp;
+		reqp->next_reqp = NULL;
+	}
+
+	/*
+	 * Get 32-byte aligned ADV_SCSI_REQ_Q and ADV_SG_BLOCK pointers.
+	 */
+	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
+
+	/*
+	 * Initialize the structure.
+	 */
+	scsiqp->cntl = scsiqp->scsi_cntl = scsiqp->done_status = 0;
+
+	/*
+	 * Set the ADV_SCSI_REQ_Q 'srb_ptr' to point to the adv_req_t structure.
+	 */
+	scsiqp->srb_ptr = ASC_VADDR_TO_U32(reqp);
+
+	/*
+	 * Set the adv_req_t 'cmndp' to point to the struct scsi_cmnd structure.
+	 */
+	reqp->cmndp = scp;
+
+	/*
+	 * Build the ADV_SCSI_REQ_Q request.
+	 */
+
+	/* Set CDB length and copy it to the request structure.  */
+	scsiqp->cdb_len = scp->cmd_len;
+	/* Copy first 12 CDB bytes to cdb[]. */
+	for (i = 0; i < scp->cmd_len && i < 12; i++) {
+		scsiqp->cdb[i] = scp->cmnd[i];
+	}
+	/* Copy last 4 CDB bytes, if present, to cdb16[]. */
+	for (; i < scp->cmd_len; i++) {
+		scsiqp->cdb16[i - 12] = scp->cmnd[i];
+	}
+
+	scsiqp->target_id = scp->device->id;
+	scsiqp->target_lun = scp->device->lun;
+
+	scsiqp->sense_addr = cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
+	scsiqp->sense_len = sizeof(scp->sense_buffer);
+
+	/*
+	 * Build ADV_SCSI_REQ_Q for a contiguous buffer or a scatter-gather
+	 * buffer command.
+	 */
+
+	scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
+	scsiqp->vdata_addr = scp->request_buffer;
+	scsiqp->data_addr = cpu_to_le32(virt_to_bus(scp->request_buffer));
+
+	if (scp->use_sg == 0) {
+		/*
+		 * CDB request of single contiguous buffer.
+		 */
+		reqp->sgblkp = NULL;
+		scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
+		if (scp->request_bufflen) {
+			scsiqp->vdata_addr = scp->request_buffer;
+			scp->SCp.dma_handle =
+			    dma_map_single(boardp->dev, scp->request_buffer,
+					   scp->request_bufflen,
+					   scp->sc_data_direction);
+		} else {
+			scsiqp->vdata_addr = NULL;
+			scp->SCp.dma_handle = 0;
+		}
+		scsiqp->data_addr = cpu_to_le32(scp->SCp.dma_handle);
+		scsiqp->sg_list_ptr = NULL;
+		scsiqp->sg_real_addr = 0;
+		ASC_STATS(scp->device->host, cont_cnt);
+		ASC_STATS_ADD(scp->device->host, cont_xfer,
+			      ASC_CEILING(scp->request_bufflen, 512));
+	} else {
+		/*
+		 * CDB scatter-gather request list.
+		 */
+		struct scatterlist *slp;
+		int use_sg;
+
+		slp = (struct scatterlist *)scp->request_buffer;
+		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
+				    scp->sc_data_direction);
+
+		if (use_sg > ADV_MAX_SG_LIST) {
+			ASC_PRINT3("adv_build_req: board %d: use_sg %d > "
+				   "ADV_MAX_SG_LIST %d\n", boardp->id, use_sg,
+				   scp->device->host->sg_tablesize);
+			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
+				     scp->sc_data_direction);
+			scp->result = HOST_BYTE(DID_ERROR);
+
+			/*
+			 * Free the 'adv_req_t' structure by adding it back
+			 * to the board free list.
+			 */
+			reqp->next_reqp = boardp->adv_reqp;
+			boardp->adv_reqp = reqp;
+
+			return ASC_ERROR;
+		}
+
+		ret = adv_get_sglist(boardp, reqp, scp, use_sg);
+		if (ret != ADV_SUCCESS) {
+			/*
+			 * Free the adv_req_t structure by adding it back to
+			 * the board free list.
+			 */
+			reqp->next_reqp = boardp->adv_reqp;
+			boardp->adv_reqp = reqp;
+
+			return ret;
+		}
+
+		ASC_STATS(scp->device->host, sg_cnt);
+		ASC_STATS_ADD(scp->device->host, sg_elem, use_sg);
+	}
+
+	ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
+	ASC_DBG_PRT_CDB(1, scp->cmnd, scp->cmd_len);
+
+	*adv_scsiqpp = scsiqp;
+
+	return ASC_NOERROR;
+}
+
+static int AscSgListToQueue(int sg_list)
+{
+	int n_sg_list_qs;
+
+	n_sg_list_qs = ((sg_list - 1) / ASC_SG_LIST_PER_Q);
+	if (((sg_list - 1) % ASC_SG_LIST_PER_Q) != 0)
+		n_sg_list_qs++;
+	return n_sg_list_qs + 1;
+}
+
+static uint
+AscGetNumOfFreeQueue(ASC_DVC_VAR *asc_dvc, uchar target_ix, uchar n_qs)
+{
+	uint cur_used_qs;
+	uint cur_free_qs;
+	ASC_SCSI_BIT_ID_TYPE target_id;
+	uchar tid_no;
+
+	target_id = ASC_TIX_TO_TARGET_ID(target_ix);
+	tid_no = ASC_TIX_TO_TID(target_ix);
+	if ((asc_dvc->unit_not_ready & target_id) ||
+	    (asc_dvc->queue_full_or_busy & target_id)) {
+		return 0;
+	}
+	if (n_qs == 1) {
+		cur_used_qs = (uint) asc_dvc->cur_total_qng +
+		    (uint) asc_dvc->last_q_shortage + (uint) ASC_MIN_FREE_Q;
+	} else {
+		cur_used_qs = (uint) asc_dvc->cur_total_qng +
+		    (uint) ASC_MIN_FREE_Q;
+	}
+	if ((uint) (cur_used_qs + n_qs) <= (uint) asc_dvc->max_total_qng) {
+		cur_free_qs = (uint) asc_dvc->max_total_qng - cur_used_qs;
+		if (asc_dvc->cur_dvc_qng[tid_no] >=
+		    asc_dvc->max_dvc_qng[tid_no]) {
+			return 0;
+		}
+		return cur_free_qs;
+	}
+	if (n_qs > 1) {
+		if ((n_qs > asc_dvc->last_q_shortage)
+		    && (n_qs <= (asc_dvc->max_total_qng - ASC_MIN_FREE_Q))) {
+			asc_dvc->last_q_shortage = n_qs;
+		}
+	}
+	return 0;
+}
+
+static uchar AscAllocFreeQueue(PortAddr iop_base, uchar free_q_head)
+{
+	ushort q_addr;
+	uchar next_qp;
+	uchar q_status;
+
+	q_addr = ASC_QNO_TO_QADDR(free_q_head);
+	q_status = (uchar)AscReadLramByte(iop_base,
+					  (ushort)(q_addr +
+						   ASC_SCSIQ_B_STATUS));
+	next_qp = AscReadLramByte(iop_base, (ushort)(q_addr + ASC_SCSIQ_B_FWD));
+	if (((q_status & QS_READY) == 0) && (next_qp != ASC_QLINK_END))
+		return next_qp;
+	return ASC_QLINK_END;
+}
+
+static uchar
+AscAllocMultipleFreeQueue(PortAddr iop_base, uchar free_q_head, uchar n_free_q)
+{
+	uchar i;
+
+	for (i = 0; i < n_free_q; i++) {
+		free_q_head = AscAllocFreeQueue(iop_base, free_q_head);
+		if (free_q_head == ASC_QLINK_END)
+			break;
+	}
+	return free_q_head;
+}
+
+/*
+ * void
+ * DvcPutScsiQ(PortAddr iop_base, ushort s_addr, uchar *outbuf, int words)
+ *
+ * Calling/Exit State:
+ *    none
+ *
+ * Description:
+ *     Output an ASC_SCSI_Q structure to the chip
+ */
+static void
+DvcPutScsiQ(PortAddr iop_base, ushort s_addr, uchar *outbuf, int words)
+{
+	int i;
+
+	ASC_DBG_PRT_HEX(2, "DvcPutScsiQ", outbuf, 2 * words);
+	AscSetChipLramAddr(iop_base, s_addr);
+	for (i = 0; i < 2 * words; i += 2) {
+		if (i == 4 || i == 20) {
+			continue;
+		}
+		outpw(iop_base + IOP_RAM_DATA,
+		      ((ushort)outbuf[i + 1] << 8) | outbuf[i]);
+	}
+}
+
+static int AscPutReadyQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
+{
+	ushort q_addr;
+	uchar tid_no;
+	uchar sdtr_data;
+	uchar syn_period_ix;
+	uchar syn_offset;
+	PortAddr iop_base;
+
+	iop_base = asc_dvc->iop_base;
+	if (((asc_dvc->init_sdtr & scsiq->q1.target_id) != 0) &&
+	    ((asc_dvc->sdtr_done & scsiq->q1.target_id) == 0)) {
+		tid_no = ASC_TIX_TO_TID(scsiq->q2.target_ix);
+		sdtr_data = AscGetMCodeInitSDTRAtID(iop_base, tid_no);
+		syn_period_ix =
+		    (sdtr_data >> 4) & (asc_dvc->max_sdtr_index - 1);
+		syn_offset = sdtr_data & ASC_SYN_MAX_OFFSET;
+		AscMsgOutSDTR(asc_dvc,
+			      asc_dvc->sdtr_period_tbl[syn_period_ix],
+			      syn_offset);
+		scsiq->q1.cntl |= QC_MSG_OUT;
+	}
+	q_addr = ASC_QNO_TO_QADDR(q_no);
+	if ((scsiq->q1.target_id & asc_dvc->use_tagged_qng) == 0) {
+		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
+	}
+	scsiq->q1.status = QS_FREE;
+	AscMemWordCopyPtrToLram(iop_base,
+				q_addr + ASC_SCSIQ_CDB_BEG,
+				(uchar *)scsiq->cdbptr, scsiq->q2.cdb_len >> 1);
+
+	DvcPutScsiQ(iop_base,
+		    q_addr + ASC_SCSIQ_CPY_BEG,
+		    (uchar *)&scsiq->q1.cntl,
+		    ((sizeof(ASC_SCSIQ_1) + sizeof(ASC_SCSIQ_2)) / 2) - 1);
+	AscWriteLramWord(iop_base,
+			 (ushort)(q_addr + (ushort)ASC_SCSIQ_B_STATUS),
+			 (ushort)(((ushort)scsiq->q1.
+				   q_no << 8) | (ushort)QS_READY));
+	return 1;
+}
+
+static int
+AscPutReadySgListQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar q_no)
+{
+	int sta;
+	int i;
+	ASC_SG_HEAD *sg_head;
+	ASC_SG_LIST_Q scsi_sg_q;
+	ASC_DCNT saved_data_addr;
+	ASC_DCNT saved_data_cnt;
+	PortAddr iop_base;
+	ushort sg_list_dwords;
+	ushort sg_index;
+	ushort sg_entry_cnt;
+	ushort q_addr;
+	uchar next_qp;
+
+	iop_base = asc_dvc->iop_base;
+	sg_head = scsiq->sg_head;
+	saved_data_addr = scsiq->q1.data_addr;
+	saved_data_cnt = scsiq->q1.data_cnt;
+	scsiq->q1.data_addr = (ASC_PADDR) sg_head->sg_list[0].addr;
+	scsiq->q1.data_cnt = (ASC_DCNT) sg_head->sg_list[0].bytes;
+#if CC_VERY_LONG_SG_LIST
+	/*
+	 * If sg_head->entry_cnt is greater than ASC_MAX_SG_LIST
+	 * then not all SG elements will fit in the allocated queues.
+	 * The rest of the SG elements will be copied when the RISC
+	 * completes the SG elements that fit and halts.
+	 */
+	if (sg_head->entry_cnt > ASC_MAX_SG_LIST) {
+		/*
+		 * Set sg_entry_cnt to be the number of SG elements that
+		 * will fit in the allocated SG queues. It is minus 1, because
+		 * the first SG element is handled above. ASC_MAX_SG_LIST is
+		 * already inflated by 1 to account for this. For example it
+		 * may be 50 which is 1 + 7 queues * 7 SG elements.
+		 */
+		sg_entry_cnt = ASC_MAX_SG_LIST - 1;
+
+		/*
+		 * Keep track of remaining number of SG elements that will
+		 * need to be handled from a_isr.c.
+		 */
+		scsiq->remain_sg_entry_cnt =
+		    sg_head->entry_cnt - ASC_MAX_SG_LIST;
+	} else {
+#endif /* CC_VERY_LONG_SG_LIST */
+		/*
+		 * Set sg_entry_cnt to be the number of SG elements that
+		 * will fit in the allocated SG queues. It is minus 1, because
+		 * the first SG element is handled above.
+		 */
+		sg_entry_cnt = sg_head->entry_cnt - 1;
+#if CC_VERY_LONG_SG_LIST
+	}
+#endif /* CC_VERY_LONG_SG_LIST */
+	if (sg_entry_cnt != 0) {
+		scsiq->q1.cntl |= QC_SG_HEAD;
+		q_addr = ASC_QNO_TO_QADDR(q_no);
+		sg_index = 1;
+		scsiq->q1.sg_queue_cnt = sg_head->queue_cnt;
+		scsi_sg_q.sg_head_qp = q_no;
+		scsi_sg_q.cntl = QCSG_SG_XFER_LIST;
+		for (i = 0; i < sg_head->queue_cnt; i++) {
+			scsi_sg_q.seq_no = i + 1;
+			if (sg_entry_cnt > ASC_SG_LIST_PER_Q) {
+				sg_list_dwords = (uchar)(ASC_SG_LIST_PER_Q * 2);
+				sg_entry_cnt -= ASC_SG_LIST_PER_Q;
+				if (i == 0) {
+					scsi_sg_q.sg_list_cnt =
+					    ASC_SG_LIST_PER_Q;
+					scsi_sg_q.sg_cur_list_cnt =
+					    ASC_SG_LIST_PER_Q;
+				} else {
+					scsi_sg_q.sg_list_cnt =
+					    ASC_SG_LIST_PER_Q - 1;
+					scsi_sg_q.sg_cur_list_cnt =
+					    ASC_SG_LIST_PER_Q - 1;
+				}
+			} else {
+#if CC_VERY_LONG_SG_LIST
+				/*
+				 * This is the last SG queue in the list of
+				 * allocated SG queues. If there are more
+				 * SG elements than will fit in the allocated
+				 * queues, then set the QCSG_SG_XFER_MORE flag.
+				 */
+				if (sg_head->entry_cnt > ASC_MAX_SG_LIST) {
+					scsi_sg_q.cntl |= QCSG_SG_XFER_MORE;
+				} else {
+#endif /* CC_VERY_LONG_SG_LIST */
+					scsi_sg_q.cntl |= QCSG_SG_XFER_END;
+#if CC_VERY_LONG_SG_LIST
+				}
+#endif /* CC_VERY_LONG_SG_LIST */
+				sg_list_dwords = sg_entry_cnt << 1;
+				if (i == 0) {
+					scsi_sg_q.sg_list_cnt = sg_entry_cnt;
+					scsi_sg_q.sg_cur_list_cnt =
+					    sg_entry_cnt;
+				} else {
+					scsi_sg_q.sg_list_cnt =
+					    sg_entry_cnt - 1;
+					scsi_sg_q.sg_cur_list_cnt =
+					    sg_entry_cnt - 1;
+				}
+				sg_entry_cnt = 0;
+			}
+			next_qp = AscReadLramByte(iop_base,
+						  (ushort)(q_addr +
+							   ASC_SCSIQ_B_FWD));
+			scsi_sg_q.q_no = next_qp;
+			q_addr = ASC_QNO_TO_QADDR(next_qp);
+			AscMemWordCopyPtrToLram(iop_base,
+						q_addr + ASC_SCSIQ_SGHD_CPY_BEG,
+						(uchar *)&scsi_sg_q,
+						sizeof(ASC_SG_LIST_Q) >> 1);
+			AscMemDWordCopyPtrToLram(iop_base,
+						 q_addr + ASC_SGQ_LIST_BEG,
+						 (uchar *)&sg_head->
+						 sg_list[sg_index],
+						 sg_list_dwords);
+			sg_index += ASC_SG_LIST_PER_Q;
+			scsiq->next_sg_index = sg_index;
+		}
+	} else {
+		scsiq->q1.cntl &= ~QC_SG_HEAD;
+	}
+	sta = AscPutReadyQueue(asc_dvc, scsiq, q_no);
+	scsiq->q1.data_addr = saved_data_addr;
+	scsiq->q1.data_cnt = saved_data_cnt;
+	return (sta);
+}
+
+static int
+AscSendScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar n_q_required)
+{
+	PortAddr iop_base;
+	uchar free_q_head;
+	uchar next_qp;
+	uchar tid_no;
+	uchar target_ix;
+	int sta;
+
+	iop_base = asc_dvc->iop_base;
+	target_ix = scsiq->q2.target_ix;
+	tid_no = ASC_TIX_TO_TID(target_ix);
+	sta = 0;
+	free_q_head = (uchar)AscGetVarFreeQHead(iop_base);
+	if (n_q_required > 1) {
+		next_qp = AscAllocMultipleFreeQueue(iop_base, free_q_head,
+						    (uchar)n_q_required);
+		if (next_qp != ASC_QLINK_END) {
+			asc_dvc->last_q_shortage = 0;
+			scsiq->sg_head->queue_cnt = n_q_required - 1;
+			scsiq->q1.q_no = free_q_head;
+			sta = AscPutReadySgListQueue(asc_dvc, scsiq,
+						     free_q_head);
+		}
+	} else if (n_q_required == 1) {
+		next_qp = AscAllocFreeQueue(iop_base, free_q_head);
+		if (next_qp != ASC_QLINK_END) {
+			scsiq->q1.q_no = free_q_head;
+			sta = AscPutReadyQueue(asc_dvc, scsiq, free_q_head);
+		}
+	}
+	if (sta == 1) {
+		AscPutVarFreeQHead(iop_base, next_qp);
+		asc_dvc->cur_total_qng += n_q_required;
+		asc_dvc->cur_dvc_qng[tid_no]++;
+	}
+	return sta;
+}
+
+#define ASC_SYN_OFFSET_ONE_DISABLE_LIST  16
+static uchar _syn_offset_one_disable_cmd[ASC_SYN_OFFSET_ONE_DISABLE_LIST] = {
+	INQUIRY,
+	REQUEST_SENSE,
+	READ_CAPACITY,
+	READ_TOC,
+	MODE_SELECT,
+	MODE_SENSE,
+	MODE_SELECT_10,
+	MODE_SENSE_10,
+	0xFF,
+	0xFF,
+	0xFF,
+	0xFF,
+	0xFF,
+	0xFF,
+	0xFF,
+	0xFF
+};
+
+static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
+{
+	PortAddr iop_base;
+	int sta;
+	int n_q_required;
+	int disable_syn_offset_one_fix;
+	int i;
+	ASC_PADDR addr;
+	ushort sg_entry_cnt = 0;
+	ushort sg_entry_cnt_minus_one = 0;
+	uchar target_ix;
+	uchar tid_no;
+	uchar sdtr_data;
+	uchar extra_bytes;
+	uchar scsi_cmd;
+	uchar disable_cmd;
+	ASC_SG_HEAD *sg_head;
+	ASC_DCNT data_cnt;
+
+	iop_base = asc_dvc->iop_base;
+	sg_head = scsiq->sg_head;
+	if (asc_dvc->err_code != 0)
+		return (ERR);
+	scsiq->q1.q_no = 0;
+	if ((scsiq->q2.tag_code & ASC_TAG_FLAG_EXTRA_BYTES) == 0) {
+		scsiq->q1.extra_bytes = 0;
+	}
+	sta = 0;
+	target_ix = scsiq->q2.target_ix;
+	tid_no = ASC_TIX_TO_TID(target_ix);
+	n_q_required = 1;
+	if (scsiq->cdbptr[0] == REQUEST_SENSE) {
+		if ((asc_dvc->init_sdtr & scsiq->q1.target_id) != 0) {
+			asc_dvc->sdtr_done &= ~scsiq->q1.target_id;
+			sdtr_data = AscGetMCodeInitSDTRAtID(iop_base, tid_no);
+			AscMsgOutSDTR(asc_dvc,
+				      asc_dvc->
+				      sdtr_period_tbl[(sdtr_data >> 4) &
+						      (uchar)(asc_dvc->
+							      max_sdtr_index -
+							      1)],
+				      (uchar)(sdtr_data & (uchar)
+					      ASC_SYN_MAX_OFFSET));
+			scsiq->q1.cntl |= (QC_MSG_OUT | QC_URGENT);
+		}
+	}
+	if (asc_dvc->in_critical_cnt != 0) {
+		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_CRITICAL_RE_ENTRY);
+		return (ERR);
+	}
+	asc_dvc->in_critical_cnt++;
+	if ((scsiq->q1.cntl & QC_SG_HEAD) != 0) {
+		if ((sg_entry_cnt = sg_head->entry_cnt) == 0) {
+			asc_dvc->in_critical_cnt--;
+			return (ERR);
+		}
+#if !CC_VERY_LONG_SG_LIST
+		if (sg_entry_cnt > ASC_MAX_SG_LIST) {
+			asc_dvc->in_critical_cnt--;
+			return (ERR);
+		}
+#endif /* !CC_VERY_LONG_SG_LIST */
+		if (sg_entry_cnt == 1) {
+			scsiq->q1.data_addr =
+			    (ADV_PADDR)sg_head->sg_list[0].addr;
+			scsiq->q1.data_cnt =
+			    (ADV_DCNT)sg_head->sg_list[0].bytes;
+			scsiq->q1.cntl &= ~(QC_SG_HEAD | QC_SG_SWAP_QUEUE);
+		}
+		sg_entry_cnt_minus_one = sg_entry_cnt - 1;
+	}
+	scsi_cmd = scsiq->cdbptr[0];
+	disable_syn_offset_one_fix = FALSE;
+	if ((asc_dvc->pci_fix_asyn_xfer & scsiq->q1.target_id) &&
+	    !(asc_dvc->pci_fix_asyn_xfer_always & scsiq->q1.target_id)) {
+		if (scsiq->q1.cntl & QC_SG_HEAD) {
+			data_cnt = 0;
+			for (i = 0; i < sg_entry_cnt; i++) {
+				data_cnt +=
+				    (ADV_DCNT)le32_to_cpu(sg_head->sg_list[i].
+							  bytes);
+			}
+		} else {
+			data_cnt = le32_to_cpu(scsiq->q1.data_cnt);
+		}
+		if (data_cnt != 0UL) {
+			if (data_cnt < 512UL) {
+				disable_syn_offset_one_fix = TRUE;
+			} else {
+				for (i = 0; i < ASC_SYN_OFFSET_ONE_DISABLE_LIST;
+				     i++) {
+					disable_cmd =
+					    _syn_offset_one_disable_cmd[i];
+					if (disable_cmd == 0xFF) {
+						break;
+					}
+					if (scsi_cmd == disable_cmd) {
+						disable_syn_offset_one_fix =
+						    TRUE;
+						break;
+					}
+				}
+			}
+		}
+	}
+	if (disable_syn_offset_one_fix) {
+		scsiq->q2.tag_code &= ~MSG_SIMPLE_TAG;
+		scsiq->q2.tag_code |= (ASC_TAG_FLAG_DISABLE_ASYN_USE_SYN_FIX |
+				       ASC_TAG_FLAG_DISABLE_DISCONNECT);
+	} else {
+		scsiq->q2.tag_code &= 0x27;
+	}
+	if ((scsiq->q1.cntl & QC_SG_HEAD) != 0) {
+		if (asc_dvc->bug_fix_cntl) {
+			if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_IF_NOT_DWB) {
+				if ((scsi_cmd == READ_6) ||
+				    (scsi_cmd == READ_10)) {
+					addr =
+					    (ADV_PADDR)le32_to_cpu(sg_head->
+								   sg_list
+								   [sg_entry_cnt_minus_one].
+								   addr) +
+					    (ADV_DCNT)le32_to_cpu(sg_head->
+								  sg_list
+								  [sg_entry_cnt_minus_one].
+								  bytes);
+					extra_bytes =
+					    (uchar)((ushort)addr & 0x0003);
+					if ((extra_bytes != 0)
+					    &&
+					    ((scsiq->q2.
+					      tag_code &
+					      ASC_TAG_FLAG_EXTRA_BYTES)
+					     == 0)) {
+						scsiq->q2.tag_code |=
+						    ASC_TAG_FLAG_EXTRA_BYTES;
+						scsiq->q1.extra_bytes =
+						    extra_bytes;
+						data_cnt =
+						    le32_to_cpu(sg_head->
+								sg_list
+								[sg_entry_cnt_minus_one].
+								bytes);
+						data_cnt -=
+						    (ASC_DCNT) extra_bytes;
+						sg_head->
+						    sg_list
+						    [sg_entry_cnt_minus_one].
+						    bytes =
+						    cpu_to_le32(data_cnt);
+					}
+				}
+			}
+		}
+		sg_head->entry_to_copy = sg_head->entry_cnt;
+#if CC_VERY_LONG_SG_LIST
+		/*
+		 * Set the sg_entry_cnt to the maximum possible. The rest of
+		 * the SG elements will be copied when the RISC completes the
+		 * SG elements that fit and halts.
+		 */
+		if (sg_entry_cnt > ASC_MAX_SG_LIST) {
+			sg_entry_cnt = ASC_MAX_SG_LIST;
+		}
+#endif /* CC_VERY_LONG_SG_LIST */
+		n_q_required = AscSgListToQueue(sg_entry_cnt);
+		if ((AscGetNumOfFreeQueue(asc_dvc, target_ix, n_q_required) >=
+		     (uint) n_q_required)
+		    || ((scsiq->q1.cntl & QC_URGENT) != 0)) {
+			if ((sta =
+			     AscSendScsiQueue(asc_dvc, scsiq,
+					      n_q_required)) == 1) {
+				asc_dvc->in_critical_cnt--;
+				return (sta);
+			}
+		}
+	} else {
+		if (asc_dvc->bug_fix_cntl) {
+			if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_IF_NOT_DWB) {
+				if ((scsi_cmd == READ_6) ||
+				    (scsi_cmd == READ_10)) {
+					addr =
+					    le32_to_cpu(scsiq->q1.data_addr) +
+					    le32_to_cpu(scsiq->q1.data_cnt);
+					extra_bytes =
+					    (uchar)((ushort)addr & 0x0003);
+					if ((extra_bytes != 0)
+					    &&
+					    ((scsiq->q2.
+					      tag_code &
+					      ASC_TAG_FLAG_EXTRA_BYTES)
+					     == 0)) {
+						data_cnt =
+						    le32_to_cpu(scsiq->q1.
+								data_cnt);
+						if (((ushort)data_cnt & 0x01FF)
+						    == 0) {
+							scsiq->q2.tag_code |=
+							    ASC_TAG_FLAG_EXTRA_BYTES;
+							data_cnt -= (ASC_DCNT)
+							    extra_bytes;
+							scsiq->q1.data_cnt =
+							    cpu_to_le32
+							    (data_cnt);
+							scsiq->q1.extra_bytes =
+							    extra_bytes;
+						}
+					}
+				}
+			}
+		}
+		n_q_required = 1;
+		if ((AscGetNumOfFreeQueue(asc_dvc, target_ix, 1) >= 1) ||
+		    ((scsiq->q1.cntl & QC_URGENT) != 0)) {
+			if ((sta = AscSendScsiQueue(asc_dvc, scsiq,
+						    n_q_required)) == 1) {
+				asc_dvc->in_critical_cnt--;
+				return (sta);
+			}
+		}
+	}
+	asc_dvc->in_critical_cnt--;
+	return (sta);
+}
+
+/*
+ * AdvExeScsiQueue() - Send a request to the RISC microcode program.
+ *
+ *   Allocate a carrier structure, point the carrier to the ADV_SCSI_REQ_Q,
+ *   add the carrier to the ICQ (Initiator Command Queue), and tickle the
+ *   RISC to notify it a new command is ready to be executed.
+ *
+ * If 'done_status' is not set to QD_DO_RETRY, then 'error_retry' will be
+ * set to SCSI_MAX_RETRY.
+ *
+ * Multi-byte fields in the ASC_SCSI_REQ_Q that are used by the microcode
+ * for DMA addresses or math operations are byte swapped to little-endian
+ * order.
+ *
+ * Return:
+ *      ADV_SUCCESS(1) - The request was successfully queued.
+ *      ADV_BUSY(0) -    Resource unavailable; Retry again after pending
+ *                       request completes.
+ *      ADV_ERROR(-1) -  Invalid ADV_SCSI_REQ_Q request structure
+ *                       host IC error.
+ */
+static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
+{
+	AdvPortAddr iop_base;
+	ADV_DCNT req_size;
+	ADV_PADDR req_paddr;
+	ADV_CARR_T *new_carrp;
+
+	/*
+	 * The ADV_SCSI_REQ_Q 'target_id' field should never exceed ADV_MAX_TID.
+	 */
+	if (scsiq->target_id > ADV_MAX_TID) {
+		scsiq->host_status = QHSTA_M_INVALID_DEVICE;
+		scsiq->done_status = QD_WITH_ERROR;
+		return ADV_ERROR;
+	}
+
+	iop_base = asc_dvc->iop_base;
+
+	/*
+	 * Allocate a carrier ensuring at least one carrier always
+	 * remains on the freelist and initialize fields.
+	 */
+	if ((new_carrp = asc_dvc->carr_freelist) == NULL) {
+		return ADV_BUSY;
+	}
+	asc_dvc->carr_freelist = (ADV_CARR_T *)
+	    ADV_U32_TO_VADDR(le32_to_cpu(new_carrp->next_vpa));
+	asc_dvc->carr_pending_cnt++;
+
+	/*
+	 * Set the carrier to be a stopper by setting 'next_vpa'
+	 * to the stopper value. The current stopper will be changed
+	 * below to point to the new stopper.
+	 */
+	new_carrp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
+
+	/*
+	 * Clear the ADV_SCSI_REQ_Q done flag.
+	 */
+	scsiq->a_flag &= ~ADV_SCSIQ_DONE;
+
+	req_size = sizeof(ADV_SCSI_REQ_Q);
+	req_paddr = DvcGetPhyAddr(asc_dvc, scsiq, (uchar *)scsiq,
+				  (ADV_SDCNT *)&req_size, ADV_IS_SCSIQ_FLAG);
+
+	BUG_ON(req_paddr & 31);
+	BUG_ON(req_size < sizeof(ADV_SCSI_REQ_Q));
+
+	/* Wait for assertion before making little-endian */
+	req_paddr = cpu_to_le32(req_paddr);
+
+	/* Save virtual and physical address of ADV_SCSI_REQ_Q and carrier. */
+	scsiq->scsiq_ptr = cpu_to_le32(ADV_VADDR_TO_U32(scsiq));
+	scsiq->scsiq_rptr = req_paddr;
+
+	scsiq->carr_va = cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->icq_sp));
+	/*
+	 * Every ADV_CARR_T.carr_pa is byte swapped to little-endian
+	 * order during initialization.
+	 */
+	scsiq->carr_pa = asc_dvc->icq_sp->carr_pa;
+
+	/*
+	 * Use the current stopper to send the ADV_SCSI_REQ_Q command to
+	 * the microcode. The newly allocated stopper will become the new
+	 * stopper.
+	 */
+	asc_dvc->icq_sp->areq_vpa = req_paddr;
+
+	/*
+	 * Set the 'next_vpa' pointer for the old stopper to be the
+	 * physical address of the new stopper. The RISC can only
+	 * follow physical addresses.
+	 */
+	asc_dvc->icq_sp->next_vpa = new_carrp->carr_pa;
+
+	/*
+	 * Set the host adapter stopper pointer to point to the new carrier.
+	 */
+	asc_dvc->icq_sp = new_carrp;
+
+	if (asc_dvc->chip_type == ADV_CHIP_ASC3550 ||
+	    asc_dvc->chip_type == ADV_CHIP_ASC38C0800) {
+		/*
+		 * Tickle the RISC to tell it to read its Command Queue Head pointer.
+		 */
+		AdvWriteByteRegister(iop_base, IOPB_TICKLE, ADV_TICKLE_A);
+		if (asc_dvc->chip_type == ADV_CHIP_ASC3550) {
+			/*
+			 * Clear the tickle value. In the ASC-3550 the RISC flag
+			 * command 'clr_tickle_a' does not work unless the host
+			 * value is cleared.
+			 */
+			AdvWriteByteRegister(iop_base, IOPB_TICKLE,
+					     ADV_TICKLE_NOP);
+		}
+	} else if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
+		/*
+		 * Notify the RISC a carrier is ready by writing the physical
+		 * address of the new carrier stopper to the COMMA register.
+		 */
+		AdvWriteDWordRegister(iop_base, IOPDW_COMMA,
+				      le32_to_cpu(new_carrp->carr_pa));
+	}
+
+	return ADV_SUCCESS;
+}
+
+/*
+ * Execute a single 'Scsi_Cmnd'.
+ *
+ * The function 'done' is called when the request has been completed.
+ *
+ * Scsi_Cmnd:
+ *
+ *  host - board controlling device
+ *  device - device to send command
+ *  target - target of device
+ *  lun - lun of device
+ *  cmd_len - length of SCSI CDB
+ *  cmnd - buffer for SCSI 8, 10, or 12 byte CDB
+ *  use_sg - if non-zero indicates scatter-gather request with use_sg elements
+ *
+ *  if (use_sg == 0) {
+ *    request_buffer - buffer address for request
+ *    request_bufflen - length of request buffer
+ *  } else {
+ *    request_buffer - pointer to scatterlist structure
+ *  }
+ *
+ *  sense_buffer - sense command buffer
+ *
+ *  result (4 bytes of an int):
+ *    Byte Meaning
+ *    0 SCSI Status Byte Code
+ *    1 SCSI One Byte Message Code
+ *    2 Host Error Code
+ *    3 Mid-Level Error Code
+ *
+ *  host driver fields:
+ *    SCp - Scsi_Pointer used for command processing status
+ *    scsi_done - used to save caller's done function
+ *    host_scribble - used for pointer to another struct scsi_cmnd
+ *
+ * If this function returns ASC_NOERROR the request will be completed
+ * from the interrupt handler.
+ *
+ * If this function returns ASC_ERROR the host error code has been set,
+ * and the called must call asc_scsi_done.
+ *
+ * If ASC_BUSY is returned the request will be returned to the midlayer
+ * and re-tried later.
+ */
+static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
+{
+	asc_board_t *boardp;
+	ASC_DVC_VAR *asc_dvc_varp;
+	ADV_DVC_VAR *adv_dvc_varp;
+	ADV_SCSI_REQ_Q *adv_scsiqp;
+	struct scsi_device *device;
+	int ret;
+
+	ASC_DBG2(1, "asc_execute_scsi_cmnd: scp 0x%lx, done 0x%lx\n",
+		 (ulong)scp, (ulong)scp->scsi_done);
+
+	boardp = ASC_BOARDP(scp->device->host);
+	device = boardp->device[scp->device->id];
+
+	if (ASC_NARROW_BOARD(boardp)) {
+		/*
+		 * Build and execute Narrow Board request.
+		 */
+
+		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
+
+		/*
+		 * Build Asc Library request structure using the
+		 * global structures 'asc_scsi_req' and 'asc_sg_head'.
+		 *
+		 * If an error is returned, then the request has been
+		 * queued on the board done queue. It will be completed
+		 * by the caller.
+		 *
+		 * asc_build_req() can not return ASC_BUSY.
+		 */
+		if (asc_build_req(boardp, scp) == ASC_ERROR) {
+			ASC_STATS(scp->device->host, build_error);
+			return ASC_ERROR;
+		}
+
+		switch (ret = AscExeScsiQueue(asc_dvc_varp, &asc_scsi_q)) {
+		case ASC_NOERROR:
+			ASC_STATS(scp->device->host, exe_noerror);
+			/*
+			 * Increment monotonically increasing per device
+			 * successful request counter. Wrapping doesn't matter.
+			 */
+			boardp->reqcnt[scp->device->id]++;
+			ASC_DBG(1, "asc_execute_scsi_cmnd: AscExeScsiQueue(), "
+				"ASC_NOERROR\n");
+			break;
+		case ASC_BUSY:
+			ASC_STATS(scp->device->host, exe_busy);
+			break;
+		case ASC_ERROR:
+			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
+				"AscExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
+				boardp->id, asc_dvc_varp->err_code);
+			ASC_STATS(scp->device->host, exe_error);
+			scp->result = HOST_BYTE(DID_ERROR);
+			break;
+		default:
+			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
+				"AscExeScsiQueue() unknown, err_code 0x%x\n",
+				boardp->id, asc_dvc_varp->err_code);
+			ASC_STATS(scp->device->host, exe_unknown);
+			scp->result = HOST_BYTE(DID_ERROR);
+			break;
+		}
+	} else {
+		/*
+		 * Build and execute Wide Board request.
+		 */
+		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
+
+		/*
+		 * Build and get a pointer to an Adv Library request structure.
+		 *
+		 * If the request is successfully built then send it below,
+		 * otherwise return with an error.
+		 */
+		switch (adv_build_req(boardp, scp, &adv_scsiqp)) {
+		case ASC_NOERROR:
+			ASC_DBG(3, "asc_execute_scsi_cmnd: adv_build_req "
+				"ASC_NOERROR\n");
+			break;
+		case ASC_BUSY:
+			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
+				"ASC_BUSY\n");
+			/*
+			 * The asc_stats fields 'adv_build_noreq' and
+			 * 'adv_build_nosg' count wide board busy conditions.
+			 * They are updated in adv_build_req and
+			 * adv_get_sglist, respectively.
+			 */
+			return ASC_BUSY;
+		case ASC_ERROR:
+		default:
+			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
+				"ASC_ERROR\n");
+			ASC_STATS(scp->device->host, build_error);
+			return ASC_ERROR;
+		}
+
+		switch (ret = AdvExeScsiQueue(adv_dvc_varp, adv_scsiqp)) {
+		case ASC_NOERROR:
+			ASC_STATS(scp->device->host, exe_noerror);
+			/*
+			 * Increment monotonically increasing per device
+			 * successful request counter. Wrapping doesn't matter.
+			 */
+			boardp->reqcnt[scp->device->id]++;
+			ASC_DBG(1, "asc_execute_scsi_cmnd: AdvExeScsiQueue(), "
+				"ASC_NOERROR\n");
+			break;
+		case ASC_BUSY:
+			ASC_STATS(scp->device->host, exe_busy);
+			break;
+		case ASC_ERROR:
+			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
+				"AdvExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
+				boardp->id, adv_dvc_varp->err_code);
+			ASC_STATS(scp->device->host, exe_error);
+			scp->result = HOST_BYTE(DID_ERROR);
+			break;
+		default:
+			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
+				"AdvExeScsiQueue() unknown, err_code 0x%x\n",
+				boardp->id, adv_dvc_varp->err_code);
+			ASC_STATS(scp->device->host, exe_unknown);
+			scp->result = HOST_BYTE(DID_ERROR);
+			break;
+		}
+	}
+
+	ASC_DBG(1, "asc_execute_scsi_cmnd: end\n");
+	return ret;
+}
+
+/*
+ * advansys_queuecommand() - interrupt-driven I/O entrypoint.
+ *
+ * This function always returns 0. Command return status is saved
+ * in the 'scp' result field.
+ */
+static int
+advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
+{
+	struct Scsi_Host *shost = scp->device->host;
+	asc_board_t *boardp = ASC_BOARDP(shost);
+	unsigned long flags;
+	int asc_res, result = 0;
+
+	ASC_STATS(shost, queuecommand);
+	scp->scsi_done = done;
+
+	/*
+	 * host_lock taken by mid-level prior to call, but need
+	 * to protect against own ISR
+	 */
+	spin_lock_irqsave(&boardp->lock, flags);
+	asc_res = asc_execute_scsi_cmnd(scp);
+	spin_unlock_irqrestore(&boardp->lock, flags);
+
+	switch (asc_res) {
+	case ASC_NOERROR:
+		break;
+	case ASC_BUSY:
+		result = SCSI_MLQUEUE_HOST_BUSY;
+		break;
+	case ASC_ERROR:
+	default:
+		asc_scsi_done(scp);
+		break;
+	}
+
+	return result;
+}
+
+static ushort __devinit AscGetEisaChipCfg(PortAddr iop_base)
+{
+	PortAddr eisa_cfg_iop = (PortAddr) ASC_GET_EISA_SLOT(iop_base) |
+	    (PortAddr) (ASC_EISA_CFG_IOP_MASK);
+	return inpw(eisa_cfg_iop);
+}
+
+/*
+ * Return the BIOS address of the adapter at the specified
+ * I/O port and with the specified bus type.
+ */
+static unsigned short __devinit
+AscGetChipBiosAddress(PortAddr iop_base, unsigned short bus_type)
+{
+	unsigned short cfg_lsw;
+	unsigned short bios_addr;
+
+	/*
+	 * The PCI BIOS is re-located by the motherboard BIOS. Because
+	 * of this the driver can not determine where a PCI BIOS is
+	 * loaded and executes.
+	 */
+	if (bus_type & ASC_IS_PCI)
+		return 0;
+
+	if ((bus_type & ASC_IS_EISA) != 0) {
+		cfg_lsw = AscGetEisaChipCfg(iop_base);
+		cfg_lsw &= 0x000F;
+		bios_addr = ASC_BIOS_MIN_ADDR + cfg_lsw * ASC_BIOS_BANK_SIZE;
+		return bios_addr;
+	}
+
+	cfg_lsw = AscGetChipCfgLsw(iop_base);
+
+	/*
+	 *  ISA PnP uses the top bit as the 32K BIOS flag
+	 */
+	if (bus_type == ASC_IS_ISAPNP)
+		cfg_lsw &= 0x7FFF;
+	bios_addr = ASC_BIOS_MIN_ADDR + (cfg_lsw >> 12) * ASC_BIOS_BANK_SIZE;
+	return bios_addr;
+}
+
+static uchar __devinit AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
+{
+	ushort cfg_lsw;
+
+	if (AscGetChipScsiID(iop_base) == new_host_id) {
+		return (new_host_id);
+	}
+	cfg_lsw = AscGetChipCfgLsw(iop_base);
+	cfg_lsw &= 0xF8FF;
+	cfg_lsw |= (ushort)((new_host_id & ASC_MAX_TID) << 8);
+	AscSetChipCfgLsw(iop_base, cfg_lsw);
+	return (AscGetChipScsiID(iop_base));
+}
+
+static unsigned char __devinit AscGetChipScsiCtrl(PortAddr iop_base)
+{
+	unsigned char sc;
+
+	AscSetBank(iop_base, 1);
+	sc = inp(iop_base + IOP_REG_SC);
+	AscSetBank(iop_base, 0);
+	return sc;
+}
+
+static unsigned char __devinit
+AscGetChipVersion(PortAddr iop_base, unsigned short bus_type)
+{
+	if (bus_type & ASC_IS_EISA) {
+		PortAddr eisa_iop;
+		unsigned char revision;
+		eisa_iop = (PortAddr) ASC_GET_EISA_SLOT(iop_base) |
+		    (PortAddr) ASC_EISA_REV_IOP_MASK;
+		revision = inp(eisa_iop);
+		return ASC_CHIP_MIN_VER_EISA - 1 + revision;
+	}
+	return AscGetChipVerNo(iop_base);
+}
+
+static void __devinit AscToggleIRQAct(PortAddr iop_base)
+{
+	AscSetChipStatus(iop_base, CIW_IRQ_ACT);
+	AscSetChipStatus(iop_base, 0);
+	return;
+}
+
+static uchar __devinit AscGetChipIRQ(PortAddr iop_base, ushort bus_type)
+{
+	ushort cfg_lsw;
+	uchar chip_irq;
+
+	if ((bus_type & ASC_IS_EISA) != 0) {
+		cfg_lsw = AscGetEisaChipCfg(iop_base);
+		chip_irq = (uchar)(((cfg_lsw >> 8) & 0x07) + 10);
+		if ((chip_irq == 13) || (chip_irq > 15)) {
+			return (0);
+		}
+		return (chip_irq);
+	}
+	if ((bus_type & ASC_IS_VL) != 0) {
+		cfg_lsw = AscGetChipCfgLsw(iop_base);
+		chip_irq = (uchar)(((cfg_lsw >> 2) & 0x07));
+		if ((chip_irq == 0) || (chip_irq == 4) || (chip_irq == 7)) {
+			return (0);
+		}
+		return ((uchar)(chip_irq + (ASC_MIN_IRQ_NO - 1)));
+	}
+	cfg_lsw = AscGetChipCfgLsw(iop_base);
+	chip_irq = (uchar)(((cfg_lsw >> 2) & 0x03));
+	if (chip_irq == 3)
+		chip_irq += (uchar)2;
+	return ((uchar)(chip_irq + ASC_MIN_IRQ_NO));
+}
+
+static uchar __devinit
+AscSetChipIRQ(PortAddr iop_base, uchar irq_no, ushort bus_type)
+{
+	ushort cfg_lsw;
+
+	if ((bus_type & ASC_IS_VL) != 0) {
+		if (irq_no != 0) {
+			if ((irq_no < ASC_MIN_IRQ_NO)
+			    || (irq_no > ASC_MAX_IRQ_NO)) {
+				irq_no = 0;
+			} else {
+				irq_no -= (uchar)((ASC_MIN_IRQ_NO - 1));
+			}
+		}
+		cfg_lsw = (ushort)(AscGetChipCfgLsw(iop_base) & 0xFFE3);
+		cfg_lsw |= (ushort)0x0010;
+		AscSetChipCfgLsw(iop_base, cfg_lsw);
+		AscToggleIRQAct(iop_base);
+		cfg_lsw = (ushort)(AscGetChipCfgLsw(iop_base) & 0xFFE0);
+		cfg_lsw |= (ushort)((irq_no & 0x07) << 2);
+		AscSetChipCfgLsw(iop_base, cfg_lsw);
+		AscToggleIRQAct(iop_base);
+		return (AscGetChipIRQ(iop_base, bus_type));
+	}
+	if ((bus_type & (ASC_IS_ISA)) != 0) {
+		if (irq_no == 15)
+			irq_no -= (uchar)2;
+		irq_no -= (uchar)ASC_MIN_IRQ_NO;
+		cfg_lsw = (ushort)(AscGetChipCfgLsw(iop_base) & 0xFFF3);
+		cfg_lsw |= (ushort)((irq_no & 0x03) << 2);
+		AscSetChipCfgLsw(iop_base, cfg_lsw);
+		return (AscGetChipIRQ(iop_base, bus_type));
+	}
+	return (0);
+}
+
+#ifdef CONFIG_ISA
+static void __devinit AscEnableIsaDma(uchar dma_channel)
+{
+	if (dma_channel < 4) {
+		outp(0x000B, (ushort)(0xC0 | dma_channel));
+		outp(0x000A, dma_channel);
+	} else if (dma_channel < 8) {
+		outp(0x00D6, (ushort)(0xC0 | (dma_channel - 4)));
+		outp(0x00D4, (ushort)(dma_channel - 4));
+	}
+	return;
+}
+#endif /* CONFIG_ISA */
+
+static int AscStopQueueExe(PortAddr iop_base)
+{
+	int count = 0;
+
+	if (AscReadLramByte(iop_base, ASCV_STOP_CODE_B) == 0) {
+		AscWriteLramByte(iop_base, ASCV_STOP_CODE_B,
+				 ASC_STOP_REQ_RISC_STOP);
+		do {
+			if (AscReadLramByte(iop_base, ASCV_STOP_CODE_B) &
+			    ASC_STOP_ACK_RISC_STOP) {
+				return (1);
+			}
+			mdelay(100);
+		} while (count++ < 20);
+	}
+	return (0);
+}
+
+static ASC_DCNT __devinit AscGetMaxDmaCount(ushort bus_type)
+{
+	if (bus_type & ASC_IS_ISA)
+		return ASC_MAX_ISA_DMA_COUNT;
+	else if (bus_type & (ASC_IS_EISA | ASC_IS_VL))
+		return ASC_MAX_VL_DMA_COUNT;
+	return ASC_MAX_PCI_DMA_COUNT;
+}
+
+#ifdef CONFIG_ISA
+static ushort __devinit AscGetIsaDmaChannel(PortAddr iop_base)
+{
+	ushort channel;
+
+	channel = AscGetChipCfgLsw(iop_base) & 0x0003;
+	if (channel == 0x03)
+		return (0);
+	else if (channel == 0x00)
+		return (7);
+	return (channel + 4);
+}
+
+static ushort __devinit AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channel)
+{
+	ushort cfg_lsw;
+	uchar value;
+
+	if ((dma_channel >= 5) && (dma_channel <= 7)) {
+		if (dma_channel == 7)
+			value = 0x00;
+		else
+			value = dma_channel - 4;
+		cfg_lsw = AscGetChipCfgLsw(iop_base) & 0xFFFC;
+		cfg_lsw |= value;
+		AscSetChipCfgLsw(iop_base, cfg_lsw);
+		return (AscGetIsaDmaChannel(iop_base));
+	}
+	return 0;
+}
+
+static uchar __devinit AscGetIsaDmaSpeed(PortAddr iop_base)
+{
+	uchar speed_value;
+
+	AscSetBank(iop_base, 1);
+	speed_value = AscReadChipDmaSpeed(iop_base);
+	speed_value &= 0x07;
+	AscSetBank(iop_base, 0);
+	return speed_value;
+}
+
+static uchar __devinit AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
+{
+	speed_value &= 0x07;
+	AscSetBank(iop_base, 1);
+	AscWriteChipDmaSpeed(iop_base, speed_value);
+	AscSetBank(iop_base, 0);
+	return AscGetIsaDmaSpeed(iop_base);
+}
+#endif /* CONFIG_ISA */
+
+static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
+{
+	int i;
+	PortAddr iop_base;
+	ushort warn_code;
+	uchar chip_version;
+
+	iop_base = asc_dvc->iop_base;
+	warn_code = 0;
+	asc_dvc->err_code = 0;
+	if ((asc_dvc->bus_type &
+	     (ASC_IS_ISA | ASC_IS_PCI | ASC_IS_EISA | ASC_IS_VL)) == 0) {
+		asc_dvc->err_code |= ASC_IERR_NO_BUS_TYPE;
+	}
+	AscSetChipControl(iop_base, CC_HALT);
+	AscSetChipStatus(iop_base, 0);
+	asc_dvc->bug_fix_cntl = 0;
+	asc_dvc->pci_fix_asyn_xfer = 0;
+	asc_dvc->pci_fix_asyn_xfer_always = 0;
+	/* asc_dvc->init_state initalized in AscInitGetConfig(). */
+	asc_dvc->sdtr_done = 0;
+	asc_dvc->cur_total_qng = 0;
+	asc_dvc->is_in_int = 0;
+	asc_dvc->in_critical_cnt = 0;
+	asc_dvc->last_q_shortage = 0;
+	asc_dvc->use_tagged_qng = 0;
+	asc_dvc->no_scam = 0;
+	asc_dvc->unit_not_ready = 0;
+	asc_dvc->queue_full_or_busy = 0;
+	asc_dvc->redo_scam = 0;
+	asc_dvc->res2 = 0;
+	asc_dvc->host_init_sdtr_index = 0;
+	asc_dvc->cfg->can_tagged_qng = 0;
+	asc_dvc->cfg->cmd_qng_enabled = 0;
+	asc_dvc->dvc_cntl = ASC_DEF_DVC_CNTL;
+	asc_dvc->init_sdtr = 0;
+	asc_dvc->max_total_qng = ASC_DEF_MAX_TOTAL_QNG;
+	asc_dvc->scsi_reset_wait = 3;
+	asc_dvc->start_motor = ASC_SCSI_WIDTH_BIT_SET;
+	asc_dvc->max_dma_count = AscGetMaxDmaCount(asc_dvc->bus_type);
+	asc_dvc->cfg->sdtr_enable = ASC_SCSI_WIDTH_BIT_SET;
+	asc_dvc->cfg->disc_enable = ASC_SCSI_WIDTH_BIT_SET;
+	asc_dvc->cfg->chip_scsi_id = ASC_DEF_CHIP_SCSI_ID;
+	asc_dvc->cfg->lib_serial_no = ASC_LIB_SERIAL_NUMBER;
+	asc_dvc->cfg->lib_version = (ASC_LIB_VERSION_MAJOR << 8) |
+	    ASC_LIB_VERSION_MINOR;
+	chip_version = AscGetChipVersion(iop_base, asc_dvc->bus_type);
+	asc_dvc->cfg->chip_version = chip_version;
+	asc_dvc->sdtr_period_tbl[0] = SYN_XFER_NS_0;
+	asc_dvc->sdtr_period_tbl[1] = SYN_XFER_NS_1;
+	asc_dvc->sdtr_period_tbl[2] = SYN_XFER_NS_2;
+	asc_dvc->sdtr_period_tbl[3] = SYN_XFER_NS_3;
+	asc_dvc->sdtr_period_tbl[4] = SYN_XFER_NS_4;
+	asc_dvc->sdtr_period_tbl[5] = SYN_XFER_NS_5;
+	asc_dvc->sdtr_period_tbl[6] = SYN_XFER_NS_6;
+	asc_dvc->sdtr_period_tbl[7] = SYN_XFER_NS_7;
+	asc_dvc->max_sdtr_index = 7;
+	if ((asc_dvc->bus_type & ASC_IS_PCI) &&
+	    (chip_version >= ASC_CHIP_VER_PCI_ULTRA_3150)) {
+		asc_dvc->bus_type = ASC_IS_PCI_ULTRA;
+		asc_dvc->sdtr_period_tbl[0] = SYN_ULTRA_XFER_NS_0;
+		asc_dvc->sdtr_period_tbl[1] = SYN_ULTRA_XFER_NS_1;
+		asc_dvc->sdtr_period_tbl[2] = SYN_ULTRA_XFER_NS_2;
+		asc_dvc->sdtr_period_tbl[3] = SYN_ULTRA_XFER_NS_3;
+		asc_dvc->sdtr_period_tbl[4] = SYN_ULTRA_XFER_NS_4;
+		asc_dvc->sdtr_period_tbl[5] = SYN_ULTRA_XFER_NS_5;
+		asc_dvc->sdtr_period_tbl[6] = SYN_ULTRA_XFER_NS_6;
+		asc_dvc->sdtr_period_tbl[7] = SYN_ULTRA_XFER_NS_7;
+		asc_dvc->sdtr_period_tbl[8] = SYN_ULTRA_XFER_NS_8;
+		asc_dvc->sdtr_period_tbl[9] = SYN_ULTRA_XFER_NS_9;
+		asc_dvc->sdtr_period_tbl[10] = SYN_ULTRA_XFER_NS_10;
+		asc_dvc->sdtr_period_tbl[11] = SYN_ULTRA_XFER_NS_11;
+		asc_dvc->sdtr_period_tbl[12] = SYN_ULTRA_XFER_NS_12;
+		asc_dvc->sdtr_period_tbl[13] = SYN_ULTRA_XFER_NS_13;
+		asc_dvc->sdtr_period_tbl[14] = SYN_ULTRA_XFER_NS_14;
+		asc_dvc->sdtr_period_tbl[15] = SYN_ULTRA_XFER_NS_15;
+		asc_dvc->max_sdtr_index = 15;
+		if (chip_version == ASC_CHIP_VER_PCI_ULTRA_3150) {
+			AscSetExtraControl(iop_base,
+					   (SEC_ACTIVE_NEGATE | SEC_SLEW_RATE));
+		} else if (chip_version >= ASC_CHIP_VER_PCI_ULTRA_3050) {
+			AscSetExtraControl(iop_base,
+					   (SEC_ACTIVE_NEGATE |
+					    SEC_ENABLE_FILTER));
+		}
+	}
+	if (asc_dvc->bus_type == ASC_IS_PCI) {
+		AscSetExtraControl(iop_base,
+				   (SEC_ACTIVE_NEGATE | SEC_SLEW_RATE));
+	}
+
+	asc_dvc->cfg->isa_dma_speed = ASC_DEF_ISA_DMA_SPEED;
+#ifdef CONFIG_ISA
+	if ((asc_dvc->bus_type & ASC_IS_ISA) != 0) {
+		if (chip_version >= ASC_CHIP_MIN_VER_ISA_PNP) {
+			AscSetChipIFC(iop_base, IFC_INIT_DEFAULT);
+			asc_dvc->bus_type = ASC_IS_ISAPNP;
+		}
+		asc_dvc->cfg->isa_dma_channel =
+		    (uchar)AscGetIsaDmaChannel(iop_base);
+	}
+#endif /* CONFIG_ISA */
+	for (i = 0; i <= ASC_MAX_TID; i++) {
+		asc_dvc->cur_dvc_qng[i] = 0;
+		asc_dvc->max_dvc_qng[i] = ASC_MAX_SCSI1_QNG;
+		asc_dvc->scsiq_busy_head[i] = (ASC_SCSI_Q *)0L;
+		asc_dvc->scsiq_busy_tail[i] = (ASC_SCSI_Q *)0L;
+		asc_dvc->cfg->max_tag_qng[i] = ASC_MAX_INRAM_TAG_QNG;
+	}
+	return warn_code;
+}
+
+static int __devinit AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
+{
+	int retry;
+
+	for (retry = 0; retry < ASC_EEP_MAX_RETRY; retry++) {
+		unsigned char read_back;
+		AscSetChipEEPCmd(iop_base, cmd_reg);
+		mdelay(1);
+		read_back = AscGetChipEEPCmd(iop_base);
+		if (read_back == cmd_reg)
+			return 1;
+	}
+	return 0;
+}
+
+static void __devinit AscWaitEEPRead(void)
+{
+	mdelay(1);
+}
+
+static ushort __devinit AscReadEEPWord(PortAddr iop_base, uchar addr)
+{
+	ushort read_wval;
+	uchar cmd_reg;
+
+	AscWriteEEPCmdReg(iop_base, ASC_EEP_CMD_WRITE_DISABLE);
+	AscWaitEEPRead();
+	cmd_reg = addr | ASC_EEP_CMD_READ;
+	AscWriteEEPCmdReg(iop_base, cmd_reg);
+	AscWaitEEPRead();
+	read_wval = AscGetChipEEPData(iop_base);
+	AscWaitEEPRead();
+	return read_wval;
+}
+
+static ushort __devinit
+AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
+{
+	ushort wval;
+	ushort sum;
+	ushort *wbuf;
+	int cfg_beg;
+	int cfg_end;
+	int uchar_end_in_config = ASC_EEP_MAX_DVC_ADDR - 2;
+	int s_addr;
+
+	wbuf = (ushort *)cfg_buf;
+	sum = 0;
+	/* Read two config words; Byte-swapping done by AscReadEEPWord(). */
+	for (s_addr = 0; s_addr < 2; s_addr++, wbuf++) {
+		*wbuf = AscReadEEPWord(iop_base, (uchar)s_addr);
+		sum += *wbuf;
+	}
+	if (bus_type & ASC_IS_VL) {
+		cfg_beg = ASC_EEP_DVC_CFG_BEG_VL;
+		cfg_end = ASC_EEP_MAX_DVC_ADDR_VL;
+	} else {
+		cfg_beg = ASC_EEP_DVC_CFG_BEG;
+		cfg_end = ASC_EEP_MAX_DVC_ADDR;
+	}
+	for (s_addr = cfg_beg; s_addr <= (cfg_end - 1); s_addr++, wbuf++) {
+		wval = AscReadEEPWord(iop_base, (uchar)s_addr);
+		if (s_addr <= uchar_end_in_config) {
+			/*
+			 * Swap all char fields - must unswap bytes already swapped
+			 * by AscReadEEPWord().
+			 */
+			*wbuf = le16_to_cpu(wval);
+		} else {
+			/* Don't swap word field at the end - cntl field. */
+			*wbuf = wval;
+		}
+		sum += wval;	/* Checksum treats all EEPROM data as words. */
+	}
+	/*
+	 * Read the checksum word which will be compared against 'sum'
+	 * by the caller. Word field already swapped.
+	 */
+	*wbuf = AscReadEEPWord(iop_base, (uchar)s_addr);
+	return sum;
+}
+
+static int __devinit AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
+{
+	PortAddr iop_base;
+	ushort q_addr;
+	ushort saved_word;
+	int sta;
+
+	iop_base = asc_dvc->iop_base;
+	sta = 0;
+	q_addr = ASC_QNO_TO_QADDR(241);
+	saved_word = AscReadLramWord(iop_base, q_addr);
+	AscSetChipLramAddr(iop_base, q_addr);
+	AscSetChipLramData(iop_base, 0x55AA);
+	mdelay(10);
+	AscSetChipLramAddr(iop_base, q_addr);
+	if (AscGetChipLramData(iop_base) == 0x55AA) {
+		sta = 1;
+		AscWriteLramWord(iop_base, q_addr, saved_word);
+	}
+	return (sta);
+}
+
+static void __devinit AscWaitEEPWrite(void)
+{
+	mdelay(20);
+	return;
+}
+
+static int __devinit AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
+{
+	ushort read_back;
+	int retry;
+
+	retry = 0;
+	while (TRUE) {
+		AscSetChipEEPData(iop_base, data_reg);
+		mdelay(1);
+		read_back = AscGetChipEEPData(iop_base);
+		if (read_back == data_reg) {
+			return (1);
+		}
+		if (retry++ > ASC_EEP_MAX_RETRY) {
+			return (0);
+		}
+	}
+}
+
+static ushort __devinit
+AscWriteEEPWord(PortAddr iop_base, uchar addr, ushort word_val)
+{
+	ushort read_wval;
+
+	read_wval = AscReadEEPWord(iop_base, addr);
+	if (read_wval != word_val) {
+		AscWriteEEPCmdReg(iop_base, ASC_EEP_CMD_WRITE_ABLE);
+		AscWaitEEPRead();
+		AscWriteEEPDataReg(iop_base, word_val);
+		AscWaitEEPRead();
+		AscWriteEEPCmdReg(iop_base,
+				  (uchar)((uchar)ASC_EEP_CMD_WRITE | addr));
+		AscWaitEEPWrite();
+		AscWriteEEPCmdReg(iop_base, ASC_EEP_CMD_WRITE_DISABLE);
+		AscWaitEEPRead();
+		return (AscReadEEPWord(iop_base, addr));
+	}
+	return (read_wval);
+}
+
+static int __devinit
+AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
+{
+	int n_error;
+	ushort *wbuf;
+	ushort word;
+	ushort sum;
+	int s_addr;
+	int cfg_beg;
+	int cfg_end;
+	int uchar_end_in_config = ASC_EEP_MAX_DVC_ADDR - 2;
+
+	wbuf = (ushort *)cfg_buf;
+	n_error = 0;
+	sum = 0;
+	/* Write two config words; AscWriteEEPWord() will swap bytes. */
+	for (s_addr = 0; s_addr < 2; s_addr++, wbuf++) {
+		sum += *wbuf;
+		if (*wbuf != AscWriteEEPWord(iop_base, (uchar)s_addr, *wbuf)) {
+			n_error++;
+		}
+	}
+	if (bus_type & ASC_IS_VL) {
+		cfg_beg = ASC_EEP_DVC_CFG_BEG_VL;
+		cfg_end = ASC_EEP_MAX_DVC_ADDR_VL;
+	} else {
+		cfg_beg = ASC_EEP_DVC_CFG_BEG;
+		cfg_end = ASC_EEP_MAX_DVC_ADDR;
+	}
+	for (s_addr = cfg_beg; s_addr <= (cfg_end - 1); s_addr++, wbuf++) {
+		if (s_addr <= uchar_end_in_config) {
+			/*
+			 * This is a char field. Swap char fields before they are
+			 * swapped again by AscWriteEEPWord().
+			 */
+			word = cpu_to_le16(*wbuf);
+			if (word !=
+			    AscWriteEEPWord(iop_base, (uchar)s_addr, word)) {
+				n_error++;
+			}
+		} else {
+			/* Don't swap word field at the end - cntl field. */
+			if (*wbuf !=
+			    AscWriteEEPWord(iop_base, (uchar)s_addr, *wbuf)) {
+				n_error++;
+			}
+		}
+		sum += *wbuf;	/* Checksum calculated from word values. */
+	}
+	/* Write checksum word. It will be swapped by AscWriteEEPWord(). */
+	*wbuf = sum;
+	if (sum != AscWriteEEPWord(iop_base, (uchar)s_addr, sum)) {
+		n_error++;
+	}
+
+	/* Read EEPROM back again. */
+	wbuf = (ushort *)cfg_buf;
+	/*
+	 * Read two config words; Byte-swapping done by AscReadEEPWord().
+	 */
+	for (s_addr = 0; s_addr < 2; s_addr++, wbuf++) {
+		if (*wbuf != AscReadEEPWord(iop_base, (uchar)s_addr)) {
+			n_error++;
+		}
+	}
+	if (bus_type & ASC_IS_VL) {
+		cfg_beg = ASC_EEP_DVC_CFG_BEG_VL;
+		cfg_end = ASC_EEP_MAX_DVC_ADDR_VL;
+	} else {
+		cfg_beg = ASC_EEP_DVC_CFG_BEG;
+		cfg_end = ASC_EEP_MAX_DVC_ADDR;
+	}
+	for (s_addr = cfg_beg; s_addr <= (cfg_end - 1); s_addr++, wbuf++) {
+		if (s_addr <= uchar_end_in_config) {
+			/*
+			 * Swap all char fields. Must unswap bytes already swapped
+			 * by AscReadEEPWord().
+			 */
+			word =
+			    le16_to_cpu(AscReadEEPWord
+					(iop_base, (uchar)s_addr));
+		} else {
+			/* Don't swap word field at the end - cntl field. */
+			word = AscReadEEPWord(iop_base, (uchar)s_addr);
+		}
+		if (*wbuf != word) {
+			n_error++;
+		}
+	}
+	/* Read checksum; Byte swapping not needed. */
+	if (AscReadEEPWord(iop_base, (uchar)s_addr) != sum) {
+		n_error++;
+	}
+	return n_error;
+}
+
+static int __devinit
+AscSetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_type)
+{
+	int retry;
+	int n_error;
+
+	retry = 0;
+	while (TRUE) {
+		if ((n_error = AscSetEEPConfigOnce(iop_base, cfg_buf,
+						   bus_type)) == 0) {
+			break;
+		}
+		if (++retry > ASC_EEP_MAX_RETRY) {
+			break;
+		}
+	}
+	return n_error;
+}
+
+static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
+{
+	ASCEEP_CONFIG eep_config_buf;
+	ASCEEP_CONFIG *eep_config;
+	PortAddr iop_base;
+	ushort chksum;
+	ushort warn_code;
+	ushort cfg_msw, cfg_lsw;
+	int i;
+	int write_eep = 0;
+
+	iop_base = asc_dvc->iop_base;
+	warn_code = 0;
+	AscWriteLramWord(iop_base, ASCV_HALTCODE_W, 0x00FE);
+	AscStopQueueExe(iop_base);
+	if ((AscStopChip(iop_base) == FALSE) ||
+	    (AscGetChipScsiCtrl(iop_base) != 0)) {
+		asc_dvc->init_state |= ASC_INIT_RESET_SCSI_DONE;
+		AscResetChipAndScsiBus(asc_dvc);
+		mdelay(asc_dvc->scsi_reset_wait * 1000); /* XXX: msleep? */
+	}
+	if (AscIsChipHalted(iop_base) == FALSE) {
+		asc_dvc->err_code |= ASC_IERR_START_STOP_CHIP;
+		return (warn_code);
+	}
+	AscSetPCAddr(iop_base, ASC_MCODE_START_ADDR);
+	if (AscGetPCAddr(iop_base) != ASC_MCODE_START_ADDR) {
+		asc_dvc->err_code |= ASC_IERR_SET_PC_ADDR;
+		return (warn_code);
+	}
+	eep_config = (ASCEEP_CONFIG *)&eep_config_buf;
+	cfg_msw = AscGetChipCfgMsw(iop_base);
+	cfg_lsw = AscGetChipCfgLsw(iop_base);
+	if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {
+		cfg_msw &= ~ASC_CFG_MSW_CLR_MASK;
+		warn_code |= ASC_WARN_CFG_MSW_RECOVER;
+		AscSetChipCfgMsw(iop_base, cfg_msw);
+	}
+	chksum = AscGetEEPConfig(iop_base, eep_config, asc_dvc->bus_type);
+	ASC_DBG1(1, "AscInitFromEEP: chksum 0x%x\n", chksum);
+	if (chksum == 0) {
+		chksum = 0xaa55;
+	}
+	if (AscGetChipStatus(iop_base) & CSW_AUTO_CONFIG) {
+		warn_code |= ASC_WARN_AUTO_CONFIG;
+		if (asc_dvc->cfg->chip_version == 3) {
+			if (eep_config->cfg_lsw != cfg_lsw) {
+				warn_code |= ASC_WARN_EEPROM_RECOVER;
+				eep_config->cfg_lsw =
+				    AscGetChipCfgLsw(iop_base);
+			}
+			if (eep_config->cfg_msw != cfg_msw) {
+				warn_code |= ASC_WARN_EEPROM_RECOVER;
+				eep_config->cfg_msw =
+				    AscGetChipCfgMsw(iop_base);
+			}
+		}
+	}
+	eep_config->cfg_msw &= ~ASC_CFG_MSW_CLR_MASK;
+	eep_config->cfg_lsw |= ASC_CFG0_HOST_INT_ON;
+	ASC_DBG1(1, "AscInitFromEEP: eep_config->chksum 0x%x\n",
+		 eep_config->chksum);
+	if (chksum != eep_config->chksum) {
+		if (AscGetChipVersion(iop_base, asc_dvc->bus_type) ==
+		    ASC_CHIP_VER_PCI_ULTRA_3050) {
+			ASC_DBG(1,
+				"AscInitFromEEP: chksum error ignored; EEPROM-less board\n");
+			eep_config->init_sdtr = 0xFF;
+			eep_config->disc_enable = 0xFF;
+			eep_config->start_motor = 0xFF;
+			eep_config->use_cmd_qng = 0;
+			eep_config->max_total_qng = 0xF0;
+			eep_config->max_tag_qng = 0x20;
+			eep_config->cntl = 0xBFFF;
+			ASC_EEP_SET_CHIP_ID(eep_config, 7);
+			eep_config->no_scam = 0;
+			eep_config->adapter_info[0] = 0;
+			eep_config->adapter_info[1] = 0;
+			eep_config->adapter_info[2] = 0;
+			eep_config->adapter_info[3] = 0;
+			eep_config->adapter_info[4] = 0;
+			/* Indicate EEPROM-less board. */
+			eep_config->adapter_info[5] = 0xBB;
+		} else {
+			ASC_PRINT
+			    ("AscInitFromEEP: EEPROM checksum error; Will try to re-write EEPROM.\n");
+			write_eep = 1;
+			warn_code |= ASC_WARN_EEPROM_CHKSUM;
+		}
+	}
+	asc_dvc->cfg->sdtr_enable = eep_config->init_sdtr;
+	asc_dvc->cfg->disc_enable = eep_config->disc_enable;
+	asc_dvc->cfg->cmd_qng_enabled = eep_config->use_cmd_qng;
+	asc_dvc->cfg->isa_dma_speed = ASC_EEP_GET_DMA_SPD(eep_config);
+	asc_dvc->start_motor = eep_config->start_motor;
+	asc_dvc->dvc_cntl = eep_config->cntl;
+	asc_dvc->no_scam = eep_config->no_scam;
+	asc_dvc->cfg->adapter_info[0] = eep_config->adapter_info[0];
+	asc_dvc->cfg->adapter_info[1] = eep_config->adapter_info[1];
+	asc_dvc->cfg->adapter_info[2] = eep_config->adapter_info[2];
+	asc_dvc->cfg->adapter_info[3] = eep_config->adapter_info[3];
+	asc_dvc->cfg->adapter_info[4] = eep_config->adapter_info[4];
+	asc_dvc->cfg->adapter_info[5] = eep_config->adapter_info[5];
+	if (!AscTestExternalLram(asc_dvc)) {
+		if (((asc_dvc->bus_type & ASC_IS_PCI_ULTRA) ==
+		     ASC_IS_PCI_ULTRA)) {
+			eep_config->max_total_qng =
+			    ASC_MAX_PCI_ULTRA_INRAM_TOTAL_QNG;
+			eep_config->max_tag_qng =
+			    ASC_MAX_PCI_ULTRA_INRAM_TAG_QNG;
+		} else {
+			eep_config->cfg_msw |= 0x0800;
+			cfg_msw |= 0x0800;
+			AscSetChipCfgMsw(iop_base, cfg_msw);
+			eep_config->max_total_qng = ASC_MAX_PCI_INRAM_TOTAL_QNG;
+			eep_config->max_tag_qng = ASC_MAX_INRAM_TAG_QNG;
+		}
+	} else {
+	}
+	if (eep_config->max_total_qng < ASC_MIN_TOTAL_QNG) {
+		eep_config->max_total_qng = ASC_MIN_TOTAL_QNG;
+	}
+	if (eep_config->max_total_qng > ASC_MAX_TOTAL_QNG) {
+		eep_config->max_total_qng = ASC_MAX_TOTAL_QNG;
+	}
+	if (eep_config->max_tag_qng > eep_config->max_total_qng) {
+		eep_config->max_tag_qng = eep_config->max_total_qng;
+	}
+	if (eep_config->max_tag_qng < ASC_MIN_TAG_Q_PER_DVC) {
+		eep_config->max_tag_qng = ASC_MIN_TAG_Q_PER_DVC;
+	}
+	asc_dvc->max_total_qng = eep_config->max_total_qng;
+	if ((eep_config->use_cmd_qng & eep_config->disc_enable) !=
+	    eep_config->use_cmd_qng) {
+		eep_config->disc_enable = eep_config->use_cmd_qng;
+		warn_code |= ASC_WARN_CMD_QNG_CONFLICT;
+	}
+	if (asc_dvc->bus_type & (ASC_IS_ISA | ASC_IS_VL | ASC_IS_EISA)) {
+		asc_dvc->irq_no = AscGetChipIRQ(iop_base, asc_dvc->bus_type);
+	}
+	ASC_EEP_SET_CHIP_ID(eep_config,
+			    ASC_EEP_GET_CHIP_ID(eep_config) & ASC_MAX_TID);
+	asc_dvc->cfg->chip_scsi_id = ASC_EEP_GET_CHIP_ID(eep_config);
+	if (((asc_dvc->bus_type & ASC_IS_PCI_ULTRA) == ASC_IS_PCI_ULTRA) &&
+	    !(asc_dvc->dvc_cntl & ASC_CNTL_SDTR_ENABLE_ULTRA)) {
+		asc_dvc->host_init_sdtr_index = ASC_SDTR_ULTRA_PCI_10MB_INDEX;
+	}
+
+	for (i = 0; i <= ASC_MAX_TID; i++) {
+		asc_dvc->dos_int13_table[i] = eep_config->dos_int13_table[i];
+		asc_dvc->cfg->max_tag_qng[i] = eep_config->max_tag_qng;
+		asc_dvc->cfg->sdtr_period_offset[i] =
+		    (uchar)(ASC_DEF_SDTR_OFFSET |
+			    (asc_dvc->host_init_sdtr_index << 4));
+	}
+	eep_config->cfg_msw = AscGetChipCfgMsw(iop_base);
+	if (write_eep) {
+		if ((i = AscSetEEPConfig(iop_base, eep_config,
+				     asc_dvc->bus_type)) != 0) {
+			ASC_PRINT1
+			    ("AscInitFromEEP: Failed to re-write EEPROM with %d errors.\n",
+			     i);
+		} else {
+			ASC_PRINT
+			    ("AscInitFromEEP: Successfully re-wrote EEPROM.\n");
+		}
+	}
+	return (warn_code);
+}
+
+static int __devinit AscInitGetConfig(asc_board_t *boardp)
+{
+	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
+	unsigned short warn_code = 0;
+
+	asc_dvc->init_state = ASC_INIT_STATE_BEG_GET_CFG;
+	if (asc_dvc->err_code != 0)
+		return asc_dvc->err_code;
+
+	if (AscFindSignature(asc_dvc->iop_base)) {
+		warn_code |= AscInitAscDvcVar(asc_dvc);
+		warn_code |= AscInitFromEEP(asc_dvc);
+		asc_dvc->init_state |= ASC_INIT_STATE_END_GET_CFG;
+		if (asc_dvc->scsi_reset_wait > ASC_MAX_SCSI_RESET_WAIT)
+			asc_dvc->scsi_reset_wait = ASC_MAX_SCSI_RESET_WAIT;
+	} else {
+		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
+	}
+
+	switch (warn_code) {
+	case 0:	/* No error */
+		break;
+	case ASC_WARN_IO_PORT_ROTATE:
+		ASC_PRINT1("AscInitGetConfig: board %d: I/O port address "
+			   "modified\n", boardp->id);
+		break;
+	case ASC_WARN_AUTO_CONFIG:
+		ASC_PRINT1("AscInitGetConfig: board %d: I/O port increment "
+			   "switch enabled\n", boardp->id);
+		break;
+	case ASC_WARN_EEPROM_CHKSUM:
+		ASC_PRINT1("AscInitGetConfig: board %d: EEPROM checksum "
+			   "error\n", boardp->id);
+		break;
+	case ASC_WARN_IRQ_MODIFIED:
+		ASC_PRINT1("AscInitGetConfig: board %d: IRQ modified\n",
+			   boardp->id);
+		break;
+	case ASC_WARN_CMD_QNG_CONFLICT:
+		ASC_PRINT1("AscInitGetConfig: board %d: tag queuing enabled "
+			   "w/o disconnects\n", boardp->id);
+		break;
+	default:
+		ASC_PRINT2("AscInitGetConfig: board %d: unknown warning: "
+			   "0x%x\n", boardp->id, warn_code);
+		break;
+	}
+
+	if (asc_dvc->err_code != 0) {
+		ASC_PRINT3("AscInitGetConfig: board %d error: init_state 0x%x, "
+			   "err_code 0x%x\n", boardp->id, asc_dvc->init_state,
+			   asc_dvc->err_code);
+	}
+
+	return asc_dvc->err_code;
+}
+
+static int __devinit AscInitSetConfig(struct pci_dev *pdev, asc_board_t *boardp)
+{
+	ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
+	PortAddr iop_base = asc_dvc->iop_base;
+	unsigned short cfg_msw;
+	unsigned short warn_code = 0;
+
+	asc_dvc->init_state |= ASC_INIT_STATE_BEG_SET_CFG;
+	if (asc_dvc->err_code != 0)
+		return asc_dvc->err_code;
+	if (!AscFindSignature(asc_dvc->iop_base)) {
+		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
+		return asc_dvc->err_code;
+	}
+
+	cfg_msw = AscGetChipCfgMsw(iop_base);
+	if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {
+		cfg_msw &= ~ASC_CFG_MSW_CLR_MASK;
+		warn_code |= ASC_WARN_CFG_MSW_RECOVER;
+		AscSetChipCfgMsw(iop_base, cfg_msw);
+	}
+	if ((asc_dvc->cfg->cmd_qng_enabled & asc_dvc->cfg->disc_enable) !=
+	    asc_dvc->cfg->cmd_qng_enabled) {
+		asc_dvc->cfg->disc_enable = asc_dvc->cfg->cmd_qng_enabled;
+		warn_code |= ASC_WARN_CMD_QNG_CONFLICT;
+	}
+	if (AscGetChipStatus(iop_base) & CSW_AUTO_CONFIG) {
+		warn_code |= ASC_WARN_AUTO_CONFIG;
+	}
+	if ((asc_dvc->bus_type & (ASC_IS_ISA | ASC_IS_VL)) != 0) {
+		if (AscSetChipIRQ(iop_base, asc_dvc->irq_no, asc_dvc->bus_type)
+		    != asc_dvc->irq_no) {
+			asc_dvc->err_code |= ASC_IERR_SET_IRQ_NO;
+		}
+	}
+#ifdef CONFIG_PCI
+	if (asc_dvc->bus_type & ASC_IS_PCI) {
+		cfg_msw &= 0xFFC0;
+		AscSetChipCfgMsw(iop_base, cfg_msw);
+		if ((asc_dvc->bus_type & ASC_IS_PCI_ULTRA) == ASC_IS_PCI_ULTRA) {
+		} else {
+			if ((pdev->device == PCI_DEVICE_ID_ASP_1200A) ||
+			    (pdev->device == PCI_DEVICE_ID_ASP_ABP940)) {
+				asc_dvc->bug_fix_cntl |= ASC_BUG_FIX_IF_NOT_DWB;
+				asc_dvc->bug_fix_cntl |=
+				    ASC_BUG_FIX_ASYN_USE_SYN;
+			}
+		}
+	} else
+#endif /* CONFIG_PCI */
+	if (asc_dvc->bus_type == ASC_IS_ISAPNP) {
+		if (AscGetChipVersion(iop_base, asc_dvc->bus_type)
+		    == ASC_CHIP_VER_ASYN_BUG) {
+			asc_dvc->bug_fix_cntl |= ASC_BUG_FIX_ASYN_USE_SYN;
+		}
+	}
+	if (AscSetChipScsiID(iop_base, asc_dvc->cfg->chip_scsi_id) !=
+	    asc_dvc->cfg->chip_scsi_id) {
+		asc_dvc->err_code |= ASC_IERR_SET_SCSI_ID;
+	}
+#ifdef CONFIG_ISA
+	if (asc_dvc->bus_type & ASC_IS_ISA) {
+		AscSetIsaDmaChannel(iop_base, asc_dvc->cfg->isa_dma_channel);
+		AscSetIsaDmaSpeed(iop_base, asc_dvc->cfg->isa_dma_speed);
+	}
+#endif /* CONFIG_ISA */
+
+	asc_dvc->init_state |= ASC_INIT_STATE_END_SET_CFG;
+
+	switch (warn_code) {
+	case 0:	/* No error. */
+		break;
+	case ASC_WARN_IO_PORT_ROTATE:
+		ASC_PRINT1("AscInitSetConfig: board %d: I/O port address "
+			   "modified\n", boardp->id);
+		break;
+	case ASC_WARN_AUTO_CONFIG:
+		ASC_PRINT1("AscInitSetConfig: board %d: I/O port increment "
+			   "switch enabled\n", boardp->id);
+		break;
+	case ASC_WARN_EEPROM_CHKSUM:
+		ASC_PRINT1("AscInitSetConfig: board %d: EEPROM checksum "
+			   "error\n", boardp->id);
+		break;
+	case ASC_WARN_IRQ_MODIFIED:
+		ASC_PRINT1("AscInitSetConfig: board %d: IRQ modified\n",
+			   boardp->id);
+		break;
+	case ASC_WARN_CMD_QNG_CONFLICT:
+		ASC_PRINT1("AscInitSetConfig: board %d: tag queuing w/o "
+			   "disconnects\n",
+		     boardp->id);
+		break;
+	default:
+		ASC_PRINT2("AscInitSetConfig: board %d: unknown warning: "
+			   "0x%x\n", boardp->id, warn_code);
+		break;
+	}
+
+	if (asc_dvc->err_code != 0) {
+		ASC_PRINT3("AscInitSetConfig: board %d error: init_state 0x%x, "
+			   "err_code 0x%x\n", boardp->id, asc_dvc->init_state,
+			   asc_dvc->err_code);
+	}
+
+	return asc_dvc->err_code;
+}
+
+/*
+ * EEPROM Configuration.
+ *
+ * All drivers should use this structure to set the default EEPROM
+ * configuration. The BIOS now uses this structure when it is built.
+ * Additional structure information can be found in a_condor.h where
+ * the structure is defined.
+ *
+ * The *_Field_IsChar structs are needed to correct for endianness.
+ * These values are read from the board 16 bits at a time directly
+ * into the structs. Because some fields are char, the values will be
+ * in the wrong order. The *_Field_IsChar tells when to flip the
+ * bytes. Data read and written to PCI memory is automatically swapped
+ * on big-endian platforms so char fields read as words are actually being
+ * unswapped on big-endian platforms.
+ */
+static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __devinitdata = {
+	ADV_EEPROM_BIOS_ENABLE,	/* cfg_lsw */
+	0x0000,			/* cfg_msw */
+	0xFFFF,			/* disc_enable */
+	0xFFFF,			/* wdtr_able */
+	0xFFFF,			/* sdtr_able */
+	0xFFFF,			/* start_motor */
+	0xFFFF,			/* tagqng_able */
+	0xFFFF,			/* bios_scan */
+	0,			/* scam_tolerant */
+	7,			/* adapter_scsi_id */
+	0,			/* bios_boot_delay */
+	3,			/* scsi_reset_delay */
+	0,			/* bios_id_lun */
+	0,			/* termination */
+	0,			/* reserved1 */
+	0xFFE7,			/* bios_ctrl */
+	0xFFFF,			/* ultra_able */
+	0,			/* reserved2 */
+	ASC_DEF_MAX_HOST_QNG,	/* max_host_qng */
+	ASC_DEF_MAX_DVC_QNG,	/* max_dvc_qng */
+	0,			/* dvc_cntl */
+	0,			/* bug_fix */
+	0,			/* serial_number_word1 */
+	0,			/* serial_number_word2 */
+	0,			/* serial_number_word3 */
+	0,			/* check_sum */
+	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+	,			/* oem_name[16] */
+	0,			/* dvc_err_code */
+	0,			/* adv_err_code */
+	0,			/* adv_err_addr */
+	0,			/* saved_dvc_err_code */
+	0,			/* saved_adv_err_code */
+	0,			/* saved_adv_err_addr */
+	0			/* num_of_err */
+};
+
+static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __devinitdata = {
+	0,			/* cfg_lsw */
+	0,			/* cfg_msw */
+	0,			/* -disc_enable */
+	0,			/* wdtr_able */
+	0,			/* sdtr_able */
+	0,			/* start_motor */
+	0,			/* tagqng_able */
+	0,			/* bios_scan */
+	0,			/* scam_tolerant */
+	1,			/* adapter_scsi_id */
+	1,			/* bios_boot_delay */
+	1,			/* scsi_reset_delay */
+	1,			/* bios_id_lun */
+	1,			/* termination */
+	1,			/* reserved1 */
+	0,			/* bios_ctrl */
+	0,			/* ultra_able */
+	0,			/* reserved2 */
+	1,			/* max_host_qng */
+	1,			/* max_dvc_qng */
+	0,			/* dvc_cntl */
+	0,			/* bug_fix */
+	0,			/* serial_number_word1 */
+	0,			/* serial_number_word2 */
+	0,			/* serial_number_word3 */
+	0,			/* check_sum */
+	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
+	,			/* oem_name[16] */
+	0,			/* dvc_err_code */
+	0,			/* adv_err_code */
+	0,			/* adv_err_addr */
+	0,			/* saved_dvc_err_code */
+	0,			/* saved_adv_err_code */
+	0,			/* saved_adv_err_addr */
+	0			/* num_of_err */
+};
+
+static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __devinitdata = {
+	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
+	0x0000,			/* 01 cfg_msw */
+	0xFFFF,			/* 02 disc_enable */
+	0xFFFF,			/* 03 wdtr_able */
+	0x4444,			/* 04 sdtr_speed1 */
+	0xFFFF,			/* 05 start_motor */
+	0xFFFF,			/* 06 tagqng_able */
+	0xFFFF,			/* 07 bios_scan */
+	0,			/* 08 scam_tolerant */
+	7,			/* 09 adapter_scsi_id */
+	0,			/*    bios_boot_delay */
+	3,			/* 10 scsi_reset_delay */
+	0,			/*    bios_id_lun */
+	0,			/* 11 termination_se */
+	0,			/*    termination_lvd */
+	0xFFE7,			/* 12 bios_ctrl */
+	0x4444,			/* 13 sdtr_speed2 */
+	0x4444,			/* 14 sdtr_speed3 */
+	ASC_DEF_MAX_HOST_QNG,	/* 15 max_host_qng */
+	ASC_DEF_MAX_DVC_QNG,	/*    max_dvc_qng */
+	0,			/* 16 dvc_cntl */
+	0x4444,			/* 17 sdtr_speed4 */
+	0,			/* 18 serial_number_word1 */
+	0,			/* 19 serial_number_word2 */
+	0,			/* 20 serial_number_word3 */
+	0,			/* 21 check_sum */
+	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+	,			/* 22-29 oem_name[16] */
+	0,			/* 30 dvc_err_code */
+	0,			/* 31 adv_err_code */
+	0,			/* 32 adv_err_addr */
+	0,			/* 33 saved_dvc_err_code */
+	0,			/* 34 saved_adv_err_code */
+	0,			/* 35 saved_adv_err_addr */
+	0,			/* 36 reserved */
+	0,			/* 37 reserved */
+	0,			/* 38 reserved */
+	0,			/* 39 reserved */
+	0,			/* 40 reserved */
+	0,			/* 41 reserved */
+	0,			/* 42 reserved */
+	0,			/* 43 reserved */
+	0,			/* 44 reserved */
+	0,			/* 45 reserved */
+	0,			/* 46 reserved */
+	0,			/* 47 reserved */
+	0,			/* 48 reserved */
+	0,			/* 49 reserved */
+	0,			/* 50 reserved */
+	0,			/* 51 reserved */
+	0,			/* 52 reserved */
+	0,			/* 53 reserved */
+	0,			/* 54 reserved */
+	0,			/* 55 reserved */
+	0,			/* 56 cisptr_lsw */
+	0,			/* 57 cisprt_msw */
+	PCI_VENDOR_ID_ASP,	/* 58 subsysvid */
+	PCI_DEVICE_ID_38C0800_REV1,	/* 59 subsysid */
+	0,			/* 60 reserved */
+	0,			/* 61 reserved */
+	0,			/* 62 reserved */
+	0			/* 63 reserved */
+};
+
+static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __devinitdata = {
+	0,			/* 00 cfg_lsw */
+	0,			/* 01 cfg_msw */
+	0,			/* 02 disc_enable */
+	0,			/* 03 wdtr_able */
+	0,			/* 04 sdtr_speed1 */
+	0,			/* 05 start_motor */
+	0,			/* 06 tagqng_able */
+	0,			/* 07 bios_scan */
+	0,			/* 08 scam_tolerant */
+	1,			/* 09 adapter_scsi_id */
+	1,			/*    bios_boot_delay */
+	1,			/* 10 scsi_reset_delay */
+	1,			/*    bios_id_lun */
+	1,			/* 11 termination_se */
+	1,			/*    termination_lvd */
+	0,			/* 12 bios_ctrl */
+	0,			/* 13 sdtr_speed2 */
+	0,			/* 14 sdtr_speed3 */
+	1,			/* 15 max_host_qng */
+	1,			/*    max_dvc_qng */
+	0,			/* 16 dvc_cntl */
+	0,			/* 17 sdtr_speed4 */
+	0,			/* 18 serial_number_word1 */
+	0,			/* 19 serial_number_word2 */
+	0,			/* 20 serial_number_word3 */
+	0,			/* 21 check_sum */
+	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
+	,			/* 22-29 oem_name[16] */
+	0,			/* 30 dvc_err_code */
+	0,			/* 31 adv_err_code */
+	0,			/* 32 adv_err_addr */
+	0,			/* 33 saved_dvc_err_code */
+	0,			/* 34 saved_adv_err_code */
+	0,			/* 35 saved_adv_err_addr */
+	0,			/* 36 reserved */
+	0,			/* 37 reserved */
+	0,			/* 38 reserved */
+	0,			/* 39 reserved */
+	0,			/* 40 reserved */
+	0,			/* 41 reserved */
+	0,			/* 42 reserved */
+	0,			/* 43 reserved */
+	0,			/* 44 reserved */
+	0,			/* 45 reserved */
+	0,			/* 46 reserved */
+	0,			/* 47 reserved */
+	0,			/* 48 reserved */
+	0,			/* 49 reserved */
+	0,			/* 50 reserved */
+	0,			/* 51 reserved */
+	0,			/* 52 reserved */
+	0,			/* 53 reserved */
+	0,			/* 54 reserved */
+	0,			/* 55 reserved */
+	0,			/* 56 cisptr_lsw */
+	0,			/* 57 cisprt_msw */
+	0,			/* 58 subsysvid */
+	0,			/* 59 subsysid */
+	0,			/* 60 reserved */
+	0,			/* 61 reserved */
+	0,			/* 62 reserved */
+	0			/* 63 reserved */
+};
+
+static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __devinitdata = {
+	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
+	0x0000,			/* 01 cfg_msw */
+	0xFFFF,			/* 02 disc_enable */
+	0xFFFF,			/* 03 wdtr_able */
+	0x5555,			/* 04 sdtr_speed1 */
+	0xFFFF,			/* 05 start_motor */
+	0xFFFF,			/* 06 tagqng_able */
+	0xFFFF,			/* 07 bios_scan */
+	0,			/* 08 scam_tolerant */
+	7,			/* 09 adapter_scsi_id */
+	0,			/*    bios_boot_delay */
+	3,			/* 10 scsi_reset_delay */
+	0,			/*    bios_id_lun */
+	0,			/* 11 termination_se */
+	0,			/*    termination_lvd */
+	0xFFE7,			/* 12 bios_ctrl */
+	0x5555,			/* 13 sdtr_speed2 */
+	0x5555,			/* 14 sdtr_speed3 */
+	ASC_DEF_MAX_HOST_QNG,	/* 15 max_host_qng */
+	ASC_DEF_MAX_DVC_QNG,	/*    max_dvc_qng */
+	0,			/* 16 dvc_cntl */
+	0x5555,			/* 17 sdtr_speed4 */
+	0,			/* 18 serial_number_word1 */
+	0,			/* 19 serial_number_word2 */
+	0,			/* 20 serial_number_word3 */
+	0,			/* 21 check_sum */
+	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+	,			/* 22-29 oem_name[16] */
+	0,			/* 30 dvc_err_code */
+	0,			/* 31 adv_err_code */
+	0,			/* 32 adv_err_addr */
+	0,			/* 33 saved_dvc_err_code */
+	0,			/* 34 saved_adv_err_code */
+	0,			/* 35 saved_adv_err_addr */
+	0,			/* 36 reserved */
+	0,			/* 37 reserved */
+	0,			/* 38 reserved */
+	0,			/* 39 reserved */
+	0,			/* 40 reserved */
+	0,			/* 41 reserved */
+	0,			/* 42 reserved */
+	0,			/* 43 reserved */
+	0,			/* 44 reserved */
+	0,			/* 45 reserved */
+	0,			/* 46 reserved */
+	0,			/* 47 reserved */
+	0,			/* 48 reserved */
+	0,			/* 49 reserved */
+	0,			/* 50 reserved */
+	0,			/* 51 reserved */
+	0,			/* 52 reserved */
+	0,			/* 53 reserved */
+	0,			/* 54 reserved */
+	0,			/* 55 reserved */
+	0,			/* 56 cisptr_lsw */
+	0,			/* 57 cisprt_msw */
+	PCI_VENDOR_ID_ASP,	/* 58 subsysvid */
+	PCI_DEVICE_ID_38C1600_REV1,	/* 59 subsysid */
+	0,			/* 60 reserved */
+	0,			/* 61 reserved */
+	0,			/* 62 reserved */
+	0			/* 63 reserved */
+};
+
+static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __devinitdata = {
+	0,			/* 00 cfg_lsw */
+	0,			/* 01 cfg_msw */
+	0,			/* 02 disc_enable */
+	0,			/* 03 wdtr_able */
+	0,			/* 04 sdtr_speed1 */
+	0,			/* 05 start_motor */
+	0,			/* 06 tagqng_able */
+	0,			/* 07 bios_scan */
+	0,			/* 08 scam_tolerant */
+	1,			/* 09 adapter_scsi_id */
+	1,			/*    bios_boot_delay */
+	1,			/* 10 scsi_reset_delay */
+	1,			/*    bios_id_lun */
+	1,			/* 11 termination_se */
+	1,			/*    termination_lvd */
+	0,			/* 12 bios_ctrl */
+	0,			/* 13 sdtr_speed2 */
+	0,			/* 14 sdtr_speed3 */
+	1,			/* 15 max_host_qng */
+	1,			/*    max_dvc_qng */
+	0,			/* 16 dvc_cntl */
+	0,			/* 17 sdtr_speed4 */
+	0,			/* 18 serial_number_word1 */
+	0,			/* 19 serial_number_word2 */
+	0,			/* 20 serial_number_word3 */
+	0,			/* 21 check_sum */
+	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
+	,			/* 22-29 oem_name[16] */
+	0,			/* 30 dvc_err_code */
+	0,			/* 31 adv_err_code */
+	0,			/* 32 adv_err_addr */
+	0,			/* 33 saved_dvc_err_code */
+	0,			/* 34 saved_adv_err_code */
+	0,			/* 35 saved_adv_err_addr */
+	0,			/* 36 reserved */
+	0,			/* 37 reserved */
+	0,			/* 38 reserved */
+	0,			/* 39 reserved */
+	0,			/* 40 reserved */
+	0,			/* 41 reserved */
+	0,			/* 42 reserved */
+	0,			/* 43 reserved */
+	0,			/* 44 reserved */
+	0,			/* 45 reserved */
+	0,			/* 46 reserved */
+	0,			/* 47 reserved */
+	0,			/* 48 reserved */
+	0,			/* 49 reserved */
+	0,			/* 50 reserved */
+	0,			/* 51 reserved */
+	0,			/* 52 reserved */
+	0,			/* 53 reserved */
+	0,			/* 54 reserved */
+	0,			/* 55 reserved */
+	0,			/* 56 cisptr_lsw */
+	0,			/* 57 cisprt_msw */
+	0,			/* 58 subsysvid */
+	0,			/* 59 subsysid */
+	0,			/* 60 reserved */
+	0,			/* 61 reserved */
+	0,			/* 62 reserved */
+	0			/* 63 reserved */
+};
+
+#ifdef CONFIG_PCI
+/*
+ * Wait for EEPROM command to complete
+ */
+static void __devinit AdvWaitEEPCmd(AdvPortAddr iop_base)
+{
+	int eep_delay_ms;
+
+	for (eep_delay_ms = 0; eep_delay_ms < ADV_EEP_DELAY_MS; eep_delay_ms++) {
+		if (AdvReadWordRegister(iop_base, IOPW_EE_CMD) &
+		    ASC_EEP_CMD_DONE) {
+			break;
+		}
+		mdelay(1);
+	}
+	if ((AdvReadWordRegister(iop_base, IOPW_EE_CMD) & ASC_EEP_CMD_DONE) ==
+	    0)
+		BUG();
+}
+
+/*
+ * Read the EEPROM from specified location
+ */
+static ushort __devinit AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
+{
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
+			     ASC_EEP_CMD_READ | eep_word_addr);
+	AdvWaitEEPCmd(iop_base);
+	return AdvReadWordRegister(iop_base, IOPW_EE_DATA);
+}
+
+/*
+ * Write the EEPROM from 'cfg_buf'.
+ */
+void __devinit
+AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
+{
+	ushort *wbuf;
+	ushort addr, chksum;
+	ushort *charfields;
+
+	wbuf = (ushort *)cfg_buf;
+	charfields = (ushort *)&ADVEEP_3550_Config_Field_IsChar;
+	chksum = 0;
+
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_ABLE);
+	AdvWaitEEPCmd(iop_base);
+
+	/*
+	 * Write EEPROM from word 0 to word 20.
+	 */
+	for (addr = ADV_EEP_DVC_CFG_BEGIN;
+	     addr < ADV_EEP_DVC_CFG_END; addr++, wbuf++) {
+		ushort word;
+
+		if (*charfields++) {
+			word = cpu_to_le16(*wbuf);
+		} else {
+			word = *wbuf;
+		}
+		chksum += *wbuf;	/* Checksum is calculated from word values. */
+		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
+		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
+				     ASC_EEP_CMD_WRITE | addr);
+		AdvWaitEEPCmd(iop_base);
+		mdelay(ADV_EEP_DELAY_MS);
+	}
+
+	/*
+	 * Write EEPROM checksum at word 21.
+	 */
+	AdvWriteWordRegister(iop_base, IOPW_EE_DATA, chksum);
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE | addr);
+	AdvWaitEEPCmd(iop_base);
+	wbuf++;
+	charfields++;
+
+	/*
+	 * Write EEPROM OEM name at words 22 to 29.
+	 */
+	for (addr = ADV_EEP_DVC_CTL_BEGIN;
+	     addr < ADV_EEP_MAX_WORD_ADDR; addr++, wbuf++) {
+		ushort word;
+
+		if (*charfields++) {
+			word = cpu_to_le16(*wbuf);
+		} else {
+			word = *wbuf;
+		}
+		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
+		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
+				     ASC_EEP_CMD_WRITE | addr);
+		AdvWaitEEPCmd(iop_base);
+	}
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_DISABLE);
+	AdvWaitEEPCmd(iop_base);
+}
+
+/*
+ * Write the EEPROM from 'cfg_buf'.
+ */
+void __devinit
+AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
+{
+	ushort *wbuf;
+	ushort *charfields;
+	ushort addr, chksum;
+
+	wbuf = (ushort *)cfg_buf;
+	charfields = (ushort *)&ADVEEP_38C0800_Config_Field_IsChar;
+	chksum = 0;
+
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_ABLE);
+	AdvWaitEEPCmd(iop_base);
+
+	/*
+	 * Write EEPROM from word 0 to word 20.
+	 */
+	for (addr = ADV_EEP_DVC_CFG_BEGIN;
+	     addr < ADV_EEP_DVC_CFG_END; addr++, wbuf++) {
+		ushort word;
+
+		if (*charfields++) {
+			word = cpu_to_le16(*wbuf);
+		} else {
+			word = *wbuf;
+		}
+		chksum += *wbuf;	/* Checksum is calculated from word values. */
+		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
+		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
+				     ASC_EEP_CMD_WRITE | addr);
+		AdvWaitEEPCmd(iop_base);
+		mdelay(ADV_EEP_DELAY_MS);
+	}
+
+	/*
+	 * Write EEPROM checksum at word 21.
+	 */
+	AdvWriteWordRegister(iop_base, IOPW_EE_DATA, chksum);
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE | addr);
+	AdvWaitEEPCmd(iop_base);
+	wbuf++;
+	charfields++;
+
+	/*
+	 * Write EEPROM OEM name at words 22 to 29.
+	 */
+	for (addr = ADV_EEP_DVC_CTL_BEGIN;
+	     addr < ADV_EEP_MAX_WORD_ADDR; addr++, wbuf++) {
+		ushort word;
+
+		if (*charfields++) {
+			word = cpu_to_le16(*wbuf);
+		} else {
+			word = *wbuf;
+		}
+		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
+		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
+				     ASC_EEP_CMD_WRITE | addr);
+		AdvWaitEEPCmd(iop_base);
+	}
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_DISABLE);
+	AdvWaitEEPCmd(iop_base);
+}
+
+/*
+ * Write the EEPROM from 'cfg_buf'.
+ */
+void __devinit
+AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
+{
+	ushort *wbuf;
+	ushort *charfields;
+	ushort addr, chksum;
+
+	wbuf = (ushort *)cfg_buf;
+	charfields = (ushort *)&ADVEEP_38C1600_Config_Field_IsChar;
+	chksum = 0;
+
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_ABLE);
+	AdvWaitEEPCmd(iop_base);
+
+	/*
+	 * Write EEPROM from word 0 to word 20.
+	 */
+	for (addr = ADV_EEP_DVC_CFG_BEGIN;
+	     addr < ADV_EEP_DVC_CFG_END; addr++, wbuf++) {
+		ushort word;
+
+		if (*charfields++) {
+			word = cpu_to_le16(*wbuf);
+		} else {
+			word = *wbuf;
+		}
+		chksum += *wbuf;	/* Checksum is calculated from word values. */
+		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
+		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
+				     ASC_EEP_CMD_WRITE | addr);
+		AdvWaitEEPCmd(iop_base);
+		mdelay(ADV_EEP_DELAY_MS);
+	}
+
+	/*
+	 * Write EEPROM checksum at word 21.
+	 */
+	AdvWriteWordRegister(iop_base, IOPW_EE_DATA, chksum);
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE | addr);
+	AdvWaitEEPCmd(iop_base);
+	wbuf++;
+	charfields++;
+
+	/*
+	 * Write EEPROM OEM name at words 22 to 29.
+	 */
+	for (addr = ADV_EEP_DVC_CTL_BEGIN;
+	     addr < ADV_EEP_MAX_WORD_ADDR; addr++, wbuf++) {
+		ushort word;
+
+		if (*charfields++) {
+			word = cpu_to_le16(*wbuf);
+		} else {
+			word = *wbuf;
+		}
+		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
+		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
+				     ASC_EEP_CMD_WRITE | addr);
+		AdvWaitEEPCmd(iop_base);
+	}
+	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_DISABLE);
+	AdvWaitEEPCmd(iop_base);
+}
+
+/*
+ * Read EEPROM configuration into the specified buffer.
+ *
+ * Return a checksum based on the EEPROM configuration read.
+ */
+static ushort __devinit
+AdvGet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
+{
+	ushort wval, chksum;
+	ushort *wbuf;
+	int eep_addr;
+	ushort *charfields;
+
+	charfields = (ushort *)&ADVEEP_3550_Config_Field_IsChar;
+	wbuf = (ushort *)cfg_buf;
+	chksum = 0;
+
+	for (eep_addr = ADV_EEP_DVC_CFG_BEGIN;
+	     eep_addr < ADV_EEP_DVC_CFG_END; eep_addr++, wbuf++) {
+		wval = AdvReadEEPWord(iop_base, eep_addr);
+		chksum += wval;	/* Checksum is calculated from word values. */
+		if (*charfields++) {
+			*wbuf = le16_to_cpu(wval);
+		} else {
+			*wbuf = wval;
+		}
+	}
+	/* Read checksum word. */
+	*wbuf = AdvReadEEPWord(iop_base, eep_addr);
+	wbuf++;
+	charfields++;
+
+	/* Read rest of EEPROM not covered by the checksum. */
+	for (eep_addr = ADV_EEP_DVC_CTL_BEGIN;
+	     eep_addr < ADV_EEP_MAX_WORD_ADDR; eep_addr++, wbuf++) {
+		*wbuf = AdvReadEEPWord(iop_base, eep_addr);
+		if (*charfields++) {
+			*wbuf = le16_to_cpu(*wbuf);
+		}
+	}
+	return chksum;
+}
+
+/*
+ * Read EEPROM configuration into the specified buffer.
+ *
+ * Return a checksum based on the EEPROM configuration read.
+ */
+static ushort __devinit
+AdvGet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
+{
+	ushort wval, chksum;
+	ushort *wbuf;
+	int eep_addr;
+	ushort *charfields;
+
+	charfields = (ushort *)&ADVEEP_38C0800_Config_Field_IsChar;
+	wbuf = (ushort *)cfg_buf;
+	chksum = 0;
+
+	for (eep_addr = ADV_EEP_DVC_CFG_BEGIN;
+	     eep_addr < ADV_EEP_DVC_CFG_END; eep_addr++, wbuf++) {
+		wval = AdvReadEEPWord(iop_base, eep_addr);
+		chksum += wval;	/* Checksum is calculated from word values. */
+		if (*charfields++) {
+			*wbuf = le16_to_cpu(wval);
+		} else {
+			*wbuf = wval;
+		}
+	}
+	/* Read checksum word. */
+	*wbuf = AdvReadEEPWord(iop_base, eep_addr);
+	wbuf++;
+	charfields++;
+
+	/* Read rest of EEPROM not covered by the checksum. */
+	for (eep_addr = ADV_EEP_DVC_CTL_BEGIN;
+	     eep_addr < ADV_EEP_MAX_WORD_ADDR; eep_addr++, wbuf++) {
+		*wbuf = AdvReadEEPWord(iop_base, eep_addr);
+		if (*charfields++) {
+			*wbuf = le16_to_cpu(*wbuf);
+		}
+	}
+	return chksum;
+}
+
+/*
+ * Read EEPROM configuration into the specified buffer.
+ *
+ * Return a checksum based on the EEPROM configuration read.
+ */
+static ushort __devinit
+AdvGet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
+{
+	ushort wval, chksum;
+	ushort *wbuf;
+	int eep_addr;
+	ushort *charfields;
+
+	charfields = (ushort *)&ADVEEP_38C1600_Config_Field_IsChar;
+	wbuf = (ushort *)cfg_buf;
+	chksum = 0;
+
+	for (eep_addr = ADV_EEP_DVC_CFG_BEGIN;
+	     eep_addr < ADV_EEP_DVC_CFG_END; eep_addr++, wbuf++) {
+		wval = AdvReadEEPWord(iop_base, eep_addr);
+		chksum += wval;	/* Checksum is calculated from word values. */
+		if (*charfields++) {
+			*wbuf = le16_to_cpu(wval);
+		} else {
+			*wbuf = wval;
+		}
+	}
+	/* Read checksum word. */
+	*wbuf = AdvReadEEPWord(iop_base, eep_addr);
+	wbuf++;
+	charfields++;
+
+	/* Read rest of EEPROM not covered by the checksum. */
+	for (eep_addr = ADV_EEP_DVC_CTL_BEGIN;
+	     eep_addr < ADV_EEP_MAX_WORD_ADDR; eep_addr++, wbuf++) {
+		*wbuf = AdvReadEEPWord(iop_base, eep_addr);
+		if (*charfields++) {
+			*wbuf = le16_to_cpu(*wbuf);
+		}
+	}
+	return chksum;
+}
+
+/*
  * Read the board's EEPROM configuration. Set fields in ADV_DVC_VAR and
  * ADV_DVC_CFG based on the EEPROM settings. The chip is stopped while
  * all of this is done.
@@ -13234,834 +13757,124 @@ static int __devinit AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
 }
 
 /*
- * Read EEPROM configuration into the specified buffer.
- *
- * Return a checksum based on the EEPROM configuration read.
- */
-static ushort __devinit
-AdvGet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
-{
-	ushort wval, chksum;
-	ushort *wbuf;
-	int eep_addr;
-	ushort *charfields;
-
-	charfields = (ushort *)&ADVEEP_3550_Config_Field_IsChar;
-	wbuf = (ushort *)cfg_buf;
-	chksum = 0;
-
-	for (eep_addr = ADV_EEP_DVC_CFG_BEGIN;
-	     eep_addr < ADV_EEP_DVC_CFG_END; eep_addr++, wbuf++) {
-		wval = AdvReadEEPWord(iop_base, eep_addr);
-		chksum += wval;	/* Checksum is calculated from word values. */
-		if (*charfields++) {
-			*wbuf = le16_to_cpu(wval);
-		} else {
-			*wbuf = wval;
-		}
-	}
-	/* Read checksum word. */
-	*wbuf = AdvReadEEPWord(iop_base, eep_addr);
-	wbuf++;
-	charfields++;
-
-	/* Read rest of EEPROM not covered by the checksum. */
-	for (eep_addr = ADV_EEP_DVC_CTL_BEGIN;
-	     eep_addr < ADV_EEP_MAX_WORD_ADDR; eep_addr++, wbuf++) {
-		*wbuf = AdvReadEEPWord(iop_base, eep_addr);
-		if (*charfields++) {
-			*wbuf = le16_to_cpu(*wbuf);
-		}
-	}
-	return chksum;
-}
-
-/*
- * Read EEPROM configuration into the specified buffer.
+ * Initialize the ADV_DVC_VAR structure.
  *
- * Return a checksum based on the EEPROM configuration read.
- */
-static ushort __devinit
-AdvGet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
-{
-	ushort wval, chksum;
-	ushort *wbuf;
-	int eep_addr;
-	ushort *charfields;
-
-	charfields = (ushort *)&ADVEEP_38C0800_Config_Field_IsChar;
-	wbuf = (ushort *)cfg_buf;
-	chksum = 0;
-
-	for (eep_addr = ADV_EEP_DVC_CFG_BEGIN;
-	     eep_addr < ADV_EEP_DVC_CFG_END; eep_addr++, wbuf++) {
-		wval = AdvReadEEPWord(iop_base, eep_addr);
-		chksum += wval;	/* Checksum is calculated from word values. */
-		if (*charfields++) {
-			*wbuf = le16_to_cpu(wval);
-		} else {
-			*wbuf = wval;
-		}
-	}
-	/* Read checksum word. */
-	*wbuf = AdvReadEEPWord(iop_base, eep_addr);
-	wbuf++;
-	charfields++;
-
-	/* Read rest of EEPROM not covered by the checksum. */
-	for (eep_addr = ADV_EEP_DVC_CTL_BEGIN;
-	     eep_addr < ADV_EEP_MAX_WORD_ADDR; eep_addr++, wbuf++) {
-		*wbuf = AdvReadEEPWord(iop_base, eep_addr);
-		if (*charfields++) {
-			*wbuf = le16_to_cpu(*wbuf);
-		}
-	}
-	return chksum;
-}
-
-/*
- * Read EEPROM configuration into the specified buffer.
+ * On failure set the ADV_DVC_VAR field 'err_code' and return ADV_ERROR.
  *
- * Return a checksum based on the EEPROM configuration read.
- */
-static ushort __devinit
-AdvGet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
-{
-	ushort wval, chksum;
-	ushort *wbuf;
-	int eep_addr;
-	ushort *charfields;
-
-	charfields = (ushort *)&ADVEEP_38C1600_Config_Field_IsChar;
-	wbuf = (ushort *)cfg_buf;
-	chksum = 0;
-
-	for (eep_addr = ADV_EEP_DVC_CFG_BEGIN;
-	     eep_addr < ADV_EEP_DVC_CFG_END; eep_addr++, wbuf++) {
-		wval = AdvReadEEPWord(iop_base, eep_addr);
-		chksum += wval;	/* Checksum is calculated from word values. */
-		if (*charfields++) {
-			*wbuf = le16_to_cpu(wval);
-		} else {
-			*wbuf = wval;
-		}
-	}
-	/* Read checksum word. */
-	*wbuf = AdvReadEEPWord(iop_base, eep_addr);
-	wbuf++;
-	charfields++;
-
-	/* Read rest of EEPROM not covered by the checksum. */
-	for (eep_addr = ADV_EEP_DVC_CTL_BEGIN;
-	     eep_addr < ADV_EEP_MAX_WORD_ADDR; eep_addr++, wbuf++) {
-		*wbuf = AdvReadEEPWord(iop_base, eep_addr);
-		if (*charfields++) {
-			*wbuf = le16_to_cpu(*wbuf);
-		}
-	}
-	return chksum;
-}
-
-/*
- * Read the EEPROM from specified location
- */
-static ushort __devinit AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
-{
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
-			     ASC_EEP_CMD_READ | eep_word_addr);
-	AdvWaitEEPCmd(iop_base);
-	return AdvReadWordRegister(iop_base, IOPW_EE_DATA);
-}
-
-/*
- * Wait for EEPROM command to complete
- */
-static void __devinit AdvWaitEEPCmd(AdvPortAddr iop_base)
-{
-	int eep_delay_ms;
-
-	for (eep_delay_ms = 0; eep_delay_ms < ADV_EEP_DELAY_MS; eep_delay_ms++) {
-		if (AdvReadWordRegister(iop_base, IOPW_EE_CMD) &
-		    ASC_EEP_CMD_DONE) {
-			break;
-		}
-		mdelay(1);
-	}
-	if ((AdvReadWordRegister(iop_base, IOPW_EE_CMD) & ASC_EEP_CMD_DONE) ==
-	    0)
-		BUG();
-	return;
-}
-
-/*
- * Write the EEPROM from 'cfg_buf'.
- */
-void __devinit
-AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
-{
-	ushort *wbuf;
-	ushort addr, chksum;
-	ushort *charfields;
-
-	wbuf = (ushort *)cfg_buf;
-	charfields = (ushort *)&ADVEEP_3550_Config_Field_IsChar;
-	chksum = 0;
-
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_ABLE);
-	AdvWaitEEPCmd(iop_base);
-
-	/*
-	 * Write EEPROM from word 0 to word 20.
-	 */
-	for (addr = ADV_EEP_DVC_CFG_BEGIN;
-	     addr < ADV_EEP_DVC_CFG_END; addr++, wbuf++) {
-		ushort word;
-
-		if (*charfields++) {
-			word = cpu_to_le16(*wbuf);
-		} else {
-			word = *wbuf;
-		}
-		chksum += *wbuf;	/* Checksum is calculated from word values. */
-		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
-		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
-				     ASC_EEP_CMD_WRITE | addr);
-		AdvWaitEEPCmd(iop_base);
-		mdelay(ADV_EEP_DELAY_MS);
-	}
-
-	/*
-	 * Write EEPROM checksum at word 21.
-	 */
-	AdvWriteWordRegister(iop_base, IOPW_EE_DATA, chksum);
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE | addr);
-	AdvWaitEEPCmd(iop_base);
-	wbuf++;
-	charfields++;
-
-	/*
-	 * Write EEPROM OEM name at words 22 to 29.
-	 */
-	for (addr = ADV_EEP_DVC_CTL_BEGIN;
-	     addr < ADV_EEP_MAX_WORD_ADDR; addr++, wbuf++) {
-		ushort word;
-
-		if (*charfields++) {
-			word = cpu_to_le16(*wbuf);
-		} else {
-			word = *wbuf;
-		}
-		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
-		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
-				     ASC_EEP_CMD_WRITE | addr);
-		AdvWaitEEPCmd(iop_base);
-	}
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_DISABLE);
-	AdvWaitEEPCmd(iop_base);
-	return;
-}
-
-/*
- * Write the EEPROM from 'cfg_buf'.
- */
-void __devinit
-AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
-{
-	ushort *wbuf;
-	ushort *charfields;
-	ushort addr, chksum;
-
-	wbuf = (ushort *)cfg_buf;
-	charfields = (ushort *)&ADVEEP_38C0800_Config_Field_IsChar;
-	chksum = 0;
-
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_ABLE);
-	AdvWaitEEPCmd(iop_base);
-
-	/*
-	 * Write EEPROM from word 0 to word 20.
-	 */
-	for (addr = ADV_EEP_DVC_CFG_BEGIN;
-	     addr < ADV_EEP_DVC_CFG_END; addr++, wbuf++) {
-		ushort word;
-
-		if (*charfields++) {
-			word = cpu_to_le16(*wbuf);
-		} else {
-			word = *wbuf;
-		}
-		chksum += *wbuf;	/* Checksum is calculated from word values. */
-		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
-		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
-				     ASC_EEP_CMD_WRITE | addr);
-		AdvWaitEEPCmd(iop_base);
-		mdelay(ADV_EEP_DELAY_MS);
-	}
-
-	/*
-	 * Write EEPROM checksum at word 21.
-	 */
-	AdvWriteWordRegister(iop_base, IOPW_EE_DATA, chksum);
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE | addr);
-	AdvWaitEEPCmd(iop_base);
-	wbuf++;
-	charfields++;
-
-	/*
-	 * Write EEPROM OEM name at words 22 to 29.
-	 */
-	for (addr = ADV_EEP_DVC_CTL_BEGIN;
-	     addr < ADV_EEP_MAX_WORD_ADDR; addr++, wbuf++) {
-		ushort word;
-
-		if (*charfields++) {
-			word = cpu_to_le16(*wbuf);
-		} else {
-			word = *wbuf;
-		}
-		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
-		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
-				     ASC_EEP_CMD_WRITE | addr);
-		AdvWaitEEPCmd(iop_base);
-	}
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_DISABLE);
-	AdvWaitEEPCmd(iop_base);
-	return;
-}
-
-/*
- * Write the EEPROM from 'cfg_buf'.
+ * For a non-fatal error return a warning code. If there are no warnings
+ * then 0 is returned.
  */
-void __devinit
-AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
+static int __devinit
+AdvInitGetConfig(struct pci_dev *pdev, asc_board_t *boardp)
 {
-	ushort *wbuf;
-	ushort *charfields;
-	ushort addr, chksum;
-
-	wbuf = (ushort *)cfg_buf;
-	charfields = (ushort *)&ADVEEP_38C1600_Config_Field_IsChar;
-	chksum = 0;
-
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_ABLE);
-	AdvWaitEEPCmd(iop_base);
-
-	/*
-	 * Write EEPROM from word 0 to word 20.
-	 */
-	for (addr = ADV_EEP_DVC_CFG_BEGIN;
-	     addr < ADV_EEP_DVC_CFG_END; addr++, wbuf++) {
-		ushort word;
+	ADV_DVC_VAR *asc_dvc = &boardp->dvc_var.adv_dvc_var;
+	unsigned short warn_code = 0;
+	AdvPortAddr iop_base = asc_dvc->iop_base;
+	u16 cmd;
+	int status;
 
-		if (*charfields++) {
-			word = cpu_to_le16(*wbuf);
-		} else {
-			word = *wbuf;
-		}
-		chksum += *wbuf;	/* Checksum is calculated from word values. */
-		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
-		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
-				     ASC_EEP_CMD_WRITE | addr);
-		AdvWaitEEPCmd(iop_base);
-		mdelay(ADV_EEP_DELAY_MS);
-	}
+	asc_dvc->err_code = 0;
 
 	/*
-	 * Write EEPROM checksum at word 21.
+	 * Save the state of the PCI Configuration Command Register
+	 * "Parity Error Response Control" Bit. If the bit is clear (0),
+	 * in AdvInitAsc3550/38C0800Driver() tell the microcode to ignore
+	 * DMA parity errors.
 	 */
-	AdvWriteWordRegister(iop_base, IOPW_EE_DATA, chksum);
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE | addr);
-	AdvWaitEEPCmd(iop_base);
-	wbuf++;
-	charfields++;
+	asc_dvc->cfg->control_flag = 0;
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	if ((cmd & PCI_COMMAND_PARITY) == 0)
+		asc_dvc->cfg->control_flag |= CONTROL_FLAG_IGNORE_PERR;
 
-	/*
-	 * Write EEPROM OEM name at words 22 to 29.
-	 */
-	for (addr = ADV_EEP_DVC_CTL_BEGIN;
-	     addr < ADV_EEP_MAX_WORD_ADDR; addr++, wbuf++) {
-		ushort word;
+	asc_dvc->cfg->lib_version = (ADV_LIB_VERSION_MAJOR << 8) |
+	    ADV_LIB_VERSION_MINOR;
+	asc_dvc->cfg->chip_version =
+	    AdvGetChipVersion(iop_base, asc_dvc->bus_type);
 
-		if (*charfields++) {
-			word = cpu_to_le16(*wbuf);
-		} else {
-			word = *wbuf;
-		}
-		AdvWriteWordRegister(iop_base, IOPW_EE_DATA, word);
-		AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
-				     ASC_EEP_CMD_WRITE | addr);
-		AdvWaitEEPCmd(iop_base);
-	}
-	AdvWriteWordRegister(iop_base, IOPW_EE_CMD, ASC_EEP_CMD_WRITE_DISABLE);
-	AdvWaitEEPCmd(iop_base);
-	return;
-}
+	ASC_DBG2(1, "AdvInitGetConfig: iopb_chip_id_1: 0x%x 0x%x\n",
+		 (ushort)AdvReadByteRegister(iop_base, IOPB_CHIP_ID_1),
+		 (ushort)ADV_CHIP_ID_BYTE);
 
-/*
- * AdvExeScsiQueue() - Send a request to the RISC microcode program.
- *
- *   Allocate a carrier structure, point the carrier to the ADV_SCSI_REQ_Q,
- *   add the carrier to the ICQ (Initiator Command Queue), and tickle the
- *   RISC to notify it a new command is ready to be executed.
- *
- * If 'done_status' is not set to QD_DO_RETRY, then 'error_retry' will be
- * set to SCSI_MAX_RETRY.
- *
- * Multi-byte fields in the ASC_SCSI_REQ_Q that are used by the microcode
- * for DMA addresses or math operations are byte swapped to little-endian
- * order.
- *
- * Return:
- *      ADV_SUCCESS(1) - The request was successfully queued.
- *      ADV_BUSY(0) -    Resource unavailable; Retry again after pending
- *                       request completes.
- *      ADV_ERROR(-1) -  Invalid ADV_SCSI_REQ_Q request structure
- *                       host IC error.
- */
-static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
-{
-	AdvPortAddr iop_base;
-	ADV_DCNT req_size;
-	ADV_PADDR req_paddr;
-	ADV_CARR_T *new_carrp;
+	ASC_DBG2(1, "AdvInitGetConfig: iopw_chip_id_0: 0x%x 0x%x\n",
+		 (ushort)AdvReadWordRegister(iop_base, IOPW_CHIP_ID_0),
+		 (ushort)ADV_CHIP_ID_WORD);
 
 	/*
-	 * The ADV_SCSI_REQ_Q 'target_id' field should never exceed ADV_MAX_TID.
+	 * Reset the chip to start and allow register writes.
 	 */
-	if (scsiq->target_id > ADV_MAX_TID) {
-		scsiq->host_status = QHSTA_M_INVALID_DEVICE;
-		scsiq->done_status = QD_WITH_ERROR;
+	if (AdvFindSignature(iop_base) == 0) {
+		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
 		return ADV_ERROR;
-	}
-
-	iop_base = asc_dvc->iop_base;
-
-	/*
-	 * Allocate a carrier ensuring at least one carrier always
-	 * remains on the freelist and initialize fields.
-	 */
-	if ((new_carrp = asc_dvc->carr_freelist) == NULL) {
-		return ADV_BUSY;
-	}
-	asc_dvc->carr_freelist = (ADV_CARR_T *)
-	    ADV_U32_TO_VADDR(le32_to_cpu(new_carrp->next_vpa));
-	asc_dvc->carr_pending_cnt++;
-
-	/*
-	 * Set the carrier to be a stopper by setting 'next_vpa'
-	 * to the stopper value. The current stopper will be changed
-	 * below to point to the new stopper.
-	 */
-	new_carrp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
-
-	/*
-	 * Clear the ADV_SCSI_REQ_Q done flag.
-	 */
-	scsiq->a_flag &= ~ADV_SCSIQ_DONE;
-
-	req_size = sizeof(ADV_SCSI_REQ_Q);
-	req_paddr = DvcGetPhyAddr(asc_dvc, scsiq, (uchar *)scsiq,
-				  (ADV_SDCNT *)&req_size, ADV_IS_SCSIQ_FLAG);
-
-	BUG_ON(req_paddr & 31);
-	BUG_ON(req_size < sizeof(ADV_SCSI_REQ_Q));
-
-	/* Wait for assertion before making little-endian */
-	req_paddr = cpu_to_le32(req_paddr);
-
-	/* Save virtual and physical address of ADV_SCSI_REQ_Q and carrier. */
-	scsiq->scsiq_ptr = cpu_to_le32(ADV_VADDR_TO_U32(scsiq));
-	scsiq->scsiq_rptr = req_paddr;
-
-	scsiq->carr_va = cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->icq_sp));
-	/*
-	 * Every ADV_CARR_T.carr_pa is byte swapped to little-endian
-	 * order during initialization.
-	 */
-	scsiq->carr_pa = asc_dvc->icq_sp->carr_pa;
-
-	/*
-	 * Use the current stopper to send the ADV_SCSI_REQ_Q command to
-	 * the microcode. The newly allocated stopper will become the new
-	 * stopper.
-	 */
-	asc_dvc->icq_sp->areq_vpa = req_paddr;
-
-	/*
-	 * Set the 'next_vpa' pointer for the old stopper to be the
-	 * physical address of the new stopper. The RISC can only
-	 * follow physical addresses.
-	 */
-	asc_dvc->icq_sp->next_vpa = new_carrp->carr_pa;
-
-	/*
-	 * Set the host adapter stopper pointer to point to the new carrier.
-	 */
-	asc_dvc->icq_sp = new_carrp;
-
-	if (asc_dvc->chip_type == ADV_CHIP_ASC3550 ||
-	    asc_dvc->chip_type == ADV_CHIP_ASC38C0800) {
+	} else {
 		/*
-		 * Tickle the RISC to tell it to read its Command Queue Head pointer.
+		 * The caller must set 'chip_type' to a valid setting.
 		 */
-		AdvWriteByteRegister(iop_base, IOPB_TICKLE, ADV_TICKLE_A);
-		if (asc_dvc->chip_type == ADV_CHIP_ASC3550) {
-			/*
-			 * Clear the tickle value. In the ASC-3550 the RISC flag
-			 * command 'clr_tickle_a' does not work unless the host
-			 * value is cleared.
-			 */
-			AdvWriteByteRegister(iop_base, IOPB_TICKLE,
-					     ADV_TICKLE_NOP);
+		if (asc_dvc->chip_type != ADV_CHIP_ASC3550 &&
+		    asc_dvc->chip_type != ADV_CHIP_ASC38C0800 &&
+		    asc_dvc->chip_type != ADV_CHIP_ASC38C1600) {
+			asc_dvc->err_code |= ASC_IERR_BAD_CHIPTYPE;
+			return ADV_ERROR;
 		}
-	} else if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
+
 		/*
-		 * Notify the RISC a carrier is ready by writing the physical
-		 * address of the new carrier stopper to the COMMA register.
+		 * Reset Chip.
 		 */
-		AdvWriteDWordRegister(iop_base, IOPDW_COMMA,
-				      le32_to_cpu(new_carrp->carr_pa));
-	}
-
-	return ADV_SUCCESS;
-}
-
-/*
- * Reset SCSI Bus and purge all outstanding requests.
- *
- * Return Value:
- *      ADV_TRUE(1) -   All requests are purged and SCSI Bus is reset.
- *      ADV_FALSE(0) -  Microcode command failed.
- *      ADV_ERROR(-1) - Microcode command timed-out. Microcode or IC
- *                      may be hung which requires driver recovery.
- */
-static int AdvResetSB(ADV_DVC_VAR *asc_dvc)
-{
-	int status;
-
-	/*
-	 * Send the SCSI Bus Reset idle start idle command which asserts
-	 * the SCSI Bus Reset signal.
-	 */
-	status = AdvSendIdleCmd(asc_dvc, (ushort)IDLE_CMD_SCSI_RESET_START, 0L);
-	if (status != ADV_TRUE) {
-		return status;
-	}
-
-	/*
-	 * Delay for the specified SCSI Bus Reset hold time.
-	 *
-	 * The hold time delay is done on the host because the RISC has no
-	 * microsecond accurate timer.
-	 */
-	udelay(ASC_SCSI_RESET_HOLD_TIME_US);
-
-	/*
-	 * Send the SCSI Bus Reset end idle command which de-asserts
-	 * the SCSI Bus Reset signal and purges any pending requests.
-	 */
-	status = AdvSendIdleCmd(asc_dvc, (ushort)IDLE_CMD_SCSI_RESET_END, 0L);
-	if (status != ADV_TRUE) {
-		return status;
-	}
-
-	mdelay(asc_dvc->scsi_reset_wait * 1000);	/* XXX: msleep? */
-
-	return status;
-}
-
-/*
- * Reset chip and SCSI Bus.
- *
- * Return Value:
- *      ADV_TRUE(1) -   Chip re-initialization and SCSI Bus Reset successful.
- *      ADV_FALSE(0) -  Chip re-initialization and SCSI Bus Reset failure.
- */
-static int AdvResetChipAndSB(ADV_DVC_VAR *asc_dvc)
-{
-	int status;
-	ushort wdtr_able, sdtr_able, tagqng_able;
-	ushort ppr_able = 0;
-	uchar tid, max_cmd[ADV_MAX_TID + 1];
-	AdvPortAddr iop_base;
-	ushort bios_sig;
-
-	iop_base = asc_dvc->iop_base;
-
-	/*
-	 * Save current per TID negotiated values.
-	 */
-	AdvReadWordLram(iop_base, ASC_MC_WDTR_ABLE, wdtr_able);
-	AdvReadWordLram(iop_base, ASC_MC_SDTR_ABLE, sdtr_able);
-	if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
-		AdvReadWordLram(iop_base, ASC_MC_PPR_ABLE, ppr_able);
-	}
-	AdvReadWordLram(iop_base, ASC_MC_TAGQNG_ABLE, tagqng_able);
-	for (tid = 0; tid <= ADV_MAX_TID; tid++) {
-		AdvReadByteLram(iop_base, ASC_MC_NUMBER_OF_MAX_CMD + tid,
-				max_cmd[tid]);
-	}
-
-	/*
-	 * Force the AdvInitAsc3550/38C0800Driver() function to
-	 * perform a SCSI Bus Reset by clearing the BIOS signature word.
-	 * The initialization functions assumes a SCSI Bus Reset is not
-	 * needed if the BIOS signature word is present.
-	 */
-	AdvReadWordLram(iop_base, ASC_MC_BIOS_SIGNATURE, bios_sig);
-	AdvWriteWordLram(iop_base, ASC_MC_BIOS_SIGNATURE, 0);
-
-	/*
-	 * Stop chip and reset it.
-	 */
-	AdvWriteWordRegister(iop_base, IOPW_RISC_CSR, ADV_RISC_CSR_STOP);
-	AdvWriteWordRegister(iop_base, IOPW_CTRL_REG, ADV_CTRL_REG_CMD_RESET);
-	mdelay(100);
-	AdvWriteWordRegister(iop_base, IOPW_CTRL_REG,
-			     ADV_CTRL_REG_CMD_WR_IO_REG);
-
-	/*
-	 * Reset Adv Library error code, if any, and try
-	 * re-initializing the chip.
-	 */
-	asc_dvc->err_code = 0;
-	if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
-		status = AdvInitAsc38C1600Driver(asc_dvc);
-	} else if (asc_dvc->chip_type == ADV_CHIP_ASC38C0800) {
-		status = AdvInitAsc38C0800Driver(asc_dvc);
-	} else {
-		status = AdvInitAsc3550Driver(asc_dvc);
-	}
-
-	/* Translate initialization return value to status value. */
-	if (status == 0) {
-		status = ADV_TRUE;
-	} else {
-		status = ADV_FALSE;
-	}
-
-	/*
-	 * Restore the BIOS signature word.
-	 */
-	AdvWriteWordLram(iop_base, ASC_MC_BIOS_SIGNATURE, bios_sig);
+		AdvWriteWordRegister(iop_base, IOPW_CTRL_REG,
+				     ADV_CTRL_REG_CMD_RESET);
+		mdelay(100);
+		AdvWriteWordRegister(iop_base, IOPW_CTRL_REG,
+				     ADV_CTRL_REG_CMD_WR_IO_REG);
 
-	/*
-	 * Restore per TID negotiated values.
-	 */
-	AdvWriteWordLram(iop_base, ASC_MC_WDTR_ABLE, wdtr_able);
-	AdvWriteWordLram(iop_base, ASC_MC_SDTR_ABLE, sdtr_able);
-	if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
-		AdvWriteWordLram(iop_base, ASC_MC_PPR_ABLE, ppr_able);
-	}
-	AdvWriteWordLram(iop_base, ASC_MC_TAGQNG_ABLE, tagqng_able);
-	for (tid = 0; tid <= ADV_MAX_TID; tid++) {
-		AdvWriteByteLram(iop_base, ASC_MC_NUMBER_OF_MAX_CMD + tid,
-				 max_cmd[tid]);
+		if (asc_dvc->chip_type == ADV_CHIP_ASC38C1600) {
+			status = AdvInitFrom38C1600EEP(asc_dvc);
+		} else if (asc_dvc->chip_type == ADV_CHIP_ASC38C0800) {
+			status = AdvInitFrom38C0800EEP(asc_dvc);
+		} else {
+			status = AdvInitFrom3550EEP(asc_dvc);
+		}
+		warn_code |= status;
 	}
 
-	return status;
-}
-
-/*
- * Adv Library Interrupt Service Routine
- *
- *  This function is called by a driver's interrupt service routine.
- *  The function disables and re-enables interrupts.
- *
- *  When a microcode idle command is completed, the ADV_DVC_VAR
- *  'idle_cmd_done' field is set to ADV_TRUE.
- *
- *  Note: AdvISR() can be called when interrupts are disabled or even
- *  when there is no hardware interrupt condition present. It will
- *  always check for completed idle commands and microcode requests.
- *  This is an important feature that shouldn't be changed because it
- *  allows commands to be completed from polling mode loops.
- *
- * Return:
- *   ADV_TRUE(1) - interrupt was pending
- *   ADV_FALSE(0) - no interrupt was pending
- */
-static int AdvISR(ADV_DVC_VAR *asc_dvc)
-{
-	AdvPortAddr iop_base;
-	uchar int_stat;
-	ushort target_bit;
-	ADV_CARR_T *free_carrp;
-	ADV_VADDR irq_next_vpa;
-	ADV_SCSI_REQ_Q *scsiq;
-
-	iop_base = asc_dvc->iop_base;
-
-	/* Reading the register clears the interrupt. */
-	int_stat = AdvReadByteRegister(iop_base, IOPB_INTR_STATUS_REG);
-
-	if ((int_stat & (ADV_INTR_STATUS_INTRA | ADV_INTR_STATUS_INTRB |
-			 ADV_INTR_STATUS_INTRC)) == 0) {
-		return ADV_FALSE;
+	if (warn_code != 0) {
+		ASC_PRINT2("AdvInitGetConfig: board %d: warning: 0x%x\n",
+			   boardp->id, warn_code);
 	}
 
-	/*
-	 * Notify the driver of an asynchronous microcode condition by
-	 * calling the adv_async_callback function. The function
-	 * is passed the microcode ASC_MC_INTRB_CODE byte value.
-	 */
-	if (int_stat & ADV_INTR_STATUS_INTRB) {
-		uchar intrb_code;
-
-		AdvReadByteLram(iop_base, ASC_MC_INTRB_CODE, intrb_code);
-
-		if (asc_dvc->chip_type == ADV_CHIP_ASC3550 ||
-		    asc_dvc->chip_type == ADV_CHIP_ASC38C0800) {
-			if (intrb_code == ADV_ASYNC_CARRIER_READY_FAILURE &&
-			    asc_dvc->carr_pending_cnt != 0) {
-				AdvWriteByteRegister(iop_base, IOPB_TICKLE,
-						     ADV_TICKLE_A);
-				if (asc_dvc->chip_type == ADV_CHIP_ASC3550) {
-					AdvWriteByteRegister(iop_base,
-							     IOPB_TICKLE,
-							     ADV_TICKLE_NOP);
-				}
-			}
-		}
-
-		adv_async_callback(asc_dvc, intrb_code);
+	if (asc_dvc->err_code) {
+		ASC_PRINT2("AdvInitGetConfig: board %d error: err_code 0x%x\n",
+		     boardp->id, asc_dvc->err_code);
 	}
 
-	/*
-	 * Check if the IRQ stopper carrier contains a completed request.
-	 */
-	while (((irq_next_vpa =
-		 le32_to_cpu(asc_dvc->irq_sp->next_vpa)) & ASC_RQ_DONE) != 0) {
-		/*
-		 * Get a pointer to the newly completed ADV_SCSI_REQ_Q structure.
-		 * The RISC will have set 'areq_vpa' to a virtual address.
-		 *
-		 * The firmware will have copied the ASC_SCSI_REQ_Q.scsiq_ptr
-		 * field to the carrier ADV_CARR_T.areq_vpa field. The conversion
-		 * below complements the conversion of ASC_SCSI_REQ_Q.scsiq_ptr'
-		 * in AdvExeScsiQueue().
-		 */
-		scsiq = (ADV_SCSI_REQ_Q *)
-		    ADV_U32_TO_VADDR(le32_to_cpu(asc_dvc->irq_sp->areq_vpa));
-
-		/*
-		 * Request finished with good status and the queue was not
-		 * DMAed to host memory by the firmware. Set all status fields
-		 * to indicate good status.
-		 */
-		if ((irq_next_vpa & ASC_RQ_GOOD) != 0) {
-			scsiq->done_status = QD_NO_ERROR;
-			scsiq->host_status = scsiq->scsi_status = 0;
-			scsiq->data_cnt = 0L;
-		}
-
-		/*
-		 * Advance the stopper pointer to the next carrier
-		 * ignoring the lower four bits. Free the previous
-		 * stopper carrier.
-		 */
-		free_carrp = asc_dvc->irq_sp;
-		asc_dvc->irq_sp = (ADV_CARR_T *)
-		    ADV_U32_TO_VADDR(ASC_GET_CARRP(irq_next_vpa));
-
-		free_carrp->next_vpa =
-		    cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->carr_freelist));
-		asc_dvc->carr_freelist = free_carrp;
-		asc_dvc->carr_pending_cnt--;
-
-		target_bit = ADV_TID_TO_TIDMASK(scsiq->target_id);
-
-		/*
-		 * Clear request microcode control flag.
-		 */
-		scsiq->cntl = 0;
-
-		/*
-		 * Notify the driver of the completed request by passing
-		 * the ADV_SCSI_REQ_Q pointer to its callback function.
-		 */
-		scsiq->a_flag |= ADV_SCSIQ_DONE;
-		adv_isr_callback(asc_dvc, scsiq);
-		/*
-		 * Note: After the driver callback function is called, 'scsiq'
-		 * can no longer be referenced.
-		 *
-		 * Fall through and continue processing other completed
-		 * requests...
-		 */
-	}
-	return ADV_TRUE;
+	return asc_dvc->err_code;
 }
+#endif
 
-/*
- * Send an idle command to the chip and wait for completion.
- *
- * Command completion is polled for once per microsecond.
- *
- * The function can be called from anywhere including an interrupt handler.
- * But the function is not re-entrant, so it uses the DvcEnter/LeaveCritical()
- * functions to prevent reentrancy.
- *
- * Return Values:
- *   ADV_TRUE - command completed successfully
- *   ADV_FALSE - command failed
- *   ADV_ERROR - command timed out
- */
-static int
-AdvSendIdleCmd(ADV_DVC_VAR *asc_dvc,
-	       ushort idle_cmd, ADV_DCNT idle_cmd_parameter)
-{
-	int result;
-	ADV_DCNT i, j;
-	AdvPortAddr iop_base;
-
-	iop_base = asc_dvc->iop_base;
-
-	/*
-	 * Clear the idle command status which is set by the microcode
-	 * to a non-zero value to indicate when the command is completed.
-	 * The non-zero result is one of the IDLE_CMD_STATUS_* values
-	 */
-	AdvWriteWordLram(iop_base, ASC_MC_IDLE_CMD_STATUS, (ushort)0);
-
+static struct scsi_host_template advansys_template = {
+	.proc_name = DRV_NAME,
+#ifdef CONFIG_PROC_FS
+	.proc_info = advansys_proc_info,
+#endif
+	.name = DRV_NAME,
+	.info = advansys_info,
+	.queuecommand = advansys_queuecommand,
+	.eh_bus_reset_handler = advansys_reset,
+	.bios_param = advansys_biosparam,
+	.slave_configure = advansys_slave_configure,
 	/*
-	 * Write the idle command value after the idle command parameter
-	 * has been written to avoid a race condition. If the order is not
-	 * followed, the microcode may process the idle command before the
-	 * parameters have been written to LRAM.
+	 * Because the driver may control an ISA adapter 'unchecked_isa_dma'
+	 * must be set. The flag will be cleared in advansys_board_found
+	 * for non-ISA adapters.
 	 */
-	AdvWriteDWordLramNoSwap(iop_base, ASC_MC_IDLE_CMD_PARAMETER,
-				cpu_to_le32(idle_cmd_parameter));
-	AdvWriteWordLram(iop_base, ASC_MC_IDLE_CMD, idle_cmd);
-
+	.unchecked_isa_dma = 1,
 	/*
-	 * Tickle the RISC to tell it to process the idle command.
+	 * All adapters controlled by this driver are capable of large
+	 * scatter-gather lists. According to the mid-level SCSI documentation
+	 * this obviates any performance gain provided by setting
+	 * 'use_clustering'. But empirically while CPU utilization is increased
+	 * by enabling clustering, I/O throughput increases as well.
 	 */
-	AdvWriteByteRegister(iop_base, IOPB_TICKLE, ADV_TICKLE_B);
-	if (asc_dvc->chip_type == ADV_CHIP_ASC3550) {
-		/*
-		 * Clear the tickle value. In the ASC-3550 the RISC flag
-		 * command 'clr_tickle_b' does not work unless the host
-		 * value is cleared.
-		 */
-		AdvWriteByteRegister(iop_base, IOPB_TICKLE, ADV_TICKLE_NOP);
-	}
-
-	/* Wait for up to 100 millisecond for the idle command to timeout. */
-	for (i = 0; i < SCSI_WAIT_100_MSEC; i++) {
-		/* Poll once each microsecond for command completion. */
-		for (j = 0; j < SCSI_US_PER_MSEC; j++) {
-			AdvReadWordLram(iop_base, ASC_MC_IDLE_CMD_STATUS,
-					result);
-			if (result != 0)
-				return result;
-			udelay(1);
-		}
-	}
-
-	BUG();		/* The idle command should never timeout. */
-	return ADV_ERROR;
-}
+	.use_clustering = ENABLE_CLUSTERING,
+};
 
 static int __devinit
 advansys_wide_init_chip(asc_board_t *boardp, ADV_DVC_VAR *adv_dvc_varp)
-- 
1.5.2.4

