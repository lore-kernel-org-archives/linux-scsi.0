From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 10/28] be2iscsi: Rename iface get/set/create/destroy APIs
Date: Thu, 21 Jul 2016 14:37:47 +0530
Message-ID: <1469092085-14311-11-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37183 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbcGUJIz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:08:55 -0400
Received: by mail-wm0-f41.google.com with SMTP id i5so16920272wmg.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:08:55 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Rename mgmt_get_if_info to be consistent with APIs name.
Rename create/destroy APIs to indicate IFACE operations.
Remove legacy be2iscsi and use beiscsi.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 42 ++++++++++++++++++++--------------------
 drivers/scsi/be2iscsi/be_iscsi.h | 10 +++++-----
 drivers/scsi/be2iscsi/be_main.c  | 10 +++++-----
 drivers/scsi/be2iscsi/be_mgmt.c  |  8 ++++----
 drivers/scsi/be2iscsi/be_mgmt.h  |  4 ++--
 5 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 1418d6b..1fe273d 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -237,7 +237,7 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	return beiscsi_bindconn_cid(phba, beiscsi_conn, beiscsi_ep->ep_cid);
 }
 
-static int beiscsi_create_ipv4_iface(struct beiscsi_hba *phba)
+static int beiscsi_iface_create_ipv4(struct beiscsi_hba *phba)
 {
 	if (phba->ipv4_iface)
 		return 0;
@@ -256,7 +256,7 @@ static int beiscsi_create_ipv4_iface(struct beiscsi_hba *phba)
 	return 0;
 }
 
-static int beiscsi_create_ipv6_iface(struct beiscsi_hba *phba)
+static int beiscsi_iface_create_ipv6(struct beiscsi_hba *phba)
 {
 	if (phba->ipv6_iface)
 		return 0;
@@ -275,22 +275,22 @@ static int beiscsi_create_ipv6_iface(struct beiscsi_hba *phba)
 	return 0;
 }
 
-void beiscsi_create_def_ifaces(struct beiscsi_hba *phba)
+void beiscsi_iface_create_default(struct beiscsi_hba *phba)
 {
 	struct be_cmd_get_if_info_resp *if_info;
 
-	if (!mgmt_get_if_info(phba, BE2_IPV4, &if_info)) {
-		beiscsi_create_ipv4_iface(phba);
+	if (!beiscsi_if_get_info(phba, BE2_IPV4, &if_info)) {
+		beiscsi_iface_create_ipv4(phba);
 		kfree(if_info);
 	}
 
-	if (!mgmt_get_if_info(phba, BE2_IPV6, &if_info)) {
-		beiscsi_create_ipv6_iface(phba);
+	if (!beiscsi_if_get_info(phba, BE2_IPV6, &if_info)) {
+		beiscsi_iface_create_ipv6(phba);
 		kfree(if_info);
 	}
 }
 
-void beiscsi_destroy_def_ifaces(struct beiscsi_hba *phba)
+void beiscsi_iface_destroy_default(struct beiscsi_hba *phba)
 {
 	if (phba->ipv6_iface) {
 		iscsi_destroy_iface(phba->ipv6_iface);
@@ -350,7 +350,7 @@ beiscsi_iface_config_ipv4(struct Scsi_Host *shost,
 	switch (info->param) {
 	case ISCSI_NET_PARAM_IFACE_ENABLE:
 		if (info->value[0] == ISCSI_IFACE_ENABLE)
-			ret = beiscsi_create_ipv4_iface(phba);
+			ret = beiscsi_iface_create_ipv4(phba);
 		else {
 			iscsi_destroy_iface(phba->ipv4_iface);
 			phba->ipv4_iface = NULL;
@@ -409,7 +409,7 @@ beiscsi_iface_config_ipv6(struct Scsi_Host *shost,
 	switch (iface_param->param) {
 	case ISCSI_NET_PARAM_IFACE_ENABLE:
 		if (iface_param->value[0] == ISCSI_IFACE_ENABLE)
-			ret = beiscsi_create_ipv6_iface(phba);
+			ret = beiscsi_iface_create_ipv6(phba);
 		else {
 			iscsi_destroy_iface(phba->ipv6_iface);
 			phba->ipv6_iface = NULL;
@@ -424,8 +424,8 @@ beiscsi_iface_config_ipv6(struct Scsi_Host *shost,
 	return ret;
 }
 
-int be2iscsi_iface_set_param(struct Scsi_Host *shost,
-		void *data, uint32_t dt_len)
+int beiscsi_iface_set_param(struct Scsi_Host *shost,
+			    void *data, uint32_t dt_len)
 {
 	struct iscsi_iface_param_info *iface_param = NULL;
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
@@ -506,9 +506,9 @@ int be2iscsi_iface_set_param(struct Scsi_Host *shost,
 	return ret;
 }
 
-static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
-		struct iscsi_iface *iface, int param,
-		char *buf)
+static int __beiscsi_iface_get_param(struct beiscsi_hba *phba,
+				     struct iscsi_iface *iface,
+				     int param, char *buf)
 {
 	struct be_cmd_get_if_info_resp *if_info;
 	int len, ip_type = BE2_IPV4;
@@ -516,7 +516,7 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 	if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
 		ip_type = BE2_IPV6;
 
-	len = mgmt_get_if_info(phba, ip_type, &if_info);
+	len = beiscsi_if_get_info(phba, ip_type, &if_info);
 	if (len)
 		return len;
 
@@ -565,9 +565,9 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 	return len;
 }
 
-int be2iscsi_iface_get_param(struct iscsi_iface *iface,
-		enum iscsi_param_type param_type,
-		int param, char *buf)
+int beiscsi_iface_get_param(struct iscsi_iface *iface,
+			    enum iscsi_param_type param_type,
+			    int param, char *buf)
 {
 	struct Scsi_Host *shost = iscsi_iface_to_shost(iface);
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
@@ -588,7 +588,7 @@ int be2iscsi_iface_get_param(struct iscsi_iface *iface,
 	case ISCSI_NET_PARAM_VLAN_ENABLED:
 	case ISCSI_NET_PARAM_VLAN_ID:
 	case ISCSI_NET_PARAM_VLAN_PRIORITY:
-		len = be2iscsi_get_if_param(phba, iface, param, buf);
+		len = __beiscsi_iface_get_param(phba, iface, param, buf);
 		break;
 	case ISCSI_NET_PARAM_IFACE_ENABLE:
 		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
@@ -1360,7 +1360,7 @@ free_ep:
 	iscsi_destroy_endpoint(beiscsi_ep->openiscsi_ep);
 }
 
-umode_t be2iscsi_attr_is_visible(int param_type, int param)
+umode_t beiscsi_attr_is_visible(int param_type, int param)
 {
 	switch (param_type) {
 	case ISCSI_NET_PARAM:
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 0c84e1c..5928ba9 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -30,18 +30,18 @@
 #define NON_BLOCKING 0x0
 #define BLOCKING 0x1
 
-void beiscsi_create_def_ifaces(struct beiscsi_hba *phba);
+void beiscsi_iface_create_default(struct beiscsi_hba *phba);
 
-void beiscsi_destroy_def_ifaces(struct beiscsi_hba *phba);
+void beiscsi_iface_destroy_default(struct beiscsi_hba *phba);
 
-int be2iscsi_iface_get_param(struct iscsi_iface *iface,
+int beiscsi_iface_get_param(struct iscsi_iface *iface,
 			     enum iscsi_param_type param_type,
 			     int param, char *buf);
 
-int be2iscsi_iface_set_param(struct Scsi_Host *shost,
+int beiscsi_iface_set_param(struct Scsi_Host *shost,
 			     void *data, uint32_t count);
 
-umode_t be2iscsi_attr_is_visible(int param_type, int param);
+umode_t beiscsi_attr_is_visible(int param_type, int param);
 
 void beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 				struct beiscsi_offload_params *params);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 6763883..92287ad 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5336,7 +5336,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 		return;
 	}
 
-	beiscsi_destroy_def_ifaces(phba);
+	beiscsi_iface_destroy_default(phba);
 	iscsi_boot_destroy_kset(phba->boot_kset);
 	iscsi_host_remove(phba->shost);
 	beiscsi_quiesce(phba, BEISCSI_CLEAN_UNLOAD);
@@ -5786,7 +5786,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 			    "BM_%d : Could not set up "
 			    "iSCSI boot info.\n");
 
-	beiscsi_create_def_ifaces(phba);
+	beiscsi_iface_create_default(phba);
 	schedule_delayed_work(&phba->beiscsi_hw_check_task,
 			      msecs_to_jiffies(1000));
 
@@ -5837,9 +5837,9 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.create_conn = beiscsi_conn_create,
 	.bind_conn = beiscsi_conn_bind,
 	.destroy_conn = iscsi_conn_teardown,
-	.attr_is_visible = be2iscsi_attr_is_visible,
-	.set_iface_param = be2iscsi_iface_set_param,
-	.get_iface_param = be2iscsi_iface_get_param,
+	.attr_is_visible = beiscsi_attr_is_visible,
+	.set_iface_param = beiscsi_iface_set_param,
+	.get_iface_param = beiscsi_iface_get_param,
 	.set_param = beiscsi_set_param,
 	.get_conn_param = iscsi_conn_get_param,
 	.get_session_param = iscsi_session_get_param,
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index fa95525..8d05add 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1167,7 +1167,7 @@ int beiscsi_if_en_static(struct beiscsi_hba *phba, u32 ip_type,
 	struct be_dma_mem nonemb_cmd;
 	int rc;
 
-	rc = mgmt_get_if_info(phba, ip_type, &if_info);
+	rc = beiscsi_if_get_info(phba, ip_type, &if_info);
 	if (rc)
 		return rc;
 
@@ -1212,7 +1212,7 @@ int beiscsi_if_en_dhcp(struct beiscsi_hba *phba, u32 ip_type)
 	u8 *gw;
 	int rc;
 
-	rc = mgmt_get_if_info(phba, ip_type, &if_info);
+	rc = beiscsi_if_get_info(phba, ip_type, &if_info);
 	if (rc)
 		return rc;
 
@@ -1299,8 +1299,8 @@ int beiscsi_if_set_vlan(struct beiscsi_hba *phba, uint16_t vlan_tag)
 }
 
 
-int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
-		     struct be_cmd_get_if_info_resp **if_info)
+int beiscsi_if_get_info(struct beiscsi_hba *phba, int ip_type,
+			struct be_cmd_get_if_info_resp **if_info)
 {
 	struct be_cmd_get_if_info_req *req;
 	struct be_dma_mem nonemb_cmd;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 8ae6a24..294b740 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -295,8 +295,8 @@ unsigned int mgmt_get_session_info(struct beiscsi_hba *phba,
 int mgmt_get_nic_conf(struct beiscsi_hba *phba,
 		      struct be_cmd_get_nic_conf_resp *mac);
 
-int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
-		     struct be_cmd_get_if_info_resp **if_info);
+int beiscsi_if_get_info(struct beiscsi_hba *phba, int ip_type,
+			struct be_cmd_get_if_info_resp **if_info);
 
 int beiscsi_if_get_gw(struct beiscsi_hba *phba, u32 ip_type,
 		      struct be_cmd_get_def_gateway_resp *resp);
-- 
1.9.1

