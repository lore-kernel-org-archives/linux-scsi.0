From: James Smart <james.smart@emulex.com>
Subject: [PATCH 15/16] lpfc 8.3.35: Fixed not reporting logical link speed
 to SCSI midlayer when QoS not on
Date: Sat, 29 Sep 2012 11:32:37 -0400
Message-ID: <1348932757.23909.34.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:33800 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab2I2PiK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:38:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed not reporting logical link speed to SCSI midlayer when QoS not on


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h |    1 
 lpfc_hw4.h  |   12 +++++
 lpfc_init.c |  134 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 lpfc_scsi.c |   18 +++++---
 lpfc_sli4.h |    2 
 5 files changed, 151 insertions(+), 16 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2012-09-26 21:12:00.571154459 -0400
@@ -467,3 +467,4 @@ int lpfc_sli4_read_config(struct lpfc_hb
 void lpfc_sli4_node_prep(struct lpfc_hba *);
 int lpfc_sli4_xri_sgl_update(struct lpfc_hba *);
 void lpfc_free_sgl_list(struct lpfc_hba *, struct list_head *);
+uint32_t lpfc_sli_port_speed_get(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-09-26 21:11:46.323154134 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-09-26 21:12:00.582154459 -0400
@@ -1305,6 +1305,11 @@ struct lpfc_mbx_mq_create_ext {
 #define lpfc_mbx_mq_create_ext_async_evt_link_SHIFT	LPFC_TRAILER_CODE_LINK
 #define lpfc_mbx_mq_create_ext_async_evt_link_MASK	0x00000001
 #define lpfc_mbx_mq_create_ext_async_evt_link_WORD	async_evt_bmap
+#define LPFC_EVT_CODE_LINK_NO_LINK	0x0
+#define LPFC_EVT_CODE_LINK_10_MBIT	0x1
+#define LPFC_EVT_CODE_LINK_100_MBIT	0x2
+#define LPFC_EVT_CODE_LINK_1_GBIT	0x3
+#define LPFC_EVT_CODE_LINK_10_GBIT	0x4
 #define lpfc_mbx_mq_create_ext_async_evt_fip_SHIFT	LPFC_TRAILER_CODE_FCOE
 #define lpfc_mbx_mq_create_ext_async_evt_fip_MASK	0x00000001
 #define lpfc_mbx_mq_create_ext_async_evt_fip_WORD	async_evt_bmap
@@ -1314,6 +1319,13 @@ struct lpfc_mbx_mq_create_ext {
 #define lpfc_mbx_mq_create_ext_async_evt_fc_SHIFT	LPFC_TRAILER_CODE_FC
 #define lpfc_mbx_mq_create_ext_async_evt_fc_MASK	0x00000001
 #define lpfc_mbx_mq_create_ext_async_evt_fc_WORD	async_evt_bmap
+#define LPFC_EVT_CODE_FC_NO_LINK	0x0
+#define LPFC_EVT_CODE_FC_1_GBAUD	0x1
+#define LPFC_EVT_CODE_FC_2_GBAUD	0x2
+#define LPFC_EVT_CODE_FC_4_GBAUD	0x4
+#define LPFC_EVT_CODE_FC_8_GBAUD	0x8
+#define LPFC_EVT_CODE_FC_10_GBAUD	0xA
+#define LPFC_EVT_CODE_FC_16_GBAUD	0x10
 #define lpfc_mbx_mq_create_ext_async_evt_sli_SHIFT	LPFC_TRAILER_CODE_SLI
 #define lpfc_mbx_mq_create_ext_async_evt_sli_MASK	0x00000001
 #define lpfc_mbx_mq_create_ext_async_evt_sli_WORD	async_evt_bmap
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:47.796154168 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:12:00.597154460 -0400
@@ -3508,6 +3508,119 @@ lpfc_sli4_parse_latt_link_speed(struct l
 }
 
 /**
+ * lpfc_sli_port_speed_get - Get sli3 link speed code to link speed
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is to get an SLI3 FC port's link speed in Mbps.
+ *
+ * Return: link speed in terms of Mbps.
+ **/
+uint32_t
+lpfc_sli_port_speed_get(struct lpfc_hba *phba)
+{
+	uint32_t link_speed;
+
+	if (!lpfc_is_link_up(phba))
+		return 0;
+
+	switch (phba->fc_linkspeed) {
+	case LPFC_LINK_SPEED_1GHZ:
+		link_speed = 1000;
+		break;
+	case LPFC_LINK_SPEED_2GHZ:
+		link_speed = 2000;
+		break;
+	case LPFC_LINK_SPEED_4GHZ:
+		link_speed = 4000;
+		break;
+	case LPFC_LINK_SPEED_8GHZ:
+		link_speed = 8000;
+		break;
+	case LPFC_LINK_SPEED_10GHZ:
+		link_speed = 10000;
+		break;
+	case LPFC_LINK_SPEED_16GHZ:
+		link_speed = 16000;
+		break;
+	default:
+		link_speed = 0;
+	}
+	return link_speed;
+}
+
+/**
+ * lpfc_sli4_port_speed_parse - Parse async evt link speed code to link speed
+ * @phba: pointer to lpfc hba data structure.
+ * @evt_code: asynchronous event code.
+ * @speed_code: asynchronous event link speed code.
+ *
+ * This routine is to parse the giving SLI4 async event link speed code into
+ * value of Mbps for the link speed.
+ *
+ * Return: link speed in terms of Mbps.
+ **/
+static uint32_t
+lpfc_sli4_port_speed_parse(struct lpfc_hba *phba, uint32_t evt_code,
+			   uint8_t speed_code)
+{
+	uint32_t port_speed;
+
+	switch (evt_code) {
+	case LPFC_TRAILER_CODE_LINK:
+		switch (speed_code) {
+		case LPFC_EVT_CODE_LINK_NO_LINK:
+			port_speed = 0;
+			break;
+		case LPFC_EVT_CODE_LINK_10_MBIT:
+			port_speed = 10;
+			break;
+		case LPFC_EVT_CODE_LINK_100_MBIT:
+			port_speed = 100;
+			break;
+		case LPFC_EVT_CODE_LINK_1_GBIT:
+			port_speed = 1000;
+			break;
+		case LPFC_EVT_CODE_LINK_10_GBIT:
+			port_speed = 10000;
+			break;
+		default:
+			port_speed = 0;
+		}
+		break;
+	case LPFC_TRAILER_CODE_FC:
+		switch (speed_code) {
+		case LPFC_EVT_CODE_FC_NO_LINK:
+			port_speed = 0;
+			break;
+		case LPFC_EVT_CODE_FC_1_GBAUD:
+			port_speed = 1000;
+			break;
+		case LPFC_EVT_CODE_FC_2_GBAUD:
+			port_speed = 2000;
+			break;
+		case LPFC_EVT_CODE_FC_4_GBAUD:
+			port_speed = 4000;
+			break;
+		case LPFC_EVT_CODE_FC_8_GBAUD:
+			port_speed = 8000;
+			break;
+		case LPFC_EVT_CODE_FC_10_GBAUD:
+			port_speed = 10000;
+			break;
+		case LPFC_EVT_CODE_FC_16_GBAUD:
+			port_speed = 16000;
+			break;
+		default:
+			port_speed = 0;
+		}
+		break;
+	default:
+		port_speed = 0;
+	}
+	return port_speed;
+}
+
+/**
  * lpfc_sli4_async_link_evt - Process the asynchronous FCoE link event
  * @phba: pointer to lpfc hba data structure.
  * @acqe_link: pointer to the async link completion queue entry.
@@ -3564,7 +3677,8 @@ lpfc_sli4_async_link_evt(struct lpfc_hba
 
 	/* Keep the link status for extra SLI4 state machine reference */
 	phba->sli4_hba.link_state.speed =
-				bf_get(lpfc_acqe_link_speed, acqe_link);
+			lpfc_sli4_port_speed_parse(phba, LPFC_TRAILER_CODE_LINK,
+				bf_get(lpfc_acqe_link_speed, acqe_link));
 	phba->sli4_hba.link_state.duplex =
 				bf_get(lpfc_acqe_link_duplex, acqe_link);
 	phba->sli4_hba.link_state.status =
@@ -3576,7 +3690,8 @@ lpfc_sli4_async_link_evt(struct lpfc_hba
 	phba->sli4_hba.link_state.fault =
 				bf_get(lpfc_acqe_link_fault, acqe_link);
 	phba->sli4_hba.link_state.logical_speed =
-			bf_get(lpfc_acqe_logical_link_speed, acqe_link);
+			bf_get(lpfc_acqe_logical_link_speed, acqe_link) * 10;
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"2900 Async FC/FCoE Link event - Speed:%dGBit "
 			"duplex:x%x LA Type:x%x Port Type:%d Port Number:%d "
@@ -3586,7 +3701,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba
 			phba->sli4_hba.link_state.status,
 			phba->sli4_hba.link_state.type,
 			phba->sli4_hba.link_state.number,
-			phba->sli4_hba.link_state.logical_speed * 10,
+			phba->sli4_hba.link_state.logical_speed,
 			phba->sli4_hba.link_state.fault);
 	/*
 	 * For FC Mode: issue the READ_TOPOLOGY mailbox command to fetch
@@ -3658,7 +3773,8 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *
 	}
 	/* Keep the link status for extra SLI4 state machine reference */
 	phba->sli4_hba.link_state.speed =
-				bf_get(lpfc_acqe_fc_la_speed, acqe_fc);
+			lpfc_sli4_port_speed_parse(phba, LPFC_TRAILER_CODE_FC,
+				bf_get(lpfc_acqe_fc_la_speed, acqe_fc));
 	phba->sli4_hba.link_state.duplex = LPFC_ASYNC_LINK_DUPLEX_FULL;
 	phba->sli4_hba.link_state.topology =
 				bf_get(lpfc_acqe_fc_la_topology, acqe_fc);
@@ -3671,7 +3787,7 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *
 	phba->sli4_hba.link_state.fault =
 				bf_get(lpfc_acqe_link_fault, acqe_fc);
 	phba->sli4_hba.link_state.logical_speed =
-				bf_get(lpfc_acqe_fc_la_llink_spd, acqe_fc);
+				bf_get(lpfc_acqe_fc_la_llink_spd, acqe_fc) * 10;
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"2896 Async FC event - Speed:%dGBaud Topology:x%x "
 			"LA Type:x%x Port Type:%d Port Number:%d Logical speed:"
@@ -3681,7 +3797,7 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *
 			phba->sli4_hba.link_state.status,
 			phba->sli4_hba.link_state.type,
 			phba->sli4_hba.link_state.number,
-			phba->sli4_hba.link_state.logical_speed * 10,
+			phba->sli4_hba.link_state.logical_speed,
 			phba->sli4_hba.link_state.fault);
 	pmb = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmb) {
@@ -4171,11 +4287,11 @@ lpfc_sli4_async_grp5_evt(struct lpfc_hba
 	phba->fcoe_eventtag = acqe_grp5->event_tag;
 	prev_ll_spd = phba->sli4_hba.link_state.logical_speed;
 	phba->sli4_hba.link_state.logical_speed =
-		(bf_get(lpfc_acqe_grp5_llink_spd, acqe_grp5));
+		(bf_get(lpfc_acqe_grp5_llink_spd, acqe_grp5)) * 10;
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"2789 GRP5 Async Event: Updating logical link speed "
-			"from %dMbps to %dMbps\n", (prev_ll_spd * 10),
-			(phba->sli4_hba.link_state.logical_speed*10));
+			"from %dMbps to %dMbps\n", prev_ll_spd,
+			phba->sli4_hba.link_state.logical_speed);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-09-26 21:11:42.521154049 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-09-26 21:12:00.609154460 -0400
@@ -4163,7 +4163,7 @@ lpfc_info(struct Scsi_Host *host)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) host->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	int len;
+	int len, link_speed = 0;
 	static char  lpfcinfobuf[384];
 
 	memset(lpfcinfobuf,0,384);
@@ -4184,12 +4184,18 @@ lpfc_info(struct Scsi_Host *host)
 				 phba->Port);
 		}
 		len = strlen(lpfcinfobuf);
-		if (phba->sli4_hba.link_state.logical_speed) {
-			snprintf(lpfcinfobuf + len,
-				 384-len,
-				 " Logical Link Speed: %d Mbps",
-				 phba->sli4_hba.link_state.logical_speed * 10);
+		if (phba->sli_rev <= LPFC_SLI_REV3) {
+			link_speed = lpfc_sli_port_speed_get(phba);
+		} else {
+			if (phba->sli4_hba.link_state.logical_speed)
+				link_speed =
+				      phba->sli4_hba.link_state.logical_speed;
+			else
+				link_speed = phba->sli4_hba.link_state.speed;
 		}
+		if (link_speed != 0)
+			snprintf(lpfcinfobuf + len, 384-len,
+				 " Logical Link Speed: %d Mbps", link_speed);
 	}
 	return lpfcinfobuf;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2012-09-26 21:11:36.040153900 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2012-09-26 21:12:00.613154460 -0400
@@ -168,7 +168,7 @@ struct lpfc_queue {
 };
 
 struct lpfc_sli4_link {
-	uint8_t speed;
+	uint16_t speed;
 	uint8_t duplex;
 	uint8_t status;
 	uint8_t type;



