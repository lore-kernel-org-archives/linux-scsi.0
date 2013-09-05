From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/16] libfc: Fix a race in fc_exch_timer_set_locked()
Date: Thu, 05 Sep 2013 12:13:01 -0700
Message-ID: <20130905191301.15235.71555.stgit@fritz>
References: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:36772 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab3IETND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:13:03 -0400
In-Reply-To: <20130905191218.15235.85917.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

It is allowed to pass a zero timeout value to fc_seq_exch_abort().
Avoid that this can cause the timeout function to drop the exchange
reference before it has been increased by fc_exch_timer_set_locked().
This patch fixes a crash when running FCoE target code with poisoning
enabled in the memory allocator.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index f6bb0fb..7000203 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -360,9 +360,10 @@ static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
 
 	FC_EXCH_DBG(ep, "Exchange timer armed : %d msecs\n", timer_msec);
 
-	if (queue_delayed_work(fc_exch_workqueue, &ep->timeout_work,
-			       msecs_to_jiffies(timer_msec)))
-		fc_exch_hold(ep);		/* hold for timer */
+	fc_exch_hold(ep);		/* hold for timer */
+	if (!queue_delayed_work(fc_exch_workqueue, &ep->timeout_work,
+				msecs_to_jiffies(timer_msec)))
+		fc_exch_release(ep);
 }
 
 /**

