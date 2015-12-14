From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 7/9] be2iscsi: Fix to process 25G link speed info from FW
Date: Mon, 14 Dec 2015 11:41:04 +0530
Message-ID: <1450073466-21077-8-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:54830 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752490AbbLNG2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 01:28:22 -0500
In-Reply-To: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

Async link event provides port_speed info. Use the same to report in
ISCSI_HOST_PARAM_PORT_SPEED query. Removed link status query IOCTL used
to do the same.

25G and 40G are defined in kernel enum iscsi_port_speed.

Fixed get_nic_conf structure definition. Removed rsvd[23] field in
be_cmd_get_nic_conf_resp.

Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c     |   52 +++++++++++++---------------
 drivers/scsi/be2iscsi/be_cmds.h     |   65 ++++++++++------------------------
 drivers/scsi/be2iscsi/be_iscsi.c    |   49 +++++++-------------------
 drivers/scsi/be2iscsi/be_main.h     |    1 +
 drivers/scsi/be2iscsi/be_mgmt.c     |   28 ---------------
 drivers/scsi/scsi_transport_iscsi.c |    2 +
 include/scsi/iscsi_if.h             |    2 +
 7 files changed, 62 insertions(+), 137 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 37d1008..498eba2 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -402,31 +402,31 @@ void beiscsi_fail_session(struct iscsi_cls_session *cls_session)
 	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
 }
 
-static void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
-		struct be_async_event_link_state *evt)
+static void beiscsi_process_async_link(struct beiscsi_hba *phba,
+				       struct be_mcc_compl *compl)
 {
-	if ((evt->port_link_status == ASYNC_EVENT_LINK_DOWN) ||
-	    ((evt->port_link_status & ASYNC_EVENT_LOGICAL) &&
-	     (evt->port_fault != BEISCSI_PHY_LINK_FAULT_NONE))) {
-		phba->state = BE_ADAPTER_LINK_DOWN;
+	struct be_async_event_link_state *evt;
 
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
-			    "BC_%d : Link Down on Port %d\n",
-			    evt->physical_port);
+	evt = (struct be_async_event_link_state *)compl;
 
-		iscsi_host_for_each_session(phba->shost,
-					    beiscsi_fail_session);
-	} else if ((evt->port_link_status & ASYNC_EVENT_LINK_UP) ||
-		    ((evt->port_link_status & ASYNC_EVENT_LOGICAL) &&
-		     (evt->port_fault == BEISCSI_PHY_LINK_FAULT_NONE))) {
+	phba->port_speed = evt->port_speed;
+	/**
+	 * Check logical link status in ASYNC event.
+	 * This has been newly introduced in SKH-R Firmware 10.0.338.45.
+	 **/
+	if (evt->port_link_status & BE_ASYNC_LINK_UP_MASK) {
 		phba->state = BE_ADAPTER_LINK_UP | BE_ADAPTER_CHECK_BOOT;
 		phba->get_boot = BE_GET_BOOT_RETRIES;
-
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
-			    "BC_%d : Link UP on Port %d\n",
-			    evt->physical_port);
+		__beiscsi_log(phba, KERN_ERR,
+			      "BC_%d : Link Up on Port %d tag 0x%x\n",
+			      evt->physical_port, evt->event_tag);
+	} else {
+		phba->state = BE_ADAPTER_LINK_DOWN;
+		__beiscsi_log(phba, KERN_ERR,
+			      "BC_%d : Link Down on Port %d tag 0x%x\n",
+			      evt->physical_port, evt->event_tag);
+		iscsi_host_for_each_session(phba->shost,
+					    beiscsi_fail_session);
 	}
 }
 
@@ -438,9 +438,6 @@ static char *beiscsi_port_misconf_event_msg[] = {
 	"Unqualified optics - Replace with Avago optics for Warranty and Technical Support.",
 	"Uncertified optics - Replace with Avago Certified optics to enable link operation."
 };
-#define BEISCSI_PORT_MISCONF_EVENT_MAX \
-	(sizeof(beiscsi_port_misconf_event_msg) / \
-	 sizeof(beiscsi_port_misconf_event_msg[0]))
 
 static void beiscsi_process_async_sli(struct beiscsi_hba *phba,
 				      struct be_mcc_compl *compl)
@@ -466,7 +463,7 @@ static void beiscsi_process_async_sli(struct beiscsi_hba *phba,
 	old_state = phba->optic_state;
 	phba->optic_state = state;
 
-	if (state >= BEISCSI_PORT_MISCONF_EVENT_MAX) {
+	if (state >= ARRAY_SIZE(beiscsi_port_misconf_event_msg)) {
 		/* fw is reporting a state we don't know, log and return */
 		__beiscsi_log(phba, KERN_ERR,
 			    "BC_%d : Port %c: Unrecognized optic state 0x%x\n",
@@ -506,8 +503,7 @@ void beiscsi_process_async_event(struct beiscsi_hba *phba,
 	evt_code &= ASYNC_TRAILER_EVENT_CODE_MASK;
 	switch (evt_code) {
 	case ASYNC_EVENT_CODE_LINK_STATE:
-		beiscsi_async_link_state_process(phba,
-				(struct be_async_event_link_state *)compl);
+		beiscsi_process_async_link(phba, compl);
 		break;
 	case ASYNC_EVENT_CODE_ISCSI:
 		phba->state |= BE_ADAPTER_CHECK_BOOT;
@@ -523,8 +519,8 @@ void beiscsi_process_async_event(struct beiscsi_hba *phba,
 	}
 
 	beiscsi_log(phba, sev, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BC_%d : ASYNC Event: status 0x%08x flags 0x%08x\n",
-		    compl->status, compl->flags);
+		    "BC_%d : ASYNC Event %x: status 0x%08x flags 0x%08x\n",
+		    evt_code, compl->status, compl->flags);
 }
 
 int beiscsi_process_mcc(struct beiscsi_hba *phba)
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 6411f7b..3b9bc2e 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -142,7 +142,6 @@ struct be_async_event_trailer {
 enum {
 	ASYNC_EVENT_LINK_DOWN = 0x0,
 	ASYNC_EVENT_LINK_UP = 0x1,
-	ASYNC_EVENT_LOGICAL = 0x2
 };
 
 /**
@@ -152,13 +151,26 @@ enum {
 struct be_async_event_link_state {
 	u8 physical_port;
 	u8 port_link_status;
+/**
+ * ASYNC_EVENT_LINK_DOWN		0x0
+ * ASYNC_EVENT_LINK_UP			0x1
+ * ASYNC_EVENT_LINK_LOGICAL_DOWN	0x2
+ * ASYNC_EVENT_LINK_LOGICAL_UP		0x3
+ */
+#define BE_ASYNC_LINK_UP_MASK		0x01
 	u8 port_duplex;
 	u8 port_speed;
-#define BEISCSI_PHY_LINK_FAULT_NONE	0x00
-#define BEISCSI_PHY_LINK_FAULT_LOCAL	0x01
-#define BEISCSI_PHY_LINK_FAULT_REMOTE	0x02
+/* BE2ISCSI_LINK_SPEED_ZERO	0x00 - no link */
+#define BE2ISCSI_LINK_SPEED_10MBPS	0x01
+#define BE2ISCSI_LINK_SPEED_100MBPS	0x02
+#define BE2ISCSI_LINK_SPEED_1GBPS	0x03
+#define BE2ISCSI_LINK_SPEED_10GBPS	0x04
+#define BE2ISCSI_LINK_SPEED_25GBPS	0x06
+#define BE2ISCSI_LINK_SPEED_40GBPS	0x07
 	u8 port_fault;
-	u8 rsvd0[7];
+	u8 event_reason;
+	u16 qos_link_speed;
+	u32 event_tag;
 	struct be_async_event_trailer trailer;
 } __packed;
 
@@ -675,20 +687,6 @@ struct be_cmd_req_modify_eq_delay {
 
 /******************** Get MAC ADDR *******************/
 
-#define ETH_ALEN	6
-
-struct be_cmd_get_nic_conf_req {
-	struct be_cmd_req_hdr hdr;
-	u32 nic_port_count;
-	u32 speed;
-	u32 max_speed;
-	u32 link_state;
-	u32 max_frame_size;
-	u16 size_of_structure;
-	u8 mac_address[ETH_ALEN];
-	u32 rsvd[23];
-};
-
 struct be_cmd_get_nic_conf_resp {
 	struct be_cmd_resp_hdr hdr;
 	u32 nic_port_count;
@@ -697,9 +695,8 @@ struct be_cmd_get_nic_conf_resp {
 	u32 link_state;
 	u32 max_frame_size;
 	u16 size_of_structure;
-	u8 mac_address[6];
-	u32 rsvd[23];
-};
+	u8 mac_address[ETH_ALEN];
+} __packed;
 
 #define BEISCSI_ALIAS_LEN 32
 
@@ -711,29 +708,6 @@ struct be_cmd_hba_name {
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
 
@@ -752,7 +726,6 @@ int be_poll_mcc(struct be_ctrl_info *ctrl);
 int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				      struct beiscsi_hba *phba);
 unsigned int be_cmd_get_initname(struct beiscsi_hba *phba);
-unsigned int be_cmd_get_port_speed(struct beiscsi_hba *phba);
 
 void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag);
 
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 3545721..eca72b9 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -749,51 +749,30 @@ static int beiscsi_get_initname(char *buf, struct beiscsi_hba *phba)
 }
 
 /**
- * beiscsi_get_port_state - Get the Port State
+ * beiscsi_set_port_state - Set port_state in iscsi_cls_host
  * @shost : pointer to scsi_host structure
  *
  */
-static void beiscsi_get_port_state(struct Scsi_Host *shost)
+static void beiscsi_set_port_state(struct Scsi_Host *shost)
 {
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 	struct iscsi_cls_host *ihost = shost->shost_data;
 
-	ihost->port_state = (phba->state == BE_ADAPTER_LINK_UP) ?
+	ihost->port_state = (phba->state & BE_ADAPTER_LINK_UP) ?
 		ISCSI_PORT_STATE_UP : ISCSI_PORT_STATE_DOWN;
 }
 
 /**
- * beiscsi_get_port_speed  - Get the Port Speed from Adapter
+ * beiscsi_set_port_speed  - Set port_speed in iscsi_cls_host
  * @shost : pointer to scsi_host structure
  *
- * returns Success/Failure
  */
-static int beiscsi_get_port_speed(struct Scsi_Host *shost)
+static void beiscsi_set_port_speed(struct Scsi_Host *shost)
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
@@ -855,16 +839,11 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 		}
 		break;
 	case ISCSI_HOST_PARAM_PORT_STATE:
-		beiscsi_get_port_state(shost);
+		beiscsi_set_port_state(shost);
 		status = sprintf(buf, "%s\n", iscsi_get_port_state_name(shost));
 		break;
 	case ISCSI_HOST_PARAM_PORT_SPEED:
-		status = beiscsi_get_port_speed(shost);
-		if (status) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS_%d : Retreiving Port Speed Failed\n");
-			return status;
-		}
+		beiscsi_set_port_speed(shost);
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
index 15f7ad7..5c66f44 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1382,34 +1382,6 @@ unsigned int be_cmd_get_initname(struct beiscsi_hba *phba)
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
-	be_mcc_notify(phba);
-	mutex_unlock(&ctrl->mbox_lock);
-	return tag;
-}
-
 /**
  * be_mgmt_get_boot_shandle()- Get the session handle
  * @phba: device priv structure instance
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e4b3d8f..4414816 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4308,6 +4308,8 @@ static const struct {
 	{ISCSI_PORT_SPEED_100MBPS,	"100 Mbps" },
 	{ISCSI_PORT_SPEED_1GBPS,	"1 Gbps" },
 	{ISCSI_PORT_SPEED_10GBPS,	"10 Gbps" },
+	{ISCSI_PORT_SPEED_25GBPS,       "25 Gbps" },
+	{ISCSI_PORT_SPEED_40GBPS,       "40 Gbps" },
 };
 
 char *iscsi_get_port_speed_name(struct Scsi_Host *shost)
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 95ed942..d66c070 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -724,6 +724,8 @@ enum iscsi_port_speed {
 	ISCSI_PORT_SPEED_100MBPS	= 0x4,
 	ISCSI_PORT_SPEED_1GBPS		= 0x8,
 	ISCSI_PORT_SPEED_10GBPS		= 0x10,
+	ISCSI_PORT_SPEED_25GBPS         = 0x20,
+	ISCSI_PORT_SPEED_40GBPS         = 0x40,
 };
 
 /* iSCSI port state */
-- 
1.7.1

