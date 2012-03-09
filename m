From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/10] fcoe: reduce contention for fcoe_rx_list lock [v2]
Date: Fri, 09 Mar 2012 14:50:24 -0800
Message-ID: <20120309225024.6515.5554.stgit@localhost6.localdomain6>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28753 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab2CIWuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:50:25 -0500
In-Reply-To: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vasu Dev <vasu.dev@intel.com>

From: Neil Horman <nhorman@tuxdriver.com>

There is potentially lots of contention for the rx_list_lock.  On a cpu that is
receiving lots of fcoe traffic, the softirq context has to add and release the
lock for every frame it receives, as does the receiving per-cpu thread.  We can
reduce this contention somewhat by altering the per-cpu threads loop such that
when traffic is detected on the fcoe_rx_list, we splice it to a temporary list.
In this way, we can process multiple skbs while only having to acquire and
release the fcoe_rx_list lock once.

[ Braces around single statement while loop removed by Robert Love
  to satisfy checkpath.pl. ]

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index d86ca37..58c88b0 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1471,7 +1471,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	 * in softirq context.
 	 */
 	__skb_queue_tail(&fps->fcoe_rx_list, skb);
-	if (fps->fcoe_rx_list.qlen == 1)
+	if (fps->thread->state == TASK_INTERRUPTIBLE)
 		wake_up_process(fps->thread);
 	spin_unlock(&fps->fcoe_rx_list.lock);
 
@@ -1790,23 +1790,29 @@ static int fcoe_percpu_receive_thread(void *arg)
 {
 	struct fcoe_percpu_s *p = arg;
 	struct sk_buff *skb;
+	struct sk_buff_head tmp;
+
+	skb_queue_head_init(&tmp);
 
 	set_user_nice(current, -20);
 
 	while (!kthread_should_stop()) {
 
 		spin_lock_bh(&p->fcoe_rx_list.lock);
-		while ((skb = __skb_dequeue(&p->fcoe_rx_list)) == NULL) {
+		skb_queue_splice_init(&p->fcoe_rx_list, &tmp);
+		spin_unlock_bh(&p->fcoe_rx_list.lock);
+
+		while ((skb = __skb_dequeue(&tmp)) != NULL)
+			fcoe_recv_frame(skb);
+
+		spin_lock_bh(&p->fcoe_rx_list.lock);
+		if (!skb_queue_len(&p->fcoe_rx_list)) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_bh(&p->fcoe_rx_list.lock);
 			schedule();
 			set_current_state(TASK_RUNNING);
-			if (kthread_should_stop())
-				return 0;
-			spin_lock_bh(&p->fcoe_rx_list.lock);
-		}
-		spin_unlock_bh(&p->fcoe_rx_list.lock);
-		fcoe_recv_frame(skb);
+		} else
+			spin_unlock_bh(&p->fcoe_rx_list.lock);
 	}
 	return 0;
 }

