From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 6/8] qla4xxx: Exporting new attrs for iscsi session and connection in sysfs
Date: Thu, 9 May 2013 06:02:10 -0400
Message-ID: <1368093732-8524-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:23778
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756Ab3EIK0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 06:26:54 -0400
In-Reply-To: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 222 +++++++++++++++++++++++++++++++-----------
 1 file changed, 165 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3313358..171c0e4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -378,6 +378,47 @@ static umode_t qla4_attr_is_visible(int param_type, int param)
 		case ISCSI_PARAM_PASSWORD:
 		case ISCSI_PARAM_USERNAME_IN:
 		case ISCSI_PARAM_PASSWORD_IN:
+		case ISCSI_PARAM_AUTO_SND_TGT_DISABLE:
+		case ISCSI_PARAM_DISCOVERY_SESS:
+		case ISCSI_PARAM_PORTAL_TYPE:
+		case ISCSI_PARAM_CHAP_AUTH_EN:
+		case ISCSI_PARAM_DISCOVERY_LOGOUT_EN:
+		case ISCSI_PARAM_BIDI_CHAP_EN:
+		case ISCSI_PARAM_DISCOVERY_AUTH_OPTIONAL:
+		case ISCSI_PARAM_DEF_TIME2WAIT:
+		case ISCSI_PARAM_DEF_TIME2RETAIN:
+		case ISCSI_PARAM_HDRDGST_EN:
+		case ISCSI_PARAM_DATADGST_EN:
+		case ISCSI_PARAM_INITIAL_R2T_EN:
+		case ISCSI_PARAM_IMM_DATA_EN:
+		case ISCSI_PARAM_PDU_INORDER_EN:
+		case ISCSI_PARAM_DATASEQ_INORDER_EN:
+		case ISCSI_PARAM_SNACK_REQ_EN:
+		case ISCSI_PARAM_MAX_SEGMENT_SIZE:
+		case ISCSI_PARAM_TCP_TIMESTAMP_STAT:
+		case ISCSI_PARAM_TCP_WSF_DISABLE:
+		case ISCSI_PARAM_TCP_NAGLE_DISABLE:
+		case ISCSI_PARAM_TCP_TIMER_SCALE:
+		case ISCSI_PARAM_TCP_TIMESTAMP_EN:
+		case ISCSI_PARAM_TCP_XMIT_WSF:
+		case ISCSI_PARAM_TCP_RECV_WSF:
+		case ISCSI_PARAM_IP_FRAGMENT_DISABLE:
+		case ISCSI_PARAM_IPV4_TOS:
+		case ISCSI_PARAM_IPV6_TC:
+		case ISCSI_PARAM_IPV6_FLOW_LABEL:
+		case ISCSI_PARAM_IS_FW_ASSIGNED_IPV6:
+		case ISCSI_PARAM_LINK_LOCAL_IPV6:
+		case ISCSI_PARAM_REDIRECT_IPADDR:
+		case ISCSI_PARAM_KEEPALIVE_TMO:
+		case ISCSI_PARAM_LOCAL_PORT:
+		case ISCSI_PARAM_ISID:
+		case ISCSI_PARAM_TSID:
+		case ISCSI_PARAM_DEF_TASKMGMT_TMO:
+		case ISCSI_PARAM_ERL:
+		case ISCSI_PARAM_STATSN:
+		case ISCSI_PARAM_EXP_STATSN:
+		case ISCSI_PARAM_DISCOVERY_PARENT_IDX:
+		case ISCSI_PARAM_DISCOVERY_PARENT_TYPE:
 			return S_IRUGO;
 		default:
 			return 0;
@@ -3314,6 +3355,113 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
 	return rc;
 }
 
+static void qla4xxx_copy_to_sess_conn_params(struct iscsi_conn *conn,
+					     struct iscsi_session *sess,
+					     struct dev_db_entry *fw_ddb_entry)
+{
+	unsigned long options = 0;
+	uint16_t ddb_link;
+	uint16_t disc_parent;
+	char ip_addr[DDB_IPADDR_LEN];
+
+	options = le16_to_cpu(fw_ddb_entry->options);
+	conn->is_fw_assigned_ipv6 = test_bit(OPT_IS_FW_ASSIGNED_IPV6, &options);
+	sess->auto_snd_tgt_disable = test_bit(OPT_AUTO_SENDTGTS_DISABLE,
+					      &options);
+	sess->discovery_sess = test_bit(OPT_DISC_SESSION, &options);
+
+	options = le16_to_cpu(fw_ddb_entry->iscsi_options);
+	conn->hdrdgst_en = test_bit(ISCSIOPT_HEADER_DIGEST_EN, &options);
+	conn->datadgst_en = test_bit(ISCSIOPT_DATA_DIGEST_EN, &options);
+	sess->imm_data_en = test_bit(ISCSIOPT_IMMEDIATE_DATA_EN, &options);
+	sess->initial_r2t_en = test_bit(ISCSIOPT_INITIAL_R2T_EN, &options);
+	sess->dataseq_inorder_en = test_bit(ISCSIOPT_DATA_SEQ_IN_ORDER,
+					    &options);
+	sess->pdu_inorder_en = test_bit(ISCSIOPT_DATA_PDU_IN_ORDER, &options);
+	sess->chap_auth_en = test_bit(ISCSIOPT_CHAP_AUTH_EN, &options);
+	conn->snack_req_en = test_bit(ISCSIOPT_SNACK_REQ_EN, &options);
+	sess->discovery_logout_en = test_bit(ISCSIOPT_DISCOVERY_LOGOUT_EN,
+					     &options);
+	sess->bidi_chap_en = test_bit(ISCSIOPT_BIDI_CHAP_EN, &options);
+	sess->discovery_auth_optional =
+			test_bit(ISCSIOPT_DISCOVERY_AUTH_OPTIONAL, &options);
+	if (test_bit(ISCSIOPT_ERL1, &options))
+		sess->erl |= BIT_1;
+	if (test_bit(ISCSIOPT_ERL0, &options))
+		sess->erl |= BIT_0;
+
+	options = le16_to_cpu(fw_ddb_entry->tcp_options);
+	conn->tcp_timestamp_stat = test_bit(TCPOPT_TIMESTAMP_STAT, &options);
+	conn->tcp_nagle_disable = test_bit(TCPOPT_NAGLE_DISABLE, &options);
+	conn->tcp_wsf_disable = test_bit(TCPOPT_WSF_DISABLE, &options);
+	if (test_bit(TCPOPT_TIMER_SCALE3, &options))
+		conn->tcp_timer_scale |= BIT_3;
+	if (test_bit(TCPOPT_TIMER_SCALE2, &options))
+		conn->tcp_timer_scale |= BIT_2;
+	if (test_bit(TCPOPT_TIMER_SCALE1, &options))
+		conn->tcp_timer_scale |= BIT_1;
+
+	conn->tcp_timer_scale >>= 1;
+	conn->tcp_timestamp_en = test_bit(TCPOPT_TIMESTAMP_EN, &options);
+
+	options = le16_to_cpu(fw_ddb_entry->ip_options);
+	conn->fragment_disable = test_bit(IPOPT_FRAGMENT_DISABLE, &options);
+
+	conn->max_recv_dlength = BYTE_UNITS *
+			  le16_to_cpu(fw_ddb_entry->iscsi_max_rcv_data_seg_len);
+	conn->max_xmit_dlength = BYTE_UNITS *
+			  le16_to_cpu(fw_ddb_entry->iscsi_max_snd_data_seg_len);
+	sess->max_r2t = le16_to_cpu(fw_ddb_entry->iscsi_max_outsnd_r2t);
+	sess->first_burst = BYTE_UNITS *
+			       le16_to_cpu(fw_ddb_entry->iscsi_first_burst_len);
+	sess->max_burst = BYTE_UNITS *
+				 le16_to_cpu(fw_ddb_entry->iscsi_max_burst_len);
+	sess->time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
+	sess->time2retain = le16_to_cpu(fw_ddb_entry->iscsi_def_time2retain);
+	sess->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+	conn->max_segment_size = le16_to_cpu(fw_ddb_entry->mss);
+	conn->tcp_xmit_wsf = fw_ddb_entry->tcp_xmt_wsf;
+	conn->tcp_recv_wsf = fw_ddb_entry->tcp_rcv_wsf;
+	conn->ipv4_tos = fw_ddb_entry->ipv4_tos;
+	conn->keepalive_tmo = le16_to_cpu(fw_ddb_entry->ka_timeout);
+	conn->local_port = le16_to_cpu(fw_ddb_entry->lcl_port);
+	conn->statsn = le32_to_cpu(fw_ddb_entry->stat_sn);
+	conn->exp_statsn = le32_to_cpu(fw_ddb_entry->exp_stat_sn);
+	sess->tsid = le16_to_cpu(fw_ddb_entry->tsid);
+	COPY_ISID(sess->isid, fw_ddb_entry->isid);
+
+	ddb_link = le16_to_cpu(fw_ddb_entry->ddb_link);
+	if (ddb_link < MAX_DDB_ENTRIES)
+		sess->discovery_parent_idx = ddb_link;
+	else
+		sess->discovery_parent_idx = DDB_NO_LINK;
+
+	if (ddb_link == DDB_ISNS)
+		disc_parent = ISCSI_DISC_PARENT_ISNS;
+	else if (ddb_link == DDB_NO_LINK)
+		disc_parent = ISCSI_DISC_PARENT_UNKNOWN;
+	else if (ddb_link < MAX_DDB_ENTRIES)
+		disc_parent = ISCSI_DISC_PARENT_SENDTGT;
+	else
+		disc_parent = ISCSI_DISC_PARENT_UNKNOWN;
+
+	iscsi_set_param(conn->cls_conn, ISCSI_PARAM_DISCOVERY_PARENT_TYPE,
+			iscsi_get_discovery_parent_name(disc_parent), 0);
+
+	iscsi_set_param(conn->cls_conn, ISCSI_PARAM_TARGET_ALIAS,
+			(char *)fw_ddb_entry->iscsi_alias, 0);
+
+	memset(ip_addr, 0, sizeof(ip_addr));
+	options = le16_to_cpu(fw_ddb_entry->options);
+	if (options & DDB_OPT_IPV6_DEVICE)
+		sprintf(ip_addr, "%pI6", fw_ddb_entry->tgt_addr);
+	else
+		sprintf(ip_addr, "%pI4", fw_ddb_entry->tgt_addr);
+
+	iscsi_set_param(conn->cls_conn, ISCSI_PARAM_REDIRECT_IPADDR,
+			(char *)ip_addr, 0);
+}
+
 static void qla4xxx_copy_fwddb_param(struct scsi_qla_host *ha,
 				     struct dev_db_entry *fw_ddb_entry,
 				     struct iscsi_cls_session *cls_sess,
@@ -3332,47 +3480,33 @@ static void qla4xxx_copy_fwddb_param(struct scsi_qla_host *ha,
 
 	ddb_entry->chap_tbl_idx = le16_to_cpu(fw_ddb_entry->chap_tbl_idx);
 
-	conn->max_recv_dlength = BYTE_UNITS *
-			  le16_to_cpu(fw_ddb_entry->iscsi_max_rcv_data_seg_len);
-
-	conn->max_xmit_dlength = BYTE_UNITS *
-			  le16_to_cpu(fw_ddb_entry->iscsi_max_snd_data_seg_len);
-
-	sess->initial_r2t_en =
-			    (BIT_10 & le16_to_cpu(fw_ddb_entry->iscsi_options));
-
-	sess->max_r2t = le16_to_cpu(fw_ddb_entry->iscsi_max_outsnd_r2t);
-
-	sess->imm_data_en = (BIT_11 & le16_to_cpu(fw_ddb_entry->iscsi_options));
-
-	sess->first_burst = BYTE_UNITS *
-			       le16_to_cpu(fw_ddb_entry->iscsi_first_burst_len);
-
-	sess->max_burst = BYTE_UNITS *
-				 le16_to_cpu(fw_ddb_entry->iscsi_max_burst_len);
-
-	sess->time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
-
-	sess->time2retain = le16_to_cpu(fw_ddb_entry->iscsi_def_time2retain);
+	qla4xxx_copy_to_sess_conn_params(conn, sess, fw_ddb_entry);
 
+	sess->def_taskmgmt_tmo = le16_to_cpu(fw_ddb_entry->def_timeout);
 	conn->persistent_port = le16_to_cpu(fw_ddb_entry->port);
 
-	sess->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
-
+	memset(ip_addr, 0, sizeof(ip_addr));
 	options = le16_to_cpu(fw_ddb_entry->options);
-	if (options & DDB_OPT_IPV6_DEVICE)
+	if (options & DDB_OPT_IPV6_DEVICE) {
+		sprintf(ip_addr, "%pI6", fw_ddb_entry->link_local_ipv6_addr);
+		iscsi_set_param(cls_conn, ISCSI_PARAM_LINK_LOCAL_IPV6,
+				(char *)ip_addr, buflen);
+
+		iscsi_set_param(cls_conn, ISCSI_PARAM_PORTAL_TYPE, "ipv6", 4);
+
+		memset(ip_addr, 0, sizeof(ip_addr));
 		sprintf(ip_addr, "%pI6", fw_ddb_entry->ip_addr);
-	else
+	} else {
+		iscsi_set_param(cls_conn, ISCSI_PARAM_PORTAL_TYPE, "ipv4", 4);
 		sprintf(ip_addr, "%pI4", fw_ddb_entry->ip_addr);
+	}
 
+	iscsi_set_param(cls_conn, ISCSI_PARAM_PERSISTENT_ADDRESS,
+			(char *)ip_addr, buflen);
 	iscsi_set_param(cls_conn, ISCSI_PARAM_TARGET_NAME,
 			(char *)fw_ddb_entry->iscsi_name, buflen);
 	iscsi_set_param(cls_conn, ISCSI_PARAM_INITIATOR_NAME,
 			(char *)ha->name_string, buflen);
-	iscsi_set_param(cls_conn, ISCSI_PARAM_PERSISTENT_ADDRESS,
-			(char *)ip_addr, buflen);
-	iscsi_set_param(cls_conn, ISCSI_PARAM_TARGET_ALIAS,
-			(char *)fw_ddb_entry->iscsi_alias, buflen);
 }
 
 void qla4xxx_update_session_conn_fwddb_param(struct scsi_qla_host *ha,
@@ -3460,37 +3594,11 @@ void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 
 	/* Update params */
 	ddb_entry->chap_tbl_idx = le16_to_cpu(fw_ddb_entry->chap_tbl_idx);
-	conn->max_recv_dlength = BYTE_UNITS *
-			  le16_to_cpu(fw_ddb_entry->iscsi_max_rcv_data_seg_len);
-
-	conn->max_xmit_dlength = BYTE_UNITS *
-			  le16_to_cpu(fw_ddb_entry->iscsi_max_snd_data_seg_len);
-
-	sess->initial_r2t_en =
-			    (BIT_10 & le16_to_cpu(fw_ddb_entry->iscsi_options));
-
-	sess->max_r2t = le16_to_cpu(fw_ddb_entry->iscsi_max_outsnd_r2t);
-
-	sess->imm_data_en = (BIT_11 & le16_to_cpu(fw_ddb_entry->iscsi_options));
-
-	sess->first_burst = BYTE_UNITS *
-			       le16_to_cpu(fw_ddb_entry->iscsi_first_burst_len);
-
-	sess->max_burst = BYTE_UNITS *
-				 le16_to_cpu(fw_ddb_entry->iscsi_max_burst_len);
-
-	sess->time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
-
-	sess->time2retain = le16_to_cpu(fw_ddb_entry->iscsi_def_time2retain);
-
-	sess->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+	qla4xxx_copy_to_sess_conn_params(conn, sess, fw_ddb_entry);
 
 	memcpy(sess->initiatorname, ha->name_string,
 	       min(sizeof(ha->name_string), sizeof(sess->initiatorname)));
 
-	iscsi_set_param(cls_conn, ISCSI_PARAM_TARGET_ALIAS,
-			(char *)fw_ddb_entry->iscsi_alias, 0);
-
 exit_session_conn_param:
 	if (fw_ddb_entry)
 		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
-- 
1.8.2.GIT


