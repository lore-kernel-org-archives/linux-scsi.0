From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 2/6] qla2xxx: Move function prototype to correct header
Date: Fri, 21 Jul 2017 09:32:24 -0700
Message-ID: <20170721163228.32339-3-himanshu.madhani@cavium.com>
References: <20170721163228.32339-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0051.outbound.protection.outlook.com ([104.47.42.51]:24663
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754493AbdGUQci (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jul 2017 12:32:38 -0400
In-Reply-To: <20170721163228.32339-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Cc: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  | 11 -----------
 drivers/scsi/qla2xxx/qla_isr.c  |  4 ++--
 drivers/scsi/qla2xxx/qla_nvme.c |  9 ++++-----
 drivers/scsi/qla2xxx/qla_nvme.h | 17 +++++++++++++++++
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index cadb6e3baacc..659cdf592678 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -10,17 +10,6 @@
 #include <linux/interrupt.h>
 
 /*
- * Global functions prototype in qla_nvme.c source file.
- */
-extern void qla_nvme_register_hba(scsi_qla_host_t *);
-extern int  qla_nvme_register_remote(scsi_qla_host_t *, fc_port_t *);
-extern void qla_nvme_delete(scsi_qla_host_t *);
-extern void qla_nvme_abort(struct qla_hw_data *, srb_t *sp);
-extern void qla24xx_nvme_ls4_iocb(scsi_qla_host_t *, struct pt_ls4_request *,
-    struct req_que *);
-extern void qla24xx_async_gffid_sp_done(void *, int);
-
-/*
  * Global Function Prototypes in qla_init.c source file.
  */
 extern int qla2x00_initialize_adapter(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7b3b702ef622..9127eee67478 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2827,8 +2827,8 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	sp->done(sp, 0);
 }
 
-void qla24xx_nvme_ls4_iocb(scsi_qla_host_t *vha, struct pt_ls4_request *pkt,
-    struct req_que *req)
+void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
+    struct pt_ls4_request *pkt, struct req_que *req)
 {
 	srb_t *sp;
 	const char func[] = "LS4_IOCB";
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 3c58d1b71e6e..11494f2f90b5 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -5,7 +5,6 @@
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_nvme.h"
-#include "qla_def.h"
 #include <linux/scatterlist.h>
 #include <linux/delay.h>
 #include <linux/nvme.h>
@@ -15,7 +14,7 @@ static struct nvme_fc_port_template qla_nvme_fc_transport;
 
 static void qla_nvme_unregister_remote_port(struct work_struct *);
 
-int qla_nvme_register_remote(scsi_qla_host_t *vha, fc_port_t *fcport)
+int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 {
 	struct nvme_rport *rport;
 	int ret;
@@ -616,7 +615,7 @@ static int qla_nvme_wait_on_rport_del(fc_port_t *fcport)
 	return ret;
 }
 
-void qla_nvme_abort(struct qla_hw_data *ha, srb_t *sp)
+void qla_nvme_abort(struct qla_hw_data *ha, struct srb *sp)
 {
 	int rval;
 
@@ -679,7 +678,7 @@ static void qla_nvme_unregister_remote_port(struct work_struct *work)
 	}
 }
 
-void qla_nvme_delete(scsi_qla_host_t *vha)
+void qla_nvme_delete(struct scsi_qla_host *vha)
 {
 	struct nvme_rport *rport, *trport;
 	fc_port_t *fcport;
@@ -711,7 +710,7 @@ void qla_nvme_delete(scsi_qla_host_t *vha)
 	}
 }
 
-void qla_nvme_register_hba(scsi_qla_host_t *vha)
+void qla_nvme_register_hba(struct scsi_qla_host *vha)
 {
 	struct nvme_fc_port_template *tmpl;
 	struct qla_hw_data *ha;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
index dfe56f207b28..7f05fa1c77db 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.h
+++ b/drivers/scsi/qla2xxx/qla_nvme.h
@@ -12,12 +12,18 @@
 #include <uapi/scsi/fc/fc_els.h>
 #include <linux/nvme-fc-driver.h>
 
+#include "qla_def.h"
+
 #define NVME_ATIO_CMD_OFF 32
 #define NVME_FIRST_PACKET_CMDLEN (64 - NVME_ATIO_CMD_OFF)
 #define Q2T_NVME_NUM_TAGS 2048
 #define QLA_MAX_FC_SEGMENTS 64
 
+struct scsi_qla_host;
+struct qla_hw_data;
+struct req_que;
 struct srb;
+
 struct nvme_private {
 	struct srb	*sp;
 	struct nvmefc_ls_req *fd;
@@ -129,4 +135,15 @@ struct pt_ls4_rx_unsol {
 	uint32_t desc_len;
 	uint32_t payload[3];
 };
+
+/*
+ * Global functions prototype in qla_nvme.c source file.
+ */
+void qla_nvme_register_hba(struct scsi_qla_host *);
+int  qla_nvme_register_remote(struct scsi_qla_host *, struct fc_port *);
+void qla_nvme_delete(struct scsi_qla_host *);
+void qla_nvme_abort(struct qla_hw_data *, struct srb *sp);
+void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *, struct pt_ls4_request *,
+    struct req_que *);
+void qla24xx_async_gffid_sp_done(void *, int);
 #endif
-- 
2.12.0
