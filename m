From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 05/37] target: Fix transport_cmd_finish_abort queue removal bug
Date: Fri, 14 Oct 2011 00:41:37 +0000
Message-ID: <1318552929-13341-6-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in LUN_RESET operation with transport_cmd_finish_abort()
where transport_remove_cmd_from_queue() was incorrectly being called, causing
descriptors with t_state == TRANSPORT_FREE_CMD_INTR to be incorrectly removed
from qobj->qobj_list during process context release.  This change ensures the
descriptor is only removed via transport_remove_cmd_from_queue() when doing a
direct release via transport_generic_remove().

Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
---
 drivers/target/target_core_transport.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 046da7f..009547b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -593,13 +593,14 @@ check_lun:
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
 	transport_lun_remove_cmd(cmd);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
-	if (remove)
+	if (remove) {
+		transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
 		transport_generic_remove(cmd, 0);
+	}
 }
 
 void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
-- 
1.5.6.5
