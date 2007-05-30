From: michaelc@cs.wisc.edu
Subject: [PATCH 12/19] libiscsi: fix iscsi cmdsn allocation
Date: Wed, 30 May 2007 12:57:18 -0500
Message-ID: <11805478592848-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu> <1180547857548-git-send-email-michaelc@cs.wisc.edu> <118054785852-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbXE3R5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:47 -0400
In-Reply-To: <118054785852-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The cmdsn allocation and pdu transmit code can race, and we can end
up sending a pdu with cmdsn 10 before a pdu with 5. The target will
then fail the connection/session. This patch fixes the problem by
delaying the cmdsn allocation until we are about to send the pdu.

This also removes the xmitmutex. We were using the connection xmitmutex
during error handling to handle races with mtask and ctask cleanup and
completion. For ctasks we now have nice refcounting and for the mtask,
if we hit the case where the mtask timesout and it is floating
around somewhere in the driver, we end up dropping the session.
And to handle session level cleanup, we use the xmit suspend bit
along with scsi_flush_queue and the session lock to make sure
that the xmit thread is not possibly transmitting a task while
we are trying to kill it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   18 -
 drivers/scsi/iscsi_tcp.c                 |   33 --
 drivers/scsi/libiscsi.c                  |  491 ++++++++++++++----------------
 include/scsi/libiscsi.h                  |   11 -
 include/scsi/scsi_transport_iscsi.h      |    3 
 5 files changed, 250 insertions(+), 306 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6c8cd09..9782190 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -134,19 +134,9 @@ iscsi_iser_cmd_init(struct iscsi_cmd_tas
 {
 	struct iscsi_iser_conn     *iser_conn  = ctask->conn->dd_data;
 	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
-	struct scsi_cmnd  *sc = ctask->sc;
 
 	iser_ctask->command_sent = 0;
 	iser_ctask->iser_conn    = iser_conn;
-
-	if (sc->sc_data_direction == DMA_TO_DEVICE) {
-		BUG_ON(sc->request_bufflen == 0);
-
-		debug_scsi("cmd [itt %x total %d imm %d unsol_data %d\n",
-			   ctask->itt, sc->request_bufflen, ctask->imm_count,
-			   ctask->unsol_count);
-	}
-
 	iser_ctask_rdma_init(iser_ctask);
 }
 
@@ -219,6 +209,14 @@ iscsi_iser_ctask_xmit(struct iscsi_conn 
 	struct iscsi_iser_cmd_task *iser_ctask = ctask->dd_data;
 	int error = 0;
 
+	if (ctask->sc->sc_data_direction == DMA_TO_DEVICE) {
+		BUG_ON(ctask->sc->request_bufflen == 0);
+
+		debug_scsi("cmd [itt %x total %d imm %d unsol_data %d\n",
+			   ctask->itt, ctask->sc->request_bufflen,
+			   ctask->imm_count, ctask->unsol_count);
+	}
+
 	debug_scsi("ctask deq [cid %d itt 0x%x]\n",
 		   conn->id, ctask->itt);
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 0afdca2..8edcfdd 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -34,7 +34,6 @@ #include <linux/crypto.h>
 #include <linux/delay.h>
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
-#include <linux/mutex.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -211,7 +210,6 @@ iscsi_tcp_cleanup_ctask(struct iscsi_con
 static int
 iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
-	int rc;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct iscsi_data_rsp *rhdr = (struct iscsi_data_rsp *)tcp_conn->in.hdr;
@@ -219,9 +217,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, 
 	struct scsi_cmnd *sc = ctask->sc;
 	int datasn = be32_to_cpu(rhdr->datasn);
 
-	rc = iscsi_check_assign_cmdsn(session, (struct iscsi_nopin*)rhdr);
-	if (rc)
-		return rc;
+	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 	/*
 	 * setup Data-In byte counter (gets decremented..)
 	 */
@@ -377,12 +373,10 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 		return ISCSI_ERR_R2TSN;
 	}
 
-	rc = iscsi_check_assign_cmdsn(session, (struct iscsi_nopin*)rhdr);
-	if (rc)
-		return rc;
-
 	/* fill-in new R2T associated with the task */
 	spin_lock(&session->lock);
+	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
+
 	if (!ctask->sc || ctask->mtask ||
 	     session->state != ISCSI_STATE_LOGGED_IN) {
 		printk(KERN_INFO "iscsi_tcp: dropping R2T itt %d in "
@@ -1762,12 +1756,6 @@ iscsi_tcp_ctask_xmit(struct iscsi_conn *
 	debug_scsi("ctask deq [cid %d xmstate %x itt 0x%x]\n",
 		conn->id, tcp_ctask->xmstate, ctask->itt);
 
-	/*
-	 * serialize with TMF AbortTask
-	 */
-	if (ctask->mtask)
-		return rc;
-
 	rc = iscsi_send_cmd_hdr(conn, ctask);
 	if (rc)
 		return rc;
@@ -1949,8 +1937,7 @@ iscsi_tcp_conn_bind(struct iscsi_cls_ses
 
 /* called with host lock */
 static void
-iscsi_tcp_mgmt_init(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask,
-		    char *data, uint32_t data_size)
+iscsi_tcp_mgmt_init(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask)
 {
 	struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
 	tcp_mtask->xmstate = XMSTATE_IMM_HDR_INIT;
@@ -2073,22 +2060,15 @@ iscsi_tcp_conn_get_param(struct iscsi_cl
 
 	switch(param) {
 	case ISCSI_PARAM_CONN_PORT:
-		mutex_lock(&conn->xmitmutex);
-		if (!tcp_conn->sock) {
-			mutex_unlock(&conn->xmitmutex);
+		if (!tcp_conn->sock)
 			return -EINVAL;
-		}
 
 		inet = inet_sk(tcp_conn->sock->sk);
 		len = sprintf(buf, "%hu\n", be16_to_cpu(inet->dport));
-		mutex_unlock(&conn->xmitmutex);
 		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
-		mutex_lock(&conn->xmitmutex);
-		if (!tcp_conn->sock) {
-			mutex_unlock(&conn->xmitmutex);
+		if (!tcp_conn->sock)
 			return -EINVAL;
-		}
 
 		sk = tcp_conn->sock->sk;
 		if (sk->sk_family == PF_INET) {
@@ -2099,7 +2079,6 @@ iscsi_tcp_conn_get_param(struct iscsi_cl
 			np = inet6_sk(sk);
 			len = sprintf(buf, NIP6_FMT "\n", NIP6(np->daddr));
 		}
-		mutex_unlock(&conn->xmitmutex);
 		break;
 	default:
 		return iscsi_conn_get_param(cls_conn, param, buf);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 63f0a15..938f527 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -22,7 +22,6 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <linux/types.h>
-#include <linux/mutex.h>
 #include <linux/kfifo.h>
 #include <linux/delay.h>
 #include <asm/unaligned.h>
@@ -46,27 +45,53 @@ class_to_transport_session(struct iscsi_
 }
 EXPORT_SYMBOL_GPL(class_to_transport_session);
 
-#define INVALID_SN_DELTA	0xffff
+/* Serial Number Arithmetic, 32 bits, less than, RFC1982 */
+#define SNA32_CHECK 2147483648UL
 
-int
-iscsi_check_assign_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
+static int iscsi_sna_lt(u32 n1, u32 n2)
+{
+	return n1 != n2 && ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
+			    (n1 > n2 && (n2 - n1 < SNA32_CHECK)));
+}
+
+/* Serial Number Arithmetic, 32 bits, less than, RFC1982 */
+static int iscsi_sna_lte(u32 n1, u32 n2)
+{
+	return n1 == n2 || ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
+			    (n1 > n2 && (n2 - n1 < SNA32_CHECK)));
+}
+
+void
+iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 {
 	uint32_t max_cmdsn = be32_to_cpu(hdr->max_cmdsn);
 	uint32_t exp_cmdsn = be32_to_cpu(hdr->exp_cmdsn);
 
-	if (max_cmdsn < exp_cmdsn -1 &&
-	    max_cmdsn > exp_cmdsn - INVALID_SN_DELTA)
-		return ISCSI_ERR_MAX_CMDSN;
-	if (max_cmdsn > session->max_cmdsn ||
-	    max_cmdsn < session->max_cmdsn - INVALID_SN_DELTA)
-		session->max_cmdsn = max_cmdsn;
-	if (exp_cmdsn > session->exp_cmdsn ||
-	    exp_cmdsn < session->exp_cmdsn - INVALID_SN_DELTA)
+	/*
+	 * standard specifies this check for when to update expected and
+	 * max sequence numbers
+	 */
+	if (iscsi_sna_lt(max_cmdsn, exp_cmdsn - 1))
+		return;
+
+	if (exp_cmdsn != session->exp_cmdsn &&
+	    !iscsi_sna_lt(exp_cmdsn, session->exp_cmdsn))
 		session->exp_cmdsn = exp_cmdsn;
 
-	return 0;
+	if (max_cmdsn != session->max_cmdsn &&
+	    !iscsi_sna_lt(max_cmdsn, session->max_cmdsn)) {
+		session->max_cmdsn = max_cmdsn;
+		/*
+		 * if the window closed with IO queued, then kick the
+		 * xmit thread
+		 */
+		if (!list_empty(&session->leadconn->xmitqueue) ||
+		    __kfifo_len(session->leadconn->mgmtqueue))
+			scsi_queue_work(session->host,
+					&session->leadconn->xmitwork);
+	}
 }
-EXPORT_SYMBOL_GPL(iscsi_check_assign_cmdsn);
+EXPORT_SYMBOL_GPL(iscsi_update_cmdsn);
 
 void iscsi_prep_unsolicit_data_pdu(struct iscsi_cmd_task *ctask,
 				   struct iscsi_data *hdr)
@@ -175,8 +200,13 @@ static void iscsi_prep_scsi_cmd_pdu(stru
 	}
 
 	conn->scsicmd_pdus_cnt++;
+
+        debug_scsi("iscsi prep [%s cid %d sc %p cdb 0x%x itt 0x%x len %d "
+		"cmdsn %d win %d]\n",
+                sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
+                conn->id, sc, sc->cmnd[0], ctask->itt, sc->request_bufflen,
+                session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 }
-EXPORT_SYMBOL_GPL(iscsi_prep_scsi_cmd_pdu);
 
 /**
  * iscsi_complete_command - return command back to scsi-ml
@@ -205,26 +235,12 @@ static void __iscsi_get_ctask(struct isc
 	atomic_inc(&ctask->refcount);
 }
 
-static void iscsi_get_ctask(struct iscsi_cmd_task *ctask)
-{
-	spin_lock_bh(&ctask->conn->session->lock);
-	__iscsi_get_ctask(ctask);
-	spin_unlock_bh(&ctask->conn->session->lock);
-}
-
 static void __iscsi_put_ctask(struct iscsi_cmd_task *ctask)
 {
 	if (atomic_dec_and_test(&ctask->refcount))
 		iscsi_complete_command(ctask);
 }
 
-static void iscsi_put_ctask(struct iscsi_cmd_task *ctask)
-{
-	spin_lock_bh(&ctask->conn->session->lock);
-	__iscsi_put_ctask(ctask);
-	spin_unlock_bh(&ctask->conn->session->lock);
-}
-
 /**
  * iscsi_cmd_rsp - SCSI Command Response processing
  * @conn: iscsi connection
@@ -236,21 +252,15 @@ static void iscsi_put_ctask(struct iscsi
  * iscsi_cmd_rsp sets up the scsi_cmnd fields based on the PDU and
  * then completes the command and task.
  **/
-static int iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-			      struct iscsi_cmd_task *ctask, char *data,
-			      int datalen)
+static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+			       struct iscsi_cmd_task *ctask, char *data,
+			       int datalen)
 {
-	int rc;
 	struct iscsi_cmd_rsp *rhdr = (struct iscsi_cmd_rsp *)hdr;
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = ctask->sc;
 
-	rc = iscsi_check_assign_cmdsn(session, (struct iscsi_nopin*)rhdr);
-	if (rc) {
-		sc->result = DID_ERROR << 16;
-		goto out;
-	}
-
+	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 
 	sc->result = (DID_OK << 16) | rhdr->cmd_status;
@@ -302,7 +312,6 @@ out:
 	conn->scsirsp_pdus_cnt++;
 
 	__iscsi_put_ctask(ctask);
-	return rc;
 }
 
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
@@ -382,8 +391,8 @@ int __iscsi_complete_pdu(struct iscsi_co
 		switch(opcode) {
 		case ISCSI_OP_SCSI_CMD_RSP:
 			BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
-			rc = iscsi_scsi_cmd_rsp(conn, hdr, ctask, data,
-						datalen);
+			iscsi_scsi_cmd_rsp(conn, hdr, ctask, data,
+					   datalen);
 			break;
 		case ISCSI_OP_SCSI_DATA_IN:
 			BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
@@ -406,11 +415,7 @@ int __iscsi_complete_pdu(struct iscsi_co
 		debug_scsi("immrsp [op 0x%x cid %d itt 0x%x len %d]\n",
 			   opcode, conn->id, mtask->itt, datalen);
 
-		rc = iscsi_check_assign_cmdsn(session,
-					      (struct iscsi_nopin*)hdr);
-		if (rc)
-			goto done;
-
+		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
 		switch(opcode) {
 		case ISCSI_OP_LOGOUT_RSP:
 			if (datalen) {
@@ -459,10 +464,7 @@ int __iscsi_complete_pdu(struct iscsi_co
 			break;
 		}
 	} else if (itt == ~0U) {
-		rc = iscsi_check_assign_cmdsn(session,
-					     (struct iscsi_nopin*)hdr);
-		if (rc)
-			goto done;
+		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
 
 		switch(opcode) {
 		case ISCSI_OP_NOOP_IN:
@@ -492,7 +494,6 @@ int __iscsi_complete_pdu(struct iscsi_co
 	} else
 		rc = ISCSI_ERR_BAD_ITT;
 
-done:
 	return rc;
 }
 EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
@@ -579,17 +580,47 @@ void iscsi_conn_failure(struct iscsi_con
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
+static void iscsi_prep_mtask(struct iscsi_conn *conn,
+			     struct iscsi_mgmt_task *mtask)
+{
+	struct iscsi_session *session = conn->session;
+	struct iscsi_hdr *hdr = mtask->hdr;
+	struct iscsi_nopout *nop = (struct iscsi_nopout *)hdr;
+
+	if (hdr->opcode != (ISCSI_OP_LOGIN | ISCSI_OP_IMMEDIATE) &&
+	    hdr->opcode != (ISCSI_OP_TEXT | ISCSI_OP_IMMEDIATE))
+		nop->exp_statsn = cpu_to_be32(conn->exp_statsn);
+	/*
+	 * pre-format CmdSN for outgoing PDU.
+	 */
+	nop->cmdsn = cpu_to_be32(session->cmdsn);
+	if (hdr->itt != RESERVED_ITT) {
+		hdr->itt = build_itt(mtask->itt, conn->id, session->age);
+		if (conn->c_stage == ISCSI_CONN_STARTED &&
+		    !(hdr->opcode & ISCSI_OP_IMMEDIATE))
+			session->cmdsn++;
+	}
+
+	if (session->tt->init_mgmt_task)
+		session->tt->init_mgmt_task(conn, mtask);
+
+	debug_scsi("mgmtpdu [op 0x%x hdr->itt 0x%x datalen %d]\n",
+		   hdr->opcode, hdr->itt, mtask->data_count);
+}
+
 static int iscsi_xmit_mtask(struct iscsi_conn *conn)
 {
 	struct iscsi_hdr *hdr = conn->mtask->hdr;
 	int rc, was_logout = 0;
 
+	spin_unlock_bh(&conn->session->lock);
 	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT) {
 		conn->session->state = ISCSI_STATE_IN_RECOVERY;
 		iscsi_block_session(session_to_cls(conn->session));
 		was_logout = 1;
 	}
 	rc = conn->session->tt->xmit_mgmt_task(conn, conn->mtask);
+	spin_lock_bh(&conn->session->lock);
 	if (rc)
 		return rc;
 
@@ -603,6 +634,45 @@ static int iscsi_xmit_mtask(struct iscsi
 	return 0;
 }
 
+static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
+{
+	struct iscsi_session *session = conn->session;
+
+	/*
+	 * Check for iSCSI window and take care of CmdSN wrap-around
+	 */
+	if (!iscsi_sna_lte(session->cmdsn, session->max_cmdsn)) {
+		debug_scsi("iSCSI CmdSN closed. MaxCmdSN %u CmdSN %u\n",
+			   session->max_cmdsn, session->cmdsn);
+		return -ENOSPC;
+	}
+	return 0;
+}
+
+static int iscsi_xmit_ctask(struct iscsi_conn *conn)
+{
+	struct iscsi_cmd_task *ctask = conn->ctask;
+	int rc = 0;
+
+	/*
+	 * serialize with TMF AbortTask
+	 */
+	if (ctask->state == ISCSI_TASK_ABORTING)
+		goto done;
+
+	__iscsi_get_ctask(ctask);
+	spin_unlock_bh(&conn->session->lock);
+	rc = conn->session->tt->xmit_cmd_task(conn, ctask);
+	spin_lock_bh(&conn->session->lock);
+	__iscsi_put_ctask(ctask);
+
+done:
+	if (!rc)
+		/* done with this ctask */
+		conn->ctask = NULL;
+	return rc;
+}
+
 /**
  * iscsi_data_xmit - xmit any command into the scheduled connection
  * @conn: iscsi connection
@@ -614,106 +684,79 @@ static int iscsi_xmit_mtask(struct iscsi
  **/
 static int iscsi_data_xmit(struct iscsi_conn *conn)
 {
-	struct iscsi_transport *tt;
 	int rc = 0;
 
+	spin_lock_bh(&conn->session->lock);
 	if (unlikely(conn->suspend_tx)) {
 		debug_scsi("conn %d Tx suspended!\n", conn->id);
+		spin_unlock_bh(&conn->session->lock);
 		return -ENODATA;
 	}
-	tt = conn->session->tt;
-
-	/*
-	 * Transmit in the following order:
-	 *
-	 * 1) un-finished xmit (ctask or mtask)
-	 * 2) immediate control PDUs
-	 * 3) write data
-	 * 4) SCSI commands
-	 * 5) non-immediate control PDUs
-	 *
-	 * No need to lock around __kfifo_get as long as
-	 * there's one producer and one consumer.
-	 */
-
-	BUG_ON(conn->ctask && conn->mtask);
 
 	if (conn->ctask) {
-		iscsi_get_ctask(conn->ctask);
-		rc = tt->xmit_cmd_task(conn, conn->ctask);
-		iscsi_put_ctask(conn->ctask);
+		rc = iscsi_xmit_ctask(conn);
 		if (rc)
 			goto again;
-		/* done with this in-progress ctask */
-		conn->ctask = NULL;
 	}
+
 	if (conn->mtask) {
 		rc = iscsi_xmit_mtask(conn);
 	        if (rc)
 		        goto again;
 	}
 
-	/* process immediate first */
-        if (unlikely(__kfifo_len(conn->immqueue))) {
-	        while (__kfifo_get(conn->immqueue, (void*)&conn->mtask,
-			           sizeof(void*))) {
-			spin_lock_bh(&conn->session->lock);
-			list_add_tail(&conn->mtask->running,
-				      &conn->mgmt_run_list);
-			spin_unlock_bh(&conn->session->lock);
-			rc = iscsi_xmit_mtask(conn);
-		        if (rc)
-			        goto again;
-	        }
+	/*
+	 * process mgmt pdus like nops before commands since we should
+	 * only have one nop-out as a ping from us and targets should not
+	 * overflow us with nop-ins
+	 */
+check_mgmt:
+	while (__kfifo_get(conn->mgmtqueue, (void*)&conn->mtask,
+			   sizeof(void*))) {
+		iscsi_prep_mtask(conn, conn->mtask);
+		list_add_tail(&conn->mtask->running, &conn->mgmt_run_list);
+		rc = iscsi_xmit_mtask(conn);
+		if (rc)
+			goto again;
 	}
 
 	/* process command queue */
-	spin_lock_bh(&conn->session->lock);
 	while (!list_empty(&conn->xmitqueue)) {
+		rc = iscsi_check_cmdsn_window_closed(conn);
+		if (rc) {
+			spin_unlock_bh(&conn->session->lock);
+			return rc;
+		}
 		/*
 		 * iscsi tcp may readd the task to the xmitqueue to send
 		 * write data
 		 */
 		conn->ctask = list_entry(conn->xmitqueue.next,
 					 struct iscsi_cmd_task, running);
+		if (conn->ctask->state == ISCSI_TASK_PENDING) {
+			iscsi_prep_scsi_cmd_pdu(conn->ctask);
+			conn->session->tt->init_cmd_task(conn->ctask);
+		}
 		conn->ctask->state = ISCSI_TASK_RUNNING;
 		list_move_tail(conn->xmitqueue.next, &conn->run_list);
-		__iscsi_get_ctask(conn->ctask);
-		spin_unlock_bh(&conn->session->lock);
-
-		rc = tt->xmit_cmd_task(conn, conn->ctask);
-
-		spin_lock_bh(&conn->session->lock);
-		__iscsi_put_ctask(conn->ctask);
-		if (rc) {
-			spin_unlock_bh(&conn->session->lock);
+		rc = iscsi_xmit_ctask(conn);
+		if (rc)
 			goto again;
-		}
+		/*
+		 * we could continuously get new ctask requests so
+		 * we need to check the mgmt queue for nops that need to
+		 * be sent to aviod starvation
+		 */
+		if (__kfifo_len(conn->mgmtqueue))
+			goto check_mgmt;
 	}
 	spin_unlock_bh(&conn->session->lock);
-	/* done with this ctask */
-	conn->ctask = NULL;
-
-	/* process the rest control plane PDUs, if any */
-        if (unlikely(__kfifo_len(conn->mgmtqueue))) {
-	        while (__kfifo_get(conn->mgmtqueue, (void*)&conn->mtask,
-			           sizeof(void*))) {
-			spin_lock_bh(&conn->session->lock);
-			list_add_tail(&conn->mtask->running,
-				      &conn->mgmt_run_list);
-			spin_unlock_bh(&conn->session->lock);
-			rc = iscsi_xmit_mtask(conn);
-		        if (rc)
-			        goto again;
-	        }
-	}
-
 	return -ENODATA;
 
 again:
 	if (unlikely(conn->suspend_tx))
-		return -ENODATA;
-
+		rc = -ENODATA;
+	spin_unlock_bh(&conn->session->lock);
 	return rc;
 }
 
@@ -725,11 +768,9 @@ static void iscsi_xmitworker(struct work
 	/*
 	 * serialize Xmit worker on a per-connection basis.
 	 */
-	mutex_lock(&conn->xmitmutex);
 	do {
 		rc = iscsi_data_xmit(conn);
 	} while (rc >= 0 || rc == -EAGAIN);
-	mutex_unlock(&conn->xmitmutex);
 }
 
 enum {
@@ -787,20 +828,23 @@ int iscsi_queuecommand(struct scsi_cmnd 
 		goto fault;
 	}
 
-	/*
-	 * Check for iSCSI window and take care of CmdSN wrap-around
-	 */
-	if ((int)(session->max_cmdsn - session->cmdsn) < 0) {
-		reason = FAILURE_WINDOW_CLOSED;
-		goto reject;
-	}
-
 	conn = session->leadconn;
 	if (!conn) {
 		reason = FAILURE_SESSION_FREED;
 		goto fault;
 	}
 
+	/*
+	 * We check this here and in data xmit, because if we get to the point
+	 * that this check is hitting the window then we have enough IO in
+	 * flight and enough IO waiting to be transmitted it is better
+	 * to let the scsi/block layer queue up.
+	 */
+	if (iscsi_check_cmdsn_window_closed(conn)) {
+		reason = FAILURE_WINDOW_CLOSED;
+		goto reject;
+	}
+
 	if (!__kfifo_get(session->cmdpool.queue, (void*)&ctask,
 			 sizeof(void*))) {
 		reason = FAILURE_OOM;
@@ -815,17 +859,8 @@ int iscsi_queuecommand(struct scsi_cmnd 
 	ctask->conn = conn;
 	ctask->sc = sc;
 	INIT_LIST_HEAD(&ctask->running);
-	iscsi_prep_scsi_cmd_pdu(ctask);
-
-	session->tt->init_cmd_task(ctask);
 
 	list_add_tail(&ctask->running, &conn->xmitqueue);
-	debug_scsi(
-	       "ctask enq [%s cid %d sc %p cdb 0x%x itt 0x%x len %d cmdsn %d "
-		"win %d]\n",
-		sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
-		conn->id, sc, sc->cmnd[0], ctask->itt, sc->request_bufflen,
-		session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 	spin_unlock(&session->lock);
 
 	scsi_queue_work(host, &conn->xmitwork);
@@ -856,19 +891,16 @@ int iscsi_change_queue_depth(struct scsi
 }
 EXPORT_SYMBOL_GPL(iscsi_change_queue_depth);
 
-static int
-iscsi_conn_send_generic(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-			char *data, uint32_t data_size)
+static struct iscsi_mgmt_task *
+__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_nopout *nop = (struct iscsi_nopout *)hdr;
 	struct iscsi_mgmt_task *mtask;
 
-	spin_lock_bh(&session->lock);
-	if (session->state == ISCSI_STATE_TERMINATE) {
-		spin_unlock_bh(&session->lock);
-		return -EPERM;
-	}
+	if (session->state == ISCSI_STATE_TERMINATE)
+		return NULL;
+
 	if (hdr->opcode == (ISCSI_OP_LOGIN | ISCSI_OP_IMMEDIATE) ||
 	    hdr->opcode == (ISCSI_OP_TEXT | ISCSI_OP_IMMEDIATE))
 		/*
@@ -882,27 +914,11 @@ iscsi_conn_send_generic(struct iscsi_con
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		nop->exp_statsn = cpu_to_be32(conn->exp_statsn);
 		if (!__kfifo_get(session->mgmtpool.queue,
-				 (void*)&mtask, sizeof(void*))) {
-			spin_unlock_bh(&session->lock);
-			return -ENOSPC;
-		}
+				 (void*)&mtask, sizeof(void*)))
+			return NULL;
 	}
 
-	/*
-	 * pre-format CmdSN for outgoing PDU.
-	 */
-	if (hdr->itt != RESERVED_ITT) {
-		hdr->itt = build_itt(mtask->itt, conn->id, session->age);
-		nop->cmdsn = cpu_to_be32(session->cmdsn);
-		if (conn->c_stage == ISCSI_CONN_STARTED &&
-		    !(hdr->opcode & ISCSI_OP_IMMEDIATE))
-			session->cmdsn++;
-	} else
-		/* do not advance CmdSN */
-		nop->cmdsn = cpu_to_be32(session->cmdsn);
-
 	if (data_size) {
 		memcpy(mtask->data, data, data_size);
 		mtask->data_count = data_size;
@@ -911,38 +927,23 @@ iscsi_conn_send_generic(struct iscsi_con
 
 	INIT_LIST_HEAD(&mtask->running);
 	memcpy(mtask->hdr, hdr, sizeof(struct iscsi_hdr));
-	if (session->tt->init_mgmt_task)
-		session->tt->init_mgmt_task(conn, mtask, data, data_size);
-	spin_unlock_bh(&session->lock);
-
-	debug_scsi("mgmtpdu [op 0x%x hdr->itt 0x%x datalen %d]\n",
-		   hdr->opcode, hdr->itt, data_size);
-
-	/*
-	 * since send_pdu() could be called at least from two contexts,
-	 * we need to serialize __kfifo_put, so we don't have to take
-	 * additional lock on fast data-path
-	 */
-        if (hdr->opcode & ISCSI_OP_IMMEDIATE)
-	        __kfifo_put(conn->immqueue, (void*)&mtask, sizeof(void*));
-	else
-	        __kfifo_put(conn->mgmtqueue, (void*)&mtask, sizeof(void*));
-
-	scsi_queue_work(session->host, &conn->xmitwork);
-	return 0;
+	__kfifo_put(conn->mgmtqueue, (void*)&mtask, sizeof(void*));
+	return mtask;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 			char *data, uint32_t data_size)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	int rc;
-
-	mutex_lock(&conn->xmitmutex);
-	rc = iscsi_conn_send_generic(conn, hdr, data, data_size);
-	mutex_unlock(&conn->xmitmutex);
+	struct iscsi_session *session = conn->session;
+	int err = 0;
 
-	return rc;
+	spin_lock_bh(&session->lock);
+	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+		err = -EPERM;
+	spin_unlock_bh(&session->lock);
+	scsi_queue_work(session->host, &conn->xmitwork);
+	return err;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
 
@@ -1027,14 +1028,12 @@ static void iscsi_tmabort_timedout(unsig
 	spin_unlock(&session->lock);
 }
 
-/* must be called with the mutex lock */
 static int iscsi_exec_abort_task(struct scsi_cmnd *sc,
 				 struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_conn *conn = ctask->conn;
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tm *hdr = &conn->tmhdr;
-	int rc;
 
 	/*
 	 * ctask timed out but session is OK requests must be serialized.
@@ -1047,32 +1046,27 @@ static int iscsi_exec_abort_task(struct 
 	hdr->rtt = ctask->hdr->itt;
 	hdr->refcmdsn = ctask->hdr->cmdsn;
 
-	rc = iscsi_conn_send_generic(conn, (struct iscsi_hdr *)hdr,
-				     NULL, 0);
-	if (rc) {
+	ctask->mtask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
+					    NULL, 0);
+	if (!ctask->mtask) {
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-		debug_scsi("abort sent failure [itt 0x%x] %d\n", ctask->itt,
-		           rc);
-		return rc;
+		debug_scsi("abort sent failure [itt 0x%x]\n", ctask->itt);
+		return -EPERM;
 	}
+	ctask->state = ISCSI_TASK_ABORTING;
 
 	debug_scsi("abort sent [itt 0x%x]\n", ctask->itt);
 
-	spin_lock_bh(&session->lock);
-	ctask->mtask = (struct iscsi_mgmt_task *)
-			session->mgmt_cmds[get_itt(hdr->itt) -
-					ISCSI_MGMT_ITT_OFFSET];
-
 	if (conn->tmabort_state == TMABORT_INITIAL) {
 		conn->tmfcmd_pdus_cnt++;
-		conn->tmabort_timer.expires = 10*HZ + jiffies;
+		conn->tmabort_timer.expires = 20*HZ + jiffies;
 		conn->tmabort_timer.function = iscsi_tmabort_timedout;
 		conn->tmabort_timer.data = (unsigned long)ctask;
 		add_timer(&conn->tmabort_timer);
 		debug_scsi("abort set timeout [itt 0x%x]\n", ctask->itt);
 	}
 	spin_unlock_bh(&session->lock);
-	mutex_unlock(&conn->xmitmutex);
+	scsi_queue_work(session->host, &conn->xmitwork);
 
 	/*
 	 * block eh thread until:
@@ -1089,13 +1083,12 @@ static int iscsi_exec_abort_task(struct 
 	if (signal_pending(current))
 		flush_signals(current);
 	del_timer_sync(&conn->tmabort_timer);
-
-	mutex_lock(&conn->xmitmutex);
+	spin_lock_bh(&session->lock);
 	return 0;
 }
 
 /*
- * xmit mutex and session lock must be held
+ * session lock must be held
  */
 static struct iscsi_mgmt_task *
 iscsi_remove_mgmt_task(struct kfifo *fifo, uint32_t itt)
@@ -1127,7 +1120,7 @@ static int iscsi_ctask_mtask_cleanup(str
 	if (!ctask->mtask)
 		return -EINVAL;
 
-	if (!iscsi_remove_mgmt_task(conn->immqueue, ctask->mtask->itt))
+	if (!iscsi_remove_mgmt_task(conn->mgmtqueue, ctask->mtask->itt))
 		list_del(&ctask->mtask->running);
 	__kfifo_put(session->mgmtpool.queue, (void*)&ctask->mtask,
 		    sizeof(void*));
@@ -1136,7 +1129,7 @@ static int iscsi_ctask_mtask_cleanup(str
 }
 
 /*
- * session lock and xmitmutex must be held
+ * session lock must be held
  */
 static void fail_command(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask,
 			 int err)
@@ -1147,11 +1140,14 @@ static void fail_command(struct iscsi_co
 	if (!sc)
 		return;
 
-	conn->session->tt->cleanup_cmd_task(conn, ctask);
+	if (ctask->state != ISCSI_TASK_PENDING)
+		conn->session->tt->cleanup_cmd_task(conn, ctask);
 	iscsi_ctask_mtask_cleanup(ctask);
 
 	sc->result = err;
 	sc->resid = sc->request_bufflen;
+	if (conn->ctask == ctask)
+		conn->ctask = NULL;
 	/* release ref from queuecommand */
 	__iscsi_put_ctask(ctask);
 }
@@ -1179,7 +1175,6 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	conn->eh_abort_cnt++;
 	debug_scsi("aborting [sc %p itt 0x%x]\n", sc, ctask->itt);
 
-	mutex_lock(&conn->xmitmutex);
 	spin_lock_bh(&session->lock);
 
 	/*
@@ -1192,9 +1187,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 
 	/* ctask completed before time out */
 	if (!ctask->sc) {
-		spin_unlock_bh(&session->lock);
 		debug_scsi("sc completed while abort in progress\n");
-		goto success_rel_mutex;
+		goto success;
 	}
 
 	/* what should we do here ? */
@@ -1204,15 +1198,13 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		goto failed;
 	}
 
-	if (ctask->state == ISCSI_TASK_PENDING)
-		goto success_cleanup;
+	if (ctask->state == ISCSI_TASK_PENDING) {
+		fail_command(conn, ctask, DID_ABORT << 16);
+		goto success;
+	}
 
 	conn->tmabort_state = TMABORT_INITIAL;
-
-	spin_unlock_bh(&session->lock);
 	rc = iscsi_exec_abort_task(sc, ctask);
-	spin_lock_bh(&session->lock);
-
 	if (rc || sc->SCp.phase != session->age ||
 	    session->state != ISCSI_STATE_LOGGED_IN)
 		goto failed;
@@ -1220,45 +1212,44 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 
 	switch (conn->tmabort_state) {
 	case TMABORT_SUCCESS:
-		goto success_cleanup;
+		spin_unlock_bh(&session->lock);
+		/*
+		 * clean up task if aborted. grab the recv lock as a writer
+		 */
+		write_lock_bh(conn->recv_lock);
+		spin_lock(&session->lock);
+		fail_command(conn, ctask, DID_ABORT << 16);
+		spin_unlock(&session->lock);
+		write_unlock_bh(conn->recv_lock);
+		/*
+		 * make sure xmit thread is not still touching the
+		 * ctask/scsi_cmnd
+		 */
+		scsi_flush_work(session->host);
+		goto success_unlocked;
 	case TMABORT_NOT_FOUND:
 		if (!ctask->sc) {
 			/* ctask completed before tmf abort response */
-			spin_unlock_bh(&session->lock);
 			debug_scsi("sc completed while abort in progress\n");
-			goto success_rel_mutex;
+			goto success;
 		}
 		/* fall through */
 	default:
 		/* timedout or failed */
 		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-		spin_lock_bh(&session->lock);
-		goto failed;
+		goto failed_unlocked;
 	}
 
-success_cleanup:
-	debug_scsi("abort success [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
+success:
 	spin_unlock_bh(&session->lock);
-
-	/*
-	 * clean up task if aborted. we have the xmitmutex so grab
-	 * the recv lock as a writer
-	 */
-	write_lock_bh(conn->recv_lock);
-	spin_lock(&session->lock);
-	fail_command(conn, ctask, DID_ABORT << 16);
-	spin_unlock(&session->lock);
-	write_unlock_bh(conn->recv_lock);
-
-success_rel_mutex:
-	mutex_unlock(&conn->xmitmutex);
+success_unlocked:
+	debug_scsi("abort success [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
 	return SUCCESS;
 
 failed:
 	spin_unlock_bh(&session->lock);
-	mutex_unlock(&conn->xmitmutex);
-
+failed_unlocked:
 	debug_scsi("abort failed [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
 	return FAILED;
 }
@@ -1505,11 +1496,6 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	INIT_LIST_HEAD(&conn->xmitqueue);
 
 	/* initialize general immediate & non-immediate PDU commands queue */
-	conn->immqueue = kfifo_alloc(session->mgmtpool_max * sizeof(void*),
-			                GFP_KERNEL, NULL);
-	if (conn->immqueue == ERR_PTR(-ENOMEM))
-		goto immqueue_alloc_fail;
-
 	conn->mgmtqueue = kfifo_alloc(session->mgmtpool_max * sizeof(void*),
 			                GFP_KERNEL, NULL);
 	if (conn->mgmtqueue == ERR_PTR(-ENOMEM))
@@ -1533,7 +1519,6 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	conn->login_mtask->data = conn->data = data;
 
 	init_timer(&conn->tmabort_timer);
-	mutex_init(&conn->xmitmutex);
 	init_waitqueue_head(&conn->ehwait);
 
 	return cls_conn;
@@ -1544,8 +1529,6 @@ login_mtask_data_alloc_fail:
 login_mtask_alloc_fail:
 	kfifo_free(conn->mgmtqueue);
 mgmtqueue_alloc_fail:
-	kfifo_free(conn->immqueue);
-immqueue_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
 	return NULL;
 }
@@ -1564,10 +1547,8 @@ void iscsi_conn_teardown(struct iscsi_cl
 	struct iscsi_session *session = conn->session;
 	unsigned long flags;
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	mutex_lock(&conn->xmitmutex);
-
 	spin_lock_bh(&session->lock);
+	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	conn->c_stage = ISCSI_CONN_CLEANUP_WAIT;
 	if (session->leadconn == conn) {
 		/*
@@ -1578,8 +1559,6 @@ void iscsi_conn_teardown(struct iscsi_cl
 	}
 	spin_unlock_bh(&session->lock);
 
-	mutex_unlock(&conn->xmitmutex);
-
 	/*
 	 * Block until all in-progress commands for this connection
 	 * time out or fail.
@@ -1616,7 +1595,6 @@ void iscsi_conn_teardown(struct iscsi_cl
 	}
 	spin_unlock_bh(&session->lock);
 
-	kfifo_free(conn->immqueue);
 	kfifo_free(conn->mgmtqueue);
 
 	iscsi_destroy_conn(cls_conn);
@@ -1677,8 +1655,7 @@ flush_control_queues(struct iscsi_sessio
 	struct iscsi_mgmt_task *mtask, *tmp;
 
 	/* handle pending */
-	while (__kfifo_get(conn->immqueue, (void*)&mtask, sizeof(void*)) ||
-	       __kfifo_get(conn->mgmtqueue, (void*)&mtask, sizeof(void*))) {
+	while (__kfifo_get(conn->mgmtqueue, (void*)&mtask, sizeof(void*))) {
 		if (mtask == conn->login_mtask)
 			continue;
 		debug_scsi("flushing pending mgmt task itt 0x%x\n", mtask->itt);
@@ -1748,12 +1725,12 @@ static void iscsi_start_session_recovery
 	conn->c_stage = ISCSI_CONN_STOPPED;
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	spin_unlock_bh(&session->lock);
+	scsi_flush_work(session->host);
 
 	write_lock_bh(conn->recv_lock);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
 	write_unlock_bh(conn->recv_lock);
 
-	mutex_lock(&conn->xmitmutex);
 	/*
 	 * for connection level recovery we should not calculate
 	 * header digest. conn->hdr_size used for optimization
@@ -1777,8 +1754,6 @@ static void iscsi_start_session_recovery
 	fail_all_commands(conn);
 	flush_control_queues(session, conn);
 	spin_unlock_bh(&session->lock);
-
-	mutex_unlock(&conn->xmitmutex);
 }
 
 void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 61bc8f7..8d48cf8 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -90,6 +90,7 @@ enum {
 	ISCSI_TASK_COMPLETED,
 	ISCSI_TASK_PENDING,
 	ISCSI_TASK_RUNNING,
+	ISCSI_TASK_ABORTING,
 };
 
 struct iscsi_cmd_task {
@@ -150,18 +151,11 @@ struct iscsi_conn {
 	struct iscsi_cmd_task	*ctask;		/* xmit ctask in progress */
 
 	/* xmit */
-	struct kfifo		*immqueue;	/* immediate xmit queue */
 	struct kfifo		*mgmtqueue;	/* mgmt (control) xmit queue */
 	struct list_head	mgmt_run_list;	/* list of control tasks */
 	struct list_head	xmitqueue;	/* data-path cmd queue */
 	struct list_head	run_list;	/* list of cmds in progress */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
-	/*
-	 * serializes connection xmit, access to kfifos:
-	 * xmitqueue, immqueue, mgmtqueue
-	 */
-	struct mutex		xmitmutex;
-
 	unsigned long		suspend_tx;	/* suspend Tx */
 	unsigned long		suspend_rx;	/* suspend Rx */
 
@@ -303,8 +297,7 @@ extern int iscsi_conn_get_param(struct i
 /*
  * pdu and task processing
  */
-extern int iscsi_check_assign_cmdsn(struct iscsi_session *,
-				    struct iscsi_nopin *);
+extern void iscsi_update_cmdsn(struct iscsi_session *, struct iscsi_nopin *);
 extern void iscsi_prep_unsolicit_data_pdu(struct iscsi_cmd_task *,
 					struct iscsi_data *hdr);
 extern int iscsi_conn_send_pdu(struct iscsi_cls_conn *, struct iscsi_hdr *,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 1ac450b..abc4068 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -117,8 +117,7 @@ struct iscsi_transport {
 			   struct iscsi_stats *stats);
 	void (*init_cmd_task) (struct iscsi_cmd_task *ctask);
 	void (*init_mgmt_task) (struct iscsi_conn *conn,
-				struct iscsi_mgmt_task *mtask,
-				char *data, uint32_t data_size);
+				struct iscsi_mgmt_task *mtask);
 	int (*xmit_cmd_task) (struct iscsi_conn *conn,
 			      struct iscsi_cmd_task *ctask);
 	void (*cleanup_cmd_task) (struct iscsi_conn *conn,
-- 
1.4.1.1

