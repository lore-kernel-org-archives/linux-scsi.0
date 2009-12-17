From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PULL] cpumask cleanups
Date: Thu, 17 Dec 2009 12:25:43 +1030
Message-ID: <200912171225.44165.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:47980 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763285AbZLQBzv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 20:55:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux-foundation.org>, linux-scsi@vger.kernel.org, Andy Henroid <andrew.d.henroid@intel.com>, Gautham R Shenoy <ego@in.ibm.com>, Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>

The following changes since commit bea4c899f2b5fad80099aea979780ef19f9b1987:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git cpumask-cleanups

Rusty Russell (7):
      cpumask: use cpu_online in kernel/perf_event.c
      cpumask: avoid deprecated function in mm/slab.c
      cpumask: use modern cpumask style in drivers/scsi/fcoe/fcoe.c
      cpumask: convert drivers/idle/i7300_idle.c to cpumask_var_t
      cpumask: avoid dereferencing struct cpumask
      cpumask: don't recommend set_cpus_allowed hack in Documentation/cpu-hotplug.txt
      cpumask: rename tsk_cpumask to tsk_cpus_allowed

 Documentation/cpu-hotplug.txt             |   49 ++++++++++-------------------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
 drivers/idle/i7300_idle.c                 |   15 +++++---
 drivers/scsi/fcoe/fcoe.c                  |    2 +-
 include/linux/sched.h                     |    2 +-
 kernel/perf_event.c                       |    2 +-
 kernel/time/timer_list.c                  |    4 +-
 mm/slab.c                                 |    2 +-
 8 files changed, 33 insertions(+), 45 deletions(-)

commit f6325e30ebd6fc870315b017a5d4a6ab15bf790b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Dec 17 11:43:08 2009 -0600

    cpumask: use cpu_online in kernel/perf_event.c
    
    Also, we want to check against nr_cpu_ids, not num_possible_cpus().
    The latter works, but the correct bounds check is < nr_cpu_ids.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    To: Thomas Gleixner <tglx@linutronix.de>

 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 58463c1fe25f7c4183f30f06a5a86cb6cd9d8231
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Dec 17 11:43:12 2009 -0600

    cpumask: avoid deprecated function in mm/slab.c
    
    These days we use cpumask_empty() which takes a pointer.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Christoph Lameter <cl@linux-foundation.org>

 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 6957177f5c3c0e51b9e90a1d7fadb3177a333949
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Dec 17 11:43:14 2009 -0600

    cpumask: use modern cpumask style in drivers/scsi/fcoe/fcoe.c
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
    Cc: Robert Love <robert.w.love@intel.com>
    Cc: Chris Leech <christopher.leech@intel.com>
    Cc: linux-scsi@vger.kernel.org

 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit cc216b86e51e9ab22265ea9591769c9ee235e1e4
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Dec 17 11:43:24 2009 -0600

    cpumask: convert drivers/idle/i7300_idle.c to cpumask_var_t
    
    Fairly simple transformation:
    1) cpumask_t -> cpumask_var_t and alloc_cpumask_var/free_cpumask_var
       (which are a NOOP unless CONFIG_CPUMASK_OFFSTACK=y).
    2) cpu_set -> cpumask_set_cpu
    3) cpus_weight -> cpumask_weight
    4) cpu_clear -> cpumask_clear_cpu
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    To: Andy Henroid <andrew.d.henroid@intel.com>

 drivers/idle/i7300_idle.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

commit 62ac12795095dc959649c66ace78708e7ac52477
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Dec 17 11:43:26 2009 -0600

    cpumask: avoid dereferencing struct cpumask
    
    struct cpumask will be undefined soon with CONFIG_CPUMASK_OFFSTACK=y,
    to avoid them being declared on the stack.
    
    cpumask_bits() does what we want here (of course, this code is crap).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    To: Thomas Gleixner <tglx@linutronix.de>

 kernel/time/timer_list.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit 4251417484a1775ba5cbfe38c67e6d5af9615de4
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Dec 17 11:43:29 2009 -0600

    cpumask: don't recommend set_cpus_allowed hack in Documentation/cpu-hotplug.txt
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Gautham R Shenoy <ego@in.ibm.com>
    Cc: Ashok Raj <ashok.raj@intel.com>

 Documentation/cpu-hotplug.txt |   49 ++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 32 deletions(-)

commit a4636818f8e0991f32d9528f39cf4f3d6a7d30a3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Dec 17 11:43:29 2009 -0600

    cpumask: rename tsk_cpumask to tsk_cpus_allowed
    
    Noone uses this wrapper yet, and Ingo asked that it be kept consistent
    with current task_struct usage.
    
    (One user crept in via linux-next: fixed)
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au.
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Tejun Heo <tj@kernel.org>

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
 include/linux/sched.h                     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 4d4a644..a99d703 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -315,41 +315,26 @@ A: The following are what is required for CPU hotplug infrastructure to work
 
 Q: I need to ensure that a particular cpu is not removed when there is some
    work specific to this cpu is in progress.
-A: First switch the current thread context to preferred cpu
+A: There are two ways.  If your code can be run in interrupt context, use
+   smp_call_function_single(), otherwise use work_on_cpu().  Note that
+   work_on_cpu() is slow, and can fail due to out of memory:
 
 	int my_func_on_cpu(int cpu)
 	{
-		cpumask_t saved_mask, new_mask = CPU_MASK_NONE;
-		int curr_cpu, err = 0;
-
-		saved_mask = current->cpus_allowed;
-		cpu_set(cpu, new_mask);
-		err = set_cpus_allowed(current, new_mask);
-
-		if (err)
-			return err;
-
-		/*
-		 * If we got scheduled out just after the return from
-		 * set_cpus_allowed() before running the work, this ensures
-		 * we stay locked.
-		 */
-		curr_cpu = get_cpu();
-
-		if (curr_cpu != cpu) {
-			err = -EAGAIN;
-			goto ret;
-		} else {
-			/*
-			 * Do work : But cant sleep, since get_cpu() disables preempt
-			 */
-		}
-		ret:
-			put_cpu();
-			set_cpus_allowed(current, saved_mask);
-			return err;
-		}
-
+		int err;
+		get_online_cpus();
+		if (!cpu_online(cpu))
+			err = -EINVAL;
+		else
+#if NEEDS_BLOCKING
+			err = work_on_cpu(cpu, __my_func_on_cpu, NULL);
+#else
+			smp_call_function_single(cpu, __my_func_on_cpu, &err,
+						 true);
+#endif
+		put_online_cpus();
+		return err;
+	}
 
 Q: How do we determine how many CPUs are available for hotplug.
 A: There is no clear spec defined way from ACPI that can give us that
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index a9df944..f125e5c 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1136,7 +1136,7 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 	if (!alloc_cpumask_var(&oldmask, GFP_KERNEL))
 		return -ENOMEM;
 
-	cpumask_copy(oldmask, tsk_cpumask(current));
+	cpumask_copy(oldmask, tsk_cpus_allowed(current));
 	set_cpus_allowed_ptr(current, cpumask_of(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index 1f20a04..dd25300 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -81,7 +81,7 @@ static u8 i7300_idle_thrtctl_saved;
 static u8 i7300_idle_thrtlow_saved;
 static u32 i7300_idle_mc_saved;
 
-static cpumask_t idle_cpumask;
+static cpumask_var_t idle_cpumask;
 static ktime_t start_ktime;
 static unsigned long avg_idle_us;
 
@@ -459,9 +459,9 @@ static int i7300_idle_notifier(struct notifier_block *nb, unsigned long val,
 	spin_lock_irqsave(&i7300_idle_lock, flags);
 	if (val == IDLE_START) {
 
-		cpu_set(smp_processor_id(), idle_cpumask);
+		cpumask_set_cpu(smp_processor_id(), idle_cpumask);
 
-		if (cpus_weight(idle_cpumask) != num_online_cpus())
+		if (cpumask_weight(idle_cpumask) != num_online_cpus())
 			goto end;
 
 		now_ktime = ktime_get();
@@ -478,8 +478,8 @@ static int i7300_idle_notifier(struct notifier_block *nb, unsigned long val,
 		i7300_idle_ioat_start();
 
 	} else if (val == IDLE_END) {
-		cpu_clear(smp_processor_id(), idle_cpumask);
-		if (cpus_weight(idle_cpumask) == (num_online_cpus() - 1)) {
+		cpumask_clear_cpu(smp_processor_id(), idle_cpumask);
+		if (cpumask_weight(idle_cpumask) == (num_online_cpus() - 1)) {
 			/* First CPU coming out of idle */
 			u64 idle_duration_us;
 
@@ -553,7 +553,6 @@ struct debugfs_file_info {
 static int __init i7300_idle_init(void)
 {
 	spin_lock_init(&i7300_idle_lock);
-	cpus_clear(idle_cpumask);
 	total_us = 0;
 
 	if (i7300_idle_platform_probe(&fbd_dev, &ioat_dev, forceload))
@@ -565,6 +564,9 @@ static int __init i7300_idle_init(void)
 	if (i7300_idle_ioat_init())
 		return -ENODEV;
 
+	if (!zalloc_cpumask_var(&idle_cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
 	debugfs_dir = debugfs_create_dir("i7300_idle", NULL);
 	if (debugfs_dir) {
 		int i = 0;
@@ -589,6 +591,7 @@ static int __init i7300_idle_init(void)
 static void __exit i7300_idle_exit(void)
 {
 	idle_notifier_unregister(&i7300_idle_nb);
+	free_cpumask_var(idle_cpumask);
 
 	if (debugfs_dir) {
 		int i = 0;
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a30ffaa..51c24b3 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1231,7 +1231,7 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 				"CPU.\n");
 
 		spin_unlock_bh(&fps->fcoe_rx_list.lock);
-		cpu = first_cpu(cpu_online_map);
+		cpu = cpumask_first(cpu_online_mask);
 		fps = &per_cpu(fcoe_percpu, cpu);
 		spin_lock_bh(&fps->fcoe_rx_list.lock);
 		if (!fps->thread) {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 244c287..4d7adb2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1555,7 +1555,7 @@ struct task_struct {
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
-#define tsk_cpumask(tsk) (&(tsk)->cpus_allowed)
+#define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8ab8698..97d1a3d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1614,7 +1614,7 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 		 * offline CPU and activate it when the CPU comes up, but
 		 * that's for later.
 		 */
-		if (!cpu_isset(cpu, cpu_online_map))
+		if (!cpu_online(cpu))
 			return ERR_PTR(-ENODEV);
 
 		cpuctx = &per_cpu(perf_cpu_context, cpu);
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 2826563..bdfb8dd 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -237,10 +237,10 @@ static void timer_list_show_tickdevices(struct seq_file *m)
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 	print_tickdevice(m, tick_get_broadcast_device(), -1);
 	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
-		   tick_get_broadcast_mask()->bits[0]);
+		   cpumask_bits(tick_get_broadcast_mask())[0]);
 #ifdef CONFIG_TICK_ONESHOT
 	SEQ_printf(m, "tick_broadcast_oneshot_mask: %08lx\n",
-		   tick_get_broadcast_oneshot_mask()->bits[0]);
+		   cpumask_bits(tick_get_broadcast_oneshot_mask())[0]);
 #endif
 	SEQ_printf(m, "\n");
 #endif
diff --git a/mm/slab.c b/mm/slab.c
index 3f48229..7560eb0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1132,7 +1132,7 @@ static void __cpuinit cpuup_canceled(long cpu)
 		if (nc)
 			free_block(cachep, nc->entry, nc->avail, node);
 
-		if (!cpus_empty(*mask)) {
+		if (!cpumask_empty(mask)) {
 			spin_unlock_irq(&l3->list_lock);
 			goto free_array_cache;
 		}
