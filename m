From: <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] libiscsi: Add support to update host stats param
Date: Fri, 22 Apr 2016 09:39:32 -0400
Message-ID: <1461332373-18491-3-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1461332373-18491-1-git-send-email-adheer.chandravanshi@qlogic.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBC35NFWBRAHBB6PG5C4AKGQETOEPURI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1461332373-18491-1-git-send-email-adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shyam.sundar-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Adheer Chandravanshi <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Adheer Chandravanshi <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

This adds support to update the stats param maintained at host level.
The stats are updated based on the status in response pdus.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/libiscsi.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/scsi/libiscsi.h |   5 +++
 2 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c051694..d2481b6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1034,6 +1034,7 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_reject *reject = (struct iscsi_reject *)hdr;
 	struct iscsi_hdr rejected_pdu;
 	int opcode, rc = 0;
+	struct iscsi_host *ihost = shost_priv(conn->session->host);
 
 	conn->exp_statsn = be32_to_cpu(reject->statsn) + 1;
 
@@ -1050,12 +1051,14 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 	switch (reject->reason) {
 	case ISCSI_REASON_DATA_DIGEST_ERROR:
+		ihost->ihost_stats.digest_err++;
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "pdu (op 0x%x itt 0x%x) rejected "
 				  "due to DataDigest error.\n",
 				  opcode, rejected_pdu.itt);
 		break;
 	case ISCSI_REASON_IMM_CMD_REJECT:
+		ihost->ihost_stats.format_err++;
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "pdu (op 0x%x itt 0x%x) rejected. Too many "
 				  "immediate commands.\n",
@@ -1102,6 +1105,7 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 		break;
 	default:
+		ihost->ihost_stats.format_err++;
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "pdu (op 0x%x itt 0x%x) rejected. Reason "
 				  "code 0x%x\n", rejected_pdu.opcode,
@@ -1241,6 +1245,8 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		iscsi_data_in_rsp(conn, hdr, task);
 		break;
 	case ISCSI_OP_LOGOUT_RSP:
+		iscsi_update_logout_stats(session->host,
+					  (struct iscsi_logout_rsp *)hdr);
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
 		if (datalen) {
 			rc = ISCSI_ERR_PROTO;
@@ -1249,6 +1255,9 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 		goto recv_pdu;
 	case ISCSI_OP_LOGIN_RSP:
+		iscsi_update_login_stats(session->host,
+					 (struct iscsi_login_rsp *)hdr);
+
 	case ISCSI_OP_TEXT_RSP:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
 		/*
@@ -1372,6 +1381,7 @@ void iscsi_session_failure(struct iscsi_session *session,
 {
 	struct iscsi_conn *conn;
 	struct device *dev;
+	struct iscsi_host *ihost;
 
 	spin_lock_bh(&session->frwd_lock);
 	conn = session->leadconn;
@@ -1389,10 +1399,13 @@ void iscsi_session_failure(struct iscsi_session *session,
 	 * recovery initialization because we are going to kill
 	 * the session.
 	 */
-	if (err == ISCSI_ERR_INVALID_HOST)
+	if (err == ISCSI_ERR_INVALID_HOST) {
 		iscsi_conn_error_event(conn->cls_conn, err);
-	else
+	} else {
+		ihost = shost_priv(session->host);
+		ihost->ihost_stats.session_fails++;
 		iscsi_conn_failure(conn, err);
+	}
 	put_device(dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
@@ -2069,6 +2082,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	struct iscsi_conn *conn = (struct iscsi_conn *)data;
 	struct iscsi_session *session = conn->session;
 	unsigned long recv_timeout, next_timeout = 0, last_recv;
+	struct iscsi_host *ihost;
 
 	spin_lock(&session->frwd_lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN)
@@ -2088,6 +2102,8 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 				  conn->ping_timeout, conn->recv_timeout,
 				  last_recv, conn->last_ping, jiffies);
 		spin_unlock(&session->frwd_lock);
+		ihost = shost_priv(session->host);
+		ihost->ihost_stats.timeout_err++;
 		iscsi_conn_failure(conn, ISCSI_ERR_NOP_TIMEDOUT);
 		return;
 	}
@@ -3594,6 +3610,50 @@ int iscsi_host_get_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
 		len = sprintf(buf, "%s\n", ihost->initiatorname);
 		break;
+	case ISCSI_HOST_PARAM_LOGIN_ACCEPT_RSPS:
+		len = sprintf(buf, "%u\n",
+			      ihost->ihost_stats.login_accept_rsps);
+		break;
+	case ISCSI_HOST_PARAM_LOGIN_OTHER_FAILS:
+		len = sprintf(buf, "%u\n",
+			      ihost->ihost_stats.login_other_fails);
+		break;
+	case ISCSI_HOST_PARAM_LOGIN_AUTHENTICATION_FAILS:
+		len = sprintf(buf, "%u\n",
+			      ihost->ihost_stats.login_authentication_fails);
+		break;
+	case ISCSI_HOST_PARAM_LOGIN_AUTHORIZATION_FAILS:
+		len = sprintf(buf, "%u\n",
+			      ihost->ihost_stats.login_authorization_fails);
+		break;
+	case ISCSI_HOST_PARAM_LOGIN_NEGOTIATION_FAILS:
+		len = sprintf(buf, "%u\n",
+			      ihost->ihost_stats.login_negotiation_fails);
+		break;
+	case ISCSI_HOST_PARAM_LOGIN_REDIRECT_RSPS:
+		len = sprintf(buf, "%u\n",
+			      ihost->ihost_stats.login_redirect_rsps);
+		break;
+	case ISCSI_HOST_PARAM_LOGOUT_NORMAL_RSPS:
+		len = sprintf(buf, "%u\n",
+			      ihost->ihost_stats.logout_normal_rsps);
+		break;
+	case ISCSI_HOST_PARAM_LOGOUT_OTHER_RSPS:
+		len = sprintf(buf, "%u\n",
+			      ihost->ihost_stats.logout_other_rsps);
+		break;
+	case ISCSI_HOST_PARAM_DIGEST_ERR:
+		len = sprintf(buf, "%u\n", ihost->ihost_stats.digest_err);
+		break;
+	case ISCSI_HOST_PARAM_TIMEOUT_ERR:
+		len = sprintf(buf, "%u\n", ihost->ihost_stats.timeout_err);
+		break;
+	case ISCSI_HOST_PARAM_FORMAT_ERR:
+		len = sprintf(buf, "%u\n", ihost->ihost_stats.format_err);
+		break;
+	case ISCSI_HOST_PARAM_SESSION_FAILS:
+		len = sprintf(buf, "%u\n", ihost->ihost_stats.session_fails);
+		break;
 	default:
 		return -ENOSYS;
 	}
@@ -3622,6 +3682,56 @@ int iscsi_host_set_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 }
 EXPORT_SYMBOL_GPL(iscsi_host_set_param);
 
+void iscsi_update_login_stats(struct Scsi_Host *shost,
+			      struct iscsi_login_rsp *rsp_hdr)
+{
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	switch (rsp_hdr->status_class) {
+	case ISCSI_STATUS_CLS_SUCCESS:
+		ihost->ihost_stats.login_accept_rsps++;
+		break;
+	case ISCSI_STATUS_CLS_REDIRECT:
+		ihost->ihost_stats.login_redirect_rsps++;
+		break;
+	case ISCSI_STATUS_CLS_INITIATOR_ERR:
+		switch (rsp_hdr->status_detail) {
+		case ISCSI_LOGIN_STATUS_INIT_ERR:
+			ihost->ihost_stats.login_other_fails++;
+			break;
+		case ISCSI_LOGIN_STATUS_AUTH_FAILED:
+			ihost->ihost_stats.login_authentication_fails++;
+			break;
+		case ISCSI_LOGIN_STATUS_TGT_FORBIDDEN:
+			ihost->ihost_stats.login_authorization_fails++;
+			break;
+		default:
+			/* All other class2 errors are login negotiation
+			 * failures
+			 */
+			ihost->ihost_stats.login_negotiation_fails++;
+			break;
+		}
+		break;
+	default:
+		ihost->ihost_stats.login_other_fails++;
+	break;
+	}
+}
+EXPORT_SYMBOL_GPL(iscsi_update_login_stats);
+
+void iscsi_update_logout_stats(struct Scsi_Host *shost,
+			       struct iscsi_logout_rsp *rsp_hdr)
+{
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	if (rsp_hdr->response)
+		ihost->ihost_stats.logout_other_rsps++;
+	else
+		ihost->ihost_stats.logout_normal_rsps++;
+}
+EXPORT_SYMBOL_GPL(iscsi_update_logout_stats);
+
 MODULE_AUTHOR("Mike Christie");
 MODULE_DESCRIPTION("iSCSI library functions");
 MODULE_LICENSE("GPL");
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4d1c46a..be78e71 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -373,6 +373,7 @@ struct iscsi_host {
 
 	struct workqueue_struct	*workq;
 	char			workq_name[20];
+	struct iscsi_stats	ihost_stats;
 };
 
 /*
@@ -466,6 +467,10 @@ extern void __iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
+extern void iscsi_update_login_stats(struct Scsi_Host *shost,
+				     struct iscsi_login_rsp *rsp_hdr);
+extern void iscsi_update_logout_stats(struct Scsi_Host *shost,
+				      struct iscsi_logout_rsp *rsp_hdr);
 
 /*
  * generic helpers
-- 
1.8.3.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
