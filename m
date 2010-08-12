From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 3/5 v2] BNX2I: Recouple the CFC delete cleanup with
 cm_abort/close completion
Date: Thu, 12 Aug 2010 16:44:29 -0700
Message-ID: <1281656671-5369-4-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2289 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab0HLXmr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2010 19:42:47 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Specific to the Broadcom 10g chipset, the CFC delete operation must be
coupled with the cm_abort/close with does the SRC delete/terminate offload
operation prior.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Acked-by: Benjamin Li <benli@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 02743d0..40f3758 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1996,11 +1996,13 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	else
 		close_ret = cnic->cm_abort(bnx2i_ep->cm_sk);
 
+	/* No longer allow CFC delete if cm_close/abort fails the request */
 	if (close_ret)
-		bnx2i_ep->state = EP_STATE_DISCONN_COMPL;
-
-	/* wait for option-2 conn teardown */
-	wait_event_interruptible(bnx2i_ep->ofld_wait,
+		printk(KERN_ALERT "bnx2i: %s close/abort(%d) returned %d\n",
+			bnx2i_ep->hba->netdev->name, close, close_ret);
+	else
+		/* wait for option-2 conn teardown */
+		wait_event_interruptible(bnx2i_ep->ofld_wait,
 				 bnx2i_ep->state != EP_STATE_DISCONN_START);
 
 	if (signal_pending(current))
-- 
1.7.0.5


