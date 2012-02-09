From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 08/11] qla2xxx: Complete mailbox command timedout to avoid initialization failures during next reset cycle.
Date: Thu, 9 Feb 2012 11:14:10 -0800
Message-ID: <1328814853-21764-9-git-send-email-chad.dupuis@qlogic.com>
References: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:30396
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758300Ab2BITa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:29 -0500
Received: from mail158-ch1 (localhost [127.0.0.1])	by
 mail158-ch1-R.bigfish.com (Postfix) with ESMTP id D2B923400C9	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:30:28 +0000 (UTC)
In-Reply-To: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Complete the mailbox command timed out before initiating another abort cycle
to recover so that mailbox commands issued during next reset cycle don't fail
due to pending mailbox access timeout.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 8635722..08f1d01 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -342,6 +342,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
 				clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+				/* Allow next mbx cmd to come in. */
+				complete(&ha->mbx_cmd_comp);
 				if (ha->isp_ops->abort_isp(vha)) {
 					/* Failed. retry later. */
 					set_bit(ISP_ABORT_NEEDED,
@@ -350,6 +352,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 				clear_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
 				ql_dbg(ql_dbg_mbx, base_vha, 0x101f,
 				    "Finished abort_isp.\n");
+				goto mbx_done;
 			}
 		}
 	}
@@ -358,6 +361,7 @@ premature_exit:
 	/* Allow next mbx cmd to come in. */
 	complete(&ha->mbx_cmd_comp);
 
+mbx_done:
 	if (rval) {
 		ql_dbg(ql_dbg_mbx, base_vha, 0x1020,
 		    "**** Failed mbx[0]=%x, mb[1]=%x, mb[2]=%x, cmd=%x ****.\n",
-- 
1.6.0.2


