From: michaelc@cs.wisc.edu
Subject: [PATCH 11/19] iscsi class: expand vlan support
Date: Mon, 25 Jul 2011 13:48:47 -0500
Message-ID: <1311619735-15323-12-git-send-email-michaelc@cs.wisc.edu>
References: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab1GYSqK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 14:46:10 -0400
In-Reply-To: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Add support to set vlan priority and enable/disble a vlan.

Patch based on code from Vikas Chaudhary.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    8 ++++++++
 include/scsi/iscsi_if.h             |   13 +++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2e9b682..13f9051 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -319,6 +319,8 @@ iscsi_iface_net_attr(ipv6_iface, linklocal_autocfg,
 /* common read only iface attribute */
 iscsi_iface_net_attr(iface, enabled, ISCSI_NET_PARAM_IFACE_ENABLE);
 iscsi_iface_net_attr(iface, vlan, ISCSI_NET_PARAM_VLAN_ID);
+iscsi_iface_net_attr(iface, vlan_priority, ISCSI_NET_PARAM_VLAN_PRIORITY);
+iscsi_iface_net_attr(iface, vlan_enabled, ISCSI_NET_PARAM_VLAN_ENABLED);
 
 static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 					  struct attribute *attr, int i)
@@ -332,6 +334,10 @@ static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_NET_PARAM_IFACE_ENABLE;
 	else if (attr == &dev_attr_iface_vlan.attr)
 		param = ISCSI_NET_PARAM_VLAN_ID;
+	else if (attr == &dev_attr_iface_vlan_priority.attr)
+		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
+	else if (attr == &dev_attr_iface_vlan_enabled.attr)
+		param = ISCSI_NET_PARAM_VLAN_ENABLED;
 	else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
 		if (attr == &dev_attr_ipv4_iface_ipaddress.attr)
 			param = ISCSI_NET_PARAM_IPV4_ADDR;
@@ -367,6 +373,8 @@ static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 static struct attribute *iscsi_iface_attrs[] = {
 	&dev_attr_iface_enabled.attr,
 	&dev_attr_iface_vlan.attr,
+	&dev_attr_iface_vlan_priority.attr,
+	&dev_attr_iface_vlan_enabled.attr,
 	&dev_attr_ipv4_iface_ipaddress.attr,
 	&dev_attr_ipv4_iface_gateway.attr,
 	&dev_attr_ipv4_iface_subnet.attr,
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 3753f7e..d3f256a 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -281,6 +281,13 @@ struct iscsi_path {
 #define ISCSI_IFACE_TYPE_IPV4		0x01
 #define ISCSI_IFACE_TYPE_IPV6		0x02
 
+#define ISCSI_MAX_VLAN_ID		4095
+#define ISCSI_MAX_VLAN_PRIORITY		7
+
+/* iscsi vlan enable/disabled setting */
+#define ISCSI_VLAN_DISABLE	0x01
+#define ISCSI_VLAN_ENABLE	0x02
+
 /* iSCSI network params */
 enum iscsi_net_param {
 	ISCSI_NET_PARAM_IPV4_ADDR		= 1,
@@ -296,8 +303,10 @@ enum iscsi_net_param {
 	ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG	= 11,
 	ISCSI_NET_PARAM_IFACE_ENABLE		= 12,
 	ISCSI_NET_PARAM_VLAN_ID			= 13,
-	ISCSI_NET_PARAM_IFACE_TYPE		= 14,
-	ISCSI_NET_PARAM_IFACE_NAME		= 15,
+	ISCSI_NET_PARAM_VLAN_PRIORITY		= 14,
+	ISCSI_NET_PARAM_VLAN_ENABLED		= 15,
+	ISCSI_NET_PARAM_IFACE_TYPE		= 16,
+	ISCSI_NET_PARAM_IFACE_NAME		= 17,
 };
 
 /*
-- 
1.7.2.3

