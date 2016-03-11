From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 02/11] scsi/fcoe: remove CONFIG_SMP in fcoe_percpu_thread_destroy()
Date: Fri, 11 Mar 2016 16:28:54 +0100
Message-ID: <1457710143-29182-3-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37958 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbcCKP3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:30 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vasu Dev <vasu.dev@intel.com>, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

There is only a marginal win in code size if the !SMP code is ifdeffed
out. The compiler should be able to optimize almost everything out.

Remove the ifdeffery for readability sake.

Cc: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/fcoe/fcoe.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 2b0d207f4b2b..efbc8a1438ef 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1284,10 +1284,8 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 	struct task_struct *thread;
 	struct page *crc_eof;
 	struct sk_buff *skb;
-#ifdef CONFIG_SMP
 	struct fcoe_percpu_s *p0;
 	unsigned targ_cpu = get_cpu();
-#endif /* CONFIG_SMP */
 
 	FCOE_DBG("Destroying receive thread for CPU %d\n", cpu);
 
@@ -1301,7 +1299,6 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 	p->crc_eof_offset = 0;
 	spin_unlock_bh(&p->fcoe_rx_list.lock);
 
-#ifdef CONFIG_SMP
 	/*
 	 * Don't bother moving the skb's if this context is running
 	 * on the same CPU that is having its thread destroyed. This
@@ -1343,16 +1340,6 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 		spin_unlock_bh(&p->fcoe_rx_list.lock);
 	}
 	put_cpu();
-#else
-	/*
-	 * This a non-SMP scenario where the singular Rx thread is
-	 * being removed. Free all skbs and stop the thread.
-	 */
-	spin_lock_bh(&p->fcoe_rx_list.lock);
-	while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
-		kfree_skb(skb);
-	spin_unlock_bh(&p->fcoe_rx_list.lock);
-#endif
 
 	if (thread)
 		kthread_stop(thread);
-- 
2.7.0

