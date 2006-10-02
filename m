From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/8] qla2xxx: Add iIDMA support.
Date: Mon,  2 Oct 2006 12:00:43 -0700
Message-ID: <115981565078-git-send-email-andrew.vasquez@qlogic.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53852 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964958AbWJBTAy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:00:54 -0400
In-Reply-To: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

iIDMA (Intelligent Interleaved Direct Memory Access) allows for
the HBA hardware to send FC frames at the rate at which they can
be received by a target device.  By taking advantage of the
higher link rate, the HBA can maximize bandwidth utilization in a
heterogeneous multi-speed SAN.

Within a fabric topology, port speed detection is done via a Name
Server command (GFPN_ID) followed by a Fabric Management command
(GPSC).  In an FCAL/N2N topology, port speed is based on the HBA
link-rate.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +-
 drivers/scsi/qla2xxx/qla_def.h  |   39 +++++++-
 drivers/scsi/qla2xxx/qla_gbl.h  |    8 ++
 drivers/scsi/qla2xxx/qla_gs.c   |  187 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_init.c |   81 +++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c  |    4 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |   86 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 8 files changed, 401 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 87f90c4..144b0f8 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -691,13 +691,13 @@ qla2x00_get_host_speed(struct Scsi_Host 
 	uint32_t speed = 0;
 
 	switch (ha->link_data_rate) {
-	case LDR_1GB:
+	case PORT_SPEED_1GB:
 		speed = 1;
 		break;
-	case LDR_2GB:
+	case PORT_SPEED_2GB:
 		speed = 2;
 		break;
-	case LDR_4GB:
+	case PORT_SPEED_4GB:
 		speed = 4;
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0930260..6d677b0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -608,6 +608,7 @@ #define MBC_LUN_RESET			0x7E	/* Send LUN
  */
 #define MBC_SERDES_PARAMS		0x10	/* Serdes Tx Parameters. */
 #define MBC_GET_IOCB_STATUS		0x12	/* Get IOCB status command. */
+#define MBC_PORT_PARAMS			0x1A	/* Port iDMA Parameters. */
 #define MBC_GET_TIMEOUT_PARAMS		0x22	/* Get FW timeouts. */
 #define MBC_TRACE_CONTROL		0x27	/* Trace control command. */
 #define MBC_GEN_SYSTEM_ERROR		0x2a	/* Generate System Error. */
@@ -1497,6 +1498,9 @@ typedef struct {
 	port_id_t d_id;
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
+	uint8_t fabric_port_name[WWN_SIZE];
+	uint16_t fp_speeds;
+	uint16_t fp_speed;
 } sw_info_t;
 
 /*
@@ -1524,6 +1528,9 @@ typedef struct fc_port {
 	uint16_t loop_id;
 	uint16_t old_loop_id;
 
+	uint8_t fabric_port_name[WWN_SIZE];
+	uint16_t fp_speed;
+
 	fc_port_type_t port_type;
 
 	atomic_t state;
@@ -1635,6 +1642,15 @@ #define	RSNN_NN_CMD	 0x239
 #define	RSNN_NN_REQ_SIZE (16 + 8 + 1 + 255)
 #define	RSNN_NN_RSP_SIZE 16
 
+#define	GFPN_ID_CMD	0x11C
+#define	GFPN_ID_REQ_SIZE (16 + 4)
+#define	GFPN_ID_RSP_SIZE (16 + 8)
+
+#define	GPSC_CMD	0x127
+#define	GPSC_REQ_SIZE	(16 + 8)
+#define	GPSC_RSP_SIZE	(16 + 2 + 2)
+
+
 /*
  * HBA attribute types.
  */
@@ -1748,7 +1764,7 @@ struct ct_sns_req {
 	uint8_t reserved[3];
 
 	union {
-		/* GA_NXT, GPN_ID, GNN_ID, GFT_ID */
+		/* GA_NXT, GPN_ID, GNN_ID, GFT_ID, GFPN_ID */
 		struct {
 			uint8_t reserved;
 			uint8_t port_id[3];
@@ -1823,6 +1839,10 @@ struct ct_sns_req {
 		struct {
 			uint8_t port_name[8];
 		} dpa;
+
+		struct {
+			uint8_t port_name[8];
+		} gpsc;
 	} req;
 };
 
@@ -1886,6 +1906,15 @@ struct ct_sns_rsp {
 			uint8_t port_name[8];
 			struct ct_fdmi_hba_attributes attrs;
 		} ghat;
+
+		struct {
+			uint8_t port_name[8];
+		} gfpn_id;
+
+		struct {
+			uint16_t speeds;
+			uint16_t speed;
+		} gpsc;
 	} rsp;
 };
 
@@ -2182,11 +2211,11 @@ #define MIN_IOBASE_LEN		0x100
 	uint16_t	max_public_loop_ids;
 	uint16_t	min_external_loopid;	/* First external loop Id */
 
+#define PORT_SPEED_UNKNOWN 0xFFFF
+#define PORT_SPEED_1GB	0x00
+#define PORT_SPEED_2GB	0x01
+#define PORT_SPEED_4GB	0x03
 	uint16_t	link_data_rate;		/* F/W operating speed */
-#define LDR_1GB		0
-#define LDR_2GB		1
-#define LDR_4GB		3
-#define LDR_UNKNOWN	0xFFFF
 
 	uint8_t		current_topology;
 	uint8_t		prev_topology;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 8311ac2..c48e1d8 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -208,6 +208,12 @@ qla2x00_trace_control(scsi_qla_host_t *,
 extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
 
+extern int
+qla2x00_get_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t *, uint16_t *);
+
+extern int
+qla2x00_set_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t *);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
@@ -279,6 +285,8 @@ extern int qla2x00_rsnn_nn(scsi_qla_host
 extern void *qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
 extern void *qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
 extern int qla2x00_fdmi_register(scsi_qla_host_t *);
+extern int qla2x00_gfpn_id(scsi_qla_host_t *, sw_info_t *);
+extern int qla2x00_gpsc(scsi_qla_host_t *, sw_info_t *);
 
 /*
  * Global Function Prototypes in qla_attr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 2ebf259..029953c 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -687,7 +687,6 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 	return (rval);
 }
 
-
 /**
  * qla2x00_prep_sns_cmd() - Prepare common SNS command request fields for query.
  * @ha: HA context
@@ -1647,3 +1646,189 @@ qla2x00_fdmi_register(scsi_qla_host_t *h
 
 	return rval;
 }
+
+/**
+ * qla2x00_gfpn_id() - SNS Get Fabric Port Name (GFPN_ID) query.
+ * @ha: HA context
+ * @list: switch info entries to populate
+ *
+ * Returns 0 on success.
+ */
+int
+qla2x00_gfpn_id(scsi_qla_host_t *ha, sw_info_t *list)
+{
+	int		rval;
+	uint16_t	i;
+
+	ms_iocb_entry_t	*ms_pkt;
+	struct ct_sns_req	*ct_req;
+	struct ct_sns_rsp	*ct_rsp;
+
+	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
+		/* Issue GFPN_ID */
+		memset(list[i].fabric_port_name, 0, WWN_SIZE);
+
+		/* Prepare common MS IOCB */
+		ms_pkt = qla2x00_prep_ms_iocb(ha, GFPN_ID_REQ_SIZE,
+		    GFPN_ID_RSP_SIZE);
+
+		/* Prepare CT request */
+		ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GFPN_ID_CMD,
+		    GFPN_ID_RSP_SIZE);
+		ct_rsp = &ha->ct_sns->p.rsp;
+
+		/* Prepare CT arguments -- port_id */
+		ct_req->req.port_id.port_id[0] = list[i].d_id.b.domain;
+		ct_req->req.port_id.port_id[1] = list[i].d_id.b.area;
+		ct_req->req.port_id.port_id[2] = list[i].d_id.b.al_pa;
+
+		/* Execute MS IOCB */
+		rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+		    sizeof(ms_iocb_entry_t));
+		if (rval != QLA_SUCCESS) {
+			/*EMPTY*/
+			DEBUG2_3(printk("scsi(%ld): GFPN_ID issue IOCB "
+			    "failed (%d).\n", ha->host_no, rval));
+		} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
+		    "GFPN_ID") != QLA_SUCCESS) {
+			rval = QLA_FUNCTION_FAILED;
+		} else {
+			/* Save fabric portname */
+			memcpy(list[i].fabric_port_name,
+			    ct_rsp->rsp.gfpn_id.port_name, WWN_SIZE);
+		}
+
+		/* Last device exit. */
+		if (list[i].d_id.b.rsvd_1 != 0)
+			break;
+	}
+
+	return (rval);
+}
+
+static inline void *
+qla24xx_prep_ms_fm_iocb(scsi_qla_host_t *ha, uint32_t req_size,
+    uint32_t rsp_size)
+{
+	struct ct_entry_24xx *ct_pkt;
+
+	ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
+	memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
+
+	ct_pkt->entry_type = CT_IOCB_TYPE;
+	ct_pkt->entry_count = 1;
+	ct_pkt->nport_handle = cpu_to_le16(ha->mgmt_svr_loop_id);
+	ct_pkt->timeout = __constant_cpu_to_le16(59);
+	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
+	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
+	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
+	ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
+
+	ct_pkt->dseg_0_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
+	ct_pkt->dseg_0_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ct_pkt->dseg_0_len = ct_pkt->cmd_byte_count;
+
+	ct_pkt->dseg_1_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
+	ct_pkt->dseg_1_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ct_pkt->dseg_1_len = ct_pkt->rsp_byte_count;
+
+	return ct_pkt;
+}
+
+
+static inline struct ct_sns_req *
+qla24xx_prep_ct_fm_req(struct ct_sns_req *ct_req, uint16_t cmd,
+    uint16_t rsp_size)
+{
+	memset(ct_req, 0, sizeof(struct ct_sns_pkt));
+
+	ct_req->header.revision = 0x01;
+	ct_req->header.gs_type = 0xFA;
+	ct_req->header.gs_subtype = 0x01;
+	ct_req->command = cpu_to_be16(cmd);
+	ct_req->max_rsp_size = cpu_to_be16((rsp_size - 16) / 4);
+
+	return ct_req;
+}
+
+/**
+ * qla2x00_gpsc() - FCS Get Port Speed Capabilities (GPSC) query.
+ * @ha: HA context
+ * @list: switch info entries to populate
+ *
+ * Returns 0 on success.
+ */
+int
+qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
+{
+	int		rval;
+	uint16_t	i;
+
+	ms_iocb_entry_t	*ms_pkt;
+	struct ct_sns_req	*ct_req;
+	struct ct_sns_rsp	*ct_rsp;
+
+	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	rval = qla2x00_mgmt_svr_login(ha);
+	if (rval)
+		return rval;
+
+	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
+		/* Issue GFPN_ID */
+		list[i].fp_speeds = list[i].fp_speed = 0;
+
+		/* Prepare common MS IOCB */
+		ms_pkt = qla24xx_prep_ms_fm_iocb(ha, GPSC_REQ_SIZE,
+		    GPSC_RSP_SIZE);
+
+		/* Prepare CT request */
+		ct_req = qla24xx_prep_ct_fm_req(&ha->ct_sns->p.req,
+		    GPSC_CMD, GPSC_RSP_SIZE);
+		ct_rsp = &ha->ct_sns->p.rsp;
+
+		/* Prepare CT arguments -- port_name */
+		memcpy(ct_req->req.gpsc.port_name, list[i].fabric_port_name,
+		    WWN_SIZE);
+
+		/* Execute MS IOCB */
+		rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+		    sizeof(ms_iocb_entry_t));
+		if (rval != QLA_SUCCESS) {
+			/*EMPTY*/
+			DEBUG2_3(printk("scsi(%ld): GPSC issue IOCB "
+			    "failed (%d).\n", ha->host_no, rval));
+		} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
+		    "GPSC") != QLA_SUCCESS) {
+			rval = QLA_FUNCTION_FAILED;
+		} else {
+			/* Save portname */
+			list[i].fp_speeds = ct_rsp->rsp.gpsc.speeds;
+			list[i].fp_speed = ct_rsp->rsp.gpsc.speed;
+
+			DEBUG2_3(printk("scsi(%ld): GPSC ext entry - "
+			    "fpn %02x%02x%02x%02x%02x%02x%02x%02x speeds=%04x "
+			    "speed=%04x.\n", ha->host_no,
+			    list[i].fabric_port_name[0],
+			    list[i].fabric_port_name[1],
+			    list[i].fabric_port_name[2],
+			    list[i].fabric_port_name[3],
+			    list[i].fabric_port_name[4],
+			    list[i].fabric_port_name[5],
+			    list[i].fabric_port_name[6],
+			    list[i].fabric_port_name[7],
+			    be16_to_cpu(list[i].fp_speeds),
+			    be16_to_cpu(list[i].fp_speed)));
+		}
+
+		/* Last device exit. */
+		if (list[i].d_id.b.rsvd_1 != 0)
+			break;
+	}
+
+	return (rval);
+}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8596491..2700964 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2074,6 +2074,19 @@ qla2x00_configure_local_loop(scsi_qla_ho
 			new_fcport->flags &= ~FCF_FABRIC_DEVICE;
 		}
 
+		/* Base iIDMA settings on HBA port speed. */
+		switch (ha->link_data_rate) {
+		case PORT_SPEED_1GB:
+			fcport->fp_speed = cpu_to_be16(BIT_15);
+			break;
+		case PORT_SPEED_2GB:
+			fcport->fp_speed = cpu_to_be16(BIT_14);
+			break;
+		case PORT_SPEED_4GB:
+			fcport->fp_speed = cpu_to_be16(BIT_13);
+			break;
+		}
+
 		qla2x00_update_fcport(ha, fcport);
 
 		found_devs++;
@@ -2109,6 +2122,62 @@ qla2x00_probe_for_all_luns(scsi_qla_host
 	}
 }
 
+static void
+qla2x00_iidma_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
+{
+#define LS_UNKNOWN      2
+	static char *link_speeds[5] = { "1", "2", "?", "4" };
+	int rval;
+	uint16_t port_speed, mb[6];
+
+	if (!IS_QLA24XX(ha))
+		return;
+
+	switch (be16_to_cpu(fcport->fp_speed)) {
+	case BIT_15:
+		port_speed = PORT_SPEED_1GB;
+		break;
+	case BIT_14:
+		port_speed = PORT_SPEED_2GB;
+		break;
+	case BIT_13:
+		port_speed = PORT_SPEED_4GB;
+		break;
+	default:
+		DEBUG2(printk("scsi(%ld): %02x%02x%02x%02x%02x%02x%02x%02x -- "
+		    "unsupported FM port operating speed (%04x).\n",
+		    ha->host_no, fcport->port_name[0], fcport->port_name[1],
+		    fcport->port_name[2], fcport->port_name[3],
+		    fcport->port_name[4], fcport->port_name[5],
+		    fcport->port_name[6], fcport->port_name[7],
+		    be16_to_cpu(fcport->fp_speed)));
+		port_speed = PORT_SPEED_UNKNOWN;
+		break;
+	}
+	if (port_speed == PORT_SPEED_UNKNOWN)
+		return;
+
+	rval = qla2x00_set_idma_speed(ha, fcport->loop_id, port_speed, mb);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(printk("scsi(%ld): Unable to adjust iIDMA "
+		    "%02x%02x%02x%02x%02x%02x%02x%02x -- %04x %x %04x %04x.\n",
+		    ha->host_no, fcport->port_name[0], fcport->port_name[1],
+		    fcport->port_name[2], fcport->port_name[3],
+		    fcport->port_name[4], fcport->port_name[5],
+		    fcport->port_name[6], fcport->port_name[7], rval,
+		    port_speed, mb[0], mb[1]));
+	} else {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "iIDMA adjusted to %s GB/s on "
+		    "%02x%02x%02x%02x%02x%02x%02x%02x.\n",
+		    link_speeds[port_speed], fcport->port_name[0],
+		    fcport->port_name[1], fcport->port_name[2],
+		    fcport->port_name[3], fcport->port_name[4],
+		    fcport->port_name[5], fcport->port_name[6],
+		    fcport->port_name[7]));
+	}
+}
+
 /*
  * qla2x00_update_fcport
  *	Updates device on list.
@@ -2135,6 +2204,8 @@ qla2x00_update_fcport(scsi_qla_host_t *h
 	    PORT_RETRY_TIME);
 	fcport->flags &= ~FCF_LOGIN_NEEDED;
 
+	qla2x00_iidma_fcport(ha, fcport);
+
 	atomic_set(&fcport->state, FCS_ONLINE);
 
 	if (ha->flags.init_done)
@@ -2416,6 +2487,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 		} else if (qla2x00_gnn_id(ha, swl) != QLA_SUCCESS) {
 			kfree(swl);
 			swl = NULL;
+		} else if (qla2x00_gfpn_id(ha, swl) == QLA_SUCCESS) {
+			qla2x00_gpsc(ha, swl);
 		}
 	}
 	swl_idx = 0;
@@ -2450,6 +2523,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 				    swl[swl_idx].node_name, WWN_SIZE);
 				memcpy(new_fcport->port_name,
 				    swl[swl_idx].port_name, WWN_SIZE);
+				memcpy(new_fcport->fabric_port_name,
+				    swl[swl_idx].fabric_port_name, WWN_SIZE);
+				new_fcport->fp_speed = swl[swl_idx].fp_speed;
 
 				if (swl[swl_idx].d_id.b.rsvd_1 != 0) {
 					last_dev = 1;
@@ -2507,6 +2583,11 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 
 			found++;
 
+			/* Update port state. */
+			memcpy(fcport->fabric_port_name,
+			    new_fcport->fabric_port_name, WWN_SIZE);
+			fcport->fp_speed = new_fcport->fp_speed;
+
 			/*
 			 * If address the same and state FCS_ONLINE, nothing
 			 * changed.
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index de06131..5fa933c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -400,7 +400,7 @@ #define LS_UNKNOWN	2
 	case MBA_LOOP_UP:		/* Loop Up Event */
 		if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 			link_speed = link_speeds[0];
-			ha->link_data_rate = LDR_1GB;
+			ha->link_data_rate = PORT_SPEED_1GB;
 		} else {
 			link_speed = link_speeds[LS_UNKNOWN];
 			if (mb[1] < 5)
@@ -429,7 +429,7 @@ #define LS_UNKNOWN	2
 		}
 
 		ha->flags.management_server_logged_in = 0;
-		ha->link_data_rate = LDR_UNKNOWN;
+		ha->link_data_rate = PORT_SPEED_UNKNOWN;
 		if (ql2xfdmienable)
 			set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 879f281..4cde76c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2540,3 +2540,89 @@ qla2x00_read_sfp(scsi_qla_host_t *ha, dm
 
 	return rval;
 }
+
+int
+qla2x00_get_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
+    uint16_t *port_speed, uint16_t *mb)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA24XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_PORT_PARAMS;
+	mcp->mb[1] = loop_id;
+	mcp->mb[2] = mcp->mb[3] = mcp->mb[4] = mcp->mb[5] = 0;
+	mcp->out_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	/* Return mailbox statuses. */
+	if (mb != NULL) {
+		mb[0] = mcp->mb[0];
+		mb[1] = mcp->mb[1];
+		mb[3] = mcp->mb[3];
+		mb[4] = mcp->mb[4];
+		mb[5] = mcp->mb[5];
+	}
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
+		    ha->host_no, rval));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		if (port_speed)
+			*port_speed = mcp->mb[3];
+	}
+
+	return rval;
+}
+
+int
+qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
+    uint16_t port_speed, uint16_t *mb)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA24XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_PORT_PARAMS;
+	mcp->mb[1] = loop_id;
+	mcp->mb[2] = BIT_0;
+	mcp->mb[3] = port_speed & (BIT_2|BIT_1|BIT_0);
+	mcp->mb[4] = mcp->mb[5] = 0;
+	mcp->out_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(ha, mcp);
+
+	/* Return mailbox statuses. */
+	if (mb != NULL) {
+		mb[0] = mcp->mb[0];
+		mb[1] = mcp->mb[1];
+		mb[3] = mcp->mb[3];
+		mb[4] = mcp->mb[4];
+		mb[5] = mcp->mb[5];
+	}
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
+		    ha->host_no, rval));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 65cbe2f..9e665e1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1385,7 +1385,7 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	ha->prev_topology = 0;
 	ha->init_cb_size = sizeof(init_cb_t);
 	ha->mgmt_svr_loop_id = MANAGEMENT_SERVER;
-	ha->link_data_rate = LDR_UNKNOWN;
+	ha->link_data_rate = PORT_SPEED_UNKNOWN;
 	ha->optrom_size = OPTROM_SIZE_2300;
 
 	/* Assign ISP specific operations. */
-- 
1.4.2.3.gf59615

