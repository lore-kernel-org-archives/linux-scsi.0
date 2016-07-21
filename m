From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 01/28] be2iscsi: Fix to use correct configuration values
Date: Thu, 21 Jul 2016 14:37:38 +0530
Message-ID: <1469092085-14311-2-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35330 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbcGUJI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:08:29 -0400
Received: by mail-wm0-f42.google.com with SMTP id f65so14832546wmi.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:08:28 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Following configuration is created with what driver exports:
iface.vlan_id = 65535
iface.vlan_priority = 255
iface.vlan_state = <empty>

vlan_state is empty as iscsiadm doesn't process "Disabled".
When applying this configuration, iscsiadm checks for if vlan_state is
"disable" if not it enables with value in vlan_id. 65535 not being valid
value, 0 is applied.

Use "enable" or "disable" for ISCSI_NET_PARAM.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 09f89a3..ab696ec 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -567,8 +567,8 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		break;
 	case ISCSI_NET_PARAM_VLAN_ENABLED:
 		len = sprintf(buf, "%s\n",
-			     (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
-			     ? "Disabled\n" : "Enabled\n");
+			      (if_info->vlan_priority == BEISCSI_VLAN_DISABLE) ?
+			      "disable" : "enable");
 		break;
 	case ISCSI_NET_PARAM_VLAN_ID:
 		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
@@ -620,7 +620,7 @@ int be2iscsi_iface_get_param(struct iscsi_iface *iface,
 		len = be2iscsi_get_if_param(phba, iface, param, buf);
 		break;
 	case ISCSI_NET_PARAM_IFACE_ENABLE:
-		len = sprintf(buf, "enabled\n");
+		len = sprintf(buf, "enable\n");
 		break;
 	case ISCSI_NET_PARAM_IPV4_GW:
 		memset(&gateway, 0, sizeof(gateway));
-- 
1.9.1

