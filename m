From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/5] lpfc 8.3.20: Implement the FC and SLI async event
 handlers
Date: Wed, 15 Dec 2010 17:57:33 -0500
Message-ID: <1292453868.32478.26.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15429 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755649Ab0LOW6N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2010 17:58:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Implement the FC and SLI async event handlers:

- Updated MQ_CREATE_EXT mailbox structure to include fc and SLI async events.
- Added the SLI trailer code.
- Split physical field into type and number to reflect latest SLI spec.
- Changed lpfc_acqe_fcoe to lpfc_acqe_fip to reflect latest Spec changes.
- Added lpfc_acqe_fc_la structure for FC link attention async events.
- Added lpfc_acqe_sli structure for sli async events.
- Added lpfc_sli4_async_fc_evt routine to handle fc la async events.
- Added lpfc_sli4_async_sli routine to handle sli async events.
- Moved LPFC_TRAILER_CODE_FC to be handled by its own handler function.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h  |  129 ++++++++++++++++++++++++++++++--------
 lpfc_init.c |  199 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
 lpfc_sli.c  |   18 +++--
 lpfc_sli.h  |    4 -
 lpfc_sli4.h |    4 -
 5 files changed, 283 insertions(+), 71 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-12-15 13:04:04.000000000 -0500
@@ -1134,12 +1134,18 @@ struct lpfc_mbx_mq_create_ext {
 #define lpfc_mbx_mq_create_ext_async_evt_link_SHIFT	LPFC_TRAILER_CODE_LINK
 #define lpfc_mbx_mq_create_ext_async_evt_link_MASK	0x00000001
 #define lpfc_mbx_mq_create_ext_async_evt_link_WORD	async_evt_bmap
-#define lpfc_mbx_mq_create_ext_async_evt_fcfste_SHIFT	LPFC_TRAILER_CODE_FCOE
-#define lpfc_mbx_mq_create_ext_async_evt_fcfste_MASK	0x00000001
-#define lpfc_mbx_mq_create_ext_async_evt_fcfste_WORD	async_evt_bmap
+#define lpfc_mbx_mq_create_ext_async_evt_fip_SHIFT	LPFC_TRAILER_CODE_FCOE
+#define lpfc_mbx_mq_create_ext_async_evt_fip_MASK	0x00000001
+#define lpfc_mbx_mq_create_ext_async_evt_fip_WORD	async_evt_bmap
 #define lpfc_mbx_mq_create_ext_async_evt_group5_SHIFT	LPFC_TRAILER_CODE_GRP5
 #define lpfc_mbx_mq_create_ext_async_evt_group5_MASK	0x00000001
 #define lpfc_mbx_mq_create_ext_async_evt_group5_WORD	async_evt_bmap
+#define lpfc_mbx_mq_create_ext_async_evt_fc_SHIFT	LPFC_TRAILER_CODE_FC
+#define lpfc_mbx_mq_create_ext_async_evt_fc_MASK	0x00000001
+#define lpfc_mbx_mq_create_ext_async_evt_fc_WORD	async_evt_bmap
+#define lpfc_mbx_mq_create_ext_async_evt_sli_SHIFT	LPFC_TRAILER_CODE_SLI
+#define lpfc_mbx_mq_create_ext_async_evt_sli_MASK	0x00000001
+#define lpfc_mbx_mq_create_ext_async_evt_sli_WORD	async_evt_bmap
 			struct mq_context context;
 			struct dma_address page[LPFC_MAX_MQ_PAGE];
 		} request;
@@ -1393,7 +1399,7 @@ struct lpfc_mbx_query_fw_cfg {
 #define lpfc_function_mode_dal_WORD		function_mode
 #define lpfc_function_mode_lro_SHIFT		9
 #define lpfc_function_mode_lro_MASK		0x00000001
-#define lpfc_function_mode_lro_WORD		function_mode9
+#define lpfc_function_mode_lro_WORD		function_mode
 #define lpfc_function_mode_flex10_SHIFT		10
 #define lpfc_function_mode_flex10_MASK		0x00000001
 #define lpfc_function_mode_flex10_WORD		function_mode
@@ -2162,6 +2168,7 @@ struct lpfc_mcqe {
 #define LPFC_TRAILER_CODE_DCBX	0x3
 #define LPFC_TRAILER_CODE_GRP5	0x5
 #define LPFC_TRAILER_CODE_FC	0x10
+#define LPFC_TRAILER_CODE_SLI	0x11
 };
 
 struct lpfc_acqe_link {
@@ -2187,11 +2194,12 @@ struct lpfc_acqe_link {
 #define LPFC_ASYNC_LINK_STATUS_UP		0x1
 #define LPFC_ASYNC_LINK_STATUS_LOGICAL_DOWN	0x2
 #define LPFC_ASYNC_LINK_STATUS_LOGICAL_UP	0x3
-#define lpfc_acqe_link_physical_SHIFT		0
-#define lpfc_acqe_link_physical_MASK		0x000000FF
-#define lpfc_acqe_link_physical_WORD		word0
-#define LPFC_ASYNC_LINK_PORT_A			0x0
-#define LPFC_ASYNC_LINK_PORT_B			0x1
+#define lpfc_acqe_link_type_SHIFT		6
+#define lpfc_acqe_link_type_MASK		0x00000003
+#define lpfc_acqe_link_type_WORD		word0
+#define lpfc_acqe_link_number_SHIFT		0
+#define lpfc_acqe_link_number_MASK		0x0000003F
+#define lpfc_acqe_link_number_WORD		word0
 	uint32_t word1;
 #define lpfc_acqe_link_fault_SHIFT	0
 #define lpfc_acqe_link_fault_MASK	0x000000FF
@@ -2199,29 +2207,31 @@ struct lpfc_acqe_link {
 #define LPFC_ASYNC_LINK_FAULT_NONE	0x0
 #define LPFC_ASYNC_LINK_FAULT_LOCAL	0x1
 #define LPFC_ASYNC_LINK_FAULT_REMOTE	0x2
-#define lpfc_acqe_qos_link_speed_SHIFT	16
-#define lpfc_acqe_qos_link_speed_MASK	0x0000FFFF
-#define lpfc_acqe_qos_link_speed_WORD	word1
+#define lpfc_acqe_logical_link_speed_SHIFT	16
+#define lpfc_acqe_logical_link_speed_MASK	0x0000FFFF
+#define lpfc_acqe_logical_link_speed_WORD	word1
 	uint32_t event_tag;
 	uint32_t trailer;
+#define LPFC_LINK_EVENT_TYPE_PHYSICAL	0x0
+#define LPFC_LINK_EVENT_TYPE_VIRTUAL	0x1
 };
 
-struct lpfc_acqe_fcoe {
+struct lpfc_acqe_fip {
 	uint32_t index;
 	uint32_t word1;
-#define lpfc_acqe_fcoe_fcf_count_SHIFT		0
-#define lpfc_acqe_fcoe_fcf_count_MASK		0x0000FFFF
-#define lpfc_acqe_fcoe_fcf_count_WORD		word1
-#define lpfc_acqe_fcoe_event_type_SHIFT		16
-#define lpfc_acqe_fcoe_event_type_MASK		0x0000FFFF
-#define lpfc_acqe_fcoe_event_type_WORD		word1
-#define LPFC_FCOE_EVENT_TYPE_NEW_FCF		0x1
-#define LPFC_FCOE_EVENT_TYPE_FCF_TABLE_FULL	0x2
-#define LPFC_FCOE_EVENT_TYPE_FCF_DEAD		0x3
-#define LPFC_FCOE_EVENT_TYPE_CVL		0x4
-#define LPFC_FCOE_EVENT_TYPE_FCF_PARAM_MOD	0x5
+#define lpfc_acqe_fip_fcf_count_SHIFT		0
+#define lpfc_acqe_fip_fcf_count_MASK		0x0000FFFF
+#define lpfc_acqe_fip_fcf_count_WORD		word1
+#define lpfc_acqe_fip_event_type_SHIFT		16
+#define lpfc_acqe_fip_event_type_MASK		0x0000FFFF
+#define lpfc_acqe_fip_event_type_WORD		word1
 	uint32_t event_tag;
 	uint32_t trailer;
+#define LPFC_FIP_EVENT_TYPE_NEW_FCF		0x1
+#define LPFC_FIP_EVENT_TYPE_FCF_TABLE_FULL	0x2
+#define LPFC_FIP_EVENT_TYPE_FCF_DEAD		0x3
+#define LPFC_FIP_EVENT_TYPE_CVL			0x4
+#define LPFC_FIP_EVENT_TYPE_FCF_PARAM_MOD	0x5
 };
 
 struct lpfc_acqe_dcbx {
@@ -2233,9 +2243,12 @@ struct lpfc_acqe_dcbx {
 
 struct lpfc_acqe_grp5 {
 	uint32_t word0;
-#define lpfc_acqe_grp5_pport_SHIFT	0
-#define lpfc_acqe_grp5_pport_MASK	0x000000FF
-#define lpfc_acqe_grp5_pport_WORD	word0
+#define lpfc_acqe_grp5_type_SHIFT		6
+#define lpfc_acqe_grp5_type_MASK		0x00000003
+#define lpfc_acqe_grp5_type_WORD		word0
+#define lpfc_acqe_grp5_number_SHIFT		0
+#define lpfc_acqe_grp5_number_MASK		0x0000003F
+#define lpfc_acqe_grp5_number_WORD		word0
 	uint32_t word1;
 #define lpfc_acqe_grp5_llink_spd_SHIFT	16
 #define lpfc_acqe_grp5_llink_spd_MASK	0x0000FFFF
@@ -2244,6 +2257,68 @@ struct lpfc_acqe_grp5 {
 	uint32_t trailer;
 };
 
+struct lpfc_acqe_fc_la {
+	uint32_t word0;
+#define lpfc_acqe_fc_la_speed_SHIFT		24
+#define lpfc_acqe_fc_la_speed_MASK		0x000000FF
+#define lpfc_acqe_fc_la_speed_WORD		word0
+#define LPFC_FC_LA_SPEED_UNKOWN		0x0
+#define LPFC_FC_LA_SPEED_1G		0x1
+#define LPFC_FC_LA_SPEED_2G		0x2
+#define LPFC_FC_LA_SPEED_4G		0x4
+#define LPFC_FC_LA_SPEED_8G		0x8
+#define LPFC_FC_LA_SPEED_10G		0xA
+#define LPFC_FC_LA_SPEED_16G		0x10
+#define lpfc_acqe_fc_la_topology_SHIFT		16
+#define lpfc_acqe_fc_la_topology_MASK		0x000000FF
+#define lpfc_acqe_fc_la_topology_WORD		word0
+#define LPFC_FC_LA_TOP_UNKOWN		0x0
+#define LPFC_FC_LA_TOP_P2P		0x1
+#define LPFC_FC_LA_TOP_FCAL		0x2
+#define LPFC_FC_LA_TOP_INTERNAL_LOOP	0x3
+#define LPFC_FC_LA_TOP_SERDES_LOOP	0x4
+#define lpfc_acqe_fc_la_att_type_SHIFT		8
+#define lpfc_acqe_fc_la_att_type_MASK		0x000000FF
+#define lpfc_acqe_fc_la_att_type_WORD		word0
+#define LPFC_FC_LA_TYPE_LINK_UP		0x1
+#define LPFC_FC_LA_TYPE_LINK_DOWN	0x2
+#define LPFC_FC_LA_TYPE_NO_HARD_ALPA	0x3
+#define lpfc_acqe_fc_la_port_type_SHIFT		6
+#define lpfc_acqe_fc_la_port_type_MASK		0x00000003
+#define lpfc_acqe_fc_la_port_type_WORD		word0
+#define LPFC_LINK_TYPE_ETHERNET		0x0
+#define LPFC_LINK_TYPE_FC		0x1
+#define lpfc_acqe_fc_la_port_number_SHIFT	0
+#define lpfc_acqe_fc_la_port_number_MASK	0x0000003F
+#define lpfc_acqe_fc_la_port_number_WORD	word0
+	uint32_t word1;
+#define lpfc_acqe_fc_la_llink_spd_SHIFT		16
+#define lpfc_acqe_fc_la_llink_spd_MASK		0x0000FFFF
+#define lpfc_acqe_fc_la_llink_spd_WORD		word1
+#define lpfc_acqe_fc_la_fault_SHIFT		0
+#define lpfc_acqe_fc_la_fault_MASK		0x000000FF
+#define lpfc_acqe_fc_la_fault_WORD		word1
+#define LPFC_FC_LA_FAULT_NONE		0x0
+#define LPFC_FC_LA_FAULT_LOCAL		0x1
+#define LPFC_FC_LA_FAULT_REMOTE		0x2
+	uint32_t event_tag;
+	uint32_t trailer;
+#define LPFC_FC_LA_EVENT_TYPE_FC_LINK		0x1
+#define LPFC_FC_LA_EVENT_TYPE_SHARED_LINK	0x2
+};
+
+struct lpfc_acqe_sli {
+	uint32_t event_data1;
+	uint32_t event_data2;
+	uint32_t reserved;
+	uint32_t trailer;
+#define LPFC_SLI_EVENT_TYPE_PORT_ERROR		0x1
+#define LPFC_SLI_EVENT_TYPE_OVER_TEMP		0x2
+#define LPFC_SLI_EVENT_TYPE_NORM_TEMP		0x3
+#define LPFC_SLI_EVENT_TYPE_NVLOG_POST		0x4
+#define LPFC_SLI_EVENT_TYPE_DIAG_DUMP		0x5
+};
+
 /*
  * Define the bootstrap mailbox (bmbx) region used to communicate
  * mailbox command between the host and port. The mailbox consists
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-12-15 13:04:04.000000000 -0500
@@ -3149,11 +3149,11 @@ lpfc_sli4_parse_latt_link_speed(struct l
 }
 
 /**
- * lpfc_sli4_async_link_evt - Process the asynchronous FC or FCoE link event
+ * lpfc_sli4_async_link_evt - Process the asynchronous FCoE link event
  * @phba: pointer to lpfc hba data structure.
  * @acqe_link: pointer to the async link completion queue entry.
  *
- * This routine is to handle the SLI4 asynchronous link event.
+ * This routine is to handle the SLI4 asynchronous FCoE link event.
  **/
 static void
 lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
@@ -3210,12 +3210,25 @@ lpfc_sli4_async_link_evt(struct lpfc_hba
 				bf_get(lpfc_acqe_link_duplex, acqe_link);
 	phba->sli4_hba.link_state.status =
 				bf_get(lpfc_acqe_link_status, acqe_link);
-	phba->sli4_hba.link_state.physical =
-				bf_get(lpfc_acqe_link_physical, acqe_link);
+	phba->sli4_hba.link_state.type =
+				bf_get(lpfc_acqe_link_type, acqe_link);
+	phba->sli4_hba.link_state.number =
+				bf_get(lpfc_acqe_link_number, acqe_link);
 	phba->sli4_hba.link_state.fault =
 				bf_get(lpfc_acqe_link_fault, acqe_link);
 	phba->sli4_hba.link_state.logical_speed =
-				bf_get(lpfc_acqe_qos_link_speed, acqe_link);
+			bf_get(lpfc_acqe_logical_link_speed, acqe_link);
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"2900 Async FCoE Link event - Speed:%dGBit duplex:x%x "
+			"LA Type:x%x Port Type:%d Port Number:%d Logical "
+			"speed:%dMbps Fault:%d\n",
+			phba->sli4_hba.link_state.speed,
+			phba->sli4_hba.link_state.topology,
+			phba->sli4_hba.link_state.status,
+			phba->sli4_hba.link_state.type,
+			phba->sli4_hba.link_state.number,
+			phba->sli4_hba.link_state.logical_speed * 10,
+			phba->sli4_hba.link_state.fault);
 	/*
 	 * For FC Mode: issue the READ_TOPOLOGY mailbox command to fetch
 	 * topology info. Note: Optional for non FC-AL ports.
@@ -3262,6 +3275,118 @@ out_free_pmb:
 }
 
 /**
+ * lpfc_sli4_async_fc_evt - Process the asynchronous FC link event
+ * @phba: pointer to lpfc hba data structure.
+ * @acqe_fc: pointer to the async fc completion queue entry.
+ *
+ * This routine is to handle the SLI4 asynchronous FC event. It will simply log
+ * that the event was received and then issue a read_topology mailbox command so
+ * that the rest of the driver will treat it the same as SLI3.
+ **/
+static void
+lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
+{
+	struct lpfc_dmabuf *mp;
+	LPFC_MBOXQ_t *pmb;
+	int rc;
+
+	if (bf_get(lpfc_trailer_type, acqe_fc) !=
+	    LPFC_FC_LA_EVENT_TYPE_FC_LINK) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2895 Non FC link Event detected.(%d)\n",
+				bf_get(lpfc_trailer_type, acqe_fc));
+		return;
+	}
+	/* Keep the link status for extra SLI4 state machine reference */
+	phba->sli4_hba.link_state.speed =
+				bf_get(lpfc_acqe_fc_la_speed, acqe_fc);
+	phba->sli4_hba.link_state.duplex = LPFC_ASYNC_LINK_DUPLEX_FULL;
+	phba->sli4_hba.link_state.topology =
+				bf_get(lpfc_acqe_fc_la_topology, acqe_fc);
+	phba->sli4_hba.link_state.status =
+				bf_get(lpfc_acqe_fc_la_att_type, acqe_fc);
+	phba->sli4_hba.link_state.type =
+				bf_get(lpfc_acqe_fc_la_port_type, acqe_fc);
+	phba->sli4_hba.link_state.number =
+				bf_get(lpfc_acqe_fc_la_port_number, acqe_fc);
+	phba->sli4_hba.link_state.fault =
+				bf_get(lpfc_acqe_link_fault, acqe_fc);
+	phba->sli4_hba.link_state.logical_speed =
+				bf_get(lpfc_acqe_fc_la_llink_spd, acqe_fc);
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"2896 Async FC event - Speed:%dGBaud Topology:x%x "
+			"LA Type:x%x Port Type:%d Port Number:%d Logical speed:"
+			"%dMbps Fault:%d\n",
+			phba->sli4_hba.link_state.speed,
+			phba->sli4_hba.link_state.topology,
+			phba->sli4_hba.link_state.status,
+			phba->sli4_hba.link_state.type,
+			phba->sli4_hba.link_state.number,
+			phba->sli4_hba.link_state.logical_speed * 10,
+			phba->sli4_hba.link_state.fault);
+	pmb = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2897 The mboxq allocation failed\n");
+		return;
+	}
+	mp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!mp) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2898 The lpfc_dmabuf allocation failed\n");
+		goto out_free_pmb;
+	}
+	mp->virt = lpfc_mbuf_alloc(phba, 0, &mp->phys);
+	if (!mp->virt) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2899 The mbuf allocation failed\n");
+		goto out_free_dmabuf;
+	}
+
+	/* Cleanup any outstanding ELS commands */
+	lpfc_els_flush_all_cmd(phba);
+
+	/* Block ELS IOCBs until we have done process link event */
+	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
+
+	/* Update link event statistics */
+	phba->sli.slistat.link_event++;
+
+	/* Create lpfc_handle_latt mailbox command from link ACQE */
+	lpfc_read_topology(phba, pmb, mp);
+	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_topology;
+	pmb->vport = phba->pport;
+
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED)
+		goto out_free_dmabuf;
+	return;
+
+out_free_dmabuf:
+	kfree(mp);
+out_free_pmb:
+	mempool_free(pmb, phba->mbox_mem_pool);
+}
+
+/**
+ * lpfc_sli4_async_sli_evt - Process the asynchronous SLI link event
+ * @phba: pointer to lpfc hba data structure.
+ * @acqe_fc: pointer to the async SLI completion queue entry.
+ *
+ * This routine is to handle the SLI4 asynchronous SLI events.
+ **/
+static void
+lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
+{
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"2901 Async SLI event - Event Data1:x%08x Event Data2:"
+			"x%08x SLI Event Type:%d",
+			acqe_sli->event_data1, acqe_sli->event_data2,
+			bf_get(lpfc_trailer_type, acqe_sli));
+	return;
+}
+
+/**
  * lpfc_sli4_perform_vport_cvl - Perform clear virtual link on a vport
  * @vport: pointer to vport data structure.
  *
@@ -3348,9 +3473,9 @@ lpfc_sli4_perform_all_vport_cvl(struct l
  **/
 static void
 lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
-			struct lpfc_acqe_fcoe *acqe_fcoe)
+			struct lpfc_acqe_fip *acqe_fip)
 {
-	uint8_t event_type = bf_get(lpfc_acqe_fcoe_event_type, acqe_fcoe);
+	uint8_t event_type = bf_get(lpfc_trailer_type, acqe_fip);
 	int rc;
 	struct lpfc_vport *vport;
 	struct lpfc_nodelist *ndlp;
@@ -3359,25 +3484,25 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 	struct lpfc_vport **vports;
 	int i;
 
-	phba->fc_eventTag = acqe_fcoe->event_tag;
-	phba->fcoe_eventtag = acqe_fcoe->event_tag;
+	phba->fc_eventTag = acqe_fip->event_tag;
+	phba->fcoe_eventtag = acqe_fip->event_tag;
 	switch (event_type) {
-	case LPFC_FCOE_EVENT_TYPE_NEW_FCF:
-	case LPFC_FCOE_EVENT_TYPE_FCF_PARAM_MOD:
-		if (event_type == LPFC_FCOE_EVENT_TYPE_NEW_FCF)
+	case LPFC_FIP_EVENT_TYPE_NEW_FCF:
+	case LPFC_FIP_EVENT_TYPE_FCF_PARAM_MOD:
+		if (event_type == LPFC_FIP_EVENT_TYPE_NEW_FCF)
 			lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
 					LOG_DISCOVERY,
 					"2546 New FCF event, evt_tag:x%x, "
 					"index:x%x\n",
-					acqe_fcoe->event_tag,
-					acqe_fcoe->index);
+					acqe_fip->event_tag,
+					acqe_fip->index);
 		else
 			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP |
 					LOG_DISCOVERY,
 					"2788 FCF param modified event, "
 					"evt_tag:x%x, index:x%x\n",
-					acqe_fcoe->event_tag,
-					acqe_fcoe->index);
+					acqe_fip->event_tag,
+					acqe_fip->index);
 		if (phba->fcf.fcf_flag & FCF_DISCOVERY) {
 			/*
 			 * During period of FCF discovery, read the FCF
@@ -3388,8 +3513,8 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 					LOG_DISCOVERY,
 					"2779 Read FCF (x%x) for updating "
 					"roundrobin FCF failover bmask\n",
-					acqe_fcoe->index);
-			rc = lpfc_sli4_read_fcf_rec(phba, acqe_fcoe->index);
+					acqe_fip->index);
+			rc = lpfc_sli4_read_fcf_rec(phba, acqe_fip->index);
 		}
 
 		/* If the FCF discovery is in progress, do nothing. */
@@ -3415,7 +3540,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
 				"2770 Start FCF table scan per async FCF "
 				"event, evt_tag:x%x, index:x%x\n",
-				acqe_fcoe->event_tag, acqe_fcoe->index);
+				acqe_fip->event_tag, acqe_fip->index);
 		rc = lpfc_sli4_fcf_scan_read_fcf_rec(phba,
 						     LPFC_FCOE_FCF_GET_FIRST);
 		if (rc)
@@ -3424,17 +3549,17 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 					"command failed (x%x)\n", rc);
 		break;
 
-	case LPFC_FCOE_EVENT_TYPE_FCF_TABLE_FULL:
+	case LPFC_FIP_EVENT_TYPE_FCF_TABLE_FULL:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"2548 FCF Table full count 0x%x tag 0x%x\n",
-			bf_get(lpfc_acqe_fcoe_fcf_count, acqe_fcoe),
-			acqe_fcoe->event_tag);
+			bf_get(lpfc_acqe_fip_fcf_count, acqe_fip),
+			acqe_fip->event_tag);
 		break;
 
-	case LPFC_FCOE_EVENT_TYPE_FCF_DEAD:
+	case LPFC_FIP_EVENT_TYPE_FCF_DEAD:
 		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
 			"2549 FCF (x%x) disconnected from network, "
-			"tag:x%x\n", acqe_fcoe->index, acqe_fcoe->event_tag);
+			"tag:x%x\n", acqe_fip->index, acqe_fip->event_tag);
 		/*
 		 * If we are in the middle of FCF failover process, clear
 		 * the corresponding FCF bit in the roundrobin bitmap.
@@ -3443,13 +3568,13 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 		if (phba->fcf.fcf_flag & FCF_DISCOVERY) {
 			spin_unlock_irq(&phba->hbalock);
 			/* Update FLOGI FCF failover eligible FCF bmask */
-			lpfc_sli4_fcf_rr_index_clear(phba, acqe_fcoe->index);
+			lpfc_sli4_fcf_rr_index_clear(phba, acqe_fip->index);
 			break;
 		}
 		spin_unlock_irq(&phba->hbalock);
 
 		/* If the event is not for currently used fcf do nothing */
-		if (phba->fcf.current_rec.fcf_indx != acqe_fcoe->index)
+		if (phba->fcf.current_rec.fcf_indx != acqe_fip->index)
 			break;
 
 		/*
@@ -3466,7 +3591,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 		lpfc_printf_log(phba, KERN_INFO, LOG_FIP | LOG_DISCOVERY,
 				"2771 Start FCF fast failover process due to "
 				"FCF DEAD event: evt_tag:x%x, fcf_index:x%x "
-				"\n", acqe_fcoe->event_tag, acqe_fcoe->index);
+				"\n", acqe_fip->event_tag, acqe_fip->index);
 		rc = lpfc_sli4_redisc_fcf_table(phba);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
@@ -3493,12 +3618,12 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 			lpfc_sli4_perform_all_vport_cvl(phba);
 		}
 		break;
-	case LPFC_FCOE_EVENT_TYPE_CVL:
+	case LPFC_FIP_EVENT_TYPE_CVL:
 		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
 			"2718 Clear Virtual Link Received for VPI 0x%x"
-			" tag 0x%x\n", acqe_fcoe->index, acqe_fcoe->event_tag);
+			" tag 0x%x\n", acqe_fip->index, acqe_fip->event_tag);
 		vport = lpfc_find_vport_by_vpid(phba,
-				acqe_fcoe->index - phba->vpi_base);
+				acqe_fip->index - phba->vpi_base);
 		ndlp = lpfc_sli4_perform_vport_cvl(vport);
 		if (!ndlp)
 			break;
@@ -3549,7 +3674,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 			lpfc_printf_log(phba, KERN_INFO, LOG_FIP |
 					LOG_DISCOVERY,
 					"2773 Start FCF failover per CVL, "
-					"evt_tag:x%x\n", acqe_fcoe->event_tag);
+					"evt_tag:x%x\n", acqe_fip->event_tag);
 			rc = lpfc_sli4_redisc_fcf_table(phba);
 			if (rc) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
@@ -3577,7 +3702,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba 
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0288 Unknown FCoE event type 0x%x event tag "
-			"0x%x\n", event_type, acqe_fcoe->event_tag);
+			"0x%x\n", event_type, acqe_fip->event_tag);
 		break;
 	}
 }
@@ -3650,13 +3775,11 @@ void lpfc_sli4_async_event_proc(struct l
 		/* Process the asynchronous event */
 		switch (bf_get(lpfc_trailer_code, &cq_event->cqe.mcqe_cmpl)) {
 		case LPFC_TRAILER_CODE_LINK:
-		case LPFC_TRAILER_CODE_FC:
 			lpfc_sli4_async_link_evt(phba,
 						 &cq_event->cqe.acqe_link);
 			break;
 		case LPFC_TRAILER_CODE_FCOE:
-			lpfc_sli4_async_fip_evt(phba,
-						&cq_event->cqe.acqe_fcoe);
+			lpfc_sli4_async_fip_evt(phba, &cq_event->cqe.acqe_fip);
 			break;
 		case LPFC_TRAILER_CODE_DCBX:
 			lpfc_sli4_async_dcbx_evt(phba,
@@ -3666,6 +3789,12 @@ void lpfc_sli4_async_event_proc(struct l
 			lpfc_sli4_async_grp5_evt(phba,
 						 &cq_event->cqe.acqe_grp5);
 			break;
+		case LPFC_TRAILER_CODE_FC:
+			lpfc_sli4_async_fc_evt(phba, &cq_event->cqe.acqe_fc);
+			break;
+		case LPFC_TRAILER_CODE_SLI:
+			lpfc_sli4_async_sli_evt(phba, &cq_event->cqe.acqe_sli);
+			break;
 		default:
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"1804 Invalid asynchrous event code: "
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-12-15 13:04:04.000000000 -0500
@@ -137,9 +137,11 @@ struct lpfc_sli4_link {
 	uint8_t speed;
 	uint8_t duplex;
 	uint8_t status;
-	uint8_t physical;
+	uint8_t type;
+	uint8_t number;
 	uint8_t fault;
 	uint16_t logical_speed;
+	uint16_t topology;
 };
 
 struct lpfc_fcf_rec {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-12-15 13:03:21.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-12-15 13:04:04.000000000 -0500
@@ -10561,16 +10561,20 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 			 length, LPFC_SLI4_MBX_EMBED);
 
 	mq_create_ext = &mbox->u.mqe.un.mq_create_ext;
-	bf_set(lpfc_mbx_mq_create_ext_num_pages, &mq_create_ext->u.request,
-		    mq->page_count);
-	bf_set(lpfc_mbx_mq_create_ext_async_evt_link, &mq_create_ext->u.request,
-	       1);
-	bf_set(lpfc_mbx_mq_create_ext_async_evt_fcfste,
+	bf_set(lpfc_mbx_mq_create_ext_num_pages,
+	       &mq_create_ext->u.request, mq->page_count);
+	bf_set(lpfc_mbx_mq_create_ext_async_evt_link,
+	       &mq_create_ext->u.request, 1);
+	bf_set(lpfc_mbx_mq_create_ext_async_evt_fip,
 	       &mq_create_ext->u.request, 1);
 	bf_set(lpfc_mbx_mq_create_ext_async_evt_group5,
 	       &mq_create_ext->u.request, 1);
-	bf_set(lpfc_mq_context_cq_id, &mq_create_ext->u.request.context,
-	       cq->queue_id);
+	bf_set(lpfc_mbx_mq_create_ext_async_evt_fc,
+	       &mq_create_ext->u.request, 1);
+	bf_set(lpfc_mbx_mq_create_ext_async_evt_sli,
+	       &mq_create_ext->u.request, 1);
+	bf_set(lpfc_mq_context_cq_id,
+	       &mq_create_ext->u.request.context, cq->queue_id);
 	bf_set(lpfc_mq_context_valid, &mq_create_ext->u.request.context, 1);
 	switch (mq->entry_count) {
 	default:
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2010-12-15 13:04:04.000000000 -0500
@@ -34,9 +34,11 @@ struct lpfc_cq_event {
 	union {
 		struct lpfc_mcqe		mcqe_cmpl;
 		struct lpfc_acqe_link		acqe_link;
-		struct lpfc_acqe_fcoe		acqe_fcoe;
+		struct lpfc_acqe_fip		acqe_fip;
 		struct lpfc_acqe_dcbx		acqe_dcbx;
 		struct lpfc_acqe_grp5		acqe_grp5;
+		struct lpfc_acqe_fc_la		acqe_fc;
+		struct lpfc_acqe_sli		acqe_sli;
 		struct lpfc_rcqe		rcqe_cmpl;
 		struct sli4_wcqe_xri_aborted	wcqe_axri;
 		struct lpfc_wcqe_complete	wcqe_cmpl;


