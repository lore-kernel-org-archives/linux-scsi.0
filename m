From: James.Smart@Emulex.Com
Subject: [PATCH 8/15]  lpfc 8.1.0 : Remove RPI hash from the driver
Date: Fri, 28 Oct 2005 20:29:36 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A57@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:4817 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750927AbVJ2A3j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:39 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0TcDp018533
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:38 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove RPI hash from the driver.

Fix: Table was not providing a lot of value and injected a couple of
  errors. Removed it and made functionality inline.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -890,10 +890,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 
 	pmb->context1 = NULL;
 
-	if (ndlp->nlp_rpi != 0)
-		lpfc_findnode_remove_rpi(phba, ndlp->nlp_rpi);
 	ndlp->nlp_rpi = mb->un.varWords[0];
-	lpfc_addnode_rpi(phba, ndlp, ndlp->nlp_rpi);
 	ndlp->nlp_type |= NLP_FABRIC;
 	ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
@@ -981,10 +978,7 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_h
 
 	pmb->context1 = NULL;
 
-	if (ndlp->nlp_rpi != 0)
-		lpfc_findnode_remove_rpi(phba, ndlp->nlp_rpi);
 	ndlp->nlp_rpi = mb->un.varWords[0];
-	lpfc_addnode_rpi(phba, ndlp, ndlp->nlp_rpi);
 	ndlp->nlp_type |= NLP_FABRIC;
 	ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
@@ -1491,7 +1485,6 @@ lpfc_unreg_rpi(struct lpfc_hba * phba, s
 			if (rc == MBX_NOT_FINISHED)
 				mempool_free( mbox, phba->mbox_mem_pool);
 		}
-		lpfc_findnode_remove_rpi(phba, ndlp->nlp_rpi);
 		lpfc_no_rpi(phba, ndlp);
 		ndlp->nlp_rpi = 0;
 		return 1;
@@ -2437,10 +2430,7 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 
 	pmb->context1 = NULL;
 
-	if (ndlp->nlp_rpi != 0)
-		lpfc_findnode_remove_rpi(phba, ndlp->nlp_rpi);
 	ndlp->nlp_rpi = mb->un.varWords[0];
-	lpfc_addnode_rpi(phba, ndlp, ndlp->nlp_rpi);
 	ndlp->nlp_type |= NLP_FABRIC;
 	ndlp->nlp_state = NLP_STE_UNMAPPED_NODE;
 	lpfc_nlp_list(phba, ndlp, NLP_UNMAPPED_LIST);
@@ -2466,75 +2456,28 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 }
 
 /*
- * This routine looks up the ndlp hash
- * table for the given RPI. If rpi found
+ * This routine looks up the ndlp  lists
+ * for the given RPI. If rpi found
  * it return the node list pointer
- * else return 0.
+ * else return NULL.
  */
 struct lpfc_nodelist *
 lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi)
 {
-	struct lpfc_nodelist *ret;
-
-	ret = phba->fc_nlplookup[LPFC_RPI_HASH_FUNC(rpi)];
-	while ((ret != 0) && (ret->nlp_rpi != rpi)) {
-		ret = ret->nlp_rpi_hash_next;
-	}
-	return ret;
-}
-
-/*
- * This routine looks up the ndlp hash table for the
- * given RPI. If rpi found it return the node list
- * pointer else return 0 after deleting the entry
- * from hash table.
- */
-struct lpfc_nodelist *
-lpfc_findnode_remove_rpi(struct lpfc_hba * phba, uint16_t rpi)
-{
-	struct lpfc_nodelist *ret, *temp;;
-
-	ret = phba->fc_nlplookup[LPFC_RPI_HASH_FUNC(rpi)];
-	if (ret == 0)
-		return NULL;
-
-	if (ret->nlp_rpi == rpi) {
-		phba->fc_nlplookup[LPFC_RPI_HASH_FUNC(rpi)] =
-		    ret->nlp_rpi_hash_next;
-		ret->nlp_rpi_hash_next = NULL;
-		return ret;
-	}
-
-	while ((ret->nlp_rpi_hash_next != 0) &&
-	       (ret->nlp_rpi_hash_next->nlp_rpi != rpi)) {
-		ret = ret->nlp_rpi_hash_next;
-	}
-
-	if (ret->nlp_rpi_hash_next != 0) {
-		temp = ret->nlp_rpi_hash_next;
-		ret->nlp_rpi_hash_next = temp->nlp_rpi_hash_next;
-		temp->nlp_rpi_hash_next = NULL;
-		return temp;
-	} else {
-		return NULL;
-	}
-}
-
-/*
- * This routine adds the node list entry to the
- * ndlp hash table.
- */
-void
-lpfc_addnode_rpi(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp,
-		 uint16_t rpi)
-{
-
-	uint32_t index;
+	struct lpfc_nodelist *ndlp;
+	struct list_head * lists[]={&phba->fc_nlpunmap_list,
+				    &phba->fc_nlpmap_list,
+				    &phba->fc_plogi_list,
+				    &phba->fc_adisc_list,
+				    &phba->fc_reglogin_list};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(lists); i++ )
+		list_for_each_entry(ndlp, lists[i], nlp_listp)
+			if (ndlp->nlp_rpi == rpi)
+				return (ndlp);
 
-	index = LPFC_RPI_HASH_FUNC(rpi);
-	ndlp->nlp_rpi_hash_next = phba->fc_nlplookup[index];
-	phba->fc_nlplookup[index] = ndlp;
-	return;
+	return NULL;
 }
 
 void
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1086,11 +1086,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 		return (ndlp->nlp_state);
 	}
 
-	if (ndlp->nlp_rpi != 0)
-		lpfc_findnode_remove_rpi(phba, ndlp->nlp_rpi);
-
 	ndlp->nlp_rpi = mb->un.varWords[0];
-	lpfc_addnode_rpi(phba, ndlp, ndlp->nlp_rpi);
 
 	/* Only if we are not a fabric nport do we issue PRLI */
 	if (!(ndlp->nlp_type & NLP_FABRIC)) {
@@ -1593,12 +1589,7 @@ lpfc_cmpl_reglogin_npr_node(struct lpfc_
 	pmb = (LPFC_MBOXQ_t *) arg;
 	mb = &pmb->mb;
 
-	/* save rpi */
-	if (ndlp->nlp_rpi != 0)
-		lpfc_findnode_remove_rpi(phba, ndlp->nlp_rpi);
-
 	ndlp->nlp_rpi = mb->un.varWords[0];
-	lpfc_addnode_rpi(phba, ndlp, ndlp->nlp_rpi);
 
 	return (ndlp->nlp_state);
 }
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -62,10 +62,6 @@ void lpfc_disc_timeout(unsigned long);
 void lpfc_scan_timeout(unsigned long);
 
 struct lpfc_nodelist *lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi);
-struct lpfc_nodelist *lpfc_findnode_remove_rpi(struct lpfc_hba * phba,
-					       uint16_t rpi);
-void lpfc_addnode_rpi(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp,
-		      uint16_t rpi);
 
 int lpfc_workq_post_event(struct lpfc_hba *, void *, void *, uint32_t);
 int lpfc_do_work(void *);
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -267,10 +267,6 @@ struct lpfc_hba {
 	struct lpfc_nodelist fc_fcpnodev; /* nodelist entry for no device */
 	uint32_t nport_event_cnt;	/* timestamp for nlplist entry */
 
-#define LPFC_RPI_HASH_SIZE     64
-#define LPFC_RPI_HASH_FUNC(x)  ((x) & (0x3f))
-	/* ptr to active D_ID / RPIs */
-	struct lpfc_nodelist *fc_nlplookup[LPFC_RPI_HASH_SIZE];
 	uint32_t wwnn[2];
 	uint32_t RandomData[7];
 
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -70,7 +70,6 @@ struct lpfc_nodelist {
 	struct timer_list   nlp_tmofunc;	/* Used for nodev tmo */
 	struct fc_rport *rport;			/* Corresponding FC transport
 						   port structure */
-	struct lpfc_nodelist *nlp_rpi_hash_next;
 	struct lpfc_hba      *nlp_phba;
 	struct lpfc_work_evt nodev_timeout_evt;
 	struct lpfc_work_evt els_retry_evt;
