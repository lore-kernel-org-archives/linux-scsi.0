From: michaelc@cs.wisc.edu
Subject: [PATCH 19/19] iscsi class, iscsi_tcp, iser, qla4xxx: add netdevname sysfs attr
Date: Wed, 30 May 2007 12:57:25 -0500
Message-ID: <1180547864924-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu> <1180547857548-git-send-email-michaelc@cs.wisc.edu> <118054785852-git-send-email-michaelc@cs.wisc.edu> <11805478592848-git-send-email-michaelc@cs.wisc.edu> <11805478601019-git-send-email-michaelc@cs.wisc.edu> <11805478611832-git-send-email-michaelc@cs.wisc.edu> <11805478623536-git-send-email-michaelc@cs.wisc.edu> <11805478623287-git-send-email-michaelc@cs.w
 isc.edu> <11805478632103-git-send-email-michaelc@cs.wisc.edu> <11805478643847-git-send-em!
 ail-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbXE3R5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:52 -0400
In-Reply-To: <11805478643847-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iSCSI must support software iscsi (iscsi_tcp, iser), hardware iscsi (qla4xxx),
and partial offload (broadcom). To be able to allow each stack or driver
or port (virtual or physical) to be able to log into the same target portal
we use the initiator tuple [[HWADDRESS | NETDEVNAME], INITIATOR_NAME] and
the target tuple [TARGETNAME, CONN_ADDRESS, CONN_PORT] to id a session.
This patch adds the netdev name, which is used by software iscsi when
it binds a session to a netdevice using the SO_BINDTODEVICE sock opt.
It cannot use HWADDRESS because if someone did vlans then the same netdevice
will have the same mac and the initiator,target id will not be unique.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 drivers/scsi/iscsi_tcp.c                 |    3 ++-
 drivers/scsi/libiscsi.c                  |   11 +++++++++++
 drivers/scsi/qla4xxx/ql4_os.c            |    3 ++-
 drivers/scsi/scsi_transport_iscsi.c      |    6 ++++--
 include/scsi/iscsi_if.h                  |    3 +++
 include/scsi/libiscsi.h                  |    3 ++-
 7 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index bed583c..1bf173d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -583,6 +583,7 @@ static struct iscsi_transport iscsi_iser
 				  ISCSI_USERNAME | ISCSI_PASSWORD |
 				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
+				  ISCSI_HOST_NETDEV_NAME |
 				  ISCSI_HOST_INITIATOR_NAME,
 	.host_template          = &iscsi_iser_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index da66fb5..d5a6527 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2303,7 +2303,8 @@ static struct iscsi_transport iscsi_tcp_
 				  ISCSI_USERNAME | ISCSI_PASSWORD |
 				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
-				  ISCSI_HOST_INITIATOR_NAME,
+				  ISCSI_HOST_INITIATOR_NAME |
+				  ISCSI_HOST_NETDEV_NAME,
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1632866..865dd57 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1483,6 +1483,7 @@ void iscsi_session_teardown(struct iscsi
 	kfree(session->username);
 	kfree(session->username_in);
 	kfree(session->targetname);
+	kfree(session->netdev);
 	kfree(session->hwaddress);
 	kfree(session->initiatorname);
 
@@ -2040,6 +2041,12 @@ int iscsi_host_get_param(struct Scsi_Hos
 	int len;
 
 	switch (param) {
+	case ISCSI_HOST_PARAM_NETDEV_NAME:
+		if (!session->netdev)
+			len = sprintf(buf, "%s\n", "default");
+		else
+			len = sprintf(buf, "%s\n", session->netdev);
+		break;
 	case ISCSI_HOST_PARAM_HWADDRESS:
 		if (!session->hwaddress)
 			len = sprintf(buf, "%s\n", "default");
@@ -2067,6 +2074,10 @@ int iscsi_host_set_param(struct Scsi_Hos
 	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 
 	switch (param) {
+	case ISCSI_HOST_PARAM_NETDEV_NAME:
+		if (!session->netdev)
+			session->netdev = kstrdup(buf, GFP_KERNEL);
+		break;
 	case ISCSI_HOST_PARAM_HWADDRESS:
 		if (!session->hwaddress)
 			session->hwaddress = kstrdup(buf, GFP_KERNEL);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b87b460..e69160a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -102,7 +102,8 @@ static struct scsi_host_template qla4xxx
 static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.owner			= THIS_MODULE,
 	.name			= DRIVER_NAME,
-	.caps			= CAP_FW_DB | CAP_SENDTARGETS_OFFLOAD,
+	.caps			= CAP_FW_DB | CAP_SENDTARGETS_OFFLOAD |
+				  CAP_DATA_PATH_OFFLOAD,
 	.param_mask		= ISCSI_CONN_PORT | ISCSI_CONN_ADDRESS |
 				  ISCSI_TARGET_NAME | ISCSI_TPGT,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9b54eea..34c1860 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -32,7 +32,7 @@ #include <scsi/iscsi_if.h>
 
 #define ISCSI_SESSION_ATTRS 15
 #define ISCSI_CONN_ATTRS 11
-#define ISCSI_HOST_ATTRS 3
+#define ISCSI_HOST_ATTRS 4
 #define ISCSI_TRANSPORT_VERSION "2.0-724"
 
 struct iscsi_internal {
@@ -1261,8 +1261,9 @@ #define iscsi_host_attr(field, param)			
 static ISCSI_CLASS_ATTR(host, field, S_IRUGO, show_host_param_##param,	\
 			NULL);
 
-iscsi_host_attr(ipaddress, ISCSI_HOST_PARAM_IPADDRESS);
+iscsi_host_attr(netdev, ISCSI_HOST_PARAM_NETDEV_NAME);
 iscsi_host_attr(hwaddress, ISCSI_HOST_PARAM_HWADDRESS);
+iscsi_host_attr(ipaddress, ISCSI_HOST_PARAM_IPADDRESS);
 iscsi_host_attr(initiatorname, ISCSI_HOST_PARAM_INITIATOR_NAME);
 
 #define SETUP_PRIV_SESSION_RD_ATTR(field)				\
@@ -1399,6 +1400,7 @@ iscsi_register_transport(struct iscsi_tr
 	priv->t.host_size = sizeof(struct iscsi_host);
 	transport_container_register(&priv->t.host_attrs);
 
+	SETUP_HOST_RD_ATTR(netdev, ISCSI_HOST_NETDEV_NAME);
 	SETUP_HOST_RD_ATTR(ipaddress, ISCSI_HOST_IPADDRESS);
 	SETUP_HOST_RD_ATTR(hwaddress, ISCSI_HOST_HWADDRESS);
 	SETUP_HOST_RD_ATTR(initiatorname, ISCSI_HOST_INITIATOR_NAME);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 6429980..50e907f 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -271,12 +271,14 @@ #define ISCSI_PASSWORD_IN		(1 << ISCSI_P
 enum iscsi_host_param {
 	ISCSI_HOST_PARAM_HWADDRESS,
 	ISCSI_HOST_PARAM_INITIATOR_NAME,
+	ISCSI_HOST_PARAM_NETDEV_NAME,
 	ISCSI_HOST_PARAM_IPADDRESS,
 	ISCSI_HOST_PARAM_MAX,
 };
 
 #define ISCSI_HOST_HWADDRESS		(1 << ISCSI_HOST_PARAM_HWADDRESS)
 #define ISCSI_HOST_INITIATOR_NAME	(1 << ISCSI_HOST_PARAM_INITIATOR_NAME)
+#define ISCSI_HOST_NETDEV_NAME		(1 << ISCSI_HOST_PARAM_NETDEV_NAME)
 #define ISCSI_HOST_IPADDRESS		(1 << ISCSI_HOST_PARAM_IPADDRESS)
 
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
@@ -303,6 +305,7 @@ #define CAP_TEXT_NEGO		0x80
 #define CAP_MARKERS		0x100
 #define CAP_FW_DB		0x200
 #define CAP_SENDTARGETS_OFFLOAD	0x400
+#define CAP_DATA_PATH_OFFLOAD	0x800
 
 /*
  * These flags describes reason of stop_conn() call
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index eea33f7..3f631b0 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -228,8 +228,9 @@ struct iscsi_session {
 	char			*password_in;
 	char			*targetname;
 	char			*initiatorname;
-	/* hw address being used for iscsi connection */
+	/* hw address or netdev iscsi connection is bound to */
 	char			*hwaddress;
+	char			*netdev;
 	/* control data */
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
-- 
1.4.1.1

