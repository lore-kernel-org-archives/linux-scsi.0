From: jsmart2021@gmail.com
Subject: [PATCH-v1 16/22] Fix crash after issuing lip reset
Date: Wed, 19 Apr 2017 21:46:35 -0700
Message-ID: <20170420044641.10657-17-jsmart2021@gmail.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35378 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941127AbdDTErW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 00:47:22 -0400
Received: by mail-oi0-f66.google.com with SMTP id g11so5674053oib.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2017 21:47:21 -0700 (PDT)
In-Reply-To: <20170420044641.10657-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

When RPI is not available, driver sends WQE with invalid RPI value and
rejected by HBA.
lpfc 0000:82:00.3: 1:3154 BLS ABORT RSP failed, data:  x3/xa0320008
and
lpfc :2753 PLOGI failure DID:FFFFFA Status:x3/xa0240008

In this case, driver accesses rpi_ids array out of bounds.

Fix:
Check return value of lpfc_sli4_alloc_rpi(). Do not allocate
lpfc_nodelist entry if RPI is not available.

When RPI is not available, we will get discovery timeouts and
command drops for some of the vports as seen below.


lpfc :0273 Unexpected discovery timeout, vport State x0
lpfc :0230 Unexpected timeout, hba link state x5
lpfc :0111 Dropping received ELS cmd Data: x0 xc90c55 x0

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c     |  4 ++++
 drivers/scsi/lpfc/lpfc_crtn.h    |  2 +-
 drivers/scsi/lpfc/lpfc_els.c     | 35 ++++++++--------------------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 47 +++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_init.c    | 49 +++++++++++++++++++++-------------------
 drivers/scsi/lpfc/lpfc_sli.c     |  3 +--
 drivers/scsi/lpfc/lpfc_vport.c   |  3 +--
 7 files changed, 79 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 18157d2..a1686c2 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2486,6 +2486,10 @@ static int lpfcdiag_loop_self_reg(struct lpfc_hba *phba, uint16_t *rpi)
 				mbox, *rpi);
 	else {
 		*rpi = lpfc_sli4_alloc_rpi(phba);
+		if (*rpi == LPFC_RPI_ALLOC_ERROR) {
+			mempool_free(mbox, phba->mbox_mem_pool);
+			return -EBUSY;
+		}
 		status = lpfc_reg_rpi(phba, phba->pport->vpi,
 				phba->pport->fc_myDID,
 				(uint8_t *)&phba->pport->fc_sparam,
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 54e6ac4..d859aff 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -99,7 +99,7 @@ void lpfc_issue_reg_vpi(struct lpfc_hba *, struct lpfc_vport *);
 
 int lpfc_check_sli_ndlp(struct lpfc_hba *, struct lpfc_sli_ring *,
 			struct lpfc_iocbq *, struct lpfc_nodelist *);
-void lpfc_nlp_init(struct lpfc_vport *, struct lpfc_nodelist *, uint32_t);
+struct lpfc_nodelist *lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did);
 struct lpfc_nodelist *lpfc_nlp_get(struct lpfc_nodelist *);
 int  lpfc_nlp_put(struct lpfc_nodelist *);
 int  lpfc_nlp_not_used(struct lpfc_nodelist *ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d6e0f58..ffdcac0 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -895,10 +895,9 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			 * Cannot find existing Fabric ndlp, so allocate a
 			 * new one
 			 */
-			ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+			ndlp = lpfc_nlp_init(vport, PT2PT_RemoteID);
 			if (!ndlp)
 				goto fail;
-			lpfc_nlp_init(vport, ndlp, PT2PT_RemoteID);
 		} else if (!NLP_CHK_NODE_ACT(ndlp)) {
 			ndlp = lpfc_enable_node(vport, ndlp,
 						NLP_STE_UNUSED_NODE);
@@ -1364,7 +1363,6 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 int
 lpfc_initial_flogi(struct lpfc_vport *vport)
 {
-	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_nodelist *ndlp;
 
 	vport->port_state = LPFC_FLOGI;
@@ -1374,10 +1372,9 @@ lpfc_initial_flogi(struct lpfc_vport *vport)
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, Fabric_DID);
 		if (!ndlp)
 			return 0;
-		lpfc_nlp_init(vport, ndlp, Fabric_DID);
 		/* Set the node type */
 		ndlp->nlp_type |= NLP_FABRIC;
 		/* Put ndlp onto node list */
@@ -1418,17 +1415,15 @@ lpfc_initial_flogi(struct lpfc_vport *vport)
 int
 lpfc_initial_fdisc(struct lpfc_vport *vport)
 {
-	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_nodelist *ndlp;
 
 	/* First look for the Fabric ndlp */
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, Fabric_DID);
 		if (!ndlp)
 			return 0;
-		lpfc_nlp_init(vport, ndlp, Fabric_DID);
 		/* Put ndlp onto node list */
 		lpfc_enqueue_node(vport, ndlp);
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
@@ -1564,14 +1559,13 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 					     phba->active_rrq_pool);
 			return ndlp;
 		}
-		new_ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_ATOMIC);
+		new_ndlp = lpfc_nlp_init(vport, ndlp->nlp_DID);
 		if (!new_ndlp) {
 			if (active_rrqs_xri_bitmap)
 				mempool_free(active_rrqs_xri_bitmap,
 					     phba->active_rrq_pool);
 			return ndlp;
 		}
-		lpfc_nlp_init(vport, new_ndlp, ndlp->nlp_DID);
 	} else if (!NLP_CHK_NODE_ACT(new_ndlp)) {
 		rc = memcmp(&ndlp->nlp_portname, name,
 			    sizeof(struct lpfc_name));
@@ -2845,10 +2839,9 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 
 	ndlp = lpfc_findnode_did(vport, nportid);
 	if (!ndlp) {
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, nportid);
 		if (!ndlp)
 			return 1;
-		lpfc_nlp_init(vport, ndlp, nportid);
 		lpfc_enqueue_node(vport, ndlp);
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
@@ -2938,10 +2931,9 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 
 	ndlp = lpfc_findnode_did(vport, nportid);
 	if (!ndlp) {
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, nportid);
 		if (!ndlp)
 			return 1;
-		lpfc_nlp_init(vport, ndlp, nportid);
 		lpfc_enqueue_node(vport, ndlp);
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
@@ -6133,7 +6125,6 @@ int
 lpfc_els_handle_rscn(struct lpfc_vport *vport)
 {
 	struct lpfc_nodelist *ndlp;
-	struct lpfc_hba *phba = vport->phba;
 
 	/* Ignore RSCN if the port is being torn down. */
 	if (vport->load_flag & FC_UNLOADING) {
@@ -6182,12 +6173,11 @@ lpfc_els_handle_rscn(struct lpfc_vport *vport)
 			}
 			ndlp->nlp_prev_state = NLP_STE_UNUSED_NODE;
 		} else {
-			ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+			ndlp = lpfc_nlp_init(vport, NameServer_DID);
 			if (!ndlp) {
 				lpfc_els_flush_rscn(vport);
 				return 0;
 			}
-			lpfc_nlp_init(vport, ndlp, NameServer_DID);
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
 		}
@@ -7746,11 +7736,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	ndlp = lpfc_findnode_did(vport, did);
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, did);
 		if (!ndlp)
 			goto dropit;
-
-		lpfc_nlp_init(vport, ndlp, did);
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		newnode = 1;
 		if ((did & Fabric_DID_MASK) == Fabric_DID_MASK)
@@ -8192,7 +8180,6 @@ lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 static void
 lpfc_start_fdmi(struct lpfc_vport *vport)
 {
-	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_nodelist *ndlp;
 
 	/* If this is the first time, allocate an ndlp and initialize
@@ -8201,9 +8188,8 @@ lpfc_start_fdmi(struct lpfc_vport *vport)
 	 */
 	ndlp = lpfc_findnode_did(vport, FDMI_DID);
 	if (!ndlp) {
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, FDMI_DID);
 		if (ndlp) {
-			lpfc_nlp_init(vport, ndlp, FDMI_DID);
 			ndlp->nlp_type |= NLP_FABRIC;
 		} else {
 			return;
@@ -8256,7 +8242,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 
 	ndlp = lpfc_findnode_did(vport, NameServer_DID);
 	if (!ndlp) {
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, NameServer_DID);
 		if (!ndlp) {
 			if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 				lpfc_disc_start(vport);
@@ -8267,7 +8253,6 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 					 "0251 NameServer login: no memory\n");
 			return;
 		}
-		lpfc_nlp_init(vport, ndlp, NameServer_DID);
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
 		if (!ndlp) {
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 180b072..d313dde 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4368,10 +4368,17 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint32_t did;
 	unsigned long flags;
 	unsigned long *active_rrqs_xri_bitmap = NULL;
+	int rpi = LPFC_RPI_ALLOC_ERROR;
 
 	if (!ndlp)
 		return NULL;
 
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		rpi = lpfc_sli4_alloc_rpi(vport->phba);
+		if (rpi == LPFC_RPI_ALLOC_ERROR)
+			return NULL;
+	}
+
 	spin_lock_irqsave(&phba->ndlp_lock, flags);
 	/* The ndlp should not be in memory free mode */
 	if (NLP_CHK_FREE_REQ(ndlp)) {
@@ -4381,7 +4388,7 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				"usgmap:x%x refcnt:%d\n",
 				(void *)ndlp, ndlp->nlp_usg_map,
 				kref_read(&ndlp->kref));
-		return NULL;
+		goto free_rpi;
 	}
 	/* The ndlp should not already be in active mode */
 	if (NLP_CHK_NODE_ACT(ndlp)) {
@@ -4391,7 +4398,7 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				"usgmap:x%x refcnt:%d\n",
 				(void *)ndlp, ndlp->nlp_usg_map,
 				kref_read(&ndlp->kref));
-		return NULL;
+		goto free_rpi;
 	}
 
 	/* Keep the original DID */
@@ -4409,7 +4416,7 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
-		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
+		ndlp->nlp_rpi = rpi;
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 				 "0008 rpi:%x DID:%x flg:%x refcnt:%d "
 				 "map:%x %p\n", ndlp->nlp_rpi, ndlp->nlp_DID,
@@ -4426,6 +4433,11 @@ lpfc_enable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		"node enable:       did:x%x",
 		ndlp->nlp_DID, 0, 0);
 	return ndlp;
+
+free_rpi:
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		lpfc_sli4_free_rpi(vport->phba, rpi);
+	return NULL;
 }
 
 void
@@ -5107,11 +5119,9 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		if ((vport->fc_flag & FC_RSCN_MODE) != 0 &&
 		    lpfc_rscn_payload_check(vport, did) == 0)
 			return NULL;
-		ndlp = (struct lpfc_nodelist *)
-		     mempool_alloc(vport->phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, did);
 		if (!ndlp)
 			return NULL;
-		lpfc_nlp_init(vport, ndlp, did);
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		if (vport->phba->nvmet_support)
 			return ndlp;
@@ -5887,16 +5897,31 @@ lpfc_find_vport_by_vpid(struct lpfc_hba *phba, uint16_t vpi)
 	return NULL;
 }
 
-void
-lpfc_nlp_init(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
-	      uint32_t did)
+struct lpfc_nodelist *
+lpfc_nlp_init(struct lpfc_vport *vport, uint32_t did)
 {
+	struct lpfc_nodelist *ndlp;
+	int rpi = LPFC_RPI_ALLOC_ERROR;
+
+	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
+		rpi = lpfc_sli4_alloc_rpi(vport->phba);
+		if (rpi == LPFC_RPI_ALLOC_ERROR)
+			return NULL;
+	}
+
+	ndlp = mempool_alloc(vport->phba->nlp_mem_pool, GFP_KERNEL);
+	if (!ndlp) {
+		if (vport->phba->sli_rev == LPFC_SLI_REV4)
+			lpfc_sli4_free_rpi(vport->phba, rpi);
+		return NULL;
+	}
+
 	memset(ndlp, 0, sizeof (struct lpfc_nodelist));
 
 	lpfc_initialize_node(vport, ndlp, did);
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
-		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
+		ndlp->nlp_rpi = rpi;
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 				 "0007 rpi:%x DID:%x flg:%x refcnt:%d "
 				 "map:%x %p\n", ndlp->nlp_rpi, ndlp->nlp_DID,
@@ -5918,7 +5943,7 @@ lpfc_nlp_init(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		"node init:       did:x%x",
 		ndlp->nlp_DID, 0, 0);
 
-	return;
+	return ndlp;
 }
 
 /* This routine releases all resources associated with a specifc NPort's ndlp
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 88977b8..61bf14c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2874,34 +2874,38 @@ lpfc_sli4_node_prep(struct lpfc_hba *phba)
 {
 	struct lpfc_nodelist  *ndlp, *next_ndlp;
 	struct lpfc_vport **vports;
-	int i;
+	int i, rpi;
+	unsigned long flags;
 
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		return;
 
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL) {
-		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
-			if (vports[i]->load_flag & FC_UNLOADING)
-				continue;
+	if (vports == NULL)
+		return;
 
-			list_for_each_entry_safe(ndlp, next_ndlp,
-						 &vports[i]->fc_nodes,
-						 nlp_listp) {
-				if (NLP_CHK_NODE_ACT(ndlp)) {
-					ndlp->nlp_rpi =
-						lpfc_sli4_alloc_rpi(phba);
-					lpfc_printf_vlog(ndlp->vport, KERN_INFO,
-							 LOG_NODE,
-							 "0009 rpi:%x DID:%x "
-							 "flg:%x map:%x %p\n",
-							 ndlp->nlp_rpi,
-							 ndlp->nlp_DID,
-							 ndlp->nlp_flag,
-							 ndlp->nlp_usg_map,
-							 ndlp);
-				}
+	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
+		if (vports[i]->load_flag & FC_UNLOADING)
+			continue;
+
+		list_for_each_entry_safe(ndlp, next_ndlp,
+					 &vports[i]->fc_nodes,
+					 nlp_listp) {
+			if (!NLP_CHK_NODE_ACT(ndlp))
+				continue;
+			rpi = lpfc_sli4_alloc_rpi(phba);
+			if (rpi == LPFC_RPI_ALLOC_ERROR) {
+				spin_lock_irqsave(&phba->ndlp_lock, flags);
+				NLP_CLR_NODE_ACT(ndlp);
+				spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+				continue;
 			}
+			ndlp->nlp_rpi = rpi;
+			lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
+					 "0009 rpi:%x DID:%x "
+					 "flg:%x map:%x %p\n", ndlp->nlp_rpi,
+					 ndlp->nlp_DID, ndlp->nlp_flag,
+					 ndlp->nlp_usg_map, ndlp);
 		}
 	}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -4722,10 +4726,9 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_vport *vport)
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, Fabric_DID);
 		if (!ndlp)
 			return 0;
-		lpfc_nlp_init(vport, ndlp, Fabric_DID);
 		/* Set the node type */
 		ndlp->nlp_type |= NLP_FABRIC;
 		/* Put ndlp onto node list */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1519fdf..a6adc2b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -16542,14 +16542,13 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 
 	ndlp = lpfc_findnode_did(vport, sid);
 	if (!ndlp) {
-		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+		ndlp = lpfc_nlp_init(vport, sid);
 		if (!ndlp) {
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
 					 "1268 Failed to allocate ndlp for "
 					 "oxid:x%x SID:x%x\n", oxid, sid);
 			return;
 		}
-		lpfc_nlp_init(vport, ndlp, sid);
 		/* Put ndlp onto pport node list */
 		lpfc_enqueue_node(vport, ndlp);
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 9a0339d..c714482 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -738,10 +738,9 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		ndlp = lpfc_findnode_did(vport, Fabric_DID);
 		if (!ndlp) {
 			/* Cannot find existing Fabric ndlp, allocate one */
-			ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
+			ndlp = lpfc_nlp_init(vport, Fabric_DID);
 			if (!ndlp)
 				goto skip_logo;
-			lpfc_nlp_init(vport, ndlp, Fabric_DID);
 			/* Indicate free memory when release */
 			NLP_SET_FREE_REQ(ndlp);
 		} else {
-- 
2.1.0
