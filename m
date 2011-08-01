From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/8] scsi_transport_iscsi: Added support to update mtu
Date: Mon, 1 Aug 2011 03:26:12 -0700
Message-ID: <1312194379-9241-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1312194379-9241-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:51894 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab1HAKfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 06:35:47 -0400
In-Reply-To: <1312194379-9241-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    4 ++++
 include/scsi/iscsi_if.h             |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b85f8a4..b3a2515 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -323,6 +323,7 @@ iscsi_iface_net_attr(iface, enabled, ISCSI_NET_PARAM_IFACE_ENABLE);
 iscsi_iface_net_attr(iface, vlan, ISCSI_NET_PARAM_VLAN_ID);
 iscsi_iface_net_attr(iface, vlan_priority, ISCSI_NET_PARAM_VLAN_PRIORITY);
 iscsi_iface_net_attr(iface, vlan_enabled, ISCSI_NET_PARAM_VLAN_ENABLED);
+iscsi_iface_net_attr(iface, mtu, ISCSI_NET_PARAM_MTU);
 
 static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 					  struct attribute *attr, int i)
@@ -340,6 +341,8 @@ static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
 	else if (attr == &dev_attr_iface_vlan_enabled.attr)
 		param = ISCSI_NET_PARAM_VLAN_ENABLED;
+	else if (attr == &dev_attr_iface_mtu.attr)
+		param = ISCSI_NET_PARAM_MTU;
 	else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
 		if (attr == &dev_attr_ipv4_iface_ipaddress.attr)
 			param = ISCSI_NET_PARAM_IPV4_ADDR;
@@ -386,6 +389,7 @@ static struct attribute *iscsi_iface_attrs[] = {
 	&dev_attr_ipv6_iface_router_addr.attr,
 	&dev_attr_ipv6_iface_ipaddr_autocfg.attr,
 	&dev_attr_ipv6_iface_linklocal_autocfg.attr,
+	&dev_attr_iface_mtu.attr,
 	NULL,
 };
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 629ca42..d1f0927 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -313,6 +313,7 @@ enum iscsi_net_param {
 	ISCSI_NET_PARAM_VLAN_ENABLED		= 15,
 	ISCSI_NET_PARAM_IFACE_TYPE		= 16,
 	ISCSI_NET_PARAM_IFACE_NAME		= 17,
+	ISCSI_NET_PARAM_MTU			= 18,
 };
 
 enum iscsi_conn_state {
-- 
1.7.6


