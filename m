From: michaelc@cs.wisc.edu
Subject: [PATCH 21/25] iscsi class: Add session initiatorname and ifacename sysfs attrs.
Date: Wed, 21 May 2008 15:54:16 -0500
Message-ID: <1211403260-5487-22-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-19-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-20-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-21-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976AbYEUUyh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:37 -0400
In-Reply-To: <1211403260-5487-21-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This adds two new attrs used for creating initiator ports and
binding sessions to hardware.

The session level initiatorname:

Since bnx2i does a scsi_host per host device, we need to add the
iface initiator port settings on the session, so we can create
multiple initiator ports (each with different inames) per device/scsi_host.

The current iname reflects that qla4xxx can have one iname per hba, and we are
allocating a host per session for software. The iname on the host will
remain so we can export and set the hba level qla4xxx setting.

The ifacename attr:

To bind a session to a some peice of hardware in userspace we maintain
some mappings, but during boot or iscsid restart (iscsid contains the user
space part of the driver) we need to be able to figure out which of those
host mappings abstractions maps to certain sessions. This patch adds
a ifacename attr, which userspace can set to id the host side of the
endpoint across pivot_roots and iscsid restarts.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    3 +-
 drivers/scsi/iscsi_tcp.c                 |    3 +-
 drivers/scsi/libiscsi.c                  |   20 ++++++++
 drivers/scsi/scsi_transport_iscsi.c      |    6 ++-
 include/scsi/iscsi_if.h                  |   79 ++++++++++++++++--------------
 include/scsi/libiscsi.h                  |    2 +
 6 files changed, 74 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 42e95b8..08edbaf 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -629,7 +629,8 @@ static struct iscsi_transport iscsi_iser_transport = {
 				  ISCSI_USERNAME | ISCSI_PASSWORD |
 				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
 				  ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
-				  ISCSI_PING_TMO | ISCSI_RECV_TMO,
+				  ISCSI_PING_TMO | ISCSI_RECV_TMO |
+				  ISCSI_IFACE_NAME | ISCSI_INITIATOR_NAME,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_NETDEV_NAME |
 				  ISCSI_HOST_INITIATOR_NAME,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 92d0319..7552dd8 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1957,7 +1957,8 @@ static struct iscsi_transport iscsi_tcp_transport = {
 				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
 				  ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
 				  ISCSI_LU_RESET_TMO |
-				  ISCSI_PING_TMO | ISCSI_RECV_TMO,
+				  ISCSI_PING_TMO | ISCSI_RECV_TMO |
+				  ISCSI_IFACE_NAME | ISCSI_INITIATOR_NAME,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME |
 				  ISCSI_HOST_NETDEV_NAME,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e88b726..c1af2aa 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1990,6 +1990,8 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->username);
 	kfree(session->username_in);
 	kfree(session->targetname);
+	kfree(session->initiatorname);
+	kfree(session->ifacename);
 
 	iscsi_destroy_session(cls_session);
 	module_put(owner);
@@ -2453,6 +2455,14 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		if (!conn->persistent_address)
 			return -ENOMEM;
 		break;
+	case ISCSI_PARAM_IFACE_NAME:
+		if (!session->ifacename)
+			session->ifacename = kstrdup(buf, GFP_KERNEL);
+		break;
+	case ISCSI_PARAM_INITIATOR_NAME:
+		if (!session->initiatorname)
+			session->initiatorname = kstrdup(buf, GFP_KERNEL);
+		break;
 	default:
 		return -ENOSYS;
 	}
@@ -2519,6 +2529,15 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 	case ISCSI_PARAM_PASSWORD_IN:
 		len = sprintf(buf, "%s\n", session->password_in);
 		break;
+	case ISCSI_PARAM_IFACE_NAME:
+		len = sprintf(buf, "%s\n", session->ifacename);
+		break;
+	case ISCSI_PARAM_INITIATOR_NAME:
+		if (!session->initiatorname)
+			len = sprintf(buf, "%s\n", "unknown");
+		else
+			len = sprintf(buf, "%s\n", session->initiatorname);
+		break;
 	default:
 		return -ENOSYS;
 	}
@@ -2606,6 +2625,7 @@ int iscsi_host_get_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 		else
 			len = sprintf(buf, "%s\n",
 				      ihost->local_address);
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c3c07cc..9fd5c6d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -30,7 +30,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 
-#define ISCSI_SESSION_ATTRS 19
+#define ISCSI_SESSION_ATTRS 21
 #define ISCSI_CONN_ATTRS 13
 #define ISCSI_HOST_ATTRS 4
 
@@ -1634,6 +1634,8 @@ iscsi_session_attr(password_in, ISCSI_PARAM_PASSWORD_IN, 1);
 iscsi_session_attr(fast_abort, ISCSI_PARAM_FAST_ABORT, 0);
 iscsi_session_attr(abort_tmo, ISCSI_PARAM_ABORT_TMO, 0);
 iscsi_session_attr(lu_reset_tmo, ISCSI_PARAM_LU_RESET_TMO, 0);
+iscsi_session_attr(ifacename, ISCSI_PARAM_IFACE_NAME, 0);
+iscsi_session_attr(initiatorname, ISCSI_PARAM_INITIATOR_NAME, 0)
 
 static ssize_t
 show_priv_session_state(struct device *dev, struct device_attribute *attr,
@@ -1875,6 +1877,8 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_SESSION_RD_ATTR(fast_abort, ISCSI_FAST_ABORT);
 	SETUP_SESSION_RD_ATTR(abort_tmo, ISCSI_ABORT_TMO);
 	SETUP_SESSION_RD_ATTR(lu_reset_tmo,ISCSI_LU_RESET_TMO);
+	SETUP_SESSION_RD_ATTR(ifacename, ISCSI_IFACE_NAME);
+	SETUP_SESSION_RD_ATTR(initiatorname, ISCSI_INITIATOR_NAME);
 	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
 	SETUP_PRIV_SESSION_RD_ATTR(state);
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index a0f13a2..16be12f 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -257,42 +257,49 @@ enum iscsi_param {
 
 	ISCSI_PARAM_PING_TMO,
 	ISCSI_PARAM_RECV_TMO,
+
+	ISCSI_PARAM_IFACE_NAME,
+	ISCSI_PARAM_ISID,
+	ISCSI_PARAM_INITIATOR_NAME,
 	/* must always be last */
 	ISCSI_PARAM_MAX,
 };
 
-#define ISCSI_MAX_RECV_DLENGTH		(1 << ISCSI_PARAM_MAX_RECV_DLENGTH)
-#define ISCSI_MAX_XMIT_DLENGTH		(1 << ISCSI_PARAM_MAX_XMIT_DLENGTH)
-#define ISCSI_HDRDGST_EN		(1 << ISCSI_PARAM_HDRDGST_EN)
-#define ISCSI_DATADGST_EN		(1 << ISCSI_PARAM_DATADGST_EN)
-#define ISCSI_INITIAL_R2T_EN		(1 << ISCSI_PARAM_INITIAL_R2T_EN)
-#define ISCSI_MAX_R2T			(1 << ISCSI_PARAM_MAX_R2T)
-#define ISCSI_IMM_DATA_EN		(1 << ISCSI_PARAM_IMM_DATA_EN)
-#define ISCSI_FIRST_BURST		(1 << ISCSI_PARAM_FIRST_BURST)
-#define ISCSI_MAX_BURST			(1 << ISCSI_PARAM_MAX_BURST)
-#define ISCSI_PDU_INORDER_EN		(1 << ISCSI_PARAM_PDU_INORDER_EN)
-#define ISCSI_DATASEQ_INORDER_EN	(1 << ISCSI_PARAM_DATASEQ_INORDER_EN)
-#define ISCSI_ERL			(1 << ISCSI_PARAM_ERL)
-#define ISCSI_IFMARKER_EN		(1 << ISCSI_PARAM_IFMARKER_EN)
-#define ISCSI_OFMARKER_EN		(1 << ISCSI_PARAM_OFMARKER_EN)
-#define ISCSI_EXP_STATSN		(1 << ISCSI_PARAM_EXP_STATSN)
-#define ISCSI_TARGET_NAME		(1 << ISCSI_PARAM_TARGET_NAME)
-#define ISCSI_TPGT			(1 << ISCSI_PARAM_TPGT)
-#define ISCSI_PERSISTENT_ADDRESS	(1 << ISCSI_PARAM_PERSISTENT_ADDRESS)
-#define ISCSI_PERSISTENT_PORT		(1 << ISCSI_PARAM_PERSISTENT_PORT)
-#define ISCSI_SESS_RECOVERY_TMO		(1 << ISCSI_PARAM_SESS_RECOVERY_TMO)
-#define ISCSI_CONN_PORT			(1 << ISCSI_PARAM_CONN_PORT)
-#define ISCSI_CONN_ADDRESS		(1 << ISCSI_PARAM_CONN_ADDRESS)
-#define ISCSI_USERNAME			(1 << ISCSI_PARAM_USERNAME)
-#define ISCSI_USERNAME_IN		(1 << ISCSI_PARAM_USERNAME_IN)
-#define ISCSI_PASSWORD			(1 << ISCSI_PARAM_PASSWORD)
-#define ISCSI_PASSWORD_IN		(1 << ISCSI_PARAM_PASSWORD_IN)
-#define ISCSI_FAST_ABORT		(1 << ISCSI_PARAM_FAST_ABORT)
-#define ISCSI_ABORT_TMO			(1 << ISCSI_PARAM_ABORT_TMO)
-#define ISCSI_LU_RESET_TMO		(1 << ISCSI_PARAM_LU_RESET_TMO)
-#define ISCSI_HOST_RESET_TMO		(1 << ISCSI_PARAM_HOST_RESET_TMO)
-#define ISCSI_PING_TMO			(1 << ISCSI_PARAM_PING_TMO)
-#define ISCSI_RECV_TMO			(1 << ISCSI_PARAM_RECV_TMO)
+#define ISCSI_MAX_RECV_DLENGTH		(1ULL << ISCSI_PARAM_MAX_RECV_DLENGTH)
+#define ISCSI_MAX_XMIT_DLENGTH		(1ULL << ISCSI_PARAM_MAX_XMIT_DLENGTH)
+#define ISCSI_HDRDGST_EN		(1ULL << ISCSI_PARAM_HDRDGST_EN)
+#define ISCSI_DATADGST_EN		(1ULL << ISCSI_PARAM_DATADGST_EN)
+#define ISCSI_INITIAL_R2T_EN		(1ULL << ISCSI_PARAM_INITIAL_R2T_EN)
+#define ISCSI_MAX_R2T			(1ULL << ISCSI_PARAM_MAX_R2T)
+#define ISCSI_IMM_DATA_EN		(1ULL << ISCSI_PARAM_IMM_DATA_EN)
+#define ISCSI_FIRST_BURST		(1ULL << ISCSI_PARAM_FIRST_BURST)
+#define ISCSI_MAX_BURST			(1ULL << ISCSI_PARAM_MAX_BURST)
+#define ISCSI_PDU_INORDER_EN		(1ULL << ISCSI_PARAM_PDU_INORDER_EN)
+#define ISCSI_DATASEQ_INORDER_EN	(1ULL << ISCSI_PARAM_DATASEQ_INORDER_EN)
+#define ISCSI_ERL			(1ULL << ISCSI_PARAM_ERL)
+#define ISCSI_IFMARKER_EN		(1ULL << ISCSI_PARAM_IFMARKER_EN)
+#define ISCSI_OFMARKER_EN		(1ULL << ISCSI_PARAM_OFMARKER_EN)
+#define ISCSI_EXP_STATSN		(1ULL << ISCSI_PARAM_EXP_STATSN)
+#define ISCSI_TARGET_NAME		(1ULL << ISCSI_PARAM_TARGET_NAME)
+#define ISCSI_TPGT			(1ULL << ISCSI_PARAM_TPGT)
+#define ISCSI_PERSISTENT_ADDRESS	(1ULL << ISCSI_PARAM_PERSISTENT_ADDRESS)
+#define ISCSI_PERSISTENT_PORT		(1ULL << ISCSI_PARAM_PERSISTENT_PORT)
+#define ISCSI_SESS_RECOVERY_TMO		(1ULL << ISCSI_PARAM_SESS_RECOVERY_TMO)
+#define ISCSI_CONN_PORT			(1ULL << ISCSI_PARAM_CONN_PORT)
+#define ISCSI_CONN_ADDRESS		(1ULL << ISCSI_PARAM_CONN_ADDRESS)
+#define ISCSI_USERNAME			(1ULL << ISCSI_PARAM_USERNAME)
+#define ISCSI_USERNAME_IN		(1ULL << ISCSI_PARAM_USERNAME_IN)
+#define ISCSI_PASSWORD			(1ULL << ISCSI_PARAM_PASSWORD)
+#define ISCSI_PASSWORD_IN		(1ULL << ISCSI_PARAM_PASSWORD_IN)
+#define ISCSI_FAST_ABORT		(1ULL << ISCSI_PARAM_FAST_ABORT)
+#define ISCSI_ABORT_TMO			(1ULL << ISCSI_PARAM_ABORT_TMO)
+#define ISCSI_LU_RESET_TMO		(1ULL << ISCSI_PARAM_LU_RESET_TMO)
+#define ISCSI_HOST_RESET_TMO		(1ULL << ISCSI_PARAM_HOST_RESET_TMO)
+#define ISCSI_PING_TMO			(1ULL << ISCSI_PARAM_PING_TMO)
+#define ISCSI_RECV_TMO			(1ULL << ISCSI_PARAM_RECV_TMO)
+#define ISCSI_IFACE_NAME		(1ULL << ISCSI_PARAM_IFACE_NAME)
+#define ISCSI_ISID			(1ULL << ISCSI_PARAM_ISID)
+#define ISCSI_INITIATOR_NAME		(1ULL << ISCSI_PARAM_INITIATOR_NAME)
 
 /* iSCSI HBA params */
 enum iscsi_host_param {
@@ -303,10 +310,10 @@ enum iscsi_host_param {
 	ISCSI_HOST_PARAM_MAX,
 };
 
-#define ISCSI_HOST_HWADDRESS		(1 << ISCSI_HOST_PARAM_HWADDRESS)
-#define ISCSI_HOST_INITIATOR_NAME	(1 << ISCSI_HOST_PARAM_INITIATOR_NAME)
-#define ISCSI_HOST_NETDEV_NAME		(1 << ISCSI_HOST_PARAM_NETDEV_NAME)
-#define ISCSI_HOST_IPADDRESS		(1 << ISCSI_HOST_PARAM_IPADDRESS)
+#define ISCSI_HOST_HWADDRESS		(1ULL << ISCSI_HOST_PARAM_HWADDRESS)
+#define ISCSI_HOST_INITIATOR_NAME	(1ULL << ISCSI_HOST_PARAM_INITIATOR_NAME)
+#define ISCSI_HOST_NETDEV_NAME		(1ULL << ISCSI_HOST_PARAM_NETDEV_NAME)
+#define ISCSI_HOST_IPADDRESS		(1ULL << ISCSI_HOST_PARAM_IPADDRESS)
 
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 13c92d7..21cfb1d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -270,6 +270,8 @@ struct iscsi_session {
 	char			*password;
 	char			*password_in;
 	char			*targetname;
+	char			*ifacename;
+	char			*initiatorname;
 	/* control data */
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
-- 
1.5.4.1

