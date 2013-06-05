From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] tcm_qla2xxx: Fix residual for underrun commands that fail
Date: Wed,  5 Jun 2013 09:54:17 -0700
Message-ID: <1370451257-20892-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:47850 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756190Ab3FEQy1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 12:54:27 -0400
Received: by mail-pd0-f174.google.com with SMTP id 10so1109654pdc.5
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jun 2013 09:54:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-driver@qlogic.com, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

Suppose an initiator sends a DATA IN command with an allocation length
shorter than the FC transfer length -- we get a target message like

    TARGET_CORE[qla2xxx]: Expected Transfer Length: 256 does not match SCSI CDB Length: 0 for SAM Opcode: 0x12

In that case, the target core adjusts the data_length and sets
se_cmd->residual_count for the underrun.  But now suppose that command
fails and we end up in tcm_qla2xxx_queue_status() -- that function
unconditionally overwrites residual_count with the already adjusted
data_length, and the initiator will burp with a message like

    qla2xxx [0000:00:06.0]-301d:0: Dropped frame(s) detected (0x100 of 0x100 bytes).

Fix this by adding on to the existing underflow residual count instead.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7a3870f..66b0b26 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -688,8 +688,12 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 		 * For FCP_READ with CHECK_CONDITION status, clear cmd->bufflen
 		 * for qla_tgt_xmit_response LLD code
 		 */
+		if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
+			se_cmd->se_cmd_flags &= ~SCF_OVERFLOW_BIT;
+			se_cmd->residual_count = 0;
+		}
 		se_cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-		se_cmd->residual_count = se_cmd->data_length;
+		se_cmd->residual_count += se_cmd->data_length;
 
 		cmd->bufflen = 0;
 	}
-- 
1.8.1.2

