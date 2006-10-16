From: michaelc@cs.wisc.edu
Subject: [PATCH 5/5] libiscsi: fix logout pdu processing
Date: Mon, 16 Oct 2006 18:09:42 -0400
Message-ID: <1161036586255-git-send-email-michaelc@cs.wisc.edu>
References: <11610365823995-git-send-email-michaelc@cs.wisc.edu> <1161036583544-git-send-email-michaelc@cs.wisc.edu> <1161036584778-git-send-email-michaelc@cs.wisc.edu> <1161036585226-git-send-email-michaelc@cs.wisc.edu> <1161036586795-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:2242 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1422914AbWJPXJp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 19:09:45 -0400
In-Reply-To: <1161036586795-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

According to the iscsi RFC, we cannot send other requests if
we have sent a logout pdu. This patch enforces this requirement
by blocking the session and suspending the send thread. Userspace
decides if we restart the connection or if we just free everything.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f5a9560..2865ebd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -578,6 +578,27 @@ void iscsi_conn_failure(struct iscsi_con
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
+static int iscsi_xmit_imm_task(struct iscsi_conn *conn)
+{
+	struct iscsi_hdr *hdr = conn->mtask->hdr;
+	int rc, was_logout = 0;
+
+	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT) {
+		conn->session->state = ISCSI_STATE_IN_RECOVERY;
+		iscsi_block_session(session_to_cls(conn->session));
+		was_logout = 1;
+	}
+	rc = conn->session->tt->xmit_mgmt_task(conn, conn->mtask);
+	if (rc)
+		return rc;
+
+	if (was_logout) {
+		set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+		return -ENODATA;
+	}
+	return 0;
+}
+
 /**
  * iscsi_data_xmit - xmit any command into the scheduled connection
  * @conn: iscsi connection
@@ -623,7 +644,7 @@ static int iscsi_data_xmit(struct iscsi_
 		conn->ctask = NULL;
 	}
 	if (conn->mtask) {
-		rc = tt->xmit_mgmt_task(conn, conn->mtask);
+		rc = iscsi_xmit_imm_task(conn);
 	        if (rc)
 		        goto again;
 		/* done with this in-progress mtask */
@@ -638,7 +659,7 @@ static int iscsi_data_xmit(struct iscsi_
 			list_add_tail(&conn->mtask->running,
 				      &conn->mgmt_run_list);
 			spin_unlock_bh(&conn->session->lock);
-			rc = tt->xmit_mgmt_task(conn, conn->mtask);
+			rc = iscsi_xmit_imm_task(conn);
 		        if (rc)
 			        goto again;
 	        }
-- 
1.4.1

