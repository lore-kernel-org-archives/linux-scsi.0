From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 06/11] scsi/fcoe: use skb_queue_splice_tail() intead of manual job
Date: Fri, 11 Mar 2016 16:28:58 +0100
Message-ID: <1457710143-29182-7-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37898 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515AbcCKP3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:25 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vasu Dev <vasu.dev@intel.com>, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

skb_queue_splice_tail() is able to do the same thing as a loop with
__skb_dequeue() and __skb_queue_tail() like we have it now.

Cc: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/fcoe/fcoe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a065b31a7a02..15826094cc65 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1311,8 +1311,8 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 			FCOE_DBG("Moving frames from CPU %d to CPU %d\n",
 				 cpu, targ_cpu);
 
-			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
-				__skb_queue_tail(&p_target->fcoe_rx_list, skb);
+			skb_queue_splice_tail(&p->fcoe_rx_list,
+					      &p_target->fcoe_rx_list);
 			spin_unlock_bh(&p_target->fcoe_rx_list.lock);
 		} else {
 			/*
-- 
2.7.0

