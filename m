From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 05/11] scsi/fcoe: drop the p_target lock earlier if there is no thread online
Date: Fri, 11 Mar 2016 16:28:57 +0100
Message-ID: <1457710143-29182-6-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37896 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbcCKP3Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:24 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vasu Dev <vasu.dev@intel.com>, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

If the thread on the target CPU is not online then all skbs are freed.
There is no need to hold p_target's lock during that period.

Cc: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/fcoe/fcoe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 06f56b7f51c2..a065b31a7a02 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1320,9 +1320,10 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 			 * new	skbs. Unlock the targeted CPU and drop the skbs
 			 * on the CPU that is going offline.
 			 */
+			spin_unlock_bh(&p_target->fcoe_rx_list.lock);
+
 			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
 				kfree_skb(skb);
-			spin_unlock_bh(&p_target->fcoe_rx_list.lock);
 		}
 	} else {
 		/*
-- 
2.7.0

