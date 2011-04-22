From: vikas.chaudhary@qlogic.com
Subject: [PATCH 5/5] qla4xxx: added support to show multiple iface in sysfs
Date: Fri, 22 Apr 2011 11:07:46 -0700
Message-ID: <1303495666-731-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46867 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753697Ab1DVSNV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 14:13:21 -0400
In-Reply-To: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Reviewed-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Reviewed-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    3 +
 drivers/scsi/qla4xxx/ql4_os.c  |  114 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index bce5c89..3a0316c 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -588,6 +588,9 @@ struct scsi_qla_host {
 
 	struct completion mbx_intr_comp;
 	struct ipaddress_config ip_config;
+	struct iscsi_iface *iface_ipv4;
+	struct iscsi_iface *iface_ipv6_1;
+	struct iscsi_iface *iface_ipv6_2;
 };
 
 static inline int is_ipv4_enabled(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 09e371f..673deb3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -82,6 +82,8 @@ static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf);
 static int qla4xxx_set_net_config(struct Scsi_Host *shost, char *data,
 				  int count);
+static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
+				   enum iscsi_net_param_type param, char *buf);
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
 
@@ -139,16 +141,95 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
+	.ipv4_iface_param_mask	= ISCSI_NET_IPV4_ADDR |
+				  ISCSI_NET_IPV4_SUBNET |
+				  ISCSI_NET_IPV4_GW |
+				  ISCSI_NET_IPV4_BOOTPROTO |
+				  ISCSI_NET_IFACE_ENABLED,
+	.ipv6_iface_param_mask	= ISCSI_NET_IPV6_LINKLOCAL |
+				  ISCSI_NET_IPV6_ADDR |
+				  ISCSI_NET_IPV6_ROUTER |
+				  ISCSI_NET_IPV6_ADDR_AUTOCFG |
+				  ISCSI_NET_IPV6_LINKLOCAL_AUTOCFG |
+				  ISCSI_NET_IFACE_ENABLED,
 	.tgt_dscvr		= qla4xxx_tgt_dscvr,
 	.get_conn_param		= qla4xxx_conn_get_param,
 	.get_session_param	= qla4xxx_sess_get_param,
 	.get_host_param		= qla4xxx_host_get_param,
 	.set_net_config		= qla4xxx_set_net_config,
 	.session_recovery_timedout = qla4xxx_recovery_timedout,
+	.get_iface_param	= qla4xxx_get_iface_param,
 };
 
 static struct scsi_transport_template *qla4xxx_scsi_transport;
 
+static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
+				   enum iscsi_net_param_type param, char *buf)
+{
+	struct Scsi_Host *shost = iscsi_iface_to_shost(iface);
+	struct scsi_qla_host *ha = to_qla_host(shost);
+	int len = -ENOSYS;
+
+	switch (param) {
+	case ISCSI_NET_PARAM_IPV4_ADDR:
+		len = sprintf(buf, "%pI4\n", &ha->ip_config.ip_address);
+		break;
+	case ISCSI_NET_PARAM_IPV4_SUBNET:
+		len = sprintf(buf, "%pI4\n", &ha->ip_config.subnet_mask);
+		break;
+	case ISCSI_NET_PARAM_IPV4_GW:
+		len = sprintf(buf, "%pI4\n", &ha->ip_config.gateway);
+		break;
+	case ISCSI_NET_PARAM_IFACE_ENABLED:
+		if (iface->iface_type == IFACE_TYPE_IPV4)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv4_options &
+				       IPOPT_IPV4_PROTOCOL_ENABLE) ?
+				      "true" : "false");
+		else if (iface->iface_type == IFACE_TYPE_IPV6)
+			len = sprintf(buf, "%s\n",
+				      (ha->ip_config.ipv6_options &
+				       IPV6_OPT_IPV6_PROTOCOL_ENABLE) ?
+				       "true" : "false");
+		break;
+	case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.tcp_options & TCPOPT_DHCP_ENABLE) ?
+			      "dhcp" : "static");
+		break;
+	case ISCSI_NET_PARAM_IPV6_ADDR:
+		if (iface->iface_num == 1)
+			len = sprintf(buf, "%pI6\n", &ha->ip_config.ipv6_addr0);
+		if (iface->iface_num == 2)
+			len = sprintf(buf, "%pI6\n", &ha->ip_config.ipv6_addr1);
+		break;
+	case ISCSI_NET_PARAM_IPV6_LINKLOCAL:
+		len = sprintf(buf, "%pI6\n",
+			      &ha->ip_config.ipv6_link_local_addr);
+		break;
+	case ISCSI_NET_PARAM_IPV6_ROUTER:
+		len = sprintf(buf, "%pI6\n",
+			      &ha->ip_config.ipv6_default_router_addr);
+		break;
+	case ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv6_addl_options &
+			       IPV6_ADDOPT_NEIGHBOR_DISCOVERY_ADDR_ENABLE) ?
+			       "nd" : "static");
+		break;
+	case ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG:
+		len = sprintf(buf, "%s\n",
+			      (ha->ip_config.ipv6_addl_options &
+			       IPV6_ADDOPT_AUTOCONFIG_LINK_LOCAL_ADDR) ?
+			       "auto" : "static");
+		break;
+	default:
+		len = -ENOSYS;
+	}
+
+	return len;
+}
+
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *session;
@@ -1899,6 +1980,34 @@ uint16_t qla4_8xxx_rd_shdw_rsp_q_in(struct scsi_qla_host *ha)
 	return (uint16_t)le32_to_cpu(readl(&ha->qla4_8xxx_reg->rsp_q_in));
 }
 
+static void qla4xxx_create_iface(struct scsi_qla_host *ha)
+{
+	/* IPv4 */
+	ha->iface_ipv4 = iscsi_create_iface(ha->host,
+					    &qla4xxx_iscsi_transport,
+					    IFACE_TYPE_IPV4, 1, 0);
+
+	/* IPv6 iface-1 */
+	ha->iface_ipv6_1 = iscsi_create_iface(ha->host,
+					      &qla4xxx_iscsi_transport,
+					      IFACE_TYPE_IPV6, 1, 0);
+
+	/* IPv6 iface-2 */
+	ha->iface_ipv6_2 = iscsi_create_iface(ha->host,
+					      &qla4xxx_iscsi_transport,
+					      IFACE_TYPE_IPV6, 2, 0);
+}
+
+static void qla4xxx_destroy_iface(struct scsi_qla_host *ha)
+{
+	if (ha->iface_ipv4)
+		iscsi_destroy_iface(ha->iface_ipv4);
+	if (ha->iface_ipv6_1)
+		iscsi_destroy_iface(ha->iface_ipv6_1);
+	if (ha->iface_ipv6_2)
+		iscsi_destroy_iface(ha->iface_ipv6_2);
+}
+
 /**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
@@ -2099,6 +2208,8 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	       ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
 	       ha->patch_number, ha->build_number);
 	scsi_scan_host(host);
+
+	qla4xxx_create_iface(ha);
 	return 0;
 
 probe_failed:
@@ -2168,6 +2279,9 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
 	/* remove devs from iscsi_sessions to scsi_devices */
 	qla4xxx_free_ddb_list(ha);
 
+	/* destroy iface from sysfs */
+	qla4xxx_destroy_iface(ha);
+
 	scsi_remove_host(ha->host);
 
 	qla4xxx_free_adapter(ha);
-- 
1.7.3.2

