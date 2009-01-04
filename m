From: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 1/4] fastboot: Asynchronous function calls to speed up
 kernel boot
Date: Sun, 4 Jan 2009 09:28:57 -0800
Message-ID: <20090104092857.5fbf6b2d@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbZADR3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 12:29:22 -0500
In-Reply-To: <20090104092430.7ffd2c41@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org

>From 97ade4deb2124aebe73d0094da76fd136fc5b082 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 4 Jan 2009 05:32:28 -0800
Subject: [PATCH] fastboot: Asynchronous function calls to speed up kernel boot

Right now, most of the kernel boot is strictly synchronous, such that
various hardware delays are done sequentially.

In order to make the kernel boot faster, this patch introduces
infrastructure to allow doing some of the initialization steps
asynchronously, which will hide significant portions of the hardware delays
in practice.

In order to not change device order and other similar observables, this
patch does NOT do full parallel initialization.

Rather, it operates more in the way an out of order CPU does; the work may
be done out of order and asynchronous, but the observable effects
(instruction retiring for the CPU) are still done in the original sequence.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/async.h |   21 ++++
 init/main.c           |    5 +-
 kernel/Makefile       |    3 +-
 kernel/async.c        |  305 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 332 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/async.h
 create mode 100644 kernel/async.c

diff --git a/include/linux/async.h b/include/linux/async.h
new file mode 100644
index 0000000..b54d83a
--- /dev/null
+++ b/include/linux/async.h
@@ -0,0 +1,21 @@
+/*
+ * async.h: Asynchronous function calls for boot performance
+ *
+ * (C) Copyright 2009 Intel Corporation
+ * Author: Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/types.h>
+
+typedef u64 async_cookie_t;
+typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
+
+extern void async_schedule(async_func_ptr *ptr, void *data);
+extern void async_synchronize_full(void);
+extern void async_synchronize_cookie(async_cookie_t cookie);
+
diff --git a/init/main.c b/init/main.c
index cd168eb..40d5373 100644
--- a/init/main.c
+++ b/init/main.c
@@ -63,6 +63,7 @@
 #include <linux/signal.h>
 #include <linux/idr.h>
 #include <linux/ftrace.h>
+#include <linux/async.h>
 #include <trace/boot.h>
 
 #include <asm/io.h>
@@ -687,7 +688,7 @@ asmlinkage void __init start_kernel(void)
 	rest_init();
 }
 
-static int initcall_debug;
+int initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
 int do_one_initcall(initcall_t fn)
@@ -788,6 +789,8 @@ static void run_init_process(char *init_filename)
  */
 static int noinline init_post(void)
 {
+	/* need to finish all async __init code before freeing the memory */
+	async_synchronize_full();
 	free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();
diff --git a/kernel/Makefile b/kernel/Makefile
index e1c5bf3..2921d90 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,8 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
-	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o
+	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
+	    async.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff --git a/kernel/async.c b/kernel/async.c
new file mode 100644
index 0000000..9918fe5
--- /dev/null
+++ b/kernel/async.c
@@ -0,0 +1,305 @@
+/*
+ * async.c: Asynchronous function calls for boot performance
+ *
+ * (C) Copyright 2009 Intel Corporation
+ * Author: Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+
+/*
+
+Goals and Theory of Operation
+
+The primary goal of this feature is to reduce the kernel boot time,
+by doing various independent hardware delays and discovery operations
+decoupled and not strictly serialized.
+
+More specifically, the asynchronous function call concept allows
+certain operations (primarily during system boot) to happen
+asynchronously, out of order, while these operations still
+have their externally visible parts happen sequentially and in-order.
+(not unlike how out-of-order CPUs retire their instructions in order)
+
+Key to the asynchronous function call implementation is the concept of
+a "sequence cookie" (which, although it has an abstracted type, can be
+thought of as a monotonically incrementing number).
+
+The async core will assign each scheduled event such a sequence cookie and
+pass this to the called functions.
+
+The asynchronously called function should before doing a globally visible
+operation, such as registering device numbers, call the
+async_synchronize_cookie() function and pass in its own cookie. The
+async_synchronize_cookie() function will make sure that all asynchronous
+operations that were scheduled prior to the operation corresponding with the
+cookie have completed.
+
+Subsystem/driver initialization code that scheduled asynchronous probe
+functions, but which shares global resources with other drivers/subsystems
+that do not use the asynchronous call feature, need to do a full
+synchronization with the async_synchronize_full() function, before returning
+from their init function. This is to maintain strict ordering between the
+asynchronous and synchronous parts of the kernel.
+
+*/
+
+#include <linux/async.h>
+#include <linux/module.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/kthread.h>
+#include <asm/atomic.h>
+
+static async_cookie_t next_cookie = 1;
+static async_cookie_t lowest_in_progress = 1;
+
+
+static LIST_HEAD(async_pending);
+static LIST_HEAD(async_running);
+static DEFINE_SPINLOCK(async_lock);
+
+struct async_entry {
+	struct list_head list;
+	async_cookie_t   cookie;
+	async_func_ptr	 *func;
+	void             *data;
+};
+
+static DECLARE_WAIT_QUEUE_HEAD(async_done);
+static DECLARE_WAIT_QUEUE_HEAD(async_new);
+
+static atomic_t entry_count;
+static atomic_t thread_count;
+
+extern int initcall_debug;
+
+
+/*
+ * MUST be called with the lock held!
+ */
+static void __recalc_lowest_in_progress(void)
+{
+	struct async_entry *entry;
+	if (!list_empty(&async_pending)) {
+		entry = list_first_entry(&async_pending,
+			struct async_entry, list);
+		lowest_in_progress = entry->cookie;
+	} else if (!list_empty(&async_running)) {
+		entry = list_first_entry(&async_running,
+			struct async_entry, list);
+		lowest_in_progress = entry->cookie;
+	} else {
+		/* nothing in progress... next_cookie is "infinity" */
+		lowest_in_progress = next_cookie;
+	}
+
+}
+/*
+ * pick the first pending entry and run it
+ */
+static void run_one_entry(void)
+{
+	unsigned long flags;
+	struct async_entry *entry;
+	ktime_t calltime, delta, rettime;
+
+	/* 1) pick one task from the pending queue */
+
+	spin_lock_irqsave(&async_lock, flags);
+	if (list_empty(&async_pending))
+		goto out;
+	entry = list_first_entry(&async_pending, struct async_entry, list);
+
+	/* 2) move it to the running queue */
+	list_del(&entry->list);
+	list_add_tail(&entry->list, &async_running);
+	spin_unlock_irqrestore(&async_lock, flags);
+
+	/* 3) run it (and print duration)*/
+	if (initcall_debug) {
+		printk("calling  %lli_%pF @ %i\n", entry->cookie, entry->func, task_pid_nr(current));
+		calltime = ktime_get();
+	}
+	entry->func(entry->data, entry->cookie);
+	if (initcall_debug) {
+		rettime = ktime_get();
+		delta = ktime_sub(rettime, calltime);
+		printk("initcall %lli_%pF returned 0 after %lld usecs\n", entry->cookie,
+			entry->func, ktime_to_ns(delta) >> 10);
+	}
+
+	/* 4) remove it from the running queue */
+	spin_lock_irqsave(&async_lock, flags);
+	list_del(&entry->list);
+
+	/* 5) free the entry  */
+	kfree(entry);
+	atomic_dec(&entry_count);
+
+	/* 6) update the lowest_in_progress value */
+	__recalc_lowest_in_progress();
+
+	spin_unlock_irqrestore(&async_lock, flags);
+
+	/* 7) wake up any waiters. */
+	wake_up(&async_done);
+	return;
+
+out:
+	spin_unlock_irqrestore(&async_lock, flags);
+}
+
+
+void async_schedule(async_func_ptr *ptr, void *data)
+{
+	struct async_entry *entry;
+	unsigned long flags;
+
+	/* allow irq-off callers */
+	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
+	if (!entry) {
+		async_cookie_t newcookie;
+		spin_lock_irqsave(&async_lock, flags);
+		newcookie = next_cookie++;
+		spin_unlock_irqrestore(&async_lock, flags);
+
+		/* low on memory.. run synchronously */
+		ptr(data, newcookie);
+		return;
+	}
+	entry->func = ptr;
+	entry->data = data;
+
+	spin_lock_irqsave(&async_lock, flags);
+	entry->cookie = next_cookie++;
+	list_add_tail(&entry->list, &async_pending);
+	atomic_inc(&entry_count);
+	spin_unlock_irqrestore(&async_lock, flags);
+	wake_up(&async_new);
+}
+EXPORT_SYMBOL_GPL(async_schedule);
+
+void async_synchronize_full(void)
+{
+	async_synchronize_cookie(next_cookie);
+}
+EXPORT_SYMBOL_GPL(async_synchronize_full);
+
+void async_synchronize_cookie(async_cookie_t cookie)
+{
+	ktime_t starttime, delta, endtime;
+
+	if (initcall_debug) {
+		printk("async_waiting @ %i\n", task_pid_nr(current));
+		starttime = ktime_get();
+	}
+
+	wait_event(async_done, lowest_in_progress >= cookie);
+
+	if (initcall_debug) {
+		endtime = ktime_get();
+		delta = ktime_sub(endtime, starttime);
+
+		printk("async_continuing @ %i after %lli usec\n",
+			task_pid_nr(current), ktime_to_ns(delta) >> 10);
+	}
+}
+EXPORT_SYMBOL_GPL(async_synchronize_cookie);
+
+
+static int async_thread(void *unused)
+{
+	DECLARE_WAITQUEUE(wq, current);
+	add_wait_queue(&async_new, &wq);
+
+	while (!kthread_should_stop()) {
+		int ret = HZ;
+		set_current_state(TASK_INTERRUPTIBLE);
+		/*
+		 * check the list head without lock.. false positives
+		 * are dealt with inside run_one_entry() while holding
+		 * the lock.
+		 */
+		rmb();
+		if (!list_empty(&async_pending))
+			run_one_entry();
+		else
+			ret = schedule_timeout(HZ);
+
+		if (ret == 0) {
+			/*
+			 * we timed out, this means we as thread are redundant.
+			 * we sign off and die, but we to avoid any races there
+			 * is a last-straw check to see if work snuck in.
+			 */
+			atomic_dec(&thread_count);
+			wmb(); /* manager must see our departure first */
+			if (list_empty(&async_pending))
+				break;
+			/*
+			 * woops work came in between us timing out and us
+			 * signing off; we need to stay alive and keep working.
+			 */
+			atomic_inc(&thread_count);
+		}
+	}
+	remove_wait_queue(&async_new, &wq);
+
+	return 0;
+}
+
+static int async_manager_thread(void *unused)
+{
+	int max_threads;
+	DECLARE_WAITQUEUE(wq, current);
+	add_wait_queue(&async_new, &wq);
+
+	while (!kthread_should_stop()) {
+		int tc, ec;
+
+		/*
+		 * Maximum number of worker threads.
+		 * Even on the smallest machine we want 8
+		 * Scaling by 4 per logical CPU
+		 * But no more than 256 to not overload stuff too much
+		 * (and yes these are magic numbers that might need tuning)
+		 * Calculated dynamic because early on the nr of online cpus
+		 * is 1...
+		 */
+		max_threads = 4 + 4 * num_online_cpus();
+		if (max_threads > 256)
+			max_threads = 256;
+
+
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		tc = atomic_read(&thread_count);
+		rmb();
+		ec = atomic_read(&entry_count);
+
+		while (tc < ec && tc < max_threads) {
+			kthread_run(async_thread, NULL, "async/%i", tc);
+			atomic_inc(&thread_count);
+			tc++;
+		}
+
+		schedule();
+	}
+	remove_wait_queue(&async_new, &wq);
+
+	return 0;
+}
+
+static int __init async_init(void)
+{
+	kthread_run(async_manager_thread, NULL, "async/mgr");
+	return 0;
+}
+
+core_initcall(async_init);
-- 
1.6.0.6

