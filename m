From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 17/20] be2iscsi: Add support for iscsi boot
Date: Mon, 12 Jul 2010 23:29:46 +0530
Message-ID: <20100712175931.GA11828@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:34313 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753258Ab0GLR7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:59:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu, konrad@darnok.org

  This patch contains changes for adding support for iscsi_boot.
Have modified to make read of mac address from chip as a function.

Since this is a rarely used call, I would like to make the call
 to the chip

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.h  |  147 +++++++++++++++--
 drivers/scsi/be2iscsi/be_iscsi.c |   71 +++++----
 drivers/scsi/be2iscsi/be_iscsi.h |    2 +
 drivers/scsi/be2iscsi/be_main.c  |  334 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/be2iscsi/be_main.h  |    2 +
 drivers/scsi/be2iscsi/be_mgmt.c  |   71 ++++++++
 6 files changed, 580 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 40641d0..5218de4 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -162,6 +162,13 @@ struct be_mcc_mailbox {
 #define OPCODE_COMMON_ISCSI_CFG_POST_SGL_PAGES		2
 #define OPCODE_COMMON_ISCSI_CFG_REMOVE_SGL_PAGES        3
 #define OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG		7
+#define OPCODE_COMMON_ISCSI_NTWK_SET_VLAN		14
+#define OPCODE_COMMON_ISCSI_NTWK_CONFIGURE_STATELESS_IP_ADDR	17
+#define OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR		21
+#define OPCODE_COMMON_ISCSI_NTWK_GET_DEFAULT_GATEWAY	22
+#define OPCODE_COMMON_ISCSI_NTWK_MODIFY_DEFAULT_GATEWAY 23
+#define OPCODE_COMMON_ISCSI_NTWK_GET_ALL_IF_ID		24
+#define OPCODE_COMMON_ISCSI_NTWK_GET_IF_INFO		25
 #define OPCODE_COMMON_ISCSI_SET_FRAGNUM_BITS_FOR_SGL_CRA 61
 #define OPCODE_COMMON_ISCSI_DEFQ_CREATE                 64
 #define OPCODE_COMMON_ISCSI_DEFQ_DESTROY		65
@@ -237,11 +244,109 @@ struct be_cmd_resp_eq_create {
 	u16 rsvd0;		/* sword */
 } __packed;
 
+struct mgmt_chap_format {
+	u32 flags;
+	u8  intr_chap_name[256];
+	u8  intr_secret[16];
+	u8  target_chap_name[256];
+	u8  target_secret[16];
+	u16 intr_chap_name_length;
+	u16 intr_secret_length;
+	u16 target_chap_name_length;
+	u16 target_secret_length;
+} __packed;
+
+struct mgmt_auth_method_format {
+	u8	auth_method_type;
+	u8	padding[3];
+	struct	mgmt_chap_format chap;
+} __packed;
+
+struct mgmt_conn_login_options {
+	u8 flags;
+	u8 header_digest;
+	u8 data_digest;
+	u8 rsvd0;
+	u32 max_recv_datasegment_len_ini;
+	u32 max_recv_datasegment_len_tgt;
+	u32 tcp_mss;
+	u32 tcp_window_size;
+	struct	mgmt_auth_method_format auth_data;
+} __packed;
+
+struct ip_address_format {
+	u16 size_of_structure;
+	u8 reserved;
+	u8 ip_type;
+	u8 ip_address[16];
+	u32 rsvd0;
+} __packed;
+
+struct	mgmt_conn_info {
+	u32	connection_handle;
+	u32	connection_status;
+	u16	src_port;
+	u16	dest_port;
+	u16	dest_port_redirected;
+	u16	cid;
+	u32	estimated_throughput;
+	struct	ip_address_format	src_ipaddr;
+	struct	ip_address_format	dest_ipaddr;
+	struct	ip_address_format	dest_ipaddr_redirected;
+	struct	mgmt_conn_login_options	negotiated_login_options;
+} __packed;
+
+struct mgmt_session_login_options {
+	u8	flags;
+	u8	error_recovery_level;
+	u16	rsvd0;
+	u32	first_burst_length;
+	u32	max_burst_length;
+	u16	max_connections;
+	u16	max_outstanding_r2t;
+	u16	default_time2wait;
+	u16	default_time2retain;
+} __packed;
+
+struct mgmt_session_info {
+	u32	session_handle;
+	u32	status;
+	u8	isid[6];
+	u16	tsih;
+	u32	session_flags;
+	u16	conn_count;
+	u16	pad;
+	u8	target_name[224];
+	u8	initiator_iscsiname[224];
+	struct	mgmt_session_login_options negotiated_login_options;
+	struct	mgmt_conn_info	conn_list[1];
+} __packed;
+
+struct  be_cmd_req_get_session {
+	struct be_cmd_req_hdr hdr;
+	u32 session_handle;
+} __packed;
+
+struct  be_cmd_resp_get_session {
+	struct be_cmd_resp_hdr hdr;
+	struct mgmt_session_info session_info;
+} __packed;
+
 struct mac_addr {
 	u16 size_of_struct;
 	u8 addr[ETH_ALEN];
 } __packed;
 
+struct be_cmd_req_get_boot_target {
+	struct be_cmd_req_hdr hdr;
+} __packed;
+
+struct be_cmd_resp_get_boot_target {
+	struct be_cmd_resp_hdr hdr;
+	u32  boot_session_count;
+	int  boot_session_handle;
+};
+
 struct be_cmd_req_mac_query {
 	struct be_cmd_req_hdr hdr;
 	u8 type;
@@ -426,6 +531,11 @@ int be_poll_mcc(struct be_ctrl_info *ctrl);
 int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				      struct beiscsi_hba *phba);
 unsigned int be_cmd_get_mac_addr(struct beiscsi_hba *phba);
+unsigned int beiscsi_get_boot_target(struct beiscsi_hba *phba);
+unsigned int beiscsi_get_session_info(struct beiscsi_hba *phba,
+				  u32 boot_session_handle,
+				  struct be_dma_mem *nonemb_cmd);
+
 void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag);
 /*ISCSI Functuions */
 int be_cmd_fw_initialize(struct be_ctrl_info *ctrl);
@@ -601,14 +711,6 @@ struct be_eq_delay_params_in {
 	struct eq_delay delay[8];
 } __packed;
 
-struct ip_address_format {
-	u16 size_of_structure;
-	u8 reserved;
-	u8 ip_type;
-	u8 ip_address[16];
-	u32 rsvd0;
-} __packed;
-
 struct tcp_connect_and_offload_in {
 	struct be_cmd_req_hdr hdr;
 	struct ip_address_format ip_address;
@@ -688,18 +790,29 @@ struct be_fw_cfg {
 	u32 function_caps;
 } __packed;
 
-#define CMD_ISCSI_COMMAND_INVALIDATE  1
-#define ISCSI_OPCODE_SCSI_DATA_OUT      5
+struct be_all_if_id {
+	struct be_cmd_req_hdr hdr;
+	u32 if_count;
+	u32 if_hndl_list[1];
+} __packed;
+
+#define ISCSI_OPCODE_SCSI_DATA_OUT		5
+#define OPCODE_COMMON_MODIFY_EQ_DELAY		41
+#define OPCODE_COMMON_ISCSI_CLEANUP		59
+#define	OPCODE_COMMON_TCP_UPLOAD		56
 #define OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD 70
-#define OPCODE_ISCSI_INI_DRIVER_OFFLOAD_SESSION 41
-#define OPCODE_COMMON_MODIFY_EQ_DELAY	41
-#define OPCODE_COMMON_ISCSI_CLEANUP	59
-#define	OPCODE_COMMON_TCP_UPLOAD	56
 #define OPCODE_COMMON_ISCSI_ERROR_RECOVERY_INVALIDATE_COMMANDS 1
-/* --- CMD_ISCSI_INVALIDATE_CONNECTION_TYPE --- */
-#define CMD_ISCSI_CONNECTION_INVALIDATE 0x8001
-#define CMD_ISCSI_CONNECTION_ISSUE_TCP_RST 0x8002
+#define OPCODE_ISCSI_INI_CFG_GET_HBA_NAME	6
+#define OPCODE_ISCSI_INI_CFG_SET_HBA_NAME	7
+#define OPCODE_ISCSI_INI_SESSION_GET_A_SESSION  14
+#define OPCODE_ISCSI_INI_DRIVER_OFFLOAD_SESSION 41
 #define OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION 42
+#define OPCODE_ISCSI_INI_BOOT_GET_BOOT_TARGET	52
+
+/* --- CMD_ISCSI_INVALIDATE_CONNECTION_TYPE --- */
+#define CMD_ISCSI_COMMAND_INVALIDATE		1
+#define CMD_ISCSI_CONNECTION_INVALIDATE		0x8001
+#define CMD_ISCSI_CONNECTION_ISSUE_TCP_RST	0x8002
 
 #define INI_WR_CMD			1	/* Initiator write command */
 #define INI_TMF_CMD			2	/* Initiator TMF command */
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index ff4a482..43c95b0 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -300,40 +300,16 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 			   enum iscsi_host_param param, char *buf)
 {
 	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
-	struct be_cmd_resp_get_mac_addr *resp;
-	struct be_mcc_wrb *wrb;
-	unsigned int tag, wrb_num;
 	int len = 0;
-	unsigned short status, extd_status;
-	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
+	int status;
 
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_get_host_param, param= %d\n", param);
 	switch (param) {
 	case ISCSI_HOST_PARAM_HWADDRESS:
-		tag = be_cmd_get_mac_addr(phba);
-		if (!tag) {
-			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed\n");
-			return -EAGAIN;
-		} else
-			wait_event_interruptible(phba->ctrl.mcc_wait[tag],
-						 phba->ctrl.mcc_numtag[tag]);
-
-		wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
-		extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
-		status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
-		if (status || extd_status) {
-			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed"
-					    " status = %d extd_status = %d\n",
-					    status, extd_status);
-			free_mcc_tag(&phba->ctrl, tag);
-			return -EAGAIN;
-		} else {
-			wrb = queue_get_wrb(mccq, wrb_num);
-			free_mcc_tag(&phba->ctrl, tag);
-			resp = embedded_payload(wrb);
-			memcpy(phba->mac_address, resp->mac_address, ETH_ALEN);
-			len = sysfs_format_mac(buf, phba->mac_address,
-					       ETH_ALEN);
+		status = beiscsi_get_macaddr(buf, phba);
+		if (status < 0) {
+			SE_DEBUG(DBG_LVL_1, "beiscsi_get_macaddr Failed\n");
+			return status;
 		}
 		break;
 	default:
@@ -342,6 +318,43 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 	return len;
 }
 
+int beiscsi_get_macaddr(char *buf, struct beiscsi_hba *phba)
+{
+	struct be_cmd_resp_get_mac_addr *resp;
+	struct be_mcc_wrb *wrb;
+	unsigned int tag, wrb_num;
+	unsigned short status, extd_status;
+	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
+	int rc;
+
+	tag = be_cmd_get_mac_addr(phba);
+	if (!tag) {
+		SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed\n");
+		return -EBUSY;
+	} else
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+					 phba->ctrl.mcc_numtag[tag]);
+
+	wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
+	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
+	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
+	if (status || extd_status) {
+		SE_DEBUG(DBG_LVL_1, "Failed to get be_cmd_get_mac_addr"
+				    " status = %d extd_status = %d\n",
+				    status, extd_status);
+		free_mcc_tag(&phba->ctrl, tag);
+		return -EAGAIN;
+	}
+	wrb = queue_get_wrb(mccq, wrb_num);
+	free_mcc_tag(&phba->ctrl, tag);
+	resp = embedded_payload(wrb);
+	memcpy(phba->mac_address, resp->mac_address, ETH_ALEN);
+	rc = sysfs_format_mac(buf, phba->mac_address,
+			       ETH_ALEN);
+	return rc;
+}
+
+
 /**
  * beiscsi_conn_get_stats - get the iscsi stats
  * @cls_conn: pointer to iscsi cls conn
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 1f512c2..5a7f9b7 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -54,6 +54,8 @@ int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 int beiscsi_get_host_param(struct Scsi_Host *shost,
 			   enum iscsi_host_param param, char *buf);
 
+int beiscsi_get_macaddr(char *buf, struct beiscsi_hba *phba);
+
 int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		      enum iscsi_param param, char *buf, int buflen);
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 5a98aff..d9102d3 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -26,6 +26,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/semaphore.h>
+#include <linux/iscsi_boot_sysfs.h>
 
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_transport_iscsi.h>
@@ -211,6 +212,229 @@ unlock:
 	return rc;
 }
 
+static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
+{
+	struct beiscsi_hba *phba = data;
+	char *str = buf;
+	int rc;
+
+	printk(KERN_ERR " In beiscsi_show_boot_tgt_info type=%d\n", type);
+	switch (type) {
+	case ISCSI_BOOT_TGT_NAME:
+		rc = sprintf(buf, "%.*s\n",
+				(int)strlen(phba->boot_sess.target_name),
+				(char *)&phba->boot_sess.target_name);
+		break;
+	case ISCSI_BOOT_TGT_IP_ADDR:
+		if (phba->boot_sess.conn_list[0].dest_ipaddr.ip_type == 0x1)
+			rc = sprintf(buf, "%pI4\n",
+				(char *)&phba->boot_sess.conn_list[0].
+				dest_ipaddr.ip_address);
+		else
+			rc = sprintf(str, "%pI6\n",
+				(char *)&phba->boot_sess.conn_list[0].
+				dest_ipaddr.ip_address);
+		break;
+	case ISCSI_BOOT_TGT_PORT:
+		rc = sprintf(str, "%d\n", phba->boot_sess.conn_list[0].
+				  dest_port);
+		break;
+
+	case ISCSI_BOOT_TGT_CHAP_NAME:
+		rc = sprintf(str,  "%.*s\n",
+				      phba->boot_sess.conn_list[0].
+				      negotiated_login_options.auth_data.chap.
+				      target_chap_name_length,
+				      (char *)&phba->boot_sess.conn_list[0].
+				      negotiated_login_options.auth_data.chap.
+				      target_chap_name);
+		break;
+	case ISCSI_BOOT_TGT_CHAP_SECRET:
+		rc = sprintf(str,  "%.*s\n",
+				      phba->boot_sess.conn_list[0].
+				      negotiated_login_options.auth_data.chap.
+				      target_secret_length,
+				      (char *)&phba->boot_sess.conn_list[0].
+				      negotiated_login_options.auth_data.chap.
+				      target_secret);
+
+		break;
+	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
+		rc = sprintf(str,  "%.*s\n",
+				      phba->boot_sess.conn_list[0].
+				      negotiated_login_options.auth_data.chap.
+				      intr_chap_name_length,
+				      (char *)&phba->boot_sess.conn_list[0].
+				      negotiated_login_options.auth_data.chap.
+				      intr_chap_name);
+
+		break;
+	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
+			rc = sprintf(str,  "%.*s\n",
+				      phba->boot_sess.conn_list[0].
+				      negotiated_login_options.auth_data.chap.
+				      intr_secret_length,
+				      (char *)&phba->boot_sess.conn_list[0].
+				      negotiated_login_options.auth_data.chap.
+				      intr_secret);
+		break;
+	case ISCSI_BOOT_TGT_FLAGS:
+			rc = sprintf(str, "2\n");
+		break;
+	case ISCSI_BOOT_TGT_NIC_ASSOC:
+			rc = sprintf(str, "0\n");
+		break;
+	default:
+		rc = -ENOSYS;
+		break;
+	}
+	return rc;
+}
+
+static ssize_t beiscsi_show_boot_ini_info(void *data, int type, char *buf)
+{
+	struct beiscsi_hba *phba = data;
+	char *str = buf;
+	int rc;
+
+	printk(KERN_ERR " In beiscsi_show_boot_ini_info type=%d\n", type);
+	switch (type) {
+	case ISCSI_BOOT_INI_INITIATOR_NAME:
+		rc = sprintf(str, "%s\n", phba->boot_sess.initiator_iscsiname);
+		break;
+	default:
+		rc = -ENOSYS;
+		break;
+	}
+	return rc;
+}
+
+static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)
+{
+	struct beiscsi_hba *phba = data;
+	char *str = buf;
+	int rc;
+
+	printk(KERN_ERR " In beiscsi_show_boot_eth_info type = %d\n", type);
+	switch (type) {
+	case ISCSI_BOOT_ETH_FLAGS:
+			rc = sprintf(str, "2\n");
+		break;
+	case ISCSI_BOOT_ETH_INDEX:
+			rc = sprintf(str, "0\n");
+		break;
+	case ISCSI_BOOT_ETH_MAC:
+		rc  = beiscsi_get_macaddr(buf, phba);
+		if (rc < 0) {
+			SE_DEBUG(DBG_LVL_1, "beiscsi_get_macaddr Failed\n");
+			return rc;
+		}
+	break;
+	default:
+		rc = -ENOSYS;
+		break;
+	}
+	return rc;
+}
+
+
+static mode_t beiscsi_tgt_get_attr_visibility(void *data, int type)
+{
+	int rc;
+
+	switch (type) {
+	case ISCSI_BOOT_TGT_NAME:
+	case ISCSI_BOOT_TGT_IP_ADDR:
+	case ISCSI_BOOT_TGT_PORT:
+	case ISCSI_BOOT_TGT_CHAP_NAME:
+	case ISCSI_BOOT_TGT_CHAP_SECRET:
+	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
+	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
+	case ISCSI_BOOT_TGT_NIC_ASSOC:
+	case ISCSI_BOOT_TGT_FLAGS:
+		rc = S_IRUGO;
+		break;
+	default:
+		rc = 0;
+		break;
+	}
+	return rc;
+}
+
+static mode_t beiscsi_ini_get_attr_visibility(void *data, int type)
+{
+	int rc;
+
+	switch (type) {
+	case ISCSI_BOOT_INI_INITIATOR_NAME:
+		rc = S_IRUGO;
+		break;
+	default:
+		rc = 0;
+		break;
+	}
+	return rc;
+}
+
+
+static mode_t beiscsi_eth_get_attr_visibility(void *data, int type)
+{
+	int rc;
+
+	switch (type) {
+	case ISCSI_BOOT_ETH_FLAGS:
+	case ISCSI_BOOT_ETH_MAC:
+	case ISCSI_BOOT_ETH_INDEX:
+		rc = S_IRUGO;
+		break;
+	default:
+		rc = 0;
+		break;
+	}
+	return rc;
+}
+
+static int beiscsi_setup_boot_info(struct beiscsi_hba *phba)
+{
+	struct iscsi_boot_kobj *boot_kobj;
+	char *set_name;
+
+	set_name = kasprintf(GFP_KERNEL, "iscsi_boot%u", phba->shost->host_no);
+	if (!set_name)
+		return -ENOMEM;
+
+	phba->boot_kset = iscsi_boot_create_kset(set_name);
+	if (!phba->boot_kset) {
+		kfree(set_name);
+		return -ENOMEM;
+	}
+
+	/* get boot info using mgmt cmd */
+	boot_kobj = iscsi_boot_create_target(phba->boot_kset, 0, phba,
+					     beiscsi_show_boot_tgt_info,
+					     beiscsi_tgt_get_attr_visibility);
+	if (!boot_kobj)
+		goto free_kset;
+
+	boot_kobj = iscsi_boot_create_initiator(phba->boot_kset, 0, phba,
+					     beiscsi_show_boot_ini_info,
+					     beiscsi_ini_get_attr_visibility);
+	if (!boot_kobj)
+		goto free_kset;
+
+	boot_kobj = iscsi_boot_create_ethernet(phba->boot_kset, 0, phba,
+					     beiscsi_show_boot_eth_info,
+					     beiscsi_eth_get_attr_visibility);
+	if (!boot_kobj)
+		goto free_kset;
+	return 0;
+
+free_kset:
+	kfree(set_name);
+	iscsi_boot_destroy_kset(phba->boot_kset);
+	return -ENOMEM;
+}
+
 /*------------------- PCI Driver operations and data ----------------- */
 static DEFINE_PCI_DEVICE_TABLE(beiscsi_pci_id_table) = {
 	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
@@ -268,6 +492,15 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 
 	if (iscsi_host_add(shost, &phba->pcidev->dev))
 		goto free_devices;
+
+	if (beiscsi_setup_boot_info(phba))
+		/*
+		 * log error but continue, because we may not be using
+		 * iscsi boot.
+		 */
+		shost_printk(KERN_ERR, phba->shost, "Could not set up "
+		"iSCSI boot info.");
+
 	return phba;
 
 free_devices:
@@ -3277,6 +3510,89 @@ static void hwi_disable_intr(struct beiscsi_hba *phba)
 			     "In hwi_disable_intr, Already Disabled\n");
 }
 
+static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
+{
+	struct be_cmd_resp_get_boot_target *boot_resp;
+	struct be_cmd_resp_get_session *session_resp;
+	struct be_mcc_wrb *wrb;
+	struct be_dma_mem nonemb_cmd;
+	unsigned int tag, wrb_num;
+	unsigned short status, extd_status;
+	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
+
+	tag = beiscsi_get_boot_target(phba);
+	if (!tag) {
+		SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed\n");
+		return -EAGAIN;
+	} else
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+					 phba->ctrl.mcc_numtag[tag]);
+
+	wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
+	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
+	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
+	if (status || extd_status) {
+		SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed"
+				    " status = %d extd_status = %d\n",
+				    status, extd_status);
+		free_mcc_tag(&phba->ctrl, tag);
+		return -EBUSY;
+	}
+	wrb = queue_get_wrb(mccq, wrb_num);
+	free_mcc_tag(&phba->ctrl, tag);
+	boot_resp = embedded_payload(wrb);
+
+	if (boot_resp->boot_session_handle < 0) {
+		printk(KERN_ERR "No Boot Session for this pci_func,"
+			"session Hndl = %d\n", boot_resp->boot_session_handle);
+		return -ENXIO;
+	}
+
+	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
+				sizeof(*session_resp),
+				&nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Failed to allocate memory for"
+			 "beiscsi_get_session_info\n");
+		return -ENOMEM;
+	}
+
+	memset(nonemb_cmd.va, 0, sizeof(*session_resp));
+	tag = beiscsi_get_session_info(phba,
+		boot_resp->boot_session_handle, &nonemb_cmd);
+	if (!tag) {
+		SE_DEBUG(DBG_LVL_1, "beiscsi_get_session_info"
+			" Failed\n");
+		goto boot_freemem;
+	} else
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+					 phba->ctrl.mcc_numtag[tag]);
+
+	wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
+	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
+	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
+	if (status || extd_status) {
+		SE_DEBUG(DBG_LVL_1, "beiscsi_get_session_info Failed"
+				    " status = %d extd_status = %d\n",
+				    status, extd_status);
+		free_mcc_tag(&phba->ctrl, tag);
+		goto boot_freemem;
+	}
+	wrb = queue_get_wrb(mccq, wrb_num);
+	free_mcc_tag(&phba->ctrl, tag);
+	session_resp = nonemb_cmd.va ;
+	memcpy(&phba->boot_sess, &session_resp->session_info,
+	       sizeof(struct mgmt_session_info));
+	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+		    nonemb_cmd.va, nonemb_cmd.dma);
+	return 0;
+boot_freemem:
+	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+		    nonemb_cmd.va, nonemb_cmd.dma);
+	return -ENOMEM;
+}
+
 static int beiscsi_init_port(struct beiscsi_hba *phba)
 {
 	int ret;
@@ -3839,6 +4155,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	iscsi_host_remove(phba->shost);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
+	iscsi_boot_destroy_kset(phba->boot_kset);
 }
 
 static void beiscsi_msix_enable(struct beiscsi_hba *phba)
@@ -3863,7 +4180,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
-	int ret, num_cpus, i;
+	int ret, msix_vec, num_cpus, i;
 	u8 *real_offset = 0;
 	u32 value = 0;
 
@@ -3994,9 +4311,24 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto free_blkenbld;
 	}
 	hwi_enable_intr(phba);
+	ret = beiscsi_get_boot_info(phba);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
+			     "Failed to hwi_enable_intr\n");
+		goto free_intr;
+	}
 	SE_DEBUG(DBG_LVL_8, "\n\n\n SUCCESS - DRIVER LOADED\n\n\n");
 	return 0;
 
+free_intr:
+	if (phba->msix_enabled) {
+		for (i = 0; i <= phba->num_cpus; i++) {
+			msix_vec = phba->msix_entries[i].vector;
+			free_irq(msix_vec, &phwi_context->be_eq[i]);
+		}
+	} else
+		if (phba->pcidev->irq)
+			free_irq(phba->pcidev->irq, phba);
 free_blkenbld:
 	destroy_workqueue(phba->wq);
 	if (blk_iopoll_enabled)
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 08996d0..978a57d 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -311,6 +311,7 @@ struct beiscsi_hba {
 	struct list_head hba_queue;
 	unsigned short *cid_array;
 	struct iscsi_endpoint **ep_array;
+	struct iscsi_boot_kset *boot_kset;
 	struct Scsi_Host *shost;
 	struct {
 		/**
@@ -341,6 +342,7 @@ struct beiscsi_hba {
 	struct work_struct work_cqs;	/* The work being queued */
 	struct be_ctrl_info ctrl;
 	unsigned int generation;
+	struct mgmt_session_info boot_sess;
 	struct invalidate_command_table inv_tbl[128];
 
 };
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 3f3fab9..26350e4 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -20,6 +20,77 @@
 
 #include "be_mgmt.h"
 #include "be_iscsi.h"
+#include <scsi/scsi_transport_iscsi.h>
+
+unsigned int beiscsi_get_boot_target(struct beiscsi_hba *phba)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_req_get_mac_addr *req;
+	unsigned int tag = 0;
+
+	SE_DEBUG(DBG_LVL_8, "In bescsi_get_boot_target\n");
+	spin_lock(&ctrl->mbox_lock);
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
+
+	wrb = wrb_from_mccq(phba);
+	req = embedded_payload(wrb);
+	wrb->tag0 |= tag;
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
+			   OPCODE_ISCSI_INI_BOOT_GET_BOOT_TARGET,
+			   sizeof(*req));
+
+	be_mcc_notify(phba);
+	spin_unlock(&ctrl->mbox_lock);
+	return tag;
+}
+
+unsigned int beiscsi_get_session_info(struct beiscsi_hba *phba,
+				  u32 boot_session_handle,
+				  struct be_dma_mem *nonemb_cmd)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb;
+	unsigned int tag = 0;
+	struct  be_cmd_req_get_session *req;
+	struct be_cmd_resp_get_session *resp;
+	struct be_sge *sge;
+
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_get_session_info\n");
+	spin_lock(&ctrl->mbox_lock);
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
+
+	nonemb_cmd->size = sizeof(*resp);
+	req = nonemb_cmd->va;
+	memset(req, 0, sizeof(*req));
+	wrb = wrb_from_mccq(phba);
+	sge = nonembedded_sgl(wrb);
+	wrb->tag0 |= tag;
+
+
+	wrb->tag0 |= tag;
+	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
+			   OPCODE_ISCSI_INI_SESSION_GET_A_SESSION,
+			   sizeof(*resp));
+	req->session_handle = boot_session_handle;
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
+	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
+	sge->len = cpu_to_le32(nonemb_cmd->size);
+
+	be_mcc_notify(phba);
+	spin_unlock(&ctrl->mbox_lock);
+	return tag;
+}
 
 int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				struct beiscsi_hba *phba)
-- 
1.6.5.2

