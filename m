From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 15/18] qla2xxx: Implement FCP priority tagging for 82xx adapters.
Date: Fri, 18 Nov 2011 09:03:19 -0800
Message-ID: <1321635802-16491-16-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:30740
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758261Ab1KRRQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:31 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

This provides a capability to set a priority in the FCP packet.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    7 ++++++-
 drivers/scsi/qla2xxx/qla_iocb.c |    9 +++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 371d0de..c0bc0c6 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -102,7 +102,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply->reply_payload_rcv_len = 0;
 
-	if (!(IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))) {
+	if (!(IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) || IS_QLA82XX(ha))) {
 		ret = -EINVAL;
 		goto exit_fcp_prio_cfg;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ec73cc1..05931e6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5642,6 +5642,11 @@ qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (priority < 0)
 		return QLA_FUNCTION_FAILED;
 
+	if (IS_QLA82XX(vha->hw)) {
+		fcport->fcp_prio = priority & 0xf;
+		return QLA_SUCCESS;
+	}
+
 	ret = qla24xx_set_fcp_prio(vha, fcport->loop_id, priority, mb);
 	if (ret == QLA_SUCCESS) {
 		if (fcport->fcp_prio != priority)
@@ -5650,7 +5655,7 @@ qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 			    "port_id=%02x%02x%02x.\n", priority,
 			    fcport->loop_id, fcport->d_id.b.domain,
 			    fcport->d_id.b.area, fcport->d_id.b.al_pa);
-		fcport->fcp_prio = priority;
+		fcport->fcp_prio = priority & 0xf;
 	} else
 		ql_dbg(ql_dbg_user, vha, 0x704f,
 		    "Unable to update FCP_CMND priority - ret=0x%x for "
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d2cc0cc..841ffb3 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2432,6 +2432,11 @@ sufficient_dsds:
 			}
 		}
 
+		/* Populate the FCP_PRIO. */
+		if (ha->flags.fcp_prio_enabled)
+			ctx->fcp_cmnd->task_attribute |=
+			    sp->fcport->fcp_prio << 3;
+
 		memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
 
 		fcp_dl = (uint32_t *)(ctx->fcp_cmnd->cdb + 16 +
@@ -2501,6 +2506,10 @@ sufficient_dsds:
 			}
 		}
 
+		/* Populate the FCP_PRIO. */
+		if (ha->flags.fcp_prio_enabled)
+			cmd_pkt->task |= sp->fcport->fcp_prio << 3;
+
 		/* Load SCSI command packet. */
 		memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
 		host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
-- 
1.6.0.2


