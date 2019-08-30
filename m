Return-Path: <SRS0=dBT0=W2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEDEC3A59F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 00:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CF8F21874
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 00:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfH3AzT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:55:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfH3AzT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 20:55:19 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86D2583F3B;
        Fri, 30 Aug 2019 00:55:18 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BDBBF608C1;
        Fri, 30 Aug 2019 00:55:07 +0000 (UTC)
Date:   Fri, 30 Aug 2019 08:55:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Long Li <longli@microsoft.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190830005459.GB25999@ming.t460p>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-2-ming.lei@redhat.com>
 <DM5PR21MB0748278B86FB5103AF6E8A37CEA20@DM5PR21MB0748.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR21MB0748278B86FB5103AF6E8A37CEA20@DM5PR21MB0748.namprd21.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 30 Aug 2019 00:55:19 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 29, 2019 at 06:15:00AM +0000, Long Li wrote:
> >>>For some high performance IO devices, interrupt may come very frequently,
> >>>meantime IO request completion may take a bit time. Especially on some
> >>>devices(SCSI or NVMe), IO requests can be submitted concurrently from
> >>>multiple CPU cores, however IO completion is only done on one of these
> >>>submission CPU cores.
> >>>
> >>>Then IRQ flood can be easily triggered, and CPU lockup.
> >>>
> >>>Implement one simple generic CPU IRQ flood detection mechanism. This
> >>>mechanism uses the CPU average interrupt interval to evaluate if IRQ flood
> >>>is triggered. The Exponential Weighted Moving Average(EWMA) is used to
> >>>compute CPU average interrupt interval.
> >>>
> >>>Cc: Long Li <longli@microsoft.com>
> >>>Cc: Ingo Molnar <mingo@redhat.com>,
> >>>Cc: Peter Zijlstra <peterz@infradead.org>
> >>>Cc: Keith Busch <keith.busch@intel.com>
> >>>Cc: Jens Axboe <axboe@fb.com>
> >>>Cc: Christoph Hellwig <hch@lst.de>
> >>>Cc: Sagi Grimberg <sagi@grimberg.me>
> >>>Cc: John Garry <john.garry@huawei.com>
> >>>Cc: Thomas Gleixner <tglx@linutronix.de>
> >>>Cc: Hannes Reinecke <hare@suse.com>
> >>>Cc: linux-nvme@lists.infradead.org
> >>>Cc: linux-scsi@vger.kernel.org
> >>>Signed-off-by: Ming Lei <ming.lei@redhat.com>
> >>>---
> >>> drivers/base/cpu.c      | 25 ++++++++++++++++++++++
> >>> include/linux/hardirq.h |  2 ++
> >>> kernel/softirq.c        | 46
> >>>+++++++++++++++++++++++++++++++++++++++++
> >>> 3 files changed, 73 insertions(+)
> >>>
> >>>diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c index
> >>>cc37511de866..7277d1aa0906 100644
> >>>--- a/drivers/base/cpu.c
> >>>+++ b/drivers/base/cpu.c
> >>>@@ -20,6 +20,7 @@
> >>> #include <linux/tick.h>
> >>> #include <linux/pm_qos.h>
> >>> #include <linux/sched/isolation.h>
> >>>+#include <linux/hardirq.h>
> >>>
> >>> #include "base.h"
> >>>
> >>>@@ -183,10 +184,33 @@ static struct attribute_group
> >>>crash_note_cpu_attr_group = {  };  #endif
> >>>
> >>>+static ssize_t show_irq_interval(struct device *dev,
> >>>+				 struct device_attribute *attr, char *buf) {
> >>>+	struct cpu *cpu = container_of(dev, struct cpu, dev);
> >>>+	ssize_t rc;
> >>>+	int cpunum;
> >>>+
> >>>+	cpunum = cpu->dev.id;
> >>>+
> >>>+	rc = sprintf(buf, "%llu\n", irq_get_avg_interval(cpunum));
> >>>+	return rc;
> >>>+}
> >>>+
> >>>+static DEVICE_ATTR(irq_interval, 0400, show_irq_interval, NULL); static
> >>>+struct attribute *irq_interval_cpu_attrs[] = {
> >>>+	&dev_attr_irq_interval.attr,
> >>>+	NULL
> >>>+};
> >>>+static struct attribute_group irq_interval_cpu_attr_group = {
> >>>+	.attrs = irq_interval_cpu_attrs,
> >>>+};
> >>>+
> >>> static const struct attribute_group *common_cpu_attr_groups[] = {  #ifdef
> >>>CONFIG_KEXEC
> >>> 	&crash_note_cpu_attr_group,
> >>> #endif
> >>>+	&irq_interval_cpu_attr_group,
> >>> 	NULL
> >>> };
> >>>
> >>>@@ -194,6 +218,7 @@ static const struct attribute_group
> >>>*hotplugable_cpu_attr_groups[] = {  #ifdef CONFIG_KEXEC
> >>> 	&crash_note_cpu_attr_group,
> >>> #endif
> >>>+	&irq_interval_cpu_attr_group,
> >>> 	NULL
> >>> };
> >>>
> >>>diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h index
> >>>da0af631ded5..fd394060ddb3 100644
> >>>--- a/include/linux/hardirq.h
> >>>+++ b/include/linux/hardirq.h
> >>>@@ -8,6 +8,8 @@
> >>> #include <linux/vtime.h>
> >>> #include <asm/hardirq.h>
> >>>
> >>>+extern u64 irq_get_avg_interval(int cpu); extern bool
> >>>+irq_flood_detected(void);
> >>>
> >>> extern void synchronize_irq(unsigned int irq);  extern bool
> >>>synchronize_hardirq(unsigned int irq); diff --git a/kernel/softirq.c
> >>>b/kernel/softirq.c index 0427a86743a4..96e01669a2e0 100644
> >>>--- a/kernel/softirq.c
> >>>+++ b/kernel/softirq.c
> >>>@@ -25,6 +25,7 @@
> >>> #include <linux/smpboot.h>
> >>> #include <linux/tick.h>
> >>> #include <linux/irq.h>
> >>>+#include <linux/sched/clock.h>
> >>>
> >>> #define CREATE_TRACE_POINTS
> >>> #include <trace/events/irq.h>
> >>>@@ -52,6 +53,12 @@ DEFINE_PER_CPU_ALIGNED(irq_cpustat_t, irq_stat);
> >>>EXPORT_PER_CPU_SYMBOL(irq_stat);  #endif
> >>>
> >>>+struct irq_interval {
> >>>+	u64                     last_irq_end;
> >>>+	u64                     avg;
> >>>+};
> >>>+DEFINE_PER_CPU(struct irq_interval, avg_irq_interval);
> >>>+
> >>> static struct softirq_action softirq_vec[NR_SOFTIRQS]
> >>>__cacheline_aligned_in_smp;
> >>>
> >>> DEFINE_PER_CPU(struct task_struct *, ksoftirqd); @@ -339,6 +346,41 @@
> >>>asmlinkage __visible void do_softirq(void)
> >>> 	local_irq_restore(flags);
> >>> }
> >>>
> >>>+/*
> >>>+ * Update average irq interval with the Exponential Weighted Moving
> >>>+ * Average(EWMA)
> >>>+ */
> >>>+static void irq_update_interval(void)
> >>>+{
> >>>+#define IRQ_INTERVAL_EWMA_WEIGHT	128
> >>>+#define IRQ_INTERVAL_EWMA_PREV_FACTOR	127
> >>>+#define IRQ_INTERVAL_EWMA_CURR_FACTOR
> >>>	(IRQ_INTERVAL_EWMA_WEIGHT - \
> >>>+		IRQ_INTERVAL_EWMA_PREV_FACTOR)
> >>>+
> >>>+	int cpu = raw_smp_processor_id();
> >>>+	struct irq_interval *inter = per_cpu_ptr(&avg_irq_interval, cpu);
> >>>+	u64 delta = sched_clock_cpu(cpu) - inter->last_irq_end;
> >>>+
> >>>+	inter->avg = (inter->avg * IRQ_INTERVAL_EWMA_PREV_FACTOR +
> 
> inter->avg will start with 0? maybe use a bigger value like IRQ_FLOOD_THRESHOLD_NS

I won't be a big deal, any initial value should be fine since it is Exponential
Weighted Moving Average.


Thanks,
Ming
