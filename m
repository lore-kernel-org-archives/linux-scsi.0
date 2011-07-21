From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 065/103] target: Remove fabric callback to allocate iovecs
Date: Thu, 21 Jul 2011 00:11:48 -0700
Message-ID: <1311232346-6674-66-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.146]:28086 "HELO
	nm6-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752180Ab1GUHGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:55 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

iscsi is the only one to use it, and by allocating it from
iscsit_alloc_buffs we are covered.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c      |    7 -------
 drivers/target/target_core_transport.c  |   13 -------------
 include/target/target_core_fabric_ops.h |    5 -----
 3 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index f6f78f1..1e0c7ca 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1424,13 +1424,6 @@ static int tcm_loop_register_configfs(void)
 					&tcm_loop_tpg_release_fabric_acl;
 	fabric->tf_ops.tpg_get_inst_index = &tcm_loop_get_inst_index;
 	/*
-	 * Since tcm_loop is mapping physical memory from Linux/SCSI
-	 * struct scatterlist arrays for each struct scsi_cmnd I/O,
-	 * we do not need TCM to allocate a iovec array for
-	 * virtual memory address mappings
-	 */
-	fabric->tf_ops.alloc_cmd_iovecs = NULL;
-	/*
 	 * Used for setting up remaining TCM resources in process context
 	 */
 	fabric->tf_ops.new_cmd_map = &tcm_loop_new_cmd_map;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fbc5687..9fc017e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4748,7 +4748,6 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
 	 */
 int transport_generic_new_cmd(struct se_cmd *cmd)
 {
-	struct se_portal_group *se_tpg;
 	struct se_task *task;
 	struct se_device *dev = cmd->se_dev;
 	int ret = 0;
@@ -4769,18 +4768,6 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
 	if (ret < 0)
 		return ret;
 
-	/*
-	 * Determine if the calling TCM fabric module is talking to
-	 * Linux/NET via kernel sockets and needs to allocate a
-	 * struct iovec array to complete the struct se_cmd
-	 */
-	se_tpg = cmd->se_lun->lun_sep->sep_tpg;
-	if (se_tpg->se_tpg_tfo->alloc_cmd_iovecs != NULL) {
-		ret = se_tpg->se_tpg_tfo->alloc_cmd_iovecs(cmd);
-		if (ret < 0)
-			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
-	}
-
 	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
 		list_for_each_entry(task, &cmd->t_task_list, t_list) {
 			if (atomic_read(&task->task_sent))
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index 747e140..1752ed3 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -39,11 +39,6 @@ struct target_core_fabric_ops {
 	 */
 	int (*new_cmd_map)(struct se_cmd *);
 	/*
-	 * Optional function pointer for TCM fabric modules that use
-	 * Linux/NET sockets to allocate struct iovec array to struct se_cmd
-	 */
-	int (*alloc_cmd_iovecs)(struct se_cmd *);
-	/*
 	 * Optional to release struct se_cmd and fabric dependent allocated
 	 * I/O descriptor in transport_cmd_check_stop()
 	 */
-- 
1.7.6

