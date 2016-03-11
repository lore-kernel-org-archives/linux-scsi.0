From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 04/11] scsi/fcoe: rename p0 to p_target in fcoe_percpu_thread_destroy()
Date: Fri, 11 Mar 2016 16:28:56 +0100
Message-ID: <1457710143-29182-5-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37976 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586AbcCKP3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:32 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vasu Dev <vasu.dev@intel.com>, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

The `p' and `p0' variables have very small names on can get mixed up
easily. Thus I rename `p0' to `p_target' so it sounds more like the
target pointer than `p0' does.

Cc: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/fcoe/fcoe.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 50e9e980563e..06f56b7f51c2 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1284,7 +1284,7 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 	struct task_struct *thread;
 	struct page *crc_eof;
 	struct sk_buff *skb;
-	struct fcoe_percpu_s *p0;
+	struct fcoe_percpu_s *p_target;
 	unsigned targ_cpu = get_cpu();
 
 	FCOE_DBG("Destroying receive thread for CPU %d\n", cpu);
@@ -1305,15 +1305,15 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 	 * can easily happen when the module is removed.
 	 */
 	if (cpu != targ_cpu) {
-		p0 = &per_cpu(fcoe_percpu, targ_cpu);
-		spin_lock_bh(&p0->fcoe_rx_list.lock);
-		if (p0->thread) {
+		p_target = &per_cpu(fcoe_percpu, targ_cpu);
+		spin_lock_bh(&p_target->fcoe_rx_list.lock);
+		if (p_target->thread) {
 			FCOE_DBG("Moving frames from CPU %d to CPU %d\n",
 				 cpu, targ_cpu);
 
 			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
-				__skb_queue_tail(&p0->fcoe_rx_list, skb);
-			spin_unlock_bh(&p0->fcoe_rx_list.lock);
+				__skb_queue_tail(&p_target->fcoe_rx_list, skb);
+			spin_unlock_bh(&p_target->fcoe_rx_list.lock);
 		} else {
 			/*
 			 * The targeted CPU is not initialized and cannot accept
@@ -1322,7 +1322,7 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 			 */
 			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
 				kfree_skb(skb);
-			spin_unlock_bh(&p0->fcoe_rx_list.lock);
+			spin_unlock_bh(&p_target->fcoe_rx_list.lock);
 		}
 	} else {
 		/*
-- 
2.7.0

