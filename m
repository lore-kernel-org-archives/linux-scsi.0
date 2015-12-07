From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/13] irq_poll: mark __irq_poll_complete static
Date: Mon,  7 Dec 2015 12:51:44 -0800
Message-ID: <1449521512-22921-6-git-send-email-hch@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/irq_poll.h | 1 -
 lib/irq_poll.c           | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/irq_poll.h b/include/linux/irq_poll.h
index c3145c7..ce9e1db 100644
--- a/include/linux/irq_poll.h
+++ b/include/linux/irq_poll.h
@@ -21,7 +21,6 @@ enum {
 extern void irq_poll_sched(struct irq_poll *);
 extern void irq_poll_init(struct irq_poll *, int, irq_poll_fn *);
 extern void irq_poll_complete(struct irq_poll *);
-extern void __irq_poll_complete(struct irq_poll *);
 extern void irq_poll_enable(struct irq_poll *);
 extern void irq_poll_disable(struct irq_poll *);
 
diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index 2c7b8e6..652ef4d 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -47,13 +47,12 @@ EXPORT_SYMBOL(irq_poll_sched);
  *     See irq_poll_complete(). This function must be called with interrupts
  *     disabled.
  **/
-void __irq_poll_complete(struct irq_poll *iop)
+static void __irq_poll_complete(struct irq_poll *iop)
 {
 	list_del(&iop->list);
 	smp_mb__before_atomic();
 	clear_bit_unlock(IRQ_POLL_F_SCHED, &iop->state);
 }
-EXPORT_SYMBOL(__irq_poll_complete);
 
 /**
  * irq_poll_complete - Mark this @iop as un-polled again
-- 
1.9.1
