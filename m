From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/2] PM / sleep: Make lock/unlock_system_sleep() available to kernel modules
Date: Fri,  5 Jan 2018 09:19:08 -0800
Message-ID: <20180105171909.11839-2-bart.vanassche@wdc.com>
References: <20180105171909.11839-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:61665 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbeAERTL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 12:19:11 -0500
In-Reply-To: <20180105171909.11839-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Woody Suwalski <terraluna977@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Bart Van Assche <bart.vanassche@wdc.com>

Since pm_mutex is not exported using lock/unlock_system_sleep() from
inside a kernel module causes a "pm_mutex undefined" linker error.
Hence move lock/unlock_system_sleep() into kernel/power/main.c and
export these.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
---
 include/linux/suspend.h | 28 ++--------------------------
 kernel/power/main.c     | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index d60b0f5c38d5..cc22a24516d6 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -443,32 +443,8 @@ extern bool pm_save_wakeup_count(unsigned int count);
 extern void pm_wakep_autosleep_enabled(bool set);
 extern void pm_print_active_wakeup_sources(void);
 
-static inline void lock_system_sleep(void)
-{
-	current->flags |= PF_FREEZER_SKIP;
-	mutex_lock(&pm_mutex);
-}
-
-static inline void unlock_system_sleep(void)
-{
-	/*
-	 * Don't use freezer_count() because we don't want the call to
-	 * try_to_freeze() here.
-	 *
-	 * Reason:
-	 * Fundamentally, we just don't need it, because freezing condition
-	 * doesn't come into effect until we release the pm_mutex lock,
-	 * since the freezer always works with pm_mutex held.
-	 *
-	 * More importantly, in the case of hibernation,
-	 * unlock_system_sleep() gets called in snapshot_read() and
-	 * snapshot_write() when the freezing condition is still in effect.
-	 * Which means, if we use try_to_freeze() here, it would make them
-	 * enter the refrigerator, thus causing hibernation to lockup.
-	 */
-	current->flags &= ~PF_FREEZER_SKIP;
-	mutex_unlock(&pm_mutex);
-}
+extern void lock_system_sleep(void);
+extern void unlock_system_sleep(void);
 
 #else /* !CONFIG_PM_SLEEP */
 
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 3a2ca9066583..705c2366dafe 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -22,6 +22,35 @@ DEFINE_MUTEX(pm_mutex);
 
 #ifdef CONFIG_PM_SLEEP
 
+void lock_system_sleep(void)
+{
+	current->flags |= PF_FREEZER_SKIP;
+	mutex_lock(&pm_mutex);
+}
+EXPORT_SYMBOL_GPL(lock_system_sleep);
+
+void unlock_system_sleep(void)
+{
+	/*
+	 * Don't use freezer_count() because we don't want the call to
+	 * try_to_freeze() here.
+	 *
+	 * Reason:
+	 * Fundamentally, we just don't need it, because freezing condition
+	 * doesn't come into effect until we release the pm_mutex lock,
+	 * since the freezer always works with pm_mutex held.
+	 *
+	 * More importantly, in the case of hibernation,
+	 * unlock_system_sleep() gets called in snapshot_read() and
+	 * snapshot_write() when the freezing condition is still in effect.
+	 * Which means, if we use try_to_freeze() here, it would make them
+	 * enter the refrigerator, thus causing hibernation to lockup.
+	 */
+	current->flags &= ~PF_FREEZER_SKIP;
+	mutex_unlock(&pm_mutex);
+}
+EXPORT_SYMBOL_GPL(unlock_system_sleep);
+
 /* Routines for PM-transition notifications */
 
 static BLOCKING_NOTIFIER_HEAD(pm_chain_head);
-- 
2.15.1
