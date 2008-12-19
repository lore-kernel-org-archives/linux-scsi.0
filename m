From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 2/6]: Update struct target_core_fabric_ops
Date: Fri, 19 Dec 2008 15:25:53 -0800
Message-ID: <1229729153.4560.86.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:27998 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752130AbYLSX0W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:26:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From d2f819ffd998f362d1e6a5543ec91ee73c2133f7 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 13:10:31 -0800
Subject: [PATCH] [Target_Core_Mod]: Update struct target_core_fabric_ops

Add tpg_check_demo_mode_cache() function pointer

Update tpg_release_node_acl() and stop_session() to return 'void'

Remove the now no-longer required dec_nacl_count().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_fabric_ops.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/target_core_fabric_ops.h b/drivers/lio-core/target_core_fabric_ops.h
index 37aa015..6499005 100644
--- a/drivers/lio-core/target_core_fabric_ops.h
+++ b/drivers/lio-core/target_core_fabric_ops.h
@@ -4,16 +4,16 @@ struct target_core_fabric_ops {
 	u32 (*tpg_get_tag)(struct se_portal_group_s *);
 	u32 (*tpg_get_default_depth)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode)(struct se_portal_group_s *);
+	int (*tpg_check_demo_mode_cache)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode_write_protect)(struct se_portal_group_s *);
-	int (*tpg_release_node_acl)(struct se_portal_group_s *, struct se_node_acl_s *);
+	void (*tpg_release_node_acl)(struct se_portal_group_s *, struct se_node_acl_s *);
 	int (*tpg_get_inst_index)(struct se_portal_group_s *);
         void (*release_cmd_to_pool)(struct se_cmd_s *);
         void (*release_cmd_direct)(struct se_cmd_s *);
 	int (*dev_del_lun)(struct se_portal_group_s *, __u32);
-	int (*stop_session)(struct se_session_s *, int, int);
+	void (*stop_session)(struct se_session_s *, int, int);
 	void (*fall_back_to_erl0)(struct se_session_s *);
 	int (*write_pending)(struct se_cmd_s *);
-	void (*dec_nacl_count)(struct se_node_acl_s *, struct se_cmd_s *);
 	void (*set_default_node_attributes)(struct se_node_acl_s *);
 	void *(*scsi_auth_intr_seq_start)(struct seq_file *, loff_t *);
 	void *(*scsi_auth_intr_seq_next)(struct seq_file *, void *, loff_t *);
-- 
1.5.4.1



