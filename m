From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 5/7] Add support for configuring the VLAN on the adapter.
Date: Mon, 13 Aug 2012 16:00:34 +0530
Message-ID: <1ccc8229-524d-4778-823f-bab06ee80b10@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:11030 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2HMKba (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 06:31:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Add support for configuring the VLAN parameters on the adapter
 using the iscsiadm interface.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |   43 +++++++++++++++++++++
 drivers/scsi/be2iscsi/be_cmds.h  |    9 ++++
 drivers/scsi/be2iscsi/be_iscsi.c |   77 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.c  |   43 +++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h  |    4 ++
 5 files changed, 176 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 33f89f9..e37a85a 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -934,3 +934,46 @@ int beiscsi_cmd_reset_function(struct beiscsi_hba  *phba)
 	spin_unlock(&ctrl->mbox_lock);
 	return status;
 }
+
+/**
+  * be_cmd_set_vlan : Configure the VLAN parameters on the adapter
+  * @phba : the device priv structure instance
+  * vlan_value : The value to set for VLAN
+  *
+  * Set the VLAN ID/Priority for the adapter or Disable the VLAN
+  * option of the adapter. This function issues MBX Cmd for setting
+  * the values
+  *
+  * returns the tag for the Mbx Command
+  **/
+int be_cmd_set_vlan(struct beiscsi_hba *phba,
+		uint16_t vlan_value)
+{
+	unsigned int tag = 0;
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_set_vlan_req *req;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+
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
+	be_wrb_hdr_prepare(wrb, sizeof(*wrb), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			OPCODE_COMMON_ISCSI_NTWK_SET_VLAN,
+			sizeof(*req));
+
+	req->interface_hndl = phba->interface_handle;
+	req->vlan_priority = vlan_value;
+
+	be_mcc_notify(phba);
+	spin_unlock(&ctrl->mbox_lock);
+
+	return tag;
+}
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 953c354..d6c1e2c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -449,6 +449,12 @@ struct be_cmd_get_def_gateway_resp {
 	struct ip_addr_format ip_addr;
 } __packed;
 
+#define BEISCSI_VLAN_DISABLE	0xFFFF
+struct be_cmd_set_vlan_req {
+	struct be_cmd_req_hdr hdr;
+	u32 interface_hndl;
+	u32 vlan_priority;
+} __packed;
 /******************** Create CQ ***************************/
 /**
  * Pseudo amap definition in which each bit of the actual structure is defined
@@ -688,6 +694,9 @@ int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
 
 bool is_link_state_evt(u32 trailer);
 
+/* Configuration Functions */
+int be_cmd_set_vlan(struct beiscsi_hba *phba, uint16_t vlan_value);
+
 struct be_default_pdu_context {
 	u32 dw[4];
 } __packed;
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 73300f1..17b0907 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -332,6 +332,52 @@ beiscsi_set_static_ip(struct Scsi_Host *shost,
 	return ret;
 }
 
+/**
+  * beiscsi_set_vlan_attrib : Set the VLAN priority
+  *	@shost : Scsi_Host pointer for the function.
+  * @iface_param : Interface paramter structure.
+  *
+  * Set the VLAN value for the adapter or enable
+  * disable the VLAN option.
+  *
+  * Return
+  *	Success - 0
+  *	Failure - Non-Zero value
+  *
+  **/
+static int
+beiscsi_set_vlan_attrib(struct Scsi_Host *shost,
+		struct iscsi_iface_param_info *iface_param)
+{
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	int ret = 0;
+
+	/* Get the Interface Handle */
+	if (mgmt_get_all_if_id(phba)) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
+				"BS_%d : Getting Interface Handle Failed\n");
+		return -EIO;
+	}
+
+	switch (iface_param->param) {
+	case ISCSI_NET_PARAM_VLAN_ENABLED:
+		if (iface_param->value[0] != ISCSI_VLAN_ENABLE)
+			ret = mgmt_set_vlan(phba, BEISCSI_VLAN_DISABLE);
+		break;
+	case ISCSI_NET_PARAM_VLAN_TAG:
+		ret = mgmt_set_vlan(phba,
+				*((uint16_t *)iface_param->value));
+		break;
+	default:
+		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
+				"BS_%d : Unkown Param Type : %d\n",
+				iface_param->param);
+		return -ENOSYS;
+	}
+	return ret;
+}
+
+
 static int
 beiscsi_set_ipv4(struct Scsi_Host *shost,
 		struct iscsi_iface_param_info *iface_param,
@@ -368,6 +414,10 @@ beiscsi_set_ipv4(struct Scsi_Host *shost,
 		ret = beiscsi_set_static_ip(shost, iface_param,
 					    data, dt_len);
 		break;
+	case ISCSI_NET_PARAM_VLAN_ENABLED:
+	case ISCSI_NET_PARAM_VLAN_TAG:
+		ret = beiscsi_set_vlan_attrib(shost, iface_param);
+		break;
 	default:
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 				"BS_%d : Param %d not supported\n",
@@ -489,6 +539,27 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 	case ISCSI_NET_PARAM_IPV4_SUBNET:
 		len = sprintf(buf, "%pI4\n", &if_info.ip_addr.subnet_mask);
 		break;
+	case ISCSI_NET_PARAM_VLAN_ENABLED:
+		len = sprintf(buf, "%s\n",
+				(if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
+				? "Disabled" : "Enabled");
+		break;
+	case ISCSI_NET_PARAM_VLAN_ID:
+		if (if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
+			len = sprintf(buf, "\n");
+		else
+			len = sprintf(buf, "%d\n",
+					(if_info.vlan_priority &
+					 ISCSI_MAX_VLAN_ID));
+		break;
+	case ISCSI_NET_PARAM_VLAN_PRIORITY:
+		if (if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
+			len = sprintf(buf, "\n");
+		else
+			len = sprintf(buf, "%d\n",
+					((if_info.vlan_priority >> 13) &
+					 ISCSI_MAX_VLAN_PRIORITY));
+		break;
 	default:
 		WARN_ON(1);
 	}
@@ -510,6 +581,9 @@ int be2iscsi_iface_get_param(struct iscsi_iface *iface,
 	case ISCSI_NET_PARAM_IPV4_SUBNET:
 	case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
 	case ISCSI_NET_PARAM_IPV6_ADDR:
+	case ISCSI_NET_PARAM_VLAN_ENABLED:
+	case ISCSI_NET_PARAM_VLAN_ID:
+	case ISCSI_NET_PARAM_VLAN_PRIORITY:
 		len = be2iscsi_get_if_param(phba, iface, param, buf);
 		break;
 	case ISCSI_NET_PARAM_IFACE_ENABLE:
@@ -1233,6 +1307,9 @@ umode_t be2iscsi_attr_is_visible(int param_type, int param)
 		case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
 		case ISCSI_NET_PARAM_IPV4_GW:
 		case ISCSI_NET_PARAM_IPV6_ADDR:
+		case ISCSI_NET_PARAM_VLAN_ID:
+		case ISCSI_NET_PARAM_VLAN_PRIORITY:
+		case ISCSI_NET_PARAM_VLAN_ENABLED:
 			return S_IRUGO;
 		default:
 			return 0;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index c97a814..790629a 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1092,3 +1092,46 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 			"BG_%d : Login to Boot Target Failed\n");
 	return -ENXIO;
 }
+
+/**
+  * mgmt_set_vlan : Wait for the Mbox completion
+  * @phba : device private structure
+  * @vlan_value : the VLAN value to be set
+  *
+  * Returns
+  *		Success : 0
+  *		Failure : Non-Zero Value
+  **/
+int mgmt_set_vlan(struct beiscsi_hba *phba,
+		uint16_t vlan_value)
+{
+	unsigned int tag, wrb_num;
+	unsigned short status, extd_status;
+
+	tag = be_cmd_set_vlan(phba, vlan_value);
+	if (!tag) {
+		beiscsi_log(phba, KERN_ERR,
+				(BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX),
+				"BG_%d : VLAN Setting Failed\n");
+		return -EBUSY;
+	} else
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+				phba->ctrl.mcc_numtag[tag]);
+
+	wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
+	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
+	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
+
+	if (status || extd_status) {
+		beiscsi_log(phba, KERN_ERR,
+				(BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX),
+				"BS_%d : status : %d extd_status : %d\n",
+				status, extd_status);
+
+		free_mcc_tag(&phba->ctrl, tag);
+		return -EAGAIN;
+	}
+
+	free_mcc_tag(&phba->ctrl, tag);
+	return 0;
+}
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index cd97e70..f5b0074 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -295,4 +295,8 @@ int mgmt_set_gateway(struct beiscsi_hba *phba,
 
 int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 		unsigned int *s_handle);
+
+unsigned int mgmt_get_all_if_id(struct beiscsi_hba *phba);
+
+int mgmt_set_vlan(struct beiscsi_hba *phba, uint16_t vlan_value);
 #endif
-- 
1.7.1

