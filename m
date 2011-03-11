From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 1/2] ISCSID: Added vlan field to the iface struct
Date: Thu, 10 Mar 2011 18:21:12 -0800
Message-ID: <1299810073-7339-2-git-send-email-eddie.wai@broadcom.com>
References: <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3455 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1CKCV2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 21:21:28 -0500
In-Reply-To: <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Defined the iface.vlan field to hold the VLAN tag of the interface
in the corresponding iface file.  This will then be passed to the
iSCSI HBA prior to the connect request.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 usr/config.h         |    4 ++++
 usr/iface.c          |   19 +++++++++++++++++--
 usr/iscsi_settings.h |    1 +
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/usr/config.h b/usr/config.h
index 3f61118..b967359 100644
--- a/usr/config.h
+++ b/usr/config.h
@@ -205,6 +205,10 @@ typedef struct iface_rec {
 	 */
 	char			alias[TARGET_NAME_MAXLEN + 1];
 	char			iname[TARGET_NAME_MAXLEN + 1];
+ 	/*
+	 * This is used only for hba 
+	 */
+	char			vlan[ISCSI_MAX_IFACE_LEN];
 	/*
 	 * Following fields are used to support UIO driver based
 	 * DHCP/ARP functionality for offload capable cards.
diff --git a/usr/iface.c b/usr/iface.c
index 52371c7..5543e89 100644
--- a/usr/iface.c
+++ b/usr/iface.c
@@ -501,6 +501,8 @@ void iface_copy(struct iface_rec *dst, struct iface_rec *src)
 		strcpy(dst->transport_name, src->transport_name);
 	if (strlen(src->iname))
 		strcpy(dst->iname, src->iname);
+	if (strlen(src->vlan))
+		strcpy(dst->vlan, src->vlan);
 	if (strlen(src->uiolib))
 		strcpy(dst->uiolib, src->uiolib);
 }
@@ -577,6 +579,14 @@ int iface_is_bound_by_ipaddr(struct iface_rec *iface)
 	return 0;
 }
 
+int iface_is_bound_by_vlan(struct iface_rec *iface)
+{
+	if (iface && strlen(iface->vlan) &&
+	   strcmp(iface->vlan, DEFAULT_VLAN))
+		return 1;
+	return 0;
+}
+
 int iface_is_bound_by_uiolib(struct iface_rec *iface)
 {
 	if (iface && strlen(iface->uiolib))
@@ -619,6 +629,10 @@ void iface_print(struct iface_rec *iface, char *prefix)
 		printf("%sIface Netdev: %s\n", prefix, iface->netdev);
 	else
 		printf("%sIface Netdev: %s\n", prefix, UNKNOWN_VALUE);
+	if (strlen(iface->vlan))
+		printf("%sIface VLAN ID: %s\n", prefix, iface->vlan);
+	else
+		printf("%sIface VLAN ID: %s\n", prefix, UNKNOWN_VALUE);
 }
 
 struct iface_print_node_data {
@@ -664,14 +678,15 @@ int iface_print_tree(void *data, struct iface_rec *iface)
 
 int iface_print_flat(void *data, struct iface_rec *iface)
 {
-	printf("%s %s,%s,%s,%s,%s\n",
+	printf("%s %s,%s,%s,%s,%s,%s\n",
 		strlen(iface->name) ? iface->name : UNKNOWN_VALUE,
 		strlen(iface->transport_name) ? iface->transport_name :
 							UNKNOWN_VALUE,
 		strlen(iface->hwaddress) ? iface->hwaddress : UNKNOWN_VALUE,
 		strlen(iface->ipaddress) ? iface->ipaddress : UNKNOWN_VALUE,
 		strlen(iface->netdev) ? iface->netdev : UNKNOWN_VALUE,
-		strlen(iface->iname) ? iface->iname : UNKNOWN_VALUE);
+		strlen(iface->iname) ? iface->iname : UNKNOWN_VALUE,
+		strlen(iface->vlan) ? iface->vlan : UNKNOWN_VALUE);
 	return 0;
 }
 
diff --git a/usr/iscsi_settings.h b/usr/iscsi_settings.h
index 32d0e85..e5f8aa0 100644
--- a/usr/iscsi_settings.h
+++ b/usr/iscsi_settings.h
@@ -27,6 +27,7 @@
 #define DEFAULT_IPADDRESS	"default"
 #define DEFAULT_HWADDRESS	"default"
 #define DEFAULT_TRANSPORT	"tcp"
+#define DEFAULT_VLAN		"0"
 
 #define PORTAL_GROUP_TAG_UNKNOWN -1
 
-- 
1.7.0.5


