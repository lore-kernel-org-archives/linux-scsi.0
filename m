From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 03/11] scsi/fcoe: drop locking in fcoe_percpu_thread_destroy() if cpu == targ_cpu
Date: Fri, 11 Mar 2016 16:28:55 +0100
Message-ID: <1457710143-29182-4-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:38003 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490AbcCKP3i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:38 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vasu Dev <vasu.dev@intel.com>, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

The locking here is not required. At the begin of the function we hold
the lock and assign NULL to p->thread. This is used in other places to
ensure that nobody adds new items to the list.
Also, in the cpu != targ_cpu case we don't hold the lock of p-> as well.
This makes is consistent.

Cc: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/fcoe/fcoe.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index efbc8a1438ef..50e9e980563e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1334,10 +1334,8 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 		 * will reach this case and we will drop all skbs and later
 		 * stop the thread.
 		 */
-		spin_lock_bh(&p->fcoe_rx_list.lock);
 		while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
 			kfree_skb(skb);
-		spin_unlock_bh(&p->fcoe_rx_list.lock);
 	}
 	put_cpu();
 
-- 
2.7.0

