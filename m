From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Mon, 13 Feb 2012 17:11:09 +0800
Message-ID: <1329124271-29464-5-git-send-email-ming.m.lin@intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

Introduce flag can_power_off in device structure to support runtime
power off/on.

Note that, for a specific device driver,
"support runtime power off/on" means that the driver .runtime_suspend
callback needs to
1) save all the context so that it can restore the device back to the previous
   working state after powered on.
2) set can_power_off flag to tell the driver model that it's ready for power off.

The following example shows how this works.

device A
 |---------|
 v         v
device B  device C

A is the parent of device B and device C, and device A/B/C shares the
same power logic
(Only device A knows how to turn on/off the power).

In order to power off A, B, C at runtime,
1) device B and device C should support runtime power off
   (runtime suspended with can_power_off flag set)
2) pm idle request for device A is fired by runtime PM core.
3) in device A .runtime_suspend callback, it tries to set can_power_off flag.
4) if succeed, it means all its children have been ready for power off
   and it can turn off the power at any time.
5) if failed, it means at least one of its children does not support runtime
   power off, thus the power can not be turned off.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 include/linux/pm.h         |    1 +
 include/linux/pm_runtime.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index e4982ac..4a09c76 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -474,6 +474,7 @@ struct dev_pm_info {
 	bool			is_prepared:1;	/* Owned by the PM core */
 	bool			is_suspended:1;	/* Ditto */
 	bool			ignore_children:1;
+	bool			can_power_off:1;
 	spinlock_t		lock;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 609daae..81f3f13 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -100,6 +100,33 @@ static inline void pm_runtime_mark_last_busy(struct device *dev)
 	ACCESS_ONCE(dev->power.last_busy) = jiffies;
 }
 
+static inline bool pm_runtime_can_power_off(struct device *dev)
+{
+	return !!dev->power.can_power_off;
+}
+
+static inline int check_fn(struct device *dev, void *data)
+{
+	return pm_runtime_can_power_off(dev) ? 0 : -1;
+}
+
+static inline bool pm_runtime_allow_power_off(struct device *dev)
+{
+	return device_for_each_child(dev, NULL, check_fn) ? false : true;
+}
+
+static inline void pm_runtime_enable_power_off(struct device *dev)
+{
+	if (!dev->power.is_prepared)
+		dev->power.can_power_off = pm_runtime_allow_power_off(dev);
+}
+
+static inline void pm_runtime_disable_power_off(struct device *dev)
+{
+	if (!dev->power.is_prepared)
+		dev->power.can_power_off = false;
+}
+
 #else /* !CONFIG_PM_RUNTIME */
 
 static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
@@ -149,6 +176,9 @@ static inline void pm_runtime_set_autosuspend_delay(struct device *dev,
 						int delay) {}
 static inline unsigned long pm_runtime_autosuspend_expiration(
 				struct device *dev) { return 0; }
+static inline bool pm_runtime_can_power_off(struct device *dev) { return false; }
+static inline void pm_runtime_enable_power_off(struct device *dev) {}
+static inline void pm_runtime_disable_power_off(struct device *dev) {}
 
 static inline void pm_runtime_update_max_time_suspended(struct device *dev,
 							s64 delta_ns) {}
-- 
1.7.2.5
