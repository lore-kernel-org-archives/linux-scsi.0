From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 3/12]: Update struct
	target_core_fabric_ops API
Date: Fri, 12 Dec 2008 01:30:26 -0800
Message-ID: <1229074226.4153.641.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:37822 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758642AbYLLJaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:30:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

>From aa7f86b29b9cb57c3a61a40a08ec50cccb9ee1d1 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 00:46:21 -0800
Subject: [PATCH] [Target_Core_Mod]: Update struct target_core_fabric_ops API

This patch adds function pointers to struct target_core_fabric_ops,
the template for Target_Core_Mod/ConfigFS.  Also, some previously prefixed
iscsi_* parameters have now been completely converted to se_* data structures.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_fabric_ops.h |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/lio-core/target_core_fabric_ops.h b/drivers/lio-core/target_core_fabric_ops.h
index 1ac2d61..37aa015 100644
--- a/drivers/lio-core/target_core_fabric_ops.h
+++ b/drivers/lio-core/target_core_fabric_ops.h
@@ -1,11 +1,20 @@
 struct target_core_fabric_ops {
+	char *(*get_fabric_name)(void);
+	char *(*tpg_get_wwn)(struct se_portal_group_s *);
+	u32 (*tpg_get_tag)(struct se_portal_group_s *);
+	u32 (*tpg_get_default_depth)(struct se_portal_group_s *);
+	int (*tpg_check_demo_mode)(struct se_portal_group_s *);
+	int (*tpg_check_demo_mode_write_protect)(struct se_portal_group_s *);
+	int (*tpg_release_node_acl)(struct se_portal_group_s *, struct se_node_acl_s *);
+	int (*tpg_get_inst_index)(struct se_portal_group_s *);
         void (*release_cmd_to_pool)(struct se_cmd_s *);
         void (*release_cmd_direct)(struct se_cmd_s *);
-	int (*dev_del_lun)(struct iscsi_portal_group_s *, __u32);
-	int (*stop_session)(struct iscsi_session_s *, int, int);
-	void (*fall_back_to_erl0)(struct iscsi_conn_s *);
+	int (*dev_del_lun)(struct se_portal_group_s *, __u32);
+	int (*stop_session)(struct se_session_s *, int, int);
+	void (*fall_back_to_erl0)(struct se_session_s *);
 	int (*write_pending)(struct se_cmd_s *);
-	void (*dec_nacl_count)(struct iscsi_node_acl_s *, struct se_cmd_s *);
+	void (*dec_nacl_count)(struct se_node_acl_s *, struct se_cmd_s *);
+	void (*set_default_node_attributes)(struct se_node_acl_s *);
 	void *(*scsi_auth_intr_seq_start)(struct seq_file *, loff_t *);
 	void *(*scsi_auth_intr_seq_next)(struct seq_file *, void *, loff_t *);
 	int (*scsi_auth_intr_seq_show)(struct seq_file *, void *);
-- 
1.5.4.1



