From: Jens Axboe <axboe@kernel.dk>
Subject: Re: rq_affinity doesn't seem to work?
Date: Tue, 12 Jul 2011 22:30:35 +0200
Message-ID: <4E1CAEEB.8050506@kernel.dk>
References: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Foong, Annie" <annie.foong@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 2011-07-12 21:03, Jiang, Dave wrote:
> Jens,
> I'm doing some performance tuning for the Intel isci SAS controller
> driver, and I noticed some interesting numbers with mpstat. Looking at
> the numbers it seems that rq_affinity is not moving the request
> completion to the request submission CPU. Using fio to saturate the
> system with 512B I/Os, I noticed that all I/Os are bound to the CPUs
> (CPUs 6 and 7) that service the hard irqs. I have put in a quick hack
> in the driver so that it records the CPU during request construction
> and then I try to steer the scsi->done() calls to the request CPUs.
> With this simple hack, mpstat shows that the soft irq contexts are now
> distributed. I observed significant performance increase. The iowait%
> gone from 30s and 40s to low single digit approaching 0. Any ideas
> what could be happening with the rq_affinity logic? I'm assuming
> rq_affinity should behave the way my hacked solution is behaving. This
> is running on an 8 core single CPU SandyBridge based system with
> hyper-threading turned off. The two MSIX interrupts on the controller
> are tied to CPU 6 and 7 respectively via /proc/irq/X/smp_affinity. I'm
> running fio with 8 SAS disks and 8 threads. 

It's probably the grouping, we need to do something about that. Does the
below patch make it behave as you expect?

diff --git a/block/blk.h b/block/blk.h
index d658628..17d53d8 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -157,6 +157,7 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
 
 static inline int blk_cpu_to_group(int cpu)
 {
+#if 0
 	int group = NR_CPUS;
 #ifdef CONFIG_SCHED_MC
 	const struct cpumask *mask = cpu_coregroup_mask(cpu);
@@ -168,6 +169,7 @@ static inline int blk_cpu_to_group(int cpu)
 #endif
 	if (likely(group < NR_CPUS))
 		return group;
+#endif
 	return cpu;
 }
 

-- 
Jens Axboe
