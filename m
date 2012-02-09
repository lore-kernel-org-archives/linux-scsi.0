From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 14/29] qla2xxx: Print mailbox command opcode and return code when a command times out.
Date: Thu, 9 Feb 2012 11:15:46 -0800
Message-ID: <1328814961-21866-15-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:31841
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758449Ab2BITcO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:14 -0500
Received: from mail42-ch1 (localhost [127.0.0.1])	by mail42-ch1-R.bigfish.com
 (Postfix) with ESMTP id 5430B200147	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:13 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 5470177..bde3eb2 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -90,7 +90,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	if (!wait_for_completion_timeout(&ha->mbx_cmd_comp, mcp->tov * HZ)) {
 		/* Timeout occurred. Return error. */
 		ql_log(ql_log_warn, base_vha, 0x1005,
-		    "Cmd access timeout, Exiting.\n");
+		    "Cmd access timeout, cmd=0x%x, Exiting.\n",
+		    mcp->mb[0]);
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
@@ -313,9 +314,10 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 					    CRB_NIU_XG_PAUSE_CTL_P1);
 				}
 				ql_log(ql_log_info, base_vha, 0x101c,
-				    "Mailbox cmd timeout occured. "
-				    "Scheduling ISP abort eeh_busy=0x%x.\n",
-					ha->flags.eeh_busy);
+				    "Mailbox cmd timeout occured, cmd=0x%x, "
+				    "mb[0]=0x%x, eeh_busy=0x%x. Scheduling ISP "
+				    "abort.\n", command, mcp->mb[0],
+				    ha->flags.eeh_busy);
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 				qla2xxx_wake_dpc(vha);
 			}
@@ -337,9 +339,9 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 					    CRB_NIU_XG_PAUSE_CTL_P1);
 				}
 				ql_log(ql_log_info, base_vha, 0x101e,
-				    "Mailbox cmd timeout occured. "
-				    "Scheduling ISP abort.\n");
-
+				    "Mailbox cmd timeout occured, cmd=0x%x, "
+				    "mb[0]=0x%x. Scheduling ISP abort ",
+				    command, mcp->mb[0]);
 				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
 				clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 				/* Allow next mbx cmd to come in. */
-- 
1.6.0.2


