From: michaelc@cs.wisc.edu
Subject: [PATCH 1/3] qla4xxx: fix flash/ddb support
Date: Thu,  1 Dec 2011 21:38:41 -0600
Message-ID: <1322797123-5299-2-git-send-email-michaelc@cs.wisc.edu>
References: <1322797123-5299-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab1LBDcN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 22:32:13 -0500
In-Reply-To: <1322797123-5299-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Manish Rangankar <manish.rangankar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Mike Christie <michaelc@cs.wisc.edu>

With open-iscsi support, target entries persisted in the FLASH were not
login. Added support in the qla4xxx driver to do the login on probe
time to the target entries saved in the FLASH by user.
With this changes upgrade to the new kernel with open-iscsi support in
qla4xxx will ensure users original target entries login on driver load

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_def.h     |   55 ++-
 drivers/scsi/qla4xxx/ql4_fw.h      |    8 +
 drivers/scsi/qla4xxx/ql4_glbl.h    |   16 +-
 drivers/scsi/qla4xxx/ql4_init.c    |  239 +++++++--
 drivers/scsi/qla4xxx/ql4_mbx.c     |   11 +
 drivers/scsi/qla4xxx/ql4_os.c      | 1081 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 7 files changed, 1315 insertions(+), 97 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index ace637b..fd5edc6 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -147,7 +147,7 @@
 #define ISCSI_ALIAS_SIZE		32	/* ISCSI Alias name size */
 #define ISCSI_NAME_SIZE			0xE0	/* ISCSI Name size */
 
-#define QL4_SESS_RECOVERY_TMO		30	/* iSCSI session */
+#define QL4_SESS_RECOVERY_TMO		120	/* iSCSI session */
 						/* recovery timeout */
 
 #define LSDW(x) ((u32)((u64)(x)))
@@ -173,6 +173,8 @@
 #define ISNS_DEREG_TOV			5
 #define HBA_ONLINE_TOV			30
 #define DISABLE_ACB_TOV			30
+#define IP_CONFIG_TOV			30
+#define LOGIN_TOV			12
 
 #define MAX_RESET_HA_RETRIES		2
 
@@ -240,6 +242,45 @@ struct ddb_entry {
 
 	uint16_t fw_ddb_index;	/* DDB firmware index */
 	uint32_t fw_ddb_device_state; /* F/W Device State  -- see ql4_fw.h */
+	uint16_t ddb_type;
+#define FLASH_DDB 0x01
+
+	struct dev_db_entry fw_ddb_entry;
+	int (*unblock_sess)(struct iscsi_cls_session *cls_session);
+	int (*ddb_change)(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
+			  struct ddb_entry *ddb_entry, uint32_t state);
+
+	/* Driver Re-login  */
+	unsigned long flags;		  /* DDB Flags */
+	uint16_t default_relogin_timeout; /*  Max time to wait for
+					   *  relogin to complete */
+	atomic_t retry_relogin_timer;	  /* Min Time between relogins
+					   * (4000 only) */
+	atomic_t relogin_timer;		  /* Max Time to wait for
+					   * relogin to complete */
+	atomic_t relogin_retry_count;	  /* Num of times relogin has been
+					   * retried */
+	uint32_t default_time2wait;	  /* Default Min time between
+					   * relogins (+aens) */
+
+};
+
+struct qla_ddb_index {
+	struct list_head list;
+	uint16_t fw_ddb_idx;
+	struct dev_db_entry fw_ddb;
+};
+
+#define DDB_IPADDR_LEN 64
+
+struct ql4_tuple_ddb {
+	int port;
+	int tpgt;
+	char ip_addr[DDB_IPADDR_LEN];
+	char iscsi_name[ISCSI_NAME_SIZE];
+	uint16_t options;
+#define DDB_OPT_IPV6 0x0e0e
+#define DDB_OPT_IPV4 0x0f0f
 };
 
 /*
@@ -411,7 +452,7 @@ struct scsi_qla_host {
 #define AF_FW_RECOVERY			19 /* 0x00080000 */
 #define AF_EEH_BUSY			20 /* 0x00100000 */
 #define AF_PCI_CHANNEL_IO_PERM_FAILURE	21 /* 0x00200000 */
-
+#define AF_BUILD_DDB_LIST		22 /* 0x00400000 */
 	unsigned long dpc_flags;
 
 #define DPC_RESET_HA			1 /* 0x00000002 */
@@ -604,6 +645,7 @@ struct scsi_qla_host {
 	uint16_t bootload_minor;
 	uint16_t bootload_patch;
 	uint16_t bootload_build;
+	uint16_t def_timeout; /* Default login timeout */
 
 	uint32_t flash_state;
 #define	QLFLASH_WAITING		0
@@ -623,6 +665,11 @@ struct scsi_qla_host {
 	uint16_t iscsi_pci_func_cnt;
 	uint8_t model_name[16];
 	struct completion disable_acb_comp;
+	struct dma_pool *fw_ddb_dma_pool;
+#define DDB_DMA_BLOCK_SIZE 512
+	uint16_t pri_ddb_idx;
+	uint16_t sec_ddb_idx;
+	int is_reset;
 };
 
 struct ql4_task_data {
@@ -835,6 +882,10 @@ static inline int ql4xxx_reset_active(struct scsi_qla_host *ha)
 /*---------------------------------------------------------------------------*/
 
 /* Defines for qla4xxx_initialize_adapter() and qla4xxx_recover_adapter() */
+
+#define INIT_ADAPTER    0
+#define RESET_ADAPTER   1
+
 #define PRESERVE_DDB_LIST	0
 #define REBUILD_DDB_LIST	1
 
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index cbd5a20..4ac07f8 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -12,6 +12,7 @@
 #define MAX_PRST_DEV_DB_ENTRIES		64
 #define MIN_DISC_DEV_DB_ENTRY		MAX_PRST_DEV_DB_ENTRIES
 #define MAX_DEV_DB_ENTRIES		512
+#define MAX_DEV_DB_ENTRIES_40XX		256
 
 /*************************************************************************
  *
@@ -604,6 +605,13 @@ struct addr_ctrl_blk {
 	uint8_t res14[140];	/* 274-2FF */
 };
 
+#define IP_ADDR_COUNT	4 /* Total 4 IP address supported in one interface
+			   * One IPv4, one IPv6 link local and 2 IPv6
+			   */
+
+#define IP_STATE_MASK	0x0F000000
+#define IP_STATE_SHIFT	24
+
 struct init_fw_ctrl_blk {
 	struct addr_ctrl_blk pri;
 /*	struct addr_ctrl_blk sec;*/
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 160db9d..d0dd4b3 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -13,7 +13,7 @@ struct iscsi_cls_conn;
 int qla4xxx_hw_reset(struct scsi_qla_host *ha);
 int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a);
 int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb *srb);
-int qla4xxx_initialize_adapter(struct scsi_qla_host *ha);
+int qla4xxx_initialize_adapter(struct scsi_qla_host *ha, int is_reset);
 int qla4xxx_soft_reset(struct scsi_qla_host *ha);
 irqreturn_t qla4xxx_intr_handler(int irq, void *dev_id);
 
@@ -153,10 +153,13 @@ int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 			  uint32_t *mbx_sts);
 int qla4xxx_clear_ddb_entry(struct scsi_qla_host *ha, uint32_t fw_ddb_index);
 int qla4xxx_send_passthru0(struct iscsi_task *task);
+void qla4xxx_free_ddb_index(struct scsi_qla_host *ha);
 int qla4xxx_get_mgmt_data(struct scsi_qla_host *ha, uint16_t fw_ddb_index,
 			  uint16_t stats_size, dma_addr_t stats_dma);
 void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 				       struct ddb_entry *ddb_entry);
+void qla4xxx_update_session_conn_fwddb_param(struct scsi_qla_host *ha,
+					     struct ddb_entry *ddb_entry);
 int qla4xxx_bootdb_by_index(struct scsi_qla_host *ha,
 			    struct dev_db_entry *fw_ddb_entry,
 			    dma_addr_t fw_ddb_entry_dma, uint16_t ddb_index);
@@ -169,11 +172,22 @@ int qla4xxx_set_nvram(struct scsi_qla_host *ha, dma_addr_t nvram_dma,
 int qla4xxx_restore_factory_defaults(struct scsi_qla_host *ha,
 				     uint32_t region, uint32_t field0,
 				     uint32_t field1);
+int qla4xxx_get_ddb_index(struct scsi_qla_host *ha, uint16_t *ddb_index);
+void qla4xxx_login_flash_ddb(struct iscsi_cls_session *cls_session);
+int qla4xxx_unblock_ddb(struct iscsi_cls_session *cls_session);
+int qla4xxx_unblock_flash_ddb(struct iscsi_cls_session *cls_session);
+int qla4xxx_flash_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
+			     struct ddb_entry *ddb_entry, uint32_t state);
+int qla4xxx_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
+		       struct ddb_entry *ddb_entry, uint32_t state);
+void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset);
 
 /* BSG Functions */
 int qla4xxx_bsg_request(struct bsg_job *bsg_job);
 int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job);
 
+void qla4xxx_arm_relogin_timer(struct ddb_entry *ddb_entry);
+
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
 extern int ql4xenablemsix;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 3075fba..0497873 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -773,14 +773,14 @@ int qla4xxx_start_firmware(struct scsi_qla_host *ha)
  * be freed so that when login happens from user space there are free DDB
  * indices available.
  **/
-static void qla4xxx_free_ddb_index(struct scsi_qla_host *ha)
+void qla4xxx_free_ddb_index(struct scsi_qla_host *ha)
 {
 	int max_ddbs;
 	int ret;
 	uint32_t idx = 0, next_idx = 0;
 	uint32_t state = 0, conn_err = 0;
 
-	max_ddbs =  is_qla40XX(ha) ? MAX_PRST_DEV_DB_ENTRIES :
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
 				     MAX_DEV_DB_ENTRIES;
 
 	for (idx = 0; idx < max_ddbs; idx = next_idx) {
@@ -804,7 +804,6 @@ static void qla4xxx_free_ddb_index(struct scsi_qla_host *ha)
 	}
 }
 
-
 /**
  * qla4xxx_initialize_adapter - initiailizes hba
  * @ha: Pointer to host adapter structure.
@@ -812,7 +811,7 @@ static void qla4xxx_free_ddb_index(struct scsi_qla_host *ha)
  * This routine parforms all of the steps necessary to initialize the adapter.
  *
  **/
-int qla4xxx_initialize_adapter(struct scsi_qla_host *ha)
+int qla4xxx_initialize_adapter(struct scsi_qla_host *ha, int is_reset)
 {
 	int status = QLA_ERROR;
 
@@ -840,7 +839,8 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha)
 	if (status == QLA_ERROR)
 		goto exit_init_hba;
 
-	qla4xxx_free_ddb_index(ha);
+	if (is_reset == RESET_ADAPTER)
+		qla4xxx_build_ddb_list(ha, is_reset);
 
 	set_bit(AF_ONLINE, &ha->flags);
 exit_init_hba:
@@ -855,38 +855,12 @@ exit_init_hba:
 	return status;
 }
 
-/**
- * qla4xxx_process_ddb_changed - process ddb state change
- * @ha - Pointer to host adapter structure.
- * @fw_ddb_index - Firmware's device database index
- * @state - Device state
- *
- * This routine processes a Decive Database Changed AEN Event.
- **/
-int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
-		uint32_t state, uint32_t conn_err)
+int qla4xxx_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
+		       struct ddb_entry *ddb_entry, uint32_t state)
 {
-	struct ddb_entry * ddb_entry;
 	uint32_t old_fw_ddb_device_state;
 	int status = QLA_ERROR;
 
-	/* check for out of range index */
-	if (fw_ddb_index >= MAX_DDB_ENTRIES)
-		goto exit_ddb_event;
-
-	/* Get the corresponging ddb entry */
-	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
-	/* Device does not currently exist in our database. */
-	if (ddb_entry == NULL) {
-		ql4_printk(KERN_ERR, ha, "%s: No ddb_entry at FW index [%d]\n",
-			   __func__, fw_ddb_index);
-
-		if (state == DDB_DS_NO_CONNECTION_ACTIVE)
-			clear_bit(fw_ddb_index, ha->ddb_idx_map);
-
-		goto exit_ddb_event;
-	}
-
 	old_fw_ddb_device_state = ddb_entry->fw_ddb_device_state;
 	DEBUG2(ql4_printk(KERN_INFO, ha,
 			  "%s: DDB - old state = 0x%x, new state = 0x%x for "
@@ -900,9 +874,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		switch (state) {
 		case DDB_DS_SESSION_ACTIVE:
 		case DDB_DS_DISCOVERY:
-			iscsi_conn_start(ddb_entry->conn);
-			iscsi_conn_login_event(ddb_entry->conn,
-					       ISCSI_CONN_STATE_LOGGED_IN);
+			ddb_entry->unblock_sess(ddb_entry->sess);
 			qla4xxx_update_session_conn_param(ha, ddb_entry);
 			status = QLA_SUCCESS;
 			break;
@@ -936,9 +908,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		switch (state) {
 		case DDB_DS_SESSION_ACTIVE:
 		case DDB_DS_DISCOVERY:
-			iscsi_conn_start(ddb_entry->conn);
-			iscsi_conn_login_event(ddb_entry->conn,
-					       ISCSI_CONN_STATE_LOGGED_IN);
+			ddb_entry->unblock_sess(ddb_entry->sess);
 			qla4xxx_update_session_conn_param(ha, ddb_entry);
 			status = QLA_SUCCESS;
 			break;
@@ -954,7 +924,198 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 				__func__));
 		break;
 	}
+	return status;
+}
+
+void qla4xxx_arm_relogin_timer(struct ddb_entry *ddb_entry)
+{
+	/*
+	 * This triggers a relogin.  After the relogin_timer
+	 * expires, the relogin gets scheduled.  We must wait a
+	 * minimum amount of time since receiving an 0x8014 AEN
+	 * with failed device_state or a logout response before
+	 * we can issue another relogin.
+	 *
+	 * Firmware pads this timeout: (time2wait +1).
+	 * Driver retry to login should be longer than F/W.
+	 * Otherwise F/W will fail
+	 * set_ddb() mbx cmd with 0x4005 since it still
+	 * counting down its time2wait.
+	 */
+	atomic_set(&ddb_entry->relogin_timer, 0);
+	atomic_set(&ddb_entry->retry_relogin_timer,
+		   ddb_entry->default_time2wait + 4);
+
+}
+
+int qla4xxx_flash_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
+			     struct ddb_entry *ddb_entry, uint32_t state)
+{
+	uint32_t old_fw_ddb_device_state;
+	int status = QLA_ERROR;
+
+	old_fw_ddb_device_state = ddb_entry->fw_ddb_device_state;
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "%s: DDB - old state = 0x%x, new state = 0x%x for "
+			  "index [%d]\n", __func__,
+			  ddb_entry->fw_ddb_device_state, state, fw_ddb_index));
+
+	ddb_entry->fw_ddb_device_state = state;
+
+	switch (old_fw_ddb_device_state) {
+	case DDB_DS_LOGIN_IN_PROCESS:
+	case DDB_DS_NO_CONNECTION_ACTIVE:
+		switch (state) {
+		case DDB_DS_SESSION_ACTIVE:
+			ddb_entry->unblock_sess(ddb_entry->sess);
+			qla4xxx_update_session_conn_fwddb_param(ha, ddb_entry);
+			status = QLA_SUCCESS;
+			break;
+		case DDB_DS_SESSION_FAILED:
+			iscsi_block_session(ddb_entry->sess);
+			if (!test_bit(DF_RELOGIN, &ddb_entry->flags))
+				qla4xxx_arm_relogin_timer(ddb_entry);
+			status = QLA_SUCCESS;
+			break;
+		}
+		break;
+	case DDB_DS_SESSION_ACTIVE:
+		switch (state) {
+		case DDB_DS_SESSION_FAILED:
+			iscsi_block_session(ddb_entry->sess);
+			if (!test_bit(DF_RELOGIN, &ddb_entry->flags))
+				qla4xxx_arm_relogin_timer(ddb_entry);
+			status = QLA_SUCCESS;
+			break;
+		}
+		break;
+	case DDB_DS_SESSION_FAILED:
+		switch (state) {
+		case DDB_DS_SESSION_ACTIVE:
+			ddb_entry->unblock_sess(ddb_entry->sess);
+			qla4xxx_update_session_conn_fwddb_param(ha, ddb_entry);
+			status = QLA_SUCCESS;
+			break;
+		case DDB_DS_SESSION_FAILED:
+			if (!test_bit(DF_RELOGIN, &ddb_entry->flags))
+				qla4xxx_arm_relogin_timer(ddb_entry);
+			status = QLA_SUCCESS;
+			break;
+		}
+		break;
+	default:
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: Unknown Event\n",
+				  __func__));
+		break;
+	}
+	return status;
+}
+
+/**
+ * qla4xxx_process_ddb_changed - process ddb state change
+ * @ha - Pointer to host adapter structure.
+ * @fw_ddb_index - Firmware's device database index
+ * @state - Device state
+ *
+ * This routine processes a Decive Database Changed AEN Event.
+ **/
+int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
+				uint32_t fw_ddb_index,
+				uint32_t state, uint32_t conn_err)
+{
+	struct ddb_entry *ddb_entry;
+	int status = QLA_ERROR;
+
+	/* check for out of range index */
+	if (fw_ddb_index >= MAX_DDB_ENTRIES)
+		goto exit_ddb_event;
+
+	/* Get the corresponging ddb entry */
+	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
+	/* Device does not currently exist in our database. */
+	if (ddb_entry == NULL) {
+		ql4_printk(KERN_ERR, ha, "%s: No ddb_entry at FW index [%d]\n",
+			   __func__, fw_ddb_index);
+
+		if (state == DDB_DS_NO_CONNECTION_ACTIVE)
+			clear_bit(fw_ddb_index, ha->ddb_idx_map);
+
+		goto exit_ddb_event;
+	}
+
+	ddb_entry->ddb_change(ha, fw_ddb_index, ddb_entry, state);
 
 exit_ddb_event:
 	return status;
 }
+
+/**
+ * qla4xxx_login_flash_ddb - Login to target (DDB)
+ * @cls_session: Pointer to the session to login
+ *
+ * This routine logins to the target.
+ * Issues setddb and conn open mbx
+ **/
+void qla4xxx_login_flash_ddb(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	struct dev_db_entry *fw_ddb_entry = NULL;
+	dma_addr_t fw_ddb_dma;
+	uint32_t mbx_sts = 0;
+	int ret;
+
+	sess = cls_session->dd_data;
+	ddb_entry = sess->dd_data;
+	ha =  ddb_entry->ha;
+
+	if (!test_bit(AF_LINK_UP, &ha->flags))
+		return;
+
+	if (ddb_entry->ddb_type != FLASH_DDB) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "Skipping login to non FLASH DB"));
+		goto exit_login;
+	}
+
+	fw_ddb_entry = dma_pool_alloc(ha->fw_ddb_dma_pool, GFP_KERNEL,
+				      &fw_ddb_dma);
+	if (fw_ddb_entry == NULL) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "Out of memory\n"));
+		goto exit_login;
+	}
+
+	if (ddb_entry->fw_ddb_index == INVALID_ENTRY) {
+		ret = qla4xxx_get_ddb_index(ha, &ddb_entry->fw_ddb_index);
+		if (ret == QLA_ERROR)
+			goto exit_login;
+
+		ha->fw_ddb_index_map[ddb_entry->fw_ddb_index] = ddb_entry;
+		ha->tot_ddbs++;
+	}
+
+	memcpy(fw_ddb_entry, &ddb_entry->fw_ddb_entry,
+	       sizeof(struct dev_db_entry));
+	ddb_entry->sess->target_id = ddb_entry->fw_ddb_index;
+
+	ret = qla4xxx_set_ddb_entry(ha, ddb_entry->fw_ddb_index,
+				    fw_ddb_dma, &mbx_sts);
+	if (ret == QLA_ERROR) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "Set DDB failed\n"));
+		goto exit_login;
+	}
+
+	ddb_entry->fw_ddb_device_state = DDB_DS_LOGIN_IN_PROCESS;
+	ret = qla4xxx_conn_open(ha, ddb_entry->fw_ddb_index);
+	if (ret == QLA_ERROR) {
+		ql4_printk(KERN_ERR, ha, "%s: Login failed: %s\n", __func__,
+			   sess->targetname);
+		goto exit_login;
+	}
+
+exit_login:
+	if (fw_ddb_entry)
+		dma_pool_free(ha->fw_ddb_dma_pool, fw_ddb_entry, fw_ddb_dma);
+}
+
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 4c2b848..c259378 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -41,6 +41,16 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		return status;
 	}
 
+	if (is_qla40XX(ha)) {
+		if (test_bit(AF_HA_REMOVAL, &ha->flags)) {
+			DEBUG2(ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: "
+					  "prematurely completing mbx cmd as "
+					  "adapter removal detected\n",
+					  ha->host_no, __func__));
+			return status;
+		}
+	}
+
 	if (is_qla8022(ha)) {
 		if (test_bit(AF_FW_RECOVERY, &ha->flags)) {
 			DEBUG2(ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: "
@@ -413,6 +423,7 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
 	memcpy(ha->name_string, init_fw_cb->iscsi_name,
 		min(sizeof(ha->name_string),
 		sizeof(init_fw_cb->iscsi_name)));
+	ha->def_timeout = le16_to_cpu(init_fw_cb->def_timeout);
 	/*memcpy(ha->alias, init_fw_cb->Alias,
 	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));*/
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 30f31b1..95910c9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/iscsi_boot_sysfs.h>
+#include <linux/inet.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -31,6 +32,13 @@ static struct kmem_cache *srb_cachep;
 /*
  * Module parameter information and variables
  */
+int ql4xdisablesysfsboot = 1;
+module_param(ql4xdisablesysfsboot, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ql4xdisablesysfsboot,
+		"Set to disable exporting boot targets to sysfs\n"
+		" 0 - Export boot targets\n"
+		" 1 - Do not export boot targets (Default)");
+
 int ql4xdontresethba = 0;
 module_param(ql4xdontresethba, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xdontresethba,
@@ -63,7 +71,7 @@ static int ql4xsess_recovery_tmo = QL4_SESS_RECOVERY_TMO;
 module_param(ql4xsess_recovery_tmo, int, S_IRUGO);
 MODULE_PARM_DESC(ql4xsess_recovery_tmo,
 		"Target Session Recovery Timeout.\n"
-		" Default: 30 sec.");
+		" Default: 120 sec.");
 
 static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha);
 /*
@@ -415,7 +423,7 @@ static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 	qla_ep = ep->dd_data;
 	ha = to_qla_host(qla_ep->host);
 
-	if (adapter_up(ha))
+	if (adapter_up(ha) && !test_bit(AF_BUILD_DDB_LIST, &ha->flags))
 		ret = 1;
 
 	return ret;
@@ -975,6 +983,150 @@ static int qla4xxx_conn_get_param(struct iscsi_cls_conn *cls_conn,
 
 }
 
+int qla4xxx_get_ddb_index(struct scsi_qla_host *ha, uint16_t *ddb_index)
+{
+	uint32_t mbx_sts = 0;
+	uint16_t tmp_ddb_index;
+	int ret;
+
+get_ddb_index:
+	tmp_ddb_index = find_first_zero_bit(ha->ddb_idx_map, MAX_DDB_ENTRIES);
+
+	if (tmp_ddb_index >= MAX_DDB_ENTRIES) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "Free DDB index not available\n"));
+		ret = QLA_ERROR;
+		goto exit_get_ddb_index;
+	}
+
+	if (test_and_set_bit(tmp_ddb_index, ha->ddb_idx_map))
+		goto get_ddb_index;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "Found a free DDB index at %d\n", tmp_ddb_index));
+	ret = qla4xxx_req_ddb_entry(ha, tmp_ddb_index, &mbx_sts);
+	if (ret == QLA_ERROR) {
+		if (mbx_sts == MBOX_STS_COMMAND_ERROR) {
+			ql4_printk(KERN_INFO, ha,
+				   "DDB index = %d not available trying next\n",
+				   tmp_ddb_index);
+			goto get_ddb_index;
+		}
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "Free FW DDB not available\n"));
+	}
+
+	*ddb_index = tmp_ddb_index;
+
+exit_get_ddb_index:
+	return ret;
+}
+
+static int qla4xxx_match_ipaddress(struct scsi_qla_host *ha,
+				   struct ddb_entry *ddb_entry,
+				   char *existing_ipaddr,
+				   char *user_ipaddr)
+{
+	uint8_t dst_ipaddr[IPv6_ADDR_LEN];
+	char formatted_ipaddr[DDB_IPADDR_LEN];
+	int status = QLA_SUCCESS, ret = 0;
+
+	if (ddb_entry->fw_ddb_entry.options & DDB_OPT_IPV6_DEVICE) {
+		ret = in6_pton(user_ipaddr, strlen(user_ipaddr), dst_ipaddr,
+			       '\0', NULL);
+		if (ret == 0) {
+			status = QLA_ERROR;
+			goto out_match;
+		}
+		ret = sprintf(formatted_ipaddr, "%pI6", dst_ipaddr);
+	} else {
+		ret = in4_pton(user_ipaddr, strlen(user_ipaddr), dst_ipaddr,
+			       '\0', NULL);
+		if (ret == 0) {
+			status = QLA_ERROR;
+			goto out_match;
+		}
+		ret = sprintf(formatted_ipaddr, "%pI4", dst_ipaddr);
+	}
+
+	if (strcmp(existing_ipaddr, formatted_ipaddr))
+		status = QLA_ERROR;
+
+out_match:
+	return status;
+}
+
+static int qla4xxx_match_fwdb_session(struct scsi_qla_host *ha,
+				      struct iscsi_cls_conn *cls_conn)
+{
+	int idx = 0, max_ddbs, rval;
+	struct iscsi_cls_session *cls_sess = iscsi_conn_to_session(cls_conn);
+	struct iscsi_session *sess, *existing_sess;
+	struct iscsi_conn *conn, *existing_conn;
+	struct ddb_entry *ddb_entry;
+
+	sess = cls_sess->dd_data;
+	conn = cls_conn->dd_data;
+
+	if (sess->targetname == NULL ||
+	    conn->persistent_address == NULL ||
+	    conn->persistent_port == 0)
+		return QLA_ERROR;
+
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+				     MAX_DEV_DB_ENTRIES;
+
+	for (idx = 0; idx < max_ddbs; idx++) {
+		ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, idx);
+		if (ddb_entry == NULL)
+			continue;
+
+		if (ddb_entry->ddb_type != FLASH_DDB)
+			continue;
+
+		existing_sess = ddb_entry->sess->dd_data;
+		existing_conn = ddb_entry->conn->dd_data;
+
+		if (existing_sess->targetname == NULL ||
+		    existing_conn->persistent_address == NULL ||
+		    existing_conn->persistent_port == 0)
+			continue;
+
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "IQN = %s User IQN = %s\n",
+				  existing_sess->targetname,
+				  sess->targetname));
+
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "IP = %s User IP = %s\n",
+				  existing_conn->persistent_address,
+				  conn->persistent_address));
+
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "Port = %d User Port = %d\n",
+				  existing_conn->persistent_port,
+				  conn->persistent_port));
+
+		if (strcmp(existing_sess->targetname, sess->targetname))
+			continue;
+		rval = qla4xxx_match_ipaddress(ha, ddb_entry,
+					existing_conn->persistent_address,
+					conn->persistent_address);
+		if (rval == QLA_ERROR)
+			continue;
+		if (existing_conn->persistent_port != conn->persistent_port)
+			continue;
+		break;
+	}
+
+	if (idx == max_ddbs)
+		return QLA_ERROR;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "Match found in fwdb sessions\n"));
+	return QLA_SUCCESS;
+}
+
 static struct iscsi_cls_session *
 qla4xxx_session_create(struct iscsi_endpoint *ep,
 			uint16_t cmds_max, uint16_t qdepth,
@@ -984,8 +1136,7 @@ qla4xxx_session_create(struct iscsi_endpoint *ep,
 	struct scsi_qla_host *ha;
 	struct qla_endpoint *qla_ep;
 	struct ddb_entry *ddb_entry;
-	uint32_t ddb_index;
-	uint32_t mbx_sts = 0;
+	uint16_t ddb_index;
 	struct iscsi_session *sess;
 	struct sockaddr *dst_addr;
 	int ret;
@@ -1000,32 +1151,9 @@ qla4xxx_session_create(struct iscsi_endpoint *ep,
 	dst_addr = (struct sockaddr *)&qla_ep->dst_addr;
 	ha = to_qla_host(qla_ep->host);
 
-get_ddb_index:
-	ddb_index = find_first_zero_bit(ha->ddb_idx_map, MAX_DDB_ENTRIES);
-
-	if (ddb_index >= MAX_DDB_ENTRIES) {
-		DEBUG2(ql4_printk(KERN_INFO, ha,
-				  "Free DDB index not available\n"));
+	ret = qla4xxx_get_ddb_index(ha, &ddb_index);
+	if (ret == QLA_ERROR)
 		return NULL;
-	}
-
-	if (test_and_set_bit(ddb_index, ha->ddb_idx_map))
-		goto get_ddb_index;
-
-	DEBUG2(ql4_printk(KERN_INFO, ha,
-			  "Found a free DDB index at %d\n", ddb_index));
-	ret = qla4xxx_req_ddb_entry(ha, ddb_index, &mbx_sts);
-	if (ret == QLA_ERROR) {
-		if (mbx_sts == MBOX_STS_COMMAND_ERROR) {
-			ql4_printk(KERN_INFO, ha,
-				   "DDB index = %d not available trying next\n",
-				   ddb_index);
-			goto get_ddb_index;
-		}
-		DEBUG2(ql4_printk(KERN_INFO, ha,
-				  "Free FW DDB not available\n"));
-		return NULL;
-	}
 
 	cls_sess = iscsi_session_setup(&qla4xxx_iscsi_transport, qla_ep->host,
 				       cmds_max, sizeof(struct ddb_entry),
@@ -1040,6 +1168,8 @@ get_ddb_index:
 	ddb_entry->fw_ddb_device_state = DDB_DS_NO_CONNECTION_ACTIVE;
 	ddb_entry->ha = ha;
 	ddb_entry->sess = cls_sess;
+	ddb_entry->unblock_sess = qla4xxx_unblock_ddb;
+	ddb_entry->ddb_change = qla4xxx_ddb_change;
 	cls_sess->recovery_tmo = ql4xsess_recovery_tmo;
 	ha->fw_ddb_index_map[ddb_entry->fw_ddb_index] = ddb_entry;
 	ha->tot_ddbs++;
@@ -1109,7 +1239,7 @@ static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
 	struct iscsi_session *sess;
 	struct ddb_entry *ddb_entry;
 	struct scsi_qla_host *ha;
-	struct dev_db_entry *fw_ddb_entry;
+	struct dev_db_entry *fw_ddb_entry = NULL;
 	dma_addr_t fw_ddb_entry_dma;
 	uint32_t mbx_sts = 0;
 	int ret = 0;
@@ -1120,12 +1250,25 @@ static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
 	ddb_entry = sess->dd_data;
 	ha = ddb_entry->ha;
 
+	/* Check if we have  matching FW DDB, if yes then do not
+	 * login to this target. This could cause target to logout previous
+	 * connection
+	 */
+	ret = qla4xxx_match_fwdb_session(ha, cls_conn);
+	if (ret == QLA_SUCCESS) {
+		ql4_printk(KERN_INFO, ha,
+			   "Session already exist in FW.\n");
+		ret = -EEXIST;
+		goto exit_conn_start;
+	}
+
 	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
 					  &fw_ddb_entry_dma, GFP_KERNEL);
 	if (!fw_ddb_entry) {
 		ql4_printk(KERN_ERR, ha,
 			   "%s: Unable to allocate dma buffer\n", __func__);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto exit_conn_start;
 	}
 
 	ret = qla4xxx_set_param_ddbentry(ha, ddb_entry, cls_conn, &mbx_sts);
@@ -1138,9 +1281,7 @@ static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
 		if (mbx_sts)
 			if (ddb_entry->fw_ddb_device_state ==
 						DDB_DS_SESSION_ACTIVE) {
-				iscsi_conn_start(ddb_entry->conn);
-				iscsi_conn_login_event(ddb_entry->conn,
-						ISCSI_CONN_STATE_LOGGED_IN);
+				ddb_entry->unblock_sess(ddb_entry->sess);
 				goto exit_set_param;
 			}
 
@@ -1167,8 +1308,9 @@ exit_set_param:
 	ret = 0;
 
 exit_conn_start:
-	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
-			  fw_ddb_entry, fw_ddb_entry_dma);
+	if (fw_ddb_entry)
+		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+				  fw_ddb_entry, fw_ddb_entry_dma);
 	return ret;
 }
 
@@ -1344,6 +1486,101 @@ static int qla4xxx_task_xmit(struct iscsi_task *task)
 	return -ENOSYS;
 }
 
+static void qla4xxx_copy_fwddb_param(struct scsi_qla_host *ha,
+				     struct dev_db_entry *fw_ddb_entry,
+				     struct iscsi_cls_session *cls_sess,
+				     struct iscsi_cls_conn *cls_conn)
+{
+	int buflen = 0;
+	struct iscsi_session *sess;
+	struct iscsi_conn *conn;
+	char ip_addr[DDB_IPADDR_LEN];
+	uint16_t options = 0;
+
+	sess = cls_sess->dd_data;
+	conn = cls_conn->dd_data;
+
+	conn->max_recv_dlength = BYTE_UNITS *
+			  le16_to_cpu(fw_ddb_entry->iscsi_max_rcv_data_seg_len);
+
+	conn->max_xmit_dlength = BYTE_UNITS *
+			  le16_to_cpu(fw_ddb_entry->iscsi_max_snd_data_seg_len);
+
+	sess->initial_r2t_en =
+			    (BIT_10 & le16_to_cpu(fw_ddb_entry->iscsi_options));
+
+	sess->max_r2t = le16_to_cpu(fw_ddb_entry->iscsi_max_outsnd_r2t);
+
+	sess->imm_data_en = (BIT_11 & le16_to_cpu(fw_ddb_entry->iscsi_options));
+
+	sess->first_burst = BYTE_UNITS *
+			       le16_to_cpu(fw_ddb_entry->iscsi_first_burst_len);
+
+	sess->max_burst = BYTE_UNITS *
+				 le16_to_cpu(fw_ddb_entry->iscsi_max_burst_len);
+
+	sess->time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
+
+	sess->time2retain = le16_to_cpu(fw_ddb_entry->iscsi_def_time2retain);
+
+	conn->persistent_port = le16_to_cpu(fw_ddb_entry->port);
+
+	sess->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+
+	options = le16_to_cpu(fw_ddb_entry->options);
+	if (options & DDB_OPT_IPV6_DEVICE)
+		sprintf(ip_addr, "%pI6", fw_ddb_entry->ip_addr);
+	else
+		sprintf(ip_addr, "%pI4", fw_ddb_entry->ip_addr);
+
+	iscsi_set_param(cls_conn, ISCSI_PARAM_TARGET_NAME,
+			(char *)fw_ddb_entry->iscsi_name, buflen);
+	iscsi_set_param(cls_conn, ISCSI_PARAM_INITIATOR_NAME,
+			(char *)ha->name_string, buflen);
+	iscsi_set_param(cls_conn, ISCSI_PARAM_PERSISTENT_ADDRESS,
+			(char *)ip_addr, buflen);
+}
+
+void qla4xxx_update_session_conn_fwddb_param(struct scsi_qla_host *ha,
+					     struct ddb_entry *ddb_entry)
+{
+	struct iscsi_cls_session *cls_sess;
+	struct iscsi_cls_conn *cls_conn;
+	uint32_t ddb_state;
+	dma_addr_t fw_ddb_entry_dma;
+	struct dev_db_entry *fw_ddb_entry;
+
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Unable to allocate dma buffer\n", __func__);
+		goto exit_session_conn_fwddb_param;
+	}
+
+	if (qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index, fw_ddb_entry,
+				    fw_ddb_entry_dma, NULL, NULL, &ddb_state,
+				    NULL, NULL, NULL) == QLA_ERROR) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "scsi%ld: %s: failed "
+				  "get_ddb_entry for fw_ddb_index %d\n",
+				  ha->host_no, __func__,
+				  ddb_entry->fw_ddb_index));
+		goto exit_session_conn_fwddb_param;
+	}
+
+	cls_sess = ddb_entry->sess;
+
+	cls_conn = ddb_entry->conn;
+
+	/* Update params */
+	qla4xxx_copy_fwddb_param(ha, fw_ddb_entry, cls_sess, cls_conn);
+
+exit_session_conn_fwddb_param:
+	if (fw_ddb_entry)
+		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+				  fw_ddb_entry, fw_ddb_entry_dma);
+}
+
 void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 				       struct ddb_entry *ddb_entry)
 {
@@ -1360,7 +1597,7 @@ void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 	if (!fw_ddb_entry) {
 		ql4_printk(KERN_ERR, ha,
 			   "%s: Unable to allocate dma buffer\n", __func__);
-		return;
+		goto exit_session_conn_param;
 	}
 
 	if (qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index, fw_ddb_entry,
@@ -1370,7 +1607,7 @@ void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 				  "get_ddb_entry for fw_ddb_index %d\n",
 				  ha->host_no, __func__,
 				  ddb_entry->fw_ddb_index));
-		return;
+		goto exit_session_conn_param;
 	}
 
 	cls_sess = ddb_entry->sess;
@@ -1379,6 +1616,12 @@ void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 	cls_conn = ddb_entry->conn;
 	conn = cls_conn->dd_data;
 
+	/* Update timers after login */
+	ddb_entry->default_relogin_timeout =
+				le16_to_cpu(fw_ddb_entry->def_timeout);
+	ddb_entry->default_time2wait =
+				le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
+
 	/* Update params */
 	conn->max_recv_dlength = BYTE_UNITS *
 			  le16_to_cpu(fw_ddb_entry->iscsi_max_rcv_data_seg_len);
@@ -1407,6 +1650,11 @@ void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 
 	memcpy(sess->initiatorname, ha->name_string,
 	       min(sizeof(ha->name_string), sizeof(sess->initiatorname)));
+
+exit_session_conn_param:
+	if (fw_ddb_entry)
+		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+				  fw_ddb_entry, fw_ddb_entry_dma);
 }
 
 /*
@@ -1607,6 +1855,9 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 		vfree(ha->chap_list);
 	ha->chap_list = NULL;
 
+	if (ha->fw_ddb_dma_pool)
+		dma_pool_destroy(ha->fw_ddb_dma_pool);
+
 	/* release io space registers  */
 	if (is_qla8022(ha)) {
 		if (ha->nx_pcibase)
@@ -1689,6 +1940,16 @@ static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
 		goto mem_alloc_error_exit;
 	}
 
+	ha->fw_ddb_dma_pool = dma_pool_create("ql4_fw_ddb", &ha->pdev->dev,
+					      DDB_DMA_BLOCK_SIZE, 8, 0);
+
+	if (ha->fw_ddb_dma_pool == NULL) {
+		ql4_printk(KERN_WARNING, ha,
+			   "%s: fw_ddb_dma_pool allocation failed..\n",
+			   __func__);
+		goto mem_alloc_error_exit;
+	}
+
 	return QLA_SUCCESS;
 
 mem_alloc_error_exit:
@@ -1800,6 +2061,60 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 	}
 }
 
+void qla4xxx_check_relogin_flash_ddb(struct iscsi_cls_session *cls_sess)
+{
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+
+	sess = cls_sess->dd_data;
+	ddb_entry = sess->dd_data;
+	ha = ddb_entry->ha;
+
+	if (!(ddb_entry->ddb_type == FLASH_DDB))
+		return;
+
+	if (adapter_up(ha) && !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
+	    !iscsi_is_session_online(cls_sess)) {
+		if (atomic_read(&ddb_entry->retry_relogin_timer) !=
+		    INVALID_ENTRY) {
+			if (atomic_read(&ddb_entry->retry_relogin_timer) ==
+					0) {
+				atomic_set(&ddb_entry->retry_relogin_timer,
+					   INVALID_ENTRY);
+				set_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags);
+				set_bit(DF_RELOGIN, &ddb_entry->flags);
+				DEBUG2(ql4_printk(KERN_INFO, ha,
+				       "%s: index [%d] login device\n",
+					__func__, ddb_entry->fw_ddb_index));
+			} else
+				atomic_dec(&ddb_entry->retry_relogin_timer);
+		}
+	}
+
+	/* Wait for relogin to timeout */
+	if (atomic_read(&ddb_entry->relogin_timer) &&
+	    (atomic_dec_and_test(&ddb_entry->relogin_timer) != 0)) {
+		/*
+		 * If the relogin times out and the device is
+		 * still NOT ONLINE then try and relogin again.
+		 */
+		if (!iscsi_is_session_online(cls_sess)) {
+			/* Reset retry relogin timer */
+			atomic_inc(&ddb_entry->relogin_retry_count);
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+				"%s: index[%d] relogin timed out-retrying"
+				" relogin (%d), retry (%d)\n", __func__,
+				ddb_entry->fw_ddb_index,
+				atomic_read(&ddb_entry->relogin_retry_count),
+				ddb_entry->default_time2wait + 4));
+			set_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags);
+			atomic_set(&ddb_entry->retry_relogin_timer,
+				   ddb_entry->default_time2wait + 4);
+		}
+	}
+}
+
 /**
  * qla4xxx_timer - checks every second for work to do.
  * @ha: Pointer to host adapter structure.
@@ -1809,6 +2124,8 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 	int start_dpc = 0;
 	uint16_t w;
 
+	iscsi_host_for_each_session(ha->host, qla4xxx_check_relogin_flash_ddb);
+
 	/* If we are in the middle of AER/EEH processing
 	 * skip any processing and reschedule the timer
 	 */
@@ -2078,7 +2395,12 @@ static void qla4xxx_fail_session(struct iscsi_cls_session *cls_session)
 	sess = cls_session->dd_data;
 	ddb_entry = sess->dd_data;
 	ddb_entry->fw_ddb_device_state = DDB_DS_SESSION_FAILED;
-	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
+
+	if (ddb_entry->ddb_type == FLASH_DDB)
+		iscsi_block_session(ddb_entry->sess);
+	else
+		iscsi_session_failure(cls_session->dd_data,
+				      ISCSI_ERR_CONN_FAILED);
 }
 
 /**
@@ -2163,7 +2485,7 @@ recover_ha_init_adapter:
 
 		/* NOTE: AF_ONLINE flag set upon successful completion of
 		 *       qla4xxx_initialize_adapter */
-		status = qla4xxx_initialize_adapter(ha);
+		status = qla4xxx_initialize_adapter(ha, RESET_ADAPTER);
 	}
 
 	/* Retry failed adapter initialization, if necessary
@@ -2245,17 +2567,108 @@ static void qla4xxx_relogin_devices(struct iscsi_cls_session *cls_session)
 			iscsi_unblock_session(ddb_entry->sess);
 		} else {
 			/* Trigger relogin */
-			iscsi_session_failure(cls_session->dd_data,
-					      ISCSI_ERR_CONN_FAILED);
+			if (ddb_entry->ddb_type == FLASH_DDB) {
+				if (!test_bit(DF_RELOGIN, &ddb_entry->flags))
+					qla4xxx_arm_relogin_timer(ddb_entry);
+			} else
+				iscsi_session_failure(cls_session->dd_data,
+						      ISCSI_ERR_CONN_FAILED);
 		}
 	}
 }
 
+int qla4xxx_unblock_flash_ddb(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+
+	sess = cls_session->dd_data;
+	ddb_entry = sess->dd_data;
+	ha = ddb_entry->ha;
+	ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
+		   " unblock session\n", ha->host_no, __func__,
+		   ddb_entry->fw_ddb_index);
+
+	iscsi_unblock_session(ddb_entry->sess);
+
+	/* Start scan target */
+	if (test_bit(AF_ONLINE, &ha->flags)) {
+		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
+			   " start scan\n", ha->host_no, __func__,
+			   ddb_entry->fw_ddb_index);
+		scsi_queue_work(ha->host, &ddb_entry->sess->scan_work);
+	}
+	return QLA_SUCCESS;
+}
+
+int qla4xxx_unblock_ddb(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+
+	sess = cls_session->dd_data;
+	ddb_entry = sess->dd_data;
+	ha = ddb_entry->ha;
+	ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
+		   " unblock user space session\n", ha->host_no, __func__,
+		   ddb_entry->fw_ddb_index);
+	iscsi_conn_start(ddb_entry->conn);
+	iscsi_conn_login_event(ddb_entry->conn,
+			       ISCSI_CONN_STATE_LOGGED_IN);
+
+	return QLA_SUCCESS;
+}
+
 static void qla4xxx_relogin_all_devices(struct scsi_qla_host *ha)
 {
 	iscsi_host_for_each_session(ha->host, qla4xxx_relogin_devices);
 }
 
+static void qla4xxx_relogin_flash_ddb(struct iscsi_cls_session *cls_sess)
+{
+	uint16_t relogin_timer;
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+
+	sess = cls_sess->dd_data;
+	ddb_entry = sess->dd_data;
+	ha = ddb_entry->ha;
+
+	relogin_timer = max(ddb_entry->default_relogin_timeout,
+			    (uint16_t)RELOGIN_TOV);
+	atomic_set(&ddb_entry->relogin_timer, relogin_timer);
+
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "scsi%ld: Relogin index [%d]. TOV=%d\n", ha->host_no,
+			  ddb_entry->fw_ddb_index, relogin_timer));
+
+	qla4xxx_login_flash_ddb(cls_sess);
+}
+
+static void qla4xxx_dpc_relogin(struct iscsi_cls_session *cls_sess)
+{
+	struct iscsi_session *sess;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+
+	sess = cls_sess->dd_data;
+	ddb_entry = sess->dd_data;
+	ha = ddb_entry->ha;
+
+	if (!(ddb_entry->ddb_type == FLASH_DDB))
+		return;
+
+	if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags) &&
+	    !iscsi_is_session_online(cls_sess)) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "relogin issued\n"));
+		qla4xxx_relogin_flash_ddb(cls_sess);
+	}
+}
+
 void qla4xxx_wake_dpc(struct scsi_qla_host *ha)
 {
 	if (ha->dpc_thread)
@@ -2356,6 +2769,12 @@ dpc_post_reset_ha:
 	if (test_and_clear_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags))
 		qla4xxx_get_dhcp_ip_address(ha);
 
+	/* ---- relogin device? --- */
+	if (adapter_up(ha) &&
+	    test_and_clear_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags)) {
+		iscsi_host_for_each_session(ha->host, qla4xxx_dpc_relogin);
+	}
+
 	/* ---- link change? --- */
 	if (test_and_clear_bit(DPC_LINK_CHANGED, &ha->dpc_flags)) {
 		if (!test_bit(AF_LINK_UP, &ha->flags)) {
@@ -2368,8 +2787,12 @@ dpc_post_reset_ha:
 			 * fatal error recovery.  Therefore, the driver must
 			 * manually relogin to devices when recovering from
 			 * connection failures, logouts, expired KATO, etc. */
-
-			qla4xxx_relogin_all_devices(ha);
+			if (test_and_clear_bit(AF_BUILD_DDB_LIST, &ha->flags)) {
+				qla4xxx_build_ddb_list(ha, ha->is_reset);
+				iscsi_host_for_each_session(ha->host,
+						qla4xxx_login_flash_ddb);
+			} else
+				qla4xxx_relogin_all_devices(ha);
 		}
 	}
 }
@@ -2867,6 +3290,9 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 			  " target ID %d\n", __func__, ddb_index[0],
 			  ddb_index[1]));
 
+	ha->pri_ddb_idx = ddb_index[0];
+	ha->sec_ddb_idx = ddb_index[1];
+
 exit_boot_info_free:
 	dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
 exit_boot_info:
@@ -3034,6 +3460,9 @@ static int qla4xxx_get_boot_info(struct scsi_qla_host *ha)
 		return ret;
 	}
 
+	if (ql4xdisablesysfsboot)
+		return QLA_SUCCESS;
+
 	if (ddb_index[0] == 0xffff)
 		goto sec_target;
 
@@ -3066,7 +3495,15 @@ static int qla4xxx_setup_boot_info(struct scsi_qla_host *ha)
 	struct iscsi_boot_kobj *boot_kobj;
 
 	if (qla4xxx_get_boot_info(ha) != QLA_SUCCESS)
-		return 0;
+		return QLA_ERROR;
+
+	if (ql4xdisablesysfsboot) {
+		ql4_printk(KERN_INFO, ha,
+			   "%s: syfsboot disabled - driver will trigger login"
+			   "and publish session for discovery .\n", __func__);
+		return QLA_SUCCESS;
+	}
+
 
 	ha->boot_kset = iscsi_boot_create_host_kset(ha->host->host_no);
 	if (!ha->boot_kset)
@@ -3108,7 +3545,7 @@ static int qla4xxx_setup_boot_info(struct scsi_qla_host *ha)
 	if (!boot_kobj)
 		goto put_host;
 
-	return 0;
+	return QLA_SUCCESS;
 
 put_host:
 	scsi_host_put(ha->host);
@@ -3174,9 +3611,507 @@ static void qla4xxx_create_chap_list(struct scsi_qla_host *ha)
 exit_chap_list:
 	dma_free_coherent(&ha->pdev->dev, chap_size,
 			chap_flash_data, chap_dma);
-	return;
 }
 
+static void qla4xxx_get_param_ddb(struct ddb_entry *ddb_entry,
+				  struct ql4_tuple_ddb *tddb)
+{
+	struct scsi_qla_host *ha;
+	struct iscsi_cls_session *cls_sess;
+	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_session *sess;
+	struct iscsi_conn *conn;
+
+	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	ha = ddb_entry->ha;
+	cls_sess = ddb_entry->sess;
+	sess = cls_sess->dd_data;
+	cls_conn = ddb_entry->conn;
+	conn = cls_conn->dd_data;
+
+	tddb->tpgt = sess->tpgt;
+	tddb->port = conn->persistent_port;
+	strncpy(tddb->iscsi_name, sess->targetname, ISCSI_NAME_SIZE);
+	strncpy(tddb->ip_addr, conn->persistent_address, DDB_IPADDR_LEN);
+}
+
+static void qla4xxx_convert_param_ddb(struct dev_db_entry *fw_ddb_entry,
+				      struct ql4_tuple_ddb *tddb)
+{
+	uint16_t options = 0;
+
+	tddb->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+	memcpy(&tddb->iscsi_name[0], &fw_ddb_entry->iscsi_name[0],
+	       min(sizeof(tddb->iscsi_name), sizeof(fw_ddb_entry->iscsi_name)));
+
+	options = le16_to_cpu(fw_ddb_entry->options);
+	if (options & DDB_OPT_IPV6_DEVICE)
+		sprintf(tddb->ip_addr, "%pI6", fw_ddb_entry->ip_addr);
+	else
+		sprintf(tddb->ip_addr, "%pI4", fw_ddb_entry->ip_addr);
+
+	tddb->port = le16_to_cpu(fw_ddb_entry->port);
+}
+
+static int qla4xxx_compare_tuple_ddb(struct scsi_qla_host *ha,
+				     struct ql4_tuple_ddb *old_tddb,
+				     struct ql4_tuple_ddb *new_tddb)
+{
+	if (strcmp(old_tddb->iscsi_name, new_tddb->iscsi_name))
+		return QLA_ERROR;
+
+	if (strcmp(old_tddb->ip_addr, new_tddb->ip_addr))
+		return QLA_ERROR;
+
+	if (old_tddb->port != new_tddb->port)
+		return QLA_ERROR;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "Match Found, fw[%d,%d,%s,%s], [%d,%d,%s,%s]",
+			  old_tddb->port, old_tddb->tpgt, old_tddb->ip_addr,
+			  old_tddb->iscsi_name, new_tddb->port, new_tddb->tpgt,
+			  new_tddb->ip_addr, new_tddb->iscsi_name));
+
+	return QLA_SUCCESS;
+}
+
+static int qla4xxx_is_session_exists(struct scsi_qla_host *ha,
+				     struct dev_db_entry *fw_ddb_entry)
+{
+	struct ddb_entry *ddb_entry;
+	struct ql4_tuple_ddb *fw_tddb = NULL;
+	struct ql4_tuple_ddb *tmp_tddb = NULL;
+	int idx;
+	int ret = QLA_ERROR;
+
+	fw_tddb = vzalloc(sizeof(*fw_tddb));
+	if (!fw_tddb) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha,
+				  "Memory Allocation failed.\n"));
+		ret = QLA_SUCCESS;
+		goto exit_check;
+	}
+
+	tmp_tddb = vzalloc(sizeof(*tmp_tddb));
+	if (!tmp_tddb) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha,
+				  "Memory Allocation failed.\n"));
+		ret = QLA_SUCCESS;
+		goto exit_check;
+	}
+
+	qla4xxx_convert_param_ddb(fw_ddb_entry, fw_tddb);
+
+	for (idx = 0; idx < MAX_DDB_ENTRIES; idx++) {
+		ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, idx);
+		if (ddb_entry == NULL)
+			continue;
+
+		qla4xxx_get_param_ddb(ddb_entry, tmp_tddb);
+		if (!qla4xxx_compare_tuple_ddb(ha, fw_tddb, tmp_tddb)) {
+			ret = QLA_SUCCESS; /* found */
+			goto exit_check;
+		}
+	}
+
+exit_check:
+	if (fw_tddb)
+		vfree(fw_tddb);
+	if (tmp_tddb)
+		vfree(tmp_tddb);
+	return ret;
+}
+
+static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
+				       struct list_head *list_nt,
+				       struct dev_db_entry *fw_ddb_entry)
+{
+	struct qla_ddb_index  *nt_ddb_idx, *nt_ddb_idx_tmp;
+	struct ql4_tuple_ddb *fw_tddb = NULL;
+	struct ql4_tuple_ddb *tmp_tddb = NULL;
+	int ret = QLA_ERROR;
+
+	fw_tddb = vzalloc(sizeof(*fw_tddb));
+	if (!fw_tddb) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha,
+				  "Memory Allocation failed.\n"));
+		ret = QLA_SUCCESS;
+		goto exit_check;
+	}
+
+	tmp_tddb = vzalloc(sizeof(*tmp_tddb));
+	if (!tmp_tddb) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha,
+				  "Memory Allocation failed.\n"));
+		ret = QLA_SUCCESS;
+		goto exit_check;
+	}
+
+	qla4xxx_convert_param_ddb(fw_ddb_entry, fw_tddb);
+
+	list_for_each_entry_safe(nt_ddb_idx, nt_ddb_idx_tmp, list_nt, list) {
+		qla4xxx_convert_param_ddb(&nt_ddb_idx->fw_ddb, tmp_tddb);
+		if (!qla4xxx_compare_tuple_ddb(ha, fw_tddb, tmp_tddb)) {
+			ret = QLA_SUCCESS; /* found */
+			goto exit_check;
+		}
+	}
+
+exit_check:
+	if (fw_tddb)
+		vfree(fw_tddb);
+	if (tmp_tddb)
+		vfree(tmp_tddb);
+	return ret;
+}
+
+static void qla4xxx_free_nt_list(struct list_head *list_nt)
+{
+	struct qla_ddb_index  *nt_ddb_idx, *nt_ddb_idx_tmp;
+
+	/* Free up the normaltargets list */
+	list_for_each_entry_safe(nt_ddb_idx, nt_ddb_idx_tmp, list_nt, list) {
+		list_del_init(&nt_ddb_idx->list);
+		vfree(nt_ddb_idx);
+	}
+
+}
+
+static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
+					struct dev_db_entry *fw_ddb_entry)
+{
+	struct iscsi_endpoint *ep;
+	struct sockaddr_in *addr;
+	struct sockaddr_in6 *addr6;
+	struct sockaddr *dst_addr;
+	char *ip;
+
+	/* TODO: need to destroy on unload iscsi_endpoint*/
+	dst_addr = vmalloc(sizeof(*dst_addr));
+	if (!dst_addr)
+		return NULL;
+
+	if (fw_ddb_entry->options & DDB_OPT_IPV6_DEVICE) {
+		dst_addr->sa_family = AF_INET6;
+		addr6 = (struct sockaddr_in6 *)dst_addr;
+		ip = (char *)&addr6->sin6_addr;
+		memcpy(ip, fw_ddb_entry->ip_addr, IPv6_ADDR_LEN);
+		addr6->sin6_port = htons(le16_to_cpu(fw_ddb_entry->port));
+
+	} else {
+		dst_addr->sa_family = AF_INET;
+		addr = (struct sockaddr_in *)dst_addr;
+		ip = (char *)&addr->sin_addr;
+		memcpy(ip, fw_ddb_entry->ip_addr, IP_ADDR_LEN);
+		addr->sin_port = htons(le16_to_cpu(fw_ddb_entry->port));
+	}
+
+	ep = qla4xxx_ep_connect(ha->host, dst_addr, 0);
+	vfree(dst_addr);
+	return ep;
+}
+
+static int qla4xxx_verify_boot_idx(struct scsi_qla_host *ha, uint16_t idx)
+{
+	if (ql4xdisablesysfsboot)
+		return QLA_SUCCESS;
+	if (idx == ha->pri_ddb_idx || idx == ha->sec_ddb_idx)
+		return QLA_ERROR;
+	return QLA_SUCCESS;
+}
+
+static void qla4xxx_setup_flash_ddb_entry(struct scsi_qla_host *ha,
+					  struct ddb_entry *ddb_entry)
+{
+	ddb_entry->ddb_type = FLASH_DDB;
+	ddb_entry->fw_ddb_index = INVALID_ENTRY;
+	ddb_entry->fw_ddb_device_state = DDB_DS_NO_CONNECTION_ACTIVE;
+	ddb_entry->ha = ha;
+	ddb_entry->unblock_sess = qla4xxx_unblock_flash_ddb;
+	ddb_entry->ddb_change = qla4xxx_flash_ddb_change;
+
+	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
+	atomic_set(&ddb_entry->relogin_timer, 0);
+	atomic_set(&ddb_entry->relogin_retry_count, 0);
+
+	ddb_entry->default_relogin_timeout =
+		le16_to_cpu(ddb_entry->fw_ddb_entry.def_timeout);
+	ddb_entry->default_time2wait =
+		le16_to_cpu(ddb_entry->fw_ddb_entry.iscsi_def_time2wait);
+}
+
+static void qla4xxx_wait_for_ip_configuration(struct scsi_qla_host *ha)
+{
+	uint32_t idx = 0;
+	uint32_t ip_idx[IP_ADDR_COUNT] = {0, 1, 2, 3}; /* 4 IP interfaces */
+	uint32_t sts[MBOX_REG_COUNT];
+	uint32_t ip_state;
+	unsigned long wtime;
+	int ret;
+
+	wtime = jiffies + (HZ * IP_CONFIG_TOV);
+	do {
+		for (idx = 0; idx < IP_ADDR_COUNT; idx++) {
+			if (ip_idx[idx] == -1)
+				continue;
+
+			ret = qla4xxx_get_ip_state(ha, 0, ip_idx[idx], sts);
+
+			if (ret == QLA_ERROR) {
+				ip_idx[idx] = -1;
+				continue;
+			}
+
+			ip_state = (sts[1] & IP_STATE_MASK) >> IP_STATE_SHIFT;
+
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "Waiting for IP state for idx = %d, state = 0x%x\n",
+					  ip_idx[idx], ip_state));
+			if (ip_state == IP_ADDRSTATE_UNCONFIGURED ||
+			    ip_state == IP_ADDRSTATE_INVALID ||
+			    ip_state == IP_ADDRSTATE_PREFERRED ||
+			    ip_state == IP_ADDRSTATE_DEPRICATED ||
+			    ip_state == IP_ADDRSTATE_DISABLING)
+				ip_idx[idx] = -1;
+
+		}
+
+		/* Break if all IP states checked */
+		if ((ip_idx[0] == -1) &&
+		    (ip_idx[1] == -1) &&
+		    (ip_idx[2] == -1) &&
+		    (ip_idx[3] == -1))
+			break;
+		schedule_timeout_uninterruptible(HZ);
+	} while (time_after(wtime, jiffies));
+}
+
+void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset)
+{
+	int max_ddbs;
+	int ret;
+	uint32_t idx = 0, next_idx = 0;
+	uint32_t state = 0, conn_err = 0;
+	uint16_t conn_id;
+	struct dev_db_entry *fw_ddb_entry;
+	struct ddb_entry *ddb_entry = NULL;
+	dma_addr_t fw_ddb_dma;
+	struct iscsi_cls_session *cls_sess;
+	struct iscsi_session *sess;
+	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_endpoint *ep;
+	uint16_t cmds_max = 32, tmo = 0;
+	uint32_t initial_cmdsn = 0;
+	struct list_head list_st, list_nt; /* List of sendtargets */
+	struct qla_ddb_index  *st_ddb_idx, *st_ddb_idx_tmp;
+	int fw_idx_size;
+	unsigned long wtime;
+	struct qla_ddb_index  *nt_ddb_idx;
+
+	if (!test_bit(AF_LINK_UP, &ha->flags)) {
+		set_bit(AF_BUILD_DDB_LIST, &ha->flags);
+		ha->is_reset = is_reset;
+		return;
+	}
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+				     MAX_DEV_DB_ENTRIES;
+
+	fw_ddb_entry = dma_pool_alloc(ha->fw_ddb_dma_pool, GFP_KERNEL,
+				      &fw_ddb_dma);
+	if (fw_ddb_entry == NULL) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "Out of memory\n"));
+		goto exit_ddb_list;
+	}
+
+	INIT_LIST_HEAD(&list_st);
+	INIT_LIST_HEAD(&list_nt);
+	fw_idx_size = sizeof(struct qla_ddb_index);
+
+	for (idx = 0; idx < max_ddbs; idx = next_idx) {
+		ret = qla4xxx_get_fwddb_entry(ha, idx, fw_ddb_entry,
+					      fw_ddb_dma, NULL,
+					      &next_idx, &state, &conn_err,
+					      NULL, &conn_id);
+		if (ret == QLA_ERROR)
+			break;
+
+		if (qla4xxx_verify_boot_idx(ha, idx) != QLA_SUCCESS)
+			goto continue_next_st;
+
+		/* Check if ST, add to the list_st */
+		if (strlen((char *) fw_ddb_entry->iscsi_name) != 0)
+			goto continue_next_st;
+
+		st_ddb_idx = vzalloc(fw_idx_size);
+		if (!st_ddb_idx)
+			break;
+
+		st_ddb_idx->fw_ddb_idx = idx;
+
+		list_add_tail(&st_ddb_idx->list, &list_st);
+continue_next_st:
+		if (next_idx == 0)
+			break;
+	}
+
+	/* Before issuing conn open mbox, ensure all IPs states are configured
+	 * Note, conn open fails if IPs are not configured
+	 */
+	qla4xxx_wait_for_ip_configuration(ha);
+
+	/* Go thru the STs and fire the sendtargets by issuing conn open mbx */
+	list_for_each_entry_safe(st_ddb_idx, st_ddb_idx_tmp, &list_st, list) {
+		qla4xxx_conn_open(ha, st_ddb_idx->fw_ddb_idx);
+	}
+
+	/* Wait to ensure all sendtargets are done for min 12 sec wait */
+	tmo = ((ha->def_timeout < LOGIN_TOV) ? LOGIN_TOV : ha->def_timeout);
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "Default time to wait for build ddb %d\n", tmo));
+
+	wtime = jiffies + (HZ * tmo);
+	do {
+		list_for_each_entry_safe(st_ddb_idx, st_ddb_idx_tmp, &list_st,
+					 list) {
+			ret = qla4xxx_get_fwddb_entry(ha,
+						      st_ddb_idx->fw_ddb_idx,
+						      NULL, 0, NULL, &next_idx,
+						      &state, &conn_err, NULL,
+						      NULL);
+			if (ret == QLA_ERROR)
+				continue;
+
+			if (state == DDB_DS_NO_CONNECTION_ACTIVE ||
+			    state == DDB_DS_SESSION_FAILED) {
+				list_del_init(&st_ddb_idx->list);
+				vfree(st_ddb_idx);
+			}
+		}
+		schedule_timeout_uninterruptible(HZ / 10);
+	} while (time_after(wtime, jiffies));
+
+	/* Free up the sendtargets list */
+	list_for_each_entry_safe(st_ddb_idx, st_ddb_idx_tmp, &list_st, list) {
+		list_del_init(&st_ddb_idx->list);
+		vfree(st_ddb_idx);
+	}
+
+	for (idx = 0; idx < max_ddbs; idx = next_idx) {
+		ret = qla4xxx_get_fwddb_entry(ha, idx, fw_ddb_entry,
+					      fw_ddb_dma, NULL,
+					      &next_idx, &state, &conn_err,
+					      NULL, &conn_id);
+		if (ret == QLA_ERROR)
+			break;
+
+		if (qla4xxx_verify_boot_idx(ha, idx) != QLA_SUCCESS)
+			goto continue_next_nt;
+
+		/* Check if NT, then add to list it */
+		if (strlen((char *) fw_ddb_entry->iscsi_name) == 0)
+			goto continue_next_nt;
+
+		if (state == DDB_DS_NO_CONNECTION_ACTIVE ||
+		    state == DDB_DS_SESSION_FAILED) {
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "Adding  DDB to session = 0x%x\n",
+					  idx));
+			if (is_reset == INIT_ADAPTER) {
+				nt_ddb_idx = vmalloc(fw_idx_size);
+				if (!nt_ddb_idx)
+					break;
+
+				nt_ddb_idx->fw_ddb_idx = idx;
+
+				memcpy(&nt_ddb_idx->fw_ddb, fw_ddb_entry,
+				       sizeof(struct dev_db_entry));
+
+				if (qla4xxx_is_flash_ddb_exists(ha, &list_nt,
+						fw_ddb_entry) == QLA_SUCCESS) {
+					vfree(nt_ddb_idx);
+					goto continue_next_nt;
+				}
+				list_add_tail(&nt_ddb_idx->list, &list_nt);
+			} else if (is_reset == RESET_ADAPTER) {
+				if (qla4xxx_is_session_exists(ha,
+						   fw_ddb_entry) == QLA_SUCCESS)
+					goto continue_next_nt;
+			}
+
+			/* Create session object, with INVALID_ENTRY,
+			 * the targer_id would get set when we issue the login
+			 */
+			cls_sess = iscsi_session_setup(&qla4xxx_iscsi_transport,
+						ha->host, cmds_max,
+						sizeof(struct ddb_entry),
+						sizeof(struct ql4_task_data),
+						initial_cmdsn, INVALID_ENTRY);
+			if (!cls_sess)
+				goto exit_ddb_list;
+
+			/*
+			 * iscsi_session_setup increments the driver reference
+			 * count which wouldn't let the driver to be unloaded.
+			 * so calling module_put function to decrement the
+			 * reference count.
+			 **/
+			module_put(qla4xxx_iscsi_transport.owner);
+			sess = cls_sess->dd_data;
+			ddb_entry = sess->dd_data;
+			ddb_entry->sess = cls_sess;
+
+			cls_sess->recovery_tmo = ql4xsess_recovery_tmo;
+			memcpy(&ddb_entry->fw_ddb_entry, fw_ddb_entry,
+			       sizeof(struct dev_db_entry));
+
+			qla4xxx_setup_flash_ddb_entry(ha, ddb_entry);
+
+			cls_conn = iscsi_conn_setup(cls_sess,
+						    sizeof(struct qla_conn),
+						    conn_id);
+			if (!cls_conn)
+				goto exit_ddb_list;
+
+			ddb_entry->conn = cls_conn;
+
+			/* Setup ep, for displaying attributes in sysfs */
+			ep = qla4xxx_get_ep_fwdb(ha, fw_ddb_entry);
+			if (ep) {
+				ep->conn = cls_conn;
+				cls_conn->ep = ep;
+			} else {
+				DEBUG2(ql4_printk(KERN_ERR, ha,
+						  "Unable to get ep\n"));
+			}
+
+			/* Update sess/conn params */
+			qla4xxx_copy_fwddb_param(ha, fw_ddb_entry, cls_sess,
+						 cls_conn);
+
+			if (is_reset == RESET_ADAPTER) {
+				iscsi_block_session(cls_sess);
+				/* Use the relogin path to discover new devices
+				 *  by short-circuting the logic of setting
+				 *  timer to relogin - instead set the flags
+				 *  to initiate login right away.
+				 */
+				set_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags);
+				set_bit(DF_RELOGIN, &ddb_entry->flags);
+			}
+		}
+continue_next_nt:
+		if (next_idx == 0)
+			break;
+	}
+exit_ddb_list:
+	qla4xxx_free_nt_list(&list_nt);
+	if (fw_ddb_entry)
+		dma_pool_free(ha->fw_ddb_dma_pool, fw_ddb_entry, fw_ddb_dma);
+
+	qla4xxx_free_ddb_index(ha);
+}
+
+
 /**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
@@ -3298,7 +4233,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	 * firmware
 	 * NOTE: interrupts enabled upon successful completion
 	 */
-	status = qla4xxx_initialize_adapter(ha);
+	status = qla4xxx_initialize_adapter(ha, INIT_ADAPTER);
 	while ((!test_bit(AF_ONLINE, &ha->flags)) &&
 	    init_retry_count++ < MAX_INIT_RETRIES) {
 
@@ -3319,7 +4254,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 		if (ha->isp_ops->reset_chip(ha) == QLA_ERROR)
 			continue;
 
-		status = qla4xxx_initialize_adapter(ha);
+		status = qla4xxx_initialize_adapter(ha, INIT_ADAPTER);
 	}
 
 	if (!test_bit(AF_ONLINE, &ha->flags)) {
@@ -3386,12 +4321,16 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	       ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
 	       ha->patch_number, ha->build_number);
 
-	qla4xxx_create_chap_list(ha);
-
 	if (qla4xxx_setup_boot_info(ha))
 		ql4_printk(KERN_ERR, ha, "%s:ISCSI boot info setup failed\n",
 			   __func__);
 
+		/* Perform the build ddb list and login to each */
+	qla4xxx_build_ddb_list(ha, INIT_ADAPTER);
+	iscsi_host_for_each_session(ha->host, qla4xxx_login_flash_ddb);
+
+	qla4xxx_create_chap_list(ha);
+
 	qla4xxx_create_ifaces(ha);
 	return 0;
 
@@ -3449,6 +4388,38 @@ static void qla4xxx_prevent_other_port_reinit(struct scsi_qla_host *ha)
 	}
 }
 
+static void qla4xxx_destroy_fw_ddb_session(struct scsi_qla_host *ha)
+{
+	struct ddb_entry *ddb_entry;
+	int options;
+	int idx;
+
+	for (idx = 0; idx < MAX_DDB_ENTRIES; idx++) {
+
+		ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, idx);
+		if ((ddb_entry != NULL) &&
+		    (ddb_entry->ddb_type == FLASH_DDB)) {
+
+			options = LOGOUT_OPTION_CLOSE_SESSION;
+			if (qla4xxx_session_logout_ddb(ha, ddb_entry, options)
+			    == QLA_ERROR)
+				ql4_printk(KERN_ERR, ha, "%s: Logout failed\n",
+					   __func__);
+
+			qla4xxx_clear_ddb_entry(ha, ddb_entry->fw_ddb_index);
+			/*
+			 * we have decremented the reference count of the driver
+			 * when we setup the session to have the driver unload
+			 * to be seamless without actually destroying the
+			 * session
+			 **/
+			try_module_get(qla4xxx_iscsi_transport.owner);
+			iscsi_destroy_endpoint(ddb_entry->conn->ep);
+			qla4xxx_free_ddb(ha, ddb_entry);
+			iscsi_session_teardown(ddb_entry->sess);
+		}
+	}
+}
 /**
  * qla4xxx_remove_adapter - calback function to remove adapter.
  * @pci_dev: PCI device pointer
@@ -3465,9 +4436,11 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
 	/* destroy iface from sysfs */
 	qla4xxx_destroy_ifaces(ha);
 
-	if (ha->boot_kset)
+	if ((!ql4xdisablesysfsboot) && ha->boot_kset)
 		iscsi_boot_destroy_kset(ha->boot_kset);
 
+	qla4xxx_destroy_fw_ddb_session(ha);
+
 	scsi_remove_host(ha->host);
 
 	qla4xxx_free_adapter(ha);
@@ -4115,7 +5088,7 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 
 		qla4_8xxx_idc_unlock(ha);
 		clear_bit(AF_FW_RECOVERY, &ha->flags);
-		rval = qla4xxx_initialize_adapter(ha);
+		rval = qla4xxx_initialize_adapter(ha, RESET_ADAPTER);
 		qla4_8xxx_idc_lock(ha);
 
 		if (rval != QLA_SUCCESS) {
@@ -4151,7 +5124,7 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 		if ((qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE) ==
 		    QLA82XX_DEV_READY)) {
 			clear_bit(AF_FW_RECOVERY, &ha->flags);
-			rval = qla4xxx_initialize_adapter(ha);
+			rval = qla4xxx_initialize_adapter(ha, RESET_ADAPTER);
 			if (rval == QLA_SUCCESS) {
 				ret = qla4xxx_request_irqs(ha);
 				if (ret) {
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index c15347d..5254e57 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,4 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.02.00-k8"
+#define QLA4XXX_DRIVER_VERSION	"5.02.00-k9"
-- 
1.7.6

