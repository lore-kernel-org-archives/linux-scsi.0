From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/9] lpfc 8.1.11 :  Discovery Fixes
Date: Sat, 02 Dec 2006 13:33:57 -0500
Message-ID: <1165084437.27443.22.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:54231 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1759461AbWLBQHD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:03 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71ad009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Discovery Fixes:
 - Prevent starting discovery of a node if discovery is in progress.
 - Code improvement (reduction) for lpfc_findnode_did().
 - Update discovery to send RFF to Fabric on link up
 - Bypass unique WWN checks for fabric addresses
 - Add ndlp to plogi list prior to issuing the plogi els command

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2006-12-02 11:50:58.000000000 -0500
@@ -558,6 +558,14 @@ lpfc_cmpl_ct_cmd_rsnn_nn(struct lpfc_hba
 	return;
 }
 
+static void
+lpfc_cmpl_ct_cmd_rff_id(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
+			 struct lpfc_iocbq * rspiocb)
+{
+	lpfc_cmpl_ct_cmd_rft_id(phba, cmdiocb, rspiocb);
+	return;
+}
+
 void
 lpfc_get_hba_sym_node_name(struct lpfc_hba * phba, uint8_t * symbp)
 {
@@ -629,6 +637,8 @@ lpfc_ns_cmd(struct lpfc_hba * phba, stru
 		bpl->tus.f.bdeSize = RNN_REQUEST_SZ;
 	else if (cmdcode == SLI_CTNS_RSNN_NN)
 		bpl->tus.f.bdeSize = RSNN_REQUEST_SZ;
+	else if (cmdcode == SLI_CTNS_RFF_ID)
+		bpl->tus.f.bdeSize = RFF_REQUEST_SZ;
 	else
 		bpl->tus.f.bdeSize = 0;
 	bpl->tus.w = le32_to_cpu(bpl->tus.w);
@@ -660,6 +670,17 @@ lpfc_ns_cmd(struct lpfc_hba * phba, stru
 		cmpl = lpfc_cmpl_ct_cmd_rft_id;
 		break;
 
+	case SLI_CTNS_RFF_ID:
+		CtReq->CommandResponse.bits.CmdRsp =
+			be16_to_cpu(SLI_CTNS_RFF_ID);
+		CtReq->un.rff.PortId = be32_to_cpu(phba->fc_myDID);
+		CtReq->un.rff.feature_res = 0;
+		CtReq->un.rff.feature_tgt = 0;
+		CtReq->un.rff.type_code = FC_FCP_DATA;
+		CtReq->un.rff.feature_init = 1;
+		cmpl = lpfc_cmpl_ct_cmd_rff_id;
+		break;
+
 	case SLI_CTNS_RNN_ID:
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RNN_ID);
@@ -934,7 +955,8 @@ lpfc_fdmi_cmd(struct lpfc_hba * phba, st
 			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
 			ae->ad.bits.AttrType = be16_to_cpu(OS_NAME_VERSION);
 			sprintf(ae->un.OsNameVersion, "%s %s %s",
-				init_utsname()->sysname, init_utsname()->release,
+				init_utsname()->sysname,
+				init_utsname()->release,
 				init_utsname()->version);
 			len = strlen(ae->un.OsNameVersion);
 			len += (len & 3) ? (4 - (len & 3)) : 4;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2006-12-02 11:50:58.000000000 -0500
@@ -657,6 +657,12 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 	uint8_t name[sizeof (struct lpfc_name)];
 	uint32_t rc;
 
+	/* Fabric nodes can have the same WWPN so we don't bother searching
+	 * by WWPN.  Just return the ndlp that was given to us.
+	 */
+	if (ndlp->nlp_type & NLP_FABRIC)
+		return ndlp;
+
 	lp = (uint32_t *) prsp->virt;
 	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
 	memset(name, 0, sizeof (struct lpfc_name));
@@ -2644,6 +2650,7 @@ lpfc_els_handle_rscn(struct lpfc_hba * p
 			ndlp->nlp_type |= NLP_FABRIC;
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			ndlp->nlp_state = NLP_STE_PLOGI_ISSUE;
+			lpfc_nlp_list(phba, ndlp, NLP_PLOGI_LIST);
 			lpfc_issue_els_plogi(phba, NameServer_DID, 0);
 			/* Wait for NameServer login cmpl before we can
 			   continue */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-12-02 11:50:58.000000000 -0500
@@ -1067,6 +1067,7 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_h
 		lpfc_ns_cmd(phba, ndlp, SLI_CTNS_RNN_ID);
 		lpfc_ns_cmd(phba, ndlp, SLI_CTNS_RSNN_NN);
 		lpfc_ns_cmd(phba, ndlp, SLI_CTNS_RFT_ID);
+		lpfc_ns_cmd(phba, ndlp, SLI_CTNS_RFF_ID);
 	}
 
 	phba->fc_ns_retry = 0;
@@ -1680,112 +1681,38 @@ lpfc_matchdid(struct lpfc_hba * phba, st
 struct lpfc_nodelist *
 lpfc_findnode_did(struct lpfc_hba * phba, uint32_t order, uint32_t did)
 {
-	struct lpfc_nodelist *ndlp, *next_ndlp;
+	struct lpfc_nodelist *ndlp;
+	struct list_head *lists[]={&phba->fc_nlpunmap_list,
+				   &phba->fc_nlpmap_list,
+				   &phba->fc_plogi_list,
+				   &phba->fc_adisc_list,
+				   &phba->fc_reglogin_list,
+				   &phba->fc_prli_list,
+				   &phba->fc_npr_list,
+				   &phba->fc_unused_list};
+	uint32_t search[]={NLP_SEARCH_UNMAPPED,
+			   NLP_SEARCH_MAPPED,
+			   NLP_SEARCH_PLOGI,
+			   NLP_SEARCH_ADISC,
+			   NLP_SEARCH_REGLOGIN,
+			   NLP_SEARCH_PRLI,
+			   NLP_SEARCH_NPR,
+			   NLP_SEARCH_UNUSED};
+	int i;
 	uint32_t data1;
 
 	spin_lock_irq(phba->host->host_lock);
-	if (order & NLP_SEARCH_UNMAPPED) {
-		list_for_each_entry_safe(ndlp, next_ndlp,
-					 &phba->fc_nlpunmap_list, nlp_listp) {
-			if (lpfc_matchdid(phba, ndlp, did)) {
-				data1 = (((uint32_t) ndlp->nlp_state << 24) |
-					 ((uint32_t) ndlp->nlp_xri << 16) |
-					 ((uint32_t) ndlp->nlp_type << 8) |
-					 ((uint32_t) ndlp->nlp_rpi & 0xff));
-				/* FIND node DID unmapped */
-				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0929 FIND node DID unmapped"
-						" Data: x%p x%x x%x x%x\n",
-						phba->brd_no,
-						ndlp, ndlp->nlp_DID,
-						ndlp->nlp_flag, data1);
-				spin_unlock_irq(phba->host->host_lock);
-				return ndlp;
-			}
-		}
-	}
-
-	if (order & NLP_SEARCH_MAPPED) {
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nlpmap_list,
-					nlp_listp) {
-			if (lpfc_matchdid(phba, ndlp, did)) {
-
-				data1 = (((uint32_t) ndlp->nlp_state << 24) |
-					 ((uint32_t) ndlp->nlp_xri << 16) |
-					 ((uint32_t) ndlp->nlp_type << 8) |
-					 ((uint32_t) ndlp->nlp_rpi & 0xff));
-				/* FIND node DID mapped */
-				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0930 FIND node DID mapped "
-						"Data: x%p x%x x%x x%x\n",
-						phba->brd_no,
-						ndlp, ndlp->nlp_DID,
-						ndlp->nlp_flag, data1);
-				spin_unlock_irq(phba->host->host_lock);
-				return ndlp;
-			}
-		}
-	}
-
-	if (order & NLP_SEARCH_PLOGI) {
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_plogi_list,
-					nlp_listp) {
-			if (lpfc_matchdid(phba, ndlp, did)) {
-
-				data1 = (((uint32_t) ndlp->nlp_state << 24) |
-					 ((uint32_t) ndlp->nlp_xri << 16) |
-					 ((uint32_t) ndlp->nlp_type << 8) |
-					 ((uint32_t) ndlp->nlp_rpi & 0xff));
-				/* LOG change to PLOGI */
-				/* FIND node DID plogi */
-				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0908 FIND node DID plogi "
-						"Data: x%p x%x x%x x%x\n",
-						phba->brd_no,
-						ndlp, ndlp->nlp_DID,
-						ndlp->nlp_flag, data1);
-				spin_unlock_irq(phba->host->host_lock);
-				return ndlp;
-			}
-		}
-	}
-
-	if (order & NLP_SEARCH_ADISC) {
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_adisc_list,
-					nlp_listp) {
-			if (lpfc_matchdid(phba, ndlp, did)) {
-
-				data1 = (((uint32_t) ndlp->nlp_state << 24) |
-					 ((uint32_t) ndlp->nlp_xri << 16) |
-					 ((uint32_t) ndlp->nlp_type << 8) |
-					 ((uint32_t) ndlp->nlp_rpi & 0xff));
-				/* LOG change to ADISC */
-				/* FIND node DID adisc */
-				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0931 FIND node DID adisc "
-						"Data: x%p x%x x%x x%x\n",
-						phba->brd_no,
-						ndlp, ndlp->nlp_DID,
-						ndlp->nlp_flag, data1);
-				spin_unlock_irq(phba->host->host_lock);
-				return ndlp;
-			}
-		}
-	}
-
-	if (order & NLP_SEARCH_REGLOGIN) {
-		list_for_each_entry_safe(ndlp, next_ndlp,
-					 &phba->fc_reglogin_list, nlp_listp) {
+	for (i = 0; i < ARRAY_SIZE(lists); i++ ) {
+		if (!(order & search[i]))
+			continue;
+		list_for_each_entry(ndlp, lists[i], nlp_listp) {
 			if (lpfc_matchdid(phba, ndlp, did)) {
-
 				data1 = (((uint32_t) ndlp->nlp_state << 24) |
 					 ((uint32_t) ndlp->nlp_xri << 16) |
 					 ((uint32_t) ndlp->nlp_type << 8) |
 					 ((uint32_t) ndlp->nlp_rpi & 0xff));
-				/* LOG change to REGLOGIN */
-				/* FIND node DID reglogin */
 				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0901 FIND node DID reglogin"
+						"%d:0929 FIND node DID "
 						" Data: x%p x%x x%x x%x\n",
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
@@ -1795,86 +1722,12 @@ lpfc_findnode_did(struct lpfc_hba * phba
 			}
 		}
 	}
-
-	if (order & NLP_SEARCH_PRLI) {
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_prli_list,
-					nlp_listp) {
-			if (lpfc_matchdid(phba, ndlp, did)) {
-
-				data1 = (((uint32_t) ndlp->nlp_state << 24) |
-					 ((uint32_t) ndlp->nlp_xri << 16) |
-					 ((uint32_t) ndlp->nlp_type << 8) |
-					 ((uint32_t) ndlp->nlp_rpi & 0xff));
-				/* LOG change to PRLI */
-				/* FIND node DID prli */
-				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0902 FIND node DID prli "
-						"Data: x%p x%x x%x x%x\n",
-						phba->brd_no,
-						ndlp, ndlp->nlp_DID,
-						ndlp->nlp_flag, data1);
-				spin_unlock_irq(phba->host->host_lock);
-				return ndlp;
-			}
-		}
-	}
-
-	if (order & NLP_SEARCH_NPR) {
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
-					nlp_listp) {
-			if (lpfc_matchdid(phba, ndlp, did)) {
-
-				data1 = (((uint32_t) ndlp->nlp_state << 24) |
-					 ((uint32_t) ndlp->nlp_xri << 16) |
-					 ((uint32_t) ndlp->nlp_type << 8) |
-					 ((uint32_t) ndlp->nlp_rpi & 0xff));
-				/* LOG change to NPR */
-				/* FIND node DID npr */
-				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0903 FIND node DID npr "
-						"Data: x%p x%x x%x x%x\n",
-						phba->brd_no,
-						ndlp, ndlp->nlp_DID,
-						ndlp->nlp_flag, data1);
-				spin_unlock_irq(phba->host->host_lock);
-				return ndlp;
-			}
-		}
-	}
-
-	if (order & NLP_SEARCH_UNUSED) {
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_adisc_list,
-					nlp_listp) {
-			if (lpfc_matchdid(phba, ndlp, did)) {
-
-				data1 = (((uint32_t) ndlp->nlp_state << 24) |
-					 ((uint32_t) ndlp->nlp_xri << 16) |
-					 ((uint32_t) ndlp->nlp_type << 8) |
-					 ((uint32_t) ndlp->nlp_rpi & 0xff));
-				/* LOG change to UNUSED */
-				/* FIND node DID unused */
-				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0905 FIND node DID unused "
-						"Data: x%p x%x x%x x%x\n",
-						phba->brd_no,
-						ndlp, ndlp->nlp_DID,
-						ndlp->nlp_flag, data1);
-				spin_unlock_irq(phba->host->host_lock);
-				return ndlp;
-			}
-		}
-	}
-
 	spin_unlock_irq(phba->host->host_lock);
 
 	/* FIND node did <did> NOT FOUND */
-	lpfc_printf_log(phba,
-			KERN_INFO,
-			LOG_NODE,
+	lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
 			"%d:0932 FIND node did x%x NOT FOUND Data: x%x\n",
 			phba->brd_no, did, order);
-
-	/* no match found */
 	return NULL;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2006-12-02 11:50:58.000000000 -0500
@@ -121,6 +121,20 @@ struct lpfc_sli_ct_request {
 
 			uint32_t rsvd[7];
 		} rft;
+		struct rff {
+			uint32_t PortId;
+			uint8_t reserved[2];
+#ifdef __BIG_ENDIAN_BITFIELD
+			uint8_t feature_res:6;
+			uint8_t feature_init:1;
+			uint8_t feature_tgt:1;
+#else  /*  __LITTLE_ENDIAN_BITFIELD */
+			uint8_t feature_tgt:1;
+			uint8_t feature_init:1;
+			uint8_t feature_res:6;
+#endif
+			uint8_t type_code;     /* type=8 for FCP */
+		} rff;
 		struct rnn {
 			uint32_t PortId;	/* For RNN_ID requests */
 			uint8_t wwnn[8];
@@ -136,6 +150,7 @@ struct lpfc_sli_ct_request {
 #define  SLI_CT_REVISION        1
 #define  GID_REQUEST_SZ         (sizeof(struct lpfc_sli_ct_request) - 260)
 #define  RFT_REQUEST_SZ         (sizeof(struct lpfc_sli_ct_request) - 228)
+#define  RFF_REQUEST_SZ         (sizeof(struct lpfc_sli_ct_request) - 235)
 #define  RNN_REQUEST_SZ         (sizeof(struct lpfc_sli_ct_request) - 252)
 #define  RSNN_REQUEST_SZ        (sizeof(struct lpfc_sli_ct_request))
 
@@ -225,6 +240,7 @@ struct lpfc_sli_ct_request {
 #define  SLI_CTNS_RNN_ID      0x0213
 #define  SLI_CTNS_RCS_ID      0x0214
 #define  SLI_CTNS_RFT_ID      0x0217
+#define  SLI_CTNS_RFF_ID      0x021F
 #define  SLI_CTNS_RSPN_ID     0x0218
 #define  SLI_CTNS_RPT_ID      0x021A
 #define  SLI_CTNS_RIP_NN      0x0235
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2006-12-02 11:50:58.000000000 -0500
@@ -1620,8 +1620,8 @@ lpfc_rcv_padisc_npr_node(struct lpfc_hba
 	 * or discovery in progress for this node. Starting discovery
 	 * here will affect the counting of discovery threads.
 	 */
-	if ((!(ndlp->nlp_flag & NLP_DELAY_TMO)) &&
-		(ndlp->nlp_flag & NLP_NPR_2B_DISC)){
+	if (!(ndlp->nlp_flag & NLP_DELAY_TMO) &&
+		!(ndlp->nlp_flag & NLP_NPR_2B_DISC)){
 		if (ndlp->nlp_flag & NLP_NPR_ADISC) {
 			ndlp->nlp_prev_state = NLP_STE_NPR_NODE;
 			ndlp->nlp_state = NLP_STE_ADISC_ISSUE;


