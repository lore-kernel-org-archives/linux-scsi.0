From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 6/8] qla4xxx: Add support for ISCSI_PARAM_LOCAL_IPADDR sysfs attr
Date: Fri, 22 Nov 2013 05:28:22 -0500
Message-ID: <1385116104-19784-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:62195 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424Ab3KVLBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Nov 2013 06:01:15 -0500
In-Reply-To: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index aa438f2..4181758 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -421,6 +421,7 @@ static umode_t qla4_attr_is_visible(int param_type, int param)
 		case ISCSI_PARAM_EXP_STATSN:
 		case ISCSI_PARAM_DISCOVERY_PARENT_IDX:
 		case ISCSI_PARAM_DISCOVERY_PARENT_TYPE:
+		case ISCSI_PARAM_LOCAL_IPADDR:
 			return S_IRUGO;
 		default:
 			return 0;
@@ -3619,6 +3620,7 @@ static void qla4xxx_copy_to_sess_conn_params(struct iscsi_conn *conn,
 	unsigned long options = 0;
 	uint16_t ddb_link;
 	uint16_t disc_parent;
+	char ip_addr[DDB_IPADDR_LEN];
 
 	options = le16_to_cpu(fw_ddb_entry->options);
 	conn->is_fw_assigned_ipv6 = test_bit(OPT_IS_FW_ASSIGNED_IPV6, &options);
@@ -3700,6 +3702,14 @@ static void qla4xxx_copy_to_sess_conn_params(struct iscsi_conn *conn,
 
 	iscsi_set_param(conn->cls_conn, ISCSI_PARAM_TARGET_ALIAS,
 			(char *)fw_ddb_entry->iscsi_alias, 0);
+
+	options = le16_to_cpu(fw_ddb_entry->options);
+	if (options & DDB_OPT_IPV6_DEVICE) {
+		memset(ip_addr, 0, sizeof(ip_addr));
+		sprintf(ip_addr, "%pI6", fw_ddb_entry->link_local_ipv6_addr);
+		iscsi_set_param(conn->cls_conn, ISCSI_PARAM_LOCAL_IPADDR,
+				(char *)ip_addr, 0);
+	}
 }
 
 static void qla4xxx_copy_fwddb_param(struct scsi_qla_host *ha,
-- 
1.8.2.GIT

