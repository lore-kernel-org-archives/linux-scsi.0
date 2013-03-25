From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/3] qla4xxx: Replace dev type macros with generic portal type macros
Date: Mon, 25 Mar 2013 08:08:32 -0400
Message-ID: <1364213313-17754-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1364213313-17754-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:65258 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756782Ab3CYMb3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 08:31:29 -0400
In-Reply-To: <1364213313-17754-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, manish.rangankar@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |  3 ---
 drivers/scsi/qla4xxx/ql4_os.c  | 26 ++++++++++++++------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index b487b0a..ddf16a8 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -159,9 +159,6 @@
 #define LSDW(x) ((u32)((u64)(x)))
 #define MSDW(x) ((u32)((((u64)(x)) >> 16) >> 16))
 
-#define DEV_TYPE_IPV4	"ipv4"
-#define DEV_TYPE_IPV6	"ipv6"
-
 #define DEV_DB_NON_PERSISTENT	0
 #define DEV_DB_PERSISTENT	1
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 497ac68..95a951c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2021,11 +2021,13 @@ static int qla4xxx_copy_from_fwddb_param(struct iscsi_bus_flash_session *sess,
 	options = le16_to_cpu(fw_ddb_entry->options);
 	conn->is_fw_assigned_ipv6 = test_bit(OPT_IS_FW_ASSIGNED_IPV6, &options);
 	if (test_bit(OPT_IPV6_DEVICE, &options)) {
-		rc = iscsi_switch_str_param(&sess->portal_type, DEV_TYPE_IPV6);
+		rc = iscsi_switch_str_param(&sess->portal_type,
+					    PORTAL_TYPE_IPV6);
 		if (rc)
 			goto exit_copy;
 	} else {
-		rc = iscsi_switch_str_param(&sess->portal_type, DEV_TYPE_IPV4);
+		rc = iscsi_switch_str_param(&sess->portal_type,
+					    PORTAL_TYPE_IPV4);
 		if (rc)
 			goto exit_copy;
 	}
@@ -2161,7 +2163,7 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
 
 	options = le16_to_cpu(fw_ddb_entry->options);
 	SET_BITVAL(conn->is_fw_assigned_ipv6,  options, BIT_11);
-	if (!strncmp(sess->portal_type, DEV_TYPE_IPV6, 4))
+	if (!strncmp(sess->portal_type, PORTAL_TYPE_IPV6, 4))
 		options |= BIT_8;
 	else
 		options &= ~BIT_8;
@@ -5578,8 +5580,8 @@ static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
 	uint32_t options = 0;
 	uint32_t rval = QLA_ERROR;
 
-	if (strncasecmp(DEV_TYPE_IPV4, buf, 4) &&
-	    strncasecmp(DEV_TYPE_IPV6, buf, 4)) {
+	if (strncasecmp(PORTAL_TYPE_IPV4, buf, 4) &&
+	    strncasecmp(PORTAL_TYPE_IPV6, buf, 4)) {
 		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: Invalid portal type\n",
 				  __func__));
 		goto exit_ddb_add;
@@ -5663,7 +5665,7 @@ static int  qla4xxx_sysfs_ddb_apply(struct iscsi_bus_flash_session *fnode_sess,
 		goto exit_ddb_apply;
 	}
 
-	if (!strncasecmp(fnode_sess->portal_type, DEV_TYPE_IPV6, 4))
+	if (!strncasecmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
 		options |= IPV6_DEFAULT_DDB_ENTRY;
 
 	rval = qla4xxx_get_default_ddb(ha, options, fw_ddb_entry_dma);
@@ -5858,7 +5860,7 @@ static int qla4xxx_sysfs_ddb_login(struct iscsi_bus_flash_session *fnode_sess,
 		goto exit_ddb_login;
 	}
 
-	if (!strncasecmp(fnode_sess->portal_type, DEV_TYPE_IPV6, 4))
+	if (!strncasecmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
 		options |= IPV6_DEFAULT_DDB_ENTRY;
 
 	ret = qla4xxx_get_default_ddb(ha, options, fw_ddb_entry_dma);
@@ -6038,7 +6040,7 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 	strncpy(flash_tddb->iscsi_name, fnode_sess->targetname,
 		ISCSI_NAME_SIZE);
 
-	if (!strncmp(fnode_sess->portal_type, DEV_TYPE_IPV6, 4))
+	if (!strncmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
 		sprintf(flash_tddb->ip_addr, "%pI6", fnode_conn->ipaddress);
 	else
 		sprintf(flash_tddb->ip_addr, "%pI4", fnode_conn->ipaddress);
@@ -6220,7 +6222,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
 			     fnode_sess->default_taskmgmt_timeout);
 		break;
 	case ISCSI_FLASHNODE_IPADDR:
-		if (!strncmp(fnode_sess->portal_type, DEV_TYPE_IPV6, 4))
+		if (!strncmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
 			rc = sprintf(buf, "%pI6\n", fnode_conn->ipaddress);
 		else
 			rc = sprintf(buf, "%pI4\n", fnode_conn->ipaddress);
@@ -6232,7 +6234,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
 			rc = sprintf(buf, "\n");
 		break;
 	case ISCSI_FLASHNODE_REDIRECT_IPADDR:
-		if (!strncmp(fnode_sess->portal_type, DEV_TYPE_IPV6, 4))
+		if (!strncmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
 			rc = sprintf(buf, "%pI6\n",
 				     fnode_conn->redirect_ipaddr);
 		else
@@ -6249,7 +6251,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
 		rc = sprintf(buf, "%u\n", fnode_conn->ipv4_tos);
 		break;
 	case ISCSI_FLASHNODE_IPV6_TC:
-		if (!strncmp(fnode_sess->portal_type, DEV_TYPE_IPV6, 4))
+		if (!strncmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
 			rc = sprintf(buf, "%u\n",
 				     fnode_conn->ipv6_traffic_class);
 		else
@@ -6259,7 +6261,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
 		rc = sprintf(buf, "%u\n", fnode_conn->ipv6_flow_label);
 		break;
 	case ISCSI_FLASHNODE_LINK_LOCAL_IPV6:
-		if (!strncmp(fnode_sess->portal_type, DEV_TYPE_IPV6, 4))
+		if (!strncmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
 			rc = sprintf(buf, "%pI6\n",
 				     fnode_conn->link_local_ipv6_addr);
 		else
-- 
1.8.2.GIT

