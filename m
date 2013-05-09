From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 7/8] qla4xxx: Add support to allow flashnode multi-session login.
Date: Thu, 9 May 2013 06:02:11 -0400
Message-ID: <1368093732-8524-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:45834
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581Ab3EIK0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 06:26:50 -0400
In-Reply-To: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 69 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 62 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 171c0e4..5271807 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6977,17 +6977,72 @@ exit_login_st_clr_bit:
 }
 
 static int qla4xxx_ddb_login_nt(struct scsi_qla_host *ha,
-				struct dev_db_entry *fw_ddb_entry,
+				struct dev_db_entry *sfw_ddb_entry,
 				uint16_t idx)
 {
-	int ret = QLA_ERROR;
+	struct ql4_tuple_ddb *temp_tddb = NULL;
+	struct ql4_tuple_ddb *src_tddb = NULL;
+	struct ddb_entry *ddb_entry = NULL;
+	struct iscsi_session *session = NULL;
+	uint8_t is_isid_compare;
+	int ret = QLA_ERROR, status;
+	int i, max_ddbs;
 
-	ret = qla4xxx_is_session_exists(ha, fw_ddb_entry);
-	if (ret != QLA_SUCCESS)
-		ret = qla4xxx_sess_conn_setup(ha, fw_ddb_entry, RESET_ADAPTER,
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+				     MAX_DEV_DB_ENTRIES;
+
+	src_tddb = vzalloc(sizeof(*src_tddb));
+	if (!src_tddb) {
+		ql4_printk(KERN_WARNING, ha, "%s:Memory allocation failed\n",
+			   __func__);
+		ret = -ENOMEM;
+		goto exit_ddb_login;
+	}
+
+	temp_tddb = vzalloc(sizeof(*temp_tddb));
+	if (!temp_tddb) {
+		ql4_printk(KERN_WARNING, ha, "%s:Memory allocation failed\n",
+			   __func__);
+		ret = -ENOMEM;
+		goto exit_ddb_login;
+	}
+
+	qla4xxx_convert_param_ddb(sfw_ddb_entry, src_tddb, NULL);
+
+	for (i = 0; i < max_ddbs; i++) {
+		ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, i);
+		if (ddb_entry == NULL)
+			continue;
+
+		memset(temp_tddb, 0, sizeof(*temp_tddb));
+		qla4xxx_get_param_ddb(ddb_entry, temp_tddb);
+
+		if (ddb_entry->ddb_type != FLASH_DDB) {
+			is_isid_compare = false;
+		} else {
+			session = ddb_entry->sess->dd_data;
+			COPY_ISID(temp_tddb->isid, session->isid);
+			is_isid_compare = true;
+		}
+
+		status = qla4xxx_compare_tuple_ddb(ha, src_tddb, temp_tddb,
+						   is_isid_compare);
+		if (status == QLA_SUCCESS) {
+			ret = -EEXIST;
+			goto exit_ddb_login;
+		} else {
+			continue;
+		}
+	}
+
+	if (i == max_ddbs)
+		ret = qla4xxx_sess_conn_setup(ha, sfw_ddb_entry, RESET_ADAPTER,
 					      idx);
-	else
-		ret = -EPERM;
+exit_ddb_login:
+	if (src_tddb)
+		vfree(src_tddb);
+	if (temp_tddb)
+		vfree(temp_tddb);
 
 	return ret;
 }
-- 
1.8.2.GIT


