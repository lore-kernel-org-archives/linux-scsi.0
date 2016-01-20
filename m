From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v4 14/17] be2iscsi: Fix to process 25G link speed info from FW
Date: Wed, 20 Jan 2016 14:10:58 +0530
Message-ID: <1453279261-659-15-git-send-email-jitendra.bhivare@avagotech.com>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55634 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933843AbcATIl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 03:41:56 -0500
In-Reply-To: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Async link event provides port_speed info. Cache the port_speed info
and use the same to report in ISCSI_HOST_PARAM_PORT_SPEED query.

Removed link status query IOCTL used to do the same.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |  1 +
 drivers/scsi/be2iscsi/be_cmds.h  | 35 ++++++++++-------------------------
 drivers/scsi/be2iscsi/be_iscsi.c | 39 +++++++++------------------------------
 drivers/scsi/be2iscsi/be_main.h  |  1 +
 drivers/scsi/be2iscsi/be_mgmt.c  | 28 ----------------------------
 5 files changed, 21 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 14a1c71..ce82f4d 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -408,6 +408,7 @@ void beiscsi_fail_session(struct iscsi_cls_session *cls_session)
 static void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 		struct be_async_event_link_state *evt)
 {
+	phba->port_speed = evt->port_speed;
 	if ((evt->port_link_status == ASYNC_EVENT_LINK_DOWN) ||
 	    ((evt->port_link_status & ASYNC_EVENT_LOGICAL) &&
 	     (evt->port_fault != BEISCSI_PHY_LINK_FAULT_NONE))) {
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 724974e..a194066 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -153,12 +153,21 @@ struct be_async_event_link_state {
 	u8 physical_port;
 	u8 port_link_status;
 	u8 port_duplex;
+/* BE2ISCSI_LINK_SPEED_ZERO	0x00 - no link */
+#define BE2ISCSI_LINK_SPEED_10MBPS	0x01
+#define BE2ISCSI_LINK_SPEED_100MBPS	0x02
+#define BE2ISCSI_LINK_SPEED_1GBPS	0x03
+#define BE2ISCSI_LINK_SPEED_10GBPS	0x04
+#define BE2ISCSI_LINK_SPEED_25GBPS	0x06
+#define BE2ISCSI_LINK_SPEED_40GBPS	0x07
 	u8 port_speed;
 #define BEISCSI_PHY_LINK_FAULT_NONE	0x00
 #define BEISCSI_PHY_LINK_FAULT_LOCAL	0x01
 #define BEISCSI_PHY_LINK_FAULT_REMOTE	0x02
 	u8 port_fault;
-	u8 rsvd0[7];
+	u8 event_reason;
+	u16 qos_link_speed;
+	u32 event_tag;
 	struct be_async_event_trailer trailer;
 } __packed;
 
@@ -711,29 +720,6 @@ struct be_cmd_hba_name {
 	u8 initiator_alias[BEISCSI_ALIAS_LEN];
 } __packed;
 
-struct be_cmd_ntwk_link_status_req {
-	struct be_cmd_req_hdr hdr;
-	u32 rsvd0;
-} __packed;
-
-/*** Port Speed Values ***/
-#define BE2ISCSI_LINK_SPEED_ZERO	0x00
-#define BE2ISCSI_LINK_SPEED_10MBPS	0x01
-#define BE2ISCSI_LINK_SPEED_100MBPS	0x02
-#define BE2ISCSI_LINK_SPEED_1GBPS	0x03
-#define BE2ISCSI_LINK_SPEED_10GBPS	0x04
-struct be_cmd_ntwk_link_status_resp {
-	struct be_cmd_resp_hdr hdr;
-	u8 phys_port;
-	u8 mac_duplex;
-	u8 mac_speed;
-	u8 mac_fault;
-	u8 mgmt_mac_duplex;
-	u8 mgmt_mac_speed;
-	u16 qos_link_speed;
-	u32 logical_link_speed;
-} __packed;
-
 int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
 			  struct be_queue_info *eq, int eq_delay);
 
@@ -752,7 +738,6 @@ int be_poll_mcc(struct be_ctrl_info *ctrl);
 int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				      struct beiscsi_hba *phba);
 unsigned int be_cmd_get_initname(struct beiscsi_hba *phba);
-unsigned int be_cmd_get_port_speed(struct beiscsi_hba *phba);
 
 void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag);
 
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 3545721..a3bc5e4 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -766,34 +766,13 @@ static void beiscsi_get_port_state(struct Scsi_Host *shost)
  * beiscsi_get_port_speed  - Get the Port Speed from Adapter
  * @shost : pointer to scsi_host structure
  *
- * returns Success/Failure
  */
-static int beiscsi_get_port_speed(struct Scsi_Host *shost)
+static void beiscsi_get_port_speed(struct Scsi_Host *shost)
 {
-	int rc;
-	unsigned int tag;
-	struct be_mcc_wrb *wrb;
-	struct be_cmd_ntwk_link_status_resp *resp;
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 	struct iscsi_cls_host *ihost = shost->shost_data;
 
-	tag = be_cmd_get_port_speed(phba);
-	if (!tag) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Getting Port Speed Failed\n");
-
-		 return -EBUSY;
-	}
-	rc = beiscsi_mccq_compl(phba, tag, &wrb, NULL);
-	if (rc) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BS_%d : Port Speed MBX Failed\n");
-		return rc;
-	}
-	resp = embedded_payload(wrb);
-
-	switch (resp->mac_speed) {
+	switch (phba->port_speed) {
 	case BE2ISCSI_LINK_SPEED_10MBPS:
 		ihost->port_speed = ISCSI_PORT_SPEED_10MBPS;
 		break;
@@ -806,10 +785,15 @@ static int beiscsi_get_port_speed(struct Scsi_Host *shost)
 	case BE2ISCSI_LINK_SPEED_10GBPS:
 		ihost->port_speed = ISCSI_PORT_SPEED_10GBPS;
 		break;
+	case BE2ISCSI_LINK_SPEED_25GBPS:
+		ihost->port_speed = ISCSI_PORT_SPEED_25GBPS;
+		break;
+	case BE2ISCSI_LINK_SPEED_40GBPS:
+		ihost->port_speed = ISCSI_PORT_SPEED_40GBPS;
+		break;
 	default:
 		ihost->port_speed = ISCSI_PORT_SPEED_UNKNOWN;
 	}
-	return 0;
 }
 
 /**
@@ -859,12 +843,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 		status = sprintf(buf, "%s\n", iscsi_get_port_state_name(shost));
 		break;
 	case ISCSI_HOST_PARAM_PORT_SPEED:
-		status = beiscsi_get_port_speed(shost);
-		if (status) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS_%d : Retreiving Port Speed Failed\n");
-			return status;
-		}
+		beiscsi_get_port_speed(shost);
 		status = sprintf(buf, "%s\n", iscsi_get_port_speed_name(shost));
 		break;
 	default:
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index fabade3..41c708c 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -427,6 +427,7 @@ struct beiscsi_hba {
 	bool mac_addr_set;
 	u8 mac_address[ETH_ALEN];
 	u8 port_name;
+	u8 port_speed;
 	char fw_ver_str[BEISCSI_VER_STRLEN];
 	char wq_name[20];
 	struct workqueue_struct *wq;	/* The actuak work queue */
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 3eea8b8..da040e7 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1393,34 +1393,6 @@ unsigned int be_cmd_get_initname(struct beiscsi_hba *phba)
 	return tag;
 }
 
-unsigned int be_cmd_get_port_speed(struct beiscsi_hba *phba)
-{
-	unsigned int tag = 0;
-	struct be_mcc_wrb *wrb;
-	struct be_cmd_ntwk_link_status_req *req;
-	struct be_ctrl_info *ctrl = &phba->ctrl;
-
-	if (mutex_lock_interruptible(&ctrl->mbox_lock))
-		return 0;
-	tag = alloc_mcc_tag(phba);
-	if (!tag) {
-		mutex_unlock(&ctrl->mbox_lock);
-		return tag;
-	}
-
-	wrb = wrb_from_mccq(phba);
-	req = embedded_payload(wrb);
-	wrb->tag0 |= tag;
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
-	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
-			OPCODE_COMMON_NTWK_LINK_STATUS_QUERY,
-			sizeof(*req));
-
-	be_mcc_notify(phba, tag);
-	mutex_unlock(&ctrl->mbox_lock);
-	return tag;
-}
-
 /**
  * be_mgmt_get_boot_shandle()- Get the session handle
  * @phba: device priv structure instance
-- 
2.5.0

