From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/7] lpfc 8.3.10: Update SLI interface areas
Date: Fri, 26 Feb 2010 14:14:23 -0500
Message-ID: <1267211683.3372.4.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:4831 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965821Ab0BZTPS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 14:15:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Clear LPFC_DRIVER_ABORTED on FCP command completion.
- Clear exchange busy flag when I/O is aborted and found on aborted list.
- Free sglq when XRI_ABORTED event is processed before release of IOCB.
- Only process iocb as aborted when LPFC_DRIVER_ABORTED is set.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    1 
 lpfc_crtn.h |    2 
 lpfc_els.c  |   23 +++++++---
 lpfc_init.c |    7 +++
 lpfc_scsi.c |   35 +++++++++++++---
 lpfc_sli.c  |  128 ++++++++++++++++++++++++++++++++++++++----------------------
 lpfc_sli.h  |    1 
 lpfc_sli4.h |    7 +++
 8 files changed, 141 insertions(+), 63 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-25 16:33:47.000000000 -0500
@@ -385,7 +385,7 @@ void lpfc_parse_fcoe_conf(struct lpfc_hb
 int lpfc_parse_vpd(struct lpfc_hba *, uint8_t *, int);
 void lpfc_start_fdiscs(struct lpfc_hba *phba);
 struct lpfc_vport *lpfc_find_vport_by_vpid(struct lpfc_hba *, uint16_t);
-
+struct lpfc_sglq *__lpfc_get_active_sglq(struct lpfc_hba *, uint16_t);
 #define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code)
 #define HBA_EVENT_RSCN                   5
 #define HBA_EVENT_LINK_UP                2
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-02-25 16:33:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-02-25 16:33:47.000000000 -0500
@@ -6234,7 +6234,8 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 		lpfc_mbx_unreg_vpi(vport);
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
-		vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
 		spin_unlock_irq(shost->host_lock);
 	}
 
@@ -6812,21 +6813,27 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hb
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
 	unsigned long iflag = 0;
 
-	spin_lock_irqsave(&phba->sli4_hba.abts_sgl_list_lock, iflag);
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->sli4_xritag == xri) {
 			list_del(&sglq_entry->list);
-			spin_unlock_irqrestore(
-					&phba->sli4_hba.abts_sgl_list_lock,
-					 iflag);
-			spin_lock_irqsave(&phba->hbalock, iflag);
-
 			list_add_tail(&sglq_entry->list,
 				&phba->sli4_hba.lpfc_sgl_list);
+			sglq_entry->state = SGL_FREED;
+			spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			return;
 		}
 	}
-	spin_unlock_irqrestore(&phba->sli4_hba.abts_sgl_list_lock, iflag);
+	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+	sglq_entry = __lpfc_get_active_sglq(phba, xri);
+	if (!sglq_entry || (sglq_entry->sli4_xritag != xri)) {
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		return;
+	}
+	sglq_entry->state = SGL_XRI_ABORTED;
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-02-25 16:33:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2010-02-25 16:33:47.000000000 -0500
@@ -509,7 +509,6 @@ struct lpfc_hba {
 	int (*lpfc_hba_down_link)
 		(struct lpfc_hba *);
 
-
 	/* SLI4 specific HBA data structure */
 	struct lpfc_sli4_hba sli4_hba;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:33:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:33:47.000000000 -0500
@@ -822,6 +822,8 @@ lpfc_hba_down_post_s4(struct lpfc_hba *p
 	LIST_HEAD(aborts);
 	int ret;
 	unsigned long iflag = 0;
+	struct lpfc_sglq *sglq_entry = NULL;
+
 	ret = lpfc_hba_down_post_s3(phba);
 	if (ret)
 		return ret;
@@ -837,6 +839,10 @@ lpfc_hba_down_post_s4(struct lpfc_hba *p
 	 * list.
 	 */
 	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
+	list_for_each_entry(sglq_entry,
+		&phba->sli4_hba.lpfc_abts_els_sgl_list, list)
+		sglq_entry->state = SGL_FREED;
+
 	list_splice_init(&phba->sli4_hba.lpfc_abts_els_sgl_list,
 			&phba->sli4_hba.lpfc_sgl_list);
 	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
@@ -4412,6 +4418,7 @@ lpfc_init_sgl_list(struct lpfc_hba *phba
 
 		/* The list order is used by later block SGL registraton */
 		spin_lock_irq(&phba->hbalock);
+		sglq_entry->state = SGL_FREED;
 		list_add_tail(&sglq_entry->list, &phba->sli4_hba.lpfc_sgl_list);
 		phba->sli4_hba.lpfc_els_sgl_array[i] = sglq_entry;
 		phba->sli4_hba.total_sglq_bufs++;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-02-25 16:33:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-02-25 16:33:47.000000000 -0500
@@ -620,23 +620,40 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hb
 	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
 	struct lpfc_scsi_buf *psb, *next_psb;
 	unsigned long iflag = 0;
+	struct lpfc_iocbq *iocbq;
+	int i;
 
-	spin_lock_irqsave(&phba->sli4_hba.abts_scsi_buf_list_lock, iflag);
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
 	list_for_each_entry_safe(psb, next_psb,
 		&phba->sli4_hba.lpfc_abts_scsi_buf_list, list) {
 		if (psb->cur_iocbq.sli4_xritag == xri) {
 			list_del(&psb->list);
 			psb->exch_busy = 0;
 			psb->status = IOSTAT_SUCCESS;
-			spin_unlock_irqrestore(
-				&phba->sli4_hba.abts_scsi_buf_list_lock,
-				iflag);
+			spin_unlock(
+				&phba->sli4_hba.abts_scsi_buf_list_lock);
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			lpfc_release_scsi_buf_s4(phba, psb);
 			return;
 		}
 	}
-	spin_unlock_irqrestore(&phba->sli4_hba.abts_scsi_buf_list_lock,
-				iflag);
+	spin_unlock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	for (i = 1; i <= phba->sli.last_iotag; i++) {
+		iocbq = phba->sli.iocbq_lookup[i];
+
+		if (!(iocbq->iocb_flag &  LPFC_IO_FCP) ||
+			(iocbq->iocb_flag & LPFC_IO_LIBDFC))
+			continue;
+		if (iocbq->sli4_xritag != xri)
+			continue;
+		psb = container_of(iocbq, struct lpfc_scsi_buf, cur_iocbq);
+		psb->exch_busy = 0;
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		return;
+
+	}
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
 }
 
 /**
@@ -1006,6 +1023,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hb
 	struct scatterlist *sgel = NULL;
 	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
 	struct ulp_bde64 *bpl = lpfc_cmd->fcp_bpl;
+	struct lpfc_iocbq *iocbq = &lpfc_cmd->cur_iocbq;
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
 	struct ulp_bde64 *data_bde = iocb_cmd->unsli3.fcp_ext.dbde;
 	dma_addr_t physaddr;
@@ -1056,6 +1074,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hb
 			physaddr = sg_dma_address(sgel);
 			if (phba->sli_rev == 3 &&
 			    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
+			    !(iocbq->iocb_flag & DSS_SECURITY_OP) &&
 			    nseg <= LPFC_EXT_DATA_BDE_COUNT) {
 				data_bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 				data_bde->tus.f.bdeSize = sg_dma_len(sgel);
@@ -1082,7 +1101,8 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hb
 	 * explicitly reinitialized since all iocb memory resources are reused.
 	 */
 	if (phba->sli_rev == 3 &&
-	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED)) {
+	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
+	    !(iocbq->iocb_flag & DSS_SECURITY_OP)) {
 		if (num_bde > LPFC_EXT_DATA_BDE_COUNT) {
 			/*
 			 * The extended IOCB format can only fit 3 BDE or a BPL.
@@ -1107,6 +1127,7 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hb
 	} else {
 		iocb_cmd->un.fcpi64.bdl.bdeSize =
 			((num_bde + 2) * sizeof(struct ulp_bde64));
+		iocb_cmd->unsli3.fcp_ext.ebde_count = (num_bde + 1);
 	}
 	fcp_cmnd->fcpDl = cpu_to_be32(scsi_bufflen(scsi_cmnd));
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-25 16:33:47.000000000 -0500
@@ -431,11 +431,18 @@ enum lpfc_sge_type {
 	SCSI_BUFF_TYPE
 };
 
+enum lpfc_sgl_state {
+	SGL_FREED,
+	SGL_ALLOCATED,
+	SGL_XRI_ABORTED
+};
+
 struct lpfc_sglq {
 	/* lpfc_sglqs are used in double linked lists */
 	struct list_head list;
 	struct list_head clist;
 	enum lpfc_sge_type buff_type; /* is this a scsi sgl */
+	enum lpfc_sgl_state state;
 	uint16_t iotag;         /* pre-assigned IO tag */
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
 	struct sli4_sge *sgl;	/* pre-assigned SGL */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-02-25 16:33:26.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-02-25 16:33:47.000000000 -0500
@@ -494,7 +494,7 @@ __lpfc_clear_active_sglq(struct lpfc_hba
  *
  * Returns sglq ponter = success, NULL = Failure.
  **/
-static struct lpfc_sglq *
+struct lpfc_sglq *
 __lpfc_get_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
 {
 	uint16_t adj_xri;
@@ -526,6 +526,7 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 		return NULL;
 	adj_xri = sglq->sli4_xritag - phba->sli4_hba.max_cfg_param.xri_base;
 	phba->sli4_hba.lpfc_sglq_active_list[adj_xri] = sglq;
+	sglq->state = SGL_ALLOCATED;
 	return sglq;
 }
 
@@ -580,15 +581,18 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 	else
 		sglq = __lpfc_clear_active_sglq(phba, iocbq->sli4_xritag);
 	if (sglq)  {
-		if (iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) {
+		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
+			(sglq->state != SGL_XRI_ABORTED)) {
 			spin_lock_irqsave(&phba->sli4_hba.abts_sgl_list_lock,
 					iflag);
 			list_add(&sglq->list,
 				&phba->sli4_hba.lpfc_abts_els_sgl_list);
 			spin_unlock_irqrestore(
 				&phba->sli4_hba.abts_sgl_list_lock, iflag);
-		} else
+		} else {
+			sglq->state = SGL_FREED;
 			list_add(&sglq->list, &phba->sli4_hba.lpfc_sgl_list);
+		}
 	}
 

@@ -2258,41 +2262,56 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 					spin_unlock_irqrestore(&phba->hbalock,
 							       iflag);
 				}
-				if ((phba->sli_rev == LPFC_SLI_REV4) &&
-				    (saveq->iocb_flag & LPFC_EXCHANGE_BUSY)) {
-					/* Set cmdiocb flag for the exchange
-					 * busy so sgl (xri) will not be
-					 * released until the abort xri is
-					 * received from hba, clear the
-					 * LPFC_DRIVER_ABORTED bit in case
-					 * it was driver initiated abort.
-					 */
-					spin_lock_irqsave(&phba->hbalock,
-							  iflag);
-					cmdiocbp->iocb_flag &=
-						~LPFC_DRIVER_ABORTED;
-					cmdiocbp->iocb_flag |=
-						LPFC_EXCHANGE_BUSY;
-					spin_unlock_irqrestore(&phba->hbalock,
-							       iflag);
-					cmdiocbp->iocb.ulpStatus =
-						IOSTAT_LOCAL_REJECT;
-					cmdiocbp->iocb.un.ulpWord[4] =
-						IOERR_ABORT_REQUESTED;
-					/*
-					 * For SLI4, irsiocb contains NO_XRI
-					 * in sli_xritag, it shall not affect
-					 * releasing sgl (xri) process.
-					 */
-					saveq->iocb.ulpStatus =
-						IOSTAT_LOCAL_REJECT;
-					saveq->iocb.un.ulpWord[4] =
-						IOERR_SLI_ABORTED;
-					spin_lock_irqsave(&phba->hbalock,
-							  iflag);
-					saveq->iocb_flag |= LPFC_DELAY_MEM_FREE;
-					spin_unlock_irqrestore(&phba->hbalock,
-							       iflag);
+				if (phba->sli_rev == LPFC_SLI_REV4) {
+					if (saveq->iocb_flag &
+					    LPFC_EXCHANGE_BUSY) {
+						/* Set cmdiocb flag for the
+						 * exchange busy so sgl (xri)
+						 * will not be released until
+						 * the abort xri is received
+						 * from hba.
+						 */
+						spin_lock_irqsave(
+							&phba->hbalock, iflag);
+						cmdiocbp->iocb_flag |=
+							LPFC_EXCHANGE_BUSY;
+						spin_unlock_irqrestore(
+							&phba->hbalock, iflag);
+					}
+					if (cmdiocbp->iocb_flag &
+					    LPFC_DRIVER_ABORTED) {
+						/*
+						 * Clear LPFC_DRIVER_ABORTED
+						 * bit in case it was driver
+						 * initiated abort.
+						 */
+						spin_lock_irqsave(
+							&phba->hbalock, iflag);
+						cmdiocbp->iocb_flag &=
+							~LPFC_DRIVER_ABORTED;
+						spin_unlock_irqrestore(
+							&phba->hbalock, iflag);
+						cmdiocbp->iocb.ulpStatus =
+							IOSTAT_LOCAL_REJECT;
+						cmdiocbp->iocb.un.ulpWord[4] =
+							IOERR_ABORT_REQUESTED;
+						/*
+						 * For SLI4, irsiocb contains
+						 * NO_XRI in sli_xritag, it
+						 * shall not affect releasing
+						 * sgl (xri) process.
+						 */
+						saveq->iocb.ulpStatus =
+							IOSTAT_LOCAL_REJECT;
+						saveq->iocb.un.ulpWord[4] =
+							IOERR_SLI_ABORTED;
+						spin_lock_irqsave(
+							&phba->hbalock, iflag);
+						saveq->iocb_flag |=
+							LPFC_DELAY_MEM_FREE;
+						spin_unlock_irqrestore(
+							&phba->hbalock, iflag);
+					}
 				}
 			}
 			(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
@@ -2515,14 +2534,16 @@ lpfc_sli_handle_fast_ring_event(struct l
 
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
-			if ((cmdiocbq) && (cmdiocbq->iocb_cmpl)) {
-					spin_unlock_irqrestore(&phba->hbalock,
-							       iflag);
-					(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
-							      &rspiocbq);
-					spin_lock_irqsave(&phba->hbalock,
-							  iflag);
-				}
+			if (unlikely(!cmdiocbq))
+				break;
+			if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED)
+				cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+			if (cmdiocbq->iocb_cmpl) {
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
+				(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
+						      &rspiocbq);
+				spin_lock_irqsave(&phba->hbalock, iflag);
+			}
 			break;
 		case LPFC_UNSOL_IOCB:
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
@@ -7451,6 +7472,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba 
 {
 	wait_queue_head_t *pdone_q;
 	unsigned long iflags;
+	struct lpfc_scsi_buf *lpfc_cmd;
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
@@ -7458,6 +7480,14 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba 
 		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
 		       &rspiocbq->iocb, sizeof(IOCB_t));
 
+	/* Set the exchange busy flag for task management commands */
+	if ((cmdiocbq->iocb_flag & LPFC_IO_FCP) &&
+		!(cmdiocbq->iocb_flag & LPFC_IO_LIBDFC)) {
+		lpfc_cmd = container_of(cmdiocbq, struct lpfc_scsi_buf,
+			cur_iocbq);
+		lpfc_cmd->exch_busy = rspiocbq->iocb_flag & LPFC_EXCHANGE_BUSY;
+	}
+
 	pdone_q = cmdiocbq->context_un.wait_queue;
 	if (pdone_q)
 		wake_up(pdone_q);
@@ -9076,6 +9106,12 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc
 	/* Fake the irspiocb and copy necessary response information */
 	lpfc_sli4_iocb_param_transfer(phba, &irspiocbq, cmdiocbq, wcqe);
 
+	if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED) {
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+	}
+
 	/* Pass the cmd_iocb and the rsp state to the upper layer */
 	(cmdiocbq->iocb_cmpl)(phba, cmdiocbq, &irspiocbq);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2010-02-11 17:26:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2010-02-25 16:33:47.000000000 -0500
@@ -62,6 +62,7 @@ struct lpfc_iocbq {
 #define LPFC_DELAY_MEM_FREE	0x20    /* Defer free'ing of FC data */
 #define LPFC_EXCHANGE_BUSY	0x40    /* SLI4 hba reported XB in response */
 #define LPFC_USE_FCPWQIDX	0x80    /* Submit to specified FCPWQ index */
+#define DSS_SECURITY_OP		0x100	/* security IO */
 
 #define LPFC_FIP_ELS_ID_MASK	0xc000	/* ELS_ID range 0-3, non-shifted mask */
 #define LPFC_FIP_ELS_ID_SHIFT	14


