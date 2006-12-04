From: akpm@osdl.org
Subject: [patch 22/30] make qla2x00_reg_remote_port() static
Date: Mon, 04 Dec 2006 15:18:39 -0800
Message-ID: <200612042319.kB4NJm9q008798@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57557 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967804AbWLDXXR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:23:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de, andrew.vasquez@qlogic.com

From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qla2xxx/qla_gbl.h  |    1 
 drivers/scsi/qla2xxx/qla_init.c |   68 +++++++++++++++---------------
 2 files changed, 34 insertions(+), 35 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_gbl.h~make-qla2x00_reg_remote_port-static drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h~make-qla2x00_reg_remote_port-static
+++ a/drivers/scsi/qla2xxx/qla_gbl.h
@@ -45,7 +45,6 @@ extern void qla2x00_update_fcports(scsi_
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
 
 extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
-extern void qla2x00_reg_remote_port(scsi_qla_host_t *, fc_port_t *);
 
 extern void qla2x00_alloc_fw_dump(scsi_qla_host_t *);
 extern void qla2x00_try_to_stop_firmware(scsi_qla_host_t *);
diff -puN drivers/scsi/qla2xxx/qla_init.c~make-qla2x00_reg_remote_port-static drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c~make-qla2x00_reg_remote_port-static
+++ a/drivers/scsi/qla2xxx/qla_init.c
@@ -2103,40 +2103,7 @@ qla2x00_iidma_fcport(scsi_qla_host_t *ha
 	}
 }
 
-/*
- * qla2x00_update_fcport
- *	Updates device on list.
- *
- * Input:
- *	ha = adapter block pointer.
- *	fcport = port structure pointer.
- *
- * Return:
- *	0  - Success
- *  BIT_0 - error
- *
- * Context:
- *	Kernel context.
- */
-void
-qla2x00_update_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
-{
-	fcport->ha = ha;
-	fcport->login_retry = 0;
-	fcport->port_login_retry_count = ha->port_down_retry_count *
-	    PORT_RETRY_TIME;
-	atomic_set(&fcport->port_down_timer, ha->port_down_retry_count *
-	    PORT_RETRY_TIME);
-	fcport->flags &= ~FCF_LOGIN_NEEDED;
-
-	qla2x00_iidma_fcport(ha, fcport);
-
-	atomic_set(&fcport->state, FCS_ONLINE);
-
-	qla2x00_reg_remote_port(ha, fcport);
-}
-
-void
+static void
 qla2x00_reg_remote_port(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
 	struct fc_rport_identifiers rport_ids;
@@ -2179,6 +2146,39 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 }
 
 /*
+ * qla2x00_update_fcport
+ *	Updates device on list.
+ *
+ * Input:
+ *	ha = adapter block pointer.
+ *	fcport = port structure pointer.
+ *
+ * Return:
+ *	0  - Success
+ *  BIT_0 - error
+ *
+ * Context:
+ *	Kernel context.
+ */
+void
+qla2x00_update_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
+{
+	fcport->ha = ha;
+	fcport->login_retry = 0;
+	fcport->port_login_retry_count = ha->port_down_retry_count *
+	    PORT_RETRY_TIME;
+	atomic_set(&fcport->port_down_timer, ha->port_down_retry_count *
+	    PORT_RETRY_TIME);
+	fcport->flags &= ~FCF_LOGIN_NEEDED;
+
+	qla2x00_iidma_fcport(ha, fcport);
+
+	atomic_set(&fcport->state, FCS_ONLINE);
+
+	qla2x00_reg_remote_port(ha, fcport);
+}
+
+/*
  * qla2x00_configure_fabric
  *      Setup SNS devices with loop ID's.
  *
_
