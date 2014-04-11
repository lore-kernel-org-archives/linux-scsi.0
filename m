From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 26/42] qla2xxx: Avoid escalating the SCSI error handler if the command is not found in firmware.
Date: Fri, 11 Apr 2014 16:54:31 -0400
Message-ID: <1397249687-32666-27-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:60786 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854AbaDKVcB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:01 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If the firmware cannot find the command specified then return SUCCESS to the
error handler so as not to needlessly escalate.  Also cleanup the resources for
the command since we cannot expect the original command to returned in
interrupt context.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 ++
 drivers/scsi/qla2xxx/qla_mbx.c |    5 ++++-
 drivers/scsi/qla2xxx/qla_os.c  |   24 ++++++++++++++++++++----
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a81e8ba..6c9724c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1755,6 +1755,8 @@ typedef struct {
 #define CS_PORT_CONFIG_CHG	0x2A	/* Port Configuration Changed */
 #define CS_PORT_BUSY		0x2B	/* Port Busy */
 #define CS_COMPLETE_CHKCOND	0x30	/* Error? */
+#define CS_IOCB_ERROR		0x31	/* Generic error for IOCB request
+					   failure */
 #define CS_BAD_PAYLOAD		0x80	/* Driver defined */
 #define CS_UNKNOWN		0x81	/* Driver defined */
 #define CS_RETRY		0x82	/* Driver defined */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a2e3787..01d9f54 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2644,7 +2644,10 @@ qla24xx_abort_command(srb_t *sp)
 		ql_dbg(ql_dbg_mbx, vha, 0x1090,
 		    "Failed to complete IOCB -- completion status (%x).\n",
 		    le16_to_cpu(abt->nport_handle));
-		rval = QLA_FUNCTION_FAILED;
+		if (abt->nport_handle == CS_IOCB_ERROR)
+			rval = QLA_FUNCTION_PARAMETER_ERROR;
+		else
+			rval = QLA_FUNCTION_FAILED;
 	} else {
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1091,
 		    "Done %s.\n", __func__);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b182d276..8f1a098 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -945,7 +945,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	int ret;
 	unsigned int id, lun;
 	unsigned long flags;
-	int wait = 0;
+	int rval, wait = 0;
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!CMD_SP(cmd))
@@ -974,10 +974,20 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	sp_get(sp);
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	if (ha->isp_ops->abort_command(sp)) {
-		ret = FAILED;
+	rval = ha->isp_ops->abort_command(sp);
+	if (rval) {
+		if (rval == QLA_FUNCTION_PARAMETER_ERROR) {
+			/*
+			 * Decrement the ref_count since we can't find the
+			 * command
+			 */
+			atomic_dec(&sp->ref_count);
+			ret = SUCCESS;
+		} else
+			ret = FAILED;
+
 		ql_dbg(ql_dbg_taskm, vha, 0x8003,
-		    "Abort command mbx failed cmd=%p.\n", cmd);
+		    "Abort command mbx failed cmd=%p, rval=%x.\n", cmd, rval);
 	} else {
 		ql_dbg(ql_dbg_taskm, vha, 0x8004,
 		    "Abort command mbx success cmd=%p.\n", cmd);
@@ -985,6 +995,12 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
+	/*
+	 * Clear the slot in the oustanding_cmds array if we can't find the
+	 * command to reclaim the resources.
+	 */
+	if (rval == QLA_FUNCTION_PARAMETER_ERROR)
+		vha->req->outstanding_cmds[sp->handle] = NULL;
 	sp->done(ha, sp, 0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-- 
1.7.7

