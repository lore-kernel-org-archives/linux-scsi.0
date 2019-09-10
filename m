Return-Path: <SRS0=qYHy=XF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7AAC4740A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 03:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E41B218DE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 03:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389735AbfIJDKN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Sep 2019 23:10:13 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34678 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfIJDKN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2019 23:10:13 -0400
Received: by mail-ot1-f68.google.com with SMTP id z26so6792572oto.1;
        Mon, 09 Sep 2019 20:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kxwunZkkHtv4RXlkcMG5MzHeEbMqLnTkl646TCFSclc=;
        b=uQKT0coi9P/w75DBb4D9d72ugJqhwl2RUiVAz+tEKocNcfiuNTM04PWcLSJf8+U4BP
         CqF2jmC7r6PUEZQ54xWmO4Bv5MxmCuw2lz5XwU3aieAYdFumxqy9MojTfhZGwjQealiH
         A32Z7N08QxntqvphFCG4VnPQ2tv02OEcAw/6UUjLkrq3jq/wtQdaRiwu4VMuumGAFvOu
         Z+WfAK+tnBdeIZOidwGQcii9UnIjvaJA6JZ8TgfsODijNcZq0hbHN3CvS+HnExgSZens
         O91C574QtMtBrWkJ93gExd3IO3Lk+wNbQoJFBkSG+dJCafZ96xALuXPCjlNwB34l44kl
         7ieA==
X-Gm-Message-State: APjAAAVH96nAJII+1L5yJurOmXWpmktxEIVIZX8wg1saLirjYzjJvz91
        bANtZLF/c3aSNWXlnybGOQk=
X-Google-Smtp-Source: APXvYqwPFnL2WYpMErCGuFYsJ7vq1xNVv+Ygt9e7CxeTc2yjOW04vNcinTGassMuQ4zx4sJLmkDoiQ==
X-Received: by 2002:a05:6830:1217:: with SMTP id r23mr11958726otp.104.1568085011205;
        Mon, 09 Sep 2019 20:10:11 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id q124sm3814579oia.5.2019.09.09.20.10.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 20:10:10 -0700 (PDT)
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Keith Busch <keith.busch@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
References: <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
 <ffefcfa0-09b6-9af5-f94e-8e7ddd2eef16@linaro.org>
 <6eb2a745-7b92-73ce-46f5-cc6a5ef08abc@grimberg.me>
 <20190907000100.GC12290@ming.t460p>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <f5685543-8cd5-6c6a-5b80-c77ef09c6b3b@grimberg.me>
Date:   Mon, 9 Sep 2019 20:10:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190907000100.GC12290@ming.t460p>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Ming,

>>> Ok, so the real problem is per-cpu bounded tasks.
>>>
>>> I share Thomas opinion about a NAPI like approach.
>>
>> We already have that, its irq_poll, but it seems that for this
>> use-case, we get lower performance for some reason. I'm not
>> entirely sure why that is, maybe its because we need to mask interrupts
>> because we don't have an "arm" register in nvme like network devices
>> have?
> 
> Long observed that IOPS drops much too by switching to threaded irq. If
> softirqd is waken up for handing softirq, the performance shouldn't
> be better than threaded irq.

Its true that it shouldn't be any faster, but what irqpoll already has
and we don't need to reinvent is a proper budgeting mechanism that
needs to occur when multiple devices map irq vectors to the same cpu
core.

irqpoll already maintains a percpu list and dispatch the ->poll with
a budget that the backend enforces and irqpoll multiplexes between them.
Having this mechanism in irq (hard or threaded) context sounds
unnecessary a bit.

It seems like we're attempting to stay in irq context for as long as we
can instead of scheduling to softirq/thread context if we have more than
a minimal amount of work to do. Without at least understanding why
softirq/thread degrades us so much this code seems like the wrong
approach to me. Interrupt context will always be faster, but it is
not a sufficient reason to spend as much time as possible there, is it?

We should also keep in mind, that the networking stack has been doing
this for years, I would try to understand why this cannot work for nvme
before dismissing.

> Especially, Long found that context
> switch is increased a lot after applying your irq poll patch.
> 
> http://lists.infradead.org/pipermail/linux-nvme/2019-August/026788.html

Oh, I didn't see that one, wonder why... thanks!

5% improvement, I guess we can buy that for other users as is :)

If we suffer from lots of context switches while the CPU is flooded with
interrupts, then I would argue that we're re-raising softirq too much.
In this use-case, my assumption is that the cpu cannot keep up with the
interrupts and not that it doesn't reap enough (we also reap the first
batch in interrupt context...)

Perhaps making irqpoll continue until it must resched would improve
things further? Although this is a latency vs. efficiency tradeoff,
looks like MAX_SOFTIRQ_TIME is set to 2ms:

"
  * The MAX_SOFTIRQ_TIME provides a nice upper bound in most cases, but in
  * certain cases, such as stop_machine(), jiffies may cease to
  * increment and so we need the MAX_SOFTIRQ_RESTART limit as
  * well to make sure we eventually return from this method.
  *
  * These limits have been established via experimentation.
  * The two things to balance is latency against fairness -
  * we want to handle softirqs as soon as possible, but they
  * should not be able to lock up the box.
"

Long, does this patch make any difference?
--
diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index 2f17b488d58e..d8eab563fa77 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -12,8 +12,6 @@
  #include <linux/irq_poll.h>
  #include <linux/delay.h>

-static unsigned int irq_poll_budget __read_mostly = 256;
-
  static DEFINE_PER_CPU(struct list_head, blk_cpu_iopoll);

  /**
@@ -77,42 +75,29 @@ EXPORT_SYMBOL(irq_poll_complete);

  static void __latent_entropy irq_poll_softirq(struct softirq_action *h)
  {
-       struct list_head *list = this_cpu_ptr(&blk_cpu_iopoll);
-       int rearm = 0, budget = irq_poll_budget;
-       unsigned long start_time = jiffies;
+       struct list_head *irqpoll_list = this_cpu_ptr(&blk_cpu_iopoll);
+       LIST_HEAD(list);

         local_irq_disable();
+       list_splice_init(irqpoll_list, &list);
+       local_irq_enable();

-       while (!list_empty(list)) {
+       while (!list_empty(&list)) {
                 struct irq_poll *iop;
                 int work, weight;

-               /*
-                * If softirq window is exhausted then punt.
-                */
-               if (budget <= 0 || time_after(jiffies, start_time)) {
-                       rearm = 1;
-                       break;
-               }
-
-               local_irq_enable();
-
                 /* Even though interrupts have been re-enabled, this
                  * access is safe because interrupts can only add new
                  * entries to the tail of this list, and only ->poll()
                  * calls can remove this head entry from the list.
                  */
-               iop = list_entry(list->next, struct irq_poll, list);
+               iop = list_first_entry(&list, struct irq_poll, list);

                 weight = iop->weight;
                 work = 0;
                 if (test_bit(IRQ_POLL_F_SCHED, &iop->state))
                         work = iop->poll(iop, weight);

-               budget -= work;
-
-               local_irq_disable();
-
                 /*
                  * Drivers must not modify the iopoll state, if they
                  * consume their assigned weight (or more, some drivers 
can't
@@ -125,11 +110,21 @@ static void __latent_entropy 
irq_poll_softirq(struct softirq_action *h)
                         if (test_bit(IRQ_POLL_F_DISABLE, &iop->state))
                                 __irq_poll_complete(iop);
                         else
-                               list_move_tail(&iop->list, list);
+                               list_move_tail(&iop->list, &list);
                 }
+
+               /*
+                * If softirq window is exhausted then punt.
+                */
+               if (need_resched())
+                       break;
         }

-       if (rearm)
+       local_irq_disable();
+
+       list_splice_tail_init(irqpoll_list, &list);
+       list_splice(&list, irqpoll_list);
+       if (!list_empty(irqpoll_list))
                 __raise_softirq_irqoff(IRQ_POLL_SOFTIRQ);

         local_irq_enable();
--

Reminder to the nvme side (slightly modified):
--
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 52205f8d90b4..09dc6da67b05 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -24,6 +24,7 @@
  #include <linux/io-64-nonatomic-lo-hi.h>
  #include <linux/sed-opal.h>
  #include <linux/pci-p2pdma.h>
+#include <linux/irq_poll.h>

  #include "trace.h"
  #include "nvme.h"
@@ -32,6 +33,7 @@
  #define CQ_SIZE(q)     ((q)->q_depth * sizeof(struct nvme_completion))

  #define SGES_PER_PAGE  (PAGE_SIZE / sizeof(struct nvme_sgl_desc))
+#define NVME_POLL_BUDGET_IRQ   256

  /*
   * These can be higher, but we need to ensure that any command doesn't
@@ -189,6 +191,7 @@ struct nvme_queue {
         u32 *dbbuf_cq_db;
         u32 *dbbuf_sq_ei;
         u32 *dbbuf_cq_ei;
+       struct irq_poll iop;
         struct completion delete_done;
  };

@@ -1014,11 +1017,29 @@ static inline int nvme_process_cq(struct 
nvme_queue *nvmeq, u16 *start,
         return found;
  }

+static int nvme_irqpoll_handler(struct irq_poll *iop, int budget)
+{
+       struct nvme_queue *nvmeq = container_of(iop, struct nvme_queue, 
iop);
+       struct pci_dev *pdev = to_pci_dev(nvmeq->dev->dev);
+       u16 start, end;
+       int completed;
+
+       completed = nvme_process_cq(nvmeq, &start, &end, budget);
+       nvme_complete_cqes(nvmeq, start, end);
+       if (completed < budget) {
+               irq_poll_complete(&nvmeq->iop);
+               enable_irq(pci_irq_vector(pdev, nvmeq->cq_vector));
+       }
+
+       return completed;
+}
+
  static irqreturn_t nvme_irq(int irq, void *data)
  {
         struct nvme_queue *nvmeq = data;
         irqreturn_t ret = IRQ_NONE;
         u16 start, end;
+       int budget = nvmeq->q_depth;

         /*
          * The rmb/wmb pair ensures we see all updates from a previous 
run of
@@ -1027,13 +1048,23 @@ static irqreturn_t nvme_irq(int irq, void *data)
         rmb();
         if (nvmeq->cq_head != nvmeq->last_cq_head)
                 ret = IRQ_HANDLED;
-       nvme_process_cq(nvmeq, &start, &end, -1);
+
+       /* reap here up to a budget of the size the queue depth */
+       do {
+               budget -= nvme_process_cq(nvmeq, &start, &end, budget);
+               if (start != end) {
+                       nvme_complete_cqes(nvmeq, start, end);
+                       ret = IRQ_HANDLED;
+               }
+       } while (start != end && budget > 0);
+
         nvmeq->last_cq_head = nvmeq->cq_head;
         wmb();

-       if (start != end) {
-               nvme_complete_cqes(nvmeq, start, end);
-               return IRQ_HANDLED;
+       /* if we still have cqes to reap, schedule irqpoll */
+       if (start != end && nvme_cqe_pending(nvmeq)) {
+               disable_irq_nosync(irq);
+               irq_poll_sched(&nvmeq->iop);
         }

         return ret;
@@ -1346,6 +1377,7 @@ static enum blk_eh_timer_return 
nvme_timeout(struct request *req, bool reserved)

  static void nvme_free_queue(struct nvme_queue *nvmeq)
  {
+       irq_poll_disable(&nvmeq->iop);
         dma_free_coherent(nvmeq->dev->dev, CQ_SIZE(nvmeq),
                                 (void *)nvmeq->cqes, nvmeq->cq_dma_addr);
         if (!nvmeq->sq_cmds)
@@ -1480,6 +1512,7 @@ static int nvme_alloc_queue(struct nvme_dev *dev, 
int qid, int depth)
         nvmeq->dev = dev;
         spin_lock_init(&nvmeq->sq_lock);
         spin_lock_init(&nvmeq->cq_poll_lock);
+       irq_poll_init(&nvmeq->iop, NVME_POLL_BUDGET_IRQ, 
nvme_irqpoll_handler);
         nvmeq->cq_head = 0;
         nvmeq->cq_phase = 1;
         nvmeq->q_db = &dev->dbs[qid * 2 * dev->db_stride];
--
