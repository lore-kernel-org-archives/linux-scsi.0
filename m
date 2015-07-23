From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target: fix crash in cmd tracing when cmd didn't match a LUN
Date: Thu, 23 Jul 2015 15:19:32 -0700
Message-ID: <1437689973-22991-1-git-send-email-sbaugh@catern.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Alexei Potashnik <alexei@purestorage.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, Roland Dreier <roland@purestorage.com>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
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
 drivers/target/iscsi/iscsi_target.c    |  4 ++--
 drivers/target/target_core_device.c    | 11 +++++++++--
 drivers/target/target_core_transport.c |  9 +++++----
 include/target/target_core_fabric.h    |  2 +-
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f615d75..98899f1 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1003,8 +1003,8 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
-	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
-						     scsilun_to_int(&hdr->lun));
+	cmd->sense_reason = transport_lookup_cmd_lun_cdb(&cmd->se_cmd,
+							 scsilun_to_int(&hdr->lun), hdr->cdb);
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c4a8db6..acf84cf 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -56,13 +56,20 @@ static struct se_hba *lun0_hba;
 struct se_device *g_lun0_dev;
 
 sense_reason_t
-transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
+transport_lookup_cmd_lun_cdb(struct se_cmd *se_cmd, u64 unpacked_lun, unsigned char *cdb)
 {
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
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
@@ -142,7 +149,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 
 	return 0;
 }
-EXPORT_SYMBOL(transport_lookup_cmd_lun);
+EXPORT_SYMBOL(transport_lookup_cmd_lun_cdb);
 
 int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 {
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f6626bb..1f761a3 100644
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
@@ -1404,7 +1405,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	/*
 	 * Locate se_lun pointer and attach it to struct se_cmd
 	 */
-	rc = transport_lookup_cmd_lun(se_cmd, unpacked_lun);
+	rc = transport_lookup_cmd_lun_cdb(se_cmd, unpacked_lun, cdb);
 	if (rc) {
 		transport_send_check_condition_and_sense(se_cmd, rc, 0);
 		target_put_sess_cmd(se_cmd);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 18afef9..bfa6368 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -116,7 +116,7 @@ void	transport_deregister_session(struct se_session *);
 void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
 		struct se_session *, u32, int, int, unsigned char *);
-sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
+sense_reason_t transport_lookup_cmd_lun_cdb(struct se_cmd *, u64, unsigned char *);
 sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u64, u32, int, int, int,
-- 
2.5.0.rc3
