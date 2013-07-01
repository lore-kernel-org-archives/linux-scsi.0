From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH V2 2/4] libiscsi: Exporting new attrs for iscsi session and connection in sysfs
Date: Mon, 1 Jul 2013 05:54:12 -0400
Message-ID: <1372672454-31817-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1372672454-31817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:22455
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669Ab3GAKUt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 06:20:49 -0400
In-Reply-To: <1372672454-31817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/libiscsi.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/libiscsi.h |   31 +++++++++++++++
 2 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ae69dfc..86153e0 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2812,6 +2812,8 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->boot_nic);
 	kfree(session->boot_target);
 	kfree(session->ifacename);
+	kfree(session->portal_type);
+	kfree(session->discovery_parent_type);
 
 	iscsi_destroy_session(cls_session);
 	iscsi_host_dec_session_cnt(shost);
@@ -3257,6 +3259,11 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		return iscsi_switch_str_param(&session->boot_nic, buf);
 	case ISCSI_PARAM_BOOT_TARGET:
 		return iscsi_switch_str_param(&session->boot_target, buf);
+	case ISCSI_PARAM_PORTAL_TYPE:
+		return iscsi_switch_str_param(&session->portal_type, buf);
+	case ISCSI_PARAM_DISCOVERY_PARENT_TYPE:
+		return iscsi_switch_str_param(&session->discovery_parent_type,
+					      buf);
 	default:
 		return -ENOSYS;
 	}
@@ -3343,6 +3350,51 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 		break;
 	case ISCSI_PARAM_BOOT_TARGET:
 		len = sprintf(buf, "%s\n", session->boot_target);
+	case ISCSI_PARAM_AUTO_SND_TGT_DISABLE:
+		len = sprintf(buf, "%u\n", session->auto_snd_tgt_disable);
+		break;
+	case ISCSI_PARAM_DISCOVERY_SESS:
+		len = sprintf(buf, "%u\n", session->discovery_sess);
+		break;
+	case ISCSI_PARAM_PORTAL_TYPE:
+		len = sprintf(buf, "%s\n", session->portal_type);
+		break;
+	case ISCSI_PARAM_CHAP_AUTH_EN:
+		len = sprintf(buf, "%u\n", session->chap_auth_en);
+		break;
+	case ISCSI_PARAM_DISCOVERY_LOGOUT_EN:
+		len = sprintf(buf, "%u\n", session->discovery_logout_en);
+		break;
+	case ISCSI_PARAM_BIDI_CHAP_EN:
+		len = sprintf(buf, "%u\n", session->bidi_chap_en);
+		break;
+	case ISCSI_PARAM_DISCOVERY_AUTH_OPTIONAL:
+		len = sprintf(buf, "%u\n", session->discovery_auth_optional);
+		break;
+	case ISCSI_PARAM_DEF_TIME2WAIT:
+		len = sprintf(buf, "%d\n", session->time2wait);
+		break;
+	case ISCSI_PARAM_DEF_TIME2RETAIN:
+		len = sprintf(buf, "%d\n", session->time2retain);
+		break;
+	case ISCSI_PARAM_TSID:
+		len = sprintf(buf, "%u\n", session->tsid);
+		break;
+	case ISCSI_PARAM_ISID:
+		len = sprintf(buf, "%02x%02x%02x%02x%02x%02x\n",
+			      session->isid[0], session->isid[1],
+			      session->isid[2], session->isid[3],
+			      session->isid[4], session->isid[5]);
+		break;
+	case ISCSI_PARAM_DISCOVERY_PARENT_IDX:
+		len = sprintf(buf, "%u\n", session->discovery_parent_idx);
+		break;
+	case ISCSI_PARAM_DISCOVERY_PARENT_TYPE:
+		if (session->discovery_parent_type)
+			len = sprintf(buf, "%s\n",
+				      session->discovery_parent_type);
+		else
+			len = sprintf(buf, "\n");
 		break;
 	default:
 		return -ENOSYS;
@@ -3433,6 +3485,51 @@ int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_PERSISTENT_ADDRESS:
 		len = sprintf(buf, "%s\n", conn->persistent_address);
 		break;
+	case ISCSI_PARAM_STATSN:
+		len = sprintf(buf, "%u\n", conn->statsn);
+		break;
+	case ISCSI_PARAM_MAX_SEGMENT_SIZE:
+		len = sprintf(buf, "%u\n", conn->max_segment_size);
+		break;
+	case ISCSI_PARAM_KEEPALIVE_TMO:
+		len = sprintf(buf, "%u\n", conn->keepalive_tmo);
+		break;
+	case ISCSI_PARAM_LOCAL_PORT:
+		len = sprintf(buf, "%u\n", conn->local_port);
+		break;
+	case ISCSI_PARAM_TCP_TIMESTAMP_STAT:
+		len = sprintf(buf, "%u\n", conn->tcp_timestamp_stat);
+		break;
+	case ISCSI_PARAM_TCP_NAGLE_DISABLE:
+		len = sprintf(buf, "%u\n", conn->tcp_nagle_disable);
+		break;
+	case ISCSI_PARAM_TCP_WSF_DISABLE:
+		len = sprintf(buf, "%u\n", conn->tcp_wsf_disable);
+		break;
+	case ISCSI_PARAM_TCP_TIMER_SCALE:
+		len = sprintf(buf, "%u\n", conn->tcp_timer_scale);
+		break;
+	case ISCSI_PARAM_TCP_TIMESTAMP_EN:
+		len = sprintf(buf, "%u\n", conn->tcp_timestamp_en);
+		break;
+	case ISCSI_PARAM_IP_FRAGMENT_DISABLE:
+		len = sprintf(buf, "%u\n", conn->fragment_disable);
+		break;
+	case ISCSI_PARAM_IPV4_TOS:
+		len = sprintf(buf, "%u\n", conn->ipv4_tos);
+		break;
+	case ISCSI_PARAM_IPV6_TC:
+		len = sprintf(buf, "%u\n", conn->ipv6_traffic_class);
+		break;
+	case ISCSI_PARAM_IS_FW_ASSIGNED_IPV6:
+		len = sprintf(buf, "%u\n", conn->is_fw_assigned_ipv6);
+		break;
+	case ISCSI_PARAM_TCP_XMIT_WSF:
+		len = sprintf(buf, "%u\n", conn->tcp_xmit_wsf);
+		break;
+	case ISCSI_PARAM_TCP_RECV_WSF:
+		len = sprintf(buf, "%u\n", conn->tcp_recv_wsf);
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4265a4b..6ac9e17 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -62,6 +62,8 @@ enum {
 	TMF_NOT_FOUND,
 };
 
+#define ISID_SIZE			6
+
 /* Connection suspend "bit" */
 #define ISCSI_SUSPEND_BIT		1
 
@@ -173,6 +175,7 @@ struct iscsi_conn {
 
 	/* iSCSI connection-wide sequencing */
 	uint32_t		exp_statsn;
+	uint32_t		statsn;
 
 	/* control data */
 	int			id;		/* CID */
@@ -213,6 +216,22 @@ struct iscsi_conn {
 	int			persistent_port;
 	char			*persistent_address;
 
+	unsigned		max_segment_size;
+	unsigned		tcp_xmit_wsf;
+	unsigned		tcp_recv_wsf;
+	uint16_t		keepalive_tmo;
+	uint16_t		local_port;
+	uint8_t			tcp_timestamp_stat;
+	uint8_t			tcp_nagle_disable;
+	uint8_t			tcp_wsf_disable;
+	uint8_t			tcp_timer_scale;
+	uint8_t			tcp_timestamp_en;
+	uint8_t			fragment_disable;
+	uint8_t			ipv4_tos;
+	uint8_t			ipv6_traffic_class;
+	uint8_t			ipv6_flow_label;
+	uint8_t			is_fw_assigned_ipv6;
+
 	/* MIB-statistics */
 	uint64_t		txdata_octets;
 	uint64_t		rxdata_octets;
@@ -290,6 +309,18 @@ struct iscsi_session {
 	char			*boot_root;
 	char			*boot_nic;
 	char			*boot_target;
+	char			*portal_type;
+	char			*discovery_parent_type;
+	uint16_t		discovery_parent_idx;
+	uint16_t		def_taskmgmt_tmo;
+	uint16_t		tsid;
+	uint8_t			auto_snd_tgt_disable;
+	uint8_t			discovery_sess;
+	uint8_t			chap_auth_en;
+	uint8_t			discovery_logout_en;
+	uint8_t			bidi_chap_en;
+	uint8_t			discovery_auth_optional;
+	uint8_t			isid[ISID_SIZE];
 
 	/* control data */
 	struct iscsi_transport	*tt;
-- 
1.7.1


