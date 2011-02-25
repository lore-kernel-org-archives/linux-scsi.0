From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 5/5] [RFC] qla4xxx: added support to show multiple iface in
 sysfs
Date: Fri, 25 Feb 2011 03:08:29 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8722624A357@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:4631
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932459Ab1BYLIk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 06:08:40 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>


Reviewed-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Reviewed-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    3 +
 drivers/scsi/qla4xxx/ql4_os.c  |   98 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 67280b5..6a49f8a 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -591,6 +591,9 @@ struct scsi_qla_host {

        struct completion mbx_intr_comp;
        struct ipaddress_config ip_config;
+       struct iscsi_iface *iface_ipv4;
+       struct iscsi_iface *iface_ipv6_1;
+       struct iscsi_iface *iface_ipv6_2;
 };

 static inline int is_ipv4_enabled(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index dfc52f3..c0ce5cf 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -75,6 +75,8 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
                                  enum iscsi_host_param param, char *buf);
 static int qla4xxx_set_net_config(struct Scsi_Host *shost, char *data,
                                  int count);
+static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
+                                  enum iscsi_net_param_type param, char *buf);
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);

@@ -132,16 +134,82 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
        .host_param_mask        = ISCSI_HOST_HWADDRESS |
                                  ISCSI_HOST_IPADDRESS |
                                  ISCSI_HOST_INITIATOR_NAME,
+       .ipv4_iface_param_mask  = ISCSI_NET_IPV4_ADDR |
+                                 ISCSI_NET_IPV4_SUBNET |
+                                 ISCSI_NET_IPV4_GW |
+                                 ISCSI_NET_IPV4_BOOTPROTO |
+                                 ISCSI_NET_NET_STATE,
+       .ipv6_iface_param_mask  = ISCSI_NET_IPV6_LINKLOCAL |
+                                 ISCSI_NET_IPV6_ADDR |
+                                 ISCSI_NET_IPV6_ROUTER |
+                                 ISCSI_NET_NET_STATE,
        .tgt_dscvr              = qla4xxx_tgt_dscvr,
        .get_conn_param         = qla4xxx_conn_get_param,
        .get_session_param      = qla4xxx_sess_get_param,
        .get_host_param         = qla4xxx_host_get_param,
        .set_net_config         = qla4xxx_set_net_config,
        .session_recovery_timedout = qla4xxx_recovery_timedout,
+       .get_iface_param        = qla4xxx_get_iface_param,
 };

 static struct scsi_transport_template *qla4xxx_scsi_transport;

+static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
+                                  enum iscsi_net_param_type param, char *buf)
+{
+       struct Scsi_Host *shost = iscsi_iface_to_shost(iface);
+       struct scsi_qla_host *ha = to_qla_host(shost);
+       int len = -ENOSYS;
+
+       switch (param) {
+       case ISCSI_NET_PARAM_IPV4_ADDR:
+               len = sprintf(buf, "%pI4\n", &ha->ip_config.ip_address);
+               break;
+       case ISCSI_NET_PARAM_IPV4_SUBNET:
+               len = sprintf(buf, "%pI4\n", &ha->ip_config.subnet_mask);
+               break;
+       case ISCSI_NET_PARAM_IPV4_GW:
+               len = sprintf(buf, "%pI4\n", &ha->ip_config.gateway);
+               break;
+       case ISCSI_NET_PARAM_NET_STATE:
+               if (iface->iface_type == IFACE_TYPE_IPV4)
+                       len = sprintf(buf, "%s\n",
+                           (ha->ip_config.ipv4_options &
+                            IPOPT_IPv4_PROTOCOL_ENABLE) ?
+                            "enable" : "disable");
+               else if (iface->iface_type == IFACE_TYPE_IPV6)
+                       len = sprintf(buf, "%s\n",
+                           (ha->ip_config.ipv6_options &
+                            IPV6_OPT_IPV6_PROTOCOL_ENABLE) ?
+                            "enable" : "disable");
+               break;
+       case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
+               len = sprintf(buf, "%s\n",
+                   (ha->ip_config.tcp_options & TCPOPT_DHCP_ENABLE) ?
+                   "dhcp" : "static");
+               break;
+       case ISCSI_NET_PARAM_IPV6_ADDR:
+               if (iface->iface_num == 1)
+                       len = sprintf(buf, "%pI6\n", &ha->ip_config.ipv6_addr0);
+               if (iface->iface_num == 2)
+                       len = sprintf(buf, "%pI6\n", &ha->ip_config.ipv6_addr1);
+               break;
+       case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
+               len = sprintf(buf, "%pI6\n",
+                   &ha->ip_config.ipv6_link_local_addr);
+               break;
+       case ISCSI_NET_PARAM_IPV6_ROUTER:
+               len = sprintf(buf, "%pI6\n",
+                   &ha->ip_config.ipv6_default_router_addr);
+               break;
+       default:
+               len = -ENOSYS;
+       }
+
+       return len;
+}
+
+
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
        struct iscsi_cls_session *session;
@@ -1930,6 +1998,31 @@ uint16_t qla4_8xxx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha)
        return (uint16_t)le32_to_cpu(readl(&ha->qla4_8xxx_reg->rsp_q_in));
 }

+static void qla4xxx_create_iface(struct scsi_qla_host *ha)
+{
+       /* IPv4 */
+       ha->iface_ipv4 = iscsi_create_iface(ha->host,
+           &qla4xxx_iscsi_transport, IFACE_TYPE_IPV4, 1, 0);
+
+       /* IPv6 iface-1 */
+       ha->iface_ipv6_1 = iscsi_create_iface(ha->host,
+           &qla4xxx_iscsi_transport, IFACE_TYPE_IPV6, 1, 0);
+
+       /* IPv6 iface-2 */
+       ha->iface_ipv6_2 = iscsi_create_iface(ha->host,
+           &qla4xxx_iscsi_transport, IFACE_TYPE_IPV6, 2, 0);
+}
+
+static void qla4xxx_destroy_iface(struct scsi_qla_host *ha)
+{
+       if (ha->iface_ipv4)
+               iscsi_destroy_iface(ha->iface_ipv4);
+       if (ha->iface_ipv6_1)
+               iscsi_destroy_iface(ha->iface_ipv6_1);
+       if (ha->iface_ipv6_2)
+               iscsi_destroy_iface(ha->iface_ipv6_2);
+}
+
 /**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
@@ -2117,6 +2210,8 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
               ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
               ha->patch_number, ha->build_number);
        scsi_scan_host(host);
+
+       qla4xxx_create_iface(ha);
        return 0;

 probe_failed:
@@ -2147,6 +2242,9 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
        /* remove devs from iscsi_sessions to scsi_devices */
        qla4xxx_free_ddb_list(ha);

+       /* destroy iface from sysfs */
+       qla4xxx_destroy_iface(ha);
+
        scsi_remove_host(ha->host);

        qla4xxx_free_adapter(ha);
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

