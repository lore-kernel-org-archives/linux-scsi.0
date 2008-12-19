From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 1/6] Updates for core data structures
Date: Fri, 19 Dec 2008 15:25:17 -0800
Message-ID: <1229729117.4560.83.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752604AbYLSXZ7@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From a56e1e6d783ddac851244b4ed2eba253eeb911ec Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 13:06:52 -0800
Subject: [PATCH] [Target_Core_Mod] Updates for core data structures

This patch adds TRANSPORT_TPG_TYPE_* defines used for core_tpg_register() and
adds ____cacheline_aligned to all of the se_* prefixed data structures.

For se_node_acl_t, it adds a *nacl_sess and ConfigFS struct config_groups.
For se_portal_group_t, it makes the former session headless list to use list_head.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 5a036e5..7349131 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -140,6 +140,10 @@
 #define TRANSPORT_LUN_TYPE_NONE			0
 #define TRANSPORT_LUN_TYPE_DEVICE		1
 
+/* se_portal_group_t->se_tpg_type */
+#define TRANSPORT_TPG_TYPE_NORMAL		0
+#define TRANSPORT_TPG_TYPE_DISCOVERY		1
+
 /* Used for se_node_acl->nodeacl_flags */
 #define NAF_DYNAMIC_NODE_ACL                    0x01
 
@@ -227,7 +231,7 @@
 
 typedef struct se_obj_s {
 	atomic_t obj_access_count;
-} se_obj_t;
+} ____cacheline_aligned se_obj_t;
 
 typedef struct t10_wwn_s {
         unsigned char vendor[8];
@@ -236,7 +240,7 @@ typedef struct t10_wwn_s {
         unsigned char unit_serial[INQUIRY_EVPD_SERIAL_LEN];
 	u32 device_identifier_code_set;
 	unsigned char device_identifier[INQUIRY_EVPD_DEVICE_IDENTIFIER_LEN];
-} t10_wwn_t;
+} ____cacheline_aligned t10_wwn_t;
 
 typedef struct se_queue_req_s {
         int                     state;
@@ -432,7 +436,7 @@ typedef struct se_cmd_s {
 
 typedef struct se_tmr_req_s {
 	void 			*fabric_tmr_ptr;	
-} se_tmr_req_t;
+} ____cacheline_aligned se_tmr_req_t;
 
 typedef struct se_node_acl_s {
 	char			initiatorname[TRANSPORT_IQN_LEN];
@@ -446,22 +450,26 @@ typedef struct se_node_acl_s {
 	spinlock_t		stats_lock;
 #endif /* SNMP_SUPPORT */
 	struct se_dev_entry_s	*device_list;
+	struct se_session_s	*nacl_sess;
 	struct se_portal_group_s *se_tpg;
 	void			*fabric_acl_ptr;
 	spinlock_t		device_list_lock;
 	spinlock_t		nacl_sess_lock;
+	struct config_group	acl_group;
+	struct config_group	acl_param_group;
 	struct se_node_acl_s	*next;
 	struct se_node_acl_s	*prev;
-} se_node_acl_t;
+} ____cacheline_aligned se_node_acl_t;
 
 typedef struct se_session_s {
-	struct se_node_acl_s	*node_acl;
+	struct se_node_acl_s	*se_node_acl;
 	struct se_portal_group_s *se_tpg;
 	void			*fabric_sess_ptr;
-} se_session_t;
+	struct list_head	sess_list;
+} ____cacheline_aligned se_session_t;
 
 #define SE_SESS(cmd)		((struct se_session_s *)(cmd)->se_sess)
-#define SE_NODE_ACL(sess)	((struct se_node_acl_s *)(sess)->node_acl)
+#define SE_NODE_ACL(sess)	((struct se_node_acl_s *)(sess)->se_node_acl)
 
 struct se_device_s;
 struct se_transform_info_s;
@@ -642,9 +650,10 @@ typedef struct se_port_s {
         struct se_lun_s *sep_lun;
         struct se_portal_group_s *sep_tpg;
         struct list_head sep_list;
-} se_port_t;
+} ____cacheline_aligned se_port_t;
 
 typedef struct se_portal_group_s {
+	int			se_tpg_type;	/* Type of target portal group */
 	u32			num_node_acls;  /* Number of ACLed Initiator Nodes for this TPG */
 	spinlock_t		acl_node_lock;  /* Spinlock for adding/removing ACLed Nodes */
 	spinlock_t		session_lock;   /* Spinlock for adding/removing sessions */
@@ -654,10 +663,9 @@ typedef struct se_portal_group_s {
 	struct se_lun_s		*tpg_lun_list;
 	struct se_node_acl_s	*acl_node_head; /* Pointer to start of Initiator ACL list */
 	struct se_node_acl_s	*acl_node_tail; /* Pointer to end of Initiator ACL list */
-	struct se_session_s	*session_head;  /* Pointer to start of iSCSI session list */
-	struct se_session_s	*session_tail;  /* Pointer to end of iSCSI session list */
+	struct list_head	tpg_sess_list;	/* List of TCM sessions assoicated wth this TPG */
 	struct target_core_fabric_ops *se_tpg_tfo; /* Pointer to $FABRIC_MOD dependent code */
-} se_portal_group_t;
+} ____cacheline_aligned se_portal_group_t;
 
 #define TPG_TFO(se_tpg)		((struct target_core_fabric_ops *)(se_tpg)->se_tpg_tfo)
 
@@ -671,6 +679,6 @@ typedef struct se_global_s {
 #ifdef DEBUG_DEV
         spinlock_t              debug_dev_lock;
 #endif
-} se_global_t;
+} ____cacheline_aligned se_global_t;
 
 #endif /* TARGET_CORE_BASE_H */
-- 
1.5.4.1
