From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/8] [Target_Core_Mod/LIO-Target]: Rename and update usage
	of transport_allocate_session()
Date: Sat, 20 Dec 2008 15:01:08 -0800
Message-ID: <1229814068.4560.198.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:28426 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754265AbYLTXBh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2008 18:01:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 24da24b223b3002c897d727d04ee5f8a16a64eab Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 20 Dec 2008 02:23:21 -0800
Subject: [PATCH 3/8] [Target_Core_Mod/LIO-Target]: Rename and update usage of transport_allocate_session()

Rename transport_allocate_session() to transport_init_session() to keep in line
with existing init/free register/deregister usage in Target_Core_Mod and
LIO-Target/ConfigFS code.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_login.c    |    2 +-
 drivers/lio-core/target_core_transport.c |    4 ++--
 drivers/lio-core/target_core_transport.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_login.c b/drivers/lio-core/iscsi_target_login.c
index a28a314..40d9b65 100644
--- a/drivers/lio-core/iscsi_target_login.c
+++ b/drivers/lio-core/iscsi_target_login.c
@@ -253,7 +253,7 @@ static int iscsi_login_zero_tsih_s1 (
 		return(-1);
 	}
 
-	if (!(sess->se_sess = transport_allocate_session())) {
+	if (!(sess->se_sess = transport_init_session())) {
 		iscsi_tx_login_rsp(conn, STAT_CLASS_TARGET, STAT_DETAIL_OUT_OF_RESOURCE);
 		return(-1);
 	}
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index ed042eb..31a96ec 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -574,7 +574,7 @@ extern void transport_check_dev_params_delim (char *ptr, char **cur)
 	return;
 }
 
-extern se_session_t *transport_allocate_session (void)
+extern se_session_t *transport_init_session (void)
 {
 	se_session_t *se_sess;
 
@@ -587,7 +587,7 @@ extern se_session_t *transport_allocate_session (void)
 	return(se_sess);
 }
 
-EXPORT_SYMBOL(transport_allocate_session);
+EXPORT_SYMBOL(transport_init_session);
 
 /*
  * Called with spin_lock_bh(&se_portal_group_t->session_lock called.
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 9c989bd..a6a68af 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -110,7 +110,7 @@ extern void transport_init_queue_obj (struct se_queue_obj_s *);
 extern void transport_load_plugins (void);
 extern struct se_plugin_s *transport_core_get_plugin_by_name (const char *name);
 extern void transport_check_dev_params_delim (char *, char **);
-extern struct se_session_s *transport_allocate_session (void);
+extern struct se_session_s *transport_init_session (void);
 extern void __transport_register_session (struct se_portal_group_s *, struct se_node_acl_s *, struct se_session_s *, void *);
 extern void transport_register_session (struct se_portal_group_s *, struct se_node_acl_s *, struct se_session_s *, void *);
 extern void transport_deregister_session_configfs (struct se_session_s *);
-- 
1.5.4.1



