From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 19/23] be2iscsi: Fix Insufficient Buffer Error returned in MBX Completion
Date: Sat, 28 Sep 2013 15:35:56 -0700
Message-ID: <1380407761-2949-19-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36057 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3I1Wgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:50 -0400
Received: by mail-pd0-f169.google.com with SMTP id r10so4068537pdi.0
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:49 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 When MBX_Cmd completion happens with error code Insufficient Buffer,
 the MBX_Cmd is posted again with the new buffer size posted by FW.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |   20 ++++++---
 drivers/scsi/be2iscsi/be_iscsi.c |   37 +++++++++--------
 drivers/scsi/be2iscsi/be_mgmt.c  |   83 ++++++++++++++++++++++++++++----------
 drivers/scsi/be2iscsi/be_mgmt.h  |    2 +-
 4 files changed, 99 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index cc37a4e..fce298b 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -158,8 +158,10 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 	struct be_cmd_resp_hdr *ioctl_resp_hdr;
 	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
 
-	if (beiscsi_error(phba))
+	if (beiscsi_error(phba)) {
+		free_mcc_tag(&phba->ctrl, tag);
 		return -EIO;
+	}
 
 	/* wait for the mccq completion */
 	rc = wait_event_interruptible_timeout(
@@ -173,7 +175,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
 			    BEISCSI_LOG_CONFIG,
 			    "BC_%d : MBX Cmd Completion timed out\n");
-		rc = -EAGAIN;
+		rc = -EBUSY;
 
 		/* decrement the mccq used count */
 		atomic_dec(&phba->ctrl.mcc_obj.q.used);
@@ -212,10 +214,18 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 
 		if (status == MCC_STATUS_INSUFFICIENT_BUFFER) {
 			ioctl_resp_hdr = (struct be_cmd_resp_hdr *) ioctl_hdr;
-			if (ioctl_resp_hdr->response_length)
-				goto release_mcc_tag;
+			beiscsi_log(phba, KERN_WARNING,
+				    BEISCSI_LOG_INIT | BEISCSI_LOG_EH |
+				    BEISCSI_LOG_CONFIG,
+				    "BC_%d : Insufficent Buffer Error "
+				    "Resp_Len : %d Actual_Resp_Len : %d\n",
+				    ioctl_resp_hdr->response_length,
+				    ioctl_resp_hdr->actual_resp_len);
+
+			rc = -EAGAIN;
+			goto release_mcc_tag;
 		}
-		rc = -EAGAIN;
+		rc = -EIO;
 	}
 
 release_mcc_tag:
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a7cd92c..e82ab81 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -271,13 +271,17 @@ static int beiscsi_create_ipv6_iface(struct beiscsi_hba *phba)
 
 void beiscsi_create_def_ifaces(struct beiscsi_hba *phba)
 {
-	struct be_cmd_get_if_info_resp if_info;
+	struct be_cmd_get_if_info_resp *if_info;
 
-	if (!mgmt_get_if_info(phba, BE2_IPV4, &if_info))
+	if (!mgmt_get_if_info(phba, BE2_IPV4, &if_info)) {
 		beiscsi_create_ipv4_iface(phba);
+		kfree(if_info);
+	}
 
-	if (!mgmt_get_if_info(phba, BE2_IPV6, &if_info))
+	if (!mgmt_get_if_info(phba, BE2_IPV6, &if_info)) {
 		beiscsi_create_ipv6_iface(phba);
+		kfree(if_info);
+	}
 }
 
 void beiscsi_destroy_def_ifaces(struct beiscsi_hba *phba)
@@ -518,59 +522,60 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		struct iscsi_iface *iface, int param,
 		char *buf)
 {
-	struct be_cmd_get_if_info_resp if_info;
+	struct be_cmd_get_if_info_resp *if_info;
 	int len, ip_type = BE2_IPV4;
 
-	memset(&if_info, 0, sizeof(if_info));
-
 	if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
 		ip_type = BE2_IPV6;
 
 	len = mgmt_get_if_info(phba, ip_type, &if_info);
-	if (len)
+	if (len) {
+		kfree(if_info);
 		return len;
+	}
 
 	switch (param) {
 	case ISCSI_NET_PARAM_IPV4_ADDR:
-		len = sprintf(buf, "%pI4\n", &if_info.ip_addr.addr);
+		len = sprintf(buf, "%pI4\n", if_info->ip_addr.addr);
 		break;
 	case ISCSI_NET_PARAM_IPV6_ADDR:
-		len = sprintf(buf, "%pI6\n", &if_info.ip_addr.addr);
+		len = sprintf(buf, "%pI6\n", if_info->ip_addr.addr);
 		break;
 	case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
-		if (!if_info.dhcp_state)
+		if (!if_info->dhcp_state)
 			len = sprintf(buf, "static\n");
 		else
 			len = sprintf(buf, "dhcp\n");
 		break;
 	case ISCSI_NET_PARAM_IPV4_SUBNET:
-		len = sprintf(buf, "%pI4\n", &if_info.ip_addr.subnet_mask);
+		len = sprintf(buf, "%pI4\n", if_info->ip_addr.subnet_mask);
 		break;
 	case ISCSI_NET_PARAM_VLAN_ENABLED:
 		len = sprintf(buf, "%s\n",
-			     (if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
+			     (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
 			     ? "Disabled\n" : "Enabled\n");
 		break;
 	case ISCSI_NET_PARAM_VLAN_ID:
-		if (if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
+		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
 			return -EINVAL;
 		else
 			len = sprintf(buf, "%d\n",
-				     (if_info.vlan_priority &
+				     (if_info->vlan_priority &
 				     ISCSI_MAX_VLAN_ID));
 		break;
 	case ISCSI_NET_PARAM_VLAN_PRIORITY:
-		if (if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
+		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
 			return -EINVAL;
 		else
 			len = sprintf(buf, "%d\n",
-				     ((if_info.vlan_priority >> 13) &
+				     ((if_info->vlan_priority >> 13) &
 				     ISCSI_MAX_VLAN_PRIORITY));
 		break;
 	default:
 		WARN_ON(1);
 	}
 
+	kfree(if_info);
 	return len;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index befeace..1f2b546 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -824,11 +824,14 @@ static int mgmt_exec_nonemb_cmd(struct beiscsi_hba *phba,
 
 	rc = beiscsi_mccq_compl(phba, tag, NULL, nonemb_cmd->va);
 	if (rc) {
+		/* Check if the IOCTL needs to be re-issued */
+		if (rc == -EAGAIN)
+			return rc;
+
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
 			    "BG_%d : mgmt_exec_nonemb_cmd Failed status\n");
 
-		rc = -EIO;
 		goto free_cmd;
 	}
 
@@ -937,7 +940,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 		uint32_t boot_proto)
 {
 	struct be_cmd_get_def_gateway_resp gtway_addr_set;
-	struct be_cmd_get_if_info_resp if_info;
+	struct be_cmd_get_if_info_resp *if_info;
 	struct be_cmd_set_dhcp_req *dhcpreq;
 	struct be_cmd_rel_dhcp_req *reldhcp;
 	struct be_dma_mem nonemb_cmd;
@@ -948,16 +951,17 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 	if (mgmt_get_all_if_id(phba))
 		return -EIO;
 
-	memset(&if_info, 0, sizeof(if_info));
 	ip_type = (ip_param->param == ISCSI_NET_PARAM_IPV6_ADDR) ?
 		BE2_IPV6 : BE2_IPV4 ;
 
 	rc = mgmt_get_if_info(phba, ip_type, &if_info);
-	if (rc)
+	if (rc) {
+		kfree(if_info);
 		return rc;
+	}
 
 	if (boot_proto == ISCSI_BOOTPROTO_DHCP) {
-		if (if_info.dhcp_state) {
+		if (if_info->dhcp_state) {
 			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
 				    "BG_%d : DHCP Already Enabled\n");
 			return 0;
@@ -970,9 +974,9 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 				IP_V6_LEN : IP_V4_LEN;
 
 	} else {
-		if (if_info.dhcp_state) {
+		if (if_info->dhcp_state) {
 
-			memset(&if_info, 0, sizeof(if_info));
+			memset(if_info, 0, sizeof(*if_info));
 			rc = mgmt_alloc_cmd_data(phba, &nonemb_cmd,
 				OPCODE_COMMON_ISCSI_NTWK_REL_STATELESS_IP_ADDR,
 				sizeof(*reldhcp));
@@ -995,8 +999,8 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 	}
 
 	/* Delete the Static IP Set */
-	if (if_info.ip_addr.addr[0]) {
-		rc = mgmt_static_ip_modify(phba, &if_info, ip_param, NULL,
+	if (if_info->ip_addr.addr[0]) {
+		rc = mgmt_static_ip_modify(phba, if_info, ip_param, NULL,
 					   IP_ACTION_DEL);
 		if (rc)
 			return rc;
@@ -1042,7 +1046,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 
 		return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
 	} else {
-		return mgmt_static_ip_modify(phba, &if_info, ip_param,
+		return mgmt_static_ip_modify(phba, if_info, ip_param,
 					     subnet_param, IP_ACTION_ADD);
 	}
 
@@ -1107,27 +1111,64 @@ int mgmt_get_gateway(struct beiscsi_hba *phba, int ip_type,
 }
 
 int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
-		     struct be_cmd_get_if_info_resp *if_info)
+		     struct be_cmd_get_if_info_resp **if_info)
 {
 	struct be_cmd_get_if_info_req *req;
 	struct be_dma_mem nonemb_cmd;
+	uint32_t ioctl_size = sizeof(struct be_cmd_get_if_info_resp);
 	int rc;
 
 	if (mgmt_get_all_if_id(phba))
 		return -EIO;
 
-	rc = mgmt_alloc_cmd_data(phba, &nonemb_cmd,
-				 OPCODE_COMMON_ISCSI_NTWK_GET_IF_INFO,
-				 sizeof(*if_info));
-	if (rc)
-		return rc;
+	do {
+		rc = mgmt_alloc_cmd_data(phba, &nonemb_cmd,
+					 OPCODE_COMMON_ISCSI_NTWK_GET_IF_INFO,
+					 ioctl_size);
+		if (rc)
+			return rc;
 
-	req = nonemb_cmd.va;
-	req->interface_hndl = phba->interface_handle;
-	req->ip_type = ip_type;
+		req = nonemb_cmd.va;
+		req->interface_hndl = phba->interface_handle;
+		req->ip_type = ip_type;
+
+		/* Allocate memory for if_info */
+		*if_info = kzalloc(ioctl_size, GFP_KERNEL);
+		if (!*if_info) {
+			beiscsi_log(phba, KERN_ERR,
+				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+				    "BG_%d : Memory Allocation Failure\n");
+
+				/* Free the DMA memory for the IOCTL issuing */
+				pci_free_consistent(phba->ctrl.pdev,
+						    nonemb_cmd.size,
+						    nonemb_cmd.va,
+						    nonemb_cmd.dma);
+				return -ENOMEM;
+		}
 
-	return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, if_info,
-				    sizeof(*if_info));
+		rc =  mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, *if_info,
+					   ioctl_size);
+
+		/* Check if the error is because of Insufficent_Buffer */
+		if (rc == -EAGAIN) {
+
+			/* Get the new memory size */
+			ioctl_size = ((struct be_cmd_resp_hdr *)
+				      nonemb_cmd.va)->actual_resp_len;
+			ioctl_size += sizeof(struct be_cmd_req_hdr);
+
+			/* Free the previous allocated DMA memory */
+			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
+					    nonemb_cmd.va,
+					    nonemb_cmd.dma);
+
+			/* Free the virtual memory */
+			kfree(*if_info);
+		} else
+			break;
+	} while (true);
+	return rc;
 }
 
 int mgmt_get_nic_conf(struct beiscsi_hba *phba,
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 645e144..01b8c97 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -294,7 +294,7 @@ int mgmt_get_nic_conf(struct beiscsi_hba *phba,
 		      struct be_cmd_get_nic_conf_resp *mac);
 
 int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
-		     struct be_cmd_get_if_info_resp *if_info);
+		     struct be_cmd_get_if_info_resp **if_info);
 
 int mgmt_get_gateway(struct beiscsi_hba *phba, int ip_type,
 		     struct be_cmd_get_def_gateway_resp *gateway);
-- 
1.7.10.4

