From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup
 detector
Date: Tue, 28 Feb 2012 10:48:55 +0100
Message-ID: <1330422535.11248.78.camel@twins>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, James Bottomley <JBottomley@parallels.com>, Andrzej Jakowski <andrzej.jakowski@intel.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-02-27 at 12:38 -0800, Dan Williams wrote:
> An experimental hack to tease out whether we are continuing to
> run the softirq handler past the point of needing scheduling.
> 
> It allows only one trip through __do_softirq() as long as need_resched()
> is set which hopefully creates the back pressure needed to get ksoftirqd
> scheduled.
> 
> Targeted to address reports like the following that are produced
> with i/o tests to a sas domain with a large number of disks (48+), and
> lots of debugging enabled (slub_deubg, lockdep) that makes the
> block+scsi softirq path more cpu-expensive than normal.
> 
> With this patch applied the softlockup detector seems appeased, but it
> seems odd to need changes to kernel/softirq.c so maybe I have overlooked
> something that needs changing at the block/scsi level?
> 
> BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:78] 

So you're stuck in softirq for 22s+, max_restart is 10, this gives that
on average you spend 2.2s+ per softirq invocation, this is completely
absolutely bonkers. Softirq handlers should never consume significant
amount of cpu-time.

Thomas, think its about time we put something like the below in?


---
 kernel/softirq.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index ff066a4..6137ee1 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -210,6 +210,7 @@ asmlinkage void __do_softirq(void)
 	__u32 pending;
 	int max_restart = MAX_SOFTIRQ_RESTART;
 	int cpu;
+	u64 start, callback, now;
 
 	pending = local_softirq_pending();
 	account_system_vtime(current);
@@ -223,6 +224,8 @@ asmlinkage void __do_softirq(void)
 	/* Reset the pending bitmask before enabling irqs */
 	set_softirq_pending(0);
 
+	start = callback = cpu_clock(cpu);
+
 	local_irq_enable();
 
 	h = softirq_vec;
@@ -246,6 +249,15 @@ asmlinkage void __do_softirq(void)
 				preempt_count() = prev_count;
 			}
 
+			now = cpu_clock(cpu);
+			if (now - callback > TICK_NSEC / 4) {
+				printk(KERN_ERR "softirq took longer than 1/4 tick: "
+						"%u %s %p\n", vec_nr, 
+						softirq_to_name[vec_nr],
+						h->action);
+			}
+			callback = now;
+
 			rcu_bh_qs(cpu);
 		}
 		h++;
@@ -254,6 +266,10 @@ asmlinkage void __do_softirq(void)
 
 	local_irq_disable();
 
+	now = cpu_clock(cpu);
+	if (now - start > TICK_NSEC / 2)
+		printk(KERN_ERR "softirq loop took longer than 1/2 tick\n");
+
 	pending = local_softirq_pending();
 	if (pending && --max_restart)
 		goto restart;
