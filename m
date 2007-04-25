From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 11/16] lpfc 8.1.12 : Collapse discovery lists to a single
	node list
Date: Wed, 25 Apr 2007 09:53:08 -0400
Message-ID: <1177509188.23155.18.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51730 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031024AbXDYNxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:53:00 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDqwkP006668
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:52:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Collapse discovery lists to a single node list.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:42.000000000 -0400
@@ -1781,67 +1781,51 @@ lpfc_reset_stats(struct Scsi_Host *shost
  * The LPFC driver treats linkdown handling as target loss events so there
  * are no sysfs handlers for link_down_tmo.
  */
-static void
-lpfc_get_starget_port_id(struct scsi_target *starget)
+
+static struct lpfc_nodelist *
+lpfc_get_node_by_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata;
-	uint32_t did = -1;
-	struct lpfc_nodelist *ndlp = NULL;
+	struct lpfc_nodelist *ndlp;
 
 	spin_lock_irq(shost->host_lock);
-	/* Search the mapped list for this target ID */
-	list_for_each_entry(ndlp, &phba->fc_nlpmap_list, nlp_listp) {
-		if (starget->id == ndlp->nlp_sid) {
-			did = ndlp->nlp_DID;
-			break;
+	/* Search for this, mapped, target ID */
+	list_for_each_entry(ndlp, &phba->fc_nodes, nlp_listp) {
+		if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
+		    starget->id == ndlp->nlp_sid) {
+			spin_unlock_irq(shost->host_lock);
+			return ndlp;
 		}
 	}
 	spin_unlock_irq(shost->host_lock);
+	return NULL;
+}
 
-	fc_starget_port_id(starget) = did;
+static void
+lpfc_get_starget_port_id(struct scsi_target *starget)
+{
+	struct lpfc_nodelist *ndlp = lpfc_get_node_by_target(starget);
+
+	fc_starget_port_id(starget) = ndlp ? ndlp->nlp_DID : -1;
 }
 
 static void
 lpfc_get_starget_node_name(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata;
-	u64 node_name = 0;
-	struct lpfc_nodelist *ndlp = NULL;
-
-	spin_lock_irq(shost->host_lock);
-	/* Search the mapped list for this target ID */
-	list_for_each_entry(ndlp, &phba->fc_nlpmap_list, nlp_listp) {
-		if (starget->id == ndlp->nlp_sid) {
-			node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
-			break;
-		}
-	}
-	spin_unlock_irq(shost->host_lock);
+	struct lpfc_nodelist *ndlp = lpfc_get_node_by_target(starget);
 
-	fc_starget_node_name(starget) = node_name;
+	fc_starget_node_name(starget) =
+		ndlp ? wwn_to_u64(ndlp->nlp_nodename.u.wwn) : 0;
 }
 
 static void
 lpfc_get_starget_port_name(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata;
-	u64 port_name = 0;
-	struct lpfc_nodelist *ndlp = NULL;
-
-	spin_lock_irq(shost->host_lock);
-	/* Search the mapped list for this target ID */
-	list_for_each_entry(ndlp, &phba->fc_nlpmap_list, nlp_listp) {
-		if (starget->id == ndlp->nlp_sid) {
-			port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
-			break;
-		}
-	}
-	spin_unlock_irq(shost->host_lock);
+	struct lpfc_nodelist *ndlp = lpfc_get_node_by_target(starget);
 
-	fc_starget_port_name(starget) = port_name;
+	fc_starget_port_name(starget) =
+		ndlp ? wwn_to_u64(ndlp->nlp_portname.u.wwn) : 0;
 }
 
 static void
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-04-24 11:12:42.000000000 -0400
@@ -18,6 +18,8 @@
  * included with this package.                                     *
  *******************************************************************/
 
+typedef int (*node_filter)(struct lpfc_nodelist *ndlp, void *param);
+
 struct fc_rport;
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
 void lpfc_read_nv(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -178,9 +180,8 @@ int lpfc_sli_abort_iocb(struct lpfc_hba 
 void lpfc_mbox_timeout(unsigned long);
 void lpfc_mbox_timeout_handler(struct lpfc_hba *);
 
-struct lpfc_nodelist *lpfc_findnode_did(struct lpfc_hba *, uint32_t, uint32_t);
-struct lpfc_nodelist *lpfc_findnode_wwpn(struct lpfc_hba *, uint32_t,
-					struct lpfc_name *);
+struct lpfc_nodelist *lpfc_findnode_did(struct lpfc_hba *, uint32_t);
+struct lpfc_nodelist *lpfc_findnode_wwpn(struct lpfc_hba *, struct lpfc_name *);
 
 int lpfc_sli_issue_mbox_wait(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq,
 			 uint32_t timeout);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-04-24 11:12:42.000000000 -0400
@@ -443,10 +443,8 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 		if (phba->fc_ns_retry < LPFC_MAX_NS_RETRY) {
 			phba->fc_ns_retry++;
 			/* CT command is being retried */
-			ndlp =
-			    lpfc_findnode_did(phba, NLP_SEARCH_UNMAPPED,
-					      NameServer_DID);
-			if (ndlp) {
+			ndlp = lpfc_findnode_did(phba, NameServer_DID);
+			if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 				if (lpfc_ns_cmd(phba, ndlp, SLI_CTNS_GID_FT) ==
 				    0) {
 					goto out;
@@ -730,7 +728,7 @@ lpfc_cmpl_ct_cmd_fdmi(struct lpfc_hba * 
 	uint16_t fdmi_cmd = CTcmd->CommandResponse.bits.CmdRsp;
 	uint16_t fdmi_rsp = CTrsp->CommandResponse.bits.CmdRsp;
 
-	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, FDMI_DID);
+	ndlp = lpfc_findnode_did(phba, FDMI_DID);
 	if (fdmi_rsp == be16_to_cpu(SLI_CT_RESPONSE_FS_RJT)) {
 		/* FDMI rsp failed */
 		lpfc_printf_log(phba,
@@ -1162,7 +1160,7 @@ lpfc_fdmi_tmo_handler(struct lpfc_hba *p
 {
 	struct lpfc_nodelist *ndlp;
 
-	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, FDMI_DID);
+	ndlp = lpfc_findnode_did(phba, FDMI_DID);
 	if (ndlp) {
 		if (init_utsname()->nodename[0] != '\0') {
 			lpfc_fdmi_cmd(phba, ndlp, SLI_MGMT_DHBA);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2007-04-24 11:12:42.000000000 -0400
@@ -83,15 +83,6 @@ struct lpfc_nodelist {
 };
 
 /* Defines for nlp_flag (uint32) */
-#define NLP_UNUSED_LIST    0x1		/* Flg to indicate node will be freed */
-#define NLP_PLOGI_LIST     0x2		/* Flg to indicate sent PLOGI */
-#define NLP_ADISC_LIST     0x3		/* Flg to indicate sent ADISC */
-#define NLP_REGLOGIN_LIST  0x4		/* Flg to indicate sent REG_LOGIN */
-#define NLP_PRLI_LIST      0x5		/* Flg to indicate sent PRLI */
-#define NLP_UNMAPPED_LIST  0x6		/* Node is now unmapped */
-#define NLP_MAPPED_LIST    0x7		/* Node is now mapped */
-#define NLP_NPR_LIST       0x8		/* Node is in NPort Recovery state */
-#define NLP_LIST_MASK      0xf		/* mask to see what list node is on */
 #define NLP_PLOGI_SND      0x20		/* sent PLOGI request for this entry */
 #define NLP_PRLI_SND       0x40		/* sent PRLI request for this entry */
 #define NLP_ADISC_SND      0x80		/* sent ADISC request for this entry */
@@ -109,17 +100,6 @@ struct lpfc_nodelist {
 					   NPR list */
 #define NLP_NODEV_REMOVE   0x8000000	/* Defer removal till discovery ends */
 
-/* Defines for list searchs */
-#define NLP_SEARCH_MAPPED    0x1	/* search mapped */
-#define NLP_SEARCH_UNMAPPED  0x2	/* search unmapped */
-#define NLP_SEARCH_PLOGI     0x4	/* search plogi */
-#define NLP_SEARCH_ADISC     0x8	/* search adisc */
-#define NLP_SEARCH_REGLOGIN  0x10	/* search reglogin */
-#define NLP_SEARCH_PRLI      0x20	/* search prli */
-#define NLP_SEARCH_NPR       0x40	/* search npr */
-#define NLP_SEARCH_UNUSED    0x80	/* search mapped */
-#define NLP_SEARCH_ALL       0xff	/* search all lists */
-
 /* There are 4 different double linked lists nodelist entries can reside on.
  * The Port Login (PLOGI) list and Address Discovery (ADISC) list are used
  * when Link Up discovery or Registered State Change Notification (RSCN)
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:42.000000000 -0400
@@ -182,7 +182,7 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 		icmd->un.elsreq64.bdl.bdeSize = (2 * sizeof (struct ulp_bde64));
 		icmd->un.elsreq64.remoteID = did;	/* DID */
 		icmd->ulpCommand = CMD_ELS_REQUEST64_CR;
-		icmd->ulpTimeout = phba->fc_ratov * 2; 
+		icmd->ulpTimeout = phba->fc_ratov * 2;
 	} else {
 		icmd->un.elsreq64.bdl.bdeSize = sizeof (struct ulp_bde64);
 		icmd->ulpCommand = CMD_XMIT_ELS_RSP64_CX;
@@ -372,7 +372,7 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_hb
 		}
 		lpfc_nlp_put(ndlp);
 
-		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, PT2PT_RemoteID);
+		ndlp = lpfc_findnode_did(phba, PT2PT_RemoteID);
 		if (!ndlp) {
 			/*
 			 * Cannot find existing Fabric ndlp, so allocate a
@@ -592,12 +592,12 @@ lpfc_els_abort_flogi(struct lpfc_hba * p
 }
 
 int
-lpfc_initial_flogi(struct lpfc_hba * phba)
+lpfc_initial_flogi(struct lpfc_hba *phba)
 {
 	struct lpfc_nodelist *ndlp;
 
 	/* First look for the Fabric ndlp */
-	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, Fabric_DID);
+	ndlp = lpfc_findnode_did(phba, Fabric_DID);
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
 		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
@@ -637,7 +637,7 @@ lpfc_more_plogi(struct lpfc_hba * phba)
 }
 
 static struct lpfc_nodelist *
-lpfc_plogi_confirm_nport(struct lpfc_hba * phba, struct lpfc_dmabuf *prsp,
+lpfc_plogi_confirm_nport(struct lpfc_hba *phba, struct lpfc_dmabuf *prsp,
 			 struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_nodelist *new_ndlp;
@@ -654,12 +654,12 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 
 	lp = (uint32_t *) prsp->virt;
 	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
-	memset(name, 0, sizeof (struct lpfc_name));
+	memset(name, 0, sizeof(struct lpfc_name));
 
-	/* Now we to find out if the NPort we are logging into, matches the WWPN
+	/* Now we find out if the NPort we are logging into, matches the WWPN
 	 * we have for that ndlp. If not, we have some work to do.
 	 */
-	new_ndlp = lpfc_findnode_wwpn(phba, NLP_SEARCH_ALL, &sp->portName);
+	new_ndlp = lpfc_findnode_wwpn(phba, &sp->portName);
 
 	if (new_ndlp == ndlp)
 		return ndlp;
@@ -705,8 +705,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
 	irsp = &rspiocb->iocb;
-	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL,
-						irsp->un.elsreq64.remoteID);
+	ndlp = lpfc_findnode_did(phba, irsp->un.elsreq64.remoteID);
 	if (!ndlp)
 		goto out;
 
@@ -1408,7 +1407,7 @@ lpfc_issue_els_farpr(struct lpfc_hba * p
 
 	memcpy(&fp->RportName, &phba->fc_portname, sizeof (struct lpfc_name));
 	memcpy(&fp->RnodeName, &phba->fc_nodename, sizeof (struct lpfc_name));
-	if ((ondlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, nportid))) {
+	if ((ondlp = lpfc_findnode_did(phba, nportid))) {
 		memcpy(&fp->OportName, &ondlp->nlp_portname,
 		       sizeof (struct lpfc_name));
 		memcpy(&fp->OnodeName, &ondlp->nlp_nodename,
@@ -1595,7 +1594,7 @@ lpfc_els_retry(struct lpfc_hba * phba, s
 	else {
 		/* We should only hit this case for retrying PLOGI */
 		did = irsp->un.elsreq64.remoteID;
-		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, did);
+		ndlp = lpfc_findnode_did(phba, did);
 		if (!ndlp && (cmd != ELS_CMD_PLOGI))
 			return 1;
 	}
@@ -2291,31 +2290,31 @@ lpfc_els_rsp_rnid_acc(struct lpfc_hba *p
 }
 
 int
-lpfc_els_disc_adisc(struct lpfc_hba * phba)
+lpfc_els_disc_adisc(struct lpfc_hba *phba)
 {
 	int sentadisc;
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 
 	sentadisc = 0;
-	/* go thru NPR list and issue any remaining ELS ADISCs */
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
-			nlp_listp) {
-		if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
-			if (ndlp->nlp_flag & NLP_NPR_ADISC) {
-				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-				ndlp->nlp_prev_state = ndlp->nlp_state;
-				lpfc_nlp_set_state(phba, ndlp,
-						   NLP_STE_ADISC_ISSUE);
-				lpfc_issue_els_adisc(phba, ndlp, 0);
-				sentadisc++;
-				phba->num_disc_nodes++;
-				if (phba->num_disc_nodes >=
-				    phba->cfg_discovery_threads) {
-					spin_lock_irq(phba->host->host_lock);
-					phba->fc_flag |= FC_NLP_MORE;
-					spin_unlock_irq(phba->host->host_lock);
-					break;
-				}
+	/* go thru NPR nodes and issue any remaining ELS ADISCs */
+	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes, nlp_listp) {
+		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
+		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
+		    (ndlp->nlp_flag & NLP_NPR_ADISC) != 0) {
+			spin_lock_irq(phba->host->host_lock);
+			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+			spin_unlock_irq(phba->host->host_lock);
+			ndlp->nlp_prev_state = ndlp->nlp_state;
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_ADISC_ISSUE);
+			lpfc_issue_els_adisc(phba, ndlp, 0);
+			sentadisc++;
+			phba->num_disc_nodes++;
+			if (phba->num_disc_nodes >=
+			    phba->cfg_discovery_threads) {
+				spin_lock_irq(phba->host->host_lock);
+				phba->fc_flag |= FC_NLP_MORE;
+				spin_unlock_irq(phba->host->host_lock);
+				break;
 			}
 		}
 	}
@@ -2335,24 +2334,22 @@ lpfc_els_disc_plogi(struct lpfc_hba * ph
 
 	sentplogi = 0;
 	/* go thru NPR list and issue any remaining ELS PLOGIs */
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
-				nlp_listp) {
-		if ((ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
-		   (!(ndlp->nlp_flag & NLP_DELAY_TMO))) {
-			if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
-				ndlp->nlp_prev_state = ndlp->nlp_state;
-				lpfc_nlp_set_state(phba, ndlp,
-						   NLP_STE_PLOGI_ISSUE);
-				lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
-				sentplogi++;
-				phba->num_disc_nodes++;
-				if (phba->num_disc_nodes >=
-				    phba->cfg_discovery_threads) {
-					spin_lock_irq(phba->host->host_lock);
-					phba->fc_flag |= FC_NLP_MORE;
-					spin_unlock_irq(phba->host->host_lock);
-					break;
-				}
+	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes, nlp_listp) {
+		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
+		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
+		    (ndlp->nlp_flag & NLP_DELAY_TMO) == 0 &&
+		    (ndlp->nlp_flag & NLP_NPR_ADISC) == 0) {
+			ndlp->nlp_prev_state = ndlp->nlp_state;
+			lpfc_nlp_set_state(phba, ndlp, NLP_STE_PLOGI_ISSUE);
+			lpfc_issue_els_plogi(phba, ndlp->nlp_DID, 0);
+			sentplogi++;
+			phba->num_disc_nodes++;
+			if (phba->num_disc_nodes >=
+			    phba->cfg_discovery_threads) {
+				spin_lock_irq(phba->host->host_lock);
+				phba->fc_flag |= FC_NLP_MORE;
+				spin_unlock_irq(phba->host->host_lock);
+				break;
 			}
 		}
 	}
@@ -2456,40 +2453,28 @@ lpfc_rscn_payload_check(struct lpfc_hba 
 static int
 lpfc_rscn_recovery_check(struct lpfc_hba *phba)
 {
-	struct lpfc_nodelist *ndlp = NULL, *next_ndlp;
-	struct list_head *listp;
-	struct list_head *node_list[7];
-	int i;
+	struct lpfc_nodelist *ndlp = NULL;
 
 	/* Look at all nodes effected by pending RSCNs and move
-	 * them to NPR list.
+	 * them to NPR state.
 	 */
-	node_list[0] = &phba->fc_npr_list;  /* MUST do this list first */
-	node_list[1] = &phba->fc_nlpmap_list;
-	node_list[2] = &phba->fc_nlpunmap_list;
-	node_list[3] = &phba->fc_prli_list;
-	node_list[4] = &phba->fc_reglogin_list;
-	node_list[5] = &phba->fc_adisc_list;
-	node_list[6] = &phba->fc_plogi_list;
-	for (i = 0; i < 7; i++) {
-		listp = node_list[i];
-		if (list_empty(listp))
-			continue;
 
-		list_for_each_entry_safe(ndlp, next_ndlp, listp, nlp_listp) {
-			if (!(lpfc_rscn_payload_check(phba, ndlp->nlp_DID)))
-				continue;
+	list_for_each_entry(ndlp, &phba->fc_nodes, nlp_listp) {
+		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE ||
+		    lpfc_rscn_payload_check(phba, ndlp->nlp_DID) == 0)
+			continue;
 
-			lpfc_disc_state_machine(phba, ndlp, NULL,
+		lpfc_disc_state_machine(phba, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 
-			/* Make sure NLP_DELAY_TMO is NOT running
-			 * after a device recovery event.
-			 */
-			if (ndlp->nlp_flag & NLP_DELAY_TMO)
-				lpfc_cancel_retry_delay_tmo(phba, ndlp);
-		}
+		/*
+		 * Make sure NLP_DELAY_TMO is NOT running after a device
+		 * recovery event.
+		 */
+		if (ndlp->nlp_flag & NLP_DELAY_TMO)
+			lpfc_cancel_retry_delay_tmo(phba, ndlp);
 	}
+
 	return 0;
 }
 
@@ -2614,8 +2599,8 @@ lpfc_els_handle_rscn(struct lpfc_hba * p
 
 	/* To process RSCN, first compare RSCN data with NameServer */
 	phba->fc_ns_retry = 0;
-	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_UNMAPPED, NameServer_DID);
-	if (ndlp) {
+	ndlp = lpfc_findnode_did(phba, NameServer_DID);
+	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 		/* Good ndlp, issue CT Request to NameServer */
 		if (lpfc_ns_cmd(phba, ndlp, SLI_CTNS_GID_FT) == 0) {
 			/* Wait for NameServer query cmpl before we can
@@ -2625,7 +2610,7 @@ lpfc_els_handle_rscn(struct lpfc_hba * p
 	} else {
 		/* If login to NameServer does not exist, issue one */
 		/* Good status, issue PLOGI to NameServer */
-		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, NameServer_DID);
+		ndlp = lpfc_findnode_did(phba, NameServer_DID);
 		if (ndlp) {
 			/* Wait for NameServer login cmpl before we can
 			   continue */
@@ -2859,6 +2844,7 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
 
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_acc;
 	phba->fc_stat.elsXmitACC++;
+
 	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 	}
@@ -3144,8 +3130,9 @@ lpfc_els_rcv_fan(struct lpfc_hba * phba,
 			 */
 
 			list_for_each_entry_safe(ndlp, next_ndlp,
-				&phba->fc_npr_list, nlp_listp) {
-
+						 &phba->fc_nodes, nlp_listp) {
+				if (ndlp->nlp_state != NLP_STE_NPR_NODE)
+					continue;
 				if (ndlp->nlp_type & NLP_FABRIC) {
 					/*
 					 * Clean up old Fabric, Nameserver and
@@ -3168,8 +3155,10 @@ lpfc_els_rcv_fan(struct lpfc_hba * phba,
 		/* Discovery not needed,
 		 * move the nodes to their original state.
 		 */
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
-			nlp_listp) {
+		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes,
+					 nlp_listp) {
+			if (ndlp->nlp_state != NLP_STE_NPR_NODE)
+				continue;
 
 			switch (ndlp->nlp_prev_state) {
 			case NLP_STE_UNMAPPED_NODE:
@@ -3409,7 +3398,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	}
 
 	did = icmd->un.rcvels.remoteID;
-	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, did);
+	ndlp = lpfc_findnode_did(phba, did);
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
 		ndlp = mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:42.000000000 -0400
@@ -255,17 +255,7 @@ struct lpfc_hba {
 
 	struct lpfc_stats fc_stat;
 
-	/* These are the head/tail pointers for the bind, plogi, adisc, unmap,
-	 *  and map lists.  Their counters are immediately following.
-	 */
-	struct list_head fc_plogi_list;
-	struct list_head fc_adisc_list;
-	struct list_head fc_reglogin_list;
-	struct list_head fc_prli_list;
-	struct list_head fc_nlpunmap_list;
-	struct list_head fc_nlpmap_list;
-	struct list_head fc_npr_list;
-	struct list_head fc_unused_list;
+	struct list_head fc_nodes;
 
 	/* Keep counters for the number of entries in each list. */
 	uint16_t fc_plogi_cnt;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:42.000000000 -0400
@@ -374,13 +374,12 @@ lpfc_workq_post_event(struct lpfc_hba * 
 }
 
 int
-lpfc_linkdown(struct lpfc_hba * phba)
+lpfc_linkdown(struct lpfc_hba *phba)
 {
 	struct lpfc_sli       *psli;
 	struct lpfc_nodelist  *ndlp, *next_ndlp;
-	struct list_head *listp, *node_list[7];
-	LPFC_MBOXQ_t     *mb;
-	int               rc, i;
+	LPFC_MBOXQ_t          *mb;
+	int                   rc;
 
 	psli = &phba->sli;
 	/* sysfs or selective reset may call this routine to clean up */
@@ -412,32 +411,18 @@ lpfc_linkdown(struct lpfc_hba * phba)
 	/* Cleanup any outstanding ELS commands */
 	lpfc_els_flush_cmd(phba);
 
-	/* Issue a LINK DOWN event to all nodes */
-	node_list[0] = &phba->fc_npr_list;  /* MUST do this list first */
-	node_list[1] = &phba->fc_nlpmap_list;
-	node_list[2] = &phba->fc_nlpunmap_list;
-	node_list[3] = &phba->fc_prli_list;
-	node_list[4] = &phba->fc_reglogin_list;
-	node_list[5] = &phba->fc_adisc_list;
-	node_list[6] = &phba->fc_plogi_list;
-	for (i = 0; i < 7; i++) {
-		listp = node_list[i];
-		if (list_empty(listp))
-			continue;
-
-		list_for_each_entry_safe(ndlp, next_ndlp, listp, nlp_listp) {
-
+	/*
+	 * Issue a LINK DOWN event to all nodes.
+	 */
+	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes, nlp_listp) {
+				/* free any ndlp's on unused list */
+		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+			lpfc_drop_node(phba, ndlp);
+		else		/* otherwise, force node recovery. */
 			rc = lpfc_disc_state_machine(phba, ndlp, NULL,
-					     NLP_EVT_DEVICE_RECOVERY);
-
-		}
+						     NLP_EVT_DEVICE_RECOVERY);
 	}
 
-	/* free any ndlp's on unused list */
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_unused_list,
-				nlp_listp)
-		lpfc_drop_node(phba, ndlp);
-
 	/* Setup myDID for link up if we are in pt2pt mode */
 	if (phba->fc_flag & FC_PT2PT) {
 		phba->fc_myDID = 0;
@@ -466,11 +451,9 @@ lpfc_linkdown(struct lpfc_hba * phba)
 }
 
 static int
-lpfc_linkup(struct lpfc_hba * phba)
+lpfc_linkup(struct lpfc_hba *phba)
 {
 	struct lpfc_nodelist *ndlp, *next_ndlp;
-	struct list_head *listp, *node_list[7];
-	int i;
 
 	fc_host_post_event(phba->host, fc_get_event_number(),
 			FCH_EVT_LINKUP, 0);
@@ -484,29 +467,20 @@ lpfc_linkup(struct lpfc_hba * phba)
 	spin_unlock_irq(phba->host->host_lock);
 

-	node_list[0] = &phba->fc_plogi_list;
-	node_list[1] = &phba->fc_adisc_list;
-	node_list[2] = &phba->fc_reglogin_list;
-	node_list[3] = &phba->fc_prli_list;
-	node_list[4] = &phba->fc_nlpunmap_list;
-	node_list[5] = &phba->fc_nlpmap_list;
-	node_list[6] = &phba->fc_npr_list;
-	for (i = 0; i < 7; i++) {
-		listp = node_list[i];
-		if (list_empty(listp))
-			continue;
-
-		list_for_each_entry_safe(ndlp, next_ndlp, listp, nlp_listp) {
-			if (phba->fc_flag & FC_LBIT) {
+	if (phba->fc_flag & FC_LBIT) {
+		list_for_each_entry(ndlp, &phba->fc_nodes, nlp_listp) {
+			if (ndlp->nlp_state != NLP_STE_UNUSED_NODE) {
 				if (ndlp->nlp_type & NLP_FABRIC) {
-					/* On Linkup its safe to clean up the
+					/*
+					 * On Linkup its safe to clean up the
 					 * ndlp from Fabric connections.
 					 */
 					lpfc_nlp_set_state(phba, ndlp,
-						       NLP_STE_UNUSED_NODE);
+							   NLP_STE_UNUSED_NODE);
 				} else if (!(ndlp->nlp_flag & NLP_NPR_ADISC)) {
-					/* Fail outstanding IO now since device
-					 * is marked for PLOGI.
+					/*
+					 * Fail outstanding IO now since
+					 * device is marked for PLOGI.
 					 */
 					lpfc_unreg_rpi(phba, ndlp);
 				}
@@ -515,9 +489,11 @@ lpfc_linkup(struct lpfc_hba * phba)
 	}
 
 	/* free any ndlp's on unused list */
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_unused_list,
-				nlp_listp)
-		lpfc_drop_node(phba, ndlp);
+	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes,
+				 nlp_listp) {
+		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+			lpfc_drop_node(phba, ndlp);
+	}
 
 	return 0;
 }
@@ -1021,7 +997,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 		 */
 		lpfc_issue_els_scr(phba, SCR_DID, 0);
 
-		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, NameServer_DID);
+		ndlp = lpfc_findnode_did(phba, NameServer_DID);
 		if (!ndlp) {
 			/* Allocate a new node instance. If the pool is empty,
 			 * start the discovery process and skip the Nameserver
@@ -1200,6 +1176,7 @@ lpfc_unregister_remote_port(struct lpfc_
 static void
 lpfc_nlp_counters(struct lpfc_hba *phba, int state, int count)
 {
+	spin_lock_irq(phba->host->host_lock);
 	switch (state) {
 	case NLP_STE_UNUSED_NODE:
 		phba->fc_unused_cnt += count;
@@ -1226,107 +1203,7 @@ lpfc_nlp_counters(struct lpfc_hba *phba,
 		phba->fc_npr_cnt += count;
 		break;
 	}
-}
-
-void
-lpfc_delink_node(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
-{
-	switch (ndlp->nlp_flag & NLP_LIST_MASK) {
-	case NLP_UNUSED_LIST:
-		list_del_init(&ndlp->nlp_listp);
-		break;
-	case NLP_PLOGI_LIST:
-		list_del_init(&ndlp->nlp_listp);
-		break;
-	case NLP_ADISC_LIST:
-		list_del_init(&ndlp->nlp_listp);
-		break;
-	case NLP_REGLOGIN_LIST:
-		list_del_init(&ndlp->nlp_listp);
-		break;
-	case NLP_PRLI_LIST:
-		list_del_init(&ndlp->nlp_listp);
-		break;
-	case NLP_UNMAPPED_LIST:
-		list_del_init(&ndlp->nlp_listp);
-		break;
-	case NLP_MAPPED_LIST:
-		list_del_init(&ndlp->nlp_listp);
-		break;
-	case NLP_NPR_LIST:
-		list_del_init(&ndlp->nlp_listp);
-		break;
-	}
-
-	ndlp->nlp_flag &= ~NLP_LIST_MASK;
-}
-
-static int
-lpfc_nlp_list(struct lpfc_hba * phba, struct lpfc_nodelist * nlp, int list)
-{
-	struct lpfc_sli      *psli;
-
-	psli = &phba->sli;
-	/* Sanity check to ensure we are not moving to / from the same list */
-	if ((nlp->nlp_flag & NLP_LIST_MASK) == list)
-		return 0;
-
-	spin_lock_irq(phba->host->host_lock);
-	lpfc_delink_node(phba, nlp);
-
-	/* Add NPort <did> to <num> list */
-	lpfc_printf_log(phba,
-			KERN_INFO,
-			LOG_NODE,
-			"%d:0904 Add NPort x%x to %d list Data: x%x\n",
-			phba->brd_no,
-			nlp->nlp_DID, list, nlp->nlp_flag);
-
-	switch (list) {
-	case NLP_UNUSED_LIST:
-		nlp->nlp_flag |= list;
-		/* Put it at the end of the unused list */
-		list_add_tail(&nlp->nlp_listp, &phba->fc_unused_list);
-		break;
-	case NLP_PLOGI_LIST:
-		nlp->nlp_flag |= list;
-		/* Put it at the end of the plogi list */
-		list_add_tail(&nlp->nlp_listp, &phba->fc_plogi_list);
-		break;
-	case NLP_ADISC_LIST:
-		nlp->nlp_flag |= list;
-		/* Put it at the end of the adisc list */
-		list_add_tail(&nlp->nlp_listp, &phba->fc_adisc_list);
-		break;
-	case NLP_REGLOGIN_LIST:
-		nlp->nlp_flag |= list;
-		/* Put it at the end of the reglogin list */
-		list_add_tail(&nlp->nlp_listp, &phba->fc_reglogin_list);
-		break;
-	case NLP_PRLI_LIST:
-		nlp->nlp_flag |= list;
-		/* Put it at the end of the prli list */
-		list_add_tail(&nlp->nlp_listp, &phba->fc_prli_list);
-		break;
-	case NLP_UNMAPPED_LIST:
-		nlp->nlp_flag |= list;
-		/* Put it at the end of the unmap list */
-		list_add_tail(&nlp->nlp_listp, &phba->fc_nlpunmap_list);
-		break;
-	case NLP_MAPPED_LIST:
-		nlp->nlp_flag |= list;
-		/* Put it at the end of the map list */
-		list_add_tail(&nlp->nlp_listp, &phba->fc_nlpmap_list);
-		break;
-	case NLP_NPR_LIST:
-		nlp->nlp_flag |= list;
-		/* Put it at the end of the npr list */
-		list_add_tail(&nlp->nlp_listp, &phba->fc_npr_list);
-		break;
-	}
-
 	spin_unlock_irq(phba->host->host_lock);
-	return 0;
 }
 
 static void
@@ -1378,21 +1255,39 @@ lpfc_nlp_state_cleanup(struct lpfc_hba *
 	}
 }
 
+static char *
+lpfc_nlp_state_name(char *buffer, size_t size, int state)
+{
+	static char *states[] = {
+		[NLP_STE_UNUSED_NODE] = "UNUSED",
+		[NLP_STE_PLOGI_ISSUE] = "PLOGI",
+		[NLP_STE_ADISC_ISSUE] = "ADISC",
+		[NLP_STE_REG_LOGIN_ISSUE] = "REGLOGIN",
+		[NLP_STE_PRLI_ISSUE] = "PRLI",
+		[NLP_STE_UNMAPPED_NODE] = "UNMAPPED",
+		[NLP_STE_MAPPED_NODE] = "MAPPED",
+		[NLP_STE_NPR_NODE] = "NPR",
+	};
+
+	if (state < ARRAY_SIZE(states) && states[state])
+		strlcpy(buffer, states[state], size);
+	else
+		snprintf(buffer, size, "unknown (%d)", state);
+	return buffer;
+}
+
 void
 lpfc_nlp_set_state(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp, int state)
 {
 	int  old_state = ndlp->nlp_state;
-	static int  list_id[] = {
-		[NLP_STE_UNUSED_NODE] = NLP_UNUSED_LIST,
-		[NLP_STE_PLOGI_ISSUE] = NLP_PLOGI_LIST,
-		[NLP_STE_ADISC_ISSUE] = NLP_ADISC_LIST,
-		[NLP_STE_REG_LOGIN_ISSUE] = NLP_REGLOGIN_LIST,
-		[NLP_STE_PRLI_ISSUE] = NLP_PRLI_LIST,
-		[NLP_STE_UNMAPPED_NODE] = NLP_UNMAPPED_LIST,
-		[NLP_STE_MAPPED_NODE] = NLP_MAPPED_LIST,
-		[NLP_STE_NPR_NODE] = NLP_NPR_LIST,
-	};
+	char name1[16], name2[16];
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
+			"%d:0904 NPort state transition x%06x, %s -> %s\n",
+			phba->brd_no,
+			ndlp->nlp_DID,
+			lpfc_nlp_state_name(name1, sizeof(name1), old_state),
+			lpfc_nlp_state_name(name2, sizeof(name2), state));
 	if (old_state == NLP_STE_NPR_NODE &&
 	    (ndlp->nlp_flag & NLP_DELAY_TMO) != 0 &&
 	    state != NLP_STE_NPR_NODE)
@@ -1402,13 +1297,15 @@ lpfc_nlp_set_state(struct lpfc_hba *phba
 		ndlp->nlp_type &= ~NLP_FC_NODE;
 	}
 
-	if (old_state && !list_empty(&ndlp->nlp_listp))
+	if (list_empty(&ndlp->nlp_listp)) {
+		spin_lock_irq(phba->host->host_lock);
+		list_add_tail(&ndlp->nlp_listp, &phba->fc_nodes);
+		spin_unlock_irq(phba->host->host_lock);
+	} else if (old_state)
 		lpfc_nlp_counters(phba, old_state, -1);
 
 	ndlp->nlp_state = state;
-	lpfc_nlp_list(phba, ndlp, list_id[state]);
 	lpfc_nlp_counters(phba, state, 1);
-
 	lpfc_nlp_state_cleanup(phba, ndlp, old_state, state);
 }
 
@@ -1417,10 +1314,10 @@ lpfc_dequeue_node(struct lpfc_hba *phba,
 {
 	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)
 		lpfc_cancel_retry_delay_tmo(phba, ndlp);
-	spin_lock_irq(phba->host->host_lock);
 	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
 		lpfc_nlp_counters(phba, ndlp->nlp_state, -1);
-	lpfc_delink_node(phba, ndlp);
+	spin_lock_irq(phba->host->host_lock);
+	list_del_init(&ndlp->nlp_listp);
 	spin_unlock_irq(phba->host->host_lock);
 	lpfc_nlp_state_cleanup(phba, ndlp, ndlp->nlp_state, 0);
 }
@@ -1430,10 +1327,10 @@ lpfc_drop_node(struct lpfc_hba *phba, st
 {
 	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)
 		lpfc_cancel_retry_delay_tmo(phba, ndlp);
-	spin_lock_irq(phba->host->host_lock);
 	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
 		lpfc_nlp_counters(phba, ndlp->nlp_state, -1);
-	lpfc_delink_node(phba, ndlp);
+	spin_lock_irq(phba->host->host_lock);
+	list_del_init(&ndlp->nlp_listp);
 	spin_unlock_irq(phba->host->host_lock);
 	lpfc_nlp_put(ndlp);
 }
@@ -1638,7 +1535,7 @@ lpfc_unreg_rpi(struct lpfc_hba * phba, s
  * so it can be freed.
  */
 static int
-lpfc_freenode(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp)
+lpfc_cleanup_node(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp)
 {
 	LPFC_MBOXQ_t       *mb;
 	LPFC_MBOXQ_t       *nextmb;
@@ -1708,7 +1605,7 @@ lpfc_nlp_remove(struct lpfc_hba *phba, s
 		lpfc_cancel_retry_delay_tmo(phba, ndlp);
 	}
 
-	lpfc_freenode(phba, ndlp);
+	lpfc_cleanup_node(phba, ndlp);
 
 	if ((ndlp->rport) && !(phba->fc_flag & FC_UNLOADING)) {
 		put_device(&ndlp->rport->dev);
@@ -1719,7 +1616,7 @@ lpfc_nlp_remove(struct lpfc_hba *phba, s
 }
 
 static int
-lpfc_matchdid(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp, uint32_t did)
+lpfc_matchdid(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp, uint32_t did)
 {
 	D_ID mydid;
 	D_ID ndlpdid;
@@ -1768,57 +1665,36 @@ lpfc_matchdid(struct lpfc_hba * phba, st
 	return 0;
 }
 
-/* Search for a nodelist entry on a specific list */
+/* Search for a nodelist entry */
 struct lpfc_nodelist *
-lpfc_findnode_did(struct lpfc_hba * phba, uint32_t order, uint32_t did)
+lpfc_findnode_did(struct lpfc_hba *phba, uint32_t did)
 {
 	struct lpfc_nodelist *ndlp;
-	struct list_head *lists[]={&phba->fc_nlpunmap_list,
-				   &phba->fc_nlpmap_list,
-				   &phba->fc_plogi_list,
-				   &phba->fc_adisc_list,
-				   &phba->fc_reglogin_list,
-				   &phba->fc_prli_list,
-				   &phba->fc_npr_list,
-				   &phba->fc_unused_list};
-	uint32_t search[]={NLP_SEARCH_UNMAPPED,
-			   NLP_SEARCH_MAPPED,
-			   NLP_SEARCH_PLOGI,
-			   NLP_SEARCH_ADISC,
-			   NLP_SEARCH_REGLOGIN,
-			   NLP_SEARCH_PRLI,
-			   NLP_SEARCH_NPR,
-			   NLP_SEARCH_UNUSED};
-	int i;
 	uint32_t data1;
 
 	spin_lock_irq(phba->host->host_lock);
-	for (i = 0; i < ARRAY_SIZE(lists); i++ ) {
-		if (!(order & search[i]))
-			continue;
-		list_for_each_entry(ndlp, lists[i], nlp_listp) {
-			if (lpfc_matchdid(phba, ndlp, did)) {
-				data1 = (((uint32_t) ndlp->nlp_state << 24) |
-					 ((uint32_t) ndlp->nlp_xri << 16) |
-					 ((uint32_t) ndlp->nlp_type << 8) |
-					 ((uint32_t) ndlp->nlp_rpi & 0xff));
-				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0929 FIND node DID "
-						" Data: x%p x%x x%x x%x\n",
-						phba->brd_no,
-						ndlp, ndlp->nlp_DID,
-						ndlp->nlp_flag, data1);
-				spin_unlock_irq(phba->host->host_lock);
-				return ndlp;
-			}
+	list_for_each_entry(ndlp, &phba->fc_nodes, nlp_listp) {
+		if (lpfc_matchdid(phba, ndlp, did)) {
+			data1 = (((uint32_t) ndlp->nlp_state << 24) |
+				 ((uint32_t) ndlp->nlp_xri << 16) |
+				 ((uint32_t) ndlp->nlp_type << 8) |
+				 ((uint32_t) ndlp->nlp_rpi & 0xff));
+			lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
+					"%d:0929 FIND node DID "
+					" Data: x%p x%x x%x x%x\n",
+					phba->brd_no,
+					ndlp, ndlp->nlp_DID,
+					ndlp->nlp_flag, data1);
+			spin_unlock_irq(phba->host->host_lock);
+			return ndlp;
 		}
 	}
 	spin_unlock_irq(phba->host->host_lock);
 
 	/* FIND node did <did> NOT FOUND */
 	lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-			"%d:0932 FIND node did x%x NOT FOUND Data: x%x\n",
-			phba->brd_no, did, order);
+			"%d:0932 FIND node did x%x NOT FOUND.\n",
+			phba->brd_no, did);
 	return NULL;
 }
 
@@ -1826,9 +1702,8 @@ struct lpfc_nodelist *
 lpfc_setup_disc_node(struct lpfc_hba * phba, uint32_t did)
 {
 	struct lpfc_nodelist *ndlp;
-	uint32_t flg;
 
-	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, did);
+	ndlp = lpfc_findnode_did(phba, did);
 	if (!ndlp) {
 		if ((phba->fc_flag & FC_RSCN_MODE) &&
 		   ((lpfc_rscn_payload_check(phba, did) == 0)))
@@ -1854,8 +1729,8 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 		} else
 			ndlp = NULL;
 	} else {
-		flg = ndlp->nlp_flag & NLP_LIST_MASK;
-		if ((flg == NLP_ADISC_LIST) || (flg == NLP_PLOGI_LIST))
+		if (ndlp->nlp_state == NLP_STE_ADISC_ISSUE ||
+		    ndlp->nlp_state == NLP_STE_PLOGI_ISSUE)
 			return NULL;
 		lpfc_nlp_set_state(phba, ndlp, NLP_STE_NPR_NODE);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
@@ -1915,8 +1790,9 @@ lpfc_disc_start(struct lpfc_hba * phba)
 	struct lpfc_sli *psli;
 	LPFC_MBOXQ_t *mbox;
 	struct lpfc_nodelist *ndlp, *next_ndlp;
-	uint32_t did_changed, num_sent;
+	uint32_t num_sent;
 	uint32_t clear_la_pending;
+	int did_changed;
 	int rc;
 
 	psli = &phba->sli;
@@ -1950,14 +1826,13 @@ lpfc_disc_start(struct lpfc_hba * phba)
 			phba->fc_plogi_cnt, phba->fc_adisc_cnt);
 
 	/* If our did changed, we MUST do PLOGI */
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
-				nlp_listp) {
-		if (ndlp->nlp_flag & NLP_NPR_2B_DISC) {
-			if (did_changed) {
-				spin_lock_irq(phba->host->host_lock);
-				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-				spin_unlock_irq(phba->host->host_lock);
-			}
+	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes, nlp_listp) {
+		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
+		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
+		    did_changed) {
+			spin_lock_irq(phba->host->host_lock);
+			ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+			spin_unlock_irq(phba->host->host_lock);
 		}
 	}
 
@@ -2077,21 +1952,16 @@ lpfc_disc_flush_list(struct lpfc_hba * p
 {
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 
-	if (phba->fc_plogi_cnt) {
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_plogi_list,
-					nlp_listp) {
-			lpfc_free_tx(phba, ndlp);
-			lpfc_nlp_put(ndlp);
-		}
-	}
-	if (phba->fc_adisc_cnt) {
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_adisc_list,
-					nlp_listp) {
-			lpfc_free_tx(phba, ndlp);
-			lpfc_nlp_put(ndlp);
+	if (phba->fc_plogi_cnt || phba->fc_adisc_cnt) {
+		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes,
+					 nlp_listp) {
+			if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE ||
+			    ndlp->nlp_state == NLP_STE_ADISC_ISSUE) {
+				lpfc_free_tx(phba, ndlp);
+				lpfc_nlp_put(ndlp);
+			}
 		}
 	}
-	return;
 }
 
 /*****************************************************************************/
@@ -2160,8 +2030,10 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 				 phba->brd_no);
 
 		/* Start discovery by sending FLOGI, clean up old rpis */
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
-					nlp_listp) {
+		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes,
+					 nlp_listp) {
+			if (ndlp->nlp_state != NLP_STE_NPR_NODE)
+				continue;
 			if (ndlp->nlp_type & NLP_FABRIC) {
 				/* Clean up the ndlp on Fabric connections */
 				lpfc_drop_node(phba, ndlp);
@@ -2205,7 +2077,7 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 				"login\n", phba->brd_no);
 
 		/* Next look for NameServer ndlp */
-		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, NameServer_DID);
+		ndlp = lpfc_findnode_did(phba, NameServer_DID);
 		if (ndlp)
 			lpfc_nlp_put(ndlp);
 		/* Start discovery */
@@ -2220,9 +2092,8 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 				phba->brd_no,
 				phba->fc_ns_retry, LPFC_MAX_NS_RETRY);
 
-		ndlp = lpfc_findnode_did(phba, NLP_SEARCH_UNMAPPED,
-								NameServer_DID);
-		if (ndlp) {
+		ndlp = lpfc_findnode_did(phba, NameServer_DID);
+		if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 			if (phba->fc_ns_retry < LPFC_MAX_NS_RETRY) {
 				/* Try it one more time */
 				rc = lpfc_ns_cmd(phba, ndlp, SLI_CTNS_GID_FT);
@@ -2394,31 +2265,63 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 	return;
 }
 
+static int
+lpfc_filter_by_rpi(struct lpfc_nodelist *ndlp, void *param)
+{
+	uint16_t *rpi = param;
+
+	return ndlp->nlp_rpi == *rpi;
+}
+
+static int
+lpfc_filter_by_wwpn(struct lpfc_nodelist *ndlp, void *param)
+{
+	return memcmp(&ndlp->nlp_portname, param,
+		      sizeof(ndlp->nlp_portname)) == 0;
+}
+
 /*
- * This routine looks up the ndlp  lists
- * for the given RPI. If rpi found
- * it return the node list pointer
- * else return NULL.
+ * Search node lists for a remote port matching filter criteria
+ * Caller needs to hold host_lock before calling this routine.
  */
 struct lpfc_nodelist *
-__lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi)
+__lpfc_find_node(struct lpfc_hba *phba, node_filter filter, void *param)
 {
 	struct lpfc_nodelist *ndlp;
-	struct list_head * lists[]={&phba->fc_nlpunmap_list,
-				    &phba->fc_nlpmap_list,
-				    &phba->fc_plogi_list,
-				    &phba->fc_adisc_list,
-				    &phba->fc_reglogin_list};
-	int i;
 
-	for (i = 0; i < ARRAY_SIZE(lists); i++ )
-		list_for_each_entry(ndlp, lists[i], nlp_listp)
-			if (ndlp->nlp_rpi == rpi) {
-				return ndlp;
-			}
+	list_for_each_entry(ndlp, &phba->fc_nodes, nlp_listp) {
+		if (ndlp->nlp_state != NLP_STE_UNUSED_NODE &&
+		    filter(ndlp, param))
+			return ndlp;
+	}
 	return NULL;
 }
 
+/*
+ * Search node lists for a remote port matching filter criteria
+ * This routine is used when the caller does NOT have host_lock.
+ */
+struct lpfc_nodelist *
+lpfc_find_node(struct lpfc_hba *phba, node_filter filter, void *param)
+{
+	struct lpfc_nodelist *ndlp;
+
+	spin_lock_irq(phba->host->host_lock);
+	ndlp = __lpfc_find_node(phba, filter, param);
+	spin_unlock_irq(phba->host->host_lock);
+	return ndlp;
+}
+
+/*
+ * This routine looks up the ndlp lists for the given RPI. If rpi found it
+ * returns the node list pointer else return NULL.
+ */
+struct lpfc_nodelist *
+__lpfc_findnode_rpi(struct lpfc_hba *phba, uint16_t rpi)
+{
+	return __lpfc_find_node(phba, lpfc_filter_by_rpi, &rpi);
+}
+
 struct lpfc_nodelist *
 lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi)
 {
@@ -2431,44 +2334,16 @@ lpfc_findnode_rpi(struct lpfc_hba * phba
 }
 
 /*
- * This routine looks up the ndlp  lists
- * for the given WWPN. If WWPN found
- * it return the node list pointer
- * else return NULL.
+ * This routine looks up the ndlp lists for the given WWPN. If WWPN found it
+ * returns the node list pointer else return NULL.
  */
 struct lpfc_nodelist *
-lpfc_findnode_wwpn(struct lpfc_hba * phba, uint32_t order,
-		   struct lpfc_name * wwpn)
+lpfc_findnode_wwpn(struct lpfc_hba *phba, struct lpfc_name *wwpn)
 {
 	struct lpfc_nodelist *ndlp;
-	struct list_head * lists[]={&phba->fc_nlpunmap_list,
-				    &phba->fc_nlpmap_list,
-				    &phba->fc_npr_list,
-				    &phba->fc_plogi_list,
-				    &phba->fc_adisc_list,
-				    &phba->fc_reglogin_list,
-				    &phba->fc_prli_list};
-	uint32_t search[]={NLP_SEARCH_UNMAPPED,
-			   NLP_SEARCH_MAPPED,
-			   NLP_SEARCH_NPR,
-			   NLP_SEARCH_PLOGI,
-			   NLP_SEARCH_ADISC,
-			   NLP_SEARCH_REGLOGIN,
-			   NLP_SEARCH_PRLI};
-	int i;
 
 	spin_lock_irq(phba->host->host_lock);
-	for (i = 0; i < ARRAY_SIZE(lists); i++ ) {
-		if (!(order & search[i]))
-			continue;
-		list_for_each_entry(ndlp, lists[i], nlp_listp) {
-			if (memcmp(&ndlp->nlp_portname, wwpn,
-				   sizeof(struct lpfc_name)) == 0) {
-				spin_unlock_irq(phba->host->host_lock);
-				return ndlp;
-			}
-		}
-	}
+	ndlp = __lpfc_find_node(phba, lpfc_filter_by_wwpn, wwpn);
 	spin_unlock_irq(phba->host->host_lock);
 	return NULL;
 }
@@ -2484,6 +2359,7 @@ lpfc_nlp_init(struct lpfc_hba *phba, str
 	ndlp->nlp_DID = did;
 	ndlp->nlp_phba = phba;
 	ndlp->nlp_sid = NLP_NO_SID;
+	INIT_LIST_HEAD(&ndlp->nlp_listp);
 	kref_init(&ndlp->kref);
 	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:43.000000000 -0400
@@ -1185,63 +1185,11 @@ lpfc_cleanup(struct lpfc_hba * phba)
 
 	/* clean up phba - lpfc specific */
 	lpfc_can_disctmo(phba);
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nlpunmap_list,
-				nlp_listp) {
+	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes, nlp_listp)
 		lpfc_nlp_put(ndlp);
-	}
-
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nlpmap_list,
-				 nlp_listp) {
-		lpfc_nlp_put(ndlp);
-	}
-
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_unused_list,
-				nlp_listp) {
-		lpfc_drop_node(phba, ndlp);
-	}
 
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_plogi_list,
-				nlp_listp) {
-		lpfc_nlp_put(ndlp);
-	}
-
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_adisc_list,
-				nlp_listp) {
-		lpfc_nlp_put(ndlp);
-	}
+	INIT_LIST_HEAD(&phba->fc_nodes);
 
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_reglogin_list,
-				nlp_listp) {
-		lpfc_nlp_put(ndlp);
-	}
-
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_prli_list,
-				nlp_listp) {
-		lpfc_nlp_put(ndlp);
-	}
-
-	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
-				nlp_listp) {
-		lpfc_nlp_put(ndlp);
-	}
-
-	INIT_LIST_HEAD(&phba->fc_nlpmap_list);
-	INIT_LIST_HEAD(&phba->fc_nlpunmap_list);
-	INIT_LIST_HEAD(&phba->fc_unused_list);
-	INIT_LIST_HEAD(&phba->fc_plogi_list);
-	INIT_LIST_HEAD(&phba->fc_adisc_list);
-	INIT_LIST_HEAD(&phba->fc_reglogin_list);
-	INIT_LIST_HEAD(&phba->fc_prli_list);
-	INIT_LIST_HEAD(&phba->fc_npr_list);
-
-	phba->fc_map_cnt   = 0;
-	phba->fc_unmap_cnt = 0;
-	phba->fc_plogi_cnt = 0;
-	phba->fc_adisc_cnt = 0;
-	phba->fc_reglogin_cnt = 0;
-	phba->fc_prli_cnt  = 0;
-	phba->fc_npr_cnt   = 0;
-	phba->fc_unused_cnt= 0;
 	return;
 }
 
@@ -1336,8 +1284,6 @@ void
 lpfc_offline_prep(struct lpfc_hba * phba)
 {
 	struct lpfc_nodelist  *ndlp, *next_ndlp;
-	struct list_head *listp, *node_list[7];
-	int i;
 
 	if (phba->fc_flag & FC_OFFLINE_MODE)
 		return;
@@ -1347,21 +1293,9 @@ lpfc_offline_prep(struct lpfc_hba * phba
 	lpfc_linkdown(phba);
 
 	/* Issue an unreg_login to all nodes */
-	node_list[0] = &phba->fc_npr_list;  /* MUST do this list first */
-	node_list[1] = &phba->fc_nlpmap_list;
-	node_list[2] = &phba->fc_nlpunmap_list;
-	node_list[3] = &phba->fc_prli_list;
-	node_list[4] = &phba->fc_reglogin_list;
-	node_list[5] = &phba->fc_adisc_list;
-	node_list[6] = &phba->fc_plogi_list;
-	for (i = 0; i < 7; i++) {
-		listp = node_list[i];
-		if (list_empty(listp))
-			continue;
-
-		list_for_each_entry_safe(ndlp, next_ndlp, listp, nlp_listp)
+	list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_nodes, nlp_listp)
+		if (ndlp->nlp_state != NLP_STE_UNUSED_NODE)
 			lpfc_unreg_rpi(phba, ndlp);
-	}
 
 	lpfc_sli_flush_mbox_queue(phba);
 }
@@ -1500,15 +1434,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	host->max_lun = phba->cfg_max_luns;
 	host->this_id = -1;
 
-	/* Initialize all internally managed lists. */
-	INIT_LIST_HEAD(&phba->fc_nlpmap_list);
-	INIT_LIST_HEAD(&phba->fc_nlpunmap_list);
-	INIT_LIST_HEAD(&phba->fc_unused_list);
-	INIT_LIST_HEAD(&phba->fc_plogi_list);
-	INIT_LIST_HEAD(&phba->fc_adisc_list);
-	INIT_LIST_HEAD(&phba->fc_reglogin_list);
-	INIT_LIST_HEAD(&phba->fc_prli_list);
-	INIT_LIST_HEAD(&phba->fc_npr_list);
+	INIT_LIST_HEAD(&phba->fc_nodes);
 
 	pci_set_master(pdev);
 	retval = pci_set_mwi(pdev);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-04-24 11:12:43.000000000 -0400
@@ -1175,10 +1175,12 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	 * fail, this routine returns failure to the midlayer.
 	 */
 	for (i = 0; i < LPFC_MAX_TARGET; i++) {
-		/* Search the mapped list for this target ID */
+		/* Search for mapped node by target ID */
 		match = 0;
-		list_for_each_entry(ndlp, &phba->fc_nlpmap_list, nlp_listp) {
-			if ((i == ndlp->nlp_sid) && ndlp->rport) {
+		list_for_each_entry(ndlp, &phba->fc_nodes, nlp_listp) {
+			if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
+			    i == ndlp->nlp_sid &&
+			    ndlp->rport) {
 				match = 1;
 				break;
 			}


