From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 05/28] be2iscsi: Set and return right iface v4/v6 states
Date: Thu, 21 Jul 2016 14:37:42 +0530
Message-ID: <1469092085-14311-6-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34608 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbcGUJIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:08:40 -0400
Received: by mail-wm0-f52.google.com with SMTP id q128so2347948wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:08:40 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

ipv4_iface and ipv6_iface fields need to be set to NULL when destroyed.
Before creation these are checked. Use these to report correct states.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index ab696ec..eab0f4f 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -292,10 +292,14 @@ void beiscsi_create_def_ifaces(struct beiscsi_hba *phba)
 
 void beiscsi_destroy_def_ifaces(struct beiscsi_hba *phba)
 {
-	if (phba->ipv6_iface)
+	if (phba->ipv6_iface) {
 		iscsi_destroy_iface(phba->ipv6_iface);
-	if (phba->ipv4_iface)
+		phba->ipv6_iface = NULL;
+	}
+	if (phba->ipv4_iface) {
 		iscsi_destroy_iface(phba->ipv4_iface);
+		phba->ipv4_iface = NULL;
+	}
 }
 
 static int
@@ -406,6 +410,14 @@ beiscsi_set_ipv4(struct Scsi_Host *shost,
 
 	/* Check the param */
 	switch (iface_param->param) {
+	case ISCSI_NET_PARAM_IFACE_ENABLE:
+		if (iface_param->value[0] == ISCSI_IFACE_ENABLE)
+			ret = beiscsi_create_ipv4_iface(phba);
+		else {
+			iscsi_destroy_iface(phba->ipv4_iface);
+			phba->ipv4_iface = NULL;
+		}
+		break;
 	case ISCSI_NET_PARAM_IPV4_GW:
 		ret = mgmt_set_gateway(phba, iface_param);
 		break;
@@ -421,12 +433,6 @@ beiscsi_set_ipv4(struct Scsi_Host *shost,
 				    "BS_%d : Invalid BOOTPROTO: %d\n",
 				    iface_param->value[0]);
 		break;
-	case ISCSI_NET_PARAM_IFACE_ENABLE:
-		if (iface_param->value[0] == ISCSI_IFACE_ENABLE)
-			ret = beiscsi_create_ipv4_iface(phba);
-		else
-			iscsi_destroy_iface(phba->ipv4_iface);
-		break;
 	case ISCSI_NET_PARAM_IPV4_SUBNET:
 	case ISCSI_NET_PARAM_IPV4_ADDR:
 		ret = beiscsi_set_static_ip(shost, iface_param,
@@ -459,7 +465,7 @@ beiscsi_set_ipv6(struct Scsi_Host *shost,
 			ret = beiscsi_create_ipv6_iface(phba);
 		else {
 			iscsi_destroy_iface(phba->ipv6_iface);
-			ret = 0;
+			phba->ipv6_iface = NULL;
 		}
 		break;
 	case ISCSI_NET_PARAM_IPV6_ADDR:
@@ -620,7 +626,12 @@ int be2iscsi_iface_get_param(struct iscsi_iface *iface,
 		len = be2iscsi_get_if_param(phba, iface, param, buf);
 		break;
 	case ISCSI_NET_PARAM_IFACE_ENABLE:
-		len = sprintf(buf, "enable\n");
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%s\n",
+				      phba->ipv4_iface ? "enable" : "disable");
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n",
+				      phba->ipv6_iface ? "enable" : "disable");
 		break;
 	case ISCSI_NET_PARAM_IPV4_GW:
 		memset(&gateway, 0, sizeof(gateway));
-- 
1.9.1

