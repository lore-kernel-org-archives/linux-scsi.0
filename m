From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/8] qla4xxx: Export CHAP index as sysfs attribute
Date: Mon, 27 Feb 2012 03:08:54 -0800
Message-ID: <1330340938-12893-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:2356
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab2B0LWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2012 06:22:30 -0500
In-Reply-To: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Mike Christie <michaelc@cs.wisc.edu>

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 ++
 drivers/scsi/qla4xxx/ql4_mbx.c  |    9 ++++++--
 drivers/scsi/qla4xxx/ql4_os.c   |   45 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 954ba91..9105366 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -81,6 +81,8 @@ int qla4xxx_set_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t length, uint32_t options);
 int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		uint8_t outCount, uint32_t *mbx_cmd, uint32_t *mbx_sts);
+int qla4xxx_get_chap_index(struct scsi_qla_host *ha, char *username,
+			   char *password, int bidi, uint16_t *chap_index);
 
 void qla4xxx_queue_iocb(struct scsi_qla_host *ha);
 void qla4xxx_complete_iocb(struct scsi_qla_host *ha);
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index eaf2185..71331e3 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1426,8 +1426,8 @@ exit_set_chap:
  * match is found. If a match is not found then add the entry in FLASH and
  * return the index at which entry is written in the FLASH.
  **/
-static int qla4xxx_get_chap_index(struct scsi_qla_host *ha, char *username,
-			    char *password, int bidi, uint16_t *chap_index)
+int qla4xxx_get_chap_index(struct scsi_qla_host *ha, char *username,
+			   char *password, int bidi, uint16_t *chap_index)
 {
 	int i, rval;
 	int free_index = -1;
@@ -1446,6 +1446,11 @@ static int qla4xxx_get_chap_index(struct scsi_qla_host *ha, char *username,
 		return QLA_ERROR;
 	}
 
+	if (!username || !password) {
+		ql4_printk(KERN_ERR, ha, "Do not have username and psw\n");
+		return QLA_ERROR;
+	}
+
 	mutex_lock(&ha->chap_sem);
 	for (i = 0; i < max_chap_entries; i++) {
 		chap_table = (struct ql4_chap_table *)ha->chap_list + i;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c6cfe32..cbaf2b3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -83,6 +83,8 @@ static void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha);
 /*
  * iSCSI template entry points
  */
+static int qla4xxx_session_get_param(struct iscsi_cls_session *cls_sess,
+				     enum iscsi_param param, char *buf);
 static int qla4xxx_conn_get_param(struct iscsi_cls_conn *conn,
 				  enum iscsi_param param, char *buf);
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
@@ -186,7 +188,7 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.destroy_conn           = qla4xxx_conn_destroy,
 	.set_param              = iscsi_set_param,
 	.get_conn_param		= qla4xxx_conn_get_param,
-	.get_session_param	= iscsi_session_get_param,
+	.get_session_param	= qla4xxx_session_get_param,
 	.get_ep_param           = qla4xxx_get_ep_param,
 	.ep_connect		= qla4xxx_ep_connect,
 	.ep_poll		= qla4xxx_ep_poll,
@@ -317,6 +319,12 @@ static umode_t ql4_attr_is_visible(int param_type, int param)
 		case ISCSI_PARAM_MAX_RECV_DLENGTH:
 		case ISCSI_PARAM_MAX_XMIT_DLENGTH:
 		case ISCSI_PARAM_IFACE_NAME:
+		case ISCSI_PARAM_CHAP_OUT_IDX:
+		case ISCSI_PARAM_CHAP_IN_IDX:
+		case ISCSI_PARAM_USERNAME:
+		case ISCSI_PARAM_PASSWORD:
+		case ISCSI_PARAM_USERNAME_IN:
+		case ISCSI_PARAM_PASSWORD_IN:
 			return S_IRUGO;
 		default:
 			return 0;
@@ -1288,6 +1296,41 @@ exit_init_fw_cb:
 	return rval;
 }
 
+static int qla4xxx_session_get_param(struct iscsi_cls_session *cls_sess,
+				     enum iscsi_param param, char *buf)
+{
+	struct iscsi_session *sess = cls_sess->dd_data;
+	struct ddb_entry *ddb_entry = sess->dd_data;
+	struct scsi_qla_host *ha = ddb_entry->ha;
+	int rval, len;
+	uint16_t idx;
+
+	switch (param) {
+	case ISCSI_PARAM_CHAP_IN_IDX:
+		rval = qla4xxx_get_chap_index(ha, sess->username_in,
+					      sess->password_in, BIDI_CHAP,
+					      &idx);
+		if (rval)
+			return -EINVAL;
+
+		len = sprintf(buf, "%hu\n", idx);
+		break;
+	case ISCSI_PARAM_CHAP_OUT_IDX:
+		rval = qla4xxx_get_chap_index(ha, sess->username,
+					      sess->password, LOCAL_CHAP,
+					      &idx);
+		if (rval)
+			return -EINVAL;
+
+		len = sprintf(buf, "%hu\n", idx);
+		break;
+	default:
+		return iscsi_session_get_param(cls_sess, param, buf);
+	}
+
+	return len;
+}
+
 static int qla4xxx_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				  enum iscsi_param param, char *buf)
 {
-- 
1.7.9.1.265.gb3a76


