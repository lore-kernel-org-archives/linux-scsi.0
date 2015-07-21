From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target: fix crash in cmd tracing when cmd didn't match a LUN
Date: Tue, 21 Jul 2015 15:07:54 -0700
Message-ID: <1437516477-30554-2-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Alexei Potashnik <alexei@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Alexei Potashnik <alexei@purestorage.com>

If command didn't match a LUN and we're sending check condition, the
target_cmd_complete ftrace point will crash because it assumes that
cmd->t_task_cdb has been set.

The fix will temporarily set t_task_cdb to the se_cmd buffer
and copy first 6 bytes of cdb in there as soon as possible.
At a later point t_task_cdb is reset to the correct buffer,
but until then traces and printks don't cause a crash.

Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/target_core_device.c    | 7 +++++++
 drivers/target/target_core_transport.c | 7 ++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c4a8db6..b74dfb2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -63,6 +63,13 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_dev_entry *deve;
 
+	/* Temporarily set t_task_cdb to the se_cmd buffer and save a portion
+	 * of cdb in there (fabrics must provide at least 6 bytes). t_task_cdb
+	 * will be correctly replaced in target_setup_cmd_from_cdb. Until then
+	 * tracing and printks can access t_task_cdb without causing a crash. */
+	se_cmd->t_task_cdb = se_cmd->__t_task_cdb;
+	memcpy(se_cmd->t_task_cdb, cdb, 6);
+
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, unpacked_lun);
 	if (deve) {
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ce8574b..8dd15c7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1210,15 +1210,16 @@ target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 	 * setup the pointer from __t_task_cdb to t_task_cdb.
 	 */
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
-		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb),
-						GFP_KERNEL);
-		if (!cmd->t_task_cdb) {
+		unsigned char *ptr = kzalloc(scsi_command_size(cdb),
+					     GFP_KERNEL);
+		if (!ptr) {
 			pr_err("Unable to allocate cmd->t_task_cdb"
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
 				(unsigned long)sizeof(cmd->__t_task_cdb));
 			return TCM_OUT_OF_RESOURCES;
 		}
+		cmd->t_task_cdb = ptr;
 	} else
 		cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
-- 
2.4.3
