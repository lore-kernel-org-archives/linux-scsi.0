From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/5] [RFC] iscsi_transport: add set_net_config
Date: Fri, 25 Feb 2011 03:06:26 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8722624A353@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:38135
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932517Ab1BYLGi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 06:06:38 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Allows user space (iscsiadm) to send down network configuration parameters
for LLD to set private network configuration on the iSCSI adapters.

Reviewed-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Reviewed-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |   27 +++++++++++++++++++++++
 include/scsi/iscsi_if.h             |   41 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |    1 +
 3 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f905ecb..5201ebd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1542,6 +1542,30 @@ iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 }

 static int
+iscsi_set_net_config(struct iscsi_transport *transport,
+               struct iscsi_uevent *ev)
+{
+       char *data = (char *)ev + sizeof(*ev);
+       struct Scsi_Host *shost;
+       int err;
+
+       if (!transport->set_net_config)
+               return -ENOSYS;
+
+       shost = scsi_host_lookup(ev->u.set_net_config.host_no);
+       if (!shost) {
+               printk(KERN_ERR "set_net_config could not find host no %u\n",
+                      ev->u.set_net_config.host_no);
+               return -ENODEV;
+       }
+
+       err = transport->set_net_config(shost, data,
+                                       ev->u.set_net_config.count);
+       scsi_host_put(shost);
+       return err;
+}
+
+static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 {
        int err = 0;
@@ -1661,6 +1685,9 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
        case ISCSI_UEVENT_PATH_UPDATE:
                err = iscsi_set_path(transport, ev);
                break;
+       case ISCSI_UEVENT_SET_NET_CONFIG:
+               err = iscsi_set_net_config(transport, ev);
+               break;
        default:
                err = -ENOSYS;
                break;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index c3e1cbc..33e6d33 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -59,6 +59,7 @@ enum iscsi_uevent_e {
        ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST  = UEVENT_BASE + 19,

        ISCSI_UEVENT_PATH_UPDATE        = UEVENT_BASE + 20,
+       ISCSI_UEVENT_SET_NET_CONFIG     = UEVENT_BASE + 21,

        /* up events */
        ISCSI_KEVENT_RECV_PDU           = KEVENT_BASE + 1,
@@ -172,6 +173,10 @@ struct iscsi_uevent {
                struct msg_set_path {
                        uint32_t        host_no;
                } set_path;
+               struct msg_set_net_config {
+                       uint32_t        host_no;
+                       uint32_t        count;
+               } set_net_config;
        } u;
        union {
                /* messages k -> u */
@@ -237,6 +242,42 @@ struct iscsi_path {
        uint16_t        pmtu;
 } __attribute__ ((aligned (sizeof(uint64_t))));

+#define ISCSI_IPv6_AUTOCFG_LINKLOCAL_ADDR      0x01
+#define ISCSI_IPv6_AUTOCFG_ND_ADDR_ENABLE      0x02
+#define ISCSI_IPv6_AUTOCFG_DFLT_ROUTER_ADDR    0x04
+
+/* iSCSI network params */
+enum iscsi_net_param_type {
+       ISCSI_NET_PARAM_IPV4_ADDR       = 1,
+       ISCSI_NET_PARAM_IPV4_SUBNET     = 2,
+       ISCSI_NET_PARAM_IPV4_GW         = 3,
+       ISCSI_NET_PARAM_IPV4_BOOTPROTO  = 4,
+       ISCSI_NET_PARAM_VLAN            = 5,
+       ISCSI_NET_PARAM_MAC             = 6,
+       ISCSI_NET_PARAM_IPV6_LINKLOCAL  = 7,
+       ISCSI_NET_PARAM_IPV6_ADDR       = 8,
+       ISCSI_NET_PARAM_IPV6_ROUTER     = 9,
+       ISCSI_NET_PARAM_IPV6_AUTOCFG    = 10,
+       ISCSI_NET_PARAM_NET_STATE       = 11,
+};
+
+/* 10 param per iface * 10 iface per port = 100 params */
+#define ISCSI_MAX_IFACE_PER_HW         10
+#define ISCSI_MAX_PARAM_PER_IFACE      10
+#define ISCSI_MAX_NET_PARAMS (ISCSI_MAX_IFACE_PER_HW * \
+                             ISCSI_MAX_PARAM_PER_IFACE)
+
+#define IFACE_TYPE_IPV4                0
+#define IFACE_TYPE_IPV6                1
+struct iscsi_net_param {
+       uint32_t param_type;    /* enum iscsi_net_param */
+       uint32_t iface_type;    /* IPv4 or IPv6 */
+       uint32_t iface_num;     /* iface number, 0 - n */
+       uint32_t length;        /* Actual length of the param */
+       uint32_t offset;        /* For param with length > 256 */
+       uint8_t value[256];     /* max is 223 iscsi name */
+} __packed;
+
 /*
  * Common error codes
  */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 7fff94b..6fd0463 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -135,6 +135,7 @@ struct iscsi_transport {
        int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
                          uint32_t enable, struct sockaddr *dst_addr);
        int (*set_path) (struct Scsi_Host *shost, struct iscsi_path *params);
+       int (*set_net_config) (struct Scsi_Host *shost, char *data, int count);
 };

 /*
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

