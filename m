From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] [LIO-Target]: Update for iSCSI Initiator LUN ACLs
	using write_protect
Date: Wed, 03 Dec 2008 20:35:04 -0800
Message-ID: <1228365304.4153.106.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:32031 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752927AbYLDEfI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 23:35:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 1f3f9cbd8d917500b91d52fea34791ad335712aa Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 3 Dec 2008 18:48:11 -0800
Subject: [PATCH] [LIO-Target]: Update for iSCSI Initiator LUN ACLs using write_protect

Reenabled the write-protect logic in iscsi_target_device.c.

This patch does some cleanups for iscsi_update_device_list_access() and
iscsi_update_device_list_for_node().  Also, it removes the legacy usage of
iscsi_check_device_list_access() in iscsi_dev_init_initiator_node_lun_acl().

This patch also removes the following functions that where part of v2.9 IOCTL:

iscsi_check_device_list_access() and iscsi_dev_set_initiator_node_lun_access()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_device.c |  109 +++++++-------------------------
 drivers/lio-core/iscsi_target_device.h |    2 +-
 2 files changed, 24 insertions(+), 87 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_device.c b/drivers/lio-core/iscsi_target_device.c
index e811b70..a375c69 100644
--- a/drivers/lio-core/iscsi_target_device.c
+++ b/drivers/lio-core/iscsi_target_device.c
@@ -346,23 +346,7 @@ extern int iscsi_free_device_list_for_node (iscsi_node_acl_t *nacl, iscsi_portal
 	return(0);
 }
 
-static int iscsi_check_device_list_access (
-	u32 mapped_lun,
-	iscsi_node_acl_t *nacl)
-{
-	int ret = 0;
-	se_dev_entry_t *deve;
-	
-	spin_lock_bh(&nacl->device_list_lock);
-	deve = &nacl->device_list[mapped_lun];
-	if (deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS)
-		ret = -1;
-	spin_unlock_bh(&nacl->device_list_lock);
-
-	return(ret);
-}
-
-extern int iscsi_update_device_list_access (
+extern void iscsi_update_device_list_access (
 	u32 mapped_lun,
 	u32 lun_access,
 	iscsi_node_acl_t *nacl)
@@ -371,23 +355,16 @@ extern int iscsi_update_device_list_access (
 
 	spin_lock_bh(&nacl->device_list_lock);
 	deve = &nacl->device_list[mapped_lun];
-	if (!(deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS)) {
-		TRACE_ERROR("TPG[%u] - Initiator: %s Mapped LUN: %u not present!\n",
-			nacl->tpg->tpgt, nacl->initiatorname, mapped_lun);
-		spin_unlock_bh(&nacl->device_list_lock);
-		return(ERR_LUN_NOT_ACTIVE);
-	}
-	
-	if (deve->lun_flags & ISCSI_LUNFLAGS_READ_ONLY) {
-		if (lun_access & ISCSI_LUNFLAGS_READ_WRITE)
-			deve->lun_flags &= ~ISCSI_LUNFLAGS_READ_ONLY;
+	if (lun_access & ISCSI_LUNFLAGS_READ_WRITE) {
+		deve->lun_flags &= ~ISCSI_LUNFLAGS_READ_ONLY;
+		deve->lun_flags |= ISCSI_LUNFLAGS_READ_WRITE;
 	} else {
-		if (lun_access & ISCSI_LUNFLAGS_READ_ONLY)
-			deve->lun_flags |= ISCSI_LUNFLAGS_READ_ONLY;
+		deve->lun_flags &= ~ISCSI_LUNFLAGS_READ_WRITE;
+		deve->lun_flags |= ISCSI_LUNFLAGS_READ_ONLY;
 	}
 	spin_unlock_bh(&nacl->device_list_lock);
 
-	return(0);
+	return;
 }
 
 /*	iscsi_update_device_list_for_node():
@@ -402,32 +379,30 @@ extern void iscsi_update_device_list_for_node (
 	iscsi_portal_group_t *tpg,
 	int enable)
 {
-	int status = 0;
 	se_dev_entry_t *deve;
 
 	spin_lock_bh(&nacl->device_list_lock);
 	deve = &nacl->device_list[mapped_lun];
 	if (enable) {
-		if (!(deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS)) {
-			deve->iscsi_lun = lun;
-			deve->mapped_lun = mapped_lun;
-			deve->lun_flags |= ISCSI_LUNFLAGS_INITIATOR_ACCESS;	
+		deve->iscsi_lun = lun;
+		deve->mapped_lun = mapped_lun;
+		deve->lun_flags |= ISCSI_LUNFLAGS_INITIATOR_ACCESS;	
 
-			if (lun_access & ISCSI_LUNFLAGS_READ_ONLY)
-				deve->lun_flags |= ISCSI_LUNFLAGS_READ_ONLY;
-			
-			status = 2;
+		if (lun_access & ISCSI_LUNFLAGS_READ_WRITE) {
+			deve->lun_flags &= ~ISCSI_LUNFLAGS_READ_ONLY;
+			deve->lun_flags |= ISCSI_LUNFLAGS_READ_WRITE;
+		} else {
+			deve->lun_flags &= ~ISCSI_LUNFLAGS_READ_WRITE;
+			deve->lun_flags |= ISCSI_LUNFLAGS_READ_ONLY;
+		}
 #ifdef SNMP_SUPPORT
-			deve->creation_time = get_jiffies_64();
-			deve->attach_count++;
+		deve->creation_time = get_jiffies_64();
+		deve->attach_count++;
 #endif /* SNMP_SUPPORT */
-		}
 	} else {
-		if (deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS) {
-			deve->iscsi_lun = NULL;
-			deve->lun_flags = 0;
-			status = 1;
-		}
+		deve->iscsi_lun = NULL;
+		deve->lun_flags = 0;
+		deve->creation_time = 0;
 	}
 	spin_unlock_bh(&nacl->device_list_lock);
 		
@@ -745,16 +720,6 @@ extern se_lun_acl_t *iscsi_dev_init_initiator_node_lun_acl (
 		*ret = -EINVAL;
 		return(NULL);
 	}
-#warning iscsi_check_device_list_access() fails for IQN with active session when generate_node_acls=1,cache_dynmaic_acls=1
-	if (iscsi_check_device_list_access(mapped_lun, nacl) < 0) {
-		TRACE_ERROR("ACL Entry already exists for iSCSI"
-			" Initiator Node: %s for Mapped iSCSI Logout Unit Number: %u"
-			" on iSCSI Target Portal Group: %hu, ignoring request\n",
-				initiatorname, mapped_lun, tpg->tpgt);
-		*ret = -EEXIST;
-		return(NULL);
-	}
-	
 	if (!(lacl = (se_lun_acl_t *) kmalloc(sizeof(se_lun_acl_t), GFP_KERNEL))) {	
 		TRACE_ERROR("Unable to allocate memory for se_lun_acl_t.\n");
 		*ret = -ENOMEM;
@@ -763,6 +728,7 @@ extern se_lun_acl_t *iscsi_dev_init_initiator_node_lun_acl (
 	memset(lacl, 0, sizeof(se_lun_acl_t));
 
 	lacl->mapped_lun = mapped_lun;
+	lacl->se_lun_nacl = nacl;
 	snprintf(lacl->initiatorname, ISCSI_IQN_LEN, "%s", initiatorname);
 
 	return(lacl);
@@ -846,32 +812,3 @@ extern void iscsi_dev_free_initiator_node_lun_acl (
 	kfree(lacl);
 	return;
 }
-
-extern int iscsi_dev_set_initiator_node_lun_access (
-	iscsi_portal_group_t *tpg,
-	u32 mapped_lun,
-	u32 lun_access,
-	char *initiatorname)
-{
-	int ret;
-	iscsi_node_acl_t *nacl;
-	
-	if (strlen(initiatorname) > ISCSI_IQN_LEN) {
-		TRACE_ERROR("iSCSI InitiatorName exceeds maximum size.\n");
-		return(ERR_INITIATORNAME_TOO_LARGE);
-	}
-
-	if (mapped_lun > (ISCSI_MAX_LUNS_PER_TPG-1)) {
-		TRACE_ERROR("iSCSI MAPPED LUN: %u exceeds ISCSI_MAX_LUNS_PER_TPG-1:"
-			" %u for Target Portal Group: %hu\n", mapped_lun,
-			ISCSI_MAX_LUNS_PER_TPG-1, tpg->tpgt);
-		return(ERR_LUN_NOT_ACTIVE);
-	}
-	
-	if (!(nacl = iscsi_tpg_get_initiator_node_acl(tpg, initiatorname)))
-		 return(ERR_DELLUNACL_NODE_ACL_MISSING);
-
-	ret = iscsi_update_device_list_access(mapped_lun, lun_access, nacl);
-
-	return(ret);
-}
diff --git a/drivers/lio-core/iscsi_target_device.h b/drivers/lio-core/iscsi_target_device.h
index 6ad0aed..89f71b4 100644
--- a/drivers/lio-core/iscsi_target_device.h
+++ b/drivers/lio-core/iscsi_target_device.h
@@ -34,6 +34,7 @@ extern void iscsi_increment_maxcmdsn (iscsi_cmd_t *, iscsi_session_t *);
 extern int iscsi_set_queue_depth_for_node (iscsi_portal_group_t *, iscsi_node_acl_t *);
 extern int iscsi_create_device_list_for_node (iscsi_node_acl_t *, iscsi_portal_group_t *);
 extern int iscsi_free_device_list_for_node (iscsi_node_acl_t *, iscsi_portal_group_t *);
+extern void iscsi_update_device_list_access (u32, u32, iscsi_node_acl_t *);
 extern void iscsi_update_device_list_for_node (se_lun_t *, u32, u32, iscsi_node_acl_t *, iscsi_portal_group_t *, int);     
 extern void iscsi_clear_lun_from_sessions (se_lun_t *, iscsi_portal_group_t *);
 extern void iscsi_clear_lun_from_tpg (se_lun_t *, iscsi_portal_group_t *);
@@ -44,6 +45,5 @@ extern se_lun_acl_t *iscsi_dev_init_initiator_node_lun_acl (iscsi_portal_group_t
 extern int iscsi_dev_add_initiator_node_lun_acl (iscsi_portal_group_t *, se_lun_acl_t *, u32, u32);
 extern int iscsi_dev_del_initiator_node_lun_acl (iscsi_portal_group_t *, se_lun_t *, se_lun_acl_t *);
 extern void iscsi_dev_free_initiator_node_lun_acl (iscsi_portal_group_t *, se_lun_acl_t *lacl);
-extern int iscsi_dev_set_initiator_node_lun_access (iscsi_portal_group_t *, u32, u32, char *);
 
 #endif /* ISCSI_TARGET_DEVICE_H */
-- 
1.5.4.1



