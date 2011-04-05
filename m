From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v3 2/3] qla2xxx: Enable 2xxx series LLD target mode support
Date: Mon,  4 Apr 2011 22:11:46 -0700
Message-ID: <1301980307-14778-3-git-send-email-nab@linux-iscsi.org>
References: <1301980307-14778-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm14.bullet.mail.ne1.yahoo.com ([98.138.90.77]:40562 "HELO
	nm14.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752705Ab1DEFMS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2011 01:12:18 -0400
In-Reply-To: <1301980307-14778-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Hannes
Cc: Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Ruediger Oertel <ro@suse.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch enables target mode support with the qla2xxx SCSI LLD using
qla_target.c logic introduced in commit f86d9fc734.  This includes:

*) Addition of target mode specific members to existing data
structures in qla_def.h and struct qla_hw_data->qla2x_tmpl using
qla_target.h:struct qla_target_template.

*) Addition of struct qla_target_template and direct calls into
qla_target.c logic w/ qla_tgt_* prefixed functions.

*) Addition of qla_iocb:qla2x00_req_pkt() for ring processing, and
qla2x00_issue_marker() for handling request/response queue processing
for target mode operation

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
 drivers/scsi/qla2xxx/qla_attr.c |    5 +-
 drivers/scsi/qla2xxx/qla_dbg.h  |   34 +++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |   63 +++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h  |    7 ++
 drivers/scsi/qla2xxx/qla_gs.c   |    4 +-
 drivers/scsi/qla2xxx/qla_init.c |   79 ++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_iocb.c |  105 ++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c  |   83 ++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  |  122 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mid.c  |   21 ++++++-
 drivers/scsi/qla2xxx/qla_os.c   |  107 +++++++++++++++++++++++++++++-----
 12 files changed, 595 insertions(+), 39 deletions(-)

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
index d3e58d7..5318478 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
@@ -1816,6 +1817,7 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 	fc_host_supported_speeds(vha->host) =
 		fc_host_supported_speeds(base_vha->host);
 
+	qla_tgt_vport_create(vha, ha);
 	qla24xx_vport_disable(fc_vport, disable);
 
 	if (ha->flags.cpu_affinity_enabled) {
@@ -2020,7 +2022,8 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
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
index 6c51c0a..465ea41 100644
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
+#define MBA_WAKEUP_THRES       0x8005  /* Request Queue Wake-up. */
 #define MBA_LIP_OCCURRED	0x8010	/* Loop Initialization Procedure */
 					/* occurred. */
 #define MBA_LOOP_UP		0x8011	/* FC Loop UP. */
@@ -1220,11 +1221,27 @@ typedef struct {
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
@@ -1707,6 +1724,9 @@ typedef struct fc_port {
 
 	uint16_t vp_idx;
 	uint8_t fc4_type;
+
+	/* True, if confirmed completion is supported */
+	uint8_t conf_compl_supported:1;
 } fc_port_t;
 
 /*
@@ -2812,6 +2832,39 @@ struct qla_hw_data {
 
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
@@ -2938,6 +2991,11 @@ typedef struct scsi_qla_host {
 	atomic_t	vref_count;
 } scsi_qla_host_t;
 
+struct qla_tgt_vp_map {
+	uint8_t	idx;
+	scsi_qla_host_t *vha;
+};
+
 /*
  * Macros to help code, maintain, etc.
  */
@@ -2961,7 +3019,6 @@ typedef struct scsi_qla_host {
 	atomic_dec(&__vha->vref_count);			     \
 } while (0)
 
-
 #define qla_printk(level, ha, format, arg...) \
 	dev_printk(level , &((ha)->pdev->dev) , format , ## arg)
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index d48326e..6c0a9e8 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -172,6 +172,7 @@ extern int  qla2x00_vp_abort_isp(scsi_qla_host_t *);
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
+
 extern uint16_t qla2x00_calc_iocbs_32(uint16_t);
 extern uint16_t qla2x00_calc_iocbs_64(uint16_t);
 extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
@@ -185,6 +186,9 @@ extern uint16_t qla24xx_calc_iocbs(uint16_t);
 extern void qla24xx_build_scsi_iocbs(srb_t *, struct cmd_type_7 *, uint16_t);
 extern int qla24xx_dif_start_scsi(srb_t *);
 
+extern void *qla2x00_alloc_iocbs(scsi_qla_host_t *, srb_t *);
+extern void qla2x00_isp_cmd(struct scsi_qla_host *, struct req_que *);
+extern int qla2x00_issue_marker(scsi_qla_host_t *, int);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
@@ -237,6 +241,9 @@ extern int
 qla2x00_init_firmware(scsi_qla_host_t *, uint16_t);
 
 extern int
+qla2x00_get_node_name_list(scsi_qla_host_t *, void **, int *);
+
+extern int
 qla2x00_get_port_database(scsi_qla_host_t *, fc_port_t *, uint8_t);
 
 extern int
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 74a91b6..e5f33ad 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 static int qla2x00_sns_ga_nxt(scsi_qla_host_t *, fc_port_t *);
 static int qla2x00_sns_gid_pt(scsi_qla_host_t *, sw_info_t *);
@@ -548,7 +549,8 @@ qla2x00_rff_id(scsi_qla_host_t *vha)
 	ct_req->req.rff_id.port_id[1] = vha->d_id.b.area;
 	ct_req->req.rff_id.port_id[2] = vha->d_id.b.al_pa;
 
-	ct_req->req.rff_id.fc4_feature = BIT_1;
+	qla_tgt_rff_id(vha, ct_req);
+
 	ct_req->req.rff_id.fc4_type = 0x08;		/* SCSI - FCP */
 
 	/* Execute MS IOCB */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8575808..129a487 100644
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
@@ -580,6 +584,9 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))
 		qla24xx_read_fcp_prio_cfg(vha);
 
+	if (rval == QLA_SUCCESS)
+		qla_tgt_initialize_adapter(vha, ha);
+
 	return (rval);
 }
 
@@ -1733,6 +1740,12 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
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
@@ -1774,6 +1787,8 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
 		WRT_REG_DWORD(&reg->isp24.rsp_q_in, 0);
 		WRT_REG_DWORD(&reg->isp24.rsp_q_out, 0);
 	}
+	qla_tgt_24xx_config_rings(vha, reg);
+
 	/* PCI posting */
 	RD_REG_DWORD(&ioreg->hccr);
 }
@@ -1835,6 +1850,11 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 
 	spin_unlock(&ha->vport_slock);
 
+	ha->atio_ring_ptr = ha->atio_ring;
+	ha->atio_ring_index = 0;
+	/* Initialize ATIO queue entries */
+	qla_tgt_init_atio_q_entries(vha);
+
 	ha->isp_ops->config_rings(vha);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -2097,6 +2117,8 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	vha->d_id.b.area = area;
 	vha->d_id.b.al_pa = al_pa;
 
+	ha->tgt_vp_map[al_pa].idx = vha->vp_idx;
+
 	if (!vha->flags.init_done)
  		qla_printk(KERN_INFO, ha,
 		    "Topology - %s, Host Loop address 0x%x\n",
@@ -2296,21 +2318,31 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	}
 #endif
 
+	qla_tgt_2x00_config_nvram_stage1(vha, nv);
+
 	/* Reset Initialization control block */
 	memset(icb, 0, ha->init_cb_size);
 
 	/*
 	 * Setup driver NVRAM options.
 	 */
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
-		nv->firmware_options[0] &= ~BIT_6;
+		/* out-of-order frames rassembly */
+		nv->special_options[0] |= BIT_6;
+		/* P2P preferred, otherwise loop */
 		nv->add_firmware_options[1] |= BIT_5 | BIT_4;
 
 		if (IS_QLA2300(ha)) {
@@ -2324,6 +2356,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			    sizeof(nv->model_number), "QLA23xx");
 		}
 	} else if (IS_QLA2200(ha)) {
+		/* Enable full duplex */
 		nv->firmware_options[0] |= BIT_2;
 		/*
 		 * 'Point-to-point preferred, else loop' is not a safe
@@ -2355,12 +2388,14 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	while (cnt--)
 		*dptr1++ = *dptr2++;
 
-	/* Use alternate WWN? */
 	if (nv->host_p[1] & BIT_7) {
+		/* Use alternate WWN? */
 		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
 		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
 	}
 
+	qla_tgt_2x00_config_nvram_stage2(vha, icb);
+
 	/* Prepare nodename */
 	if ((icb->firmware_options[1] & BIT_6) == 0) {
 		/*
@@ -2505,14 +2540,21 @@ qla2x00_rport_del(void *data)
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
+		qla_tgt_fc_port_deleted(vha, fcport);
+	}
 }
 
 /**
@@ -2895,6 +2937,12 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    "Unable to allocate fc remote port!\n");
 		return;
 	}
+	/*
+	 * Create target mode FC NEXUS in qla2x_target.c if target mode is
+	 * enabled..
+	 */
+	qla_tgt_fc_port_added(vha, fcport);
+
 	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
 	*((fc_port_t **)rport->dd_data) = fcport;
 	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
@@ -3554,11 +3602,13 @@ qla2x00_device_resync(scsi_qla_host_t *vha)
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
@@ -3706,6 +3756,13 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
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
@@ -4067,6 +4124,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 
 			vha->flags.online = 1;
 
+			qla_tgt_abort_isp(vha);
+
 			ha->isp_ops->enable_intrs(ha);
 
 			ha->isp_abort_cnt = 0;
@@ -4448,6 +4507,8 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		rval = 1;
 	}
 
+	qla_tgt_24xx_config_nvram_stage1(vha, nv);
+
 	/* Reset Initialization control block */
 	memset(icb, 0, ha->init_cb_size);
 
@@ -4475,8 +4536,10 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	qla2x00_set_model_info(vha, nv->model_name, sizeof(nv->model_name),
 	    "QLA2462");
 
-	/* Use alternate WWN? */
+	qla_tgt_24xx_config_nvram_stage2(vha, icb);
+
 	if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
+		/* Use alternate WWN? */
 		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
 		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d78d589..214bcdf 100644
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
@@ -534,13 +533,111 @@ qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
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
@@ -594,6 +691,7 @@ qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
 	}
 
 }
+EXPORT_SYMBOL(qla2x00_isp_cmd);
 
 /**
  * qla24xx_calc_iocbs() - Determine number of Command Type 3 and
@@ -1621,6 +1719,7 @@ skip_cmd_array:
 queuing_error:
 	return pkt;
 }
+EXPORT_SYMBOL(qla2x00_alloc_iocbs);
 
 static void
 qla2x00_start_iocbs(srb_t *sp)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d17ed9a..f50b157 100644
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
@@ -331,6 +338,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	if (IS_QLA8XXX_TYPE(ha))
 		goto skip_rio;
 	switch (mb[0]) {
+	case MBA_CTIO_COMPLETION:
 	case MBA_SCSI_COMPLETION:
 		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
 		handle_cnt = 1;
@@ -392,6 +400,10 @@ skip_rio:
 				handles[cnt]);
 		break;
 
+	case MBA_CTIO_COMPLETION:
+		qla_tgt_ctio_completion(vha, handles[0]);
+		break;
+
 	case MBA_RESET:			/* Reset */
 		DEBUG2(printk("scsi(%ld): Asynchronous RESET.\n",
 			vha->host_no));
@@ -450,8 +462,10 @@ skip_rio:
 	case MBA_WAKEUP_THRES:		/* Request Queue Wake-up */
 		DEBUG2(printk("scsi(%ld): Asynchronous WAKEUP_THRES.\n",
 		    vha->host_no));
-		break;
 
+		if (qla_tgt_mode_enabled(vha))
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		break;
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
 		DEBUG2(printk("scsi(%ld): LIP occurred (%x).\n", vha->host_no,
 		    mb[1]));
@@ -677,6 +691,8 @@ skip_rio:
 			DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE "
 			    "ignored %04x/%04x/%04x.\n", vha->host_no, mb[1],
 			    mb[2], mb[3]));
+
+			qla_tgt_async_event(mb[0], vha, mb);
 			break;
 		}
 
@@ -697,6 +713,8 @@ skip_rio:
 
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+
+		qla_tgt_async_event(mb[0], vha, mb);
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
@@ -820,6 +838,8 @@ skip_rio:
 		break;
 	}
 
+	qla_tgt_async_event(mb[0], vha, mb);
+
 	if (!vha->vp_idx && ha->num_vhosts)
 		qla2x00_alert_all_vps(rsp, mb);
 }
@@ -836,6 +856,11 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (HANDLE_IS_CTIO_COMP(index)) {
+		qla_tgt_ctio_completion(vha, index);
+		return;
+	}
+
 	/* Validate handle. */
 	if (index >= MAX_OUTSTANDING_COMMANDS) {
 		DEBUG2(printk("scsi(%ld): Invalid SCSI completion handle %d.\n",
@@ -1342,6 +1367,9 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (sts_entry_t *)rsp->ring_ptr;
 
+		DEBUG5(printk(KERN_INFO "%s(): IOCB data:\n", __func__));
+		DEBUG5(qla2x00_dump_buffer((uint8_t *)pkt, RESPONSE_ENTRY_SIZE));
+
 		rsp->ring_index++;
 		if (rsp->ring_index == rsp->length) {
 			rsp->ring_index = 0;
@@ -1355,12 +1383,29 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 			    "scsi(%ld): Process error entry.\n", vha->host_no));
 
 			qla2x00_error_entry(vha, rsp, pkt);
+
+			if (qla_tgt_2x00_process_response_error(vha, pkt) == 1)
+				break;
+
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
 			continue;
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
+			qla_tgt_response_pkt_all_vps(vha, (response_t *)pkt);
+			break;
 		case STATUS_TYPE:
 			qla2x00_status_entry(vha, rsp, pkt);
 			break;
@@ -1949,6 +1994,16 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
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
 }
 
 /**
@@ -1980,6 +2035,10 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    "scsi(%ld): Process error entry.\n", vha->host_no));
 
 			qla2x00_error_entry(vha, rsp, (sts_entry_t *) pkt);
+
+			if (qla_tgt_24xx_process_response_error(vha, pkt) == 1)
+				break;
+
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
 			continue;
@@ -2011,6 +2070,14 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
                 case ELS_IOCB_TYPE:
 			qla24xx_els_ct_entry(vha, rsp->req, pkt, ELS_IOCB_TYPE);
 			break;
+		case ABTS_RECV_24XX:
+			/* ensure that the ATIO queue is empty */
+			qla_tgt_24xx_process_atio_queue(vha);
+		case ABTS_RESP_24XX:
+		case CTIO_TYPE7:
+		case NOTIFY_ACK_TYPE:
+			qla_tgt_response_pkt_all_vps(vha, (response_t *)pkt);
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
@@ -2156,6 +2223,13 @@ qla24xx_intr_handler(int irq, void *dev_id)
 		case 0x14:
 			qla24xx_process_response_queue(vha, rsp);
 			break;
+		case 0x1C: /* ATIO queue updated */
+			qla_tgt_24xx_process_atio_queue(vha);
+			break;
+		case 0x1D: /* ATIO and response queues updated */
+			qla_tgt_24xx_process_atio_queue(vha);
+			qla24xx_process_response_queue(vha, rsp);
+			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
 			    "(%d).\n",
@@ -2300,6 +2374,13 @@ qla24xx_msix_default(int irq, void *dev_id)
 		case 0x14:
 			qla24xx_process_response_queue(vha, rsp);
 			break;
+		case 0x1C: /* ATIO queue updated */
+			qla_tgt_24xx_process_atio_queue(vha);
+			break;
+		case 0x1D: /* ATIO and response queues updated */
+			qla_tgt_24xx_process_atio_queue(vha);
+			qla24xx_process_response_queue(vha, rsp);
+			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
 			    "(%d).\n",
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7a7c0ec..0cd32b7 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 #include <linux/delay.h>
 #include <linux/gfp.h>
@@ -1187,6 +1188,99 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
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
+
+/*
  * qla2x00_get_port_database
  *	Issue normal/enhanced get port database mailbox command
  *	and copy device name as necessary.
@@ -1281,10 +1375,17 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
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
@@ -1304,14 +1405,17 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
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
@@ -1326,6 +1430,7 @@ gpd_error_out:
 
 	return rval;
 }
+EXPORT_SYMBOL(qla2x00_get_port_database);
 
 /*
  * qla2x00_get_firmware_state
@@ -1684,6 +1789,8 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 			mb[10] |= BIT_0;	/* Class 2. */
 		if (lg->io_parameter[9] || lg->io_parameter[10])
 			mb[10] |= BIT_1;	/* Class 3. */
+		if (lg->io_parameter[0] & __constant_cpu_to_le32(BIT_7))
+			mb[10] |= BIT_7;	/* Confirmed Completion Allowed */
 	}
 
 	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
@@ -3007,6 +3114,9 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 	vpmod->vp_count = 1;
 	vpmod->vp_index1 = vha->vp_idx;
 	vpmod->options_idx1 = BIT_3|BIT_4|BIT_5;
+
+	qla_tgt_modify_vp_config(vha, vpmod);
+
 	memcpy(vpmod->node_name_idx1, vha->node_name, WWN_SIZE);
 	memcpy(vpmod->port_name_idx1, vha->port_name, WWN_SIZE);
 	vpmod->entry_count = 1;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 2b69392..b91a50a 100644
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
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 75a966c..7f29370 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_target.h"
 
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
@@ -36,6 +37,12 @@ static struct kmem_cache *srb_cachep;
  */
 static struct kmem_cache *ctx_cachep;
 
+int ql2xenableclass2;
+module_param(ql2xenableclass2, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xenableclass2,
+		"Specify if Class 2 operations are supported from the very "
+		"beginning.");
+
 int ql2xlogintimeout = 20;
 module_param(ql2xlogintimeout, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xlogintimeout,
@@ -208,6 +215,8 @@ struct scsi_host_template qla2xxx_driver_template = {
 
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla2x00_host_attrs,
+
+	.supported_mode		= MODE_INITIATOR | MODE_TARGET,
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
@@ -758,7 +767,7 @@ qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
  *    Success (LOOP_READY) : 0
  *    Failed  (LOOP_NOT_READY) : 1
  */
-static inline int
+static int
 qla2x00_wait_for_loop_ready(scsi_qla_host_t *vha)
 {
 	int 	 return_status = QLA_SUCCESS;
@@ -791,6 +800,38 @@ sp_get(struct srb *sp)
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
@@ -1940,6 +1981,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_out;
 	}
 	ha->pdev = pdev;
+	ha->enable_class_2 = ql2xenableclass2;
 
 	/* Clear our data area */
 	ha->bars = bars;
@@ -2011,6 +2053,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		req_length = REQUEST_ENTRY_CNT_24XX;
 		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
 		ha->gid_list_info_size = 8;
@@ -2025,6 +2068,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		req_length = REQUEST_ENTRY_CNT_24XX;
 		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
 		ha->gid_list_info_size = 8;
@@ -2132,6 +2176,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->transportt = qla2xxx_transport_template;
 	sht->vendor_id = (SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC);
 
+	qla_tgt_probe_one_stage1(base_vha, ha);
+
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
@@ -2271,6 +2317,8 @@ skip_dpc:
 	    ha->flags.enable_64bit_addressing ? '+' : '-', base_vha->host_no,
 	    ha->isp_ops->fw_version_str(base_vha, fw_str));
 
+	qla_tgt_add_target(ha, base_vha);
+
 	return 0;
 
 probe_init_failed:
@@ -2351,15 +2399,33 @@ qla2x00_shutdown(struct pci_dev *pdev)
 }
 
 static void
+qla2x00_stop_dpc_thread(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct task_struct *t = ha->dpc_thread;
+
+	if (ha->dpc_thread == NULL)
+		return;
+	/*
+	 * qla2xxx_wake_dpc checks for ->dpc_thread
+	 * so we need to zero it out.
+	 */
+	ha->dpc_thread = NULL;
+	kthread_stop(t);
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
 
+	ha->host_shutting_down = 1;
+
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry(vha, &ha->vp_list, list) {
 		atomic_inc(&vha->vref_count);
@@ -2408,6 +2474,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 		ha->dpc_thread = NULL;
 		kthread_stop(t);
 	}
+	qla_tgt_remove_target(ha, base_vha);
 
 	qla2x00_free_sysfs_attr(base_vha);
 
@@ -2456,17 +2523,7 @@ qla2x00_free_device(scsi_qla_host_t *vha)
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
 
@@ -2635,10 +2692,13 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->init_cb)
 		goto fail;
 
+	if (qla_tgt_mem_alloc(ha) < 0)
+		goto fail_free_init_cb;
+
 	ha->gid_list = dma_alloc_coherent(&ha->pdev->dev, GID_LIST_SIZE,
 		&ha->gid_list_dma, GFP_KERNEL);
 	if (!ha->gid_list)
-		goto fail_free_init_cb;
+		goto fail_free_tgt_mem;
 
 	ha->srb_mempool = mempool_create_slab_pool(SRB_MIN_REQ, srb_cachep);
 	if (!ha->srb_mempool)
@@ -2829,6 +2889,8 @@ fail_free_gid_list:
 	ha->gid_list_dma);
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
+fail_free_tgt_mem:
+	qla_tgt_mem_free(ha);
 fail_free_init_cb:
 	dma_free_coherent(&ha->pdev->dev, ha->init_cb_size, ha->init_cb,
 	ha->init_cb_dma);
@@ -2946,6 +3008,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	if (ha->ctx_mempool)
 		mempool_destroy(ha->ctx_mempool);
 
+	qla_tgt_mem_free(ha);
+
 	if (ha->init_cb)
 		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
 			ha->init_cb, ha->init_cb_dma);
@@ -2974,6 +3038,10 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 
 	ha->gid_list = NULL;
 	ha->gid_list_dma = 0;
+
+	ha->atio_ring = NULL;
+	ha->atio_dma = 0;
+	ha->tgt_vp_map = NULL;
 }
 
 struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
@@ -4119,6 +4187,13 @@ qla2x00_module_init(void)
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
@@ -4128,6 +4203,7 @@ qla2x00_module_init(void)
 	    fc_attach_transport(&qla2xxx_transport_functions);
 	if (!qla2xxx_transport_template) {
 		kmem_cache_destroy(srb_cachep);
+		qla_tgt_exit();
 		return -ENODEV;
 	}
 
@@ -4141,6 +4217,7 @@ qla2x00_module_init(void)
 	    fc_attach_transport(&qla2xxx_transport_vport_functions);
 	if (!qla2xxx_transport_vport_template) {
 		kmem_cache_destroy(srb_cachep);
+		qla_tgt_exit();
 		fc_release_transport(qla2xxx_transport_template);
 		return -ENODEV;
 	}
@@ -4150,6 +4227,7 @@ qla2x00_module_init(void)
 	ret = pci_register_driver(&qla2xxx_pci_driver);
 	if (ret) {
 		kmem_cache_destroy(srb_cachep);
+		qla_tgt_exit();
 		fc_release_transport(qla2xxx_transport_template);
 		fc_release_transport(qla2xxx_transport_vport_template);
 	}
@@ -4166,6 +4244,7 @@ qla2x00_module_exit(void)
 	pci_unregister_driver(&qla2xxx_pci_driver);
 	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
+	qla_tgt_exit();
 	if (ctx_cachep)
 		kmem_cache_destroy(ctx_cachep);
 	fc_release_transport(qla2xxx_transport_template);
-- 
1.7.4.3

