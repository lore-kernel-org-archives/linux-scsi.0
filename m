From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] iscsi class: fix vlan configuration
Date: Thu,  6 Oct 2011 03:57:00 -0500
Message-ID: <1317891420-7116-5-git-send-email-michaelc@cs.wisc.edu>
References: <1317891420-7116-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934775Ab1JFIv7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Oct 2011 04:51:59 -0400
In-Reply-To: <1317891420-7116-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Userspace was sending the priority/id part of the vlan tag
and sysfs was displaying the id in the vlan file. This
renames the vlan sysfs file to vlan_id to reflect that it
was showing the id and to match the vlan_priority file.
This also adds a ISCSI_NET_PARAM_VLAN_TAG iscsi nl command
to relfect that we are sending down the vlan/priority
part of the tag.
---
 drivers/scsi/qla4xxx/ql4_os.c       |    2 +-
 drivers/scsi/scsi_transport_iscsi.c |    6 +++---
 include/scsi/iscsi_if.h             |    9 +++++----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f1bdc56..9f7ef0d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -718,7 +718,7 @@ static void qla4xxx_set_ipv6(struct scsi_qla_host *ha,
 			qla4xxx_destroy_ipv6_iface(ha);
 		}
 		break;
-	case ISCSI_NET_PARAM_VLAN_ID:
+	case ISCSI_NET_PARAM_VLAN_TAG:
 		if (iface_param->len != sizeof(init_fw_cb->ipv6_vlan_tag))
 			break;
 		init_fw_cb->ipv6_vlan_tag =
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 142a09a..1bcd65a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -322,7 +322,7 @@ iscsi_iface_net_attr(ipv6_iface, link_local_autocfg,
 
 /* common read only iface attribute */
 iscsi_iface_net_attr(iface, enabled, ISCSI_NET_PARAM_IFACE_ENABLE);
-iscsi_iface_net_attr(iface, vlan, ISCSI_NET_PARAM_VLAN_ID);
+iscsi_iface_net_attr(iface, vlan_id, ISCSI_NET_PARAM_VLAN_ID);
 iscsi_iface_net_attr(iface, vlan_priority, ISCSI_NET_PARAM_VLAN_PRIORITY);
 iscsi_iface_net_attr(iface, vlan_enabled, ISCSI_NET_PARAM_VLAN_ENABLED);
 iscsi_iface_net_attr(iface, mtu, ISCSI_NET_PARAM_MTU);
@@ -338,7 +338,7 @@ static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 
 	if (attr == &dev_attr_iface_enabled.attr)
 		param = ISCSI_NET_PARAM_IFACE_ENABLE;
-	else if (attr == &dev_attr_iface_vlan.attr)
+	else if (attr == &dev_attr_iface_vlan_id.attr)
 		param = ISCSI_NET_PARAM_VLAN_ID;
 	else if (attr == &dev_attr_iface_vlan_priority.attr)
 		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
@@ -382,7 +382,7 @@ static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 
 static struct attribute *iscsi_iface_attrs[] = {
 	&dev_attr_iface_enabled.attr,
-	&dev_attr_iface_vlan.attr,
+	&dev_attr_iface_vlan_id.attr,
 	&dev_attr_iface_vlan_priority.attr,
 	&dev_attr_iface_vlan_enabled.attr,
 	&dev_attr_ipv4_iface_ipaddress.attr,
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 706a1bb..2703e3b 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -311,10 +311,11 @@ enum iscsi_net_param {
 	ISCSI_NET_PARAM_VLAN_ID			= 13,
 	ISCSI_NET_PARAM_VLAN_PRIORITY		= 14,
 	ISCSI_NET_PARAM_VLAN_ENABLED		= 15,
-	ISCSI_NET_PARAM_IFACE_TYPE		= 16,
-	ISCSI_NET_PARAM_IFACE_NAME		= 17,
-	ISCSI_NET_PARAM_MTU			= 18,
-	ISCSI_NET_PARAM_PORT			= 19,
+	ISCSI_NET_PARAM_VLAN_TAG		= 16,
+	ISCSI_NET_PARAM_IFACE_TYPE		= 17,
+	ISCSI_NET_PARAM_IFACE_NAME		= 18,
+	ISCSI_NET_PARAM_MTU			= 19,
+	ISCSI_NET_PARAM_PORT			= 20,
 };
 
 enum iscsi_conn_state {
-- 
1.7.6

