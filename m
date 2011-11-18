From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 10/14] qla2xxx: Clear mailbox busy flag during premature mailbox completion for ISP82xx.
Date: Fri, 18 Nov 2011 09:02:18 -0800
Message-ID: <1321635742-16426-11-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:29032
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758200Ab1KRRPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:30 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.cim>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 ++
 drivers/scsi/qla2xxx/qla_nx.c  |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f965a57..6ff7c3c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -162,6 +162,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 				HINT_MBX_INT_PENDING) {
 				spin_unlock_irqrestore(&ha->hardware_lock,
 					flags);
+				ha->flags.mbox_busy = 0;
 				ql_dbg(ql_dbg_mbx, base_vha, 0x1010,
 				    "Pending mailbox timeout, exiting.\n");
 				rval = QLA_FUNCTION_TIMEOUT;
@@ -187,6 +188,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 				HINT_MBX_INT_PENDING) {
 				spin_unlock_irqrestore(&ha->hardware_lock,
 					flags);
+				ha->flags.mbox_busy = 0;
 				ql_dbg(ql_dbg_mbx, base_vha, 0x1012,
 				    "Pending mailbox timeout, exiting.\n");
 				rval = QLA_FUNCTION_TIMEOUT;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 9e2c192..a54f15e 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3823,6 +3823,7 @@ void qla82xx_clear_pending_mbx(scsi_qla_host_t *vha)
 
 	if (ha->flags.mbox_busy) {
 		ha->flags.mbox_int = 1;
+		ha->flags.mbox_busy = 0;
 		ql_log(ql_log_warn, vha, 0x6010,
 		    "Doing premature completion of mbx command.\n");
 		if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags))
-- 
1.6.0.2


