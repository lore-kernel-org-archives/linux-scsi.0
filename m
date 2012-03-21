From: michaelc@cs.wisc.edu
Subject: [PATCH 17/17] be2iscsi: Get Port State and Speed of the Adapter
Date: Tue, 20 Mar 2012 20:48:08 -0500
Message-ID: <1332294488-13684-18-git-send-email-michaelc@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030486Ab2CUBsq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:48:46 -0400
In-Reply-To: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: John Soni Jose <sony.john-n@emulex.com>

 Implement ISCSI_HOST_PARAM_PORT_STATE and ISCSI_HOST_PARAM_PORT_SPEED
 to get the Adapter port state and port name

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_cmds.h  |   24 ++++++++++
 drivers/scsi/be2iscsi/be_iscsi.c |   89 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.c  |   27 +++++++++++
 3 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 60d1445..b0b36c6 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -596,6 +596,28 @@ struct be_cmd_hba_name {
 	u8 initiator_alias[BEISCSI_ALIAS_LEN];
 } __packed;
 
+struct be_cmd_ntwk_link_status_req {
+	struct be_cmd_req_hdr hdr;
+	u32 rsvd0;
+} __packed;
+
+/*** Port Speed Values ***/
+#define BE2ISCSI_LINK_SPEED_ZERO	0x00
+#define BE2ISCSI_LINK_SPEED_10MBPS	0x01
+#define BE2ISCSI_LINK_SPEED_100MBPS	0x02
+#define BE2ISCSI_LINK_SPEED_1GBPS	0x03
+#define BE2ISCSI_LINK_SPEED_10GBPS	0x04
+struct be_cmd_ntwk_link_status_resp {
+	struct be_cmd_resp_hdr hdr;
+	u8 phys_port;
+	u8 mac_duplex;
+	u8 mac_speed;
+	u8 mac_fault;
+	u8 mgmt_mac_duplex;
+	u8 mgmt_mac_speed;
+	u16 qos_link_speed;
+	u32 logical_link_speed;
+} __packed;
 
 int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
 			  struct be_queue_info *eq, int eq_delay);
@@ -615,6 +637,7 @@ int be_poll_mcc(struct be_ctrl_info *ctrl);
 int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				      struct beiscsi_hba *phba);
 unsigned int be_cmd_get_initname(struct beiscsi_hba *phba);
+unsigned int be_cmd_get_port_speed(struct beiscsi_hba *phba);
 
 void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag);
 /*ISCSI Functuions */
@@ -879,6 +902,7 @@ struct be_cmd_get_all_if_id_req {
 } __packed;
 
 #define ISCSI_OPCODE_SCSI_DATA_OUT		5
+#define OPCODE_COMMON_NTWK_LINK_STATUS_QUERY 5
 #define OPCODE_COMMON_MODIFY_EQ_DELAY		41
 #define OPCODE_COMMON_ISCSI_CLEANUP		59
 #define	OPCODE_COMMON_TCP_UPLOAD		56
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 46cc40e..43f3503 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -618,6 +618,79 @@ static int beiscsi_get_initname(char *buf, struct beiscsi_hba *phba)
 }
 
 /**
+ * beiscsi_get_port_state - Get the Port State
+ * @shost : pointer to scsi_host structure
+ *
+ * returns number of bytes
+ */
+static void beiscsi_get_port_state(struct Scsi_Host *shost)
+{
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+
+	ihost->port_state = (phba->state == BE_ADAPTER_UP) ?
+		ISCSI_PORT_STATE_UP : ISCSI_PORT_STATE_DOWN;
+}
+
+/**
+ * beiscsi_get_port_speed  - Get the Port Speed from Adapter
+ * @shost : pointer to scsi_host structure
+ *
+ * returns Success/Failure
+ */
+static int beiscsi_get_port_speed(struct Scsi_Host *shost)
+{
+	unsigned int tag, wrb_num;
+	unsigned short status, extd_status;
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_ntwk_link_status_resp *resp;
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
+
+	tag = be_cmd_get_port_speed(phba);
+	if (!tag) {
+		SE_DEBUG(DBG_LVL_1, "Getting Port Speed Failed\n");
+		 return -EBUSY;
+	 } else
+		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
+				phba->ctrl.mcc_numtag[tag]);
+
+	wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
+	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
+	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
+
+	if (status || extd_status) {
+		SE_DEBUG(DBG_LVL_1, "MailBox Command Failed with "
+				"status = %d extd_status = %d\n",
+				status, extd_status);
+		free_mcc_tag(&phba->ctrl, tag);
+		return -EAGAIN;
+	}
+	wrb = queue_get_wrb(mccq, wrb_num);
+	free_mcc_tag(&phba->ctrl, tag);
+	resp = embedded_payload(wrb);
+
+	switch (resp->mac_speed) {
+	case BE2ISCSI_LINK_SPEED_10MBPS:
+		ihost->port_speed = ISCSI_PORT_SPEED_10MBPS;
+		break;
+	case BE2ISCSI_LINK_SPEED_100MBPS:
+		ihost->port_speed = BE2ISCSI_LINK_SPEED_100MBPS;
+		break;
+	case BE2ISCSI_LINK_SPEED_1GBPS:
+		ihost->port_speed = ISCSI_PORT_SPEED_1GBPS;
+		break;
+	case BE2ISCSI_LINK_SPEED_10GBPS:
+		ihost->port_speed = ISCSI_PORT_SPEED_10GBPS;
+		break;
+	default:
+		ihost->port_speed = ISCSI_PORT_SPEED_UNKNOWN;
+	}
+	return 0;
+}
+
+/**
  * beiscsi_get_host_param - get the iscsi parameter
  * @shost: pointer to scsi_host structure
  * @param: parameter type identifier
@@ -648,6 +721,19 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 			return status;
 		}
 		break;
+	case ISCSI_HOST_PARAM_PORT_STATE:
+		beiscsi_get_port_state(shost);
+		status = sprintf(buf, "%s\n", iscsi_get_port_state_name(shost));
+		break;
+	case ISCSI_HOST_PARAM_PORT_SPEED:
+		status = beiscsi_get_port_speed(shost);
+		if (status) {
+			SE_DEBUG(DBG_LVL_1,
+					"Retreiving Port Speed Failed\n");
+			return status;
+		}
+		status = sprintf(buf, "%s\n", iscsi_get_port_speed_name(shost));
+		break;
 	default:
 		return iscsi_host_get_param(shost, param, buf);
 	}
@@ -1073,6 +1159,9 @@ umode_t be2iscsi_attr_is_visible(int param_type, int param)
 	case ISCSI_HOST_PARAM:
 		switch (param) {
 		case ISCSI_HOST_PARAM_HWADDRESS:
+		case ISCSI_HOST_PARAM_INITIATOR_NAME:
+		case ISCSI_HOST_PARAM_PORT_STATE:
+		case ISCSI_HOST_PARAM_PORT_SPEED:
 			return S_IRUGO;
 		default:
 			return 0;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 47d4005..46271ec 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -898,3 +898,30 @@ unsigned int be_cmd_get_initname(struct beiscsi_hba *phba)
 	spin_unlock(&ctrl->mbox_lock);
 	return tag;
 }
+
+unsigned int be_cmd_get_port_speed(struct beiscsi_hba *phba)
+{
+	unsigned int tag = 0;
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_ntwk_link_status_req *req;
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
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			OPCODE_COMMON_NTWK_LINK_STATUS_QUERY,
+			sizeof(*req));
+
+	be_mcc_notify(phba);
+	spin_unlock(&ctrl->mbox_lock);
+	return tag;
+}
-- 
1.7.7.6

