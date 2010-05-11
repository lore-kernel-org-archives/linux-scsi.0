From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 5/7][RFC] iscsi_transport: added new iscsi_param to display
	target alias is sysfs
Date: Tue, 11 May 2010 13:29:17 +0530
Message-ID: <20100511075917.GA30765@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:6887
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753441Ab0EKIDS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 04:03:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c       |    9 +++++++--
 drivers/scsi/scsi_transport_iscsi.c |    4 +++-
 include/scsi/iscsi_if.h             |    2 ++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6bc6571..a3b45e2 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -121,7 +121,8 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.caps			= CAP_FW_DB | CAP_SENDTARGETS_OFFLOAD |
 				  CAP_DATA_PATH_OFFLOAD,
 	.param_mask		= ISCSI_CONN_PORT | ISCSI_CONN_ADDRESS |
-				  ISCSI_TARGET_NAME | ISCSI_TPGT,
+				  ISCSI_TARGET_NAME | ISCSI_TPGT |
+				  ISCSI_TARGET_ALIAS,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
@@ -416,11 +417,15 @@ static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
 	switch (param) {
 	case ISCSI_PARAM_TARGET_NAME:
 		len = snprintf(buf, PAGE_SIZE - 1, "%s\n",
-			       ddb_entry->iscsi_name);
+		    ddb_entry->iscsi_name);
 		break;
 	case ISCSI_PARAM_TPGT:
 		len = sprintf(buf, "%u\n", ddb_entry->tpgt);
 		break;
+	case ISCSI_PARAM_TARGET_ALIAS:
+		len = snprintf(buf, PAGE_SIZE - 1, "%s\n",
+		    ddb_entry->iscsi_alias);
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c20e3b8..fb433d8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -33,7 +33,7 @@
 #include <scsi/scsi_bsg_iscsi.h>
 #include <scsi/scsi_cmnd.h>
 
-#define ISCSI_SESSION_ATTRS 22
+#define ISCSI_SESSION_ATTRS 23
 #define ISCSI_CONN_ATTRS 13
 #define ISCSI_HOST_ATTRS 4
 
@@ -2202,6 +2202,7 @@ static ISCSI_CLASS_ATTR(sess, field, S_IRUGO, show_session_param_##param, \
 			NULL);
 
 iscsi_session_attr(targetname, ISCSI_PARAM_TARGET_NAME, 0);
+iscsi_session_attr(targetalias, ISCSI_PARAM_TARGET_ALIAS, 0);
 iscsi_session_attr(initial_r2t, ISCSI_PARAM_INITIAL_R2T_EN, 0);
 iscsi_session_attr(max_outstanding_r2t, ISCSI_PARAM_MAX_R2T, 0);
 iscsi_session_attr(immediate_data, ISCSI_PARAM_IMM_DATA_EN, 0);
@@ -2452,6 +2453,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_SESSION_RD_ATTR(data_seq_in_order, ISCSI_DATASEQ_INORDER_EN);
 	SETUP_SESSION_RD_ATTR(erl, ISCSI_ERL);
 	SETUP_SESSION_RD_ATTR(targetname, ISCSI_TARGET_NAME);
+	SETUP_SESSION_RD_ATTR(targetalias, ISCSI_TARGET_ALIAS);
 	SETUP_SESSION_RD_ATTR(tpgt, ISCSI_TPGT);
 	SETUP_SESSION_RD_ATTR(password, ISCSI_USERNAME);
 	SETUP_SESSION_RD_ATTR(password_in, ISCSI_USERNAME_IN);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 66d377b..2990ca8 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -286,6 +286,7 @@ enum iscsi_param {
 	ISCSI_PARAM_OFMARKER_EN,
 	ISCSI_PARAM_EXP_STATSN,
 	ISCSI_PARAM_TARGET_NAME,
+	ISCSI_PARAM_TARGET_ALIAS,
 	ISCSI_PARAM_TPGT,
 	ISCSI_PARAM_PERSISTENT_ADDRESS,
 	ISCSI_PARAM_PERSISTENT_PORT,
@@ -333,6 +334,7 @@ enum iscsi_param {
 #define ISCSI_OFMARKER_EN		(1ULL << ISCSI_PARAM_OFMARKER_EN)
 #define ISCSI_EXP_STATSN		(1ULL << ISCSI_PARAM_EXP_STATSN)
 #define ISCSI_TARGET_NAME		(1ULL << ISCSI_PARAM_TARGET_NAME)
+#define ISCSI_TARGET_ALIAS		(1ULL << ISCSI_PARAM_TARGET_ALIAS)
 #define ISCSI_TPGT			(1ULL << ISCSI_PARAM_TPGT)
 #define ISCSI_PERSISTENT_ADDRESS	(1ULL << ISCSI_PARAM_PERSISTENT_ADDRESS)
 #define ISCSI_PERSISTENT_PORT		(1ULL << ISCSI_PARAM_PERSISTENT_PORT)
-- 
1.7.0.5

