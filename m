From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/6] fastboot: Asynchronous function calls to speed up
	kernel boot
Date: Thu, 15 Jan 2009 13:55:11 +0800
Message-ID: <1231998912.20746.155.camel@rzhang-dt>
References: <20090105200959.04a626ac@infradead.org>
	 <20090105201041.3289d3dd@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090105201041.3289d3dd@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "mingo@elte.hu" <mingo@elte.hu>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-01-06 at 12:10 +0800, Arjan van de Ven wrote:
> From 15815a54b95e6866ff9532dead9cca4d6a298b54 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 4 Jan 2009 05:32:28 -0800
> Subject: [PATCH] fastboot: Asynchronous function calls to speed up kernel boot
> 
> Right now, most of the kernel boot is strictly synchronous, such that
> various hardware delays are done sequentially.
> 
> In order to make the kernel boot faster, this patch introduces
> infrastructure to allow doing some of the initialization steps
> asynchronously, which will hide significant portions of the hardware delays
> in practice.
> 
> In order to not change device order and other similar observables, this
> patch does NOT do full parallel initialization.
> 
> Rather, it operates more in the way an out of order CPU does; the work may
> be done out of order and asynchronous, but the observable effects
> (instruction retiring for the CPU) are still done in the original sequence.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  include/linux/async.h  |   21 ++++
>  init/do_mounts.c       |    2 +
>  init/main.c            |    5 +-
>  kernel/Makefile        |    3 +-
>  kernel/async.c         |  307 ++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/irq/autoprobe.c |    5 +
>  kernel/module.c        |    2 +
>  7 files changed, 343 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/async.h
>  create mode 100644 kernel/async.c
> +/*
> + * pick the first pending entry and run it
> + */
> +static void run_one_entry(void)
> +{
> +       unsigned long flags;
> +       struct async_entry *entry;
> +       ktime_t calltime, delta, rettime;
> +
> +       /* 1) pick one task from the pending queue */
> +
> +       spin_lock_irqsave(&async_lock, flags);
> +       if (list_empty(&async_pending))
> +               goto out;
> +       entry = list_first_entry(&async_pending, struct async_entry, list);
> +
> +       /* 2) move it to the running queue */
> +       list_del(&entry->list);
> +       list_add_tail(&entry->list, &async_running);
> +       spin_unlock_irqrestore(&async_lock, flags);
> +
another question,
we should move the entry to the proper run list, don't we?

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 kernel/async.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/async.c
===================================================================
--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -133,7 +133,7 @@ static void run_one_entry(void)
 
 	/* 2) move it to the running queue */
 	list_del(&entry->list);
-	list_add_tail(&entry->list, &async_running);
+	list_add_tail(&entry->list, entry->running);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 3) run it (and print duration)*/


> +       /* 3) run it (and print duration)*/
> +       if (initcall_debug) {
> +               printk("calling  %lli_%pF @ %i\n", entry->cookie, entry->func, task_pid_nr(current));
> +               calltime = ktime_get();
> +       }
> +       entry->func(entry->data, entry->cookie);
> +       if (initcall_debug) {
> +               rettime = ktime_get();
> +               delta = ktime_sub(rettime, calltime);
> +               printk("initcall %lli_%pF returned 0 after %lld usecs\n", entry->cookie,
> +                       entry->func, ktime_to_ns(delta) >> 10);
> +       }
> +
> +       /* 4) remove it from the running queue */
> +       spin_lock_irqsave(&async_lock, flags);
> +       list_del(&entry->list);
> +
> +       /* 5) free the entry  */
> +       kfree(entry);
> +       atomic_dec(&entry_count);
> +
> +       /* 6) update the lowest_in_progress value */
> +       __recalc_lowest_in_progress();
> +
> +       spin_unlock_irqrestore(&async_lock, flags);
> +
> +       /* 7) wake up any waiters. */
> +       wake_up(&async_done);
> +       return;
> +
> +out:
> +       spin_unlock_irqrestore(&async_lock, flags);
> +}
> +
> +
> +async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
> +{
> +       struct async_entry *entry;
> +       unsigned long flags;
> +       async_cookie_t newcookie;
> +
> +
> +       /* allow irq-off callers */
> +       entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
> +       if (!entry) {
> +               spin_lock_irqsave(&async_lock, flags);
> +               newcookie = next_cookie++;
> +               spin_unlock_irqrestore(&async_lock, flags);
> +
> +               /* low on memory.. run synchronously */
> +               ptr(data, newcookie);
> +               return newcookie;
> +       }
> +       entry->func = ptr;
> +       entry->data = data;
> +
> +       spin_lock_irqsave(&async_lock, flags);
> +       newcookie = entry->cookie = next_cookie++;
> +       list_add_tail(&entry->list, &async_pending);
> +       atomic_inc(&entry_count);
> +       spin_unlock_irqrestore(&async_lock, flags);
> +       wake_up(&async_new);
> +       return newcookie;
> +}
> +EXPORT_SYMBOL_GPL(async_schedule);
> +

