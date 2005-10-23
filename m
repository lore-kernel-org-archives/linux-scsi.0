From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 2/2] HCIL drivers update
Date: Sun, 23 Oct 2005 15:52:07 -0400
Message-ID: <20051023195207.GB12102@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33511 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750740AbVJWTwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 15:52:08 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 7DF031C095A7
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 15:52:07 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9NJq7Jv012176
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 15:52:07 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


See patch 1/2 for description.  DO NOT APPLY.

 drivers/scsi/lpfc/lpfc_scsi.c         |   80 ++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_sli.c          |    7 +-
 drivers/scsi/megaraid/mega_common.h   |    8 +-
 drivers/scsi/megaraid/megaraid_mbox.c |    8 +-
 drivers/scsi/megaraid/megaraid_sas.c  |   14 ++---
 drivers/scsi/megaraid/megaraid_sas.h  |    6 +-
 drivers/scsi/pcmcia/nsp_cs.c          |   14 ++---
 drivers/scsi/pcmcia/sym53c500_cs.c    |    2 
 drivers/scsi/psi240i.c                |    4 -
 drivers/scsi/qla2xxx/qla_dbg.c        |    7 +-
 drivers/scsi/qla2xxx/qla_iocb.c       |    6 +-
 drivers/scsi/qla2xxx/qla_isr.c        |    7 +-
 drivers/scsi/qla2xxx/qla_mbx.c        |    2 
 drivers/scsi/qla2xxx/qla_os.c         |   43 ++++++---------
 drivers/scsi/scsi_scan.c              |    2 
 drivers/scsi/sym53c8xx_2/sym_glue.c   |   44 +++++++++------
 drivers/scsi/sym53c8xx_2/sym_hipd.c   |   94 ++++++++++++++++++----------------
 drivers/scsi/sym53c8xx_2/sym_hipd.h   |   13 +++-
 drivers/scsi/sym53c8xx_2/sym_misc.h   |   10 ++-
 drivers/usb/storage/dpcm.c            |   17 ++++--
 drivers/usb/storage/transport.c       |    4 -
 drivers/usb/storage/usb.c             |   22 +++++--
 include/scsi/scsi.h                   |    2 
 include/scsi/scsi_device.h            |   11 +++
 24 files changed, 250 insertions(+), 177 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b5ad187..a162174 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -370,6 +370,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
 	unsigned long iflag;
+	char lunstr[SCSILUN_STR_LEN];
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
@@ -382,10 +383,11 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			lpfc_cmd->status = IOSTAT_DEFAULT;
 
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
-				"%d:0729 FCP cmd x%x failed <%d/%d> status: "
+				"%d:0729 FCP cmd x%x failed <%d/%s> status: "
 				"x%x result: x%x Data: x%x x%x\n",
-				phba->brd_no, cmd->cmnd[0], cmd->device->id,
-				cmd->device->lun, lpfc_cmd->status,
+				phba->brd_no, cmd->cmnd[0], sdev_id(cmd->device),
+				scsilun_to_str(&cmd->device->lun, lunstr),
+				lpfc_cmd->status,
 				lpfc_cmd->result, pIocbOut->iocb.ulpContext,
 				lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
 
@@ -419,10 +421,11 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
-				"%d:0710 Iodone <%d/%d> cmd %p, error x%x "
+				"%d:0710 Iodone <%d/%s> cmd %p, error x%x "
 				"SNS x%x x%x Data: x%x x%x\n",
-				phba->brd_no, cmd->device->id,
-				cmd->device->lun, cmd, cmd->result,
+				phba->brd_no, sdev_id(cmd->device),
+				scsilun_to_str(&cmd->device->lun, lunstr),
+				cmd, cmd->result,
 				*lp, *(lp + 3), cmd->retries, cmd->resid);
 	}
 
@@ -448,8 +451,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_hba * ph
 	/* clear task management bits */
 	lpfc_cmd->fcp_cmnd->fcpCntl2 = 0;
 
-	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
-			&lpfc_cmd->fcp_cmnd->fcp_lun);
+	scsilun_cp(&lpfc_cmd->fcp_cmnd->fcp_lun, &lpfc_cmd->pCmd->device->lun);
 
 	memcpy(&fcp_cmnd->fcpCdb[0], scsi_cmnd->cmnd, 16);
 
@@ -538,6 +540,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	struct scsi_device *scsi_dev = lpfc_cmd->pCmd->device;
 	struct lpfc_rport_data *rdata = scsi_dev->hostdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
+	char lunstr[SCSILUN_STR_LEN];
 
 	if ((ndlp == 0) || (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
 		return 0;
@@ -548,8 +551,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	piocb = &piocbq->iocb;
 
 	fcp_cmnd = lpfc_cmd->fcp_cmnd;
-	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
-			&lpfc_cmd->fcp_cmnd->fcp_lun);
+	scsilun_cp(&lpfc_cmd->fcp_cmnd->fcp_lun, &lpfc_cmd->pCmd->device->lun);
 	fcp_cmnd->fcpCntl2 = task_mgmt_cmd;
 
 	piocb->ulpCommand = CMD_FCP_ICMND64_CR;
@@ -579,10 +581,11 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		lpfc_printf_log(phba,
 				KERN_INFO,
 				LOG_FCP,
-				"%d:0703 Issue LUN Reset to TGT %d LUN %d "
+				"%d:0703 Issue LUN Reset to TGT %d LUN %s "
 				"Data: x%x x%x\n",
 				phba->brd_no,
-				scsi_dev->id, scsi_dev->lun,
+				sdev_id(scsi_dev),
+				scsilun_to_str(&scsi_dev->lun, lunstr),
 				ndlp->nlp_rpi, ndlp->nlp_flag);
 
 		break;
@@ -591,10 +594,11 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		lpfc_printf_log(phba,
 				KERN_INFO,
 				LOG_FCP,
-				"%d:0701 Issue Abort Task Set to TGT %d LUN %d "
+				"%d:0701 Issue Abort Task Set to TGT %d LUN %s "
 				"Data: x%x x%x\n",
 				phba->brd_no,
-				scsi_dev->id, scsi_dev->lun,
+				sdev_id(scsi_dev),
+				scsilun_to_str(&scsi_dev->lun, lunstr),
 				ndlp->nlp_rpi, ndlp->nlp_flag);
 
 		break;
@@ -606,7 +610,8 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 				"%d:0702 Issue Target Reset to TGT %d "
 				"Data: x%x x%x\n",
 				phba->brd_no,
-				scsi_dev->id, ndlp->nlp_rpi,
+				sdev_id(scsi_dev),
+				ndlp->nlp_rpi,
 				ndlp->nlp_flag);
 		break;
 	}
@@ -657,8 +662,9 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 	 * to double check.
 	 */
 	lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-			    lpfc_cmd->pCmd->device->id,
-			    lpfc_cmd->pCmd->device->lun, 0, LPFC_CTX_TGT);
+			    sdev_id(lpfc_cmd->pCmd->device),
+			    scsilun_to_int(&lpfc_cmd->pCmd->device->lun),
+			    0, LPFC_CTX_TGT);
 
 	/* Return response IOCB to free list. */
 	list_add_tail(&iocbqrsp->list, lpfc_iocb_list);
@@ -828,8 +834,8 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 		return SUCCESS;
 
 	/* save these now since lpfc_cmd can be freed */
-	id   = lpfc_cmd->pCmd->device->id;
-	lun  = lpfc_cmd->pCmd->device->lun;
+	id   = sdev_id(lpfc_cmd->pCmd->device);
+	lun  = scsilun_to_int(&lpfc_cmd->pCmd->device->lun);
 	snum = lpfc_cmd->pCmd->serial_number;
 
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
@@ -947,6 +953,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	int ret = FAILED;
 	int cnt, loopcnt;
+	char lunstr[SCSILUN_STR_LEN];
 
 	/*
 	 * If target is not in a MAPPED state, delay the reset until
@@ -1008,13 +1015,15 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 	 * to double check.
 	 */
 	lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-			    cmnd->device->id, cmnd->device->lun, 0,
+			    sdev_id(cmnd->device),
+			    scsilun_to_int(&cmnd->device->lun), 0,
 			    LPFC_CTX_LUN);
 
 	loopcnt = 0;
 	while((cnt = lpfc_sli_sum_iocb(phba,
 				       &phba->sli.ring[phba->sli.fcp_ring],
-				       cmnd->device->id, cmnd->device->lun,
+				       sdev_id(cmnd->device),
+				       scsilun_to_int(&cmnd->device->lun),
 				       LPFC_CTX_LUN))) {
 		spin_unlock_irq(phba->host->host_lock);
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -1036,10 +1045,12 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 
 out_free_scsi_buf:
 	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-			"%d:0713 SCSI layer issued LUN reset (%d, %d) "
+			"%d:0713 SCSI layer issued LUN reset (%d, %s) "
 			"Data: x%x x%x x%x\n",
-			phba->brd_no, lpfc_cmd->pCmd->device->id,
-			lpfc_cmd->pCmd->device->lun, ret, lpfc_cmd->status,
+			phba->brd_no,
+			sdev_id(lpfc_cmd->pCmd->device),
+			scsilun_to_str(&lpfc_cmd->pCmd->device->lun, lunstr),
+			ret, lpfc_cmd->status,
 			lpfc_cmd->result);
 	lpfc_free_scsi_buf(lpfc_cmd);
 out:
@@ -1086,7 +1097,7 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 	 * targets known to the driver.  Should any target reset
 	 * fail, this routine returns failure to the midlayer.
 	 */
-	midlayer_id = cmnd->device->id;
+	midlayer_id = sdev_id(cmnd->device);
 	for (i = 0; i < MAX_FCP_TARGET; i++) {
 		/* Search the mapped list for this target ID */
 		match = 0;
@@ -1099,7 +1110,14 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 		if (!match)
 			continue;
 
-		lpfc_cmd->pCmd->device->id = i;
+		/* FIXME: what is this doing?  presumably,
+		 * sdev->id == sdev->sdev_target->id, but the following
+		 * code breaks that assumption.  We guess at a fix,
+		 * for now.
+		 */
+		/* PREV: lpfc_cmd->pCmd->device->id = i; */
+		lpfc_cmd->pCmd->device->sdev_target->id = i;
+
 		lpfc_cmd->pCmd->device->hostdata = ndlp->rport->dd_data;
 		ret = lpfc_scsi_tgt_reset(lpfc_cmd, phba);
 		if (ret != SUCCESS) {
@@ -1110,7 +1128,13 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 		}
 	}
 
-	cmnd->device->id = midlayer_id;
+	/* FIXME: what is this doing?  presumably,
+	 * sdev->id == sdev->sdev_target->id, but the following
+	 * code breaks that assumption.  We guess at a fix,
+	 * for now.
+	 */
+	/* PREV: cmnd->device->id = midlayer_id; */
+	cmnd->device->sdev_target->id = midlayer_id;
 	loopcnt = 0;
 	while((cnt = lpfc_sli_sum_iocb(phba,
 				&phba->sli.ring[phba->sli.fcp_ring],
@@ -1190,7 +1214,7 @@ lpfc_slave_alloc(struct scsi_device *sde
 		if (list_empty(listp))
 			continue;
 		list_for_each_entry(ndlp, listp, nlp_listp) {
-			if ((sdev->id == ndlp->nlp_sid) && ndlp->rport) {
+			if ((sdev_id(sdev) == ndlp->nlp_sid) && ndlp->rport) {
 				match = 1;
 				break;
 			}
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e74e224..153c69a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2504,12 +2504,13 @@ lpfc_sli_validate_iocb_cmd(struct lpfc_s
 
 	switch (ctx_cmd) {
 	case LPFC_CTX_LUN:
-		if ((lpfc_cmd->pCmd->device->id == tgt_id) &&
-		    (lpfc_cmd->pCmd->device->lun == lun_id))
+		/* FIXME: use scsilun_eq() */
+		if ((sdev_id(lpfc_cmd->pCmd->device) == tgt_id) &&
+		    (scsilun_to_int(&lpfc_cmd->pCmd->device->lun) == lun_id))
 			rc = 0;
 		break;
 	case LPFC_CTX_TGT:
-		if (lpfc_cmd->pCmd->device->id == tgt_id)
+		if (sdev_id(lpfc_cmd->pCmd->device) == tgt_id)
 			rc = 0;
 		break;
 	case LPFC_CTX_CTX:
diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 69df1a9..87b3ec7 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -199,9 +199,9 @@ typedef struct {
 // conversion from scsi command
 #define SCP2HOST(scp)			(scp)->device->host	// to host
 #define SCP2HOSTDATA(scp)		SCP2HOST(scp)->hostdata	// to soft state
-#define SCP2CHANNEL(scp)		(scp)->device->channel	// to channel
-#define SCP2TARGET(scp)			(scp)->device->id	// to target
-#define SCP2LUN(scp)			(scp)->device->lun	// to LUN
+#define SCP2CHANNEL(scp)		sdev_channel((scp)->device) // to channel
+#define SCP2TARGET(scp)			sdev_id((scp)->device)	// to target
+#define SCP2LUN(scp)			scsilun_to_int(&(scp)->device->lun) // to LUN
 
 // generic macro to convert scsi command and host to controller's soft state
 #define SCSIHOST2ADAP(host)	(((caddr_t *)(host->hostdata))[0])
@@ -223,7 +223,7 @@ typedef struct {
 	(SCP2CHANNEL(scp) == (adp)->max_channel) ? 1 : 0
 
 #define MRAID_IS_LOGICAL_SDEV(adp, sdev)	\
-	(sdev->channel == (adp)->max_channel) ? 1 : 0
+	(sdev_channel(sdev) == (adp)->max_channel) ? 1 : 0
 
 #define MRAID_GET_DEVICE_MAP(adp, scp, p_chan, target, islogical)	\
 	/*								\
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index d47be8e..6749b34 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1712,7 +1712,7 @@ megaraid_mbox_build_cmd(adapter_t *adapt
 			 * Do not allow LUN > 0 for logical drives and
 			 * requests for more than 40 logical drives
 			 */
-			if (SCP2LUN(scp)) {
+			if (!scsilun_zero(&scp->device->lun)) {
 				scp->result = (DID_BAD_TARGET << 16);
 				return NULL;
 			}
@@ -4165,15 +4165,15 @@ megaraid_sysfs_show_ldnum(struct device 
 
 			for (i = 0; i < MAX_LOGICAL_DRIVES_40LD; i++) {
 
-				mapped_sdev_id = sdev->id;
+				mapped_sdev_id = sdev_id(sdev);
 
-				if (sdev->id > adapter->init_id) {
+				if (sdev_id(sdev) > adapter->init_id) {
 					mapped_sdev_id -= 1;
 				}
 
 				if (raid_dev->curr_ldmap[i] == mapped_sdev_id) {
 
-					scsi_id = sdev->id;
+					scsi_id = sdev_id(sdev);
 
 					logical_drv = i;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index c3f6373..8dcec7c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -389,7 +389,7 @@ megasas_build_dcdb(struct megasas_instan
 	pthru->cmd_status = 0x0;
 	pthru->scsi_status = 0x0;
 	pthru->target_id = device_id;
-	pthru->lun = scp->device->lun;
+	pthru->lun = scsilun_to_int(&scp->device->lun);
 	pthru->cdb_len = scp->cmd_len;
 	pthru->timeout = 0;
 	pthru->flags = flags;
@@ -581,7 +581,7 @@ static inline struct megasas_cmd *megasa
 	 */
 	if (logical_cmd) {
 
-		if (scp->device->id >= MEGASAS_MAX_LD) {
+		if (sdev_id(scp->device) >= MEGASAS_MAX_LD) {
 			scp->result = DID_BAD_TARGET << 16;
 			return NULL;
 		}
@@ -599,7 +599,7 @@ static inline struct megasas_cmd *megasa
 			/*
 			 * Fail for LUN > 0
 			 */
-			if (scp->device->lun) {
+			if (!scsilun_zero(&scp->device->lun)) {
 				scp->result = DID_BAD_TARGET << 16;
 				return NULL;
 			}
@@ -624,7 +624,7 @@ static inline struct megasas_cmd *megasa
 			/*
 			 * Fail for LUN > 0
 			 */
-			if (scp->device->lun) {
+			if (!scsilun_zero(&scp->device->lun)) {
 				scp->result = DID_BAD_TARGET << 16;
 				return NULL;
 			}
@@ -758,9 +758,9 @@ static int megasas_generic_reset(struct 
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
-	printk(KERN_NOTICE "megasas: RESET -%ld cmd=%x <c=%d t=%d l=%d>\n",
-	       scmd->serial_number, scmd->cmnd[0], scmd->device->channel,
-	       scmd->device->id, scmd->device->lun);
+	dev_printk(KERN_NOTICE, &scmd->device->sdev_gendev,
+		"megasas: RESET -%ld cmd=%x\n",
+	       scmd->serial_number, scmd->cmnd[0]);
 
 	if (instance->hw_crit_error) {
 		printk(KERN_ERR "megasas: cannot recover from previous reset "
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index eaec9d5..f86a80d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1059,11 +1059,11 @@ struct megasas_instance {
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\
-	(scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
+	(sdev_channel(scp->device) < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
 
 #define MEGASAS_DEV_INDEX(inst, scp)					\
-	((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + 	\
-	scp->device->id
+	((sdev_channel(scp->device) % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + \
+	sdev_id(scp->device)
 
 struct megasas_cmd {
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 3cd3b40..b5fb13d 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -201,7 +201,7 @@ static int nsp_queuecommand(Scsi_Cmnd *S
 #ifdef NSP_DEBUG
 	/*unsigned int host_id = SCpnt->device->host->this_id;*/
 	/*unsigned int base    = SCpnt->device->host->io_port;*/
-	unsigned char target = SCpnt->device->id;
+	unsigned char target = sdev_id(SCpnt->device);
 #endif
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 
@@ -373,7 +373,7 @@ static int nsphw_start_selection(Scsi_Cm
 {
 	unsigned int  host_id	 = SCpnt->device->host->this_id;
 	unsigned int  base	 = SCpnt->device->host->io_port;
-	unsigned char target	 = SCpnt->device->id;
+	unsigned char target	 = sdev_id(SCpnt->device);
 	nsp_hw_data  *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	int	      time_out;
 	unsigned char phase, arbit;
@@ -452,7 +452,7 @@ static struct nsp_sync_table nsp_sync_ta
  */
 static int nsp_analyze_sdtr(Scsi_Cmnd *SCpnt)
 {
-	unsigned char	       target = SCpnt->device->id;
+	unsigned char	       target = sdev_id(SCpnt->device);
 //	unsigned char	       lun    = SCpnt->device->lun;
 	nsp_hw_data           *data   = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	sync_data	      *sync   = &(data->Sync[target]);
@@ -677,7 +677,7 @@ static int nsp_reselected(Scsi_Cmnd *SCp
 		target++;
 	}
 
-	if (SCpnt->device->id != target) {
+	if (sdev_id(SCpnt->device) != target) {
 		nsp_msg(KERN_ERR, "XXX: reselect ID must be %d in this implementation.", target);
 	}
 
@@ -912,7 +912,7 @@ static void nsp_pio_write(Scsi_Cmnd *SCp
 static int nsp_nexus(Scsi_Cmnd *SCpnt)
 {
 	unsigned int   base   = SCpnt->device->host->io_port;
-	unsigned char  target = SCpnt->device->id;
+	unsigned char  target = sdev_id(SCpnt->device);
 //	unsigned char  lun    = SCpnt->device->lun;
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
 	sync_data     *sync   = &(data->Sync[target]);
@@ -1051,8 +1051,8 @@ static irqreturn_t nspintr(int irq, void
 	}
 
 	tmpSC    = data->CurrentSC;
-	target   = tmpSC->device->id;
-	lun      = tmpSC->device->lun;
+	target   = sdev_id(tmpSC->device);
+	lun      = scsilun_to_int(&tmpSC->device->lun);
 	sync_neg = &(data->Sync[target].SyncNegotiation);
 
 	/*
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index b4b3a1a..11ee73e 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -610,7 +610,7 @@ SYM53C500_queue(struct scsi_cmnd *SCpnt,
 
 	/* We are locked here already by the mid layer */
 	REG0(port_base);
-	outb(SCpnt->device->id, port_base + DEST_ID);	/* set destination */
+	outb(sdev_id(SCpnt->device), port_base + DEST_ID);	/* set destination */
 	outb(FLUSH_FIFO, port_base + CMD_REG);	/* reset the fifos */
 
 	for (i = 0; i < SCpnt->cmd_len; i++) {
diff --git a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
index 0f576d4..2a673de 100644
--- a/drivers/scsi/psi240i.c
+++ b/drivers/scsi/psi240i.c
@@ -394,7 +394,7 @@ static int Psi240i_QueueCommand (Scsi_Cm
 	{
 	UCHAR		   *cdb = (UCHAR *)SCpnt->cmnd;					// Pointer to SCSI CDB
 	PADAPTER240I	padapter = HOSTDATA (SCpnt->device->host); 			// Pointer to adapter control structure
-	POUR_DEVICE 		pdev	 = &padapter->device [SCpnt->device->id];// Pointer to device information
+	POUR_DEVICE 		pdev	 = &padapter->device [sdev_id(SCpnt->device)];// Pointer to device information
 	UCHAR			rc;											// command return code
 
 	SCpnt->scsi_done = done;
@@ -659,7 +659,7 @@ static int Psi240i_BiosParam (struct scs
 	{
 	POUR_DEVICE	pdev;
 
-	pdev = &(HOSTDATA(sdev->host)->device[sdev->id]);
+	pdev = &(HOSTDATA(sdev->host)->device[sdev_id(sdev)]);
 
 	geom[0] = pdev->heads;
 	geom[1] = pdev->sectors;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 9791496..3590a46 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1985,9 +1985,10 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd 
 	ha = (struct scsi_qla_host *)cmd->device->host->hostdata;
 
 	sp = (srb_t *) cmd->SCp.ptr;
-	printk("SCSI Command @=0x%p, Handle=0x%p\n", cmd, cmd->host_scribble);
-	printk("  chan=0x%02x, target=0x%02x, lun=0x%02x, cmd_len=0x%02x\n",
-	    cmd->device->channel, cmd->device->id, cmd->device->lun,
+	dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+		"SCSI Command @=0x%p, Handle=0x%p\n", cmd, cmd->host_scribble);
+	dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+		"  cmd_len=0x%02x\n",
 	    cmd->cmd_len);
 	printk(" CDB: ");
 	for (i = 0; i < cmd->cmd_len; i++) {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 37f82e2..307c7da 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -397,7 +397,7 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Set target ID and LUN number*/
 	SET_TARGET_ID(ha, cmd_pkt->target, sp->fcport->loop_id);
-	cmd_pkt->lun = cpu_to_le16(sp->cmd->device->lun);
+	cmd_pkt->lun = cpu_to_le16(scsilun_to_int(&sp->cmd->device->lun));
 
 	/* Update tagged queuing modifier */
 	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
@@ -834,8 +834,8 @@ qla24xx_start_scsi(srb_t *sp)
 	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
 	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
 
-	cmd_pkt->lun[1] = LSB(sp->cmd->device->lun);
-	cmd_pkt->lun[2] = MSB(sp->cmd->device->lun);
+	cmd_pkt->lun[1] = LSB(scsilun_to_int(&sp->cmd->device->lun));
+	cmd_pkt->lun[2] = MSB(scsilun_to_int(&sp->cmd->device->lun));
 
 	/* Update tagged queuing modifier -- default is TSK_SIMPLE (0). */
 	if (scsi_populate_tag_msg(cmd, tag)) {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c255bb0..a51235d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1034,11 +1034,10 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			if ((unsigned)(cp->request_bufflen - resid) <
 			    cp->underflow) {
 				qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
+				    "Mid-layer underflow "
 				    "detected (%x of %x bytes)...returning "
-				    "error status.\n", ha->host_no,
-				    cp->device->channel, cp->device->id,
-				    cp->device->lun, resid,
+				    "error status.\n",
+				    resid,
 				    cp->request_bufflen);
 
 				cp->result = DID_ERROR << 16;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 13e1c90..6e511b8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -904,7 +904,7 @@ qla2x00_abort_command(scsi_qla_host_t *h
 		mcp->mb[1] = fcport->loop_id << 8;
 	mcp->mb[2] = (uint16_t)handle;
 	mcp->mb[3] = (uint16_t)(handle >> 16);
-	mcp->mb[6] = (uint16_t)sp->cmd->device->lun;
+	mcp->mb[6] = (uint16_t)scsilun_to_int(&sp->cmd->device->lun);
 	mcp->out_mb = MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = 30;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8982978..588aa08 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -617,7 +617,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
 	srb_t *sp;
 	int ret, i;
-	unsigned int id, lun;
+	unsigned int id;
 	unsigned long serial;
 	unsigned long flags;
 
@@ -626,8 +626,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 	ret = FAILED;
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
+	id = sdev_id(cmd->device);
 	serial = cmd->serial_number;
 
 	/* Check active list for command command. */
@@ -665,14 +664,13 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	if (ret == SUCCESS) {
 		if (qla2x00_eh_wait_on_command(ha, cmd) != QLA_SUCCESS) {
 			qla_printk(KERN_ERR, ha,
-			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
-			    "%x.\n", ha->host_no, id, lun, serial, ret);
+			    "Abort handler timed out -- %lx "
+			    "%x.\n", serial, ret);
 		}
 	}
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): Abort command issued -- %lx %x.\n", ha->host_no,
-	    id, lun, serial, ret);
+	qla_printk(KERN_INFO, ha, "Abort command issued -- %lx %x.\n",
+	    serial, ret);
 
 	return ret;
 }
@@ -712,7 +710,7 @@ qla2x00_eh_wait_for_pending_target_comma
 		if (sp) {
 			cmd = sp->cmd;
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			if (cmd->device->id == t) {
+			if (sdev_id(cmd->device) == t) {
 				if (!qla2x00_eh_wait_on_command(ha, cmd)) {
 					status = 1;
 					break;
@@ -752,21 +750,19 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int ret;
-	unsigned int id, lun;
+	unsigned int id;
 	unsigned long serial;
 
 	ret = FAILED;
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
+	id = sdev_id(cmd->device);
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
 	if (!sp || !fcport)
 		return ret;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): DEVICE RESET ISSUED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, ha, "DEVICE RESET ISSUED.\n");
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
 		goto eh_dev_reset_done;
@@ -816,8 +812,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 		}
 	}
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): DEVICE RESET SUCCEEDED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, ha, "DEVICE RESET SUCCEEDED.\n");
 
 eh_dev_reset_done:
 	return ret;
@@ -893,21 +888,19 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int ret;
-	unsigned int id, lun;
+	unsigned int id;
 	unsigned long serial;
 
 	ret = FAILED;
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
+	id = sdev_id(cmd->device);
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
 	if (!sp || !fcport)
 		return ret;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): LOOP RESET ISSUED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, ha, "LOOP RESET ISSUED.\n");
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
 		DEBUG2(printk("%s failed:board disabled\n",__func__));
@@ -955,21 +948,19 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	srb_t *sp;
 	int ret;
-	unsigned int id, lun;
+	unsigned int id;
 	unsigned long serial;
 
 	ret = FAILED;
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
+	id = sdev_id(cmd->device);
 	serial = cmd->serial_number;
 
 	sp = (srb_t *) CMD_SP(cmd);
 	if (!sp || !fcport)
 		return ret;
 
-	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", ha->host_no, id, lun);
+	qla_printk(KERN_INFO, ha, "ADAPTER RESET ISSUED.\n");
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
 		goto eh_host_reset_lock;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2edf967..df9fa91 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -215,7 +215,7 @@ static struct scsi_device *scsi_alloc_sd
 	sdev->model = scsi_null_device_strs;
 	sdev->rev = scsi_null_device_strs;
 	sdev->host = shost;
-	memcpy(&sdev->lun, lun, sizeof(*lun));
+	scsilun_cp(&sdev->lun, lun);
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d76766c..2ce0f7f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -357,7 +357,7 @@ void sym_set_cam_result_error(struct sym
 			 * condition otherwise the device will always return
 			 * BUSY.  Use a big stick.
 			 */
-			sym_reset_scsi_target(np, cmd->device->id);
+			sym_reset_scsi_target(np, sdev_id(cmd->device));
 			cam_status = DID_ERROR;
 		}
 	} else if (cp->host_status == HS_COMPLETE) 	/* Bad SCSI status */
@@ -470,7 +470,7 @@ static int sym_queue_command(struct sym_
 	 *  Minimal checkings, so that we will not 
 	 *  go outside our tables.
 	 */
-	if (sdev->id == np->myaddr) {
+	if (sdev_id(sdev) == np->myaddr) {
 		sym_xpt_done2(np, cmd, DID_NO_CONNECT);
 		return 0;
 	}
@@ -478,12 +478,12 @@ static int sym_queue_command(struct sym_
 	/*
 	 *  Retrieve the target descriptor.
 	 */
-	tp = &np->target[sdev->id];
+	tp = &np->target[sdev_id(sdev)];
 
 	/*
 	 *  Select tagged/untagged.
 	 */
-	lp = sym_lp(tp, sdev->lun);
+	lp = sym_lp(tp, &sdev->lun);
 	order = (lp && lp->s.reqtags) ? M_SIMPLE_TAG : 0;
 
 	/*
@@ -516,7 +516,7 @@ int sym_setup_data_and_start(struct sym_
 {
 	int dir;
 	struct sym_tcb *tp = &np->target[cp->target];
-	struct sym_lcb *lp = sym_lp(tp, cp->lun);
+	struct sym_lcb *lp = sym_lp(tp, &cp->lun);
 
 	/*
 	 *  Build the CDB.
@@ -804,7 +804,7 @@ prepare:
 		sts = sym_abort_scsiio(np, cmd, 1);
 		break;
 	case SYM_EH_DEVICE_RESET:
-		sts = sym_reset_scsi_target(np, cmd->device->id);
+		sts = sym_reset_scsi_target(np, sdev_id(cmd->device));
 		break;
 	case SYM_EH_BUS_RESET:
 		sym_reset_scsi_bus(np, 1);
@@ -901,7 +901,8 @@ static int sym53c8xx_eh_host_reset_handl
 /*
  *  Tune device queuing depth, according to various limits.
  */
-static void sym_tune_dev_queuing(struct sym_tcb *tp, int lun, u_short reqtags)
+static void sym_tune_dev_queuing(struct sym_tcb *tp,
+				const struct scsi_lun *lun, u_short reqtags)
 {
 	struct sym_lcb *lp = sym_lp(tp, lun);
 	u_short	oldtags;
@@ -984,11 +985,12 @@ static int sym53c8xx_slave_alloc(struct 
 	struct sym_hcb *np;
 	struct sym_tcb *tp;
 
-	if (sdev->id >= SYM_CONF_MAX_TARGET || sdev->lun >= SYM_CONF_MAX_LUN)
+	if (sdev_id(sdev) >= SYM_CONF_MAX_TARGET ||
+	    scsilun_to_int(&sdev->lun) >= SYM_CONF_MAX_LUN)
 		return -ENXIO;
 
 	np = sym_get_hcb(sdev->host);
-	tp = &np->target[sdev->id];
+	tp = &np->target[sdev_id(sdev)];
 
 	/*
 	 * Fail the device init if the device is flagged NOSCAN at BOOT in
@@ -1000,7 +1002,7 @@ static int sym53c8xx_slave_alloc(struct 
 	 */
 
 	if ((tp->usrflags & SYM_SCAN_BOOT_DISABLED) ||
-	    ((tp->usrflags & SYM_SCAN_LUNS_DISABLED) && sdev->lun != 0)) {
+	    ((tp->usrflags & SYM_SCAN_LUNS_DISABLED) && !scsilun_zero(&sdev->lun))) {
 		tp->usrflags &= ~SYM_SCAN_BOOT_DISABLED;
 		return -ENXIO;
 	}
@@ -1015,7 +1017,7 @@ static int sym53c8xx_slave_alloc(struct 
 static int sym53c8xx_slave_configure(struct scsi_device *device)
 {
 	struct sym_hcb *np = sym_get_hcb(device->host);
-	struct sym_tcb *tp = &np->target[device->id];
+	struct sym_tcb *tp = &np->target[sdev_id(device)];
 	struct sym_lcb *lp;
 	int reqtags, depth_to_use;
 
@@ -1023,7 +1025,7 @@ static int sym53c8xx_slave_configure(str
 	 *  Allocate the LCB if not yet.
 	 *  If it fail, we may well be in the sh*t. :)
 	 */
-	lp = sym_alloc_lcb(np, device->id, device->lun);
+	lp = sym_alloc_lcb(np, sdev_id(device), &device->lun);
 	if (!lp)
 		return -ENOMEM;
 
@@ -1038,7 +1040,8 @@ static int sym53c8xx_slave_configure(str
 	 *  Use at least 2.
 	 *  Donnot use more than our maximum.
 	 */
-	reqtags = device_queue_depth(np, device->id, device->lun);
+	reqtags = device_queue_depth(np, sdev_id(device),
+				scsilun_to_int(&device->lun));
 	if (reqtags > tp->usrtags)
 		reqtags = tp->usrtags;
 	if (!device->tagged_supported)
@@ -1055,7 +1058,7 @@ static int sym53c8xx_slave_configure(str
 				 MSG_SIMPLE_TAG : 0),
 				depth_to_use);
 	lp->s.scdev_depth = depth_to_use;
-	sym_tune_dev_queuing(tp, device->lun, reqtags);
+	sym_tune_dev_queuing(tp, &device->lun, reqtags);
 
 	if (!spi_initial_dv(device->sdev_target))
 		spi_dv_device(device);
@@ -1157,8 +1160,11 @@ static void sym_exec_user_command (struc
 				tp->tgoal.check_nego = 1;
 				break;
 			case UC_SETTAGS:
-				for (l = 0; l < SYM_CONF_MAX_LUN; l++)
-					sym_tune_dev_queuing(tp, l, uc->data);
+				for (l = 0; l < SYM_CONF_MAX_LUN; l++) {
+					struct scsi_lun __l;
+					int_to_scsilun(l, &__l);
+					sym_tune_dev_queuing(tp, &__l,uc->data);
+				}
 				break;
 			case UC_RESETDEV:
 				tp->to_reset = 1;
@@ -1167,7 +1173,11 @@ static void sym_exec_user_command (struc
 				break;
 			case UC_CLEARDEV:
 				for (l = 0; l < SYM_CONF_MAX_LUN; l++) {
-					struct sym_lcb *lp = sym_lp(tp, l);
+					struct scsi_lun __l;
+					struct sym_lcb *lp;
+
+					int_to_scsilun(l, &__l);
+					lp = sym_lp(tp, &__l);
 					if (lp) lp->to_clear = 1;
 				}
 				np->istat_sem = SEM;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index e753ba2..68f7b97 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -51,7 +51,7 @@ static void sym_int_ma (struct sym_hcb *
 static void sym_int_sir (struct sym_hcb *np);
 static struct sym_ccb *sym_alloc_ccb(struct sym_hcb *np);
 static struct sym_ccb *sym_ccb_from_dsa(struct sym_hcb *np, u32 dsa);
-static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, u_char ln);
+static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, const struct scsi_lun *ln);
 static void sym_complete_error (struct sym_hcb *np, struct sym_ccb *cp);
 static void sym_complete_ok (struct sym_hcb *np, struct sym_ccb *cp);
 static int sym_compute_residual(struct sym_hcb *np, struct sym_ccb *cp);
@@ -1697,7 +1697,7 @@ static void sym_flush_comp_queue(struct 
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 		if (sym_get_cam_status(cmd) == DID_SOFT_ERROR) {
 			struct sym_tcb *tp = &np->target[cp->target];
-			struct sym_lcb *lp = sym_lp(tp, cp->lun);
+			struct sym_lcb *lp = sym_lp(tp, &cp->lun);
 			if (lp) {
 				sym_remque(&cp->link2_ccbq);
 				sym_insque_tail(&cp->link2_ccbq,
@@ -2706,7 +2706,7 @@ unexpected_phase:
 		if	(dsp == SCRIPTA_BA(np, send_ident)) {
 			if (cp->tag != NO_TAG && olen - rest <= 3) {
 				cp->host_status = HS_BUSY;
-				np->msgout[0] = IDENTIFY(0, cp->lun);
+				np->msgout[0] = IDENTIFY(0, &cp->lun);
 				nxtdsp = SCRIPTB_BA(np, ident_break_atn);
 			}
 			else
@@ -2956,7 +2956,8 @@ unknown_int:
  *  It is called with SCRIPTS not running.
  */
 static int 
-sym_dequeue_from_squeue(struct sym_hcb *np, int i, int target, int lun, int task)
+sym_dequeue_from_squeue(struct sym_hcb *np, int i, int target,
+			const struct scsi_lun *lun, int task)
 {
 	int j;
 	struct sym_ccb *cp;
@@ -2979,7 +2980,7 @@ sym_dequeue_from_squeue(struct sym_hcb *
 		cp->host_flags &= ~HF_HINT_IARB;
 #endif
 		if ((target == -1 || cp->target == target) &&
-		    (lun    == -1 || cp->lun    == lun)    &&
+		    (lun  == NULL || scsilun_eq(&cp->lun, lun))    &&
 		    (task   == -1 || cp->tag    == task)) {
 			sym_set_cam_status(cp->cmd, DID_SOFT_ERROR);
 			sym_remque(&cp->link_ccbq);
@@ -3066,7 +3067,7 @@ static void sym_sir_bad_scsi_status(stru
 		 *  Dequeue all queued CCBs for that device not yet started,
 		 *  and restart the SCRIPTS processor immediately.
 		 */
-		sym_dequeue_from_squeue(np, i, cp->target, cp->lun, -1);
+		sym_dequeue_from_squeue(np, i, cp->target, &cp->lun, -1);
 		OUTL_DSP(np, SCRIPTA_BA(np, start));
 
  		/*
@@ -3082,7 +3083,7 @@ static void sym_sir_bad_scsi_status(stru
 		 *  requesting sense data.
 		 */
 
-		cp->scsi_smsg2[0] = IDENTIFY(0, cp->lun);
+		cp->scsi_smsg2[0] = IDENTIFY(0, &cp->lun);
 		msglen = 1;
 
 		/*
@@ -3114,8 +3115,9 @@ static void sym_sir_bad_scsi_status(stru
 		 */
 		cp->sensecmd[0]		= REQUEST_SENSE;
 		cp->sensecmd[1]		= 0;
-		if (cp->cmd->device->scsi_level <= SCSI_2 && cp->lun <= 7)
-			cp->sensecmd[1]	= cp->lun << 5;
+		if (cp->cmd->device->scsi_level <= SCSI_2 &&
+		    scsilun_to_int(&cp->lun) <= 7)
+			cp->sensecmd[1]	= scsilun_to_int(&cp->lun) << 5;
 		cp->sensecmd[4]		= SYM_SNS_BBUF_LEN;
 		cp->data_len		= SYM_SNS_BBUF_LEN;
 
@@ -3172,7 +3174,8 @@ static void sym_sir_bad_scsi_status(stru
  *  - lun=-1  means any logical UNIT otherwise a given one.
  *  - task=-1 means any task, otherwise a given one.
  */
-int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int task)
+int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target,
+		    const struct scsi_lun *lun, int task)
 {
 	SYM_QUEHEAD qtmp, *qp;
 	int i = 0;
@@ -3196,7 +3199,7 @@ int sym_clear_tasks(struct sym_hcb *np, 
 		cmd = cp->cmd;
 		if (cp->host_status != HS_DISCONNECT ||
 		    cp->target != target	     ||
-		    (lun  != -1 && cp->lun != lun)   ||
+		    (lun != NULL && !scsilun_eq(&cp->lun, lun))   ||
 		    (task != -1 && 
 			(cp->tag != NO_TAG && cp->scsi_smsg[2] != task))) {
 			sym_insque_tail(&cp->link_ccbq, &np->busy_ccbq);
@@ -3261,7 +3264,9 @@ static void sym_sir_task_recovery(struct
 	struct sym_ccb *cp;
 	struct sym_tcb *tp = NULL; /* gcc isn't quite smart enough yet */
 	struct scsi_target *starget;
-	int target=-1, lun=-1, task;
+	int target=-1, task;
+	struct scsi_lun lunv;
+	struct scsi_lun *lunp = NULL;
 	int i, k;
 
 	switch(num) {
@@ -3367,7 +3372,7 @@ static void sym_sir_task_recovery(struct
 		 *  all CCBs for that device that haven't been started.
 		 */
 		i = (INL(np, nc_scratcha) - np->squeue_ba) / 4;
-		i = sym_dequeue_from_squeue(np, i, cp->target, cp->lun, -1);
+		i = sym_dequeue_from_squeue(np, i, cp->target, &cp->lun, -1);
 
 		/*
 		 *  Make sure at least our IO to abort has been dequeued.
@@ -3416,12 +3421,14 @@ static void sym_sir_task_recovery(struct
 		/*
 		 *  Otherwise, look for some logical unit to be cleared.
 		 */
-		if (tp->lun0p && tp->lun0p->to_clear)
-			lun = 0;
-		else if (tp->lunmp) {
+		if (tp->lun0p && tp->lun0p->to_clear) {
+			lunp = &lunv;
+			int_to_scsilun(0, lunp);
+		} else if (tp->lunmp) {
 			for (k = 1 ; k < SYM_CONF_MAX_LUN ; k++) {
 				if (tp->lunmp[k] && tp->lunmp[k]->to_clear) {
-					lun = k;
+					lunp = &lunv;
+					int_to_scsilun(k, lunp);
 					break;
 				}
 			}
@@ -3431,10 +3438,10 @@ static void sym_sir_task_recovery(struct
 		 *  If a logical unit is to be cleared, prepare 
 		 *  an IDENTIFY(lun) + ABORT MESSAGE.
 		 */
-		if (lun != -1) {
-			struct sym_lcb *lp = sym_lp(tp, lun);
+		if (lunp != NULL) {
+			struct sym_lcb *lp = sym_lp(tp, lunp);
 			lp->to_clear = 0; /* We don't expect to fail here */
-			np->abrt_msg[0] = IDENTIFY(0, lun);
+			np->abrt_msg[0] = IDENTIFY(0, lunp);
 			np->abrt_msg[1] = M_ABORT;
 			np->abrt_tbl.size = 2;
 			break;
@@ -3475,7 +3482,7 @@ static void sym_sir_task_recovery(struct
 		 *  We have some task to abort.
 		 *  Set the IDENTIFY(lun)
 		 */
-		np->abrt_msg[0] = IDENTIFY(0, cp->lun);
+		np->abrt_msg[0] = IDENTIFY(0, &cp->lun);
 
 		/*
 		 *  If we want to abort an untagged command, we 
@@ -3525,7 +3532,7 @@ static void sym_sir_task_recovery(struct
 		 *  - Prepare to clear all disconnected CCBs for 
 		 *    this target from our task list (lun=task=-1)
 		 */
-		lun = -1;
+		lunp = NULL;
 		task = -1;
 		if (np->abrt_msg[0] == M_RESET) {
 			tp->head.sval = 0;
@@ -3547,7 +3554,8 @@ static void sym_sir_task_recovery(struct
 		 *  or an ABORT message :-)
 		 */
 		else {
-			lun = np->abrt_msg[0] & 0x3f;
+			lunp = &lunv;
+			int_to_scsilun(np->abrt_msg[0] & 0x3f, lunp);
 			if (np->abrt_msg[1] == M_ABORT_TAG)
 				task = np->abrt_msg[2];
 		}
@@ -3557,8 +3565,8 @@ static void sym_sir_task_recovery(struct
 		 *  aborted due to our 'kiss of death' message.
 		 */
 		i = (INL(np, nc_scratcha) - np->squeue_ba) / 4;
-		sym_dequeue_from_squeue(np, i, target, lun, -1);
-		sym_clear_tasks(np, DID_ABORT, target, lun, task);
+		sym_dequeue_from_squeue(np, i, target, lunp, -1);
+		sym_clear_tasks(np, DID_ABORT, target, lunp, task);
 		sym_flush_comp_queue(np, 0);
 
  		/*
@@ -4642,8 +4650,8 @@ out_stuck:
  */
 struct sym_ccb *sym_get_ccb (struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order)
 {
-	u_char tn = cmd->device->id;
-	u_char ln = cmd->device->lun;
+	u_char tn = sdev_id(cmd->device);
+	const struct scsi_lun *ln = &cmd->device->lun;
 	struct sym_tcb *tp = &np->target[tn];
 	struct sym_lcb *lp = sym_lp(tp, ln);
 	u_short tag = NO_TAG;
@@ -4772,7 +4780,7 @@ struct sym_ccb *sym_get_ccb (struct sym_
 	cp->tag	   = tag;
 	cp->order  = tag_order;
 	cp->target = tn;
-	cp->lun    = ln;
+	scsilun_cp(&cp->lun, ln);
 
 	if (DEBUG_FLAGS & DEBUG_TAGS) {
 		sym_print_addr(cmd, "ccb @%p using tag %d.\n", cp, tag);
@@ -4791,7 +4799,7 @@ out_free:
 void sym_free_ccb (struct sym_hcb *np, struct sym_ccb *cp)
 {
 	struct sym_tcb *tp = &np->target[cp->target];
-	struct sym_lcb *lp = sym_lp(tp, cp->lun);
+	struct sym_lcb *lp = sym_lp(tp, &cp->lun);
 
 	if (DEBUG_FLAGS & DEBUG_TAGS) {
 		sym_print_addr(cp->cmd, "ccb @%p freeing tag %d.\n",
@@ -4841,7 +4849,7 @@ void sym_free_ccb (struct sym_hcb *np, s
 	 *  Clear the bit that keeps track of this IO.
 	 */
 	else
-		sym_clr_bit(tp->busy0_map, cp->lun);
+		sym_clr_bit(tp->busy0_map, &cp->lun);
 
 	/*
 	 *  We donnot queue more than 1 ccb per target 
@@ -4990,7 +4998,7 @@ static void sym_init_tcb (struct sym_hcb
 /*
  *  Lun control block allocation and initialization.
  */
-struct sym_lcb *sym_alloc_lcb (struct sym_hcb *np, u_char tn, u_char ln)
+struct sym_lcb *sym_alloc_lcb (struct sym_hcb *np, u_char tn, const struct scsi_lun *ln)
 {
 	struct sym_tcb *tp = &np->target[tn];
 	struct sym_lcb *lp = sym_lp(tp, ln);
@@ -5045,9 +5053,9 @@ struct sym_lcb *sym_alloc_lcb (struct sy
 	lp = sym_calloc_dma(sizeof(struct sym_lcb), "LCB");
 	if (!lp)
 		goto fail;
-	if (ln) {
-		tp->lunmp[ln] = lp;
-		tp->luntbl[ln] = cpu_to_scr(vtobus(lp));
+	if (!scsilun_zero(ln)) {
+		tp->lunmp[scsilun_to_int(ln)] = lp;
+		tp->luntbl[scsilun_to_int(ln)] = cpu_to_scr(vtobus(lp));
 	}
 	else {
 		tp->lun0p = lp;
@@ -5092,7 +5100,7 @@ fail:
 /*
  *  Allocate LCB resources for tagged command queuing.
  */
-static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, u_char ln)
+static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, const struct scsi_lun *ln)
 {
 	struct sym_tcb *tp = &np->target[tn];
 	struct sym_lcb *lp = sym_lp(tp, ln);
@@ -5166,14 +5174,14 @@ int sym_queue_scsiio(struct sym_hcb *np,
 	/*
 	 *  Retrieve the lun descriptor.
 	 */
-	lp = sym_lp(tp, sdev->lun);
+	lp = sym_lp(tp, &sdev->lun);
 
 	can_disconnect = (cp->tag != NO_TAG) ||
 		(lp && (lp->curr_flags & SYM_DISC_ENABLED));
 
 	msgptr = cp->scsi_smsg;
 	msglen = 0;
-	msgptr[msglen++] = IDENTIFY(can_disconnect, sdev->lun);
+	msgptr[msglen++] = IDENTIFY(can_disconnect, &sdev->lun);
 
 	/*
 	 *  Build the tag message if present.
@@ -5385,7 +5393,7 @@ void sym_complete_error(struct sym_hcb *
 	 *  Get target and lun pointers.
 	 */
 	tp = &np->target[cp->target];
-	lp = sym_lp(tp, sdev->lun);
+	lp = sym_lp(tp, &sdev->lun);
 
 	/*
 	 *  Check for extended errors.
@@ -5416,7 +5424,7 @@ if (resid)
 	 *  not yet started by SCRIPTS.
 	 */
 	i = (INL(np, nc_scratcha) - np->squeue_ba) / 4;
-	i = sym_dequeue_from_squeue(np, i, cp->target, sdev->lun, -1);
+	i = sym_dequeue_from_squeue(np, i, cp->target, &sdev->lun, -1);
 
 	/*
 	 *  Restart the SCRIPTS processor.
@@ -5514,13 +5522,13 @@ void sym_complete_ok (struct sym_hcb *np
 	 *  Get target and lun pointers.
 	 */
 	tp = &np->target[cp->target];
-	lp = sym_lp(tp, cp->lun);
+	lp = sym_lp(tp, &cp->lun);
 
 	/*
 	 *  Assume device discovered on first success.
 	 */
 	if (!lp)
-		sym_set_bit(tp->lun_map, cp->lun);
+		sym_set_bit(tp->lun_map, &cp->lun);
 
 	/*
 	 *  If all data have been transferred, given than no
@@ -5854,7 +5862,9 @@ void sym_hcb_free(struct sym_hcb *np)
 	for (target = 0; target < SYM_CONF_MAX_TARGET ; target++) {
 		tp = &np->target[target];
 		for (lun = 0 ; lun < SYM_CONF_MAX_LUN ; lun++) {
-			lp = sym_lp(tp, lun);
+			struct scsi_lun __lun;
+			int_to_scsilun(lun, &__lun);
+			lp = sym_lp(tp, &__lun);
 			if (!lp)
 				continue;
 			if (lp->itlq_tbl)
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 3131a6b..adb105d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -589,10 +589,11 @@ struct sym_pmc {
  *  LUN(s) > 0.
  */
 #if SYM_CONF_MAX_LUN <= 1
-#define sym_lp(tp, lun) (!lun) ? (tp)->lun0p : NULL
+#define sym_lp(tp, lun) (scsilun_zero(lun)) ? (tp)->lun0p : NULL
 #else
 #define sym_lp(tp, lun) \
-	(!lun) ? (tp)->lun0p : (tp)->lunmp ? (tp)->lunmp[(lun)] : NULL
+	(scsilun_zero(lun)) ? \
+	(tp)->lun0p : (tp)->lunmp ? (tp)->lunmp[scsilun_to_int(lun)] : NULL
 #endif
 
 /*
@@ -797,7 +798,11 @@ struct sym_ccb {
 	u_short	tag;		/* Tag for this transfer	*/
 				/*  NO_TAG means no tag		*/
 	u_char	target;
+#if 0
 	u_char	lun;
+#else
+	struct scsi_lun lun;
+#endif
 	struct sym_ccb *link_ccbh;	/* Host adapter CCB hash chain	*/
 	SYM_QUEHEAD link_ccbq;	/* Link to free/busy CCB queue	*/
 	u32	startp;		/* Initial data pointer		*/
@@ -1081,10 +1086,10 @@ void sym_start_next_ccbs(struct sym_hcb 
 #endif
 void sym_start_up(struct sym_hcb *np, int reason);
 void sym_interrupt(struct sym_hcb *np);
-int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int task);
+int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, const struct scsi_lun *lun, int task);
 struct sym_ccb *sym_get_ccb(struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order);
 void sym_free_ccb(struct sym_hcb *np, struct sym_ccb *cp);
-struct sym_lcb *sym_alloc_lcb(struct sym_hcb *np, u_char tn, u_char ln);
+struct sym_lcb *sym_alloc_lcb(struct sym_hcb *np, u_char tn, const struct scsi_lun *ln);
 int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
 int sym_abort_scsiio(struct sym_hcb *np, struct scsi_cmnd *ccb, int timed_out);
 int sym_reset_scsi_target(struct sym_hcb *np, int target);
diff --git a/drivers/scsi/sym53c8xx_2/sym_misc.h b/drivers/scsi/sym53c8xx_2/sym_misc.h
index 0433d5d..344e732 100644
--- a/drivers/scsi/sym53c8xx_2/sym_misc.h
+++ b/drivers/scsi/sym53c8xx_2/sym_misc.h
@@ -169,9 +169,13 @@ static __inline struct sym_quehead *sym_
 /*
  *  Simple bitmap operations.
  */ 
-#define sym_set_bit(p, n)	(((u32 *)(p))[(n)>>5] |=  (1<<((n)&0x1f)))
-#define sym_clr_bit(p, n)	(((u32 *)(p))[(n)>>5] &= ~(1<<((n)&0x1f)))
-#define sym_is_bit(p, n)	(((u32 *)(p))[(n)>>5] &   (1<<((n)&0x1f)))
+#define __sym_set_bit(p, n)	(((u32 *)(p))[(n)>>5] |=  (1<<((n)&0x1f)))
+#define __sym_clr_bit(p, n)	(((u32 *)(p))[(n)>>5] &= ~(1<<((n)&0x1f)))
+#define __sym_is_bit(p, n)	(((u32 *)(p))[(n)>>5] &   (1<<((n)&0x1f)))
+
+#define sym_set_bit(p, lun) __sym_set_bit((p), scsilun_to_int(lun))
+#define sym_clr_bit(p, lun) __sym_clr_bit((p), scsilun_to_int(lun))
+#define sym_is_bit(p, lun) __sym_is_bit((p), scsilun_to_int(lun))
 
 /*
  * The below round up/down macros are to be used with a constant 
diff --git a/drivers/usb/storage/dpcm.c b/drivers/usb/storage/dpcm.c
index 92b69e4..3ce376a 100644
--- a/drivers/usb/storage/dpcm.c
+++ b/drivers/usb/storage/dpcm.c
@@ -48,13 +48,16 @@
 int dpcm_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
   int ret;
+  unsigned int tmp_lun;
+
+  tmp_lun = scsilun_to_int(&srb->device->lun);
 
   if(srb == NULL)
     return USB_STOR_TRANSPORT_ERROR;
 
-  US_DEBUGP("dpcm_transport: LUN=%d\n", srb->device->lun);
+  US_DEBUGP("dpcm_transport: LUN=%u\n", tmp_lun);
 
-  switch(srb->device->lun) {
+  switch(tmp_lun) {
   case 0:
 
     /*
@@ -73,15 +76,19 @@ int dpcm_transport(struct scsi_cmnd *srb
     /*
      * Set the LUN to 0 (just in case).
      */
-    srb->device->lun = 0; us->srb->device->lun = 0;
+    int_to_scsilun(0, &srb->device->lun);
+    int_to_scsilun(0, &us->srb->device->lun);
+
     ret = sddr09_transport(srb, us);
-    srb->device->lun = 1; us->srb->device->lun = 1;
+
+    int_to_scsilun(1, &srb->device->lun);
+    int_to_scsilun(1, &us->srb->device->lun);
     break;
 
 #endif
 
   default:
-    US_DEBUGP("dpcm_transport: Invalid LUN %d\n", srb->device->lun);
+    US_DEBUGP("dpcm_transport: Invalid LUN %d\n", tmp_lun);
     ret = USB_STOR_TRANSPORT_ERROR;
     break;
   }
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index c1ba530..42edb19 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -979,9 +979,9 @@ int usb_stor_Bulk_transport(struct scsi_
 	bcb->DataTransferLength = cpu_to_le32(transfer_length);
 	bcb->Flags = srb->sc_data_direction == DMA_FROM_DEVICE ? 1 << 7 : 0;
 	bcb->Tag = ++us->tag;
-	bcb->Lun = srb->device->lun;
+	bcb->Lun = scsilun_to_int(&srb->device->lun);
 	if (us->flags & US_FL_SCM_MULT_TARG)
-		bcb->Lun |= srb->device->id << 4;
+		bcb->Lun |= sdev_id(srb->device) << 4;
 	bcb->Length = srb->cmd_len;
 
 	/* copy the command payload */
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index f9a9bfa..0b484a9 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -344,17 +344,27 @@ static int usb_stor_control_thread(void 
 		/* reject if target != 0 or if LUN is higher than
 		 * the maximum known LUN
 		 */
-		else if (us->srb->device->id && 
+		else if (sdev_id(us->srb->device) && 
 				!(us->flags & US_FL_SCM_MULT_TARG)) {
-			US_DEBUGP("Bad target number (%d:%d)\n",
-				  us->srb->device->id, us->srb->device->lun);
+			char lunstr[SCSILUN_STR_LEN];
+
+			US_DEBUGP("Bad target number (%d:%s)\n",
+				  sdev_id(us->srb->device),
+				  scsilun_to_str(&us->srb->device->lun, lunstr));
 			us->srb->result = DID_BAD_TARGET << 16;
+
+			(void) lunstr;	/* avoid warn, if debug disabled */
 		}
 
-		else if (us->srb->device->lun > us->max_lun) {
-			US_DEBUGP("Bad LUN (%d:%d)\n",
-				  us->srb->device->id, us->srb->device->lun);
+		else if (scsilun_to_int(&us->srb->device->lun) > us->max_lun) {
+			char lunstr[SCSILUN_STR_LEN];
+
+			US_DEBUGP("Bad LUN (%d:%s)\n",
+				  sdev_id(us->srb->device),
+				  scsilun_to_str(&us->srb->device->lun, lunstr));
 			us->srb->result = DID_BAD_TARGET << 16;
+
+			(void) lunstr;	/* avoid warn, if debug disabled */
 		}
 
 		/* Handle those devices which need us to fake 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index deb1a27..9d5ba34 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -380,7 +380,7 @@ struct scsi_lun {
 #define IDENTIFY_BASE       0x80
 #define IDENTIFY(can_disconnect, lun)   (IDENTIFY_BASE |\
 		     ((can_disconnect) ?  0x40 : 0) |\
-		     ((lun) & 0x07))
+		     (scsilun_to_int(lun) & 0x07))
 
 /*
  *  struct scsi_device::scsi_level values. For SCSI devices other than those
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 769469c..9e22d3b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -289,6 +289,17 @@ static inline int scsilun_eq(const struc
 	return (memcmp(a, b, sizeof(struct scsi_lun)) == 0);
 }
 
+static inline int scsilun_zero(const struct scsi_lun *lun)
+{
+	return (memcmp(lun, "\0\0\0\0\0\0\0\0", 8) == 0);
+}
+
+static inline void scsilun_cp(struct scsi_lun *dest_lun,
+			     const struct scsi_lun *src_lun)
+{
+	memcpy(dest_lun, src_lun, sizeof(struct scsi_lun));
+}
+
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
