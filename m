From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 2/3] qla2xxx: Enable 2xxx series LLD target mode support
Date: Thu,  3 Mar 2011 19:21:40 -0800
Message-ID: <1299208901-32133-3-git-send-email-nab@linux-iscsi.org>
References: <1299208901-32133-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1299208901-32133-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Ruediger Oertel <ro@suse.de>, Nicholas Bellinger <nab@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@risingtidesystems.com>

This patch enables target mode support with the qla2xxx SCSI LLD using
qla_target.c logic introduced in commit 703194ae2.  This includes:

*) Addition of target mode specific members to existing data
structures in qla_def.h and struct qla_hw_data->qla2x_tmpl using
qla_tgt_def.h:struct qla_target_template.

*) Addition of qla_hw_data->qla2x_tmpl checks for API calls via
struct qla_target_template and/or direct calls into qla_target.c
logic w/ qla_tgt_* prefixed functions.

*) Addition of qla24xx_process_atio_queue(), qla2x00_req_pkt()
for ring processing, and qla2x00_issue_marker() for handling
request/response queue processing for target mode.

*) Addition of various qla_tgt_mode_enabled() logic checks in
qla24xx_nvram_config(), qla2x00_initialize_adapter(), qla2x00_rff_id(),
qla2x00_abort_isp(), qla24xx_modify_vp_config(), and qla2x00_vp_abort_isp().

For the specific checks for qla_hw_data->qla2x_tmpl this includes:

*) control plane:

qla_init.c:qla2x00_rport_del() -> qla_tgt_fc_port_deleted()
qla_init.c:qla2x00_reg_remote_port() -> qla_tgt_fc_port_added()
qla_init.c:qla2x00_device_resync() -> qla2x00_mark_device_lost()

*) I/O path:

qla_isr.c:qla2x00_async_event() -> qla_tgt_async_event()
qla_isr.c:qla2x00_process_response_queue() -> qla_tgt_response_pkt_all_vps()
qla_isr.c:qla24xx_process_response_queue() -> qla_tgt_response_pkt_all_vps()

Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
---
 drivers/scsi/qla2xxx/Makefile   |    4 +-
 drivers/scsi/qla2xxx/qla_attr.c |   13 ++-
 drivers/scsi/qla2xxx/qla_dbg.h  |   34 ++++++
 drivers/scsi/qla2xxx/qla_def.h  |   68 ++++++++++-
 drivers/scsi/qla2xxx/qla_fw.h   |   10 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |   11 ++
 drivers/scsi/qla2xxx/qla_gs.c   |   13 ++-
 drivers/scsi/qla2xxx/qla_init.c |  249 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_iocb.c |  106 ++++++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c  |  229 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c  |  173 +++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mid.c  |   34 +++++-
 drivers/scsi/qla2xxx/qla_os.c   |  168 ++++++++++++++++++++++++---
 13 files changed, 1054 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index 5df782f..4861054 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,5 +1,7 @@
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
 		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o \
-        qla_nx.o
+        qla_nx.o qla_target.o
 
 obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
+
+EXTRA_CFLAGS    := -Idrivers/scsi/qla2xxx/ -Idrivers/target/ -Idrivers/target/tcm_qla2xxx/
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d3e58d7..aaeee53 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
@@ -1816,6 +1817,15 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 	fc_host_supported_speeds(vha->host) =
 		fc_host_supported_speeds(base_vha->host);
 
+	mutex_init(&ha->tgt_mutex);
+	mutex_init(&ha->tgt_host_action_mutex);
+	qla_tgt_clear_mode(vha);
+	qla2x00_send_enable_lun(vha, false);
+	if (IS_QLA24XX_TYPE(ha))
+		ha->atio_q_length = ATIO_ENTRY_CNT_24XX;
+	else if (IS_QLA25XX(ha))
+		ha->atio_q_length = ATIO_ENTRY_CNT_24XX;
+
 	qla24xx_vport_disable(fc_vport, disable);
 
 	if (ha->flags.cpu_affinity_enabled) {
@@ -2020,7 +2030,8 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
 	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
 	fc_host_port_name(vha->host) = wwn_to_u64(vha->port_name);
-	fc_host_supported_classes(vha->host) = FC_COS_CLASS3;
+	fc_host_supported_classes(vha->host) = ha->enable_class_2 ?
+			(FC_COS_CLASS2|FC_COS_CLASS3) : FC_COS_CLASS3;
 	fc_host_max_npiv_vports(vha->host) = ha->max_npiv_vports;
 	fc_host_npiv_vports_inuse(vha->host) = ha->cur_vport_count;
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index b74e6b5..b5b2f95 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -28,6 +28,11 @@
 /* #define QL_DEBUG_LEVEL_16 */ /* Output ISP84XX trace msgs */
 /* #define QL_DEBUG_LEVEL_17 */ /* Output EEH trace messages */
 /* #define QL_DEBUG_LEVEL_18 */ /* Output T10 CRC trace messages */
+/* #define QL_DEBUG_LEVEL_21 */ /* Output for target */
+/* #define QL_DEBUG_LEVEL_22 */ /* Output for target management */
+/* #define QL_DEBUG_LEVEL_23 */ /* Output for target scsi packets */
+/* #define QL_DEBUG_LEVEL_24 */ /* Output for target SG lists */
+/* #define QL_DEBUG_LEVEL_25 */ /* Output for target task management */
 
 /*
 * Macros use for debugging the driver.
@@ -146,6 +151,35 @@
 #define DEBUG18(x)	do {} while (0)
 #endif
 
+#if defined(QL_DEBUG_LEVEL_21)
+#define DEBUG21(x)	do {x;} while (0)
+#else
+#define DEBUG21(x)	do {} while (0)
+#endif
+
+#if defined(QL_DEBUG_LEVEL_22)
+#define DEBUG22(x)	do {x;} while (0)
+#else
+#define DEBUG22(x)	do {} while (0)
+#endif
+
+#if defined(QL_DEBUG_LEVEL_23)
+#define DEBUG23(x)	do {x;} while (0)
+#else
+#define DEBUG23(x)	do {} while (0)
+#endif
+
+#if defined(QL_DEBUG_LEVEL_24)
+#define DEBUG24(x)	do {x;} while (0)
+#else
+#define DEBUG24(x)	do {} while (0)
+#endif
+
+#if defined(QL_DEBUG_LEVEL_25)
+#define DEBUG25(x)	do {x;} while (0)
+#else
+#define DEBUG25(x)	do {} while (0)
+#endif
 
 /*
  * Firmware Dump structure definition
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ccfc8e7..5de7326 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -185,6 +185,7 @@
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_MQ		128	/* Number of response entries.*/
+#define ATIO_ENTRY_CNT_24XX		4096	/* Number of ATIO entries. */
 
 struct req_que;
 
@@ -546,7 +547,7 @@ typedef struct {
 #define MBA_SYSTEM_ERR		0x8002	/* System Error. */
 #define MBA_REQ_TRANSFER_ERR	0x8003	/* Request Transfer Error. */
 #define MBA_RSP_TRANSFER_ERR	0x8004	/* Response Transfer Error. */
-#define MBA_WAKEUP_THRES	0x8005	/* Request Queue Wake-up. */
+#define MBA_ATIO_TRANSFER_ERR	0x8005	/* ATIO Queue Transfer Error. */
 #define MBA_LIP_OCCURRED	0x8010	/* Loop Initialization Procedure */
 					/* occurred. */
 #define MBA_LOOP_UP		0x8011	/* FC Loop UP. */
@@ -886,7 +887,6 @@ typedef struct {
 	uint16_t response_q_length;
 	uint32_t request_q_address[2];
 	uint32_t response_q_address[2];
-
 	uint16_t lun_enables;
 	uint8_t  command_resource_count;
 	uint8_t  immediate_notify_resource_count;
@@ -1220,11 +1220,27 @@ typedef struct {
  * ISP queue - response queue entry definition.
  */
 typedef struct {
-	uint8_t		data[60];
+	uint8_t		entry_type;		/* Entry type. */
+	uint8_t		entry_count;		/* Entry count. */
+	uint8_t		sys_define;		/* System defined. */
+	uint8_t		entry_status;		/* Entry Status. */
+	uint32_t	handle;			/* System defined handle */
+	uint8_t		data[52];
 	uint32_t	signature;
 #define RESPONSE_PROCESSED	0xDEADDEAD	/* Signature */
 } response_t;
 
+/*
+ * ISP queue - ATIO queue entry definition.
+ */
+typedef struct {
+	uint8_t		entry_type;		/* Entry type. */
+	uint8_t		entry_count;		/* Entry count. */
+	uint8_t		data[58];
+	uint32_t	signature;
+#define ATIO_PROCESSED 0xDEADDEAD		/* Signature */
+} atio_t;
+
 typedef union {
 	uint16_t extended;
 	struct {
@@ -1686,6 +1702,8 @@ typedef struct fc_port {
 
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
+	/* True, if confirmed completion is supported */
+	uint8_t conf_compl_supported:1;
 	port_id_t d_id;
 	uint16_t loop_id;
 	uint16_t old_loop_id;
@@ -2616,6 +2634,7 @@ struct qla_hw_data {
 	void		*dcbx_tlv;
 	dma_addr_t	dcbx_tlv_dma;
 
+	spinlock_t	dpc_lock;
 	struct task_struct	*dpc_thread;
 	uint8_t dpc_active;                  /* DPC routine is active */
 
@@ -2692,6 +2711,8 @@ struct qla_hw_data {
 	struct mutex	fce_mutex;
 
 	uint32_t	pci_attr;
+#define HA_HOST_STR_SIZE 16
+	uint8_t		host_str[HA_HOST_STR_SIZE];
 	uint16_t	chip_revision;
 
 	uint16_t	product_id[4];
@@ -2809,6 +2830,40 @@ struct qla_hw_data {
 
 	uint8_t fw_type;
 	__le32 file_prd_off;	/* File firmware product offset */
+
+	/* Protected by hw lock */
+	uint32_t enable_class_2:1;
+	uint32_t enable_explicit_conf:1;
+	uint32_t host_shutting_down:1;
+	uint32_t ini_mode_force_reverse:1;
+	uint32_t node_name_set:1;
+
+	dma_addr_t atio_dma;	/* Physical address. */
+	atio_t  *atio_ring;	/* Base virtual address */
+	atio_t	*atio_ring_ptr;	/* Current address. */
+	uint16_t atio_ring_index; /* Current index. */
+	uint16_t atio_q_length;
+
+	void *target_lport_ptr;
+	struct qla_target_template *qla2x_tmpl;
+	struct qla_tgt *qla_tgt;
+	struct qla_tgt_cmd *cmds[MAX_OUTSTANDING_COMMANDS];
+	uint16_t current_handle;
+
+	struct qla_tgt_vp_map *tgt_vp_map;
+	struct mutex tgt_mutex;
+	struct mutex tgt_host_action_mutex;
+
+	struct list_head ha_list_entry;
+	int saved_set;
+	uint16_t saved_exchange_count;
+	uint32_t saved_firmware_options_1;
+	uint32_t saved_firmware_options_2;
+	uint32_t saved_firmware_options_3;
+	uint8_t saved_firmware_options[2];
+	uint8_t saved_add_firmware_options[2];
+
+	uint8_t tgt_node_name[WWN_SIZE];
 };
 
 /*
@@ -2933,8 +2988,14 @@ typedef struct scsi_qla_host {
 	int		seconds_since_last_heartbeat;
 
 	atomic_t	vref_count;
+
 } scsi_qla_host_t;
 
+struct qla_tgt_vp_map {
+	uint8_t	idx;
+	scsi_qla_host_t *vha;
+};
+
 /*
  * Macros to help code, maintain, etc.
  */
@@ -2958,6 +3019,7 @@ typedef struct scsi_qla_host {
 	atomic_dec(&__vha->vref_count);			     \
 } while (0)
 
+#define to_qla_host(x)	((scsi_qla_host_t *) (x)->hostdata)
 
 #define qla_printk(level, ha, format, arg...) \
 	dev_printk(level , &((ha)->pdev->dev) , format , ## arg)
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 631fefc..9a1f8b8b 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -26,6 +26,16 @@
 #define PDO_FORCE_ADISC		BIT_1
 #define PDO_FORCE_PLOGI		BIT_0
 
+struct qla_port23_data {
+	uint8_t port_name[WWN_SIZE];
+	uint16_t loop_id;
+};
+
+struct qla_port24_data {
+	uint8_t port_name[WWN_SIZE];
+	uint16_t loop_id;
+	uint16_t reserved;
+};
 
 #define	PORT_DATABASE_24XX_SIZE		64
 struct port_database_24xx {
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 89e900a..717e6ce 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -53,6 +53,9 @@ extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
 extern void qla2x00_alloc_fw_dump(scsi_qla_host_t *);
 extern void qla2x00_try_to_stop_firmware(scsi_qla_host_t *);
 
+extern void qla2x00_enable_tgt_mode(struct scsi_qla_host *);
+extern void qla2x00_disable_tgt_mode(struct scsi_qla_host *);
+
 extern int qla2x00_get_thermal_temp(scsi_qla_host_t *, uint16_t *, uint16_t *);
 
 extern void qla84xx_put_chip(struct scsi_qla_host *);
@@ -172,6 +175,11 @@ extern int  qla2x00_vp_abort_isp(scsi_qla_host_t *);
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
+
+extern void *qla2x00_alloc_iocbs(scsi_qla_host_t *, srb_t *);
+extern void qla2x00_isp_cmd(struct scsi_qla_host *, struct req_que *);
+extern int qla2x00_issue_marker(scsi_qla_host_t *, int);
+
 extern uint16_t qla2x00_calc_iocbs_32(uint16_t);
 extern uint16_t qla2x00_calc_iocbs_64(uint16_t);
 extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
@@ -237,6 +245,9 @@ extern int
 qla2x00_init_firmware(scsi_qla_host_t *, uint16_t);
 
 extern int
+qla2x00_get_node_name_list(scsi_qla_host_t *, void **, int *);
+
+extern int
 qla2x00_get_port_database(scsi_qla_host_t *, fc_port_t *, uint8_t);
 
 extern int
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 4c08392..3c5fc2b 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 static int qla2x00_sns_ga_nxt(scsi_qla_host_t *, fc_port_t *);
 static int qla2x00_sns_gid_pt(scsi_qla_host_t *, sw_info_t *);
@@ -540,8 +541,18 @@ qla2x00_rff_id(scsi_qla_host_t *vha)
 	ct_req->req.rff_id.port_id[0] = vha->d_id.b.domain;
 	ct_req->req.rff_id.port_id[1] = vha->d_id.b.area;
 	ct_req->req.rff_id.port_id[2] = vha->d_id.b.al_pa;
+	/*
+	 * FC-4 Feature bit 0 indicates target functionality to the name server.
+	 */
+	if (qla_tgt_mode_enabled(vha)) {
+		if (qla_ini_mode_enabled(vha))
+			ct_req->req.rff_id.fc4_feature = BIT_0 | BIT_1;
+		else
+			ct_req->req.rff_id.fc4_feature = BIT_0;
+	} else if (qla_ini_mode_enabled(vha)) {
+		ct_req->req.rff_id.fc4_feature = BIT_1;
+	}
 
-	ct_req->req.rff_id.fc4_feature = BIT_1;
 	ct_req->req.rff_id.fc4_type = 0x08;		/* SCSI - FCP */
 
 	/* Execute MS IOCB */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d9479c3..02d66a7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -17,6 +17,10 @@
 #include <asm/prom.h>
 #endif
 
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include "qla_target.h"
+
 /*
 *  QLogic ISP2x00 Hardware Support Function Prototypes.
 */
@@ -580,6 +584,16 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))
 		qla24xx_read_fcp_prio_cfg(vha);
 
+	if (rval == QLA_SUCCESS &&
+	   (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))) {
+		/* Enable target response to SCSI bus. */
+		if (qla_tgt_mode_enabled(vha)) {
+			qla2x00_send_enable_lun(vha, true);
+		} else if (qla_ini_mode_enabled(vha)) {
+			qla2x00_send_enable_lun(vha, false);
+		}
+	}
+
 	return (rval);
 }
 
@@ -1581,6 +1595,30 @@ qla2x00_init_response_q_entries(struct rsp_que *rsp)
 	}
 }
 
+/*
+ * qla2x00_init_atio_q_entries() - Initializes ATIO queue entries.
+ * @ha: HA context
+ *
+ * Beginning of ATIO ring has initialization control block already built
+ * by nvram config routine.
+ *
+ * Returns 0 on success.
+ */
+static void
+qla2x00_init_atio_q_entries(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t cnt;
+	atio_t *pkt;
+
+	pkt = ha->atio_ring;
+	for (cnt = 0; cnt < ha->atio_q_length; cnt++) {
+		pkt->signature = ATIO_PROCESSED;
+		pkt++;
+	}
+
+}
+
 /**
  * qla2x00_update_fw_options() - Read and process firmware options.
  * @ha: HA context
@@ -1733,6 +1771,12 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 	icb->response_q_address[0] = cpu_to_le32(LSD(rsp->dma));
 	icb->response_q_address[1] = cpu_to_le32(MSD(rsp->dma));
 
+	/* Setup ATIO queue dma pointers for target mode */
+	icb->atio_q_inpointer = __constant_cpu_to_le16(0);
+	icb->atio_q_length = cpu_to_le16(ha->atio_q_length);
+	icb->atio_q_address[0] = cpu_to_le32(LSD(ha->atio_dma));
+	icb->atio_q_address[1] = cpu_to_le32(MSD(ha->atio_dma));
+
 	if (ha->mqenable) {
 		icb->qos = __constant_cpu_to_le16(QLA_DEFAULT_QUE_QOS);
 		icb->rid = __constant_cpu_to_le16(rid);
@@ -1768,12 +1812,24 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 		WRT_REG_DWORD(&reg->isp25mq.req_q_out, 0);
 		WRT_REG_DWORD(&reg->isp25mq.rsp_q_in, 0);
 		WRT_REG_DWORD(&reg->isp25mq.rsp_q_out, 0);
+#warning FIXME: atio_q in/out for ha->mqueue=1..?
+#if 0
+		WRT_REG_DWORD(&reg->isp25mq.atio_q_in, 0);
+		WRT_REG_DWORD(&reg->isp25mq.atio_q_out, 0);
+		RD_REG_DWORD(&reg->isp25mq.atio_q_out);
+#endif
 	} else {
 		WRT_REG_DWORD(&reg->isp24.req_q_in, 0);
 		WRT_REG_DWORD(&reg->isp24.req_q_out, 0);
 		WRT_REG_DWORD(&reg->isp24.rsp_q_in, 0);
 		WRT_REG_DWORD(&reg->isp24.rsp_q_out, 0);
+
+		/* Setup APTIO registers for target mode */
+		WRT_REG_DWORD(&reg->isp24.atio_q_in, 0);
+		WRT_REG_DWORD(&reg->isp24.atio_q_out, 0);
+		RD_REG_DWORD(&reg->isp24.atio_q_out);
 	}
+
 	/* PCI posting */
 	RD_REG_DWORD(&ioreg->hccr);
 }
@@ -1835,6 +1891,11 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 
 	spin_unlock(&ha->vport_slock);
 
+	ha->atio_ring_ptr = ha->atio_ring;
+	ha->atio_ring_index = 0;
+	/* Initialize ATIO queue entries */
+	qla2x00_init_atio_q_entries(vha);
+
 	ha->isp_ops->config_rings(vha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -2045,7 +2106,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	vha->loop_id = loop_id;
 
 	/* initialize */
-	ha->min_external_loopid = SNS_FIRST_LOOP_ID;
+	ha->min_external_loopid = SNS_FIRST_LOOP_ID + 1;
 	ha->operating_mode = LOOP;
 	ha->switch_cap = 0;
 
@@ -2097,6 +2158,8 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	vha->d_id.b.area = area;
 	vha->d_id.b.al_pa = al_pa;
 
+	ha->tgt_vp_map[al_pa].idx = vha->vp_idx;
+
 	if (!vha->flags.init_done)
  		qla_printk(KERN_INFO, ha,
 		    "Topology - %s, Host Loop address 0x%x\n",
@@ -2207,6 +2270,13 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 
 	rval = QLA_SUCCESS;
 
+	if (unlikely(nv == NULL)) {
+		qla_printk(KERN_ERR, ha, "request_ring pointer is NULL\n");
+		dump_stack();
+		rval = 1;
+		goto out;
+	}
+
 	/* Determine NVRAM starting address. */
 	ha->nvram_size = sizeof(nvram_t);
 	ha->nvram_base = 0;
@@ -2302,15 +2372,78 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	/*
 	 * Setup driver NVRAM options.
 	 */
+	if (!IS_QLA2100(ha)) {
+		/* Check if target mode enabled */
+		if (qla_tgt_mode_enabled(vha)) {
+			if (!ha->saved_set) {
+				/* We save only once */
+				ha->saved_firmware_options[0] = nv->firmware_options[0];
+				ha->saved_firmware_options[1] = nv->firmware_options[1];
+				ha->saved_add_firmware_options[0] = nv->add_firmware_options[0];
+				ha->saved_add_firmware_options[1] = nv->add_firmware_options[1];
+				ha->saved_set = 1;
+			}
+			/* Enable target mode */
+			nv->firmware_options[0] |= BIT_4;
+			/* Disable ini mode, if requested */
+			if (!qla_ini_mode_enabled(vha))
+				nv->firmware_options[0] |= BIT_5;
+
+			/* Disable Full Login after LIP */
+			nv->firmware_options[1] &= ~BIT_5;
+			/* Enable initial LIP */
+			nv->firmware_options[1] &= BIT_1;
+			/* Enable FC tapes support */
+			nv->add_firmware_options[1] |= BIT_4;
+			/* Enable Command Queuing in Target Mode */
+			nv->add_firmware_options[1] |= BIT_6;
+		} else {
+			if (ha->saved_set) {
+				nv->firmware_options[0] = ha->saved_firmware_options[0];
+				nv->firmware_options[1] = ha->saved_firmware_options[1];
+				nv->add_firmware_options[0] = ha->saved_add_firmware_options[0];
+				nv->add_firmware_options[1] = ha->saved_add_firmware_options[1];
+			}
+		}
+	}
+
+	if (!IS_QLA2100(ha)) {
+		if (ha->enable_class_2) {
+			if (vha->flags.init_done) {
+				fc_host_supported_classes(vha->host) =
+					FC_COS_CLASS2 | FC_COS_CLASS3;
+			}
+			nv->add_firmware_options[1] |= BIT_0;
+		} else {
+			if (vha->flags.init_done) {
+				fc_host_supported_classes(vha->host) =
+					FC_COS_CLASS3;
+			}
+			nv->add_firmware_options[1] &= BIT_0;
+		}
+	}
+
+	/* Enable ADISC and fairness */
 	nv->firmware_options[0] |= (BIT_6 | BIT_1);
 	nv->firmware_options[0] &= ~(BIT_5 | BIT_4);
 	nv->firmware_options[1] |= (BIT_5 | BIT_0);
+	/* Enable PDB changed AE */
+	nv->firmware_options[1] |= BIT_0;
+	/* Stop Port Queue on Full Status */
 	nv->firmware_options[1] &= ~BIT_4;
 
 	if (IS_QLA23XX(ha)) {
+		/* Enable full duplex */
 		nv->firmware_options[0] |= BIT_2;
+		/* Disable Fast Status Posting */
 		nv->firmware_options[0] &= ~BIT_3;
+#if 0
 		nv->firmware_options[0] &= ~BIT_6;
+#else
+		/* out-of-order frames rassembly */
+		nv->special_options[0] |= BIT_6;
+#endif
+		/* P2P preferred, otherwise loop */
 		nv->add_firmware_options[1] |= BIT_5 | BIT_4;
 
 		if (IS_QLA2300(ha)) {
@@ -2324,6 +2457,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			    sizeof(nv->model_number), "QLA23xx");
 		}
 	} else if (IS_QLA2200(ha)) {
+		/* Enable full duplex */
 		nv->firmware_options[0] |= BIT_2;
 		/*
 		 * 'Point-to-point preferred, else loop' is not a safe
@@ -2355,8 +2489,12 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	while (cnt--)
 		*dptr1++ = *dptr2++;
 
-	/* Use alternate WWN? */
-	if (nv->host_p[1] & BIT_7) {
+	/* For target mode.. */
+	if (ha->node_name_set) {
+		memcpy(icb->node_name, ha->tgt_node_name, WWN_SIZE);
+		icb->firmware_options[1] |= BIT_6;
+	} else if (nv->host_p[1] & BIT_7) {
+		/* Use alternate WWN? */
 		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
 		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
 	}
@@ -2493,6 +2631,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 		}
 	}
 
+out:
 	if (rval) {
 		DEBUG2_3(printk(KERN_WARNING
 		    "scsi(%ld): NVRAM configuration failed!\n", vha->host_no));
@@ -2505,14 +2644,22 @@ qla2x00_rport_del(void *data)
 {
 	fc_port_t *fcport = data;
 	struct fc_rport *rport;
+	scsi_qla_host_t *vha = fcport->vha;
 	unsigned long flags;
 
 	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
 	rport = fcport->drport ? fcport->drport: fcport->rport;
 	fcport->drport = NULL;
 	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
-	if (rport)
+	if (rport) {
 		fc_remote_port_delete(rport);
+		/*
+		 * Release the target mode FC NEXUS in qla2x_target.c code
+		 * if target mod is enabled.
+		 */
+		if (vha->hw->qla2x_tmpl)
+			qla_tgt_fc_port_deleted(vha, fcport);
+	}
 }
 
 /**
@@ -2895,6 +3042,13 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    "Unable to allocate fc remote port!\n");
 		return;
 	}
+	/*
+	 * Create target mode FC NEXUS in qla2x_target.c if target mode is
+	 * enabled..
+	 */
+	if (ha->qla2x_tmpl)
+		qla_tgt_fc_port_added(vha, fcport);
+
 	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
 	*((fc_port_t **)rport->dd_data) = fcport;
 	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
@@ -3162,6 +3316,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	struct scsi_qla_host *tvp;
 
 	rval = QLA_SUCCESS;
+	wrap.b24 = 0; /* undefined */
 
 	/* Try GID_PT to get device list, else GAN. */
 	swl = kcalloc(MAX_FIBRE_DEVICES, sizeof(sw_info_t), GFP_KERNEL);
@@ -3554,11 +3709,13 @@ qla2x00_device_resync(scsi_qla_host_t *vha)
 				continue;
 
 			if (atomic_read(&fcport->state) == FCS_ONLINE) {
-				if (format != 3 ||
-				    fcport->port_type != FCT_INITIATOR) {
+				if (vha->hw->qla2x_tmpl != NULL)
 					qla2x00_mark_device_lost(vha, fcport,
-					    0, 0);
-				}
+							0, 0);
+				else if ((format != 3) ||
+					   (fcport->port_type != FCT_INITIATOR))
+					qla2x00_mark_device_lost(vha, fcport,
+						0, 0);
 			}
 		}
 	}
@@ -3706,6 +3863,13 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 			if (mb[10] & BIT_1)
 				fcport->supported_classes |= FC_COS_CLASS3;
 
+			if (IS_FWI2_CAPABLE(ha)) {
+				if (mb[10] & BIT_7)
+					fcport->conf_compl_supported = 1;
+			} else {
+				/* mb[10] bits are undocumented, ToDo */
+			}
+
 			rval = QLA_SUCCESS;
 			break;
 		} else if (mb[0] == MBS_LOOP_ID_USED) {
@@ -4042,6 +4206,10 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 
 			vha->flags.online = 1;
 
+			/* Enable target response to SCSI bus. */
+			if (qla_tgt_mode_enabled(vha))
+				qla2x00_send_enable_lun(vha, true);
+
 			ha->isp_ops->enable_intrs(ha);
 
 			ha->isp_abort_cnt = 0;
@@ -4423,6 +4591,64 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		rval = 1;
 	}
 
+	/* Check if target mode enabled */
+	if (qla_tgt_mode_enabled(vha)) {
+		if (!ha->saved_set) {
+			/* We save only once */
+			ha->saved_exchange_count = nv->exchange_count;
+			ha->saved_firmware_options_1 = nv->firmware_options_1;
+			ha->saved_firmware_options_2 = nv->firmware_options_2;
+			ha->saved_firmware_options_3 = nv->firmware_options_3;
+			ha->saved_set = 1;
+		}
+
+		nv->exchange_count = __constant_cpu_to_le16(0xFFFF);
+
+		/* Enable target mode */
+		nv->firmware_options_1 |= __constant_cpu_to_le32(BIT_4);
+
+		/* Disable ini mode, if requested */
+		if (!qla_ini_mode_enabled(vha))
+			nv->firmware_options_1 |= __constant_cpu_to_le32(BIT_5);
+
+		/* Disable Full Login after LIP */
+		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_13);
+		/* Enable initial LIP */
+		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_9);
+		/* Enable FC tapes support */
+		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
+	} else {
+		if (ha->saved_set) {
+			nv->exchange_count = ha->saved_exchange_count;
+			nv->firmware_options_1 = ha->saved_firmware_options_1;
+			nv->firmware_options_2 = ha->saved_firmware_options_2;
+			nv->firmware_options_3 = ha->saved_firmware_options_3;
+		}
+	}
+
+	/* out-of-order frames reassembly */
+	nv->firmware_options_3 |= BIT_6|BIT_9;
+
+	if (ha->enable_class_2) {
+		if (vha->flags.init_done)
+			fc_host_supported_classes(vha->host) =
+				FC_COS_CLASS2 | FC_COS_CLASS3;
+
+		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_8);
+	} else {
+		if (vha->flags.init_done)
+			fc_host_supported_classes(vha->host) = FC_COS_CLASS3;
+
+		nv->firmware_options_2 &= ~__constant_cpu_to_le32(BIT_8);
+	}
+#if 0
+	/*
+	 * firmware_options_3 bits 3-2 are reserved, but for some reason
+	 * sometimes set by BIOS. Let's explicitly reset them.
+	 */
+	nv->firmware_options_3 &= ~__constant_cpu_to_le32(BIT_3|BIT_2);
+#endif
+
 	/* Reset Initialization control block */
 	memset(icb, 0, ha->init_cb_size);
 
@@ -4450,8 +4676,11 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	qla2x00_set_model_info(vha, nv->model_name, sizeof(nv->model_name),
 	    "QLA2462");
 
-	/* Use alternate WWN? */
-	if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
+	if (ha->node_name_set) {
+		memcpy(icb->node_name, ha->tgt_node_name, WWN_SIZE);
+		icb->firmware_options_1 |= __constant_cpu_to_le32(BIT_14);
+	} else if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
+		/* Use alternate WWN? */
 		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
 		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 4c1ba62..6e75dbb 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -5,14 +5,13 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 
 #include <scsi/scsi_tcq.h>
 
-static void qla2x00_isp_cmd(struct scsi_qla_host *, struct req_que *);
-
 static void qla25xx_set_que(srb_t *, struct rsp_que **);
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
@@ -518,13 +517,112 @@ qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 	return (ret);
 }
 
+/*
+ * qla2x00_issue_marker
+ *
+ * Issue marker
+ * Caller CAN have hardware lock held as specified by ha_locked parameter.
+ * Might release it, then reaquire.
+ */
+int qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
+{
+	if (ha_locked) {
+		if (__qla2x00_marker(vha, vha->req, vha->req->rsp, 0, 0,
+					MK_SYNC_ALL) != QLA_SUCCESS)
+			return QLA_FUNCTION_FAILED;
+	} else {
+		if (qla2x00_marker(vha, vha->req, vha->req->rsp, 0, 0,
+					MK_SYNC_ALL) != QLA_SUCCESS)
+			return QLA_FUNCTION_FAILED;
+	}
+	vha->marker_needed = 0;
+
+	return QLA_SUCCESS;
+}
+EXPORT_SYMBOL(qla2x00_issue_marker);
+
+/**
+ * qla2x00_req_pkt() - Retrieve a request packet from the request ring.
+ * @ha: HA context
+ *
+ * Note: The caller must hold the hardware lock before calling this routine.
+ * Might release it, then reaquire.
+ *
+ * Returns NULL if function failed, else, a pointer to the request packet.
+ */
+request_t *
+qla2x00_req_pkt(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	device_reg_t __iomem *reg = ha->iobase;
+	request_t *pkt = NULL;
+	uint32_t *dword_ptr, timer;
+	uint16_t req_cnt = 1, cnt;
+
+	/* Wait 1 second for slot. */
+	for (timer = HZ; timer; timer--) {
+		if ((req_cnt + 2) >= vha->req->cnt) {
+			/* Calculate number of free request entries. */
+			if (IS_FWI2_CAPABLE(ha))
+				cnt = (uint16_t)RD_REG_DWORD(&reg->isp24.req_q_out);
+			else
+				cnt = qla2x00_debounce_register(
+					ISP_REQ_Q_OUT(ha, &reg->isp));
+
+			if  (vha->req->ring_index < cnt)
+				vha->req->cnt = cnt - vha->req->ring_index;
+			else
+				vha->req->cnt = vha->req->length -
+					(vha->req->ring_index - cnt);
+		}
+
+		/* If room for request in request ring. */
+		if ((req_cnt + 2) < vha->req->cnt) {
+			vha->req->cnt--;
+			pkt = vha->req->ring_ptr;
+
+			/* Zero out packet. */
+			dword_ptr = (uint32_t *)pkt;
+			for (cnt = 0; cnt < REQUEST_ENTRY_SIZE / 4; cnt++)
+				*dword_ptr++ = 0;
+
+			/* Set system defined field. */
+			pkt->sys_define = (uint8_t)vha->req->ring_index;
+
+			/* Set entry count. */
+			pkt->entry_count = 1;
+
+			return pkt;
+		}
+
+		/* Release ring specific lock */
+		spin_unlock_irq(&ha->hardware_lock);
+
+		/* 2 us */
+		udelay(2);
+		/*
+		 * Check for pending interrupts, during init we issue marker directly
+		 */
+		if (!vha->marker_needed && !vha->flags.init_done)
+			qla2x00_poll(vha->req->rsp);
+
+		/* Reaquire ring specific lock */
+		spin_lock_irq(&ha->hardware_lock);
+	}
+
+	printk(KERN_INFO "Unable to locate request_t *pkt in ring\n");
+	dump_stack();
+
+	return NULL;
+}
+
 /**
  * qla2x00_isp_cmd() - Modify the request ring pointer.
  * @ha: HA context
  *
  * Note: The caller must hold the hardware lock before calling this routine.
  */
-static void
+void
 qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
 {
 	struct qla_hw_data *ha = vha->hw;
@@ -578,6 +676,7 @@ qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
 	}
 
 }
+EXPORT_SYMBOL(qla2x00_isp_cmd);
 
 /**
  * qla24xx_calc_iocbs() - Determine number of Command Type 3 and
@@ -1573,6 +1672,7 @@ skip_cmd_array:
 queuing_error:
 	return pkt;
 }
+EXPORT_SYMBOL(qla2x00_alloc_iocbs);
 
 static void
 qla2x00_start_iocbs(srb_t *sp)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d17ed9a..cfb58e1 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 #include <linux/delay.h>
 #include <linux/slab.h>
@@ -212,6 +213,12 @@ qla2300_intr_handler(int irq, void *dev_id)
 			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
 			qla2x00_async_event(vha, rsp, mb);
 			break;
+		case 0x17: /* FAST_CTIO_COMP */
+			mb[0] = MBA_CTIO_COMPLETION;
+			mb[1] = MSW(stat);
+			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
+			qla2x00_async_event(vha, rsp, mb);
+			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
 			    "(%d).\n",
@@ -304,6 +311,9 @@ qla81xx_idc_event(scsi_qla_host_t *vha, uint16_t aen, uint16_t descr)
 		    "IDC failed to post ACK.\n");
 }
 
+extern void qla2xxx_ctio_completion(scsi_qla_host_t *, uint32_t);
+extern void qla_tgt_async_event(uint16_t, scsi_qla_host_t *, uint16_t *);
+
 /**
  * qla2x00_async_event() - Process aynchronous events.
  * @ha: SCSI driver HA context
@@ -331,6 +341,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	if (IS_QLA8XXX_TYPE(ha))
 		goto skip_rio;
 	switch (mb[0]) {
+	case MBA_CTIO_COMPLETION:
 	case MBA_SCSI_COMPLETION:
 		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
 		handle_cnt = 1;
@@ -392,6 +403,10 @@ skip_rio:
 				handles[cnt]);
 		break;
 
+	case MBA_CTIO_COMPLETION:
+		qla2xxx_ctio_completion(vha, handles[0]);
+		break;
+
 	case MBA_RESET:			/* Reset */
 		DEBUG2(printk("scsi(%ld): Asynchronous RESET.\n",
 			vha->host_no));
@@ -446,12 +461,20 @@ skip_rio:
 
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
-
+#if 0
 	case MBA_WAKEUP_THRES:		/* Request Queue Wake-up */
 		DEBUG2(printk("scsi(%ld): Asynchronous WAKEUP_THRES.\n",
 		    vha->host_no));
 		break;
+#else
+	case MBA_ATIO_TRANSFER_ERR:	/* ATIO Queue Transfer Error */
+		DEBUG2(printk(KERN_INFO "scsi(%ld): ATIO Transfer Error.\n",
+					vha->host_no));
+		qla_printk(KERN_WARNING, ha, "ATIO Transfer Error.\n");
 
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		break;
+#endif
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
 		DEBUG2(printk("scsi(%ld): LIP occurred (%x).\n", vha->host_no,
 		    mb[1]));
@@ -677,6 +700,15 @@ skip_rio:
 			DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE "
 			    "ignored %04x/%04x/%04x.\n", vha->host_no, mb[1],
 			    mb[2], mb[3]));
+
+			DEBUG2(printk(KERN_INFO "scsi(%ld): ha state %d "
+				"init_done %d oper_mode %d topo %d\n",
+				vha->host_no, atomic_read(&vha->loop_state),
+				vha->flags.init_done, ha->operating_mode,
+				ha->current_topology));
+
+			if (ha->qla2x_tmpl)
+				qla_tgt_async_event(mb[0], vha, mb);
 			break;
 		}
 
@@ -697,6 +729,9 @@ skip_rio:
 
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+
+		if (ha->qla2x_tmpl)
+			qla_tgt_async_event(mb[0], vha, mb);
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
@@ -818,6 +853,36 @@ skip_rio:
 	case MBA_IDC_TIME_EXT:
 		qla81xx_idc_event(vha, mb[0], mb[1]);
 		break;
+	case MBA_LOOP_INIT_ERR:
+		printk(KERN_INFO "scsi(%ld): Loop init error received -- "
+			"%04x %04x %04x.\n", vha->host_no, mb[1], mb[2], mb[3]);
+		break;
+	default:
+		printk(KERN_INFO "scsi(%ld): Unhandled async event %d "
+			"received -- %04x %04x %04x.\n", vha->host_no,
+			mb[0], mb[1], mb[2], mb[3]);
+		break;
+	}
+
+	switch (mb[0]) {
+	case MBA_POINT_TO_POINT:	/* Point-to-Point */
+	case MBA_CHG_IN_CONNECTION:	/* Change in connection mode */
+		if (IS_QLA2100(ha))
+			break;
+		/* else go through */
+	case MBA_RESET:			/* Reset */
+	case MBA_SYSTEM_ERR:		/* System Error */
+	case MBA_REQ_TRANSFER_ERR:	/* Request Transfer Error */
+	case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
+	case MBA_ATIO_TRANSFER_ERR:	/* ATIO Queue Transfer Error */
+	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
+	case MBA_LOOP_UP:		/* Loop Up Event */
+	case MBA_LOOP_DOWN:		/* Loop Down Event */
+	case MBA_LIP_RESET:		/* LIP reset occurred */
+	default:
+		if (ha->qla2x_tmpl)
+			qla_tgt_async_event(mb[0], vha, mb);
+		break;
 	}
 
 	if (!vha->vp_idx && ha->num_vhosts)
@@ -836,6 +901,11 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (HANDLE_IS_CTIO_COMP(index)) {
+		qla2xxx_ctio_completion(vha, index);
+		return;
+	}
+
 	/* Validate handle. */
 	if (index >= MAX_OUTSTANDING_COMMANDS) {
 		DEBUG2(printk("scsi(%ld): Invalid SCSI completion handle %d.\n",
@@ -843,6 +913,7 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		qla_printk(KERN_WARNING, ha,
 		    "Invalid SCSI completion handle %d.\n", index);
 
+		DEBUG2(dump_stack());
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		return;
 	}
@@ -861,6 +932,7 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		qla_printk(KERN_WARNING, ha,
 		    "Invalid ISP SCSI completion handle\n");
 
+		DEBUG2(dump_stack());
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	}
 }
@@ -1320,6 +1392,8 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	iocb->done(sp);
 }
 
+extern void qla_tgt_response_pkt_all_vps(scsi_qla_host_t *, response_t *);
+
 /**
  * qla2x00_process_response_queue() - Process response queue entries.
  * @ha: SCSI driver HA context
@@ -1342,6 +1416,9 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (sts_entry_t *)rsp->ring_ptr;
 
+		DEBUG5(printk(KERN_INFO "%s(): IOCB data:\n", __func__));
+		DEBUG5(qla2x00_dump_buffer((uint8_t *)pkt, RESPONSE_ENTRY_SIZE));
+
 		rsp->ring_index++;
 		if (rsp->ring_index == rsp->length) {
 			rsp->ring_index = 0;
@@ -1354,13 +1431,37 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 			DEBUG3(printk(KERN_INFO
 			    "scsi(%ld): Process error entry.\n", vha->host_no));
 
-			qla2x00_error_entry(vha, rsp, pkt);
-			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
-			wmb();
-			continue;
+			switch (pkt->entry_type) {
+			case ACCEPT_TGT_IO_TYPE:
+			case CONTINUE_TGT_IO_TYPE:
+			case CTIO_A64_TYPE:
+			case IMMED_NOTIFY_TYPE:
+			case NOTIFY_ACK_TYPE:
+			case ENABLE_LUN_TYPE:
+			case MODIFY_LUN_TYPE:
+				break;
+			default:
+				((response_t *)pkt)->signature = RESPONSE_PROCESSED;
+				wmb();
+				continue;
+			}
 		}
 
 		switch (pkt->entry_type) {
+		case ACCEPT_TGT_IO_TYPE:
+		case CONTINUE_TGT_IO_TYPE:
+		case CTIO_A64_TYPE:
+		case IMMED_NOTIFY_TYPE:
+		case NOTIFY_ACK_TYPE:
+		case ENABLE_LUN_TYPE:
+		case MODIFY_LUN_TYPE:
+			DEBUG5(printk(KERN_WARNING "qla2x00_response_pkt: calling"
+				" tgt_response_pkt %p (type %02X)\n",
+				qla_target.tgt_response_pkt, pkt->entry_type););
+
+			if (vha->hw->qla2x_tmpl)
+				qla_tgt_response_pkt_all_vps(vha, (response_t *)pkt);
+			break;
 		case STATUS_TYPE:
 			qla2x00_status_entry(vha, rsp, pkt);
 			break;
@@ -1388,6 +1489,9 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 		case CT_IOCB_TYPE:
 			qla2x00_ct_entry(vha, rsp->req, pkt, CT_IOCB_TYPE);
 			break;
+		case MARKER_TYPE:
+			printk("Got MARKER_TYPE response packet!!\n");
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
@@ -1547,6 +1651,16 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	/* Fast path completion. */
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
+		DEBUG3(printk(KERN_WARNING "scsi(%ld): Status Type %#x:\n"
+			"  entry_count\t%d\n  entry_status\t%#x\n"
+			"  handle:\t%#x\n  scsi_status:\t%#x\n"
+			"  comp_status:\t%#x\n  state_flags:\t%#x\n"
+			"  status_flags:\t%#x\n", vha->host_no,
+			sts->entry_type, sts->entry_count,
+			sts->entry_status, sts->handle,
+			sts->scsi_status, sts->comp_status,
+			sts->state_flags, sts->status_flags));
+
 		qla2x00_process_completed_request(vha, req, handle);
 
 		return;
@@ -1870,9 +1984,12 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	uint16_t que = MSW(pkt->handle);
 	struct req_que *req = ha->req_q_map[que];
 #if defined(QL_DEBUG_LEVEL_2)
-	if (pkt->entry_status & RF_INV_E_ORDER)
+	qla_printk(KERN_ERR, ha, "%s: Error entry with type %x:\n", __func__,
+		pkt->entry_type);
+	if (pkt->entry_status & RF_INV_E_ORDER) {
 		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Order\n", __func__);
-	else if (pkt->entry_status & RF_INV_E_COUNT)
+		qla2x00_dump_buffer((void *)pkt, sizeof(*pkt));
+	} else if (pkt->entry_status & RF_INV_E_COUNT)
 		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Count\n", __func__);
 	else if (pkt->entry_status & RF_INV_E_PARAM)
 		qla_printk(KERN_ERR, ha,
@@ -1949,6 +2066,60 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 		DEBUG2_3(printk("%s(%ld): MBX pointer ERROR!\n",
 		    __func__, vha->host_no));
 	}
+
+#if defined(QL_DEBUG_LEVEL_1)
+	printk(KERN_INFO "scsi(%ld): Mailbox registers:", vha->host_no);
+	for (cnt = 0; cnt < vha->mbx_count; cnt++) {
+		if ((cnt % 4) == 0)
+			printk(KERN_CONT "\n");
+		printk("mbox %02d: 0x%04x   ", cnt, ha->mailbox_out[cnt]);
+	}
+	printk(KERN_CONT "\n");
+#endif
+}
+
+extern void qla24xx_atio_pkt_all_vps(struct scsi_qla_host *, atio7_entry_t *);
+
+/*
+ * qla24xx_process_atio_queue() - Process ATIO queue entries.
+ * @ha: SCSI driver HA context
+ */
+static void
+qla24xx_process_atio_queue(struct scsi_qla_host *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	atio_t *pkt;
+	int cnt, i;
+
+	if (!vha->flags.online)
+		return;
+
+	while (ha->atio_ring_ptr->signature != ATIO_PROCESSED) {
+		pkt = ha->atio_ring_ptr;
+		cnt = pkt->entry_count;
+
+		DEBUG5(printk(KERN_INFO "%s(): IOCB data:\n", __func__));
+		DEBUG5(qla2x00_dump_buffer((uint8_t *)pkt, RESPONSE_ENTRY_SIZE));
+
+		qla24xx_atio_pkt_all_vps(vha, (atio7_entry_t *)pkt);
+
+		for (i = 0; i < cnt; i++) {
+			ha->atio_ring_index++;
+			if (ha->atio_ring_index == ha->atio_q_length) {
+				ha->atio_ring_index = 0;
+				ha->atio_ring_ptr = ha->atio_ring;
+			} else
+				ha->atio_ring_ptr++;
+
+			pkt->signature = ATIO_PROCESSED;
+			pkt = ha->atio_ring_ptr;
+		}
+		wmb();
+	}
+
+	/* Adjust ring index */
+	WRT_REG_DWORD(&reg->atio_q_out, ha->atio_ring_index);
 }
 
 /**
@@ -1967,6 +2138,9 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 
+		DEBUG5(printk(KERN_INFO "%s(): IOCB data:\n", __func__));
+		DEBUG5(qla2x00_dump_buffer((uint8_t *)pkt, RESPONSE_ENTRY_SIZE));
+
 		rsp->ring_index++;
 		if (rsp->ring_index == rsp->length) {
 			rsp->ring_index = 0;
@@ -1980,9 +2154,18 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    "scsi(%ld): Process error entry.\n", vha->host_no));
 
 			qla2x00_error_entry(vha, rsp, (sts_entry_t *) pkt);
-			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
-			wmb();
-			continue;
+
+			switch (pkt->entry_type) {
+			case ABTS_RECV_24XX:
+			case ABTS_RESP_24XX:
+			case CTIO_TYPE7:
+			case NOTIFY_ACK_TYPE:
+				break;
+			default:
+				((response_t *)pkt)->signature = RESPONSE_PROCESSED;
+				wmb();
+				continue;
+			}
 		}
 
 		switch (pkt->entry_type) {
@@ -2011,6 +2194,18 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
                 case ELS_IOCB_TYPE:
 			qla24xx_els_ct_entry(vha, rsp->req, pkt, ELS_IOCB_TYPE);
 			break;
+		case ABTS_RECV_24XX:
+			/* ensure that the ATIO queue is empty */
+			qla24xx_process_atio_queue(vha);
+		case ABTS_RESP_24XX:
+		case CTIO_TYPE7:
+		case NOTIFY_ACK_TYPE:
+			
+			if (vha->hw->qla2x_tmpl)
+				qla_tgt_response_pkt_all_vps(vha, (response_t *)pkt);
+			break;
+		case MARKER_TYPE:
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
@@ -2156,6 +2351,13 @@ qla24xx_intr_handler(int irq, void *dev_id)
 		case 0x14:
 			qla24xx_process_response_queue(vha, rsp);
 			break;
+		case 0x1C: /* ATIO queue updated */
+			qla24xx_process_atio_queue(vha);
+			break;
+		case 0x1D: /* ATIO and response queues updated */
+			qla24xx_process_atio_queue(vha);
+			qla24xx_process_response_queue(vha, rsp);
+			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
 			    "(%d).\n",
@@ -2300,6 +2502,13 @@ qla24xx_msix_default(int irq, void *dev_id)
 		case 0x14:
 			qla24xx_process_response_queue(vha, rsp);
 			break;
+		case 0x1C: /* ATIO queue updated */
+			qla24xx_process_atio_queue(vha);
+			break;
+		case 0x1D: /* ATIO and response queues updated */
+			qla24xx_process_atio_queue(vha);
+			qla24xx_process_response_queue(vha, rsp);
+			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
 			    "(%d).\n",
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e473e9f..42bc647 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5,11 +5,11 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 #include <linux/delay.h>
 #include <linux/gfp.h>
 
-
 /*
  * qla2x00_mailbox_command
  *	Issue mailbox command and waits for completion.
@@ -29,7 +29,7 @@
  * Context:
  *	Kernel context.
  */
-static int
+int
 qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 {
 	int		rval;
@@ -1142,6 +1142,33 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
 	    vha->host_no));
 
+	if (!qla_tgt_mode_enabled(vha) && !qla_ini_mode_enabled(vha)) {
+		DEBUG11(printk("qla2x00_init_firmware(%ld): neither initiator, "
+			"nor target mode enabled, exiting\n", vha->host_no));
+		return QLA_SUCCESS;
+	}
+
+#ifdef QL_DEBUG_LEVEL_5
+	if (IS_FWI2_CAPABLE(ha)) {
+		struct init_cb_24xx *icb = (struct init_cb_24xx *)vha->init_cb;
+		DEBUG5(printk(KERN_INFO "%s(): firmware_options_1 %x, "
+			"firmware_options_2 %x, firmware_options_3 %x\n",
+			__func__, icb->firmware_options_1,
+			icb->firmware_options_2, icb->firmware_options_3));
+		DEBUG5(printk(KERN_INFO "%s(): Control Block:\n", __func__));
+		DEBUG5(qla2x00_dump_buffer((uint8_t *)icb, sizeof(*icb)));
+	} else {
+		init_cb_t *icb = (init_cb_t *)vha->init_cb;
+		DEBUG5(printk(KERN_INFO "%s(): firmware_options[0] %x, "
+			"firmware_options[1] %x, add_firmware_options[0] %x, "
+			"add_firmware_options[1] %x\n", __func__,
+			icb->firmware_options[0], icb->firmware_options[1],
+			icb->add_firmware_options[0],
+			icb->add_firmware_options[1]));
+		DEBUG5(printk(KERN_INFO "%s(): Control Block:\n", __func__));
+		DEBUG5(qla2x00_dump_buffer((uint8_t *)icb, sizeof(*icb)));
+	}
+#endif
 	if (IS_QLA82XX(ha) && ql2xdbwr)
 		qla82xx_wr_32(ha, ha->nxdb_wr_ptr,
 			(0x04 | (ha->portnum << 5) | (0 << 8) | (0 << 16)));
@@ -1187,6 +1214,100 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 }
 
 /*
+ * qla2x00_get_node_name_list
+ *      Issue get node name list mailbox command, kmalloc()
+ *      and return the resulting list. Caller must kfree() it!
+ *
+ * Input:
+ *      ha = adapter state pointer.
+ *      out_data = resulting list
+ *      out_len = length of the resulting list
+ *
+ * Returns:
+ *      qla2x00 local function return status code.
+ *
+ * Context:
+ *      Kernel context.
+ */
+int
+qla2x00_get_node_name_list(scsi_qla_host_t *vha, void **out_data, int *out_len)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_port24_data *list = NULL;
+	void *pmap;
+	mbx_cmd_t mc;
+	dma_addr_t pmap_dma;
+	ulong dma_size;
+	int rval, left;
+
+	BUILD_BUG_ON(sizeof(struct qla_port24_data) <
+			sizeof(struct qla_port23_data));
+
+	left = 1;
+	while (left > 0) {
+		dma_size = left * sizeof(*list);
+		pmap = dma_alloc_coherent(&ha->pdev->dev, dma_size,
+					 &pmap_dma, GFP_KERNEL);
+		if (!pmap) {
+			printk(KERN_ERR "%s(%ld): DMA Alloc failed of "
+				"%ld\n", __func__, vha->host_no, dma_size);
+			rval = QLA_MEMORY_ALLOC_FAILED;
+			goto out;
+		}
+
+		mc.mb[0] = MBC_PORT_NODE_NAME_LIST;
+		mc.mb[1] = BIT_1 | BIT_3;
+		mc.mb[2] = MSW(pmap_dma);
+		mc.mb[3] = LSW(pmap_dma);
+		mc.mb[6] = MSW(MSD(pmap_dma));
+		mc.mb[7] = LSW(MSD(pmap_dma));
+		mc.mb[8] = dma_size;
+		mc.out_mb = MBX_0|MBX_1|MBX_2|MBX_3|MBX_6|MBX_7|MBX_8;
+		mc.in_mb = MBX_0|MBX_1;
+		mc.tov = 30;
+		mc.flags = MBX_DMA_IN;
+
+		rval = qla2x00_mailbox_command(vha, &mc);
+		if (rval != QLA_SUCCESS) {
+			if ((mc.mb[0] == MBS_COMMAND_ERROR) &&
+			    (mc.mb[1] == 0xA)) {
+				if (IS_FWI2_CAPABLE(ha))
+					left += le16_to_cpu(mc.mb[2]) / sizeof(struct qla_port24_data);
+				else
+					left += le16_to_cpu(mc.mb[2]) / sizeof(struct qla_port23_data);
+				goto restart;
+			}
+			goto out_free;
+		}
+
+		left = 0;
+
+		list = kzalloc(dma_size, GFP_KERNEL);
+		if (!list) {
+			printk(KERN_ERR "%s(%ld): failed to allocate node names"
+				" list structure.\n", __func__, vha->host_no);
+			rval = QLA_MEMORY_ALLOC_FAILED;
+			goto out_free;
+		}
+
+		memcpy(list, pmap, dma_size);
+restart:
+		dma_free_coherent(&ha->pdev->dev, dma_size, pmap, pmap_dma);
+	}
+
+	*out_data = list;
+	*out_len = dma_size;
+
+out:
+	return rval;
+
+out_free:
+	dma_free_coherent(&ha->pdev->dev, dma_size, pmap, pmap_dma);
+	return rval;
+}
+EXPORT_SYMBOL(qla2x00_get_node_name_list);
+
+/*
  * qla2x00_get_port_database
  *	Issue normal/enhanced get port database mailbox command
  *	and copy device name as necessary.
@@ -1281,10 +1402,17 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		fcport->d_id.b.rsvd_1 = 0;
 
 		/* If not target must be initiator or unknown type. */
-		if ((pd24->prli_svc_param_word_3[0] & BIT_4) == 0)
-			fcport->port_type = FCT_INITIATOR;
-		else
+		if ((pd24->prli_svc_param_word_3[0] & BIT_4))
 			fcport->port_type = FCT_TARGET;
+		else if ((pd24->prli_svc_param_word_3[0] & BIT_5))
+			fcport->port_type = FCT_INITIATOR;
+
+		/* Passback COS information. */
+		fcport->supported_classes = (pd24->flags & PDF_CLASS_2) ?
+				FC_COS_CLASS2 : FC_COS_CLASS3;
+
+		if (pd24->prli_svc_param_word_3[0] & BIT_7)
+			fcport->conf_compl_supported = 1;
 	} else {
 		/* Check for logged in state. */
 		if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
@@ -1304,14 +1432,17 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		fcport->d_id.b.rsvd_1 = 0;
 
 		/* If not target must be initiator or unknown type. */
-		if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
-			fcport->port_type = FCT_INITIATOR;
-		else
+		if ((pd24->prli_svc_param_word_3[0] & BIT_4))
 			fcport->port_type = FCT_TARGET;
+		else if ((pd24->prli_svc_param_word_3[0] & BIT_5))
+			fcport->port_type = FCT_INITIATOR;
 
 		/* Passback COS information. */
 		fcport->supported_classes = (pd->options & BIT_4) ?
 		    FC_COS_CLASS2: FC_COS_CLASS3;
+
+		if (pd->prli_svc_param_word_3[0] & BIT_7)
+			fcport->conf_compl_supported = 1;
 	}
 
 gpd_error_out:
@@ -1326,6 +1457,7 @@ gpd_error_out:
 
 	return rval;
 }
+EXPORT_SYMBOL(qla2x00_get_port_database);
 
 /*
  * qla2x00_get_firmware_state
@@ -1684,6 +1816,8 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 			mb[10] |= BIT_0;	/* Class 2. */
 		if (lg->io_parameter[9] || lg->io_parameter[10])
 			mb[10] |= BIT_1;	/* Class 3. */
+		if (lg->io_parameter[0] & __constant_cpu_to_le32(BIT_7))
+			mb[10] |= BIT_7;	/* Confirmed Completion Allowed */
 	}
 
 	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
@@ -2033,6 +2167,8 @@ int
 qla2x00_get_id_list(scsi_qla_host_t *vha, void *id_list, dma_addr_t id_list_dma,
     uint16_t *entries)
 {
+
+	struct qla_hw_data *ha = vha->hw;
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
@@ -2061,7 +2197,14 @@ qla2x00_get_id_list(scsi_qla_host_t *vha, void *id_list, dma_addr_t id_list_dma,
 		mcp->out_mb |= MBX_6|MBX_3|MBX_2|MBX_1;
 	}
 	mcp->in_mb = MBX_1|MBX_0;
-	mcp->tov = MBX_TOV_SECONDS;
+
+	if (ha->qla2x_tmpl == NULL)
+		mcp->tov = MBX_TOV_SECONDS;
+	else {
+		mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
+		DEBUG11(printk("Using target mode mcp->tiov: %d\n", mcp->tov));
+	}
+
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 
@@ -2077,6 +2220,7 @@ qla2x00_get_id_list(scsi_qla_host_t *vha, void *id_list, dma_addr_t id_list_dma,
 
 	return rval;
 }
+EXPORT_SYMBOL(qla2x00_get_id_list);
 
 /*
  * qla2x00_get_resource_cnts
@@ -3010,6 +3154,17 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 	vpmod->vp_count = 1;
 	vpmod->vp_index1 = vha->vp_idx;
 	vpmod->options_idx1 = BIT_3|BIT_4|BIT_5;
+	/* Enable target mode */
+	if (qla_tgt_mode_enabled(vha)) {
+		DEBUG11(printk("MODE_TARGET enabled, clearing BIT_5\n"));
+		vpmod->options_idx1 &= ~BIT_5;
+	}
+	/* Disable ini mode, if requested */
+	if (!qla_ini_mode_enabled(vha)) {
+		DEBUG11(printk("MODE_INITIATOR disabled, clearing BIT_4\n"));
+		vpmod->options_idx1 &= ~BIT_4;
+	}
+
 	memcpy(vpmod->node_name_idx1, vha->node_name, WWN_SIZE);
 	memcpy(vpmod->port_name_idx1, vha->port_name, WWN_SIZE);
 	vpmod->entry_count = 1;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 2b69392..50a5c2a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -6,6 +6,7 @@
  */
 #include "qla_def.h"
 #include "qla_gbl.h"
+#include "qla_target.h"
 
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
@@ -48,6 +49,7 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_add_tail(&vha->list, &ha->vp_list);
+	ha->tgt_vp_map[vp_id].vha = vha;
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	mutex_unlock(&ha->vport_lock);
@@ -78,6 +80,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 		spin_lock_irqsave(&ha->vport_slock, flags);
 	}
 	list_del(&vha->list);
+	ha->tgt_vp_map[vha->vp_idx].vha = NULL;
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	vp_id = vha->vp_idx;
@@ -143,12 +146,16 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 int
 qla24xx_disable_vp(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	int ret;
 
 	ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 
+	/* Remove port id from vp target map */
+	ha->tgt_vp_map[vha->d_id.b.al_pa].idx = 0;
+
 	qla2x00_mark_vp_devices_dead(vha);
 	atomic_set(&vha->vp_state, VP_FAILED);
 	vha->flags.management_server_logged_in = 0;
@@ -266,6 +273,8 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 int
 qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 {
+	int ret;
+
 	/*
 	 * Physical port will do most of the abort and recovery work. We can
 	 * just treat it as a loop down
@@ -288,7 +297,17 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 
 	DEBUG15(printk("scsi(%ld): Scheduling enable of Vport %d...\n",
 	    vha->host_no, vha->vp_idx));
-	return qla24xx_enable_vp(vha);
+	ret = qla24xx_enable_vp(vha);
+	if (ret)
+		return ret;
+
+	/* Enable target response to SCSI bus. */
+	if (qla_tgt_mode_enabled(vha)) {
+		DEBUG15(printk("qla2x00_vp_abort_isp() calling qla2x00_send_enable_lun()\n"));
+		qla2x00_send_enable_lun(vha, true);
+	}
+
+	return 0;
 }
 
 static int
@@ -375,17 +394,22 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 	scsi_qla_host_t *vha;
 	uint8_t port_name[WWN_SIZE];
 
-	if (fc_vport->roles != FC_PORT_ROLE_FCP_INITIATOR)
+	if (fc_vport->roles != FC_PORT_ROLE_FCP_INITIATOR) {
+		DEBUG15(printk("fc_vport->roles != FC_PORT_ROLE_FCP_INITIATOR\n"));
 		return VPCERR_UNSUPPORTED;
+	}
 
 	/* Check up the F/W and H/W support NPIV */
-	if (!ha->flags.npiv_supported)
+	if (!ha->flags.npiv_supported) {
+		DEBUG15(printk("!ha->flags.npiv_supported\n"));
 		return VPCERR_UNSUPPORTED;
+	}
 
 	/* Check up whether npiv supported switch presented */
-	if (!(ha->switch_cap & FLOGI_MID_SUPPORT))
+	if (!(ha->switch_cap & FLOGI_MID_SUPPORT)) {
+		DEBUG15(printk("!(ha->switch_cap & FLOGI_MID_SUPPORT))\n"));
 		return VPCERR_NO_FABRIC_SUPP;
-
+	}
 	/* Check up unique WWPN */
 	u64_to_wwn(fc_vport->port_name, port_name);
 	if (!memcmp(port_name, base_vha->port_name, WWN_SIZE))
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f27724d..b1e2820 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
@@ -20,6 +21,12 @@
 #include <scsi/scsi_transport_fc.h>
 
 /*
+ * List of ha's and mutex protecting it.
+ */
+static LIST_HEAD(qla_ha_list);
+static DEFINE_MUTEX(qla_ha_list_mutex);
+
+/*
  * Driver version
  */
 char qla2x00_version_str[40];
@@ -59,6 +66,12 @@ module_param(ql2xloginretrycount, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
+int ql2xenableclass2;
+module_param(ql2xenableclass2, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xenableclass2,
+		"Specify if Class 2 operations are supported from the very "
+		"beginning.");
+
 int ql2xallocfwdump = 1;
 module_param(ql2xallocfwdump, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xallocfwdump,
@@ -208,6 +221,8 @@ struct scsi_host_template qla2xxx_driver_template = {
 
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla2x00_host_attrs,
+
+	.supported_mode		= MODE_INITIATOR | MODE_TARGET,
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
@@ -679,6 +694,7 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *vha)
 
 	return (return_status);
 }
+EXPORT_SYMBOL(qla2x00_wait_for_hba_online);
 
 /*
  * qla2x00_wait_for_reset_ready
@@ -768,7 +784,7 @@ qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
  *    Success (LOOP_READY) : 0
  *    Failed  (LOOP_NOT_READY) : 1
  */
-static inline int
+int
 qla2x00_wait_for_loop_ready(scsi_qla_host_t *vha)
 {
 	int 	 return_status = QLA_SUCCESS;
@@ -801,6 +817,38 @@ sp_get(struct srb *sp)
 	atomic_inc(&sp->ref_count);
 }
 
+void
+qla2xxx_abort_fcport_cmds(fc_port_t *fcport)
+{
+	scsi_qla_host_t *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp;
+	unsigned long flags;
+	int cnt;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		sp = vha->req->outstanding_cmds[cnt];
+		if (!sp)
+			continue;
+		if (sp->fcport != fcport)
+			continue;
+
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(sp)) {
+			DEBUG2(qla_printk(KERN_WARNING, ha,
+				"Abort failed --  %lx\n", sp->cmd->serial_number));
+		} else {
+			if (qla2x00_eh_wait_on_command(sp->cmd) != QLA_SUCCESS)
+				DEBUG2(qla_printk(KERN_WARNING, ha,
+					"Abort failed while waiting --  %lx\n",
+					sp->cmd->serial_number));
+		}
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
 /**************************************************************************
 * qla2xxx_eh_abort
 *
@@ -1939,6 +1987,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_out;
 	}
 	ha->pdev = pdev;
+	ha->enable_class_2 = ql2xenableclass2;
 
 	/* Clear our data area */
 	ha->bars = bars;
@@ -2010,6 +2059,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		req_length = REQUEST_ENTRY_CNT_24XX;
 		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
 		ha->gid_list_info_size = 8;
@@ -2024,6 +2074,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		req_length = REQUEST_ENTRY_CNT_24XX;
 		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
 		ha->gid_list_info_size = 8;
@@ -2064,6 +2115,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->nvram_data_off = FARX_ACCESS_NVRAM_DATA;
 	}
 
+	spin_lock_init(&ha->dpc_lock);
+
 	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
@@ -2108,7 +2161,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		base_vha->mgmt_svr_loop_id = MANAGEMENT_SERVER +
 						base_vha->vp_idx;
-
 	/* Set the SG table size based on ISP type */
 	if (!IS_FWI2_CAPABLE(ha)) {
 		if (IS_QLA2100(ha))
@@ -2131,6 +2183,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->transportt = qla2xxx_transport_template;
 	sht->vendor_id = (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC);
 
+        /* Set target mode init */
+	mutex_init(&ha->tgt_mutex);
+	mutex_init(&ha->tgt_host_action_mutex);
+	qla_tgt_clear_mode(base_vha);
+
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
@@ -2252,6 +2309,8 @@ skip_dpc:
 	base_vha->flags.init_done = 1;
 	base_vha->flags.online = 1;
 
+	ha->isp_ops->enable_intrs(ha);
+
 	scsi_scan_host(host);
 
 	qla2x00_alloc_sysfs_attr(base_vha);
@@ -2270,6 +2329,13 @@ skip_dpc:
 	    ha->flags.enable_64bit_addressing ? '+' : '-', base_vha->host_no,
 	    ha->isp_ops->fw_version_str(base_vha, fw_str));
 
+#warning FIXME: Check for target mode enabled bit before calling qla_tgt_add_target()
+	qla_tgt_add_target(ha, base_vha);
+
+	mutex_lock(&qla_ha_list_mutex);
+	list_add_tail(&ha->ha_list_entry, &qla_ha_list);
+	mutex_unlock(&qla_ha_list_mutex);
+
 	return 0;
 
 probe_init_failed:
@@ -2350,15 +2416,47 @@ qla2x00_shutdown(struct pci_dev *pdev)
 }
 
 static void
+qla2x00_stop_dpc_thread(scsi_qla_host_t *vha)
+{
+	struct task_struct *t = NULL;
+	struct qla_hw_data *ha = vha->hw;
+
+	spin_lock_irq(&ha->dpc_lock);
+	if (ha->dpc_thread != NULL) {
+		t = ha->dpc_thread;
+		/*
+		 * qla2xxx_wake_dpc checks for ->dpc_thread
+		 * so we need to zero it out.
+		 */
+		ha->dpc_thread = NULL;
+	}
+	spin_unlock_irq(&ha->dpc_lock);
+
+	if (t != NULL)
+		kthread_stop(t);
+}
+
+static void
 qla2x00_remove_one(struct pci_dev *pdev)
 {
 	scsi_qla_host_t *base_vha, *vha;
-	struct qla_hw_data  *ha;
+	struct qla_hw_data *ha;
 	unsigned long flags;
 
 	base_vha = pci_get_drvdata(pdev);
 	ha = base_vha->hw;
 
+	mutex_lock(&qla_ha_list_mutex);
+	list_del(&ha->ha_list_entry);
+	mutex_unlock(&qla_ha_list_mutex);
+
+	ha->host_shutting_down = 1;
+#warning FIXME: Check for target mode enabled bit before calling qla_tgt_remove_target()
+	qla_tgt_remove_target(ha, base_vha);
+
+	/* Necessary to prevent races with it */
+	qla2x00_stop_dpc_thread(base_vha);
+
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry(vha, &ha->vp_list, list) {
 		atomic_inc(&vha->vref_count);
@@ -2455,17 +2553,7 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 	if (vha->timer_active)
 		qla2x00_stop_timer(vha);
 
-	/* Kill the kernel thread for this host */
-	if (ha->dpc_thread) {
-		struct task_struct *t = ha->dpc_thread;
-
-		/*
-		 * qla2xxx_wake_dpc checks for ->dpc_thread
-		 * so we need to zero it out.
-		 */
-		ha->dpc_thread = NULL;
-		kthread_stop(t);
-	}
+	qla2x00_stop_dpc_thread(vha);
 
 	qla25xx_delete_queues(vha);
 
@@ -2634,10 +2722,26 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->init_cb)
 		goto fail;
 
+	/*
+	 * Setup qla_hw_data->tgt_vp_map
+	 */
+	if (IS_FWI2_CAPABLE(ha)) {
+		ha->tgt_vp_map = kzalloc(sizeof(struct qla_tgt_vp_map) *
+					MAX_MULTI_ID_FABRIC, GFP_KERNEL);
+		if (!ha->tgt_vp_map)
+			goto fail_free_init_cb;
+
+		ha->atio_ring = dma_alloc_coherent(&ha->pdev->dev,
+				(ha->atio_q_length + 1) * sizeof(atio_t),
+				&ha->atio_dma, GFP_KERNEL);
+		if (!ha->atio_ring)
+			goto fail_free_vp_map;
+	}
+
 	ha->gid_list = dma_alloc_coherent(&ha->pdev->dev, GID_LIST_SIZE,
 		&ha->gid_list_dma, GFP_KERNEL);
 	if (!ha->gid_list)
-		goto fail_free_init_cb;
+		goto fail_free_atio_ring;
 
 	ha->srb_mempool = mempool_create_slab_pool(SRB_MIN_REQ, srb_cachep);
 	if (!ha->srb_mempool)
@@ -2828,6 +2932,14 @@ fail_free_gid_list:
 	ha->gid_list_dma);
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
+fail_free_atio_ring:
+	dma_free_coherent(&ha->pdev->dev, (ha->atio_q_length + 1) *
+			sizeof(response_t), ha->atio_ring, ha->atio_dma);
+	ha->atio_ring = NULL;
+	ha->atio_dma = 0;
+fail_free_vp_map:
+	kfree(ha->tgt_vp_map);
+	ha->tgt_vp_map = NULL;
 fail_free_init_cb:
 	dma_free_coherent(&ha->pdev->dev, ha->init_cb_size, ha->init_cb,
 	ha->init_cb_dma);
@@ -2945,6 +3057,12 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	if (ha->ctx_mempool)
 		mempool_destroy(ha->ctx_mempool);
 
+	if (ha->atio_ring) {
+		dma_free_coherent(&ha->pdev->dev, (ha->atio_q_length + 1) * sizeof(atio_t),
+				ha->atio_ring, ha->atio_dma);
+	}
+	kfree(ha->tgt_vp_map);
+
 	if (ha->init_cb)
 		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
 			ha->init_cb, ha->init_cb_dma);
@@ -2973,6 +3091,10 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
+
+	ha->atio_ring = NULL;
+	ha->atio_dma = 0;
+	ha->tgt_vp_map = NULL;
 }
 
 struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
@@ -4109,6 +4231,11 @@ qla2x00_module_init(void)
 {
 	int ret = 0;
 
+	if (!qla_tgt_parse_ini_mode()) {
+		printk(KERN_ERR "qla_tgt_parse_ini_mode() failed\n");
+		return -EINVAL;
+	}
+
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
 	    SLAB_HWCACHE_ALIGN, NULL);
@@ -4118,6 +4245,13 @@ qla2x00_module_init(void)
 		return -ENOMEM;
 	}
 
+	/* Initialize target kmem_cache and mem_pools */
+	ret = qla_tgt_init();
+	if (ret < 0) {
+		kmem_cache_destroy(srb_cachep);
+		return ret;
+	}
+
 	/* Derive version string. */
 	strcpy(qla2x00_version_str, QLA2XXX_VERSION);
 	if (ql2xextended_error_logging)
@@ -4127,6 +4261,7 @@ qla2x00_module_init(void)
 	    fc_attach_transport(&qla2xxx_transport_functions);
 	if (!qla2xxx_transport_template) {
 		kmem_cache_destroy(srb_cachep);
+		qla_tgt_exit();
 		return -ENODEV;
 	}
 
@@ -4140,6 +4275,7 @@ qla2x00_module_init(void)
 	    fc_attach_transport(&qla2xxx_transport_vport_functions);
 	if (!qla2xxx_transport_vport_template) {
 		kmem_cache_destroy(srb_cachep);
+		qla_tgt_exit();
 		fc_release_transport(qla2xxx_transport_template);
 		return -ENODEV;
 	}
@@ -4149,6 +4285,7 @@ qla2x00_module_init(void)
 	ret = pci_register_driver(&qla2xxx_pci_driver);
 	if (ret) {
 		kmem_cache_destroy(srb_cachep);
+		qla_tgt_exit();
 		fc_release_transport(qla2xxx_transport_template);
 		fc_release_transport(qla2xxx_transport_vport_template);
 	}
@@ -4165,6 +4302,7 @@ qla2x00_module_exit(void)
 	pci_unregister_driver(&qla2xxx_pci_driver);
 	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
+	qla_tgt_exit();
 	if (ctx_cachep)
 		kmem_cache_destroy(ctx_cachep);
 	fc_release_transport(qla2xxx_transport_template);
-- 
1.7.4.1
