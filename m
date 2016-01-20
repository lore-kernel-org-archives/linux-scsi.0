From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v4 15/17] be2iscsi: Fix async link event processing
Date: Wed, 20 Jan 2016 14:10:59 +0530
Message-ID: <1453279261-659-16-git-send-email-jitendra.bhivare@avagotech.com>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55634 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933862AbcATIl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 03:41:58 -0500
In-Reply-To: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Use only port_link_status only to determine link state change.
Only bit 0 is used to get the state.
Remove code for processing port_fault.

Fixed get_nic_conf structure definition. Removed rsvd[23] field in
be_cmd_get_nic_conf_resp.

Moved defintions of struct field values below the field.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  | 48 +++++++++++++++++++---------------------
 drivers/scsi/be2iscsi/be_cmds.h  | 32 +++++++++------------------
 drivers/scsi/be2iscsi/be_iscsi.c |  2 +-
 3 files changed, 34 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index ce82f4d..34c33d4 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -405,32 +405,31 @@ void beiscsi_fail_session(struct iscsi_cls_session *cls_session)
 	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
 }
 
-static void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
-		struct be_async_event_link_state *evt)
+static void beiscsi_process_async_link(struct beiscsi_hba *phba,
+				       struct be_mcc_compl *compl)
 {
-	phba->port_speed = evt->port_speed;
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
 
@@ -507,8 +506,7 @@ void beiscsi_process_async_event(struct beiscsi_hba *phba,
 	evt_code &= ASYNC_TRAILER_EVENT_CODE_MASK;
 	switch (evt_code) {
 	case ASYNC_EVENT_CODE_LINK_STATE:
-		beiscsi_async_link_state_process(phba,
-				(struct be_async_event_link_state *)compl);
+		beiscsi_process_async_link(phba, compl);
 		break;
 	case ASYNC_EVENT_CODE_ISCSI:
 		phba->state |= BE_ADAPTER_CHECK_BOOT;
@@ -524,8 +522,8 @@ void beiscsi_process_async_event(struct beiscsi_hba *phba,
 	}
 
 	beiscsi_log(phba, sev, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BC_%d : ASYNC Event: status 0x%08x flags 0x%08x\n",
-		    compl->status, compl->flags);
+		    "BC_%d : ASYNC Event %x: status 0x%08x flags 0x%08x\n",
+		    evt_code, compl->status, compl->flags);
 }
 
 int beiscsi_process_mcc(struct beiscsi_hba *phba)
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index a194066..7caf585 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -142,7 +142,6 @@ struct be_async_event_trailer {
 enum {
 	ASYNC_EVENT_LINK_DOWN = 0x0,
 	ASYNC_EVENT_LINK_UP = 0x1,
-	ASYNC_EVENT_LOGICAL = 0x2
 };
 
 /**
@@ -152,7 +151,15 @@ enum {
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
+	u8 port_speed;
 /* BE2ISCSI_LINK_SPEED_ZERO	0x00 - no link */
 #define BE2ISCSI_LINK_SPEED_10MBPS	0x01
 #define BE2ISCSI_LINK_SPEED_100MBPS	0x02
@@ -160,10 +167,6 @@ struct be_async_event_link_state {
 #define BE2ISCSI_LINK_SPEED_10GBPS	0x04
 #define BE2ISCSI_LINK_SPEED_25GBPS	0x06
 #define BE2ISCSI_LINK_SPEED_40GBPS	0x07
-	u8 port_speed;
-#define BEISCSI_PHY_LINK_FAULT_NONE	0x00
-#define BEISCSI_PHY_LINK_FAULT_LOCAL	0x01
-#define BEISCSI_PHY_LINK_FAULT_REMOTE	0x02
 	u8 port_fault;
 	u8 event_reason;
 	u16 qos_link_speed;
@@ -684,20 +687,6 @@ struct be_cmd_req_modify_eq_delay {
 
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
@@ -706,9 +695,8 @@ struct be_cmd_get_nic_conf_resp {
 	u32 link_state;
 	u32 max_frame_size;
 	u16 size_of_structure;
-	u8 mac_address[6];
-	u32 rsvd[23];
-};
+	u8 mac_address[ETH_ALEN];
+} __packed;
 
 #define BEISCSI_ALIAS_LEN 32
 
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a3bc5e4..9eef68b 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -758,7 +758,7 @@ static void beiscsi_get_port_state(struct Scsi_Host *shost)
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 	struct iscsi_cls_host *ihost = shost->shost_data;
 
-	ihost->port_state = (phba->state == BE_ADAPTER_LINK_UP) ?
+	ihost->port_state = (phba->state & BE_ADAPTER_LINK_UP) ?
 		ISCSI_PORT_STATE_UP : ISCSI_PORT_STATE_DOWN;
 }
 
-- 
2.5.0

