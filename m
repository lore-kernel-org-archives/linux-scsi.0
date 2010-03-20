From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/5] qla2xxx: Add APEX support.
Date: Fri, 19 Mar 2010 17:03:59 -0700
Message-ID: <1269043442-2306-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36574 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752262Ab0CTAEF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 20:04:05 -0400
In-Reply-To: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Sarang Radke <sarang.radke@qlogic.com>

From: Sarang Radke <sarang.radke@qlogic.com>

Allows priority setting for FCP_CMNDs.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |  163 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    7 ++
 drivers/scsi/qla2xxx/qla_fw.h   |   59 ++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    9 ++-
 drivers/scsi/qla2xxx/qla_init.c |  168 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |   47 +++++++++++
 drivers/scsi/qla2xxx/qla_sup.c  |   69 +++++++++++++++-
 7 files changed, 518 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index dfad295..239d37b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -35,6 +35,166 @@ done:
 	return sp;
 }
 
+int
+qla24xx_fcp_prio_cfg_valid(struct qla_fcp_prio_cfg *pri_cfg, uint8_t flag)
+{
+	int i, ret, num_valid;
+	uint8_t *bcode;
+	struct qla_fcp_prio_entry *pri_entry;
+
+	ret = 1;
+	num_valid = 0;
+	bcode = (uint8_t *)pri_cfg;
+
+	if (bcode[0x0] != 'H' || bcode[0x1] != 'Q' || bcode[0x2] != 'O' ||
+			bcode[0x3] != 'S') {
+		return 0;
+	}
+	if (flag != 1)
+		return ret;
+
+	pri_entry = &pri_cfg->entry[0];
+	for (i = 0; i < pri_cfg->num_entries; i++) {
+		if (pri_entry->flags & FCP_PRIO_ENTRY_TAG_VALID)
+			num_valid++;
+		pri_entry++;
+	}
+
+	if (num_valid == 0)
+		ret = 0;
+
+	return ret;
+}
+
+static int
+qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	int ret = 0;
+	uint32_t len;
+	uint32_t oper;
+
+	bsg_job->reply->reply_payload_rcv_len = 0;
+
+	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
+		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
+		ret = -EBUSY;
+		goto exit_fcp_prio_cfg;
+	}
+
+	/* Get the sub command */
+	oper = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+
+	/* Only set config is allowed if config memory is not allocated */
+	if (!ha->fcp_prio_cfg && (oper != QLFC_FCP_PRIO_SET_CONFIG)) {
+		ret = -EINVAL;
+		goto exit_fcp_prio_cfg;
+	}
+	switch (oper) {
+	case QLFC_FCP_PRIO_DISABLE:
+		if (ha->flags.fcp_prio_enabled) {
+			ha->flags.fcp_prio_enabled = 0;
+			ha->fcp_prio_cfg->attributes &=
+				~FCP_PRIO_ATTR_ENABLE;
+			qla24xx_update_all_fcp_prio(vha);
+			bsg_job->reply->result = DID_OK;
+		} else {
+			ret = -EINVAL;
+			bsg_job->reply->result = (DID_ERROR << 16);
+			goto exit_fcp_prio_cfg;
+		}
+		break;
+
+	case QLFC_FCP_PRIO_ENABLE:
+		if (!ha->flags.fcp_prio_enabled) {
+			if (ha->fcp_prio_cfg) {
+				ha->flags.fcp_prio_enabled = 1;
+				ha->fcp_prio_cfg->attributes |=
+				    FCP_PRIO_ATTR_ENABLE;
+				qla24xx_update_all_fcp_prio(vha);
+				bsg_job->reply->result = DID_OK;
+			} else {
+				ret = -EINVAL;
+				bsg_job->reply->result = (DID_ERROR << 16);
+				goto exit_fcp_prio_cfg;
+			}
+		}
+		break;
+
+	case QLFC_FCP_PRIO_GET_CONFIG:
+		len = bsg_job->reply_payload.payload_len;
+		if (!len || len > FCP_PRIO_CFG_SIZE) {
+			ret = -EINVAL;
+			bsg_job->reply->result = (DID_ERROR << 16);
+			goto exit_fcp_prio_cfg;
+		}
+
+		bsg_job->reply->result = DID_OK;
+		bsg_job->reply->reply_payload_rcv_len =
+			sg_copy_from_buffer(
+			bsg_job->reply_payload.sg_list,
+			bsg_job->reply_payload.sg_cnt, ha->fcp_prio_cfg,
+			len);
+
+		break;
+
+	case QLFC_FCP_PRIO_SET_CONFIG:
+		len = bsg_job->request_payload.payload_len;
+		if (!len || len > FCP_PRIO_CFG_SIZE) {
+			bsg_job->reply->result = (DID_ERROR << 16);
+			ret = -EINVAL;
+			goto exit_fcp_prio_cfg;
+		}
+
+		if (!ha->fcp_prio_cfg) {
+			ha->fcp_prio_cfg = vmalloc(FCP_PRIO_CFG_SIZE);
+			if (!ha->fcp_prio_cfg) {
+				qla_printk(KERN_WARNING, ha,
+					"Unable to allocate memory "
+					"for fcp prio config data (%x).\n",
+					FCP_PRIO_CFG_SIZE);
+				bsg_job->reply->result = (DID_ERROR << 16);
+				ret = -ENOMEM;
+				goto exit_fcp_prio_cfg;
+			}
+		}
+
+		memset(ha->fcp_prio_cfg, 0, FCP_PRIO_CFG_SIZE);
+		sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+		bsg_job->request_payload.sg_cnt, ha->fcp_prio_cfg,
+			FCP_PRIO_CFG_SIZE);
+
+		/* validate fcp priority data */
+		if (!qla24xx_fcp_prio_cfg_valid(
+			(struct qla_fcp_prio_cfg *)
+			ha->fcp_prio_cfg, 1)) {
+			bsg_job->reply->result = (DID_ERROR << 16);
+			ret = -EINVAL;
+			/* If buffer was invalidatic int
+			 * fcp_prio_cfg is of no use
+			 */
+			vfree(ha->fcp_prio_cfg);
+			ha->fcp_prio_cfg = NULL;
+			goto exit_fcp_prio_cfg;
+		}
+
+		ha->flags.fcp_prio_enabled = 0;
+		if (ha->fcp_prio_cfg->attributes & FCP_PRIO_ATTR_ENABLE)
+			ha->flags.fcp_prio_enabled = 1;
+		qla24xx_update_all_fcp_prio(vha);
+		bsg_job->reply->result = DID_OK;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+exit_fcp_prio_cfg:
+	bsg_job->job_done(bsg_job);
+	return ret;
+}
 static int
 qla2x00_process_els(struct fc_bsg_job *bsg_job)
 {
@@ -948,6 +1108,9 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 	case QL_VND_IIDMA:
 		return qla24xx_iidma(bsg_job);
 
+	case QL_VND_FCP_PRIO_CFG_CMD:
+		return qla24xx_proc_fcp_prio_cfg_cmd(bsg_job);
+
 	default:
 		bsg_job->reply->result = (DID_ERROR << 16);
 		bsg_job->job_done(bsg_job);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 608397b..c51bd4e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1580,6 +1580,8 @@ typedef struct fc_port {
 	uint16_t loop_id;
 	uint16_t old_loop_id;
 
+	uint8_t fcp_prio;
+
 	uint8_t fabric_port_name[WWN_SIZE];
 	uint16_t fp_speed;
 
@@ -2296,6 +2298,7 @@ struct qla_hw_data {
 		uint32_t	eeh_busy		:1;
 		uint32_t	cpu_affinity_enabled	:1;
 		uint32_t	disable_msix_handshake	:1;
+		uint32_t	fcp_prio_enabled	:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
@@ -2599,6 +2602,7 @@ struct qla_hw_data {
 	uint32_t        flt_region_nvram;
 	uint32_t        flt_region_npiv_conf;
 	uint32_t	flt_region_gold_fw;
+	uint32_t	flt_region_fcp_prio;
 
 	/* Needed for BEACON */
 	uint16_t        beacon_blink_led;
@@ -2627,6 +2631,9 @@ struct qla_hw_data {
 	struct isp_operations *isp_ops;
 	struct workqueue_struct *wq;
 	struct qlfc_fw fw_buf;
+
+	/* FCP_CMND priority support */
+	struct qla_fcp_prio_cfg *fcp_prio_cfg;
 };
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 42c5587..a77a247 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -841,6 +841,8 @@ struct device_reg_24xx {
 #define FA_HW_EVENT_ENTRY_SIZE	4
 #define FA_NPIV_CONF0_ADDR	0x5C000
 #define FA_NPIV_CONF1_ADDR	0x5D000
+#define FA_FCP_PRIO0_ADDR	0x10000
+#define FA_FCP_PRIO1_ADDR	0x12000
 
 /*
  * Flash Error Log Event Codes.
@@ -1274,6 +1276,8 @@ struct qla_flt_header {
 #define FLT_REG_NPIV_CONF_0	0x29
 #define FLT_REG_NPIV_CONF_1	0x2a
 #define FLT_REG_GOLD_FW		0x2f
+#define FLT_REG_FCP_PRIO_0	0x87
+#define FLT_REG_FCP_PRIO_1	0x88
 
 struct qla_flt_region {
 	uint32_t code;
@@ -1750,6 +1754,61 @@ struct ex_init_cb_81xx {
 #define FARX_ACCESS_FLASH_CONF_81XX	0x7FFD0000
 #define FARX_ACCESS_FLASH_DATA_81XX	0x7F800000
 
+/* FCP priority config defines *************************************/
+/* operations */
+#define QLFC_FCP_PRIO_DISABLE           0x0
+#define QLFC_FCP_PRIO_ENABLE            0x1
+#define QLFC_FCP_PRIO_GET_CONFIG        0x2
+#define QLFC_FCP_PRIO_SET_CONFIG        0x3
+
+struct qla_fcp_prio_entry {
+	uint16_t flags;         /* Describes parameter(s) in FCP        */
+	/* priority entry that are valid        */
+#define FCP_PRIO_ENTRY_VALID            0x1
+#define FCP_PRIO_ENTRY_TAG_VALID        0x2
+#define FCP_PRIO_ENTRY_SPID_VALID       0x4
+#define FCP_PRIO_ENTRY_DPID_VALID       0x8
+#define FCP_PRIO_ENTRY_LUNB_VALID       0x10
+#define FCP_PRIO_ENTRY_LUNE_VALID       0x20
+#define FCP_PRIO_ENTRY_SWWN_VALID       0x40
+#define FCP_PRIO_ENTRY_DWWN_VALID       0x80
+	uint8_t  tag;           /* Priority value                   */
+	uint8_t  reserved;      /* Reserved for future use          */
+	uint32_t src_pid;       /* Src port id. high order byte     */
+				/* unused; -1 (wild card)           */
+	uint32_t dst_pid;       /* Src port id. high order byte     */
+	/* unused; -1 (wild card)           */
+	uint16_t lun_beg;       /* 1st lun num of lun range.        */
+				/* -1 (wild card)                   */
+	uint16_t lun_end;       /* 2nd lun num of lun range.        */
+				/* -1 (wild card)                   */
+	uint8_t  src_wwpn[8];   /* Source WWPN: -1 (wild card)      */
+	uint8_t  dst_wwpn[8];   /* Destination WWPN: -1 (wild card) */
+};
+
+struct qla_fcp_prio_cfg {
+	uint8_t  signature[4];  /* "HQOS" signature of config data  */
+	uint16_t version;       /* 1: Initial version               */
+	uint16_t length;        /* config data size in num bytes    */
+	uint16_t checksum;      /* config data bytes checksum       */
+	uint16_t num_entries;   /* Number of entries                */
+	uint16_t size_of_entry; /* Size of each entry in num bytes  */
+	uint8_t  attributes;    /* enable/disable, persistence      */
+#define FCP_PRIO_ATTR_DISABLE   0x0
+#define FCP_PRIO_ATTR_ENABLE    0x1
+#define FCP_PRIO_ATTR_PERSIST   0x2
+	uint8_t  reserved;      /* Reserved for future use          */
+#define FCP_PRIO_CFG_HDR_SIZE   0x10
+	struct qla_fcp_prio_entry entry[1];     /* fcp priority entries  */
+#define FCP_PRIO_CFG_ENTRY_SIZE 0x20
+};
+
+#define FCP_PRIO_CFG_SIZE       (32*1024) /* fcp prio data per port*/
+
+/* 25XX Support ****************************************************/
+#define FA_FCP_PRIO0_ADDR_25	0x3C000
+#define FA_FCP_PRIO1_ADDR_25	0x3E000
+
 /* 81XX Flash locations -- occupies second 2MB region. */
 #define FA_BOOT_CODE_ADDR_81	0x80000
 #define FA_RISC_CODE_ADDR_81	0xA0000
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index c1f1736..5efd4c0 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -328,6 +328,9 @@ extern int
 qla2x00_write_ram_word(scsi_qla_host_t *, uint32_t, uint32_t);
 
 extern int qla2x00_get_data_rate(scsi_qla_host_t *);
+extern int qla24xx_set_fcp_prio(scsi_qla_host_t *, uint16_t, uint16_t,
+	uint16_t *);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
@@ -384,6 +387,7 @@ extern int qla2xxx_get_flash_info(scsi_qla_host_t *);
 extern int qla2xxx_get_vpd_field(scsi_qla_host_t *, char *, char *, size_t);
 
 extern void qla2xxx_flash_npiv_conf(scsi_qla_host_t *);
+extern int qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *);
 
 /*
  * Global Function Prototypes in qla_dbg.c source file.
@@ -430,7 +434,10 @@ extern void qla2x00_init_host_attr(scsi_qla_host_t *);
 extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
 extern int qla2x00_loopback_test(scsi_qla_host_t *, struct msg_echo_lb *, uint16_t *);
-extern int qla2x00_echo_test(scsi_qla_host_t *, struct msg_echo_lb *, uint16_t *);
+extern int qla2x00_echo_test(scsi_qla_host_t *,
+	struct msg_echo_lb *, uint16_t *);
+extern int qla24xx_update_all_fcp_prio(scsi_qla_host_t *);
+extern int qla24xx_fcp_prio_cfg_valid(struct qla_fcp_prio_cfg *, uint8_t);
 
 /*
  * Global Function Prototypes in qla_dfs.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a67b2ba..3714fec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -348,6 +348,12 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 		}
 	}
 
+	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha)) {
+		if (qla24xx_read_fcp_prio_cfg(vha))
+			qla_printk(KERN_ERR, ha,
+			"Unable to read FCP priority data.\n");
+	}
+
 	return (rval);
 }
 
@@ -4904,3 +4910,165 @@ qla81xx_update_fw_options(scsi_qla_host_t *vha)
 	ha->fw_options[2] |= BIT_9;
 	qla2x00_set_fw_options(vha, ha->fw_options);
 }
+
+/*
+ * qla24xx_get_fcp_prio
+ *	Gets the fcp cmd priority value for the logged in port.
+ *	Looks for a match of the port descriptors within
+ *	each of the fcp prio config entries. If a match is found,
+ *	the tag (priority) value is returned.
+ *
+ * Input:
+ *	ha = adapter block po
+ *	fcport = port structure pointer.
+ *
+ * Return:
+ * 	non-zero (if found)
+ * 	0 (if not found)
+ *
+ * Context:
+ * 	Kernel context
+ */
+uint8_t
+qla24xx_get_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
+{
+	int i, entries;
+	uint8_t pid_match, wwn_match;
+	uint8_t priority;
+	uint32_t pid1, pid2;
+	uint64_t wwn1, wwn2;
+	struct qla_fcp_prio_entry *pri_entry;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!ha->fcp_prio_cfg || !ha->flags.fcp_prio_enabled)
+		return 0;
+
+	priority = 0;
+	entries = ha->fcp_prio_cfg->num_entries;
+	pri_entry = &ha->fcp_prio_cfg->entry[0];
+
+	for (i = 0; i < entries; i++) {
+		pid_match = wwn_match = 0;
+
+		if (!(pri_entry->flags & FCP_PRIO_ENTRY_VALID)) {
+			pri_entry++;
+			continue;
+		}
+
+		/* check source pid for a match */
+		if (pri_entry->flags & FCP_PRIO_ENTRY_SPID_VALID) {
+			pid1 = pri_entry->src_pid & INVALID_PORT_ID;
+			pid2 = vha->d_id.b24 & INVALID_PORT_ID;
+			if (pid1 == INVALID_PORT_ID)
+				pid_match++;
+			else if (pid1 == pid2)
+				pid_match++;
+		}
+
+		/* check destination pid for a match */
+		if (pri_entry->flags & FCP_PRIO_ENTRY_DPID_VALID) {
+			pid1 = pri_entry->dst_pid & INVALID_PORT_ID;
+			pid2 = fcport->d_id.b24 & INVALID_PORT_ID;
+			if (pid1 == INVALID_PORT_ID)
+				pid_match++;
+			else if (pid1 == pid2)
+				pid_match++;
+		}
+
+		/* check source WWN for a match */
+		if (pri_entry->flags & FCP_PRIO_ENTRY_SWWN_VALID) {
+			wwn1 = wwn_to_u64(vha->port_name);
+			wwn2 = wwn_to_u64(pri_entry->src_wwpn);
+			if (wwn2 == (uint64_t)-1)
+				wwn_match++;
+			else if (wwn1 == wwn2)
+				wwn_match++;
+		}
+
+		/* check destination WWN for a match */
+		if (pri_entry->flags & FCP_PRIO_ENTRY_DWWN_VALID) {
+			wwn1 = wwn_to_u64(fcport->port_name);
+			wwn2 = wwn_to_u64(pri_entry->dst_wwpn);
+			if (wwn2 == (uint64_t)-1)
+				wwn_match++;
+			else if (wwn1 == wwn2)
+				wwn_match++;
+		}
+
+		if (pid_match == 2 || wwn_match == 2) {
+			/* Found a matching entry */
+			if (pri_entry->flags & FCP_PRIO_ENTRY_TAG_VALID)
+				priority = pri_entry->tag;
+			break;
+		}
+
+		pri_entry++;
+	}
+
+	return priority;
+}
+
+/*
+ * qla24xx_update_fcport_fcp_prio
+ *	Activates fcp priority for the logged in fc port
+ *
+ * Input:
+ *	ha = adapter block pointer.
+ *	fcp = port structure pointer.
+ *
+ * Return:
+ *	QLA_SUCCESS or QLA_FUNCTION_FAILED
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *ha, fc_port_t *fcport)
+{
+	int ret;
+	uint8_t priority;
+	uint16_t mb[5];
+
+	if (atomic_read(&fcport->state) == FCS_UNCONFIGURED ||
+		fcport->port_type != FCT_TARGET ||
+		fcport->loop_id == FC_NO_LOOP_ID)
+		return QLA_FUNCTION_FAILED;
+
+	priority = qla24xx_get_fcp_prio(ha, fcport);
+	ret = qla24xx_set_fcp_prio(ha, fcport->loop_id, priority, mb);
+	if (ret == QLA_SUCCESS)
+		fcport->fcp_prio = priority;
+	else
+		DEBUG2(printk(KERN_WARNING
+			"scsi(%ld): Unable to activate fcp priority, "
+			" ret=0x%x\n", ha->host_no, ret));
+
+	return  ret;
+}
+
+/*
+ * qla24xx_update_all_fcp_prio
+ *	Activates fcp priority for all the logged in ports
+ *
+ * Input:
+ *	ha = adapter block pointer.
+ *
+ * Return:
+ *	QLA_SUCCESS or QLA_FUNCTION_FAILED
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla24xx_update_all_fcp_prio(scsi_qla_host_t *vha)
+{
+	int ret;
+	fc_port_t *fcport;
+
+	ret = QLA_FUNCTION_FAILED;
+	/* We need to set priority for all logged in ports */
+	list_for_each_entry(fcport, &vha->vp_fcports, list)
+		ret = qla24xx_update_fcport_fcp_prio(vha, fcport);
+
+	return ret;
+}
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b9e5ea3..d1d66a1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3895,3 +3895,50 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 
 	return rval;
 }
+
+int
+qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority,
+		uint16_t *mb)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk(KERN_INFO
+	    "%s(%ld): entered.\n", __func__, ha->host_no));
+
+	mcp->mb[0] = MBC_PORT_PARAMS;
+	mcp->mb[1] = loop_id;
+	if (ha->flags.fcp_prio_enabled)
+		mcp->mb[2] = BIT_1;
+	else
+		mcp->mb[2] = BIT_2;
+	mcp->mb[4] = priority & 0xf;
+	mcp->mb[9] = vha->vp_idx;
+	mcp->out_mb = MBX_9|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_4|MBX_3|MBX_1|MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (mb != NULL) {
+		mb[0] = mcp->mb[0];
+		mb[1] = mcp->mb[1];
+		mb[3] = mcp->mb[3];
+		mb[4] = mcp->mb[4];
+	}
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk(KERN_WARNING
+		    "%s(%ld): failed=%x.\n", __func__,
+		    vha->host_no, rval));
+	} else {
+		DEBUG11(printk(KERN_INFO
+		    "%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 371dc89..4ee22a2 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -647,6 +647,12 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 	const uint32_t def_npiv_conf1[] =
 		{ FA_NPIV_CONF1_ADDR_24, FA_NPIV_CONF1_ADDR,
 			FA_NPIV_CONF1_ADDR_81 };
+	const uint32_t fcp_prio_cfg0[] =
+		{ FA_FCP_PRIO0_ADDR, FA_FCP_PRIO0_ADDR_25,
+			0 };
+	const uint32_t fcp_prio_cfg1[] =
+		{ FA_FCP_PRIO1_ADDR, FA_FCP_PRIO1_ADDR_25,
+			0 };
 	uint32_t def;
 	uint16_t *wptr;
 	uint16_t cnt, chksum;
@@ -731,6 +737,14 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 		case FLT_REG_GOLD_FW:
 			ha->flt_region_gold_fw = start;
 			break;
+		case FLT_REG_FCP_PRIO_0:
+			if (!(PCI_FUNC(ha->pdev->devfn) & 1))
+				ha->flt_region_fcp_prio = start;
+			break;
+		case FLT_REG_FCP_PRIO_1:
+			if (PCI_FUNC(ha->pdev->devfn) & 1)
+				ha->flt_region_fcp_prio = start;
+			break;
 		}
 	}
 	goto done;
@@ -749,12 +763,14 @@ no_flash_data:
 	ha->flt_region_boot = def_boot[def];
 	ha->flt_region_vpd_nvram = def_vpd_nvram[def];
 	ha->flt_region_vpd = ha->flags.port0 ?
-	    def_vpd0[def]: def_vpd1[def];
+	    def_vpd0[def] : def_vpd1[def];
 	ha->flt_region_nvram = ha->flags.port0 ?
-	    def_nvram0[def]: def_nvram1[def];
+	    def_nvram0[def] : def_nvram1[def];
 	ha->flt_region_fdt = def_fdt[def];
 	ha->flt_region_npiv_conf = ha->flags.port0 ?
-	    def_npiv_conf0[def]: def_npiv_conf1[def];
+	    def_npiv_conf0[def] : def_npiv_conf1[def];
+	ha->flt_region_fcp_prio = ha->flags.port0 ?
+	    fcp_prio_cfg0[def] : fcp_prio_cfg1[def];
 done:
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLT[%s]: boot=0x%x fw=0x%x "
 	    "vpd_nvram=0x%x vpd=0x%x nvram=0x%x fdt=0x%x flt=0x%x "
@@ -2721,3 +2737,50 @@ qla2xxx_get_vpd_field(scsi_qla_host_t *vha, char *key, char *str, size_t size)
 
 	return 0;
 }
+
+int
+qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *vha)
+{
+	int len, max_len;
+	uint32_t fcp_prio_addr;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!ha->fcp_prio_cfg) {
+		ha->fcp_prio_cfg = vmalloc(FCP_PRIO_CFG_SIZE);
+		if (!ha->fcp_prio_cfg) {
+			qla_printk(KERN_WARNING, ha,
+			"Unable to allocate memory for fcp priority data "
+					"(%x).\n", FCP_PRIO_CFG_SIZE);
+			return QLA_FUNCTION_FAILED;
+		}
+	}
+	memset(ha->fcp_prio_cfg, 0, FCP_PRIO_CFG_SIZE);
+
+	fcp_prio_addr = ha->flt_region_fcp_prio;
+
+	/* first read the fcp priority data header from flash */
+	ha->isp_ops->read_optrom(vha, (uint8_t *)ha->fcp_prio_cfg,
+			fcp_prio_addr << 2, FCP_PRIO_CFG_HDR_SIZE);
+
+	if (!qla24xx_fcp_prio_cfg_valid(ha->fcp_prio_cfg, 0))
+		goto fail;
+
+	/* read remaining FCP CMD config data from flash */
+	fcp_prio_addr += (FCP_PRIO_CFG_HDR_SIZE >> 2);
+	len = ha->fcp_prio_cfg->num_entries * FCP_PRIO_CFG_ENTRY_SIZE;
+	max_len = FCP_PRIO_CFG_SIZE - FCP_PRIO_CFG_HDR_SIZE;
+
+	ha->isp_ops->read_optrom(vha, (uint8_t *)&ha->fcp_prio_cfg->entry[0],
+			fcp_prio_addr << 2, (len < max_len ? len : max_len));
+
+	/* revalidate the entire FCP priority config data, including entries */
+	if (!qla24xx_fcp_prio_cfg_valid(ha->fcp_prio_cfg, 1))
+		goto fail;
+
+	ha->flags.fcp_prio_enabled = 1;
+	return QLA_SUCCESS;
+fail:
+	vfree(ha->fcp_prio_cfg);
+	ha->fcp_prio_cfg = NULL;
+	return QLA_FUNCTION_FAILED;
+}
-- 
1.6.2.rc1.30.gd43c

