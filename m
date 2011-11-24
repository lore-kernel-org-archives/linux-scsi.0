From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH] qla2xxx: simplify qla24xx_update_fcport_fcp_prio
Date: Thu, 24 Nov 2011 01:23:16 +0100
Message-ID: <20111124002316.GA23013@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.183.114.52] ([85.183.114.52]:44747 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751604Ab1KXA5f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2011 19:57:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

- make it static
- remove unused mb field
- remove mb parameter from qla24xx_set_fcp_prio

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 +---
 drivers/scsi/qla2xxx/qla_init.c |    5 ++---
 drivers/scsi/qla2xxx/qla_mbx.c  |    9 +--------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index b3f4fcd..76ef618 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -74,7 +74,6 @@ extern void qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
 extern void qla2x00_async_tm_cmd_done(struct scsi_qla_host *, fc_port_t *,
 	struct srb_iocb *);
 extern void *qla2x00_alloc_iocbs(struct scsi_qla_host *, srb_t *);
-extern int qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *, fc_port_t *);
 
 extern fc_port_t *
 qla2x00_alloc_fcport(scsi_qla_host_t *, gfp_t );
@@ -368,8 +367,7 @@ qla2x00_write_ram_word(scsi_qla_host_t *, uint32_t, uint32_t);
 extern int
 qla81xx_write_mpi_register(scsi_qla_host_t *, uint16_t *);
 extern int qla2x00_get_data_rate(scsi_qla_host_t *);
-extern int qla24xx_set_fcp_prio(scsi_qla_host_t *, uint16_t, uint16_t,
-	uint16_t *);
+extern int qla24xx_set_fcp_prio(scsi_qla_host_t *, uint16_t, uint16_t);
 extern int
 qla81xx_get_port_config(scsi_qla_host_t *, uint16_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b904666..3310f17 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5710,12 +5710,11 @@ qla24xx_get_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
  * Context:
  *	Kernel context.
  */
-int
+static int
 qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	int ret;
 	int priority;
-	uint16_t mb[5];
 
 	if (fcport->port_type != FCT_TARGET ||
 	    fcport->loop_id == FC_NO_LOOP_ID)
@@ -5725,7 +5724,7 @@ qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (priority < 0)
 		return QLA_FUNCTION_FAILED;
 
-	ret = qla24xx_set_fcp_prio(vha, fcport->loop_id, priority, mb);
+	ret = qla24xx_set_fcp_prio(vha, fcport->loop_id, priority);
 	if (ret == QLA_SUCCESS)
 		fcport->fcp_prio = priority;
 	else
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b4a0dfd..af436d2 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4157,8 +4157,7 @@ qla81xx_set_port_config(scsi_qla_host_t *vha, uint16_t *mb)
 
 
 int
-qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority,
-		uint16_t *mb)
+qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -4183,12 +4182,6 @@ qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority,
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
-	if (mb != NULL) {
-		mb[0] = mcp->mb[0];
-		mb[1] = mcp->mb[1];
-		mb[3] = mcp->mb[3];
-		mb[4] = mcp->mb[4];
-	}
 
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_mbx, vha, 0x10cd, "Failed=%x.\n", rval);
-- 
1.7.7.1

