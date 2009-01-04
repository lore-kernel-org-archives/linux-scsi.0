From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] libfc: ! has a higher precedence than &
Date: Sun, 04 Jan 2009 17:30:05 +0100
Message-ID: <4960E40D.1030705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:1329 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZADQaG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 11:30:06 -0500
Received: by ey-out-2122.google.com with SMTP id 22so812206eye.37
        for <linux-scsi@vger.kernel.org>; Sun, 04 Jan 2009 08:30:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robert.w.love@intel.com
Cc: linux-scsi@vger.kernel.org

! has a higher precedence than &

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
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

