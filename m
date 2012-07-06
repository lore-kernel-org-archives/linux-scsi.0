From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/6] fcoe: Cleanup locking on fcoe_percpu_receive_thread
Date: Fri, 06 Jul 2012 10:40:05 -0700
Message-ID: <20120706174005.4102.2475.stgit@fritz>
References: <20120706173959.4102.12091.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54998 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab2GFRkF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jul 2012 13:40:05 -0400
In-Reply-To: <20120706173959.4102.12091.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vasu Dev <vasu.dev@intel.com>

From: Neil Horman <nhorman@tuxdriver.com>

Noticed that we can shuffle the code around in fcoe_percpu_receive_thread a bit
and avoid taking the fcoe_rx_list lock twice per iteration.  This should improve
throughput somewhat.  With this change we take the lock, and check for new
frames in a single critical section.  Only if the list is empty do we drop the
lock and re-acquire it after being signaled to wake up.

Change Notes:
v2) did some further cleanup on the patch by replacing the 2nd call of
spin_lock/splice_init with a goto to the top of the outer loop.  This allows me
to change the inner while loop to an if conditional and remove the sencond check
of kthread_should_stop.  Based on suggestion from Vasu Dev.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index fe30b1b..656ff65 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1851,23 +1851,25 @@ static int fcoe_percpu_receive_thread(void *arg)
 
 	set_user_nice(current, -20);
 
+retry:
 	while (!kthread_should_stop()) {
 
 		spin_lock_bh(&p->fcoe_rx_list.lock);
 		skb_queue_splice_init(&p->fcoe_rx_list, &tmp);
-		spin_unlock_bh(&p->fcoe_rx_list.lock);
-
-		while ((skb = __skb_dequeue(&tmp)) != NULL)
-			fcoe_recv_frame(skb);
 
-		spin_lock_bh(&p->fcoe_rx_list.lock);
-		if (!skb_queue_len(&p->fcoe_rx_list)) {
+		if (!skb_queue_len(&tmp)) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_bh(&p->fcoe_rx_list.lock);
 			schedule();
 			set_current_state(TASK_RUNNING);
-		} else
-			spin_unlock_bh(&p->fcoe_rx_list.lock);
+			goto retry;
+		}
+
+		spin_unlock_bh(&p->fcoe_rx_list.lock);
+
+		while ((skb = __skb_dequeue(&tmp)) != NULL)
+			fcoe_recv_frame(skb);
+
 	}
 	return 0;
 }

