From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/5] tcm_fc: Invalidation of DDP context for FCoE target in error conditions
Date: Fri, 16 Sep 2011 10:38:23 +0000
Message-ID: <1316169506-4441-3-git-send-email-nab@linux-iscsi.org>
References: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54901 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1IPLEt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2011 07:04:49 -0400
In-Reply-To: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Problem: HW DDP context wasn;t invalidated in case of ABORTS, etc...
This leads to the problem where memory pages which are used for DDP
as user descriptor could get reused for some other purpose (such as to
satisfy new memory allocation request either by kernel or user mode threads)
and since HW DDP context was not invalidated, HW continue to write to
those pages, hence causing memory corruption.

Fix: Either on incoming ABORTS or due to exchange time out, allowed the
target to cleanup HW DDP context if it was setup for respective ft_cmd.
Added new function to perform this cleanup, furthur it can be enhanced
for other cleanup activity.

Additinal Notes: To avoid calling ddp_done from multiple places, composed
the functionality in helper function "ft_invl_hw_context" and it is being
called from multiple places. Cleaned up code in function "ft_recv_write_data"
w.r.t DDP.

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_io.c |   62 +++++++++++++++++++--------------------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index c37f4cd..d35ea5a 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -219,43 +219,41 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	if (cmd->was_ddp_setup) {
 		BUG_ON(!ep);
 		BUG_ON(!lport);
-	}
-
-	/*
-	 * Doesn't expect payload if DDP is setup. Payload
-	 * is expected to be copied directly to user buffers
-	 * due to DDP (Large Rx offload),
-	 */
-	buf = fc_frame_payload_get(fp, 1);
-	if (buf)
-		pr_err("%s: xid 0x%x, f_ctl 0x%x, cmd->sg %p, "
+		/*
+		 * Since DDP (Large Rx offload) was setup for this request,
+		 * payload is expected to be copied directly to user buffers.
+		 */
+		buf = fc_frame_payload_get(fp, 1);
+		if (buf)
+			pr_err("%s: xid 0x%x, f_ctl 0x%x, cmd->sg %p, "
 				"cmd->sg_cnt 0x%x. DDP was setup"
 				" hence not expected to receive frame with "
-				"payload, Frame will be dropped if "
-				"'Sequence Initiative' bit in f_ctl is "
+				"payload, Frame will be dropped if"
+				"'Sequence Initiative' bit in f_ctl is"
 				"not set\n", __func__, ep->xid, f_ctl,
 				cmd->sg, cmd->sg_cnt);
-	/*
- 	 * Invalidate HW DDP context if it was setup for respective
- 	 * command. Invalidation of HW DDP context is requited in both
- 	 * situation (success and error). 
- 	 */
-	ft_invl_hw_context(cmd);
+		/*
+		 * Invalidate HW DDP context if it was setup for respective
+		 * command. Invalidation of HW DDP context is requited in both
+		 * situation (success and error).
+		 */
+		ft_invl_hw_context(cmd);
 
-	/*
-	 * If "Sequence Initiative (TSI)" bit set in f_ctl, means last
-	 * write data frame is received successfully where payload is
-	 * posted directly to user buffer and only the last frame's
-	 * header is posted in receive queue.
-	 *
-	 * If "Sequence Initiative (TSI)" bit is not set, means error
-	 * condition w.r.t. DDP, hence drop the packet and let explict
-	 * ABORTS from other end of exchange timer trigger the recovery.
-	 */
-	if (f_ctl & FC_FC_SEQ_INIT)
-		goto last_frame;
-	else
-		goto drop;
+		/*
+		 * If "Sequence Initiative (TSI)" bit set in f_ctl, means last
+		 * write data frame is received successfully where payload is
+		 * posted directly to user buffer and only the last frame's
+		 * header is posted in receive queue.
+		 *
+		 * If "Sequence Initiative (TSI)" bit is not set, means error
+		 * condition w.r.t. DDP, hence drop the packet and let explict
+		 * ABORTS from other end of exchange timer trigger the recovery.
+		 */
+		if (f_ctl & FC_FC_SEQ_INIT)
+			goto last_frame;
+		else
+			goto drop;
+	}
 
 	rel_off = ntohl(fh->fh_parm_offset);
 	frame_len = fr_len(fp);
-- 
1.5.6.5

