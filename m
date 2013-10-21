From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/19] libfc: Fix a race in fc_exch_timer_set_locked()
Date: Mon, 21 Oct 2013 11:01:08 -0700
Message-ID: <20131021180108.31563.29352.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27348 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab3JUSBJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:01:09 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
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

