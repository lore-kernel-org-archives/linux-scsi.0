From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 02/24] target: fix dubious one-bit signed bitfield
Date: Sat, 29 Jan 2011 10:36:02 -0800
Message-ID: <1296326184-16664-3-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm24.bullet.mail.ac4.yahoo.com ([98.139.52.221]:32688 "HELO
	nm24.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754278Ab1A2SgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:36:16 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dan Carpenter <error27@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Dan Carpenter <error27@gmail.com>

The signed one-bit types can be 0 or -1 which can cause a problem if
someone ever checks if (foo->lu_gp_assoc == 1).  The current code is
fine because everyone just checks zero vs non-zero.  But Sparse
complains about it so lets change it.  The warnings look like this:

include/target/target_core_base.h:228:26: error: dubious one-bit signed bitfield

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit daf0bd7aa57e14b903c81761b421e1130f12b7d1)
---
 include/target/target_core_base.h       |   14 +++++++-------
 include/target/target_core_fabric_ops.h |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 07fdfb6..764177b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -225,7 +225,7 @@ struct t10_alua_lu_gp {
 } ____cacheline_aligned;
 
 struct t10_alua_lu_gp_member {
-	int lu_gp_assoc:1;
+	bool lu_gp_assoc;
 	atomic_t lu_gp_mem_ref_cnt;
 	spinlock_t lu_gp_mem_lock;
 	struct t10_alua_lu_gp *lu_gp;
@@ -257,7 +257,7 @@ struct t10_alua_tg_pt_gp {
 } ____cacheline_aligned;
 
 struct t10_alua_tg_pt_gp_member {
-	int tg_pt_gp_assoc:1;
+	bool tg_pt_gp_assoc;
 	atomic_t tg_pt_gp_mem_ref_cnt;
 	spinlock_t tg_pt_gp_mem_lock;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
@@ -322,7 +322,7 @@ struct t10_pr_registration {
 	int pr_res_type;
 	int pr_res_scope;
 	/* Used for fabric initiator WWPNs using a ISID */
-	int isid_present_at_reg:1;
+	bool isid_present_at_reg;
 	u32 pr_res_mapped_lun;
 	u32 pr_aptpl_target_lun;
 	u32 pr_res_generation;
@@ -404,7 +404,7 @@ struct se_transport_task {
 	unsigned long long	t_task_lba;
 	int			t_tasks_failed;
 	int			t_tasks_fua;
-	int			t_tasks_bidi:1;
+	bool			t_tasks_bidi;
 	u32			t_task_cdbs;
 	u32			t_tasks_check;
 	u32			t_tasks_no;
@@ -456,7 +456,7 @@ struct se_task {
 	u8		task_flags;
 	int		task_error_status;
 	int		task_state_flags;
-	int		task_padded_sg:1;
+	bool		task_padded_sg;
 	unsigned long long	task_lba;
 	u32		task_no;
 	u32		task_sectors;
@@ -569,7 +569,7 @@ struct se_ua {
 struct se_node_acl {
 	char			initiatorname[TRANSPORT_IQN_LEN];
 	/* Used to signal demo mode created ACL, disabled by default */
-	int			dynamic_node_acl:1;
+	bool			dynamic_node_acl;
 	u32			queue_depth;
 	u32			acl_index;
 	u64			num_cmds;
@@ -622,7 +622,7 @@ struct se_lun_acl {
 }  ____cacheline_aligned;
 
 struct se_dev_entry {
-	int			def_pr_registered:1;
+	bool			def_pr_registered;
 	/* See transport_lunflags_table */
 	u32			lun_flags;
 	u32			deve_cmds;
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index f3ac12b..5eb8b1a 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -8,7 +8,7 @@ struct target_core_fabric_ops {
 	 * for scatterlist chaining using transport_do_task_sg_link(),
 	 * disabled by default
 	 */
-	int task_sg_chaining:1;
+	bool task_sg_chaining;
 	char *(*get_fabric_name)(void);
 	u8 (*get_fabric_proto_ident)(struct se_portal_group *);
 	char *(*tpg_get_wwn)(struct se_portal_group *);
-- 
1.7.3.5

