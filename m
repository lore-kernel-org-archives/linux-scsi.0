From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 1/14]: Update core data structures and defines
Date: Fri, 19 Dec 2008 15:30:29 -0800
Message-ID: <1229729429.4560.103.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:22418 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751337AbYLSXa7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:30:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 9d7fe19966ca0a91ad84d925dfc32fd700032cb7 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 13:48:24 -0800
Subject: [PATCH] [LIO-Target]: Update core data structures and defines

This patch removes structure members from iscsi_cmd_t, iscsi_session_t,
iscsi_node_acl_t and iscsi_portal_group_t that have been made generic
in their target_core_base.h: se_* prefix'ed counterparts.

This patch also adds a iscsi_logout_t structure that will be needed later.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_core.h |   91 +++++----------------------------
 1 files changed, 14 insertions(+), 77 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_core.h b/drivers/lio-core/iscsi_target_core.h
index 079eca7..345230e 100644
--- a/drivers/lio-core/iscsi_target_core.h
+++ b/drivers/lio-core/iscsi_target_core.h
@@ -55,10 +55,7 @@
 #define IPV4_ADDRESS_SPACE		4
 #define IPV4_BUF_SIZE			18
 #define RESERVED			0xFFFFFFFF
-#define ISCSI_MAX_RAIDS			64 /* Maximum soft RAID arrays */
-#define ISCSI_RAID_ID_FPAA		(ISCSI_MAX_RAIDS / 2)
-#define ISCSI_MAX_GLOBAL_HBAS		256 /* Maximum Physical or Virtual HBAs globally (not part of a TPG) */
-#define ISCSI_MAX_LUNS_PER_TPG		256 /* Maximum Number of LUNs per iSCSI Target Portal Group */
+#define ISCSI_MAX_LUNS_PER_TPG		TRANSPORT_MAX_LUNS_PER_TPG /* from target_core_base.h */
 #define ISCSI_MAX_TPGS			64 /* Maximum Target Portal Groups allowed */
 #define ISCSI_NETDEV_NAME_SIZE		12 /* Size of the Network Device Name Buffer */
 
@@ -159,7 +156,6 @@
 #define ICF_ATTACHED_TO_RQUEUE			0x00000040
 #define ICF_OOO_CMDSN				0x00000080
 #define ICF_REJECT_FAIL_CONN			0x00000100
-#define ICF_SE_LUN_CMD				0x00000200
 
 /* iscsi_cmd_t->i_state */
 #define ISTATE_NO_STATE				0
@@ -227,9 +223,6 @@
 #define DATAOUT_SEND_TO_TRANSPORT		2
 #define DATAOUT_WITHIN_COMMAND_RECOVERY		3
 
-/* Used for iscsi_node_acl->nodeacl->flags */
-#define NAF_DYNAMIC_NODE_ACL			0x01
-
 /* Used for iscsi_cmd_t->dataout_timer_flags */
 #define DATAOUT_TF_RUNNING			0x01
 #define DATAOUT_TF_STOP				0x02
@@ -456,42 +449,12 @@ typedef struct iscsi_cmd_s {
 	struct iscsi_conn_s 	*conn;		/* Connection this command is alligient to */
 	struct iscsi_conn_recovery_s *cr;	/* Pointer to connection recovery entry */
 	struct iscsi_session_s	*sess;		/* Session the command is part of,  used for connection recovery */
-#if 0
-	struct se_dev_entry_s	*iscsi_deve;
-	struct se_lun_s		*iscsi_lun;	/* iSCSI device/LUN this commands belongs to */
-#endif
 	struct iscsi_cmd_s	*next;		/* Next command in the session pool */
 	struct iscsi_cmd_s	*i_next;	/* Next command in connection list */
 	struct iscsi_cmd_s	*i_prev;	/* Previous command in connection list */
 	struct iscsi_cmd_s	*t_next;	/* Next command in DAS transport list */
 	struct iscsi_cmd_s	*t_prev;	/* Previous command in DAS transport list */
 	struct se_cmd_s		*se_cmd;
-#if 0
-	struct se_device_s	*iscsi_dev;
-	struct se_obj_lun_type_s *se_obj_api;
-	void			*se_obj_ptr;
-	struct se_obj_lun_type_s *se_orig_obj_api;
-	void			*se_orig_obj_ptr;
-	struct se_transport_task_s *t_task;
-	int (*transport_add_cmd_to_queue)(struct iscsi_cmd_s *, u8);
-	int (*transport_allocate_iovecs)(struct iscsi_cmd_s *);
-	int (*transport_allocate_resources)(struct iscsi_cmd_s *, u32, u32);
-	int (*transport_cdb_transform)(struct iscsi_cmd_s *, struct se_transform_info_s *);
-	int (*transport_do_transform)(struct iscsi_cmd_s *, struct se_transform_info_s *);
-	void (*transport_free_resources)(struct iscsi_cmd_s *);
-	u32 (*transport_get_lba)(unsigned char *);
-	unsigned long long (*transport_get_long_lba)(unsigned char *);
-	struct se_task_s *(*transport_get_task)(struct se_transform_info_s *, struct iscsi_cmd_s *, void *, struct se_obj_lun_type_s *);
-	int (*transport_map_buffers_to_tasks)(struct iscsi_cmd_s *);
-	void (*transport_map_SG_segments)(struct iscsi_unmap_sg_s *);
-	void (*transport_passthrough_done)(struct iscsi_cmd_s *);
-	void (*transport_unmap_SG_segments)(struct iscsi_unmap_sg_s *);
-	int (*transport_set_iovec_ptrs)(struct iscsi_map_sg_s *, struct iscsi_unmap_sg_s *);
-	void (*transport_split_cdb)(unsigned long long, u32 *, unsigned char *);
-	void (*transport_wait_for_tasks)(struct iscsi_cmd_s *, int, int);
-        void (*callback)(struct iscsi_cmd_s *cmd, void *callback_arg, int complete_status);
-        void *callback_arg;
- #endif 
 }  ____cacheline_aligned iscsi_cmd_t;
 
 #define SE_CMD(cmd)		((struct se_cmd_s *)(cmd)->se_cmd)
@@ -638,7 +601,6 @@ typedef struct iscsi_session_s {
 	spinlock_t		session_stats_lock;
 #endif /* SNMP_SUPPORT */
 	atomic_t		nconn;		/* Number of active connections */
-	atomic_t		pool_count;
 	atomic_t		session_continuation;
 	atomic_t		session_fall_back_to_erl0;
 	atomic_t		session_logout;
@@ -648,8 +610,6 @@ typedef struct iscsi_session_s {
 	atomic_t		session_waiting_on_uc;
 	atomic_t		sleep_on_sess_wait_sem;
 	atomic_t		transport_wait_cmds;
-	iscsi_cmd_t		*pool_head;
-	iscsi_cmd_t		*pool_tail;
 	iscsi_conn_t		*conn_head;	/* Pointer to start of connection list */
 	iscsi_conn_t		*conn_tail;	/* Pointer to end of connection list */
 	iscsi_conn_recovery_t	*cr_a_head;
@@ -660,7 +620,6 @@ typedef struct iscsi_session_s {
 	spinlock_t		conn_lock;
 	spinlock_t		cr_a_lock;
 	spinlock_t		cr_i_lock;
-	spinlock_t		pool_lock;
 	spinlock_t		session_usage_lock;
 	spinlock_t		ttt_lock;
 	iscsi_ooo_cmdsn_t	*ooo_cmdsn_head;
@@ -671,16 +630,14 @@ typedef struct iscsi_session_s {
 	struct semaphore		session_waiting_on_uc_sem;
 	struct timer_list		time2retain_timer;
 	iscsi_sess_ops_t	*sess_ops;
+	struct se_session_s	*se_sess;
 	struct iscsi_portal_group_s *tpg;
-	struct iscsi_node_acl_s *node_acl;
-	struct iscsi_session_s	*next;
-	struct iscsi_session_s	*prev;
 } ____cacheline_aligned iscsi_session_t;
 
 #define SESS(conn)		((iscsi_session_t *)(conn)->sess)
 #define SESS_OPS(sess)		((iscsi_sess_ops_t *)(sess)->sess_ops)
 #define SESS_OPS_C(conn)	((iscsi_sess_ops_t *)(conn)->sess->sess_ops)
-#define SESS_NODE_ACL(sess)	((iscsi_node_acl_t *)(sess)->node_acl)
+#define SESS_NODE_ACL(sess)	((se_node_acl_t *)(sess)->se_sess->se_node_acl)
 
 typedef struct iscsi_login_s {
 	u8 auth_complete;
@@ -702,6 +659,12 @@ typedef struct iscsi_login_s {
 	char *rsp_buf;
 } ____cacheline_aligned iscsi_login_t;
 
+typedef struct iscsi_logout_s {
+	u8		logout_reason;
+	u8		logout_response;
+	u16		logout_cid;
+} ____cacheline_aligned iscsi_logout_t;
+
 #include <iscsi_thread_queue.h>
 
 #ifdef DEBUG_ERL
@@ -753,26 +716,8 @@ typedef struct iscsi_node_attrib_s {
 struct se_dev_entry_s;
 
 typedef struct iscsi_node_acl_s {
-	char			initiatorname[ISCSI_IQN_LEN];
-	int			nodeacl_flags;
-	__u32			queue_depth;
-#ifdef SNMP_SUPPORT
-	u32			acl_index;
-	u64			num_cmds;
-	u64			read_bytes;
-	u64			write_bytes;
-	spinlock_t		stats_lock;
-#endif /* SNMP_SUPPORT */
-	struct se_dev_entry_s	*device_list;
-	spinlock_t		device_list_lock;
-	spinlock_t		nacl_sess_lock;
 	iscsi_node_attrib_t	node_attrib;
-	iscsi_session_t		*nacl_sess;
-	struct config_group	acl_group;
-	struct config_group	acl_param_group;
-	struct iscsi_portal_group_s *tpg;
-	struct iscsi_node_acl_s	*next;
-	struct iscsi_node_acl_s	*prev;
+	struct se_node_acl_s	*se_node_acl;
 } ____cacheline_aligned iscsi_node_acl_t;
 
 #define ISCSI_NODE_ATTRIB(t)	(&(t)->node_attrib)
@@ -857,28 +802,19 @@ typedef struct iscsi_portal_group_s {
 	__u32			ndevs;		/* Number of available iSCSI devices */
 	__u32			nluns;		/* Number of active iSCSI LUNs */
 	__u32			nsessions;	/* Number of active sessions */
-	__u32			num_node_acls;	/* Number of ACLed Initiator Nodes for this TPG */
 	__u32			num_tpg_nps;	/* Number of Network Portals available for this TPG */
 	__u32			sid;		/* Per TPG PyX specific session ID. */
-	atomic_t		tpg_hba_count;
-	spinlock_t		acl_node_lock;	/* Spinlock for adding/removing ACLed Nodes */
-	spinlock_t		session_lock;	/* Spinlock for adding/removing sessions */
-	spinlock_t		tpg_lun_lock;
 	spinlock_t		tpg_np_lock;	/* Spinlock for adding/removing Network Portals */
 	spinlock_t		tpg_state_lock;
-	struct se_lun_s		*tpg_lun_list;
-	iscsi_node_acl_t	*acl_node_head;	/* Pointer to start of Initiator ACL list */
-	iscsi_node_acl_t	*acl_node_tail;	/* Pointer to end of Initiator ACL list */
+	struct se_portal_group_s *tpg_se_tpg;
 	struct config_group	tpg_np_group;
 	struct config_group	tpg_lun_group;
 	struct config_group	tpg_acl_group;
 	struct config_group	tpg_param_group;
 	struct config_group	tpg_group;
-	struct semaphore		tpg_access_sem;
-	struct semaphore		np_login_sem;
+	struct semaphore	tpg_access_sem;
+	struct semaphore	np_login_sem;
 	iscsi_tpg_attrib_t	tpg_attrib;
-	iscsi_session_t		*session_head;	/* Pointer to start of iSCSI session list */
-	iscsi_session_t		*session_tail;	/* Pointer to end of iSCSI session list */
 	iscsi_param_list_t	*param_list;	/* Pointer to default list of iSCSI parameters for TPG */
 	struct iscsi_tiqn_s	*tpg_tiqn;
 	struct iscsi_portal_group_s *next;	/* Pointer to next TPG entry */
@@ -890,6 +826,7 @@ typedef struct iscsi_portal_group_s {
 #define ISCSI_TPG_LUN(c, lun)	((iscsi_tpg_list_t *)(c)->tpg->tpg_lun_list_t[lun])
 #define ISCSI_TPG_S(s)		((iscsi_portal_group_t *)(s)->tpg)
 #define ISCSI_TPG_ATTRIB(t)	(&(t)->tpg_attrib)
+#define SE_TPG(tpg)		((struct se_portal_group_s *)(tpg)->tpg_se_tpg)
 
 typedef struct iscsi_tiqn_s {
 	unsigned char		tiqn[ISCSI_TIQN_LEN];
-- 
1.5.4.1



