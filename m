From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/4] qla4xxx: multi-session fix for flash ddbs
Date: Thu, 14 Jun 2012 06:35:48 -0400
Message-ID: <1339670151-26289-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1339670151-26289-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:42429 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755603Ab2FNKwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2012 06:52:05 -0400
In-Reply-To: <1339670151-26289-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Allow multi-session to target (for flash ddbs) accesible via
multiple network portal

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    1 +
 drivers/scsi/qla4xxx/ql4_os.c  |  156 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 144 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 96a5616..7fdba7f 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -279,6 +279,7 @@ struct qla_ddb_index {
 	struct list_head list;
 	uint16_t fw_ddb_idx;
 	struct dev_db_entry fw_ddb;
+	uint8_t flash_isid[6];
 };
 
 #define DDB_IPADDR_LEN 64
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index cd15678..9da4266 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4299,7 +4299,8 @@ static void qla4xxx_get_param_ddb(struct ddb_entry *ddb_entry,
 }
 
 static void qla4xxx_convert_param_ddb(struct dev_db_entry *fw_ddb_entry,
-				      struct ql4_tuple_ddb *tddb)
+				      struct ql4_tuple_ddb *tddb,
+				      uint8_t *flash_isid)
 {
 	uint16_t options = 0;
 
@@ -4314,7 +4315,12 @@ static void qla4xxx_convert_param_ddb(struct dev_db_entry *fw_ddb_entry,
 		sprintf(tddb->ip_addr, "%pI4", fw_ddb_entry->ip_addr);
 
 	tddb->port = le16_to_cpu(fw_ddb_entry->port);
-	memcpy(&tddb->isid[0], &fw_ddb_entry->isid[0], sizeof(tddb->isid));
+
+	if (flash_isid == NULL)
+		memcpy(&tddb->isid[0], &fw_ddb_entry->isid[0],
+		       sizeof(tddb->isid));
+	else
+		memcpy(&tddb->isid[0], &flash_isid[0], sizeof(tddb->isid));
 }
 
 static int qla4xxx_compare_tuple_ddb(struct scsi_qla_host *ha,
@@ -4385,7 +4391,7 @@ static int qla4xxx_is_session_exists(struct scsi_qla_host *ha,
 		goto exit_check;
 	}
 
-	qla4xxx_convert_param_ddb(fw_ddb_entry, fw_tddb);
+	qla4xxx_convert_param_ddb(fw_ddb_entry, fw_tddb, NULL);
 
 	for (idx = 0; idx < MAX_DDB_ENTRIES; idx++) {
 		ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, idx);
@@ -4407,6 +4413,102 @@ exit_check:
 	return ret;
 }
 
+/**
+ * qla4xxx_check_existing_isid - check if target with same isid exist
+ *				 in target list
+ * @list_nt: list of target
+ * @isid: isid to check
+ *
+ * This routine return QLA_SUCCESS if target with same isid exist
+ **/
+static int qla4xxx_check_existing_isid(struct list_head *list_nt, uint8_t *isid)
+{
+	struct qla_ddb_index *nt_ddb_idx, *nt_ddb_idx_tmp;
+	struct dev_db_entry *fw_ddb_entry;
+
+	list_for_each_entry_safe(nt_ddb_idx, nt_ddb_idx_tmp, list_nt, list) {
+		fw_ddb_entry = &nt_ddb_idx->fw_ddb;
+
+		if (memcmp(&fw_ddb_entry->isid[0], &isid[0],
+			   sizeof(nt_ddb_idx->fw_ddb.isid)) == 0) {
+			return QLA_SUCCESS;
+		}
+	}
+	return QLA_ERROR;
+}
+
+/**
+ * qla4xxx_update_isid - compare ddbs and updated isid
+ * @ha: Pointer to host adapter structure.
+ * @list_nt: list of nt target
+ * @fw_ddb_entry: firmware ddb entry
+ *
+ * This routine update isid if ddbs have same iqn, same isid and
+ * different IP addr.
+ * Return QLA_SUCCESS if isid is updated.
+ **/
+static int qla4xxx_update_isid(struct scsi_qla_host *ha,
+			       struct list_head *list_nt,
+			       struct dev_db_entry *fw_ddb_entry)
+{
+	uint8_t base_value, i;
+
+	base_value = fw_ddb_entry->isid[1] & 0x1f;
+	for (i = 0; i < 8; i++) {
+		fw_ddb_entry->isid[1] = (base_value | (i << 5));
+		if (qla4xxx_check_existing_isid(list_nt, fw_ddb_entry->isid))
+			break;
+	}
+
+	if (!qla4xxx_check_existing_isid(list_nt, fw_ddb_entry->isid))
+		return QLA_ERROR;
+
+	return QLA_SUCCESS;
+}
+
+/**
+ * qla4xxx_should_update_isid - check if isid need to update
+ * @ha: Pointer to host adapter structure.
+ * @old_tddb: ddb tuple
+ * @new_tddb: ddb tuple
+ *
+ * Return QLA_SUCCESS if different IP, different PORT, same iqn,
+ * same isid
+ **/
+static int qla4xxx_should_update_isid(struct scsi_qla_host *ha,
+				      struct ql4_tuple_ddb *old_tddb,
+				      struct ql4_tuple_ddb *new_tddb)
+{
+	if (strcmp(old_tddb->ip_addr, new_tddb->ip_addr) == 0) {
+		/* Same ip */
+		if (old_tddb->port == new_tddb->port)
+			return QLA_ERROR;
+	}
+
+	if (strcmp(old_tddb->iscsi_name, new_tddb->iscsi_name))
+		/* different iqn */
+		return QLA_ERROR;
+
+	if (memcmp(&old_tddb->isid[0], &new_tddb->isid[0],
+		   sizeof(old_tddb->isid)))
+		/* different isid */
+		return QLA_ERROR;
+
+	return QLA_SUCCESS;
+}
+
+/**
+ * qla4xxx_is_flash_ddb_exists - check if fw_ddb_entry already exists in list_nt
+ * @ha: Pointer to host adapter structure.
+ * @list_nt: list of nt target.
+ * @fw_ddb_entry: firmware ddb entry.
+ *
+ * This routine check if fw_ddb_entry already exists in list_nt to avoid
+ * duplicate ddb in list_nt.
+ * Return QLA_SUCCESS if duplicate ddb exit in list_nl.
+ * Note: This function also update isid of DDB if required.
+ **/
+
 static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
 				       struct list_head *list_nt,
 				       struct dev_db_entry *fw_ddb_entry)
@@ -4414,7 +4516,7 @@ static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
 	struct qla_ddb_index  *nt_ddb_idx, *nt_ddb_idx_tmp;
 	struct ql4_tuple_ddb *fw_tddb = NULL;
 	struct ql4_tuple_ddb *tmp_tddb = NULL;
-	int ret = QLA_ERROR;
+	int rval, ret = QLA_ERROR;
 
 	fw_tddb = vzalloc(sizeof(*fw_tddb));
 	if (!fw_tddb) {
@@ -4432,12 +4534,28 @@ static int qla4xxx_is_flash_ddb_exists(struct scsi_qla_host *ha,
 		goto exit_check;
 	}
 
-	qla4xxx_convert_param_ddb(fw_ddb_entry, fw_tddb);
+	qla4xxx_convert_param_ddb(fw_ddb_entry, fw_tddb, NULL);
 
 	list_for_each_entry_safe(nt_ddb_idx, nt_ddb_idx_tmp, list_nt, list) {
-		qla4xxx_convert_param_ddb(&nt_ddb_idx->fw_ddb, tmp_tddb);
-		if (!qla4xxx_compare_tuple_ddb(ha, fw_tddb, tmp_tddb, true)) {
-			ret = QLA_SUCCESS; /* found */
+		qla4xxx_convert_param_ddb(&nt_ddb_idx->fw_ddb, tmp_tddb,
+					  nt_ddb_idx->flash_isid);
+		ret = qla4xxx_compare_tuple_ddb(ha, fw_tddb, tmp_tddb, true);
+		/* found duplicate ddb */
+		if (ret == QLA_SUCCESS)
+			goto exit_check;
+	}
+
+	list_for_each_entry_safe(nt_ddb_idx, nt_ddb_idx_tmp, list_nt, list) {
+		qla4xxx_convert_param_ddb(&nt_ddb_idx->fw_ddb, tmp_tddb, NULL);
+
+		ret = qla4xxx_should_update_isid(ha, tmp_tddb, fw_tddb);
+		if (ret == QLA_SUCCESS) {
+			rval = qla4xxx_update_isid(ha, list_nt, fw_ddb_entry);
+			if (rval == QLA_SUCCESS)
+				ret = QLA_ERROR;
+			else
+				ret = QLA_SUCCESS;
+
 			goto exit_check;
 		}
 	}
@@ -4788,14 +4906,26 @@ static void qla4xxx_build_nt_list(struct scsi_qla_host *ha,
 
 			nt_ddb_idx->fw_ddb_idx = idx;
 
-			memcpy(&nt_ddb_idx->fw_ddb, fw_ddb_entry,
-			       sizeof(struct dev_db_entry));
-
-			if (qla4xxx_is_flash_ddb_exists(ha, list_nt,
-					fw_ddb_entry) == QLA_SUCCESS) {
+			/* Copy original isid as it may get updated in function
+			 * qla4xxx_update_isid(). We need original isid in
+			 * function qla4xxx_compare_tuple_ddb to find duplicate
+			 * target */
+			memcpy(&nt_ddb_idx->flash_isid[0],
+			       &fw_ddb_entry->isid[0],
+			       sizeof(nt_ddb_idx->flash_isid));
+
+			ret = qla4xxx_is_flash_ddb_exists(ha, list_nt,
+							  fw_ddb_entry);
+			if (ret == QLA_SUCCESS) {
+				/* free nt_ddb_idx and do not add to list_nt */
 				vfree(nt_ddb_idx);
 				goto continue_next_nt;
 			}
+
+			/* Copy updated isid */
+			memcpy(&nt_ddb_idx->fw_ddb, fw_ddb_entry,
+			       sizeof(struct dev_db_entry));
+
 			list_add_tail(&nt_ddb_idx->list, list_nt);
 		} else if (is_reset == RESET_ADAPTER) {
 			if (qla4xxx_is_session_exists(ha, fw_ddb_entry) ==
-- 
1.7.9.1.265.gb3a76

