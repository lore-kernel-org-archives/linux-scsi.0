From: michaelc@cs.wisc.edu
Subject: [PATCH 10/19] iscsi class, iscsi_tcp, ib_iser: add sysfs chap file
Date: Wed, 30 May 2007 12:57:16 -0500
Message-ID: <1180547857548-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbXE3R5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:45 -0400
In-Reply-To: <11805478564182-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The attached patches add sysfs files for the chap settings
to the iscsi transport class, iscsi_tcp and ib_iser. This is
needed for software iscsi because there are times when iscsid
can die and it will need to reread the values it was using.
And it is needed by qla4xxx for basic management opertaions.
This patch does not hook in qla4xxx yet, because I am not sure
the mbx command to use.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    5 ++--
 drivers/scsi/iscsi_tcp.c                 |    5 ++--
 drivers/scsi/libiscsi.c                  |   40 ++++++++++++++++++++++++++++++
 drivers/scsi/scsi_transport_iscsi.c      |   39 +++++++++++++++++++----------
 include/scsi/iscsi_if.h                  |    9 +++++++
 include/scsi/libiscsi.h                  |    4 +++
 6 files changed, 84 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 568f88b..6c8cd09 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -574,8 +574,9 @@ static struct iscsi_transport iscsi_iser
 				  ISCSI_EXP_STATSN |
 				  ISCSI_PERSISTENT_PORT |
 				  ISCSI_PERSISTENT_ADDRESS |
-				  ISCSI_TARGET_NAME |
-				  ISCSI_TPGT,
+				  ISCSI_TARGET_NAME | ISCSI_TPGT |
+				  ISCSI_USERNAME | ISCSI_PASSWORD |
+				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
 	.host_template          = &iscsi_iser_sht,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b2827d1..1e722f5 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2186,8 +2186,9 @@ static struct iscsi_transport iscsi_tcp_
 				  ISCSI_EXP_STATSN |
 				  ISCSI_PERSISTENT_PORT |
 				  ISCSI_PERSISTENT_ADDRESS |
-				  ISCSI_TARGET_NAME |
-				  ISCSI_TPGT,
+				  ISCSI_TARGET_NAME | ISCSI_TPGT |
+				  ISCSI_USERNAME | ISCSI_PASSWORD |
+				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
 	.host_template		= &iscsi_sht,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0a9c64e..63981ed 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1461,6 +1461,10 @@ void iscsi_session_teardown(struct iscsi
 	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
 
+	kfree(session->password);
+	kfree(session->password_in);
+	kfree(session->username);
+	kfree(session->username_in);
 	kfree(session->targetname);
 	kfree(session->hwaddress);
 	kfree(session->initiatorname);
@@ -1869,6 +1873,30 @@ int iscsi_set_param(struct iscsi_cls_con
 	case ISCSI_PARAM_EXP_STATSN:
 		sscanf(buf, "%u", &conn->exp_statsn);
 		break;
+	case ISCSI_PARAM_USERNAME:
+		kfree(session->username);
+		session->username = kstrdup(buf, GFP_KERNEL);
+		if (!session->username)
+			return -ENOMEM;
+		break;
+	case ISCSI_PARAM_USERNAME_IN:
+		kfree(session->username_in);
+		session->username_in = kstrdup(buf, GFP_KERNEL);
+		if (!session->username_in)
+			return -ENOMEM;
+		break;
+	case ISCSI_PARAM_PASSWORD:
+		kfree(session->password);
+		session->password = kstrdup(buf, GFP_KERNEL);
+		if (!session->password)
+			return -ENOMEM;
+		break;
+	case ISCSI_PARAM_PASSWORD_IN:
+		kfree(session->password_in);
+		session->password_in = kstrdup(buf, GFP_KERNEL);
+		if (!session->password_in)
+			return -ENOMEM;
+		break;
 	case ISCSI_PARAM_TARGET_NAME:
 		/* this should not change between logins */
 		if (session->targetname)
@@ -1942,6 +1970,18 @@ int iscsi_session_get_param(struct iscsi
 	case ISCSI_PARAM_TPGT:
 		len = sprintf(buf, "%d\n", session->tpgt);
 		break;
+	case ISCSI_PARAM_USERNAME:
+		len = sprintf(buf, "%s\n", session->username);
+		break;
+	case ISCSI_PARAM_USERNAME_IN:
+		len = sprintf(buf, "%s\n", session->username_in);
+		break;
+	case ISCSI_PARAM_PASSWORD:
+		len = sprintf(buf, "%s\n", session->password);
+		break;
+	case ISCSI_PARAM_PASSWORD_IN:
+		len = sprintf(buf, "%s\n", session->password_in);
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 5ec2fbe..341d4fb 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -30,7 +30,7 @@ #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 
-#define ISCSI_SESSION_ATTRS 11
+#define ISCSI_SESSION_ATTRS 15
 #define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 2
 #define ISCSI_TRANSPORT_VERSION "2.0-724"
@@ -1196,30 +1196,37 @@ #define iscsi_cdev_to_session(_cdev) \
 /*
  * iSCSI session attrs
  */
-#define iscsi_session_attr_show(param)					\
+#define iscsi_session_attr_show(param, perm)				\
 static ssize_t								\
 show_session_param_##param(struct class_device *cdev, char *buf)	\
 {									\
 	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev); \
 	struct iscsi_transport *t = session->transport;			\
+									\
+	if (perm && !capable(CAP_SYS_ADMIN))				\
+		return -EACCES;						\
 	return t->get_session_param(session, param, buf);		\
 }
 
-#define iscsi_session_attr(field, param)				\
-	iscsi_session_attr_show(param)					\
+#define iscsi_session_attr(field, param, perm)				\
+	iscsi_session_attr_show(param, perm)				\
 static ISCSI_CLASS_ATTR(sess, field, S_IRUGO, show_session_param_##param, \
 			NULL);
 
-iscsi_session_attr(targetname, ISCSI_PARAM_TARGET_NAME);
-iscsi_session_attr(initial_r2t, ISCSI_PARAM_INITIAL_R2T_EN);
-iscsi_session_attr(max_outstanding_r2t, ISCSI_PARAM_MAX_R2T);
-iscsi_session_attr(immediate_data, ISCSI_PARAM_IMM_DATA_EN);
-iscsi_session_attr(first_burst_len, ISCSI_PARAM_FIRST_BURST);
-iscsi_session_attr(max_burst_len, ISCSI_PARAM_MAX_BURST);
-iscsi_session_attr(data_pdu_in_order, ISCSI_PARAM_PDU_INORDER_EN);
-iscsi_session_attr(data_seq_in_order, ISCSI_PARAM_DATASEQ_INORDER_EN);
-iscsi_session_attr(erl, ISCSI_PARAM_ERL);
-iscsi_session_attr(tpgt, ISCSI_PARAM_TPGT);
+iscsi_session_attr(targetname, ISCSI_PARAM_TARGET_NAME, 0);
+iscsi_session_attr(initial_r2t, ISCSI_PARAM_INITIAL_R2T_EN, 0);
+iscsi_session_attr(max_outstanding_r2t, ISCSI_PARAM_MAX_R2T, 0);
+iscsi_session_attr(immediate_data, ISCSI_PARAM_IMM_DATA_EN, 0);
+iscsi_session_attr(first_burst_len, ISCSI_PARAM_FIRST_BURST, 0);
+iscsi_session_attr(max_burst_len, ISCSI_PARAM_MAX_BURST, 0);
+iscsi_session_attr(data_pdu_in_order, ISCSI_PARAM_PDU_INORDER_EN, 0);
+iscsi_session_attr(data_seq_in_order, ISCSI_PARAM_DATASEQ_INORDER_EN, 0);
+iscsi_session_attr(erl, ISCSI_PARAM_ERL, 0);
+iscsi_session_attr(tpgt, ISCSI_PARAM_TPGT, 0);
+iscsi_session_attr(username, ISCSI_PARAM_USERNAME, 1);
+iscsi_session_attr(username_in, ISCSI_PARAM_USERNAME_IN, 1);
+iscsi_session_attr(password, ISCSI_PARAM_PASSWORD, 1);
+iscsi_session_attr(password_in, ISCSI_PARAM_PASSWORD_IN, 1);
 
 #define iscsi_priv_session_attr_show(field, format)			\
 static ssize_t								\
@@ -1433,6 +1440,10 @@ iscsi_register_transport(struct iscsi_tr
 	SETUP_SESSION_RD_ATTR(erl, ISCSI_ERL);
 	SETUP_SESSION_RD_ATTR(targetname, ISCSI_TARGET_NAME);
 	SETUP_SESSION_RD_ATTR(tpgt, ISCSI_TPGT);
+	SETUP_SESSION_RD_ATTR(password, ISCSI_USERNAME);
+	SETUP_SESSION_RD_ATTR(password_in, ISCSI_USERNAME_IN);
+	SETUP_SESSION_RD_ATTR(username, ISCSI_PASSWORD);
+	SETUP_SESSION_RD_ATTR(username_in, ISCSI_PASSWORD_IN);
 	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index e057c5d..1a18196 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -229,6 +229,11 @@ enum iscsi_param {
 	ISCSI_PARAM_CONN_PORT,
 	ISCSI_PARAM_CONN_ADDRESS,
 
+	ISCSI_PARAM_USERNAME,
+	ISCSI_PARAM_USERNAME_IN,
+	ISCSI_PARAM_PASSWORD,
+	ISCSI_PARAM_PASSWORD_IN,
+
 	/* must always be last */
 	ISCSI_PARAM_MAX,
 };
@@ -255,6 +260,10 @@ #define ISCSI_PERSISTENT_PORT		(1 << ISC
 #define ISCSI_SESS_RECOVERY_TMO		(1 << ISCSI_PARAM_SESS_RECOVERY_TMO)
 #define ISCSI_CONN_PORT			(1 << ISCSI_PARAM_CONN_PORT)
 #define ISCSI_CONN_ADDRESS		(1 << ISCSI_PARAM_CONN_ADDRESS)
+#define ISCSI_USERNAME			(1 << ISCSI_PARAM_USERNAME)
+#define ISCSI_USERNAME_IN		(1 << ISCSI_PARAM_USERNAME_IN)
+#define ISCSI_PASSWORD			(1 << ISCSI_PARAM_PASSWORD)
+#define ISCSI_PASSWORD_IN		(1 << ISCSI_PARAM_PASSWORD_IN)
 
 /* iSCSI HBA params */
 enum iscsi_host_param {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 348265d..61bc8f7 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -221,6 +221,10 @@ struct iscsi_session {
 	int			dataseq_inorder_en;
 	int			erl;
 	int			tpgt;
+	char			*username;
+	char			*username_in;
+	char			*password;
+	char			*password_in;
 	char			*targetname;
 	char			*initiatorname;
 	/* hw address being used for iscsi connection */
-- 
1.4.1.1

