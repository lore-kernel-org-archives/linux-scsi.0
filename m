From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target; Drop pointless tfo->check_stop_free check
Date: Wed,  8 Mar 2017 08:20:25 +0000
Message-ID: <1488961225-6378-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

All in-tree fabric drivers provide a tfo->check_stop_free(),
so there is no need to do the extra check within existing
transport_cmd_check_stop_to_fabric() code.

Just to be sure, add a check in target_fabric_tf_ops_check()
to notify any out-of-tree drivers that might be missing it.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  | 4 ++++
 drivers/target/target_core_transport.c | 3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 54b36c9..38b5025 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -421,6 +421,10 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 		pr_err("Missing tfo->aborted_task()\n");
 		return -EINVAL;
 	}
+	if (!tfo->check_stop_free) {
+		pr_err("Missing tfo->check_stop_free()\n");
+		return -EINVAL;
+	}
 	/*
 	 * We at least require tfo->fabric_make_wwn(), tfo->fabric_drop_wwn()
 	 * tfo->fabric_make_tpg() and tfo->fabric_drop_tpg() in
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 434d9d6..b1a3cdb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -636,8 +636,7 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 	 * Fabric modules are expected to return '1' here if the se_cmd being
 	 * passed is released at this point, or zero if not being released.
 	 */
-	return cmd->se_tfo->check_stop_free ? cmd->se_tfo->check_stop_free(cmd)
-		: 0;
+	return cmd->se_tfo->check_stop_free(cmd);
 }
 
 static void transport_lun_remove_cmd(struct se_cmd *cmd)
-- 
1.9.1
