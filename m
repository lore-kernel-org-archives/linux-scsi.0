From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/16]  qla2xxx: Add FDMI support.
Date: Fri, 26 Aug 2005 19:08:30 -0700 (PDT)
Message-ID: <20050827020830.27275.83854.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:49255 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751612AbVH0CIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:08:32 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add FDMI support.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_dbg.h  |    7 
 drivers/scsi/qla2xxx/qla_def.h  |  151 ++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 
 drivers/scsi/qla2xxx/qla_gs.c   |  564 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_init.c |    6 
 drivers/scsi/qla2xxx/qla_isr.c  |    2 
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 
 drivers/scsi/qla2xxx/qla_os.c   |   10 +
 8 files changed, 741 insertions(+), 5 deletions(-)

65d5302a171f3f42542962aa597500334f41bdf4
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -81,6 +81,7 @@
 #define DEBUG2_3_11(x)  do {x;} while (0);
 #define DEBUG2_9_10(x)    do {x;} while (0);
 #define DEBUG2_11(x)    do {x;} while (0);
+#define DEBUG2_13(x)    do {x;} while (0);
 #else
 #define DEBUG2(x)	do {} while (0);
 #endif
@@ -169,8 +170,14 @@
 
 #if defined(QL_DEBUG_LEVEL_13)
 #define DEBUG13(x)      do {x;} while (0)
+#if !defined(DEBUG2_13)
+#define DEBUG2_13(x)    do {x;} while(0)
+#endif
 #else
 #define DEBUG13(x)	do {} while (0)
+#if !defined(QL_DEBUG_LEVEL_2)
+#define DEBUG2_13(x)	do {} while(0)
+#endif
 #endif
 
 #if defined(QL_DEBUG_LEVEL_14)
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -214,6 +214,7 @@
  * valid range of an N-PORT id is 0 through 0x7ef.
  */
 #define NPH_LAST_HANDLE		0x7ef
+#define NPH_MGMT_SERVER		0x7fa		/*  FFFFFA */
 #define NPH_SNS			0x7fc		/*  FFFFFC */
 #define NPH_FABRIC_CONTROLLER	0x7fd		/*  FFFFFD */
 #define NPH_F_PORT		0x7fe		/*  FFFFFE */
@@ -1131,10 +1132,7 @@ typedef struct {
 
 	uint8_t link_down_timeout;
 
-	uint8_t adapter_id_0[4];
-	uint8_t adapter_id_1[4];
-	uint8_t adapter_id_2[4];
-	uint8_t adapter_id_3[4];
+	uint8_t adapter_id[16];
 
 	uint8_t alt1_boot_node_name[WWN_SIZE];
 	uint16_t alt1_boot_lun_number;
@@ -1728,6 +1726,8 @@ typedef struct fc_port {
 
 #define CT_REJECT_RESPONSE	0x8001
 #define CT_ACCEPT_RESPONSE	0x8002
+#define CT_REASON_CANNOT_PERFORM	0x09
+#define CT_EXPL_ALREADY_REGISTERED	0x10
 
 #define NS_N_PORT_TYPE	0x01
 #define NS_NL_PORT_TYPE	0x02
@@ -1769,6 +1769,100 @@ typedef struct fc_port {
 #define	RSNN_NN_REQ_SIZE (16 + 8 + 1 + 255)
 #define	RSNN_NN_RSP_SIZE 16
 
+/*
+ * HBA attribute types.
+ */
+#define FDMI_HBA_ATTR_COUNT			9
+#define FDMI_HBA_NODE_NAME			1
+#define FDMI_HBA_MANUFACTURER			2
+#define FDMI_HBA_SERIAL_NUMBER			3
+#define FDMI_HBA_MODEL				4
+#define FDMI_HBA_MODEL_DESCRIPTION		5
+#define FDMI_HBA_HARDWARE_VERSION		6
+#define FDMI_HBA_DRIVER_VERSION			7
+#define FDMI_HBA_OPTION_ROM_VERSION		8
+#define FDMI_HBA_FIRMWARE_VERSION		9
+#define FDMI_HBA_OS_NAME_AND_VERSION		0xa
+#define FDMI_HBA_MAXIMUM_CT_PAYLOAD_LENGTH	0xb
+
+struct ct_fdmi_hba_attr {
+	uint16_t type;
+	uint16_t len;
+	union {
+		uint8_t node_name[WWN_SIZE];
+		uint8_t manufacturer[32];
+		uint8_t serial_num[8];
+		uint8_t model[16];
+		uint8_t model_desc[80];
+		uint8_t hw_version[16];
+		uint8_t driver_version[32];
+		uint8_t orom_version[16];
+		uint8_t fw_version[16];
+		uint8_t os_version[128];
+		uint8_t max_ct_len[4];
+	} a;
+};
+
+struct ct_fdmi_hba_attributes {
+	uint32_t count;
+	struct ct_fdmi_hba_attr entry[FDMI_HBA_ATTR_COUNT];
+};
+
+/*
+ * Port attribute types.
+ */
+#define FDMI_PORT_ATTR_COUNT		5
+#define FDMI_PORT_FC4_TYPES		1
+#define FDMI_PORT_SUPPORT_SPEED		2
+#define FDMI_PORT_CURRENT_SPEED		3
+#define FDMI_PORT_MAX_FRAME_SIZE	4
+#define FDMI_PORT_OS_DEVICE_NAME	5
+#define FDMI_PORT_HOST_NAME		6
+
+struct ct_fdmi_port_attr {
+	uint16_t type;
+	uint16_t len;
+	union {
+		uint8_t fc4_types[32];
+		uint32_t sup_speed;
+		uint32_t cur_speed;
+		uint32_t max_frame_size;
+		uint8_t os_dev_name[32];
+		uint8_t host_name[32];
+	} a;
+};
+
+/*
+ * Port Attribute Block.
+ */
+struct ct_fdmi_port_attributes {
+	uint32_t count;
+	struct ct_fdmi_port_attr entry[FDMI_PORT_ATTR_COUNT];
+};
+
+/* FDMI definitions. */
+#define GRHL_CMD	0x100
+#define GHAT_CMD	0x101
+#define GRPL_CMD	0x102
+#define GPAT_CMD	0x110
+
+#define RHBA_CMD	0x200
+#define RHBA_RSP_SIZE	16
+
+#define RHAT_CMD	0x201
+#define RPRT_CMD	0x210
+
+#define RPA_CMD		0x211
+#define RPA_RSP_SIZE	16
+
+#define DHBA_CMD	0x300
+#define DHBA_REQ_SIZE	(16 + 8)
+#define DHBA_RSP_SIZE	16
+
+#define DHAT_CMD	0x301
+#define DPRT_CMD	0x310
+#define DPA_CMD		0x311
+
 /* CT command header -- request/response common fields */
 struct ct_cmd_hdr {
 	uint8_t revision;
@@ -1826,6 +1920,43 @@ struct ct_sns_req {
 			uint8_t name_len;
 			uint8_t sym_node_name[255];
 		} rsnn_nn;
+
+		struct {
+			uint8_t hba_indentifier[8];
+		} ghat;
+
+		struct {
+			uint8_t hba_identifier[8];
+			uint32_t entry_count;
+			uint8_t port_name[8];
+			struct ct_fdmi_hba_attributes attrs;
+		} rhba;
+
+		struct {
+			uint8_t hba_identifier[8];
+			struct ct_fdmi_hba_attributes attrs;
+		} rhat;
+
+		struct {
+			uint8_t port_name[8];
+			struct ct_fdmi_port_attributes attrs;
+		} rpa;
+
+		struct {
+			uint8_t port_name[8];
+		} dhba;
+
+		struct {
+			uint8_t port_name[8];
+		} dhat;
+
+		struct {
+			uint8_t port_name[8];
+		} dprt;
+
+		struct {
+			uint8_t port_name[8];
+		} dpa;
 	} req;
 };
 
@@ -1883,6 +2014,12 @@ struct ct_sns_rsp {
 		struct {
 			uint8_t fc4_types[32];
 		} gft_id;
+
+		struct {
+			uint32_t entry_count;
+			uint8_t port_name[8];
+			struct ct_fdmi_hba_attributes attrs;
+		} ghat;
 	} rsp;
 };
 
@@ -2033,6 +2170,8 @@ struct isp_operations {
 	uint16_t (*calc_req_entries) (uint16_t);
 	void (*build_iocbs) (srb_t *, cmd_entry_t *, uint16_t);
 	void * (*prep_ms_iocb) (struct scsi_qla_host *, uint32_t, uint32_t);
+	void * (*prep_ms_fdmi_iocb) (struct scsi_qla_host *, uint32_t,
+	    uint32_t);
 
 	uint8_t * (*read_nvram) (struct scsi_qla_host *, uint8_t *,
 		uint32_t, uint32_t);
@@ -2112,6 +2251,7 @@ typedef struct scsi_qla_host {
 #define IOCTL_ERROR_RECOVERY	23
 #define LOOP_RESET_NEEDED	24
 #define BEACON_BLINK_NEEDED	25
+#define REGISTER_FDMI_NEEDED	26
 
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
@@ -2205,6 +2345,7 @@ typedef struct scsi_qla_host {
 	int		port_down_retry_count;
 	uint8_t		mbx_count;
 	uint16_t	last_loop_id;
+	uint16_t	mgmt_svr_loop_id;
 
         uint32_t	login_retry_count;
 
@@ -2319,6 +2460,7 @@ typedef struct scsi_qla_host {
 	uint8_t		model_number[16+1];
 #define BINZERO		"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
 	char		*model_desc;
+	uint8_t		adapter_id[16+1];
 
 	uint8_t		*node_name;
 	uint8_t		*port_name;
@@ -2378,6 +2520,7 @@ typedef struct scsi_qla_host {
 #define QLA_SUSPENDED			0x106
 #define QLA_BUSY			0x107
 #define QLA_RSCNS_HANDLED		0x108
+#define QLA_ALREADY_REGISTERED		0x109
 
 /*
 * Stat info for all adpaters
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -79,6 +79,7 @@ extern int ql2xplogiabsentdevice;
 extern int ql2xenablezio;
 extern int ql2xintrdelaytimer;
 extern int ql2xloginretrycount;
+extern int ql2xfdmienable;
 
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
@@ -269,6 +270,9 @@ extern int qla2x00_rft_id(scsi_qla_host_
 extern int qla2x00_rff_id(scsi_qla_host_t *);
 extern int qla2x00_rnn_id(scsi_qla_host_t *);
 extern int qla2x00_rsnn_nn(scsi_qla_host_t *);
+extern void *qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
+extern void *qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
+extern int qla2x00_fdmi_register(scsi_qla_host_t *);
 
 /*
  * Global Function Prototypes in qla_rscn.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1099,3 +1099,567 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *ha)
 
 	return (rval);
 }
+
+/**
+ * qla2x00_mgmt_svr_login() - Login to fabric Managment Service.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+static int
+qla2x00_mgmt_svr_login(scsi_qla_host_t *ha)
+{
+	int ret;
+	uint16_t mb[MAILBOX_REGISTER_COUNT];
+
+	ret = QLA_SUCCESS;
+	if (ha->flags.management_server_logged_in)
+		return ret;
+
+	ha->isp_ops.fabric_login(ha, ha->mgmt_svr_loop_id, 0xff, 0xff, 0xfa,
+	    mb, BIT_1);
+	if (mb[0] != MBS_COMMAND_COMPLETE) {
+		DEBUG2_13(printk("%s(%ld): Failed MANAGEMENT_SERVER login: "
+		    "loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x mb[6]=%x mb[7]=%x\n",
+		    __func__, ha->host_no, ha->mgmt_svr_loop_id, mb[0], mb[1],
+		    mb[2], mb[6], mb[7]));
+		ret = QLA_FUNCTION_FAILED;
+	} else
+		ha->flags.management_server_logged_in = 1;
+
+	return ret;
+}
+
+/**
+ * qla2x00_prep_ms_fdmi_iocb() - Prepare common MS IOCB fields for FDMI query.
+ * @ha: HA context
+ * @req_size: request size in bytes
+ * @rsp_size: response size in bytes
+ *
+ * Returns a pointer to the @ha's ms_iocb.
+ */
+void *
+qla2x00_prep_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size,
+    uint32_t rsp_size)
+{
+	ms_iocb_entry_t *ms_pkt;
+
+	ms_pkt = ha->ms_iocb;
+	memset(ms_pkt, 0, sizeof(ms_iocb_entry_t));
+
+	ms_pkt->entry_type = MS_IOCB_TYPE;
+	ms_pkt->entry_count = 1;
+	SET_TARGET_ID(ha, ms_pkt->loop_id, ha->mgmt_svr_loop_id);
+	ms_pkt->control_flags = __constant_cpu_to_le16(CF_READ | CF_HEAD_TAG);
+	ms_pkt->timeout = __constant_cpu_to_le16(59);
+	ms_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
+	ms_pkt->total_dsd_count = __constant_cpu_to_le16(2);
+	ms_pkt->rsp_bytecount = cpu_to_le32(rsp_size);
+	ms_pkt->req_bytecount = cpu_to_le32(req_size);
+
+	ms_pkt->dseg_req_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
+	ms_pkt->dseg_req_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ms_pkt->dseg_req_length = ms_pkt->req_bytecount;
+
+	ms_pkt->dseg_rsp_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
+	ms_pkt->dseg_rsp_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ms_pkt->dseg_rsp_length = ms_pkt->rsp_bytecount;
+
+	return ms_pkt;
+}
+
+/**
+ * qla24xx_prep_ms_fdmi_iocb() - Prepare common MS IOCB fields for FDMI query.
+ * @ha: HA context
+ * @req_size: request size in bytes
+ * @rsp_size: response size in bytes
+ *
+ * Returns a pointer to the @ha's ms_iocb.
+ */
+void *
+qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size,
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
+static inline ms_iocb_entry_t *
+qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *ha, uint32_t req_size)
+{
+	ms_iocb_entry_t *ms_pkt = ha->ms_iocb;
+	struct ct_entry_24xx *ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
+
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
+		ct_pkt->dseg_0_len = ct_pkt->cmd_byte_count;
+	} else {
+		ms_pkt->req_bytecount = cpu_to_le32(req_size);
+		ms_pkt->dseg_req_length = ms_pkt->req_bytecount;
+	}
+
+	return ms_pkt;
+}
+
+/**
+ * qla2x00_prep_ct_req() - Prepare common CT request fields for SNS query.
+ * @ct_req: CT request buffer
+ * @cmd: GS command
+ * @rsp_size: response size in bytes
+ *
+ * Returns a pointer to the intitialized @ct_req.
+ */
+static inline struct ct_sns_req *
+qla2x00_prep_ct_fdmi_req(struct ct_sns_req *ct_req, uint16_t cmd,
+    uint16_t rsp_size)
+{
+	memset(ct_req, 0, sizeof(struct ct_sns_pkt));
+
+	ct_req->header.revision = 0x01;
+	ct_req->header.gs_type = 0xFA;
+	ct_req->header.gs_subtype = 0x10;
+	ct_req->command = cpu_to_be16(cmd);
+	ct_req->max_rsp_size = cpu_to_be16((rsp_size - 16) / 4);
+
+	return ct_req;
+}
+
+/**
+ * qla2x00_fdmi_rhba() -
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+static int
+qla2x00_fdmi_rhba(scsi_qla_host_t *ha)
+{
+	int rval, alen;
+	uint32_t size, sn;
+
+	ms_iocb_entry_t *ms_pkt;
+	struct ct_sns_req *ct_req;
+	struct ct_sns_rsp *ct_rsp;
+	uint8_t *entries;
+	struct ct_fdmi_hba_attr *eiter;
+
+	/* Issue RHBA */
+	/* Prepare common MS IOCB */
+	/*   Request size adjusted after CT preparation */
+	ms_pkt = ha->isp_ops.prep_ms_fdmi_iocb(ha, 0, RHBA_RSP_SIZE);
+
+	/* Prepare CT request */
+	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RHBA_CMD,
+	    RHBA_RSP_SIZE);
+	ct_rsp = &ha->ct_sns->p.rsp;
+
+	/* Prepare FDMI command arguments -- attribute block, attributes. */
+	memcpy(ct_req->req.rhba.hba_identifier, ha->port_name, WWN_SIZE);
+	ct_req->req.rhba.entry_count = __constant_cpu_to_be32(1);
+	memcpy(ct_req->req.rhba.port_name, ha->port_name, WWN_SIZE);
+	size = 2 * WWN_SIZE + 4 + 4;
+
+	/* Attributes */
+	ct_req->req.rhba.attrs.count =
+	    __constant_cpu_to_be32(FDMI_HBA_ATTR_COUNT);
+	entries = ct_req->req.rhba.hba_identifier;
+
+	/* Nodename. */
+	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_HBA_NODE_NAME);
+	eiter->len = __constant_cpu_to_be16(4 + WWN_SIZE);
+	memcpy(eiter->a.node_name, ha->node_name, WWN_SIZE);
+	size += 4 + WWN_SIZE;
+
+	DEBUG13(printk("%s(%ld): NODENAME=%02x%02x%02x%02x%02x%02x%02x%02x.\n",
+	    __func__, ha->host_no,
+	    eiter->a.node_name[0], eiter->a.node_name[1], eiter->a.node_name[2],
+	    eiter->a.node_name[3], eiter->a.node_name[4], eiter->a.node_name[5],
+	    eiter->a.node_name[6], eiter->a.node_name[7]));
+
+	/* Manufacturer. */
+	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
+	strcpy(eiter->a.manufacturer, "QLogic Corporation");
+	alen = strlen(eiter->a.manufacturer);
+	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+	eiter->len = cpu_to_be16(4 + alen);
+	size += 4 + alen;
+
+	DEBUG13(printk("%s(%ld): MANUFACTURER=%s.\n", __func__, ha->host_no,
+	    eiter->a.manufacturer));
+
+	/* Serial number. */
+	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_HBA_SERIAL_NUMBER);
+	sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | ha->serial1;
+	sprintf(eiter->a.serial_num, "%c%05d", 'A' + sn / 100000, sn % 100000);
+	alen = strlen(eiter->a.serial_num);
+	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+	eiter->len = cpu_to_be16(4 + alen);
+	size += 4 + alen;
+
+	DEBUG13(printk("%s(%ld): SERIALNO=%s.\n", __func__, ha->host_no,
+	    eiter->a.serial_num));
+
+	/* Model name. */
+	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MODEL);
+	strcpy(eiter->a.model, ha->model_number);
+	alen = strlen(eiter->a.model);
+	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+	eiter->len = cpu_to_be16(4 + alen);
+	size += 4 + alen;
+
+	DEBUG13(printk("%s(%ld): MODEL_NAME=%s.\n", __func__, ha->host_no,
+	    eiter->a.model));
+
+	/* Model description. */
+	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MODEL_DESCRIPTION);
+	if (ha->model_desc)
+		strncpy(eiter->a.model_desc, ha->model_desc, 80);
+	alen = strlen(eiter->a.model_desc);
+	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+	eiter->len = cpu_to_be16(4 + alen);
+	size += 4 + alen;
+
+	DEBUG13(printk("%s(%ld): MODEL_DESC=%s.\n", __func__, ha->host_no,
+	    eiter->a.model_desc));
+
+	/* Hardware version. */
+	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_HBA_HARDWARE_VERSION);
+	strcpy(eiter->a.hw_version, ha->adapter_id);
+	alen = strlen(eiter->a.hw_version);
+	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+	eiter->len = cpu_to_be16(4 + alen);
+	size += 4 + alen;
+
+	DEBUG13(printk("%s(%ld): HARDWAREVER=%s.\n", __func__, ha->host_no,
+	    eiter->a.hw_version));
+
+	/* Driver version. */
+	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_HBA_DRIVER_VERSION);
+	strcpy(eiter->a.driver_version, qla2x00_version_str);
+	alen = strlen(eiter->a.driver_version);
+	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+	eiter->len = cpu_to_be16(4 + alen);
+	size += 4 + alen;
+
+	DEBUG13(printk("%s(%ld): DRIVERVER=%s.\n", __func__, ha->host_no,
+	    eiter->a.driver_version));
+
+	/* Option ROM version. */
+	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
+	strcpy(eiter->a.orom_version, "0.00");
+	alen = strlen(eiter->a.orom_version);
+	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+	eiter->len = cpu_to_be16(4 + alen);
+	size += 4 + alen;
+
+	DEBUG13(printk("%s(%ld): OPTROMVER=%s.\n", __func__, ha->host_no,
+	    eiter->a.orom_version));
+
+	/* Firmware version */
+	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_HBA_FIRMWARE_VERSION);
+	ha->isp_ops.fw_version_str(ha, eiter->a.fw_version);
+	alen = strlen(eiter->a.fw_version);
+	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+	eiter->len = cpu_to_be16(4 + alen);
+	size += 4 + alen;
+
+	DEBUG13(printk("%s(%ld): FIRMWAREVER=%s.\n", __func__, ha->host_no,
+	    eiter->a.fw_version));
+
+	/* Update MS request size. */
+	qla2x00_update_ms_fdmi_iocb(ha, size + 16);
+
+	DEBUG13(printk("%s(%ld): RHBA identifier="
+	    "%02x%02x%02x%02x%02x%02x%02x%02x size=%d.\n", __func__,
+	    ha->host_no, ct_req->req.rhba.hba_identifier[0],
+	    ct_req->req.rhba.hba_identifier[1],
+	    ct_req->req.rhba.hba_identifier[2],
+	    ct_req->req.rhba.hba_identifier[3],
+	    ct_req->req.rhba.hba_identifier[4],
+	    ct_req->req.rhba.hba_identifier[5],
+	    ct_req->req.rhba.hba_identifier[6],
+	    ct_req->req.rhba.hba_identifier[7], size));
+	DEBUG13(qla2x00_dump_buffer(entries, size));
+
+	/* Execute MS IOCB */
+	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	    sizeof(ms_iocb_entry_t));
+	if (rval != QLA_SUCCESS) {
+		/*EMPTY*/
+		DEBUG2_3(printk("scsi(%ld): RHBA issue IOCB failed (%d).\n",
+		    ha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RHBA") !=
+	    QLA_SUCCESS) {
+		rval = QLA_FUNCTION_FAILED;
+		if (ct_rsp->header.reason_code == CT_REASON_CANNOT_PERFORM &&
+		    ct_rsp->header.explanation_code ==
+		    CT_EXPL_ALREADY_REGISTERED) {
+			DEBUG2_13(printk("%s(%ld): HBA already registered.\n",
+			    __func__, ha->host_no));
+			rval = QLA_ALREADY_REGISTERED;
+		}
+	} else {
+		DEBUG2(printk("scsi(%ld): RHBA exiting normally.\n",
+		    ha->host_no));
+	}
+
+	return rval;
+}
+
+/**
+ * qla2x00_fdmi_dhba() -
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+static int
+qla2x00_fdmi_dhba(scsi_qla_host_t *ha)
+{
+	int rval;
+
+	ms_iocb_entry_t *ms_pkt;
+	struct ct_sns_req *ct_req;
+	struct ct_sns_rsp *ct_rsp;
+
+	/* Issue RPA */
+	/* Prepare common MS IOCB */
+	ms_pkt = ha->isp_ops.prep_ms_fdmi_iocb(ha, DHBA_REQ_SIZE,
+	    DHBA_RSP_SIZE);
+
+	/* Prepare CT request */
+	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, DHBA_CMD,
+	    DHBA_RSP_SIZE);
+	ct_rsp = &ha->ct_sns->p.rsp;
+
+	/* Prepare FDMI command arguments -- portname. */
+	memcpy(ct_req->req.dhba.port_name, ha->port_name, WWN_SIZE);
+
+	DEBUG13(printk("%s(%ld): DHBA portname="
+	    "%02x%02x%02x%02x%02x%02x%02x%02x.\n", __func__, ha->host_no,
+	    ct_req->req.dhba.port_name[0], ct_req->req.dhba.port_name[1],
+	    ct_req->req.dhba.port_name[2], ct_req->req.dhba.port_name[3],
+	    ct_req->req.dhba.port_name[4], ct_req->req.dhba.port_name[5],
+	    ct_req->req.dhba.port_name[6], ct_req->req.dhba.port_name[7]));
+
+	/* Execute MS IOCB */
+	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	    sizeof(ms_iocb_entry_t));
+	if (rval != QLA_SUCCESS) {
+		/*EMPTY*/
+		DEBUG2_3(printk("scsi(%ld): DHBA issue IOCB failed (%d).\n",
+		    ha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "DHBA") !=
+	    QLA_SUCCESS) {
+		rval = QLA_FUNCTION_FAILED;
+	} else {
+		DEBUG2(printk("scsi(%ld): DHBA exiting normally.\n",
+		    ha->host_no));
+	}
+
+	return rval;
+}
+
+/**
+ * qla2x00_fdmi_rpa() -
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+static int
+qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
+{
+	int rval, alen;
+	uint32_t size, max_frame_size;
+
+	ms_iocb_entry_t *ms_pkt;
+	struct ct_sns_req *ct_req;
+	struct ct_sns_rsp *ct_rsp;
+	uint8_t *entries;
+	struct ct_fdmi_port_attr *eiter;
+	struct init_cb_24xx *icb24 = (struct init_cb_24xx *)ha->init_cb;
+
+	/* Issue RPA */
+	/* Prepare common MS IOCB */
+	/*   Request size adjusted after CT preparation */
+	ms_pkt = ha->isp_ops.prep_ms_fdmi_iocb(ha, 0, RPA_RSP_SIZE);
+
+	/* Prepare CT request */
+	ct_req = qla2x00_prep_ct_fdmi_req(&ha->ct_sns->p.req, RPA_CMD,
+	    RPA_RSP_SIZE);
+	ct_rsp = &ha->ct_sns->p.rsp;
+
+	/* Prepare FDMI command arguments -- attribute block, attributes. */
+	memcpy(ct_req->req.rpa.port_name, ha->port_name, WWN_SIZE);
+	size = WWN_SIZE + 4;
+
+	/* Attributes */
+	ct_req->req.rpa.attrs.count =
+	    __constant_cpu_to_be32(FDMI_PORT_ATTR_COUNT);
+	entries = ct_req->req.rpa.port_name;
+
+	/* FC4 types. */
+	eiter = (struct ct_fdmi_port_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_PORT_FC4_TYPES);
+	eiter->len = __constant_cpu_to_be16(4 + 32);
+	eiter->a.fc4_types[2] = 0x01;
+	size += 4 + 32;
+
+	DEBUG13(printk("%s(%ld): FC4_TYPES=%02x %02x.\n", __func__, ha->host_no,
+	    eiter->a.fc4_types[2], eiter->a.fc4_types[1]));
+
+	/* Supported speed. */
+	eiter = (struct ct_fdmi_port_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
+	eiter->len = __constant_cpu_to_be16(4 + 4);
+	if (IS_QLA25XX(ha))
+		eiter->a.sup_speed = __constant_cpu_to_be32(4);
+	else if (IS_QLA24XX(ha))
+		eiter->a.sup_speed = __constant_cpu_to_be32(8);
+	else if (IS_QLA23XX(ha))
+		eiter->a.sup_speed = __constant_cpu_to_be32(2);
+	else
+		eiter->a.sup_speed = __constant_cpu_to_be32(1);
+	size += 4 + 4;
+
+	DEBUG13(printk("%s(%ld): SUPPORTED_SPEED=%x.\n", __func__, ha->host_no,
+	    eiter->a.sup_speed));
+
+	/* Current speed. */
+	eiter = (struct ct_fdmi_port_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_PORT_CURRENT_SPEED);
+	eiter->len = __constant_cpu_to_be16(4 + 4);
+	switch (ha->link_data_rate) {
+	case 0:
+		eiter->a.cur_speed = __constant_cpu_to_be32(1);
+		break;
+	case 1:
+		eiter->a.cur_speed = __constant_cpu_to_be32(2);
+		break;
+	case 3:
+		eiter->a.cur_speed = __constant_cpu_to_be32(8);
+		break;
+	case 4:
+		eiter->a.cur_speed = __constant_cpu_to_be32(4);
+		break;
+	}
+	size += 4 + 4;
+
+	DEBUG13(printk("%s(%ld): CURRENT_SPEED=%x.\n", __func__, ha->host_no,
+	    eiter->a.cur_speed));
+
+	/* Max frame size. */
+	eiter = (struct ct_fdmi_port_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
+	eiter->len = __constant_cpu_to_be16(4 + 4);
+	max_frame_size = IS_QLA24XX(ha) || IS_QLA25XX(ha) ?
+		(uint32_t) icb24->frame_payload_size:
+		(uint32_t) ha->init_cb->frame_payload_size;
+	eiter->a.max_frame_size = cpu_to_be32(max_frame_size);
+	size += 4 + 4;
+
+	DEBUG13(printk("%s(%ld): MAX_FRAME_SIZE=%x.\n", __func__, ha->host_no,
+	    eiter->a.max_frame_size));
+
+	/* OS device name. */
+	eiter = (struct ct_fdmi_port_attr *) (entries + size);
+	eiter->type = __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
+	sprintf(eiter->a.os_dev_name, "/proc/scsi/qla2xxx/%ld", ha->host_no);
+	alen = strlen(eiter->a.os_dev_name);
+	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+	eiter->len = cpu_to_be16(4 + alen);
+	size += 4 + alen;
+
+	DEBUG13(printk("%s(%ld): OS_DEVICE_NAME=%s.\n", __func__, ha->host_no,
+	    eiter->a.os_dev_name));
+
+	/* Update MS request size. */
+	qla2x00_update_ms_fdmi_iocb(ha, size + 16);
+
+	DEBUG13(printk("%s(%ld): RPA portname="
+	    "%02x%02x%02x%02x%02x%02x%02x%02x size=%d.\n", __func__,
+	    ha->host_no, ct_req->req.rpa.port_name[0],
+	    ct_req->req.rpa.port_name[1], ct_req->req.rpa.port_name[2],
+	    ct_req->req.rpa.port_name[3], ct_req->req.rpa.port_name[4],
+	    ct_req->req.rpa.port_name[5], ct_req->req.rpa.port_name[6],
+	    ct_req->req.rpa.port_name[7], size));
+	DEBUG13(qla2x00_dump_buffer(entries, size));
+
+	/* Execute MS IOCB */
+	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
+	    sizeof(ms_iocb_entry_t));
+	if (rval != QLA_SUCCESS) {
+		/*EMPTY*/
+		DEBUG2_3(printk("scsi(%ld): RPA issue IOCB failed (%d).\n",
+		    ha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RPA") !=
+	    QLA_SUCCESS) {
+		rval = QLA_FUNCTION_FAILED;
+	} else {
+		DEBUG2(printk("scsi(%ld): RPA exiting normally.\n",
+		    ha->host_no));
+	}
+
+	return rval;
+}
+
+/**
+ * qla2x00_fdmi_register() -
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+int
+qla2x00_fdmi_register(scsi_qla_host_t *ha)
+{
+	int rval;
+
+	rval = qla2x00_mgmt_svr_login(ha);
+	if (rval)
+		return rval;
+
+	rval = qla2x00_fdmi_rhba(ha);
+	if (rval) {
+		if (rval != QLA_ALREADY_REGISTERED)
+			return rval;
+
+		rval = qla2x00_fdmi_dhba(ha);
+		if (rval)
+			return rval;
+
+		rval = qla2x00_fdmi_rhba(ha);
+		if (rval)
+			return rval;
+	}
+	rval = qla2x00_fdmi_rpa(ha);
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -88,6 +88,7 @@ qla2x00_initialize_adapter(scsi_qla_host
 	ha->mbx_flags = 0;
 	ha->isp_abort_cnt = 0;
 	ha->beacon_blink_led = 0;
+	set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
 
 	qla_printk(KERN_INFO, ha, "Configuring PCI space...\n");
 	rval = ha->isp_ops.pci_config(ha);
@@ -2136,6 +2137,11 @@ qla2x00_configure_fabric(scsi_qla_host_t
 		return (QLA_SUCCESS);
 	}
 	do {
+		/* FDMI support. */
+		if (ql2xfdmienable &&
+		    test_and_clear_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags))
+			qla2x00_fdmi_register(ha);
+
 		/* Ensure we are logged into the SNS. */
 		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
 			loop_id = NPH_SNS;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -451,6 +451,8 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 
 		ha->flags.management_server_logged_in = 0;
 		ha->link_data_rate = 0;
+		if (ql2xfdmienable)
+			set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
 
 		/* Update AEN queue. */
 		qla2x00_enqueue_aen(ha, MBA_LOOP_DOWN, NULL);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -252,7 +252,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 			mb0 = RD_REG_WORD(&reg->isp24.mailbox0);
 			ictrl = RD_REG_DWORD(&reg->isp24.ictrl);
 		} else {
-			mb0 = RD_MAILBOX_REG(ha, reg->isp, 0);
+			mb0 = RD_MAILBOX_REG(ha, &reg->isp, 0);
 			ictrl = RD_REG_WORD(&reg->isp.ictrl);
 		}
 		printk("%s(%ld): **** MB Command Timeout for cmd %x ****\n",
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -88,6 +88,12 @@ static void qla2x00_free_device(scsi_qla
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
 
+int ql2xfdmienable;
+module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xfdmienable,
+		"Enables FDMI registratons "
+		"Default is 0 - no FDMI. 1 - perfom FDMI.");
+
 /*
  * SCSI host template entry points
  */
@@ -1303,6 +1309,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->prev_topology = 0;
 	ha->ports = MAX_BUSES;
 	ha->init_cb_size = sizeof(init_cb_t);
+	ha->mgmt_svr_loop_id = MANAGEMENT_SERVER;
 
 	/* Assign ISP specific operations. */
 	ha->isp_ops.pci_config		= qla2100_pci_config;
@@ -1325,6 +1332,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->isp_ops.calc_req_entries	= qla2x00_calc_iocbs_32;
 	ha->isp_ops.build_iocbs		= qla2x00_build_scsi_iocbs_32;
 	ha->isp_ops.prep_ms_iocb	= qla2x00_prep_ms_iocb;
+	ha->isp_ops.prep_ms_fdmi_iocb	= qla2x00_prep_ms_fdmi_iocb;
 	ha->isp_ops.read_nvram		= qla2x00_read_nvram_data;
 	ha->isp_ops.write_nvram		= qla2x00_write_nvram_data;
 	ha->isp_ops.fw_dump		= qla2100_fw_dump;
@@ -1362,6 +1370,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
 		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct init_cb_24xx);
+		ha->mgmt_svr_loop_id = 10;
 		ha->isp_ops.pci_config = qla24xx_pci_config;
 		ha->isp_ops.reset_chip = qla24xx_reset_chip;
 		ha->isp_ops.chip_diag = qla24xx_chip_diag;
@@ -1382,6 +1391,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->isp_ops.fabric_login = qla24xx_login_fabric;
 		ha->isp_ops.fabric_logout = qla24xx_fabric_logout;
 		ha->isp_ops.prep_ms_iocb = qla24xx_prep_ms_iocb;
+		ha->isp_ops.prep_ms_fdmi_iocb = qla24xx_prep_ms_fdmi_iocb;
 		ha->isp_ops.read_nvram = qla24xx_read_nvram_data;
 		ha->isp_ops.write_nvram = qla24xx_write_nvram_data;
 		ha->isp_ops.fw_dump = qla24xx_fw_dump;

-- 
Andrew Vasquez
