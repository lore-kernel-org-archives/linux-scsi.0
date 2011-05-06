From: vikas.chaudhary@qlogic.com
Subject: [RFC PATCH 2/3] qla4xxx: support session management using iscsiadm.
Date: Fri,  6 May 2011 05:29:52 -0700
Message-ID: <1304684993-1715-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1304684993-1715-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36733 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752258Ab1EFMgC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 08:36:02 -0400
In-Reply-To: <1304684993-1715-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Add scsi_transport_iscsi hooks in qla4xxx to support iSCSI session
management using iscsiadm.

This patch is based on discussion here
http://groups.google.com/group/open-iscsi/browse_thread/thread/e89fd888baf656a0#

Now users can use iscsiadm to do target discovery and do login/logout to
individual targets using the qla4xxx iSCSI class interface.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |   38 ++-
 drivers/scsi/qla4xxx/ql4_fw.h   |   43 ++-
 drivers/scsi/qla4xxx/ql4_glbl.h |   18 +-
 drivers/scsi/qla4xxx/ql4_init.c |  111 ++----
 drivers/scsi/qla4xxx/ql4_iocb.c |   66 +++
 drivers/scsi/qla4xxx/ql4_isr.c  |   82 +++-
 drivers/scsi/qla4xxx/ql4_mbx.c  |  334 ++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c   |  991 ++++++++++++++++++++++++++++++---------
 8 files changed, 1317 insertions(+), 366 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 3a0316c..d9d59ba 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -33,9 +33,12 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
+#include <scsi/libiscsi.h>
 
 #include "ql4_dbg.h"
 #include "ql4_nx.h"
+#include "ql4_fw.h"
+#include "ql4_nvram.h"
 
 #ifndef PCI_DEVICE_ID_QLOGIC_ISP4010
 #define PCI_DEVICE_ID_QLOGIC_ISP4010	0x4010
@@ -109,7 +112,7 @@
 #define MAX_BUSES		1
 #define MAX_TARGETS		MAX_DEV_DB_ENTRIES
 #define MAX_LUNS		0xffff
-#define MAX_AEN_ENTRIES		256 /* should be > EXT_DEF_MAX_AEN_QUEUE */
+#define MAX_AEN_ENTRIES		MAX_DEV_DB_ENTRIES
 #define MAX_DDB_ENTRIES		MAX_DEV_DB_ENTRIES
 #define MAX_PDU_ENTRIES		32
 #define INVALID_ENTRY		0xFFFF
@@ -166,6 +169,7 @@
 #define RELOGIN_TOV			18
 #define ISNS_DEREG_TOV			5
 #define HBA_ONLINE_TOV			30
+#define AEN_WAIT_TOV			30
 
 #define MAX_RESET_HA_RETRIES		2
 
@@ -273,6 +277,7 @@ struct ddb_entry {
 
 	struct in6_addr remote_ipv6_addr;
 	struct in6_addr link_local_ipv6_addr;
+	struct completion aen_comp;
 };
 
 /*
@@ -293,8 +298,6 @@ struct ddb_entry {
 #define DF_FO_MASKED		3
 
 
-#include "ql4_fw.h"
-#include "ql4_nvram.h"
 
 struct ql82xx_hw_data {
 	/* Offsets for flash/nvram access (set to ~0 if not used). */
@@ -591,6 +594,33 @@ struct scsi_qla_host {
 	struct iscsi_iface *iface_ipv4;
 	struct iscsi_iface *iface_ipv6_1;
 	struct iscsi_iface *iface_ipv6_2;
+	struct dma_pool *chap_dma_pool;
+#define CHAP_DMA_BLOCK_SIZE	512
+	struct workqueue_struct *task_wq;
+	unsigned long ddb_idx_map[MAX_DDB_ENTRIES / BITS_PER_LONG];
+};
+
+struct ql4_task_data {
+	struct scsi_qla_host *ha;
+	uint8_t iocb_req_cnt;
+	dma_addr_t data_dma;
+	void *req_buffer;
+	dma_addr_t req_dma;
+	void *resp_buffer;
+	dma_addr_t resp_dma;
+	uint32_t resp_len;
+	struct iscsi_task *task;
+	struct passthru_status sts;
+	struct work_struct task_work;
+};
+
+struct qla_endpoint {
+	struct Scsi_Host *host;
+	struct sockaddr dst_addr;
+};
+
+struct qla_conn {
+	struct qla_endpoint *qla_ep;
 };
 
 static inline int is_ipv4_enabled(struct scsi_qla_host *ha)
@@ -641,7 +671,7 @@ static inline int adapter_up(struct scsi_qla_host *ha)
 
 static inline struct scsi_qla_host* to_qla_host(struct Scsi_Host *shost)
 {
-	return (struct scsi_qla_host *)shost->hostdata;
+	return (struct scsi_qla_host *)iscsi_host_priv(shost);
 }
 
 static inline void __iomem* isp_semaphore(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 6978a67..c557853 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -335,9 +335,11 @@ struct qla_flt_region {
 #define MBOX_CMD_WRITE_FLASH			0x0025
 #define MBOX_CMD_READ_FLASH			0x0026
 #define MBOX_CMD_CLEAR_DATABASE_ENTRY		0x0031
+#define MBOX_CMD_CONN_OPEN			0x0074
 #define MBOX_CMD_CONN_CLOSE_SESS_LOGOUT		0x0056
-#define LOGOUT_OPTION_CLOSE_SESSION		0x01
-#define LOGOUT_OPTION_RELOGIN			0x02
+#define LOGOUT_OPTION_CLOSE_SESSION		0x0002
+#define LOGOUT_OPTION_RELOGIN			0x0004
+#define LOGOUT_OPTION_FREE_DDB			0x0008
 #define MBOX_CMD_EXECUTE_IOCB_A64		0x005A
 #define MBOX_CMD_INITIALIZE_FIRMWARE		0x0060
 #define MBOX_CMD_GET_INIT_FW_CTRL_BLOCK		0x0061
@@ -346,6 +348,7 @@ struct qla_flt_region {
 #define MBOX_CMD_GET_DATABASE_ENTRY		0x0064
 #define DDB_DS_UNASSIGNED			0x00
 #define DDB_DS_NO_CONNECTION_ACTIVE		0x01
+#define DDB_DS_DISCOVERY			0x02
 #define DDB_DS_SESSION_ACTIVE			0x04
 #define DDB_DS_SESSION_FAILED			0x06
 #define DDB_DS_LOGIN_IN_PROCESS			0x07
@@ -379,7 +382,11 @@ struct qla_flt_region {
 #define FW_ADDSTATE_DHCPv4_LEASE_EXPIRED	0x0008
 #define FW_ADDSTATE_LINK_UP			0x0010
 #define FW_ADDSTATE_ISNS_SVC_ENABLED		0x0020
+
 #define MBOX_CMD_GET_DATABASE_ENTRY_DEFAULTS	0x006B
+/* Mailbox 1 */
+#define IPV6_DEFAULT_DDB_ENTRY			0x0001
+
 #define MBOX_CMD_CONN_OPEN_SESS_LOGIN		0x0074
 #define MBOX_CMD_GET_CRASH_RECORD		0x0076	/* 4010 only */
 #define MBOX_CMD_GET_CONN_EVENT_LOG		0x0077
@@ -467,7 +474,8 @@ struct addr_ctrl_blk {
 	uint8_t res0;	/* 07 */
 	uint16_t eth_mtu_size;	/* 08-09 */
 	uint16_t add_fw_options;	/* 0A-0B */
-#define SERIALIZE_TASK_MGMT		0x0400
+#define ADFWOPT_SERIALIZE_TASK_MGMT	0x0400
+#define ADFWOPT_AUTOCONN_DISABLE	0x0002
 
 	uint8_t hb_interval;	/* 0C */
 	uint8_t inst_num; /* 0D */
@@ -659,11 +667,30 @@ struct addr_ctrl_blk_def {
 
 /*************************************************************************/
 
+#define MAX_CHAP_ENTRIES_40XX  128
+#define MAX_CHAP_ENTRIES_82XX  1024
+
+struct ql4_chap_table {
+	uint16_t link;
+	uint8_t flags;
+	uint8_t secret_len;
+#define MIN_CHAP_SECRET_LEN 12
+#define MAX_CHAP_SECRET_LEN 100
+	uint8_t secret[MAX_CHAP_SECRET_LEN];
+#define MAX_CHAP_NAME_LEN 256
+	uint8_t name[MAX_CHAP_NAME_LEN];
+	uint16_t reserved;
+#define CHAP_VALID_COOKIE 0x4092
+#define CHAP_INVALID_COOKIE 0xFFEE
+	uint16_t cookie;
+};
+
 struct dev_db_entry {
 	uint16_t options;	/* 00-01 */
 #define DDB_OPT_DISC_SESSION  0x10
 #define DDB_OPT_TARGET	      0x02 /* device is a target */
 #define DDB_OPT_IPV6_DEVICE	0x100
+#define DDB_OPT_AUTO_SENDTGTS_DISABLE		0x40
 #define DDB_OPT_IPV6_NULL_LINK_LOCAL		0x800 /* post connection */
 #define DDB_OPT_IPV6_FW_DEFINED_LINK_LOCAL	0x800 /* pre connection */
 
@@ -834,6 +861,7 @@ struct qla4_header {
 
 	uint8_t entryStatus;
 	uint8_t systemDefined;
+#define SD_ISCSI_PDU	0x01
 	uint8_t entryCount;
 
 	/* SyetemDefined definition */
@@ -991,21 +1019,22 @@ struct passthru0 {
 	struct qla4_header hdr;		       /* 00-03 */
 	uint32_t handle;	/* 04-07 */
 	uint16_t target;	/* 08-09 */
-	uint16_t connectionID;	/* 0A-0B */
+	uint16_t connection_id;	/* 0A-0B */
 #define ISNS_DEFAULT_SERVER_CONN_ID	((uint16_t)0x8000)
 
-	uint16_t controlFlags;	/* 0C-0D */
+	uint16_t control_flags;	/* 0C-0D */
 #define PT_FLAG_ETHERNET_FRAME		0x8000
 #define PT_FLAG_ISNS_PDU		0x8000
 #define PT_FLAG_SEND_BUFFER		0x0200
 #define PT_FLAG_WAIT_4_RESPONSE		0x0100
+#define PT_FLAG_ISCSI_PDU		0x1000
 
 	uint16_t timeout;	/* 0E-0F */
 #define PT_DEFAULT_TIMEOUT		30 /* seconds */
 
-	struct data_seg_a64 outDataSeg64;	/* 10-1B */
+	struct data_seg_a64 out_dsd;	/* 10-1B */
 	uint32_t res1;		/* 1C-1F */
-	struct data_seg_a64 inDataSeg64;	/* 20-2B */
+	struct data_seg_a64 in_dsd;	/* 20-2B */
 	uint8_t res2[20];	/* 2C-3F */
 };
 
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index e0a2abb..74d89d6 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -51,7 +51,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 			    uint16_t *connection_id);
 
 int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_index,
-			  dma_addr_t fw_ddb_entry_dma);
+			  dma_addr_t fw_ddb_entry_dma, uint32_t *mbx_sts);
 uint8_t qla4xxx_get_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 			 uint32_t *mbox_sts, dma_addr_t init_fw_cb_dma);
 int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *ha,
@@ -63,8 +63,8 @@ int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 		    uint32_t *mbox_sts, dma_addr_t acb_dma);
 int qla4xxx_get_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 		    uint32_t *mbox_sts, dma_addr_t acb_dma);
-void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
-				 struct ddb_entry *ddb_entry);
+void qla4xxx_mark_device_missing(struct iscsi_cls_session *cls_session);
+int qla4xxx_session_online(struct iscsi_cls_session *session);
 u16 rd_nvram_word(struct scsi_qla_host *ha, int offset);
 void qla4xxx_get_crash_record(struct scsi_qla_host *ha);
 struct ddb_entry *qla4xxx_alloc_sess(struct scsi_qla_host *ha);
@@ -153,6 +153,18 @@ void qla4_8xxx_need_qsnt_handler(struct scsi_qla_host *ha);
 void qla4_8xxx_clear_drv_active(struct scsi_qla_host *ha);
 void qla4_8xxx_set_drv_active(struct scsi_qla_host *ha);
 
+int qla4xxx_conn_open(struct scsi_qla_host *ha, uint16_t fw_ddb_index);
+int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
+			       struct ddb_entry *ddb_entry,
+			       struct iscsi_cls_conn *cls_conn,
+			       uint32_t *mbx_sts);
+int qla4xxx_session_logout_ddb(struct scsi_qla_host *ha,
+			       struct ddb_entry *ddb_entry, int options);
+int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
+			  uint32_t *mbx_sts);
+int qla4xxx_clear_ddb_entry(struct scsi_qla_host *ha, uint32_t fw_ddb_index);
+int qla4xxx_send_passthru0(struct iscsi_task *task);
+
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
 extern int ql4xenablemsix;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 1f267d8..4165bfe 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -48,22 +48,16 @@ static void ql4xxx_set_mac_number(struct scsi_qla_host *ha)
  * @ha: pointer to host adapter structure.
  * @ddb_entry: pointer to device database entry
  *
- * This routine deallocates and unlinks the specified ddb_entry from the
- * adapter's
+ * This routine marks a DDB entry INVALID
+ *
  **/
 void qla4xxx_free_ddb(struct scsi_qla_host *ha,
-    struct ddb_entry *ddb_entry)
+		      struct ddb_entry *ddb_entry)
 {
-	/* Remove device entry from list */
-	list_del_init(&ddb_entry->list);
-
 	/* Remove device pointer from index mapping arrays */
 	ha->fw_ddb_index_map[ddb_entry->fw_ddb_index] =
-		(struct ddb_entry *) INVALID_ENTRY;
+				(struct ddb_entry *) INVALID_ENTRY;
 	ha->tot_ddbs--;
-
-	/* Free memory and scsi-ml struct for device entry */
-	qla4xxx_destroy_sess(ddb_entry);
 }
 
 /**
@@ -820,7 +814,8 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 					((!ipv6_device &&
 					  *((uint32_t *)fw_ddb_entry->ip_addr))
 					 || ipv6_device)) {
-				qla4xxx_set_ddb_entry(ha, fw_ddb_index, 0);
+				qla4xxx_set_ddb_entry(ha, fw_ddb_index, 0,
+						      NULL);
 				if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index,
 							NULL, 0, NULL,
 							&next_fw_ddb_index,
@@ -927,7 +922,7 @@ int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host *ha)
 				       ddb_entry->fw_ddb_index));
 			iscsi_unblock_session(ddb_entry->sess);
 		} else if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
-			qla4xxx_mark_device_missing(ha, ddb_entry);
+			qla4xxx_mark_device_missing(ddb_entry->sess);
 	}
 	return status;
 }
@@ -952,7 +947,7 @@ int qla4xxx_relogin_device(struct scsi_qla_host *ha,
 	DEBUG2(printk("scsi%ld: Relogin ddb [%d]. TOV=%d\n", ha->host_no,
 		      ddb_entry->fw_ddb_index, relogin_timer));
 
-	qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index, 0);
+	qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index, 0, NULL);
 
 	return QLA_SUCCESS;
 }
@@ -1415,9 +1410,10 @@ static void qla4xxx_add_device_dynamically(struct scsi_qla_host *ha,
  * This routine processes a Decive Database Changed AEN Event.
  **/
 int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
-		uint32_t state, uint32_t conn_err)
+				uint32_t state, uint32_t conn_err)
 {
 	struct ddb_entry * ddb_entry;
+	uint32_t old_fw_ddb_device_state;
 
 	/* check for out of range index */
 	if (fw_ddb_index >= MAX_DDB_ENTRIES)
@@ -1427,79 +1423,34 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
 	/* Device does not currently exist in our database. */
 	if (ddb_entry == NULL) {
-		if (state == DDB_DS_SESSION_ACTIVE)
-			qla4xxx_add_device_dynamically(ha, fw_ddb_index);
-		return QLA_SUCCESS;
+		ql4_printk(KERN_ERR, ha,
+			   "%s: No ddb_entry at FW index [%d]\n", __func__,
+			   fw_ddb_index);
+		return QLA_ERROR;
 	}
 
-	/* Device already exists in our database. */
-	DEBUG2(printk("scsi%ld: %s DDB - old state= 0x%x, new state=0x%x for "
-		      "index [%d]\n", ha->host_no, __func__,
-		      ddb_entry->fw_ddb_device_state, state, fw_ddb_index));
+	old_fw_ddb_device_state = ddb_entry->fw_ddb_device_state;
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "%s: DDB - old state = 0x%x, new state = 0x%x for "
+			  "index [%d]\n", __func__,
+			  ddb_entry->fw_ddb_device_state, state, fw_ddb_index));
 
 	ddb_entry->fw_ddb_device_state = state;
-	/* Device is back online. */
-	if ((ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) &&
-	   (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)) {
-		atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
-		atomic_set(&ddb_entry->relogin_retry_count, 0);
-		atomic_set(&ddb_entry->relogin_timer, 0);
-		clear_bit(DF_RELOGIN, &ddb_entry->flags);
-		iscsi_unblock_session(ddb_entry->sess);
-		iscsi_session_event(ddb_entry->sess,
-				    ISCSI_KEVENT_CREATE_SESSION);
-		/*
-		 * Change the lun state to READY in case the lun TIMEOUT before
-		 * the device came back.
-		 */
-	} else if (ddb_entry->fw_ddb_device_state != DDB_DS_SESSION_ACTIVE) {
-		/* Device went away, mark device missing */
-		if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE) {
-			DEBUG2(ql4_printk(KERN_INFO, ha, "%s mark missing "
-					"ddb_entry 0x%p sess 0x%p conn 0x%p\n",
-					__func__, ddb_entry,
-					ddb_entry->sess, ddb_entry->conn));
-			qla4xxx_mark_device_missing(ha, ddb_entry);
-		}
 
-		/*
-		 * Relogin if device state changed to a not active state.
-		 * However, do not relogin if a RELOGIN is in process, or
-		 * we are not allowed to relogin to this DDB.
-		 */
-		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_FAILED &&
-		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
-		    qla4_is_relogin_allowed(ha, conn_err)) {
-			/*
-			 * This triggers a relogin.  After the relogin_timer
-			 * expires, the relogin gets scheduled.	 We must wait a
-			 * minimum amount of time since receiving an 0x8014 AEN
-			 * with failed device_state or a logout response before
-			 * we can issue another relogin.
-			 */
-			/* Firmware pads this timeout: (time2wait +1).
-			 * Driver retry to login should be longer than F/W.
-			 * Otherwise F/W will fail
-			 * set_ddb() mbx cmd with 0x4005 since it still
-			 * counting down its time2wait.
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "%s: Completing the AEN wait\n", __func__));
+	complete(&ddb_entry->aen_comp);
+
+	if (old_fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
+		if (state == DDB_DS_SESSION_FAILED) {
+			/* iscsi_session failure  will cause userspace to
+			 * stop the connection which in turn would block the
+			 * iscsi_session and start relogin
 			 */
-			atomic_set(&ddb_entry->relogin_timer, 0);
-			atomic_set(&ddb_entry->retry_relogin_timer,
-				   ddb_entry->default_time2wait + 4);
-			DEBUG(printk("scsi%ld: %s: ddb[%d] "
-			    "initiate relogin after %d seconds\n",
-			    ha->host_no, __func__,
-			    ddb_entry->fw_ddb_index,
-			    ddb_entry->default_time2wait + 4));
-		} else {
-			DEBUG(printk("scsi%ld: %s: ddb[%d] "
-			    "relogin not initiated, state = %d, "
-			    "ddb_entry->flags = 0x%lx\n",
-			    ha->host_no, __func__,
-			    ddb_entry->fw_ddb_index,
-			    ddb_entry->fw_ddb_device_state,
-			    ddb_entry->flags));
+			iscsi_session_failure(ddb_entry->sess->dd_data,
+					      ISCSI_ERR_CONN_FAILED);
 		}
 	}
+
 	return QLA_SUCCESS;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index 75fcd82..2c752ab 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -381,3 +381,69 @@ queuing_error:
 	return QLA_ERROR;
 }
 
+int qla4xxx_send_passthru0(struct iscsi_task *task)
+{
+	struct passthru0 *passthru_iocb;
+	struct iscsi_session *sess = task->conn->session;
+	struct ddb_entry *ddb_entry = (struct ddb_entry *)sess->dd_data;
+	struct scsi_qla_host *ha = ddb_entry->ha;
+	struct ql4_task_data *task_data = task->dd_data;
+	uint16_t ctrl_flags = 0;
+	unsigned long flags;
+	int ret = QLA_ERROR;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	task_data->iocb_req_cnt = 1;
+	/* Put the IOCB on the request queue */
+	if (!qla4xxx_space_in_req_ring(ha, task_data->iocb_req_cnt))
+		goto queuing_error;
+
+	passthru_iocb = (struct passthru0 *) ha->request_ptr;
+
+	memset(passthru_iocb, 0, sizeof(struct passthru0));
+	passthru_iocb->hdr.entryType = ET_PASSTHRU0;
+	passthru_iocb->hdr.systemDefined = SD_ISCSI_PDU;
+	passthru_iocb->hdr.entryCount = task_data->iocb_req_cnt;
+	passthru_iocb->handle = task->itt;
+	passthru_iocb->target = cpu_to_le16(ddb_entry->fw_ddb_index);
+	passthru_iocb->timeout = cpu_to_le16(PT_DEFAULT_TIMEOUT);
+
+	/* Setup the out & in DSDs */
+	if (task->data_count) {
+		memcpy((uint8_t *)task_data->req_buffer +
+		       sizeof(struct iscsi_hdr), task->data, task->data_count);
+		ctrl_flags |= PT_FLAG_SEND_BUFFER;
+		passthru_iocb->out_dsd.base.addrLow =
+					cpu_to_le32(LSDW(task_data->req_dma));
+		passthru_iocb->out_dsd.base.addrHigh =
+					cpu_to_le32(MSDW(task_data->req_dma));
+		passthru_iocb->out_dsd.count =
+					cpu_to_le32(task->data_count +
+						    sizeof(struct iscsi_hdr));
+	}
+	if (task_data->resp_len) {
+		passthru_iocb->in_dsd.base.addrLow =
+					cpu_to_le32(LSDW(task_data->resp_dma));
+		passthru_iocb->in_dsd.base.addrHigh =
+					cpu_to_le32(MSDW(task_data->resp_dma));
+		passthru_iocb->in_dsd.count =
+			cpu_to_le32(task_data->resp_len);
+	}
+
+	ctrl_flags |= (PT_FLAG_ISCSI_PDU | PT_FLAG_WAIT_4_RESPONSE);
+	passthru_iocb->control_flags = cpu_to_le16(ctrl_flags);
+
+	/* Update the request pointer */
+	qla4xxx_advance_req_ring_ptr(ha);
+	wmb();
+
+	/* Track IOCB used */
+	ha->iocb_cnt += task_data->iocb_req_cnt;
+	ha->req_q_count -= task_data->iocb_req_cnt;
+	ha->isp_ops->queue_iocb(ha);
+	ret = QLA_SUCCESS;
+
+queuing_error:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return ret;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 2f40ac7..70f45a1 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -219,8 +219,8 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		 * I/O to this device.	We should get a ddb state change
 		 * AEN soon.
 		 */
-		if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
-			qla4xxx_mark_device_missing(ha, ddb_entry);
+		if (qla4xxx_session_online(ddb_entry->sess))
+			qla4xxx_mark_device_missing(ddb_entry->sess);
 		break;
 
 	case SCS_DATA_UNDERRUN:
@@ -301,8 +301,8 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		 * send I/O to this device.  We should get a ddb
 		 * state change AEN soon.
 		 */
-		if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
-			qla4xxx_mark_device_missing(ha, ddb_entry);
+		if (qla4xxx_session_online(ddb_entry->sess))
+			qla4xxx_mark_device_missing(ddb_entry->sess);
 
 		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 		break;
@@ -336,6 +336,53 @@ status_entry_exit:
 }
 
 /**
+ * qla4xxx_passthru_status_entry - processes passthru status IOCBs (0x3C)
+ * @ha: Pointer to host adapter structure.
+ * @sts_entry: Pointer to status entry structure.
+ **/
+static void qla4xxx_passthru_status_entry(struct scsi_qla_host *ha,
+					  struct passthru_status *sts_entry)
+{
+	struct iscsi_task *task;
+	struct ddb_entry *ddb_entry;
+	struct ql4_task_data *task_data;
+	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_conn *conn;
+	itt_t itt;
+	uint32_t fw_ddb_index;
+
+	itt = sts_entry->handle;
+	fw_ddb_index = le32_to_cpu(sts_entry->target);
+
+	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
+
+	if (ddb_entry == NULL) {
+		ql4_printk(KERN_ERR, ha, "%s: Invalid target index = 0x%x\n",
+			   __func__, sts_entry->target);
+		return;
+	}
+
+	cls_conn = ddb_entry->conn;
+	conn = cls_conn->dd_data;
+	spin_lock(&conn->session->lock);
+	task = iscsi_itt_to_task(conn, itt);
+	spin_unlock(&conn->session->lock);
+
+	if (task == NULL) {
+		ql4_printk(KERN_ERR, ha, "%s: Task is NULL\n", __func__);
+		return;
+	}
+
+	task_data = (struct ql4_task_data *)task->dd_data;
+	memcpy(&task_data->sts, sts_entry, sizeof(struct passthru_status));
+	ha->req_q_count += task_data->iocb_req_cnt;
+	ha->iocb_cnt -= task_data->iocb_req_cnt;
+	queue_work(ha->task_wq, &task_data->task_work);
+
+	return;
+}
+
+/**
  * qla4xxx_process_response_queue - process response queue completions
  * @ha: Pointer to host adapter structure.
  *
@@ -370,6 +417,13 @@ void qla4xxx_process_response_queue(struct scsi_qla_host *ha)
 			break;
 
 		case ET_PASSTHRU_STATUS:
+			if (sts_entry->hdr.systemDefined == SD_ISCSI_PDU)
+				qla4xxx_passthru_status_entry(ha,
+					(struct passthru_status *)sts_entry);
+			else
+				ql4_printk(KERN_ERR, ha,
+					   "%s: Invalid status received\n",
+					   __func__);
 			break;
 
 		case ET_STATUS_CONTINUATION:
@@ -1001,23 +1055,23 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen)
 
 		switch (mbox_sts[0]) {
 		case MBOX_ASTS_DATABASE_CHANGED:
-			if (process_aen == FLUSH_DDB_CHANGED_AENS) {
+			switch (process_aen) {
+			case FLUSH_DDB_CHANGED_AENS:
 				DEBUG2(printk("scsi%ld: AEN[%d] %04x, index "
 					      "[%d] state=%04x FLUSHED!\n",
 					      ha->host_no, ha->aen_out,
 					      mbox_sts[0], mbox_sts[2],
 					      mbox_sts[3]));
 				break;
+			case PROCESS_ALL_AENS:
+			default:
+				/* Specific device. */
+				if (mbox_sts[1] == 1)
+					qla4xxx_process_ddb_changed(ha,
+						mbox_sts[2], mbox_sts[3],
+						mbox_sts[4]);
+				break;
 			}
-		case PROCESS_ALL_AENS:
-		default:
-			if (mbox_sts[1] == 0) {	/* Global DB change. */
-				qla4xxx_reinitialize_ddb_list(ha);
-			} else if (mbox_sts[1] == 1) {	/* Specific device. */
-				qla4xxx_process_ddb_changed(ha, mbox_sts[2],
-						mbox_sts[3], mbox_sts[4]);
-			}
-			break;
 		}
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index a62435d..100b4f2 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -491,10 +491,11 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 
 	init_fw_cb->fw_options &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);
 
-	/* Set bit for "serialize task mgmt" all other bits need to be zero */
 	init_fw_cb->add_fw_options = 0;
 	init_fw_cb->add_fw_options |=
-	    __constant_cpu_to_le16(SERIALIZE_TASK_MGMT);
+			__constant_cpu_to_le16(ADFWOPT_SERIALIZE_TASK_MGMT);
+	init_fw_cb->add_fw_options |=
+			__constant_cpu_to_le16(ADFWOPT_AUTOCONN_DISABLE);
 
 	if (qla4xxx_set_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma)
 		!= QLA_SUCCESS) {
@@ -720,19 +721,38 @@ exit_get_fwddb:
 	return status;
 }
 
+int qla4xxx_conn_open(struct scsi_qla_host *ha, uint16_t fw_ddb_index)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status;
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_CONN_OPEN;
+	mbox_cmd[1] = fw_ddb_index;
+
+	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
+					 &mbox_sts[0]);
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "%s: status = %d mbx0 = 0x%x mbx1 = 0x%x\n",
+			  __func__, status, mbox_sts[0], mbox_sts[1]));
+	return status;
+}
+
 /**
  * qla4xxx_set_fwddb_entry - sets a ddb entry.
  * @ha: Pointer to host adapter structure.
  * @fw_ddb_index: Firmware's device database index
- * @fw_ddb_entry: Pointer to firmware's ddb entry structure, or NULL.
+ * @fw_ddb_entry_dma: dma address of ddb entry
+ * @mbx_sts: mailbox 0 to be returned or NULL
  *
  * This routine initializes or updates the adapter's device database
- * entry for the specified device. It also triggers a login for the
- * specified device. Therefore, it may also be used as a secondary
- * login routine when a NULL pointer is specified for the fw_ddb_entry.
+ * entry for the specified device.
  **/
 int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_index,
-			  dma_addr_t fw_ddb_entry_dma)
+			  dma_addr_t fw_ddb_entry_dma, uint32_t *mbx_sts)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
@@ -751,13 +771,40 @@ int qla4xxx_set_ddb_entry(struct scsi_qla_host * ha, uint16_t fw_ddb_index,
 	mbox_cmd[4] = sizeof(struct dev_db_entry);
 
 	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0],
-	    &mbox_sts[0]);
+					 &mbox_sts[0]);
+	if (mbx_sts)
+		*mbx_sts = mbox_sts[0];
 	DEBUG2(printk("scsi%ld: %s: status=%d mbx0=0x%x mbx4=0x%x\n",
 	    ha->host_no, __func__, status, mbox_sts[0], mbox_sts[4]);)
 
 	return status;
 }
 
+int qla4xxx_session_logout_ddb(struct scsi_qla_host *ha,
+			       struct ddb_entry *ddb_entry, int options)
+{
+	int status;
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_CONN_CLOSE_SESS_LOGOUT;
+	mbox_cmd[1] = ddb_entry->fw_ddb_index;
+	mbox_cmd[3] = options;
+
+	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0],
+					 &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "%s: MBOX_CMD_CONN_CLOSE_SESS_LOGOUT "
+				  "failed sts %04X %04X", __func__,
+				  mbox_sts[0], mbox_sts[1]));
+	}
+
+	return status;
+}
 /**
  * qla4xxx_get_crash_record - retrieves crash record.
  * @ha: Pointer to host adapter structure.
@@ -1106,7 +1153,7 @@ int qla4xxx_get_fw_version(struct scsi_qla_host * ha)
 	return QLA_SUCCESS;
 }
 
-static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
+static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha, uint32_t options,
 				   dma_addr_t dma_addr)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
@@ -1116,6 +1163,7 @@ static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
 
 	mbox_cmd[0] = MBOX_CMD_GET_DATABASE_ENTRY_DEFAULTS;
+	mbox_cmd[1] = options;
 	mbox_cmd[2] = LSDW(dma_addr);
 	mbox_cmd[3] = MSDW(dma_addr);
 
@@ -1128,8 +1176,10 @@ static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
 	return QLA_SUCCESS;
 }
 
-static int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t *ddb_index)
+int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t ddb_index,
+			  uint32_t *mbx_sts)
 {
+	int status;
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
 
@@ -1137,30 +1187,25 @@ static int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t *ddb_index)
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
 
 	mbox_cmd[0] = MBOX_CMD_REQUEST_DATABASE_ENTRY;
-	mbox_cmd[1] = MAX_PRST_DEV_DB_ENTRIES;
+	mbox_cmd[1] = ddb_index;
 
-	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 3, &mbox_cmd[0], &mbox_sts[0]) !=
-	    QLA_SUCCESS) {
-		if (mbox_sts[0] == MBOX_STS_COMMAND_ERROR) {
-			*ddb_index = mbox_sts[2];
-		} else {
-			DEBUG2(printk("scsi%ld: %s: failed status %04X\n",
-			     ha->host_no, __func__, mbox_sts[0]));
-			return QLA_ERROR;
-		}
-	} else {
-		*ddb_index = MAX_PRST_DEV_DB_ENTRIES;
+	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+					 &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: failed status %04X\n",
+				   __func__, mbox_sts[0]));
 	}
 
-	return QLA_SUCCESS;
+	*mbx_sts = mbox_sts[0];
+	return status;
 }
 
-
 int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 {
 	struct dev_db_entry *fw_ddb_entry;
 	dma_addr_t fw_ddb_entry_dma;
 	uint32_t ddb_index;
+	uint32_t mbx_sts;
 	int ret_val = QLA_SUCCESS;
 
 
@@ -1178,7 +1223,7 @@ int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 	if (ret_val != QLA_SUCCESS)
 		goto exit_send_tgts;
 
-	ret_val = qla4xxx_req_ddb_entry(ha, &ddb_index);
+	ret_val = qla4xxx_req_ddb_entry(ha, ddb_index, &mbx_sts);
 	if (ret_val != QLA_SUCCESS)
 		goto exit_send_tgts;
 
@@ -1200,7 +1245,8 @@ int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 	fw_ddb_entry->ip_addr[2] = *(ip + 2);
 	fw_ddb_entry->ip_addr[3] = *(ip + 3);
 
-	ret_val = qla4xxx_set_ddb_entry(ha, ddb_index, fw_ddb_entry_dma);
+	ret_val = qla4xxx_set_ddb_entry(ha, ddb_index, fw_ddb_entry_dma,
+					NULL);
 
 exit_send_tgts:
 	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
@@ -1209,6 +1255,29 @@ exit_send_tgts_no_free:
 	return ret_val;
 }
 
+int qla4xxx_clear_ddb_entry(struct scsi_qla_host *ha, uint32_t ddb_index)
+{
+	int status;
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_CLEAR_DATABASE_ENTRY;
+	mbox_cmd[1] = ddb_index;
+
+	status = qla4xxx_mailbox_command(ha, 2, 1, &mbox_cmd[0],
+					 &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: failed status %04X\n",
+				   __func__, mbox_sts[0]));
+	}
+
+	return status;
+}
+
+
 int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t length, uint32_t options)
 {
@@ -1351,3 +1420,216 @@ int qla4xxx_ping(struct scsi_qla_host *ha, uint32_t options,
 
 	return status;
 }
+
+static int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username,
+			    char *password, uint16_t idx, int bidi)
+{
+	int ret = 0;
+	int rval = QLA_ERROR;
+	uint32_t offset = 0;
+	struct ql4_chap_table *chap_table;
+	dma_addr_t chap_dma;
+
+	chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
+	if (chap_table == NULL) {
+		ret =  -ENOMEM;
+		goto exit_set_chap;
+	}
+
+	memset(chap_table, 0, sizeof(struct ql4_chap_table));
+	if (bidi)
+		chap_table->flags |= BIT_6; /* peer */
+	else
+		chap_table->flags |= BIT_7; /* local */
+	chap_table->secret_len = strlen(password) + 1;
+	strncpy(chap_table->secret, password, 100);
+	strncpy(chap_table->name, username, 256);
+	chap_table->cookie = __constant_cpu_to_le16(CHAP_VALID_COOKIE);
+	offset = 0x06000000 | (idx * sizeof(struct ql4_chap_table));
+	rval = qla4xxx_set_flash(ha, chap_dma, offset,
+				sizeof(struct ql4_chap_table),
+				FLASH_OPT_RMW_COMMIT);
+	dma_pool_free(ha->chap_dma_pool, chap_table, chap_dma);
+	if (rval != QLA_SUCCESS)
+		ret =  -EINVAL;
+
+exit_set_chap:
+	return ret;
+}
+
+
+int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
+			       struct ddb_entry *ddb_entry,
+			       struct iscsi_cls_conn *cls_conn,
+			       uint32_t *mbx_sts)
+{
+	struct dev_db_entry *fw_ddb_entry;
+	struct iscsi_conn *conn;
+	struct iscsi_session *sess;
+	struct qla_conn *qla_conn;
+	struct sockaddr *dst_addr;
+	dma_addr_t fw_ddb_entry_dma;
+	int status = QLA_SUCCESS;
+	int rval = 0;
+	struct sockaddr_in *addr;
+	struct sockaddr_in6 *addr6;
+	char *ip;
+	uint16_t iscsi_opts = 0;
+	uint32_t options = 0;
+	uint16_t idx;
+	int max_chap_entries = 0;
+
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		DEBUG2(ql4_printk(KERN_ERR, ha,
+				  "%s: Unable to allocate dma buffer.\n",
+				  __func__));
+		rval = -ENOMEM;
+		goto exit_set_param_no_free;
+	}
+
+	conn = cls_conn->dd_data;
+	qla_conn = conn->dd_data;
+	sess = conn->session;
+	dst_addr = &qla_conn->qla_ep->dst_addr;
+
+	if (dst_addr->sa_family == AF_INET6)
+		options |= IPV6_DEFAULT_DDB_ENTRY;
+
+	status = qla4xxx_get_default_ddb(ha, options, fw_ddb_entry_dma);
+	if (status == QLA_ERROR) {
+		rval = -EINVAL;
+		goto exit_set_param;
+	}
+
+	iscsi_opts = le16_to_cpu(fw_ddb_entry->iscsi_options);
+	memset(fw_ddb_entry->iscsi_alias, 0, sizeof(fw_ddb_entry->iscsi_alias));
+
+	memset(fw_ddb_entry->iscsi_name, 0, sizeof(fw_ddb_entry->iscsi_name));
+
+	if (sess->targetname != NULL) {
+		memcpy(fw_ddb_entry->iscsi_name, sess->targetname,
+		       min(strlen(sess->targetname),
+		       sizeof(fw_ddb_entry->iscsi_name)));
+	}
+
+	memset(fw_ddb_entry->ip_addr, 0, sizeof(fw_ddb_entry->ip_addr));
+	memset(fw_ddb_entry->tgt_addr, 0, sizeof(fw_ddb_entry->tgt_addr));
+
+	fw_ddb_entry->options =  DDB_OPT_TARGET | DDB_OPT_AUTO_SENDTGTS_DISABLE;
+
+	if (dst_addr->sa_family == AF_INET) {
+		addr = (struct sockaddr_in *)dst_addr;
+		ip = (char *)&addr->sin_addr;
+		memcpy(fw_ddb_entry->ip_addr, ip, IP_ADDR_LEN);
+		fw_ddb_entry->port = cpu_to_le16(ntohs(addr->sin_port));
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "%s: Destination Address [%pI4]: index [%d]\n",
+				   __func__, fw_ddb_entry->ip_addr,
+				  ddb_entry->fw_ddb_index));
+	} else if (dst_addr->sa_family == AF_INET6) {
+		addr6 = (struct sockaddr_in6 *)dst_addr;
+		ip = (char *)&addr6->sin6_addr;
+		memcpy(fw_ddb_entry->ip_addr, ip, IPv6_ADDR_LEN);
+		fw_ddb_entry->port = cpu_to_le16(ntohs(addr6->sin6_port));
+		fw_ddb_entry->options |= DDB_OPT_IPV6_DEVICE;
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "%s: Destination Address [%pI6]: index [%d]\n",
+				   __func__, fw_ddb_entry->ip_addr,
+				  ddb_entry->fw_ddb_index));
+	} else {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Failed to get IP Address\n",
+			   __func__);
+		rval = -EINVAL;
+		goto exit_set_param;
+	}
+
+	if (is_qla8022(ha))
+		max_chap_entries = MAX_CHAP_ENTRIES_82XX;
+	else
+		max_chap_entries = MAX_CHAP_ENTRIES_40XX;
+	/* CHAP */
+	if (sess->username != NULL && sess->password != NULL) {
+		if (strlen(sess->username) && strlen(sess->password)) {
+			iscsi_opts |= BIT_7;
+			idx = ddb_entry->fw_ddb_index * 2;
+			if (idx > max_chap_entries) {
+				ql4_printk(KERN_ERR, ha,
+					   "%s: Invalid ddb or chap index\n",
+					   __func__);
+				rval  = -EINVAL;
+				goto exit_set_param;
+			}
+
+			rval = qla4xxx_set_chap(ha, sess->username,
+						sess->password, idx, 0);
+			if (rval)
+				goto exit_set_param;
+
+			fw_ddb_entry->chap_tbl_idx = cpu_to_le16(idx);
+		}
+	}
+
+	if (sess->username_in != NULL && sess->password_in != NULL) {
+		/* Check if BIDI CHAP */
+		if (strlen(sess->username_in) && strlen(sess->password_in)) {
+			iscsi_opts |= BIT_4;
+			idx = (ddb_entry->fw_ddb_index * 2) + 1;
+			if (idx > max_chap_entries) {
+				ql4_printk(KERN_ERR, ha,
+					   "%s: Invalid ddb or bidi chap "
+					   "index\n", __func__);
+				rval  = -EINVAL;
+				goto exit_set_param;
+			}
+			rval = qla4xxx_set_chap(ha, sess->username_in,
+						sess->password_in, idx, 0);
+			if (rval)
+				goto exit_set_param;
+		}
+	}
+
+	if (sess->initial_r2t_en)
+		iscsi_opts |= BIT_10;
+
+	if (sess->imm_data_en)
+		iscsi_opts |= BIT_11;
+
+	fw_ddb_entry->iscsi_options = cpu_to_le16(iscsi_opts);
+
+	if (conn->max_recv_dlength)
+		fw_ddb_entry->iscsi_max_rcv_data_seg_len =
+		    __constant_cpu_to_le16((conn->max_recv_dlength / 512));
+
+	if (sess->max_r2t)
+		fw_ddb_entry->iscsi_max_outsnd_r2t = cpu_to_le16(sess->max_r2t);
+
+	if (sess->first_burst)
+		fw_ddb_entry->iscsi_first_burst_len =
+			__constant_cpu_to_le16((sess->first_burst / 512));
+
+	if (sess->max_burst)
+		fw_ddb_entry->iscsi_max_burst_len =
+			__constant_cpu_to_le16((sess->max_burst / 512));
+
+	if (sess->time2wait)
+		fw_ddb_entry->iscsi_def_time2wait =
+			cpu_to_le16(sess->time2wait);
+
+	if (sess->time2retain)
+		fw_ddb_entry->iscsi_def_time2retain =
+			cpu_to_le16(sess->time2retain);
+
+	status = qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index,
+				       fw_ddb_entry_dma, mbx_sts);
+
+	if (status != QLA_SUCCESS)
+		rval = -EINVAL;
+exit_set_param:
+	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+			  fw_ddb_entry, fw_ddb_entry_dma);
+exit_set_param_no_free:
+	return rval;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6c8a53a..8c9eea2 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -63,6 +63,8 @@ MODULE_PARM_DESC(ql4xsess_recovery_tmo,
 		"Target Session Recovery Timeout.\n"
 		" Default: 30 sec.");
 
+
+static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha);
 /*
  * SCSI host template entry points
  */
@@ -76,20 +78,42 @@ static int qla4xxx_tgt_dscvr(struct Scsi_Host *shost,
 			     struct sockaddr *dst_addr);
 static int qla4xxx_conn_get_param(struct iscsi_cls_conn *conn,
 				  enum iscsi_param param, char *buf);
-static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
-				  enum iscsi_param param, char *buf);
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf);
 static int qla4xxx_set_net_config(struct Scsi_Host *shost, char *data,
 				  int count);
 static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 				   enum iscsi_net_param_type param, char *buf);
-static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
+static struct iscsi_endpoint *qla4xxx_ep_connect(struct Scsi_Host *shost,
+						 struct sockaddr *dst_addr,
+						 int non_blocking);
+static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
+static void qla4xxx_ep_disconnect(struct iscsi_endpoint *ep);
+static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
+				enum iscsi_param param, char *buf);
+static int qla4xxx_conn_start(struct iscsi_cls_conn *conn);
+static struct iscsi_cls_conn *
+qla4xxx_conn_create(struct iscsi_cls_session *cls_sess, uint32_t conn_idx);
+static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
+			     struct iscsi_cls_conn *cls_conn,
+			     uint64_t transport_fd, int is_leading);
+static void qla4xxx_conn_destroy(struct iscsi_cls_conn *conn);
+static struct iscsi_cls_session *
+qla4xxx_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
+			uint16_t qdepth, uint32_t initial_cmdsn);
+static void qla4xxx_session_destroy(struct iscsi_cls_session *sess);
+static void qla4xxx_task_work(struct work_struct *wdata);
+static int qla4xxx_alloc_pdu(struct iscsi_task *, uint8_t);
+static int qla4xxx_task_xmit(struct iscsi_task *);
+static void qla4xxx_task_cleanup(struct iscsi_task *);
+static void qla4xxx_fail_session(struct iscsi_cls_session *cls_session);
 static int qla4xxx_send_ping(struct Scsi_Host *shost, uint32_t iface_num,
 			     uint32_t iface_type, uint32_t payload_size,
 			     struct sockaddr *dst_addr);
-
+static void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
+					struct ddb_entry *ddb_entry,
+					struct dev_db_entry *fw_ddb_entrya);
 /*
  * SCSI host template entry points
  */
@@ -122,9 +146,6 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.slave_alloc		= qla4xxx_slave_alloc,
 	.slave_destroy		= qla4xxx_slave_destroy,
 
-	.scan_finished		= iscsi_scan_finished,
-	.scan_start		= qla4xxx_scan_start,
-
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -136,11 +157,15 @@ static struct scsi_host_template qla4xxx_driver_template = {
 static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.owner			= THIS_MODULE,
 	.name			= DRIVER_NAME,
-	.caps			= CAP_FW_DB | CAP_SENDTARGETS_OFFLOAD |
-				  CAP_DATA_PATH_OFFLOAD,
+	.caps			= CAP_TEXT_NEGO |
+				  CAP_DATA_PATH_OFFLOAD | CAP_HDRDGST |
+				  CAP_DATADGST | CAP_LOGIN_OFFLOAD |
+				  CAP_MULTI_R2T,
 	.param_mask		= ISCSI_CONN_PORT | ISCSI_CONN_ADDRESS |
 				  ISCSI_TARGET_NAME | ISCSI_TPGT |
-				  ISCSI_TARGET_ALIAS,
+				  ISCSI_MAX_BURST | ISCSI_MAX_R2T |
+				  ISCSI_FIRST_BURST | ISCSI_MAX_RECV_DLENGTH |
+				  ISCSI_MAX_XMIT_DLENGTH | ISCSI_TARGET_ALIAS,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
@@ -162,17 +187,135 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 				  ISCSI_NET_VLAN_PRIORITY |
 				  ISCSI_NET_VLAN_ENABLED,
 	.tgt_dscvr		= qla4xxx_tgt_dscvr,
+	.create_session         = qla4xxx_session_create,
+	.destroy_session        = qla4xxx_session_destroy,
+	.start_conn             = qla4xxx_conn_start,
+	.create_conn            = qla4xxx_conn_create,
+	.bind_conn              = qla4xxx_conn_bind,
+	.stop_conn              = iscsi_conn_stop,
+	.destroy_conn           = qla4xxx_conn_destroy,
+	.set_param              = iscsi_set_param,
 	.get_conn_param		= qla4xxx_conn_get_param,
-	.get_session_param	= qla4xxx_sess_get_param,
+	.get_session_param	= iscsi_session_get_param,
 	.get_host_param		= qla4xxx_host_get_param,
 	.set_net_config		= qla4xxx_set_net_config,
-	.session_recovery_timedout = qla4xxx_recovery_timedout,
 	.get_iface_param	= qla4xxx_get_iface_param,
 	.send_ping		= qla4xxx_send_ping,
+	.get_ep_param           = qla4xxx_get_ep_param,
+	.ep_connect		= qla4xxx_ep_connect,
+	.ep_poll		= qla4xxx_ep_poll,
+	.ep_disconnect		= qla4xxx_ep_disconnect,
+	.send_pdu		= iscsi_conn_send_pdu,
+	.xmit_task		= qla4xxx_task_xmit,
+	.cleanup_task		= qla4xxx_task_cleanup,
+	.alloc_pdu		= qla4xxx_alloc_pdu,
 };
 
 static struct scsi_transport_template *qla4xxx_scsi_transport;
 
+static struct iscsi_endpoint *
+qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
+		   int non_blocking)
+{
+	int ret;
+	struct iscsi_endpoint *ep;
+	struct qla_endpoint *qla_ep;
+	struct scsi_qla_host *ha;
+	struct sockaddr_in *addr;
+	struct sockaddr_in6 *addr6;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	if (!shost) {
+		ret = -ENXIO;
+		printk(KERN_ERR "%s: shost is NULL\n",
+		       __func__);
+		return ERR_PTR(ret);
+	}
+
+	ha = iscsi_host_priv(shost);
+	if (qla4xxx_wait_for_hba_online(ha) == QLA_ERROR) {
+		ret = -EBUSY;
+		if (!test_bit(AF_ONLINE, &ha->flags))
+			ql4_printk(KERN_WARNING, ha,
+				   "%s: adapter not online\n", __func__);
+		else if (!test_bit(AF_LINK_UP, &ha->flags))
+			ql4_printk(KERN_WARNING, ha,
+				   "%s: adapter link not up\n", __func__);
+		return ERR_PTR(ret);
+	}
+
+	ep = iscsi_create_endpoint(sizeof(struct qla_endpoint));
+	if (!ep) {
+		ret = -ENOMEM;
+		return ERR_PTR(ret);
+	}
+
+	qla_ep = (struct qla_endpoint *)ep->dd_data;
+	memset(qla_ep, 0, sizeof(struct qla_endpoint));
+	if (dst_addr->sa_family == AF_INET) {
+		memcpy(&qla_ep->dst_addr, dst_addr, sizeof(struct sockaddr_in));
+		addr = (struct sockaddr_in *)&qla_ep->dst_addr;
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI4\n", __func__,
+				  (char *)&addr->sin_addr));
+	} else if (dst_addr->sa_family == AF_INET6) {
+		memcpy(&qla_ep->dst_addr, dst_addr,
+		       sizeof(struct sockaddr_in6));
+		addr6 = (struct sockaddr_in6 *)&qla_ep->dst_addr;
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI6\n", __func__,
+				  (char *)&addr6->sin6_addr));
+	}
+
+	qla_ep->host = shost;
+
+	return ep;
+}
+
+/**
+ * qla4xxx_ep_poll
+ * @ep: endpoint to be used
+ * @timeout_ms: timeout specified in millisecs
+ *
+ * Nothing to be done for qla4xxx, connection open and
+ * login will happen in start_conn.
+ */
+static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
+{
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	return 1;
+}
+
+static void qla4xxx_ep_disconnect(struct iscsi_endpoint *ep)
+{
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	iscsi_destroy_endpoint(ep);
+}
+
+static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
+				enum iscsi_param param,
+				char *buf)
+{
+	struct qla_endpoint *qla_ep = ep->dd_data;
+	struct sockaddr *dst_addr;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+
+	switch (param) {
+	case ISCSI_PARAM_CONN_PORT:
+	case ISCSI_PARAM_CONN_ADDRESS:
+		if (!qla_ep)
+			return -ENOTCONN;
+
+		dst_addr = (struct sockaddr *)&qla_ep->dst_addr;
+		if (!dst_addr)
+			return -ENOTCONN;
+
+		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
+						 &qla_ep->dst_addr, param, buf);
+	default:
+		return -ENOSYS;
+	}
+}
+
 static int qla4xxx_send_ping(struct Scsi_Host *shost, uint32_t iface_num,
 			     uint32_t iface_type, uint32_t payload_size,
 			     struct sockaddr *dst_addr)
@@ -353,31 +496,19 @@ static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *session;
-	struct ddb_entry *ddb_entry;
+	struct iscsi_session *sess;
+	unsigned long flags;
+	enum blk_eh_timer_return ret = BLK_EH_NOT_HANDLED;
 
 	session = starget_to_session(scsi_target(sc->device));
-	ddb_entry = session->dd_data;
+	sess = session->dd_data;
 
-	/* if we are not logged in then the LLD is going to clean up the cmd */
-	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)
-		return BLK_EH_RESET_TIMER;
-	else
-		return BLK_EH_NOT_HANDLED;
-}
+	spin_lock_irqsave(&session->lock, flags);
+	if (session->state == ISCSI_SESSION_FAILED)
+		ret = BLK_EH_RESET_TIMER;
+	spin_unlock_irqrestore(&session->lock, flags);
 
-static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
-{
-	struct ddb_entry *ddb_entry = session->dd_data;
-	struct scsi_qla_host *ha = ddb_entry->ha;
-
-	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
-		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
-
-		DEBUG2(printk("scsi%ld: %s: ddb [%d] session recovery timeout "
-			      "of (%d) secs exhausted, marking device DEAD.\n",
-			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
-			      ddb_entry->sess->recovery_tmo));
-	}
+	return ret;
 }
 
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
@@ -716,54 +847,45 @@ exit_init_fw_cb:
 	return rval;
 }
 
-static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
-				  enum iscsi_param param, char *buf)
-{
-	struct ddb_entry *ddb_entry = sess->dd_data;
-	int len;
-
-	switch (param) {
-	case ISCSI_PARAM_TARGET_NAME:
-		len = snprintf(buf, PAGE_SIZE - 1, "%s\n",
-			       ddb_entry->iscsi_name);
-		break;
-	case ISCSI_PARAM_TPGT:
-		len = sprintf(buf, "%u\n", ddb_entry->tpgt);
-		break;
-	case ISCSI_PARAM_TARGET_ALIAS:
-		len = snprintf(buf, PAGE_SIZE - 1, "%s\n",
-		    ddb_entry->iscsi_alias);
-		break;
-	default:
-		return -ENOSYS;
-	}
-
-	return len;
-}
-
-static int qla4xxx_conn_get_param(struct iscsi_cls_conn *conn,
+static int qla4xxx_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				  enum iscsi_param param, char *buf)
 {
-	struct iscsi_cls_session *session;
-	struct ddb_entry *ddb_entry;
-	int len;
+	struct iscsi_conn *conn;
+	struct qla_conn *qla_conn;
+	struct sockaddr *dst_addr;
+	struct sockaddr_in *addr;
+	struct sockaddr_in6 *addr6;
+	int len = 0;
 
-	session = iscsi_dev_to_session(conn->dev.parent);
-	ddb_entry = session->dd_data;
+	conn = cls_conn->dd_data;
+	qla_conn = conn->dd_data;
+	dst_addr = &qla_conn->qla_ep->dst_addr;
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
-		len = sprintf(buf, "%hu\n", ddb_entry->port);
+		if (dst_addr->sa_family == AF_INET) {
+			addr = (struct sockaddr_in *)dst_addr;
+			len = sprintf(buf, "%hu\n", ntohs(addr->sin_port));
+		} else if (dst_addr->sa_family == AF_INET6) {
+			addr6 = (struct sockaddr_in6 *)dst_addr;
+			len = sprintf(buf, "%hu\n", ntohs(addr6->sin6_port));
+		}
 		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
-		/* TODO: what are the ipv6 bits */
-		len = sprintf(buf, "%pI4\n", &ddb_entry->ip_addr);
+		if (dst_addr->sa_family == AF_INET) {
+			addr = (struct sockaddr_in *)dst_addr;
+			len = sprintf(buf, "%pI4\n", &addr->sin_addr);
+		} else if (dst_addr->sa_family == AF_INET6) {
+			addr6 = (struct sockaddr_in6 *)dst_addr;
+			len = sprintf(buf, "%pI6\n", &addr6->sin6_addr);
+		}
 		break;
 	default:
-		return -ENOSYS;
+		return iscsi_conn_get_param(cls_conn, param, buf);
 	}
 
 	return len;
+
 }
 
 static int qla4xxx_tgt_dscvr(struct Scsi_Host *shost,
@@ -775,7 +897,7 @@ static int qla4xxx_tgt_dscvr(struct Scsi_Host *shost,
 	struct sockaddr_in6 *addr6;
 	int ret = 0;
 
-	ha = (struct scsi_qla_host *) shost->hostdata;
+	ha = (struct scsi_qla_host *) to_qla_host(shost);
 
 	switch (type) {
 	case ISCSI_TGT_DSCVR_SEND_TARGETS:
@@ -854,9 +976,419 @@ struct ddb_entry *qla4xxx_alloc_sess(struct scsi_qla_host *ha)
 	return ddb_entry;
 }
 
+static struct iscsi_cls_session *
+qla4xxx_session_create(struct iscsi_endpoint *ep,
+			uint16_t cmds_max, uint16_t qdepth,
+			uint32_t initial_cmdsn)
+{
+	struct iscsi_cls_session *cls_sess;
+	struct scsi_qla_host *ha;
+	struct qla_endpoint *qla_ep;
+	struct ddb_entry *ddb_entry;
+	uint32_t ddb_index;
+	uint32_t mbx_sts = 0;
+	struct iscsi_session *sess;
+	struct sockaddr *dst_addr;
+	int ret;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	if (!ep) {
+		printk(KERN_ERR "qla4xxx: missing ep.\n");
+		return NULL;
+	}
+
+	qla_ep = (struct qla_endpoint *)ep->dd_data;
+	dst_addr = (struct sockaddr *)&qla_ep->dst_addr;
+	ha = to_qla_host(qla_ep->host);
+get_ddb_index:
+	ddb_index = find_first_zero_bit(ha->ddb_idx_map, MAX_DDB_ENTRIES);
+
+	if (ddb_index >= MAX_DDB_ENTRIES) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "Free DDB index not available\n"));
+		return NULL;
+	}
+
+	if (test_and_set_bit(ddb_index, ha->ddb_idx_map))
+		goto get_ddb_index;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "Found a free DDB index at %d\n", ddb_index));
+	ret = qla4xxx_req_ddb_entry(ha, ddb_index, &mbx_sts);
+	if (ret == QLA_ERROR) {
+		if (mbx_sts == MBOX_STS_COMMAND_ERROR) {
+			ql4_printk(KERN_INFO, ha,
+				   "DDB index = %d not available trying next\n",
+				   ddb_index);
+			goto get_ddb_index;
+		}
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "Free FW DDB not available\n"));
+		return NULL;
+	}
+
+	cls_sess = iscsi_session_setup(&qla4xxx_iscsi_transport, qla_ep->host,
+				       cmds_max, sizeof(struct ddb_entry),
+				       sizeof(struct ql4_task_data),
+				       initial_cmdsn, ddb_index);
+	if (!cls_sess)
+		return NULL;
+
+	sess = (struct iscsi_session *)cls_sess->dd_data;
+	ddb_entry = (struct ddb_entry *)sess->dd_data;
+	ddb_entry->fw_ddb_index = ddb_index;
+	ddb_entry->fw_ddb_device_state = DDB_DS_NO_CONNECTION_ACTIVE;
+	ddb_entry->ha = ha;
+	ddb_entry->sess = cls_sess;
+	cls_sess->recovery_tmo = ql4xsess_recovery_tmo;
+	init_completion(&ddb_entry->aen_comp);
+	ha->fw_ddb_index_map[ddb_entry->fw_ddb_index] = ddb_entry;
+	ha->tot_ddbs++;
+
+	return cls_sess;
+}
+
+static void qla4xxx_session_destroy(struct iscsi_cls_session *cls_sess)
+{
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	unsigned long flags;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	sess = cls_sess->dd_data;
+	ddb_entry = (struct ddb_entry *)sess->dd_data;
+	ha = ddb_entry->ha;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	qla4xxx_free_ddb(ha, ddb_entry);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	iscsi_session_teardown(cls_sess);
+}
+
+static struct iscsi_cls_conn *
+qla4xxx_conn_create(struct iscsi_cls_session *cls_sess, uint32_t conn_idx)
+{
+	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	cls_conn = iscsi_conn_setup(cls_sess, sizeof(struct qla_conn),
+				    conn_idx);
+	sess = (struct iscsi_session *)cls_sess->dd_data;
+	ddb_entry = (struct ddb_entry *)sess->dd_data;
+	ddb_entry->conn = cls_conn;
+
+	return cls_conn;
+}
+
+static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
+			     struct iscsi_cls_conn *cls_conn,
+			     uint64_t transport_fd, int is_leading)
+{
+	struct iscsi_conn *conn;
+	struct qla_conn *qla_conn;
+	struct iscsi_endpoint *ep;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
+		return -EINVAL;
+	ep = iscsi_lookup_endpoint(transport_fd);
+	conn = cls_conn->dd_data;
+	qla_conn = conn->dd_data;
+	qla_conn->qla_ep = ep->dd_data;
+
+	return 0;
+}
+
+static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
+{
+	struct iscsi_cls_session *cls_sess = iscsi_conn_to_session(cls_conn);
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	struct dev_db_entry *fw_ddb_entry;
+	dma_addr_t fw_ddb_entry_dma;
+	uint32_t fw_ddb_device_state;
+	uint32_t mbx_sts = 0;
+	int ret = 0;
+	int status = QLA_SUCCESS;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	sess = cls_sess->dd_data;
+	ddb_entry = sess->dd_data;
+	ha = ddb_entry->ha;
+
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Unable to allocate dma buffer\n", __func__);
+		return -ENOMEM;
+	}
+
+	ret = qla4xxx_set_param_ddbentry(ha, ddb_entry, cls_conn, &mbx_sts);
+	if (ret) {
+		/* If iscsid is stopped and started then no need to do
+		 * set param again since ddb state will be already
+		 * active and FW does not allow set ddb to an
+		 * active session.
+		 */
+		if (mbx_sts)
+			if (ddb_entry->fw_ddb_device_state ==
+					DDB_DS_SESSION_ACTIVE)
+				goto get_state;
+
+		ql4_printk(KERN_ERR, ha, "%s: Failed set param for index[%d]\n",
+			   __func__, ddb_entry->fw_ddb_index);
+		goto exit_conn_start;
+	}
+
+	init_completion(&ddb_entry->aen_comp);
+	status = qla4xxx_conn_open(ha, ddb_entry->fw_ddb_index);
+	if (status == QLA_ERROR) {
+		ql4_printk(KERN_ERR, ha, "%s: Login failed: %s %s:%d\n",
+			   __func__, ddb_entry->iscsi_name,
+			   ddb_entry->ip_addr, ddb_entry->port);
+		ret = -EINVAL;
+		goto exit_conn_start;
+	}
+
+wait_for_aen:
+	/* Wait till DDB state changes to discovery or active state. */
+	wait_for_completion_timeout(&ddb_entry->aen_comp,
+				    AEN_WAIT_TOV * HZ);
+get_state:
+	status = qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index,
+					 fw_ddb_entry, fw_ddb_entry_dma, NULL,
+					 NULL, &fw_ddb_device_state, NULL,
+					 NULL, NULL);
+	if (status == QLA_ERROR) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: failed get ddb entry for "
+			   "fw_ddb_index %d state %d\n", __func__,
+			   ddb_entry->fw_ddb_index, fw_ddb_device_state);
+		ret = -EINVAL;
+		goto exit_conn_start;
+	}
+
+	ddb_entry->fw_ddb_device_state = fw_ddb_device_state;
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Device state is [%d]\n",
+			  __func__, fw_ddb_device_state));
+	switch (fw_ddb_device_state) {
+	case DDB_DS_DISCOVERY:
+		ret = 0;
+	break;
+	case DDB_DS_SESSION_ACTIVE:
+		iscsi_conn_start(cls_conn);
+		qla4xxx_update_session_conn_param(ha, ddb_entry, fw_ddb_entry);
+
+		/* Inform userspace of session creation, also triggers
+		 * LUN discovery
+		 */
+		iscsi_session_event(ddb_entry->sess,
+				    ISCSI_KEVENT_CREATE_SESSION);
+		ret = 0;
+	break;
+	case DDB_DS_LOGIN_IN_PROCESS:
+		goto wait_for_aen;
+	default:
+		ret = -EAGAIN;
+	}
+
+exit_conn_start:
+	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+			  fw_ddb_entry, fw_ddb_entry_dma);
+	return ret;
+}
+
+static void qla4xxx_conn_destroy(struct iscsi_cls_conn *cls_conn)
+{
+	struct iscsi_cls_session *cls_sess = iscsi_conn_to_session(cls_conn);
+	struct iscsi_session *sess;
+	struct scsi_qla_host *ha;
+	struct ddb_entry *ddb_entry;
+	int options;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	sess = cls_sess->dd_data;
+	ddb_entry = sess->dd_data;
+	ha = ddb_entry->ha;
+
+	init_completion(&ddb_entry->aen_comp);
+	options = LOGOUT_OPTION_CLOSE_SESSION;
+	if (qla4xxx_session_logout_ddb(ha, ddb_entry, options) == QLA_ERROR)
+		ql4_printk(KERN_ERR, ha, "%s: Logout failed\n", __func__);
+	else {
+		wait_for_completion_timeout(&ddb_entry->aen_comp,
+					    AEN_WAIT_TOV * HZ);
+		qla4xxx_clear_ddb_entry(ha, ddb_entry->fw_ddb_index);
+	}
+
+	/* Clear the DDB bit so that next login can use the bit
+	 * if FW is not clearing the DDB entry then set DDB will fail anyways
+	 */
+	clear_bit(ddb_entry->fw_ddb_index, ha->ddb_idx_map);
+}
+
+static void qla4xxx_task_work(struct work_struct *wdata)
+{
+	struct ql4_task_data *task_data;
+	struct scsi_qla_host *ha;
+	struct passthru_status *sts;
+	struct iscsi_task *task;
+	struct iscsi_hdr *hdr;
+	uint8_t *data;
+	uint32_t data_len;
+	struct iscsi_conn *conn;
+	int hdr_len;
+	itt_t itt;
+
+	task_data = container_of(wdata, struct ql4_task_data, task_work);
+	ha = task_data->ha;
+	task = task_data->task;
+	sts = &task_data->sts;
+	hdr_len = sizeof(struct iscsi_hdr);
+
+	DEBUG2(printk(KERN_INFO "Status returned\n"));
+	DEBUG2(qla4xxx_dump_buffer(sts, 64));
+	DEBUG2(printk(KERN_INFO "Response buffer"));
+	DEBUG2(qla4xxx_dump_buffer(task_data->resp_buffer, 64));
+
+	conn = task->conn;
+
+	switch (sts->completionStatus) {
+	case PASSTHRU_STATUS_COMPLETE:
+		hdr = (struct iscsi_hdr *)task_data->resp_buffer;
+		/* Assign back the itt in hdr, until we use the PREASSIGN_TAG */
+		itt = sts->handle;
+		hdr->itt = itt;
+		data = task_data->resp_buffer + hdr_len;
+		data_len = task_data->resp_len - hdr_len;
+		iscsi_complete_pdu(conn, hdr, data, data_len);
+		break;
+	default:
+		ql4_printk(KERN_ERR, ha, "Passthru failed status = 0x%x\n",
+			   sts->completionStatus);
+		break;
+	}
+	return;
+}
+
+static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
+{
+	struct ql4_task_data *task_data;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	int hdr_len;
+
+	sess = task->conn->session;
+	ddb_entry = (struct ddb_entry *)sess->dd_data;
+	ha = ddb_entry->ha;
+	task_data = (struct ql4_task_data *)task->dd_data;
+	memset(task_data, 0, sizeof(struct ql4_task_data));
+
+	if (task->sc) {
+		ql4_printk(KERN_INFO, ha,
+			   "%s: SCSI Commands not implemented\n", __func__);
+		return -EINVAL;
+	}
+
+	hdr_len = sizeof(struct iscsi_hdr);
+	task_data->ha = ha;
+	task_data->task = task;
+
+	if (task->data_count) {
+		task_data->data_dma = dma_map_single(&ha->pdev->dev, task->data,
+						     task->data_count,
+						     PCI_DMA_TODEVICE);
+	}
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
+		      __func__, task->conn->max_recv_dlength, hdr_len));
+
+	task_data->resp_len = task->conn->max_recv_dlength;
+	task_data->resp_buffer = dma_alloc_coherent(&ha->pdev->dev,
+						    task_data->resp_len,
+						    &task_data->resp_dma,
+						    GFP_ATOMIC);
+	if (!task_data->resp_buffer)
+		goto exit_alloc_pdu;
+
+	task_data->req_buffer = dma_alloc_coherent(&ha->pdev->dev,
+						   task->data_count + hdr_len,
+						   &task_data->req_dma,
+						   GFP_ATOMIC);
+	if (!task_data->req_buffer)
+		goto exit_alloc_pdu;
+
+	task->hdr = task_data->req_buffer;
+
+	INIT_WORK(&task_data->task_work, qla4xxx_task_work);
+
+	return 0;
+
+exit_alloc_pdu:
+	if (task_data->resp_buffer)
+		dma_free_coherent(&ha->pdev->dev, task_data->resp_len,
+				  task_data->resp_buffer, task_data->resp_dma);
+
+	if (task_data->req_buffer)
+		dma_free_coherent(&ha->pdev->dev, task->data_count + hdr_len,
+				  task_data->req_buffer, task_data->req_dma);
+	return -ENOMEM;
+}
+
+static void qla4xxx_task_cleanup(struct iscsi_task *task)
+{
+	struct ql4_task_data *task_data;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	int hdr_len;
+
+	hdr_len = sizeof(struct iscsi_hdr);
+	sess = task->conn->session;
+	ddb_entry = (struct ddb_entry *)sess->dd_data;
+	ha = ddb_entry->ha;
+	task_data = (struct ql4_task_data *)task->dd_data;
+
+	if (task->data_count) {
+		dma_unmap_single(&ha->pdev->dev, task_data->data_dma,
+				 task->data_count, PCI_DMA_TODEVICE);
+	}
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
+		      __func__, task->conn->max_recv_dlength, hdr_len));
+
+	dma_free_coherent(&ha->pdev->dev, task_data->resp_len,
+			  task_data->resp_buffer, task_data->resp_dma);
+	dma_free_coherent(&ha->pdev->dev, task->data_count + hdr_len,
+			  task_data->req_buffer, task_data->req_dma);
+	return;
+}
+
+static int qla4xxx_task_xmit(struct iscsi_task *task)
+{
+	struct scsi_cmnd *sc = task->sc;
+	struct iscsi_session *sess = task->conn->session;
+	struct ddb_entry *ddb_entry = (struct ddb_entry *)sess->dd_data;
+	struct scsi_qla_host *ha = ddb_entry->ha;
+
+	if (!sc)
+		return qla4xxx_send_passthru0(task);
+
+	ql4_printk(KERN_INFO, ha, "%s: scsi cmd xmit not implemented\n",
+		   __func__);
+	return -1;
+}
+
 static void qla4xxx_scan_start(struct Scsi_Host *shost)
 {
-	struct scsi_qla_host *ha = shost_priv(shost);
+	struct scsi_qla_host *ha = to_qla_host(shost);
 	struct ddb_entry *ddb_entry, *ddbtemp;
 
 	/* finish setup of sessions that were already setup in firmware */
@@ -866,6 +1398,50 @@ static void qla4xxx_scan_start(struct Scsi_Host *shost)
 	}
 }
 
+static void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
+					     struct ddb_entry *ddb_entry,
+					     struct dev_db_entry *fw_ddb_entry)
+{
+	struct iscsi_cls_session *cls_sess;
+	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_session *sess;
+	struct iscsi_conn *conn;
+
+	cls_sess = ddb_entry->sess;
+	sess = cls_sess->dd_data;
+
+	cls_conn = ddb_entry->conn;
+	conn = cls_conn->dd_data;
+
+	/* Update params */
+	conn->max_recv_dlength = 512 *
+			  le16_to_cpu(fw_ddb_entry->iscsi_max_rcv_data_seg_len);
+
+	conn->max_xmit_dlength = 512 *
+			  le16_to_cpu(fw_ddb_entry->iscsi_max_snd_data_seg_len);
+
+	sess->initial_r2t_en =
+			    (BIT_10 & le16_to_cpu(fw_ddb_entry->iscsi_options));
+
+	sess->max_r2t = le16_to_cpu(fw_ddb_entry->iscsi_max_outsnd_r2t);
+
+	sess->imm_data_en = (BIT_11 & le16_to_cpu(fw_ddb_entry->iscsi_options));
+
+	sess->first_burst = 512 *
+			       le16_to_cpu(fw_ddb_entry->iscsi_first_burst_len);
+
+	sess->max_burst = 512 * le16_to_cpu(fw_ddb_entry->iscsi_max_burst_len);
+
+	sess->time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
+
+	sess->time2retain = le16_to_cpu(fw_ddb_entry->iscsi_def_time2retain);
+
+	sess->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+
+	memcpy(sess->initiatorname, ha->name_string,
+	       min(sizeof(ha->name_string), sizeof(sess->initiatorname)));
+}
+
 /*
  * Timer routines
  */
@@ -890,25 +1466,15 @@ static void qla4xxx_stop_timer(struct scsi_qla_host *ha)
 }
 
 /***
- * qla4xxx_mark_device_missing - mark a device as missing.
- * @ha: Pointer to host adapter structure.
+ * qla4xxx_mark_device_missing - blocks the session
+ * @cls_session: Pointer to the session to be blocked
  * @ddb_entry: Pointer to device database entry
  *
  * This routine marks a device missing and close connection.
  **/
-void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
-				 struct ddb_entry *ddb_entry)
+void qla4xxx_mark_device_missing(struct iscsi_cls_session *cls_session)
 {
-	if ((atomic_read(&ddb_entry->state) != DDB_STATE_DEAD)) {
-		atomic_set(&ddb_entry->state, DDB_STATE_MISSING);
-		DEBUG2(printk("scsi%ld: ddb [%d] marked MISSING\n",
-		    ha->host_no, ddb_entry->fw_ddb_index));
-	} else
-		DEBUG2(printk("scsi%ld: ddb [%d] DEAD\n", ha->host_no,
-		    ddb_entry->fw_ddb_index))
-
-	iscsi_block_session(ddb_entry->sess);
-	iscsi_conn_error_event(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
+	iscsi_block_session(cls_session);
 }
 
 /**
@@ -919,10 +1485,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
  **/
 void qla4xxx_mark_all_devices_missing(struct scsi_qla_host *ha)
 {
-	struct ddb_entry *ddb_entry, *ddbtemp;
-	list_for_each_entry_safe(ddb_entry, ddbtemp, &ha->ddb_list, list) {
-		qla4xxx_mark_device_missing(ha, ddb_entry);
-	}
+	iscsi_host_for_each_session(ha->host, qla4xxx_mark_device_missing);
 }
 
 static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
@@ -1013,20 +1576,13 @@ static int qla4xxx_queuecommand_lck(struct scsi_cmnd *cmd,
 		goto qc_fail_command;
 	}
 
-	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
-		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
-			cmd->result = DID_NO_CONNECT << 16;
-			goto qc_fail_command;
-		}
-		return SCSI_MLQUEUE_TARGET_BUSY;
-	}
-
 	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
 	    test_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags) ||
 	    test_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags) ||
 	    !test_bit(AF_ONLINE, &ha->flags) ||
+	    !test_bit(AF_LINK_UP, &ha->flags) ||
 	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
 		goto qc_host_busy;
 
@@ -1089,6 +1645,9 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 
 	ha->srb_mempool = NULL;
 
+	if (ha->chap_dma_pool)
+		dma_pool_destroy(ha->chap_dma_pool);
+
 	/* release io space registers  */
 	if (is_qla8022(ha)) {
 		if (ha->nx_pcibase)
@@ -1162,10 +1721,18 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 		goto mem_alloc_error_exit;
 	}
 
+	ha->chap_dma_pool = dma_pool_create("ql4_chap", &ha->pdev->dev,
+					    CHAP_DMA_BLOCK_SIZE, 8, 0);
+
+	if (ha->chap_dma_pool == NULL) {
+		ql4_printk(KERN_WARNING, ha,
+		    "%s: chap_dma_pool allocation failed..\n", __func__);
+		goto mem_alloc_error_exit;
+	}
+
 	return QLA_SUCCESS;
 
 mem_alloc_error_exit:
-	qla4xxx_mem_free(ha);
 	return QLA_ERROR;
 }
 
@@ -1259,7 +1826,6 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
  **/
 static void qla4xxx_timer(struct scsi_qla_host *ha)
 {
-	struct ddb_entry *ddb_entry, *dtemp;
 	int start_dpc = 0;
 	uint16_t w;
 
@@ -1279,69 +1845,6 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 		qla4_8xxx_watchdog(ha);
 	}
 
-	/* Search for relogin's to time-out and port down retry. */
-	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
-		/* Count down time between sending relogins */
-		if (adapter_up(ha) &&
-		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
-		    atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
-			if (atomic_read(&ddb_entry->retry_relogin_timer) !=
-			    INVALID_ENTRY) {
-				if (atomic_read(&ddb_entry->retry_relogin_timer)
-				    		== 0) {
-					atomic_set(&ddb_entry->
-						retry_relogin_timer,
-						INVALID_ENTRY);
-					set_bit(DPC_RELOGIN_DEVICE,
-						&ha->dpc_flags);
-					set_bit(DF_RELOGIN, &ddb_entry->flags);
-					DEBUG2(printk("scsi%ld: %s: ddb [%d]"
-						      " login device\n",
-						      ha->host_no, __func__,
-						      ddb_entry->fw_ddb_index));
-				} else
-					atomic_dec(&ddb_entry->
-							retry_relogin_timer);
-			}
-		}
-
-		/* Wait for relogin to timeout */
-		if (atomic_read(&ddb_entry->relogin_timer) &&
-		    (atomic_dec_and_test(&ddb_entry->relogin_timer) != 0)) {
-			/*
-			 * If the relogin times out and the device is
-			 * still NOT ONLINE then try and relogin again.
-			 */
-			if (atomic_read(&ddb_entry->state) !=
-			    DDB_STATE_ONLINE &&
-			    ddb_entry->fw_ddb_device_state ==
-			    DDB_DS_SESSION_FAILED) {
-				/* Reset retry relogin timer */
-				atomic_inc(&ddb_entry->relogin_retry_count);
-				DEBUG2(printk("scsi%ld: ddb [%d] relogin"
-					      " timed out-retrying"
-					      " relogin (%d)\n",
-					      ha->host_no,
-					      ddb_entry->fw_ddb_index,
-					      atomic_read(&ddb_entry->
-							  relogin_retry_count))
-					);
-				start_dpc++;
-				DEBUG(printk("scsi%ld:%d:%d: ddb [%d] "
-					     "initiate relogin after"
-					     " %d seconds\n",
-					     ha->host_no, ddb_entry->bus,
-					     ddb_entry->target,
-					     ddb_entry->fw_ddb_index,
-					     ddb_entry->default_time2wait + 4)
-					);
-
-				atomic_set(&ddb_entry->retry_relogin_timer,
-					   ddb_entry->default_time2wait + 4);
-			}
-		}
-	}
-
 	if (!is_qla8022(ha)) {
 		/* Check for heartbeat interval. */
 		if (ha->firmware_options & FWOPT_HEARTBEAT_ENABLE &&
@@ -1589,6 +2092,17 @@ void qla4xxx_dead_adapter_cleanup(struct scsi_qla_host *ha)
 	clear_bit(AF_INIT_DONE, &ha->flags);
 }
 
+static void qla4xxx_fail_session(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+
+	sess = cls_session->dd_data;
+	ddb_entry = sess->dd_data;
+	ddb_entry->fw_ddb_device_state = DDB_DS_SESSION_FAILED;
+	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
+}
+
 /**
  * qla4xxx_recover_adapter - recovers adapter after a fatal error
  * @ha: Pointer to host adapter structure.
@@ -1601,11 +2115,14 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 	/* Stall incoming I/O until we are done */
 	scsi_block_requests(ha->host);
 	clear_bit(AF_ONLINE, &ha->flags);
+	clear_bit(AF_LINK_UP, &ha->flags);
 
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: adapter OFFLINE\n", __func__));
 
 	set_bit(DPC_RESET_ACTIVE, &ha->dpc_flags);
 
+	iscsi_host_for_each_session(ha->host, qla4xxx_fail_session);
+
 	if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
 		reset_chip = 1;
 
@@ -1733,27 +2250,34 @@ recover_ha_init_adapter:
 	return status;
 }
 
-static void qla4xxx_relogin_all_devices(struct scsi_qla_host *ha)
+static void qla4xxx_relogin_devices(struct iscsi_cls_session *cls_session)
 {
-	struct ddb_entry *ddb_entry, *dtemp;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
 
-	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
-		if ((atomic_read(&ddb_entry->state) == DDB_STATE_MISSING) ||
-		    (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD)) {
-			if (ddb_entry->fw_ddb_device_state ==
-			    DDB_DS_SESSION_ACTIVE) {
-				atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
-				ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
-				    " marked ONLINE\n",	ha->host_no, __func__,
-				    ddb_entry->fw_ddb_index);
-
-				iscsi_unblock_session(ddb_entry->sess);
-			} else
-				qla4xxx_relogin_device(ha, ddb_entry);
+	sess = cls_session->dd_data;
+	ddb_entry = sess->dd_data;
+	ha = ddb_entry->ha;
+	if (!qla4xxx_session_online(cls_session)) {
+		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
+			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
+				   " unblock session\n", ha->host_no, __func__,
+				   ddb_entry->fw_ddb_index);
+			iscsi_unblock_session(ddb_entry->sess);
+		} else {
+			/* Trigger relogin */
+			iscsi_session_failure(cls_session->dd_data,
+					      ISCSI_ERR_CONN_FAILED);
 		}
 	}
 }
 
+static void qla4xxx_relogin_all_devices(struct scsi_qla_host *ha)
+{
+	iscsi_host_for_each_session(ha->host, qla4xxx_relogin_devices);
+}
+
 void qla4xxx_wake_dpc(struct scsi_qla_host *ha)
 {
 	if (ha->dpc_thread &&
@@ -1778,7 +2302,6 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 {
 	struct scsi_qla_host *ha =
 		container_of(work, struct scsi_qla_host, dpc_work);
-	struct ddb_entry *ddb_entry, *dtemp;
 	int status = QLA_ERROR;
 
 	DEBUG2(printk("scsi%ld: %s: DPC handler waking up."
@@ -1822,8 +2345,9 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 			goto dpc_post_reset_ha;
 		}
 		if (test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags) ||
-		    test_bit(DPC_RESET_HA, &ha->dpc_flags))
+				test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
 			qla4xxx_recover_adapter(ha);
+		}
 
 		if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
 			uint8_t wait_time = RESET_INTR_TOV;
@@ -1875,30 +2399,6 @@ dpc_post_reset_ha:
 		}
 	}
 
-	/* ---- relogin device? --- */
-	if (adapter_up(ha) &&
-	    test_and_clear_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags)) {
-		list_for_each_entry_safe(ddb_entry, dtemp,
-					 &ha->ddb_list, list) {
-			if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags) &&
-			    atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)
-				qla4xxx_relogin_device(ha, ddb_entry);
-
-			/*
-			 * If mbx cmd times out there is no point
-			 * in continuing further.
-			 * With large no of targets this can hang
-			 * the system.
-			 */
-			if (test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
-				printk(KERN_WARNING "scsi%ld: %s: "
-				       "need to reset hba\n",
-				       ha->host_no, __func__);
-				break;
-			}
-		}
-	}
-
 do_dpc_exit:
 	clear_bit(AF_DPC_SCHEDULED, &ha->flags);
 }
@@ -1923,6 +2423,10 @@ static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
 	if (ha->dpc_thread)
 		destroy_workqueue(ha->dpc_thread);
 
+	/* Kill the kernel thread for this host */
+	if (ha->task_wq)
+		destroy_workqueue(ha->task_wq);
+
 	/* Put firmware in known state */
 	ha->isp_ops->reset_firmware(ha);
 
@@ -2165,7 +2669,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	if (pci_enable_device(pdev))
 		return -1;
 
-	host = scsi_host_alloc(&qla4xxx_driver_template, sizeof(*ha));
+	host = iscsi_host_alloc(&qla4xxx_driver_template, sizeof(*ha), 0);
 	if (host == NULL) {
 		printk(KERN_WARNING
 		       "qla4xxx: Couldn't allocate host from scsi layer!\n");
@@ -2173,7 +2677,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	}
 
 	/* Clear our data area */
-	ha = (struct scsi_qla_host *) host->hostdata;
+	ha = to_qla_host(host);
 	memset(ha, 0, sizeof(*ha));
 
 	/* Save the information from PCI BIOS.	*/
@@ -2233,9 +2737,32 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 		goto probe_failed;
 	}
 
+	host->cmd_per_lun = 3;
+	host->max_channel = 0;
+	host->max_lun = MAX_LUNS - 1;
+	host->max_id = MAX_TARGETS;
+	host->max_cmd_len = IOCB_MAX_CDB_LEN;
+	host->can_queue = MAX_SRBS ;
+	host->transportt = qla4xxx_scsi_transport;
+
+	ret = scsi_init_shared_tag_map(host, MAX_SRBS);
+	if (ret) {
+		ql4_printk(KERN_WARNING, ha,
+			   "%s: scsi_init_shared_tag_map failed\n", __func__);
+		goto probe_failed;
+	}
+
+	pci_set_drvdata(pdev, ha);
+
+	ret = scsi_add_host(host, &pdev->dev);
+	if (ret)
+		goto probe_failed;
+
 	if (is_qla8022(ha))
 		(void) qla4_8xxx_get_flash_info(ha);
 
+	ha->task_wq = alloc_workqueue("qla4xxx_task_wq", WQ_MEM_RECLAIM, 1);
+
 	/*
 	 * Initialize the Host adapter request/response queues and
 	 * firmware
@@ -2277,24 +2804,9 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 			qla4_8xxx_idc_unlock(ha);
 		}
 		ret = -ENODEV;
-		goto probe_failed;
+		goto remove_host;
 	}
 
-	host->cmd_per_lun = 3;
-	host->max_channel = 0;
-	host->max_lun = MAX_LUNS - 1;
-	host->max_id = MAX_TARGETS;
-	host->max_cmd_len = IOCB_MAX_CDB_LEN;
-	host->can_queue = MAX_SRBS ;
-	host->transportt = qla4xxx_scsi_transport;
-
-        ret = scsi_init_shared_tag_map(host, MAX_SRBS);
-        if (ret) {
-		ql4_printk(KERN_WARNING, ha,
-		    "scsi_init_shared_tag_map failed\n");
-		goto probe_failed;
-        }
-
 	/* Startup the kernel thread for this host adapter. */
 	DEBUG2(printk("scsi: %s: Starting kernel thread for "
 		      "qla4xxx_dpc\n", __func__));
@@ -2303,7 +2815,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	if (!ha->dpc_thread) {
 		ql4_printk(KERN_WARNING, ha, "Unable to start DPC thread!\n");
 		ret = -ENODEV;
-		goto probe_failed;
+		goto remove_host;
 	}
 	INIT_WORK(&ha->dpc_work, qla4xxx_do_dpc);
 
@@ -2317,7 +2829,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 		if (ret) {
 			ql4_printk(KERN_WARNING, ha, "Failed to reserve "
 			    "interrupt %d already in use.\n", pdev->irq);
-			goto probe_failed;
+			goto remove_host;
 		}
 	}
 
@@ -2329,11 +2841,6 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 
 	set_bit(AF_INIT_DONE, &ha->flags);
 
-	pci_set_drvdata(pdev, ha);
-
-	ret = scsi_add_host(host, &pdev->dev);
-	if (ret)
-		goto probe_failed;
 
 	printk(KERN_INFO
 	       " QLogic iSCSI HBA Driver version: %s\n"
@@ -2341,11 +2848,13 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	       qla4xxx_version_str, ha->pdev->device, pci_name(ha->pdev),
 	       ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
 	       ha->patch_number, ha->build_number);
-	scsi_scan_host(host);
 
 	qla4xxx_create_iface(ha);
 	return 0;
 
+remove_host:
+	scsi_remove_host(ha->host);
+
 probe_failed:
 	qla4xxx_free_adapter(ha);
 
@@ -2453,10 +2962,15 @@ static void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha)
 
 static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 {
-	struct iscsi_cls_session *sess = starget_to_session(sdev->sdev_target);
-	struct ddb_entry *ddb = sess->dd_data;
+	struct iscsi_cls_session *cls_sess;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb;
 	int queue_depth = QL4_DEF_QDEPTH;
 
+	cls_sess = starget_to_session(sdev->sdev_target);
+	sess = cls_sess->dd_data;
+	ddb = sess->dd_data;
+
 	sdev->hostdata = ddb;
 	sdev->tagged_supported = 1;
 
@@ -2795,7 +3309,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	int return_status = FAILED;
 	struct scsi_qla_host *ha;
 
-	ha = (struct scsi_qla_host *) cmd->device->host->hostdata;
+	ha = to_qla_host(cmd->device->host);
 
 	if (ql4xdontresethba) {
 		DEBUG2(printk("scsi%ld: %s: Don't Reset HBA\n",
@@ -2831,6 +3345,18 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	return return_status;
 }
 
+int qla4xxx_session_online(struct iscsi_cls_session *session)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&session->lock, flags);
+	if (session->state == ISCSI_SESSION_LOGGED_IN)
+		ret = 1;
+	spin_unlock_irqrestore(&session->lock, flags);
+	return ret;
+}
+
 /* PCI AER driver recovers from all correctable errors w/o
  * driver intervention. For uncorrectable errors PCI AER
  * driver calls the following device driver's callbacks
@@ -2907,7 +3433,8 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 
 	if (test_bit(AF_ONLINE, &ha->flags)) {
 		clear_bit(AF_ONLINE, &ha->flags);
-		qla4xxx_mark_all_devices_missing(ha);
+		clear_bit(AF_LINK_UP, &ha->flags);
+		iscsi_host_for_each_session(ha->host, qla4xxx_fail_session);
 		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 	}
 
-- 
1.7.3.2

