From: James Smart <james.smart@emulex.com>
Subject: [PATCH v3 14/20] lpfc: Fix premature release of rpi bit in
 bitmask
Date: Tue, 7 Apr 2015 15:07:22 -0400
Message-ID: <55242aea.fWo84uZUz/4JDwbt%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:27592 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbbDGTIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:08:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix premature release of rpi bit in bitmask

Currently, the driver plays off the fact that older sli4 adapters have a
different rpi access pattern that allowed for the rpi reference to be
released earlier in the teardown sequence, allowing the driver to recycle
the rpi value sooner. Newer sli4 adapters have a different access pattern that
requires us to wait for a later mailbox completion. This changes the put
call location on the newer sli4 adapters.

Symptoms of the error are "0110 ELS" and the "0372 iotag" errors.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h    |  1 +
 drivers/scsi/lpfc/lpfc_els.c     |  5 ++++
 drivers/scsi/lpfc/lpfc_hbadisc.c | 60 +++++++++++++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_init.c    | 24 ++++++++++++++--
 drivers/scsi/lpfc/lpfc_sli.c     | 49 ++++++++++++++++++++++++++++++--
 5 files changed, 127 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 665c88c..dd01ea8 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -284,6 +284,7 @@ void lpfc_sli_handle_slow_ring_event(struct lpfc_hba *,
 				    struct lpfc_sli_ring *, uint32_t);
 void lpfc_sli4_handle_received_buffer(struct lpfc_hba *, struct hbq_dmabuf *);
 void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
 			struct lpfc_iocbq *, uint32_t);
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f73d58c..ba5da26 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3700,6 +3700,11 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
 	if (ndlp) {
+		lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
+				 "0006 rpi%x DID:%x flg:%x %d map:%x %p\n",
+				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
+				 atomic_read(&ndlp->kref.refcount),
+				 ndlp->nlp_usg_map, ndlp);
 		if (NLP_CHK_NODE_ACT(ndlp)) {
 			lpfc_nlp_put(ndlp);
 			/* This is the end of the default RPI cleanup logic for
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9d06d45..2a51df7 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3439,6 +3439,11 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	pmb->context1 = NULL;
 	pmb->context2 = NULL;
 
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+			 "0002 rpi:%x DID:%x flg:%x %d map:%x %p\n",
+			 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
+			 atomic_read(&ndlp->kref.refcount),
+			 ndlp->nlp_usg_map, ndlp);
 	if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
 		ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 
@@ -3855,6 +3860,11 @@ out:
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+			 "0003 rpi:%x DID:%x flg:%x %d map%x %p\n",
+			 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
+			 atomic_read(&ndlp->kref.refcount),
+			 ndlp->nlp_usg_map, ndlp);
 
 	if (vport->port_state < LPFC_VPORT_READY) {
 		/* Link up discovery requires Fabric registration. */
@@ -4250,8 +4260,15 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		ndlp->active_rrqs_xri_bitmap = active_rrqs_xri_bitmap;
 
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
-	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+				 "0008 rpi:%x DID:%x flg:%x refcnt:%d "
+				 "map:%x %p\n", ndlp->nlp_rpi, ndlp->nlp_DID,
+				 ndlp->nlp_flag,
+				 atomic_read(&ndlp->kref.refcount),
+				 ndlp->nlp_usg_map, ndlp);
+	}
 
 
 	if (state != NLP_STE_UNUSED_NODE)
@@ -4276,9 +4293,12 @@ lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 		return;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
-	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		lpfc_cleanup_vports_rrqs(vport, ndlp);
-	lpfc_nlp_put(ndlp);
+		lpfc_unreg_rpi(vport, ndlp);
+	} else {
+		lpfc_nlp_put(ndlp);
+	}
 	return;
 }
 
@@ -4515,7 +4535,17 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				mbox->context1 = ndlp;
 				mbox->mbox_cmpl = lpfc_nlp_logo_unreg;
 			} else {
-				mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+				if (phba->sli_rev == LPFC_SLI_REV4 &&
+				    (!(vport->load_flag & FC_UNLOADING)) &&
+				    (bf_get(lpfc_sli_intf_if_type,
+				     &phba->sli4_hba.sli_intf) ==
+				      LPFC_SLI_INTF_IF_TYPE_2)) {
+					mbox->context1 = lpfc_nlp_get(ndlp);
+					mbox->mbox_cmpl =
+						lpfc_sli4_unreg_rpi_cmpl_clr;
+				} else
+					mbox->mbox_cmpl =
+						lpfc_sli_def_mbox_cmpl;
 			}
 
 			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
@@ -4741,6 +4771,11 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		/* For this case we need to cleanup the default rpi
 		 * allocated by the firmware.
 		 */
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+				 "0005 rpi:%x DID:%x flg:%x %d map:%x %p\n",
+				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
+				 atomic_read(&ndlp->kref.refcount),
+				 ndlp->nlp_usg_map, ndlp);
 		if ((mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))
 			!= NULL) {
 			rc = lpfc_reg_rpi(phba, vport->vpi, ndlp->nlp_DID,
@@ -5482,7 +5517,11 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
-
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+			 "0004 rpi:%x DID:%x flg:%x %d map:%x %p\n",
+			 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
+			 atomic_read(&ndlp->kref.refcount),
+			 ndlp->nlp_usg_map, ndlp);
 	/*
 	 * Start issuing Fabric-Device Management Interface (FDMI) command to
 	 * 0xfffffa (FDMI well known port) or Delay issuing FDMI command if
@@ -5648,6 +5687,13 @@ lpfc_nlp_init(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+				 "0007 rpi:%x DID:%x flg:%x refcnt:%d "
+				 "map:%x %p\n", ndlp->nlp_rpi, ndlp->nlp_DID,
+				 ndlp->nlp_flag,
+				 atomic_read(&ndlp->kref.refcount),
+				 ndlp->nlp_usg_map, ndlp);
+
 		ndlp->active_rrqs_xri_bitmap =
 				mempool_alloc(vport->phba->active_rrq_pool,
 					      GFP_KERNEL);
@@ -5682,9 +5728,9 @@ lpfc_nlp_release(struct kref *kref)
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
 			"0279 lpfc_nlp_release: ndlp:x%p did %x "
-			"usgmap:x%x refcnt:%d\n",
+			"usgmap:x%x refcnt:%d rpi:%x\n",
 			(void *)ndlp, ndlp->nlp_DID, ndlp->nlp_usg_map,
-			atomic_read(&ndlp->kref.refcount));
+			atomic_read(&ndlp->kref.refcount), ndlp->nlp_rpi);
 
 	/* remove ndlp from action. */
 	lpfc_nlp_remove(ndlp->vport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4947cc4..166b2c7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2775,9 +2775,19 @@ lpfc_sli4_node_prep(struct lpfc_hba *phba)
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
 						 nlp_listp) {
-				if (NLP_CHK_NODE_ACT(ndlp))
+				if (NLP_CHK_NODE_ACT(ndlp)) {
 					ndlp->nlp_rpi =
 						lpfc_sli4_alloc_rpi(phba);
+					lpfc_printf_vlog(ndlp->vport, KERN_INFO,
+							 LOG_NODE,
+							 "0009 rpi:%x DID:%x "
+							 "flg:%x map:%x %p\n",
+							 ndlp->nlp_rpi,
+							 ndlp->nlp_DID,
+							 ndlp->nlp_flag,
+							 ndlp->nlp_usg_map,
+							 ndlp);
+				}
 			}
 		}
 	}
@@ -2941,8 +2951,18 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 				 * RPI. Get a new RPI when the adapter port
 				 * comes back online.
 				 */
-				if (phba->sli_rev == LPFC_SLI_REV4)
+				if (phba->sli_rev == LPFC_SLI_REV4) {
+					lpfc_printf_vlog(ndlp->vport,
+							 KERN_INFO, LOG_NODE,
+							 "0011 lpfc_offline: "
+							 "ndlp:x%p did %x "
+							 "usgmap:x%x rpi:%x\n",
+							 ndlp, ndlp->nlp_DID,
+							 ndlp->nlp_usg_map,
+							 ndlp->nlp_rpi);
+
 					lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
+				}
 				lpfc_unreg_rpi(vports[i], ndlp);
 			}
 		}
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 303b231..c76c2a1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2213,6 +2213,46 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	else
 		mempool_free(pmb, phba->mbox_mem_pool);
 }
+ /**
+ * lpfc_sli4_unreg_rpi_cmpl_clr - mailbox completion handler
+ * @phba: Pointer to HBA context object.
+ * @pmb: Pointer to mailbox object.
+ *
+ * This function is the unreg rpi mailbox completion handler. It
+ * frees the memory resources associated with the completed mailbox
+ * command. An additional refrenece is put on the ndlp to prevent
+ * lpfc_nlp_release from freeing the rpi bit in the bitmask before
+ * the unreg mailbox command completes, this routine puts the
+ * reference back.
+ *
+ **/
+void
+lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	struct lpfc_vport  *vport = pmb->vport;
+	struct lpfc_nodelist *ndlp;
+
+	ndlp = pmb->context1;
+	if (pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) {
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+		    (bf_get(lpfc_sli_intf_if_type,
+		     &phba->sli4_hba.sli_intf) ==
+		     LPFC_SLI_INTF_IF_TYPE_2)) {
+			if (ndlp) {
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+						 "0010 UNREG_LOGIN vpi:%x "
+						 "rpi:%x DID:%x map:%x %p\n",
+						 vport->vpi, ndlp->nlp_rpi,
+						 ndlp->nlp_DID,
+						 ndlp->nlp_usg_map, ndlp);
+
+				lpfc_nlp_put(ndlp);
+			}
+		}
+	}
+
+	mempool_free(pmb, phba->mbox_mem_pool);
+}
 
 /**
  * lpfc_sli_handle_mb_event - Handle mailbox completions from firmware
@@ -15659,14 +15699,14 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
 	struct lpfc_rpi_hdr *rpi_hdr;
 	unsigned long iflag;
 
-	max_rpi = phba->sli4_hba.max_cfg_param.max_rpi;
-	rpi_limit = phba->sli4_hba.next_rpi;
-
 	/*
 	 * Fetch the next logical rpi.  Because this index is logical,
 	 * the  driver starts at 0 each time.
 	 */
 	spin_lock_irqsave(&phba->hbalock, iflag);
+	max_rpi = phba->sli4_hba.max_cfg_param.max_rpi;
+	rpi_limit = phba->sli4_hba.next_rpi;
+
 	rpi = find_next_zero_bit(phba->sli4_hba.rpi_bmask, rpi_limit, 0);
 	if (rpi >= rpi_limit)
 		rpi = LPFC_RPI_ALLOC_ERROR;
@@ -15675,6 +15715,9 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
 		phba->sli4_hba.max_cfg_param.rpi_used++;
 		phba->sli4_hba.rpi_count++;
 	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"0001 rpi:%x max:%x lim:%x\n",
+			(int) rpi, max_rpi, rpi_limit);
 
 	/*
 	 * Don't try to allocate more rpi header regions if the device limit
-- 
1.7.11.7

