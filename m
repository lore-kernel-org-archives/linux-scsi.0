From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/8] [Target_Core_Mod]: Add transport_free_session()
Date: Sat, 20 Dec 2008 15:01:36 -0800
Message-ID: <1229814096.4560.200.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:30403 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754230AbYLTXCH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2008 18:02:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From a4600727191e4b31ad76f8958359b3713cbc26a7 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 20 Dec 2008 02:53:14 -0800
Subject: [PATCH 4/8] [Target_Core_Mod]: Add transport_free_session()

This patch adds transport_free_session(), which is simply a wrapper
around kmem_cache_free() for se_session_t.  It also adds EXPORT_SYMBOL()
usage for $FABRIC_MODs.

Also in transport_deregister_session(), added transport_free_session() usage,
including a conditional to check for the existance of se_session_t->se_portal_group_t.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_transport.c |   15 ++++++++++++++-
 drivers/lio-core/target_core_transport.h |    1 +
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 31a96ec..2290f45 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -654,11 +654,24 @@ extern void transport_deregister_session_configfs (se_session_t *se_sess)
 
 EXPORT_SYMBOL(transport_deregister_session_configfs);
 
+extern void transport_free_session (se_session_t *se_sess)
+{
+	kmem_cache_free(se_sess_cache, se_sess);
+	return;
+}
+
+EXPORT_SYMBOL(transport_free_session);
+
 extern void transport_deregister_session (se_session_t *se_sess)
 {
 	se_portal_group_t *se_tpg = se_sess->se_tpg;
 	se_node_acl_t *se_nacl;
 
+	if (!(se_tpg)) {
+		transport_free_session(se_sess);
+		return;
+	}
+
 	spin_lock_bh(&se_tpg->session_lock);
 	list_del(&se_sess->sess_list);	
 	se_sess->se_tpg = NULL;
@@ -685,7 +698,7 @@ extern void transport_deregister_session (se_session_t *se_sess)
 		spin_unlock_bh(&se_tpg->acl_node_lock);
 	}
 
-	kmem_cache_free(se_sess_cache, se_sess);
+	transport_free_session(se_sess);
 
 	printk("TARGET_CORE[%s]: Deregistered fabric_sess\n",
 		TPG_TFO(se_tpg)->get_fabric_name());
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index a6a68af..b9fd482 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -113,6 +113,7 @@ extern void transport_check_dev_params_delim (char *, char **);
 extern struct se_session_s *transport_init_session (void);
 extern void __transport_register_session (struct se_portal_group_s *, struct se_node_acl_s *, struct se_session_s *, void *);
 extern void transport_register_session (struct se_portal_group_s *, struct se_node_acl_s *, struct se_session_s *, void *);
+extern void transport_free_session (struct se_session_s *);
 extern void transport_deregister_session_configfs (struct se_session_s *);
 extern void transport_deregister_session (struct se_session_s *);
 extern void transport_task_dev_remove_state (struct se_task_s *, struct se_device_s *);
-- 
1.5.4.1



