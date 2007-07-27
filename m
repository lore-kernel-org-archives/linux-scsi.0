From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 13/24] advansys: misc reformatting
Date: Fri, 27 Jul 2007 07:42:22 -0600
Message-ID: <11855437533064-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:50356 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbXG0Nmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:37 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Remove some useless forward declarations
Reformat some comments, debug messages, and the occasional piece of real code
Removal of unnecessary braces
Remove duplicate setting of shost->irq

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  274 ++++++++++++++++++++---------------------------
 1 files changed, 116 insertions(+), 158 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 7c59739..9974c01 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1826,9 +1826,6 @@ static void AscEnableInterrupt(PortAddr);
 static void AscSetBank(PortAddr, uchar);
 static int AscResetChipAndScsiBus(ASC_DVC_VAR *);
 #ifdef CONFIG_ISA
-static ushort AscGetIsaDmaChannel(PortAddr);
-static ushort AscSetIsaDmaChannel(PortAddr, ushort);
-static uchar AscSetIsaDmaSpeed(PortAddr, uchar);
 static uchar AscGetIsaDmaSpeed(PortAddr);
 #endif /* CONFIG_ISA */
 static uchar AscReadLramByte(PortAddr, ushort);
@@ -1875,18 +1872,11 @@ static PortAddr AscSearchIOPortAddr11(PortAddr);
 static void AscSetISAPNPWaitForKey(void);
 #endif /* CONFIG_ISA */
 static uchar AscGetChipScsiCtrl(PortAddr);
-static uchar AscSetChipScsiID(PortAddr, uchar);
 static uchar AscGetChipVersion(PortAddr, ushort);
-static ushort AscGetChipBusType(PortAddr);
 static ASC_DCNT AscLoadMicroCode(PortAddr, ushort, uchar *, ushort);
-static int AscFindSignature(PortAddr);
 static void AscToggleIRQAct(PortAddr);
-static uchar AscGetChipIRQ(PortAddr, ushort);
-static uchar AscSetChipIRQ(PortAddr, uchar, ushort);
-static ushort AscGetChipBiosAddress(PortAddr, ushort);
 static inline ulong DvcEnterCritical(void);
 static inline void DvcLeaveCritical(ulong);
-static ushort AscGetChipBiosAddress(PortAddr, ushort);
 static void DvcSleepMilliSecond(ASC_DCNT);
 static void DvcDelayNanoSecond(ASC_DVC_VAR *, ASC_DCNT);
 static void DvcPutScsiQ(PortAddr, ushort, uchar *, int);
@@ -1900,7 +1890,6 @@ static int AscSgListToQueue(int);
 #ifdef CONFIG_ISA
 static void AscEnableIsaDma(uchar);
 #endif /* CONFIG_ISA */
-static ASC_DCNT AscGetMaxDmaCount(ushort);
 static const char *advansys_info(struct Scsi_Host *shost);
 
 /*
@@ -3754,10 +3743,6 @@ static int asc_prt_adv_board_info(struct Scsi_Host *, char *, int);
 static int asc_prt_line(char *, int, char *fmt, ...);
 #endif /* CONFIG_PROC_FS */
 
-/* Declaration for Asc Library internal functions referenced by driver. */
-static int AscFindSignature(PortAddr);
-static ushort AscGetEEPConfig(PortAddr, ASCEEP_CONFIG *, ushort);
-
 /* Statistics function prototypes. */
 #ifdef ADVANSYS_STATS
 #ifdef CONFIG_PROC_FS
@@ -3866,8 +3851,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		cp = boardp->prtbuf;
 		cplen = asc_prt_adv_bios(shost, cp, ASC_PRTBUF_SIZE);
 		ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
-		cnt =
-		    asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
+		cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
 				  cplen);
 		totcnt += cnt;
 		leftlen -= cnt;
@@ -3954,11 +3938,10 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	for (tgt_id = 0; tgt_id <= ADV_MAX_TID; tgt_id++) {
 		cp = boardp->prtbuf;
 		cplen = asc_prt_target_stats(shost, tgt_id, cp,
-							ASC_PRTBUF_SIZE);
+					     ASC_PRTBUF_SIZE);
 		ASC_ASSERT(cplen <= ASC_PRTBUF_SIZE);
-		cnt =
-		    asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
-				  cplen);
+		cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
+				    cplen);
 		totcnt += cnt;
 		leftlen -= cnt;
 		if (leftlen == 0) {
@@ -4048,15 +4031,14 @@ static const char *advansys_info(struct Scsi_Host *shost)
 				}
 			} else {
 				busname = "?";
-				ASC_PRINT2
-				    ("advansys_info: board %d: unknown bus type %d\n",
-				     boardp->id, asc_dvc_varp->bus_type);
+				ASC_PRINT2("advansys_info: board %d: unknown "
+					   "bus type %d\n", boardp->id,
+					   asc_dvc_varp->bus_type);
 			}
 			/* Don't reference 'shost->n_io_port'; It may be truncated. */
 			sprintf(info,
 				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X",
-				ASC_VERSION, busname,
-				(ulong)shost->io_port,
+				ASC_VERSION, busname, (ulong)shost->io_port,
 				(ulong)shost->io_port + boardp->asc_n_io_port -
 				1, shost->irq);
 		}
@@ -4237,18 +4219,16 @@ static int advansys_reset(struct scsi_cmnd *scp)
 
 		/* Refer to ASC_IERR_* defintions for meaning of 'err_code'. */
 		if (asc_dvc_varp->err_code) {
-			ASC_PRINT2
-			    ("advansys_reset: board %d: SCSI bus reset error: 0x%x\n",
-			     boardp->id, asc_dvc_varp->err_code);
+			ASC_PRINT2("advansys_reset: board %d: SCSI bus reset "
+				   "error: 0x%x\n", boardp->id,
+				   asc_dvc_varp->err_code);
 			ret = FAILED;
 		} else if (status) {
-			ASC_PRINT2
-			    ("advansys_reset: board %d: SCSI bus reset warning: 0x%x\n",
-			     boardp->id, status);
+			ASC_PRINT2("advansys_reset: board %d: SCSI bus reset "
+				   "warning: 0x%x\n", boardp->id, status);
 		} else {
-			ASC_PRINT1
-			    ("advansys_reset: board %d: SCSI bus reset successful.\n",
-			     boardp->id);
+			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
+				   "successful.\n", boardp->id);
 		}
 
 		ASC_DBG(1, "advansys_reset: after AscInitAsc1000Driver()\n");
@@ -4269,15 +4249,13 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		ASC_DBG(1, "advansys_reset: before AdvResetChipAndSB()\n");
 		switch (AdvResetChipAndSB(adv_dvc_varp)) {
 		case ASC_TRUE:
-			ASC_PRINT1
-			    ("advansys_reset: board %d: SCSI bus reset successful.\n",
-			     boardp->id);
+			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
+				   "successful.\n", boardp->id);
 			break;
 		case ASC_FALSE:
 		default:
-			ASC_PRINT1
-			    ("advansys_reset: board %d: SCSI bus reset error.\n",
-			     boardp->id);
+			ASC_PRINT1("advansys_reset: board %d: SCSI bus reset "
+				   "error.\n", boardp->id);
 			ret = FAILED;
 			break;
 		}
@@ -4298,8 +4276,8 @@ static int advansys_reset(struct scsi_cmnd *scp)
 	 * is returned in 'last_scp'.
 	 */
 	if (done_scp == NULL) {
-		done_scp =
-		    asc_dequeue_list(&boardp->active, &last_scp, ASC_TID_ALL);
+		done_scp = asc_dequeue_list(&boardp->active, &last_scp,
+					    ASC_TID_ALL);
 		for (tscp = done_scp; tscp; tscp = REQPNEXT(tscp)) {
 			tscp->result = HOST_BYTE(DID_RESET);
 		}
@@ -4325,8 +4303,8 @@ static int advansys_reset(struct scsi_cmnd *scp)
 	 * to DID_RESET.
 	 */
 	if (done_scp == NULL) {
-		done_scp =
-		    asc_dequeue_list(&boardp->waiting, &last_scp, ASC_TID_ALL);
+		done_scp = asc_dequeue_list(&boardp->waiting, &last_scp,
+					    ASC_TID_ALL);
 		for (tscp = done_scp; tscp; tscp = REQPNEXT(tscp)) {
 			tscp->result = HOST_BYTE(DID_RESET);
 		}
@@ -4357,9 +4335,8 @@ static int advansys_reset(struct scsi_cmnd *scp)
 	/*
 	 * Complete all the 'done_scp' requests.
 	 */
-	if (done_scp != NULL) {
+	if (done_scp)
 		asc_scsi_done_list(done_scp);
-	}
 
 	ASC_DBG1(1, "advansys_reset: ret %d\n", ret);
 
@@ -4500,14 +4477,13 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 		 * handler will complete pending requests after it has completed.
 		 */
 		if ((boardp->flags & ASC_HOST_IN_RESET) == 0) {
-			ASC_DBG2(1,
-				 "advansys_interrupt: done_scp 0x%lx, last_scp 0x%lx\n",
-				 (ulong)done_scp, (ulong)last_scp);
+			ASC_DBG2(1, "advansys_interrupt: done_scp 0x%p, "
+				 "last_scp 0x%p\n", done_scp, last_scp);
 
 			/* Start any waiting commands for the board. */
 			if (!ASC_QUEUE_EMPTY(&boardp->waiting)) {
-				ASC_DBG(1,
-					"advansys_interrupt: before asc_execute_queue()\n");
+				ASC_DBG(1, "advansys_interrupt: before "
+					"asc_execute_queue()\n");
 				asc_execute_queue(&boardp->waiting);
 			}
 
@@ -4519,9 +4495,8 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 			 * 'done_scp'.
 			 */
 			if (done_scp == NULL) {
-				done_scp =
-				    asc_dequeue_list(&boardp->done, &last_scp,
-						     ASC_TID_ALL);
+				done_scp = asc_dequeue_list(&boardp->done,
+							&last_scp, ASC_TID_ALL);
 			} else {
 				ASC_ASSERT(last_scp != NULL);
 				last_scp->host_scribble =
@@ -4888,33 +4863,33 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		case ASC_NOERROR:
 			ASC_STATS(scp->device->host, exe_noerror);
 			/*
-			 * Increment monotonically increasing per device successful
-			 * request counter. Wrapping doesn't matter.
+			 * Increment monotonically increasing per device
+			 * successful request counter. Wrapping doesn't matter.
 			 */
 			boardp->reqcnt[scp->device->id]++;
 			asc_enqueue(&boardp->active, scp, ASC_BACK);
-			ASC_DBG(1,
-				"asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR\n");
+			ASC_DBG(1, "asc_execute_scsi_cmnd: AscExeScsiQueue(), "
+				"ASC_NOERROR\n");
 			break;
 		case ASC_BUSY:
 			/*
-			 * Caller will enqueue request on the target's waiting queue
-			 * and retry later.
+			 * Caller will enqueue request on the target's waiting
+			 * queue and retry later.
 			 */
 			ASC_STATS(scp->device->host, exe_busy);
 			break;
 		case ASC_ERROR:
-			ASC_PRINT2
-			    ("asc_execute_scsi_cmnd: board %d: AscExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
-			     boardp->id, asc_dvc_varp->err_code);
+			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
+				"AscExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
+				boardp->id, asc_dvc_varp->err_code);
 			ASC_STATS(scp->device->host, exe_error);
 			scp->result = HOST_BYTE(DID_ERROR);
 			asc_enqueue(&boardp->done, scp, ASC_BACK);
 			break;
 		default:
-			ASC_PRINT2
-			    ("asc_execute_scsi_cmnd: board %d: AscExeScsiQueue() unknown, err_code 0x%x\n",
-			     boardp->id, asc_dvc_varp->err_code);
+			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
+				"AscExeScsiQueue() unknown, err_code 0x%x\n",
+				boardp->id, asc_dvc_varp->err_code);
 			ASC_STATS(scp->device->host, exe_unknown);
 			scp->result = HOST_BYTE(DID_ERROR);
 			asc_enqueue(&boardp->done, scp, ASC_BACK);
@@ -4934,20 +4909,21 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		 */
 		switch (adv_build_req(boardp, scp, &adv_scsiqp)) {
 		case ASC_NOERROR:
-			ASC_DBG(3,
-				"asc_execute_scsi_cmnd: adv_build_req ASC_NOERROR\n");
+			ASC_DBG(3, "asc_execute_scsi_cmnd: adv_build_req "
+				"ASC_NOERROR\n");
 			break;
 		case ASC_BUSY:
-			ASC_DBG(1,
-				"asc_execute_scsi_cmnd: adv_build_req ASC_BUSY\n");
+			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
+				"ASC_BUSY\n");
 			/*
-			 * If busy is returned the request has not been enqueued.
-			 * It will be enqueued by the caller on the target's waiting
-			 * queue and retried later.
+			 * If busy is returned the request has not been
+			 * enqueued.  It will be enqueued by the caller on the
+			 * target's waiting queue and retried later.
 			 *
-			 * The asc_stats fields 'adv_build_noreq' and 'adv_build_nosg'
-			 * count wide board busy conditions. They are updated in
-			 * adv_build_req and adv_get_sglist, respectively.
+			 * The asc_stats fields 'adv_build_noreq' and
+			 * 'adv_build_nosg' count wide board busy conditions.
+			 * They are updated in adv_build_req and
+			 * adv_get_sglist, respectively.
 			 */
 			return ASC_BUSY;
 		case ASC_ERROR:
@@ -4957,8 +4933,8 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			 * by the caller.
 			 */
 		default:
-			ASC_DBG(1,
-				"asc_execute_scsi_cmnd: adv_build_req ASC_ERROR\n");
+			ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req "
+				"ASC_ERROR\n");
 			ASC_STATS(scp->device->host, build_error);
 			return ASC_ERROR;
 		}
@@ -4971,33 +4947,33 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		case ASC_NOERROR:
 			ASC_STATS(scp->device->host, exe_noerror);
 			/*
-			 * Increment monotonically increasing per device successful
-			 * request counter. Wrapping doesn't matter.
+			 * Increment monotonically increasing per device
+			 * successful request counter. Wrapping doesn't matter.
 			 */
 			boardp->reqcnt[scp->device->id]++;
 			asc_enqueue(&boardp->active, scp, ASC_BACK);
-			ASC_DBG(1,
-				"asc_execute_scsi_cmnd: AdvExeScsiQueue(), ASC_NOERROR\n");
+			ASC_DBG(1, "asc_execute_scsi_cmnd: AdvExeScsiQueue(), "
+				"ASC_NOERROR\n");
 			break;
 		case ASC_BUSY:
 			/*
-			 * Caller will enqueue request on the target's waiting queue
-			 * and retry later.
+			 * Caller will enqueue request on the target's waiting
+			 * queue and retry later.
 			 */
 			ASC_STATS(scp->device->host, exe_busy);
 			break;
 		case ASC_ERROR:
-			ASC_PRINT2
-			    ("asc_execute_scsi_cmnd: board %d: AdvExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
-			     boardp->id, adv_dvc_varp->err_code);
+			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
+				"AdvExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
+				boardp->id, adv_dvc_varp->err_code);
 			ASC_STATS(scp->device->host, exe_error);
 			scp->result = HOST_BYTE(DID_ERROR);
 			asc_enqueue(&boardp->done, scp, ASC_BACK);
 			break;
 		default:
-			ASC_PRINT2
-			    ("asc_execute_scsi_cmnd: board %d: AdvExeScsiQueue() unknown, err_code 0x%x\n",
-			     boardp->id, adv_dvc_varp->err_code);
+			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
+				"AdvExeScsiQueue() unknown, err_code 0x%x\n",
+				boardp->id, adv_dvc_varp->err_code);
 			ASC_STATS(scp->device->host, exe_unknown);
 			scp->result = HOST_BYTE(DID_ERROR);
 			asc_enqueue(&boardp->done, scp, ASC_BACK);
@@ -5040,9 +5016,9 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 	 * is supported.
 	 */
 	if (scp->cmd_len > ASC_MAX_CDB_LEN) {
-		ASC_PRINT3
-		    ("asc_build_req: board %d: cmd_len %d > ASC_MAX_CDB_LEN  %d\n",
-		     boardp->id, scp->cmd_len, ASC_MAX_CDB_LEN);
+		ASC_PRINT3("asc_build_req: board %d: cmd_len %d > "
+			"ASC_MAX_CDB_LEN %d\n", boardp->id, scp->cmd_len,
+			ASC_MAX_CDB_LEN);
 		scp->result = HOST_BYTE(DID_ERROR);
 		asc_enqueue(&boardp->done, scp, ASC_BACK);
 		return ASC_ERROR;
@@ -7427,27 +7403,27 @@ DvcGetQinfo(PortAddr iop_base, ushort s_addr, uchar *inbuf, int words)
  * Return the BIOS address of the adapter at the specified
  * I/O port and with the specified bus type.
  */
-static ushort __devinit AscGetChipBiosAddress(PortAddr iop_base, ushort bus_type)
+static unsigned short __devinit
+AscGetChipBiosAddress(PortAddr iop_base, unsigned short bus_type)
 {
-	ushort cfg_lsw;
-	ushort bios_addr;
+	unsigned short cfg_lsw;
+	unsigned short bios_addr;
 
 	/*
 	 * The PCI BIOS is re-located by the motherboard BIOS. Because
 	 * of this the driver can not determine where a PCI BIOS is
 	 * loaded and executes.
 	 */
-	if (bus_type & ASC_IS_PCI) {
-		return (0);
-	}
+	if (bus_type & ASC_IS_PCI)
+		return 0;
+
 #ifdef CONFIG_ISA
 	if ((bus_type & ASC_IS_EISA) != 0) {
 		cfg_lsw = AscGetEisaChipCfg(iop_base);
 		cfg_lsw &= 0x000F;
-		bios_addr = (ushort)(ASC_BIOS_MIN_ADDR +
-				     (cfg_lsw * ASC_BIOS_BANK_SIZE));
-		return (bios_addr);
-	}			/* if */
+		bios_addr = ASC_BIOS_MIN_ADDR + cfg_lsw * ASC_BIOS_BANK_SIZE;
+		return bios_addr;
+	}
 #endif /* CONFIG_ISA */
 
 	cfg_lsw = AscGetChipCfgLsw(iop_base);
@@ -7455,13 +7431,10 @@ static ushort __devinit AscGetChipBiosAddress(PortAddr iop_base, ushort bus_type
 	/*
 	 *  ISA PnP uses the top bit as the 32K BIOS flag
 	 */
-	if (bus_type == ASC_IS_ISAPNP) {
+	if (bus_type == ASC_IS_ISAPNP)
 		cfg_lsw &= 0x7FFF;
-	}
-	/* if */
-	bios_addr = (ushort)(((cfg_lsw >> 12) * ASC_BIOS_BANK_SIZE) +
-			     ASC_BIOS_MIN_ADDR);
-	return (bios_addr);
+	bios_addr = ASC_BIOS_MIN_ADDR + (cfg_lsw >> 12) * ASC_BIOS_BANK_SIZE;
+	return bios_addr;
 }
 
 /*
@@ -7758,10 +7731,8 @@ static void asc_prt_scsi_cmnd(struct scsi_cmnd *s)
 
 	printk(" timeout_per_command %d\n", s->timeout_per_command);
 
-	printk
-	    (" scsi_done 0x%lx, done 0x%lx, host_scribble 0x%lx, result 0x%x\n",
-	     (ulong)s->scsi_done, (ulong)s->done, (ulong)s->host_scribble,
-	     s->result);
+	printk(" scsi_done 0x%p, done 0x%p, host_scribble 0x%p, result 0x%x\n",
+		s->scsi_done, s->done, s->host_scribble, s->result);
 
 	printk(" tag %u, pid %u\n", (unsigned)s->tag, (unsigned)s->pid);
 }
@@ -7773,34 +7744,31 @@ static void asc_prt_asc_dvc_var(ASC_DVC_VAR *h)
 {
 	printk("ASC_DVC_VAR at addr 0x%lx\n", (ulong)h);
 
-	printk
-	    (" iop_base 0x%x, err_code 0x%x, dvc_cntl 0x%x, bug_fix_cntl %d,\n",
-	     h->iop_base, h->err_code, h->dvc_cntl, h->bug_fix_cntl);
+	printk(" iop_base 0x%x, err_code 0x%x, dvc_cntl 0x%x, bug_fix_cntl "
+	       "%d,\n", h->iop_base, h->err_code, h->dvc_cntl, h->bug_fix_cntl);
 
-	printk
-	    (" bus_type %d, isr_callback 0x%lx, exe_callback 0x%lx, init_sdtr 0x%x,\n",
-	     h->bus_type, (ulong)h->isr_callback, (ulong)h->exe_callback,
-	     (unsigned)h->init_sdtr);
+	printk(" bus_type %d, isr_callback 0x%p, exe_callback 0x%p, "
+	       "init_sdtr 0x%x,\n", h->bus_type, h->isr_callback,
+	       h->exe_callback, (unsigned)h->init_sdtr);
 
-	printk
-	    (" sdtr_done 0x%x, use_tagged_qng 0x%x, unit_not_ready 0x%x, chip_no 0x%x,\n",
-	     (unsigned)h->sdtr_done, (unsigned)h->use_tagged_qng,
-	     (unsigned)h->unit_not_ready, (unsigned)h->chip_no);
+	printk(" sdtr_done 0x%x, use_tagged_qng 0x%x, unit_not_ready 0x%x, "
+	       "chip_no 0x%x,\n", (unsigned)h->sdtr_done,
+	       (unsigned)h->use_tagged_qng, (unsigned)h->unit_not_ready,
+	       (unsigned)h->chip_no);
 
-	printk
-	    (" queue_full_or_busy 0x%x, start_motor 0x%x, scsi_reset_wait %u,\n",
-	     (unsigned)h->queue_full_or_busy, (unsigned)h->start_motor,
-	     (unsigned)h->scsi_reset_wait);
+	printk(" queue_full_or_busy 0x%x, start_motor 0x%x, scsi_reset_wait "
+	       "%u,\n", (unsigned)h->queue_full_or_busy,
+	       (unsigned)h->start_motor, (unsigned)h->scsi_reset_wait);
 
-	printk
-	    (" is_in_int %u, max_total_qng %u, cur_total_qng %u, in_critical_cnt %u,\n",
-	     (unsigned)h->is_in_int, (unsigned)h->max_total_qng,
-	     (unsigned)h->cur_total_qng, (unsigned)h->in_critical_cnt);
+	printk(" is_in_int %u, max_total_qng %u, cur_total_qng %u, "
+	       "in_critical_cnt %u,\n", (unsigned)h->is_in_int,
+	       (unsigned)h->max_total_qng, (unsigned)h->cur_total_qng,
+	       (unsigned)h->in_critical_cnt);
 
-	printk
-	    (" last_q_shortage %u, init_state 0x%x, no_scam 0x%x, pci_fix_asyn_xfer 0x%x,\n",
-	     (unsigned)h->last_q_shortage, (unsigned)h->init_state,
-	     (unsigned)h->no_scam, (unsigned)h->pci_fix_asyn_xfer);
+	printk(" last_q_shortage %u, init_state 0x%x, no_scam 0x%x, "
+	       "pci_fix_asyn_xfer 0x%x,\n", (unsigned)h->last_q_shortage,
+	       (unsigned)h->init_state, (unsigned)h->no_scam,
+	       (unsigned)h->pci_fix_asyn_xfer);
 
 	printk(" cfg 0x%lx, irq_no 0x%x\n", (ulong)h->cfg, (unsigned)h->irq_no);
 }
@@ -8104,27 +8072,28 @@ static uchar __devinit AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
 	return (AscGetChipScsiID(iop_base));
 }
 
-static uchar __devinit AscGetChipScsiCtrl(PortAddr iop_base)
+static unsigned char __devinit AscGetChipScsiCtrl(PortAddr iop_base)
 {
-	uchar sc;
+	unsigned char sc;
 
 	AscSetBank(iop_base, 1);
 	sc = inp(iop_base + IOP_REG_SC);
 	AscSetBank(iop_base, 0);
-	return (sc);
+	return sc;
 }
 
-static uchar __devinit AscGetChipVersion(PortAddr iop_base, ushort bus_type)
+static unsigned char __devinit
+AscGetChipVersion(PortAddr iop_base, unsigned short bus_type)
 {
-	if ((bus_type & ASC_IS_EISA) != 0) {
+	if (bus_type & ASC_IS_EISA) {
 		PortAddr eisa_iop;
-		uchar revision;
+		unsigned char revision;
 		eisa_iop = (PortAddr) ASC_GET_EISA_SLOT(iop_base) |
 		    (PortAddr) ASC_EISA_REV_IOP_MASK;
 		revision = inp(eisa_iop);
-		return ((uchar)((ASC_CHIP_MIN_VER_EISA - 1) + revision));
+		return ASC_CHIP_MIN_VER_EISA - 1 + revision;
 	}
-	return (AscGetChipVerNo(iop_base));
+	return AscGetChipVerNo(iop_base);
 }
 
 static ushort __devinit AscGetChipBusType(PortAddr iop_base)
@@ -10441,13 +10410,12 @@ static ushort __devinit AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
 		warn_code |= AscInitAscDvcVar(asc_dvc);
 		warn_code |= AscInitFromEEP(asc_dvc);
 		asc_dvc->init_state |= ASC_INIT_STATE_END_GET_CFG;
-		if (asc_dvc->scsi_reset_wait > ASC_MAX_SCSI_RESET_WAIT) {
+		if (asc_dvc->scsi_reset_wait > ASC_MAX_SCSI_RESET_WAIT)
 			asc_dvc->scsi_reset_wait = ASC_MAX_SCSI_RESET_WAIT;
-		}
 	} else {
 		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
 	}
-	return (warn_code);
+	return warn_code;
 }
 
 static ushort __devinit AscInitSetConfig(ASC_DVC_VAR *asc_dvc)
@@ -17302,14 +17270,11 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	int ret;
 
 	/*
-	 * Adapter found.
-	 *
 	 * Register the adapter, get its configuration, and
 	 * initialize it.
 	 */
 	ASC_DBG(2, "advansys_board_found: scsi_host_alloc()\n");
 	shost = scsi_host_alloc(&advansys_template, sizeof(asc_board_t));
-
 	if (!shost)
 		return NULL;
 
@@ -17320,8 +17285,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	boardp = ASC_BOARDP(shost);
 	memset(boardp, 0, sizeof(asc_board_t));
 	boardp->id = asc_board_count - 1;
-
-	/* Initialize spinlock. */
 	spin_lock_init(&boardp->lock);
 
 	/*
@@ -17741,11 +17704,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 */
 		boardp->init_tidmask |=
 		    ADV_TID_TO_TIDMASK(adv_dvc_varp->chip_scsi_id);
-
-		/*
-		 * Finish initializing the 'Scsi_Host' structure.
-		 */
-		shost->irq = adv_dvc_varp->irq_no;
 	}
 
 	/*
-- 
1.4.4.4

