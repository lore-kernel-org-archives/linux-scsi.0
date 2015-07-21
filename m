From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] qla2xxx: Return the fabric command state for non-task management requests
Date: Tue, 21 Jul 2015 15:07:55 -0700
Message-ID: <1437516477-30554-3-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "open list:QLOGIC QLA2XXX FC-SCSI DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Dilip Kumar Uppugandla <dilip@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Dilip Kumar Uppugandla <dilip@purestorage.com>

Invoking get_cmd_state for qla2xxx always returns 0. Instead change it
to return the actual fabric state from qla_tgt_cmd. This will help with
debugging.

Signed-off-by: Dilip Kumar Uppugandla <dilip@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index d9a8c60..e859586 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -420,6 +420,12 @@ static void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *nacl)
 
 static int tcm_qla2xxx_get_cmd_state(struct se_cmd *se_cmd)
 {
+	if (!(se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
+		struct qla_tgt_cmd *cmd = container_of(se_cmd,
+				struct qla_tgt_cmd, se_cmd);
+		return cmd->state;
+	}
+
 	return 0;
 }
 
-- 
2.4.3
