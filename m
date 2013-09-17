From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 2/7] qla4xxx: Support setting of local CHAP index for flash target entry
Date: Tue, 17 Sep 2013 07:54:45 -0400
Message-ID: <1379418890-1141-3-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:62545 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465Ab3IQMZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 08:25:18 -0400
In-Reply-To: <1379418890-1141-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Support setting of CHAP_OUT_IDX param for the target entry in flash.
Setting of valid local CHAP index with enable CHAP AUTH for that
flash target entry and disabling CHAP AUTH will invalidate the CHAP
index for the flash target entry.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h |    4 ++++
 drivers/scsi/qla4xxx/ql4_os.c |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 51d1a70..1243e59 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -539,6 +539,10 @@ struct qla_flt_region {
 #define ENABLE_INTERNAL_LOOPBACK	0x04
 #define ENABLE_EXTERNAL_LOOPBACK	0x08
 
+/* generic defines to enable/disable params */
+#define QL4_PARAM_DISABLE	0
+#define QL4_PARAM_ENABLE	1
+
 /*************************************************************************/
 
 /* Host Adapter Initialization Control Block (from host) */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a8847a3..057d068 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6684,10 +6684,13 @@ qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
 	struct iscsi_flashnode_param_info *fnode_param;
+	struct ql4_chap_table chap_tbl;
 	struct nlattr *attr;
+	uint16_t chap_out_idx = INVALID_ENTRY;
 	int rc = QLA_ERROR;
 	uint32_t rem = len;
 
+	memset((void *)&chap_tbl, 0, sizeof(chap_tbl));
 	nla_for_each_attr(attr, data, len, rem) {
 		fnode_param = nla_data(attr);
 
@@ -6729,6 +6732,10 @@ qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
 			break;
 		case ISCSI_FLASHNODE_CHAP_AUTH_EN:
 			fnode_sess->chap_auth_en = fnode_param->value[0];
+			/* Invalidate chap index if chap auth is disabled */
+			if (!fnode_sess->chap_auth_en)
+				fnode_sess->chap_out_idx = INVALID_ENTRY;
+
 			break;
 		case ISCSI_FLASHNODE_SNACK_REQ_EN:
 			fnode_conn->snack_req_en = fnode_param->value[0];
@@ -6867,6 +6874,17 @@ qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
 			fnode_conn->exp_statsn =
 						*(uint32_t *)fnode_param->value;
 			break;
+		case ISCSI_FLASHNODE_CHAP_OUT_IDX:
+			chap_out_idx = *(uint16_t *)fnode_param->value;
+			if (!qla4xxx_get_uni_chap_at_index(ha,
+							   chap_tbl.name,
+							   chap_tbl.secret,
+							   chap_out_idx)) {
+				fnode_sess->chap_out_idx = chap_out_idx;
+				/* Enable chap auth if chap index is valid */
+				fnode_sess->chap_auth_en = QL4_PARAM_ENABLE;
+			}
+			break;
 		default:
 			ql4_printk(KERN_ERR, ha,
 				   "%s: No such sysfs attribute\n", __func__);
-- 
1.7.1

