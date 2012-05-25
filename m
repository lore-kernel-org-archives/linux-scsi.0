From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/4] async: introduce 'async_domain' type
Date: Fri, 25 May 2012 00:50:27 -0700
Message-ID: <20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mroos@linux.ee
Cc: linux-scsi@vger.kernel.org, Mark Brown <broonie@opensource.wolfsonmicro.com>, linux-kernel@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Arjan van de Ven <arjan@linux.intel.com>, Liam Girdwood <lrg@ti.com>
List-Id: linux-scsi@vger.kernel.org

This is in preparation for teaching async_synchronize_full() to sync all
pending async work, and not just on the async_running domain.  This
conversion is functionally equivalent, just embedding the existing list
in a new async_domain type.

Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/regulator/core.c      |    2 +-
 drivers/scsi/libsas/sas_ata.c |    2 +-
 drivers/scsi/scsi.c           |    3 ++-
 drivers/scsi/scsi_priv.h      |    3 ++-
 include/linux/async.h         |   20 ++++++++++++++++----
 kernel/async.c                |   31 +++++++++++++++----------------
 6 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e70dd38..d1f4dae 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2521,7 +2521,7 @@ static void regulator_bulk_enable_async(void *data, async_cookie_t cookie)
 int regulator_bulk_enable(int num_consumers,
 			  struct regulator_bulk_data *consumers)
 {
-	LIST_HEAD(async_domain);
+	ASYNC_DOMAIN(async_domain);
 	int i;
 	int ret = 0;
 
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 607a35b..6dfbabc 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -828,7 +828,7 @@ static void async_sas_ata_eh(void *data, async_cookie_t cookie)
 void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
-	LIST_HEAD(async);
+	ASYNC_DOMAIN(async);
 	int i;
 
 	/* it's ok to defer revalidation events during ata eh, these
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2ecdb01..2f92007 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -54,6 +54,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
+#include <linux/async.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -91,7 +92,7 @@ EXPORT_SYMBOL(scsi_logging_level);
 #endif
 
 /* sd and scsi_pm need to coordinate flushing async actions */
-LIST_HEAD(scsi_sd_probe_domain);
+ASYNC_DOMAIN(scsi_sd_probe_domain);
 EXPORT_SYMBOL(scsi_sd_probe_domain);
 
 /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 07ce3f5..eab472d 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -2,6 +2,7 @@
 #define _SCSI_PRIV_H
 
 #include <linux/device.h>
+#include <linux/async.h>
 
 struct request_queue;
 struct request;
@@ -163,7 +164,7 @@ static inline int scsi_autopm_get_host(struct Scsi_Host *h) { return 0; }
 static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 #endif /* CONFIG_PM_RUNTIME */
 
-extern struct list_head scsi_sd_probe_domain;
+extern struct async_domain scsi_sd_probe_domain;
 
 /* 
  * internal scsi timeout functions: for use by mid-layer and transport
diff --git a/include/linux/async.h b/include/linux/async.h
index 68a9530..dbb4d25 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -9,19 +9,31 @@
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
+};
+
+#define ASYNC_DOMAIN(name) \
+	struct async_domain name = { .node = LIST_HEAD_INIT(name.node), \
+				     .domain = LIST_HEAD_INIT(name.domain), \
+				     .count = 0 }
 
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
index bd0c168..aa23eec 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -62,7 +62,7 @@ static async_cookie_t next_cookie = 1;
 #define MAX_WORK	32768
 
 static LIST_HEAD(async_pending);
-static LIST_HEAD(async_running);
+static ASYNC_DOMAIN(async_running);
 static DEFINE_SPINLOCK(async_lock);
 
 struct async_entry {
@@ -71,7 +71,7 @@ struct async_entry {
 	async_cookie_t		cookie;
 	async_func_ptr		*func;
 	void			*data;
-	struct list_head	*running;
+	struct async_domain	*running;
 };
 
 static DECLARE_WAIT_QUEUE_HEAD(async_done);
@@ -82,13 +82,12 @@ static atomic_t entry_count;
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
 
@@ -99,7 +98,7 @@ static async_cookie_t  __lowest_in_progress(struct list_head *running)
 	return next_cookie;	/* "infinity" value */
 }
 
-static async_cookie_t  lowest_in_progress(struct list_head *running)
+static async_cookie_t  lowest_in_progress(struct async_domain *running)
 {
 	unsigned long flags;
 	async_cookie_t ret;
@@ -119,10 +118,11 @@ static void async_run_entry_fn(struct work_struct *work)
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
@@ -156,7 +156,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	wake_up(&async_done);
 }
 
-static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
+static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct async_domain *running)
 {
 	struct async_entry *entry;
 	unsigned long flags;
@@ -223,7 +223,7 @@ EXPORT_SYMBOL_GPL(async_schedule);
  * Note: This function may be called from atomic or non-atomic contexts.
  */
 async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
-				     struct list_head *running)
+				     struct async_domain *running)
 {
 	return __async_schedule(ptr, data, running);
 }
@@ -238,20 +238,20 @@ void async_synchronize_full(void)
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
  * synchronization domain specified by the running list @list have been done.
  */
-void async_synchronize_full_domain(struct list_head *list)
+void async_synchronize_full_domain(struct async_domain *domain)
 {
-	async_synchronize_cookie_domain(next_cookie, list);
+	async_synchronize_cookie_domain(next_cookie, domain);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 
@@ -264,8 +264,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
  * synchronization domain specified by the running list @list submitted
  * prior to @cookie have been done.
  */
-void async_synchronize_cookie_domain(async_cookie_t cookie,
-				     struct list_head *running)
+void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain *running)
 {
 	ktime_t uninitialized_var(starttime), delta, endtime;
 
