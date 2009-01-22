From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 04/12] qla2xxx: Always serialize mailbox command execution.
Date: Thu, 22 Jan 2009 09:45:31 -0800
Message-ID: <1232646339-32503-5-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242AbZAVRpo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:44 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original code would incorrectly bypass serialization if the DPC
thread were performing a big-hammer operation (ISP abort).  This
short circuit, though rare, would subsequently stomp on a
secondary thread's mailbox command execution.  Found during
ISP81XX testing.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index db4df45..f94ffbb 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -58,14 +58,11 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	 * seconds. This is to serialize actual issuing of mailbox cmds during
 	 * non ISP abort time.
 	 */
-	if (!abort_active) {
-		if (!wait_for_completion_timeout(&ha->mbx_cmd_comp,
-		    mcp->tov * HZ)) {
-			/* Timeout occurred. Return error. */
-			DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
-			    "Exiting.\n", __func__, base_vha->host_no));
-			return QLA_FUNCTION_TIMEOUT;
-		}
+	if (!wait_for_completion_timeout(&ha->mbx_cmd_comp, mcp->tov * HZ)) {
+		/* Timeout occurred. Return error. */
+		DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
+		    "Exiting.\n", __func__, base_vha->host_no));
+		return QLA_FUNCTION_TIMEOUT;
 	}
 
 	ha->flags.mbox_busy = 1;
@@ -265,8 +262,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	}
 
 	/* Allow next mbx cmd to come in. */
-	if (!abort_active)
-		complete(&ha->mbx_cmd_comp);
+	complete(&ha->mbx_cmd_comp);
 
 	if (rval) {
 		DEBUG2_3_11(printk("%s(%ld): **** FAILED. mbx0=%x, mbx1=%x, "
-- 
1.6.1.48.ge9b8

