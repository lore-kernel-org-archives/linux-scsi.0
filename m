From: Julia Lawall <julia@diku.dk>
Subject: [PATCH] drivers/scsi: Correct use of ! and &
Date: Wed, 4 Feb 2009 22:17:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0902042215500.3091@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:44751 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZBDVRc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2009 16:17:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

!ep->esb_stat is either 1 or 0, and the rightmost bit of ESB_ST_COMPLETE is
always 0, making the result of !ep->esb_stat & ESB_ST_COMPLETE always 0.
Thus parentheses around the argument to ! seem needed.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E; constant C; @@
(
  !E & !C
|
- !E & C
+ !(E & C)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -283,7 +283,7 @@ static void fc_exch_release(struct fc_ex
 			ep->destructor(&ep->seq, ep->arg);
 		if (ep->lp->tt.exch_put)
 			ep->lp->tt.exch_put(ep->lp, mp, ep->xid);
-		WARN_ON(!ep->esb_stat & ESB_ST_COMPLETE);
+		WARN_ON(!(ep->esb_stat & ESB_ST_COMPLETE));
 		mempool_free(ep, mp->ep_pool);
 	}
 }
