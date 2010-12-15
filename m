From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Wed, 15 Dec 2010 12:22:53 -0500
Message-ID: <1292433773.4688.278.camel@mulgrave.site>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>
	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>
	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>
	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org>
	 <1292382245.19511.56.camel@mulgrave.site>  <4D08E2FF.5090605@kernel.org>
	 <1292428486.4688.180.camel@mulgrave.site>  <4D08E624.3020808@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46386 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab0LORW7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2010 12:22:59 -0500
In-Reply-To: <4D08E624.3020808@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>

On Wed, 2010-12-15 at 17:00 +0100, Tejun Heo wrote:
> Hello,
> 
> On 12/15/2010 04:54 PM, James Bottomley wrote:
> > On Wed, 2010-12-15 at 16:47 +0100, Tejun Heo wrote:
> >> One way or the other, the current code is racy.  The module can go
> >> away while the work is still running.  We'll have to add sync
> >> interface for ew's, which conceptually is fine but is unnecessary with
> >> the current code base.  Let's do it when it actually is necessary.
> > 
> > OK, ignoring the bickering over API, this is what I don't get.
> > 
> > The executed function releases the parent reference as its last call.
> > That will cause the freeing of the embedded work item and a cascade
> > release of all the parents.  If there's no more references, that will
> > result in a final put of the module semaphore and rmmod will then
> > proceed.  What is racy about that?  All the work structures and
> > references have been freed before the module gets removed.  Nothing
> > blocks the execution thread in the function, so it exits long before the
> > code path gets zeroed.
> 
> Because the final put and return aren't atomic against module
> unloading.  The worker can get preempted inbetween and the module can
> be unloaded beneath it.  When the worker is scheduled back, its text,
> which was inside the module, is gone.
> 
> To make that working, it either has to do the final put from the code
> outside of the module (in another module or built-in) or the module
> unloading should guarantee that the work item has finished executing
> before proceeding with unload, which can only be done by flushing it
> from outside the work itself.

Hmm, I suppose the original coding didn't contemplate pre-emption.  This
should fix it then, I think (with no alteration to the callsites because
of the encapsulating API).  It does assume the function being executed
is local to the file doing the execution, which is true in all current
cases.

James

---

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 0c0771f..1ebe4a1 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
 #include <linux/threads.h>
+#include <linux/module.h>
 #include <asm/atomic.h>
 
 struct workqueue_struct;
@@ -101,6 +102,8 @@ static inline struct delayed_work *to_delayed_work(struct work_struct *work)
 
 struct execute_work {
 	struct work_struct work;
+	work_func_t fn;
+	struct module *module;
 };
 
 #ifdef CONFIG_LOCKDEP
@@ -353,7 +356,11 @@ extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 extern int schedule_on_each_cpu(work_func_t func);
 extern int keventd_up(void);
 
-int execute_in_process_context(work_func_t fn, struct execute_work *);
+int __execute_in_process_context(work_func_t fn, struct execute_work *,
+				 struct module *);
+
+#define execute_in_process_context(fn, ew) \
+	__execute_in_process_context(fn, ew, THIS_MODULE)
 
 extern bool flush_work(struct work_struct *work);
 extern bool flush_work_sync(struct work_struct *work);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e785b0f..8f5d111 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2727,6 +2727,15 @@ void flush_scheduled_work(void)
 }
 EXPORT_SYMBOL(flush_scheduled_work);
 
+/* Wrapper to release the module in pinned kernel space */
+static void __execute_in_process_context_fn(struct work_struct *work)
+{
+	struct execute_work *ew = container_of(work, struct execute_work, work);
+
+	ew->fn(&ew->work);
+	module_put(ew->module);
+}
+
 /**
  * execute_in_process_context - reliably execute the routine with user context
  * @fn:		the function to execute
@@ -2739,19 +2748,25 @@ EXPORT_SYMBOL(flush_scheduled_work);
  * Returns:	0 - function was executed
  *		1 - function was scheduled for execution
  */
-int execute_in_process_context(work_func_t fn, struct execute_work *ew)
+int __execute_in_process_context(work_func_t fn, struct execute_work *ew,
+				 struct module *module)
 {
 	if (!in_interrupt()) {
 		fn(&ew->work);
 		return 0;
 	}
 
-	INIT_WORK(&ew->work, fn);
+	/* This would mean the module is already dying and the function
+	 * must be completely unsafe to execute */
+	BUG_ON(!try_module_get(module));
+	ew->fn = fn;
+	ew->module = module;
+	INIT_WORK(&ew->work, __execute_in_process_context_fn);
 	schedule_work(&ew->work);
 
 	return 1;
 }
-EXPORT_SYMBOL_GPL(execute_in_process_context);
+EXPORT_SYMBOL_GPL(__execute_in_process_context);
 
 int keventd_up(void)
 {


