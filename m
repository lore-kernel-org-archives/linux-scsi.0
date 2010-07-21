From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH] BNX2I: Fixed bugs in the handling of unsolicited
 NOP-Ins
Date: Wed, 21 Jul 2010 11:51:10 -0700
Message-ID: <1279738270-21911-2-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2468 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0GUStz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 14:49:55 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Unsolicited NOP-Ins are placed in the receive queue of the hardware
which requires to be read out regardless if the receive pipe is suspended
or not.  This patch adds the disposal of this RQ element under this
condition.
Also fixed the bug in the unsolicited NOP-In handling routine which
checks for the RESERVED_ITT.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 3a66ca2..69741cf 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1544,11 +1544,9 @@ static int bnx2i_process_nopin_mesg(struct iscsi_session *session,
 	struct iscsi_task *task;
 	struct bnx2i_nop_in_msg *nop_in;
 	struct iscsi_nopin *hdr;
-	u32 itt;
 	int tgt_async_nop = 0;
 
 	nop_in = (struct bnx2i_nop_in_msg *)cqe;
-	itt = nop_in->itt & ISCSI_NOP_IN_MSG_INDEX;
 
 	spin_lock(&session->lock);
 	hdr = (struct iscsi_nopin *)&bnx2i_conn->gen_pdu.resp_hdr;
@@ -1558,7 +1556,7 @@ static int bnx2i_process_nopin_mesg(struct iscsi_session *session,
 	hdr->exp_cmdsn = cpu_to_be32(nop_in->exp_cmd_sn);
 	hdr->ttt = cpu_to_be32(nop_in->ttt);
 
-	if (itt == (u16) RESERVED_ITT) {
+	if (nop_in->itt == (u16) RESERVED_ITT) {
 		bnx2i_unsol_pdu_adjust_rq(bnx2i_conn);
 		hdr->itt = RESERVED_ITT;
 		tgt_async_nop = 1;
@@ -1566,7 +1564,8 @@ static int bnx2i_process_nopin_mesg(struct iscsi_session *session,
 	}
 
 	/* this is a response to one of our nop-outs */
-	task = iscsi_itt_to_task(conn, itt);
+	task = iscsi_itt_to_task(conn,
+				 (u32) (nop_in->itt & ISCSI_NOP_IN_MSG_INDEX));
 	if (task) {
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
 		hdr->itt = task->hdr->itt;
@@ -1716,9 +1715,17 @@ static void bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 		if (nopin->cq_req_sn != qp->cqe_exp_seq_sn)
 			break;
 
-		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx)))
+		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx))) {
+			if (nopin->op_code == ISCSI_OP_NOOP_IN) {
+				printk(KERN_ALERT "bnx2i: Unsolicited "
+					"NOP-In detected for suspended "
+					"connection dev=%s!\n",
+					bnx2i_conn->hba->netdev->name);
+				bnx2i_unsol_pdu_adjust_rq(bnx2i_conn);
+				goto cqe_out;
+			}
 			break;
-
+		}
 		tgt_async_msg = 0;
 
 		switch (nopin->op_code) {
@@ -1765,10 +1772,9 @@ static void bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 			printk(KERN_ALERT "bnx2i: unknown opcode 0x%x\n",
 					  nopin->op_code);
 		}
-
 		if (!tgt_async_msg)
 			bnx2i_conn->ep->num_active_cmds--;
-
+cqe_out:
 		/* clear out in production version only, till beta keep opcode
 		 * field intact, will be helpful in debugging (context dump)
 		 * nopin->op_code = 0;
-- 
1.7.0.5


