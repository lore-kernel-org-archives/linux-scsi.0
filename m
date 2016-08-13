From: Joe Perches <joe@perches.com>
Subject: [PATCH 2/2] be2iscsi: Use a standard logging style
Date: Sat, 13 Aug 2016 13:42:40 -0700
Message-ID: <46735559008daaf2dd913fbb1c4cef47c97b8a3e.1471119911.git.joe@perches.com>
References: <1471107782.3467.28.camel@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471107782.3467.28.camel@perches.com>
In-Reply-To: <cover.1471119911.git.joe@perches.com>
References: <cover.1471119911.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Neaten all the beiscsi_log uses.

Remove the leading 'B<type>_%d" prefixes and make the
format and arguments match without an implied __LINE__.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |  54 +++----
 drivers/scsi/be2iscsi/be_iscsi.c | 100 ++++++------
 drivers/scsi/be2iscsi/be_main.c  | 332 +++++++++++++++++++--------------------
 drivers/scsi/be2iscsi/be_main.h  |  19 +--
 drivers/scsi/be2iscsi/be_mgmt.c  |  98 ++++++------
 5 files changed, 300 insertions(+), 303 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index cefa342..a51bc0e 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -96,7 +96,7 @@ int be_chk_reset_complete(struct beiscsi_hba *phba)
 
 	if ((status & 0x80000000) || (!num_loop)) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BC_%d : Failed in be_chk_reset_complete status = 0x%x\n",
+			    "BC", "Failed in be_chk_reset_complete status = 0x%x\n",
 			    status);
 		return -EIO;
 	}
@@ -137,7 +137,7 @@ struct be_mcc_wrb *alloc_mcc_wrb(struct beiscsi_hba *phba,
 	if (mccq->used == mccq->len) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT |
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC_%d : MCC queue full: WRB used %u tag avail %u\n",
+			    "BC", "MCC queue full: WRB used %u tag avail %u\n",
 			    mccq->used, phba->ctrl.mcc_tag_available);
 		goto alloc_failed;
 	}
@@ -149,7 +149,7 @@ struct be_mcc_wrb *alloc_mcc_wrb(struct beiscsi_hba *phba,
 	if (!tag) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT |
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC_%d : MCC tag 0 allocated: tag avail %u alloc index %u\n",
+			    "BC", "MCC tag 0 allocated: tag avail %u alloc index %u\n",
 			    phba->ctrl.mcc_tag_available,
 			    phba->ctrl.mcc_alloc_index);
 		goto alloc_failed;
@@ -266,7 +266,7 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
 			    BEISCSI_LOG_CONFIG,
-			    "BC_%d : MBX Cmd Completion timed out\n");
+			    "BC", "MBX Cmd Completion timed out\n");
 		return -EBUSY;
 	}
 
@@ -292,7 +292,7 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 		beiscsi_log(phba, KERN_WARNING,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
 			    BEISCSI_LOG_CONFIG,
-			    "BC_%d : MBX Cmd Failed for Subsys : %d Opcode : %d with Status : %d and Extd_Status : %d\n",
+			    "BC", "MBX Cmd Failed for Subsys : %d Opcode : %d with Status : %d and Extd_Status : %d\n",
 			    mbx_hdr->subsystem,
 			    mbx_hdr->opcode,
 			    status, addl_status);
@@ -302,7 +302,7 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 			beiscsi_log(phba, KERN_WARNING,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
 				    BEISCSI_LOG_CONFIG,
-				    "BC_%d : Insufficient Buffer Error Resp_Len : %d Actual_Resp_Len : %d\n",
+				    "BC", "Insufficient Buffer Error Resp_Len : %d Actual_Resp_Len : %d\n",
 				    mbx_resp_hdr->response_length,
 				    mbx_resp_hdr->actual_resp_len);
 			rc = -EAGAIN;
@@ -341,7 +341,7 @@ static int beiscsi_process_mbox_compl(struct be_ctrl_info *ctrl,
 	if (!compl->flags) {
 		beiscsi_log(phba, KERN_ERR,
 				BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-				"BC_%d : BMBX busy, no completion\n");
+				"BC", "BMBX busy, no completion\n");
 		return -EBUSY;
 	}
 	compl->flags = le32_to_cpu(compl->flags);
@@ -363,7 +363,7 @@ static int beiscsi_process_mbox_compl(struct be_ctrl_info *ctrl,
 		return 0;
 
 	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BC_%d : error in cmd completion: Subsystem : %d Opcode : %d status(compl/extd)=%d/%d\n",
+		    "BC", "error in cmd completion: Subsystem : %d Opcode : %d status(compl/extd)=%d/%d\n",
 		    hdr->subsystem, hdr->opcode, compl_status, extd_status);
 
 	if (compl_status == MCC_STATUS_INSUFFICIENT_BUFFER) {
@@ -391,13 +391,13 @@ static void beiscsi_process_async_link(struct beiscsi_hba *phba,
 		phba->state = BE_ADAPTER_LINK_UP | BE_ADAPTER_CHECK_BOOT;
 		phba->get_boot = BE_GET_BOOT_RETRIES;
 		__beiscsi_log(phba, KERN_ERR,
-			      "BC_%d : Link Up on Port %d tag 0x%x\n",
-			      evt->physical_port, evt->event_tag);
+			      "BC%d: Link Up on Port %d tag 0x%x\n",
+			      __LINE__, evt->physical_port, evt->event_tag);
 	} else {
 		phba->state = BE_ADAPTER_LINK_DOWN;
 		__beiscsi_log(phba, KERN_ERR,
-			      "BC_%d : Link Down on Port %d tag 0x%x\n",
-			      evt->physical_port, evt->event_tag);
+			      "BC%d: Link Down on Port %d tag 0x%x\n",
+			      __LINE__, evt->physical_port, evt->event_tag);
 		iscsi_host_for_each_session(phba->shost,
 					    beiscsi_fail_session);
 	}
@@ -439,8 +439,8 @@ static void beiscsi_process_async_sli(struct beiscsi_hba *phba,
 	if (state >= ARRAY_SIZE(beiscsi_port_misconf_event_msg)) {
 		/* fw is reporting a state we don't know, log and return */
 		__beiscsi_log(phba, KERN_ERR,
-			    "BC_%d : Port %c: Unrecognized optic state 0x%x\n",
-			    phba->port_name, async_sli->event_data1);
+			      "BC%d: Port %c: Unrecognized optic state 0x%x\n",
+			      __LINE__, phba->port_name, async_sli->event_data1);
 		return;
 	}
 
@@ -459,8 +459,8 @@ static void beiscsi_process_async_sli(struct beiscsi_hba *phba,
 	}
 
 	if (old_state != phba->optic_state)
-		__beiscsi_log(phba, sev, "BC_%d : Port %c: %s%s\n",
-			      phba->port_name,
+		__beiscsi_log(phba, sev, "BC%d: Port %c: %s%s\n",
+			      __LINE__, phba->port_name,
 			      beiscsi_port_misconf_event_msg[state],
 			      !msg ? "" : msg);
 }
@@ -492,7 +492,7 @@ void beiscsi_process_async_event(struct beiscsi_hba *phba,
 	}
 
 	beiscsi_log(phba, sev, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BC_%d : ASYNC Event %x: status 0x%08x flags 0x%08x\n",
+		    "BC", "ASYNC Event %x: status 0x%08x flags 0x%08x\n",
 		    evt_code, compl->status, compl->flags);
 }
 
@@ -512,7 +512,7 @@ int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
 		      &ctrl->ptag_state[tag].tag_state)) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_MBOX |
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BC_%d : MBX cmd completed but not posted\n");
+			    "BC", "MBX cmd completed but not posted\n");
 		return 0;
 	}
 
@@ -520,7 +520,7 @@ int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
 		beiscsi_log(phba, KERN_WARNING,
 			    BEISCSI_LOG_MBOX | BEISCSI_LOG_INIT |
 			    BEISCSI_LOG_CONFIG,
-			    "BC_%d : MBX Completion for timeout Command from FW\n");
+			    "BC", "MBX Completion for timeout Command from FW\n");
 		/**
 		 * Check for the size before freeing resource.
 		 * Only for non-embedded cmd, PCI resource is allocated.
@@ -573,7 +573,7 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 		      &ctrl->ptag_state[tag].tag_state)) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BC_%d: tag %u state not running\n", tag);
+			    "BC", "tag %u state not running\n", tag);
 		return 0;
 	}
 	for (i = 0; i < mcc_timeout; i++) {
@@ -594,7 +594,7 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 		return 0;
 
 	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BC_%d : FW Timed Out\n");
+		    "BC", "FW Timed Out\n");
 	phba->fw_timeout = true;
 	beiscsi_ue_detect(phba);
 	return -EBUSY;
@@ -657,7 +657,7 @@ static int be_mbox_db_ready_poll(struct be_ctrl_info *ctrl)
 
 	beiscsi_log(phba, KERN_ERR,
 			BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			"BC_%d : FW Timed Out\n");
+			"BC", "FW Timed Out\n");
 
 	phba->fw_timeout = true;
 	beiscsi_ue_detect(phba);
@@ -850,7 +850,7 @@ int be_cmd_fw_initialize(struct be_ctrl_info *ctrl)
 	status = be_mbox_notify(ctrl);
 	if (status)
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BC_%d : be_cmd_fw_initialize Failed\n");
+			    "BC", "be_cmd_fw_initialize Failed\n");
 
 	mutex_unlock(&ctrl->mbox_lock);
 	return status;
@@ -891,7 +891,7 @@ int be_cmd_fw_uninit(struct be_ctrl_info *ctrl)
 	status = be_mbox_notify(ctrl);
 	if (status)
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BC_%d : be_cmd_fw_uninit Failed\n");
+			    "BC", "be_cmd_fw_uninit Failed\n");
 
 	mutex_unlock(&ctrl->mbox_lock);
 	return status;
@@ -956,7 +956,7 @@ int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
 		cq->created = true;
 	} else
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BC_%d : In be_cmd_cq_create, status=ox%08x\n",
+			    "BC", "In be_cmd_cq_create, status=ox%08x\n",
 			    status);
 
 	mutex_unlock(&ctrl->mbox_lock);
@@ -1032,7 +1032,7 @@ int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 	int status;
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BC_%d : In beiscsi_cmd_q_destroy queue_type : %d\n",
+		    "BC", "In beiscsi_cmd_q_destroy queue_type : %d\n",
 		    queue_type);
 
 	mutex_lock(&ctrl->mbox_lock);
@@ -1328,7 +1328,7 @@ int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
 		status = be_mbox_notify(ctrl);
 		if (status) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BC_%d : FW CMD to map iscsi frags failed.\n");
+				    "BC", "FW CMD to map iscsi frags failed.\n");
 
 			goto error;
 		}
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index d28ac23..28aebd3 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -61,16 +61,16 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : PCI_ERROR Recovery\n");
+			    "BS", "PCI_ERROR Recovery\n");
 		return NULL;
 	} else {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In beiscsi_session_create\n");
+			    "BS", "In beiscsi_session_create\n");
 	}
 
 	if (cmds_max > beiscsi_ep->phba->params.wrbs_per_cxn) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Cannot handle %d cmds.Max cmds per session supported is %d. Using %d.\n",
+			    "BS", "Cannot handle %d cmds.Max cmds per session supported is %d. Using %d.\n",
 			    cmds_max,
 			    beiscsi_ep->phba->params.wrbs_per_cxn,
 			    beiscsi_ep->phba->params.wrbs_per_cxn);
@@ -138,7 +138,7 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
 	phba = iscsi_host_priv(shost);
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_conn_create ,cidfrom iscsi layer=%d\n",
+		    "BS", "In beiscsi_conn_create ,cidfrom iscsi layer=%d\n",
 		    cid);
 
 	cls_conn = iscsi_conn_setup(cls_session, sizeof(*beiscsi_conn), cid);
@@ -170,12 +170,12 @@ static int beiscsi_bindconn_cid(struct beiscsi_hba *phba,
 
 	if (phba->conn_table[cri_index]) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Connection table already occupied. Detected clash\n");
+			    "BS", "Connection table already occupied. Detected clash\n");
 
 		return -EINVAL;
 	} else {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS_%d : phba->conn_table[%d]=%p(beiscsi_conn)\n",
+			    "BS", "phba->conn_table[%d]=%p(beiscsi_conn)\n",
 			    cri_index, beiscsi_conn);
 
 		phba->conn_table[cri_index] = beiscsi_conn;
@@ -215,7 +215,7 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	if (beiscsi_ep->phba != phba) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : beiscsi_ep->hba=%p not equal to phba=%p\n",
+			    "BS", "beiscsi_ep->hba=%p not equal to phba=%p\n",
 			    beiscsi_ep->phba, phba);
 
 		return -EEXIST;
@@ -230,7 +230,7 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	beiscsi_conn->doorbell_offset = pwrb_context->doorbell_offset;
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : beiscsi_conn=%p conn=%p ep_cid=%d\n",
+		    "BS", "beiscsi_conn=%p conn=%p ep_cid=%d\n",
 		    beiscsi_conn, conn, beiscsi_ep->ep_cid);
 
 	return beiscsi_bindconn_cid(phba, beiscsi_conn, beiscsi_ep->ep_cid);
@@ -247,7 +247,7 @@ static int beiscsi_create_ipv4_iface(struct beiscsi_hba *phba)
 					      0, 0);
 	if (!phba->ipv4_iface) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Could not create default IPv4 address.\n");
+			    "BS", "Could not create default IPv4 address.\n");
 		return -ENODEV;
 	}
 
@@ -265,7 +265,7 @@ static int beiscsi_create_ipv6_iface(struct beiscsi_hba *phba)
 					      0, 0);
 	if (!phba->ipv6_iface) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Could not create default IPv6 address.\n");
+			    "BS", "Could not create default IPv6 address.\n");
 		return -ENODEV;
 	}
 
@@ -331,13 +331,13 @@ beiscsi_set_static_ip(struct Scsi_Host *shost,
 		break;
 	default:
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Unsupported param %d\n",
+			    "BS", "Unsupported param %d\n",
 			    iface_param->param);
 	}
 
 	if (!iface_ip || !iface_subnet) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : IP and Subnet Mask required\n");
+			    "BS", "IP and Subnet Mask required\n");
 		return -EINVAL;
 	}
 
@@ -370,7 +370,7 @@ beiscsi_set_vlan_tag(struct Scsi_Host *shost,
 	ret = mgmt_get_all_if_id(phba);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Getting Interface Handle Failed\n");
+			    "BS", "Getting Interface Handle Failed\n");
 		return ret;
 	}
 
@@ -385,7 +385,7 @@ beiscsi_set_vlan_tag(struct Scsi_Host *shost,
 		break;
 	default:
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Unknown Param Type : %d\n",
+			    "BS", "Unknown Param Type : %d\n",
 			    iface_param->param);
 		return -ENOSYS;
 	}
@@ -415,7 +415,7 @@ beiscsi_set_ipv4(struct Scsi_Host *shost,
 						    data, dt_len);
 		else
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS_%d : Invalid BOOTPROTO: %d\n",
+				    "BS", "Invalid BOOTPROTO: %d\n",
 				    iface_param->value[0]);
 		break;
 	case ISCSI_NET_PARAM_IFACE_ENABLE:
@@ -435,7 +435,7 @@ beiscsi_set_ipv4(struct Scsi_Host *shost,
 		break;
 	default:
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Param %d not supported\n",
+			    "BS", "Param %d not supported\n",
 			    iface_param->param);
 	}
 
@@ -469,7 +469,7 @@ beiscsi_set_ipv6(struct Scsi_Host *shost,
 		break;
 	default:
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Param %d not supported\n",
+			    "BS", "Param %d not supported\n",
 			    iface_param->param);
 	}
 
@@ -487,7 +487,7 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
+			    "BS", "In PCI_ERROR Recovery\n");
 		return -EBUSY;
 	}
 
@@ -502,7 +502,7 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 		 */
 		if (iface_param->iface_num) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS_%d : Invalid iface_num %d.Only iface_num 0 is supported.\n",
+				    "BS", "Invalid iface_num %d.Only iface_num 0 is supported.\n",
 				    iface_param->iface_num);
 
 			return -EINVAL;
@@ -519,7 +519,7 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 			break;
 		default:
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS_%d : Invalid iface type :%d passed\n",
+				    "BS", "Invalid iface type :%d passed\n",
 				    iface_param->iface_type);
 			break;
 		}
@@ -601,7 +601,7 @@ int be2iscsi_iface_get_param(struct iscsi_iface *iface,
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
+			    "BS", "In PCI_ERROR Recovery\n");
 		return -EBUSY;
 	}
 
@@ -647,7 +647,7 @@ int beiscsi_ep_get_param(struct iscsi_endpoint *ep,
 
 	beiscsi_log(beiscsi_ep->phba, KERN_INFO,
 		    BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_ep_get_param, param= %d\n",
+		    "BS", "In beiscsi_ep_get_param, param= %d\n",
 		    param);
 
 	switch (param) {
@@ -676,7 +676,7 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 
 	phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_conn_set_param, param= %d\n",
+		    "BS", "In beiscsi_conn_set_param, param= %d\n",
 		    param);
 
 	ret = iscsi_set_param(cls_conn, param, buf, buflen);
@@ -726,7 +726,7 @@ static int beiscsi_get_initname(char *buf, struct beiscsi_hba *phba)
 	tag = be_cmd_get_initname(phba);
 	if (!tag) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Getting Initiator Name Failed\n");
+			    "BS", "Getting Initiator Name Failed\n");
 
 		return -EBUSY;
 	}
@@ -735,7 +735,7 @@ static int beiscsi_get_initname(char *buf, struct beiscsi_hba *phba)
 	if (rc) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BS_%d : Initiator Name MBX Failed\n");
+			    "BS", "Initiator Name MBX Failed\n");
 		return rc;
 	}
 
@@ -809,11 +809,11 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
+			    "BS", "In PCI_ERROR Recovery\n");
 		return -EBUSY;
 	} else {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In beiscsi_get_host_param, param = %d\n",
+			    "BS", "In beiscsi_get_host_param, param = %d\n",
 			    param);
 	}
 
@@ -822,7 +822,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 		status = beiscsi_get_macaddr(buf, phba);
 		if (status < 0) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS_%d : beiscsi_get_macaddr Failed\n");
+				    "BS", "beiscsi_get_macaddr Failed\n");
 			return status;
 		}
 		break;
@@ -830,7 +830,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 		status = beiscsi_get_initname(buf, phba);
 		if (status < 0) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BS_%d : Retreiving Initiator Name Failed\n");
+				    "BS", "Retreiving Initiator Name Failed\n");
 			return status;
 		}
 		break;
@@ -881,7 +881,7 @@ void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 
 	phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_conn_get_stats\n");
+		    "BS", "In beiscsi_conn_get_stats\n");
 
 	stats->txdata_octets = conn->txdata_octets;
 	stats->rxdata_octets = conn->rxdata_octets;
@@ -959,12 +959,12 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
+			    "BS", "In PCI_ERROR Recovery\n");
 		return -EBUSY;
 	} else {
 		beiscsi_log(beiscsi_conn->phba, KERN_INFO,
 			    BEISCSI_LOG_CONFIG,
-			    "BS_%d : In beiscsi_conn_start\n");
+			    "BS", "In beiscsi_conn_start\n");
 	}
 
 	memset(&params, 0, sizeof(struct beiscsi_offload_params));
@@ -972,7 +972,7 @@ int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	if (!beiscsi_ep)
 		beiscsi_log(beiscsi_conn->phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG,
-			    "BS_%d : In beiscsi_conn_start , no beiscsi_ep\n");
+			    "BS", "In beiscsi_conn_start , no beiscsi_ep\n");
 
 	beiscsi_conn->login_in_progress = 0;
 	beiscsi_set_params_for_offld(beiscsi_conn, &params);
@@ -1090,17 +1090,17 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	int ret = -ENOMEM;
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_open_conn\n");
+		    "BS", "In beiscsi_open_conn\n");
 
 	beiscsi_ep->ep_cid = beiscsi_get_cid(phba);
 	if (beiscsi_ep->ep_cid == 0xFFFF) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : No free cid available\n");
+			    "BS", "No free cid available\n");
 		return ret;
 	}
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_open_conn, ep_cid=%d\n",
+		    "BS", "In beiscsi_open_conn, ep_cid=%d\n",
 		    beiscsi_ep->ep_cid);
 
 	phba->ep_array[BE_GET_CRI_FROM_CID
@@ -1119,7 +1119,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	if (nonemb_cmd.va == NULL) {
 
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Failed to allocate memory for mgmt_open_connection\n");
+			    "BS", "Failed to allocate memory for mgmt_open_connection\n");
 
 		beiscsi_free_ep(beiscsi_ep);
 		return -ENOMEM;
@@ -1129,7 +1129,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep, &nonemb_cmd);
 	if (tag <= 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : mgmt_open_connection Failed for cid=%d\n",
+			    "BS", "mgmt_open_connection Failed for cid=%d\n",
 			    beiscsi_ep->ep_cid);
 
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
@@ -1142,7 +1142,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BS_%d : mgmt_open_connection Failed");
+			    "BS", "mgmt_open_connection Failed");
 
 		if (ret != -EBUSY)
 			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
@@ -1157,7 +1157,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	beiscsi_ep->fw_handle = ptcpcnct_out->connection_handle;
 	beiscsi_ep->cid_vld = 1;
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : mgmt_open_connection Success\n");
+		    "BS", "mgmt_open_connection Success\n");
 
 	pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 			    nonemb_cmd.va, nonemb_cmd.dma);
@@ -1193,19 +1193,19 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	if (beiscsi_error(phba)) {
 		ret = -EIO;
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BS_%d : The FW state Not Stable!!!\n");
+			    "BS", "The FW state Not Stable!!!\n");
 		return ERR_PTR(ret);
 	}
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
 		ret = -EBUSY;
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : In PCI_ERROR Recovery\n");
+			    "BS", "In PCI_ERROR Recovery\n");
 		return ERR_PTR(ret);
 	} else if (phba->state & BE_ADAPTER_LINK_DOWN) {
 		ret = -EBUSY;
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BS_%d : The Adapter Port state is Down!!!\n");
+			    "BS", "The Adapter Port state is Down!!!\n");
 		return ERR_PTR(ret);
 	}
 
@@ -1221,7 +1221,7 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	ret = beiscsi_open_conn(ep, NULL, dst_addr, non_blocking);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Failed in beiscsi_open_conn\n");
+			    "BS", "Failed in beiscsi_open_conn\n");
 		goto free_ep;
 	}
 
@@ -1244,7 +1244,7 @@ int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
 
 	beiscsi_log(beiscsi_ep->phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : In  beiscsi_ep_poll\n");
+		    "BS", "In  beiscsi_ep_poll\n");
 
 	if (beiscsi_ep->cid_vld == 1)
 		return 1;
@@ -1291,7 +1291,7 @@ static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
 	tag = mgmt_upload_connection(phba, beiscsi_ep->ep_cid, flag);
 	if (!tag) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS_%d : upload failed for cid 0x%x\n",
+			    "BS", "upload failed for cid 0x%x\n",
 			    beiscsi_ep->ep_cid);
 
 		ret = -EAGAIN;
@@ -1319,7 +1319,7 @@ static int beiscsi_unbind_conn_to_cid(struct beiscsi_hba *phba,
 		phba->conn_table[cri_index] = NULL;
 	else {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BS_%d : Connection table Not occupied.\n");
+			    "BS", "Connection table Not occupied.\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -1343,7 +1343,7 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 	beiscsi_ep = ep->dd_data;
 	phba = beiscsi_ep->phba;
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BS_%d : In beiscsi_ep_disconnect for ep_cid = %d\n",
+		    "BS", "In beiscsi_ep_disconnect for ep_cid = %d\n",
 		    beiscsi_ep->ep_cid);
 
 	if (beiscsi_ep->conn) {
@@ -1358,7 +1358,7 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : PCI_ERROR Recovery\n");
+			    "BS", "PCI_ERROR Recovery\n");
 		goto free_ep;
 	}
 
@@ -1368,7 +1368,7 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 					  savecfg_flag);
 	if (!tag) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : mgmt_invalidate_connection Failed for cid=%d\n",
+			    "BS", "mgmt_invalidate_connection Failed for cid=%d\n",
 			    beiscsi_ep->ep_cid);
 	}
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 63a5643..19c1875 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -72,23 +72,20 @@ beiscsi_##_name##_disp(struct device *dev,\
 			phba->attr_##_name);\
 }
 
-#define beiscsi_change_param(_name, _minval, _maxval, _defaval)\
-int \
-beiscsi_##_name##_change(struct beiscsi_hba *phba, uint32_t val)\
-{\
-	if (val >= _minval && val <= _maxval) {\
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,\
-			    "BA_%d : beiscsi_"#_name" updated "\
-			    "from 0x%x ==> 0x%x\n",\
-			    phba->attr_##_name, val); \
-		phba->attr_##_name = val;\
-		return 0;\
-	} \
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT, \
-		    "BA_%d beiscsi_"#_name" attribute "\
-		    "cannot be updated to 0x%x, "\
-		    "range allowed is ["#_minval" - "#_maxval"]\n", val);\
-		return -EINVAL;\
+#define beiscsi_change_param(_name, _minval, _maxval, _defaval)		\
+int									\
+beiscsi_##_name##_change(struct beiscsi_hba *phba, uint32_t val)	\
+{									\
+	if (val >= _minval && val <= _maxval) {				\
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,		\
+			    "BA", "beiscsi_" #_name " updated from 0x%x ==> 0x%x\n", \
+			    phba->attr_##_name, val);			\
+		phba->attr_##_name = val;				\
+		return 0;						\
+	}								\
+	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,			\
+		    "BA", "beiscsi_" #_name " attribute cannot be updated to 0x%x, range allowed is [" #_minval " - " #_maxval "]\n", val); \
+	return -EINVAL;							\
 }
 
 #define beiscsi_store_param(_name)  \
@@ -110,20 +107,19 @@ beiscsi_##_name##_store(struct device *dev,\
 		return -EINVAL;\
 }
 
-#define beiscsi_init_param(_name, _minval, _maxval, _defval) \
-int \
-beiscsi_##_name##_init(struct beiscsi_hba *phba, uint32_t val) \
-{ \
-	if (val >= _minval && val <= _maxval) {\
-		phba->attr_##_name = val;\
-		return 0;\
-	} \
-	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,\
-		    "BA_%d beiscsi_"#_name" attribute " \
-		    "cannot be updated to 0x%x, "\
-		    "range allowed is ["#_minval" - "#_maxval"]\n", val);\
-	phba->attr_##_name = _defval;\
-	return -EINVAL;\
+#define beiscsi_init_param(_name, _minval, _maxval, _defval)		\
+int									\
+beiscsi_##_name##_init(struct beiscsi_hba *phba, uint32_t val)		\
+{									\
+	if (val >= _minval && val <= _maxval) {				\
+		phba->attr_##_name = val;				\
+		return 0;						\
+	}								\
+	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,			\
+		    "BA", "beiscsi_" #_name " attribute cannot be updated to 0x%x, range allowed is [" #_minval " - " #_maxval "]\n", \
+		    val);						\
+	phba->attr_##_name = _defval;					\
+	return -EINVAL;							\
 }
 
 #define BEISCSI_RW_ATTR(_name, _minval, _maxval, _defval, _descp) \
@@ -267,7 +263,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
-			    "BM_%d : Failed to allocate memory for mgmt_invalidate_icds\n");
+			    "BM", "Failed to allocate memory for mgmt_invalidate_icds\n");
 		return FAILED;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -276,7 +272,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 				   cid, &nonemb_cmd);
 	if (!tag) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
-			    "BM_%d : mgmt_invalidate_icds could not be submitted\n");
+			    "BM", "mgmt_invalidate_icds could not be submitted\n");
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 
@@ -347,7 +343,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
-			    "BM_%d : Failed to allocate memory for mgmt_invalidate_icds\n");
+			    "BM", "Failed to allocate memory for mgmt_invalidate_icds\n");
 		return FAILED;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
@@ -356,7 +352,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 				   cid, &nonemb_cmd);
 	if (!tag) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_EH,
-			    "BM_%d : mgmt_invalidate_icds could not be submitted\n");
+			    "BM", "mgmt_invalidate_icds could not be submitted\n");
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		return FAILED;
@@ -782,7 +778,7 @@ static void beiscsi_get_params(struct beiscsi_hba *phba)
 					icd_count_unavailable);
 
 			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					"BM_%d : Aligned ICD values\n"
+					"BM", "Aligned ICD values\n"
 					"\t ICD Start : %d\n"
 					"\t ICD Count : %d\n"
 					"\t ICD Discarded : %d\n",
@@ -1005,7 +1001,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 					  &phwi_context->be_eq[i]);
 			if (ret) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : beiscsi_init_irqs-Failed to register msix for i = %d\n",
+					    "BM", "beiscsi_init_irqs-Failed to register msix for i = %d\n",
 					    i);
 				kfree(phba->msi_name[i]);
 				goto free_msix_irqs;
@@ -1023,7 +1019,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 				  &phwi_context->be_eq[i]);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT ,
-				    "BM_%d : beiscsi_init_irqs-Failed to register beiscsi_msix_mcc\n");
+				    "BM", "beiscsi_init_irqs-Failed to register beiscsi_msix_mcc\n");
 			kfree(phba->msi_name[i]);
 			goto free_msix_irqs;
 		}
@@ -1033,7 +1029,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 				  "beiscsi", phba);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : beiscsi_init_irqs-Failed to register irq\n");
+				    "BM", "beiscsi_init_irqs-Failed to register irq\n");
 			return ret;
 		}
 	}
@@ -1095,7 +1091,7 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 		WARN_ON(!(buf_len == 48));
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d : In ISCSI_OP_REJECT\n");
+			    "BM", "In ISCSI_OP_REJECT\n");
 		break;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
@@ -1107,7 +1103,7 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 	default:
 		beiscsi_log(phba, KERN_WARNING,
 			    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-			    "BM_%d : Unrecognized opcode 0x%x in async msg\n",
+			    "BM", "Unrecognized opcode 0x%x in async msg\n",
 			    (ppdu->
 			     dw[offsetof(struct amap_pdu_base, opcode) / 32]
 			     & PDUBASE_OPCODE_MASK));
@@ -1127,7 +1123,7 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 	spin_lock_bh(&phba->io_sgl_lock);
 	if (phba->io_sgl_hndl_avbl) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
-			    "BM_%d : In alloc_io_sgl_handle, io_sgl_alloc_index=%d\n",
+			    "BM", "In alloc_io_sgl_handle, io_sgl_alloc_index=%d\n",
 			    phba->io_sgl_alloc_index);
 
 		psgl_handle = phba->io_sgl_hndl_base[phba->
@@ -1150,7 +1146,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
 	spin_lock_bh(&phba->io_sgl_lock);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
-		    "BM_%d : In free_,io_sgl_free_index=%d\n",
+		    "BM", "In free_,io_sgl_free_index=%d\n",
 		    phba->io_sgl_free_index);
 
 	if (phba->io_sgl_hndl_base[phba->io_sgl_free_index]) {
@@ -1159,7 +1155,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		 * failed in xmit_task or alloc_pdu.
 		 */
 		 beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
-			     "BM_%d : Double Free in IO SGL io_sgl_free_index=%d, value there=%p\n",
+			     "BM", "Double Free in IO SGL io_sgl_free_index=%d, value there=%p\n",
 			     phba->io_sgl_free_index,
 			     phba->io_sgl_hndl_base
 			     [phba->io_sgl_free_index]);
@@ -1247,7 +1243,7 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 			       phba->params.wrbs_per_cxn);
 	beiscsi_log(phba, KERN_INFO,
 		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-		    "BM_%d : FREE WRB: pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
+		    "BM", "FREE WRB: pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
 		    pwrb_handle, pwrb_context->free_index,
 		    pwrb_context->wrb_handles_available);
 }
@@ -1261,7 +1257,7 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 		psgl_handle = phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index];
 		phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index] = NULL;
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-			    "BM_%d : mgmt_sgl_alloc_index=%d=0x%x\n",
+			    "BM", "mgmt_sgl_alloc_index=%d=0x%x\n",
 			    phba->eh_sgl_alloc_index,
 			    phba->eh_sgl_alloc_index);
 
@@ -1283,7 +1279,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
 	spin_lock_bh(&phba->mgmt_sgl_lock);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BM_%d : In  free_mgmt_sgl_handle, eh_sgl_free_index=%d\n",
+		    "BM", "In  free_mgmt_sgl_handle, eh_sgl_free_index=%d\n",
 		    phba->eh_sgl_free_index);
 
 	if (phba->eh_sgl_hndl_base[phba->eh_sgl_free_index]) {
@@ -1292,7 +1288,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		 * failed in xmit_task or alloc_pdu.
 		 */
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BM_%d : Double Free in eh SGL, eh_sgl_free_index=%d\n",
+			    "BM", "Double Free in eh SGL, eh_sgl_free_index=%d\n",
 			    phba->eh_sgl_free_index);
 		spin_unlock_bh(&phba->mgmt_sgl_lock);
 		return;
@@ -1581,7 +1577,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	case HWH_TYPE_LOGIN:
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d :\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd - Solicited path\n");
+			    "BM", "\t\t No HWH_TYPE_LOGIN Expected in hwi_complete_cmd - Solicited path\n");
 		break;
 
 	case HWH_TYPE_NOP:
@@ -1591,7 +1587,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	default:
 		beiscsi_log(phba, KERN_WARNING,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d : In hwi_complete_cmd, unknown type = %d wrb_index 0x%x CID 0x%x\n",
+			    "BM", "In hwi_complete_cmd, unknown type = %d wrb_index 0x%x CID 0x%x\n",
 			    type,
 			    csol_cqe.wrb_index,
 			    csol_cqe.cid);
@@ -1662,7 +1658,7 @@ hwi_get_async_handle(struct beiscsi_hba *phba,
 		pbusy_list = NULL;
 		beiscsi_log(phba, KERN_WARNING,
 			    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-			    "BM_%d : Unexpected code=%d\n",
+			    "BM", "Unexpected code=%d\n",
 			    pdpdu_cqe->dw[offsetof(struct amap_i_t_dpdu_cqe,
 			    code) / 32] & PDUCQE_CODE_MASK);
 		return NULL;
@@ -1727,7 +1723,7 @@ hwi_update_async_writables(struct beiscsi_hba *phba,
 	if (!writables) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d : Duplicate notification received - index 0x%x!!\n",
+			    "BM", "Duplicate notification received - index 0x%x!!\n",
 			    cq_index);
 		WARN_ON(1);
 	}
@@ -2117,7 +2113,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 			 */
 			beiscsi_log(phba, KERN_WARNING,
 				    BEISCSI_LOG_INIT,
-				    "BM_%d : proc cqe of disconn ep: cid %d\n",
+				    "BM", "proc cqe of disconn ep: cid %d\n",
 				    cid);
 			goto proc_next_cqe;
 		}
@@ -2139,7 +2135,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		case DRIVERMSG_NOTIFY:
 			beiscsi_log(phba, KERN_INFO,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Received %s[%d] on CID : %d\n",
+				    "BM", "Received %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 
 			dmsg = (struct dmsg_cqe *)sol;
@@ -2148,7 +2144,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		case UNSOL_HDR_NOTIFY:
 			beiscsi_log(phba, KERN_INFO,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Received %s[%d] on CID : %d\n",
+				    "BM", "Received %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 
 			spin_lock_bh(&phba->async_pdu_lock);
@@ -2159,7 +2155,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		case UNSOL_DATA_NOTIFY:
 			beiscsi_log(phba, KERN_INFO,
 				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-				    "BM_%d : Received %s[%d] on CID : %d\n",
+				    "BM", "Received %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 
 			spin_lock_bh(&phba->async_pdu_lock);
@@ -2172,14 +2168,14 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		case CXN_INVALIDATE_NOTIFY:
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Ignoring %s[%d] on CID : %d\n",
+				    "BM", "Ignoring %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 			break;
 		case CXN_KILLED_HDR_DIGEST_ERR:
 		case SOL_CMD_KILLED_DATA_DIGEST_ERR:
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-				    "BM_%d : Cmd Notification %s[%d] on CID : %d\n",
+				    "BM", "Cmd Notification %s[%d] on CID : %d\n",
 				    cqe_desc[code], code,  cid);
 			break;
 		case CMD_KILLED_INVALID_STATSN_RCVD:
@@ -2191,13 +2187,13 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		case CMD_CXN_KILLED_INVALID_DATASN_RCVD:
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-				    "BM_%d : Cmd Notification %s[%d] on CID : %d\n",
+				    "BM", "Cmd Notification %s[%d] on CID : %d\n",
 				    cqe_desc[code], code,  cid);
 			break;
 		case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Dropping %s[%d] on DPDU ring on CID : %d\n",
+				    "BM", "Dropping %s[%d] on DPDU ring on CID : %d\n",
 				    cqe_desc[code], code, cid);
 			spin_lock_bh(&phba->async_pdu_lock);
 			hwi_flush_default_pdu_buffer(phba, beiscsi_conn,
@@ -2221,7 +2217,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		case CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN:
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Event %s[%d] received on CID : %d\n",
+				    "BM", "Event %s[%d] received on CID : %d\n",
 				    cqe_desc[code], code, cid);
 			if (beiscsi_conn)
 				iscsi_conn_failure(beiscsi_conn->conn,
@@ -2230,7 +2226,7 @@ unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget)
 		default:
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Invalid CQE Event Received Code : %d CID 0x%x...\n",
+				    "BM", "Invalid CQE Event Received Code : %d CID 0x%x...\n",
 				    code, cid);
 			break;
 		}
@@ -2309,7 +2305,7 @@ static int be_iopoll(struct irq_poll *iop, int budget)
 		irq_poll_complete(iop);
 		beiscsi_log(phba, KERN_INFO,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
-			    "BM_%d : rearm pbe_eq->q.id =%d ret %d\n",
+			    "BM", "rearm pbe_eq->q.id =%d ret %d\n",
 			    pbe_eq->q.id, ret);
 		hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
 	}
@@ -2867,7 +2863,7 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 				     GFP_KERNEL);
 	if (!phwi_ctxt->be_wrbq) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : WRBQ Mem Alloc Failed\n");
+			    "BM", "WRBQ Mem Alloc Failed\n");
 		return -ENOMEM;
 	}
 
@@ -2878,7 +2874,7 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 					phba->params.wrbs_per_cxn, GFP_KERNEL);
 		if (!pwrb_context->pwrb_handle_base) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : Mem Alloc Failed. Failing to load\n");
+				    "BM", "Mem Alloc Failed. Failing to load\n");
 			goto init_wrb_hndl_failed;
 		}
 		pwrb_context->pwrb_handle_basestd =
@@ -2886,7 +2882,7 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 					phba->params.wrbs_per_cxn, GFP_KERNEL);
 		if (!pwrb_context->pwrb_handle_basestd) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : Mem Alloc Failed. Failing to load\n");
+				    "BM", "Mem Alloc Failed. Failing to load\n");
 			goto init_wrb_hndl_failed;
 		}
 		if (!num_cxn_wrbh) {
@@ -2983,14 +2979,14 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				(ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF_ULP%d va=%p\n",
+					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_BUF_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
 			} else
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_INIT,
-					    "BM_%d : No Virtual address for ULP : %d\n",
+					    "BM", "No Virtual address for ULP : %d\n",
 					    ulp_num);
 
 			pasync_ctx->async_header.va_base =
@@ -3005,14 +3001,14 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING_ULP%d va=%p\n",
+					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_RING_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
 			} else
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_INIT,
-					    "BM_%d : No Virtual address for ULP : %d\n",
+					    "BM", "No Virtual address for ULP : %d\n",
 					    ulp_num);
 
 			pasync_ctx->async_header.ring_base =
@@ -3023,14 +3019,14 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE_ULP%d va=%p\n",
+					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_HEADER_HANDLE_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
 			} else
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_INIT,
-					    "BM_%d : No Virtual address for ULP : %d\n",
+					    "BM", "No Virtual address for ULP : %d\n",
 					    ulp_num);
 
 			pasync_ctx->async_header.handle_base =
@@ -3043,14 +3039,14 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING_ULP%d va=%p\n",
+					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_RING_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
 			} else
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_INIT,
-					    "BM_%d : No Virtual address for ULP : %d\n",
+					    "BM", "No Virtual address for ULP : %d\n",
 					    ulp_num);
 
 			pasync_ctx->async_data.ring_base =
@@ -3062,7 +3058,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 			if (!mem_descr->mem_array[0].virtual_address)
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_INIT,
-					    "BM_%d : No Virtual address for ULP : %d\n",
+					    "BM", "No Virtual address for ULP : %d\n",
 					    ulp_num);
 
 			pasync_ctx->async_data.handle_base =
@@ -3082,14 +3078,14 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 				     (ulp_num * MEM_DESCR_OFFSET);
 			if (mem_descr->mem_array[0].virtual_address) {
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-					    "BM_%d : hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF_ULP%d va=%p\n",
+					    "BM", "hwi_init_async_pdu_ctx HWI_MEM_ASYNC_DATA_BUF_ULP%d va=%p\n",
 					    ulp_num,
 					    mem_descr->mem_array[0].
 					    virtual_address);
 			} else
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_INIT,
-					    "BM_%d : No Virtual address for ULP : %d\n",
+					    "BM", "No Virtual address for ULP : %d\n",
 					    ulp_num);
 
 			idx = 0;
@@ -3277,7 +3273,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 				    sizeof(struct be_eq_entry), eq_vaddress);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : be_fill_queue Failed for EQ\n");
+				    "BM", "be_fill_queue Failed for EQ\n");
 			goto create_eq_error;
 		}
 
@@ -3286,12 +3282,12 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 					    phwi_context->cur_eqd);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : beiscsi_cmd_eq_create Failed for EQ\n");
+				    "BM", "beiscsi_cmd_eq_create Failed for EQ\n");
 			goto create_eq_error;
 		}
 
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : eqid = %d\n",
+			    "BM", "eqid = %d\n",
 			    phwi_context->be_eq[i].q.id);
 	}
 	return 0;
@@ -3341,7 +3337,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : be_fill_queue Failed for ISCSI CQ\n");
+				    "BM", "be_fill_queue Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
 
@@ -3350,11 +3346,11 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 					    false, 0);
 		if (ret) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : beiscsi_cmd_eq_create Failed for ISCSI CQ\n");
+				    "BM", "beiscsi_cmd_eq_create Failed for ISCSI CQ\n");
 			goto create_cq_error;
 		}
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : iscsi cq_id is %d for eq_id %d\n"
+			    "BM", "iscsi cq_id is %d for eq_id %d\n"
 			    "iSCSI CQ CREATED\n", cq->id, eq->id);
 	}
 	return 0;
@@ -3398,7 +3394,7 @@ beiscsi_create_def_hdr(struct beiscsi_hba *phba,
 			    sizeof(struct phys_addr), dq_vaddress);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : be_fill_queue Failed for DEF PDU HDR on ULP : %d\n",
+			    "BM", "be_fill_queue Failed for DEF PDU HDR on ULP : %d\n",
 			    ulp_num);
 
 		return ret;
@@ -3411,14 +3407,14 @@ beiscsi_create_def_hdr(struct beiscsi_hba *phba,
 					      BEISCSI_DEFQ_HDR, ulp_num);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : be_cmd_create_default_pdu_queue Failed DEFHDR on ULP : %d\n",
+			    "BM", "be_cmd_create_default_pdu_queue Failed DEFHDR on ULP : %d\n",
 			    ulp_num);
 
 		return ret;
 	}
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : iscsi hdr def pdu id for ULP : %d is %d\n",
+		    "BM", "iscsi hdr def pdu id for ULP : %d is %d\n",
 		    ulp_num,
 		    phwi_context->be_def_hdrq[ulp_num].id);
 	hwi_post_async_buffers(phba, BEISCSI_DEFQ_HDR, ulp_num);
@@ -3451,7 +3447,7 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 			    sizeof(struct phys_addr), dq_vaddress);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : be_fill_queue Failed for DEF PDU DATA on ULP : %d\n",
+			    "BM", "be_fill_queue Failed for DEF PDU DATA on ULP : %d\n",
 			    ulp_num);
 
 		return ret;
@@ -3464,19 +3460,19 @@ beiscsi_create_def_data(struct beiscsi_hba *phba,
 					      BEISCSI_DEFQ_DATA, ulp_num);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d be_cmd_create_default_pdu_queue Failed for DEF PDU DATA on ULP : %d\n",
+			    "BM", "be_cmd_create_default_pdu_queue Failed for DEF PDU DATA on ULP : %d\n",
 			    ulp_num);
 		return ret;
 	}
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : iscsi def data id on ULP : %d is  %d\n",
+		    "BM", "iscsi def data id on ULP : %d is  %d\n",
 		    ulp_num,
 		    phwi_context->be_def_dataq[ulp_num].id);
 
 	hwi_post_async_buffers(phba, BEISCSI_DEFQ_DATA, ulp_num);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : DEFAULT PDU DATA RING CREATED on ULP : %d\n",
+		    "BM", "DEFAULT PDU DATA RING CREATED on ULP : %d\n",
 		    ulp_num);
 
 	return 0;
@@ -3504,13 +3500,13 @@ beiscsi_post_template_hdr(struct beiscsi_hba *phba)
 
 			if (status != 0) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Post Template HDR Failed for ULP_%d\n",
+					    "BM", "Post Template HDR Failed for ULP_%d\n",
 					    ulp_num);
 				return status;
 			}
 
 			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-				    "BM_%d : Template HDR Pages Posted for ULP_%d\n",
+				    "BM", "Template HDR Pages Posted for ULP_%d\n",
 				    ulp_num);
 		}
 	}
@@ -3544,13 +3540,13 @@ beiscsi_post_pages(struct beiscsi_hba *phba)
 		page_offset += pm_arr->size / PAGE_SIZE;
 		if (status != 0) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : post sgl failed.\n");
+				    "BM", "post sgl failed.\n");
 			return status;
 		}
 		pm_arr++;
 	}
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : POSTED PAGES\n");
+		    "BM", "POSTED PAGES\n");
 	return 0;
 }
 
@@ -3603,7 +3599,7 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 			   GFP_KERNEL);
 	if (!pwrb_arr) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Memory alloc failed in create wrb ring.\n");
+			    "BM", "Memory alloc failed in create wrb ring.\n");
 		return -ENOMEM;
 	}
 	wrb_vaddr = mem_descr->mem_array[idx].virtual_address;
@@ -3671,7 +3667,7 @@ beiscsi_create_wrb_rings(struct beiscsi_hba *phba,
 					    ulp_base_num);
 		if (status != 0) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : wrbq create failed.\n");
+				    "BM", "wrbq create failed.\n");
 			kfree(pwrb_arr);
 			return status;
 		}
@@ -3877,7 +3873,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	status = beiscsi_create_eqs(phba, phwi_context);
 	if (status != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : EQ not created\n");
+			    "BM", "EQ not created\n");
 		goto error;
 	}
 
@@ -3888,14 +3884,14 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	status = mgmt_check_supported_fw(ctrl, phba);
 	if (status != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Unsupported fw version\n");
+			    "BM", "Unsupported fw version\n");
 		goto error;
 	}
 
 	status = beiscsi_create_cqs(phba, phwi_context);
 	if (status != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : CQ not created\n");
+			    "BM", "CQ not created\n");
 		goto error;
 	}
 
@@ -3912,7 +3908,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 							ulp_num);
 			if (status != 0) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Default Header not created for ULP : %d\n",
+					    "BM", "Default Header not created for ULP : %d\n",
 					    ulp_num);
 				goto error;
 			}
@@ -3923,7 +3919,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 							 ulp_num);
 			if (status != 0) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Default Data not created for ULP : %d\n",
+					    "BM", "Default Data not created for ULP : %d\n",
 					    ulp_num);
 				goto error;
 			}
@@ -3933,20 +3929,20 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	status = beiscsi_post_pages(phba);
 	if (status != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Post SGL Pages Failed\n");
+			    "BM", "Post SGL Pages Failed\n");
 		goto error;
 	}
 
 	status = beiscsi_post_template_hdr(phba);
 	if (status != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Template HDR Posting for CXN Failed\n");
+			    "BM", "Template HDR Posting for CXN Failed\n");
 	}
 
 	status = beiscsi_create_wrb_rings(phba,	phwi_context, phwi_ctrlr);
 	if (status != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : WRB Rings not created\n");
+			    "BM", "WRB Rings not created\n");
 		goto error;
 	}
 
@@ -3971,12 +3967,12 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	}
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : hwi_init_port success\n");
+		    "BM", "hwi_init_port success\n");
 	return 0;
 
 error:
 	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-		    "BM_%d : hwi_init_port failed\n");
+		    "BM", "hwi_init_port failed\n");
 	hwi_cleanup(phba);
 	return status;
 }
@@ -3990,11 +3986,11 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
 		phwi_ctrlr->phwi_ctxt = (struct hwi_context_memory *)phba->
 		    init_mem[HWI_MEM_ADDN_CONTEXT].mem_array[0].virtual_address;
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : phwi_ctrlr->phwi_ctxt=%p\n",
+			    "BM", "phwi_ctrlr->phwi_ctxt=%p\n",
 			    phwi_ctrlr->phwi_ctxt);
 	} else {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : HWI_MEM_ADDN_CONTEXT is more than one element.Failing to load\n");
+			    "BM", "HWI_MEM_ADDN_CONTEXT is more than one element.Failing to load\n");
 		return -ENOMEM;
 	}
 
@@ -4004,13 +4000,13 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
 
 	if (hwi_init_async_pdu_ctx(phba)) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : hwi_init_async_pdu_ctx failed\n");
+			    "BM", "hwi_init_async_pdu_ctx failed\n");
 		return -ENOMEM;
 	}
 
 	if (hwi_init_port(phba) != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : hwi_init_controller failed\n");
+			    "BM", "hwi_init_controller failed\n");
 
 		return -ENOMEM;
 	}
@@ -4049,7 +4045,7 @@ static int beiscsi_init_controller(struct beiscsi_hba *phba)
 	ret = beiscsi_get_memory(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe -Failed in beiscsi_alloc_memory\n");
+			    "BM", "beiscsi_dev_probe -Failed in beiscsi_alloc_memory\n");
 		return ret;
 	}
 
@@ -4057,7 +4053,7 @@ static int beiscsi_init_controller(struct beiscsi_hba *phba)
 	if (ret)
 		goto free_init;
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : Return success from beiscsi_init_controller\n");
+		    "BM", "Return success from beiscsi_init_controller\n");
 
 	return 0;
 
@@ -4085,7 +4081,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 						 GFP_KERNEL);
 		if (!phba->io_sgl_hndl_base) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : Mem Alloc Failed. Failing to load\n");
+				    "BM", "Mem Alloc Failed. Failing to load\n");
 			return -ENOMEM;
 		}
 		phba->eh_sgl_hndl_base = kzalloc(sizeof(struct sgl_handle *) *
@@ -4095,12 +4091,12 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		if (!phba->eh_sgl_hndl_base) {
 			kfree(phba->io_sgl_hndl_base);
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : Mem Alloc Failed. Failing to load\n");
+				    "BM", "Mem Alloc Failed. Failing to load\n");
 			return -ENOMEM;
 		}
 	} else {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : HWI_MEM_SGLH is more than one element. Failing to load\n");
+			    "BM", "HWI_MEM_SGLH is more than one element. Failing to load\n");
 		return -ENOMEM;
 	}
 
@@ -4127,14 +4123,14 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		idx++;
 	}
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : phba->io_sgl_hndl_avbl=%d phba->eh_sgl_hndl_avbl=%d\n",
+		    "BM", "phba->io_sgl_hndl_avbl=%d phba->eh_sgl_hndl_avbl=%d\n",
 		    phba->io_sgl_hndl_avbl,
 		    phba->eh_sgl_hndl_avbl);
 
 	mem_descr_sg = phba->init_mem;
 	mem_descr_sg += HWI_MEM_SGE;
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "\n BM_%d : mem_descr_sg->num_elements=%d\n",
+		    "BM", "mem_descr_sg->num_elements=%d\n",
 		    mem_descr_sg->num_elements);
 
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
@@ -4185,7 +4181,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 
 			if (!ptr_cid_info) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Failed to allocate memory for ULP_CID_INFO for ULP : %d\n",
+					    "BM", "Failed to allocate memory for ULP_CID_INFO for ULP : %d\n",
 					    ulp_num);
 				ret = -ENOMEM;
 				goto free_memory;
@@ -4198,7 +4194,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 						  ulp_num), GFP_KERNEL);
 			if (!ptr_cid_info->cid_array) {
 				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Failed to allocate memory for CID_ARRAY for ULP : %d\n",
+					    "BM", "Failed to allocate memory for CID_ARRAY for ULP : %d\n",
 					    ulp_num);
 				kfree(ptr_cid_info);
 				ptr_cid_info = NULL;
@@ -4217,7 +4213,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 				 phba->params.cxns_per_ctrl, GFP_KERNEL);
 	if (!phba->ep_array) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed to allocate memory in hba_setup_cid_tbls\n");
+			    "BM", "Failed to allocate memory in hba_setup_cid_tbls\n");
 		ret = -ENOMEM;
 
 		goto free_memory;
@@ -4227,7 +4223,7 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 				   phba->params.cxns_per_ctrl, GFP_KERNEL);
 	if (!phba->conn_table) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed to allocate memory in hba_setup_cid_tbls\n");
+			    "BM", "Failed to allocate memory in hba_setup_cid_tbls\n");
 
 		kfree(phba->ep_array);
 		phba->ep_array = NULL;
@@ -4292,21 +4288,21 @@ static void hwi_enable_intr(struct beiscsi_hba *phba)
 	if (!enabled) {
 		reg |= MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : reg =x%08x addr=%p\n", reg, addr);
+			    "BM", "reg =x%08x addr=%p\n", reg, addr);
 		iowrite32(reg, addr);
 	}
 
 	if (!phba->msix_enabled) {
 		eq = &phwi_context->be_eq[0].q;
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : eq->id=%d\n", eq->id);
+			    "BM", "eq->id=%d\n", eq->id);
 
 		hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
 	} else {
 		for (i = 0; i <= phba->num_cpus; i++) {
 			eq = &phwi_context->be_eq[i].q;
 			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-				    "BM_%d : eq->id=%d\n", eq->id);
+				    "BM", "eq->id=%d\n", eq->id);
 			hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
 		}
 	}
@@ -4325,7 +4321,7 @@ static void hwi_disable_intr(struct beiscsi_hba *phba)
 		iowrite32(reg, addr);
 	} else
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : In hwi_disable_intr, Already Disabled\n");
+			    "BM", "In hwi_disable_intr, Already Disabled\n");
 }
 
 /**
@@ -4351,7 +4347,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM_%d : No boot session\n");
+			    "BM", "No boot session\n");
 
 		if (ret == -ENXIO)
 			phba->get_boot = 0;
@@ -4366,7 +4362,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM_%d : Failed to allocate memory for beiscsi_get_session_info\n");
+			    "BM", "Failed to allocate memory for beiscsi_get_session_info\n");
 
 		return -ENOMEM;
 	}
@@ -4376,7 +4372,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	if (!tag) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM_%d : beiscsi_get_session_info Failed\n");
+			    "BM", "beiscsi_get_session_info Failed\n");
 
 		goto boot_freemem;
 	}
@@ -4385,7 +4381,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BM_%d : beiscsi_get_session_info Failed\n");
+			    "BM", "beiscsi_get_session_info Failed\n");
 
 		if (ret != -EBUSY)
 			goto boot_freemem;
@@ -4476,19 +4472,19 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 	ret = beiscsi_init_controller(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe - Failed in beiscsi_init_controller\n");
+			    "BM", "beiscsi_dev_probe - Failed in beiscsi_init_controller\n");
 		return ret;
 	}
 	ret = beiscsi_init_sgl_handle(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe - Failed in beiscsi_init_sgl_handle\n");
+			    "BM", "beiscsi_dev_probe - Failed in beiscsi_init_sgl_handle\n");
 		goto do_cleanup_ctrlr;
 	}
 
 	if (hba_setup_cid_tbls(phba)) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed in hba_setup_cid_tbls\n");
+			    "BM", "Failed in hba_setup_cid_tbls\n");
 		kfree(phba->io_sgl_hndl_base);
 		kfree(phba->eh_sgl_hndl_base);
 		goto do_cleanup_ctrlr;
@@ -4545,7 +4541,7 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 			if (mgmt_status)
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_INIT,
-					    "BM_%d : mgmt_epfw_cleanup FAILED for ULP_%d\n",
+					    "BM", "mgmt_epfw_cleanup FAILED for ULP_%d\n",
 					    ulp_num);
 		}
 	}
@@ -4717,7 +4713,7 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 			       phba->params.wrbs_per_cxn);
 	beiscsi_log(phba, KERN_INFO,
 		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-		    "BM_%d : put CONTEXT_UPDATE pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
+		    "BM", "put CONTEXT_UPDATE pwrb_handle=%p free_index=0x%x wrb_handles_available=%d\n",
 		    pwrb_handle, pwrb_context->free_index,
 		    pwrb_context->wrb_handles_available);
 }
@@ -4771,7 +4767,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		if (!io_task->psgl_handle) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Alloc of IO_SGL_ICD Failed for the CID : %d\n",
+				    "BM", "Alloc of IO_SGL_ICD Failed for the CID : %d\n",
 				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_hndls;
 		}
@@ -4781,7 +4777,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		if (!io_task->pwrb_handle) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-				    "BM_%d : Alloc of WRB_HANDLE Failed for the CID : %d\n",
+				    "BM", "Alloc of WRB_HANDLE Failed for the CID : %d\n",
 				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_io_hndls;
 		}
@@ -4796,7 +4792,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					beiscsi_log(phba, KERN_ERR,
 						    BEISCSI_LOG_IO |
 						    BEISCSI_LOG_CONFIG,
-						    "BM_%d : Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
+						    "BM", "Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
 						    beiscsi_conn->
 						    beiscsi_conn_cid);
 					goto free_hndls;
@@ -4813,7 +4809,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					beiscsi_log(phba, KERN_ERR,
 						    BEISCSI_LOG_IO |
 						    BEISCSI_LOG_CONFIG,
-						    "BM_%d : Alloc of WRB_HANDLE Failed for the CID : %d\n",
+						    "BM", "Alloc of WRB_HANDLE Failed for the CID : %d\n",
 						    beiscsi_conn->
 						    beiscsi_conn_cid);
 					goto free_mgmt_hndls;
@@ -4833,7 +4829,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_IO |
 					    BEISCSI_LOG_CONFIG,
-					    "BM_%d : Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
+					    "BM", "Alloc of MGMT_SGL_ICD Failed for the CID : %d\n",
 					    beiscsi_conn->
 					    beiscsi_conn_cid);
 				goto free_hndls;
@@ -4845,7 +4841,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			if (!io_task->pwrb_handle) {
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-					    "BM_%d : Alloc of WRB_HANDLE Failed for the CID : %d\n",
+					    "BM", "Alloc of WRB_HANDLE Failed for the CID : %d\n",
 					    beiscsi_conn->beiscsi_conn_cid);
 				goto free_mgmt_hndls;
 			}
@@ -5097,7 +5093,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 
 	default:
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BM_%d : opcode =%d Not supported\n",
+			    "BM", "opcode =%d Not supported\n",
 			    task->hdr->opcode & ISCSI_OPCODE_MASK);
 
 		return -EINVAL;
@@ -5141,7 +5137,7 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	if (num_sg < 0) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_IO | BEISCSI_LOG_ISCSI,
-			    "BM_%d : scsi_dma_map Failed Driver_ITT : 0x%x ITT : 0x%x Xferlen : 0x%x\n",
+			    "BM", "scsi_dma_map Failed Driver_ITT : 0x%x ITT : 0x%x Xferlen : 0x%x\n",
 			    be32_to_cpu(io_task->cmd_bhs->iscsi_hdr.itt),
 			    io_task->libiscsi_itt, scsi_bufflen(sc));
 
@@ -5183,14 +5179,14 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 					&nonemb_cmd.dma);
 		if (nonemb_cmd.va == NULL) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM_%d : Failed to allocate memory for beiscsi_bsg_request\n");
+				    "BM", "Failed to allocate memory for beiscsi_bsg_request\n");
 			return -ENOMEM;
 		}
 		tag = mgmt_vendor_specific_fw_cmd(&phba->ctrl, phba, job,
 						  &nonemb_cmd);
 		if (!tag) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM_%d : MBX Tag Allocation Failed\n");
+				    "BM", "MBX Tag Allocation Failed\n");
 
 			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 					    nonemb_cmd.va, nonemb_cmd.dma);
@@ -5219,7 +5215,7 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		if (status || extd_status) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM_%d : MBX Cmd Failed status = %d extd_status = %d\n",
+				    "BM", "MBX Cmd Failed status = %d extd_status = %d\n",
 				    status, extd_status);
 
 			return -EIO;
@@ -5230,7 +5226,7 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 
 	default:
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				"BM_%d : Unsupported bsg command: 0x%x\n",
+				"BM", "Unsupported bsg command: 0x%x\n",
 				bsg_req->msgcode);
 		break;
 	}
@@ -5388,7 +5384,7 @@ static void be_check_boot_session(struct beiscsi_hba *phba)
 {
 	if (beiscsi_setup_boot_info(phba))
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Could not set up iSCSI boot info on async event.\n");
+			    "BM", "Could not set up iSCSI boot info on async event.\n");
 }
 
 /*
@@ -5433,13 +5429,13 @@ static pci_ers_result_t beiscsi_eeh_err_detected(struct pci_dev *pdev,
 	phba->state |= BE_ADAPTER_PCI_ERR;
 
 	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-		    "BM_%d : EEH error detected\n");
+		    "BM", "EEH error detected\n");
 
 	beiscsi_quiesce(phba, BEISCSI_EEH_UNLOAD);
 
 	if (state == pci_channel_io_perm_failure) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : EEH : State PERM Failure\n");
+			    "BM", "EEH : State PERM Failure\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -5465,7 +5461,7 @@ static pci_ers_result_t beiscsi_eeh_reset(struct pci_dev *pdev)
 	phba = (struct beiscsi_hba *)pci_get_drvdata(pdev);
 
 	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-		    "BM_%d : EEH Reset\n");
+		    "BM", "EEH Reset\n");
 
 	status = pci_enable_device(pdev);
 	if (status)
@@ -5479,10 +5475,10 @@ static pci_ers_result_t beiscsi_eeh_reset(struct pci_dev *pdev)
 	status = be_chk_reset_complete(phba);
 	if (!status) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : EEH Reset Completed\n");
+			    "BM", "EEH Reset Completed\n");
 	} else {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : EEH Reset Completion Failure\n");
+			    "BM", "EEH Reset Completion Failure\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -5515,14 +5511,14 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	ret = beiscsi_cmd_reset_function(phba);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Reset Failed\n");
+			    "BM", "Reset Failed\n");
 		goto ret_err;
 	}
 
 	ret = be_chk_reset_complete(phba);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed to get out of reset.\n");
+			    "BM", "Failed to get out of reset.\n");
 		goto ret_err;
 	}
 
@@ -5532,7 +5528,7 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	ret = hwi_init_controller(phba);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_eeh_resume - Failed to initialize beiscsi_hba.\n");
+			    "BM", "beiscsi_eeh_resume - Failed to initialize beiscsi_hba.\n");
 		goto ret_err;
 	}
 
@@ -5560,7 +5556,7 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_eeh_resume - Failed to beiscsi_init_irqs\n");
+			    "BM", "beiscsi_eeh_resume - Failed to beiscsi_init_irqs\n");
 		goto ret_err;
 	}
 
@@ -5570,7 +5566,7 @@ static void beiscsi_eeh_resume(struct pci_dev *pdev)
 	return;
 ret_err:
 	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-		    "BM_%d : AER EEH Resume Failed\n");
+		    "BM", "AER EEH Resume Failed\n");
 }
 
 static int beiscsi_dev_probe(struct pci_dev *pcidev,
@@ -5601,7 +5597,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = pci_enable_pcie_error_reporting(pcidev);
 	if (ret)
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : PCIe Error Reporting Enabling Failed\n");
+			    "BM", "PCIe Error Reporting Enabling Failed\n");
 
 	pci_save_state(pcidev);
 
@@ -5635,7 +5631,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = be_ctrl_init(phba, pcidev);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-Failed in be_ctrl_init\n");
+			    "BM", "beiscsi_dev_probe-Failed in be_ctrl_init\n");
 		goto hba_free;
 	}
 
@@ -5645,13 +5641,13 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = beiscsi_cmd_reset_function(phba);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Reset Failed\n");
+			    "BM", "Reset Failed\n");
 		goto hba_free;
 	}
 	ret = be_chk_reset_complete(phba);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Failed to get out of reset.\n");
+			    "BM", "Failed to get out of reset.\n");
 		goto hba_free;
 	}
 
@@ -5662,7 +5658,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = mgmt_get_fw_config(&phba->ctrl, phba);
 	if (ret != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Error getting fw config\n");
+			    "BM", "Error getting fw config\n");
 		goto free_port;
 	}
 	mgmt_get_port_name(&phba->ctrl, phba);
@@ -5674,7 +5670,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		phba->num_cpus = 1;
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : num_cpus = %d\n",
+		    "BM", "num_cpus = %d\n",
 		    phba->num_cpus);
 
 	if (enable_msix) {
@@ -5688,7 +5684,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-Failed in beiscsi_init_port\n");
+			    "BM", "beiscsi_dev_probe-Failed in beiscsi_init_port\n");
 		goto free_port;
 	}
 
@@ -5708,7 +5704,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	phba->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, phba->wq_name);
 	if (!phba->wq) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-Failed to allocate work queue\n");
+			    "BM", "beiscsi_dev_probe-Failed to allocate work queue\n");
 		ret = -ENOMEM;
 		goto free_twq;
 	}
@@ -5733,7 +5729,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	ret = beiscsi_init_irqs(phba);
 	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : beiscsi_dev_probe-Failed to beiscsi_init_irqs\n");
+			    "BM", "beiscsi_dev_probe-Failed to beiscsi_init_irqs\n");
 		goto free_blkenbld;
 	}
 	hwi_enable_intr(phba);
@@ -5747,14 +5743,14 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		 * iscsi boot.
 		 */
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BM_%d : Could not set up iSCSI boot info.\n");
+			    "BM", "Could not set up iSCSI boot info.\n");
 
 	beiscsi_create_def_ifaces(phba);
 	schedule_delayed_work(&phba->beiscsi_hw_check_task,
 			      msecs_to_jiffies(1000));
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "\n\n\n BM_%d : SUCCESS - DRIVER LOADED\n\n\n");
+		    "BM", "SUCCESS - DRIVER LOADED\n");
 	return 0;
 
 free_blkenbld:
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 30a4606..aa9c682 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1075,20 +1075,21 @@ struct hwi_context_memory {
 /* Logging related definitions */
 #define BEISCSI_LOG_INIT	0x0001	/* Initialization events */
 #define BEISCSI_LOG_MBOX	0x0002	/* Mailbox Events */
-#define BEISCSI_LOG_MISC	0x0004	/* Miscllaneous Events */
+#define BEISCSI_LOG_MISC	0x0004	/* Miscellaneous Events */
 #define BEISCSI_LOG_EH		0x0008	/* Error Handler */
 #define BEISCSI_LOG_IO		0x0010	/* IO Code Path */
 #define BEISCSI_LOG_CONFIG	0x0020	/* CONFIG Code Path */
 #define BEISCSI_LOG_ISCSI	0x0040	/* SCSI/iSCSI Protocol related Logs */
 
-#define __beiscsi_log(phba, level, fmt, arg...) \
-	shost_printk(level, phba->shost, fmt, __LINE__, ##arg)
+#define __beiscsi_log(phba, level, fmt, ...)				\
+	shost_printk(level, phba->shost, fmt, ##__VA_ARGS__)
 
-#define beiscsi_log(phba, level, mask, fmt, arg...) \
-do { \
-	uint32_t log_value = phba->attr_log_enable; \
-		if (((mask) & log_value) || (level[1] <= '3')) \
-			__beiscsi_log(phba, level, fmt, ##arg); \
-} while (0);
+#define beiscsi_log(phba, level, mask, prefix, fmt, ...)		\
+do {									\
+	uint32_t log_value = phba->attr_log_enable;			\
+	if (((mask) & log_value) || (level[1] <= '3'))			\
+		__beiscsi_log(phba, level, prefix "_%d: " fmt,		\
+			      __LINE__, ##__VA_ARGS__);			\
+} while (0)
 
 #endif
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 888567b..44b69ef 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -131,7 +131,7 @@ void beiscsi_ue_detect(struct beiscsi_hba *phba)
 		phba->ue_detected = true;
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BG_%d : Error detected on the adapter\n");
+			    "BG", "Error detected on the adapter\n");
 	}
 
 	if (ue_lo) {
@@ -139,7 +139,7 @@ void beiscsi_ue_detect(struct beiscsi_hba *phba)
 			if (ue_lo & 1)
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_CONFIG,
-					    "BG_%d : UE_LOW %s bit set\n",
+					    "BG", "UE_LOW %s bit set\n",
 					    desc_ue_status_low[i]);
 		}
 	}
@@ -149,7 +149,7 @@ void beiscsi_ue_detect(struct beiscsi_hba *phba)
 			if (ue_hi & 1)
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_CONFIG,
-					    "BG_%d : UE_HIGH %s bit set\n",
+					    "BG", "UE_HIGH %s bit set\n",
 					    desc_ue_status_hi[i]);
 		}
 	}
@@ -210,7 +210,7 @@ unsigned int mgmt_reopen_session(struct beiscsi_hba *phba,
 
 	beiscsi_log(phba, KERN_INFO,
 		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BG_%d : In bescsi_get_boot_target\n");
+		    "BG", "In bescsi_get_boot_target\n");
 
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = alloc_mcc_wrb(phba, &tag);
@@ -243,7 +243,7 @@ unsigned int mgmt_get_boot_target(struct beiscsi_hba *phba)
 
 	beiscsi_log(phba, KERN_INFO,
 		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BG_%d : In bescsi_get_boot_target\n");
+		    "BG", "In bescsi_get_boot_target\n");
 
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = alloc_mcc_wrb(phba, &tag);
@@ -276,7 +276,7 @@ unsigned int mgmt_get_session_info(struct beiscsi_hba *phba,
 
 	beiscsi_log(phba, KERN_INFO,
 		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BG_%d : In beiscsi_get_session_info\n");
+		    "BG", "In beiscsi_get_session_info\n");
 
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = alloc_mcc_wrb(phba, &tag);
@@ -334,7 +334,7 @@ int mgmt_get_port_name(struct be_ctrl_info *ctrl,
 				  (phba->fw_config.phys_port * 8) & 0xff;
 	} else {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BG_%d : GET_PORT_NAME ret 0x%x status 0x%x\n",
+			    "BG", "GET_PORT_NAME ret 0x%x status 0x%x\n",
 			    ret, ioctl->h.resp_hdr.status);
 	}
 
@@ -376,7 +376,7 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 
 	if (be_mbox_notify(ctrl)) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG_%d : Failed in mgmt_get_fw_config\n");
+			    "BG", "Failed in mgmt_get_fw_config\n");
 		goto fail_init;
 	}
 
@@ -384,7 +384,7 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 	phba->fw_config.phys_port = pfw_cfg->phys_port;
 	if (phba->fw_config.phys_port >= BEISCSI_PHYS_PORT_MAX) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG_%d : invalid physical port id %d\n",
+			    "BG", "invalid physical port id %d\n",
 			    phba->fw_config.phys_port);
 		goto fail_init;
 	}
@@ -396,19 +396,19 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 		if (phba->fw_config.eqid_count == 0 ||
 		    phba->fw_config.eqid_count > 2048) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BG_%d : invalid EQ count %d\n",
+				    "BG", "invalid EQ count %d\n",
 				    phba->fw_config.eqid_count);
 			goto fail_init;
 		}
 		if (phba->fw_config.cqid_count == 0 ||
 		    phba->fw_config.cqid_count > 4096) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BG_%d : invalid CQ count %d\n",
+				    "BG", "invalid CQ count %d\n",
 				    phba->fw_config.cqid_count);
 			goto fail_init;
 		}
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BG_%d : EQ_Count : %d CQ_Count : %d\n",
+			    "BG", "EQ_Count : %d CQ_Count : %d\n",
 			    phba->fw_config.eqid_count,
 			    phba->fw_config.cqid_count);
 	}
@@ -441,7 +441,7 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				pfw_cfg->chain_icd[ulp_num].chain_count;
 
 			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-				    "BG_%d : Function loaded on ULP : %d\n"
+				    "BG", "Function loaded on ULP : %d\n"
 				    "\tiscsi_cid_count : %d\n"
 				    "\tiscsi_cid_start : %d\n"
 				    "\t iscsi_icd_count : %d\n"
@@ -460,7 +460,7 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 
 	if (phba->fw_config.ulp_supported == 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG_%d : iSCSI initiator mode not set: ULP0 %x ULP1 %x\n",
+			    "BG", "iSCSI initiator mode not set: ULP0 %x ULP1 %x\n",
 			    pfw_cfg->ulp[BEISCSI_ULP0].ulp_mode,
 			    pfw_cfg->ulp[BEISCSI_ULP1].ulp_mode);
 		goto fail_init;
@@ -475,7 +475,7 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 	icd_count = phba->fw_config.iscsi_icd_count[ulp_num];
 	if (icd_count == 0 || icd_count > 65536) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG_%d: invalid ICD count %d\n", icd_count);
+			    "BG", "invalid ICD count %d\n", icd_count);
 		goto fail_init;
 	}
 
@@ -483,7 +483,7 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 		    BEISCSI_GET_CID_COUNT(phba, BEISCSI_ULP1);
 	if (cid_count == 0 || cid_count > 4096) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG_%d: invalid CID count %d\n", cid_count);
+			    "BG", "invalid CID count %d\n", cid_count);
 		goto fail_init;
 	}
 
@@ -495,7 +495,7 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 					  BEISCSI_FUNC_DUA_MODE);
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BG_%d : DUA Mode : 0x%x\n",
+		    "BG", "DUA Mode : 0x%x\n",
 		    phba->fw_config.dual_ulp_aware);
 
 	/* all set, continue using this FW config */
@@ -519,7 +519,7 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG_%d : Failed to allocate memory for mgmt_check_supported_fw\n");
+			    "BG", "Failed to allocate memory for mgmt_check_supported_fw\n");
 		return -ENOMEM;
 	}
 	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
@@ -537,7 +537,7 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 	if (!status) {
 		struct be_mgmt_controller_attributes_resp *resp = nonemb_cmd.va;
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BG_%d : Firmware Version of CMD : %s\n"
+			    "BG", "Firmware Version of CMD : %s\n"
 			    "Firmware Version is : %s\n"
 			    "Developer Build, not performing version check...\n",
 			    resp->params.hba_attribs
@@ -548,13 +548,13 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 		phba->fw_config.iscsi_features =
 				resp->params.hba_attribs.iscsi_features;
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-			    "BM_%d : phba->fw_config.iscsi_features = %d\n",
+			    "BM", "phba->fw_config.iscsi_features = %d\n",
 			    phba->fw_config.iscsi_features);
 		memcpy(phba->fw_ver_str, resp->params.hba_attribs.
 		       firmware_version_string, BEISCSI_VER_STRLEN);
 	} else
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-			    "BG_%d :  Failed in mgmt_check_supported_fw\n");
+			    "BG", " Failed in mgmt_check_supported_fw\n");
 	mutex_unlock(&ctrl->mbox_lock);
 	if (nonemb_cmd.va)
 		pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
@@ -604,7 +604,7 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 		break;
 	default:
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG_%d : Unsupported cmd = 0x%x\n\n",
+			    "BG", "Unsupported cmd = 0x%x\n\n",
 			    bsg_req->rqst_data.h_vendor.vendor_cmd[0]);
 
 		mutex_unlock(&ctrl->mbox_lock);
@@ -667,7 +667,7 @@ int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short ulp_num)
 	status = be_mcc_compl_poll(phba, tag);
 	if (status)
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BG_%d : mgmt_epfw_cleanup , FAILED\n");
+			    "BG", "mgmt_epfw_cleanup , FAILED\n");
 	mutex_unlock(&ctrl->mbox_lock);
 	return status;
 }
@@ -810,7 +810,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 
 	if (dst_addr->sa_family != PF_INET && dst_addr->sa_family != PF_INET6) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BG_%d : unknown addr family %d\n",
+			    "BG", "unknown addr family %d\n",
 			    dst_addr->sa_family);
 		return -EINVAL;
 	}
@@ -869,7 +869,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 		phba->nxt_cqid = 0;
 	req->cq_id = phwi_context->be_cq[i].id;
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
-		    "BG_%d : i=%d cq_id=%d\n", i, req->cq_id);
+		    "BG", "i=%d cq_id=%d\n", i, req->cq_id);
 	req->defq_id = def_hdr_id;
 	req->hdr_ring_id = def_hdr_id;
 	req->data_ring_id = def_data_id;
@@ -919,7 +919,7 @@ unsigned int mgmt_get_all_if_id(struct beiscsi_hba *phba)
 	status = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
 	if (status) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG_%d : Failed in mgmt_get_all_if_id\n");
+			    "BG", "Failed in mgmt_get_all_if_id\n");
 		return -EBUSY;
 	}
 
@@ -976,7 +976,7 @@ static int mgmt_exec_nonemb_cmd(struct beiscsi_hba *phba,
 
 		beiscsi_log(phba, KERN_WARNING,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BG_%d : mgmt_exec_nonemb_cmd Failed status\n");
+			    "BG", "mgmt_exec_nonemb_cmd Failed status\n");
 
 		if (rc != -EBUSY)
 			goto free_cmd;
@@ -995,7 +995,7 @@ static int mgmt_alloc_cmd_data(struct beiscsi_hba *phba, struct be_dma_mem *cmd,
 	cmd->va = pci_zalloc_consistent(phba->ctrl.pdev, size, &cmd->dma);
 	if (!cmd->va) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BG_%d : Failed to allocate memory for if info\n");
+			    "BG", "Failed to allocate memory for if info\n");
 		return -ENOMEM;
 	}
 	cmd->size = size;
@@ -1054,7 +1054,7 @@ mgmt_static_ip_modify(struct beiscsi_hba *phba,
 	rc = mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
 	if (rc < 0)
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG_%d : Failed to Modify existing IP Address\n");
+			    "BG", "Failed to Modify existing IP Address\n");
 	return rc;
 }
 
@@ -1109,7 +1109,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 	if (boot_proto == ISCSI_BOOTPROTO_DHCP) {
 		if (if_info->dhcp_state) {
 			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-				    "BG_%d : DHCP Already Enabled\n");
+				    "BG", "DHCP Already Enabled\n");
 			goto exit;
 		}
 		/* The ip_param->len is 1 in DHCP case. Setting
@@ -1138,7 +1138,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 			if (rc < 0) {
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_CONFIG,
-					    "BG_%d : Failed to Delete existing dhcp\n");
+					    "BG", "Failed to Delete existing dhcp\n");
 				goto exit;
 			}
 		}
@@ -1158,7 +1158,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 		rc = mgmt_get_gateway(phba, BE2_IPV4, &gtway_addr_set);
 		if (rc) {
 			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-				    "BG_%d : Failed to Get Gateway Addr\n");
+				    "BG", "Failed to Get Gateway Addr\n");
 			goto exit;
 		}
 
@@ -1170,7 +1170,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 			if (rc) {
 				beiscsi_log(phba, KERN_WARNING,
 					    BEISCSI_LOG_CONFIG,
-					    "BG_%d : Failed to clear Gateway Addr Set\n");
+					    "BG", "Failed to clear Gateway Addr Set\n");
 				goto exit;
 			}
 		}
@@ -1212,7 +1212,7 @@ int mgmt_set_gateway(struct beiscsi_hba *phba,
 	rt_val = mgmt_get_gateway(phba, BE2_IPV4, &gtway_addr_set);
 	if (rt_val) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG_%d : Failed to Get Gateway Addr\n");
+			    "BG", "Failed to Get Gateway Addr\n");
 		return rt_val;
 	}
 
@@ -1222,7 +1222,7 @@ int mgmt_set_gateway(struct beiscsi_hba *phba,
 					     gateway_param->len);
 		if (rt_val) {
 			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-				    "BG_%d : Failed to clear Gateway Addr Set\n");
+				    "BG", "Failed to clear Gateway Addr Set\n");
 			return rt_val;
 		}
 	}
@@ -1233,7 +1233,7 @@ int mgmt_set_gateway(struct beiscsi_hba *phba,
 
 	if (rt_val)
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG_%d : Failed to Set Gateway Addr\n");
+			    "BG", "Failed to Set Gateway Addr\n");
 
 	return rt_val;
 }
@@ -1286,7 +1286,7 @@ int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
 		if (!*if_info) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG_%d : Memory Allocation Failure\n");
+				    "BG", "Memory Allocation Failure\n");
 
 				/* Free the DMA memory for the IOCTL issuing */
 				pci_free_consistent(phba->ctrl.pdev,
@@ -1392,7 +1392,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 		if (!tag) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
-				    "BG_%d : Getting Boot Target Info Failed\n");
+				    "BG", "Getting Boot Target Info Failed\n");
 			return -EAGAIN;
 		}
 
@@ -1400,7 +1400,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 		if (rc) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG_%d : MBX CMD get_boot_target Failed\n");
+				    "BG", "MBX CMD get_boot_target Failed\n");
 			return -EBUSY;
 		}
 
@@ -1410,7 +1410,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 		if (!boot_resp->boot_session_count) {
 			beiscsi_log(phba, KERN_INFO,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG_%d  ;No boot targets configured\n");
+				    "BG", "No boot targets configured\n");
 			return -ENXIO;
 		}
 
@@ -1426,7 +1426,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 		if (!tag) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG_%d : mgmt_reopen_session Failed\n");
+				    "BG", "mgmt_reopen_session Failed\n");
 			return -EAGAIN;
 		}
 
@@ -1434,7 +1434,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 		if (rc) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-				    "BG_%d : mgmt_reopen_session Failed");
+				    "BG", "mgmt_reopen_session Failed");
 			return rc;
 		}
 	} while (--boot_retry);
@@ -1442,7 +1442,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 	/* Couldn't log into the boot target */
 	beiscsi_log(phba, KERN_ERR,
 		    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-		    "BG_%d : Login to Boot Target Failed\n");
+		    "BG", "Login to Boot Target Failed\n");
 	return -ENXIO;
 }
 
@@ -1468,7 +1468,7 @@ int mgmt_set_vlan(struct beiscsi_hba *phba,
 	if (!tag) {
 		beiscsi_log(phba, KERN_ERR,
 			    (BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX),
-			    "BG_%d : VLAN Setting Failed\n");
+			    "BG", "VLAN Setting Failed\n");
 		return -EBUSY;
 	}
 
@@ -1476,7 +1476,7 @@ int mgmt_set_vlan(struct beiscsi_hba *phba,
 	if (rc) {
 		beiscsi_log(phba, KERN_ERR,
 			    (BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX),
-			    "BS_%d : VLAN MBX Cmd Failed\n");
+			    "BS", "VLAN MBX Cmd Failed\n");
 		return rc;
 	}
 	return rc;
@@ -1813,7 +1813,7 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *phba,
 
 	beiscsi_log(phba, KERN_INFO,
 		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-		    "BG_%d : In bescsi_logout_fwboot_sess\n");
+		    "BG", "In bescsi_logout_fwboot_sess\n");
 
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = alloc_mcc_wrb(phba, &tag);
@@ -1821,7 +1821,7 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *phba,
 		mutex_unlock(&ctrl->mbox_lock);
 		beiscsi_log(phba, KERN_INFO,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
-			    "BG_%d : MBX Tag Failure\n");
+			    "BG", "MBX Tag Failure\n");
 		return -EINVAL;
 	}
 
@@ -1840,7 +1840,7 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *phba,
 	if (rc) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BG_%d : MBX CMD FW_SESSION_LOGOUT_TARGET Failed\n");
+			    "BG", "MBX CMD FW_SESSION_LOGOUT_TARGET Failed\n");
 		return -EBUSY;
 	}
 
@@ -1849,7 +1849,7 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *phba,
 		BEISCSI_MGMT_SESSION_CLOSE) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-			    "BG_%d : FW_SESSION_LOGOUT_TARGET resp : 0x%x\n",
+			    "BG", "FW_SESSION_LOGOUT_TARGET resp : 0x%x\n",
 			    resp->session_status);
 		rc = -EINVAL;
 	}
-- 
2.8.0.rc4.16.g56331f8
