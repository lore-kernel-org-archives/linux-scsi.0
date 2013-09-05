From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/16] libfc: Clarify fc_exch_find()
Date: Thu, 05 Sep 2013 12:12:55 -0700
Message-ID: <20130905191255.15235.3353.stgit@fritz>
References: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54865 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab3IETM4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:12:56 -0400
In-Reply-To: <20130905191218.15235.85917.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

The condition ep != NULL && ep->xid != xid can never be met. Make
this explicit.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index d0be52a..f6bb0fb 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -836,8 +836,10 @@ static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
 		pool = per_cpu_ptr(mp->pool, xid & fc_cpu_mask);
 		spin_lock_bh(&pool->lock);
 		ep = fc_exch_ptr_get(pool, (xid - mp->min_xid) >> fc_cpu_order);
-		if (ep && ep->xid == xid)
+		if (ep) {
+			WARN_ON(ep->xid != xid);
 			fc_exch_hold(ep);
+		}
 		spin_unlock_bh(&pool->lock);
 	}
 	return ep;

