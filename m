From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] streamline lpfc error handling
Date: Sun, 20 Jun 2004 15:56:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040620135600.GA15620@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:20924 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265286AbUFTN4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 09:56:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

streamline the callchain in the lpdc EH functions, use sdev->hostdata in
a few places instead of the lpfc-internal lookup, fix up return values
(they seemd to be completely wrong before)


diff -ur lpfcdriver-2.6-8.0.4/lpfc_crtn.h lpfcdriver-2.6-8.0.4-hch/lpfc_crtn.h
--- lpfcdriver-2.6-8.0.4/lpfc_crtn.h	2004-06-15 00:07:01.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_crtn.h	2004-06-20 15:46:50.287255952 +0200
@@ -216,8 +216,6 @@
 				 struct lpfc_iocbq *);
 int lpfc_sli_abort_iocb_ctx(struct lpfc_hba *, struct lpfc_sli_ring *,
 			    uint32_t);
-int lpfc_sli_abort_iocb_context1(struct lpfc_hba *, struct lpfc_sli_ring *,
-				 void *);
 int lpfc_sli_abort_iocb_lun(struct lpfc_hba *, struct lpfc_sli_ring *, uint16_t,
 			    uint64_t);
 int lpfc_sli_abort_iocb_tgt(struct lpfc_hba *, struct lpfc_sli_ring *,
@@ -228,7 +226,6 @@
 void lpfc_stop_timer(struct clk_data *);
 
 
-LPFC_SCSI_BUF_t *lpfc_get_scsi_buf(struct lpfc_hba *, int);
 void lpfc_free_scsi_buf(LPFC_SCSI_BUF_t *);
 void lpfc_map_fcp_cmnd_to_bpl(struct lpfc_hba *, LPFC_SCSI_BUF_t *);
 void lpfc_free_scsi_cmd(LPFC_SCSI_BUF_t *);
@@ -277,6 +274,7 @@
 int lpfc_revoke(struct scsi_device *);
 int lpfc_queuecommand(struct scsi_cmnd *, void (*done) (struct scsi_cmnd *));
 int lpfc_abort_handler(struct scsi_cmnd *);
+int lpfc_reset_bus_handler(struct scsi_cmnd *cmnd);
 int lpfc_reset_lun_handler(struct scsi_cmnd *);
 
 #define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code)
diff -ur lpfcdriver-2.6-8.0.4/lpfc_fcp.c lpfcdriver-2.6-8.0.4-hch/lpfc_fcp.c
--- lpfcdriver-2.6-8.0.4/lpfc_fcp.c	2004-06-15 00:07:01.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_fcp.c	2004-06-20 15:47:16.409284800 +0200
@@ -83,7 +83,6 @@
 
 
 static int lpfc_device_queue_depth(struct lpfc_hba *, struct scsi_device *);
-static int lpfc_reset_bus_handler(struct scsi_cmnd *cmnd);
 
 static int lpfc_memmap(struct lpfc_hba *);
 static int lpfc_unmemmap(struct lpfc_hba *);
@@ -994,38 +993,6 @@
 	return (len);
 }
 
-static int
-lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
-{
-	struct lpfc_hba *phba;
-	LPFC_SCSI_BUF_t *lpfc_cmd;
-	unsigned long iflag;
-	int rc, tgt, lun;
-
-	phba = (struct lpfc_hba *) cmnd->device->host->hostdata[0];
-	tgt = cmnd->device->id;
-	lun = cmnd->device->lun;
-
-	rc = 0;
-	if ((lpfc_cmd = lpfc_get_scsi_buf(phba, GFP_ATOMIC))) {
-		rc = lpfc_scsi_hba_reset(phba, lpfc_cmd);
-		spin_lock_irqsave(&(phba->drvrlock), iflag);
-		lpfc_free_scsi_buf(lpfc_cmd);
-		spin_unlock_irqrestore(&(phba->drvrlock), iflag);
-	}
-
-	/* SCSI layer issued Bus Reset */
-	lpfc_printf_log(phba,
-		        KERN_ERR,
-		        LOG_FCP,
-		        "0714 SCSI layer issued Bus Reset Data: x%x x%x x%x",
-		        tgt, lun, rc);
-
-
-	return (SUCCESS);
-
-}				/* lpfc_reset_bus_handler */
-
 int
 lpfc_slave_alloc(struct scsi_device *scsi_devs)
 {
diff -ur lpfcdriver-2.6-8.0.4/lpfc_scsi.h lpfcdriver-2.6-8.0.4-hch/lpfc_scsi.h
--- lpfcdriver-2.6-8.0.4/lpfc_scsi.h	2004-06-15 00:07:02.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_scsi.h	2004-06-20 15:05:27.444705392 +0200
@@ -208,14 +208,8 @@
 
 #define LPFC_SCSI_INITIAL_BPL_SIZE  4	/* Number of scsi buf BDEs in fcp_bpl */
 
-#define FAILURE -1
 #define LPFC_CMD_STATUS_ABORTED -1
 
-#define LPFC_INTERNAL_RESET   0	/* internal reset */
-#define LPFC_EXTERNAL_RESET   1	/* external reset, scsi layer */
-#define LPFC_ISSUE_LUN_RESET  2	/* flag for reset routine to issue LUN_RESET */
-#define LPFC_ISSUE_ABORT_TSET 4	/* flag for reset routine to issue ABORT_TSET */
-
 #define LPFC_SCSI_DMA_EXT_SIZE 264
 #define LPFC_BPL_SIZE          1024
 
diff -ur lpfcdriver-2.6-8.0.4/lpfc_scsiport.c lpfcdriver-2.6-8.0.4-hch/lpfc_scsiport.c
--- lpfcdriver-2.6-8.0.4/lpfc_scsiport.c	2004-06-15 00:07:02.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_scsiport.c	2004-06-20 15:41:31.401733920 +0200
@@ -141,7 +141,6 @@
 static int lpfc_scsi_cmd_start(LPFC_SCSI_BUF_t *);
 static int lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_hba *, LPFC_SCSI_BUF_t *,
 					uint8_t);
-static int lpfc_scsi_cmd_abort(struct lpfc_hba *, LPFC_SCSI_BUF_t *);
 static int lpfc_os_prep_io(struct lpfc_hba *, LPFC_SCSI_BUF_t *);
 static void lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *, struct lpfc_iocbq *,
 				    struct lpfc_iocbq *);
@@ -149,8 +148,6 @@
 static void lpfc_iodone(struct lpfc_hba *, LPFC_SCSI_BUF_t *);
 static int lpfc_scsi_delay_iodone(struct lpfc_hba *, LPFC_SCSI_BUF_t *);
 static void lpfc_scsi_done(struct lpfc_hba *, struct scsi_cmnd *);
-static int lpfc_scsi_lun_reset(LPFC_SCSI_BUF_t *, struct lpfc_hba *, uint32_t);
-static int lpfc_scsi_tgt_reset(LPFC_SCSI_BUF_t *, struct lpfc_hba *, uint32_t);
 
 /* Functions required by the scsiport module. */
 
@@ -161,7 +158,7 @@
  * In addition to allocating memeory, the FCP CMND and FCP RSP BDEs are setup
  * in the BPL and the BPL BDE is setup in the IOCB.
  */
-LPFC_SCSI_BUF_t *
+static LPFC_SCSI_BUF_t *
 lpfc_get_scsi_buf(struct lpfc_hba * phba, int gfp_flags)
 {
 	LPFC_SCSI_BUF_t *psb;
@@ -420,17 +417,9 @@
 	struct lpfc_iocbq *piocbq;
 	IOCB_t *piocb;
 	FCP_CMND *fcp_cmnd;
-	struct lpfc_lun *lun_device;
-	struct lpfc_nodelist *ndlp;
-	struct scsi_device *scsi_dev;
-
-	scsi_dev = lpfc_cmd->pCmd->device;
-	lun_device = lpfc_find_lun(phba, scsi_dev->id, scsi_dev->lun, 1);
-	if (lun_device == 0) {
-		return 0;
-	}
-
-	ndlp = (struct lpfc_nodelist *) lun_device->pTarget->pcontext;
+	struct scsi_device *scsi_dev = lpfc_cmd->pCmd->device;
+	struct lpfc_lun *lun_device = scsi_dev->hostdata;
+	struct lpfc_nodelist *ndlp = lun_device->pTarget->pcontext;
 
 	if ((lun_device->failMask & LPFC_DEV_FATAL_ERROR) || (ndlp == 0)) {
 		return 0;
@@ -510,214 +499,66 @@
 	return (1);
 }
 
-/* returns:  0 if we successfully find and abort the command,
-	     1 if we couldn't find the command
-*/
-static int
-lpfc_scsi_cmd_abort(struct lpfc_hba * phba, LPFC_SCSI_BUF_t * lpfc_cmd)
-{
-
-	/* when this function returns, the command has been aborted and
-	   returned to the OS, or it was returned before we could abort
-	   it */
-
-	/* flush an oustanding command */
-	if (lpfc_sli_abort_iocb_context1
-	    (phba, &phba->sli.ring[phba->sli.fcp_ring], lpfc_cmd) == 0) {
-		return 1;
-	} else {
-		/* couldn't find command - fail */
-		return 0;
-	}
-
-}
-
-static int
-lpfc_scsi_lun_reset(LPFC_SCSI_BUF_t * lpfc_cmd,
-		    struct lpfc_hba *phba, uint32_t flag)
-{
-	struct lpfc_iocbq *piocbq;
-	LPFC_SLI_t *psli;
-	struct lpfc_lun *plun;
-	struct lpfc_iocbq *piocbqrsp = 0;
-	int ret = 0;
-	unsigned long iflag;
-	struct scsi_device *scsi_dev;
-
-	lpfc_cmd->scsi_hba = phba;
-	scsi_dev = lpfc_cmd->pCmd->device;
-	/*
-	 * Reset a device with either a LUN reset or an ABORT TASK
-	 * reset depending on the caller's flag value.
-	 */
-	if (flag & LPFC_ISSUE_LUN_RESET) {
-		ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, LUN_RESET);
-	} else {
-		if (flag & LPFC_ISSUE_ABORT_TSET) {
-			ret =
-			    lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd,
-							 ABORT_TASK_SET);
-		} else {
-			ret = 0;
-		}
-	}
-
-	if (ret) {
-		psli = &phba->sli;
-		piocbq = &(lpfc_cmd->cur_iocbq);
-		if (flag & LPFC_EXTERNAL_RESET) {
-
-			/* get a buffer for this response IOCB command */
-			if ((piocbqrsp = mempool_alloc(phba->iocb_mem_pool,
-						       GFP_ATOMIC)) == 0) {
-				return (ENOMEM);
-			}
-			memset(piocbqrsp, 0, sizeof (struct lpfc_iocbq));
-
-			piocbq->iocb_flag |= LPFC_IO_POLL;
-			piocbq->iocb_cmpl = lpfc_sli_wake_iocb_high_priority;
-			ret = lpfc_sli_issue_iocb_wait_high_priority(phba,
-					     &phba->sli.ring[psli->fcp_ring],
-					     piocbq, SLI_IOCB_USE_TXQ,
-					     piocbqrsp, 60);	/* 60 secs */
-			ret = (ret == IOCB_SUCCESS) ? 1 : 0;
-
-			lpfc_cmd->result = piocbqrsp->iocb.un.ulpWord[4];
-			if ((lpfc_cmd->status = piocbqrsp->iocb.ulpStatus) ==
-			    IOSTAT_LOCAL_REJECT) {
-				if (lpfc_cmd->result & IOERR_DRVR_MASK) {
-					lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
-				}
-			}
-
-			spin_lock_irqsave(&(phba->drvrlock), iflag);
-			plun = lpfc_find_lun(phba, scsi_dev->id, scsi_dev->lun,
-					     1);
-			if (plun) {
-				/* flush outstanding commands on the lun */
-				lpfc_sli_abort_iocb_lun(phba,
-				       &phba->sli.ring[phba->sli.fcp_ring],
-				       plun->pTarget->scsi_id,
-				       plun->lun_id);
-
-			}
-
-			spin_unlock_irqrestore(&(phba->drvrlock), iflag);
-
-			/* Done with piocbqrsp, return to free list */
-			if (piocbqrsp) {
-				mempool_free( piocbqrsp, phba->iocb_mem_pool);
-			}
-
-			/* If this was an external lun reset, issue a message
-			 * indicating its completion.
-			 */
-			if (flag & LPFC_ISSUE_LUN_RESET) {
-				lpfc_printf_log(phba,
-						KERN_INFO,
-						LOG_FCP,
-						"0748 Cmpl LUN Reset Data: x%x x%x x%x x%x x%x",
-						lpfc_cmd->pCmd->device->id,
-						lpfc_cmd->pCmd->device->lun,
-						ret, lpfc_cmd->status,
-						lpfc_cmd->result);
-			}
-		} else {
-
-			ret =
-			    lpfc_sli_issue_iocb(phba,
-						&phba->sli.ring[psli->fcp_ring],
-						piocbq,
-						SLI_IOCB_HIGH_PRIORITY |
-						SLI_IOCB_RET_IOCB);
-			ret = (ret == IOCB_SUCCESS) ? 1 : 0;
-		}
-	}
-
-	return (ret);
-
-}
-
 static int
-lpfc_scsi_tgt_reset(LPFC_SCSI_BUF_t * lpfc_cmd,
-		    struct lpfc_hba * phba, uint32_t flag)
+lpfc_scsi_tgt_reset(LPFC_SCSI_BUF_t * lpfc_cmd, struct lpfc_hba *phba,
+		struct lpfc_target *ptarget)
 {
 	struct lpfc_iocbq *piocbq;
 	LPFC_SLI_t *psli;
-	struct lpfc_target *ptarget = 0;
-	struct lpfc_lun *plun;
 	struct lpfc_iocbq *piocbqrsp = 0;
-	struct scsi_device *scsi_dev;
 	int ret = 0;
 
 	lpfc_cmd->scsi_hba = phba;
-	scsi_dev = lpfc_cmd->pCmd->device;
 
 	/*
 	 * target reset a device
 	 */
 	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, TARGET_RESET);
-	if (ret) {
-		psli = &phba->sli;
-		piocbq = &(lpfc_cmd->cur_iocbq);
-		if (flag & LPFC_EXTERNAL_RESET) {
-
-			/* get a buffer for this IOCB command response */
-			if ((piocbqrsp = mempool_alloc(phba->iocb_mem_pool,
-						       GFP_ATOMIC)) == 0) {
-				return (ENOMEM);
-			}
-			memset(piocbqrsp, 0, sizeof (struct lpfc_iocbq));
-
-			piocbq->iocb_flag |= LPFC_IO_POLL;
-			piocbq->iocb_cmpl = lpfc_sli_wake_iocb_high_priority;
-
-			ret = lpfc_sli_issue_iocb_wait_high_priority(phba,
-				     &phba->sli.ring[psli->fcp_ring],
-				     piocbq, SLI_IOCB_HIGH_PRIORITY,
-				     piocbqrsp,
-				     lpfc_cmd->timeout + LPFC_DRVR_TIMEOUT);
-			ret = (ret == IOCB_SUCCESS) ? 1 : 0;
-
-			lpfc_cmd->result = piocbqrsp->iocb.un.ulpWord[4];
-			if ((lpfc_cmd->status = piocbqrsp->iocb.ulpStatus) ==
-			    IOSTAT_LOCAL_REJECT) {
-				if (lpfc_cmd->result & IOERR_DRVR_MASK) {
-					lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
-				}
-			}
-
-			plun = lpfc_find_lun(phba, scsi_dev->id, scsi_dev->lun,
-					     1);
-			ptarget = plun->pTarget;
-			if (ptarget) {
-				/* flush the target */
-				lpfc_sli_abort_iocb_tgt(phba,
-				       &phba->sli.ring[phba->sli.fcp_ring],
-				       ptarget->scsi_id);
-			}
-
-			/* Done with piocbqrsp, return to free list */
-			if (piocbqrsp) {
-				mempool_free( piocbqrsp, phba->iocb_mem_pool);
-			}
-		} else {
+	if (!ret) {
+		ret =
+		    lpfc_sli_issue_iocb(phba,
+					&phba->sli.ring[psli->fcp_ring],
+					piocbq,
+					SLI_IOCB_HIGH_PRIORITY |
+					SLI_IOCB_RET_IOCB);
+		goto out;
+	}
 
-			ret =
-			    lpfc_sli_issue_iocb(phba,
-						&phba->sli.ring[psli->fcp_ring],
-						piocbq,
-						SLI_IOCB_HIGH_PRIORITY |
-						SLI_IOCB_RET_IOCB);
-			ret = (ret == IOCB_SUCCESS) ? 1 : 0;
-		}
+	psli = &phba->sli;
+	piocbq = &(lpfc_cmd->cur_iocbq);
+	/* get a buffer for this IOCB command response */
+	piocbqrsp = mempool_alloc(phba->iocb_mem_pool, GFP_ATOMIC);
+	if (!piocbqrsp)
+		return ENOMEM;
+	memset(piocbqrsp, 0, sizeof (struct lpfc_iocbq));
+
+	piocbq->iocb_flag |= LPFC_IO_POLL;
+	piocbq->iocb_cmpl = lpfc_sli_wake_iocb_high_priority;
+
+	ret = lpfc_sli_issue_iocb_wait_high_priority(phba,
+		     &phba->sli.ring[psli->fcp_ring],
+		     piocbq, SLI_IOCB_HIGH_PRIORITY,
+		     piocbqrsp,
+		     lpfc_cmd->timeout + LPFC_DRVR_TIMEOUT);
+
+	lpfc_cmd->result = piocbqrsp->iocb.un.ulpWord[4];
+	lpfc_cmd->status = piocbqrsp->iocb.ulpStatus;
+	if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT) {
+		if (lpfc_cmd->result & IOERR_DRVR_MASK)
+			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 	}
 
-	return (ret);
+	/* flush the target */
+	lpfc_sli_abort_iocb_tgt(phba,
+	       &phba->sli.ring[phba->sli.fcp_ring],
+	       ptarget->scsi_id);
+
+	/* Done with piocbqrsp, return to free list */
+	mempool_free(piocbqrsp, phba->iocb_mem_pool);
+ out:
+	return (ret == IOCB_SUCCESS) ? 1 : 0;
 }
 
-
-
 void
 lpfc_npr_timeout(unsigned long ptr)
 {
@@ -744,45 +585,56 @@
 }
 
 int
-lpfc_scsi_hba_reset(struct lpfc_hba * phba, LPFC_SCSI_BUF_t * lpfc_cmd)
+lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
 {
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
 	struct lpfc_target *ptarget;
 	int ret, i;
-	unsigned long iflag;
+	unsigned long flags;
 	struct scsi_cmnd *lnx_cmd;
 	struct scsi_device *scsi_dev;
+	LPFC_SCSI_BUF_t *lpfc_cmd;
+
+	lpfc_cmd = lpfc_get_scsi_buf(phba, GFP_ATOMIC);
+	if (!lpfc_cmd)
+		return FAILED;
 
 	lnx_cmd = kmalloc(sizeof(struct scsi_cmnd), GFP_ATOMIC);
 	if (lnx_cmd == 0) {
-		return (0);
+		return FAILED;
 	}
+
 	scsi_dev = kmalloc(sizeof(struct scsi_device), GFP_ATOMIC);
 	if (scsi_dev == 0) {
 		kfree(lnx_cmd);
-		return (0);
+		return FAILED;
 	}
+
 	lpfc_cmd->pCmd = lnx_cmd;
 	lpfc_cmd->pCmd->device = scsi_dev;
 
 	for (i = 0; i < MAX_FCP_TARGET; i++) {
-		spin_lock_irqsave(&(phba->drvrlock), iflag);
+		spin_lock_irqsave(&phba->drvrlock, flags);
 		ptarget = phba->device_queue_hash[i];
-		spin_unlock_irqrestore(&(phba->drvrlock), iflag);
-		if (ptarget) {
-			lpfc_cmd->scsi_hba = phba;
-			lpfc_cmd->pCmd->device->channel = 0;
-			lpfc_cmd->pCmd->device->id = i;
-			lpfc_cmd->pCmd->device->lun = 0;
-
-			ret = lpfc_scsi_tgt_reset(lpfc_cmd,
-						  phba, LPFC_EXTERNAL_RESET);
-			if (!ret) {
-				return (0);
-			}
-		}
+		spin_unlock_irqrestore(&phba->drvrlock, flags);
+		if (!ptarget)
+			continue;
+		lpfc_cmd->scsi_hba = phba;
+		lpfc_cmd->pCmd->device->channel = 0;
+		lpfc_cmd->pCmd->device->id = i;
+		lpfc_cmd->pCmd->device->lun = 0;
+
+		ret = lpfc_scsi_tgt_reset(lpfc_cmd, phba, ptarget);
+		if (!ret)
+			return FAILED;
 	}
 
-	return (1);
+	spin_lock_irqsave(&phba->drvrlock, flags);
+	lpfc_free_scsi_buf(lpfc_cmd);
+	spin_unlock_irqrestore(&phba->drvrlock, flags);
+
+	return SUCCESS;
 }
 
 LPFC_SCSI_BUF_t *
@@ -1323,99 +1175,71 @@
 }
 
 int
-lpfc_abort_handler(struct scsi_cmnd *cmnd)
-{
-	struct lpfc_hba *phba;
-	LPFC_SCSI_BUF_t *lpfc_cmd;
-	unsigned long iflag;
-	int rc;
-
-	phba = (struct lpfc_hba *) cmnd->device->host->hostdata[0];
-
-	spin_lock_irqsave(&(phba->drvrlock), iflag);
-
-	lpfc_cmd = (LPFC_SCSI_BUF_t *) cmnd->host_scribble;
-
-	/*
-	   If the command is in retry cahin. delete the command from the
-	   list.
-	 */
-	if (!lpfc_cmd) {
-
-		spin_unlock_irqrestore(&(phba->drvrlock), iflag);
-		return (0);
-	}
-
-	/* set command timeout to 60 seconds */
-	lpfc_cmd->timeout = 60;
-
-	/* SCSI layer issued abort device */
-	lpfc_printf_log(phba,
-			KERN_ERR,
-			LOG_FCP,
-			"0712 SCSI layer issued abort device Data: x%x x%x",
-			lpfc_cmd->pCmd->device->id,
-			lpfc_cmd->pCmd->device->lun);
-
-	/* tell low layer to abort it */
-	rc = lpfc_scsi_cmd_abort(phba, lpfc_cmd);
-
-	/* SCSI layer issued abort device */
-	lpfc_printf_log(phba,
-			KERN_INFO,
-			LOG_FCP,
-			"0749 Cmpl Abort Task Set Data: x%x x%x x%x x%x x%x",
-			lpfc_cmd->pCmd->device->id, lpfc_cmd->pCmd->device->lun,
-			rc, lpfc_cmd->status, lpfc_cmd->result);
-
-	spin_unlock_irqrestore(&(phba->drvrlock), iflag);
-
-	return ((rc == 0) ? SUCCESS : FAILURE);
-
-}
-
-/* This function is now OS-specific and driver-specific */
-
-int
 lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
 {
-	struct lpfc_hba *phba;
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
+	LPFC_SLI_t *psli = &phba->sli;
+	struct scsi_device *scsi_dev = cmnd->device;
+	struct lpfc_lun *plun = scsi_dev->hostdata;
 	LPFC_SCSI_BUF_t *lpfc_cmd;
-	int rc;
+	struct lpfc_iocbq *piocbq;
+	struct lpfc_iocbq *piocbqrsp = 0;
+	unsigned long iflag;
+	int ret = 0;
 
-	phba = (struct lpfc_hba *) cmnd->device->host->hostdata[0];
 	/* Get resources to send a SCSI command */
 	lpfc_cmd = lpfc_get_scsi_buf(phba, GFP_ATOMIC);
-	if (lpfc_cmd == 0) {
-		return (0);
-	}
-	lpfc_cmd->pCmd = cmnd;
-
-	/* set command timeout to 60 seconds */
-	lpfc_cmd->timeout = 60;
-
-	/* SCSI layer issued abort device */
-	lpfc_printf_log(phba,
-			KERN_ERR,
-			LOG_FCP,
-			"0713 SCSI layer issued Target Reset Data: x%x x%x",
-			lpfc_cmd->pCmd->device->id,
-			lpfc_cmd->pCmd->device->lun);
-
-	rc = lpfc_scsi_lun_reset(lpfc_cmd, phba,
-				 LPFC_EXTERNAL_RESET | LPFC_ISSUE_ABORT_TSET);
+	if (lpfc_cmd == 0)
+		return FAILED;
 
-	/* SCSI layer issued abort device */
-	lpfc_printf_log(phba,
-			KERN_INFO,
-			LOG_FCP,
-			"0747 Cmpl Target Reset Data: x%x x%x x%x x%x x%x",
-			lpfc_cmd->pCmd->device->id, lpfc_cmd->pCmd->device->lun,
-			rc, lpfc_cmd->status, lpfc_cmd->result);
+	lpfc_cmd->pCmd = cmnd;
+	lpfc_cmd->timeout = 60;	/* set command timeout to 60 seconds */
+	lpfc_cmd->scsi_hba = phba;
 
+	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, ABORT_TASK_SET);
+	if (!ret) {
+		ret = lpfc_sli_issue_iocb(phba,
+					&phba->sli.ring[psli->fcp_ring],
+					piocbq,
+					SLI_IOCB_HIGH_PRIORITY |
+					SLI_IOCB_RET_IOCB);
+		goto out;
+	}
+
+	piocbq = &lpfc_cmd->cur_iocbq;
+
+	/* get a buffer for this response IOCB command */
+	piocbqrsp = mempool_alloc(phba->iocb_mem_pool, GFP_ATOMIC);
+	if (!piocbqrsp)
+		return FAILED;
+	memset(piocbqrsp, 0, sizeof (struct lpfc_iocbq));
+
+	piocbq->iocb_flag |= LPFC_IO_POLL;
+	piocbq->iocb_cmpl = lpfc_sli_wake_iocb_high_priority;
+	ret = lpfc_sli_issue_iocb_wait_high_priority(phba,
+			     &phba->sli.ring[psli->fcp_ring],
+			     piocbq, SLI_IOCB_USE_TXQ,
+			     piocbqrsp, 60);	/* 60 secs */
+
+	lpfc_cmd->result = piocbqrsp->iocb.un.ulpWord[4];
+	lpfc_cmd->status = piocbqrsp->iocb.ulpStatus;
+	if (lpfc_cmd->status == IOSTAT_LOCAL_REJECT) {
+		if (lpfc_cmd->result & IOERR_DRVR_MASK)
+			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
+	}
 
+	/* flush outstanding commands on the lun */
+	spin_lock_irqsave(&(phba->drvrlock), iflag);
+	lpfc_sli_abort_iocb_lun(phba,
+			&phba->sli.ring[phba->sli.fcp_ring],
+			plun->pTarget->scsi_id,
+			plun->lun_id);
+	spin_unlock_irqrestore(&(phba->drvrlock), iflag);
 
-	return ((rc == 0) ? SUCCESS : FAILURE);
+	mempool_free(piocbqrsp, phba->iocb_mem_pool);
+ out:
+	return (ret == IOCB_SUCCESS) ? SUCCESS : FAILED;
 
 }
 
@@ -1858,8 +1682,7 @@
 				lnx_cmnd->resid);
 
 		scsi_dev = lnx_cmnd->device;
-		lun_device = lpfc_find_lun(phba, scsi_dev->id, scsi_dev->lun,
-					   1);
+		lun_device = scsi_dev->hostdata;
 		if (lnx_cmnd->result && lun_device &&
 		    (lun_device->pTarget->targetFlags & FC_NPR_ACTIVE)) {
 			lnx_cmnd->result =
diff -ur lpfcdriver-2.6-8.0.4/lpfc_sli.c lpfcdriver-2.6-8.0.4-hch/lpfc_sli.c
--- lpfcdriver-2.6-8.0.4/lpfc_sli.c	2004-06-15 00:07:02.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_sli.c	2004-06-20 15:23:40.068601312 +0200
@@ -27,8 +27,11 @@
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+
+#include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
 
 #include "lpfc_sli.h"
 #include "lpfc_disc.h"
@@ -3089,82 +3092,93 @@
 }
 
 int
-lpfc_sli_abort_iocb_context1(struct lpfc_hba * phba,
-			     struct lpfc_sli_ring * pring, void *ctx)
+lpfc_abort_handler(struct scsi_cmnd *cmnd)
 {
-	LPFC_SLI_t *psli;
-	struct lpfc_iocbq *iocb, *next_iocb;
-	struct lpfc_iocbq *abtsiocbp;
-	IOCB_t *icmd = 0, *cmd = 0;
-	int errcnt;
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata;
+	LPFC_SLI_t *psli = &phba->sli;
+	struct lpfc_sli_ring *pring = &psli->ring[psli->fcp_ring];
+	struct lpfc_iocbq *iocb, *next_iocb, *abtsiocbp;
+	LPFC_SCSI_BUF_t *lpfc_cmd;
+	IOCB_t *cmd = NULL, *icmd;
+	unsigned long flags;
+	int errcnt = 0;
 
-	psli = &phba->sli;
-	errcnt = 0;
+	spin_lock_irqsave(&phba->drvrlock, flags);
+	lpfc_cmd = (LPFC_SCSI_BUF_t *)cmnd->host_scribble;
 
-	/* Error matching iocb on txq or txcmplq
-	 * First check the txq.
+	/*
+	 * If the command is in retry cahin. delete the command from the list.
 	 */
+	if (!lpfc_cmd) {
+		spin_unlock_irqrestore(&phba->drvrlock, flags);
+		return FAILED;
+	}
+
+	/* set command timeout to 60 seconds */
+	lpfc_cmd->timeout = 60;
+
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
 		cmd = &iocb->iocb;
-		if (iocb->context1 != ctx) {
+		if (iocb->context1 != lpfc_cmd)
 			continue;
-		}
 
 		list_del_init(&iocb->list);
 		pring->txq_cnt--;
-		if (iocb->iocb_cmpl) {
-			icmd = &iocb->iocb;
-			icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		} else {
-			mempool_free( iocb, phba->iocb_mem_pool);
+		if (!iocb->iocb_cmpl) {
+			mempool_free(iocb, phba->iocb_mem_pool);
+			continue;
 		}
+
+		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
+		(iocb->iocb_cmpl)(phba, iocb, iocb);
 	}
 
 	/* Next check the txcmplq */
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
 		cmd = &iocb->iocb;
-		if (iocb->context1 != ctx) {
+		if (iocb->context1 != lpfc_cmd)
 			continue;
-		}
 
 		/* issue ABTS for this IOCB based on iotag */
-		if ((abtsiocbp = mempool_alloc(phba->iocb_mem_pool,
-					       GFP_ATOMIC)) == 0) {
+		abtsiocbp = mempool_alloc(phba->iocb_mem_pool, GFP_ATOMIC);
+		if (!abtsiocbp) {
 			errcnt++;
 			continue;
 		}
 		memset(abtsiocbp, 0, sizeof (struct lpfc_iocbq));
-		icmd = &abtsiocbp->iocb;
 
+		icmd = &abtsiocbp->iocb;
 		icmd->un.acxri.abortType = ABORT_TYPE_ABTS;
 		icmd->un.acxri.abortContextTag = cmd->ulpContext;
 		icmd->un.acxri.abortIoTag = cmd->ulpIoTag;
 
 		icmd->ulpLe = 1;
 		icmd->ulpClass = cmd->ulpClass;
-		if (phba->hba_state >= LPFC_LINK_UP) {
+		if (phba->hba_state >= LPFC_LINK_UP)
 			icmd->ulpCommand = CMD_ABORT_XRI_CN;
-		} else {
+		else
 			icmd->ulpCommand = CMD_CLOSE_XRI_CN;
-		}
 
 		/* set up an iotag  */
 		icmd->ulpIoTag = lpfc_sli_next_iotag(phba, pring);
 
-		if (lpfc_sli_issue_iocb
-		    (phba, pring, abtsiocbp, SLI_IOCB_USE_TXQ)
-		    == IOCB_ERROR) {
-			mempool_free( abtsiocbp, phba->iocb_mem_pool);
+		if (lpfc_sli_issue_iocb(phba, pring, abtsiocbp,
+					SLI_IOCB_USE_TXQ) == IOCB_ERROR) {
+			mempool_free(abtsiocbp, phba->iocb_mem_pool);
 			errcnt++;
 			continue;
 		}
-		/* The rsp ring completion will remove IOCB from txcmplq when
+
+		/*
+		 * The rsp ring completion will remove IOCB from txcmplq when
 		 * abort is read by HBA.
 		 */
 	}
-	return (errcnt);
+
+	spin_unlock_irqrestore(&phba->drvrlock, flags);
+	return errcnt ? FAILED : SUCCESS;
 }
 
 int
