From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 3/5] lpfc: Add support to generate RSCN events for nport
Date: Sat, 28 Oct 2017 18:14:54 -0700
Message-ID: <20171029011456.12885-4-jsmart2021@gmail.com>
References: <20171029011456.12885-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:50796 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdJ2BPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Oct 2017 21:15:07 -0400
Received: by mail-pg0-f67.google.com with SMTP id y5so8236549pgq.7
        for <linux-scsi@vger.kernel.org>; Sat, 28 Oct 2017 18:15:07 -0700 (PDT)
In-Reply-To: <20171029011456.12885-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

This patch adds general Changed Attribute RSCN support, both transmit
and receive, to the driver. This support will be used with NVME to
request initiators to perform nvme discovery.

This patch:
adds RSCN definitions
adds statistics on RSCN transmissions
creates a routine that will transmit a Changed Attribute RSCN
Handle RSCN receipt

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |   1 +
 drivers/scsi/lpfc/lpfc_crtn.h    |   2 +
 drivers/scsi/lpfc/lpfc_els.c     | 114 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c |  35 ++++++++++++
 drivers/scsi/lpfc/lpfc_hw.h      |   9 ++++
 drivers/scsi/lpfc/lpfc_sli.c     |   1 +
 6 files changed, 162 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8eb3f96fe068..157788f0bc10 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -277,6 +277,7 @@ struct lpfc_stats {
 	uint32_t elsXmitADISC;
 	uint32_t elsXmitLOGO;
 	uint32_t elsXmitSCR;
+	uint32_t elsXmitRSCN;
 	uint32_t elsXmitRNID;
 	uint32_t elsXmitFARP;
 	uint32_t elsXmitFARPR;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 7e300734b345..6657b71d5a57 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -142,6 +142,7 @@ int lpfc_issue_els_adisc(struct lpfc_vport *, struct lpfc_nodelist *, uint8_t);
 int lpfc_issue_els_logo(struct lpfc_vport *, struct lpfc_nodelist *, uint8_t);
 int lpfc_issue_els_npiv_logo(struct lpfc_vport *, struct lpfc_nodelist *);
 int lpfc_issue_els_scr(struct lpfc_vport *, uint32_t, uint8_t);
+int lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry);
 int lpfc_issue_fabric_reglogin(struct lpfc_vport *);
 int lpfc_els_free_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
 int lpfc_ct_free_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
@@ -357,6 +358,7 @@ void lpfc_mbox_timeout_handler(struct lpfc_hba *);
 struct lpfc_nodelist *lpfc_findnode_did(struct lpfc_vport *, uint32_t);
 struct lpfc_nodelist *lpfc_findnode_wwpn(struct lpfc_vport *,
 					 struct lpfc_name *);
+struct lpfc_nodelist *lpfc_findnode_mapped(struct lpfc_vport *vport);
 
 int lpfc_sli_issue_mbox_wait(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 468a66371de9..936fc22dfcae 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2868,6 +2868,109 @@ lpfc_cmpl_els_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
+ * lpfc_issue_els_rscn - Issue a rscn to an node on a vport
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @retry: number of retries to the command IOCB.
+ *
+ * This routine issues a RSCN to a fabric node on a @vport.
+ *  The remote node @nportid is passed into the function. It
+ * or Pt2Pt topologies, the first MAPPED node will get an RSCN
+ * notification.  For Fabric topologies, the well known SCR_DID
+ * gets notified for broadcast to all zone members.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the RSCN ELS command.
+ *
+ * Return code
+ *   0 - Successfully issued RSCN command
+ *   1 - Failed to issue RSCN command
+ **/
+int
+lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
+{
+	struct lpfc_hba  *phba = vport->phba;
+	struct lpfc_iocbq *elsiocb;
+	uint8_t *pcmd;
+	uint16_t cmdsize;
+	uint32_t value, nportid;
+	struct lpfc_nodelist *ndlp;
+
+	/* Not supported for private loop */
+	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP &&
+	    !(vport->fc_flag & FC_PUBLIC_LOOP))
+		return 1;
+
+	cmdsize = (sizeof(uint32_t) + sizeof(SCR));
+	if (vport->fc_flag & FC_PT2PT) {
+		ndlp = lpfc_findnode_mapped(vport);
+		if (!ndlp)
+			return 1;
+	} else {
+		nportid = SCR_DID;
+
+		ndlp = lpfc_findnode_did(vport, nportid);
+		if (!ndlp) {
+			ndlp = lpfc_nlp_init(vport, nportid);
+			if (!ndlp)
+				return 1;
+			lpfc_enqueue_node(vport, ndlp);
+		} else if (!NLP_CHK_NODE_ACT(ndlp)) {
+			ndlp = lpfc_enable_node(vport, ndlp,
+						NLP_STE_UNUSED_NODE);
+			if (!ndlp)
+				return 1;
+		}
+	}
+	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
+				     ndlp->nlp_DID, ELS_CMD_RSCN_XMT);
+
+	if (!elsiocb) {
+		/* This will trigger the release of the node just
+		 * allocated
+		 */
+		lpfc_nlp_put(ndlp);
+		return 1;
+	}
+
+	pcmd = (uint8_t *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+
+	*((uint32_t *)(pcmd)) = ELS_CMD_RSCN_XMT;
+	pcmd += sizeof(uint32_t);
+
+	/* For SCR, remainder of payload is SCR parameter page */
+	memset(pcmd, 0, sizeof(struct fc_RSCN));
+	/* Generic Attribute of 0 is used */
+	value = vport->fc_myDID;
+
+	((struct fc_RSCN *)pcmd)->NPort_ID = be32_to_cpu(value);
+
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
+			      "Issue RSCN:       did:x%x",
+			      ndlp->nlp_DID, 0, 0);
+
+	phba->fc_stat.elsXmitRSCN++;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) ==
+	    IOCB_ERROR) {
+		/* The additional lpfc_nlp_put will cause the following
+		 * lpfc_els_free_iocb routine to trigger the rlease of
+		 * the node.
+		 */
+		lpfc_nlp_put(ndlp);
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
+	/* This will cause the callback-function lpfc_cmpl_els_cmd to
+	 * trigger the release of node.
+	 */
+
+	lpfc_nlp_put(ndlp);
+	return 0;
+}
+
+/**
  * lpfc_issue_els_scr - Issue a scr to an node on a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @nportid: N_Port identifier to the remote node.
@@ -6071,6 +6174,16 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		fc_host_post_event(shost, fc_get_event_number(),
 			FCH_EVT_RSCN, lp[i]);
 
+	/* Check if RSCN is coming from a direct-connected remote NPort */
+	if (vport->fc_flag & FC_PT2PT) {
+		/* If so, just ACC it, no other action needed for now */
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+				 "2024 pt2pt RSCN %08x Data: x%x x%x\n",
+				 *lp, vport->fc_flag, payload_len);
+		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
+		return 0;
+	}
+
 	/* If we are about to begin discovery, just ACC the RSCN.
 	 * Discovery processing will satisfy it.
 	 */
@@ -7886,6 +7999,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	elsiocb->vport = vport;
 
+	/* Since RSCN can be varying lengths, lets mask that off */
 	if ((cmd & ELS_CMD_MASK) == ELS_CMD_RSCN) {
 		cmd &= ELS_CMD_MASK;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 20808349a80e..3eb37d5070c3 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5119,6 +5119,41 @@ __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 }
 
 struct lpfc_nodelist *
+lpfc_findnode_mapped(struct lpfc_vport *vport)
+{
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_nodelist *ndlp;
+	uint32_t data1;
+	unsigned long iflags;
+
+	spin_lock_irqsave(shost->host_lock, iflags);
+
+	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
+		if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE ||
+		    ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
+			data1 = (((uint32_t)ndlp->nlp_state << 24) |
+				 ((uint32_t)ndlp->nlp_xri << 16) |
+				 ((uint32_t)ndlp->nlp_type << 8) |
+				 ((uint32_t)ndlp->nlp_rpi & 0xff));
+			spin_unlock_irqrestore(shost->host_lock, iflags);
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+					 "2025 FIND node DID "
+					 "Data: x%p x%x x%x x%x %p\n",
+					 ndlp, ndlp->nlp_DID,
+					 ndlp->nlp_flag, data1,
+					 ndlp->active_rrqs_xri_bitmap);
+			return ndlp;
+		}
+	}
+	spin_unlock_irqrestore(shost->host_lock, iflags);
+
+	/* FIND node did <did> NOT FOUND */
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+			 "2026 FIND mapped did NOT FOUND.\n");
+	return NULL;
+}
+
+struct lpfc_nodelist *
 lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index bdc1f184f67a..a1443592fa46 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -561,6 +561,8 @@ struct fc_vft_header {
 
 /*
  *  Extended Link Service LS_COMMAND codes (Payload Word 0)
+ *  The supported payload size is also hard-coded into this word
+ *  when necessary.
  */
 #ifdef __BIG_ENDIAN_BITFIELD
 #define ELS_CMD_MASK      0xffff0000
@@ -597,6 +599,7 @@ struct fc_vft_header {
 #define ELS_CMD_RPS       0x56000000
 #define ELS_CMD_RPL       0x57000000
 #define ELS_CMD_FAN       0x60000000
+#define ELS_CMD_RSCN_XMT  0x61040008
 #define ELS_CMD_RSCN      0x61040000
 #define ELS_CMD_SCR       0x62000000
 #define ELS_CMD_RNID      0x78000000
@@ -637,6 +640,7 @@ struct fc_vft_header {
 #define ELS_CMD_RPS       0x56
 #define ELS_CMD_RPL       0x57
 #define ELS_CMD_FAN       0x60
+#define ELS_CMD_RSCN_XMT  0x08000461
 #define ELS_CMD_RSCN      0x0461
 #define ELS_CMD_SCR       0x62
 #define ELS_CMD_RNID      0x78
@@ -1088,6 +1092,11 @@ struct fc_lcb_res_frame {
 	uint16_t      lcb_duration;     /* LCB Payload Word 2, bit 15:0  */
 };
 
+struct fc_RSCN {	/* RSCN ELS frame */
+#define RSCN_EQ_PORT_ATTRIBUTE	2
+	uint32_t NPort_ID;
+};
+
 /*
  * Read Diagnostic Parameters (RDP) ELS frame.
  */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8b119f87b51d..53a4ac67c9e1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8761,6 +8761,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		if (if_type == LPFC_SLI_INTF_IF_TYPE_2) {
 			if (pcmd && (*pcmd == ELS_CMD_FLOGI ||
 				*pcmd == ELS_CMD_SCR ||
+				*pcmd == ELS_CMD_RSCN_XMT ||
 				*pcmd == ELS_CMD_FDISC ||
 				*pcmd == ELS_CMD_LOGO ||
 				*pcmd == ELS_CMD_PLOGI)) {
-- 
2.13.1
