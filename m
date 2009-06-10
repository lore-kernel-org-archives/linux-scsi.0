From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 2/5] lpfc 8.3.3 : FC/FCOE discovery fixes
Date: Wed, 10 Jun 2009 17:22:56 -0400
Message-ID: <1244668976.9571.17.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37918 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbZFJVW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 17:22:57 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n5ALMxVW001366
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 14:22:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

FC/FCoE discovery fixes

Contains the following changes:
- Force vport to send LOGO to fabric controller when deleting vport
- Fixed driver failing to register login when a PLOGI is received
- Fixes for FIP discovery
- Added stricter checks for FCF addressing mode
- Added code to send only FLOGI, FDISC and LOGO to Fabric controller as FIP
- Fixed handling of LOGO from Fabric port
- Fixed consecutive link up events skipped link_down processing

Signed-off-by: James Smart <James.Smart@emulex.com>
---

 drivers/scsi/lpfc/lpfc_els.c       |   13 +++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   35 ++++++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_hw4.h       |    2 +-
 drivers/scsi/lpfc/lpfc_mbox.c      |    6 ++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c       |   24 +++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli.h       |    1 +
 drivers/scsi/lpfc/lpfc_vport.c     |    2 --
 8 files changed, 59 insertions(+), 26 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -168,6 +168,19 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 	if (elsiocb == NULL)
 		return NULL;
 
+	/*
+	 * If this command is for fabric controller and HBA running
+	 * in FIP mode send FLOGI, FDISC and LOGO as FIP frames.
+	 */
+	if ((did == Fabric_DID) &&
+		bf_get(lpfc_fip_flag, &phba->sli4_hba.sli4_flags) &&
+		((elscmd == ELS_CMD_FLOGI) ||
+		 (elscmd == ELS_CMD_FDISC) ||
+		 (elscmd == ELS_CMD_LOGO)))
+		elsiocb->iocb_flag |= LPFC_FIP_ELS;
+	else
+		elsiocb->iocb_flag &= ~LPFC_FIP_ELS;
+
 	icmd = &elsiocb->iocb;
 
 	/* fill in BDEs for command */
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1197,6 +1197,11 @@ lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
 {
 	struct lpfc_fcf_conn_entry *conn_entry;
 
+	/* If FCF not available return 0 */
+	if (!bf_get(lpfc_fcf_record_fcf_avail, new_fcf_record) ||
+		!bf_get(lpfc_fcf_record_fcf_valid, new_fcf_record))
+		return 0;
+
 	if (!phba->cfg_enable_fip) {
 		*boot_flag = 0;
 		*addr_mode = bf_get(lpfc_fcf_record_mac_addr_prov,
@@ -1216,6 +1221,14 @@ lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
 		*boot_flag = 0;
 		*addr_mode = bf_get(lpfc_fcf_record_mac_addr_prov,
 			new_fcf_record);
+
+		/*
+		 * When there are no FCF connect entries, use driver's default
+		 * addressing mode - FPMA.
+		 */
+		if (*addr_mode & LPFC_FCF_FPMA)
+			*addr_mode = LPFC_FCF_FPMA;
+
 		*vlan_id = 0xFFFF;
 		return 1;
 	}
@@ -1241,6 +1254,14 @@ lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
 		}
 
 		/*
+		 * If connection record does not support any addressing mode,
+		 * skip the FCF record.
+		 */
+		if (!(bf_get(lpfc_fcf_record_mac_addr_prov, new_fcf_record)
+			& (LPFC_FCF_FPMA | LPFC_FCF_SPMA)))
+			continue;
+
+		/*
 		 * Check if the connection record specifies a required
 		 * addressing mode.
 		 */
@@ -1272,6 +1293,11 @@ lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
 		else
 			*boot_flag = 0;
 
+		/*
+		 * If user did not specify any addressing mode, or if the
+		 * prefered addressing mode specified by user is not supported
+		 * by FCF, allow fabric to pick the addressing mode.
+		 */
 		*addr_mode = bf_get(lpfc_fcf_record_mac_addr_prov,
 				new_fcf_record);
 		/*
@@ -1297,12 +1323,6 @@ lpfc_match_fcf_conn_list(struct lpfc_hba *phba,
 			!(conn_entry->conn_rec.flags & FCFCNCT_AM_SPMA) &&
 			(*addr_mode & LPFC_FCF_FPMA))
 				*addr_mode = LPFC_FCF_FPMA;
-		/*
-		 * If user did not specify any addressing mode, use FPMA if
-		 * possible else use SPMA.
-		 */
-		else if (*addr_mode & LPFC_FCF_FPMA)
-			*addr_mode = LPFC_FCF_FPMA;
 
 		if (conn_entry->conn_rec.flags & FCFCNCT_VLAN_VALID)
 			*vlan_id = conn_entry->conn_rec.vlan_tag;
@@ -1864,7 +1884,7 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		vport->fc_flag &= ~FC_BYPASSED_MODE;
 	spin_unlock_irq(shost->host_lock);
 
-	if (((phba->fc_eventTag + 1) < la->eventTag) ||
+	if ((phba->fc_eventTag  < la->eventTag) ||
 	    (phba->fc_eventTag == la->eventTag)) {
 		phba->fc_stat.LinkMultiEvent++;
 		if (la->attType == AT_LINK_UP)
@@ -2925,6 +2945,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		lpfc_no_rpi(phba, ndlp);
 		ndlp->nlp_rpi = 0;
 		ndlp->nlp_flag &= ~NLP_RPI_VALID;
+		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 		return 1;
 	}
 	return 0;
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1128,7 +1128,7 @@ struct fcf_record {
 #define lpfc_fcf_record_mac_5_WORD		word4
 #define lpfc_fcf_record_fcf_avail_SHIFT		16
 #define lpfc_fcf_record_fcf_avail_MASK		0x000000FF
-#define lpfc_fcf_record_fc_avail_WORD		word4
+#define lpfc_fcf_record_fcf_avail_WORD		word4
 #define lpfc_fcf_record_mac_addr_prov_SHIFT	24
 #define lpfc_fcf_record_mac_addr_prov_MASK	0x000000FF
 #define lpfc_fcf_record_mac_addr_prov_WORD	word4
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1715,8 +1715,10 @@ lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
 	/* Set up host requested features. */
 	bf_set(lpfc_mbx_rq_ftr_rq_fcpi, &mboxq->u.mqe.un.req_ftrs, 1);
 
-	/* Virtual fabrics and FIPs are not supported yet. */
-	bf_set(lpfc_mbx_rq_ftr_rq_ifip, &mboxq->u.mqe.un.req_ftrs, 0);
+	if (phba->cfg_enable_fip)
+		bf_set(lpfc_mbx_rq_ftr_rq_ifip, &mboxq->u.mqe.un.req_ftrs, 0);
+	else
+		bf_set(lpfc_mbx_rq_ftr_rq_ifip, &mboxq->u.mqe.un.req_ftrs, 1);
 
 	/* Enable DIF (block guard) only if configured to do so. */
 	if (phba->cfg_enable_bg)
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -497,7 +497,7 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
 	else
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
-	if ((ndlp->nlp_type & NLP_FABRIC) &&
+	if ((ndlp->nlp_DID == Fabric_DID) &&
 		vport->port_type == LPFC_NPIV_PORT) {
 		lpfc_linkdown_port(vport);
 		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4491,8 +4491,10 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		rc = -ENODEV;
 		goto out_free_vpd;
 	}
-	/* Temporary initialization of lpfc_fip_flag to non-fip */
-	bf_set(lpfc_fip_flag, &phba->sli4_hba.sli4_flags, 0);
+	if (phba->cfg_enable_fip)
+		bf_set(lpfc_fip_flag, &phba->sli4_hba.sli4_flags, 1);
+	else
+		bf_set(lpfc_fip_flag, &phba->sli4_hba.sli4_flags, 0);
 
 	/* Set up all the queues to the device */
 	rc = lpfc_sli4_queue_setup(phba);
@@ -5856,18 +5858,13 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 	fip = bf_get(lpfc_fip_flag, &phba->sli4_hba.sli4_flags);
 	/* The fcp commands will set command type */
-	if ((!(iocbq->iocb_flag &  LPFC_IO_FCP)) && (!fip))
-		command_type = ELS_COMMAND_NON_FIP;
-	else if (!(iocbq->iocb_flag &  LPFC_IO_FCP))
-		command_type = ELS_COMMAND_FIP;
-	else if (iocbq->iocb_flag &  LPFC_IO_FCP)
+	if (iocbq->iocb_flag &  LPFC_IO_FCP)
 		command_type = FCP_COMMAND;
-	else {
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"2019 Invalid cmd 0x%x\n",
-			iocbq->iocb.ulpCommand);
-		return IOCB_ERROR;
-	}
+	else if (fip && (iocbq->iocb_flag & LPFC_FIP_ELS))
+		command_type = ELS_COMMAND_FIP;
+	else
+		command_type = ELS_COMMAND_NON_FIP;
+
 	/* Some of the fields are in the right position already */
 	memcpy(wqe, &iocbq->iocb, sizeof(union lpfc_wqe));
 	abort_tag = (uint32_t) iocbq->iotag;
@@ -11467,6 +11464,7 @@ lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *phba,
 	bf_set(lpfc_fcf_record_fc_map_1, fcf_record, phba->fc_map[1]);
 	bf_set(lpfc_fcf_record_fc_map_2, fcf_record, phba->fc_map[2]);
 	bf_set(lpfc_fcf_record_fcf_valid, fcf_record, 1);
+	bf_set(lpfc_fcf_record_fcf_avail, fcf_record, 1);
 	bf_set(lpfc_fcf_record_fcf_index, fcf_record, fcf_index);
 	bf_set(lpfc_fcf_record_mac_addr_prov, fcf_record,
 		LPFC_FCF_FPMA | LPFC_FCF_SPMA);
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -56,6 +56,7 @@ struct lpfc_iocbq {
 #define LPFC_DRIVER_ABORTED	8	/* driver aborted this request */
 #define LPFC_IO_FABRIC		0x10	/* Iocb send using fabric scheduler */
 #define LPFC_DELAY_MEM_FREE	0x20    /* Defer free'ing of FC data */
+#define LPFC_FIP_ELS		0x40
 
 	uint8_t abort_count;
 	uint8_t rsvd2;
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -695,8 +695,6 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		}
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
-		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
-			goto skip_logo;
 		if (!lpfc_issue_els_npiv_logo(vport, ndlp))
 			while (vport->unreg_vpi_cmpl == VPORT_INVAL && timeout)
 				timeout = schedule_timeout(timeout);


