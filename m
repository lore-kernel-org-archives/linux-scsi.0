From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH 5/5] qla4xxx: Add IPv6 support and misc
Date: Wed, 02 May 2007 19:16:54 -0700
Message-ID: <1178158614.21709.10.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39559 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767300AbXECBQv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2007 21:16:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>

---
 drivers/scsi/qla4xxx/ql4_dbg.c     |    5 
 drivers/scsi/qla4xxx/ql4_glbl.h    |   12 +
 drivers/scsi/qla4xxx/ql4_iocb.c    |   39 ++-
 drivers/scsi/qla4xxx/ql4_nvram.c   |    4 
 drivers/scsi/qla4xxx/ql4_os.c      |   28 ++
 drivers/scsi/qla4xxx/ql4_version.h |    3 

diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
index 7b4e077..81fac0f 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -6,6 +6,11 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_version.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
+
 #include <scsi/scsi_dbg.h>
 
 static void qla4xxx_print_srb_info(struct srb * srb)
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index e021eb5..188b4e5 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -8,6 +8,9 @@
 #ifndef __QLA4x_GBL_H
 #define	__QLA4x_GBL_H
 
+struct iscsi_cls_conn;
+
+void qla4xxx_hw_reset(struct scsi_qla_host *ha);
 int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a);
 int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port);
 int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb);
@@ -67,14 +70,19 @@ void qla4xxx_interrupt_service_routine(s
 				       uint32_t intr_status);
 int qla4xxx_init_rings(struct scsi_qla_host * ha);
 void qla4xxx_dump_buffer(void *b, uint32_t size);
-struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha, uint32_t index);
+struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
+						uint32_t index);
 void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb);
 int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host * ha);
 int qla4xxx_process_ddb_changed(struct scsi_qla_host * ha,
 				uint32_t fw_ddb_index, uint32_t state);
 
+int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
+				uint8_t outCount, uint32_t *mbx_cmd,
+				uint32_t *mbx_sts);
+
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
 extern int ql4xdontresethba;
 extern int ql4_mod_unload;
-#endif /* _QLA4x_GBL_H */
+#endif	/* _QLA4x_GBL_H */
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index d41ce38..51f6753 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -6,6 +6,11 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_version.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
+
 
 #include <scsi/scsi_tcq.h>
 
@@ -233,23 +238,27 @@ int qla4xxx_send_command_to_isp(struct s
 	index = (uint32_t)cmd->request->tag;
 
 	/* Calculate the number of request entries needed. */
-	if (cmd->use_sg) {
-		sg = (struct scatterlist *)cmd->request_buffer;
-		tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-				      cmd->sc_data_direction);
-		if (tot_dsds == 0)
-			goto queuing_error;
-	} else if (cmd->request_bufflen) {
-		dma_addr_t	req_dma;
-
-		req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
+	if (srb->flags & SRB_SCSI_PASSTHRU) {
+		tot_dsds = 1;
+	} else {
+		if (cmd->use_sg) {
+			sg = (struct scatterlist *)cmd->request_buffer;
+			tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
+					      cmd->sc_data_direction);
+			if (tot_dsds == 0)
+				goto queuing_error;
+		} else if (cmd->request_bufflen) {
+			dma_addr_t	req_dma;
+
+			req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
 					 cmd->request_bufflen,
 					 cmd->sc_data_direction);
-		if (dma_mapping_error(req_dma))
-			goto queuing_error;
+			if (dma_mapping_error(req_dma))
+				goto queuing_error;
 
-		srb->dma_handle = req_dma;
-		tot_dsds = 1;
+			srb->dma_handle = req_dma;
+			tot_dsds = 1;
+		}
 	}
 	req_cnt = qla4xxx_calc_request_entries(tot_dsds);
 
@@ -359,6 +368,8 @@ int qla4xxx_send_command_to_isp(struct s
 	return QLA_SUCCESS;
 
 queuing_error:
+	if (srb->flags & SRB_SCSI_PASSTHRU)
+		return QLA_ERROR;
 
 	if (cmd->use_sg && tot_dsds) {
 		sg = (struct scatterlist *) cmd->request_buffer;
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index 58afd13..67cfd0a 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -6,6 +6,10 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_version.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 static inline void eeprom_cmd(uint32_t cmd, struct scsi_qla_host *ha)
 {
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0bfddf8..f7564ee 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -10,6 +10,10 @@ #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
 
 #include "ql4_def.h"
+#include "ql4_version.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 /*
  * Driver version
@@ -283,6 +287,7 @@ int qla4xxx_add_sess(struct ddb_entry *d
 	}
 
 	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
+
 	iscsi_if_create_session_done(ddb_entry->conn);
 	return 0;
 }
@@ -387,9 +392,10 @@ void qla4xxx_srb_compl(struct scsi_qla_h
 {
 	struct scsi_cmnd *cmd = srb->cmd;
 
-	qla4xxx_srb_free_dma(ha, srb);
-
-	mempool_free(srb, ha->srb_mempool);
+	if (!(srb->flags & SRB_SCSI_PASSTHRU)) {
+		qla4xxx_srb_free_dma(ha, srb);
+		mempool_free(srb, ha->srb_mempool);
+	}
 
 	cmd->scsi_done(cmd);
 }
@@ -712,7 +718,7 @@ static int qla4xxx_cmd_wait(struct scsi_
 	return stat;
 }
 
-static void qla4xxx_hw_reset(struct scsi_qla_host *ha)
+void qla4xxx_hw_reset(struct scsi_qla_host *ha)
 {
 	uint32_t ctrl_status;
 	unsigned long flags = 0;
@@ -1082,13 +1088,13 @@ static void qla4xxx_free_adapter(struct 
 	if (ha->timer_active)
 		qla4xxx_stop_timer(ha);
 
-	/* free extra memory */
-	qla4xxx_mem_free(ha);
-
 	/* Detach interrupts */
 	if (test_and_clear_bit(AF_IRQ_ATTACHED, &ha->flags))
 		free_irq(ha->pdev->irq, ha);
 
+	/* free extra memory */
+	qla4xxx_mem_free(ha);
+
 	pci_disable_device(ha->pdev);
 
 }
@@ -1197,6 +1203,9 @@ static int __devinit qla4xxx_probe_adapt
 	ha->host = host;
 	ha->host_no = host->host_no;
 
+	ha->ql4mbx = qla4xxx_mailbox_command;
+	ha->ql4cmd = qla4xxx_send_command_to_isp;
+
 	/* Configure PCI I/O space. */
 	ret = qla4xxx_iospace_config(ha);
 	if (ret)
@@ -1333,6 +1342,11 @@ static void __devexit qla4xxx_remove_ada
 
 	ha = pci_get_drvdata(pdev);
 
+	qla4xxx_disable_intrs(ha);
+
+	while (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
+		ssleep(1);
+
 	/* remove devs from iscsi_sessions to scsi_devices */
 	qla4xxx_free_ddb_list(ha);
 
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index e5183a6..2149069 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,5 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.00.07-k1"
+#define QLA4XXX_DRIVER_VERSION	"5.01.00-k7"
+
-- 
1.4.2.3


