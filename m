From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH V2 2/4] iscsi_transport: Additional parameters for network settings
Date: Fri, 18 Oct 2013 09:01:41 -0400
Message-ID: <1382101303-3420-3-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1382101303-3420-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:10083 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684Ab3JRNdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Oct 2013 09:33:31 -0400
In-Reply-To: <1382101303-3420-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Added support to display and update additional network parameters
through iscsiadm.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |  340 ++++++++++++++++++++++++++++++++++-
 include/scsi/iscsi_if.h             |   79 ++++++++
 include/scsi/scsi_transport_iscsi.h |    3 +
 3 files changed, 419 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 63a6ca4..9477f84 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -305,20 +305,71 @@ show_##type##_##name(struct device *dev, struct device_attribute *attr,	\
 	iscsi_iface_attr_show(type, name, ISCSI_NET_PARAM, param)	\
 static ISCSI_IFACE_ATTR(type, name, S_IRUGO, show_##type##_##name, NULL);
 
-/* generic read only ipvi4 attribute */
+#define iscsi_iface_attr(type, name, param)				\
+	iscsi_iface_attr_show(type, name, ISCSI_IFACE_PARAM, param)	\
+static ISCSI_IFACE_ATTR(type, name, S_IRUGO, show_##type##_##name, NULL);
+
+/* generic read only ipv4 attribute */
 iscsi_iface_net_attr(ipv4_iface, ipaddress, ISCSI_NET_PARAM_IPV4_ADDR);
 iscsi_iface_net_attr(ipv4_iface, gateway, ISCSI_NET_PARAM_IPV4_GW);
 iscsi_iface_net_attr(ipv4_iface, subnet, ISCSI_NET_PARAM_IPV4_SUBNET);
 iscsi_iface_net_attr(ipv4_iface, bootproto, ISCSI_NET_PARAM_IPV4_BOOTPROTO);
+iscsi_iface_net_attr(ipv4_iface, dhcp_dns_address_en,
+		     ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_slp_da_info_en,
+		     ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN);
+iscsi_iface_net_attr(ipv4_iface, tos_en, ISCSI_NET_PARAM_IPV4_TOS_EN);
+iscsi_iface_net_attr(ipv4_iface, tos, ISCSI_NET_PARAM_IPV4_TOS);
+iscsi_iface_net_attr(ipv4_iface, grat_arp_en,
+		     ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_alt_client_id_en,
+		     ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_alt_client_id,
+		     ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID);
+iscsi_iface_net_attr(ipv4_iface, dhcp_req_vendor_id_en,
+		     ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_use_vendor_id_en,
+		     ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN);
+iscsi_iface_net_attr(ipv4_iface, dhcp_vendor_id,
+		     ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID);
+iscsi_iface_net_attr(ipv4_iface, dhcp_learn_iqn_en,
+		     ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN);
+iscsi_iface_net_attr(ipv4_iface, fragment_disable,
+		     ISCSI_NET_PARAM_IPV4_FRAGMENT_DISABLE);
+iscsi_iface_net_attr(ipv4_iface, incoming_forwarding_en,
+		     ISCSI_NET_PARAM_IPV4_IN_FORWARD_EN);
+iscsi_iface_net_attr(ipv4_iface, ttl, ISCSI_NET_PARAM_IPV4_TTL);
 
 /* generic read only ipv6 attribute */
 iscsi_iface_net_attr(ipv6_iface, ipaddress, ISCSI_NET_PARAM_IPV6_ADDR);
-iscsi_iface_net_attr(ipv6_iface, link_local_addr, ISCSI_NET_PARAM_IPV6_LINKLOCAL);
+iscsi_iface_net_attr(ipv6_iface, link_local_addr,
+		     ISCSI_NET_PARAM_IPV6_LINKLOCAL);
 iscsi_iface_net_attr(ipv6_iface, router_addr, ISCSI_NET_PARAM_IPV6_ROUTER);
 iscsi_iface_net_attr(ipv6_iface, ipaddr_autocfg,
 		     ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG);
 iscsi_iface_net_attr(ipv6_iface, link_local_autocfg,
 		     ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG);
+iscsi_iface_net_attr(ipv6_iface, link_local_state,
+		     ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE);
+iscsi_iface_net_attr(ipv6_iface, router_state,
+		     ISCSI_NET_PARAM_IPV6_ROUTER_STATE);
+iscsi_iface_net_attr(ipv6_iface, grat_neighbor_adv_en,
+		     ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN);
+iscsi_iface_net_attr(ipv6_iface, mld_en, ISCSI_NET_PARAM_IPV6_MLD_EN);
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
+iscsi_iface_net_attr(ipv6_iface, dup_addr_detect_cnt,
+		     ISCSI_NET_PARAM_IPV6_DUP_ADDR_DETECT_CNT);
+iscsi_iface_net_attr(ipv6_iface, router_adv_link_mtu,
+		     ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU);
 
 /* common read only iface attribute */
 iscsi_iface_net_attr(iface, enabled, ISCSI_NET_PARAM_IFACE_ENABLE);
@@ -327,6 +378,40 @@ iscsi_iface_net_attr(iface, vlan_priority, ISCSI_NET_PARAM_VLAN_PRIORITY);
 iscsi_iface_net_attr(iface, vlan_enabled, ISCSI_NET_PARAM_VLAN_ENABLED);
 iscsi_iface_net_attr(iface, mtu, ISCSI_NET_PARAM_MTU);
 iscsi_iface_net_attr(iface, port, ISCSI_NET_PARAM_PORT);
+iscsi_iface_net_attr(iface, ipaddress_state, ISCSI_NET_PARAM_IPADDR_STATE);
+iscsi_iface_net_attr(iface, delayed_ack_en, ISCSI_NET_PARAM_DELAYED_ACK_EN);
+iscsi_iface_net_attr(iface, tcp_nagle_disable,
+		     ISCSI_NET_PARAM_TCP_NAGLE_DISABLE);
+iscsi_iface_net_attr(iface, tcp_wsf_disable, ISCSI_NET_PARAM_TCP_WSF_DISABLE);
+iscsi_iface_net_attr(iface, tcp_wsf, ISCSI_NET_PARAM_TCP_WSF);
+iscsi_iface_net_attr(iface, tcp_timer_scale, ISCSI_NET_PARAM_TCP_TIMER_SCALE);
+iscsi_iface_net_attr(iface, tcp_timestamp_en, ISCSI_NET_PARAM_TCP_TIMESTAMP_EN);
+iscsi_iface_net_attr(iface, cache_id, ISCSI_NET_PARAM_CACHE_ID);
+iscsi_iface_net_attr(iface, redirect_en, ISCSI_NET_PARAM_REDIRECT_EN);
+
+/* common iscsi specific settings attributes */
+iscsi_iface_attr(iface, def_taskmgmt_tmo, ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO);
+iscsi_iface_attr(iface, header_digest, ISCSI_IFACE_PARAM_HDRDGST_EN);
+iscsi_iface_attr(iface, data_digest, ISCSI_IFACE_PARAM_DATADGST_EN);
+iscsi_iface_attr(iface, immediate_data, ISCSI_IFACE_PARAM_IMM_DATA_EN);
+iscsi_iface_attr(iface, initial_r2t, ISCSI_IFACE_PARAM_INITIAL_R2T_EN);
+iscsi_iface_attr(iface, data_seq_in_order,
+		 ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN);
+iscsi_iface_attr(iface, data_pdu_in_order, ISCSI_IFACE_PARAM_PDU_INORDER_EN);
+iscsi_iface_attr(iface, erl, ISCSI_IFACE_PARAM_ERL);
+iscsi_iface_attr(iface, max_recv_dlength, ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH);
+iscsi_iface_attr(iface, first_burst_len, ISCSI_IFACE_PARAM_FIRST_BURST);
+iscsi_iface_attr(iface, max_outstanding_r2t, ISCSI_IFACE_PARAM_MAX_R2T);
+iscsi_iface_attr(iface, max_burst_len, ISCSI_IFACE_PARAM_MAX_BURST);
+iscsi_iface_attr(iface, chap_auth, ISCSI_IFACE_PARAM_CHAP_AUTH_EN);
+iscsi_iface_attr(iface, bidi_chap, ISCSI_IFACE_PARAM_BIDI_CHAP_EN);
+iscsi_iface_attr(iface, discovery_auth_optional,
+		 ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL);
+iscsi_iface_attr(iface, discovery_logout,
+		 ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN);
+iscsi_iface_attr(iface, strict_login_comp_en,
+		 ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN);
+iscsi_iface_attr(iface, initiator_name, ISCSI_IFACE_PARAM_INITIATOR_NAME);
 
 static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 					  struct attribute *attr, int i)
@@ -335,6 +420,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
 	struct iscsi_transport *t = iface->transport;
 	int param;
+	int param_type;
 
 	if (attr == &dev_attr_iface_enabled.attr)
 		param = ISCSI_NET_PARAM_IFACE_ENABLE;
@@ -348,6 +434,60 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_NET_PARAM_MTU;
 	else if (attr == &dev_attr_iface_port.attr)
 		param = ISCSI_NET_PARAM_PORT;
+	else if (attr == &dev_attr_iface_ipaddress_state.attr)
+		param = ISCSI_NET_PARAM_IPADDR_STATE;
+	else if (attr == &dev_attr_iface_delayed_ack_en.attr)
+		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
+	else if (attr == &dev_attr_iface_tcp_nagle_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_NAGLE_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF;
+	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
+	else if (attr == &dev_attr_iface_tcp_timestamp_en.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
+	else if (attr == &dev_attr_iface_cache_id.attr)
+		param = ISCSI_NET_PARAM_CACHE_ID;
+	else if (attr == &dev_attr_iface_redirect_en.attr)
+		param = ISCSI_NET_PARAM_REDIRECT_EN;
+	else if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
+		param = ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO;
+	else if (attr == &dev_attr_iface_header_digest.attr)
+		param = ISCSI_IFACE_PARAM_HDRDGST_EN;
+	else if (attr == &dev_attr_iface_data_digest.attr)
+		param = ISCSI_IFACE_PARAM_DATADGST_EN;
+	else if (attr == &dev_attr_iface_immediate_data.attr)
+		param = ISCSI_IFACE_PARAM_IMM_DATA_EN;
+	else if (attr == &dev_attr_iface_initial_r2t.attr)
+		param = ISCSI_IFACE_PARAM_INITIAL_R2T_EN;
+	else if (attr == &dev_attr_iface_data_seq_in_order.attr)
+		param = ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN;
+	else if (attr == &dev_attr_iface_data_pdu_in_order.attr)
+		param = ISCSI_IFACE_PARAM_PDU_INORDER_EN;
+	else if (attr == &dev_attr_iface_erl.attr)
+		param = ISCSI_IFACE_PARAM_ERL;
+	else if (attr == &dev_attr_iface_max_recv_dlength.attr)
+		param = ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH;
+	else if (attr == &dev_attr_iface_first_burst_len.attr)
+		param = ISCSI_IFACE_PARAM_FIRST_BURST;
+	else if (attr == &dev_attr_iface_max_outstanding_r2t.attr)
+		param = ISCSI_IFACE_PARAM_MAX_R2T;
+	else if (attr == &dev_attr_iface_max_burst_len.attr)
+		param = ISCSI_IFACE_PARAM_MAX_BURST;
+	else if (attr == &dev_attr_iface_chap_auth.attr)
+		param = ISCSI_IFACE_PARAM_CHAP_AUTH_EN;
+	else if (attr == &dev_attr_iface_bidi_chap.attr)
+		param = ISCSI_IFACE_PARAM_BIDI_CHAP_EN;
+	else if (attr == &dev_attr_iface_discovery_auth_optional.attr)
+		param = ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL;
+	else if (attr == &dev_attr_iface_discovery_logout.attr)
+		param = ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN;
+	else if (attr == &dev_attr_iface_strict_login_comp_en.attr)
+		param = ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN;
+	else if (attr == &dev_attr_iface_initiator_name.attr)
+		param = ISCSI_IFACE_PARAM_INITIATOR_NAME;
 	else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
 		if (attr == &dev_attr_ipv4_iface_ipaddress.attr)
 			param = ISCSI_NET_PARAM_IPV4_ADDR;
@@ -357,6 +497,42 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 			param = ISCSI_NET_PARAM_IPV4_SUBNET;
 		else if (attr == &dev_attr_ipv4_iface_bootproto.attr)
 			param = ISCSI_NET_PARAM_IPV4_BOOTPROTO;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_dns_address_en.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_slp_da_info_en.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN;
+		else if (attr == &dev_attr_ipv4_iface_tos_en.attr)
+			param = ISCSI_NET_PARAM_IPV4_TOS_EN;
+		else if (attr == &dev_attr_ipv4_iface_tos.attr)
+			param = ISCSI_NET_PARAM_IPV4_TOS;
+		else if (attr == &dev_attr_ipv4_iface_grat_arp_en.attr)
+			param = ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_alt_client_id_en.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN;
+		else if (attr == &dev_attr_ipv4_iface_dhcp_alt_client_id.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_req_vendor_id_en.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_use_vendor_id_en.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN;
+		else if (attr == &dev_attr_ipv4_iface_dhcp_vendor_id.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_dhcp_learn_iqn_en.attr)
+			param = ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_fragment_disable.attr)
+			param = ISCSI_NET_PARAM_IPV4_FRAGMENT_DISABLE;
+		else if (attr ==
+			 &dev_attr_ipv4_iface_incoming_forwarding_en.attr)
+			param = ISCSI_NET_PARAM_IPV4_IN_FORWARD_EN;
+		else if (attr == &dev_attr_ipv4_iface_ttl.attr)
+			param = ISCSI_NET_PARAM_IPV4_TTL;
 		else
 			return 0;
 	} else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV6) {
@@ -370,6 +546,31 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 			param = ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG;
 		else if (attr == &dev_attr_ipv6_iface_link_local_autocfg.attr)
 			param = ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG;
+		else if (attr == &dev_attr_ipv6_iface_link_local_state.attr)
+			param = ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE;
+		else if (attr == &dev_attr_ipv6_iface_router_state.attr)
+			param = ISCSI_NET_PARAM_IPV6_ROUTER_STATE;
+		else if (attr ==
+			 &dev_attr_ipv6_iface_grat_neighbor_adv_en.attr)
+			param = ISCSI_NET_PARAM_IPV6_GRAT_NEIGHBOR_ADV_EN;
+		else if (attr == &dev_attr_ipv6_iface_mld_en.attr)
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
+		else if (attr == &dev_attr_ipv6_iface_dup_addr_detect_cnt.attr)
+			param = ISCSI_NET_PARAM_IPV6_DUP_ADDR_DETECT_CNT;
+		else if (attr == &dev_attr_ipv6_iface_router_adv_link_mtu.attr)
+			param = ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU;
 		else
 			return 0;
 	} else {
@@ -377,7 +578,32 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		return 0;
 	}
 
-	return t->attr_is_visible(ISCSI_NET_PARAM, param);
+	switch (param) {
+	case ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO:
+	case ISCSI_IFACE_PARAM_HDRDGST_EN:
+	case ISCSI_IFACE_PARAM_DATADGST_EN:
+	case ISCSI_IFACE_PARAM_IMM_DATA_EN:
+	case ISCSI_IFACE_PARAM_INITIAL_R2T_EN:
+	case ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN:
+	case ISCSI_IFACE_PARAM_PDU_INORDER_EN:
+	case ISCSI_IFACE_PARAM_ERL:
+	case ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH:
+	case ISCSI_IFACE_PARAM_FIRST_BURST:
+	case ISCSI_IFACE_PARAM_MAX_R2T:
+	case ISCSI_IFACE_PARAM_MAX_BURST:
+	case ISCSI_IFACE_PARAM_CHAP_AUTH_EN:
+	case ISCSI_IFACE_PARAM_BIDI_CHAP_EN:
+	case ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL:
+	case ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN:
+	case ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN:
+	case ISCSI_IFACE_PARAM_INITIATOR_NAME:
+		param_type = ISCSI_IFACE_PARAM;
+		break;
+	default:
+		param_type = ISCSI_NET_PARAM;
+	}
+
+	return t->attr_is_visible(param_type, param);
 }
 
 static struct attribute *iscsi_iface_attrs[] = {
@@ -396,6 +622,59 @@ static struct attribute *iscsi_iface_attrs[] = {
 	&dev_attr_ipv6_iface_link_local_autocfg.attr,
 	&dev_attr_iface_mtu.attr,
 	&dev_attr_iface_port.attr,
+	&dev_attr_iface_ipaddress_state.attr,
+	&dev_attr_iface_delayed_ack_en.attr,
+	&dev_attr_iface_tcp_nagle_disable.attr,
+	&dev_attr_iface_tcp_wsf_disable.attr,
+	&dev_attr_iface_tcp_wsf.attr,
+	&dev_attr_iface_tcp_timer_scale.attr,
+	&dev_attr_iface_tcp_timestamp_en.attr,
+	&dev_attr_iface_cache_id.attr,
+	&dev_attr_iface_redirect_en.attr,
+	&dev_attr_iface_def_taskmgmt_tmo.attr,
+	&dev_attr_iface_header_digest.attr,
+	&dev_attr_iface_data_digest.attr,
+	&dev_attr_iface_immediate_data.attr,
+	&dev_attr_iface_initial_r2t.attr,
+	&dev_attr_iface_data_seq_in_order.attr,
+	&dev_attr_iface_data_pdu_in_order.attr,
+	&dev_attr_iface_erl.attr,
+	&dev_attr_iface_max_recv_dlength.attr,
+	&dev_attr_iface_first_burst_len.attr,
+	&dev_attr_iface_max_outstanding_r2t.attr,
+	&dev_attr_iface_max_burst_len.attr,
+	&dev_attr_iface_chap_auth.attr,
+	&dev_attr_iface_bidi_chap.attr,
+	&dev_attr_iface_discovery_auth_optional.attr,
+	&dev_attr_iface_discovery_logout.attr,
+	&dev_attr_iface_strict_login_comp_en.attr,
+	&dev_attr_iface_initiator_name.attr,
+	&dev_attr_ipv4_iface_dhcp_dns_address_en.attr,
+	&dev_attr_ipv4_iface_dhcp_slp_da_info_en.attr,
+	&dev_attr_ipv4_iface_tos_en.attr,
+	&dev_attr_ipv4_iface_tos.attr,
+	&dev_attr_ipv4_iface_grat_arp_en.attr,
+	&dev_attr_ipv4_iface_dhcp_alt_client_id_en.attr,
+	&dev_attr_ipv4_iface_dhcp_alt_client_id.attr,
+	&dev_attr_ipv4_iface_dhcp_req_vendor_id_en.attr,
+	&dev_attr_ipv4_iface_dhcp_use_vendor_id_en.attr,
+	&dev_attr_ipv4_iface_dhcp_vendor_id.attr,
+	&dev_attr_ipv4_iface_dhcp_learn_iqn_en.attr,
+	&dev_attr_ipv4_iface_fragment_disable.attr,
+	&dev_attr_ipv4_iface_incoming_forwarding_en.attr,
+	&dev_attr_ipv4_iface_ttl.attr,
+	&dev_attr_ipv6_iface_link_local_state.attr,
+	&dev_attr_ipv6_iface_router_state.attr,
+	&dev_attr_ipv6_iface_grat_neighbor_adv_en.attr,
+	&dev_attr_ipv6_iface_mld_en.attr,
+	&dev_attr_ipv6_iface_flow_label.attr,
+	&dev_attr_ipv6_iface_traffic_class.attr,
+	&dev_attr_ipv6_iface_hop_limit.attr,
+	&dev_attr_ipv6_iface_nd_reachable_tmo.attr,
+	&dev_attr_ipv6_iface_nd_rexmit_time.attr,
+	&dev_attr_ipv6_iface_nd_stale_tmo.attr,
+	&dev_attr_ipv6_iface_dup_addr_detect_cnt.attr,
+	&dev_attr_ipv6_iface_router_adv_link_mtu.attr,
 	NULL,
 };
 
@@ -404,6 +683,61 @@ static struct attribute_group iscsi_iface_group = {
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
+		if (iscsi_router_state_names[i].value == router_state) {
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
index 765c982..a572083 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -311,6 +311,7 @@ enum iscsi_param_type {
 	ISCSI_NET_PARAM,	/* iscsi_net_param */
 	ISCSI_FLASHNODE_PARAM,	/* iscsi_flashnode_param */
 	ISCSI_CHAP_PARAM,	/* iscsi_chap_param */
+	ISCSI_IFACE_PARAM,	/* iscsi_iface_param */
 };
 
 /* structure for minimalist usecase */
@@ -383,6 +384,10 @@ struct iscsi_path {
 #define ISCSI_VLAN_DISABLE	0x01
 #define ISCSI_VLAN_ENABLE	0x02
 
+/* iscsi generic enable/disabled setting for various features */
+#define ISCSI_NET_PARAM_DISABLE		0x01
+#define ISCSI_NET_PARAM_ENABLE		0x02
+
 /* iSCSI network params */
 enum iscsi_net_param {
 	ISCSI_NET_PARAM_IPV4_ADDR		= 1,
@@ -405,6 +410,80 @@ enum iscsi_net_param {
 	ISCSI_NET_PARAM_IFACE_NAME,
 	ISCSI_NET_PARAM_MTU,
 	ISCSI_NET_PARAM_PORT,
+	ISCSI_NET_PARAM_IPADDR_STATE,
+	ISCSI_NET_PARAM_IPV6_LINKLOCAL_STATE,
+	ISCSI_NET_PARAM_IPV6_ROUTER_STATE,
+	ISCSI_NET_PARAM_DELAYED_ACK_EN,
+	ISCSI_NET_PARAM_TCP_NAGLE_DISABLE,
+	ISCSI_NET_PARAM_TCP_WSF_DISABLE,
+	ISCSI_NET_PARAM_TCP_WSF,
+	ISCSI_NET_PARAM_TCP_TIMER_SCALE,
+	ISCSI_NET_PARAM_TCP_TIMESTAMP_EN,
+	ISCSI_NET_PARAM_CACHE_ID,
+	ISCSI_NET_PARAM_IPV4_DHCP_DNS_ADDR_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_SLP_DA_EN,
+	ISCSI_NET_PARAM_IPV4_TOS_EN,
+	ISCSI_NET_PARAM_IPV4_TOS,
+	ISCSI_NET_PARAM_IPV4_GRAT_ARP_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_ALT_CLIENT_ID,
+	ISCSI_NET_PARAM_IPV4_DHCP_REQ_VENDOR_ID_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_USE_VENDOR_ID_EN,
+	ISCSI_NET_PARAM_IPV4_DHCP_VENDOR_ID,
+	ISCSI_NET_PARAM_IPV4_DHCP_LEARN_IQN_EN,
+	ISCSI_NET_PARAM_IPV4_FRAGMENT_DISABLE,
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
+	ISCSI_NET_PARAM_IPV6_DUP_ADDR_DETECT_CNT,
+	ISCSI_NET_PARAM_IPV6_RTR_ADV_LINK_MTU,
+	ISCSI_NET_PARAM_REDIRECT_EN,
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
+};
+
+/* iSCSI specific settings params for iface */
+enum iscsi_iface_param {
+	ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO,
+	ISCSI_IFACE_PARAM_HDRDGST_EN,
+	ISCSI_IFACE_PARAM_DATADGST_EN,
+	ISCSI_IFACE_PARAM_IMM_DATA_EN,
+	ISCSI_IFACE_PARAM_INITIAL_R2T_EN,
+	ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN,
+	ISCSI_IFACE_PARAM_PDU_INORDER_EN,
+	ISCSI_IFACE_PARAM_ERL,
+	ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH,
+	ISCSI_IFACE_PARAM_FIRST_BURST,
+	ISCSI_IFACE_PARAM_MAX_R2T,
+	ISCSI_IFACE_PARAM_MAX_BURST,
+	ISCSI_IFACE_PARAM_CHAP_AUTH_EN,
+	ISCSI_IFACE_PARAM_BIDI_CHAP_EN,
+	ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL,
+	ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN,
+	ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN,
+	ISCSI_IFACE_PARAM_INITIATOR_NAME,
 };
 
 enum iscsi_conn_state {
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fe7c8f3..2ac11fe 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -478,4 +478,7 @@ iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 extern struct device *
 iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess);
 
+extern char *
+iscsi_get_ipaddress_state_name(enum iscsi_ipaddress_state port_state);
+extern char *iscsi_get_router_state_name(enum iscsi_router_state router_state);
 #endif
-- 
1.7.1

