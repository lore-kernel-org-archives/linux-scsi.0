From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 5/6]: Updates for generic device core
Date: Fri, 19 Dec 2008 15:27:43 -0800
Message-ID: <1229729263.4560.93.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755951AbYLSX2f@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From 83f3b031993ef08fca5cffc9bc416ece901b538a Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 13:31:09 -0800
Subject: [PATCH] [Target_Core_Mod]: Updates for generic device core

This patch adds a missing SCF_SE_LUN_CMD in __transport_get_lun_for_cmd()

Also, it adds a temporary NOP for transport_get_lun_for_tmr(), and adds
core_dec_lacl_count().

It also export the following symbols:

core_update_device_list_access()
core_dev_add_lun()
core_dev_del_lun()
core_get_lun_from_tpg()
core_dev_init_initiator_node_lun_acl()
core_dev_add_initiator_node_lun_acl()
core_dev_del_initiator_node_lun_acl()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_device.c |   44 +++++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_device.h |    1 +
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 132bdef..9aa2f51 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -272,6 +272,7 @@ extern int __transport_get_lun_for_cmd (
                 se_cmd->orig_fe_lun = unpacked_lun;
                 se_cmd->se_orig_obj_api = ISCSI_LUN(se_cmd)->lun_obj_api;
                 se_cmd->se_orig_obj_ptr = ISCSI_LUN(se_cmd)->lun_type_ptr;
+		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
         }
 out:
         spin_unlock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
@@ -279,11 +280,15 @@ out:
         if (!se_lun) {
 		if (read_only) {
 			se_cmd->scsi_sense_reason = WRITE_PROTECTED;
-                        printk("Detected WRITE_PROTECTED LUN Access for 0x%08x\n",
+                        printk("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
+				" Access for 0x%08x\n",
+				CMD_TFO(se_cmd)->get_fabric_name(),
 				unpacked_lun);
 		} else {
 			se_cmd->scsi_sense_reason = NON_EXISTENT_LUN;
-                        printk("Detected NON_EXISTENT_LUN Access for  0x%08x\n",
+                        printk("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
+				" Access for 0x%08x\n",
+				CMD_TFO(se_cmd)->get_fabric_name(),
 				unpacked_lun);
                 }
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -333,6 +338,14 @@ out:
 	return(0);
 }
 
+#warning FIXME: Complete transport_get_lun_for_tmr()
+extern int transport_get_lun_for_tmr (
+	se_cmd_t *se_cmd,
+	u32 unpacked_lun)
+{
+	return(-1);
+}
+
 extern int core_free_device_list_for_node (se_node_acl_t *nacl, se_portal_group_t *tpg)
 {
         se_dev_entry_t *deve;
@@ -370,6 +383,18 @@ extern int core_free_device_list_for_node (se_node_acl_t *nacl, se_portal_group_
         return(0);
 }
 
+extern void core_dec_lacl_count (se_node_acl_t *se_nacl, se_cmd_t *se_cmd)
+{
+	se_dev_entry_t *deve;
+
+	spin_lock_bh(&se_nacl->device_list_lock);
+	deve = &se_nacl->device_list[se_cmd->orig_fe_lun];
+	deve->deve_cmds--;
+	spin_unlock_bh(&se_nacl->device_list_lock);
+	
+	return;
+}
+
 extern void core_update_device_list_access (
         u32 mapped_lun,
         u32 lun_access,
@@ -391,6 +416,8 @@ extern void core_update_device_list_access (
         return;
 }
 
+EXPORT_SYMBOL(core_update_device_list_access);
+
 /*      core_update_device_list_for_node():
  *
  *
@@ -860,6 +887,8 @@ extern se_lun_t *core_dev_add_lun (
         return(lun_p);
 }
 
+EXPORT_SYMBOL(core_dev_add_lun);
+
 /*      core_dev_del_lun():
  *
  *
@@ -884,6 +913,8 @@ extern int core_dev_del_lun (
         return(0);
 }
 
+EXPORT_SYMBOL(core_dev_del_lun);
+
 extern se_lun_t *core_get_lun_from_tpg (se_portal_group_t *tpg, u32 unpacked_lun)
 {
         se_lun_t *lun;
@@ -912,6 +943,8 @@ extern se_lun_t *core_get_lun_from_tpg (se_portal_group_t *tpg, u32 unpacked_lun
         return(lun);
 }
 
+EXPORT_SYMBOL(core_get_lun_from_tpg);
+
 /*      core_dev_get_lun():
  *
  *
@@ -976,6 +1009,8 @@ extern se_lun_acl_t *core_dev_init_initiator_node_lun_acl (
         return(lacl);
 }
 
+EXPORT_SYMBOL(core_dev_init_initiator_node_lun_acl);
+
 extern int core_dev_add_initiator_node_lun_acl (
         se_portal_group_t *tpg,
         se_lun_acl_t *lacl,
@@ -1017,6 +1052,8 @@ extern int core_dev_add_initiator_node_lun_acl (
         return(0);
 }
 
+EXPORT_SYMBOL(core_dev_add_initiator_node_lun_acl);
+
 /*      core_dev_del_initiator_node_lun_acl():
  *
  *
@@ -1047,6 +1084,8 @@ extern int core_dev_del_initiator_node_lun_acl (
         return(0);
 }
 
+EXPORT_SYMBOL(core_dev_del_initiator_node_lun_acl);
+
 extern void core_dev_free_initiator_node_lun_acl (
         se_portal_group_t *tpg,
         se_lun_acl_t *lacl)
@@ -1061,3 +1100,4 @@ extern void core_dev_free_initiator_node_lun_acl (
         return;
 }
 
+EXPORT_SYMBOL(core_dev_free_initiator_node_lun_acl);
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index 6028c3a..128aae8 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -36,6 +36,7 @@ extern int se_check_devices_access (se_hba_t *);
 extern void se_disable_devices_for_hba (se_hba_t *);
 extern int transport_get_lun_for_cmd (struct se_cmd_s *, unsigned char *, u32);
 extern int core_free_device_list_for_node (se_node_acl_t *, se_portal_group_t *);
+extern void core_dec_lacl_count (struct se_node_acl_s *, struct se_cmd_s *);
 extern void core_update_device_list_access (u32, u32, se_node_acl_t *);
 extern void core_update_device_list_for_node (se_lun_t *lun, u32, u32, se_node_acl_t *, se_portal_group_t *, int);
 extern void core_clear_lun_from_tpg (se_lun_t *, se_portal_group_t *);
-- 
1.5.4.1
