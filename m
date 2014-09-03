From: James Smart <james.smart@emulex.com>
Subject: [PATCH 16/19] lpfc 10.4.8000.0: Fixed High priority issues from
 lpfc given by fortify source code scan
Date: Wed, 3 Sep 2014 12:57:55 -0400
Message-ID: <1409763475.12357.16.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:43873 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaICQ57 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:57:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed High priority issues from lpfc given by fortify source code scan.

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       |  8 +++++---
 drivers/scsi/lpfc/lpfc_els.c       |  5 ++++-
 drivers/scsi/lpfc/lpfc_init.c      | 32 +++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  2 ++
 drivers/scsi/lpfc/lpfc_sli.c       | 26 +++++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli4.h      | 20 ++++++++++----------
 6 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index d236448..a58bffb 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2827,8 +2827,10 @@ diag_cmd_data_alloc(struct lpfc_hba *phba,
 		size -= cnt;
 	}
 
-	mlist->flag = i;
-	return mlist;
+	if (mlist) {
+		mlist->flag = i;
+		return mlist;
+	}
 out:
 	diag_cmd_data_free(phba, mlist);
 	return NULL;
@@ -4592,7 +4594,7 @@ sli_cfg_ext_error:
  * being reset) and com-plete the job, otherwise issue the mailbox command and
  * let our completion handler finish the command.
  **/
-static uint32_t
+static int
 lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	struct lpfc_vport *vport)
 {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9d03e72..c7e5080 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1084,7 +1084,8 @@ stop_rr_fcf_flogi:
 	 * accessing it.
 	 */
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
-
+	if (!prsp)
+		goto out;
 	sp = prsp->virt + sizeof(uint32_t);
 
 	/* FLOGI completes successfully */
@@ -7521,6 +7522,8 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	vport->fc_myDID = irsp->un.ulpWord[4] & Mask_DID;
 	lpfc_vport_set_state(vport, FC_VPORT_ACTIVE);
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
+	if (!prsp)
+		goto out;
 	sp = prsp->virt + sizeof(uint32_t);
 	fabric_param_changed = lpfc_check_clean_addr_bit(vport, sp);
 	memcpy(&vport->fabric_portname, &sp->portName,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 33a24fc0..0d92304 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -306,10 +306,10 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 		dist = dist_char[prg->dist];
 
 	if ((prg->dist == 3) && (prg->num == 0))
-		sprintf(phba->OptionROMVersion, "%d.%d%d",
+		snprintf(phba->OptionROMVersion, 32, "%d.%d%d",
 			prg->ver, prg->rev, prg->lev);
 	else
-		sprintf(phba->OptionROMVersion, "%d.%d%d%c%d",
+		snprintf(phba->OptionROMVersion, 32, "%d.%d%d%c%d",
 			prg->ver, prg->rev, prg->lev,
 			dist, prg->num);
 	mempool_free(pmboxq, phba->mbox_mem_pool);
@@ -3177,9 +3177,11 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 		for (i = 0; i < scsi_xri_cnt; i++) {
 			list_remove_head(&scsi_sgl_list, psb,
 					 struct lpfc_scsi_buf, list);
-			pci_pool_free(phba->lpfc_scsi_dma_buf_pool, psb->data,
-				      psb->dma_handle);
-			kfree(psb);
+			if (psb) {
+				pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
+					      psb->data, psb->dma_handle);
+				kfree(psb);
+			}
 		}
 		spin_lock_irq(&phba->scsi_buf_list_get_lock);
 		phba->sli4_hba.scsi_xri_cnt -= scsi_xri_cnt;
@@ -7424,7 +7426,8 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0523 Failed setup of fast-path EQ "
-					"(%d), rc = 0x%x\n", fcp_eqidx, rc);
+					"(%d), rc = 0x%x\n", fcp_eqidx,
+					(uint32_t)rc);
 			goto out_destroy_hba_eq;
 		}
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -7455,7 +7458,8 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0527 Failed setup of fast-path FCP "
-					"CQ (%d), rc = 0x%x\n", fcp_cqidx, rc);
+					"CQ (%d), rc = 0x%x\n", fcp_cqidx,
+					(uint32_t)rc);
 			goto out_destroy_fcp_cq;
 		}
 
@@ -7495,7 +7499,8 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"0535 Failed setup of fast-path FCP "
-					"WQ (%d), rc = 0x%x\n", fcp_wqidx, rc);
+					"WQ (%d), rc = 0x%x\n", fcp_wqidx,
+					(uint32_t)rc);
 			goto out_destroy_fcp_wq;
 		}
 
@@ -7528,7 +7533,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0529 Failed setup of slow-path mailbox CQ: "
-				"rc = 0x%x\n", rc);
+				"rc = 0x%x\n", (uint32_t)rc);
 		goto out_destroy_fcp_wq;
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -7548,7 +7553,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0531 Failed setup of slow-path ELS CQ: "
-				"rc = 0x%x\n", rc);
+				"rc = 0x%x\n", (uint32_t)rc);
 		goto out_destroy_mbx_cq;
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -7592,7 +7597,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0537 Failed setup of slow-path ELS WQ: "
-				"rc = 0x%x\n", rc);
+				"rc = 0x%x\n", (uint32_t)rc);
 		goto out_destroy_mbx_wq;
 	}
 
@@ -7624,7 +7629,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0541 Failed setup of Receive Queue: "
-				"rc = 0x%x\n", rc);
+				"rc = 0x%x\n", (uint32_t)rc);
 		goto out_destroy_fcp_wq;
 	}
 
@@ -8815,7 +8820,8 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	/* Assign MSI-X vectors to interrupt handlers */
 	for (index = 0; index < vectors; index++) {
 		memset(&phba->sli4_hba.handler_name[index], 0, 16);
-		sprintf((char *)&phba->sli4_hba.handler_name[index],
+		snprintf((char *)&phba->sli4_hba.handler_name[index],
+			 LPFC_SLI4_HANDLER_NAME_SZ,
 			 LPFC_DRIVER_HANDLER_NAME"%d", index);
 
 		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index c342f6a..5cc1103 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1031,6 +1031,8 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
+	if (!prsp)
+		goto out;
 
 	lp = (uint32_t *) prsp->virt;
 	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7185aac..2c7057f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8107,7 +8107,7 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
  *
  * Return: index into SLI4 fast-path FCP queue index.
  **/
-static inline uint32_t
+static inline int
 lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba)
 {
 	struct lpfc_vector_map_info *cpup;
@@ -12837,7 +12837,7 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
  * memory this function will return -ENOMEM. If the queue create mailbox command
  * fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint16_t startq)
 {
 	struct lpfc_mbx_modify_eq_delay *eq_delay;
@@ -12923,7 +12923,7 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint16_t startq)
  * memory this function will return -ENOMEM. If the queue create mailbox command
  * fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 {
 	struct lpfc_mbx_eq_create *eq_create;
@@ -13045,7 +13045,7 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
  * memory this function will return -ENOMEM. If the queue create mailbox command
  * fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	       struct lpfc_queue *eq, uint32_t type, uint32_t subtype)
 {
@@ -13386,7 +13386,7 @@ out:
  * memory this function will return -ENOMEM. If the queue create mailbox command
  * fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	       struct lpfc_queue *cq, uint32_t subtype)
 {
@@ -13622,7 +13622,7 @@ lpfc_rq_adjust_repost(struct lpfc_hba *phba, struct lpfc_queue *rq, int qno)
  * memory this function will return -ENOMEM. If the queue create mailbox command
  * fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	       struct lpfc_queue *drq, struct lpfc_queue *cq, uint32_t subtype)
 {
@@ -13887,7 +13887,7 @@ out:
  * On success this function will return a zero. If the queue destroy mailbox
  * command fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
 {
 	LPFC_MBOXQ_t *mbox;
@@ -13943,7 +13943,7 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
  * On success this function will return a zero. If the queue destroy mailbox
  * command fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
 {
 	LPFC_MBOXQ_t *mbox;
@@ -13997,7 +13997,7 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
  * On success this function will return a zero. If the queue destroy mailbox
  * command fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
 {
 	LPFC_MBOXQ_t *mbox;
@@ -14051,7 +14051,7 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
  * On success this function will return a zero. If the queue destroy mailbox
  * command fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
 {
 	LPFC_MBOXQ_t *mbox;
@@ -14104,7 +14104,7 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
  * On success this function will return a zero. If the queue destroy mailbox
  * command fails this function will return -ENXIO.
  **/
-uint32_t
+int
 lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 		struct lpfc_queue *drq)
 {
@@ -15011,7 +15011,7 @@ uint16_t
 lpfc_sli4_xri_inrange(struct lpfc_hba *phba,
 		      uint16_t xri)
 {
-	int i;
+	uint16_t i;
 
 	for (i = 0; i < phba->sli4_hba.max_cfg_param.max_xri; i++) {
 		if (xri == phba->sli4_hba.xri_ids[i])
@@ -16948,7 +16948,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 	char *fail_msg = NULL;
 	struct lpfc_sglq *sglq;
 	union lpfc_wqe wqe;
-	int txq_cnt = 0;
+	uint32_t txq_cnt = 0;
 
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	list_for_each_entry(piocbq, &pring->txq, list) {
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 7f50aa0..22ceb2b 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -670,22 +670,22 @@ void lpfc_sli4_hba_reset(struct lpfc_hba *);
 struct lpfc_queue *lpfc_sli4_queue_alloc(struct lpfc_hba *, uint32_t,
 			uint32_t);
 void lpfc_sli4_queue_free(struct lpfc_queue *);
-uint32_t lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint32_t);
-uint32_t lpfc_modify_fcp_eq_delay(struct lpfc_hba *, uint16_t);
-uint32_t lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
+int lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint32_t);
+int lpfc_modify_fcp_eq_delay(struct lpfc_hba *, uint16_t);
+int lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t, uint32_t);
 int32_t lpfc_mq_create(struct lpfc_hba *, struct lpfc_queue *,
 		       struct lpfc_queue *, uint32_t);
-uint32_t lpfc_wq_create(struct lpfc_hba *, struct lpfc_queue *,
+int lpfc_wq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t);
-uint32_t lpfc_rq_create(struct lpfc_hba *, struct lpfc_queue *,
+int lpfc_rq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, struct lpfc_queue *, uint32_t);
 void lpfc_rq_adjust_repost(struct lpfc_hba *, struct lpfc_queue *, int);
-uint32_t lpfc_eq_destroy(struct lpfc_hba *, struct lpfc_queue *);
-uint32_t lpfc_cq_destroy(struct lpfc_hba *, struct lpfc_queue *);
-uint32_t lpfc_mq_destroy(struct lpfc_hba *, struct lpfc_queue *);
-uint32_t lpfc_wq_destroy(struct lpfc_hba *, struct lpfc_queue *);
-uint32_t lpfc_rq_destroy(struct lpfc_hba *, struct lpfc_queue *,
+int lpfc_eq_destroy(struct lpfc_hba *, struct lpfc_queue *);
+int lpfc_cq_destroy(struct lpfc_hba *, struct lpfc_queue *);
+int lpfc_mq_destroy(struct lpfc_hba *, struct lpfc_queue *);
+int lpfc_wq_destroy(struct lpfc_hba *, struct lpfc_queue *);
+int lpfc_rq_destroy(struct lpfc_hba *, struct lpfc_queue *,
 			 struct lpfc_queue *);
 int lpfc_sli4_queue_setup(struct lpfc_hba *);
 void lpfc_sli4_queue_unset(struct lpfc_hba *);
-- 
1.7.11.7




