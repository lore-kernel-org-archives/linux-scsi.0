From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 09/10] iscsi_transport: added new iscsi_param to display
	target alias is sysfs
Date: Sat, 10 Jul 2010 14:51:30 +0530
Message-ID: <20100710092130.GA11543@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:54642
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753738Ab0GJJZJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jul 2010 05:25:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c     |    3 +++
 drivers/scsi/qla4xxx/ql4_os.c       |    7 ++++++-
 drivers/scsi/scsi_transport_iscsi.c |    6 ++++--
 include/scsi/iscsi_if.h             |    2 ++
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index cdaf4bf..56f6d75 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -593,6 +593,9 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 	memcpy(&ddb_entry->iscsi_name[0], &fw_ddb_entry->iscsi_name[0],
 	       min(sizeof(ddb_entry->iscsi_name),
 		   sizeof(fw_ddb_entry->iscsi_name)));
+	memcpy(&ddb_entry->iscsi_alias[0], &fw_ddb_entry->iscsi_alias[0],
+	       min(sizeof(ddb_entry->iscsi_alias),
+		   sizeof(fw_ddb_entry->iscsi_alias)));
 	memcpy(&ddb_entry->ip_addr[0], &fw_ddb_entry->ip_addr[0],
 	       min(sizeof(ddb_entry->ip_addr), sizeof(fw_ddb_entry->ip_addr)));
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 80cb74e..686103d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -126,7 +126,8 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.caps			= CAP_FW_DB | CAP_SENDTARGETS_OFFLOAD |
 				  CAP_DATA_PATH_OFFLOAD,
 	.param_mask		= ISCSI_CONN_PORT | ISCSI_CONN_ADDRESS |
-				  ISCSI_TARGET_NAME | ISCSI_TPGT,
+				  ISCSI_TARGET_NAME | ISCSI_TPGT |
+				  ISCSI_TARGET_ALIAS,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
@@ -210,6 +211,10 @@ static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
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
index 1e6d479..b9aec30 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -31,7 +31,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 
-#define ISCSI_SESSION_ATTRS 22
+#define ISCSI_SESSION_ATTRS 23
 #define ISCSI_CONN_ATTRS 13
 #define ISCSI_HOST_ATTRS 4
 
@@ -1763,7 +1763,8 @@ iscsi_session_attr(abort_tmo, ISCSI_PARAM_ABORT_TMO, 0);
 iscsi_session_attr(lu_reset_tmo, ISCSI_PARAM_LU_RESET_TMO, 0);
 iscsi_session_attr(tgt_reset_tmo, ISCSI_PARAM_TGT_RESET_TMO, 0);
 iscsi_session_attr(ifacename, ISCSI_PARAM_IFACE_NAME, 0);
-iscsi_session_attr(initiatorname, ISCSI_PARAM_INITIATOR_NAME, 0)
+iscsi_session_attr(initiatorname, ISCSI_PARAM_INITIATOR_NAME, 0);
+iscsi_session_attr(targetalias, ISCSI_PARAM_TARGET_ALIAS, 0);
 
 static ssize_t
 show_priv_session_state(struct device *dev, struct device_attribute *attr,
@@ -2006,6 +2007,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_SESSION_RD_ATTR(tgt_reset_tmo,ISCSI_TGT_RESET_TMO);
 	SETUP_SESSION_RD_ATTR(ifacename, ISCSI_IFACE_NAME);
 	SETUP_SESSION_RD_ATTR(initiatorname, ISCSI_INITIATOR_NAME);
+	SETUP_SESSION_RD_ATTR(targetalias, ISCSI_TARGET_ALIAS);
 	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
 	SETUP_PRIV_SESSION_RD_ATTR(state);
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 66d377b..a8631ac 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -313,6 +313,7 @@ enum iscsi_param {
 	ISCSI_PARAM_INITIATOR_NAME,
 
 	ISCSI_PARAM_TGT_RESET_TMO,
+	ISCSI_PARAM_TARGET_ALIAS,
 	/* must always be last */
 	ISCSI_PARAM_MAX,
 };
@@ -353,6 +354,7 @@ enum iscsi_param {
 #define ISCSI_ISID			(1ULL << ISCSI_PARAM_ISID)
 #define ISCSI_INITIATOR_NAME		(1ULL << ISCSI_PARAM_INITIATOR_NAME)
 #define ISCSI_TGT_RESET_TMO		(1ULL << ISCSI_PARAM_TGT_RESET_TMO)
+#define ISCSI_TARGET_ALIAS		(1ULL << ISCSI_PARAM_TARGET_ALIAS)
 
 /* iSCSI HBA params */
 enum iscsi_host_param {
-- 
1.7.0.5

