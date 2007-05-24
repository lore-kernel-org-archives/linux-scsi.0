From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH 5/8] qla4xxx: Resubmission: update rev num and misc cleanup
Date: Wed, 23 May 2007 18:14:34 -0700
Message-ID: <1179969274.16099.27.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7599 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbXEXBPg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 21:15:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

Clean up and update version number

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

 drivers/scsi/qla4xxx/ql4_glbl.h    |    7 ++++++-
 drivers/scsi/qla4xxx/ql4_iocb.c    |    8 ++++++--
 drivers/scsi/qla4xxx/ql4_nvram.c   |    3 +++
 drivers/scsi/qla4xxx/ql4_version.h |    3 ++-
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 5b00cb0..a3608e0 100644
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
@@ -58,11 +61,13 @@ int qla4xxx_get_fw_version(struct scsi_q
 void qla4xxx_interrupt_service_routine(struct scsi_qla_host * ha,
 				       uint32_t intr_status);
 int qla4xxx_init_rings(struct scsi_qla_host * ha);
-struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha, uint32_t index);
+struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
+					uint32_t index);
 void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb);
 int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host * ha);
 int qla4xxx_process_ddb_changed(struct scsi_qla_host * ha,
 				uint32_t fw_ddb_index, uint32_t state);
+void qla4xxx_dump_buffer(void *b, uint32_t size);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index a216a17..6e3c8c8 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -6,6 +6,10 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
+
 
 #include <scsi/scsi_tcq.h>
 
@@ -243,8 +247,8 @@ int qla4xxx_send_command_to_isp(struct s
 		dma_addr_t	req_dma;
 
 		req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
-					 cmd->request_bufflen,
-					 cmd->sc_data_direction);
+				 cmd->request_bufflen,
+				 cmd->sc_data_direction);
 		if (dma_mapping_error(req_dma))
 			goto queuing_error;
 
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index 58afd13..7fe0482 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -6,6 +6,9 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 static inline void eeprom_cmd(uint32_t cmd, struct scsi_qla_host *ha)
 {
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

