From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/6] fastboot: Asynchronous function calls to speed up
	kernel boot
Date: Wed, 14 Jan 2009 13:32:43 +0800
Message-ID: <1231911163.20746.126.camel@rzhang-dt>
References: <20090105200959.04a626ac@infradead.org>
	 <20090105201041.3289d3dd@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xyn4g45CHn0zagyI9pxI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21603 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758853AbZANFbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2009 00:31:33 -0500
In-Reply-To: <20090105201041.3289d3dd@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "mingo@elte.hu" <mingo@elte.hu>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>


--=-xyn4g45CHn0zagyI9pxI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

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

> +
> +void async_synchronize_cookie(async_cookie_t cookie)
> +{
> +       ktime_t starttime, delta, endtime;
> +
> +       if (initcall_debug) {
> +               printk("async_waiting @ %i\n", task_pid_nr(current));
> +               starttime = ktime_get();
> +       }
> +
> +       wait_event(async_done, lowest_in_progress >= cookie);
> +

In some cases, we only want to wait for a specific cookie
rather than all the cookies smaller than it.

For example:
device          cookie
ACPI battery    1
ata port 0      2
ata port 1      3
ata port 0 and port 1 in the same host can not be probed in parallel.

In this case, ata port1 should only wait for cookie 2 rather than both 1 and 2.

how about the patch below? (it's just a prototype and I have not tested it yet)
If it's okay, I'll do some tricks in the libata-core so that port1 can get the cookie of port 0.

Introduces two new interfaces
async_synchronize_one_cookie
async_synchronize_one_cookie_special
users can use these to wait for a specific cookie.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/ata/libata-core.c |    4 +-
 include/linux/async.h     |    6 ++-
 kernel/async.c            |   82 +++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 80 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/async.c
===================================================================
--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -87,6 +87,44 @@ extern int initcall_debug;
 /*
  * MUST be called with the lock held!
  */
+static int __cookie_is_done(struct list_head *running, async_cookie_t cookie)
+{
+	struct async_entry *entry;
+
+        if (!list_empty(running)) {
+		list_for_each_entry(entry, running, list) {
+			if (entry->cookie > cookie)
+				break;
+			if (entry->cookie == cookie)
+				return 0;
+		}
+	}
+
+	if (!list_empty(&async_pending)) {
+		list_for_each_entry(entry, &async_pending, list) {
+			if (entry->cookie > cookie)
+				break;
+			if (entry->cookie == cookie)
+				return 0;
+		}
+	}
+	return 1;
+}
+
+static int cookie_is_done(struct list_head *running, async_cookie_t cookie)
+{
+	unsigned long flags;
+	async_cookie_t ret;
+
+	spin_lock_irqsave(&async_lock, flags);
+	ret = __cookie_is_done(running, cookie);
+	spin_unlock_irqrestore(&async_lock, flags);
+	return ret;
+}
+
+/*
+ * MUST be called with the lock held!
+ */
 static async_cookie_t  __lowest_in_progress(struct list_head *running)
 {
 	struct async_entry *entry;
@@ -220,18 +258,19 @@ EXPORT_SYMBOL_GPL(async_schedule_special
 void async_synchronize_full(void)
 {
 	do {
-		async_synchronize_cookie(next_cookie);
+		async_synchronize_cookies(next_cookie);
 	} while (!list_empty(&async_running) || !list_empty(&async_pending));
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
 void async_synchronize_full_special(struct list_head *list)
 {
-	async_synchronize_cookie_special(next_cookie, list);
+	async_synchronize_cookies_special(next_cookie, list);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_special);
 
-void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *running)
+static void __async_synchronize_cookie_special(async_cookie_t cookie,
+						struct list_head *running, int type)
 {
 	ktime_t starttime, delta, endtime;
 
@@ -240,7 +279,10 @@ void async_synchronize_cookie_special(as
 		starttime = ktime_get();
 	}
 
-	wait_event(async_done, lowest_in_progress(running) >= cookie);
+	if (type)
+		wait_event(async_done, lowest_in_progress(running) >= cookie);
+	else
+		wait_event(async_done, cookie_is_done(running, cookie));
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		endtime = ktime_get();
@@ -250,13 +292,37 @@ void async_synchronize_cookie_special(as
 			task_pid_nr(current), ktime_to_ns(delta) >> 10);
 	}
 }
-EXPORT_SYMBOL_GPL(async_synchronize_cookie_special);
 
-void async_synchronize_cookie(async_cookie_t cookie)
+void async_synchronize_cookies_special(async_cookie_t cookie, struct list_head *running)
+{
+	__async_synchronize_cookie_special(cookie, running, 1);
+}
+EXPORT_SYMBOL_GPL(async_synchronize_cookies_special);
+
+void async_synchronize_cookies(async_cookie_t cookie)
+{
+	__async_synchronize_cookie_special(cookie, &async_running, 1);
+}
+EXPORT_SYMBOL_GPL(async_synchronize_cookies);
+
+
+/*
+ * sychronize a specific cookie
+ * block until the entry with a speicific cookie is done.
+ * Note that waiting for a cookie while holding it is not allowed.
+ * because it may cause a deadlock issue.
+ */
+void async_synchronize_one_cookie_special(async_cookie_t cookie, struct list_head *running)
+{
+	__async_synchronize_cookie_special(cookie, running, 0);
+}
+EXPORT_SYMBOL_GPL(async_synchronize_one_cookie_special);
+
+void async_synchronize_one_cookie(async_cookie_t cookie)
 {
-	async_synchronize_cookie_special(cookie, &async_running);
+	__async_synchronize_cookie_special(cookie, &async_running, 0);
 }
-EXPORT_SYMBOL_GPL(async_synchronize_cookie);
+EXPORT_SYMBOL_GPL(async_synchronize_one_cookie);
 
 
 static int async_thread(void *unused)
Index: linux-2.6/include/linux/async.h
===================================================================
--- linux-2.6.orig/include/linux/async.h
+++ linux-2.6/include/linux/async.h
@@ -20,6 +20,8 @@ extern async_cookie_t async_schedule(asy
 extern async_cookie_t async_schedule_special(async_func_ptr *ptr, void *data, struct list_head *list);
 extern void async_synchronize_full(void);
 extern void async_synchronize_full_special(struct list_head *list);
-extern void async_synchronize_cookie(async_cookie_t cookie);
-extern void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *list);
+extern void async_synchronize_cookies(async_cookie_t cookie);
+extern void async_synchronize_cookies_special(async_cookie_t cookie, struct list_head *list);
+extern void async_synchronize_one_cookie(async_cookie_t cookie);
+extern void async_synchronize_one_cookie_special(async_cookie_t cookie, struct list_head *list);
 
Index: linux-2.6/drivers/ata/libata-core.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-core.c
+++ linux-2.6/drivers/ata/libata-core.c
@@ -5929,7 +5929,7 @@ static void async_port_probe(void *data,
 	 * don't need to wait for port 0, only for later ports.
 	 */
 	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
-		async_synchronize_cookie(cookie);
+		async_synchronize_cookies(cookie);
 
 	/* probe */
 	if (ap->ops->error_handler) {
@@ -5969,7 +5969,7 @@ static void async_port_probe(void *data,
 	}
 
 	/* in order to keep device order, we need to synchronize at this point */
-	async_synchronize_cookie(cookie);
+	async_synchronize_cookies(cookie);
 
 	ata_scsi_scan_host(ap, 1);
 




--=-xyn4g45CHn0zagyI9pxI
Content-Disposition: attachment; filename=patch-async-introduce-new-interface
Content-Type: text/plain; name=patch-async-introduce-new-interface; charset=utf-8
Content-Transfer-Encoding: 7bit


In some cases, we only want to wait for a specific cookie
rather than all the cookies smaller than it.
Introduces two new interfaces
async_synchronize_one_cookie
async_synchronize_one_cookie_special
users can use these to wait for a specific cookie.

For example:
device          cookie
ACPI battery    1
ata port 0      2
ata port 1      3
ata port 0 and port 1 in the same host can not be porbed in parallel.

In this case, ata port1 should only wait for cookie 2 rather than both 1 and 2.
And using the new interface would be a better choice.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/ata/libata-core.c |    4 +-
 include/linux/async.h     |    6 ++-
 kernel/async.c            |   82 +++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 80 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/async.c
===================================================================
--- linux-2.6.orig/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -87,6 +87,44 @@ extern int initcall_debug;
 /*
  * MUST be called with the lock held!
  */
+static int __cookie_is_done(struct list_head *running, async_cookie_t cookie)
+{
+	struct async_entry *entry;
+
+        if (!list_empty(running)) {
+		list_for_each_entry(entry, running, list) {
+			if (entry->cookie > cookie)
+				break;
+			if (entry->cookie == cookie)
+				return 0;
+		}
+	}
+
+	if (!list_empty(&async_pending)) {
+		list_for_each_entry(entry, &async_pending, list) {
+			if (entry->cookie > cookie)
+				break;
+			if (entry->cookie == cookie)
+				return 0;
+		}
+	}
+	return 1;
+}
+
+static int cookie_is_done(struct list_head *running, async_cookie_t cookie)
+{
+	unsigned long flags;
+	async_cookie_t ret;
+
+	spin_lock_irqsave(&async_lock, flags);
+	ret = __cookie_is_done(running, cookie);
+	spin_unlock_irqrestore(&async_lock, flags);
+	return ret;
+}
+
+/*
+ * MUST be called with the lock held!
+ */
 static async_cookie_t  __lowest_in_progress(struct list_head *running)
 {
 	struct async_entry *entry;
@@ -220,18 +258,19 @@ EXPORT_SYMBOL_GPL(async_schedule_special
 void async_synchronize_full(void)
 {
 	do {
-		async_synchronize_cookie(next_cookie);
+		async_synchronize_cookies(next_cookie);
 	} while (!list_empty(&async_running) || !list_empty(&async_pending));
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
 void async_synchronize_full_special(struct list_head *list)
 {
-	async_synchronize_cookie_special(next_cookie, list);
+	async_synchronize_cookies_special(next_cookie, list);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_special);
 
-void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *running)
+static void __async_synchronize_cookie_special(async_cookie_t cookie,
+						struct list_head *running, int type)
 {
 	ktime_t starttime, delta, endtime;
 
@@ -240,7 +279,10 @@ void async_synchronize_cookie_special(as
 		starttime = ktime_get();
 	}
 
-	wait_event(async_done, lowest_in_progress(running) >= cookie);
+	if (type)
+		wait_event(async_done, lowest_in_progress(running) >= cookie);
+	else
+		wait_event(async_done, cookie_is_done(running, cookie));
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		endtime = ktime_get();
@@ -250,13 +292,37 @@ void async_synchronize_cookie_special(as
 			task_pid_nr(current), ktime_to_ns(delta) >> 10);
 	}
 }
-EXPORT_SYMBOL_GPL(async_synchronize_cookie_special);
 
-void async_synchronize_cookie(async_cookie_t cookie)
+void async_synchronize_cookies_special(async_cookie_t cookie, struct list_head *running)
+{
+	__async_synchronize_cookie_special(cookie, running, 1);
+}
+EXPORT_SYMBOL_GPL(async_synchronize_cookies_special);
+
+void async_synchronize_cookies(async_cookie_t cookie)
+{
+	__async_synchronize_cookie_special(cookie, &async_running, 1);
+}
+EXPORT_SYMBOL_GPL(async_synchronize_cookies);
+
+
+/*
+ * sychronize a specific cookie
+ * block until the entry with a speicific cookie is done.
+ * Note that waiting for a cookie while holding it is not allowed.
+ * because it may cause a deadlock issue.
+ */
+void async_synchronize_one_cookie_special(async_cookie_t cookie, struct list_head *running)
+{
+	__async_synchronize_cookie_special(cookie, running, 0);
+}
+EXPORT_SYMBOL_GPL(async_synchronize_one_cookie_special);
+
+void async_synchronize_one_cookie(async_cookie_t cookie)
 {
-	async_synchronize_cookie_special(cookie, &async_running);
+	__async_synchronize_cookie_special(cookie, &async_running, 0);
 }
-EXPORT_SYMBOL_GPL(async_synchronize_cookie);
+EXPORT_SYMBOL_GPL(async_synchronize_one_cookie);
 
 
 static int async_thread(void *unused)
Index: linux-2.6/include/linux/async.h
===================================================================
--- linux-2.6.orig/include/linux/async.h
+++ linux-2.6/include/linux/async.h
@@ -20,6 +20,8 @@ extern async_cookie_t async_schedule(asy
 extern async_cookie_t async_schedule_special(async_func_ptr *ptr, void *data, struct list_head *list);
 extern void async_synchronize_full(void);
 extern void async_synchronize_full_special(struct list_head *list);
-extern void async_synchronize_cookie(async_cookie_t cookie);
-extern void async_synchronize_cookie_special(async_cookie_t cookie, struct list_head *list);
+extern void async_synchronize_cookies(async_cookie_t cookie);
+extern void async_synchronize_cookies_special(async_cookie_t cookie, struct list_head *list);
+extern void async_synchronize_one_cookie(async_cookie_t cookie);
+extern void async_synchronize_one_cookie_special(async_cookie_t cookie, struct list_head *list);
 
Index: linux-2.6/drivers/ata/libata-core.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-core.c
+++ linux-2.6/drivers/ata/libata-core.c
@@ -5929,7 +5929,7 @@ static void async_port_probe(void *data,
 	 * don't need to wait for port 0, only for later ports.
 	 */
 	if (!(ap->host->flags & ATA_HOST_PARALLEL_SCAN) && ap->port_no != 0)
-		async_synchronize_cookie(cookie);
+		async_synchronize_cookies(cookie);
 
 	/* probe */
 	if (ap->ops->error_handler) {
@@ -5969,7 +5969,7 @@ static void async_port_probe(void *data,
 	}
 
 	/* in order to keep device order, we need to synchronize at this point */
-	async_synchronize_cookie(cookie);
+	async_synchronize_cookies(cookie);
 
 	ata_scsi_scan_host(ap, 1);
 

--=-xyn4g45CHn0zagyI9pxI--

