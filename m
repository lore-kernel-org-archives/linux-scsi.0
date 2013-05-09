From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/8] iscsi_transport: Additional parameters for net settings
Date: Thu, 9 May 2013 06:02:06 -0400
Message-ID: <1368093732-8524-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:27620
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab3EIK0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 06:26:49 -0400
In-Reply-To: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Added support to display and update additional network parameters
through iscsiadm

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 331 +++++++++++++++++++++++++++++++++++-
 include/scsi/iscsi_if.h             |  78 +++++++++
 include/scsi/scsi_transport_iscsi.h |   3 +
 3 files changed, 411 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 133926b..315c8b6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -306,11 +306,38 @@ show_##type##_##name(struct device *dev, struct device_attribute *attr,	\
 	iscsi_iface_attr_show(type, name, ISCSI_NET_PARAM, param)	\
 static ISCSI_IFACE_ATTR(type, name, S_IRUGO, show_##type##_##name, NULL);
 
-/* generic read only ipvi4 attribute */
+/* generic read only ipv4 attribute */
 iscsi_iface_net_attr(ipv4_iface, ipaddress, ISCSI_NET_PARAM_IPV4_ADDR);
 iscsi_iface_net_attr(ipv4_iface, gateway, ISCSI_NET_PARAM_IPV4_GW);
 iscsi_iface_net_attr(ipv4_iface, subnet, ISCSI_NET_PARAM_IPV4_SUBNET);
 iscsi_iface_net_attr(ipv4_iface, bootproto, ISCSI_NET_PARAM_IPV4_BOOTPROTO);
+iscsi_iface_net_attr(ipv4_iface, dhcp_dns_address_enabled,
+		     ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_slp_da_info_enabled,
+		     ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_req_isns_info_enabled,
+		     ISCSI_NET_PARAM_IPV4_DHCP_REQ_ISNS_INFO_EN);
+iscsi_iface_net_attr(ipv4_iface, tos_enabled, ISCSI_NET_PARAM_IPV4_TOS_EN);
+iscsi_iface_net_attr(ipv4_iface, tos, ISCSI_NET_PARAM_IPV4_TOS);
+iscsi_iface_net_attr(ipv4_iface, grat_arp_enabled,
+		     ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_alt_client_id_enabled,
+		     ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_alt_client_id,
+		     ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID);
+iscsi_iface_net_attr(ipv4_iface, dhcp_req_vendor_id_enabled,
+		     ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_use_vendor_id_enabled,
+		     ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_vendor_id,
+		     ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID);
+iscsi_iface_net_attr(ipv4_iface, dhcp_learn_iqn_enabled,
+		     ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN);
+iscsi_iface_net_attr(ipv4_iface, fragmentation_enabled,
+		     ISCSI_NET_PARAM_IPV4_FRAGMENT_EN);
+iscsi_iface_net_attr(ipv4_iface, incoming_forwarding_enabled,
+		     ISCSI_NET_PARAM_IPV4_IN_FORWARD_EN);
+iscsi_iface_net_attr(ipv4_iface, ttl, ISCSI_NET_PARAM_IPV4_TTL);
 
 /* generic read only ipv6 attribute */
 iscsi_iface_net_attr(ipv6_iface, ipaddress, ISCSI_NET_PARAM_IPV6_ADDR);
@@ -320,6 +347,27 @@ iscsi_iface_net_attr(ipv6_iface, ipaddr_autocfg,
 		     ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG);
 iscsi_iface_net_attr(ipv6_iface, link_local_autocfg,
 		     ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG);
+iscsi_iface_net_attr(ipv6_iface, link_local_state,
+		     ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE);
+iscsi_iface_net_attr(ipv6_iface, router_state,
+		     ISCSI_NET_PARAM_IPV6_ROUTER_STATE);
+iscsi_iface_net_attr(ipv6_iface, grat_neighbor_adv_enabled,
+		     ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN);
+iscsi_iface_net_attr(ipv6_iface, mld_enabled, ISCSI_NET_PARAM_IPV6_MLD_EN);
+iscsi_iface_net_attr(ipv6_iface, flow_label, ISCSI_NET_PARAM_IPV6_FLOW_LABEL);
+iscsi_iface_net_attr(ipv6_iface, traffic_class,
+		     ISCSI_NET_PARAM_IPV6_TRAFFIC_CLASS);
+iscsi_iface_net_attr(ipv6_iface, hop_limit, ISCSI_NET_PARAM_IPV6_HOP_LIMIT);
+iscsi_iface_net_attr(ipv6_iface, nd_reachable_tmo,
+		     ISCSI_NET_PARAM_IPV6_ND_REACHABLE_TMO);
+iscsi_iface_net_attr(ipv6_iface, nd_rexmit_time,
+		     ISCSI_NET_PARAM_IPV6_ND_REXMIT_TIME);
+iscsi_iface_net_attr(ipv6_iface, nd_stale_tmo,
+		     ISCSI_NET_PARAM_IPV6_ND_STALE_TMO);
+iscsi_iface_net_attr(ipv6_iface, dup_addr_det_cnt,
+		     ISCSI_NET_PARAM_IPV6_DUP_ADDR_DET_CNT);
+iscsi_iface_net_attr(ipv6_iface, router_adv_link_mtu,
+		     ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU);
 
 /* common read only iface attribute */
 iscsi_iface_net_attr(iface, enabled, ISCSI_NET_PARAM_IFACE_ENABLE);
@@ -328,6 +376,51 @@ iscsi_iface_net_attr(iface, vlan_priority, ISCSI_NET_PARAM_VLAN_PRIORITY);
 iscsi_iface_net_attr(iface, vlan_enabled, ISCSI_NET_PARAM_VLAN_ENABLED);
 iscsi_iface_net_attr(iface, mtu, ISCSI_NET_PARAM_MTU);
 iscsi_iface_net_attr(iface, port, ISCSI_NET_PARAM_PORT);
+iscsi_iface_net_attr(iface, ipaddress_state, ISCSI_NET_PARAM_IPADDR_STATE);
+iscsi_iface_net_attr(iface, delayed_ack_enabled,
+		     ISCSI_NET_PARAM_DELAYED_ACK_EN);
+iscsi_iface_net_attr(iface, isns_enabled, ISCSI_NET_PARAM_ISNS_EN);
+iscsi_iface_net_attr(iface, isns_address, ISCSI_NET_PARAM_ISNS_ADDR);
+iscsi_iface_net_attr(iface, isns_port, ISCSI_NET_PARAM_ISNS_PORT);
+iscsi_iface_net_attr(iface, nagle_enabled, ISCSI_NET_PARAM_NAGLE_EN);
+iscsi_iface_net_attr(iface, tcp_window_scale_enabled,
+		     ISCSI_NET_PARAM_TCP_WIN_SCALE_EN);
+iscsi_iface_net_attr(iface, tcp_window_scale, ISCSI_NET_PARAM_TCP_WIN_SCALE);
+iscsi_iface_net_attr(iface, tcp_timer_scale, ISCSI_NET_PARAM_TCP_TIMER_SCALE);
+iscsi_iface_net_attr(iface, tcp_timestamp_enabled,
+		     ISCSI_NET_PARAM_TCP_TIMESTAMP_EN);
+iscsi_iface_net_attr(iface, cache_id, ISCSI_NET_PARAM_CACHE_ID);
+iscsi_iface_net_attr(iface, def_tmf_timeout, ISCSI_NET_PARAM_DEF_TMF_TMO);
+iscsi_iface_net_attr(iface, def_hdr_dgst_enabled,
+		     ISCSI_NET_PARAM_DEF_HDRDGST_EN);
+iscsi_iface_net_attr(iface, def_data_dgst_enabled,
+		     ISCSI_NET_PARAM_DEF_DATADGST_EN);
+iscsi_iface_net_attr(iface, def_immediate_data_enabled,
+		     ISCSI_NET_PARAM_DEF_IMM_DATA_EN);
+iscsi_iface_net_attr(iface, def_initial_r2t_enabled,
+		     ISCSI_NET_PARAM_DEF_INITIAL_R2T_EN);
+iscsi_iface_net_attr(iface, def_data_seq_inorder_enabled,
+		     ISCSI_NET_PARAM_DEF_DATASEQ_INORDER_EN);
+iscsi_iface_net_attr(iface, def_data_pdu_inorder_enabled,
+		     ISCSI_NET_PARAM_DEF_PDU_INORDER_EN);
+iscsi_iface_net_attr(iface, def_erl, ISCSI_NET_PARAM_DEF_ERL);
+iscsi_iface_net_attr(iface, def_max_recv_dlen,
+		     ISCSI_NET_PARAM_DEF_MAX_RECV_DLENGTH);
+iscsi_iface_net_attr(iface, def_first_burst, ISCSI_NET_PARAM_DEF_FIRST_BURST);
+iscsi_iface_net_attr(iface, def_max_r2t, ISCSI_NET_PARAM_DEF_MAX_R2T);
+iscsi_iface_net_attr(iface, def_max_burst, ISCSI_NET_PARAM_DEF_MAX_BURST);
+iscsi_iface_net_attr(iface, def_chap_auth_enabled,
+		     ISCSI_NET_PARAM_DEF_CHAP_AUTH_EN);
+iscsi_iface_net_attr(iface, def_bidi_chap_enabled,
+		     ISCSI_NET_PARAM_DEF_BIDI_CHAP_EN);
+iscsi_iface_net_attr(iface, def_strict_login_comp_enabled,
+		     ISCSI_NET_PARAM_DEF_STRICT_LOGIN_COMP_EN);
+iscsi_iface_net_attr(iface, def_discovery_auth_enabled,
+		     ISCSI_NET_PARAM_DEF_DISCOVERY_AUTH_EN);
+iscsi_iface_net_attr(iface, def_discovery_logout_enabled,
+		     ISCSI_NET_PARAM_DEF_DISCOVERY_LOGOUT_EN);
+iscsi_iface_net_attr(iface, def_iscsi_name, ISCSI_NET_PARAM_DEF_ISCSI_NAME);
+iscsi_iface_net_attr(iface, redirect_enabled, ISCSI_NET_PARAM_REDIRECT_EN);
 
 static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 					  struct attribute *attr, int i)
@@ -349,6 +442,66 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_NET_PARAM_MTU;
 	else if (attr == &dev_attr_iface_port.attr)
 		param = ISCSI_NET_PARAM_PORT;
+	else if (attr == &dev_attr_iface_ipaddress_state.attr)
+		param = ISCSI_NET_PARAM_IPADDR_STATE;
+	else if (attr == &dev_attr_iface_delayed_ack_enabled.attr)
+		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
+	else if (attr == &dev_attr_iface_isns_enabled.attr)
+		param = ISCSI_NET_PARAM_ISNS_EN;
+	else if (attr == &dev_attr_iface_isns_address.attr)
+		param = ISCSI_NET_PARAM_ISNS_ADDR;
+	else if (attr == &dev_attr_iface_isns_port.attr)
+		param = ISCSI_NET_PARAM_ISNS_PORT;
+	else if (attr == &dev_attr_iface_nagle_enabled.attr)
+		param = ISCSI_NET_PARAM_NAGLE_EN;
+	else if (attr == &dev_attr_iface_tcp_window_scale_enabled.attr)
+		param = ISCSI_NET_PARAM_TCP_WIN_SCALE_EN;
+	else if (attr == &dev_attr_iface_tcp_window_scale.attr)
+		param = ISCSI_NET_PARAM_TCP_WIN_SCALE;
+	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
+	else if (attr == &dev_attr_iface_tcp_timestamp_enabled.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
+	else if (attr == &dev_attr_iface_cache_id.attr)
+		param = ISCSI_NET_PARAM_CACHE_ID;
+	else if (attr == &dev_attr_iface_def_tmf_timeout.attr)
+		param = ISCSI_NET_PARAM_DEF_TMF_TMO;
+	else if (attr == &dev_attr_iface_def_hdr_dgst_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_HDRDGST_EN;
+	else if (attr == &dev_attr_iface_def_data_dgst_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_DATADGST_EN;
+	else if (attr == &dev_attr_iface_def_immediate_data_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_IMM_DATA_EN;
+	else if (attr == &dev_attr_iface_def_initial_r2t_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_INITIAL_R2T_EN;
+	else if (attr == &dev_attr_iface_def_data_seq_inorder_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_DATASEQ_INORDER_EN;
+	else if (attr == &dev_attr_iface_def_data_pdu_inorder_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_PDU_INORDER_EN;
+	else if (attr == &dev_attr_iface_def_erl.attr)
+		param = ISCSI_NET_PARAM_DEF_ERL;
+	else if (attr == &dev_attr_iface_def_max_recv_dlen.attr)
+		param = ISCSI_NET_PARAM_DEF_MAX_RECV_DLENGTH;
+	else if (attr == &dev_attr_iface_def_first_burst.attr)
+		param = ISCSI_NET_PARAM_DEF_FIRST_BURST;
+	else if (attr == &dev_attr_iface_def_max_r2t.attr)
+		param = ISCSI_NET_PARAM_DEF_MAX_R2T;
+	else if (attr == &dev_attr_iface_def_max_burst.attr)
+		param = ISCSI_NET_PARAM_DEF_MAX_BURST;
+	else if (attr == &dev_attr_iface_def_chap_auth_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_CHAP_AUTH_EN;
+	else if (attr == &dev_attr_iface_def_bidi_chap_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_BIDI_CHAP_EN;
+	else if (attr == &dev_attr_iface_def_strict_login_comp_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_STRICT_LOGIN_COMP_EN;
+	else if (attr == &dev_attr_iface_def_discovery_auth_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_DISCOVERY_AUTH_EN;
+	else if (attr == &dev_attr_iface_def_discovery_logout_enabled.attr)
+		param = ISCSI_NET_PARAM_DEF_DISCOVERY_LOGOUT_EN;
+	else if (attr == &dev_attr_iface_def_iscsi_name.attr)
+		param = ISCSI_NET_PARAM_DEF_ISCSI_NAME;
+	else if (attr == &dev_attr_iface_redirect_enabled.attr)
+		param = ISCSI_NET_PARAM_REDIRECT_EN;
 	else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
 		if (attr == &dev_attr_ipv4_iface_ipaddress.attr)
 			param = ISCSI_NET_PARAM_IPV4_ADDR;
@@ -358,6 +511,45 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 			param = ISCSI_NET_PARAM_IPV4_SUBNET;
 		else if (attr == &dev_attr_ipv4_iface_bootproto.attr)
 			param = ISCSI_NET_PARAM_IPV4_BOOTPROTO;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_dns_address_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_slp_da_info_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_req_isns_info_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_REQ_ISNS_INFO_EN;
+		else if (attr == &dev_attr_ipv4_iface_tos_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_TOS_EN;
+		else if (attr == &dev_attr_ipv4_iface_tos.attr)
+			param = ISCSI_NET_PARAM_IPV4_TOS;
+		else if (attr == &dev_attr_ipv4_iface_grat_arp_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_alt_client_id_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN;
+		else if (attr == &dev_attr_ipv4_iface_dhcp_alt_client_id.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_req_vendor_id_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_use_vendor_id_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN;
+		else if (attr == &dev_attr_ipv4_iface_dhcp_vendor_id.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_learn_iqn_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_fragmentation_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_FRAGMENT_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_incoming_forwarding_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV4_IN_FORWARD_EN;
+		else if (attr == &dev_attr_ipv4_iface_ttl.attr)
+			param = ISCSI_NET_PARAM_IPV4_TTL;
 		else
 			return 0;
 	} else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6) {
@@ -371,6 +563,31 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 			param = ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG;
 		else if (attr == &dev_attr_ipv6_iface_link_local_autocfg.attr)
 			param = ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG;
+		else if (attr == &dev_attr_ipv6_iface_link_local_state.attr)
+			param = ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE;
+		else if (attr == &dev_attr_ipv6_iface_router_state.attr)
+			param = ISCSI_NET_PARAM_IPV6_ROUTER_STATE;
+		else if (attr ==
+			 &dev_attr_ipv6_iface_grat_neighbor_adv_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN;
+		else if (attr == &dev_attr_ipv6_iface_mld_enabled.attr)
+			param = ISCSI_NET_PARAM_IPV6_MLD_EN;
+		else if (attr == &dev_attr_ipv6_iface_flow_label.attr)
+			param = ISCSI_NET_PARAM_IPV6_FLOW_LABEL;
+		else if (attr == &dev_attr_ipv6_iface_traffic_class.attr)
+			param = ISCSI_NET_PARAM_IPV6_TRAFFIC_CLASS;
+		else if (attr == &dev_attr_ipv6_iface_hop_limit.attr)
+			param = ISCSI_NET_PARAM_IPV6_HOP_LIMIT;
+		else if (attr == &dev_attr_ipv6_iface_nd_reachable_tmo.attr)
+			param = ISCSI_NET_PARAM_IPV6_ND_REACHABLE_TMO;
+		else if (attr == &dev_attr_ipv6_iface_nd_rexmit_time.attr)
+			param = ISCSI_NET_PARAM_IPV6_ND_REXMIT_TIME;
+		else if (attr == &dev_attr_ipv6_iface_nd_stale_tmo.attr)
+			param = ISCSI_NET_PARAM_IPV6_ND_STALE_TMO;
+		else if (attr == &dev_attr_ipv6_iface_dup_addr_det_cnt.attr)
+			param = ISCSI_NET_PARAM_IPV6_DUP_ADDR_DET_CNT;
+		else if (attr == &dev_attr_ipv6_iface_router_adv_link_mtu.attr)
+			param = ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU;
 		else
 			return 0;
 	} else {
@@ -397,6 +614,63 @@ static struct attribute *iscsi_iface_attrs[] = {
 	&dev_attr_ipv6_iface_link_local_autocfg.attr,
 	&dev_attr_iface_mtu.attr,
 	&dev_attr_iface_port.attr,
+	&dev_attr_iface_ipaddress_state.attr,
+	&dev_attr_iface_delayed_ack_enabled.attr,
+	&dev_attr_iface_isns_enabled.attr,
+	&dev_attr_iface_isns_address.attr,
+	&dev_attr_iface_isns_port.attr,
+	&dev_attr_iface_nagle_enabled.attr,
+	&dev_attr_iface_tcp_window_scale_enabled.attr,
+	&dev_attr_iface_tcp_window_scale.attr,
+	&dev_attr_iface_tcp_timer_scale.attr,
+	&dev_attr_iface_tcp_timestamp_enabled.attr,
+	&dev_attr_iface_cache_id.attr,
+	&dev_attr_ipv4_iface_dhcp_dns_address_enabled.attr,
+	&dev_attr_ipv4_iface_dhcp_slp_da_info_enabled.attr,
+	&dev_attr_ipv4_iface_dhcp_req_isns_info_enabled.attr,
+	&dev_attr_ipv4_iface_tos_enabled.attr,
+	&dev_attr_ipv4_iface_tos.attr,
+	&dev_attr_ipv4_iface_grat_arp_enabled.attr,
+	&dev_attr_ipv4_iface_dhcp_alt_client_id_enabled.attr,
+	&dev_attr_ipv4_iface_dhcp_alt_client_id.attr,
+	&dev_attr_ipv4_iface_dhcp_req_vendor_id_enabled.attr,
+	&dev_attr_ipv4_iface_dhcp_use_vendor_id_enabled.attr,
+	&dev_attr_ipv4_iface_dhcp_vendor_id.attr,
+	&dev_attr_ipv4_iface_dhcp_learn_iqn_enabled.attr,
+	&dev_attr_ipv4_iface_fragmentation_enabled.attr,
+	&dev_attr_ipv4_iface_incoming_forwarding_enabled.attr,
+	&dev_attr_ipv4_iface_ttl.attr,
+	&dev_attr_ipv6_iface_link_local_state.attr,
+	&dev_attr_ipv6_iface_router_state.attr,
+	&dev_attr_ipv6_iface_grat_neighbor_adv_enabled.attr,
+	&dev_attr_ipv6_iface_mld_enabled.attr,
+	&dev_attr_ipv6_iface_flow_label.attr,
+	&dev_attr_ipv6_iface_traffic_class.attr,
+	&dev_attr_ipv6_iface_hop_limit.attr,
+	&dev_attr_ipv6_iface_nd_reachable_tmo.attr,
+	&dev_attr_ipv6_iface_nd_rexmit_time.attr,
+	&dev_attr_ipv6_iface_nd_stale_tmo.attr,
+	&dev_attr_ipv6_iface_dup_addr_det_cnt.attr,
+	&dev_attr_ipv6_iface_router_adv_link_mtu.attr,
+	&dev_attr_iface_def_tmf_timeout.attr,
+	&dev_attr_iface_def_hdr_dgst_enabled.attr,
+	&dev_attr_iface_def_data_dgst_enabled.attr,
+	&dev_attr_iface_def_immediate_data_enabled.attr,
+	&dev_attr_iface_def_initial_r2t_enabled.attr,
+	&dev_attr_iface_def_data_seq_inorder_enabled.attr,
+	&dev_attr_iface_def_data_pdu_inorder_enabled.attr,
+	&dev_attr_iface_def_erl.attr,
+	&dev_attr_iface_def_max_recv_dlen.attr,
+	&dev_attr_iface_def_first_burst.attr,
+	&dev_attr_iface_def_max_r2t.attr,
+	&dev_attr_iface_def_max_burst.attr,
+	&dev_attr_iface_def_chap_auth_enabled.attr,
+	&dev_attr_iface_def_bidi_chap_enabled.attr,
+	&dev_attr_iface_def_strict_login_comp_enabled.attr,
+	&dev_attr_iface_def_discovery_auth_enabled.attr,
+	&dev_attr_iface_def_discovery_logout_enabled.attr,
+	&dev_attr_iface_def_iscsi_name.attr,
+	&dev_attr_iface_redirect_enabled.attr,
 	NULL,
 };
 
@@ -405,6 +679,61 @@ static struct attribute_group iscsi_iface_group = {
 	.is_visible = iscsi_iface_attr_is_visible,
 };
 
+/* convert iscsi_ipaddress_state values to ascii string name */
+static const struct {
+	enum iscsi_ipaddress_state	value;
+	char				*name;
+} iscsi_ipaddress_state_names[] = {
+	{ISCSI_IPDDRESS_STATE_UNCONFIGURED,	"Unconfigured" },
+	{ISCSI_IPDDRESS_STATE_ACQUIRING,	"Acquiring" },
+	{ISCSI_IPDDRESS_STATE_TENTATIVE,	"Tentative" },
+	{ISCSI_IPDDRESS_STATE_VALID,		"Valid" },
+	{ISCSI_IPDDRESS_STATE_DISABLING,	"Disabling" },
+	{ISCSI_IPDDRESS_STATE_INVALID,		"Invalid" },
+	{ISCSI_IPDDRESS_STATE_DEPRECATED,	"Deprecated" },
+};
+
+char *iscsi_get_ipaddress_state_name(enum iscsi_ipaddress_state port_state)
+{
+	int i;
+	char *state = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(iscsi_ipaddress_state_names); i++) {
+		if (iscsi_ipaddress_state_names[i].value == port_state) {
+			state = iscsi_ipaddress_state_names[i].name;
+			break;
+		}
+	}
+	return state;
+}
+EXPORT_SYMBOL_GPL(iscsi_get_ipaddress_state_name);
+
+/* convert iscsi_router_state values to ascii string name */
+static const struct {
+	enum iscsi_router_state	value;
+	char			*name;
+} iscsi_router_state_names[] = {
+	{ISCSI_ROUTER_STATE_UNKNOWN,		"Unknown" },
+	{ISCSI_ROUTER_STATE_ADVERTISED,		"Advertised" },
+	{ISCSI_ROUTER_STATE_MANUAL,		"Manual" },
+	{ISCSI_ROUTER_STATE_STALE,		"Stale" },
+};
+
+char *iscsi_get_router_state_name(enum iscsi_router_state router_state)
+{
+	int i;
+	char *state = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(iscsi_router_state_names); i++) {
+		if (iscsi_router_state_names[i].value & router_state) {
+			state = iscsi_router_state_names[i].name;
+			break;
+		}
+	}
+	return state;
+}
+EXPORT_SYMBOL_GPL(iscsi_get_router_state_name);
+
 struct iscsi_iface *
 iscsi_create_iface(struct Scsi_Host *shost, struct iscsi_transport *transport,
 		   uint32_t iface_type, uint32_t iface_num, int dd_size)
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 2bc5d1c..c2ee3b3 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -374,6 +374,10 @@ struct iscsi_path {
 #define ISCSI_VLAN_DISABLE	0x01
 #define ISCSI_VLAN_ENABLE	0x02
 
+/* iscsi generic enable/disabled setting for various features */
+#define ISCSI_NET_PARAM_DISABLE		0x01
+#define ISCSI_NET_PARAM_ENABLE		0x02
+
 /* iSCSI network params */
 enum iscsi_net_param {
 	ISCSI_NET_PARAM_IPV4_ADDR		= 1,
@@ -396,6 +400,80 @@ enum iscsi_net_param {
 	ISCSI_NET_PARAM_IFACE_NAME,
 	ISCSI_NET_PARAM_MTU,
 	ISCSI_NET_PARAM_PORT,
+	ISCSI_NET_PARAM_IPADDR_STATE,
+	ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE,
+	ISCSI_NET_PARAM_IPV6_ROUTER_STATE,
+	ISCSI_NET_PARAM_DELAYED_ACK_EN,
+	ISCSI_NET_PARAM_ISNS_EN,
+	ISCSI_NET_PARAM_ISNS_ADDR,
+	ISCSI_NET_PARAM_ISNS_PORT,
+	ISCSI_NET_PARAM_NAGLE_EN,
+	ISCSI_NET_PARAM_TCP_WIN_SCALE_EN,
+	ISCSI_NET_PARAM_TCP_WIN_SCALE,
+	ISCSI_NET_PARAM_TCP_TIMER_SCALE,
+	ISCSI_NET_PARAM_TCP_TIMESTAMP_EN,
+	ISCSI_NET_PARAM_CACHE_ID,
+	ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_REQ_ISNS_INFO_EN,
+	ISCSI_NET_PARAM_IPV4_TOS_EN,
+	ISCSI_NET_PARAM_IPV4_TOS,
+	ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID,
+	ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID,
+	ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN,
+	ISCSI_NET_PARAM_IPV4_FRAGMENT_EN,
+	ISCSI_NET_PARAM_IPV4_IN_FORWARD_EN,
+	ISCSI_NET_PARAM_IPV4_TTL,
+	ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN,
+	ISCSI_NET_PARAM_IPV6_MLD_EN,
+	ISCSI_NET_PARAM_IPV6_FLOW_LABEL,
+	ISCSI_NET_PARAM_IPV6_TRAFFIC_CLASS,
+	ISCSI_NET_PARAM_IPV6_HOP_LIMIT,
+	ISCSI_NET_PARAM_IPV6_ND_REACHABLE_TMO,
+	ISCSI_NET_PARAM_IPV6_ND_REXMIT_TIME,
+	ISCSI_NET_PARAM_IPV6_ND_STALE_TMO,
+	ISCSI_NET_PARAM_IPV6_DUP_ADDR_DET_CNT,
+	ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU,
+	ISCSI_NET_PARAM_REDIRECT_EN,
+	ISCSI_NET_PARAM_DEF_TMF_TMO,
+	ISCSI_NET_PARAM_DEF_HDRDGST_EN,
+	ISCSI_NET_PARAM_DEF_DATADGST_EN,
+	ISCSI_NET_PARAM_DEF_IMM_DATA_EN,
+	ISCSI_NET_PARAM_DEF_INITIAL_R2T_EN,
+	ISCSI_NET_PARAM_DEF_DATASEQ_INORDER_EN,
+	ISCSI_NET_PARAM_DEF_PDU_INORDER_EN,
+	ISCSI_NET_PARAM_DEF_ERL,
+	ISCSI_NET_PARAM_DEF_MAX_RECV_DLENGTH,
+	ISCSI_NET_PARAM_DEF_FIRST_BURST,
+	ISCSI_NET_PARAM_DEF_MAX_R2T,
+	ISCSI_NET_PARAM_DEF_MAX_BURST,
+	ISCSI_NET_PARAM_DEF_CHAP_AUTH_EN,
+	ISCSI_NET_PARAM_DEF_BIDI_CHAP_EN,
+	ISCSI_NET_PARAM_DEF_STRICT_LOGIN_COMP_EN,
+	ISCSI_NET_PARAM_DEF_DISCOVERY_AUTH_EN,
+	ISCSI_NET_PARAM_DEF_DISCOVERY_LOGOUT_EN,
+	ISCSI_NET_PARAM_DEF_ISCSI_NAME,
+};
+
+enum iscsi_ipaddress_state {
+	ISCSI_IPDDRESS_STATE_UNCONFIGURED,
+	ISCSI_IPDDRESS_STATE_ACQUIRING,
+	ISCSI_IPDDRESS_STATE_TENTATIVE,
+	ISCSI_IPDDRESS_STATE_VALID,
+	ISCSI_IPDDRESS_STATE_DISABLING,
+	ISCSI_IPDDRESS_STATE_INVALID,
+	ISCSI_IPDDRESS_STATE_DEPRECATED,
+};
+
+enum iscsi_router_state {
+	ISCSI_ROUTER_STATE_UNKNOWN,
+	ISCSI_ROUTER_STATE_ADVERTISED,
+	ISCSI_ROUTER_STATE_MANUAL,
+	ISCSI_ROUTER_STATE_STALE,
 };
 
 enum iscsi_conn_state {
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d0f1602..d6f2420 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -477,4 +477,7 @@ iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 extern struct device *
 iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess);
 
+extern char *
+iscsi_get_ipaddress_state_name(enum iscsi_ipaddress_state port_state);
+extern char *iscsi_get_router_state_name(enum iscsi_router_state router_state);
 #endif
-- 
1.8.2.GIT


