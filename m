From: Joe Perches <joe@perches.com>
Subject: [PATCH] be2iscsi: Use a more current logging style
Date: Sun, 14 Aug 2016 11:55:55 -0700
Message-ID: <e49903a4248d8f49e129ce795dd06fc4f2cd6331.1471200669.git.joe@perches.com>
References: <1471191843.4075.39.camel@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471191843.4075.39.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

shost_printk macros are converted to beiscsi_<level> for  a
more current logging style.

Consolidate the masked tests into a beiscsi_printk macro and
use that to call shost_printk.

Convert the __beiscsi_log macros to use shost_print directly.

Miscellanea:

o Remove the file prefix identifier and use kbasename(__FILE__)
  and stringify(__LINE__) to reduce code size in beiscsi_printk
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  | 142 ++++----
 drivers/scsi/be2iscsi/be_iscsi.c | 223 ++++++------
 drivers/scsi/be2iscsi/be_main.c  | 733 +++++++++++++++++++--------------------
 drivers/scsi/be2iscsi/be_main.h  |  20 +-
 drivers/scsi/be2iscsi/be_mgmt.c  | 270 +++++++-------
 5 files changed, 668 insertions(+), 720 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index a51bc0e..574d2f4 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -95,8 +95,8 @@ int be_chk_reset_complete(struct beiscsi_hba *phba)
 	}
 
 	if ((status & 0x80000000) || (!num_loop)) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BC", "Failed in be_chk_reset_complete status = 0x%x\n",
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Failed in be_chk_reset_complete status = 0x%x\n",
 			    status);
 		return -EIO;
 	}
@@ -135,9 +135,9 @@ struct be_mcc_wrb *alloc_mcc_wrb(struct beiscsi_hba *phba,
 
 	spin_lock_bh(&phba->ctrl.mcc_lock);
 	if (mccq->used == mccq->len) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT |
+		beiscsi_err(phba, BEISCSI_LOG_INIT |
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC", "MCC queue full: WRB used %u tag avail %u\n",
+			    "MCC queue full: WRB used %u tag avail %u\n",
 			    mccq->used, phba->ctrl.mcc_tag_available);
 		goto alloc_failed;
 	}
@@ -147,9 +147,9 @@ struct be_mcc_wrb *alloc_mcc_wrb(struct beiscsi_hba *phba,
 
 	tag = phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
 	if (!tag) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT |
+		beiscsi_err(phba, BEISCSI_LOG_INIT |
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC", "MCC tag 0 allocated: tag avail %u alloc index %u\n",
+			    "MCC tag 0 allocated: tag avail %u alloc index %u\n",
 			    phba->ctrl.mcc_tag_available,
 			    phba->ctrl.mcc_alloc_index);
 		goto alloc_failed;
@@ -263,10 +263,10 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 		set_bit(MCC_TAG_STATE_TIMEOUT,
 				&phba->ctrl.ptag_state[tag].tag_state);
 
-		beiscsi_log(phba, KERN_ERR,
+		beiscsi_err(phba,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
 			    BEISCSI_LOG_CONFIG,
-			    "BC", "MBX Cmd Completion timed out\n");
+			    "MBX Cmd Completion timed out\n");
 		return -EBUSY;
 	}
 
@@ -289,22 +289,22 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 	}
 
 	if (status || addl_status) {
-		beiscsi_log(phba, KERN_WARNING,
-			    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
-			    BEISCSI_LOG_CONFIG,
-			    "BC", "MBX Cmd Failed for Subsys : %d Opcode : %d with Status : %d and Extd_Status : %d\n",
-			    mbx_hdr->subsystem,
-			    mbx_hdr->opcode,
-			    status, addl_status);
+		beiscsi_warn(phba,
+			     BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
+			     BEISCSI_LOG_CONFIG,
+			     "MBX Cmd Failed for Subsys : %d Opcode : %d with Status : %d and Extd_Status : %d\n",
+			     mbx_hdr->subsystem,
+			     mbx_hdr->opcode,
+			     status, addl_status);
 		rc = -EIO;
 		if (status == MCC_STATUS_INSUFFICIENT_BUFFER) {
 			mbx_resp_hdr = (struct be_cmd_resp_hdr *) mbx_hdr;
-			beiscsi_log(phba, KERN_WARNING,
-				    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
-				    BEISCSI_LOG_CONFIG,
-				    "BC", "Insufficient Buffer Error Resp_Len : %d Actual_Resp_Len : %d\n",
-				    mbx_resp_hdr->response_length,
-				    mbx_resp_hdr->actual_resp_len);
+			beiscsi_warn(phba,
+				     BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
+				     BEISCSI_LOG_CONFIG,
+				     "Insufficient Buffer Error Resp_Len : %d Actual_Resp_Len : %d\n",
+				     mbx_resp_hdr->response_length,
+				     mbx_resp_hdr->actual_resp_len);
 			rc = -EAGAIN;
 		}
 	}
@@ -339,9 +339,8 @@ static int beiscsi_process_mbox_compl(struct be_ctrl_info *ctrl,
 	 * entry is little endian)
 	 */
 	if (!compl->flags) {
-		beiscsi_log(phba, KERN_ERR,
-				BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-				"BC", "BMBX busy, no completion\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			    "BMBX busy, no completion\n");
 		return -EBUSY;
 	}
 	compl->flags = le32_to_cpu(compl->flags);
@@ -362,8 +361,8 @@ static int beiscsi_process_mbox_compl(struct be_ctrl_info *ctrl,
 	if (compl_status == MCC_STATUS_SUCCESS)
 		return 0;
 
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BC", "error in cmd completion: Subsystem : %d Opcode : %d status(compl/extd)=%d/%d\n",
+	beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		    "error in cmd completion: Subsystem : %d Opcode : %d status(compl/extd)=%d/%d\n",
 		    hdr->subsystem, hdr->opcode, compl_status, extd_status);
 
 	if (compl_status == MCC_STATUS_INSUFFICIENT_BUFFER) {
@@ -390,14 +389,14 @@ static void beiscsi_process_async_link(struct beiscsi_hba *phba,
 	if (evt->port_link_status & BE_ASYNC_LINK_UP_MASK) {
 		phba->state = BE_ADAPTER_LINK_UP | BE_ADAPTER_CHECK_BOOT;
 		phba->get_boot = BE_GET_BOOT_RETRIES;
-		__beiscsi_log(phba, KERN_ERR,
-			      "BC%d: Link Up on Port %d tag 0x%x\n",
-			      __LINE__, evt->physical_port, evt->event_tag);
+		shost_printk(KERN_ERR, phba->shost,
+			     "BC%d: Link Up on Port %d tag 0x%x\n",
+			     __LINE__, evt->physical_port, evt->event_tag);
 	} else {
 		phba->state = BE_ADAPTER_LINK_DOWN;
-		__beiscsi_log(phba, KERN_ERR,
-			      "BC%d: Link Down on Port %d tag 0x%x\n",
-			      __LINE__, evt->physical_port, evt->event_tag);
+		shost_printk(KERN_ERR, phba->shost,
+			     "BC%d: Link Down on Port %d tag 0x%x\n",
+			     __LINE__, evt->physical_port, evt->event_tag);
 		iscsi_host_for_each_session(phba->shost,
 					    beiscsi_fail_session);
 	}
@@ -438,9 +437,9 @@ static void beiscsi_process_async_sli(struct beiscsi_hba *phba,
 
 	if (state >= ARRAY_SIZE(beiscsi_port_misconf_event_msg)) {
 		/* fw is reporting a state we don't know, log and return */
-		__beiscsi_log(phba, KERN_ERR,
-			      "BC%d: Port %c: Unrecognized optic state 0x%x\n",
-			      __LINE__, phba->port_name, async_sli->event_data1);
+		shost_printk(KERN_ERR, phba->shost,
+			     "BC%d: Port %c: Unrecognized optic state 0x%x\n",
+			     __LINE__, phba->port_name, async_sli->event_data1);
 		return;
 	}
 
@@ -459,16 +458,16 @@ static void beiscsi_process_async_sli(struct beiscsi_hba *phba,
 	}
 
 	if (old_state != phba->optic_state)
-		__beiscsi_log(phba, sev, "BC%d: Port %c: %s%s\n",
-			      __LINE__, phba->port_name,
-			      beiscsi_port_misconf_event_msg[state],
-			      !msg ? "" : msg);
+		shost_printk(sev, phba->shost, "BC%d: Port %c: %s%s\n",
+			     __LINE__, phba->port_name,
+			     beiscsi_port_misconf_event_msg[state],
+			     !msg ? "" : msg);
 }
 
 void beiscsi_process_async_event(struct beiscsi_hba *phba,
 				struct be_mcc_compl *compl)
 {
-	char *sev = KERN_INFO;
+	bool err = false;
 	u8 evt_code;
 
 	/* interpret flags as an async trailer */
@@ -481,19 +480,24 @@ void beiscsi_process_async_event(struct beiscsi_hba *phba,
 	case ASYNC_EVENT_CODE_ISCSI:
 		phba->state |= BE_ADAPTER_CHECK_BOOT;
 		phba->get_boot = BE_GET_BOOT_RETRIES;
-		sev = KERN_ERR;
+		err = true;
 		break;
 	case ASYNC_EVENT_CODE_SLI:
 		beiscsi_process_async_sli(phba, compl);
 		break;
 	default:
 		/* event not registered */
-		sev = KERN_ERR;
+		err = true;
 	}
 
-	beiscsi_log(phba, sev, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BC", "ASYNC Event %x: status 0x%08x flags 0x%08x\n",
-		    evt_code, compl->status, compl->flags);
+	if (err)
+		beiscsi_err(phba,  BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			    "ASYNC Event %x: status 0x%08x flags 0x%08x\n",
+			    evt_code, compl->status, compl->flags);
+	else
+		beiscsi_info(phba,  BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			     "ASYNC Event %x: status 0x%08x flags 0x%08x\n",
+			     evt_code, compl->status, compl->flags);
 }
 
 int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
@@ -510,17 +514,17 @@ int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
 
 	if (!test_bit(MCC_TAG_STATE_RUNNING,
 		      &ctrl->ptag_state[tag].tag_state)) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_MBOX |
+		beiscsi_err(phba, BEISCSI_LOG_MBOX |
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BC", "MBX cmd completed but not posted\n");
+			    "MBX cmd completed but not posted\n");
 		return 0;
 	}
 
 	if (test_bit(MCC_TAG_STATE_TIMEOUT, &ctrl->ptag_state[tag].tag_state)) {
-		beiscsi_log(phba, KERN_WARNING,
-			    BEISCSI_LOG_MBOX | BEISCSI_LOG_INIT |
-			    BEISCSI_LOG_CONFIG,
-			    "BC", "MBX Completion for timeout Command from FW\n");
+		beiscsi_warn(phba,
+			     BEISCSI_LOG_MBOX | BEISCSI_LOG_INIT |
+			     BEISCSI_LOG_CONFIG,
+			     "MBX Completion for timeout Command from FW\n");
 		/**
 		 * Check for the size before freeing resource.
 		 * Only for non-embedded cmd, PCI resource is allocated.
@@ -571,9 +575,8 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 
 	if (!test_bit(MCC_TAG_STATE_RUNNING,
 		      &ctrl->ptag_state[tag].tag_state)) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC", "tag %u state not running\n", tag);
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			    "tag %u state not running\n", tag);
 		return 0;
 	}
 	for (i = 0; i < mcc_timeout; i++) {
@@ -593,8 +596,8 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 	if (i < mcc_timeout)
 		return 0;
 
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BC", "FW Timed Out\n");
+	beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		    "FW Timed Out\n");
 	phba->fw_timeout = true;
 	beiscsi_ue_detect(phba);
 	return -EBUSY;
@@ -655,9 +658,8 @@ static int be_mbox_db_ready_poll(struct be_ctrl_info *ctrl)
 		msleep(20);
 	} while (!ready);
 
-	beiscsi_log(phba, KERN_ERR,
-			BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			"BC", "FW Timed Out\n");
+	beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		    "FW Timed Out\n");
 
 	phba->fw_timeout = true;
 	beiscsi_ue_detect(phba);
@@ -849,8 +851,8 @@ int be_cmd_fw_initialize(struct be_ctrl_info *ctrl)
 
 	status = be_mbox_notify(ctrl);
 	if (status)
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BC", "be_cmd_fw_initialize Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "be_cmd_fw_initialize Failed\n");
 
 	mutex_unlock(&ctrl->mbox_lock);
 	return status;
@@ -890,8 +892,8 @@ int be_cmd_fw_uninit(struct be_ctrl_info *ctrl)
 
 	status = be_mbox_notify(ctrl);
 	if (status)
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BC", "be_cmd_fw_uninit Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "be_cmd_fw_uninit Failed\n");
 
 	mutex_unlock(&ctrl->mbox_lock);
 	return status;
@@ -955,8 +957,8 @@ int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 		cq->id = le16_to_cpu(resp->cq_id);
 		cq->created = true;
 	} else
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BC", "In be_cmd_cq_create, status=ox%08x\n",
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "In be_cmd_cq_create, status=ox%08x\n",
 			    status);
 
 	mutex_unlock(&ctrl->mbox_lock);
@@ -1031,9 +1033,9 @@ int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 	u8 subsys = 0, opcode = 0;
 	int status;
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BC", "In beiscsi_cmd_q_destroy queue_type : %d\n",
-		    queue_type);
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "In beiscsi_cmd_q_destroy queue_type : %d\n",
+		     queue_type);
 
 	mutex_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
@@ -1327,8 +1329,8 @@ int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
 
 		status = be_mbox_notify(ctrl);
 		if (status) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BC", "FW CMD to map iscsi frags failed.\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "FW CMD to map iscsi frags failed.\n");
 
 			goto error;
 		}
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 28aebd3..b0909da 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -60,17 +60,17 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 	phba = beiscsi_ep->phba;
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "PCI_ERROR Recovery\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "PCI_ERROR Recovery\n");
 		return NULL;
 	} else {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS", "In beiscsi_session_create\n");
+		beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+			     "In beiscsi_session_create\n");
 	}
 
 	if (cmds_max > beiscsi_ep->phba->params.wrbs_per_cxn) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Cannot handle %d cmds.Max cmds per session supported is %d. Using %d.\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Cannot handle %d cmds.Max cmds per session supported is %d. Using %d.\n",
 			    cmds_max,
 			    beiscsi_ep->phba->params.wrbs_per_cxn,
 			    beiscsi_ep->phba->params.wrbs_per_cxn);
@@ -137,9 +137,9 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
 	shost = iscsi_session_to_shost(cls_session);
 	phba = iscsi_host_priv(shost);
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS", "In beiscsi_conn_create ,cidfrom iscsi layer=%d\n",
-		    cid);
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "In beiscsi_conn_create ,cidfrom iscsi layer=%d\n",
+		     cid);
 
 	cls_conn = iscsi_conn_setup(cls_session, sizeof(*beiscsi_conn), cid);
 	if (!cls_conn)
@@ -169,14 +169,14 @@ static int beiscsi_bindconn_cid(struct beiscsi_hba *phba,
 	uint16_t cri_index = BE_GET_CRI_FROM_CID(cid);
 
 	if (phba->conn_table[cri_index]) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Connection table already occupied. Detected clash\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Connection table already occupied. Detected clash\n");
 
 		return -EINVAL;
 	} else {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS", "phba->conn_table[%d]=%p(beiscsi_conn)\n",
-			    cri_index, beiscsi_conn);
+		beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+			     "phba->conn_table[%d]=%p(beiscsi_conn)\n",
+			     cri_index, beiscsi_conn);
 
 		phba->conn_table[cri_index] = beiscsi_conn;
 	}
@@ -214,8 +214,8 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		return -EINVAL;
 
 	if (beiscsi_ep->phba != phba) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "beiscsi_ep->hba=%p not equal to phba=%p\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "beiscsi_ep->hba=%p not equal to phba=%p\n",
 			    beiscsi_ep->phba, phba);
 
 		return -EEXIST;
@@ -229,9 +229,9 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	beiscsi_ep->conn = beiscsi_conn;
 	beiscsi_conn->doorbell_offset = pwrb_context->doorbell_offset;
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS", "beiscsi_conn=%p conn=%p ep_cid=%d\n",
-		    beiscsi_conn, conn, beiscsi_ep->ep_cid);
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "beiscsi_conn=%p conn=%p ep_cid=%d\n",
+		     beiscsi_conn, conn, beiscsi_ep->ep_cid);
 
 	return beiscsi_bindconn_cid(phba, beiscsi_conn, beiscsi_ep->ep_cid);
 }
@@ -246,8 +246,8 @@ static int beiscsi_create_ipv4_iface(struct beiscsi_hba *phba)
 					      ISCSI_IFACE_TYPE_IPV4,
 					      0, 0);
 	if (!phba->ipv4_iface) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Could not create default IPv4 address.\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Could not create default IPv4 address.\n");
 		return -ENODEV;
 	}
 
@@ -264,8 +264,8 @@ static int beiscsi_create_ipv6_iface(struct beiscsi_hba *phba)
 					      ISCSI_IFACE_TYPE_IPV6,
 					      0, 0);
 	if (!phba->ipv6_iface) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Could not create default IPv6 address.\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Could not create default IPv6 address.\n");
 		return -ENODEV;
 	}
 
@@ -330,14 +330,14 @@ beiscsi_set_static_ip(struct Scsi_Host *shost,
 			iface_ip = nla_data(nla);
 		break;
 	default:
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Unsupported param %d\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Unsupported param %d\n",
 			    iface_param->param);
 	}
 
 	if (!iface_ip || !iface_subnet) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "IP and Subnet Mask required\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "IP and Subnet Mask required\n");
 		return -EINVAL;
 	}
 
@@ -369,8 +369,8 @@ beiscsi_set_vlan_tag(struct Scsi_Host *shost,
 	/* Get the Interface Handle */
 	ret = mgmt_get_all_if_id(phba);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Getting Interface Handle Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Getting Interface Handle Failed\n");
 		return ret;
 	}
 
@@ -384,9 +384,9 @@ beiscsi_set_vlan_tag(struct Scsi_Host *shost,
 				    *((uint16_t *)iface_param->value));
 		break;
 	default:
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BS", "Unknown Param Type : %d\n",
-			    iface_param->param);
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+			     "Unknown Param Type : %d\n",
+			     iface_param->param);
 		return -ENOSYS;
 	}
 	return ret;
@@ -414,8 +414,8 @@ beiscsi_set_ipv4(struct Scsi_Host *shost,
 			ret = beiscsi_set_static_ip(shost, iface_param,
 						    data, dt_len);
 		else
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS", "Invalid BOOTPROTO: %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+				    "Invalid BOOTPROTO: %d\n",
 				    iface_param->value[0]);
 		break;
 	case ISCSI_NET_PARAM_IFACE_ENABLE:
@@ -434,8 +434,8 @@ beiscsi_set_ipv4(struct Scsi_Host *shost,
 		ret = beiscsi_set_vlan_tag(shost, iface_param);
 		break;
 	default:
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Param %d not supported\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Param %d not supported\n",
 			    iface_param->param);
 	}
 
@@ -468,8 +468,8 @@ beiscsi_set_ipv6(struct Scsi_Host *shost,
 		ret = beiscsi_set_vlan_tag(shost, iface_param);
 		break;
 	default:
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Param %d not supported\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Param %d not supported\n",
 			    iface_param->param);
 	}
 
@@ -486,8 +486,8 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 	int ret = 0 ;
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "In PCI_ERROR Recovery\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "In PCI_ERROR Recovery\n");
 		return -EBUSY;
 	}
 
@@ -501,8 +501,8 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 		 * BE2ISCSI only supports 1 interface
 		 */
 		if (iface_param->iface_num) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS", "Invalid iface_num %d.Only iface_num 0 is supported.\n",
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+				    "Invalid iface_num %d.Only iface_num 0 is supported.\n",
 				    iface_param->iface_num);
 
 			return -EINVAL;
@@ -518,8 +518,8 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 					       data, dt_len);
 			break;
 		default:
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS", "Invalid iface type :%d passed\n",
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+				    "Invalid iface type :%d passed\n",
 				    iface_param->iface_type);
 			break;
 		}
@@ -600,8 +600,8 @@ int be2iscsi_iface_get_param(struct iscsi_iface *iface,
 	int len = -ENOSYS;
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "In PCI_ERROR Recovery\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "In PCI_ERROR Recovery\n");
 		return -EBUSY;
 	}
 
@@ -645,10 +645,9 @@ int beiscsi_ep_get_param(struct iscsi_endpoint *ep,
 	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
 	int len = 0;
 
-	beiscsi_log(beiscsi_ep->phba, KERN_INFO,
-		    BEISCSI_LOG_CONFIG,
-		    "BS", "In beiscsi_ep_get_param, param= %d\n",
-		    param);
+	beiscsi_info(beiscsi_ep->phba, BEISCSI_LOG_CONFIG,
+		     "In beiscsi_ep_get_param, param= %d\n",
+		     param);
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
@@ -675,9 +674,9 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 	int ret;
 
 	phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS", "In beiscsi_conn_set_param, param= %d\n",
-		    param);
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "In beiscsi_conn_set_param, param= %d\n",
+		     param);
 
 	ret = iscsi_set_param(cls_conn, param, buf, buflen);
 	if (ret)
@@ -725,17 +724,17 @@ static int beiscsi_get_initname(char *buf, struct beiscsi_hba *phba)
 
 	tag = be_cmd_get_initname(phba);
 	if (!tag) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Getting Initiator Name Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Getting Initiator Name Failed\n");
 
 		return -EBUSY;
 	}
 
 	rc = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
 	if (rc) {
-		beiscsi_log(phba, KERN_ERR,
+		beiscsi_err(phba,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BS", "Initiator Name MBX Failed\n");
+			    "Initiator Name MBX Failed\n");
 		return rc;
 	}
 
@@ -808,29 +807,29 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "In PCI_ERROR Recovery\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "In PCI_ERROR Recovery\n");
 		return -EBUSY;
 	} else {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS", "In beiscsi_get_host_param, param = %d\n",
-			    param);
+		beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+			     "In beiscsi_get_host_param, param = %d\n",
+			     param);
 	}
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_HWADDRESS:
 		status = beiscsi_get_macaddr(buf, phba);
 		if (status < 0) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS", "beiscsi_get_macaddr Failed\n");
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+				    "beiscsi_get_macaddr Failed\n");
 			return status;
 		}
 		break;
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
 		status = beiscsi_get_initname(buf, phba);
 		if (status < 0) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS", "Retreiving Initiator Name Failed\n");
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+				    "Retreiving Initiator Name Failed\n");
 			return status;
 		}
 		break;
@@ -880,8 +879,8 @@ void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	struct beiscsi_hba *phba = NULL;
 
 	phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS", "In beiscsi_conn_get_stats\n");
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "In beiscsi_conn_get_stats\n");
 
 	stats->txdata_octets = conn->txdata_octets;
 	stats->rxdata_octets = conn->rxdata_octets;
@@ -958,21 +957,19 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "In PCI_ERROR Recovery\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "In PCI_ERROR Recovery\n");
 		return -EBUSY;
 	} else {
-		beiscsi_log(beiscsi_conn->phba, KERN_INFO,
-			    BEISCSI_LOG_CONFIG,
-			    "BS", "In beiscsi_conn_start\n");
+		beiscsi_info(beiscsi_conn->phba, BEISCSI_LOG_CONFIG,
+			     "In beiscsi_conn_start\n");
 	}
 
 	memset(&params, 0, sizeof(struct beiscsi_offload_params));
 	beiscsi_ep = beiscsi_conn->ep;
 	if (!beiscsi_ep)
-		beiscsi_log(beiscsi_conn->phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG,
-			    "BS", "In beiscsi_conn_start , no beiscsi_ep\n");
+		beiscsi_err(beiscsi_conn->phba, BEISCSI_LOG_CONFIG,
+			    "In beiscsi_conn_start , no beiscsi_ep\n");
 
 	beiscsi_conn->login_in_progress = 0;
 	beiscsi_set_params_for_offld(beiscsi_conn, &params);
@@ -1089,19 +1086,19 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	unsigned int tag, req_memsize;
 	int ret = -ENOMEM;
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS", "In beiscsi_open_conn\n");
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "In beiscsi_open_conn\n");
 
 	beiscsi_ep->ep_cid = beiscsi_get_cid(phba);
 	if (beiscsi_ep->ep_cid == 0xFFFF) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "No free cid available\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "No free cid available\n");
 		return ret;
 	}
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS", "In beiscsi_open_conn, ep_cid=%d\n",
-		    beiscsi_ep->ep_cid);
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "In beiscsi_open_conn, ep_cid=%d\n",
+		     beiscsi_ep->ep_cid);
 
 	phba->ep_array[BE_GET_CRI_FROM_CID
 		       (beiscsi_ep->ep_cid)] = ep;
@@ -1118,8 +1115,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Failed to allocate memory for mgmt_open_connection\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Failed to allocate memory for mgmt_open_connection\n");
 
 		beiscsi_free_ep(beiscsi_ep);
 		return -ENOMEM;
@@ -1128,8 +1125,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
 	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep, &nonemb_cmd);
 	if (tag <= 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "mgmt_open_connection Failed for cid=%d\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "mgmt_open_connection Failed for cid=%d\n",
 			    beiscsi_ep->ep_cid);
 
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
@@ -1140,9 +1137,9 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 
 	ret = beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR,
+		beiscsi_err(phba,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BS", "mgmt_open_connection Failed");
+			    "mgmt_open_connection Failed");
 
 		if (ret != -EBUSY)
 			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
@@ -1156,8 +1153,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	beiscsi_ep = ep->dd_data;
 	beiscsi_ep->fw_handle = ptcpcnct_out->connection_handle;
 	beiscsi_ep->cid_vld = 1;
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS", "mgmt_open_connection Success\n");
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "mgmt_open_connection Success\n");
 
 	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 			    nonemb_cmd.va, nonemb_cmd.dma);
@@ -1192,20 +1189,20 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 	if (beiscsi_error(phba)) {
 		ret = -EIO;
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BS", "The FW state Not Stable!!!\n");
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+			     "The FW state Not Stable!!!\n");
 		return ERR_PTR(ret);
 	}
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
 		ret = -EBUSY;
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "In PCI_ERROR Recovery\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "In PCI_ERROR Recovery\n");
 		return ERR_PTR(ret);
 	} else if (phba->state & BE_ADAPTER_LINK_DOWN) {
 		ret = -EBUSY;
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BS", "The Adapter Port state is Down!!!\n");
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+			     "The Adapter Port state is Down!!!\n");
 		return ERR_PTR(ret);
 	}
 
@@ -1220,8 +1217,8 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	beiscsi_ep->openiscsi_ep = ep;
 	ret = beiscsi_open_conn(ep, NULL, dst_addr, non_blocking);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "Failed in beiscsi_open_conn\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Failed in beiscsi_open_conn\n");
 		goto free_ep;
 	}
 
@@ -1243,8 +1240,8 @@ int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 {
 	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
 
-	beiscsi_log(beiscsi_ep->phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS", "In  beiscsi_ep_poll\n");
+	beiscsi_info(beiscsi_ep->phba, BEISCSI_LOG_CONFIG,
+		     "In  beiscsi_ep_poll\n");
 
 	if (beiscsi_ep->cid_vld == 1)
 		return 1;
@@ -1290,9 +1287,9 @@ static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
 
 	tag = mgmt_upload_connection(phba, beiscsi_ep->ep_cid, flag);
 	if (!tag) {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS", "upload failed for cid 0x%x\n",
-			    beiscsi_ep->ep_cid);
+		beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+			     "upload failed for cid 0x%x\n",
+			     beiscsi_ep->ep_cid);
 
 		ret = -EAGAIN;
 	}
@@ -1318,8 +1315,8 @@ static int beiscsi_unbind_conn_to_cid(struct beiscsi_hba *phba,
 	if (phba->conn_table[cri_index])
 		phba->conn_table[cri_index] = NULL;
 	else {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS", "Connection table Not occupied.\n");
+		beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+			     "Connection table Not occupied.\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -1342,9 +1339,9 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	beiscsi_ep = ep->dd_data;
 	phba = beiscsi_ep->phba;
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS", "In beiscsi_ep_disconnect for ep_cid = %d\n",
-		    beiscsi_ep->ep_cid);
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "In beiscsi_ep_disconnect for ep_cid = %d\n",
+		     beiscsi_ep->ep_cid);
 
 	if (beiscsi_ep->conn) {
 		beiscsi_conn = beiscsi_ep->conn;
@@ -1357,8 +1354,8 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 	}
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "PCI_ERROR Recovery\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "PCI_ERROR Recovery\n");
 		goto free_ep;
 	}
 
@@ -1367,8 +1364,8 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 					  mgmt_invalidate_flag,
 					  savecfg_flag);
 	if (!tag) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS", "mgmt_invalidate_connection Failed for cid=%d\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "mgmt_invalidate_connection Failed for cid=%d\n",
 			    beiscsi_ep->ep_cid);
 	}
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 19c1875..599f3a5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -77,14 +77,14 @@ int									\
 beiscsi_##_name##_change(struct beiscsi_hba *phba, uint32_t val)	\
 {									\
 	if (val >= _minval && val <= _maxval) {				\
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,		\
-			    "BA", "beiscsi_" #_name " updated from 0x%x ==> 0x%x\n", \
+		beiscsi_err(phba, BEISCSI_LOG_INIT,			\
+			    "beiscsi_" #_name " updated from 0x%x ==> 0x%x\n", \
 			    phba->attr_##_name, val);			\
 		phba->attr_##_name = val;				\
 		return 0;						\
 	}								\
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,			\
-		    "BA", "beiscsi_" #_name " attribute cannot be updated to 0x%x, range allowed is [" #_minval " - " #_maxval "]\n", val); \
+	beiscsi_err(phba, BEISCSI_LOG_INIT,				\
+		    "beiscsi_" #_name " attribute cannot be updated to 0x%x, range allowed is [" #_minval " - " #_maxval "]\n", val); \
 	return -EINVAL;							\
 }
 
@@ -115,8 +115,8 @@ beiscsi_##_name##_init(struct beiscsi_hba *phba, uint32_t val)		\
 		phba->attr_##_name = val;				\
 		return 0;						\
 	}								\
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,			\
-		    "BA", "beiscsi_" #_name " attribute cannot be updated to 0x%x, range allowed is [" #_minval " - " #_maxval "]\n", \
+	beiscsi_err(phba, BEISCSI_LOG_INIT,				\
+		    "beiscsi_" #_name " attribute cannot be updated to 0x%x, range allowed is [" #_minval " - " #_maxval "]\n", \
 		    val);						\
 	phba->attr_##_name = _defval;					\
 	return -EINVAL;							\
@@ -262,8 +262,8 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 				sizeof(struct invalidate_commands_params_in),
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
-			    "BM", "Failed to allocate memory for mgmt_invalidate_icds\n");
+		beiscsi_err(phba, BEISCSI_LOG_EH,
+			    "Failed to allocate memory for mgmt_invalidate_icds\n");
 		return FAILED;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -271,8 +271,8 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate,
 				   cid, &nonemb_cmd);
 	if (!tag) {
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
-			    "BM", "mgmt_invalidate_icds could not be submitted\n");
+		beiscsi_warn(phba, BEISCSI_LOG_EH,
+			     "mgmt_invalidate_icds could not be submitted\n");
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 
@@ -342,8 +342,8 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 				sizeof(struct invalidate_commands_params_in),
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
-			    "BM", "Failed to allocate memory for mgmt_invalidate_icds\n");
+		beiscsi_err(phba, BEISCSI_LOG_EH,
+			    "Failed to allocate memory for mgmt_invalidate_icds\n");
 		return FAILED;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -351,8 +351,8 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate,
 				   cid, &nonemb_cmd);
 	if (!tag) {
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
-			    "BM", "mgmt_invalidate_icds could not be submitted\n");
+		beiscsi_warn(phba, BEISCSI_LOG_EH,
+			     "mgmt_invalidate_icds could not be submitted\n");
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		return FAILED;
@@ -777,16 +777,16 @@ static void beiscsi_get_params(struct beiscsi_hba *phba)
 			phba->fw_config.iscsi_icd_count[ulp_num] = (icd_count -
 					icd_count_unavailable);
 
-			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					"BM", "Aligned ICD values\n"
-					"\t ICD Start : %d\n"
-					"\t ICD Count : %d\n"
-					"\t ICD Discarded : %d\n",
-					phba->fw_config.
-					iscsi_icd_start[ulp_num],
-					phba->fw_config.
-					iscsi_icd_count[ulp_num],
-					icd_count_unavailable);
+			beiscsi_info(phba, BEISCSI_LOG_INIT,
+				     "Aligned ICD values\n"
+				     "\t ICD Start : %d\n"
+				     "\t ICD Count : %d\n"
+				     "\t ICD Discarded : %d\n",
+				     phba->fw_config.
+				     iscsi_icd_start[ulp_num],
+				     phba->fw_config.
+				     iscsi_icd_count[ulp_num],
+				     icd_count_unavailable);
 			break;
 		}
 	}
@@ -1000,8 +1000,8 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 					  phba->msi_name[i],
 					  &phwi_context->be_eq[i]);
 			if (ret) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM", "beiscsi_init_irqs-Failed to register msix for i = %d\n",
+				beiscsi_err(phba, BEISCSI_LOG_INIT,
+					    "beiscsi_init_irqs-Failed to register msix for i = %d\n",
 					    i);
 				kfree(phba->msi_name[i]);
 				goto free_msix_irqs;
@@ -1018,8 +1018,8 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 		ret = request_irq(msix_vec, be_isr_mcc, 0, phba->msi_name[i],
 				  &phwi_context->be_eq[i]);
 		if (ret) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT ,
-				    "BM", "beiscsi_init_irqs-Failed to register beiscsi_msix_mcc\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "beiscsi_init_irqs-Failed to register beiscsi_msix_mcc\n");
 			kfree(phba->msi_name[i]);
 			goto free_msix_irqs;
 		}
@@ -1028,8 +1028,8 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 		ret = request_irq(pcidev->irq, be_isr, IRQF_SHARED,
 				  "beiscsi", phba);
 		if (ret) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "beiscsi_init_irqs-Failed to register irq\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "beiscsi_init_irqs-Failed to register irq\n");
 			return ret;
 		}
 	}
@@ -1089,9 +1089,8 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 	case ISCSI_OP_REJECT:
 		WARN_ON(!pbuffer);
 		WARN_ON(!(buf_len == 48));
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM", "In ISCSI_OP_REJECT\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+			    "In ISCSI_OP_REJECT\n");
 		break;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
@@ -1101,12 +1100,11 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 		login_hdr->itt = io_task->libiscsi_itt;
 		break;
 	default:
-		beiscsi_log(phba, KERN_WARNING,
-			    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-			    "BM", "Unrecognized opcode 0x%x in async msg\n",
-			    (ppdu->
-			     dw[offsetof(struct amap_pdu_base, opcode) / 32]
-			     & PDUBASE_OPCODE_MASK));
+		beiscsi_warn(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+			     "Unrecognized opcode 0x%x in async msg\n",
+			     (ppdu->
+			      dw[offsetof(struct amap_pdu_base, opcode) / 32]
+			      & PDUBASE_OPCODE_MASK));
 		return 1;
 	}
 
@@ -1122,9 +1120,9 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 
 	spin_lock_bh(&phba->io_sgl_lock);
 	if (phba->io_sgl_hndl_avbl) {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
-			    "BM", "In alloc_io_sgl_handle, io_sgl_alloc_index=%d\n",
-			    phba->io_sgl_alloc_index);
+		beiscsi_info(phba, BEISCSI_LOG_IO,
+			     "In alloc_io_sgl_handle, io_sgl_alloc_index=%d\n",
+			     phba->io_sgl_alloc_index);
 
 		psgl_handle = phba->io_sgl_hndl_base[phba->
 						io_sgl_alloc_index];
@@ -1145,17 +1143,17 @@ static void
 free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
 	spin_lock_bh(&phba->io_sgl_lock);
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
-		    "BM", "In free_,io_sgl_free_index=%d\n",
-		    phba->io_sgl_free_index);
+	beiscsi_info(phba, BEISCSI_LOG_IO,
+		     "In free_,io_sgl_free_index=%d\n",
+		     phba->io_sgl_free_index);
 
 	if (phba->io_sgl_hndl_base[phba->io_sgl_free_index]) {
 		/*
 		 * this can happen if clean_task is called on a task that
 		 * failed in xmit_task or alloc_pdu.
 		 */
-		 beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
-			     "BM", "Double Free in IO SGL io_sgl_free_index=%d, value there=%p\n",
+		beiscsi_info(phba, BEISCSI_LOG_IO,
+			     "Double Free in IO SGL io_sgl_free_index=%d, value there=%p\n",
 			     phba->io_sgl_free_index,
 			     phba->io_sgl_hndl_base
 			     [phba->io_sgl_free_index]);
@@ -1241,11 +1239,10 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 	beiscsi_put_wrb_handle(pwrb_context,
 			       pwrb_handle,
 			       phba->params.wrbs_per_cxn);
-	beiscsi_log(phba, KERN_INFO,
-		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-		    "BM", "FREE WRB: pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
-		    pwrb_handle, pwrb_context->free_index,
-		    pwrb_context->wrb_handles_available);
+	beiscsi_info(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+		     "FREE WRB: pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
+		     pwrb_handle, pwrb_context->free_index,
+		     pwrb_context->wrb_handles_available);
 }
 
 static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
@@ -1256,10 +1253,10 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 	if (phba->eh_sgl_hndl_avbl) {
 		psgl_handle = phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index];
 		phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index] = NULL;
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BM", "mgmt_sgl_alloc_index=%d=0x%x\n",
-			    phba->eh_sgl_alloc_index,
-			    phba->eh_sgl_alloc_index);
+		beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+			     "mgmt_sgl_alloc_index=%d=0x%x\n",
+			     phba->eh_sgl_alloc_index,
+			     phba->eh_sgl_alloc_index);
 
 		phba->eh_sgl_hndl_avbl--;
 		if (phba->eh_sgl_alloc_index ==
@@ -1278,18 +1275,18 @@ void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
 	spin_lock_bh(&phba->mgmt_sgl_lock);
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BM", "In  free_mgmt_sgl_handle, eh_sgl_free_index=%d\n",
-		    phba->eh_sgl_free_index);
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "In  free_mgmt_sgl_handle, eh_sgl_free_index=%d\n",
+		     phba->eh_sgl_free_index);
 
 	if (phba->eh_sgl_hndl_base[phba->eh_sgl_free_index]) {
 		/*
 		 * this can happen if clean_task is called on a task that
 		 * failed in xmit_task or alloc_pdu.
 		 */
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BM", "Double Free in eh SGL, eh_sgl_free_index=%d\n",
-			    phba->eh_sgl_free_index);
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+			     "Double Free in eh SGL, eh_sgl_free_index=%d\n",
+			     phba->eh_sgl_free_index);
 		spin_unlock_bh(&phba->mgmt_sgl_lock);
 		return;
 	}
@@ -1575,9 +1572,8 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		break;
 
 	case HWH_TYPE_LOGIN:
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM", "\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd - Solicited path\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+			    "\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd - Solicited path\n");
 		break;
 
 	case HWH_TYPE_NOP:
@@ -1585,12 +1581,11 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 		break;
 
 	default:
-		beiscsi_log(phba, KERN_WARNING,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM", "In hwi_complete_cmd, unknown type = %d wrb_index 0x%x CID 0x%x\n",
-			    type,
-			    csol_cqe.wrb_index,
-			    csol_cqe.cid);
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+			     "In hwi_complete_cmd, unknown type = %d wrb_index 0x%x CID 0x%x\n",
+			     type,
+			     csol_cqe.wrb_index,
+			     csol_cqe.cid);
 		break;
 	}
 
@@ -1656,11 +1651,10 @@ hwi_get_async_handle(struct beiscsi_hba *phba,
 		break;
 	default:
 		pbusy_list = NULL;
-		beiscsi_log(phba, KERN_WARNING,
-			    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-			    "BM", "Unexpected code=%d\n",
-			    pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe,
-			    code) / 32] & PDUCQE_CODE_MASK);
+		beiscsi_warn(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+			     "Unexpected code=%d\n",
+			     pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe,
+						    code) / 32] & PDUCQE_CODE_MASK);
 		return NULL;
 	}
 
@@ -1721,9 +1715,8 @@ hwi_update_async_writables(struct beiscsi_hba *phba,
 	}
 
 	if (!writables) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM", "Duplicate notification received - index 0x%x!!\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+			    "Duplicate notification received - index 0x%x!!\n",
 			    cq_index);
 		WARN_ON(1);
 	}
@@ -2111,10 +2104,9 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 			/* connection has already been freed
 			 * just move on to next one
 			 */
-			beiscsi_log(phba, KERN_WARNING,
-				    BEISCSI_LOG_INIT,
-				    "BM", "proc cqe of disconn ep: cid %d\n",
-				    cid);
+			beiscsi_warn(phba, BEISCSI_LOG_INIT,
+				     "proc cqe of disconn ep: cid %d\n",
+				     cid);
 			goto proc_next_cqe;
 		}
 
@@ -2133,19 +2125,17 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 			hwi_complete_cmd(beiscsi_conn, phba, sol);
 			break;
 		case DRIVERMSG_NOTIFY:
-			beiscsi_log(phba, KERN_INFO,
-				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM", "Received %s[%d] on CID : %d\n",
-				    cqe_desc[code], code, cid);
+			beiscsi_info(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				     "Received %s[%d] on CID : %d\n",
+				     cqe_desc[code], code, cid);
 
 			dmsg = (struct dmsg_cqe *)sol;
 			hwi_complete_drvr_msgs(beiscsi_conn, phba, sol);
 			break;
 		case UNSOL_HDR_NOTIFY:
-			beiscsi_log(phba, KERN_INFO,
-				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM", "Received %s[%d] on CID : %d\n",
-				    cqe_desc[code], code, cid);
+			beiscsi_info(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				     "Received %s[%d] on CID : %d\n",
+				     cqe_desc[code], code, cid);
 
 			spin_lock_bh(&phba->async_pdu_lock);
 			hwi_process_default_pdu_ring(beiscsi_conn, phba,
@@ -2153,10 +2143,9 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 			spin_unlock_bh(&phba->async_pdu_lock);
 			break;
 		case UNSOL_DATA_NOTIFY:
-			beiscsi_log(phba, KERN_INFO,
-				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-				    "BM", "Received %s[%d] on CID : %d\n",
-				    cqe_desc[code], code, cid);
+			beiscsi_info(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+				     "Received %s[%d] on CID : %d\n",
+				     cqe_desc[code], code, cid);
 
 			spin_lock_bh(&phba->async_pdu_lock);
 			hwi_process_default_pdu_ring(beiscsi_conn, phba,
@@ -2166,16 +2155,14 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		case CXN_INVALIDATE_INDEX_NOTIFY:
 		case CMD_INVALIDATED_NOTIFY:
 		case CXN_INVALIDATE_NOTIFY:
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM", "Ignoring %s[%d] on CID : %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				    "Ignoring %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 			break;
 		case CXN_KILLED_HDR_DIGEST_ERR:
 		case SOL_CMD_KILLED_DATA_DIGEST_ERR:
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-				    "BM", "Cmd Notification %s[%d] on CID : %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+				    "Cmd Notification %s[%d] on CID : %d\n",
 				    cqe_desc[code], code,  cid);
 			break;
 		case CMD_KILLED_INVALID_STATSN_RCVD:
@@ -2185,15 +2172,13 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		case CMD_CXN_KILLED_ITT_INVALID:
 		case CMD_CXN_KILLED_SEQ_OUTOFORDER:
 		case CMD_CXN_KILLED_INVALID_DATASN_RCVD:
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-				    "BM", "Cmd Notification %s[%d] on CID : %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+				    "Cmd Notification %s[%d] on CID : %d\n",
 				    cqe_desc[code], code,  cid);
 			break;
 		case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM", "Dropping %s[%d] on DPDU ring on CID : %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				    "Dropping %s[%d] on DPDU ring on CID : %d\n",
 				    cqe_desc[code], code, cid);
 			spin_lock_bh(&phba->async_pdu_lock);
 			hwi_flush_default_pdu_buffer(phba, beiscsi_conn,
@@ -2215,18 +2200,16 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		case CXN_KILLED_OVER_RUN_RESIDUAL:
 		case CXN_KILLED_UNDER_RUN_RESIDUAL:
 		case CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN:
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM", "Event %s[%d] received on CID : %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				    "Event %s[%d] received on CID : %d\n",
 				    cqe_desc[code], code, cid);
 			if (beiscsi_conn)
 				iscsi_conn_failure(beiscsi_conn->conn,
 						   ISCSI_ERR_CONN_FAILED);
 			break;
 		default:
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM", "Invalid CQE Event Received Code : %d CID 0x%x...\n",
+			beiscsi_err(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				    "Invalid CQE Event Received Code : %d CID 0x%x...\n",
 				    code, cid);
 			break;
 		}
@@ -2303,10 +2286,9 @@ static int be_iopoll(struct irq_poll *iop, int budget)
 	pbe_eq->cq_count += ret;
 	if (ret < budget) {
 		irq_poll_complete(iop);
-		beiscsi_log(phba, KERN_INFO,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM", "rearm pbe_eq->q.id =%d ret %d\n",
-			    pbe_eq->q.id, ret);
+		beiscsi_info(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
+			     "rearm pbe_eq->q.id =%d ret %d\n",
+			     pbe_eq->q.id, ret);
 		hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
 	}
 	return ret;
@@ -2862,8 +2844,8 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 				     phba->params.cxns_per_ctrl,
 				     GFP_KERNEL);
 	if (!phwi_ctxt->be_wrbq) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "WRBQ Mem Alloc Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "WRBQ Mem Alloc Failed\n");
 		return -ENOMEM;
 	}
 
@@ -2873,16 +2855,16 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 				kzalloc(sizeof(struct wrb_handle *) *
 					phba->params.wrbs_per_cxn, GFP_KERNEL);
 		if (!pwrb_context->pwrb_handle_base) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "Mem Alloc Failed. Failing to load\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "Mem Alloc Failed. Failing to load\n");
 			goto init_wrb_hndl_failed;
 		}
 		pwrb_context->pwrb_handle_basestd =
 				kzalloc(sizeof(struct wrb_handle *) *
 					phba->params.wrbs_per_cxn, GFP_KERNEL);
 		if (!pwrb_context->pwrb_handle_basestd) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "Mem Alloc Failed. Failing to load\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "Mem Alloc Failed. Failing to load\n");
 			goto init_wrb_hndl_failed;
 		}
 		if (!num_cxn_wrbh) {
@@ -2978,16 +2960,15 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 			mem_descr += HWI_MEM_ASYNC_HEADER_BUF_ULP0 +
 				(ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
-				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF_ULP%d va=%p\n",
-					    ulp_num,
-					    mem_descr->mem_array[0].
-					    virtual_address);
+				beiscsi_info(phba, BEISCSI_LOG_INIT,
+					     "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF_ULP%d va=%p\n",
+					     ulp_num,
+					     mem_descr->mem_array[0].
+					     virtual_address);
 			} else
-				beiscsi_log(phba, KERN_WARNING,
-					    BEISCSI_LOG_INIT,
-					    "BM", "No Virtual address for ULP : %d\n",
-					    ulp_num);
+				beiscsi_warn(phba, BEISCSI_LOG_INIT,
+					     "No Virtual address for ULP : %d\n",
+					     ulp_num);
 
 			pasync_ctx->async_header.va_base =
 				mem_descr->mem_array[0].virtual_address;
@@ -3000,16 +2981,15 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 			mem_descr += HWI_MEM_ASYNC_HEADER_RING_ULP0 +
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
-				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING_ULP%d va=%p\n",
-					    ulp_num,
-					    mem_descr->mem_array[0].
-					    virtual_address);
+				beiscsi_info(phba, BEISCSI_LOG_INIT,
+					     "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING_ULP%d va=%p\n",
+					     ulp_num,
+					     mem_descr->mem_array[0].
+					     virtual_address);
 			} else
-				beiscsi_log(phba, KERN_WARNING,
-					    BEISCSI_LOG_INIT,
-					    "BM", "No Virtual address for ULP : %d\n",
-					    ulp_num);
+				beiscsi_warn(phba, BEISCSI_LOG_INIT,
+					     "No Virtual address for ULP : %d\n",
+					     ulp_num);
 
 			pasync_ctx->async_header.ring_base =
 				mem_descr->mem_array[0].virtual_address;
@@ -3018,16 +2998,15 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 			mem_descr += HWI_MEM_ASYNC_HEADER_HANDLE_ULP0 +
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
-				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE_ULP%d va=%p\n",
-					    ulp_num,
-					    mem_descr->mem_array[0].
-					    virtual_address);
+				beiscsi_info(phba, BEISCSI_LOG_INIT,
+					     "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE_ULP%d va=%p\n",
+					     ulp_num,
+					     mem_descr->mem_array[0].
+					     virtual_address);
 			} else
-				beiscsi_log(phba, KERN_WARNING,
-					    BEISCSI_LOG_INIT,
-					    "BM", "No Virtual address for ULP : %d\n",
-					    ulp_num);
+				beiscsi_warn(phba, BEISCSI_LOG_INIT,
+					     "No Virtual address for ULP : %d\n",
+					     ulp_num);
 
 			pasync_ctx->async_header.handle_base =
 				mem_descr->mem_array[0].virtual_address;
@@ -3038,16 +3017,15 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 			mem_descr += HWI_MEM_ASYNC_DATA_RING_ULP0 +
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
-				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING_ULP%d va=%p\n",
-					    ulp_num,
-					    mem_descr->mem_array[0].
-					    virtual_address);
+				beiscsi_info(phba, BEISCSI_LOG_INIT,
+					     "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING_ULP%d va=%p\n",
+					     ulp_num,
+					     mem_descr->mem_array[0].
+					     virtual_address);
 			} else
-				beiscsi_log(phba, KERN_WARNING,
-					    BEISCSI_LOG_INIT,
-					    "BM", "No Virtual address for ULP : %d\n",
-					    ulp_num);
+				beiscsi_warn(phba, BEISCSI_LOG_INIT,
+					     "No Virtual address for ULP : %d\n",
+					     ulp_num);
 
 			pasync_ctx->async_data.ring_base =
 				mem_descr->mem_array[0].virtual_address;
@@ -3056,10 +3034,9 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 			mem_descr += HWI_MEM_ASYNC_DATA_HANDLE_ULP0 +
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (!mem_descr->mem_array[0].virtual_address)
-				beiscsi_log(phba, KERN_WARNING,
-					    BEISCSI_LOG_INIT,
-					    "BM", "No Virtual address for ULP : %d\n",
-					    ulp_num);
+				beiscsi_warn(phba, BEISCSI_LOG_INIT,
+					     "No Virtual address for ULP : %d\n",
+					     ulp_num);
 
 			pasync_ctx->async_data.handle_base =
 				mem_descr->mem_array[0].virtual_address;
@@ -3077,16 +3054,15 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 			mem_descr += HWI_MEM_ASYNC_DATA_BUF_ULP0 +
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
-				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF_ULP%d va=%p\n",
-					    ulp_num,
-					    mem_descr->mem_array[0].
-					    virtual_address);
+				beiscsi_info(phba, BEISCSI_LOG_INIT,
+					     "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF_ULP%d va=%p\n",
+					     ulp_num,
+					     mem_descr->mem_array[0].
+					     virtual_address);
 			} else
-				beiscsi_log(phba, KERN_WARNING,
-					    BEISCSI_LOG_INIT,
-					    "BM", "No Virtual address for ULP : %d\n",
-					    ulp_num);
+				beiscsi_warn(phba, BEISCSI_LOG_INIT,
+					     "No Virtual address for ULP : %d\n",
+					     ulp_num);
 
 			idx = 0;
 			pasync_ctx->async_data.va_base =
@@ -3272,8 +3248,8 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 		ret = be_fill_queue(eq, phba->params.num_eq_entries,
 				    sizeof(struct be_eq_entry), eq_vaddress);
 		if (ret) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "be_fill_queue Failed for EQ\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "be_fill_queue Failed for EQ\n");
 			goto create_eq_error;
 		}
 
@@ -3281,14 +3257,14 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 		ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
 					    phwi_context->cur_eqd);
 		if (ret) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "beiscsi_cmd_eq_create Failed for EQ\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "beiscsi_cmd_eq_create Failed for EQ\n");
 			goto create_eq_error;
 		}
 
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM", "eqid = %d\n",
-			    phwi_context->be_eq[i].q.id);
+		beiscsi_info(phba, BEISCSI_LOG_INIT,
+			     "eqid = %d\n",
+			     phwi_context->be_eq[i].q.id);
 	}
 	return 0;
 
@@ -3336,8 +3312,8 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "be_fill_queue Failed for ISCSI CQ\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "be_fill_queue Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
 
@@ -3345,13 +3321,13 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 		ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false,
 					    false, 0);
 		if (ret) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "beiscsi_cmd_eq_create Failed for ISCSI CQ\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "beiscsi_cmd_eq_create Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM", "iscsi cq_id is %d for eq_id %d\n"
-			    "iSCSI CQ CREATED\n", cq->id, eq->id);
+		beiscsi_info(phba, BEISCSI_LOG_INIT,
+			     "iscsi cq_id is %d for eq_id %d\n"
+			     "iSCSI CQ CREATED\n", cq->id, eq->id);
 	}
 	return 0;
 
@@ -3393,8 +3369,8 @@ beiscsi_create_def_hdr(struct beiscsi_hba *phba,
 			    sizeof(struct phys_addr),
 			    sizeof(struct phys_addr), dq_vaddress);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "be_fill_queue Failed for DEF PDU HDR on ULP : %d\n",
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "be_fill_queue Failed for DEF PDU HDR on ULP : %d\n",
 			    ulp_num);
 
 		return ret;
@@ -3406,17 +3382,17 @@ beiscsi_create_def_hdr(struct beiscsi_hba *phba,
 					      phba->params.defpdu_hdr_sz,
 					      BEISCSI_DEFQ_HDR, ulp_num);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "be_cmd_create_default_pdu_queue Failed DEFHDR on ULP : %d\n",
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "be_cmd_create_default_pdu_queue Failed DEFHDR on ULP : %d\n",
 			    ulp_num);
 
 		return ret;
 	}
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "iscsi hdr def pdu id for ULP : %d is %d\n",
-		    ulp_num,
-		    phwi_context->be_def_hdrq[ulp_num].id);
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "iscsi hdr def pdu id for ULP : %d is %d\n",
+		     ulp_num,
+		     phwi_context->be_def_hdrq[ulp_num].id);
 	hwi_post_async_buffers(phba, BEISCSI_DEFQ_HDR, ulp_num);
 	return 0;
 }
@@ -3446,8 +3422,8 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 			    sizeof(struct phys_addr),
 			    sizeof(struct phys_addr), dq_vaddress);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "be_fill_queue Failed for DEF PDU DATA on ULP : %d\n",
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "be_fill_queue Failed for DEF PDU DATA on ULP : %d\n",
 			    ulp_num);
 
 		return ret;
@@ -3459,21 +3435,21 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 					      phba->params.defpdu_data_sz,
 					      BEISCSI_DEFQ_DATA, ulp_num);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "be_cmd_create_default_pdu_queue Failed for DEF PDU DATA on ULP : %d\n",
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "be_cmd_create_default_pdu_queue Failed for DEF PDU DATA on ULP : %d\n",
 			    ulp_num);
 		return ret;
 	}
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "iscsi def data id on ULP : %d is  %d\n",
-		    ulp_num,
-		    phwi_context->be_def_dataq[ulp_num].id);
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "iscsi def data id on ULP : %d is  %d\n",
+		     ulp_num,
+		     phwi_context->be_def_dataq[ulp_num].id);
 
 	hwi_post_async_buffers(phba, BEISCSI_DEFQ_DATA, ulp_num);
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "DEFAULT PDU DATA RING CREATED on ULP : %d\n",
-		    ulp_num);
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "DEFAULT PDU DATA RING CREATED on ULP : %d\n",
+		     ulp_num);
 
 	return 0;
 }
@@ -3499,15 +3475,15 @@ beiscsi_post_template_hdr(struct beiscsi_hba *phba)
 				 &phba->ctrl, &sgl);
 
 			if (status != 0) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM", "Post Template HDR Failed for ULP_%d\n",
+				beiscsi_err(phba, BEISCSI_LOG_INIT,
+					    "Post Template HDR Failed for ULP_%d\n",
 					    ulp_num);
 				return status;
 			}
 
-			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-				    "BM", "Template HDR Pages Posted for ULP_%d\n",
-				    ulp_num);
+			beiscsi_info(phba, BEISCSI_LOG_INIT,
+				     "Template HDR Pages Posted for ULP_%d\n",
+				     ulp_num);
 		}
 	}
 	return 0;
@@ -3539,14 +3515,14 @@ beiscsi_post_pages(struct beiscsi_hba *phba)
 						(pm_arr->size / PAGE_SIZE));
 		page_offset += pm_arr->size / PAGE_SIZE;
 		if (status != 0) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "post sgl failed.\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "post sgl failed.\n");
 			return status;
 		}
 		pm_arr++;
 	}
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "POSTED PAGES\n");
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "POSTED PAGES\n");
 	return 0;
 }
 
@@ -3598,8 +3574,8 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 	pwrb_arr = kmalloc(sizeof(*pwrb_arr) * phba->params.cxns_per_ctrl,
 			   GFP_KERNEL);
 	if (!pwrb_arr) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Memory alloc failed in create wrb ring.\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Memory alloc failed in create wrb ring.\n");
 		return -ENOMEM;
 	}
 	wrb_vaddr = mem_descr->mem_array[idx].virtual_address;
@@ -3666,8 +3642,8 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 					    &phwi_ctrlr->wrb_context[i],
 					    ulp_base_num);
 		if (status != 0) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "wrbq create failed.\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "wrbq create failed.\n");
 			kfree(pwrb_arr);
 			return status;
 		}
@@ -3872,8 +3848,8 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 
 	status = beiscsi_create_eqs(phba, phwi_context);
 	if (status != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "EQ not created\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "EQ not created\n");
 		goto error;
 	}
 
@@ -3883,15 +3859,15 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 
 	status = mgmt_check_supported_fw(ctrl, phba);
 	if (status != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Unsupported fw version\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Unsupported fw version\n");
 		goto error;
 	}
 
 	status = beiscsi_create_cqs(phba, phwi_context);
 	if (status != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "CQ not created\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "CQ not created\n");
 		goto error;
 	}
 
@@ -3907,8 +3883,8 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 							def_pdu_ring_sz,
 							ulp_num);
 			if (status != 0) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM", "Default Header not created for ULP : %d\n",
+				beiscsi_err(phba, BEISCSI_LOG_INIT,
+					    "Default Header not created for ULP : %d\n",
 					    ulp_num);
 				goto error;
 			}
@@ -3918,8 +3894,8 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 							 def_pdu_ring_sz,
 							 ulp_num);
 			if (status != 0) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM", "Default Data not created for ULP : %d\n",
+				beiscsi_err(phba, BEISCSI_LOG_INIT,
+					    "Default Data not created for ULP : %d\n",
 					    ulp_num);
 				goto error;
 			}
@@ -3928,21 +3904,21 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 
 	status = beiscsi_post_pages(phba);
 	if (status != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Post SGL Pages Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Post SGL Pages Failed\n");
 		goto error;
 	}
 
 	status = beiscsi_post_template_hdr(phba);
 	if (status != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Template HDR Posting for CXN Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Template HDR Posting for CXN Failed\n");
 	}
 
 	status = beiscsi_create_wrb_rings(phba,	phwi_context, phwi_ctrlr);
 	if (status != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "WRB Rings not created\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "WRB Rings not created\n");
 		goto error;
 	}
 
@@ -3966,13 +3942,13 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 		}
 	}
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "hwi_init_port success\n");
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "hwi_init_port success\n");
 	return 0;
 
 error:
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-		    "BM", "hwi_init_port failed\n");
+	beiscsi_err(phba, BEISCSI_LOG_INIT,
+		    "hwi_init_port failed\n");
 	hwi_cleanup(phba);
 	return status;
 }
@@ -3985,12 +3961,12 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
 	if (1 == phba->init_mem[HWI_MEM_ADDN_CONTEXT].num_elements) {
 		phwi_ctrlr->phwi_ctxt = (struct hwi_context_memory *)phba->
 		    init_mem[HWI_MEM_ADDN_CONTEXT].mem_array[0].virtual_address;
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM", "phwi_ctrlr->phwi_ctxt=%p\n",
-			    phwi_ctrlr->phwi_ctxt);
+		beiscsi_info(phba, BEISCSI_LOG_INIT,
+			     "phwi_ctrlr->phwi_ctxt=%p\n",
+			     phwi_ctrlr->phwi_ctxt);
 	} else {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "HWI_MEM_ADDN_CONTEXT is more than one element.Failing to load\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "HWI_MEM_ADDN_CONTEXT is more than one element.Failing to load\n");
 		return -ENOMEM;
 	}
 
@@ -3999,14 +3975,14 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
 		return -ENOMEM;
 
 	if (hwi_init_async_pdu_ctx(phba)) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "hwi_init_async_pdu_ctx failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "hwi_init_async_pdu_ctx failed\n");
 		return -ENOMEM;
 	}
 
 	if (hwi_init_port(phba) != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "hwi_init_controller failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "hwi_init_controller failed\n");
 
 		return -ENOMEM;
 	}
@@ -4044,16 +4020,16 @@ static int beiscsi_init_controller(struct beiscsi_hba *phba)
 
 	ret = beiscsi_get_memory(phba);
 	if (ret < 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "beiscsi_dev_probe -Failed in beiscsi_alloc_memory\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "beiscsi_dev_probe -Failed in beiscsi_alloc_memory\n");
 		return ret;
 	}
 
 	ret = hwi_init_controller(phba);
 	if (ret)
 		goto free_init;
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "Return success from beiscsi_init_controller\n");
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "Return success from beiscsi_init_controller\n");
 
 	return 0;
 
@@ -4080,8 +4056,8 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 						 phba->params.ios_per_ctrl,
 						 GFP_KERNEL);
 		if (!phba->io_sgl_hndl_base) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "Mem Alloc Failed. Failing to load\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "Mem Alloc Failed. Failing to load\n");
 			return -ENOMEM;
 		}
 		phba->eh_sgl_hndl_base = kzalloc(sizeof(struct sgl_handle *) *
@@ -4090,13 +4066,13 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 						 GFP_KERNEL);
 		if (!phba->eh_sgl_hndl_base) {
 			kfree(phba->io_sgl_hndl_base);
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM", "Mem Alloc Failed. Failing to load\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "Mem Alloc Failed. Failing to load\n");
 			return -ENOMEM;
 		}
 	} else {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "HWI_MEM_SGLH is more than one element. Failing to load\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "HWI_MEM_SGLH is more than one element. Failing to load\n");
 		return -ENOMEM;
 	}
 
@@ -4122,16 +4098,16 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		}
 		idx++;
 	}
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "phba->io_sgl_hndl_avbl=%d phba->eh_sgl_hndl_avbl=%d\n",
-		    phba->io_sgl_hndl_avbl,
-		    phba->eh_sgl_hndl_avbl);
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "phba->io_sgl_hndl_avbl=%d phba->eh_sgl_hndl_avbl=%d\n",
+		     phba->io_sgl_hndl_avbl,
+		     phba->eh_sgl_hndl_avbl);
 
 	mem_descr_sg = phba->init_mem;
 	mem_descr_sg += HWI_MEM_SGE;
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "mem_descr_sg->num_elements=%d\n",
-		    mem_descr_sg->num_elements);
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "mem_descr_sg->num_elements=%d\n",
+		     mem_descr_sg->num_elements);
 
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
 		if (test_bit(ulp_num, &phba->fw_config.ulp_supported))
@@ -4180,8 +4156,8 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 					       GFP_KERNEL);
 
 			if (!ptr_cid_info) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM", "Failed to allocate memory for ULP_CID_INFO for ULP : %d\n",
+				beiscsi_err(phba, BEISCSI_LOG_INIT,
+					    "Failed to allocate memory for ULP_CID_INFO for ULP : %d\n",
 					    ulp_num);
 				ret = -ENOMEM;
 				goto free_memory;
@@ -4193,8 +4169,8 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 						  BEISCSI_GET_CID_COUNT(phba,
 						  ulp_num), GFP_KERNEL);
 			if (!ptr_cid_info->cid_array) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM", "Failed to allocate memory for CID_ARRAY for ULP : %d\n",
+				beiscsi_err(phba, BEISCSI_LOG_INIT,
+					    "Failed to allocate memory for CID_ARRAY for ULP : %d\n",
 					    ulp_num);
 				kfree(ptr_cid_info);
 				ptr_cid_info = NULL;
@@ -4212,8 +4188,8 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 	phba->ep_array = kzalloc(sizeof(struct iscsi_endpoint *) *
 				 phba->params.cxns_per_ctrl, GFP_KERNEL);
 	if (!phba->ep_array) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Failed to allocate memory in hba_setup_cid_tbls\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Failed to allocate memory in hba_setup_cid_tbls\n");
 		ret = -ENOMEM;
 
 		goto free_memory;
@@ -4222,8 +4198,8 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 	phba->conn_table = kzalloc(sizeof(struct beiscsi_conn *) *
 				   phba->params.cxns_per_ctrl, GFP_KERNEL);
 	if (!phba->conn_table) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Failed to allocate memory in hba_setup_cid_tbls\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Failed to allocate memory in hba_setup_cid_tbls\n");
 
 		kfree(phba->ep_array);
 		phba->ep_array = NULL;
@@ -4287,22 +4263,22 @@ static void hwi_enable_intr(struct beiscsi_hba *phba)
 	enabled = reg & MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
 	if (!enabled) {
 		reg |= MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM", "reg =x%08x addr=%p\n", reg, addr);
+		beiscsi_info(phba, BEISCSI_LOG_INIT,
+			     "reg =x%08x addr=%p\n", reg, addr);
 		iowrite32(reg, addr);
 	}
 
 	if (!phba->msix_enabled) {
 		eq = &phwi_context->be_eq[0].q;
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM", "eq->id=%d\n", eq->id);
+		beiscsi_info(phba, BEISCSI_LOG_INIT,
+			     "eq->id=%d\n", eq->id);
 
 		hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
 	} else {
 		for (i = 0; i <= phba->num_cpus; i++) {
 			eq = &phwi_context->be_eq[i].q;
-			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-				    "BM", "eq->id=%d\n", eq->id);
+			beiscsi_info(phba, BEISCSI_LOG_INIT,
+				     "eq->id=%d\n", eq->id);
 			hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
 		}
 	}
@@ -4320,8 +4296,8 @@ static void hwi_disable_intr(struct beiscsi_hba *phba)
 		reg &= ~MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
 		iowrite32(reg, addr);
 	} else
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM", "In hwi_disable_intr, Already Disabled\n");
+		beiscsi_warn(phba, BEISCSI_LOG_INIT,
+			     "In hwi_disable_intr, Already Disabled\n");
 }
 
 /**
@@ -4345,9 +4321,8 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	/* Get the session handle of the boot target */
 	ret = be_mgmt_get_boot_shandle(phba, &s_handle);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM", "No boot session\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+			    "No boot session\n");
 
 		if (ret == -ENXIO)
 			phba->get_boot = 0;
@@ -4360,9 +4335,8 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 					      sizeof(*session_resp),
 					      &nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM", "Failed to allocate memory for beiscsi_get_session_info\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+			    "Failed to allocate memory for beiscsi_get_session_info\n");
 
 		return -ENOMEM;
 	}
@@ -4370,18 +4344,16 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	tag = mgmt_get_session_info(phba, s_handle,
 				    &nonemb_cmd);
 	if (!tag) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM", "beiscsi_get_session_info Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+			    "beiscsi_get_session_info Failed\n");
 
 		goto boot_freemem;
 	}
 
 	ret = beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM", "beiscsi_get_session_info Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+			    "beiscsi_get_session_info Failed\n");
 
 		if (ret != -EBUSY)
 			goto boot_freemem;
@@ -4471,20 +4443,20 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 
 	ret = beiscsi_init_controller(phba);
 	if (ret < 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "beiscsi_dev_probe - Failed in beiscsi_init_controller\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "beiscsi_dev_probe - Failed in beiscsi_init_controller\n");
 		return ret;
 	}
 	ret = beiscsi_init_sgl_handle(phba);
 	if (ret < 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "beiscsi_dev_probe - Failed in beiscsi_init_sgl_handle\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "beiscsi_dev_probe - Failed in beiscsi_init_sgl_handle\n");
 		goto do_cleanup_ctrlr;
 	}
 
 	if (hba_setup_cid_tbls(phba)) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Failed in hba_setup_cid_tbls\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Failed in hba_setup_cid_tbls\n");
 		kfree(phba->io_sgl_hndl_base);
 		kfree(phba->eh_sgl_hndl_base);
 		goto do_cleanup_ctrlr;
@@ -4539,10 +4511,9 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 		if (test_bit(ulp_num, (void *)&phba->fw_config.ulp_supported)) {
 			mgmt_status = mgmt_epfw_cleanup(phba, ulp_num);
 			if (mgmt_status)
-				beiscsi_log(phba, KERN_WARNING,
-					    BEISCSI_LOG_INIT,
-					    "BM", "mgmt_epfw_cleanup FAILED for ULP_%d\n",
-					    ulp_num);
+				beiscsi_warn(phba, BEISCSI_LOG_INIT,
+					     "mgmt_epfw_cleanup FAILED for ULP_%d\n",
+					     ulp_num);
 		}
 	}
 
@@ -4711,11 +4682,10 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	 */
 	beiscsi_put_wrb_handle(pwrb_context, pwrb_handle,
 			       phba->params.wrbs_per_cxn);
-	beiscsi_log(phba, KERN_INFO,
-		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-		    "BM", "put CONTEXT_UPDATE pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
-		    pwrb_handle, pwrb_context->free_index,
-		    pwrb_context->wrb_handles_available);
+	beiscsi_info(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+		     "put CONTEXT_UPDATE pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
+		     pwrb_handle, pwrb_context->free_index,
+		     pwrb_context->wrb_handles_available);
 }
 
 static void beiscsi_parse_pdu(struct iscsi_conn *conn, itt_t itt,
@@ -4765,9 +4735,8 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	if (task->sc) {
 		io_task->psgl_handle = alloc_io_sgl_handle(phba);
 		if (!io_task->psgl_handle) {
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM", "Alloc of IO_SGL_ICD Failed for the CID : %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				    "Alloc of IO_SGL_ICD Failed for the CID : %d\n",
 				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_hndls;
 		}
@@ -4775,9 +4744,8 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					beiscsi_conn->beiscsi_conn_cid,
 					&io_task->pwrb_context);
 		if (!io_task->pwrb_handle) {
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM", "Alloc of WRB_HANDLE Failed for the CID : %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				    "Alloc of WRB_HANDLE Failed for the CID : %d\n",
 				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_io_hndls;
 		}
@@ -4789,10 +4757,10 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				io_task->psgl_handle = (struct sgl_handle *)
 						alloc_mgmt_sgl_handle(phba);
 				if (!io_task->psgl_handle) {
-					beiscsi_log(phba, KERN_ERR,
+					beiscsi_err(phba,
 						    BEISCSI_LOG_IO |
 						    BEISCSI_LOG_CONFIG,
-						    "BM", "Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
+						    "Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
 						    beiscsi_conn->
 						    beiscsi_conn_cid);
 					goto free_hndls;
@@ -4806,10 +4774,10 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					beiscsi_conn->beiscsi_conn_cid,
 					&io_task->pwrb_context);
 				if (!io_task->pwrb_handle) {
-					beiscsi_log(phba, KERN_ERR,
+					beiscsi_err(phba,
 						    BEISCSI_LOG_IO |
 						    BEISCSI_LOG_CONFIG,
-						    "BM", "Alloc of WRB_HANDLE Failed for the CID : %d\n",
+						    "Alloc of WRB_HANDLE Failed for the CID : %d\n",
 						    beiscsi_conn->
 						    beiscsi_conn_cid);
 					goto free_mgmt_hndls;
@@ -4826,12 +4794,10 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		} else {
 			io_task->psgl_handle = alloc_mgmt_sgl_handle(phba);
 			if (!io_task->psgl_handle) {
-				beiscsi_log(phba, KERN_ERR,
-					    BEISCSI_LOG_IO |
-					    BEISCSI_LOG_CONFIG,
-					    "BM", "Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
-					    beiscsi_conn->
-					    beiscsi_conn_cid);
+				beiscsi_err(phba,
+					    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+					    "Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
+					    beiscsi_conn->beiscsi_conn_cid);
 				goto free_hndls;
 			}
 			io_task->pwrb_handle =
@@ -4839,9 +4805,9 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					beiscsi_conn->beiscsi_conn_cid,
 					&io_task->pwrb_context);
 			if (!io_task->pwrb_handle) {
-				beiscsi_log(phba, KERN_ERR,
+				beiscsi_err(phba,
 					    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-					    "BM", "Alloc of WRB_HANDLE Failed for the CID : %d\n",
+					    "Alloc of WRB_HANDLE Failed for the CID : %d\n",
 					    beiscsi_conn->beiscsi_conn_cid);
 				goto free_mgmt_hndls;
 			}
@@ -5092,8 +5058,8 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		break;
 
 	default:
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BM", "opcode =%d Not supported\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "opcode =%d Not supported\n",
 			    task->hdr->opcode & ISCSI_OPCODE_MASK);
 
 		return -EINVAL;
@@ -5135,9 +5101,8 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	num_sg = scsi_dma_map(sc);
 	phba = io_task->conn->phba;
 	if (num_sg < 0) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_IO | BEISCSI_LOG_ISCSI,
-			    "BM", "scsi_dma_map Failed Driver_ITT : 0x%x ITT : 0x%x Xferlen : 0x%x\n",
+		beiscsi_err(phba, BEISCSI_LOG_IO | BEISCSI_LOG_ISCSI,
+			    "scsi_dma_map Failed Driver_ITT : 0x%x ITT : 0x%x Xferlen : 0x%x\n",
 			    be32_to_cpu(io_task->cmd_bhs->iscsi_hdr.itt),
 			    io_task->libiscsi_itt, scsi_bufflen(sc));
 
@@ -5178,15 +5143,15 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 					job->request_payload.payload_len,
 					&nonemb_cmd.dma);
 		if (nonemb_cmd.va == NULL) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM", "Failed to allocate memory for beiscsi_bsg_request\n");
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+				    "Failed to allocate memory for beiscsi_bsg_request\n");
 			return -ENOMEM;
 		}
 		tag = mgmt_vendor_specific_fw_cmd(&phba->ctrl, phba, job,
 						  &nonemb_cmd);
 		if (!tag) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM", "MBX Tag Allocation Failed\n");
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+				    "MBX Tag Allocation Failed\n");
 
 			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 					    nonemb_cmd.va, nonemb_cmd.dma);
@@ -5214,8 +5179,8 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		if (status || extd_status) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM", "MBX Cmd Failed status = %d extd_status = %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+				    "MBX Cmd Failed status = %d extd_status = %d\n",
 				    status, extd_status);
 
 			return -EIO;
@@ -5225,9 +5190,9 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 		break;
 
 	default:
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				"BM", "Unsupported bsg command: 0x%x\n",
-				bsg_req->msgcode);
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Unsupported bsg command: 0x%x\n",
+			    bsg_req->msgcode);
 		break;
 	}
 
@@ -5383,8 +5348,8 @@ static void be_eqd_update(struct beiscsi_hba *phba)
 static void be_check_boot_session(struct beiscsi_hba *phba)
 {
 	if (beiscsi_setup_boot_info(phba))
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Could not set up iSCSI boot info on async event.\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Could not set up iSCSI boot info on async event.\n");
 }
 
 /*
@@ -5428,14 +5393,14 @@ static pci_ers_result_t beiscsi_eeh_err_detected(struct pci_dev *pdev,
 	phba = (struct beiscsi_hba *)pci_get_drvdata(pdev);
 	phba->state |= BE_ADAPTER_PCI_ERR;
 
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-		    "BM", "EEH error detected\n");
+	beiscsi_err(phba, BEISCSI_LOG_INIT,
+		    "EEH error detected\n");
 
 	beiscsi_quiesce(phba, BEISCSI_EEH_UNLOAD);
 
 	if (state == pci_channel_io_perm_failure) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "EEH : State PERM Failure\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "EEH : State PERM Failure\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -5460,8 +5425,8 @@ static pci_ers_result_t beiscsi_eeh_reset(struct pci_dev *pdev)
 
 	phba = (struct beiscsi_hba *)pci_get_drvdata(pdev);
 
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-		    "BM", "EEH Reset\n");
+	beiscsi_err(phba, BEISCSI_LOG_INIT,
+		    "EEH Reset\n");
 
 	status = pci_enable_device(pdev);
 	if (status)
@@ -5474,11 +5439,11 @@ static pci_ers_result_t beiscsi_eeh_reset(struct pci_dev *pdev)
 	/* Wait for the CHIP Reset to complete */
 	status = be_chk_reset_complete(phba);
 	if (!status) {
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM", "EEH Reset Completed\n");
+		beiscsi_warn(phba, BEISCSI_LOG_INIT,
+			     "EEH Reset Completed\n");
 	} else {
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM", "EEH Reset Completion Failure\n");
+		beiscsi_warn(phba, BEISCSI_LOG_INIT,
+			     "EEH Reset Completion Failure\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -5510,15 +5475,15 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 
 	ret = beiscsi_cmd_reset_function(phba);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Reset Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Reset Failed\n");
 		goto ret_err;
 	}
 
 	ret = be_chk_reset_complete(phba);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Failed to get out of reset.\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Failed to get out of reset.\n");
 		goto ret_err;
 	}
 
@@ -5527,8 +5492,8 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = hwi_init_controller(phba);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "beiscsi_eeh_resume - Failed to initialize beiscsi_hba.\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "beiscsi_eeh_resume - Failed to initialize beiscsi_hba.\n");
 		goto ret_err;
 	}
 
@@ -5555,8 +5520,8 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "beiscsi_eeh_resume - Failed to beiscsi_init_irqs\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "beiscsi_eeh_resume - Failed to beiscsi_init_irqs\n");
 		goto ret_err;
 	}
 
@@ -5565,8 +5530,8 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 
 	return;
 ret_err:
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-		    "BM", "AER EEH Resume Failed\n");
+	beiscsi_err(phba, BEISCSI_LOG_INIT,
+		    "AER EEH Resume Failed\n");
 }
 
 static int beiscsi_dev_probe(struct pci_dev *pcidev,
@@ -5596,8 +5561,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	/* Enable EEH reporting */
 	ret = pci_enable_pcie_error_reporting(pcidev);
 	if (ret)
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM", "PCIe Error Reporting Enabling Failed\n");
+		beiscsi_warn(phba, BEISCSI_LOG_INIT,
+			     "PCIe Error Reporting Enabling Failed\n");
 
 	pci_save_state(pcidev);
 
@@ -5630,8 +5595,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	ret = be_ctrl_init(phba, pcidev);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "beiscsi_dev_probe-Failed in be_ctrl_init\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "beiscsi_dev_probe-Failed in be_ctrl_init\n");
 		goto hba_free;
 	}
 
@@ -5640,14 +5605,14 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	 */
 	ret = beiscsi_cmd_reset_function(phba);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Reset Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Reset Failed\n");
 		goto hba_free;
 	}
 	ret = be_chk_reset_complete(phba);
 	if (ret) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Failed to get out of reset.\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Failed to get out of reset.\n");
 		goto hba_free;
 	}
 
@@ -5657,8 +5622,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	spin_lock_init(&phba->async_pdu_lock);
 	ret = mgmt_get_fw_config(&phba->ctrl, phba);
 	if (ret != 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Error getting fw config\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Error getting fw config\n");
 		goto free_port;
 	}
 	mgmt_get_port_name(&phba->ctrl, phba);
@@ -5669,9 +5634,9 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	else
 		phba->num_cpus = 1;
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "num_cpus = %d\n",
-		    phba->num_cpus);
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "num_cpus = %d\n",
+		     phba->num_cpus);
 
 	if (enable_msix) {
 		beiscsi_msix_enable(phba);
@@ -5683,8 +5648,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "beiscsi_dev_probe-Failed in beiscsi_init_port\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "beiscsi_dev_probe-Failed in beiscsi_init_port\n");
 		goto free_port;
 	}
 
@@ -5703,8 +5668,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		 phba->shost->host_no);
 	phba->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, phba->wq_name);
 	if (!phba->wq) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "beiscsi_dev_probe-Failed to allocate work queue\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "beiscsi_dev_probe-Failed to allocate work queue\n");
 		ret = -ENOMEM;
 		goto free_twq;
 	}
@@ -5728,8 +5693,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "beiscsi_dev_probe-Failed to beiscsi_init_irqs\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "beiscsi_dev_probe-Failed to beiscsi_init_irqs\n");
 		goto free_blkenbld;
 	}
 	hwi_enable_intr(phba);
@@ -5742,15 +5707,15 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		 * log error but continue, because we may not be using
 		 * iscsi boot.
 		 */
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM", "Could not set up iSCSI boot info.\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Could not set up iSCSI boot info.\n");
 
 	beiscsi_create_def_ifaces(phba);
 	schedule_delayed_work(&phba->beiscsi_hw_check_task,
 			      msecs_to_jiffies(1000));
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM", "SUCCESS - DRIVER LOADED\n");
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "SUCCESS - DRIVER LOADED\n");
 	return 0;
 
 free_blkenbld:
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index aa9c682..7cce6e3 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1081,15 +1081,19 @@ struct hwi_context_memory {
 #define BEISCSI_LOG_CONFIG	0x0020	/* CONFIG Code Path */
 #define BEISCSI_LOG_ISCSI	0x0040	/* SCSI/iSCSI Protocol related Logs */
 
-#define __beiscsi_log(phba, level, fmt, ...)				\
-	shost_printk(level, phba->shost, fmt, ##__VA_ARGS__)
-
-#define beiscsi_log(phba, level, mask, prefix, fmt, ...)		\
+#define beiscsi_printk(level, phba, mask, fmt, ...)			\
 do {									\
-	uint32_t log_value = phba->attr_log_enable;			\
-	if (((mask) & log_value) || (level[1] <= '3'))			\
-		__beiscsi_log(phba, level, prefix "_%d: " fmt,		\
-			      __LINE__, ##__VA_ARGS__);			\
+	if ((mask) & (phba)->attr_log_enable)				\
+		shost_printk(level, phba->shost,			\
+			     "%s_" __stringify(__LINE__) ": " fmt,	\
+			     kbasename(__FILE__), ##__VA_ARGS__);	\
 } while (0)
 
+#define beiscsi_err(phba, mask, fmt, ...)				\
+	beiscsi_printk(KERN_ERR, phba, mask, fmt, ##__VA_ARGS__)
+#define beiscsi_warn(phba, mask, fmt, ...)				\
+	beiscsi_printk(KERN_WARNING, phba, mask, fmt, ##__VA_ARGS__)
+#define beiscsi_info(phba, mask, fmt, ...)				\
+	beiscsi_printk(KERN_INFO, phba, mask, fmt, ##__VA_ARGS__)
+
 #endif
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 44b69ef..3b23c41 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -129,17 +129,15 @@ void beiscsi_ue_detect(struct beiscsi_hba *phba)
 
 	if (ue_lo || ue_hi) {
 		phba->ue_detected = true;
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BG", "Error detected on the adapter\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			    "Error detected on the adapter\n");
 	}
 
 	if (ue_lo) {
 		for (i = 0; ue_lo; ue_lo >>= 1, i++) {
 			if (ue_lo & 1)
-				beiscsi_log(phba, KERN_ERR,
-					    BEISCSI_LOG_CONFIG,
-					    "BG", "UE_LOW %s bit set\n",
+				beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+					    "UE_LOW %s bit set\n",
 					    desc_ue_status_low[i]);
 		}
 	}
@@ -147,9 +145,8 @@ void beiscsi_ue_detect(struct beiscsi_hba *phba)
 	if (ue_hi) {
 		for (i = 0; ue_hi; ue_hi >>= 1, i++) {
 			if (ue_hi & 1)
-				beiscsi_log(phba, KERN_ERR,
-					    BEISCSI_LOG_CONFIG,
-					    "BG", "UE_HIGH %s bit set\n",
+				beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+					    "UE_HIGH %s bit set\n",
 					    desc_ue_status_hi[i]);
 		}
 	}
@@ -208,9 +205,8 @@ unsigned int mgmt_reopen_session(struct beiscsi_hba *phba,
 	struct be_cmd_reopen_session_req *req;
 	unsigned int tag;
 
-	beiscsi_log(phba, KERN_INFO,
-		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BG", "In bescsi_get_boot_target\n");
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		     "In bescsi_get_boot_target\n");
 
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = alloc_mcc_wrb(phba, &tag);
@@ -241,9 +237,8 @@ unsigned int mgmt_get_boot_target(struct beiscsi_hba *phba)
 	struct be_cmd_get_boot_target_req *req;
 	unsigned int tag;
 
-	beiscsi_log(phba, KERN_INFO,
-		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BG", "In bescsi_get_boot_target\n");
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		     "In bescsi_get_boot_target\n");
 
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = alloc_mcc_wrb(phba, &tag);
@@ -274,9 +269,8 @@ unsigned int mgmt_get_session_info(struct beiscsi_hba *phba,
 	struct be_cmd_get_session_resp *resp;
 	struct be_sge *sge;
 
-	beiscsi_log(phba, KERN_INFO,
-		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BG", "In beiscsi_get_session_info\n");
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		     "In beiscsi_get_session_info\n");
 
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = alloc_mcc_wrb(phba, &tag);
@@ -333,9 +327,9 @@ int mgmt_get_port_name(struct be_ctrl_info *ctrl,
 		phba->port_name = ioctl->p.resp.port_names >>
 				  (phba->fw_config.phys_port * 8) & 0xff;
 	} else {
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BG", "GET_PORT_NAME ret 0x%x status 0x%x\n",
-			    ret, ioctl->h.resp_hdr.status);
+		beiscsi_info(phba, BEISCSI_LOG_INIT,
+			     "GET_PORT_NAME ret 0x%x status 0x%x\n",
+			     ret, ioctl->h.resp_hdr.status);
 	}
 
 	if (phba->port_name == 0)
@@ -375,16 +369,16 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 			   EMBED_MBX_MAX_PAYLOAD_SIZE);
 
 	if (be_mbox_notify(ctrl)) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG", "Failed in mgmt_get_fw_config\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Failed in mgmt_get_fw_config\n");
 		goto fail_init;
 	}
 
 	/* FW response formats depend on port id */
 	phba->fw_config.phys_port = pfw_cfg->phys_port;
 	if (phba->fw_config.phys_port >= BEISCSI_PHYS_PORT_MAX) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG", "invalid physical port id %d\n",
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "invalid physical port id %d\n",
 			    phba->fw_config.phys_port);
 		goto fail_init;
 	}
@@ -395,22 +389,22 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 		phba->fw_config.cqid_count = pfw_cfg->cqid_count;
 		if (phba->fw_config.eqid_count == 0 ||
 		    phba->fw_config.eqid_count > 2048) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BG", "invalid EQ count %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "invalid EQ count %d\n",
 				    phba->fw_config.eqid_count);
 			goto fail_init;
 		}
 		if (phba->fw_config.cqid_count == 0 ||
 		    phba->fw_config.cqid_count > 4096) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BG", "invalid CQ count %d\n",
+			beiscsi_err(phba, BEISCSI_LOG_INIT,
+				    "invalid CQ count %d\n",
 				    phba->fw_config.cqid_count);
 			goto fail_init;
 		}
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BG", "EQ_Count : %d CQ_Count : %d\n",
-			    phba->fw_config.eqid_count,
-			    phba->fw_config.cqid_count);
+		beiscsi_info(phba, BEISCSI_LOG_INIT,
+			     "EQ_Count : %d CQ_Count : %d\n",
+			     phba->fw_config.eqid_count,
+			     phba->fw_config.cqid_count);
 	}
 
 	/**
@@ -440,27 +434,27 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 			phba->fw_config.iscsi_chain_count[ulp_num] =
 				pfw_cfg->chain_icd[ulp_num].chain_count;
 
-			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-				    "BG", "Function loaded on ULP : %d\n"
-				    "\tiscsi_cid_count : %d\n"
-				    "\tiscsi_cid_start : %d\n"
-				    "\t iscsi_icd_count : %d\n"
-				    "\t iscsi_icd_start : %d\n",
-				    ulp_num,
-				    phba->fw_config.
-				    iscsi_cid_count[ulp_num],
-				    phba->fw_config.
-				    iscsi_cid_start[ulp_num],
-				    phba->fw_config.
-				    iscsi_icd_count[ulp_num],
-				    phba->fw_config.
-				    iscsi_icd_start[ulp_num]);
+			beiscsi_info(phba, BEISCSI_LOG_INIT,
+				     "Function loaded on ULP : %d\n"
+				     "\tiscsi_cid_count : %d\n"
+				     "\tiscsi_cid_start : %d\n"
+				     "\t iscsi_icd_count : %d\n"
+				     "\t iscsi_icd_start : %d\n",
+				     ulp_num,
+				     phba->fw_config.
+				     iscsi_cid_count[ulp_num],
+				     phba->fw_config.
+				     iscsi_cid_start[ulp_num],
+				     phba->fw_config.
+				     iscsi_icd_count[ulp_num],
+				     phba->fw_config.
+				     iscsi_icd_start[ulp_num]);
 		}
 	}
 
 	if (phba->fw_config.ulp_supported == 0) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG", "iSCSI initiator mode not set: ULP0 %x ULP1 %x\n",
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "iSCSI initiator mode not set: ULP0 %x ULP1 %x\n",
 			    pfw_cfg->ulp[BEISCSI_ULP0].ulp_mode,
 			    pfw_cfg->ulp[BEISCSI_ULP1].ulp_mode);
 		goto fail_init;
@@ -474,16 +468,16 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 			break;
 	icd_count = phba->fw_config.iscsi_icd_count[ulp_num];
 	if (icd_count == 0 || icd_count > 65536) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG", "invalid ICD count %d\n", icd_count);
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "invalid ICD count %d\n", icd_count);
 		goto fail_init;
 	}
 
 	cid_count = BEISCSI_GET_CID_COUNT(phba, BEISCSI_ULP0) +
 		    BEISCSI_GET_CID_COUNT(phba, BEISCSI_ULP1);
 	if (cid_count == 0 || cid_count > 4096) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG", "invalid CID count %d\n", cid_count);
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "invalid CID count %d\n", cid_count);
 		goto fail_init;
 	}
 
@@ -494,9 +488,9 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 	phba->fw_config.dual_ulp_aware = (pfw_cfg->function_mode &
 					  BEISCSI_FUNC_DUA_MODE);
 
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BG", "DUA Mode : 0x%x\n",
-		    phba->fw_config.dual_ulp_aware);
+	beiscsi_info(phba, BEISCSI_LOG_INIT,
+		     "DUA Mode : 0x%x\n",
+		     phba->fw_config.dual_ulp_aware);
 
 	/* all set, continue using this FW config */
 	status = 0;
@@ -518,8 +512,8 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				sizeof(struct be_mgmt_controller_attributes),
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG", "Failed to allocate memory for mgmt_check_supported_fw\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    "Failed to allocate memory for mgmt_check_supported_fw\n");
 		return -ENOMEM;
 	}
 	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
@@ -536,25 +530,25 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 	status = be_mbox_notify(ctrl);
 	if (!status) {
 		struct be_mgmt_controller_attributes_resp *resp = nonemb_cmd.va;
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BG", "Firmware Version of CMD : %s\n"
-			    "Firmware Version is : %s\n"
-			    "Developer Build, not performing version check...\n",
-			    resp->params.hba_attribs
-			    .flashrom_version_string,
-			    resp->params.hba_attribs.
-			    firmware_version_string);
+		beiscsi_info(phba, BEISCSI_LOG_INIT,
+			     "Firmware Version of CMD : %s\n"
+			     "Firmware Version is : %s\n"
+			     "Developer Build, not performing version check...\n",
+			     resp->params.hba_attribs
+			     .flashrom_version_string,
+			     resp->params.hba_attribs.
+			     firmware_version_string);
 
 		phba->fw_config.iscsi_features =
 				resp->params.hba_attribs.iscsi_features;
-		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM", "phba->fw_config.iscsi_features = %d\n",
-			    phba->fw_config.iscsi_features);
+		beiscsi_info(phba, BEISCSI_LOG_INIT,
+			     "phba->fw_config.iscsi_features = %d\n",
+			     phba->fw_config.iscsi_features);
 		memcpy(phba->fw_ver_str, resp->params.hba_attribs.
 		       firmware_version_string, BEISCSI_VER_STRLEN);
 	} else
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG", " Failed in mgmt_check_supported_fw\n");
+		beiscsi_err(phba, BEISCSI_LOG_INIT,
+			    " Failed in mgmt_check_supported_fw\n");
 	mutex_unlock(&ctrl->mbox_lock);
 	if (nonemb_cmd.va)
 		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
@@ -603,9 +597,9 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 			   OPCODE_COMMON_READ_FLASH, sizeof(*req));
 		break;
 	default:
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG", "Unsupported cmd = 0x%x\n\n",
-			    bsg_req->rqst_data.h_vendor.vendor_cmd[0]);
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+			     "Unsupported cmd = 0x%x\n\n",
+			     bsg_req->rqst_data.h_vendor.vendor_cmd[0]);
 
 		mutex_unlock(&ctrl->mbox_lock);
 		return -ENOSYS;
@@ -666,8 +660,8 @@ int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short ulp_num)
 	be_mcc_notify(phba, tag);
 	status = be_mcc_compl_poll(phba, tag);
 	if (status)
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BG", "mgmt_epfw_cleanup , FAILED\n");
+		beiscsi_warn(phba, BEISCSI_LOG_INIT,
+			     "mgmt_epfw_cleanup , FAILED\n");
 	mutex_unlock(&ctrl->mbox_lock);
 	return status;
 }
@@ -809,8 +803,8 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	struct be_sge *sge;
 
 	if (dst_addr->sa_family != PF_INET && dst_addr->sa_family != PF_INET6) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BG", "unknown addr family %d\n",
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "unknown addr family %d\n",
 			    dst_addr->sa_family);
 		return -EINVAL;
 	}
@@ -868,8 +862,8 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	if (phba->nxt_cqid == phba->num_cpus)
 		phba->nxt_cqid = 0;
 	req->cq_id = phwi_context->be_cq[i].id;
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BG", "i=%d cq_id=%d\n", i, req->cq_id);
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG,
+		     "i=%d cq_id=%d\n", i, req->cq_id);
 	req->defq_id = def_hdr_id;
 	req->hdr_ring_id = def_hdr_id;
 	req->data_ring_id = def_data_id;
@@ -918,8 +912,8 @@ unsigned int mgmt_get_all_if_id(struct beiscsi_hba *phba)
 
 	status = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
 	if (status) {
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG", "Failed in mgmt_get_all_if_id\n");
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+			     "Failed in mgmt_get_all_if_id\n");
 		return -EBUSY;
 	}
 
@@ -974,9 +968,8 @@ static int mgmt_exec_nonemb_cmd(struct beiscsi_hba *phba,
 		if (rc == -EAGAIN)
 			return rc;
 
-		beiscsi_log(phba, KERN_WARNING,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BG", "mgmt_exec_nonemb_cmd Failed status\n");
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			     "mgmt_exec_nonemb_cmd Failed status\n");
 
 		if (rc != -EBUSY)
 			goto free_cmd;
@@ -994,8 +987,8 @@ static int mgmt_alloc_cmd_data(struct beiscsi_hba *phba, struct be_dma_mem *cmd,
 {
 	cmd->va = pci_zalloc_consistent(phba->ctrl.pdev, size, &cmd->dma);
 	if (!cmd->va) {
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BG", "Failed to allocate memory for if info\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG,
+			    "Failed to allocate memory for if info\n");
 		return -ENOMEM;
 	}
 	cmd->size = size;
@@ -1053,8 +1046,8 @@ mgmt_static_ip_modify(struct beiscsi_hba *phba,
 
 	rc = mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
 	if (rc < 0)
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG", "Failed to Modify existing IP Address\n");
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+			     "Failed to Modify existing IP Address\n");
 	return rc;
 }
 
@@ -1108,8 +1101,8 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 
 	if (boot_proto == ISCSI_BOOTPROTO_DHCP) {
 		if (if_info->dhcp_state) {
-			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-				    "BG", "DHCP Already Enabled\n");
+			beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+				     "DHCP Already Enabled\n");
 			goto exit;
 		}
 		/* The ip_param->len is 1 in DHCP case. Setting
@@ -1136,9 +1129,8 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 
 			rc = mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
 			if (rc < 0) {
-				beiscsi_log(phba, KERN_WARNING,
-					    BEISCSI_LOG_CONFIG,
-					    "BG", "Failed to Delete existing dhcp\n");
+				beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+					     "Failed to Delete existing dhcp\n");
 				goto exit;
 			}
 		}
@@ -1157,8 +1149,8 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 		memset(&gtway_addr_set, 0, sizeof(gtway_addr_set));
 		rc = mgmt_get_gateway(phba, BE2_IPV4, &gtway_addr_set);
 		if (rc) {
-			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-				    "BG", "Failed to Get Gateway Addr\n");
+			beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+				     "Failed to Get Gateway Addr\n");
 			goto exit;
 		}
 
@@ -1168,9 +1160,8 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 						 IP_ACTION_DEL, IP_V4_LEN);
 
 			if (rc) {
-				beiscsi_log(phba, KERN_WARNING,
-					    BEISCSI_LOG_CONFIG,
-					    "BG", "Failed to clear Gateway Addr Set\n");
+				beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+					     "Failed to clear Gateway Addr Set\n");
 				goto exit;
 			}
 		}
@@ -1211,8 +1202,8 @@ int mgmt_set_gateway(struct beiscsi_hba *phba,
 	memset(&gtway_addr_set, 0, sizeof(gtway_addr_set));
 	rt_val = mgmt_get_gateway(phba, BE2_IPV4, &gtway_addr_set);
 	if (rt_val) {
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG", "Failed to Get Gateway Addr\n");
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+			     "Failed to Get Gateway Addr\n");
 		return rt_val;
 	}
 
@@ -1221,8 +1212,8 @@ int mgmt_set_gateway(struct beiscsi_hba *phba,
 		rt_val = mgmt_modify_gateway(phba, gtway_addr, IP_ACTION_DEL,
 					     gateway_param->len);
 		if (rt_val) {
-			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-				    "BG", "Failed to clear Gateway Addr Set\n");
+			beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+				     "Failed to clear Gateway Addr Set\n");
 			return rt_val;
 		}
 	}
@@ -1232,8 +1223,8 @@ int mgmt_set_gateway(struct beiscsi_hba *phba,
 				     gateway_param->len);
 
 	if (rt_val)
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG", "Failed to Set Gateway Addr\n");
+		beiscsi_warn(phba, BEISCSI_LOG_CONFIG,
+			     "Failed to Set Gateway Addr\n");
 
 	return rt_val;
 }
@@ -1284,11 +1275,10 @@ int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
 		/* Allocate memory for if_info */
 		*if_info = kzalloc(ioctl_size, GFP_KERNEL);
 		if (!*if_info) {
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG", "Memory Allocation Failure\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+				    "Memory Allocation Failure\n");
 
-				/* Free the DMA memory for the IOCTL issuing */
+			/* Free the DMA memory for the IOCTL issuing */
 				pci_free_consistent(phba->ctrl.pdev,
 						    nonemb_cmd.size,
 						    nonemb_cmd.va,
@@ -1390,17 +1380,15 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 		/* Get the Boot Target Session Handle and Count*/
 		tag = mgmt_get_boot_target(phba);
 		if (!tag) {
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
-				    "BG", "Getting Boot Target Info Failed\n");
+			beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
+				    "Getting Boot Target Info Failed\n");
 			return -EAGAIN;
 		}
 
 		rc = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
 		if (rc) {
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG", "MBX CMD get_boot_target Failed\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+				    "MBX CMD get_boot_target Failed\n");
 			return -EBUSY;
 		}
 
@@ -1408,9 +1396,9 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 
 		/* Check if the there are any Boot targets configured */
 		if (!boot_resp->boot_session_count) {
-			beiscsi_log(phba, KERN_INFO,
-				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG", "No boot targets configured\n");
+			beiscsi_info(phba,
+				     BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+				     "No boot targets configured\n");
 			return -ENXIO;
 		}
 
@@ -1424,25 +1412,22 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 		tag = mgmt_reopen_session(phba, BE_REOPEN_BOOT_SESSIONS,
 					  INVALID_SESS_HANDLE);
 		if (!tag) {
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG", "mgmt_reopen_session Failed\n");
+			beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+				    "mgmt_reopen_session Failed\n");
 			return -EAGAIN;
 		}
 
 		rc = beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
 		if (rc) {
-			beiscsi_log(phba, KERN_ERR,
-				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG", "mgmt_reopen_session Failed");
+			beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+				    "mgmt_reopen_session Failed");
 			return rc;
 		}
 	} while (--boot_retry);
 
 	/* Couldn't log into the boot target */
-	beiscsi_log(phba, KERN_ERR,
-		    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-		    "BG", "Login to Boot Target Failed\n");
+	beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+		    "Login to Boot Target Failed\n");
 	return -ENXIO;
 }
 
@@ -1466,17 +1451,15 @@ int mgmt_set_vlan(struct beiscsi_hba *phba,
 
 	tag = be_cmd_set_vlan(phba, vlan_tag);
 	if (!tag) {
-		beiscsi_log(phba, KERN_ERR,
-			    (BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX),
-			    "BG", "VLAN Setting Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			    "VLAN Setting Failed\n");
 		return -EBUSY;
 	}
 
 	rc = beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
 	if (rc) {
-		beiscsi_log(phba, KERN_ERR,
-			    (BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX),
-			    "BS", "VLAN MBX Cmd Failed\n");
+		beiscsi_err(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			    "VLAN MBX Cmd Failed\n");
 		return rc;
 	}
 	return rc;
@@ -1811,17 +1794,15 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *phba,
 	unsigned int tag;
 	int rc;
 
-	beiscsi_log(phba, KERN_INFO,
-		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BG", "In bescsi_logout_fwboot_sess\n");
+	beiscsi_info(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+		     "In bescsi_logout_fwboot_sess\n");
 
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = alloc_mcc_wrb(phba, &tag);
 	if (!wrb) {
 		mutex_unlock(&ctrl->mbox_lock);
-		beiscsi_log(phba, KERN_INFO,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BG", "MBX Tag Failure\n");
+		beiscsi_info(phba, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
+			     "MBX Tag Failure\n");
 		return -EINVAL;
 	}
 
@@ -1838,18 +1819,17 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *phba,
 
 	rc = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
 	if (rc) {
-		beiscsi_log(phba, KERN_ERR,
+		beiscsi_err(phba,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BG", "MBX CMD FW_SESSION_LOGOUT_TARGET Failed\n");
+			    "MBX CMD FW_SESSION_LOGOUT_TARGET Failed\n");
 		return -EBUSY;
 	}
 
 	resp = embedded_payload(wrb);
 	if (resp->session_status !=
 		BEISCSI_MGMT_SESSION_CLOSE) {
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BG", "FW_SESSION_LOGOUT_TARGET resp : 0x%x\n",
+		beiscsi_err(phba, BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+			    "FW_SESSION_LOGOUT_TARGET resp : 0x%x\n",
 			    resp->session_status);
 		rc = -EINVAL;
 	}
-- 
2.8.0.rc4.16.g56331f8
