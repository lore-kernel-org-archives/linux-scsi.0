From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/7] lpfc 8.3.44: Fix kernel panics from corrupted ndlp list.
Date: Mon, 2 Dec 2013 12:48:58 -0500
Message-ID: <1386006538.11046.12.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:42166 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3LBRtq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 12:49:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix kernel panics from corrupted ndlp list.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    2 +
 lpfc_crtn.h    |    1 
 lpfc_disc.h    |    2 -
 lpfc_els.c     |   80 +++++++++++++++++++++++++++++++++++++++------------------
 lpfc_hbadisc.c |   21 ++++++++++++--
 lpfc_init.c    |    3 ++
 lpfc_mem.c     |   22 +++++++++++++++
 lpfc_sli.c     |   11 +++++--
 8 files changed, 110 insertions(+), 32 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2013-11-26 21:45:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2013-12-02 11:52:15.622242133 -0500
@@ -242,6 +242,7 @@ int lpfc_sli4_fcf_rr_next_proc(struct lp
 void lpfc_sli4_clear_fcf_rr_bmask(struct lpfc_hba *);
 
 int lpfc_mem_alloc(struct lpfc_hba *, int align);
+int lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *);
 void lpfc_mem_free(struct lpfc_hba *);
 void lpfc_mem_free_all(struct lpfc_hba *);
 void lpfc_stop_vport_timers(struct lpfc_vport *);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2013-11-26 21:45:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2013-12-02 11:52:15.623242133 -0500
@@ -116,7 +116,7 @@ struct lpfc_nodelist {
 	atomic_t cmd_pending;
 	uint32_t cmd_qdepth;
 	unsigned long last_change_time;
-	struct lpfc_node_rrqs active_rrqs;
+	unsigned long *active_rrqs_xri_bitmap;
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
 };
 struct lpfc_node_rrq {
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2013-12-02 11:52:13.063242075 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2013-12-02 11:52:15.626242133 -0500
@@ -1516,7 +1516,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	uint32_t rc, keepDID = 0;
 	int  put_node;
 	int  put_rport;
-	struct lpfc_node_rrqs rrq;
+	unsigned long *active_rrqs_xri_bitmap = NULL;
 
 	/* Fabric nodes can have the same WWPN so we don't bother searching
 	 * by WWPN.  Just return the ndlp that was given to us.
@@ -1534,7 +1534,13 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 
 	if (new_ndlp == ndlp && NLP_CHK_NODE_ACT(new_ndlp))
 		return ndlp;
-	memset(&rrq.xri_bitmap, 0, sizeof(new_ndlp->active_rrqs.xri_bitmap));
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		active_rrqs_xri_bitmap = mempool_alloc(phba->active_rrq_pool,
+						       GFP_KERNEL);
+		if (active_rrqs_xri_bitmap)
+			memset(active_rrqs_xri_bitmap, 0,
+			       phba->cfg_rrq_xri_bitmap_sz);
+	}
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 		 "3178 PLOGI confirm: ndlp %p x%x: new_ndlp %p\n",
@@ -1543,41 +1549,58 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	if (!new_ndlp) {
 		rc = memcmp(&ndlp->nlp_portname, name,
 			    sizeof(struct lpfc_name));
-		if (!rc)
+		if (!rc) {
+			if (active_rrqs_xri_bitmap)
+				mempool_free(active_rrqs_xri_bitmap,
+					     phba->active_rrq_pool);
 			return ndlp;
+		}
 		new_ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_ATOMIC);
-		if (!new_ndlp)
+		if (!new_ndlp) {
+			if (active_rrqs_xri_bitmap)
+				mempool_free(active_rrqs_xri_bitmap,
+					     phba->active_rrq_pool);
 			return ndlp;
+		}
 		lpfc_nlp_init(vport, new_ndlp, ndlp->nlp_DID);
 	} else if (!NLP_CHK_NODE_ACT(new_ndlp)) {
 		rc = memcmp(&ndlp->nlp_portname, name,
 			    sizeof(struct lpfc_name));
-		if (!rc)
+		if (!rc) {
+			if (active_rrqs_xri_bitmap)
+				mempool_free(active_rrqs_xri_bitmap,
+					     phba->active_rrq_pool);
 			return ndlp;
+		}
 		new_ndlp = lpfc_enable_node(vport, new_ndlp,
 						NLP_STE_UNUSED_NODE);
-		if (!new_ndlp)
+		if (!new_ndlp) {
+			if (active_rrqs_xri_bitmap)
+				mempool_free(active_rrqs_xri_bitmap,
+					     phba->active_rrq_pool);
 			return ndlp;
+		}
 		keepDID = new_ndlp->nlp_DID;
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			memcpy(&rrq.xri_bitmap,
-				&new_ndlp->active_rrqs.xri_bitmap,
-				sizeof(new_ndlp->active_rrqs.xri_bitmap));
+		if ((phba->sli_rev == LPFC_SLI_REV4) && active_rrqs_xri_bitmap)
+			memcpy(active_rrqs_xri_bitmap,
+			       new_ndlp->active_rrqs_xri_bitmap,
+			       phba->cfg_rrq_xri_bitmap_sz);
 	} else {
 		keepDID = new_ndlp->nlp_DID;
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			memcpy(&rrq.xri_bitmap,
-				&new_ndlp->active_rrqs.xri_bitmap,
-				sizeof(new_ndlp->active_rrqs.xri_bitmap));
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+		    active_rrqs_xri_bitmap)
+			memcpy(active_rrqs_xri_bitmap,
+			       new_ndlp->active_rrqs_xri_bitmap,
+			       phba->cfg_rrq_xri_bitmap_sz);
 	}
 
 	lpfc_unreg_rpi(vport, new_ndlp);
 	new_ndlp->nlp_DID = ndlp->nlp_DID;
 	new_ndlp->nlp_prev_state = ndlp->nlp_prev_state;
 	if (phba->sli_rev == LPFC_SLI_REV4)
-		memcpy(new_ndlp->active_rrqs.xri_bitmap,
-			&ndlp->active_rrqs.xri_bitmap,
-			sizeof(ndlp->active_rrqs.xri_bitmap));
+		memcpy(new_ndlp->active_rrqs_xri_bitmap,
+		       ndlp->active_rrqs_xri_bitmap,
+		       phba->cfg_rrq_xri_bitmap_sz);
 
 	if (ndlp->nlp_flag & NLP_NPR_2B_DISC)
 		new_ndlp->nlp_flag |= NLP_NPR_2B_DISC;
@@ -1619,10 +1642,11 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 
 		/* Two ndlps cannot have the same did on the nodelist */
 		ndlp->nlp_DID = keepDID;
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			memcpy(&ndlp->active_rrqs.xri_bitmap,
-				&rrq.xri_bitmap,
-				sizeof(ndlp->active_rrqs.xri_bitmap));
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+		    active_rrqs_xri_bitmap)
+			memcpy(ndlp->active_rrqs_xri_bitmap,
+			       active_rrqs_xri_bitmap,
+			       phba->cfg_rrq_xri_bitmap_sz);
 		lpfc_drop_node(vport, ndlp);
 	}
 	else {
@@ -1634,10 +1658,11 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 
 		/* Two ndlps cannot have the same did */
 		ndlp->nlp_DID = keepDID;
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			memcpy(&ndlp->active_rrqs.xri_bitmap,
-				&rrq.xri_bitmap,
-				sizeof(ndlp->active_rrqs.xri_bitmap));
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+		    active_rrqs_xri_bitmap)
+			memcpy(ndlp->active_rrqs_xri_bitmap,
+			       active_rrqs_xri_bitmap,
+			       phba->cfg_rrq_xri_bitmap_sz);
 
 		/* Since we are swapping the ndlp passed in with the new one
 		 * and the did has already been swapped, copy over state.
@@ -1668,6 +1693,10 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 				put_device(&rport->dev);
 		}
 	}
+	if (phba->sli_rev == LPFC_SLI_REV4 &&
+	    active_rrqs_xri_bitmap)
+		mempool_free(active_rrqs_xri_bitmap,
+			     phba->active_rrq_pool);
 	return new_ndlp;
 }
 
@@ -2772,6 +2801,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
 	/* This will cause the callback-function lpfc_cmpl_els_cmd to
 	 * trigger the release of node.
 	 */
+
 	lpfc_nlp_put(ndlp);
 	return 0;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2013-11-26 21:45:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2013-12-02 11:52:15.627242133 -0500
@@ -730,6 +730,7 @@ struct lpfc_hba {
 	uint32_t cfg_request_firmware_upgrade;
 	uint32_t cfg_iocb_cnt;
 	uint32_t cfg_suppress_link_up;
+	uint32_t cfg_rrq_xri_bitmap_sz;
 #define LPFC_INITIALIZE_LINK              0	/* do normal init_link mbox */
 #define LPFC_DELAY_INIT_LINK              1	/* layered driver hold off */
 #define LPFC_DELAY_INIT_LINK_INDEFINITELY 2	/* wait, manual intervention */
@@ -835,6 +836,7 @@ struct lpfc_hba {
 	mempool_t *mbox_mem_pool;
 	mempool_t *nlp_mem_pool;
 	mempool_t *rrq_pool;
+	mempool_t *active_rrq_pool;
 
 	struct fc_host_statistics link_stats;
 	enum intr_type_t intr_type;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-12-02 11:52:11.575242041 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-12-02 11:52:15.635242133 -0500
@@ -4186,6 +4186,7 @@ lpfc_enable_node(struct lpfc_vport *vpor
 	struct lpfc_hba *phba = vport->phba;
 	uint32_t did;
 	unsigned long flags;
+	unsigned long *active_rrqs_xri_bitmap = NULL;
 
 	if (!ndlp)
 		return NULL;
@@ -4214,12 +4215,17 @@ lpfc_enable_node(struct lpfc_vport *vpor
 
 	/* Keep the original DID */
 	did = ndlp->nlp_DID;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		active_rrqs_xri_bitmap = ndlp->active_rrqs_xri_bitmap;
 
 	/* re-initialize ndlp except of ndlp linked list pointer */
 	memset((((char *)ndlp) + sizeof (struct list_head)), 0,
 		sizeof (struct lpfc_nodelist) - sizeof (struct list_head));
 	lpfc_initialize_node(vport, ndlp, did);
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		ndlp->active_rrqs_xri_bitmap = active_rrqs_xri_bitmap;
+
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
 	if (vport->phba->sli_rev == LPFC_SLI_REV4)
 		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
@@ -4805,9 +4811,10 @@ __lpfc_findnode_did(struct lpfc_vport *v
 				 ((uint32_t) ndlp->nlp_rpi & 0xff));
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 					 "0929 FIND node DID "
-					 "Data: x%p x%x x%x x%x\n",
+					 "Data: x%p x%x x%x x%x %p\n",
 					 ndlp, ndlp->nlp_DID,
-					 ndlp->nlp_flag, data1);
+					 ndlp->nlp_flag, data1,
+					 ndlp->active_rrqs_xri_bitmap);
 			return ndlp;
 		}
 	}
@@ -5624,8 +5631,13 @@ lpfc_nlp_init(struct lpfc_vport *vport,
 
 	lpfc_initialize_node(vport, ndlp, did);
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
-	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
+		ndlp->active_rrqs_xri_bitmap =
+				mempool_alloc(vport->phba->active_rrq_pool,
+					      GFP_KERNEL);
+	}
+
 

 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
@@ -5670,6 +5682,9 @@ lpfc_nlp_release(struct kref *kref)
 	/* free ndlp memory for final ndlp release */
 	if (NLP_CHK_FREE_REQ(ndlp)) {
 		kfree(ndlp->lat_data);
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			mempool_free(ndlp->active_rrqs_xri_bitmap,
+				     ndlp->phba->active_rrq_pool);
 		mempool_free(ndlp, ndlp->phba->nlp_mem_pool);
 	}
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-12-02 10:31:27.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-12-02 11:52:15.642242133 -0500
@@ -5061,6 +5061,9 @@ lpfc_sli4_driver_resource_setup(struct l
 	rc = lpfc_sli4_read_config(phba);
 	if (unlikely(rc))
 		goto out_free_bsmbx;
+	rc = lpfc_mem_alloc_active_rrq_pool_s4(phba);
+	if (unlikely(rc))
+		goto out_free_bsmbx;
 
 	/* IF Type 0 ports get initialized now. */
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2013-11-26 21:45:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2013-12-02 11:52:15.649242134 -0500
@@ -38,10 +38,28 @@
 #include "lpfc_scsi.h"
 #include "lpfc.h"
 #include "lpfc_crtn.h"
+#include "lpfc_logmsg.h"
 
 #define LPFC_MBUF_POOL_SIZE     64      /* max elements in MBUF safety pool */
 #define LPFC_MEM_POOL_SIZE      64      /* max elem in non-DMA safety pool */
 
+int
+lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *phba) {
+	size_t bytes;
+	int max_xri = phba->sli4_hba.max_cfg_param.max_xri;
+
+	if (max_xri <= 0)
+		return -ENOMEM;
+	bytes = ((BITS_PER_LONG - 1 + max_xri) / BITS_PER_LONG) *
+		  sizeof(unsigned long);
+	phba->cfg_rrq_xri_bitmap_sz = bytes;
+	phba->active_rrq_pool = mempool_create_kmalloc_pool(LPFC_MEM_POOL_SIZE,
+							    bytes);
+	if (!phba->active_rrq_pool)
+		return -ENOMEM;
+	else
+		return 0;
+}
 
 /**
  * lpfc_mem_alloc - create and allocate all PCI and memory pools
@@ -209,6 +227,10 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	/* Free NLP memory pool */
 	mempool_destroy(phba->nlp_mem_pool);
 	phba->nlp_mem_pool = NULL;
+	if (phba->sli_rev == LPFC_SLI_REV4 && phba->active_rrq_pool) {
+		mempool_destroy(phba->active_rrq_pool);
+		phba->active_rrq_pool = NULL;
+	}
 
 	/* Free mbox memory pool */
 	mempool_destroy(phba->mbox_mem_pool);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-12-02 11:52:02.485241835 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-12-02 11:52:15.661242134 -0500
@@ -635,7 +635,7 @@ lpfc_clr_rrq_active(struct lpfc_hba *phb
 	if (!ndlp)
 		goto out;
 
-	if (test_and_clear_bit(xritag, ndlp->active_rrqs.xri_bitmap)) {
+	if (test_and_clear_bit(xritag, ndlp->active_rrqs_xri_bitmap)) {
 		rrq->send_rrq = 0;
 		rrq->xritag = 0;
 		rrq->rrq_stop_time = 0;
@@ -813,7 +813,9 @@ lpfc_test_rrq_active(struct lpfc_hba *ph
 {
 	if (!ndlp)
 		return 0;
-	if (test_bit(xritag, ndlp->active_rrqs.xri_bitmap))
+	if (!ndlp->active_rrqs_xri_bitmap)
+		return 0;
+	if (test_bit(xritag, ndlp->active_rrqs_xri_bitmap))
 			return 1;
 	else
 		return 0;
@@ -863,7 +865,10 @@ lpfc_set_rrq_active(struct lpfc_hba *phb
 	if (ndlp->vport && (ndlp->vport->load_flag & FC_UNLOADING))
 		goto out;
 
-	if (test_and_set_bit(xritag, ndlp->active_rrqs.xri_bitmap))
+	if (!ndlp->active_rrqs_xri_bitmap)
+		goto out;
+
+	if (test_and_set_bit(xritag, ndlp->active_rrqs_xri_bitmap))
 		goto out;
 
 	spin_unlock_irqrestore(&phba->hbalock, iflags);



