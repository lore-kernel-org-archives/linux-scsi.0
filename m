From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 7/7] qla4xxx: Add support to get CHAP details for flash target session
Date: Tue, 17 Sep 2013 07:54:50 -0400
Message-ID: <1379418890-1141-8-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:50137 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393Ab3IQMZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 08:25:18 -0400
In-Reply-To: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Add support to get local CHAP - index, username and password,
sysfs params of iscsi session corresponding to flash target entry.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 933c766..6dc3e99 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1652,9 +1652,12 @@ static int qla4xxx_session_get_param(struct iscsi_cls_session *cls_sess,
 	struct iscsi_session *sess = cls_sess->dd_data;
 	struct ddb_entry *ddb_entry = sess->dd_data;
 	struct scsi_qla_host *ha = ddb_entry->ha;
+	struct iscsi_cls_conn *cls_conn = ddb_entry->conn;
+	struct ql4_chap_table chap_tbl;
 	int rval, len;
 	uint16_t idx;
 
+	memset(&chap_tbl, 0, sizeof(chap_tbl));
 	switch (param) {
 	case ISCSI_PARAM_CHAP_IN_IDX:
 		rval = qla4xxx_get_chap_index(ha, sess->username_in,
@@ -1666,14 +1669,46 @@ static int qla4xxx_session_get_param(struct iscsi_cls_session *cls_sess,
 			len = sprintf(buf, "%hu\n", idx);
 		break;
 	case ISCSI_PARAM_CHAP_OUT_IDX:
-		rval = qla4xxx_get_chap_index(ha, sess->username,
-					      sess->password, LOCAL_CHAP,
-					      &idx);
+		if (ddb_entry->ddb_type == FLASH_DDB) {
+			if (ddb_entry->chap_tbl_idx != INVALID_ENTRY) {
+				idx = ddb_entry->chap_tbl_idx;
+				rval = QLA_SUCCESS;
+			} else {
+				rval = QLA_ERROR;
+			}
+		} else {
+			rval = qla4xxx_get_chap_index(ha, sess->username,
+						      sess->password,
+						      LOCAL_CHAP, &idx);
+		}
 		if (rval)
 			len = sprintf(buf, "\n");
 		else
 			len = sprintf(buf, "%hu\n", idx);
 		break;
+	case ISCSI_PARAM_USERNAME:
+	case ISCSI_PARAM_PASSWORD:
+		/* First, populate session username and password for FLASH DDB,
+		 * if not already done. This happens when session login fails
+		 * for a FLASH DDB.
+		 */
+		if (ddb_entry->ddb_type == FLASH_DDB &&
+		    ddb_entry->chap_tbl_idx != INVALID_ENTRY &&
+		    !sess->username && !sess->password) {
+			idx = ddb_entry->chap_tbl_idx;
+			rval = qla4xxx_get_uni_chap_at_index(ha, chap_tbl.name,
+							    chap_tbl.secret,
+							    idx);
+			if (!rval) {
+				iscsi_set_param(cls_conn, ISCSI_PARAM_USERNAME,
+						(char *)chap_tbl.name,
+						strlen((char *)chap_tbl.name));
+				iscsi_set_param(cls_conn, ISCSI_PARAM_PASSWORD,
+						(char *)chap_tbl.secret,
+						chap_tbl.secret_len);
+			}
+		}
+		/* allow fall-through */
 	default:
 		return iscsi_session_get_param(cls_sess, param, buf);
 	}
-- 
1.7.1

