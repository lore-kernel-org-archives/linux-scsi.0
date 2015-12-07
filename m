From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/13] irq_poll: fold irq_poll_disable_pending into irq_poll_softirq
Date: Mon,  7 Dec 2015 12:51:43 -0800
Message-ID: <1449521512-22921-5-git-send-email-hch@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449521512-22921-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/linux/irq_poll.h | 5 -----
 lib/irq_poll.c           | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/irq_poll.h b/include/linux/irq_poll.h
index 73d7c20..c3145c7 100644
--- a/include/linux/irq_poll.h
+++ b/include/linux/irq_poll.h
@@ -18,11 +18,6 @@ enum {
 	IRQ_POLL_F_DISABLE	= 1,
 };
 
-static inline int irq_poll_disable_pending(struct irq_poll *iop)
-{
-	return test_bit(IRQ_POLL_F_DISABLE, &iop->state);
-}
-
 extern void irq_poll_sched(struct irq_poll *);
 extern void irq_poll_init(struct irq_poll *, int, irq_poll_fn *);
 extern void irq_poll_complete(struct irq_poll *);
diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index 13cb149..2c7b8e6 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -122,7 +122,7 @@ static void irq_poll_softirq(struct softirq_action *h)
 		 * move the instance around on the list at-will.
 		 */
 		if (work >= weight) {
-			if (irq_poll_disable_pending(iop))
+			if (test_bit(IRQ_POLL_F_DISABLE, &iop->state))
 				__irq_poll_complete(iop);
 			else
 				list_move_tail(&iop->list, list);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
