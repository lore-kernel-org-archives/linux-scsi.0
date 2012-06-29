From: wfg@linux.intel.com
Subject: [isci:all 19/31] sound/soc/soc-dapm.c:1618:6: warning: passing
 argument 3 of 'async_schedule_domain' from incompatible pointer type
Date: Fri, 29 Jun 2012 13:35:49 +0800
Message-ID: <20120629053549.GB11236@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55388 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab2F2Ffv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jun 2012 01:35:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dan,

There are new compile warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git all
head:   dce791868fc2a0faa6348c532cb4f2a61e1ff5e3
commit: e895407d27211e4786e566fdf8eedf0023b583d1 [19/31] async: introduce 'async_domain' type

All warnings:

sound/soc/soc-dapm.c:1618:6: warning: passing argument 3 of 'async_schedule_domain' from incompatible pointer type [enabled by default]
include/linux/async.h:47:23: note: expected 'struct async_domain *' but argument is of type 'struct list_head *'
sound/soc/soc-dapm.c:1619:2: warning: passing argument 1 of 'async_synchronize_full_domain' from incompatible pointer type [enabled by default]
include/linux/async.h:50:13: note: expected 'struct async_domain *' but argument is of type 'struct list_head *'
sound/soc/soc-dapm.c:1632:6: warning: passing argument 3 of 'async_schedule_domain' from incompatible pointer type [enabled by default]
include/linux/async.h:47:23: note: expected 'struct async_domain *' but argument is of type 'struct list_head *'
sound/soc/soc-dapm.c:1633:2: warning: passing argument 1 of 'async_synchronize_full_domain' from incompatible pointer type [enabled by default]
include/linux/async.h:50:13: note: expected 'struct async_domain *' but argument is of type 'struct list_head *'

sound/soc/soc-dapm.c:1618:
  1615		/* Run all the bias changes in parallel */
  1616		list_for_each_entry(d, &dapm->card->dapm_list, list)
  1617			async_schedule_domain(dapm_pre_sequence_async, d,
> 1618						&async_domain);
  1619		async_synchronize_full_domain(&async_domain);
  1620	
  1621		/* Power down widgets first; try to avoid amplifying pops. */

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation

--AqsLC8rIMeq19msA
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-async-introduce-async_domain-type.patch"

>From e895407d27211e4786e566fdf8eedf0023b583d1 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 May 2012 19:47:05 -0700
Subject: [PATCH] async: introduce 'async_domain' type

This is in preparation for teaching async_synchronize_full() to sync all
pending async work, and not just on the async_running domain.  This
conversion is functionally equivalent, just embedding the existing list
in a new async_domain type.

The .registered attribute is used in a later patch to distinguish
between domains that want to be flushed by async_synchronize_full()
versus those that only expect async_synchronize_{full|cookie}_domain to
be used for flushing.

Cc: Liam Girdwood <lrg@ti.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: James Bottomley <JBottomley@parallels.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/regulator/core.c      |    2 +-
 drivers/scsi/libsas/sas_ata.c |    2 +-
 drivers/scsi/scsi.c           |    3 ++-
 drivers/scsi/scsi_priv.h      |    3 ++-
 include/linux/async.h         |   35 +++++++++++++++++++++++++++++++----
 kernel/async.c                |   35 +++++++++++++++++------------------
 6 files changed, 54 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 09a737c..4293aae 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2738,19 +2738,19 @@ static void regulator_bulk_enable_async(void *data, async_cookie_t cookie)
  *
  * This convenience API allows consumers to enable multiple regulator
  * clients in a single API call.  If any consumers cannot be enabled
  * then any others that were enabled will be disabled again prior to
  * return.
  */
 int regulator_bulk_enable(int num_consumers,
 			  struct regulator_bulk_data *consumers)
 {
-	LIST_HEAD(async_domain);
+	ASYNC_DOMAIN_EXCLUSIVE(async_domain);
 	int i;
 	int ret = 0;
 
 	for (i = 0; i < num_consumers; i++) {
 		if (consumers[i].consumer->always_on)
 			consumers[i].ret = 0;
 		else
 			async_schedule_domain(regulator_bulk_enable_async,
 					      &consumers[i], &async_domain);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 607a35b..899d190 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -822,19 +822,19 @@ static void async_sas_ata_eh(void *data, async_cookie_t cookie)
 
 	sas_ata_printk(KERN_DEBUG, dev, "dev error handler\n");
 	ata_scsi_port_error_handler(ha->core.shost, ap);
 	sas_put_device(dev);
 }
 
 void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
-	LIST_HEAD(async);
+	ASYNC_DOMAIN_EXCLUSIVE(async);
 	int i;
 
 	/* it's ok to defer revalidation events during ata eh, these
 	 * disks are in one of three states:
 	 * 1/ present for initial domain discovery, and these
 	 *    resets will cause bcn flutters
 	 * 2/ hot removed, we'll discover that after eh fails
 	 * 3/ hot added after initial discovery, lost the race, and need
 	 *    to catch the next train.
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index bbbc9c9..4cade88 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -48,18 +48,19 @@
 #include <linux/init.h>
 #include <linux/completion.h>
 #include <linux/unistd.h>
 #include <linux/spinlock.h>
 #include <linux/kmod.h>
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
+#include <linux/async.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
@@ -85,19 +86,19 @@ static void scsi_done(struct scsi_cmnd *cmd);
  * Note - the initial logging level can be set here to log events at boot time.
  * After the system is up, you may enable logging via the /proc interface.
  */
 unsigned int scsi_logging_level;
 #if defined(CONFIG_SCSI_LOGGING)
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
 
 /* sd, scsi core and power management need to coordinate flushing async actions */
-LIST_HEAD(scsi_sd_probe_domain);
+ASYNC_DOMAIN(scsi_sd_probe_domain);
 EXPORT_SYMBOL(scsi_sd_probe_domain);
 
 /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
  * You may not alter any existing entry (although adding new ones is
  * encouraged once assigned by ANSI/INCITS T10
  */
 static const char *const scsi_device_types[] = {
 	"Direct-Access    ",
 	"Sequential-Access",
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 07ce3f5..eab472d 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -1,13 +1,14 @@
 #ifndef _SCSI_PRIV_H
 #define _SCSI_PRIV_H
 
 #include <linux/device.h>
+#include <linux/async.h>
 
 struct request_queue;
 struct request;
 struct scsi_cmnd;
 struct scsi_device;
 struct scsi_target;
 struct scsi_host_template;
 struct Scsi_Host;
 struct scsi_nl_hdr;
@@ -157,19 +158,19 @@ extern void scsi_autopm_put_target(struct scsi_target *);
 extern int scsi_autopm_get_host(struct Scsi_Host *);
 extern void scsi_autopm_put_host(struct Scsi_Host *);
 #else
 static inline void scsi_autopm_get_target(struct scsi_target *t) {}
 static inline void scsi_autopm_put_target(struct scsi_target *t) {}
 static inline int scsi_autopm_get_host(struct Scsi_Host *h) { return 0; }
 static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 #endif /* CONFIG_PM_RUNTIME */
 
-extern struct list_head scsi_sd_probe_domain;
+extern struct async_domain scsi_sd_probe_domain;
 
 /* 
  * internal scsi timeout functions: for use by mid-layer and transport
  * classes.
  */
 
 #define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	600	/* units in seconds */
 extern int scsi_internal_device_block(struct scsi_device *sdev);
 extern int scsi_internal_device_unblock(struct scsi_device *sdev);
diff --git a/include/linux/async.h b/include/linux/async.h
index 68a9530..364e7ff 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -3,25 +3,52 @@
  *
  * (C) Copyright 2009 Intel Corporation
  * Author: Arjan van de Ven <arjan@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; version 2
  * of the License.
  */
+#ifndef __ASYNC_H__
+#define __ASYNC_H__
 
 #include <linux/types.h>
 #include <linux/list.h>
 
 typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
+struct async_domain {
+	struct list_head node;
+	struct list_head domain;
+	int count;
+	unsigned registered:1;
+};
+
+/*
+ * domain participates in global async_synchronize_full
+ */
+#define ASYNC_DOMAIN(_name) \
+	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
+				      .domain = LIST_HEAD_INIT(_name.domain), \
+				      .count = 0, \
+				      .registered = 1 }
+
+/*
+ * domain is free to go out of scope as soon as all pending work is
+ * complete, this domain does not participate in async_synchronize_full
+ */
+#define ASYNC_DOMAIN_EXCLUSIVE(_name) \
+	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
+				      .domain = LIST_HEAD_INIT(_name.domain), \
+				      .count = 0, \
+				      .registered = 0 }
 
 extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
 extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
-					    struct list_head *list);
+					    struct async_domain *domain);
 extern void async_synchronize_full(void);
-extern void async_synchronize_full_domain(struct list_head *list);
+extern void async_synchronize_full_domain(struct async_domain *domain);
 extern void async_synchronize_cookie(async_cookie_t cookie);
 extern void async_synchronize_cookie_domain(async_cookie_t cookie,
-					    struct list_head *list);
-
+					    struct async_domain *domain);
+#endif
diff --git a/kernel/async.c b/kernel/async.c
index bd0c168..ba5491d 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -56,56 +56,55 @@ asynchronous and synchronous parts of the kernel.
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
 static async_cookie_t next_cookie = 1;
 
 #define MAX_WORK	32768
 
 static LIST_HEAD(async_pending);
-static LIST_HEAD(async_running);
+static ASYNC_DOMAIN(async_running);
 static DEFINE_SPINLOCK(async_lock);
 
 struct async_entry {
 	struct list_head	list;
 	struct work_struct	work;
 	async_cookie_t		cookie;
 	async_func_ptr		*func;
 	void			*data;
-	struct list_head	*running;
+	struct async_domain	*running;
 };
 
 static DECLARE_WAIT_QUEUE_HEAD(async_done);
 
 static atomic_t entry_count;
 
 
 /*
  * MUST be called with the lock held!
  */
-static async_cookie_t  __lowest_in_progress(struct list_head *running)
+static async_cookie_t  __lowest_in_progress(struct async_domain *running)
 {
 	struct async_entry *entry;
 
-	if (!list_empty(running)) {
-		entry = list_first_entry(running,
-			struct async_entry, list);
+	if (!list_empty(&running->domain)) {
+		entry = list_first_entry(&running->domain, typeof(*entry), list);
 		return entry->cookie;
 	}
 
 	list_for_each_entry(entry, &async_pending, list)
 		if (entry->running == running)
 			return entry->cookie;
 
 	return next_cookie;	/* "infinity" value */
 }
 
-static async_cookie_t  lowest_in_progress(struct list_head *running)
+static async_cookie_t  lowest_in_progress(struct async_domain *running)
 {
 	unsigned long flags;
 	async_cookie_t ret;
 
 	spin_lock_irqsave(&async_lock, flags);
 	ret = __lowest_in_progress(running);
 	spin_unlock_irqrestore(&async_lock, flags);
 	return ret;
 }
@@ -113,22 +112,23 @@ static async_cookie_t  lowest_in_progress(struct list_head *running)
 /*
  * pick the first pending entry and run it
  */
 static void async_run_entry_fn(struct work_struct *work)
 {
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
 	unsigned long flags;
 	ktime_t uninitialized_var(calltime), delta, rettime;
+	struct async_domain *running = entry->running;
 
 	/* 1) move self to the running queue */
 	spin_lock_irqsave(&async_lock, flags);
-	list_move_tail(&entry->list, entry->running);
+	list_move_tail(&entry->list, &running->domain);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 2) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk(KERN_DEBUG "calling  %lli_%pF @ %i\n",
 			(long long)entry->cookie,
 			entry->func, task_pid_nr(current));
 		calltime = ktime_get();
 	}
@@ -150,19 +150,19 @@ static void async_run_entry_fn(struct work_struct *work)
 	kfree(entry);
 	atomic_dec(&entry_count);
 
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 5) wake up any waiters */
 	wake_up(&async_done);
 }
 
-static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
+static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct async_domain *running)
 {
 	struct async_entry *entry;
 	unsigned long flags;
 	async_cookie_t newcookie;
 
 	/* allow irq-off callers */
 	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
 
 	/*
@@ -217,61 +217,60 @@ EXPORT_SYMBOL_GPL(async_schedule);
  * @running: running list for the domain
  *
  * Returns an async_cookie_t that may be used for checkpointing later.
  * @running may be used in the async_synchronize_*_domain() functions
  * to wait within a certain synchronization domain rather than globally.
  * A synchronization domain is specified via the running queue @running to use.
  * Note: This function may be called from atomic or non-atomic contexts.
  */
 async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
-				     struct list_head *running)
+				     struct async_domain *running)
 {
 	return __async_schedule(ptr, data, running);
 }
 EXPORT_SYMBOL_GPL(async_schedule_domain);
 
 /**
  * async_synchronize_full - synchronize all asynchronous function calls
  *
  * This function waits until all asynchronous function calls have been done.
  */
 void async_synchronize_full(void)
 {
 	do {
 		async_synchronize_cookie(next_cookie);
-	} while (!list_empty(&async_running) || !list_empty(&async_pending));
+	} while (!list_empty(&async_running.domain) || !list_empty(&async_pending));
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
 /**
  * async_synchronize_full_domain - synchronize all asynchronous function within a certain domain
- * @list: running list to synchronize on
+ * @domain: running list to synchronize on
  *
  * This function waits until all asynchronous function calls for the
- * synchronization domain specified by the running list @list have been done.
+ * synchronization domain specified by the running list @domain have been done.
  */
-void async_synchronize_full_domain(struct list_head *list)
+void async_synchronize_full_domain(struct async_domain *domain)
 {
-	async_synchronize_cookie_domain(next_cookie, list);
+	async_synchronize_cookie_domain(next_cookie, domain);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 
 /**
  * async_synchronize_cookie_domain - synchronize asynchronous function calls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
  * @running: running list to synchronize on
  *
  * This function waits until all asynchronous function calls for the
- * synchronization domain specified by the running list @list submitted
+ * synchronization domain specified by running list @running submitted
  * prior to @cookie have been done.
  */
-void async_synchronize_cookie_domain(async_cookie_t cookie,
-				     struct list_head *running)
+void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain *running)
 {
 	ktime_t uninitialized_var(starttime), delta, endtime;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk(KERN_DEBUG "async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
 	}
 
 	wait_event(async_done, lowest_in_progress(running) >= cookie);
-- 
1.7.10


--AqsLC8rIMeq19msA
Content-Type: text/x-chdr; charset=us-ascii
Content-Disposition: attachment; filename="async.h"

/*
 * async.h: Asynchronous function calls for boot performance
 *
 * (C) Copyright 2009 Intel Corporation
 * Author: Arjan van de Ven <arjan@linux.intel.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2
 * of the License.
 */
#ifndef __ASYNC_H__
#define __ASYNC_H__

#include <linux/types.h>
#include <linux/list.h>

typedef u64 async_cookie_t;
typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
struct async_domain {
	struct list_head node;
	struct list_head domain;
	int count;
	unsigned registered:1;
};

/*
 * domain participates in global async_synchronize_full
 */
#define ASYNC_DOMAIN(_name) \
	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
				      .domain = LIST_HEAD_INIT(_name.domain), \
				      .count = 0, \
				      .registered = 1 }

/*
 * domain is free to go out of scope as soon as all pending work is
 * complete, this domain does not participate in async_synchronize_full
 */
#define ASYNC_DOMAIN_EXCLUSIVE(_name) \
	struct async_domain _name = { .node = LIST_HEAD_INIT(_name.node), \
				      .domain = LIST_HEAD_INIT(_name.domain), \
				      .count = 0, \
				      .registered = 0 }

extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
					    struct async_domain *domain);
extern void async_synchronize_full(void);
extern void async_synchronize_full_domain(struct async_domain *domain);
extern void async_synchronize_cookie(async_cookie_t cookie);
extern void async_synchronize_cookie_domain(async_cookie_t cookie,
					    struct async_domain *domain);
#endif

--AqsLC8rIMeq19msA--
