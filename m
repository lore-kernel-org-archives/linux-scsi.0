From: michaelc@cs.wisc.edu
Subject: [PATCH 3/19] qla4xxx: export mac as hw address
Date: Wed, 30 May 2007 12:57:09 -0500
Message-ID: <11805478483268-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbXE3R5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:44 -0400
In-Reply-To: <11805478472375-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Export mac as hw address.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |   39 +++++++++++++++++++++++++++++++++++----
 1 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index e09fc42..01308e7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -60,6 +60,8 @@ static int qla4xxx_conn_get_param(struct
 				  enum iscsi_param param, char *buf);
 static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
 				  enum iscsi_param param, char *buf);
+static int qla4xxx_host_get_param(struct Scsi_Host *shost,
+				  enum iscsi_host_param param, char *buf);
 static void qla4xxx_conn_stop(struct iscsi_cls_conn *conn, int flag);
 static int qla4xxx_conn_start(struct iscsi_cls_conn *conn);
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
@@ -99,16 +101,16 @@ static struct scsi_host_template qla4xxx
 static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.owner			= THIS_MODULE,
 	.name			= DRIVER_NAME,
-	.param_mask		= ISCSI_CONN_PORT |
-				  ISCSI_CONN_ADDRESS |
-				  ISCSI_TARGET_NAME |
-				  ISCSI_TPGT,
+	.param_mask		= ISCSI_CONN_PORT | ISCSI_CONN_ADDRESS |
+				  ISCSI_TARGET_NAME | ISCSI_TPGT,
+	.host_param_mask	= ISCSI_HOST_HWADDRESS,
 	.sessiondata_size	= sizeof(struct ddb_entry),
 	.host_template		= &qla4xxx_driver_template,
 
 	.tgt_dscvr		= qla4xxx_tgt_dscvr,
 	.get_conn_param		= qla4xxx_conn_get_param,
 	.get_session_param	= qla4xxx_sess_get_param,
+	.get_host_param		= qla4xxx_host_get_param,
 	.start_conn		= qla4xxx_conn_start,
 	.stop_conn		= qla4xxx_conn_stop,
 	.session_recovery_timedout = qla4xxx_recovery_timedout,
@@ -165,6 +167,35 @@ static void qla4xxx_conn_stop(struct isc
 		printk(KERN_ERR "iscsi: invalid stop flag %d\n", flag);
 }
 
+static ssize_t format_addr(char *buf, const unsigned char *addr, int len)
+{
+	int i;
+	char *cp = buf;
+
+	for (i = 0; i < len; i++)
+		cp += sprintf(cp, "%02x%c", addr[i],
+			      i == (len - 1) ? '\n' : ':');
+	return cp - buf;
+}
+
+
+static int qla4xxx_host_get_param(struct Scsi_Host *shost,
+				  enum iscsi_host_param param, char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(shost);
+	int len;
+
+	switch (param) {
+	case ISCSI_HOST_PARAM_HWADDRESS:
+		len = format_addr(buf, ha->my_mac, MAC_ADDR_LEN);
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return len;
+}
+
 static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
 				  enum iscsi_param param, char *buf)
 {
-- 
1.4.1.1

