From: madhu.iyengar@qlogic.com
Subject: [PATCH 05/14] qla2xxx: Update FCP priority information to firmware before sending IOs
Date: Tue, 21 Dec 2010 16:00:18 -0800
Message-ID: <1292976027-12034-6-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36154 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752862Ab0LVADX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:23 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

The FCP priority info was not being updated properly in certain situations.
Here are the changes that needs to be done to take care of this issue:
1. No need to check fcport->state for FCS_UNCONFIGURED in
qla24xx_update_fcport_fcp_prio(), since an invalid loop id check is
already performed which is sufficient.
2. Add the missing qla24xx_update_fcport_fcp_prio() function call
within qla2x00_update_fcport() function, so that the priority info
is updated on every port addition or change.
3. Perform proper adapter types checking.
4. Other changes, associated with DEBUG/printk's and parameter passing.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   18 +++++++++---------
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 6146d39..10942fc 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -103,7 +103,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply->reply_payload_rcv_len = 0;
 
-	if (!IS_QLA24XX_TYPE(ha) || !IS_QLA25XX(ha)) {
+	if (!(IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))) {
 		ret = -EINVAL;
 		goto exit_fcp_prio_cfg;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 1370f05..c228d24 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -70,6 +70,7 @@ extern void qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
 extern void qla2x00_async_tm_cmd_done(struct scsi_qla_host *, fc_port_t *,
 	struct srb_iocb *);
 extern void *qla2x00_alloc_iocbs(struct scsi_qla_host *, srb_t *);
+extern int qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *, fc_port_t *);
 
 extern fc_port_t *
 qla2x00_alloc_fcport(scsi_qla_host_t *, gfp_t );
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e9b800e..c8ca25a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2928,6 +2928,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 
 	qla2x00_iidma_fcport(vha, fcport);
+	qla24xx_update_fcport_fcp_prio(vha, fcport);
 	qla2x00_reg_remote_port(vha, fcport);
 	atomic_set(&fcport->state, FCS_ONLINE);
 }
@@ -5473,7 +5474,7 @@ qla81xx_update_fw_options(scsi_qla_host_t *vha)
  *	the tag (priority) value is returned.
  *
  * Input:
- *	ha = adapter block po
+ *	vha = scsi host structure pointer.
  *	fcport = port structure pointer.
  *
  * Return:
@@ -5567,7 +5568,7 @@ qla24xx_get_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
  *	Activates fcp priority for the logged in fc port
  *
  * Input:
- *	ha = adapter block pointer.
+ *	vha = scsi host structure pointer.
  *	fcp = port structure pointer.
  *
  * Return:
@@ -5577,25 +5578,24 @@ qla24xx_get_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
  *	Kernel context.
  */
 int
-qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *ha, fc_port_t *fcport)
+qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
 	int ret;
 	uint8_t priority;
 	uint16_t mb[5];
 
-	if (atomic_read(&fcport->state) == FCS_UNCONFIGURED ||
-		fcport->port_type != FCT_TARGET ||
-		fcport->loop_id == FC_NO_LOOP_ID)
+	if (fcport->port_type != FCT_TARGET ||
+	    fcport->loop_id == FC_NO_LOOP_ID)
 		return QLA_FUNCTION_FAILED;
 
-	priority = qla24xx_get_fcp_prio(ha, fcport);
-	ret = qla24xx_set_fcp_prio(ha, fcport->loop_id, priority, mb);
+	priority = qla24xx_get_fcp_prio(vha, fcport);
+	ret = qla24xx_set_fcp_prio(vha, fcport->loop_id, priority, mb);
 	if (ret == QLA_SUCCESS)
 		fcport->fcp_prio = priority;
 	else
 		DEBUG2(printk(KERN_WARNING
 			"scsi(%ld): Unable to activate fcp priority, "
-			" ret=0x%x\n", ha->host_no, ret));
+			" ret=0x%x\n", vha->host_no, ret));
 
 	return  ret;
 }
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index effd8a1..04d6cfc 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4125,7 +4125,7 @@ qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority,
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk(KERN_INFO
-	    "%s(%ld): entered.\n", __func__, ha->host_no));
+	    "%s(%ld): entered.\n", __func__, vha->host_no));
 
 	mcp->mb[0] = MBC_PORT_PARAMS;
 	mcp->mb[1] = loop_id;
-- 
1.6.0.2

