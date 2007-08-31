From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 4/5] qla2xxx: add target mode support
Date: Sat, 01 Sep 2007 02:03:23 +0900
Message-ID: <200708311703.l7VH3NkK016220@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47081 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965351AbXHaRDu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 13:03:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, andrew.vasquez@qlogic.com, hare@suse.de, fujita.tomonori@lab.ntt.co.jp

This adds target mode support to qla2xxx.

With set ql2enable_target_mode module parameter to 1, the driver runs
in target mode. By default, ql2enable_target_mode is set to 0, and the
driver should work in initiator mode as before.

The driver could support dual-mode in the future but it doesn't at the
moment (we need to add dual-mode support tgt first).

It is based on scst qla2xxx target mode driver. Mike converted the
driver to use tgt long ago. I changed it to use the latest (mainline)
version of qla2xxx driver and tgt, and also converted it to use fc
transport class.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla2xxx/Kconfig        |    6 +
 drivers/scsi/qla2xxx/Makefile       |    1 +
 drivers/scsi/qla2xxx/qla_attr.c     |    4 +
 drivers/scsi/qla2xxx/qla_def.h      |    4 +
 drivers/scsi/qla2xxx/qla_gbl.h      |    4 +
 drivers/scsi/qla2xxx/qla_gs.c       |    5 +-
 drivers/scsi/qla2xxx/qla_init.c     |    8 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |    9 +-
 drivers/scsi/qla2xxx/qla_isr.c      |   47 ++-
 drivers/scsi/qla2xxx/qla_mbx.c      |   12 +-
 drivers/scsi/qla2xxx/qla_os.c       |   49 ++-
 drivers/scsi/qla2xxx/qla_tgt.c      | 1194 +++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_tgt.h      |  137 ++++
 drivers/scsi/qla2xxx/qla_tgt_priv.h |  338 ++++++++++
 14 files changed, 1800 insertions(+), 18 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_tgt.c
 create mode 100644 drivers/scsi/qla2xxx/qla_tgt.h
 create mode 100644 drivers/scsi/qla2xxx/qla_tgt_priv.h

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 8c865b9..1b81ade 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -24,3 +24,9 @@ config SCSI_QLA_FC
 	Firmware images can be retrieved from:
 
 		ftp://ftp.qlogic.com/outgoing/linux/firmware/
+
+config SCSI_QLA_FC_TGT
+	bool "QLogic QLA2XXX Fibre Channel target mode Support"
+	depends on SCSI_QLA_FC && SCSI_FC_TGT_ATTRS
+	help
+		Builds in target mode support into qla2xxx driver.
diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index 71ddb5d..aec8e4c 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -2,3 +2,4 @@ qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
 		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o
 
 obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
+qla2xxx-$(CONFIG_SCSI_QLA_FC_TGT) +=	qla_tgt.o
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 0f2a9f5..5827f6f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_tgt.h"
 
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
@@ -1131,6 +1132,9 @@ struct fc_function_template qla2xxx_transport_functions = {
 	.vport_create = qla24xx_vport_create,
 	.vport_disable = qla24xx_vport_disable,
 	.vport_delete = qla24xx_vport_delete,
+
+	.tsk_mgmt_response = q2t_tsk_mgmt_response,
+	.it_nexus_response = q2t_it_nexus_response,
 };
 
 struct fc_function_template qla2xxx_transport_vport_functions = {
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 27ae3a5..dca3293 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2532,6 +2532,10 @@ typedef struct scsi_qla_host {
 #define VP_ERR_ADAP_NORESOURCES	5
 	int		max_npiv_vports;	/* 63 or 125 per topoloty */
 	int		cur_vport_count;
+
+	struct q2t_cmd	*cmds[MAX_OUTSTANDING_COMMANDS];
+	uint16_t	current_cmd;
+	struct q2t_tgt 	*tgt;
 } scsi_qla_host_t;
 
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index aa1e411..9e54ecb 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -50,6 +50,9 @@ extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
 extern void qla2x00_alloc_fw_dump(scsi_qla_host_t *);
 extern void qla2x00_try_to_stop_firmware(scsi_qla_host_t *);
 
+extern request_t *qla2x00_req_pkt(scsi_qla_host_t *);
+extern void qla2x00_isp_cmd(scsi_qla_host_t *);
+
 /*
  * Global Data in qla_os.c source file.
  */
@@ -64,6 +67,7 @@ extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
 extern int num_hosts;
+extern int ql2enable_target_mode;
 
 /*
  * Global Functions in qla_mid.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index b06cbb8..75305f7 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -544,7 +544,10 @@ qla2x00_rff_id(scsi_qla_host_t *ha)
 	ct_req->req.rff_id.port_id[1] = ha->d_id.b.area;
 	ct_req->req.rff_id.port_id[2] = ha->d_id.b.al_pa;
 
-	ct_req->req.rff_id.fc4_feature = BIT_1;
+	if (ql2enable_target_mode)
+		ct_req->req.rff_id.fc4_feature = BIT_0 | BIT_1;
+	else
+		ct_req->req.rff_id.fc4_feature = BIT_1;
 	ct_req->req.rff_id.fc4_type = 0x08;		/* SCSI - FCP */
 
 	/* Execute MS IOCB */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2a1bf3f..c11f631 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_tgt.h"
 
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
@@ -116,6 +117,8 @@ qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 			return (rval);
 	}
 	rval = qla2x00_init_rings(ha);
+	if (!rval)
+		qla2x00_en_dis_lun(ha, ql2enable_target_mode);
 
 	return (rval);
 }
@@ -1563,7 +1566,10 @@ qla2x00_nvram_config(scsi_qla_host_t *ha)
 	 * Setup driver NVRAM options.
 	 */
 	nv->firmware_options[0] |= (BIT_6 | BIT_1);
-	nv->firmware_options[0] &= ~(BIT_5 | BIT_4);
+	if (ql2enable_target_mode)
+		nv->firmware_options[0] |= BIT_4;
+	else
+		nv->firmware_options[0] &= ~BIT_4;
 	nv->firmware_options[1] |= (BIT_5 | BIT_0);
 	nv->firmware_options[1] &= ~BIT_4;
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 3a5e78c..1540c59 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -11,11 +11,11 @@
 
 #include <scsi/scsi_tcq.h>
 
+#include "qla_tgt.h"
+
 static inline uint16_t qla2x00_get_cmd_direction(struct scsi_cmnd *cmd);
 static inline cont_entry_t *qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *);
 static inline cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *);
-static request_t *qla2x00_req_pkt(scsi_qla_host_t *ha);
-static void qla2x00_isp_cmd(scsi_qla_host_t *ha);
 
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
@@ -473,7 +473,7 @@ qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
  *
  * Returns NULL if function failed, else, a pointer to the request packet.
  */
-static request_t *
+request_t *
 qla2x00_req_pkt(scsi_qla_host_t *ha)
 {
 	device_reg_t __iomem *reg = ha->iobase;
@@ -543,8 +543,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
  *
  * Note: The caller must hold the hardware lock before calling this routine.
  */
-static void
-qla2x00_isp_cmd(scsi_qla_host_t *ha)
+void qla2x00_isp_cmd(scsi_qla_host_t *ha)
 {
 	device_reg_t __iomem *reg = ha->iobase;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 50539da..999734e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
+#include "qla_tgt.h"
 
 #include <scsi/scsi_tcq.h>
 
@@ -181,6 +182,12 @@ qla2300_intr_handler(int irq, void *dev_id)
 			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
 			qla2x00_async_event(ha, mb);
 			break;
+		case 0x17: /* FAST_CTIO_COMP */
+			mb[0] = MBA_CTIO_COMPLETION;
+			mb[1] = MSW(stat);
+			mb[2] = RD_MAILBOX_REG(ha, reg, 2);
+			qla2x00_async_event(ha, mb);
+			break;
 		default:
 			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
 			    "(%d).\n",
@@ -259,6 +266,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
 	switch (mb[0]) {
+	case MBA_CTIO_COMPLETION:
 	case MBA_SCSI_COMPLETION:
 		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
 		handle_cnt = 1;
@@ -318,11 +326,14 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		for (cnt = 0; cnt < handle_cnt; cnt++)
 			qla2x00_process_completed_request(ha, handles[cnt]);
 		break;
-
+	case MBA_CTIO_COMPLETION:
+		q2t_ctio_completion(ha, handles[0], CTIO_SUCCESS, NULL);
+		break;
 	case MBA_RESET:			/* Reset */
 		DEBUG2(printk("scsi(%ld): Asynchronous RESET.\n", ha->host_no));
 
 		set_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_SYSTEM_ERR:		/* System Error */
@@ -351,6 +362,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 			ha->flags.online = 0;
 		} else
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_REQ_TRANSFER_ERR:	/* Request Transfer Error */
@@ -359,6 +371,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		qla_printk(KERN_WARNING, ha, "ISP Request Transfer Error.\n");
 
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
@@ -367,11 +380,13 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		qla_printk(KERN_WARNING, ha, "ISP Response Transfer Error.\n");
 
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_WAKEUP_THRES:		/* Request Queue Wake-up */
 		DEBUG2(printk("scsi(%ld): Asynchronous WAKEUP_THRES.\n",
 		    ha->host_no));
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
@@ -393,6 +408,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
 
 		ha->flags.management_server_logged_in = 0;
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_LOOP_UP:		/* Loop Up Event */
@@ -412,6 +428,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		    link_speed);
 
 		ha->flags.management_server_logged_in = 0;
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
@@ -435,6 +452,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		ha->link_data_rate = PORT_SPEED_UNKNOWN;
 		if (ql2xfdmienable)
 			set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_LIP_RESET:		/* LIP reset occurred */
@@ -458,6 +476,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 		ha->operating_mode = LOOP;
 		ha->flags.management_server_logged_in = 0;
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_POINT_TO_POINT:	/* Point-to-Point */
@@ -490,6 +509,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
 
 		ha->flags.gpsc_supported = 1;
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_CHG_IN_CONNECTION:	/* Change in connection mode */
@@ -517,6 +537,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	case MBA_PORT_UPDATE:		/* Port database update */
@@ -591,6 +612,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 		set_bit(RSCN_UPDATE, &ha->dpc_flags);
+		q2t_async_event(mb[0], ha, mb);
 		break;
 
 	/* case MBA_RIO_RESPONSE: */
@@ -691,6 +713,11 @@ qla2x00_process_completed_request(struct scsi_qla_host *ha, uint32_t index)
 {
 	srb_t *sp;
 
+	if (HANDLE_IS_CTIO_COMP(index)) {
+		q2t_ctio_completion(ha, index, CTIO_SUCCESS, NULL);
+		return;
+	}
+
 	/* Validate handle. */
 	if (index >= MAX_OUTSTANDING_COMMANDS) {
 		DEBUG2(printk("scsi(%ld): Invalid SCSI completion handle %d.\n",
@@ -785,6 +812,15 @@ qla2x00_process_response_queue(struct scsi_qla_host *ha)
 		case MS_IOCB_TYPE:
 			qla2x00_ms_entry(ha, (ms_iocb_entry_t *)pkt);
 			break;
+                case ACCEPT_TGT_IO_TYPE:
+                case CONTINUE_TGT_IO_TYPE:
+                case CTIO_A64_TYPE:
+                case IMMED_NOTIFY_TYPE:
+                case NOTIFY_ACK_TYPE:
+                case ENABLE_LUN_TYPE:
+                case MODIFY_LUN_TYPE:
+			q2t_response_pkt(ha, pkt);
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
@@ -1447,6 +1483,15 @@ qla24xx_process_response_queue(struct scsi_qla_host *ha)
 			qla24xx_report_id_acquisition(ha,
 			    (struct vp_rpt_id_entry_24xx *)pkt);
 			break;
+		case ACCEPT_TGT_IO_TYPE:
+		case CONTINUE_TGT_IO_TYPE:
+		case CTIO_A64_TYPE:
+		case IMMED_NOTIFY_TYPE: /* always send these responses if we can */
+		case NOTIFY_ACK_TYPE:
+		case ENABLE_LUN_TYPE:
+		case MODIFY_LUN_TYPE:
+			q2t_response_pkt(ha, (sts_entry_t *)pkt);
+			break;
 		default:
 			/* Type Not Supported. */
 			DEBUG4(printk(KERN_WARNING
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d3746ec..018a470 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1141,10 +1141,12 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 		fcport->d_id.b.rsvd_1 = 0;
 
 		/* If not target must be initiator or unknown type. */
-		if ((pd24->prli_svc_param_word_3[0] & BIT_4) == 0)
+		if (pd24->prli_svc_param_word_3[0] & BIT_4)
+			fcport->port_type = FCT_TARGET;
+		else if (pd24->prli_svc_param_word_3[0] & BIT_5)
 			fcport->port_type = FCT_INITIATOR;
 		else
-			fcport->port_type = FCT_TARGET;
+			fcport->port_type = FCT_UNKNOWN;
 	} else {
 		/* Check for logged in state. */
 		if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
@@ -1168,10 +1170,12 @@ qla2x00_get_port_database(scsi_qla_host_t *ha, fc_port_t *fcport, uint8_t opt)
 		    (fcport->flags &= ~FCF_AUTH_REQ);
 
 		/* If not target must be initiator or unknown type. */
-		if ((pd->prli_svc_param_word_3[0] & BIT_4) == 0)
+		if (pd->prli_svc_param_word_3[0] & BIT_4)
+			fcport->port_type = FCT_TARGET;
+		else if (pd->prli_svc_param_word_3[0] & BIT_5)
 			fcport->port_type = FCT_INITIATOR;
 		else
-			fcport->port_type = FCT_TARGET;
+			fcport->port_type = FCT_UNKNOWN;
 
 		/* Passback COS information. */
 		fcport->supported_classes = (pd->options & BIT_4) ?
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 93c0c7e..a77083c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -16,6 +16,8 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include "qla_tgt.h"
+
 /*
  * Driver version
  */
@@ -89,6 +91,12 @@ MODULE_PARM_DESC(ql2xqfullrampup,
 		"depth for a device after a queue-full condition has been "
 		"detected.  Default is 120 seconds.");
 
+int ql2enable_target_mode = 0;
+module_param(ql2enable_target_mode, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql2enable_target_mode,
+		"Enables target mode "
+		"Default is 0 - initiator mode. 1 - target mode.");
+
 /*
  * SCSI host template entry points
  */
@@ -592,8 +600,7 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
  *    Success (LOOP_READY) : 0
  *    Failed  (LOOP_NOT_READY) : 1
  */
-static inline int
-qla2x00_wait_for_loop_ready(scsi_qla_host_t *ha)
+inline int qla2x00_wait_for_loop_ready(scsi_qla_host_t *ha)
 {
 	int 	 return_status = QLA_SUCCESS;
 	unsigned long loop_timeout ;
@@ -734,7 +741,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 *
 * Note:
 **************************************************************************/
-static int
+int
 qla2x00_eh_wait_for_pending_target_commands(scsi_qla_host_t *ha, unsigned int t)
 {
 	int	cnt;
@@ -871,8 +878,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 *
 * Note:
 **************************************************************************/
-static int
-qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha)
+int qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *ha)
 {
 	int	cnt;
 	int	status;
@@ -1578,6 +1584,12 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5432 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2532)
 		sht = &qla24xx_driver_template;
+
+	if (ql2enable_target_mode)
+		sht->supported_mode = MODE_TARGET;
+	else
+		sht->supported_mode = MODE_INITIATOR;
+
 	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
 	if (host == NULL) {
 		printk(KERN_WARNING
@@ -1706,6 +1718,12 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
+	if (ql2enable_target_mode) {
+		ret = qla_tgt_host_init(host);
+		if (ret)
+			goto probe_failed;
+	}
+
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
@@ -1775,7 +1793,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto probe_failed;
 
-	scsi_scan_host(host);
+	if (!ql2enable_target_mode)
+		scsi_scan_host(host);
 
 	qla2x00_alloc_sysfs_attr(ha);
 
@@ -1818,6 +1837,9 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_remove_host(ha->host);
 
+	if (ql2enable_target_mode)
+		qla_tgt_host_exit(ha->host);
+
 	qla2x00_free_device(ha);
 
 	scsi_host_put(ha->host);
@@ -2877,13 +2899,26 @@ qla2x00_module_init(void)
 		return -ENODEV;
 	}
 
+	if (ql2enable_target_mode) {
+		ret = q2t_init();
+		if (ret) {
+			kmem_cache_destroy(srb_cachep);
+			fc_release_transport(qla2xxx_transport_template);
+			fc_release_transport(qla2xxx_transport_vport_template);
+			return -ENODEV;
+		}
+	}
+
 	printk(KERN_INFO "QLogic Fibre Channel HBA Driver\n");
 	ret = pci_register_driver(&qla2xxx_pci_driver);
 	if (ret) {
+		if (ql2enable_target_mode)
+			q2t_exit();
 		kmem_cache_destroy(srb_cachep);
 		fc_release_transport(qla2xxx_transport_template);
 		fc_release_transport(qla2xxx_transport_vport_template);
 	}
+
 	return ret;
 }
 
@@ -2893,6 +2928,8 @@ qla2x00_module_init(void)
 static void __exit
 qla2x00_module_exit(void)
 {
+	if (ql2enable_target_mode)
+		q2t_exit();
 	pci_unregister_driver(&qla2xxx_pci_driver);
 	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
diff --git a/drivers/scsi/qla2xxx/qla_tgt.c b/drivers/scsi/qla2xxx/qla_tgt.c
new file mode 100644
index 0000000..4bdc5ae
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_tgt.c
@@ -0,0 +1,1194 @@
+/*
+ * QLogic qla2xxx target mode functions
+ *
+ * Copyright (C) 2004-2007 Vladislav Bolkhovitin <vst@vlnb.net>
+ *                         Leonid Stoljar
+ *                         Nathaniel Clark <nate@misrule.us>
+ *
+ * Copyright (C) 2006-2007 Mike Christie <michaelc@cs.wisc.edu>
+ * Copyright (C) 2007 FUJITA Tomonori <tomof@acm.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation, version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_tgt.h>
+
+#include "qla_tgt.h"
+#include "qla_tgt_priv.h"
+
+static struct kmem_cache *q2t_cmd_cachep;
+
+/* ha->hardware_lock supposed to be held on entry */
+static void q2t_modify_command_count(scsi_qla_host_t *ha, int cmd_count,
+				     int imm_count)
+{
+	struct modify_lun_entry *pkt;
+
+	pkt = (struct modify_lun_entry *)qla2x00_req_pkt(ha);
+	ha->tgt->modify_lun_expected++;
+
+	pkt->entry_type = MODIFY_LUN_TYPE;
+	pkt->entry_count = 1;
+	if (cmd_count < 0) {
+		pkt->operators = MODIFY_LUN_CMD_SUB;	/* Subtract from command count */
+		pkt->command_count = -cmd_count;
+	} else if (cmd_count > 0){
+		pkt->operators = MODIFY_LUN_CMD_ADD;	/* Add to command count */
+		pkt->command_count = cmd_count;
+	}
+
+	if (imm_count < 0) {
+		pkt->operators |= MODIFY_LUN_IMM_SUB;
+		pkt->immed_notify_count = -imm_count;
+	} else if (imm_count > 0) {
+		pkt->operators |= MODIFY_LUN_IMM_ADD;
+		pkt->immed_notify_count = imm_count;
+	}
+
+	pkt->timeout = 0;	/* Use default */
+	qla2x00_isp_cmd(ha);
+
+	return;
+}
+
+static int __qla2x00_issue_marker(scsi_qla_host_t *ha)
+{
+	int ret;
+
+        /* Send marker if required */
+        if (ha->marker_needed) {
+		ret = __qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
+		if (ret != QLA_SUCCESS)
+			return QLA_FUNCTION_FAILED;
+                ha->marker_needed = 0;
+        }
+
+        return QLA_SUCCESS;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+static void __q2t_send_notify_ack(scsi_qla_host_t *ha, uint16_t target_id,
+				  uint16_t status, uint16_t task_flags,
+				  uint16_t seq_id, uint32_t add_flags,
+				  uint16_t resp_code, int resp_code_valid,
+				  uint16_t ox_id)
+{
+	int ret;
+	struct nack_entry *ntfy;
+
+	/* Send marker if required */
+
+	ret = __qla2x00_issue_marker(ha);
+	if (ret != QLA_SUCCESS) {
+		printk("qla2x00tgt(%ld): __QLA2X00_MARKER() "
+		       "failed", ha->instance);
+		goto out;
+	}
+
+	ntfy = (struct nack_entry *)qla2x00_req_pkt(ha);
+
+	if (ha->tgt)
+		ha->tgt->notify_ack_expected++;
+
+	memset(ntfy, 0, sizeof(*ntfy));
+	ntfy->entry_type = NOTIFY_ACK_TYPE;
+	ntfy->entry_count = 1;
+	SET_TARGET_ID(ha, ntfy->target, target_id);
+	ntfy->status = status;
+	ntfy->task_flags = task_flags;
+	ntfy->seq_id = seq_id;
+	/* Do not increment here, the chip isn't decrementing */
+	/* ntfy->flags = __constant_cpu_to_le16(NOTIFY_ACK_RES_COUNT); */
+	ntfy->flags |= cpu_to_le16(add_flags);
+	ntfy->ox_id = ox_id;
+
+	if (resp_code_valid) {
+		ntfy->resp_code = cpu_to_le16(resp_code);
+		ntfy->flags |=
+			__constant_cpu_to_le16(NOTIFY_ACK_TM_RESP_CODE_VALID);
+	}
+
+	qla2x00_isp_cmd(ha);
+
+out:
+	return;
+}
+/* ha->hardware_lock supposed to be held on entry */
+static inline void q2t_send_notify_ack(scsi_qla_host_t *ha,
+				       struct notify_entry *iocb,
+				       uint32_t add_flags, uint16_t resp_code,
+				       int resp_code_valid)
+{
+	__q2t_send_notify_ack(ha,  GET_TARGET_ID(ha, iocb), iocb->status,
+			      iocb->task_flags, iocb->seq_id, add_flags, resp_code,
+			      resp_code_valid, iocb->ox_id);
+}
+
+static int q2t_pci_map_calc_cnt(struct q2t_prm *prm)
+{
+	int ret = 0;
+
+	/* 32 bit S/G Data Transfer */
+	prm->seg_cnt = pci_map_sg(prm->tgt->ha->pdev, prm->sg, prm->sg_cnt,
+				  prm->data_direction);
+	if (unlikely(!prm->seg_cnt)) {
+		printk("%s: %lx PCI mapping failed: sg_cnt=%d", __FUNCTION__,
+		       prm->tgt->ha->instance, prm->sg_cnt);
+		return -1;
+	}
+
+	/*
+	 * If greater than four sg entries then we need to allocate
+	 * the continuation entries
+	 */
+	if (prm->seg_cnt > prm->tgt->datasegs_per_cmd) {
+		prm->req_cnt += (uint16_t)(prm->seg_cnt -
+				prm->tgt->datasegs_per_cmd) /
+				prm->tgt->datasegs_per_cont;
+		if (((uint16_t)(prm->seg_cnt - prm->tgt->datasegs_per_cmd)) %
+		    prm->tgt->datasegs_per_cont)
+			prm->req_cnt++;
+	}
+
+	return ret;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+static inline uint32_t q2t_make_handle(scsi_qla_host_t *ha)
+{
+	uint32_t h;
+
+	h = ha->current_cmd;
+	/* always increment cmd handle */
+	do {
+		++h;
+		if (h > MAX_OUTSTANDING_COMMANDS) {
+			h = 0;
+		}
+		if (h == ha->current_cmd) {
+			h = Q2T_NULL_HANDLE;
+			break;
+		}
+	} while ((h == Q2T_NULL_HANDLE) ||
+		 (h == Q2T_BUSY_HANDLE) ||
+		 (h == Q2T_SKIP_HANDLE) ||
+		 (ha->cmds[h] != NULL));
+
+	if (h != Q2T_NULL_HANDLE)
+		ha->current_cmd = h;
+
+	return h;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+/*
+ * NOTE: About CTIO_COMPLETION_HANDLE
+ *  This is checked for in qla2x00_process_response_queue() to see
+ *  if a handle coming back in a multi-complete should come to the tgt driver
+ *  or be handled there by qla2xxx
+ */
+static void q2t_build_ctio_pkt(struct q2t_prm *prm)
+{
+	uint16_t timeout;
+	uint32_t h;
+
+	prm->pkt = (struct ctio_common_entry *)qla2x00_req_pkt(prm->tgt->ha);
+
+	if (prm->tgt->tgt_enable_64bit_addr)
+		prm->pkt->entry_type = CTIO_A64_TYPE;
+	else
+		prm->pkt->entry_type = CONTINUE_TGT_IO_TYPE;
+
+	prm->pkt->entry_count = (uint8_t) prm->req_cnt;
+
+	h = q2t_make_handle(prm->tgt->ha);
+	if (h != Q2T_NULL_HANDLE)
+		prm->tgt->ha->cmds[h] = prm->cmd;
+
+	prm->pkt->handle = h | CTIO_COMPLETION_HANDLE_MARK;
+
+	timeout = Q2T_TIMEOUT;
+	prm->pkt->timeout = cpu_to_le16(timeout);
+
+	/* Set initiator ID */
+	h = GET_TARGET_ID(prm->tgt->ha, &prm->cmd->atio);
+	SET_TARGET_ID(prm->tgt->ha, prm->pkt->target, h);
+
+	prm->pkt->exchange_id = prm->cmd->atio.exchange_id;
+}
+
+static cont_entry_t *qla2x00_req_cont_pkt(scsi_qla_host_t *ha)
+{
+	/* Adjust ring index. */
+	ha->req_ring_index++;
+	if (ha->req_ring_index == ha->request_q_length) {
+		ha->req_ring_index = 0;
+		ha->request_ring_ptr = ha->request_ring;
+	} else
+		ha->request_ring_ptr++;
+
+	return (cont_entry_t *)ha->request_ring_ptr;
+}
+
+static void q2t_load_data_segments(struct q2t_prm *prm)
+{
+	uint32_t cnt;
+	uint32_t *dword_ptr;
+	int enable_64bit_addressing = prm->tgt->tgt_enable_64bit_addr;
+
+	prm->pkt->transfer_length = cpu_to_le32(prm->bufflen);
+
+	/* Setup packet address segment pointer */
+	dword_ptr = prm->pkt->dseg_0_address;
+
+	if (!prm->seg_cnt) {
+		/* No data transfer */
+		*dword_ptr++ = 0;
+		*dword_ptr = 0;
+		goto out;
+	}
+
+	/* Set total data segment count */
+	prm->pkt->dseg_count = cpu_to_le16(prm->seg_cnt);
+
+	/* Load command entry data segments */
+	for (cnt = 0; (cnt < prm->tgt->datasegs_per_cmd) && prm->seg_cnt;
+	     cnt++, prm->seg_cnt--) {
+		*dword_ptr++ =
+		    cpu_to_le32(pci_dma_lo32(sg_dma_address(prm->sg)));
+
+		if (enable_64bit_addressing)
+			*dword_ptr++ =
+				cpu_to_le32(pci_dma_hi32
+					    (sg_dma_address(prm->sg)));
+
+		*dword_ptr++ = cpu_to_le32(sg_dma_len(prm->sg));
+
+		prm->sg++;
+	}
+
+	/* Build continuation packets */
+	while (prm->seg_cnt > 0) {
+		cont_a64_entry_t *cont_pkt64 =
+			(cont_a64_entry_t *)qla2x00_req_cont_pkt(prm->tgt->ha);
+
+		/*
+		 * Make sure that from cont_pkt64 none of
+		 * 64-bit specific fields used for 32-bit
+		 * addressing. Cast to (cont_entry_t*) for
+		 * that.
+		 */
+
+		memset(cont_pkt64, 0, sizeof(*cont_pkt64));
+
+		cont_pkt64->entry_count = 1;
+		cont_pkt64->sys_define = 0;
+
+		if (enable_64bit_addressing) {
+			cont_pkt64->entry_type = CONTINUE_A64_TYPE;
+			dword_ptr =
+			    (uint32_t*)&cont_pkt64->dseg_0_address;
+		} else {
+			cont_pkt64->entry_type = CONTINUE_TYPE;
+			dword_ptr = (uint32_t*)&((cont_entry_t *)
+						 cont_pkt64)->dseg_0_address;
+		}
+
+		/* Load continuation entry data segments */
+		for (cnt = 0; cnt < prm->tgt->datasegs_per_cont && prm->seg_cnt;
+		     cnt++, prm->seg_cnt--) {
+			*dword_ptr++ =
+				cpu_to_le32(pci_dma_lo32
+					    (sg_dma_address(prm->sg)));
+			if (enable_64bit_addressing)
+				*dword_ptr++ =
+					cpu_to_le32(pci_dma_hi32(sg_dma_address(prm->sg)));
+
+			*dword_ptr++ = cpu_to_le32(sg_dma_len(prm->sg));
+
+			prm->sg++;
+		}
+	}
+
+out:
+	return;
+}
+
+static void q2t_init_ctio_ret_entry(struct ctio_ret_entry *ctio_m1,
+				    struct q2t_prm *prm, struct scsi_cmnd *scmd)
+{
+	prm->sense_buffer_len = min((uint32_t)prm->sense_buffer_len,
+				    (uint32_t)sizeof(ctio_m1->sense_data));
+
+	ctio_m1->flags = __constant_cpu_to_le16(OF_SSTS | OF_FAST_POST |
+						OF_NO_DATA | OF_SS_MODE_1);
+	ctio_m1->flags |= __constant_cpu_to_le16(OF_INC_RC);
+	ctio_m1->scsi_status = cpu_to_le16(prm->rq_result);
+	ctio_m1->residual = cpu_to_le32(prm->residual);
+
+	if (status_byte(scmd->result) == CHECK_CONDITION) {
+		ctio_m1->scsi_status |=
+			__constant_cpu_to_le16(SS_SENSE_LEN_VALID);
+		ctio_m1->sense_length = cpu_to_le16(prm->sense_buffer_len);
+		memcpy(ctio_m1->sense_data, prm->sense_buffer,
+		       prm->sense_buffer_len);
+	}
+}
+
+static int q2t_rdy_to_xfer(struct scsi_cmnd *scmd)
+{
+	scsi_qla_host_t *ha = shost_priv(scsi_tgt_cmd_to_host(scmd));
+	struct q2t_cmd *cmd = (struct q2t_cmd *)scmd->SCp.ptr;
+	int ret;
+	struct q2t_prm prm;
+
+	prm.cmd = cmd;
+	prm.sg = scsi_sglist(scmd);
+	prm.bufflen = scmd->request->data_len;
+	prm.sg_cnt = scsi_sg_count(scmd);
+	prm.data_direction = scmd->sc_data_direction;
+	prm.tgt = ha->tgt;
+	prm.req_cnt = 1;
+
+	/* Send marker if required */
+	ret = __qla2x00_issue_marker(ha);
+	if (ret != QLA_SUCCESS) {
+		printk("qla2x00tgt(%ld): __QLA2X00_MARKER() "
+		       "failed", prm.tgt->ha->instance);
+		return -1;
+	}
+
+	/* Calculate number of entries and segments required */
+	ret = q2t_pci_map_calc_cnt(&prm);
+	if (ret)
+		return -1;
+
+	q2t_build_ctio_pkt(&prm);
+
+	prm.pkt->flags = __constant_cpu_to_le16(OF_FAST_POST | OF_DATA_OUT);
+
+	q2t_load_data_segments(&prm);
+
+	prm.cmd->state = Q2T_STATE_NEED_DATA;
+
+	qla2x00_isp_cmd(prm.tgt->ha);
+
+	return 0;
+}
+
+static int q2t_do_cmd_done(struct scsi_cmnd *scmd, int locked)
+{
+	scsi_qla_host_t *ha = shost_priv(scsi_tgt_cmd_to_host(scmd));
+	struct q2t_cmd *cmd = (struct q2t_cmd *)scmd->SCp.ptr;
+	int res = 0;
+	unsigned long flags = 0;
+	struct q2t_prm prm;
+	int data_sense_flag = 0;
+
+	if (scmd->use_sg && scmd->sc_data_direction == DMA_TO_DEVICE &&
+	    cmd->state != Q2T_STATE_DATA_IN) {
+		if (!locked)
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+
+		res = q2t_rdy_to_xfer(scmd);
+		if (res)
+			printk("%s %d: %p %d\n", __FUNCTION__, __LINE__, scmd, res);
+
+		if (!locked)
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		return res;
+	}
+
+	memset(&prm, 0, sizeof(struct q2t_prm));
+	prm.cmd = cmd;
+
+	prm.sg = scsi_sglist(scmd);
+	prm.bufflen = scmd->request->data_len;
+	prm.sg_cnt = scsi_sg_count(scmd);
+	prm.data_direction = scmd->sc_data_direction;
+	prm.rq_result = status_byte(scmd->result);
+	prm.sense_buffer = scmd->sense_buffer;
+	prm.sense_buffer_len = sizeof(scmd->sense_buffer);
+	prm.tgt = ha->tgt;
+	prm.seg_cnt = 0;
+	prm.req_cnt = 1;
+
+	/* Acquire ring specific lock */
+	if (!locked)
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/* Send marker if required */
+	if (__qla2x00_issue_marker(prm.tgt->ha) != QLA_SUCCESS) {
+		printk("qla2x00tgt(%ld): __QLA2X00_MARKER() failed\n",
+		       prm.tgt->ha->instance);
+		res = SCSI_MLQUEUE_HOST_BUSY;
+		goto out_unlock;
+	}
+
+	if (scsi_sg_count(scmd) && scmd->sc_data_direction == DMA_FROM_DEVICE) {
+		if (q2t_pci_map_calc_cnt(&prm) != 0) {
+			res = SCSI_MLQUEUE_HOST_BUSY;
+			goto out_unlock;
+		}
+
+		if (status_byte(scmd->result) == CHECK_CONDITION)
+			data_sense_flag = 1;
+	}
+
+	q2t_build_ctio_pkt(&prm);
+
+	if (scmd->sc_data_direction == DMA_FROM_DEVICE) {
+		prm.residual =
+		    le32_to_cpu(prm.cmd->atio.data_length) - prm.bufflen;
+
+		if (prm.residual > 0)
+			prm.rq_result |= SS_RESIDUAL_UNDER;
+		else if (prm.residual < 0) {
+			prm.rq_result |= SS_RESIDUAL_OVER;
+			prm.residual = -prm.residual;
+		}
+
+		if (scsi_sg_count(scmd)) {
+			prm.pkt->flags |= __constant_cpu_to_le16(
+				OF_FAST_POST | OF_INC_RC | OF_DATA_IN);
+
+			q2t_load_data_segments(&prm);
+
+			if (data_sense_flag == 0) {
+				prm.pkt->scsi_status = cpu_to_le16(
+					prm.rq_result);
+				prm.pkt->residual = cpu_to_le32(prm.residual);
+				prm.pkt->flags |=
+					__constant_cpu_to_le16(OF_SSTS);
+			} else {
+				struct ctio_ret_entry *ctio_m1 =
+					(struct ctio_ret_entry *)
+					qla2x00_req_cont_pkt(prm.tgt->ha);
+
+				memcpy(ctio_m1, prm.pkt, sizeof(*ctio_m1));
+				ctio_m1->entry_count = 1;
+
+				/* Real finish is ctio_m1's finish */
+				prm.pkt->handle = Q2T_SKIP_HANDLE |
+						CTIO_COMPLETION_HANDLE_MARK;
+
+				prm.pkt->flags &= ~__constant_cpu_to_le16(OF_INC_RC);
+
+				q2t_init_ctio_ret_entry(ctio_m1, &prm, scmd);
+			}
+		} else
+			q2t_init_ctio_ret_entry((struct ctio_ret_entry *)prm.pkt,
+						&prm, scmd);
+	} else
+		q2t_init_ctio_ret_entry((struct ctio_ret_entry *)prm.pkt,
+					&prm, scmd);
+
+	/* Mid-level is done processing */
+	prm.cmd->state = Q2T_STATE_PROCESSED;
+
+	qla2x00_isp_cmd(prm.tgt->ha);
+
+out_unlock:
+	/* Release ring specific lock */
+	if (!locked)
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return res;
+}
+
+static int q2t_cmd_done(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
+{
+	scmd->scsi_done = done;
+
+	return q2t_do_cmd_done(scmd, 0);
+}
+
+static inline void q2t_free_cmd(struct q2t_cmd *cmd)
+{
+	kmem_cache_free(q2t_cmd_cachep, cmd);
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+static inline struct scsi_cmnd *q2t_get_cmd(scsi_qla_host_t *ha, uint32_t handle)
+{
+	struct scsi_cmnd *scmd;
+
+	if (!ha->cmds[handle])
+		return NULL;
+
+	scmd = ha->cmds[handle]->scmd;
+	ha->cmds[handle] = NULL;
+
+	return scmd;
+}
+
+static fc_port_t *q2t_find_port(scsi_qla_host_t *ha, int loop_id)
+{
+	fc_port_t *fcl;
+
+	list_for_each_entry(fcl, &ha->fcports, list) {
+		if (loop_id == (fcl->loop_id & 0xFF))
+			return fcl;
+	}
+
+	return NULL;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+void q2t_ctio_completion(scsi_qla_host_t *ha, uint32_t handle,
+			 uint16_t status, struct ctio_common_entry *ctio)
+{
+	struct scsi_cmnd *scmd = NULL;
+	struct q2t_cmd *cmd;
+	uint16_t loop_id = -1;
+	int err = 0;
+
+	if (ctio)
+		loop_id = GET_TARGET_ID(ha, ctio);
+
+	/* Clear out CTIO_COMPLETION_HANDLE_MARK */
+	handle &= ~CTIO_COMPLETION_HANDLE_MARK;
+
+	if (status != CTIO_SUCCESS) {
+		switch (status) {
+		case CTIO_LIP_RESET:
+		case CTIO_TARGET_RESET:
+		case CTIO_ABORTED:
+		case CTIO_TIMEOUT:
+		case CTIO_INVALID_RX_ID:
+			err = 1;
+			/* they are OK */
+			break;
+
+		case CTIO_PORT_LOGGED_OUT:
+		case CTIO_PORT_UNAVAILABLE:
+			err = 1;
+			printk("qla2x00tgt(%ld): CTIO with PORT LOGGED "
+			       "OUT (29) or PORT UNAVAILABLE (28) status %x "
+			       "received", ha->instance, status);
+			break;
+
+		default:
+			err = 1;
+			printk("qla2x00tgt(%ld): CTIO with error status "
+			       "0x%x received", ha->instance, status);
+			break;
+		}
+		q2t_modify_command_count(ha, 1, 0);
+	}
+
+	if (handle != Q2T_NULL_HANDLE) {
+		if (unlikely(handle == Q2T_SKIP_HANDLE))
+			goto out;
+
+		if (unlikely(handle == Q2T_BUSY_HANDLE))
+			goto out;
+
+		scmd = q2t_get_cmd(ha, handle);
+		if (unlikely(!scmd)) {
+			printk("qla2x00tgt(%ld): Suspicious: unable to "
+			       "find the command with handle %x\n",
+			       ha->instance, handle);
+			goto out;
+		}
+		if (unlikely(err))
+			printk("Found by handle failed CTIO %p (op %x)\n",
+			       scmd, scmd->cmnd[0]);
+
+	} else if (ctio) {
+		uint32_t tag = le16_to_cpu(ctio->exchange_id);
+
+		printk("%s %d: shouldn't happen %u\n",
+		       __FUNCTION__, __LINE__, tag);
+		goto out;
+	} else
+		goto out;
+
+	cmd = (struct q2t_cmd *)scmd->SCp.ptr;
+	if (unlikely(err))
+		printk("Failed CTIO state %d\n", cmd->state);
+
+	if (cmd->state == Q2T_STATE_PROCESSED) {
+		if (scsi_sg_count(scmd))
+			dma_unmap_sg(&ha->pdev->dev, scmd->request_buffer,
+				     scmd->use_sg, scmd->sc_data_direction);
+		goto out_free;
+	} else if (cmd->state == Q2T_STATE_NEED_DATA) {
+		cmd->state = Q2T_STATE_DATA_IN;
+		q2t_do_cmd_done(scmd, 1);
+		goto out;
+	} else if (cmd->state == Q2T_STATE_ABORTED)
+		goto out_free;
+	else
+		printk("qla2x00tgt(%ld): A command in state (%d) should "
+		       "not return a CTIO complete\n", ha->instance, cmd->state);
+		goto out_free;
+out:
+	return;
+
+out_free:
+	if (unlikely(err))
+		printk("Finishing failed CTIO\n");
+
+	scmd->scsi_done(scmd);
+	q2t_free_cmd(cmd);
+
+	goto out;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+static void q2t_send_busy(scsi_qla_host_t *ha, struct atio_entry *atio)
+{
+	struct ctio_ret_entry *ctio;
+
+	ctio = (struct ctio_ret_entry *)qla2x00_req_pkt(ha);
+	ctio->entry_type = CTIO_RET_TYPE;
+	ctio->entry_count = 1;
+	ctio->handle = Q2T_BUSY_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
+	ctio->scsi_status = __constant_cpu_to_le16(BUSY << 1);
+
+	/* Set IDs */
+	SET_TARGET_ID(ha, ctio->target, GET_TARGET_ID(ha, atio));
+	ctio->exchange_id = atio->exchange_id;
+
+	ctio->flags = __constant_cpu_to_le16(OF_SSTS | OF_FAST_POST |
+					     OF_NO_DATA | OF_SS_MODE_1);
+	ctio->flags |= __constant_cpu_to_le16(OF_INC_RC);
+
+	qla2x00_isp_cmd(ha);
+
+	return;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+static int q2t_queue_cmd(scsi_qla_host_t *ha, struct atio_entry *atio)
+{
+	enum dma_data_direction data_dir;
+	struct scsi_cmnd *scmd;
+	struct q2t_cmd *cmd;
+	uint16_t *pn;
+	int loop_id;
+	fc_port_t *fcl;
+	unsigned int lun;
+	struct scsi_lun scsilun;
+
+	loop_id = GET_TARGET_ID(ha, atio);
+
+	fcl = q2t_find_port(ha, loop_id);
+	if (!fcl)
+		return -EINVAL;
+
+	pn = (uint16_t *)(((char *)atio)+0x2a);
+
+	cmd =  kmem_cache_zalloc(q2t_cmd_cachep, GFP_ATOMIC);
+	if (!cmd)
+		return -ENOMEM;
+
+	memcpy(&cmd->atio, atio, sizeof(*atio));
+	cmd->state = Q2T_STATE_NEW;
+
+	if (cmd->atio.execution_codes & ATIO_EXEC_WRITE)
+		data_dir = DMA_TO_DEVICE;
+	else
+		data_dir = DMA_FROM_DEVICE;
+
+	scmd = scsi_host_get_command(ha->host, data_dir, GFP_ATOMIC);
+	if (!scmd) {
+		struct request_queue *q = ha->host->uspace_req_q;
+		struct request_list *rl = &q->rq;
+		printk("%s %d: %lu %d %d\n", __FUNCTION__, __LINE__,
+		       q->nr_requests, rl->count[0], rl->count[1]);
+
+		q2t_free_cmd(cmd);
+		return -ENOMEM;
+	}
+
+	cmd->scmd = scmd;
+	scmd->SCp.ptr = (char *) cmd;
+	memcpy(scmd->cmnd, cmd->atio.cdb, MAX_CMDSZ);
+	scmd->request_bufflen = cmd->atio.data_length;
+
+	if (cmd->atio.task_codes & ATIO_SIMPLE_QUEUE)
+		scmd->tag = MSG_SIMPLE_TAG;
+	else if (cmd->atio.task_codes & ATIO_HEAD_OF_QUEUE)
+		scmd->tag = MSG_HEAD_TAG;
+	else if (cmd->atio.task_codes & ATIO_ORDERED_QUEUE)
+		scmd->tag = MSG_ORDERED_TAG;
+	else if (cmd->atio.task_codes & ATIO_ACA_QUEUE)
+		scmd->tag = MSG_ORDERED_TAG;
+	else
+		scmd->tag = MSG_SIMPLE_TAG;
+
+	lun = cmd->atio.lun;
+	int_to_scsilun(lun, &scsilun);
+	scsi_tgt_queue_command(scmd, (unsigned long)fcl->rport, &scsilun,
+			       le16_to_cpu(cmd->atio.exchange_id));
+
+	return 0;
+}
+
+int q2t_tsk_mgmt_response(struct Scsi_Host *shost, u64 itn_id,
+			  u64 mid, int result)
+{
+	scsi_qla_host_t *ha = shost_priv(shost);
+	struct q2t_mgmt_cmd *m = (struct q2t_mgmt_cmd *) ((unsigned long)mid);
+	unsigned long flags;
+
+	printk("%s %d: %llx %llx %d\n", __FUNCTION__, __LINE__,
+	       itn_id, mid, result);
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	list_del(&m->mgmt_siblings);
+	q2t_send_notify_ack(ha, &m->notify_entry, 0,
+			    result ? FC_TM_FAILED : 0, 1);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	kfree(m);
+
+	return 0;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+static int q2t_handle_task_mgmt(scsi_qla_host_t *ha, struct notify_entry *iocb)
+{
+	struct Scsi_Host *shost = ha->host;
+	int fn, ret, loop_id;
+	fc_port_t *fcl;
+	uint16_t status;
+	uint32_t tag = 0;
+	struct scsi_lun scsilun;
+	struct q2t_mgmt_cmd *m;
+
+	loop_id = GET_TARGET_ID(ha, iocb);
+	status = le16_to_cpu(iocb->status);
+
+	int_to_scsilun(iocb->lun, &scsilun);
+
+	fcl = q2t_find_port(ha, loop_id);
+	if (!fcl)
+		return -EFAULT;
+
+	m = kzalloc(sizeof(*m), GFP_ATOMIC);
+	if (!m)
+		return -ENOMEM;
+
+	m->notify_entry = *iocb;
+	list_add(&m->mgmt_siblings, &ha->tgt->mgmt_list);
+
+	if (status == IMM_NTFY_ABORT_TASK) {
+		fn = ABORT_TASK;
+		tag = le16_to_cpu(iocb->seq_id);
+		goto send_request;
+	}
+
+	switch (iocb->task_flags) {
+	case IMM_NTFY_CLEAR_ACA:
+		fn = CLEAR_ACA;
+		break;
+	case IMM_NTFY_TARGET_RESET:
+		fn = TARGET_RESET;
+		break;
+	case IMM_NTFY_LUN_RESET:
+		fn = LOGICAL_UNIT_RESET;
+		break;
+	case IMM_NTFY_CLEAR_TS:
+		fn = CLEAR_TASK_SET;
+		break;
+	case IMM_NTFY_ABORT_TS:
+		fn = ABORT_TASK_SET;
+		break;
+	default:
+		printk("%s %d: Unknown task mgmt fn %lx %x\n",
+		       __FUNCTION__, __LINE__, ha->instance, iocb->task_flags);
+		return -EINVAL;
+	}
+send_request:
+	ret = scsi_tgt_tsk_mgmt_request(shost, (unsigned long)fcl->rport, fn,
+					tag, &scsilun, &m);
+	if (ret)
+		kfree(m);
+	return ret;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+static void q2t_handle_imm_notify(scsi_qla_host_t *ha, struct notify_entry *iocb)
+{
+	uint16_t status;
+	int loop_id;
+	uint32_t add_flags = 0;
+	int send_notify_ack = 1;
+
+	status = le16_to_cpu(iocb->status);
+	loop_id = GET_TARGET_ID(ha, iocb);
+
+	if (!ql2enable_target_mode || ha->tgt)
+		goto out;
+
+	switch (status) {
+	case IMM_NTFY_LIP_RESET:
+		/*
+		 * ToDo: doing so we reset all holding RESERVE'ations,
+		 * which could be unexpected, so be more carefull here
+		 */
+/* 		q2t_clear_tgt_db(ha->tgt); */
+		/* set the Clear LIP reset event flag */
+		add_flags |= NOTIFY_ACK_CLEAR_LIP_RESET;
+		break;
+
+	case IMM_NTFY_IOCB_OVERFLOW:
+		break;
+
+	case IMM_NTFY_PORT_LOGOUT:
+		/*
+		 * ToDo: doing so we reset all holding RESERVE'ations,
+		 * which could be unexpected, so be more carefull here
+		 */
+/* 		q2t_port_logout(ha, loop_id); */
+		break;
+
+	case IMM_NTFY_PORT_CONFIG:
+	case IMM_NTFY_GLBL_TPRLO:
+	case IMM_NTFY_GLBL_LOGO:
+		/* ToDo: ports DB changes handling ?? */
+		/*
+		 * ToDo: doing so we reset all holding RESERVE'ations,
+		 * which could be unexpected, so be more carefull here
+		 */
+/* 		q2t_clear_tgt_db(ha->tgt); */
+		break;
+
+	case IMM_NTFY_RESOURCE:
+		break;
+
+	case IMM_NTFY_ABORT_TASK:
+	case IMM_NTFY_MSG_RX:
+		if (!q2t_handle_task_mgmt(ha, iocb))
+			send_notify_ack = 0;
+		break;
+
+	default:
+		break;
+	}
+
+out:
+	if (send_notify_ack)
+		q2t_send_notify_ack(ha, iocb, add_flags, 0, 0);
+
+	return;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+/* called via callback from qla2xxx */
+void q2t_response_pkt(scsi_qla_host_t *ha, sts_entry_t *pkt)
+{
+	struct atio_entry *atio;
+
+	BUG_ON((!ha) || (!pkt));
+
+	if (pkt->entry_status) {
+		printk("%s: %lx Received response packet %x "
+		       "with error status %x\n", __FUNCTION__, ha->instance,
+		       pkt->entry_type, pkt->entry_status);
+		goto out;
+	}
+
+	switch (pkt->entry_type) {
+	case ACCEPT_TGT_IO_TYPE:
+		if (ql2enable_target_mode && ha->tgt) {
+			int rc;
+			uint16_t *pn;
+
+			atio = (struct atio_entry *)pkt;
+			pn = (uint16_t *)(((char *)atio)+0x2a);
+
+			if (atio->status !=
+				__constant_cpu_to_le16(ATIO_CDB_VALID)) {
+				printk("qla2x00tgt(%ld): ATIO with error "
+				       "status %x received\n", ha->instance,
+				       le16_to_cpu(atio->status));
+				break;
+			}
+
+			rc = q2t_queue_cmd(ha, atio);
+			if (unlikely(rc)) {
+				if (rc == -ESRCH)
+					q2t_send_busy(ha, atio);
+				else
+					q2t_send_busy(ha, atio);
+			}
+		}
+		break;
+
+	case CONTINUE_TGT_IO_TYPE:
+		if (ql2enable_target_mode && ha->tgt) {
+			struct ctio_common_entry *entry =
+				(struct ctio_common_entry *)pkt;
+			q2t_ctio_completion(ha, entry->handle,
+					    le16_to_cpu(entry->status),
+					    entry);
+		}
+
+		break;
+
+	case CTIO_A64_TYPE:
+		if (ql2enable_target_mode && ha->tgt) {
+			struct ctio_common_entry *entry =
+				(struct ctio_common_entry *)pkt;
+			q2t_ctio_completion(ha, entry->handle,
+					    le16_to_cpu(entry->status),
+					    entry);
+		}
+
+		break;
+
+	case IMMED_NOTIFY_TYPE:
+		q2t_handle_imm_notify(ha, (struct notify_entry *)pkt);
+		break;
+
+	case NOTIFY_ACK_TYPE:
+		if (!ha->tgt)
+			printk("qla2x00tgt(%ld): NOTIFY_ACK recieved "
+			       "with NULL tgt\n", ha->instance);
+		else if (ha->tgt->notify_ack_expected > 0) {
+			struct nack_entry *entry = (struct nack_entry *)pkt;
+			ha->tgt->notify_ack_expected--;
+			if (entry->status != __constant_cpu_to_le16(NOTIFY_ACK_SUCCESS))
+				printk("qla2x00tgt(%ld): NOTIFY_ACK "
+				       "failed %x\n", ha->instance,
+				       le16_to_cpu(entry->status));
+		} else
+			printk("qla2x00tgt(%ld): Unexpected NOTIFY_ACK "
+			       "received\n", ha->instance);
+		break;
+
+	case MODIFY_LUN_TYPE:
+		if (ha->tgt && (ha->tgt->modify_lun_expected > 0)) {
+			struct q2t_tgt *tgt = ha->tgt;
+			struct modify_lun_entry *entry =
+				(struct modify_lun_entry *)pkt;
+			tgt->modify_lun_expected--;
+			if (entry->status != MODIFY_LUN_SUCCESS)
+				printk("qla2x00tgt(%ld): MODIFY_LUN "
+				       "failed %x\n", ha->instance,
+				       entry->status);
+			tgt->disable_lun_status = entry->status;
+		} else
+			printk("qla2x00tgt(%ld): Unexpected MODIFY_LUN "
+			       "received\n", ha ? ha->instance : -1);
+		break;
+
+	case ENABLE_LUN_TYPE:
+		if (ha->tgt) {
+			struct q2t_tgt *tgt = ha->tgt;
+			struct elun_entry *entry = (struct elun_entry *)pkt;
+
+			if (ql2enable_target_mode &&
+			    (entry->status == ENABLE_LUN_ALREADY_ENABLED)) {
+				entry->status = ENABLE_LUN_SUCCESS;
+			} else if (entry->status == ENABLE_LUN_RC_NONZERO) {
+				entry->status = ENABLE_LUN_SUCCESS;
+			} else if (entry->status != ENABLE_LUN_SUCCESS) {
+				printk("qla2x00tgt(%ld): ENABLE_LUN "
+				       "failed %x\n",
+				       ha->instance, entry->status);
+/* 				ha->flags.enable_target_mode = */
+/* 					~ha->flags.enable_target_mode; */
+			} /* else success */
+			tgt->disable_lun_status = entry->status;
+		}
+		break;
+
+	default:
+		printk("qla2x00tgt(%ld): Received unknown response pkt "
+		       "type %x\n", ha->instance, pkt->entry_type);
+		break;
+	}
+
+out:
+	return;
+}
+
+/* ha->hardware_lock supposed to be held on entry */
+/* called via callback from qla2xxx */
+void q2t_async_event(uint16_t code, scsi_qla_host_t *ha, uint16_t *mailbox)
+{
+	if (ha->tgt)
+		goto out;
+
+	switch (code) {
+	case MBA_RESET:			/* Reset */
+	case MBA_SYSTEM_ERR:		/* System Error */
+	case MBA_REQ_TRANSFER_ERR:	/* Request Transfer Error */
+	case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
+	case MBA_LOOP_DOWN:
+	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
+	case MBA_LIP_RESET:		/* LIP reset occurred */
+	case MBA_POINT_TO_POINT:	/* Point to point mode. */
+	case MBA_CHG_IN_CONNECTION:	/* Change in connection mode. */
+		printk("%s: Async event %#x occured: clear tgt_db\n",
+		       __FUNCTION__, code);
+#if 0
+		/*
+		 * ToDo: doing so we reset all holding RESERVE'ations,
+		 * which could be unexpected, so be more carefull here
+		 */
+		q2t_clear_tgt_db(ha->tgt);
+#endif
+		break;
+	case MBA_RSCN_UPDATE:
+		printk("RSCN Update (%x) N_Port %#06x (fmt %x)\n",
+		       code, ((mailbox[1]&0xF)<<2)|le16_to_cpu(mailbox[2]),
+		       (mailbox[1]&0xF0)>>1);
+		break;
+
+	case MBA_PORT_UPDATE:		/* Port database update occurred */
+		printk("Port DB Chng: L_ID %#4x did %d: ignore\n",
+		       le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]));
+		break;
+
+	case MBA_LOOP_UP:
+	default:
+		printk("Async event %#x occured: ignore\n", code);
+		/* just don't DO anything */
+		break;
+	}
+
+out:
+	return;
+}
+
+static int q2t_eh_abort_handler(struct scsi_cmnd *sc)
+{
+	return 0;
+}
+
+int qla_tgt_host_init(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = shost_priv(shost);
+	struct q2t_tgt *tgt;
+	int ret;
+
+	tgt = kzalloc(sizeof(*tgt), GFP_KERNEL);
+	if (!tgt)
+		return -ENOMEM;
+
+	ret = scsi_tgt_alloc_queue(shost);
+	if (ret) {
+		kfree(tgt);
+		return ret;
+	}
+
+	tgt->ha = ha;
+	tgt->disable_lun_status = Q2T_DISABLE_LUN_STATUS_NOT_SET;
+
+	if (ha->flags.enable_64bit_addressing) {
+		printk("qla2x00tgt(%ld): 64 Bit PCI "
+		       "Addressing Enabled\n", ha->instance);
+		tgt->tgt_enable_64bit_addr = 1;
+		tgt->datasegs_per_cmd = DATASEGS_PER_COMMAND64;
+		tgt->datasegs_per_cont = DATASEGS_PER_CONT64;
+	} else {
+		printk("qla2x00tgt(%ld): Using 32 Bit "
+		       "PCI Addressing\n", ha->instance);
+		tgt->datasegs_per_cmd = DATASEGS_PER_COMMAND32;
+		tgt->datasegs_per_cont = DATASEGS_PER_CONT32;
+	}
+
+	shost->hostt->transfer_response = q2t_cmd_done;
+	shost->hostt->eh_abort_handler = q2t_eh_abort_handler;
+
+	ha->tgt = tgt;
+	INIT_LIST_HEAD(&tgt->mgmt_list);
+
+	return 0;
+}
+
+void qla_tgt_host_exit(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = shost_priv(shost);
+	struct q2t_tgt *tgt = ha->tgt;
+
+	scsi_tgt_free_queue(shost);
+	ha->tgt = NULL;
+
+	while (!list_empty(&tgt->mgmt_list)) {
+		struct q2t_mgmt_cmd *m;
+		m = list_entry(tgt->mgmt_list.next, struct q2t_mgmt_cmd,
+			       mgmt_siblings);
+		list_del(&m->mgmt_siblings);
+		kfree(m);
+	}
+
+	kfree(tgt);
+
+	return;
+}
+
+int q2t_init(void)
+{
+	q2t_cmd_cachep = kmem_cache_create("q2t_cmds", sizeof(struct q2t_cmd),
+					   0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!q2t_cmd_cachep)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void q2t_exit(void)
+{
+	kmem_cache_destroy(q2t_cmd_cachep);
+}
+
+/* Caller MUST have hardware lock held */
+static void __qla2x00_en_dis_lun(scsi_qla_host_t *ha, int enable)
+{
+	struct elun_entry *pkt;
+
+	if ((pkt = (struct elun_entry *)qla2x00_req_pkt(ha)) != NULL) {
+		pkt->entry_type = ENABLE_LUN_TYPE;
+		if (enable) {
+			pkt->command_count = QLA2X00_COMMAND_COUNT_INIT;
+			pkt->immed_notify_count = QLA2X00_IMMED_NOTIFY_COUNT_INIT;
+			pkt->timeout = 0xffff;
+		} else {
+			pkt->command_count = 0;
+			pkt->immed_notify_count = 0;
+			pkt->timeout = 0;
+		}
+		DEBUG2(printk(KERN_DEBUG
+			      "scsi%lu:ENABLE_LUN IOCB imm %u cmd %u timeout %u\n",
+			      ha->host_no, pkt->immed_notify_count,
+			      pkt->command_count, pkt->timeout));
+
+		/* Issue command to ISP */
+		qla2x00_isp_cmd(ha);
+	}
+}
+
+void qla2x00_en_dis_lun(scsi_qla_host_t *ha, int enable)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	__qla2x00_en_dis_lun(ha, enable);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+int q2t_it_nexus_response(struct Scsi_Host *shost, u64 itn_id,
+				 int result)
+{
+	printk("%s %d: %llx %d\n", __FUNCTION__, __LINE__, itn_id, result);
+
+	return 0;
+}
diff --git a/drivers/scsi/qla2xxx/qla_tgt.h b/drivers/scsi/qla2xxx/qla_tgt.h
new file mode 100644
index 0000000..9fdb909
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_tgt.h
@@ -0,0 +1,137 @@
+/*
+ *  Copyright (C) 2004-2005 Vladislav Bolkhovitin <vst@vlnb.net>
+ *                 and Leonid Stoljar
+ *
+ *  Additional file for the target driver support. Intended to define
+ *  for 2200 and 2300 thier own exported symbols with unique names.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef __QLA2X_TGT_DEF_H
+#define __QLA2X_TGT_DEF_H
+
+#include "qla_def.h"
+
+#define ENABLE_LUN_TYPE			0x0B
+#define ENABLE_LUN_SUCCESS		0x01
+#define ENABLE_LUN_RC_NONZERO		0x04
+#define ENABLE_LUN_INVALID_REQUEST	0x06
+#define ENABLE_LUN_ALREADY_ENABLED	0x3E
+
+#define MODIFY_LUN_TYPE			0x0C
+#define MODIFY_LUN_SUCCESS		0x01
+#define MODIFY_LUN_CMD_ADD		BIT_0
+#define MODIFY_LUN_CMD_SUB		BIT_1
+#define MODIFY_LUN_IMM_ADD		BIT_2
+#define MODIFY_LUN_IMM_SUB		BIT_3
+
+#define IMMED_NOTIFY_TYPE		0x0D
+
+#define NOTIFY_ACK_TYPE			0x0E
+#define NOTIFY_ACK_SUCCESS		0x01
+
+#define ACCEPT_TGT_IO_TYPE		0x16
+
+#define CONTINUE_TGT_IO_TYPE		0x17
+#define ATIO_PATH_INVALID		0x07
+#define ATIO_CANT_PROV_CAP		0x16
+#define ATIO_CDB_VALID			0x3D
+
+#define ATIO_EXEC_READ			BIT_1
+#define ATIO_EXEC_WRITE			BIT_0
+
+#define CTIO_A64_TYPE			0x1F
+#define CTIO_SUCCESS			0x01
+#define CTIO_ABORTED			0x02
+#define CTIO_INVALID_RX_ID		0x08
+#define CTIO_TIMEOUT			0x0B
+#define CTIO_LIP_RESET			0x0E
+#define CTIO_TARGET_RESET		0x17
+#define CTIO_PORT_UNAVAILABLE		0x28
+#define CTIO_PORT_LOGGED_OUT		0x29
+
+#define CTIO_RET_TYPE			0x17	/* CTIO return entry */
+
+/*
+ * Used to mark which completion handles (for RIO Status's) are for CTIO's
+ * vs. regular (non-target) info.
+ */
+#define CTIO_COMPLETION_HANDLE_MARK	BIT_15
+#if (CTIO_COMPLETION_HANDLE_MARK <= MAX_OUTSTANDING_COMMANDS)
+#error "Hackish CTIO_COMPLETION_HANDLE_MARK no longer larger than MAX_OUTSTANDING_COMMANDS"
+#endif
+
+#define HANDLE_IS_CTIO_COMP(h) (h & CTIO_COMPLETION_HANDLE_MARK)
+
+struct ctio_common_entry;
+
+#if defined(CONFIG_SCSI_QLA_FC_TGT)
+
+extern int q2t_init(void);
+extern void q2t_exit(void);
+
+extern int qla_tgt_host_init(struct Scsi_Host *shost);
+extern void qla_tgt_host_exit(struct Scsi_Host *shost);
+
+extern void qla2x00_en_dis_lun(scsi_qla_host_t *ha, int enable);
+extern void q2t_ctio_completion(scsi_qla_host_t *ha, uint32_t handle,
+				uint16_t status, struct ctio_common_entry *ctio);
+extern void q2t_response_pkt(scsi_qla_host_t *ha, sts_entry_t *pkt);
+extern void q2t_async_event(uint16_t code, scsi_qla_host_t *ha, uint16_t *mbox);
+extern int q2t_it_nexus_response(struct Scsi_Host *shost, u64 itn_id,
+				 int result);
+extern int q2t_tsk_mgmt_response(struct Scsi_Host *shost,
+				 u64 itn_id, u64 mid, int result);
+
+#else
+
+static inline int q2t_init(void)
+{
+	return 0;
+}
+static inline void q2t_exit(void)
+{
+}
+static inline int qla_tgt_host_init(struct Scsi_Host *shost)
+{
+	return 0;
+}
+static inline void qla_tgt_host_exit(struct Scsi_Host *shost)
+{
+}
+static inline void qla2x00_en_dis_lun(scsi_qla_host_t *ha, int enable)
+{
+}
+static inline void q2t_ctio_completion(scsi_qla_host_t *ha, uint32_t handle,
+				       uint16_t status, struct ctio_common_entry *ctio)
+{
+}
+static inline void q2t_response_pkt(scsi_qla_host_t *ha, sts_entry_t *pkt)
+{
+}
+static inline void q2t_async_event(uint16_t code, scsi_qla_host_t *ha, uint16_t *mbox)
+{
+}
+static inline int q2t_it_nexus_response(struct Scsi_Host *shost, u64 itn_id,
+					int result)
+{
+	return 0;
+}
+
+static inline int q2t_tsk_mgmt_response(struct Scsi_Host *shost,
+					u64 itn_id, u64 mid, int result)
+{
+	return 0;
+}
+#endif
+
+#endif
diff --git a/drivers/scsi/qla2xxx/qla_tgt_priv.h b/drivers/scsi/qla2xxx/qla_tgt_priv.h
new file mode 100644
index 0000000..e7d339a
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_tgt_priv.h
@@ -0,0 +1,338 @@
+/*
+ *  qla2x00t.h
+ *
+ *  Copyright (C) 2004-2007 Vladislav Bolkhovitin <vst@vlnb.net>
+ *                          Leonid Stoljar
+ *                          Nathaniel Clark <nate@misrule.us>
+ *
+ *  Significant modification 2006 by Nathaniel Clark <nate@misrule.us>
+ *
+ *  Qlogic 2x00 SCSI target driver.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef __QLA_TGT_PRIV_H
+#define __QLA_TGT_PRIV_H
+
+#include "qla_def.h"
+
+#define Q2T_MAX_CDB_LEN             16
+#define Q2T_TIMEOUT                 10	/* in seconds */
+
+/* Immediate notify status constants */
+#define IMM_NTFY_LIP_RESET          0x000E
+#define IMM_NTFY_IOCB_OVERFLOW      0x0016
+#define IMM_NTFY_ABORT_TASK         0x0020
+#define IMM_NTFY_PORT_LOGOUT        0x0029
+#define IMM_NTFY_PORT_CONFIG        0x002A
+#define IMM_NTFY_GLBL_TPRLO         0x002D
+#define IMM_NTFY_GLBL_LOGO          0x002E
+#define IMM_NTFY_RESOURCE           0x0034
+#define IMM_NTFY_MSG_RX             0x0036
+
+/* Immediate notify task flags */
+#define IMM_NTFY_CLEAR_ACA          0x4000
+#define IMM_NTFY_TARGET_RESET       0x2000
+#define IMM_NTFY_LUN_RESET          0x1000
+#define IMM_NTFY_CLEAR_TS           0x0400
+#define IMM_NTFY_ABORT_TS           0x0200
+
+/* Notify Acknowledge flags */
+#define NOTIFY_ACK_RES_COUNT        BIT_8
+#define NOTIFY_ACK_CLEAR_LIP_RESET  BIT_5
+#define NOTIFY_ACK_TM_RESP_CODE_VALID BIT_4
+
+/* Command's states */
+#define Q2T_STATE_NEW               0	/* New command and SCST processes it */
+#define Q2T_STATE_PROCESSED         1	/* SCST done processing */
+#define Q2T_STATE_NEED_DATA         2	/* SCST needs data to process */
+#define Q2T_STATE_DATA_IN           3	/* Data arrived and SCST processes it */
+#define Q2T_STATE_ABORTED           4	/* Command aborted */
+
+/* Misc */
+#define Q2T_NULL_HANDLE             0
+#define Q2T_SKIP_HANDLE             (0xFFFFFFFE & ~CTIO_COMPLETION_HANDLE_MARK)
+#define Q2T_BUSY_HANDLE             (0xFFFFFFFF & ~CTIO_COMPLETION_HANDLE_MARK)
+#define Q2T_DISABLE_LUN_STATUS_NOT_SET      -1
+
+/* ATIO task_codes fields */
+#define ATIO_SIMPLE_QUEUE           0
+#define ATIO_HEAD_OF_QUEUE          1
+#define ATIO_ORDERED_QUEUE          2
+#define ATIO_ACA_QUEUE              4
+#define ATIO_UNTAGGED               5
+
+/* TM failed response code, see FCP */
+#define FC_TM_FAILED                0x5
+
+#if (BITS_PER_LONG > 32) || defined(CONFIG_HIGHMEM64G)
+#define pci_dma_lo32(a) (a & 0xffffffff)
+#define pci_dma_hi32(a) ((((a) >> 16)>>16) & 0xffffffff)
+#else
+#define pci_dma_lo32(a) (a & 0xffffffff)
+#define pci_dma_hi32(a) 0
+#endif
+
+#define QLA2X00_COMMAND_COUNT_INIT	250
+#define QLA2X00_IMMED_NOTIFY_COUNT_INIT 250
+
+#define QLA_EXTENDED_LUN 1
+
+#ifndef OF_SS_MODE_0
+/*
+ * ISP target entries - Flags bit definitions.
+ */
+#define OF_SS_MODE_0        0
+#define OF_SS_MODE_1        1
+#define OF_SS_MODE_2        2
+#define OF_SS_MODE_3        3
+
+#define OF_RESET            BIT_5       /* Reset LIP flag */
+#define OF_DATA_IN          BIT_6       /* Data in to initiator */
+                                        /*  (data from target to initiator) */
+#define OF_DATA_OUT         BIT_7       /* Data out from initiator */
+                                        /*  (data from initiator to target) */
+#define OF_NO_DATA          (BIT_7 | BIT_6)
+#define OF_INC_RC           BIT_8       /* Increment command resource count */
+#define OF_FAST_POST        BIT_9       /* Enable mailbox fast posting. */
+#define OF_TERM_EXCH        BIT_14      /* Terminate exchange */
+#define OF_SSTS             BIT_15      /* Send SCSI status */
+#endif
+
+#ifndef DATASEGS_PER_COMMAND32
+#define DATASEGS_PER_COMMAND32    3
+#define DATASEGS_PER_CONT32       7
+#define QLA_MAX_SG32(ql) \
+   (DATASEGS_PER_COMMAND32 + (((ql) > 0) ? DATASEGS_PER_CONT32*((ql) - 1) : 0))
+
+#define DATASEGS_PER_COMMAND64    2
+#define DATASEGS_PER_CONT64       5
+#define QLA_MAX_SG64(ql) \
+   (DATASEGS_PER_COMMAND64 + (((ql) > 0) ? DATASEGS_PER_CONT64*((ql) - 1) : 0))
+#endif
+
+#define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))			\
+				 ? le16_to_cpu((iocb)->target.extended)	\
+				 : (uint16_t)(iocb)->target.id.standard)
+
+/********************************************************************\
+ * ISP Queue types left out of new QLogic driver (from old version)
+\********************************************************************/
+
+/*
+ * ISP queue - enable LUN entry structure definition.
+ */
+struct elun_entry {
+	uint8_t	 entry_type;		/* Entry type. */
+	uint8_t	 entry_count;		/* Entry count. */
+	uint8_t	 sys_define;		/* System defined. */
+	uint8_t	 entry_status;		/* Entry Status. */
+	uint32_t sys_define_2;		/* System defined. */
+	uint8_t	 reserved_8;
+	uint8_t	 reserved_1;
+	uint16_t reserved_2;
+	uint32_t reserved_3;
+	uint8_t	 status;
+	uint8_t	 reserved_4;
+	uint8_t	 command_count;		/* Number of ATIOs allocated. */
+	uint8_t	 immed_notify_count;	/* Number of Immediate Notify entries allocated. */
+	uint16_t reserved_5;
+	uint16_t timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
+	uint16_t reserved_6[20];
+};
+
+/*
+ * ISP queue - modify LUN entry structure definition.
+ */
+struct modify_lun_entry {
+	uint8_t	 entry_type;		    /* Entry type. */
+	uint8_t	 entry_count;		    /* Entry count. */
+	uint8_t	 sys_define;		    /* System defined. */
+	uint8_t	 entry_status;		    /* Entry Status. */
+	uint32_t sys_define_2;		    /* System defined. */
+	uint8_t	 reserved_8;
+	uint8_t	 reserved_1;
+	uint8_t	 operators;
+	uint8_t	 reserved_2;
+	uint32_t reserved_3;
+	uint8_t	 status;
+	uint8_t	 reserved_4;
+	uint8_t	 command_count;		    /* Number of ATIOs allocated. */
+	uint8_t	 immed_notify_count;	    /* Number of Immediate Notify */
+	/* entries allocated. */
+	uint16_t reserved_5;
+	uint16_t timeout;		    /* 0 = 30 seconds, 0xFFFF = disable */
+	uint16_t reserved_7[20];
+};
+
+/*
+ * ISP queue - immediate notify entry structure definition.
+ */
+struct notify_entry {
+	uint8_t	 entry_type;		    /* Entry type. */
+	uint8_t	 entry_count;		    /* Entry count. */
+	uint8_t	 sys_define;		    /* System defined. */
+	uint8_t	 entry_status;		    /* Entry Status. */
+	uint32_t sys_define_2;		    /* System defined. */
+	target_id_t target;
+	uint16_t lun;
+	uint32_t reserved_2;
+	uint16_t status;
+	uint16_t task_flags;
+	uint16_t seq_id;
+	uint16_t reserved_5[11];
+	uint16_t scsi_status;
+	uint8_t	 sense_data[16];
+	uint16_t ox_id;
+};
+
+/*
+ * ISP queue - notify acknowledge entry structure definition.
+ */
+struct nack_entry {
+	uint8_t	 entry_type;		    /* Entry type. */
+	uint8_t	 entry_count;		    /* Entry count. */
+	uint8_t	 sys_define;		    /* System defined. */
+	uint8_t	 entry_status;		    /* Entry Status. */
+	uint32_t sys_define_2;		    /* System defined. */
+	target_id_t target;
+	uint8_t	 reserved_1;
+	uint8_t	 target_id;
+	uint16_t flags;
+	uint16_t resp_code;
+	uint16_t status;
+	uint16_t task_flags;
+	uint16_t seq_id;
+	uint16_t reserved_3[20];
+	uint16_t ox_id;
+};
+
+/*
+ * ISP queue - Accept Target I/O (ATIO) entry structure definition.
+ */
+struct atio_entry {
+	uint8_t	 entry_type;		    /* Entry type. */
+	uint8_t	 entry_count;		    /* Entry count. */
+	uint8_t	 sys_define;		    /* System defined. */
+	uint8_t	 entry_status;		    /* Entry Status. */
+	uint32_t sys_define_2;		    /* System defined. */
+	target_id_t target;
+	uint16_t exchange_id;
+	uint16_t flags;
+	uint16_t status;
+	uint8_t	 command_ref;
+	uint8_t	 task_codes;
+	uint8_t	 task_flags;
+	uint8_t	 execution_codes;
+	uint8_t	 cdb[MAX_CMDSZ];
+	uint32_t data_length;
+	uint16_t lun;
+	uint8_t  initiator_port_name[WWN_SIZE]; /* on qla23xx */
+	uint8_t  reserved2[12];
+	uint16_t ox_id;
+};
+
+/*
+ * ISP queue - Continue Target I/O (CTIO) entry for status mode 0
+ *	       structure definition.
+ */
+struct ctio_common_entry {
+	uint8_t	 entry_type;		    /* Entry type. */
+	uint8_t	 entry_count;		    /* Entry count. */
+	uint8_t	 sys_define;		    /* System defined. */
+	uint8_t	 entry_status;		    /* Entry Status. */
+	uint32_t handle;		    /* System defined handle */
+	target_id_t target;
+	uint16_t exchange_id;
+	uint16_t flags;
+	uint16_t status;
+	uint16_t timeout;		    /* 0 = 30 seconds, 0xFFFF = disable */
+	uint16_t dseg_count;		    /* Data segment count. */
+	uint32_t relative_offset;
+	uint32_t residual;
+	uint16_t reserved_1[3];
+	uint16_t scsi_status;
+	uint32_t transfer_length;
+	uint32_t dseg_0_address[0];
+};
+
+/*
+ * ISP queue - CTIO returned entry structure definition.
+ */
+struct ctio_ret_entry {
+	uint8_t	 entry_type;		    /* Entry type. */
+	uint8_t	 entry_count;		    /* Entry count. */
+	uint8_t	 sys_define;		    /* System defined. */
+	uint8_t	 entry_status;		    /* Entry Status. */
+	uint32_t handle;		    /* System defined handle. */
+	target_id_t target;
+	uint16_t exchange_id;
+	uint16_t flags;
+	uint16_t status;
+	uint16_t timeout;	    /* 0 = 30 seconds, 0xFFFF = disable */
+	uint16_t dseg_count;	    /* Data segment count. */
+	uint32_t relative_offset;
+	uint32_t residual;
+	uint16_t reserved_1[2];
+	uint16_t sense_length;
+	uint16_t scsi_status;
+	uint16_t response_length;
+	uint8_t	 sense_data[26];
+};
+
+/********************************************************************\
+ * Type Definitions used by initiator & target halves
+\********************************************************************/
+
+struct q2t_cmd {
+	struct scsi_cmnd *scmd;
+	int state;
+	struct atio_entry atio;
+};
+
+struct q2t_mgmt_cmd {
+	struct list_head mgmt_siblings;
+	struct notify_entry notify_entry;
+};
+
+struct q2t_tgt {
+	scsi_qla_host_t *ha;
+	int datasegs_per_cmd;
+	int datasegs_per_cont;
+	unsigned int tgt_enable_64bit_addr:1;
+	int notify_ack_expected;
+	volatile int modify_lun_expected;
+	volatile int disable_lun_status;
+
+	/* better to put this in remote port object */
+	struct list_head mgmt_list;
+};
+
+/* we can kill this */
+struct q2t_prm {
+	struct q2t_tgt *tgt;
+	uint16_t req_cnt;
+	uint16_t seg_cnt;
+	unsigned short sg_cnt;
+	struct scatterlist *sg;
+	int bufflen;
+	enum dma_data_direction data_direction;
+	uint16_t rq_result;
+	uint16_t scsi_status;
+	unsigned char *sense_buffer;
+	unsigned int sense_buffer_len;
+	int residual;
+	struct q2t_cmd *cmd;
+	struct ctio_common_entry *pkt;
+};
+
+#endif
-- 
1.5.2.4

