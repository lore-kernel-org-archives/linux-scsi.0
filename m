From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/5] qla4xxx: cleanup, make qla4xxx_build_ddb_list short
Date: Fri, 16 Dec 2011 01:58:55 -0800
Message-ID: <1324029539-26021-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:30376
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753751Ab1LPKNG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 05:13:06 -0500
In-Reply-To: <1324029539-26021-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Make qla4xxx_build_ddb_list shorter by adding more helper functions.

JIRA Key: UPSISCSI-211

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |  399 ++++++++++++++++++++++++-----------------
 1 files changed, 237 insertions(+), 162 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 70778d5..3642f1f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2078,7 +2078,7 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 	}
 }
 
-void qla4xxx_check_relogin_flash_ddb(struct iscsi_cls_session *cls_sess)
+static void qla4xxx_check_relogin_flash_ddb(struct iscsi_cls_session *cls_sess)
 {
 	struct iscsi_session *sess;
 	struct ddb_entry *ddb_entry;
@@ -3826,16 +3826,14 @@ exit_check:
 	return ret;
 }
 
-static void qla4xxx_free_nt_list(struct list_head *list_nt)
+static void qla4xxx_free_ddb_list(struct list_head *list_ddb)
 {
-	struct qla_ddb_index  *nt_ddb_idx, *nt_ddb_idx_tmp;
+	struct qla_ddb_index  *ddb_idx, *ddb_idx_tmp;
 
-	/* Free up the normaltargets list */
-	list_for_each_entry_safe(nt_ddb_idx, nt_ddb_idx_tmp, list_nt, list) {
-		list_del_init(&nt_ddb_idx->list);
-		vfree(nt_ddb_idx);
+	list_for_each_entry_safe(ddb_idx, ddb_idx_tmp, list_ddb, list) {
+		list_del_init(&ddb_idx->list);
+		vfree(ddb_idx);
 	}
-
 }
 
 static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
@@ -3934,7 +3932,6 @@ static void qla4xxx_wait_for_ip_configuration(struct scsi_qla_host *ha)
 			    ip_state == IP_ADDRSTATE_DEPRICATED ||
 			    ip_state == IP_ADDRSTATE_DISABLING)
 				ip_idx[idx] = -1;
-
 		}
 
 		/* Break if all IP states checked */
@@ -3947,52 +3944,34 @@ static void qla4xxx_wait_for_ip_configuration(struct scsi_qla_host *ha)
 	} while (time_after(wtime, jiffies));
 }
 
-void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset)
+static void qla4xxx_build_st_list(struct scsi_qla_host *ha,
+				  struct list_head *list_st)
 {
+	struct qla_ddb_index  *st_ddb_idx;
 	int max_ddbs;
+	int fw_idx_size;
+	struct dev_db_entry *fw_ddb_entry;
+	dma_addr_t fw_ddb_dma;
 	int ret;
 	uint32_t idx = 0, next_idx = 0;
 	uint32_t state = 0, conn_err = 0;
-	uint16_t conn_id;
-	struct dev_db_entry *fw_ddb_entry;
-	struct ddb_entry *ddb_entry = NULL;
-	dma_addr_t fw_ddb_dma;
-	struct iscsi_cls_session *cls_sess;
-	struct iscsi_session *sess;
-	struct iscsi_cls_conn *cls_conn;
-	struct iscsi_endpoint *ep;
-	uint16_t cmds_max = 32, tmo = 0;
-	uint32_t initial_cmdsn = 0;
-	struct list_head list_st, list_nt; /* List of sendtargets */
-	struct qla_ddb_index  *st_ddb_idx, *st_ddb_idx_tmp;
-	int fw_idx_size;
-	unsigned long wtime;
-	struct qla_ddb_index  *nt_ddb_idx;
-
-	if (!test_bit(AF_LINK_UP, &ha->flags)) {
-		set_bit(AF_BUILD_DDB_LIST, &ha->flags);
-		ha->is_reset = is_reset;
-		return;
-	}
-	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
-				     MAX_DEV_DB_ENTRIES;
+	uint16_t conn_id = 0;
 
 	fw_ddb_entry = dma_pool_alloc(ha->fw_ddb_dma_pool, GFP_KERNEL,
 				      &fw_ddb_dma);
 	if (fw_ddb_entry == NULL) {
 		DEBUG2(ql4_printk(KERN_ERR, ha, "Out of memory\n"));
-		goto exit_ddb_list;
+		goto exit_st_list;
 	}
 
-	INIT_LIST_HEAD(&list_st);
-	INIT_LIST_HEAD(&list_nt);
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+				     MAX_DEV_DB_ENTRIES;
 	fw_idx_size = sizeof(struct qla_ddb_index);
 
 	for (idx = 0; idx < max_ddbs; idx = next_idx) {
-		ret = qla4xxx_get_fwddb_entry(ha, idx, fw_ddb_entry,
-					      fw_ddb_dma, NULL,
-					      &next_idx, &state, &conn_err,
-					      NULL, &conn_id);
+		ret = qla4xxx_get_fwddb_entry(ha, idx, fw_ddb_entry, fw_ddb_dma,
+					      NULL, &next_idx, &state,
+					      &conn_err, NULL, &conn_id);
 		if (ret == QLA_ERROR)
 			break;
 
@@ -4009,59 +3988,155 @@ void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset)
 
 		st_ddb_idx->fw_ddb_idx = idx;
 
-		list_add_tail(&st_ddb_idx->list, &list_st);
+		list_add_tail(&st_ddb_idx->list, list_st);
 continue_next_st:
 		if (next_idx == 0)
 			break;
 	}
 
-	/* Before issuing conn open mbox, ensure all IPs states are configured
-	 * Note, conn open fails if IPs are not configured
+exit_st_list:
+	if (fw_ddb_entry)
+		dma_pool_free(ha->fw_ddb_dma_pool, fw_ddb_entry, fw_ddb_dma);
+}
+
+/**
+ * qla4xxx_remove_failed_ddb - Remove inactive or failed ddb from list
+ * @ha: pointer to adapter structure
+ * @list_ddb: List from which failed ddb to be removed
+ *
+ * Iterate over the list of DDBs and find and remove DDBs that are either in
+ * no connection active state or failed state
+ **/
+static void qla4xxx_remove_failed_ddb(struct scsi_qla_host *ha,
+				      struct list_head *list_ddb)
+{
+	struct qla_ddb_index  *ddb_idx, *ddb_idx_tmp;
+	uint32_t next_idx = 0;
+	uint32_t state = 0, conn_err = 0;
+	int ret;
+
+	list_for_each_entry_safe(ddb_idx, ddb_idx_tmp, list_ddb, list) {
+		ret = qla4xxx_get_fwddb_entry(ha, ddb_idx->fw_ddb_idx,
+					      NULL, 0, NULL, &next_idx, &state,
+					      &conn_err, NULL, NULL);
+		if (ret == QLA_ERROR)
+			continue;
+
+		if (state == DDB_DS_NO_CONNECTION_ACTIVE ||
+		    state == DDB_DS_SESSION_FAILED) {
+			list_del_init(&ddb_idx->list);
+			vfree(ddb_idx);
+		}
+	}
+}
+
+static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
+				   struct dev_db_entry *fw_ddb_entry,
+				   int is_reset)
+{
+	struct iscsi_cls_session *cls_sess;
+	struct iscsi_session *sess;
+	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_endpoint *ep;
+	uint16_t cmds_max = 32;
+	uint16_t conn_id = 0;
+	uint32_t initial_cmdsn = 0;
+	int ret = QLA_SUCCESS;
+
+	struct ddb_entry *ddb_entry = NULL;
+
+	/* Create session object, with INVALID_ENTRY,
+	 * the targer_id would get set when we issue the login
 	 */
-	qla4xxx_wait_for_ip_configuration(ha);
+	cls_sess = iscsi_session_setup(&qla4xxx_iscsi_transport, ha->host,
+				       cmds_max, sizeof(struct ddb_entry),
+				       sizeof(struct ql4_task_data),
+				       initial_cmdsn, INVALID_ENTRY);
+	if (!cls_sess) {
+		ret = QLA_ERROR;
+		goto exit_setup;
+	}
 
-	/* Go thru the STs and fire the sendtargets by issuing conn open mbx */
-	list_for_each_entry_safe(st_ddb_idx, st_ddb_idx_tmp, &list_st, list) {
-		qla4xxx_conn_open(ha, st_ddb_idx->fw_ddb_idx);
+	/*
+	 * so calling module_put function to decrement the
+	 * reference count.
+	 **/
+	module_put(qla4xxx_iscsi_transport.owner);
+	sess = cls_sess->dd_data;
+	ddb_entry = sess->dd_data;
+	ddb_entry->sess = cls_sess;
+
+	cls_sess->recovery_tmo = ql4xsess_recovery_tmo;
+	memcpy(&ddb_entry->fw_ddb_entry, fw_ddb_entry,
+	       sizeof(struct dev_db_entry));
+
+	qla4xxx_setup_flash_ddb_entry(ha, ddb_entry);
+
+	cls_conn = iscsi_conn_setup(cls_sess, sizeof(struct qla_conn), conn_id);
+
+	if (!cls_conn) {
+		ret = QLA_ERROR;
+		goto exit_setup;
 	}
 
-	/* Wait to ensure all sendtargets are done for min 12 sec wait */
-	tmo = ((ha->def_timeout < LOGIN_TOV) ? LOGIN_TOV : ha->def_timeout);
-	DEBUG2(ql4_printk(KERN_INFO, ha,
-			  "Default time to wait for build ddb %d\n", tmo));
+	ddb_entry->conn = cls_conn;
 
-	wtime = jiffies + (HZ * tmo);
-	do {
-		list_for_each_entry_safe(st_ddb_idx, st_ddb_idx_tmp, &list_st,
-					 list) {
-			ret = qla4xxx_get_fwddb_entry(ha,
-						      st_ddb_idx->fw_ddb_idx,
-						      NULL, 0, NULL, &next_idx,
-						      &state, &conn_err, NULL,
-						      NULL);
-			if (ret == QLA_ERROR)
-				continue;
+	/* Setup ep, for displaying attributes in sysfs */
+	ep = qla4xxx_get_ep_fwdb(ha, fw_ddb_entry);
+	if (ep) {
+		ep->conn = cls_conn;
+		cls_conn->ep = ep;
+	} else {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "Unable to get ep\n"));
+		ret = QLA_ERROR;
+		goto exit_setup;
+	}
 
-			if (state == DDB_DS_NO_CONNECTION_ACTIVE ||
-			    state == DDB_DS_SESSION_FAILED) {
-				list_del_init(&st_ddb_idx->list);
-				vfree(st_ddb_idx);
-			}
-		}
-		schedule_timeout_uninterruptible(HZ / 10);
-	} while (time_after(wtime, jiffies));
+	/* Update sess/conn params */
+	qla4xxx_copy_fwddb_param(ha, fw_ddb_entry, cls_sess, cls_conn);
 
-	/* Free up the sendtargets list */
-	list_for_each_entry_safe(st_ddb_idx, st_ddb_idx_tmp, &list_st, list) {
-		list_del_init(&st_ddb_idx->list);
-		vfree(st_ddb_idx);
+	if (is_reset == RESET_ADAPTER) {
+		iscsi_block_session(cls_sess);
+		/* Use the relogin path to discover new devices
+		 *  by short-circuting the logic of setting
+		 *  timer to relogin - instead set the flags
+		 *  to initiate login right away.
+		 */
+		set_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags);
+		set_bit(DF_RELOGIN, &ddb_entry->flags);
 	}
 
+exit_setup:
+	return ret;
+}
+
+static void qla4xxx_build_nt_list(struct scsi_qla_host *ha,
+				  struct list_head *list_nt, int is_reset)
+{
+	struct dev_db_entry *fw_ddb_entry;
+	dma_addr_t fw_ddb_dma;
+	int max_ddbs;
+	int fw_idx_size;
+	int ret;
+	uint32_t idx = 0, next_idx = 0;
+	uint32_t state = 0, conn_err = 0;
+	uint16_t conn_id = 0;
+	struct qla_ddb_index  *nt_ddb_idx;
+
+	fw_ddb_entry = dma_pool_alloc(ha->fw_ddb_dma_pool, GFP_KERNEL,
+				      &fw_ddb_dma);
+	if (fw_ddb_entry == NULL) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "Out of memory\n"));
+		goto exit_nt_list;
+	}
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+				     MAX_DEV_DB_ENTRIES;
+	fw_idx_size = sizeof(struct qla_ddb_index);
+
 	for (idx = 0; idx < max_ddbs; idx = next_idx) {
-		ret = qla4xxx_get_fwddb_entry(ha, idx, fw_ddb_entry,
-					      fw_ddb_dma, NULL,
-					      &next_idx, &state, &conn_err,
-					      NULL, &conn_id);
+		ret = qla4xxx_get_fwddb_entry(ha, idx, fw_ddb_entry, fw_ddb_dma,
+					      NULL, &next_idx, &state,
+					      &conn_err, NULL, &conn_id);
 		if (ret == QLA_ERROR)
 			break;
 
@@ -4072,107 +4147,107 @@ continue_next_st:
 		if (strlen((char *) fw_ddb_entry->iscsi_name) == 0)
 			goto continue_next_nt;
 
-		if (state == DDB_DS_NO_CONNECTION_ACTIVE ||
-		    state == DDB_DS_SESSION_FAILED) {
-			DEBUG2(ql4_printk(KERN_INFO, ha,
-					  "Adding  DDB to session = 0x%x\n",
-					  idx));
-			if (is_reset == INIT_ADAPTER) {
-				nt_ddb_idx = vmalloc(fw_idx_size);
-				if (!nt_ddb_idx)
-					break;
-
-				nt_ddb_idx->fw_ddb_idx = idx;
-
-				memcpy(&nt_ddb_idx->fw_ddb, fw_ddb_entry,
-				       sizeof(struct dev_db_entry));
-
-				if (qla4xxx_is_flash_ddb_exists(ha, &list_nt,
-						fw_ddb_entry) == QLA_SUCCESS) {
-					vfree(nt_ddb_idx);
-					goto continue_next_nt;
-				}
-				list_add_tail(&nt_ddb_idx->list, &list_nt);
-			} else if (is_reset == RESET_ADAPTER) {
-				if (qla4xxx_is_session_exists(ha,
-						   fw_ddb_entry) == QLA_SUCCESS)
-					goto continue_next_nt;
-			}
+		if (!(state == DDB_DS_NO_CONNECTION_ACTIVE ||
+		    state == DDB_DS_SESSION_FAILED))
+			goto continue_next_nt;
 
-			/* Create session object, with INVALID_ENTRY,
-			 * the targer_id would get set when we issue the login
-			 */
-			cls_sess = iscsi_session_setup(&qla4xxx_iscsi_transport,
-						ha->host, cmds_max,
-						sizeof(struct ddb_entry),
-						sizeof(struct ql4_task_data),
-						initial_cmdsn, INVALID_ENTRY);
-			if (!cls_sess)
-				goto exit_ddb_list;
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "Adding  DDB to session = 0x%x\n", idx));
+		if (is_reset == INIT_ADAPTER) {
+			nt_ddb_idx = vmalloc(fw_idx_size);
+			if (!nt_ddb_idx)
+				break;
 
-			/*
-			 * iscsi_session_setup increments the driver reference
-			 * count which wouldn't let the driver to be unloaded.
-			 * so calling module_put function to decrement the
-			 * reference count.
-			 **/
-			module_put(qla4xxx_iscsi_transport.owner);
-			sess = cls_sess->dd_data;
-			ddb_entry = sess->dd_data;
-			ddb_entry->sess = cls_sess;
+			nt_ddb_idx->fw_ddb_idx = idx;
 
-			cls_sess->recovery_tmo = ql4xsess_recovery_tmo;
-			memcpy(&ddb_entry->fw_ddb_entry, fw_ddb_entry,
+			memcpy(&nt_ddb_idx->fw_ddb, fw_ddb_entry,
 			       sizeof(struct dev_db_entry));
 
-			qla4xxx_setup_flash_ddb_entry(ha, ddb_entry);
-
-			cls_conn = iscsi_conn_setup(cls_sess,
-						    sizeof(struct qla_conn),
-						    conn_id);
-			if (!cls_conn)
-				goto exit_ddb_list;
-
-			ddb_entry->conn = cls_conn;
-
-			/* Setup ep, for displaying attributes in sysfs */
-			ep = qla4xxx_get_ep_fwdb(ha, fw_ddb_entry);
-			if (ep) {
-				ep->conn = cls_conn;
-				cls_conn->ep = ep;
-			} else {
-				DEBUG2(ql4_printk(KERN_ERR, ha,
-						  "Unable to get ep\n"));
-			}
-
-			/* Update sess/conn params */
-			qla4xxx_copy_fwddb_param(ha, fw_ddb_entry, cls_sess,
-						 cls_conn);
-
-			if (is_reset == RESET_ADAPTER) {
-				iscsi_block_session(cls_sess);
-				/* Use the relogin path to discover new devices
-				 *  by short-circuting the logic of setting
-				 *  timer to relogin - instead set the flags
-				 *  to initiate login right away.
-				 */
-				set_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags);
-				set_bit(DF_RELOGIN, &ddb_entry->flags);
+			if (qla4xxx_is_flash_ddb_exists(ha, list_nt,
+					fw_ddb_entry) == QLA_SUCCESS) {
+				vfree(nt_ddb_idx);
+				goto continue_next_nt;
 			}
+			list_add_tail(&nt_ddb_idx->list, list_nt);
+		} else if (is_reset == RESET_ADAPTER) {
+			if (qla4xxx_is_session_exists(ha, fw_ddb_entry) ==
+								QLA_SUCCESS)
+				goto continue_next_nt;
 		}
+
+		ret = qla4xxx_sess_conn_setup(ha, fw_ddb_entry, is_reset);
+		if (ret == QLA_ERROR)
+			goto exit_nt_list;
+
 continue_next_nt:
 		if (next_idx == 0)
 			break;
 	}
-exit_ddb_list:
-	qla4xxx_free_nt_list(&list_nt);
+
+exit_nt_list:
 	if (fw_ddb_entry)
 		dma_pool_free(ha->fw_ddb_dma_pool, fw_ddb_entry, fw_ddb_dma);
+}
+
+/**
+ * qla4xxx_build_ddb_list - Build ddb list and setup sessions
+ * @ha: pointer to adapter structure
+ * @is_reset: Is this init path or reset path
+ *
+ * Create a list of sendtargets (st) from firmware DDBs, issue send targets
+ * using connection open, then create the list of normal targets (nt)
+ * from firmware DDBs. Based on the list of nt setup session and connection
+ * objects.
+ **/
+void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset)
+{
+	uint16_t tmo = 0;
+	struct list_head list_st, list_nt;
+	struct qla_ddb_index  *st_ddb_idx, *st_ddb_idx_tmp;
+	unsigned long wtime;
+
+	if (!test_bit(AF_LINK_UP, &ha->flags)) {
+		set_bit(AF_BUILD_DDB_LIST, &ha->flags);
+		ha->is_reset = is_reset;
+		return;
+	}
+
+	INIT_LIST_HEAD(&list_st);
+	INIT_LIST_HEAD(&list_nt);
+
+	qla4xxx_build_st_list(ha, &list_st);
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
+		qla4xxx_remove_failed_ddb(ha, &list_st);
+		schedule_timeout_uninterruptible(HZ / 10);
+	} while (time_after(wtime, jiffies));
+
+	/* Free up the sendtargets list */
+	qla4xxx_free_ddb_list(&list_st);
+
+	qla4xxx_build_nt_list(ha, &list_nt, is_reset);
+
+	qla4xxx_free_ddb_list(&list_nt);
 
 	qla4xxx_free_ddb_index(ha);
 }
 
-
 /**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
-- 
1.7.1


