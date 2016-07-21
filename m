From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 06/28] be2iscsi: Fix gateway APIs to support IPv4 & IPv6
Date: Thu, 21 Jul 2016 14:37:43 +0530
Message-ID: <1469092085-14311-7-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37035 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbcGUJIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:08:43 -0400
Received: by mail-wm0-f45.google.com with SMTP id i5so16913573wmg.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:08:43 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Gateway APIs assume IP type as IPv4. Modify it to be generic to allow
clearing of IPv6 gateway set using BIOS.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   4 +-
 drivers/scsi/be2iscsi/be_mgmt.c  | 124 ++++++++++++++++++---------------------
 drivers/scsi/be2iscsi/be_mgmt.h  |   7 +--
 3 files changed, 62 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index eab0f4f..3ebfeff 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -419,7 +419,7 @@ beiscsi_set_ipv4(struct Scsi_Host *shost,
 		}
 		break;
 	case ISCSI_NET_PARAM_IPV4_GW:
-		ret = mgmt_set_gateway(phba, iface_param);
+		ret = beiscsi_if_set_gw(phba, BE2_IPV4, iface_param->value);
 		break;
 	case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
 		if (iface_param->value[0] == ISCSI_BOOTPROTO_DHCP)
@@ -635,7 +635,7 @@ int be2iscsi_iface_get_param(struct iscsi_iface *iface,
 		break;
 	case ISCSI_NET_PARAM_IPV4_GW:
 		memset(&gateway, 0, sizeof(gateway));
-		len = mgmt_get_gateway(phba, BE2_IPV4, &gateway);
+		len = beiscsi_if_get_gw(phba, BE2_IPV4, &gateway);
 		if (!len)
 			len = sprintf(buf, "%pI4\n", &gateway.ip_addr.addr);
 		break;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 83926e2..9ef9f76 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1059,14 +1059,13 @@ mgmt_static_ip_modify(struct beiscsi_hba *phba,
 	return rc;
 }
 
-static int mgmt_modify_gateway(struct beiscsi_hba *phba, uint8_t *gt_addr,
-			       uint32_t gtway_action, uint32_t param_len)
+static int beiscsi_if_mod_gw(struct beiscsi_hba *phba,
+			     u32 action, u32 ip_type, u8 *gw)
 {
 	struct be_cmd_set_def_gateway_req *req;
 	struct be_dma_mem nonemb_cmd;
 	int rt_val;
 
-
 	rt_val = mgmt_alloc_cmd_data(phba, &nonemb_cmd,
 				OPCODE_COMMON_ISCSI_NTWK_MODIFY_DEFAULT_GATEWAY,
 				sizeof(*req));
@@ -1074,12 +1073,60 @@ static int mgmt_modify_gateway(struct beiscsi_hba *phba, uint8_t *gt_addr,
 		return rt_val;
 
 	req = nonemb_cmd.va;
-	req->action = gtway_action;
-	req->ip_addr.ip_type = BE2_IPV4;
+	req->action = action;
+	req->ip_addr.ip_type = ip_type;
+	memcpy(req->ip_addr.addr, gw,
+	       (ip_type == BE2_IPV4) ? IP_V4_LEN : IP_V6_LEN);
+	return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
+}
 
-	memcpy(req->ip_addr.addr, gt_addr, sizeof(req->ip_addr.addr));
+int beiscsi_if_set_gw(struct beiscsi_hba *phba, u32 ip_type, u8 *gw)
+{
+	struct be_cmd_get_def_gateway_resp gw_resp;
+	int rt_val;
 
-	return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
+	memset(&gw_resp, 0, sizeof(gw_resp));
+	rt_val = beiscsi_if_get_gw(phba, ip_type, &gw_resp);
+	if (rt_val) {
+		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
+			    "BG_%d : Failed to Get Gateway Addr\n");
+		return rt_val;
+	}
+
+	rt_val = beiscsi_if_mod_gw(phba, IP_ACTION_DEL, ip_type,
+				   gw_resp.ip_addr.addr);
+	if (rt_val) {
+		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
+				"BG_%d : Failed to clear Gateway Addr Set\n");
+		return rt_val;
+	}
+
+	rt_val = beiscsi_if_mod_gw(phba, IP_ACTION_ADD, ip_type, gw);
+	if (rt_val)
+		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
+			    "BG_%d : Failed to Set Gateway Addr\n");
+
+	return rt_val;
+}
+
+int beiscsi_if_get_gw(struct beiscsi_hba *phba, u32 ip_type,
+		      struct be_cmd_get_def_gateway_resp *resp)
+{
+	struct be_cmd_get_def_gateway_req *req;
+	struct be_dma_mem nonemb_cmd;
+	int rc;
+
+	rc = mgmt_alloc_cmd_data(phba, &nonemb_cmd,
+				 OPCODE_COMMON_ISCSI_NTWK_GET_DEFAULT_GATEWAY,
+				 sizeof(*resp));
+	if (rc)
+		return rc;
+
+	req = nonemb_cmd.va;
+	req->ip_type = ip_type;
+
+	return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, resp,
+				    sizeof(*resp));
 }
 
 int mgmt_set_ip(struct beiscsi_hba *phba,
@@ -1156,7 +1203,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 	/* Delete the Gateway settings if mode change is to DHCP */
 	if (boot_proto == ISCSI_BOOTPROTO_DHCP) {
 		memset(&gtway_addr_set, 0, sizeof(gtway_addr_set));
-		rc = mgmt_get_gateway(phba, BE2_IPV4, &gtway_addr_set);
+		rc = beiscsi_if_get_gw(phba, BE2_IPV4, &gtway_addr_set);
 		if (rc) {
 			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
 				    "BG_%d : Failed to Get Gateway Addr\n");
@@ -1165,8 +1212,8 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 
 		if (gtway_addr_set.ip_addr.addr[0]) {
 			gtway_addr = (uint8_t *)&gtway_addr_set.ip_addr.addr;
-			rc = mgmt_modify_gateway(phba, gtway_addr,
-						 IP_ACTION_DEL, IP_V4_LEN);
+			rc = beiscsi_if_mod_gw(phba, IP_ACTION_DEL,
+					       ip_type, gtway_addr);
 
 			if (rc) {
 				beiscsi_log(phba, KERN_WARNING,
@@ -1202,63 +1249,6 @@ exit:
 	return rc;
 }
 
-int mgmt_set_gateway(struct beiscsi_hba *phba,
-		     struct iscsi_iface_param_info *gateway_param)
-{
-	struct be_cmd_get_def_gateway_resp gtway_addr_set;
-	uint8_t *gtway_addr;
-	int rt_val;
-
-	memset(&gtway_addr_set, 0, sizeof(gtway_addr_set));
-	rt_val = mgmt_get_gateway(phba, BE2_IPV4, &gtway_addr_set);
-	if (rt_val) {
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG_%d : Failed to Get Gateway Addr\n");
-		return rt_val;
-	}
-
-	if (gtway_addr_set.ip_addr.addr[0]) {
-		gtway_addr = (uint8_t *)&gtway_addr_set.ip_addr.addr;
-		rt_val = mgmt_modify_gateway(phba, gtway_addr, IP_ACTION_DEL,
-					     gateway_param->len);
-		if (rt_val) {
-			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-				    "BG_%d : Failed to clear Gateway Addr Set\n");
-			return rt_val;
-		}
-	}
-
-	gtway_addr = (uint8_t *)&gateway_param->value;
-	rt_val = mgmt_modify_gateway(phba, gtway_addr, IP_ACTION_ADD,
-				     gateway_param->len);
-
-	if (rt_val)
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-			    "BG_%d : Failed to Set Gateway Addr\n");
-
-	return rt_val;
-}
-
-int mgmt_get_gateway(struct beiscsi_hba *phba, int ip_type,
-		     struct be_cmd_get_def_gateway_resp *gateway)
-{
-	struct be_cmd_get_def_gateway_req *req;
-	struct be_dma_mem nonemb_cmd;
-	int rc;
-
-	rc = mgmt_alloc_cmd_data(phba, &nonemb_cmd,
-				 OPCODE_COMMON_ISCSI_NTWK_GET_DEFAULT_GATEWAY,
-				 sizeof(*gateway));
-	if (rc)
-		return rc;
-
-	req = nonemb_cmd.va;
-	req->ip_type = ip_type;
-
-	return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, gateway,
-				    sizeof(*gateway));
-}
-
 int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
 		     struct be_cmd_get_if_info_resp **if_info)
 {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index f3a48a0..fd9b68f 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -298,11 +298,10 @@ int mgmt_get_nic_conf(struct beiscsi_hba *phba,
 int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
 		     struct be_cmd_get_if_info_resp **if_info);
 
-int mgmt_get_gateway(struct beiscsi_hba *phba, int ip_type,
-		     struct be_cmd_get_def_gateway_resp *gateway);
+int beiscsi_if_get_gw(struct beiscsi_hba *phba, u32 ip_type,
+		      struct be_cmd_get_def_gateway_resp *resp);
 
-int mgmt_set_gateway(struct beiscsi_hba *phba,
-		     struct iscsi_iface_param_info *gateway_param);
+int beiscsi_if_set_gw(struct beiscsi_hba *phba, u32 ip_type, u8 *gw);
 
 int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 			      unsigned int *s_handle);
-- 
1.9.1

