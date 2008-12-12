From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 4/12]: Updates for target_core_base.h
Date: Fri, 12 Dec 2008 01:31:00 -0800
Message-ID: <1229074260.4153.642.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758475AbYLLJb2@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From d28545d2cd9c401945360fdfd434c10aab7b00d7 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 00:48:48 -0800
Subject: [PATCH] [Target_Core_Mod]: Updates for target_core_base.h

This patch updates core Target_Core_Mod data structures to remove all
iSCSI specific code.  Also add se_portal_group_t data structure

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h |  110 ++++++++++++++++++++++++----------
 1 files changed, 77 insertions(+), 33 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 5bbde19..5a036e5 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -39,14 +39,18 @@
 #include <target_core_mib.h>
 #endif /* SNMP_SUPPORT */
 
-#include <iscsi_target_version.h>	    /* get version definition */
-
 #define SCSI_CDB_SIZE			16 /* SCSI Command Descriptor Block Size a la SCSI's MAX_COMMAND_SIZE */
 #define TRANSPORT_IOV_DATA_BUFFER	5
+
+#define TRANSPORT_MAX_GLOBAL_HBAS           256 /* Maximum Physical or Virtual HBAs globally (not part of a TPG) */
+#define TRANSPORT_MAX_LUNS_PER_TPG	    256 /* Maximum Number of LUNs per Target Portal Group */
+
 #define TRANSPORT_SENSE_BUFFER              64 /* Originally from iSCSI RFC, should be from SCSI_SENSE_BUFFERSIZE */
 #define TRANSPORT_SENSE_SEGMENT_LENGTH      66 /* Sense Data Segment */
 #define TRANSPORT_SENSE_SEGMENT_TOTAL       68 /* TRANSPORT_SENSE_SEGMENT_LENGTH + Padding */
 
+#define TRANSPORT_IQN_LEN			224 /* Currently same as ISCSI_IQN_LEN */
+
 /* used by PSCSI and iBlock Transport drivers */
 #define READ_BLOCK_LEN          		6
 #define READ_CAP_LEN            		8
@@ -129,12 +133,15 @@
 #define HBA_STATUS_INACTIVE			0x00000004
 
 /* se_lun_t->lun_status */
-#define ISCSI_LUN_STATUS_FREE			0
-#define ISCSI_LUN_STATUS_ACTIVE			1
+#define TRANSPORT_LUN_STATUS_FREE		0
+#define TRANSPORT_LUN_STATUS_ACTIVE		1
 
 /* se_lun_t->lun_type */
-#define ISCSI_LUN_TYPE_NONE			0
-#define ISCSI_LUN_TYPE_DEVICE			1
+#define TRANSPORT_LUN_TYPE_NONE			0
+#define TRANSPORT_LUN_TYPE_DEVICE		1
+
+/* Used for se_node_acl->nodeacl_flags */
+#define NAF_DYNAMIC_NODE_ACL                    0x01
 
 /* Special transport agnostic se_cmd_t->t_states */
 #define TRANSPORT_NO_STATE			240
@@ -187,18 +194,18 @@
 #define MEDIA_CHANGER				10
 
 /* se_dev_entry_t->lun_flags and se_lun_t->lun_access */
-#define ISCSI_LUNFLAGS_NO_ACCESS		0x00000000
-#define ISCSI_LUNFLAGS_INITIATOR_ACCESS		0x00000001
-#define ISCSI_LUNFLAGS_READ_ONLY		0x00000002
-#define ISCSI_LUNFLAGS_READ_WRITE		0x00000004
+#define TRANSPORT_LUNFLAGS_NO_ACCESS		0x00000000
+#define TRANSPORT_LUNFLAGS_INITIATOR_ACCESS	0x00000001
+#define TRANSPORT_LUNFLAGS_READ_ONLY		0x00000002
+#define TRANSPORT_LUNFLAGS_READ_WRITE		0x00000004
 
 /* se_device_t->dev_status */
-#define ISCSI_DEVICE_ACTIVATED			0x01
-#define	ISCSI_DEVICE_DEACTIVATED		0x02
-#define ISCSI_DEVICE_QUEUE_FULL			0x04
-#define	ISCSI_DEVICE_SHUTDOWN			0x08
-#define ISCSI_DEVICE_OFFLINE_ACTIVATED		0x10
-#define ISCSI_DEVICE_OFFLINE_DEACTIVATED	0x20
+#define TRANSPORT_DEVICE_ACTIVATED		0x01
+#define	TRANSPORT_DEVICE_DEACTIVATED		0x02
+#define TRANSPORT_DEVICE_QUEUE_FULL		0x04
+#define	TRANSPORT_DEVICE_SHUTDOWN		0x08
+#define TRANSPORT_DEVICE_OFFLINE_ACTIVATED	0x10
+#define TRANSPORT_DEVICE_OFFLINE_DEACTIVATED	0x20
 
 #define	DEV_STATUS_THR_TUR			1
 #define DEV_STATUS_THR_TAKE_ONLINE		2
@@ -300,7 +307,7 @@ typedef struct se_task_s {
         u32             task_sg_num;
         u32             task_sg_offset;
 	struct se_cmd_s	*task_se_cmd;
-        struct se_device_s     *iscsi_dev;
+        struct se_device_s     *se_dev;
         struct semaphore        task_stop_sem;
         atomic_t        task_active;
         atomic_t        task_execute_queue;
@@ -385,9 +392,9 @@ typedef struct se_cmd_s {
 	atomic_t                transport_sent;
 	void			*sense_buffer; /* Used for sense data */
 	struct iovec		*iov_data; /* Used with sockets based fabric plugins */
-	struct se_device_s      *iscsi_dev;
-	struct se_dev_entry_s   *iscsi_deve;
-	struct se_lun_s		*iscsi_lun; /* iSCSI device/LUN this commands belongs to */
+	struct se_device_s      *se_dev;
+	struct se_dev_entry_s   *se_deve;
+	struct se_lun_s		*se_lun;
 	struct se_obj_lun_type_s *se_obj_api;
 	void			*se_obj_ptr;
 	struct se_obj_lun_type_s *se_orig_obj_api;
@@ -423,14 +430,33 @@ typedef struct se_cmd_s {
 #define CMD_ORIG_OBJ_API(cmd) ((struct se_obj_lun_type_s *)(cmd->se_orig_obj_api))
 #define CMD_TFO(cmd) ((struct target_core_fabric_ops *)cmd->se_tfo)
 
+typedef struct se_tmr_req_s {
+	void 			*fabric_tmr_ptr;	
+} se_tmr_req_t;
+
 typedef struct se_node_acl_s {
+	char			initiatorname[TRANSPORT_IQN_LEN];
+	int			nodeacl_flags;
+	u32			queue_depth;
+#ifdef SNMP_SUPPORT
+	u32			acl_index;
+	u64			num_cmds;
+	u64			read_bytes;
+	u64			write_bytes;
+	spinlock_t		stats_lock;
+#endif /* SNMP_SUPPORT */
 	struct se_dev_entry_s	*device_list;
+	struct se_portal_group_s *se_tpg;
 	void			*fabric_acl_ptr;
 	spinlock_t		device_list_lock;
+	spinlock_t		nacl_sess_lock;
+	struct se_node_acl_s	*next;
+	struct se_node_acl_s	*prev;
 } se_node_acl_t;
 
 typedef struct se_session_s {
 	struct se_node_acl_s	*node_acl;
+	struct se_portal_group_s *se_tpg;
 	void			*fabric_sess_ptr;
 } se_session_t;
 
@@ -443,10 +469,10 @@ struct se_obj_lun_type_s;
 struct scatterlist;
 
 typedef struct se_lun_acl_s {
-	char			initiatorname[ISCSI_IQN_LEN];
+	char			initiatorname[TRANSPORT_IQN_LEN];
 	u32			mapped_lun;
-	struct iscsi_node_acl_s *se_lun_nacl;
-	struct se_lun_s		*iscsi_lun;
+	struct se_node_acl_s	*se_lun_nacl;
+	struct se_lun_s		*se_lun;
 	struct se_lun_acl_s	*next;
 	struct se_lun_acl_s	*prev;
 	struct config_group	se_lun_group;
@@ -466,7 +492,7 @@ typedef struct se_dev_entry_s {
 	__u64			read_bytes;
 	__u64			write_bytes;
 #endif /* SNMP_SUPPORT */
-	struct se_lun_s		*iscsi_lun;
+	struct se_lun_s		*se_lun;
 }  ____cacheline_aligned se_dev_entry_t;
 
 typedef struct se_dev_attrib_s {
@@ -540,14 +566,14 @@ typedef struct se_device_s {
 	struct se_task_s	*execute_task_tail;
 	struct se_task_s	*state_task_head;
 	struct se_task_s	*state_task_tail;
-	struct se_hba_s		*iscsi_hba;	/* Pointer to associated iSCSI HBA */
+	struct se_hba_s		*se_hba;	/* Pointer to associated iSCSI HBA */
 	struct se_subsystem_dev_s *se_sub_dev;
 	struct se_subsystem_api_s *transport;	/* Pointer to template of function pointers for transport */ 
 	struct se_device_s	*next;		/* Pointer to next device in TPG list */
 	struct se_device_s	*prev;
 }  ____cacheline_aligned se_device_t;
 
-#define ISCSI_DEV(cmd)		((se_device_t *)(cmd)->iscsi_lun->iscsi_dev)
+#define ISCSI_DEV(cmd)		((se_device_t *)(cmd)->se_lun->se_dev)
 #define DEV_ATTRIB(dev)		(&(dev)->se_sub_dev->se_dev_attrib)
 #define DEV_OBJ_API(dev)	((struct se_obj_lun_type_s *)(dev)->dev_obj_api)
 
@@ -577,15 +603,15 @@ typedef struct se_hba_s {
 	struct se_hba_s		*prev;
 }  ____cacheline_aligned se_hba_t;
 
-#define ISCSI_HBA(d)		((se_hba_t *)(d)->iscsi_hba)
+#define ISCSI_HBA(d)		((se_hba_t *)(d)->se_hba)
 // Using SE_HBA() for new code
-#define SE_HBA(d)		((se_hba_t *)(d)->iscsi_hba)
+#define SE_HBA(d)		((se_hba_t *)(d)->se_hba)
 
 typedef struct se_lun_s {
 	int			lun_type;
 	int			lun_status;
 	u32			lun_access;
-	u32			iscsi_lun;
+	u32			unpacked_lun;
 	spinlock_t		lun_acl_lock;
 	spinlock_t		lun_cmd_lock;
 	spinlock_t		lun_reservation_lock;
@@ -594,8 +620,8 @@ typedef struct se_lun_s {
 	se_cmd_t		*lun_cmd_tail;
 	se_lun_acl_t		*lun_acl_head;
 	se_lun_acl_t		*lun_acl_tail;
-	struct iscsi_node_acl_s *lun_reserved_node_acl;
-	se_device_t		*iscsi_dev;
+	struct se_node_acl_s	*lun_reserved_node_acl;
+	se_device_t		*se_dev;
 	void			*lun_type_ptr;
 	struct config_group	lun_group;
 	struct se_obj_lun_type_s *lun_obj_api;
@@ -605,7 +631,7 @@ typedef struct se_lun_s {
 	int (*persistent_reservation_reserve)(se_cmd_t *);
 } ____cacheline_aligned se_lun_t;
 
-#define ISCSI_LUN(c)            ((se_lun_t *)(c)->iscsi_lun)
+#define ISCSI_LUN(c)            ((se_lun_t *)(c)->se_lun)
 #define LUN_OBJ_API(lun)	((struct se_obj_lun_type_s *)(lun)->lun_obj_api)
 
 typedef struct se_port_s {
@@ -614,12 +640,30 @@ typedef struct se_port_s {
         scsi_port_stats_t sep_stats;
 #endif
         struct se_lun_s *sep_lun;
-        struct iscsi_portal_group_s *sep_tpg;
+        struct se_portal_group_s *sep_tpg;
         struct list_head sep_list;
 } se_port_t;
 
+typedef struct se_portal_group_s {
+	u32			num_node_acls;  /* Number of ACLed Initiator Nodes for this TPG */
+	spinlock_t		acl_node_lock;  /* Spinlock for adding/removing ACLed Nodes */
+	spinlock_t		session_lock;   /* Spinlock for adding/removing sessions */
+	spinlock_t		tpg_lun_lock;
+	void			*se_tpg_fabric_ptr; /* Pointer to $FABRIC_MOD portal group */
+	struct list_head	se_tpg_list;
+	struct se_lun_s		*tpg_lun_list;
+	struct se_node_acl_s	*acl_node_head; /* Pointer to start of Initiator ACL list */
+	struct se_node_acl_s	*acl_node_tail; /* Pointer to end of Initiator ACL list */
+	struct se_session_s	*session_head;  /* Pointer to start of iSCSI session list */
+	struct se_session_s	*session_tail;  /* Pointer to end of iSCSI session list */
+	struct target_core_fabric_ops *se_tpg_tfo; /* Pointer to $FABRIC_MOD dependent code */
+} se_portal_group_t;
+
+#define TPG_TFO(se_tpg)		((struct target_core_fabric_ops *)(se_tpg)->se_tpg_tfo)
+
 typedef struct se_global_s {
 	u32			in_shutdown;
+	struct list_head	g_se_tpg_list;
         struct se_plugin_class_s *plugin_class_list;
         se_hba_t                *hba_list;
 	spinlock_t		hba_lock;
-- 
1.5.4.1
