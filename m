From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/6] lpfc 8.3.19: Fix critical errors and crashes
Date: Sat, 20 Nov 2010 23:14:19 -0500
Message-ID: <1290312869.32645.17.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23309 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755864Ab0KUEOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Nov 2010 23:14:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix critical errors and crashes

- Replace LOF_SECURITY with LOG_SECURITY
- When calculating diag test memory size, use full size with header.
- Return LS_RJT with status=UNSUPPORTED on unrecognized ELS's
- Correct NULL pointer dereference when lpfc_create_vport_work_array()
  returns NULL.
- Added code to handle CVL when port is in LPFC_VPORT_FAILED state.
- In lpfc_do_scr_ns_plogi, check the nodelist for FDMI_DID and reuse
  the resource.
- Check for generic request 64 and calculate the sgl offset for the request
  and reply sgls, also calculate the xmit length using only the request bde.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c     |    4 +--
 lpfc_els.c     |   31 ++++++++++++++++++++--------
 lpfc_hbadisc.c |    9 ++++++++
 lpfc_init.c    |    6 +++--
 lpfc_logmsg.h  |    2 -
 lpfc_sli.c     |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 99 insertions(+), 14 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-11-19 16:08:26.000000000 -0500
@@ -2162,7 +2162,7 @@ lpfc_bsg_diag_test(struct fc_bsg_job *jo
 		goto loopback_test_exit;
 	}
 
-	if (size >= BUF_SZ_4K) {
+	if (full_size >= BUF_SZ_4K) {
 		/*
 		 * Allocate memory for ioctl data. If buffer is bigger than 64k,
 		 * then we allocate 64k and re-use that buffer over and over to
@@ -2171,7 +2171,7 @@ lpfc_bsg_diag_test(struct fc_bsg_job *jo
 		 * problem with GET_FCPTARGETMAPPING...
 		 */
 		if (size <= (64 * 1024))
-			total_mem = size;
+			total_mem = full_size;
 		else
 			total_mem = 64 * 1024;
 	} else
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-11-19 16:08:26.000000000 -0500
@@ -6201,7 +6201,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 			cmd, did, vport->port_state);
 
 		/* Unsupported ELS command, reject */
-		rjt_err = LSRJT_INVALID_CMD;
+		rjt_err = LSRJT_CMD_UNSUPPORTED;
 
 		/* Unknown ELS command <elsCmd> received from NPORT <did> */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
@@ -6408,18 +6408,31 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 	}
 
 	if (vport->cfg_fdmi_on) {
-		ndlp_fdmi = mempool_alloc(phba->nlp_mem_pool,
-					  GFP_KERNEL);
+		/* If this is the first time, allocate an ndlp and initialize
+		 * it. Otherwise, make sure the node is enabled and then do the
+		 * login.
+		 */
+		ndlp_fdmi = lpfc_findnode_did(vport, FDMI_DID);
+		if (!ndlp_fdmi) {
+			ndlp_fdmi = mempool_alloc(phba->nlp_mem_pool,
+						  GFP_KERNEL);
+			if (ndlp_fdmi) {
+				lpfc_nlp_init(vport, ndlp_fdmi, FDMI_DID);
+				ndlp_fdmi->nlp_type |= NLP_FABRIC;
+			} else
+				return;
+		}
+		if (!NLP_CHK_NODE_ACT(ndlp_fdmi))
+			ndlp_fdmi = lpfc_enable_node(vport,
+						     ndlp_fdmi,
+						     NLP_STE_NPR_NODE);
+
 		if (ndlp_fdmi) {
-			lpfc_nlp_init(vport, ndlp_fdmi, FDMI_DID);
-			ndlp_fdmi->nlp_type |= NLP_FABRIC;
 			lpfc_nlp_set_state(vport, ndlp_fdmi,
-				NLP_STE_PLOGI_ISSUE);
-			lpfc_issue_els_plogi(vport, ndlp_fdmi->nlp_DID,
-					     0);
+					   NLP_STE_PLOGI_ISSUE);
+			lpfc_issue_els_plogi(vport, ndlp_fdmi->nlp_DID, 0);
 		}
 	}
-	return;
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-11-19 16:08:26.000000000 -0500
@@ -4059,6 +4059,11 @@ lpfc_unreg_hba_rpis(struct lpfc_hba *phb
 	int i;
 
 	vports = lpfc_create_vport_work_array(phba);
+	if (!vports) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+			"2884 Vport array allocation failed \n");
+		return;
+	}
 	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 		shost = lpfc_shost_from_vport(vports[i]);
 		spin_lock_irq(shost->host_lock);
@@ -5254,6 +5259,10 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 
 	vports = lpfc_create_vport_work_array(phba);
 
+	/* If driver cannot allocate memory, indicate fcf is in use */
+	if (!vports)
+		return 1;
+
 	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 		shost = lpfc_shost_from_vport(vports[i]);
 		spin_lock_irq(shost->host_lock);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-11-19 16:08:26.000000000 -0500
@@ -3247,10 +3247,12 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_
 		if (!ndlp)
 			return 0;
 	}
-	if (phba->pport->port_state < LPFC_FLOGI)
+	if ((phba->pport->port_state < LPFC_FLOGI) &&
+		(phba->pport->port_state != LPFC_VPORT_FAILED))
 		return NULL;
 	/* If virtual link is not yet instantiated ignore CVL */
-	if ((vport != phba->pport) && (vport->port_state < LPFC_FDISC))
+	if ((vport != phba->pport) && (vport->port_state < LPFC_FDISC)
+		&& (vport->port_state != LPFC_VPORT_FAILED))
 		return NULL;
 	shost = lpfc_shost_from_vport(vport);
 	if (!shost)
diff -upNr a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
--- a/drivers/scsi/lpfc/lpfc_logmsg.h	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h	2010-11-19 16:08:26.000000000 -0500
@@ -33,7 +33,7 @@
 #define LOG_FCP_ERROR	0x00001000	/* log errors, not underruns */
 #define LOG_LIBDFC	0x00002000	/* Libdfc events */
 #define LOG_VPORT	0x00004000	/* NPIV events */
-#define LOF_SECURITY	0x00008000	/* Security events */
+#define LOG_SECURITY	0x00008000	/* Security events */
 #define LOG_EVENT	0x00010000	/* CT,TEMP,DUMP, logging */
 #define LOG_FIP		0x00020000	/* FIP events */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-11-12 12:14:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-11-19 16:08:26.000000000 -0500
@@ -5863,6 +5863,8 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba,
 	IOCB_t *icmd;
 	int numBdes = 0;
 	int i = 0;
+	uint32_t offset = 0; /* accumulated offset in the sg request list */
+	int inbound = 0; /* number of sg reply entries inbound from firmware */
 
 	if (!piocbq || !sglq)
 		return xritag;
@@ -5897,6 +5899,20 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba,
 			 */
 			bde.tus.w = le32_to_cpu(bpl->tus.w);
 			sgl->sge_len = cpu_to_le32(bde.tus.f.bdeSize);
+			/* The offsets in the sgl need to be accumulated
+			 * separately for the request and reply lists.
+			 * The request is always first, the reply follows.
+			 */
+			if (piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) {
+				/* add up the reply sg entries */
+				if (bpl->tus.f.bdeFlags == BUFF_TYPE_BDE_64I)
+					inbound++;
+				/* first inbound? reset the offset */
+				if (inbound == 1)
+					offset = 0;
+				bf_set(lpfc_sli4_sge_offset, sgl, offset);
+				offset += bde.tus.f.bdeSize;
+			}
 			bpl++;
 			sgl++;
 		}
@@ -6140,6 +6156,18 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(wqe_ebde_cnt, &wqe->fcp_icmd.wqe_com, 0);
 	break;
 	case CMD_GEN_REQUEST64_CR:
+		/* For this command calculate the xmit length of the
+		 * request bde.
+		 */
+		xmit_len = 0;
+		numBdes = iocbq->iocb.un.genreq64.bdl.bdeSize /
+			sizeof(struct ulp_bde64);
+		for (i = 0; i < numBdes; i++) {
+			if (bpl[i].tus.f.bdeFlags != BUFF_TYPE_BDE_64)
+				break;
+			bde.tus.w = le32_to_cpu(bpl[i].tus.w);
+			xmit_len += bde.tus.f.bdeSize;
+		}
 		/* word3 iocb=IO_TAG wqe=request_payload_len */
 		wqe->gen_req.request_payload_len = xmit_len;
 		/* word4 iocb=parameter wqe=relative_offset memcpy */
@@ -12854,6 +12882,7 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 	struct lpfc_nodelist *act_mbx_ndlp = NULL;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	LIST_HEAD(mbox_cmd_list);
+	uint8_t restart_loop;
 
 	/* Clean up internally queued mailbox commands with the vport */
 	spin_lock_irq(&phba->hbalock);
@@ -12882,6 +12911,38 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 			mb->mbox_flag |= LPFC_MBX_IMED_UNREG;
 		}
 	}
+	/* Cleanup any mailbox completions which are not yet processed */
+	do {
+		restart_loop = 0;
+		list_for_each_entry(mb, &phba->sli.mboxq_cmpl, list) {
+			/*
+			 * If this mailox is already processed or it is
+			 * for another vport ignore it.
+			 */
+			if ((mb->vport != vport) ||
+				(mb->mbox_flag & LPFC_MBX_IMED_UNREG))
+				continue;
+
+			if ((mb->u.mb.mbxCommand != MBX_REG_LOGIN64) &&
+				(mb->u.mb.mbxCommand != MBX_REG_VPI))
+				continue;
+
+			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+			if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
+				ndlp = (struct lpfc_nodelist *)mb->context2;
+				/* Unregister the RPI when mailbox complete */
+				mb->mbox_flag |= LPFC_MBX_IMED_UNREG;
+				restart_loop = 1;
+				spin_unlock_irq(&phba->hbalock);
+				spin_lock(shost->host_lock);
+				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
+				spin_unlock(shost->host_lock);
+				spin_lock_irq(&phba->hbalock);
+				break;
+			}
+		}
+	} while (restart_loop);
+
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Release the cleaned-up mailbox commands */


