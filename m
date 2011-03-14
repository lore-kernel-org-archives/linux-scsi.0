From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 08/21] target: Remove spurious double cast from structure macro accessors
Date: Mon, 14 Mar 2011 04:06:02 -0700
Message-ID: <1300100775-10012-9-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Reported-by: Fubo Chen <fubo.chen@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_base.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bc93b78..b3a62e4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -494,8 +494,8 @@ struct se_task {
 	struct list_head t_state_list;
 } ____cacheline_aligned;
 
-#define TASK_CMD(task)	((struct se_cmd *)task->task_se_cmd)
-#define TASK_DEV(task)	((struct se_device *)task->se_dev)
+#define TASK_CMD(task)	((task)->task_se_cmd)
+#define TASK_DEV(task)	((task)->se_dev)
 
 struct se_cmd {
 	/* SAM response code being sent to initiator */
@@ -551,8 +551,8 @@ struct se_cmd {
 	void (*transport_complete_callback)(struct se_cmd *);
 } ____cacheline_aligned;
 
-#define T_TASK(cmd)     ((struct se_transport_task *)(cmd->t_task))
-#define CMD_TFO(cmd) ((struct target_core_fabric_ops *)cmd->se_tfo)
+#define T_TASK(cmd)     ((cmd)->t_task)
+#define CMD_TFO(cmd)	((cmd)->se_tfo)
 
 struct se_tmr_req {
 	/* Task Management function to be preformed */
@@ -615,8 +615,8 @@ struct se_session {
 	struct list_head	sess_acl_list;
 } ____cacheline_aligned;
 
-#define SE_SESS(cmd)		((struct se_session *)(cmd)->se_sess)
-#define SE_NODE_ACL(sess)	((struct se_node_acl *)(sess)->se_node_acl)
+#define SE_SESS(cmd)		((cmd)->se_sess)
+#define SE_NODE_ACL(sess)	((sess)->se_node_acl)
 
 struct se_device;
 struct se_transform_info;
@@ -803,8 +803,8 @@ struct se_device {
 	struct list_head	g_se_dev_list;
 }  ____cacheline_aligned;
 
-#define SE_DEV(cmd)		((struct se_device *)(cmd)->se_lun->lun_se_dev)
-#define SU_DEV(dev)		((struct se_subsystem_dev *)(dev)->se_sub_dev)
+#define SE_DEV(cmd)		((cmd)->se_lun->lun_se_dev)
+#define SU_DEV(dev)		((dev)->se_sub_dev)
 #define DEV_ATTRIB(dev)		(&(dev)->se_sub_dev->se_dev_attrib)
 #define DEV_T10_WWN(dev)	(&(dev)->se_sub_dev->t10_wwn)
 
@@ -832,7 +832,7 @@ struct se_hba {
 	struct se_subsystem_api *transport;
 }  ____cacheline_aligned;
 
-#define SE_HBA(d)		((struct se_hba *)(d)->se_hba)
+#define SE_HBA(dev)		((dev)->se_hba)
 
 struct se_lun {
 	/* See transport_lun_status_table */
@@ -852,7 +852,7 @@ struct se_lun {
 	struct se_port	*lun_sep;
 } ____cacheline_aligned;
 
-#define SE_LUN(c)		((struct se_lun *)(c)->se_lun)
+#define SE_LUN(cmd)		((cmd)->se_lun)
 
 struct scsi_port_stats {
        u64     cmd_pdus;
@@ -919,7 +919,7 @@ struct se_portal_group {
 	struct config_group	tpg_param_group;
 } ____cacheline_aligned;
 
-#define TPG_TFO(se_tpg)	((struct target_core_fabric_ops *)(se_tpg)->se_tpg_tfo)
+#define TPG_TFO(se_tpg)	((se_tpg)->se_tpg_tfo)
 
 struct se_wwn {
 	struct target_fabric_configfs *wwn_tf;
-- 
1.7.4.1
