From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/5] lpfc 8.2.7 : Miscellaneous Fixes
Date: Sat, 14 Jun 2008 22:52:59 -0400
Message-ID: <1213498379.10002.13.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33089 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbYFOCxE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jun 2008 22:53:04 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m5F2r2Sd018799
	for <linux-scsi@vger.kernel.org>; Sat, 14 Jun 2008 19:53:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous Fixes:
- Fix bug in mbox sysfs interface that locked in EAGAIN if discovery stalled.
- Fix missing error message when npiv and loop are true when link up occurs.
- Fix panic in lpfc_scsi_cmd_iocb_cmpl: scsi_buf was NULL, but created
  race conditions with other code paths.
- Fix error in sysfs mailbox structure that didn't rezero on next use.
- Add missing mempool_free() to attachment failure path
- Fix missing put of ndlp structure during driver unload.
- Fix applications unable to send mailbox commands during discovery.
- Remove unused argument (type) from function lpfc_post_buffer() API
- Fix vport name is not shown after hbacmd vportcreate.
- Remove repeated code statements.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    1 +
 lpfc_attr.c    |    3 +--
 lpfc_crtn.h    |    3 ++-
 lpfc_ct.c      |    6 +++---
 lpfc_els.c     |    7 ++-----
 lpfc_hbadisc.c |    4 ++++
 lpfc_init.c    |   18 ++++++++++++++----
 lpfc_scsi.c    |    5 ++---
 lpfc_sli.c     |   13 +++++++------
 lpfc_vport.c   |   16 +++++++++++++++-
 10 files changed, 51 insertions(+), 25 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-04-24 08:47:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-06-14 22:29:56.000000000 -0400
@@ -1995,8 +1995,7 @@ sysfs_mbox_read(struct kobject *kobj, st
 		/* Don't allow mailbox commands to be sent when blocked
 		 * or when in the middle of discovery
 		 */
-		if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO ||
-		    vport->fc_flag & FC_NDISC_ACTIVE) {
+		if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO) {
 			sysfs_mbox_idle(phba);
 			spin_unlock_irq(&phba->hbalock);
 			return  -EAGAIN;
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2008-04-24 08:47:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2008-06-14 22:29:58.000000000 -0400
@@ -142,7 +142,7 @@ int lpfc_config_port_post(struct lpfc_hb
 int lpfc_hba_down_prep(struct lpfc_hba *);
 int lpfc_hba_down_post(struct lpfc_hba *);
 void lpfc_hba_init(struct lpfc_hba *, uint32_t *);
-int lpfc_post_buffer(struct lpfc_hba *, struct lpfc_sli_ring *, int, int);
+int lpfc_post_buffer(struct lpfc_hba *, struct lpfc_sli_ring *, int);
 void lpfc_decode_firmware_rev(struct lpfc_hba *, char *, int);
 int lpfc_online(struct lpfc_hba *);
 void lpfc_unblock_mgmt_io(struct lpfc_hba *);
@@ -263,6 +263,7 @@ extern int lpfc_sli_mode;
 extern int lpfc_enable_npiv;
 
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
+int  lpfc_vport_symbolic_port_name(struct lpfc_vport *, char *,	size_t);
 void lpfc_terminate_rport_io(struct fc_rport *);
 void lpfc_dev_loss_tmo_callbk(struct fc_rport *rport);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-06-14 22:23:56.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-06-14 22:29:58.000000000 -0400
@@ -101,7 +101,7 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 		/* Not enough posted buffers; Try posting more buffers */
 		phba->fc_stat.NoRcvBuf++;
 		if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
-			lpfc_post_buffer(phba, pring, 2, 1);
+			lpfc_post_buffer(phba, pring, 2);
 		return;
 	}
 
@@ -151,7 +151,7 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 			}
 			list_del(&iocbq->list);
 			lpfc_sli_release_iocbq(phba, iocbq);
-			lpfc_post_buffer(phba, pring, i, 1);
+			lpfc_post_buffer(phba, pring, i);
 		}
 	}
 }
@@ -990,7 +990,7 @@ lpfc_cmpl_ct_cmd_rff_id(struct lpfc_hba 
 	return;
 }
 
-static int
+int
 lpfc_vport_symbolic_port_name(struct lpfc_vport *vport, char *symbol,
 	size_t size)
 {
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-06-14 22:23:56.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-06-14 22:29:59.000000000 -0400
@@ -3857,9 +3857,6 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 		    els_command == ELS_CMD_FDISC)
 			continue;
 
-		if (vport != piocb->vport)
-			continue;
-
 		if (piocb->drvrTimeout > 0) {
 			if (piocb->drvrTimeout >= timeout)
 				piocb->drvrTimeout -= timeout;
@@ -4013,7 +4010,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	payload = ((struct lpfc_dmabuf *)elsiocb->context2)->virt;
 	cmd = *payload;
 	if ((phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) == 0)
-		lpfc_post_buffer(phba, pring, 1, 1);
+		lpfc_post_buffer(phba, pring, 1);
 
 	did = icmd->un.rcvels.remoteID;
 	if (icmd->ulpStatus) {
@@ -4322,7 +4319,7 @@ lpfc_els_unsol_event(struct lpfc_hba *ph
 		phba->fc_stat.NoRcvBuf++;
 		/* Not enough posted buffers; Try posting more buffers */
 		if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
-			lpfc_post_buffer(phba, pring, 0, 1);
+			lpfc_post_buffer(phba, pring, 0);
 		return;
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-06-14 22:23:56.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2008-06-14 22:29:58.000000000 -0400
@@ -33,6 +33,7 @@ struct lpfc_sli2_slim;
 #define LPFC_MAX_SG_SEG_CNT	256	/* sg element count per scsi cmnd */
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
 #define LPFC_Q_RAMP_UP_INTERVAL 120     /* lun q_depth ramp up interval */
+#define LPFC_VNAME_LEN		100	/* vport symbolic name length */
 
 /*
  * Following time intervals are used of adjusting SCSI device
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-06-14 22:23:56.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-06-14 22:29:13.000000000 -0400
@@ -917,6 +917,10 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	if (phba->fc_topology == TOPOLOGY_LOOP) {
 		phba->sli3_options &= ~LPFC_SLI3_NPIV_ENABLED;
 
+		if (phba->cfg_enable_npiv)
+			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
+				"1309 Link Up Event npiv not supported in loop "
+				"topology\n");
 				/* Get Loop Map information */
 		if (la->il)
 			vport->fc_flag |= FC_LBIT;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-06-14 22:23:56.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-06-14 22:29:57.000000000 -0400
@@ -145,8 +145,10 @@ lpfc_config_port_prep(struct lpfc_hba *p
 		return -ERESTART;
 	}
 
-	if (phba->sli_rev == 3 && !mb->un.varRdRev.v3rsp)
+	if (phba->sli_rev == 3 && !mb->un.varRdRev.v3rsp) {
+		mempool_free(pmb, phba->mbox_mem_pool);
 		return -EINVAL;
+	}
 
 	/* Save information as VPD data */
 	vp->rev.rBit = 1;
@@ -1197,8 +1199,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 /*   Returns the number of buffers NOT posted.    */
 /**************************************************/
 int
-lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt,
-		 int type)
+lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
 {
 	IOCB_t *icmd;
 	struct lpfc_iocbq *iocb;
@@ -1298,7 +1299,7 @@ lpfc_post_rcv_buf(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 
 	/* Ring 0, ELS / CT buffers */
-	lpfc_post_buffer(phba, &psli->ring[LPFC_ELS_RING], LPFC_BUF_RING0, 1);
+	lpfc_post_buffer(phba, &psli->ring[LPFC_ELS_RING], LPFC_BUF_RING0);
 	/* Ring 2 - FCP no buffers needed */
 
 	return 0;
@@ -1457,6 +1458,15 @@ lpfc_cleanup(struct lpfc_vport *vport)
 
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					     NLP_EVT_DEVICE_RM);
+
+		/* nlp_type zero is not defined, nlp_flag zero also not defined,
+		 * nlp_state is unused, this happens when
+		 * an initiator has logged
+		 * into us so cleanup this ndlp.
+		 */
+		if ((ndlp->nlp_type == 0) && (ndlp->nlp_flag == 0) &&
+			(ndlp->nlp_state == 0))
+			lpfc_nlp_put(ndlp);
 	}
 
 	/* At this point, ALL ndlp's should be gone
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-06-14 22:23:56.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-06-14 22:29:46.000000000 -0400
@@ -605,9 +605,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	result = cmd->result;
 	sdev = cmd->device;
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
-	spin_lock_irqsave(sdev->host->host_lock, flags);
-	lpfc_cmd->pCmd = NULL;	/* This must be done before scsi_done */
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
@@ -616,6 +613,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		 * wake up the thread.
 		 */
 		spin_lock_irqsave(sdev->host->host_lock, flags);
+		lpfc_cmd->pCmd = NULL;
 		if (lpfc_cmd->waitq)
 			wake_up(lpfc_cmd->waitq);
 		spin_unlock_irqrestore(sdev->host->host_lock, flags);
@@ -686,6 +684,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	 * wake up the thread.
 	 */
 	spin_lock_irqsave(sdev->host->host_lock, flags);
+	lpfc_cmd->pCmd = NULL;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-06-14 22:23:56.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-06-14 22:29:52.000000000 -0400
@@ -3763,7 +3763,6 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_i
 			   lpfc_ctx_cmd ctx_cmd)
 {
 	struct lpfc_scsi_buf *lpfc_cmd;
-	struct scsi_cmnd *cmnd;
 	int rc = 1;
 
 	if (!(iocbq->iocb_flag &  LPFC_IO_FCP))
@@ -3773,19 +3772,20 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_i
 		return rc;
 
 	lpfc_cmd = container_of(iocbq, struct lpfc_scsi_buf, cur_iocbq);
-	cmnd = lpfc_cmd->pCmd;
 
-	if (cmnd == NULL)
+	if (lpfc_cmd->pCmd == NULL)
 		return rc;
 
 	switch (ctx_cmd) {
 	case LPFC_CTX_LUN:
-		if ((cmnd->device->id == tgt_id) &&
-		    (cmnd->device->lun == lun_id))
+		if ((lpfc_cmd->rdata->pnode) &&
+		    (lpfc_cmd->rdata->pnode->nlp_sid == tgt_id) &&
+		    (scsilun_to_int(&lpfc_cmd->fcp_cmnd->fcp_lun) == lun_id))
 			rc = 0;
 		break;
 	case LPFC_CTX_TGT:
-		if (cmnd->device->id == tgt_id)
+		if ((lpfc_cmd->rdata->pnode) &&
+		    (lpfc_cmd->rdata->pnode->nlp_sid == tgt_id))
 			rc = 0;
 		break;
 	case LPFC_CTX_HOST:
@@ -3995,6 +3995,7 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 	if (pmboxq->context1)
 		return MBX_NOT_FINISHED;
 
+	pmboxq->mbox_flag &= ~LPFC_MBX_WAKE;
 	/* setup wake call as IOCB callback */
 	pmboxq->mbox_cmpl = lpfc_sli_wake_mbox_wait;
 	/* setup context field to pass wait_queue pointer to wake function  */
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2008-04-10 17:07:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2008-06-14 22:29:58.000000000 -0400
@@ -216,6 +216,7 @@ lpfc_vport_create(struct fc_vport *fc_vp
 	int vpi;
 	int rc = VPORT_ERROR;
 	int status;
+	int size;
 
 	if ((phba->sli_rev < 3) ||
 		!(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED)) {
@@ -278,7 +279,20 @@ lpfc_vport_create(struct fc_vport *fc_vp
 
 	memcpy(vport->fc_portname.u.wwn, vport->fc_sparam.portName.u.wwn, 8);
 	memcpy(vport->fc_nodename.u.wwn, vport->fc_sparam.nodeName.u.wwn, 8);
-
+	size = strnlen(fc_vport->symbolic_name, LPFC_VNAME_LEN);
+	if (size) {
+		vport->vname = kzalloc(size+1, GFP_KERNEL);
+		if (!vport->vname) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
+					 "1814 Create VPORT failed. "
+					 "vname allocation failed.\n");
+			rc = VPORT_ERROR;
+			lpfc_free_vpi(phba, vpi);
+			destroy_port(vport);
+			goto error_out;
+		}
+		memcpy(vport->vname, fc_vport->symbolic_name, size+1);
+	}
 	if (fc_vport->node_name != 0)
 		u64_to_wwn(fc_vport->node_name, vport->fc_nodename.u.wwn);
 	if (fc_vport->port_name != 0)


