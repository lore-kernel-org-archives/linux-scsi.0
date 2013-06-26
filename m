From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH V1 2/4] libiscsi: Exporting new attrs for iscsi session and connection in sysfs
Date: Wed, 26 Jun 2013 08:11:32 -0400
Message-ID: <1372248694-3928-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:37978
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532Ab3FZMiD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jun 2013 08:38:03 -0400
In-Reply-To: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/libiscsi.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/libiscsi.h | 32 ++++++++++++++++
 2 files changed, 130 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5de9469..12aca69 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2809,6 +2809,8 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->targetalias);
 	kfree(session->initiatorname);
 	kfree(session->ifacename);
+	kfree(session->portal_type);
+	kfree(session->discovery_parent_type);
 
 	iscsi_destroy_session(cls_session);
 	iscsi_host_dec_session_cnt(shost);
@@ -3248,6 +3250,11 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		return iscsi_switch_str_param(&session->ifacename, buf);
 	case ISCSI_PARAM_INITIATOR_NAME:
 		return iscsi_switch_str_param(&session->initiatorname, buf);
+	case ISCSI_PARAM_PORTAL_TYPE:
+		return iscsi_switch_str_param(&session->portal_type, buf);
+	case ISCSI_PARAM_DISCOVERY_PARENT_TYPE:
+		return iscsi_switch_str_param(&session->discovery_parent_type,
+					      buf);
 	default:
 		return -ENOSYS;
 	}
@@ -3326,6 +3333,52 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 	case ISCSI_PARAM_INITIATOR_NAME:
 		len = sprintf(buf, "%s\n", session->initiatorname);
 		break;
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
+		break;
 	default:
 		return -ENOSYS;
 	}
@@ -3415,6 +3468,51 @@ int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
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
index 09c041e..bc7d824 100644
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
@@ -287,6 +306,19 @@ struct iscsi_session {
 	char			*targetalias;
 	char			*ifacename;
 	char			*initiatorname;
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
+
 	/* control data */
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
-- 
1.8.2.GIT


