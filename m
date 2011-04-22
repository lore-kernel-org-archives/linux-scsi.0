From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/5] iscsi_transport: add support for set_net_config
Date: Fri, 22 Apr 2011 11:07:42 -0700
Message-ID: <1303495666-731-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46846 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755232Ab1DVSNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 14:13:20 -0400
In-Reply-To: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Allows user space (iscsiadm) to send down network configuration parameters
for LLD to set private network configuration on the iSCSI adapters.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Reviewed-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |   27 ++++++++++++++++
 include/scsi/iscsi_if.h             |   58 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |    1 +
 3 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 3fd16d7..7596234 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1558,6 +1558,30 @@ iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 }
 
 static int
+iscsi_set_net_config(struct iscsi_transport *transport,
+		     struct iscsi_uevent *ev)
+{
+	char *data = (char *)ev + sizeof(*ev);
+	struct Scsi_Host *shost;
+	int err;
+
+	if (!transport->set_net_config)
+		return -ENOSYS;
+
+	shost = scsi_host_lookup(ev->u.set_net_config.host_no);
+	if (!shost) {
+		printk(KERN_ERR "set_net_config could not find host no %u\n",
+		       ev->u.set_net_config.host_no);
+		return -ENODEV;
+	}
+
+	err = transport->set_net_config(shost, data,
+					ev->u.set_net_config.count);
+	scsi_host_put(shost);
+	return err;
+}
+
+static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 {
 	int err = 0;
@@ -1696,6 +1720,9 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	case ISCSI_UEVENT_PATH_UPDATE:
 		err = iscsi_set_path(transport, ev);
 		break;
+	case ISCSI_UEVENT_SET_NET_CONFIG:
+		err = iscsi_set_net_config(transport, ev);
+		break;
 	default:
 		err = -ENOSYS;
 		break;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index ddb0456..449e55b 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -59,6 +59,7 @@ enum iscsi_uevent_e {
 	ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST	= UEVENT_BASE + 19,
 
 	ISCSI_UEVENT_PATH_UPDATE	= UEVENT_BASE + 20,
+	ISCSI_UEVENT_SET_NET_CONFIG	= UEVENT_BASE + 21,
 
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
@@ -172,6 +173,10 @@ struct iscsi_uevent {
 		struct msg_set_path {
 			uint32_t	host_no;
 		} set_path;
+		struct msg_set_net_config {
+			uint32_t	host_no;
+			uint32_t	count;
+		} set_net_config;
 	} u;
 	union {
 		/* messages k -> u */
@@ -237,6 +242,59 @@ struct iscsi_path {
 	uint16_t	pmtu;
 } __attribute__ ((aligned (sizeof(uint64_t))));
 
+#define ISCSI_FALSE	0
+#define ISCSI_TRUE	1
+
+/* ipv4 bootproto */
+#define ISCSI_BOOTPROTO_STATIC		0x01
+#define ISCSI_BOOTPROTO_DHCP		0x02
+
+/* ipv6 addr autoconfig type */
+#define ISCSI_IPV6_AUTOCFG_DISABLE		0x01
+#define ISCSI_IPV6_AUTOCFG_ND_ENABLE		0x02
+#define ISCSI_IPV6_AUTOCFG_DHCPV6_ENABLE	0x03
+
+/* ipv6 link local addr type */
+#define ISCSI_IPV6_LINKLOCAL_AUTOCFG_ENABLE	0x01
+#define ISCSI_IPV6_LINKLOCAL_AUTOCFG_DISABLE	0x02
+
+/* ipv6 router addr type */
+#define ISCSI_IPV6_ROUTER_AUTOCFG_ENABLE	0x01
+#define ISCSI_IPV6_ROUTER_AUTOCFG_DISABLE	0x02
+
+/* iSCSI network params */
+enum iscsi_net_param_type {
+	ISCSI_NET_PARAM_IPV4_ADDR		= 1,
+	ISCSI_NET_PARAM_IPV4_SUBNET		= 2,
+	ISCSI_NET_PARAM_IPV4_GW			= 3,
+	ISCSI_NET_PARAM_IPV4_BOOTPROTO		= 4,
+	ISCSI_NET_PARAM_MAC			= 5,
+	ISCSI_NET_PARAM_IPV6_LINKLOCAL		= 6,
+	ISCSI_NET_PARAM_IPV6_ADDR		= 7,
+	ISCSI_NET_PARAM_IPV6_ROUTER		= 8,
+	ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG	= 9,
+	ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG	= 10,
+	ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG	= 11,
+	ISCSI_NET_PARAM_IFACE_ENABLED		= 12,
+	ISCSI_NET_PARAM_VLAN			= 13,
+};
+
+/* 20 param per iface * 10 iface per port = 200 params */
+#define ISCSI_MAX_IFACE_PER_HW		10
+#define ISCSI_MAX_PARAM_PER_IFACE	20
+#define ISCSI_MAX_NET_PARAMS (ISCSI_MAX_IFACE_PER_HW * \
+			      ISCSI_MAX_PARAM_PER_IFACE)
+
+#define IFACE_TYPE_IPV4		0x01
+#define IFACE_TYPE_IPV6		0x02
+struct iscsi_net_param {
+	uint32_t param_type;	/* enum iscsi_net_param */
+	uint32_t iface_type;	/* IPv4 or IPv6 */
+	uint32_t iface_num;	/* iface number, 0 - n */
+	uint32_t length;	/* Actual length of the param */
+	uint8_t value[0];	/* length sized value follows */
+} __packed;
+
 /*
  * Common error codes
  */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index bf8f529..45b9df9 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -137,6 +137,7 @@ struct iscsi_transport {
 	int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
 			  uint32_t enable, struct sockaddr *dst_addr);
 	int (*set_path) (struct Scsi_Host *shost, struct iscsi_path *params);
+	int (*set_net_config) (struct Scsi_Host *shost, char *data, int count);
 };
 
 /*
-- 
1.7.3.2

