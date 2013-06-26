From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH V1 1/4] scsi_transport_iscsi: Exporting new attrs for iscsi session and connection in sysfs
Date: Wed, 26 Jun 2013 08:11:31 -0400
Message-ID: <1372248694-3928-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:52702
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab3FZMiD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jun 2013 08:38:03 -0400
In-Reply-To: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Exporting new iSCSI Session and Connection parameters to sysfs

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 123 +++++++++++++++++++++++++++++++++++-
 include/scsi/iscsi_if.h             |  33 ++++++++++
 2 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 133926b..752967c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/bsg-lib.h>
 #include <linux/idr.h>
-#include <linux/list.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -3327,6 +3326,23 @@ iscsi_conn_attr(exp_statsn, ISCSI_PARAM_EXP_STATSN);
 iscsi_conn_attr(persistent_address, ISCSI_PARAM_PERSISTENT_ADDRESS);
 iscsi_conn_attr(ping_tmo, ISCSI_PARAM_PING_TMO);
 iscsi_conn_attr(recv_tmo, ISCSI_PARAM_RECV_TMO);
+iscsi_conn_attr(local_port, ISCSI_PARAM_LOCAL_PORT);
+iscsi_conn_attr(statsn, ISCSI_PARAM_STATSN);
+iscsi_conn_attr(keepalive_tmo, ISCSI_PARAM_KEEPALIVE_TMO);
+iscsi_conn_attr(max_segment_size, ISCSI_PARAM_MAX_SEGMENT_SIZE);
+iscsi_conn_attr(tcp_timestamp_stat, ISCSI_PARAM_TCP_TIMESTAMP_STAT);
+iscsi_conn_attr(tcp_wsf_disable, ISCSI_PARAM_TCP_WSF_DISABLE);
+iscsi_conn_attr(tcp_nagle_disable, ISCSI_PARAM_TCP_NAGLE_DISABLE);
+iscsi_conn_attr(tcp_timer_scale, ISCSI_PARAM_TCP_TIMER_SCALE);
+iscsi_conn_attr(tcp_timestamp_enable, ISCSI_PARAM_TCP_TIMESTAMP_EN);
+iscsi_conn_attr(fragment_disable, ISCSI_PARAM_IP_FRAGMENT_DISABLE);
+iscsi_conn_attr(ipv4_tos, ISCSI_PARAM_IPV4_TOS);
+iscsi_conn_attr(ipv6_traffic_class, ISCSI_PARAM_IPV6_TC);
+iscsi_conn_attr(ipv6_flow_label, ISCSI_PARAM_IPV6_FLOW_LABEL);
+iscsi_conn_attr(is_fw_assigned_ipv6, ISCSI_PARAM_IS_FW_ASSIGNED_IPV6);
+iscsi_conn_attr(tcp_xmit_wsf, ISCSI_PARAM_TCP_XMIT_WSF);
+iscsi_conn_attr(tcp_recv_wsf, ISCSI_PARAM_TCP_RECV_WSF);
+
 
 #define iscsi_conn_ep_attr_show(param)					\
 static ssize_t show_conn_ep_param_##param(struct device *dev,		\
@@ -3379,6 +3395,22 @@ static struct attribute *iscsi_conn_attrs[] = {
 	&dev_attr_conn_persistent_port.attr,
 	&dev_attr_conn_ping_tmo.attr,
 	&dev_attr_conn_recv_tmo.attr,
+	&dev_attr_conn_local_port.attr,
+	&dev_attr_conn_statsn.attr,
+	&dev_attr_conn_keepalive_tmo.attr,
+	&dev_attr_conn_max_segment_size.attr,
+	&dev_attr_conn_tcp_timestamp_stat.attr,
+	&dev_attr_conn_tcp_wsf_disable.attr,
+	&dev_attr_conn_tcp_nagle_disable.attr,
+	&dev_attr_conn_tcp_timer_scale.attr,
+	&dev_attr_conn_tcp_timestamp_enable.attr,
+	&dev_attr_conn_fragment_disable.attr,
+	&dev_attr_conn_ipv4_tos.attr,
+	&dev_attr_conn_ipv6_traffic_class.attr,
+	&dev_attr_conn_ipv6_flow_label.attr,
+	&dev_attr_conn_is_fw_assigned_ipv6.attr,
+	&dev_attr_conn_tcp_xmit_wsf.attr,
+	&dev_attr_conn_tcp_recv_wsf.attr,
 	NULL,
 };
 
@@ -3416,6 +3448,38 @@ static umode_t iscsi_conn_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_PARAM_PING_TMO;
 	else if (attr == &dev_attr_conn_recv_tmo.attr)
 		param = ISCSI_PARAM_RECV_TMO;
+	else if (attr == &dev_attr_conn_local_port.attr)
+		param = ISCSI_PARAM_LOCAL_PORT;
+	else if (attr == &dev_attr_conn_statsn.attr)
+		param = ISCSI_PARAM_STATSN;
+	else if (attr == &dev_attr_conn_keepalive_tmo.attr)
+		param = ISCSI_PARAM_KEEPALIVE_TMO;
+	else if (attr == &dev_attr_conn_max_segment_size.attr)
+		param = ISCSI_PARAM_MAX_SEGMENT_SIZE;
+	else if (attr == &dev_attr_conn_tcp_timestamp_stat.attr)
+		param = ISCSI_PARAM_TCP_TIMESTAMP_STAT;
+	else if (attr == &dev_attr_conn_tcp_wsf_disable.attr)
+		param = ISCSI_PARAM_TCP_WSF_DISABLE;
+	else if (attr == &dev_attr_conn_tcp_nagle_disable.attr)
+		param = ISCSI_PARAM_TCP_NAGLE_DISABLE;
+	else if (attr == &dev_attr_conn_tcp_timer_scale.attr)
+		param = ISCSI_PARAM_TCP_TIMER_SCALE;
+	else if (attr == &dev_attr_conn_tcp_timestamp_enable.attr)
+		param = ISCSI_PARAM_TCP_TIMESTAMP_EN;
+	else if (attr == &dev_attr_conn_fragment_disable.attr)
+		param = ISCSI_PARAM_IP_FRAGMENT_DISABLE;
+	else if (attr == &dev_attr_conn_ipv4_tos.attr)
+		param = ISCSI_PARAM_IPV4_TOS;
+	else if (attr == &dev_attr_conn_ipv6_traffic_class.attr)
+		param = ISCSI_PARAM_IPV6_TC;
+	else if (attr == &dev_attr_conn_ipv6_flow_label.attr)
+		param = ISCSI_PARAM_IPV6_FLOW_LABEL;
+	else if (attr == &dev_attr_conn_is_fw_assigned_ipv6.attr)
+		param = ISCSI_PARAM_IS_FW_ASSIGNED_IPV6;
+	else if (attr == &dev_attr_conn_tcp_xmit_wsf.attr)
+		param = ISCSI_PARAM_TCP_XMIT_WSF;
+	else if (attr == &dev_attr_conn_tcp_recv_wsf.attr)
+		param = ISCSI_PARAM_TCP_RECV_WSF;
 	else {
 		WARN_ONCE(1, "Invalid conn attr");
 		return 0;
@@ -3473,6 +3537,21 @@ iscsi_session_attr(tgt_reset_tmo, ISCSI_PARAM_TGT_RESET_TMO, 0);
 iscsi_session_attr(ifacename, ISCSI_PARAM_IFACE_NAME, 0);
 iscsi_session_attr(initiatorname, ISCSI_PARAM_INITIATOR_NAME, 0);
 iscsi_session_attr(targetalias, ISCSI_PARAM_TARGET_ALIAS, 0);
+iscsi_session_attr(auto_snd_tgt_disable, ISCSI_PARAM_AUTO_SND_TGT_DISABLE, 0);
+iscsi_session_attr(discovery_session, ISCSI_PARAM_DISCOVERY_SESS, 0);
+iscsi_session_attr(portal_type, ISCSI_PARAM_PORTAL_TYPE, 0);
+iscsi_session_attr(chap_auth, ISCSI_PARAM_CHAP_AUTH_EN, 0);
+iscsi_session_attr(discovery_logout, ISCSI_PARAM_DISCOVERY_LOGOUT_EN, 0);
+iscsi_session_attr(bidi_chap, ISCSI_PARAM_BIDI_CHAP_EN, 0);
+iscsi_session_attr(discovery_auth_optional,
+		   ISCSI_PARAM_DISCOVERY_AUTH_OPTIONAL, 0);
+iscsi_session_attr(def_time2wait, ISCSI_PARAM_DEF_TIME2WAIT, 0);
+iscsi_session_attr(def_time2retain, ISCSI_PARAM_DEF_TIME2RETAIN, 0);
+iscsi_session_attr(isid, ISCSI_PARAM_ISID, 0);
+iscsi_session_attr(tsid, ISCSI_PARAM_TSID, 0);
+iscsi_session_attr(def_taskmgmt_tmo, ISCSI_PARAM_DEF_TASKMGMT_TMO, 0);
+iscsi_session_attr(discovery_parent_idx, ISCSI_PARAM_DISCOVERY_PARENT_IDX, 0);
+iscsi_session_attr(discovery_parent_type, ISCSI_PARAM_DISCOVERY_PARENT_TYPE, 0);
 
 static ssize_t
 show_priv_session_state(struct device *dev, struct device_attribute *attr,
@@ -3574,6 +3653,20 @@ static struct attribute *iscsi_session_attrs[] = {
 	&dev_attr_sess_chap_out_idx.attr,
 	&dev_attr_sess_chap_in_idx.attr,
 	&dev_attr_priv_sess_target_id.attr,
+	&dev_attr_sess_auto_snd_tgt_disable.attr,
+	&dev_attr_sess_discovery_session.attr,
+	&dev_attr_sess_portal_type.attr,
+	&dev_attr_sess_chap_auth.attr,
+	&dev_attr_sess_discovery_logout.attr,
+	&dev_attr_sess_bidi_chap.attr,
+	&dev_attr_sess_discovery_auth_optional.attr,
+	&dev_attr_sess_def_time2wait.attr,
+	&dev_attr_sess_def_time2retain.attr,
+	&dev_attr_sess_isid.attr,
+	&dev_attr_sess_tsid.attr,
+	&dev_attr_sess_def_taskmgmt_tmo.attr,
+	&dev_attr_sess_discovery_parent_idx.attr,
+	&dev_attr_sess_discovery_parent_type.attr,
 	NULL,
 };
 
@@ -3631,6 +3724,34 @@ static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_PARAM_INITIATOR_NAME;
 	else if (attr == &dev_attr_sess_targetalias.attr)
 		param = ISCSI_PARAM_TARGET_ALIAS;
+	else if (attr == &dev_attr_sess_auto_snd_tgt_disable.attr)
+		param = ISCSI_PARAM_AUTO_SND_TGT_DISABLE;
+	else if (attr == &dev_attr_sess_discovery_session.attr)
+		param = ISCSI_PARAM_DISCOVERY_SESS;
+	else if (attr == &dev_attr_sess_portal_type.attr)
+		param = ISCSI_PARAM_PORTAL_TYPE;
+	else if (attr == &dev_attr_sess_chap_auth.attr)
+		param = ISCSI_PARAM_CHAP_AUTH_EN;
+	else if (attr == &dev_attr_sess_discovery_logout.attr)
+		param = ISCSI_PARAM_DISCOVERY_LOGOUT_EN;
+	else if (attr == &dev_attr_sess_bidi_chap.attr)
+		param = ISCSI_PARAM_BIDI_CHAP_EN;
+	else if (attr == &dev_attr_sess_discovery_auth_optional.attr)
+		param = ISCSI_PARAM_DISCOVERY_AUTH_OPTIONAL;
+	else if (attr == &dev_attr_sess_def_time2wait.attr)
+		param = ISCSI_PARAM_DEF_TIME2WAIT;
+	else if (attr == &dev_attr_sess_def_time2retain.attr)
+		param = ISCSI_PARAM_DEF_TIME2RETAIN;
+	else if (attr == &dev_attr_sess_isid.attr)
+		param = ISCSI_PARAM_ISID;
+	else if (attr == &dev_attr_sess_tsid.attr)
+		param = ISCSI_PARAM_TSID;
+	else if (attr == &dev_attr_sess_def_taskmgmt_tmo.attr)
+		param = ISCSI_PARAM_DEF_TASKMGMT_TMO;
+	else if (attr == &dev_attr_sess_discovery_parent_idx.attr)
+		param = ISCSI_PARAM_DISCOVERY_PARENT_IDX;
+	else if (attr == &dev_attr_sess_discovery_parent_type.attr)
+		param = ISCSI_PARAM_DISCOVERY_PARENT_TYPE;
 	else if (attr == &dev_attr_priv_sess_recovery_tmo.attr)
 		return S_IRUGO | S_IWUSR;
 	else if (attr == &dev_attr_priv_sess_state.attr)
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index fe7f06c..55600f7 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -489,6 +489,39 @@ enum iscsi_param {
 
 	ISCSI_PARAM_CHAP_IN_IDX,
 	ISCSI_PARAM_CHAP_OUT_IDX,
+
+	ISCSI_PARAM_AUTO_SND_TGT_DISABLE,
+	ISCSI_PARAM_DISCOVERY_SESS,
+	ISCSI_PARAM_PORTAL_TYPE,
+	ISCSI_PARAM_CHAP_AUTH_EN,
+	ISCSI_PARAM_DISCOVERY_LOGOUT_EN,
+	ISCSI_PARAM_BIDI_CHAP_EN,
+	ISCSI_PARAM_DISCOVERY_AUTH_OPTIONAL,
+
+	ISCSI_PARAM_DEF_TIME2WAIT,
+	ISCSI_PARAM_DEF_TIME2RETAIN,
+	ISCSI_PARAM_MAX_SEGMENT_SIZE,
+	ISCSI_PARAM_STATSN,
+	ISCSI_PARAM_KEEPALIVE_TMO,
+	ISCSI_PARAM_LOCAL_PORT,
+	ISCSI_PARAM_TSID,
+	ISCSI_PARAM_DEF_TASKMGMT_TMO,
+
+	ISCSI_PARAM_TCP_TIMESTAMP_STAT,
+	ISCSI_PARAM_TCP_WSF_DISABLE,
+	ISCSI_PARAM_TCP_NAGLE_DISABLE,
+	ISCSI_PARAM_TCP_TIMER_SCALE,
+	ISCSI_PARAM_TCP_TIMESTAMP_EN,
+	ISCSI_PARAM_TCP_XMIT_WSF,
+	ISCSI_PARAM_TCP_RECV_WSF,
+	ISCSI_PARAM_IP_FRAGMENT_DISABLE,
+	ISCSI_PARAM_IPV4_TOS,
+	ISCSI_PARAM_IPV6_TC,
+	ISCSI_PARAM_IPV6_FLOW_LABEL,
+	ISCSI_PARAM_IS_FW_ASSIGNED_IPV6,
+
+	ISCSI_PARAM_DISCOVERY_PARENT_IDX,
+	ISCSI_PARAM_DISCOVERY_PARENT_TYPE,
 	/* must always be last */
 	ISCSI_PARAM_MAX,
 };
-- 
1.8.2.GIT


