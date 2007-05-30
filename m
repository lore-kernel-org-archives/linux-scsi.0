From: michaelc@cs.wisc.edu
Subject: [PATCH 7/19] iscsi class, qla4xxx, iscsi_tcp, ib_iser: export/set initiator name
Date: Wed, 30 May 2007 12:57:13 -0500
Message-ID: <11805478531743-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbXE3R5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:44 -0400
In-Reply-To: <11805478523188-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

For iscsi root boot, software iscsi needs to know what the BIOS/OF
initiator used for the initiator name so this puts it in sysfs
for userspace to be able to pick up.

For hw iscsi, it is nice to see what the card is using.

This patch adds the new param, and hooks in qla4xxx, iscsi_tcp, and ib_iser.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    3 ++-
 drivers/scsi/iscsi_tcp.c                 |    3 ++-
 drivers/scsi/libiscsi.c                  |   12 ++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c            |    6 +++++-
 drivers/scsi/scsi_transport_iscsi.c      |    4 +++-
 include/scsi/iscsi_if.h                  |    2 ++
 include/scsi/libiscsi.h                  |    1 +
 7 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 2a99b7b..e39d9a0 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -576,7 +576,8 @@ static struct iscsi_transport iscsi_iser
 				  ISCSI_PERSISTENT_ADDRESS |
 				  ISCSI_TARGET_NAME |
 				  ISCSI_TPGT,
-	.host_param_mask	= ISCSI_HOST_HWADDRESS,
+	.host_param_mask	= ISCSI_HOST_HWADDRESS |
+				  ISCSI_HOST_INITIATOR_NAME,
 	.host_template          = &iscsi_iser_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_lun                = ISCSI_ISER_MAX_LUN,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9a42fc0..8201e6c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2181,7 +2181,8 @@ static struct iscsi_transport iscsi_tcp_
 				  ISCSI_PERSISTENT_ADDRESS |
 				  ISCSI_TARGET_NAME |
 				  ISCSI_TPGT,
-	.host_param_mask	= ISCSI_HOST_HWADDRESS,
+	.host_param_mask	= ISCSI_HOST_HWADDRESS |
+				  ISCSI_HOST_INITIATOR_NAME,
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d430e22..5e6a424 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1463,6 +1463,7 @@ void iscsi_session_teardown(struct iscsi
 
 	kfree(session->targetname);
 	kfree(session->hwaddress);
+	kfree(session->initiatorname);
 
 	iscsi_destroy_session(cls_session);
 	scsi_host_put(shost);
@@ -2004,6 +2005,13 @@ int iscsi_host_get_param(struct Scsi_Hos
 		else
 			len = sprintf(buf, "%s\n", session->hwaddress);
 		break;
+	case ISCSI_HOST_PARAM_INITIATOR_NAME:
+		if (!session->initiatorname)
+			len = sprintf(buf, "%s\n", "unknown");
+		else
+			len = sprintf(buf, "%s\n", session->initiatorname);
+		break;
+
 	default:
 		return -ENOSYS;
 	}
@@ -2022,6 +2030,10 @@ int iscsi_host_set_param(struct Scsi_Hos
 		if (!session->hwaddress)
 			session->hwaddress = kstrdup(buf, GFP_KERNEL);
 		break;
+	case ISCSI_HOST_PARAM_INITIATOR_NAME:
+		if (!session->initiatorname)
+			session->initiatorname = kstrdup(buf, GFP_KERNEL);
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 29cd4b9..7502bb4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -104,7 +104,8 @@ static struct iscsi_transport qla4xxx_is
 	.name			= DRIVER_NAME,
 	.param_mask		= ISCSI_CONN_PORT | ISCSI_CONN_ADDRESS |
 				  ISCSI_TARGET_NAME | ISCSI_TPGT,
-	.host_param_mask	= ISCSI_HOST_HWADDRESS,
+	.host_param_mask	= ISCSI_HOST_HWADDRESS |
+				  ISCSI_HOST_INITIATOR_NAME,
 	.sessiondata_size	= sizeof(struct ddb_entry),
 	.host_template		= &qla4xxx_driver_template,
 
@@ -190,6 +191,9 @@ static int qla4xxx_host_get_param(struct
 	case ISCSI_HOST_PARAM_HWADDRESS:
 		len = format_addr(buf, ha->my_mac, MAC_ADDR_LEN);
 		break;
+	case ISCSI_HOST_PARAM_INITIATOR_NAME:
+		len = sprintf(buf, ha->name_string);
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 3fd2da4..5ec2fbe 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -32,7 +32,7 @@ #include <scsi/iscsi_if.h>
 
 #define ISCSI_SESSION_ATTRS 11
 #define ISCSI_CONN_ATTRS 11
-#define ISCSI_HOST_ATTRS 1
+#define ISCSI_HOST_ATTRS 2
 #define ISCSI_TRANSPORT_VERSION "2.0-724"
 
 struct iscsi_internal {
@@ -1253,6 +1253,7 @@ static ISCSI_CLASS_ATTR(host, field, S_I
 			NULL);
 
 iscsi_host_attr(hwaddress, ISCSI_HOST_PARAM_HWADDRESS);
+iscsi_host_attr(initiatorname, ISCSI_HOST_PARAM_INITIATOR_NAME);
 
 #define SETUP_PRIV_SESSION_RD_ATTR(field)				\
 do {									\
@@ -1389,6 +1390,7 @@ iscsi_register_transport(struct iscsi_tr
 	transport_container_register(&priv->t.host_attrs);
 
 	SETUP_HOST_RD_ATTR(hwaddress, ISCSI_HOST_HWADDRESS);
+	SETUP_HOST_RD_ATTR(initiatorname, ISCSI_HOST_INITIATOR_NAME);
 	BUG_ON(count > ISCSI_HOST_ATTRS);
 	priv->host_attrs[count] = NULL;
 	count = 0;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 3d0372e..e057c5d 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -259,10 +259,12 @@ #define ISCSI_CONN_ADDRESS		(1 << ISCSI_
 /* iSCSI HBA params */
 enum iscsi_host_param {
 	ISCSI_HOST_PARAM_HWADDRESS,
+	ISCSI_HOST_PARAM_INITIATOR_NAME,
 	ISCSI_HOST_PARAM_MAX,
 };
 
 #define ISCSI_HOST_HWADDRESS		(1 << ISCSI_HOST_PARAM_HWADDRESS)
+#define ISCSI_HOST_INITIATOR_NAME	(1 << ISCSI_HOST_PARAM_INITIATOR_NAME)
 
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index e202cc0..deae90a 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -224,6 +224,7 @@ struct iscsi_session {
 	int			erl;
 	int			tpgt;
 	char			*targetname;
+	char			*initiatorname;
 	/* hw address being used for iscsi connection */
 	char			*hwaddress;
 	/* control data */
-- 
1.4.1.1

