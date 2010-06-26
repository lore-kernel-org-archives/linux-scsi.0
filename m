From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 5/7] BNX2I: Fixed the TCP graceful termination
 initiation
Date: Fri, 25 Jun 2010 18:39:30 -0700
Message-ID: <1277516372-469-6-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4364 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab0FZBip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2010 21:38:45 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

In compliance to RFC793, a TCP graceful termination will be used
instead of an abortive termination for the case where the remote
has initiated the close of the connection.
Additionally, a TCP abortive termination will be used to close the
connection when a logout response is not received in time after a
logout request has been initiated.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h       |    2 ++
 drivers/scsi/bnx2i/bnx2i_hwi.c   |    4 ++++
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   21 ++++++++++++++++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 69febb6..00c0335 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -639,6 +639,8 @@ enum {
 	EP_STATE_CLEANUP_CMPL           = 0x800,
 	EP_STATE_TCP_FIN_RCVD           = 0x1000,
 	EP_STATE_TCP_RST_RCVD           = 0x2000,
+	EP_STATE_LOGOUT_SENT            = 0x4000,
+	EP_STATE_LOGOUT_RESP_RCVD       = 0x8000,
 	EP_STATE_PG_OFLD_FAILED         = 0x1000000,
 	EP_STATE_ULP_UPDATE_FAILED      = 0x2000000,
 	EP_STATE_CLEANUP_FAILED         = 0x4000000,
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 3a66ca2..d23fc25 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -562,6 +562,8 @@ int bnx2i_send_iscsi_logout(struct bnx2i_conn *bnx2i_conn,
 	logout_wqe->num_bds = 1;
 	logout_wqe->cq_index = 0; /* CQ# used for completion, 5771x only */
 
+	bnx2i_conn->ep->state = EP_STATE_LOGOUT_SENT;
+
 	bnx2i_ring_dbell_update_sq_params(bnx2i_conn, 1);
 	return 0;
 }
@@ -1482,6 +1484,8 @@ static int bnx2i_process_logout_resp(struct iscsi_session *session,
 	resp_hdr->t2retain = cpu_to_be32(logout->time_to_retain);
 
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
+
+	bnx2i_conn->ep->state = EP_STATE_LOGOUT_RESP_RCVD;
 done:
 	spin_unlock(&session->lock);
 	return 0;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f8394d4..29dbb96 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1892,6 +1892,8 @@ static int bnx2i_ep_tcp_conn_active(struct bnx2i_endpoint *bnx2i_ep)
 	case EP_STATE_ULP_UPDATE_START:
 	case EP_STATE_ULP_UPDATE_COMPL:
 	case EP_STATE_TCP_FIN_RCVD:
+	case EP_STATE_LOGOUT_SENT:
+	case EP_STATE_LOGOUT_RESP_RCVD:
 	case EP_STATE_ULP_UPDATE_FAILED:
 		ret = 1;
 		break;
@@ -1941,8 +1943,6 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 		session = conn->session;
 	}
 
-	bnx2i_ep->state = EP_STATE_DISCONN_START;
-
 	init_timer(&bnx2i_ep->ofld_timer);
 	bnx2i_ep->ofld_timer.expires = hba->conn_teardown_tmo + jiffies;
 	bnx2i_ep->ofld_timer.function = bnx2i_ep_ofld_timer;
@@ -1955,10 +1955,25 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 
 		if (session) {
 			spin_lock_bh(&session->lock);
-			if (session->state == ISCSI_STATE_LOGGING_OUT)
+			if (bnx2i_ep->state != EP_STATE_TCP_FIN_RCVD) {
+				if (session->state == ISCSI_STATE_LOGGING_OUT) {
+					if (bnx2i_ep->state ==
+					    EP_STATE_LOGOUT_SENT) {
+						/* Logout sent, but no resp */
+						printk(KERN_ALERT "bnx2i - "
+						"WARNING logout response"
+						" was not received!\n");
+					} else if (bnx2i_ep->state ==
+						   EP_STATE_LOGOUT_RESP_RCVD)
+						close = 1;
+				}
+			} else
 				close = 1;
+
 			spin_unlock_bh(&session->lock);
 		}
+		bnx2i_ep->state = EP_STATE_DISCONN_START;
+
 		if (close)
 			close_ret = cnic->cm_close(bnx2i_ep->cm_sk);
 		else
-- 
1.7.0.5


