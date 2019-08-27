Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAEDC3A5A6
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 08:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FAA12173E
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 08:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfH0IyR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 04:54:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbfH0IyQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 04:54:16 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 215674E832;
        Tue, 27 Aug 2019 08:54:16 +0000 (UTC)
Received: from localhost (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D52FA5DA8B;
        Tue, 27 Aug 2019 08:54:11 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Long Li <longli@microsoft.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/4] genirq: add IRQF_RESCUE_THREAD
Date:   Tue, 27 Aug 2019 16:53:42 +0800
Message-Id: <20190827085344.30799-3-ming.lei@redhat.com>
In-Reply-To: <20190827085344.30799-1-ming.lei@redhat.com>
References: <20190827085344.30799-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 27 Aug 2019 08:54:16 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For some high performance IO devices, interrupt may come very frequently,
meantime IO request completion may take a bit time. Especially on some
devices(SCSI or NVMe), IO requests can be submitted concurrently from
multiple CPU cores, however IO completion is only done on one of
these submission CPU cores.

Then IRQ flood can be easily triggered, and CPU lockup.

However, we can't simply use threaded IRQ for avoiding IRQ flood and
CPU lockup, because thread wakup introduces extra latency, which does
affect IO latency and throughput a lot.

Add IRQF_RESCUE_THREAD to create one interrupt thread handler for
avoiding irq flood, and the thread will be waken up for handling
interrupt in case that IRQ flood is going to be triggered

Cc: Long Li <longli@microsoft.com>
Cc: Ingo Molnar <mingo@redhat.com>,
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: John Garry <john.garry@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/interrupt.h |  6 ++++++
 kernel/irq/handle.c       |  6 +++++-
 kernel/irq/manage.c       | 12 ++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5b8328a99b2a..19fdab18e679 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -61,6 +61,11 @@
  *                interrupt handler after suspending interrupts. For system
  *                wakeup devices users need to implement wakeup detection in
  *                their interrupt handlers.
+ * IRQF_RESCUE_THREAD - Interrupt will be handled in thread context in case
+ *                that irq flood is triggered. Can't afford to always handle
+ *                irq in thread context becasue IO performance drops much by
+ *                the extra wakeup latency. So one backup thread is created
+ *                for avoiding irq flood which may cause CPU lockup.
  */
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
@@ -74,6 +79,7 @@
 #define IRQF_NO_THREAD		0x00010000
 #define IRQF_EARLY_RESUME	0x00020000
 #define IRQF_COND_SUSPEND	0x00040000
+#define IRQF_RESCUE_THREAD	0x00080000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index a4ace611f47f..8e5312c35483 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -146,7 +146,11 @@ irqreturn_t __handle_irq_event_percpu(struct irq_desc *desc, unsigned int *flags
 		irqreturn_t res;
 
 		trace_irq_handler_entry(irq, action);
-		res = action->handler(irq, action->dev_id);
+		if ((action->flags & IRQF_RESCUE_THREAD) &&
+				irq_flood_detected())
+			res = IRQ_WAKE_THREAD;
+		else
+			res = action->handler(irq, action->dev_id);
 		trace_irq_handler_exit(irq, action, res);
 
 		if (WARN_ONCE(!irqs_disabled(),"irq %u handler %pS enabled interrupts\n",
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e8f7f179bf77..1566abbf50e8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1082,6 +1082,8 @@ static int irq_thread(void *data)
 	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
 					&action->thread_flags))
 		handler_fn = irq_forced_thread_fn;
+	else if (action->flags & IRQF_RESCUE_THREAD)
+		handler_fn = irq_forced_thread_fn;
 	else
 		handler_fn = irq_thread_fn;
 
@@ -2011,6 +2013,16 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 		handler = irq_default_primary_handler;
 	}
 
+	if (irqflags & IRQF_RESCUE_THREAD) {
+		if (irqflags & IRQF_NO_THREAD)
+			return -EINVAL;
+		if (thread_fn)
+			return -EINVAL;
+		if (handler == irq_default_primary_handler)
+			return -EINVAL;
+		thread_fn = handler;
+	}
+
 	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
-- 
2.20.1

