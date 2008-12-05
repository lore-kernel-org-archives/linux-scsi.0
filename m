From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/14] lpfc 8.3.0 :  Rework RSCN netlink event to send
	entire RSCN payload
Date: Thu, 4 Dec 2008 22:38:46 -0500
Message-ID: <1228448326.19053.35.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45882 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYLEOnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:14 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5EhDPU004191
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Rework RSCN netlink event to send entire RSCN payload

Rework RSCN netlink event to send entire RSCN payload

Also replaces (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX) with
LPFC_NL_VENDOR_ID


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_els.c     |  122 ++++++++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c |    2 -
 drivers/scsi/lpfc/lpfc_hw.h      |    3 +
 drivers/scsi/lpfc/lpfc_init.c    |    5 +-
 drivers/scsi/lpfc/lpfc_nl.h      |   14 ++++
 drivers/scsi/lpfc/lpfc_scsi.c    |    4 +
 drivers/scsi/lpfc/lpfc_sli.c     |    2 -
 7 files changed, 126 insertions(+), 26 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3887,6 +3887,49 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 }
 
 /**
+ * lpfc_send_rscn_event: Send an RSCN event to management application.
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ *
+ * lpfc_send_rscn_event sends an RSCN netlink event to management
+ * applications.
+ */
+static void
+lpfc_send_rscn_event(struct lpfc_vport *vport,
+		struct lpfc_iocbq *cmdiocb)
+{
+	struct lpfc_dmabuf *pcmd;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	uint32_t *payload_ptr;
+	uint32_t payload_len;
+	struct lpfc_rscn_event_header *rscn_event_data;
+
+	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	payload_ptr = (uint32_t *) pcmd->virt;
+	payload_len = be32_to_cpu(*payload_ptr & ~ELS_CMD_MASK);
+
+	rscn_event_data = kmalloc(sizeof(struct lpfc_rscn_event_header) +
+		payload_len, GFP_KERNEL);
+	if (!rscn_event_data) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+			"0147 Failed to allocate memory for RSCN event\n");
+		return;
+	}
+	rscn_event_data->event_type = FC_REG_RSCN_EVENT;
+	rscn_event_data->payload_length = payload_len;
+	memcpy(rscn_event_data->rscn_payload, payload_ptr,
+		payload_len);
+
+	fc_host_post_vendor_event(shost,
+		fc_get_event_number(),
+		sizeof(struct lpfc_els_event_header) + payload_len,
+		(char *)rscn_event_data,
+		LPFC_NL_VENDOR_ID);
+
+	kfree(rscn_event_data);
+}
+
+/**
  * lpfc_els_rcv_rscn: Process an unsolicited rscn iocb.
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
@@ -3933,6 +3976,10 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			 "0214 RSCN received Data: x%x x%x x%x x%x\n",
 			 vport->fc_flag, payload_len, *lp,
 			 vport->fc_rscn_id_cnt);
+
+	/* Send an RSCN event to the management application */
+	lpfc_send_rscn_event(vport, cmdiocb);
+
 	for (i = 0; i < payload_len/sizeof(uint32_t); i++)
 		fc_host_post_event(shost, fc_get_event_number(),
 			FCH_EVT_RSCN, lp[i]);
@@ -5128,7 +5175,7 @@ lpfc_send_els_failure_event(struct lpfc_hba *phba,
 			fc_get_event_number(),
 			sizeof(lsrjt_event),
 			(char *)&lsrjt_event,
-			SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+			LPFC_NL_VENDOR_ID);
 		return;
 	}
 	if ((rspiocbp->iocb.ulpStatus == IOSTAT_NPORT_BSY) ||
@@ -5146,7 +5193,7 @@ lpfc_send_els_failure_event(struct lpfc_hba *phba,
 			fc_get_event_number(),
 			sizeof(fabric_event),
 			(char *)&fabric_event,
-			SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+			LPFC_NL_VENDOR_ID);
 		return;
 	}
 
@@ -5164,32 +5211,68 @@ lpfc_send_els_failure_event(struct lpfc_hba *phba,
 static void
 lpfc_send_els_event(struct lpfc_vport *vport,
 		    struct lpfc_nodelist *ndlp,
-		    uint32_t cmd)
+		    uint32_t *payload)
 {
-	struct lpfc_els_event_header els_data;
+	struct lpfc_els_event_header *els_data = NULL;
+	struct lpfc_logo_event *logo_data = NULL;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
-	els_data.event_type = FC_REG_ELS_EVENT;
-	switch (cmd) {
+	if (*payload == ELS_CMD_LOGO) {
+		logo_data = kmalloc(sizeof(struct lpfc_logo_event), GFP_KERNEL);
+		if (!logo_data) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				"0148 Failed to allocate memory "
+				"for LOGO event\n");
+			return;
+		}
+		els_data = &logo_data->header;
+	} else {
+		els_data = kmalloc(sizeof(struct lpfc_els_event_header),
+			GFP_KERNEL);
+		if (!els_data) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				"0149 Failed to allocate memory "
+				"for ELS event\n");
+			return;
+		}
+	}
+	els_data->event_type = FC_REG_ELS_EVENT;
+	switch (*payload) {
 	case ELS_CMD_PLOGI:
-		els_data.subcategory = LPFC_EVENT_PLOGI_RCV;
+		els_data->subcategory = LPFC_EVENT_PLOGI_RCV;
 		break;
 	case ELS_CMD_PRLO:
-		els_data.subcategory = LPFC_EVENT_PRLO_RCV;
+		els_data->subcategory = LPFC_EVENT_PRLO_RCV;
 		break;
 	case ELS_CMD_ADISC:
-		els_data.subcategory = LPFC_EVENT_ADISC_RCV;
+		els_data->subcategory = LPFC_EVENT_ADISC_RCV;
+		break;
+	case ELS_CMD_LOGO:
+		els_data->subcategory = LPFC_EVENT_LOGO_RCV;
+		/* Copy the WWPN in the LOGO payload */
+		memcpy(logo_data->logo_wwpn, &payload[2],
+			sizeof(struct lpfc_name));
 		break;
 	default:
 		return;
 	}
-	memcpy(els_data.wwpn, &ndlp->nlp_portname, sizeof(struct lpfc_name));
-	memcpy(els_data.wwnn, &ndlp->nlp_nodename, sizeof(struct lpfc_name));
-	fc_host_post_vendor_event(shost,
-		fc_get_event_number(),
-		sizeof(els_data),
-		(char *)&els_data,
-		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+	memcpy(els_data->wwpn, &ndlp->nlp_portname, sizeof(struct lpfc_name));
+	memcpy(els_data->wwnn, &ndlp->nlp_nodename, sizeof(struct lpfc_name));
+	if (*payload == ELS_CMD_LOGO) {
+		fc_host_post_vendor_event(shost,
+			fc_get_event_number(),
+			sizeof(struct lpfc_logo_event),
+			(char *)logo_data,
+			LPFC_NL_VENDOR_ID);
+		kfree(logo_data);
+	} else {
+		fc_host_post_vendor_event(shost,
+			fc_get_event_number(),
+			sizeof(struct lpfc_els_event_header),
+			(char *)els_data,
+			LPFC_NL_VENDOR_ID);
+		kfree(els_data);
+	}
 
 	return;
 }
@@ -5296,7 +5379,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		phba->fc_stat.elsRcvPLOGI++;
 		ndlp = lpfc_plogi_confirm_nport(phba, payload, ndlp);
 
-		lpfc_send_els_event(vport, ndlp, cmd);
+		lpfc_send_els_event(vport, ndlp, payload);
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			if (!(phba->pport->fc_flag & FC_PT2PT) ||
 				(phba->pport->fc_flag & FC_PT2PT_PLOGI)) {
@@ -5334,6 +5417,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			did, vport->port_state, ndlp->nlp_flag);
 
 		phba->fc_stat.elsRcvLOGO++;
+		lpfc_send_els_event(vport, ndlp, payload);
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
 			break;
@@ -5346,7 +5430,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			did, vport->port_state, ndlp->nlp_flag);
 
 		phba->fc_stat.elsRcvPRLO++;
-		lpfc_send_els_event(vport, ndlp, cmd);
+		lpfc_send_els_event(vport, ndlp, payload);
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
 			break;
@@ -5364,7 +5448,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			"RCV ADISC:       did:x%x/ste:x%x flg:x%x",
 			did, vport->port_state, ndlp->nlp_flag);
 
-		lpfc_send_els_event(vport, ndlp, cmd);
+		lpfc_send_els_event(vport, ndlp, payload);
 		phba->fc_stat.elsRcvADISC++;
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -387,7 +387,7 @@ lpfc_send_fastpath_evt(struct lpfc_hba *phba,
 		fc_get_event_number(),
 		evt_data_size,
 		evt_data,
-		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+		LPFC_NL_VENDOR_ID);
 
 	lpfc_free_fast_evt(phba, fast_evt_data);
 	return;
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -65,6 +65,9 @@
 #define SLI3_IOCB_RSP_SIZE	64
 

+/* vendor ID used in SCSI netlink calls */
+#define LPFC_NL_VENDOR_ID (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX)
+
 /* Common Transport structures and definitions */
 
 union CtRevisionId {
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -833,8 +833,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 				  sizeof(board_event),
 				  (char *) &board_event,
-				  SCSI_NL_VID_TYPE_PCI
-				  | PCI_VENDOR_ID_EMULEX);
+				  LPFC_NL_VENDOR_ID);
 
 	if (phba->work_hs & HS_FFER6) {
 		/* Re-establishing Link */
@@ -2646,7 +2645,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(adapter_event),
 		(char *) &adapter_event,
-		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+		LPFC_NL_VENDOR_ID);
 
 	scsi_scan_host(shost);
 
--- a/drivers/scsi/lpfc/lpfc_nl.h
+++ b/drivers/scsi/lpfc/lpfc_nl.h
@@ -52,6 +52,13 @@
  * The payload sent via the fc transport is one-way driver->application.
  */
 
+/* RSCN event header */
+struct lpfc_rscn_event_header {
+	uint32_t event_type;
+	uint32_t payload_length; /* RSCN data length in bytes */
+	uint32_t rscn_payload[];
+};
+
 /* els event header */
 struct lpfc_els_event_header {
 	uint32_t event_type;
@@ -65,6 +72,7 @@ struct lpfc_els_event_header {
 #define LPFC_EVENT_PRLO_RCV		0x02
 #define LPFC_EVENT_ADISC_RCV		0x04
 #define LPFC_EVENT_LSRJT_RCV		0x08
+#define LPFC_EVENT_LOGO_RCV		0x10
 
 /* special els lsrjt event */
 struct lpfc_lsrjt_event {
@@ -74,6 +82,11 @@ struct lpfc_lsrjt_event {
 	uint32_t explanation;
 };
 
+/* special els logo event */
+struct lpfc_logo_event {
+	struct lpfc_els_event_header header;
+	uint8_t logo_wwpn[8];
+};
 
 /* fabric event header */
 struct lpfc_fabric_event_header {
@@ -125,6 +138,7 @@ struct lpfc_scsi_varqueuedepth_event {
 /* special case scsi check condition event */
 struct lpfc_scsi_check_condition_event {
 	struct lpfc_scsi_event_header scsi_event;
+	uint8_t opcode;
 	uint8_t sense_key;
 	uint8_t asc;
 	uint8_t ascq;
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1560,7 +1560,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 		fc_get_event_number(),
 		sizeof(scsi_event),
 		(char *)&scsi_event,
-		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+		LPFC_NL_VENDOR_ID);
 
 	if (!rdata || pnode->nlp_state != NLP_STE_MAPPED_NODE) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -1657,7 +1657,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 		fc_get_event_number(),
 		sizeof(scsi_event),
 		(char *)&scsi_event,
-		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+		LPFC_NL_VENDOR_ID);
 
 	lpfc_block_error_handler(cmnd);
 	/*
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4005,7 +4005,7 @@ lpfc_sli_async_event_handler(struct lpfc_hba * phba,
 	shost = lpfc_shost_from_vport(phba->pport);
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(temp_event_data), (char *) &temp_event_data,
-		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+		LPFC_NL_VENDOR_ID);
 
 }
 


