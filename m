From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 6/7][RFC] iscsi_transport: Added new iscsi_host_param for
	iSCSI transport
Date: Tue, 11 May 2010 13:29:56 +0530
Message-ID: <20100511075956.GA30776@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:12652
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755960Ab0EKID5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 04:03:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Modify QLogic qla4xxx driver to support new host param.

New host param added:
- ISCSI_HOST_PARAM_GATEWAY,
- ISCSI_HOST_PARAM_SUBNET,
- ISCSI_HOST_PARAM_ALIAS,
- ISCSI_HOST_PARAM_IF_TYPE,

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c       |   24 ++++++++++++++++++++----
 drivers/scsi/scsi_transport_iscsi.c |   10 +++++++++-
 include/scsi/iscsi_if.h             |    8 ++++++++
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a3b45e2..c21c864 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -125,7 +125,11 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 				  ISCSI_TARGET_ALIAS,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_IPADDRESS |
-				  ISCSI_HOST_INITIATOR_NAME,
+				  ISCSI_HOST_INITIATOR_NAME |
+				  ISCSI_HOST_GATEWAY |
+				  ISCSI_HOST_SUBNET |
+				  ISCSI_HOST_ALIAS |
+				  ISCSI_HOST_IF_TYPE,
 	.tgt_dscvr		= qla4xxx_tgt_dscvr,
 	.get_conn_param		= qla4xxx_conn_get_param,
 	.get_session_param	= qla4xxx_sess_get_param,
@@ -394,13 +398,25 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 		len = sysfs_format_mac(buf, ha->my_mac, MAC_ADDR_LEN);
 		break;
 	case ISCSI_HOST_PARAM_IPADDRESS:
-		len = sprintf(buf, "%d.%d.%d.%d\n", ha->ip_address[0],
-			      ha->ip_address[1], ha->ip_address[2],
-			      ha->ip_address[3]);
+		len = sprintf(buf, "%pI4\n", ha->ip_address);
 		break;
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
 		len = sprintf(buf, "%s\n", ha->name_string);
 		break;
+	case ISCSI_HOST_PARAM_GATEWAY:
+		len = sprintf(buf, "%pI4\n", ha->gateway);
+		break;
+	case ISCSI_HOST_PARAM_SUBNET:
+		len = sprintf(buf, "%pI4\n", ha->subnet_mask);
+		break;
+	case ISCSI_HOST_PARAM_ALIAS:
+		len = sprintf(buf, "%s\n", ha->alias);
+		break;
+	case ISCSI_HOST_PARAM_IF_TYPE:
+		len = sprintf(buf, "%s\n", ((ha->addl_fw_state &
+		    FW_ADDSTATE_OPTICAL_MEDIA) != 0) ?
+		    "Optical" : "Copper");
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fb433d8..13cf062 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -35,7 +35,7 @@
 
 #define ISCSI_SESSION_ATTRS 23
 #define ISCSI_CONN_ATTRS 13
-#define ISCSI_HOST_ATTRS 4
+#define ISCSI_HOST_ATTRS 8
 
 #define ISCSI_TRANSPORT_VERSION "2.0-870"
 
@@ -2271,6 +2271,10 @@ iscsi_host_attr(netdev, ISCSI_HOST_PARAM_NETDEV_NAME);
 iscsi_host_attr(hwaddress, ISCSI_HOST_PARAM_HWADDRESS);
 iscsi_host_attr(ipaddress, ISCSI_HOST_PARAM_IPADDRESS);
 iscsi_host_attr(initiatorname, ISCSI_HOST_PARAM_INITIATOR_NAME);
+iscsi_host_attr(gateway, ISCSI_HOST_PARAM_GATEWAY);
+iscsi_host_attr(subnet, ISCSI_HOST_PARAM_SUBNET);
+iscsi_host_attr(alias, ISCSI_HOST_PARAM_ALIAS);
+iscsi_host_attr(interface, ISCSI_HOST_PARAM_IF_TYPE);
 
 #define SETUP_PRIV_SESSION_RD_ATTR(field)				\
 do {									\
@@ -2410,6 +2414,10 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_HOST_RD_ATTR(ipaddress, ISCSI_HOST_IPADDRESS);
 	SETUP_HOST_RD_ATTR(hwaddress, ISCSI_HOST_HWADDRESS);
 	SETUP_HOST_RD_ATTR(initiatorname, ISCSI_HOST_INITIATOR_NAME);
+	SETUP_HOST_RD_ATTR(gateway, ISCSI_HOST_GATEWAY);
+	SETUP_HOST_RD_ATTR(subnet, ISCSI_HOST_SUBNET);
+	SETUP_HOST_RD_ATTR(alias, ISCSI_HOST_ALIAS);
+	SETUP_HOST_RD_ATTR(interface, ISCSI_HOST_IF_TYPE);
 	BUG_ON(count > ISCSI_HOST_ATTRS);
 	priv->host_attrs[count] = NULL;
 	count = 0;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 2990ca8..fa51817 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -362,6 +362,10 @@ enum iscsi_host_param {
 	ISCSI_HOST_PARAM_INITIATOR_NAME,
 	ISCSI_HOST_PARAM_NETDEV_NAME,
 	ISCSI_HOST_PARAM_IPADDRESS,
+	ISCSI_HOST_PARAM_GATEWAY,
+	ISCSI_HOST_PARAM_SUBNET,
+	ISCSI_HOST_PARAM_ALIAS,
+	ISCSI_HOST_PARAM_IF_TYPE,
 	ISCSI_HOST_PARAM_MAX,
 };
 
@@ -369,6 +373,10 @@ enum iscsi_host_param {
 #define ISCSI_HOST_INITIATOR_NAME	(1ULL << ISCSI_HOST_PARAM_INITIATOR_NAME)
 #define ISCSI_HOST_NETDEV_NAME		(1ULL << ISCSI_HOST_PARAM_NETDEV_NAME)
 #define ISCSI_HOST_IPADDRESS		(1ULL << ISCSI_HOST_PARAM_IPADDRESS)
+#define ISCSI_HOST_GATEWAY		(1ULL << ISCSI_HOST_PARAM_GATEWAY)
+#define ISCSI_HOST_SUBNET		(1ULL << ISCSI_HOST_PARAM_SUBNET)
+#define ISCSI_HOST_ALIAS		(1ULL << ISCSI_HOST_PARAM_ALIAS)
+#define ISCSI_HOST_IF_TYPE		(1ULL << ISCSI_HOST_PARAM_IF_TYPE)
 
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
-- 
1.7.0.5

