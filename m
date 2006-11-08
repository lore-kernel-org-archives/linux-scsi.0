From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/4] iscsi_tcp: fix xmittask oops
Date: Wed, 08 Nov 2006 15:58:33 -0600
Message-ID: <1163023116954-git-send-email-michaelc@cs.wisc.edu>
References: <11630231143038-git-send-email-michaelc@cs.wisc.edu> <11630231152581-git-send-email-michaelc@cs.wisc.edu> <11630231161743-git-send-email-michaelc@cs.wisc.edu>
Reply-To: Mike Christie <michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38554 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965722AbWKHV6n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 16:58:43 -0500
In-Reply-To: <11630231161743-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

XMSTATE_SOL_HDR could be set when the xmit thread tests it, but there may
not be anything on the r2tqueue yet. Move the XMSTATE_SOL_HDR set
before the addition to the queue to make sure that when we pull something
off it it is valid. This does not add locks around the xmstate test or make
that a atmoic_t because this is a fast path and if it is set when we test it
we can handle it there without the overhead. Later on we check the xmitqueue
for all requests with the session lock so we will not miss it.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c0b8b33..d0b139c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -415,8 +415,8 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 	iscsi_solicit_data_init(conn, ctask, r2t);
 
 	tcp_ctask->exp_r2tsn = r2tsn + 1;
-	tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
 	__kfifo_put(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*));
+	tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
 	list_move_tail(&ctask->running, &conn->xmitqueue);
 
 	scsi_queue_work(session->host, &conn->xmitwork);
@@ -1627,9 +1627,12 @@ static int iscsi_send_sol_pdu(struct isc
 	if (tcp_ctask->xmstate & XMSTATE_SOL_HDR) {
 		tcp_ctask->xmstate &= ~XMSTATE_SOL_HDR;
 		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
-		if (!tcp_ctask->r2t)
+		if (!tcp_ctask->r2t) {
+			spin_lock_bh(&session->lock);
 			__kfifo_get(tcp_ctask->r2tqueue, (void*)&tcp_ctask->r2t,
 				    sizeof(void*));
+			spin_unlock_bh(&session->lock);
+		}
 send_hdr:
 		r2t = tcp_ctask->r2t;
 		dtask = &r2t->dtask;
-- 
1.4.1.1

