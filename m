From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 6/7] qla4xxx: Add support to set CHAP entries
Date: Tue, 17 Sep 2013 07:54:49 -0400
Message-ID: <1379418890-1141-7-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:3344 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765Ab3IQMZv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 08:25:51 -0400
In-Reply-To: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Provide support to add/update the CHAP entries in adapter's flash
using iscsi tools, like Open-iSCSI.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_glbl.h   |    2 +
 drivers/scsi/qla4xxx/ql4_inline.h |   12 +++
 drivers/scsi/qla4xxx/ql4_mbx.c    |   16 +++-
 drivers/scsi/qla4xxx/ql4_os.c     |  197 +++++++++++++++++++++++++++++++++++++
 4 files changed, 225 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index e6f2a26..5cef252 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -83,6 +83,8 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		uint8_t outCount, uint32_t *mbx_cmd, uint32_t *mbx_sts);
 int qla4xxx_get_chap_index(struct scsi_qla_host *ha, char *username,
 			   char *password, int bidi, uint16_t *chap_index);
+int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
+		     uint16_t idx, int bidi);
 
 void qla4xxx_queue_iocb(struct scsi_qla_host *ha);
 void qla4xxx_complete_iocb(struct scsi_qla_host *ha);
diff --git a/drivers/scsi/qla4xxx/ql4_inline.h b/drivers/scsi/qla4xxx/ql4_inline.h
index 8503ad6..655b7bb 100644
--- a/drivers/scsi/qla4xxx/ql4_inline.h
+++ b/drivers/scsi/qla4xxx/ql4_inline.h
@@ -82,3 +82,15 @@ qla4xxx_disable_intrs(struct scsi_qla_host *ha)
 	__qla4xxx_disable_intrs(ha);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
+
+static inline int qla4xxx_get_chap_type(struct ql4_chap_table *chap_entry)
+{
+	int type;
+
+	if (chap_entry->flags & BIT_7)
+		type = LOCAL_CHAP;
+	else
+		type = BIDI_CHAP;
+
+	return type;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 121be42..22cbd00 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1530,8 +1530,20 @@ exit_get_chap:
 	return ret;
 }
 
-static int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username,
-			    char *password, uint16_t idx, int bidi)
+/**
+ * qla4xxx_set_chap - Make a chap entry at the given index
+ * @ha: pointer to adapter structure
+ * @username: CHAP username to set
+ * @password: CHAP password to set
+ * @idx: CHAP index at which to make the entry
+ * @bidi: type of chap entry (chap_in or chap_out)
+ *
+ * Create chap entry at the given index with the information provided.
+ *
+ * Note: Caller should acquire the chap lock before getting here.
+ **/
+int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
+		     uint16_t idx, int bidi)
 {
 	int ret = 0;
 	int rval = QLA_ERROR;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4547880..933c766 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -149,6 +149,8 @@ static int qla4xxx_send_ping(struct Scsi_Host *shost, uint32_t iface_num,
 static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 				 uint32_t *num_entries, char *buf);
 static int qla4xxx_delete_chap(struct Scsi_Host *shost, uint16_t chap_tbl_idx);
+static int qla4xxx_set_chap_entry(struct Scsi_Host *shost, void  *data,
+				  int len);
 
 /*
  * SCSI host template entry points
@@ -252,6 +254,7 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.send_ping		= qla4xxx_send_ping,
 	.get_chap		= qla4xxx_get_chap_list,
 	.delete_chap		= qla4xxx_delete_chap,
+	.set_chap		= qla4xxx_set_chap_entry,
 	.get_flashnode_param	= qla4xxx_sysfs_ddb_get_param,
 	.set_flashnode_param	= qla4xxx_sysfs_ddb_set_param,
 	.new_flashnode		= qla4xxx_sysfs_ddb_add,
@@ -508,6 +511,95 @@ static umode_t qla4_attr_is_visible(int param_type, int param)
 	return 0;
 }
 
+static int qla4xxx_get_chap_by_index(struct scsi_qla_host *ha,
+				     int16_t chap_index,
+				     struct ql4_chap_table **chap_entry)
+{
+	int rval = QLA_ERROR;
+	int max_chap_entries;
+
+	if (!ha->chap_list) {
+		ql4_printk(KERN_ERR, ha, "CHAP table cache is empty!\n");
+		rval = QLA_ERROR;
+		goto exit_get_chap;
+	}
+
+	if (is_qla80XX(ha))
+		max_chap_entries = (ha->hw.flt_chap_size / 2) /
+				   sizeof(struct ql4_chap_table);
+	else
+		max_chap_entries = MAX_CHAP_ENTRIES_40XX;
+
+	if (chap_index > max_chap_entries) {
+		ql4_printk(KERN_ERR, ha, "Invalid Chap index\n");
+		rval = QLA_ERROR;
+		goto exit_get_chap;
+	}
+
+	*chap_entry = (struct ql4_chap_table *)ha->chap_list + chap_index;
+	if ((*chap_entry)->cookie !=
+	     __constant_cpu_to_le16(CHAP_VALID_COOKIE)) {
+		rval = QLA_ERROR;
+		*chap_entry = NULL;
+	} else {
+		rval = QLA_SUCCESS;
+	}
+
+exit_get_chap:
+	return rval;
+}
+
+/**
+ * qla4xxx_find_free_chap_index - Find the first free chap index
+ * @ha: pointer to adapter structure
+ * @chap_index: CHAP index to be returned
+ *
+ * Find the first free chap index available in the chap table
+ *
+ * Note: Caller should acquire the chap lock before getting here.
+ **/
+static int qla4xxx_find_free_chap_index(struct scsi_qla_host *ha,
+					uint16_t *chap_index)
+{
+	int i, rval;
+	int free_index = -1;
+	int max_chap_entries = 0;
+	struct ql4_chap_table *chap_table;
+
+	if (is_qla80XX(ha))
+		max_chap_entries = (ha->hw.flt_chap_size / 2) /
+						sizeof(struct ql4_chap_table);
+	else
+		max_chap_entries = MAX_CHAP_ENTRIES_40XX;
+
+	if (!ha->chap_list) {
+		ql4_printk(KERN_ERR, ha, "CHAP table cache is empty!\n");
+		rval = QLA_ERROR;
+		goto exit_find_chap;
+	}
+
+	for (i = 0; i < max_chap_entries; i++) {
+		chap_table = (struct ql4_chap_table *)ha->chap_list + i;
+
+		if ((chap_table->cookie !=
+		    __constant_cpu_to_le16(CHAP_VALID_COOKIE)) &&
+		   (i > MAX_RESRV_CHAP_IDX)) {
+				free_index = i;
+				break;
+		}
+	}
+
+	if (free_index != -1) {
+		*chap_index = free_index;
+		rval = QLA_SUCCESS;
+	} else {
+		rval = QLA_ERROR;
+	}
+
+exit_find_chap:
+	return rval;
+}
+
 static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 				  uint32_t *num_entries, char *buf)
 {
@@ -691,6 +783,111 @@ exit_delete_chap:
 	return ret;
 }
 
+/**
+ * qla4xxx_set_chap_entry - Make chap entry with given information
+ * @shost: pointer to host
+ * @data: chap info - credentials, index and type to make chap entry
+ * @len: length of data
+ *
+ * Add or update chap entry with the given information
+ **/
+static int qla4xxx_set_chap_entry(struct Scsi_Host *shost, void *data, int len)
+{
+	struct scsi_qla_host *ha = to_qla_host(shost);
+	struct iscsi_chap_rec chap_rec;
+	struct ql4_chap_table *chap_entry = NULL;
+	struct iscsi_param_info *param_info;
+	struct nlattr *attr;
+	int max_chap_entries = 0;
+	int type;
+	int rem = len;
+	int rc = 0;
+
+	memset(&chap_rec, 0, sizeof(chap_rec));
+
+	nla_for_each_attr(attr, data, len, rem) {
+		param_info = nla_data(attr);
+
+		switch (param_info->param) {
+		case ISCSI_CHAP_PARAM_INDEX:
+			chap_rec.chap_tbl_idx = *(uint16_t *)param_info->value;
+			break;
+		case ISCSI_CHAP_PARAM_CHAP_TYPE:
+			chap_rec.chap_type = param_info->value[0];
+			break;
+		case ISCSI_CHAP_PARAM_USERNAME:
+			memcpy(chap_rec.username, param_info->value,
+			       param_info->len);
+			break;
+		case ISCSI_CHAP_PARAM_PASSWORD:
+			memcpy(chap_rec.password, param_info->value,
+			       param_info->len);
+			break;
+		case ISCSI_CHAP_PARAM_PASSWORD_LEN:
+			chap_rec.password_length = param_info->value[0];
+			break;
+		default:
+			ql4_printk(KERN_ERR, ha,
+				   "%s: No such sysfs attribute\n", __func__);
+			rc = -ENOSYS;
+			goto exit_set_chap;
+		};
+	}
+
+	if (chap_rec.chap_type == CHAP_TYPE_IN)
+		type = BIDI_CHAP;
+	else
+		type = LOCAL_CHAP;
+
+	if (is_qla80XX(ha))
+		max_chap_entries = (ha->hw.flt_chap_size / 2) /
+				   sizeof(struct ql4_chap_table);
+	else
+		max_chap_entries = MAX_CHAP_ENTRIES_40XX;
+
+	mutex_lock(&ha->chap_sem);
+	if (chap_rec.chap_tbl_idx < max_chap_entries) {
+		rc = qla4xxx_get_chap_by_index(ha, chap_rec.chap_tbl_idx,
+					       &chap_entry);
+		if (!rc) {
+			if (!(type == qla4xxx_get_chap_type(chap_entry))) {
+				ql4_printk(KERN_INFO, ha,
+					   "Type mismatch for CHAP entry %d\n",
+					   chap_rec.chap_tbl_idx);
+				rc = -EINVAL;
+				goto exit_unlock_chap;
+			}
+
+			/* If chap index is in use then don't modify it */
+			rc = qla4xxx_is_chap_active(shost,
+						    chap_rec.chap_tbl_idx);
+			if (rc) {
+				ql4_printk(KERN_INFO, ha,
+					   "CHAP entry %d is in use\n",
+					   chap_rec.chap_tbl_idx);
+				rc = -EBUSY;
+				goto exit_unlock_chap;
+			}
+		}
+	} else {
+		rc = qla4xxx_find_free_chap_index(ha, &chap_rec.chap_tbl_idx);
+		if (rc) {
+			ql4_printk(KERN_INFO, ha, "CHAP entry not available\n");
+			rc = -EBUSY;
+			goto exit_unlock_chap;
+		}
+	}
+
+	rc = qla4xxx_set_chap(ha, chap_rec.username, chap_rec.password,
+			      chap_rec.chap_tbl_idx, type);
+
+exit_unlock_chap:
+	mutex_unlock(&ha->chap_sem);
+
+exit_set_chap:
+	return rc;
+}
+
 static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 				   enum iscsi_param_type param_type,
 				   int param, char *buf)
-- 
1.7.1

