From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] scsi: libfc add missing braces to in WARN_ON
Date: Thu, 19 Feb 2009 11:35:52 -0800
Message-ID: <1235072152.4377.4.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:25365 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZBSTfy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Feb 2009 14:35:54 -0500
Received: by wf-out-1314.google.com with SMTP id 28so674971wfa.4
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2009 11:35:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Noticed by sparse:
drivers/scsi/libfc/fc_exch.c:286:3: warning: dubious: !x & y

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 66db08a..e3ee657 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -283,7 +283,7 @@ static void fc_exch_release(struct fc_exch *ep)
 			ep->destructor(&ep->seq, ep->arg);
 		if (ep->lp->tt.exch_put)
 			ep->lp->tt.exch_put(ep->lp, mp, ep->xid);
-		WARN_ON(!ep->esb_stat & ESB_ST_COMPLETE);
+		WARN_ON(!(ep->esb_stat & ESB_ST_COMPLETE));
 		mempool_free(ep, mp->ep_pool);
 	}
 }
-- 
1.6.2.rc1.175.g96b8a



