From: "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] scsi: be_iscsi: fix possible memory leak and refactor code
Date: Sun, 17 Nov 2013 15:51:24 -0300
Message-ID: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:54173 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3KQS4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Nov 2013 13:56:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: geyslan@gmail.com
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VLAN_ID' and
'ISCSI_NET_PARAM_VLAN_PRIORITY' and refactors code 'going out' when
necessary.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 41 +++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index ffadbee..7e909dc 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -535,51 +535,53 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		char *buf)
 {
 	struct be_cmd_get_if_info_resp *if_info;
-	int len, ip_type = BE2_IPV4;
+	int ret, ip_type = BE2_IPV4;
 
 	if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
 		ip_type = BE2_IPV6;
 
-	len = mgmt_get_if_info(phba, ip_type, &if_info);
-	if (len) {
-		kfree(if_info);
-		return len;
-	}
+	ret = mgmt_get_if_info(phba, ip_type, &if_info);
+	if (ret)
+		goto out;
 
 	switch (param) {
 	case ISCSI_NET_PARAM_IPV4_ADDR:
-		len = sprintf(buf, "%pI4\n", if_info->ip_addr.addr);
+		ret = sprintf(buf, "%pI4\n", if_info->ip_addr.addr);
 		break;
 	case ISCSI_NET_PARAM_IPV6_ADDR:
-		len = sprintf(buf, "%pI6\n", if_info->ip_addr.addr);
+		ret = sprintf(buf, "%pI6\n", if_info->ip_addr.addr);
 		break;
 	case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
 		if (!if_info->dhcp_state)
-			len = sprintf(buf, "static\n");
+			ret = sprintf(buf, "static\n");
 		else
-			len = sprintf(buf, "dhcp\n");
+			ret = sprintf(buf, "dhcp\n");
 		break;
 	case ISCSI_NET_PARAM_IPV4_SUBNET:
-		len = sprintf(buf, "%pI4\n", if_info->ip_addr.subnet_mask);
+		ret = sprintf(buf, "%pI4\n", if_info->ip_addr.subnet_mask);
 		break;
 	case ISCSI_NET_PARAM_VLAN_ENABLED:
-		len = sprintf(buf, "%s\n",
+		ret = sprintf(buf, "%s\n",
 			     (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
 			     ? "Disabled\n" : "Enabled\n");
 		break;
 	case ISCSI_NET_PARAM_VLAN_ID:
-		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
-			return -EINVAL;
+		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE) {
+			ret = -EINVAL;
+			goto out;
+		}
 		else
-			len = sprintf(buf, "%d\n",
+			ret = sprintf(buf, "%d\n",
 				     (if_info->vlan_priority &
 				     ISCSI_MAX_VLAN_ID));
 		break;
 	case ISCSI_NET_PARAM_VLAN_PRIORITY:
-		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
-			return -EINVAL;
+		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE) {
+			ret = -EINVAL;
+			goto out;
+		}
 		else
-			len = sprintf(buf, "%d\n",
+			ret = sprintf(buf, "%d\n",
 				     ((if_info->vlan_priority >> 13) &
 				     ISCSI_MAX_VLAN_PRIORITY));
 		break;
@@ -587,8 +589,9 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		WARN_ON(1);
 	}
 
+out:
 	kfree(if_info);
-	return len;
+	return ret;
 }
 
 int be2iscsi_iface_get_param(struct iscsi_iface *iface,
-- 
1.8.4.2

