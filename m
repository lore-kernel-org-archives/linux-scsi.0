From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 7/8] scsi_transport_iscsi: Added support to update initiator iscsi port
Date: Mon, 1 Aug 2011 03:26:18 -0700
Message-ID: <1312194379-9241-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1312194379-9241-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:30488 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1HAKgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 06:36:42 -0400
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
index b3a2515..c58f676 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -324,6 +324,7 @@ iscsi_iface_net_attr(iface, vlan, ISCSI_NET_PARAM_VLAN_ID);
 iscsi_iface_net_attr(iface, vlan_priority, ISCSI_NET_PARAM_VLAN_PRIORITY);
 iscsi_iface_net_attr(iface, vlan_enabled, ISCSI_NET_PARAM_VLAN_ENABLED);
 iscsi_iface_net_attr(iface, mtu, ISCSI_NET_PARAM_MTU);
+iscsi_iface_net_attr(iface, port, ISCSI_NET_PARAM_PORT);
 
 static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 					  struct attribute *attr, int i)
@@ -343,6 +344,8 @@ static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_NET_PARAM_VLAN_ENABLED;
 	else if (attr == &dev_attr_iface_mtu.attr)
 		param = ISCSI_NET_PARAM_MTU;
+	else if (attr == &dev_attr_iface_port.attr)
+		param = ISCSI_NET_PARAM_PORT;
 	else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
 		if (attr == &dev_attr_ipv4_iface_ipaddress.attr)
 			param = ISCSI_NET_PARAM_IPV4_ADDR;
@@ -390,6 +393,7 @@ static struct attribute *iscsi_iface_attrs[] = {
 	&dev_attr_ipv6_iface_ipaddr_autocfg.attr,
 	&dev_attr_ipv6_iface_linklocal_autocfg.attr,
 	&dev_attr_iface_mtu.attr,
+	&dev_attr_iface_port.attr,
 	NULL,
 };
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index d1f0927..706a1bb 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -314,6 +314,7 @@ enum iscsi_net_param {
 	ISCSI_NET_PARAM_IFACE_TYPE		= 16,
 	ISCSI_NET_PARAM_IFACE_NAME		= 17,
 	ISCSI_NET_PARAM_MTU			= 18,
+	ISCSI_NET_PARAM_PORT			= 19,
 };
 
 enum iscsi_conn_state {
-- 
1.7.6


