From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH] qla4xxx: correctly update session discovery_parent_idx.
Date: Tue, 17 Sep 2013 07:30:02 -0400
Message-ID: <1379417402-32638-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:11035 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656Ab3IQMAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 08:00:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Earlier logic for driver created iscsi_session->discovery_parent_idx
was to store ram index of a sendtarget entry, but driver frees
sendtarget ram index as soon as firmware is done with discovery,
which is available for further use. So changing the logic to point
iscsi_session->discovery_parent_idx to store sendtarget flashnode index.

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |   1 +
 drivers/scsi/qla4xxx/ql4_os.c  | 199 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 181 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 41327d4..084d1fd 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -306,6 +306,7 @@ struct ddb_entry {
 struct qla_ddb_index {
 	struct list_head list;
 	uint16_t fw_ddb_idx;
+	uint16_t flash_ddb_idx;
 	struct dev_db_entry fw_ddb;
 	uint8_t flash_isid[6];
 };
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f8a0a26..a8847a3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2373,11 +2373,6 @@ static void qla4xxx_copy_to_sess_conn_params(struct iscsi_conn *conn,
 	COPY_ISID(sess->isid, fw_ddb_entry->isid);
 
 	ddb_link = le16_to_cpu(fw_ddb_entry->ddb_link);
-	if (ddb_link < MAX_DDB_ENTRIES)
-		sess->discovery_parent_idx = ddb_link;
-	else
-		sess->discovery_parent_idx = DDB_NO_LINK;
-
 	if (ddb_link == DDB_ISNS)
 		disc_parent = ISCSI_DISC_PARENT_ISNS;
 	else if (ddb_link == DDB_NO_LINK)
@@ -4937,7 +4932,8 @@ static int qla4xxx_compare_tuple_ddb(struct scsi_qla_host *ha,
 }
 
 static int qla4xxx_is_session_exists(struct scsi_qla_host *ha,
-				     struct dev_db_entry *fw_ddb_entry)
+				     struct dev_db_entry *fw_ddb_entry,
+				     uint32_t *index)
 {
 	struct ddb_entry *ddb_entry;
 	struct ql4_tuple_ddb *fw_tddb = NULL;
@@ -4971,6 +4967,8 @@ static int qla4xxx_is_session_exists(struct scsi_qla_host *ha,
 		qla4xxx_get_param_ddb(ddb_entry, tmp_tddb);
 		if (!qla4xxx_compare_tuple_ddb(ha, fw_tddb, tmp_tddb, false)) {
 			ret = QLA_SUCCESS; /* found */
+			if (index != NULL)
+				*index = idx;
 			goto exit_check;
 		}
 	}
@@ -5267,6 +5265,87 @@ static void qla4xxx_wait_for_ip_configuration(struct scsi_qla_host *ha)
 	} while (time_after(wtime, jiffies));
 }
 
+static int qla4xxx_cmp_fw_stentry(struct dev_db_entry *fw_ddb_entry,
+				  struct dev_db_entry *flash_ddb_entry)
+{
+	uint16_t options = 0;
+	size_t ip_len = IP_ADDR_LEN;
+
+	options = le16_to_cpu(fw_ddb_entry->options);
+	if (options & DDB_OPT_IPV6_DEVICE)
+		ip_len = IPv6_ADDR_LEN;
+
+	if (memcmp(fw_ddb_entry->ip_addr, flash_ddb_entry->ip_addr, ip_len))
+		return QLA_ERROR;
+
+	if (memcmp(&fw_ddb_entry->isid[0], &flash_ddb_entry->isid[0],
+		   sizeof(fw_ddb_entry->isid)))
+		return QLA_ERROR;
+
+	if (memcmp(&fw_ddb_entry->port, &flash_ddb_entry->port,
+		   sizeof(fw_ddb_entry->port)))
+		return QLA_ERROR;
+
+	return QLA_SUCCESS;
+}
+
+static int qla4xxx_find_flash_st_idx(struct scsi_qla_host *ha,
+				     struct dev_db_entry *fw_ddb_entry,
+				     uint32_t fw_idx, uint32_t *flash_index)
+{
+	struct dev_db_entry *flash_ddb_entry;
+	dma_addr_t flash_ddb_entry_dma;
+	uint32_t idx = 0;
+	int max_ddbs;
+	int ret = QLA_ERROR, status;
+
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+				     MAX_DEV_DB_ENTRIES;
+
+	flash_ddb_entry = dma_pool_alloc(ha->fw_ddb_dma_pool, GFP_KERNEL,
+					 &flash_ddb_entry_dma);
+	if (flash_ddb_entry == NULL || fw_ddb_entry == NULL) {
+		ql4_printk(KERN_ERR, ha, "Out of memory\n");
+		goto exit_find_st_idx;
+	}
+
+	status = qla4xxx_flashdb_by_index(ha, flash_ddb_entry,
+					  flash_ddb_entry_dma, fw_idx);
+	if (status == QLA_SUCCESS) {
+		status = qla4xxx_cmp_fw_stentry(fw_ddb_entry, flash_ddb_entry);
+		if (status == QLA_SUCCESS) {
+			*flash_index = fw_idx;
+			ret = QLA_SUCCESS;
+			goto exit_find_st_idx;
+		}
+	}
+
+	for (idx = 0; idx < max_ddbs; idx++) {
+		status = qla4xxx_flashdb_by_index(ha, flash_ddb_entry,
+						  flash_ddb_entry_dma, idx);
+		if (status == QLA_ERROR)
+			continue;
+
+		status = qla4xxx_cmp_fw_stentry(fw_ddb_entry, flash_ddb_entry);
+		if (status == QLA_SUCCESS) {
+			*flash_index = idx;
+			ret = QLA_SUCCESS;
+			goto exit_find_st_idx;
+		}
+	}
+
+	if (idx == max_ddbs)
+		ql4_printk(KERN_ERR, ha, "Failed to find ST [%d] in flash\n",
+			   fw_idx);
+
+exit_find_st_idx:
+	if (flash_ddb_entry)
+		dma_pool_free(ha->fw_ddb_dma_pool, flash_ddb_entry,
+			      flash_ddb_entry_dma);
+
+	return ret;
+}
+
 static void qla4xxx_build_st_list(struct scsi_qla_host *ha,
 				  struct list_head *list_st)
 {
@@ -5278,6 +5357,7 @@ static void qla4xxx_build_st_list(struct scsi_qla_host *ha,
 	int ret;
 	uint32_t idx = 0, next_idx = 0;
 	uint32_t state = 0, conn_err = 0;
+	uint32_t flash_index = -1;
 	uint16_t conn_id = 0;
 
 	fw_ddb_entry = dma_pool_alloc(ha->fw_ddb_dma_pool, GFP_KERNEL,
@@ -5310,6 +5390,19 @@ static void qla4xxx_build_st_list(struct scsi_qla_host *ha,
 		if (!st_ddb_idx)
 			break;
 
+		ret = qla4xxx_find_flash_st_idx(ha, fw_ddb_entry, idx,
+						&flash_index);
+		if (ret == QLA_ERROR) {
+			ql4_printk(KERN_ERR, ha,
+				   "No flash entry for ST at idx [%d]\n", idx);
+			st_ddb_idx->flash_ddb_idx = idx;
+		} else {
+			ql4_printk(KERN_INFO, ha,
+				   "ST at idx [%d] is stored at flash [%d]\n",
+				   idx, flash_index);
+			st_ddb_idx->flash_ddb_idx = flash_index;
+		}
+
 		st_ddb_idx->fw_ddb_idx = idx;
 
 		list_add_tail(&st_ddb_idx->list, list_st);
@@ -5354,6 +5447,28 @@ static void qla4xxx_remove_failed_ddb(struct scsi_qla_host *ha,
 	}
 }
 
+static void qla4xxx_update_sess_disc_idx(struct scsi_qla_host *ha,
+					 struct ddb_entry *ddb_entry,
+					 struct dev_db_entry *fw_ddb_entry)
+{
+	struct iscsi_cls_session *cls_sess;
+	struct iscsi_session *sess;
+	uint32_t max_ddbs = 0;
+	uint16_t ddb_link = -1;
+
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+				     MAX_DEV_DB_ENTRIES;
+
+	cls_sess = ddb_entry->sess;
+	sess = cls_sess->dd_data;
+
+	ddb_link = le16_to_cpu(fw_ddb_entry->ddb_link);
+	if (ddb_link < max_ddbs)
+		sess->discovery_parent_idx = ddb_link;
+	else
+		sess->discovery_parent_idx = DDB_NO_LINK;
+}
+
 static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
 				   struct dev_db_entry *fw_ddb_entry,
 				   int is_reset, uint16_t idx)
@@ -5418,6 +5533,7 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
 
 	/* Update sess/conn params */
 	qla4xxx_copy_fwddb_param(ha, fw_ddb_entry, cls_sess, cls_conn);
+	qla4xxx_update_sess_disc_idx(ha, ddb_entry, fw_ddb_entry);
 
 	if (is_reset == RESET_ADAPTER) {
 		iscsi_block_session(cls_sess);
@@ -5434,17 +5550,43 @@ exit_setup:
 	return ret;
 }
 
+static void qla4xxx_update_fw_ddb_link(struct scsi_qla_host *ha,
+				       struct list_head *list_ddb,
+				       struct dev_db_entry *fw_ddb_entry)
+{
+	struct qla_ddb_index  *ddb_idx, *ddb_idx_tmp;
+	uint16_t ddb_link;
+
+	ddb_link = le16_to_cpu(fw_ddb_entry->ddb_link);
+
+	list_for_each_entry_safe(ddb_idx, ddb_idx_tmp, list_ddb, list) {
+		if (ddb_idx->fw_ddb_idx == ddb_link) {
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "Updating NT parent idx from [%d] to [%d]\n",
+					  ddb_link, ddb_idx->flash_ddb_idx));
+			fw_ddb_entry->ddb_link =
+					    cpu_to_le16(ddb_idx->flash_ddb_idx);
+			return;
+		}
+	}
+}
+
 static void qla4xxx_build_nt_list(struct scsi_qla_host *ha,
-				  struct list_head *list_nt, int is_reset)
+				  struct list_head *list_nt,
+				  struct list_head *list_st,
+				  int is_reset)
 {
 	struct dev_db_entry *fw_ddb_entry;
+	struct ddb_entry *ddb_entry = NULL;
 	dma_addr_t fw_ddb_dma;
 	int max_ddbs;
 	int fw_idx_size;
 	int ret;
 	uint32_t idx = 0, next_idx = 0;
 	uint32_t state = 0, conn_err = 0;
+	uint32_t ddb_idx = -1;
 	uint16_t conn_id = 0;
+	uint16_t ddb_link = -1;
 	struct qla_ddb_index  *nt_ddb_idx;
 
 	fw_ddb_entry = dma_pool_alloc(ha->fw_ddb_dma_pool, GFP_KERNEL,
@@ -5471,12 +5613,18 @@ static void qla4xxx_build_nt_list(struct scsi_qla_host *ha,
 		if (strlen((char *) fw_ddb_entry->iscsi_name) == 0)
 			goto continue_next_nt;
 
+		ddb_link = le16_to_cpu(fw_ddb_entry->ddb_link);
+		if (ddb_link < max_ddbs)
+			qla4xxx_update_fw_ddb_link(ha, list_st, fw_ddb_entry);
+
 		if (!(state == DDB_DS_NO_CONNECTION_ACTIVE ||
-		    state == DDB_DS_SESSION_FAILED))
+		    state == DDB_DS_SESSION_FAILED) &&
+		    (is_reset == INIT_ADAPTER))
 			goto continue_next_nt;
 
 		DEBUG2(ql4_printk(KERN_INFO, ha,
 				  "Adding  DDB to session = 0x%x\n", idx));
+
 		if (is_reset == INIT_ADAPTER) {
 			nt_ddb_idx = vmalloc(fw_idx_size);
 			if (!nt_ddb_idx)
@@ -5506,9 +5654,17 @@ static void qla4xxx_build_nt_list(struct scsi_qla_host *ha,
 
 			list_add_tail(&nt_ddb_idx->list, list_nt);
 		} else if (is_reset == RESET_ADAPTER) {
-			if (qla4xxx_is_session_exists(ha, fw_ddb_entry) ==
-								QLA_SUCCESS)
+			ret = qla4xxx_is_session_exists(ha, fw_ddb_entry,
+							&ddb_idx);
+			if (ret == QLA_SUCCESS) {
+				ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha,
+								       ddb_idx);
+				if (ddb_entry != NULL)
+					qla4xxx_update_sess_disc_idx(ha,
+								     ddb_entry,
+								  fw_ddb_entry);
 				goto continue_next_nt;
+			}
 		}
 
 		ret = qla4xxx_sess_conn_setup(ha, fw_ddb_entry, is_reset, idx);
@@ -5526,7 +5682,8 @@ exit_nt_list:
 }
 
 static void qla4xxx_build_new_nt_list(struct scsi_qla_host *ha,
-				      struct list_head *list_nt)
+				      struct list_head *list_nt,
+				      uint16_t target_id)
 {
 	struct dev_db_entry *fw_ddb_entry;
 	dma_addr_t fw_ddb_dma;
@@ -5571,13 +5728,16 @@ static void qla4xxx_build_new_nt_list(struct scsi_qla_host *ha,
 
 		nt_ddb_idx->fw_ddb_idx = idx;
 
-		ret = qla4xxx_is_session_exists(ha, fw_ddb_entry);
+		ret = qla4xxx_is_session_exists(ha, fw_ddb_entry, NULL);
 		if (ret == QLA_SUCCESS) {
 			/* free nt_ddb_idx and do not add to list_nt */
 			vfree(nt_ddb_idx);
 			goto continue_next_new_nt;
 		}
 
+		if (target_id < max_ddbs)
+			fw_ddb_entry->ddb_link = cpu_to_le16(target_id);
+
 		list_add_tail(&nt_ddb_idx->list, list_nt);
 
 		ret = qla4xxx_sess_conn_setup(ha, fw_ddb_entry, RESET_ADAPTER,
@@ -5894,7 +6054,8 @@ exit_ddb_conn_open:
 }
 
 static int qla4xxx_ddb_login_st(struct scsi_qla_host *ha,
-				struct dev_db_entry *fw_ddb_entry)
+				struct dev_db_entry *fw_ddb_entry,
+				uint16_t target_id)
 {
 	struct qla_ddb_index *ddb_idx, *ddb_idx_tmp;
 	struct list_head list_nt;
@@ -5919,7 +6080,7 @@ static int qla4xxx_ddb_login_st(struct scsi_qla_host *ha,
 	if (ret == QLA_ERROR)
 		goto exit_login_st;
 
-	qla4xxx_build_new_nt_list(ha, &list_nt);
+	qla4xxx_build_new_nt_list(ha, &list_nt, target_id);
 
 	list_for_each_entry_safe(ddb_idx, ddb_idx_tmp, &list_nt, list) {
 		list_del_init(&ddb_idx->list);
@@ -5946,7 +6107,7 @@ static int qla4xxx_ddb_login_nt(struct scsi_qla_host *ha,
 {
 	int ret = QLA_ERROR;
 
-	ret = qla4xxx_is_session_exists(ha, fw_ddb_entry);
+	ret = qla4xxx_is_session_exists(ha, fw_ddb_entry, NULL);
 	if (ret != QLA_SUCCESS)
 		ret = qla4xxx_sess_conn_setup(ha, fw_ddb_entry, RESET_ADAPTER,
 					      idx);
@@ -6001,7 +6162,8 @@ static int qla4xxx_sysfs_ddb_login(struct iscsi_bus_flash_session *fnode_sess,
 	fw_ddb_entry->cookie = DDB_VALID_COOKIE;
 
 	if (strlen((char *)fw_ddb_entry->iscsi_name) == 0)
-		ret = qla4xxx_ddb_login_st(ha, fw_ddb_entry);
+		ret = qla4xxx_ddb_login_st(ha, fw_ddb_entry,
+					   fnode_sess->target_id);
 	else
 		ret = qla4xxx_ddb_login_nt(ha, fw_ddb_entry,
 					   fnode_sess->target_id);
@@ -6926,11 +7088,10 @@ void qla4xxx_build_ddb_list(struct scsi_qla_host *ha, int is_reset)
 		schedule_timeout_uninterruptible(HZ / 10);
 	} while (time_after(wtime, jiffies));
 
-	/* Free up the sendtargets list */
-	qla4xxx_free_ddb_list(&list_st);
 
-	qla4xxx_build_nt_list(ha, &list_nt, is_reset);
+	qla4xxx_build_nt_list(ha, &list_nt, &list_st, is_reset);
 
+	qla4xxx_free_ddb_list(&list_st);
 	qla4xxx_free_ddb_list(&list_nt);
 
 	qla4xxx_free_ddb_index(ha);
-- 
1.8.2.GIT

