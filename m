From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] add cpu on/offline support in Fibre Channel exchange and
 sequence handling
Date: Fri, 8 Oct 2010 22:57:34 +0800
Message-ID: <AANLkTi=ViAo=uYK0JwK597WkV1x78mntFqU-Cn4u0Dju@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45376 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347Ab0JHO5g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2010 10:57:36 -0400
Received: by wwj40 with SMTP id 40so1291602wwj.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2010 07:57:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

Fibre Channel exchange pool is setup in a per cpu way that
entire exchange id range is divided equally across all cpus.

When cpu goes offline, the corresponding range of exchg id
becomes unavailable until it is online again.

This work tries to fix the unavailability based on notifier_block.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- o/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c	2010-10-08
22:24:48.000000000 +0800
@@ -26,6 +26,9 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>

 #include <scsi/fc/fc_fc2.h>

@@ -40,6 +43,8 @@ static u16	fc_cpu_order;	/* 2's power to
 static struct kmem_cache *fc_em_cachep;	       /* cache for exchanges */
 struct workqueue_struct *fc_exch_workqueue;

+static cpumask_t fc_offline_cpu_mask = CPU_MASK_NONE;
+
 /*
  * Structure and function definitions for managing Fibre Channel Exchanges
  * and Sequences.
@@ -666,6 +671,7 @@ static struct fc_exch *fc_exch_em_alloc(
 	unsigned int cpu;
 	u16 index;
 	struct fc_exch_pool *pool;
+	unsigned int index = -1;

 	/* allocate memory for exchange */
 	ep = mempool_alloc(mp->ep_pool, GFP_ATOMIC);
@@ -679,6 +685,7 @@ static struct fc_exch *fc_exch_em_alloc(
 	pool = per_cpu_ptr(mp->pool, cpu);
 	spin_lock_bh(&pool->lock);
 	put_cpu();
+again:
 	index = pool->next_index;
 	/* allocate new exch from pool */
 	while (fc_exch_ptr_get(pool, index)) {
@@ -719,6 +726,17 @@ out:
 err:
 	spin_unlock_bh(&pool->lock);
 	atomic_inc(&mp->stats.no_free_exch_xid);
+
+	cpu = index = cpumask_next(index, &fc_offline_cpu_mask);
+	if (cpu < nr_cpu_ids) {
+		/*
+		 * try to take the share of offline cpus
+		 */
+		pool = per_cpu_ptr(mp->pool, cpu);
+		spin_lock_bh(&pool->lock);
+		goto again;
+	}
+
 	mempool_free(ep, mp->ep_pool);
 	return NULL;
 }
@@ -2322,6 +2340,34 @@ int fc_exch_init(struct fc_lport *lport)
 }
 EXPORT_SYMBOL(fc_exch_init);

+/*
+ * cpu on/offline support
+ **/
+
+static int fc_cpu_callback(struct notifier_block *nb,
+			   unsigned long event,
+			   void *_cpu)
+{
+	int cpu = (unsigned long)_cpu;
+
+	switch (event) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		cpumask_clear_cpu(cpu, &fc_offline_cpu_mask);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		cpumask_set_cpu(cpu, &fc_offline_cpu_mask);
+		break;
+ 	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block fc_nb = {
+	.notifier_call = fc_cpu_callback,
+};
+
 /**
  * fc_setup_exch_mgr() - Setup an exchange manager
  */
@@ -2357,6 +2403,9 @@ int fc_setup_exch_mgr()
 	fc_exch_workqueue = create_singlethread_workqueue("fc_exch_workqueue");
 	if (!fc_exch_workqueue)
 		return -ENOMEM;
+
+	register_cpu_notifier(&fc_nb);
+
 	return 0;
 }

@@ -2367,4 +2416,5 @@ void fc_destroy_exch_mgr()
 {
 	destroy_workqueue(fc_exch_workqueue);
 	kmem_cache_destroy(fc_em_cachep);
+	unregister_cpu_notifier(&fc_nb);
 }
