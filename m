From: michaelc@cs.wisc.edu
Subject: [PATCH 13/19] qla4xxx: Add VLAN support
Date: Mon, 25 Jul 2011 13:48:49 -0500
Message-ID: <1311619735-15323-14-git-send-email-michaelc@cs.wisc.edu>
References: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1GYSqQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 14:46:16 -0400
In-Reply-To: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Add support to set VLAN and show vlan settings in sysfs

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
[Patch updated to new defines]
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_fw.h  |    2 +
 drivers/scsi/qla4xxx/ql4_mbx.c |    4 +++
 drivers/scsi/qla4xxx/ql4_os.c  |   57 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 8ffdd34..83e009c 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -484,6 +484,7 @@ struct addr_ctrl_blk {
 #define TCPOPT_DHCP_ENABLE		0x0200
 	uint16_t ipv4_ip_opts;	/* 34-35 */
 #define IPOPT_IPV4_PROTOCOL_ENABLE	0x8000
+#define IPOPT_VLAN_TAGGING_ENABLE	0x2000
 
 	uint16_t iscsi_max_pdu_size;	/* 36-37 */
 	uint8_t ipv4_tos;	/* 38 */
@@ -535,6 +536,7 @@ struct addr_ctrl_blk {
 	uint16_t ipv6_port;	/* 204-205 */
 	uint16_t ipv6_opts;	/* 206-207 */
 #define IPV6_OPT_IPV6_PROTOCOL_ENABLE	0x8000
+#define IPV6_OPT_VLAN_TAGGING_ENABLE	0x2000
 
 	uint16_t ipv6_addtl_opts;	/* 208-209 */
 #define IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE	0x0002 /* Pri ACB
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 0e7530e..ea04b6c 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -351,6 +351,8 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 	       min(sizeof(ha->ip_config.gateway),
 		   sizeof(init_fw_cb->ipv4_gw_addr)));
 
+	ha->ip_config.ipv4_vlan_tag = be16_to_cpu(init_fw_cb->ipv4_vlan_tag);
+
 	if (is_ipv6_enabled(ha)) {
 		/* Save IPv6 Address */
 		ha->ip_config.ipv6_link_local_state =
@@ -378,6 +380,8 @@ qla4xxx_update_local_ip(struct scsi_qla_host *ha,
 		       init_fw_cb->ipv6_dflt_rtr_addr,
 		       min(sizeof(ha->ip_config.ipv6_default_router_addr),
 			   sizeof(init_fw_cb->ipv6_dflt_rtr_addr)));
+		ha->ip_config.ipv6_vlan_tag =
+				be16_to_cpu(init_fw_cb->ipv6_vlan_tag);
 	}
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a9da315..d5f9f60 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -185,6 +185,9 @@ static mode_t ql4_attr_is_visible(int param_type, int param)
 		case ISCSI_NET_PARAM_IPV6_ROUTER:
 		case ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG:
 		case ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG:
+		case ISCSI_NET_PARAM_VLAN_ID:
+		case ISCSI_NET_PARAM_VLAN_PRIORITY:
+		case ISCSI_NET_PARAM_VLAN_ENABLED:
 			return S_IRUGO;
 		default:
 			return 0;
@@ -258,6 +261,38 @@ static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 			       IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR) ?
 			       "auto" : "static");
 		break;
+	case ISCSI_NET_PARAM_VLAN_ID:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%d\n",
+				      (ha->ip_config.ipv4_vlan_tag &
+				       ISCSI_MAX_VLAN_ID));
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%d\n",
+				      (ha->ip_config.ipv6_vlan_tag &
+				       ISCSI_MAX_VLAN_ID));
+		break;
+	case ISCSI_NET_PARAM_VLAN_PRIORITY:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%d\n",
+				      ((ha->ip_config.ipv4_vlan_tag >> 13) &
+					ISCSI_MAX_VLAN_PRIORITY));
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%d\n",
+				      ((ha->ip_config.ipv6_vlan_tag >> 13) &
+					ISCSI_MAX_VLAN_PRIORITY));
+		break;
+	case ISCSI_NET_PARAM_VLAN_ENABLED:
+		if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv4_options &
+				       IPOPT_VLAN_TAGGING_ENABLE) ?
+				       "enabled" : "disabled");
+		else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv6_options &
+				       IPV6_OPT_VLAN_TAGGING_ENABLE) ?
+				       "enabled" : "disabled");
+		break;
 	default:
 		len = -ENOSYS;
 	}
@@ -479,7 +514,16 @@ static void qla4xxx_set_ipv6(struct scsi_qla_host *ha,
 	case ISCSI_NET_PARAM_VLAN_ID:
 		if (iface_param->len != sizeof(init_fw_cb->ipv6_vlan_tag))
 			break;
-		init_fw_cb->ipv6_vlan_tag = *(uint16_t *)iface_param->value;
+		init_fw_cb->ipv6_vlan_tag =
+				cpu_to_be16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_VLAN_ENABLED:
+		if (iface_param->value[0] == ISCSI_VLAN_ENABLE)
+			init_fw_cb->ipv6_opts |=
+				cpu_to_le16(IPV6_OPT_VLAN_TAGGING_ENABLE);
+		else
+			init_fw_cb->ipv6_opts &=
+				cpu_to_le16(~IPV6_OPT_VLAN_TAGGING_ENABLE);
 		break;
 	default:
 		ql4_printk(KERN_ERR, ha, "Unknown IPv6 param = %d\n",
@@ -530,7 +574,16 @@ static void qla4xxx_set_ipv4(struct scsi_qla_host *ha,
 	case ISCSI_NET_PARAM_VLAN_ID:
 		if (iface_param->len != sizeof(init_fw_cb->ipv4_vlan_tag))
 			break;
-		init_fw_cb->ipv4_vlan_tag = *(uint16_t *)iface_param->value;
+		init_fw_cb->ipv4_vlan_tag =
+				cpu_to_be16(*(uint16_t *)iface_param->value);
+		break;
+	case ISCSI_NET_PARAM_VLAN_ENABLED:
+		if (iface_param->value[0] == ISCSI_VLAN_ENABLE)
+			init_fw_cb->ipv4_ip_opts |=
+					cpu_to_le16(IPOPT_VLAN_TAGGING_ENABLE);
+		else
+			init_fw_cb->ipv4_ip_opts &=
+					cpu_to_le16(~IPOPT_VLAN_TAGGING_ENABLE);
 		break;
 	default:
 		ql4_printk(KERN_ERR, ha, "Unknown IPv4 param = %d\n",
-- 
1.7.2.3

