From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] [TCM_Loop]: Update virtual SAS NodeACL allocation handling for v4.0
Date: Thu, 25 Feb 2010 06:05:47 -0800
Message-ID: <1267106747-7098-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:48879 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932665Ab0BYOFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Feb 2010 09:05:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates tcm_loop_tpg_alloc_fabric_acl() and tcm_loop_tpg_release_fabric_acl()
to follow TCM v4.0 convention for alloc/release of the demo mode se_node_acl_t used for
the TCM_Loop virtual SAS Initiator Ports.  This includes hanging struct se_node_acl_s
off the fabric dependent struct tcm_loop_nacl so that container_of() macros can be used
to access internal structures in tcm_loop from struct se_node_acl_s presented pointers.

Also, this patch removes the legacy usage of fabric->reg_default_groups_callback() in
tcm_loop_register_configfs().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_configfs.c |    5 +----
 drivers/target/tcm_loop/tcm_loop_core.h     |    2 +-
 drivers/target/tcm_loop/tcm_loop_fabric.c   |   10 ++++------
 drivers/target/tcm_loop/tcm_loop_fabric.h   |    3 ++-
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_configfs.c b/drivers/target/tcm_loop/tcm_loop_configfs.c
index 0f52e24..1085b9a 100644
--- a/drivers/target/tcm_loop/tcm_loop_configfs.c
+++ b/drivers/target/tcm_loop/tcm_loop_configfs.c
@@ -545,10 +545,7 @@ int tcm_loop_register_configfs(void)
 	fabric->tf_ops.get_fabric_sense_len = &tcm_loop_get_fabric_sense_len;
 	fabric->tf_ops.is_state_remove = &tcm_loop_is_state_remove;
 	fabric->tf_ops.pack_lun = &tcm_loop_pack_lun;
-	/*
-	 *  TCM_Loop does not currently register any default configfs group(s)
-	 */
-	fabric->reg_default_groups_callback = NULL;
+
 	tf_cg = &fabric->tf_group;
 	/*
 	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
diff --git a/drivers/target/tcm_loop/tcm_loop_core.h b/drivers/target/tcm_loop/tcm_loop_core.h
index 9d876d5..cb0aeb5 100644
--- a/drivers/target/tcm_loop/tcm_loop_core.h
+++ b/drivers/target/tcm_loop/tcm_loop_core.h
@@ -33,7 +33,7 @@ struct tcm_loop_nexus {
 };
 
 struct tcm_loop_nacl {
-	struct se_node_acl_s *se_nacl;
+	struct se_node_acl_s se_node_acl;
 };
 
 struct tcm_loop_tpg {
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.c b/drivers/target/tcm_loop/tcm_loop_fabric.c
index 413ea81..5a836cc 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.c
@@ -184,8 +184,7 @@ int tcm_loop_check_demo_mode_write_protect(se_portal_group_t *se_tpg)
 }
 
 void *tcm_loop_tpg_alloc_fabric_acl(
-	se_portal_group_t *se_tpg,
-	se_node_acl_t *se_nacl)
+	se_portal_group_t *se_tpg)
 {
 	struct tcm_loop_nacl *tl_nacl;
 
@@ -194,17 +193,16 @@ void *tcm_loop_tpg_alloc_fabric_acl(
 		printk(KERN_ERR "Unable to allocate struct tcm_loop_nacl\n");
 		return NULL;
 	}
-	tl_nacl->se_nacl = se_nacl;
 
-	return (void *)tl_nacl;
+	return &tl_nacl->se_node_acl;
 }
 
 void tcm_loop_tpg_release_fabric_acl(
 	se_portal_group_t *se_tpg,
 	se_node_acl_t *se_nacl)
 {
-	struct tcm_loop_nacl *tl_nacl =
-			(struct tcm_loop_nacl *)se_nacl->fabric_acl_ptr;
+	struct tcm_loop_nacl *tl_nacl = container_of(se_nacl,
+				struct tcm_loop_nacl, se_node_acl);
 
 	kfree(tl_nacl);
 }
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.h b/drivers/target/tcm_loop/tcm_loop_fabric.h
index edc7eb5..6192bdc 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.h
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.h
@@ -11,7 +11,8 @@ extern char *tcm_loop_parse_pr_out_transport_id(const char *, u32 *, char **);
 extern int tcm_loop_check_demo_mode(se_portal_group_t *);
 extern int tcm_loop_check_demo_mode_cache(se_portal_group_t *);
 extern int tcm_loop_check_demo_mode_write_protect(se_portal_group_t *);
-void *tcm_loop_tpg_alloc_fabric_acl(se_portal_group_t *, se_node_acl_t *);
+extern struct se_node_acl_s *tcm_loop_tpg_alloc_fabric_acl(
+				se_portal_group_t *);
 void tcm_loop_tpg_release_fabric_acl(se_portal_group_t *, se_node_acl_t *);
 #ifdef SNMP_SUPPORT
 extern u32 tcm_loop_tpg_get_inst_index(se_portal_group_t *);
-- 
1.5.6.5

