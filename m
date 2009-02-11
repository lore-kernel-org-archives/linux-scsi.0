From: akpm@linux-foundation.org
Subject: [patch for 2.6.29? 1/3] drivers/scsi: correct use of ! and &
Date: Wed, 11 Feb 2009 13:13:39 -0800
Message-ID: <200902112113.n1BLDdJJ012187@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756557AbZBKVOT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 16:14:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk, robert.w.love@intel.com

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
Cc: Robert Love <robert.w.love@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/libfc/fc_exch.c~drivers-scsi-correct-use-of-and drivers/scsi/libfc/fc_exch.c
--- a/drivers/scsi/libfc/fc_exch.c~drivers-scsi-correct-use-of-and
+++ a/drivers/scsi/libfc/fc_exch.c
@@ -283,7 +283,7 @@ static void fc_exch_release(struct fc_ex
 			ep->destructor(&ep->seq, ep->arg);
 		if (ep->lp->tt.exch_put)
 			ep->lp->tt.exch_put(ep->lp, mp, ep->xid);
-		WARN_ON(!ep->esb_stat & ESB_ST_COMPLETE);
+		WARN_ON(!(ep->esb_stat & ESB_ST_COMPLETE));
 		mempool_free(ep, mp->ep_pool);
 	}
 }
_
