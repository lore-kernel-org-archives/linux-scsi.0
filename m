From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 2/8] PM: Asynchronous suspend and resume of devices
Date: Sun, 24 Jan 2010 00:35:37 +0100
Message-ID: <201001240035.37550.rjw@sisk.pl>
References: <201001240033.34253.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753537Ab0AWXmi@vger.kernel.org>
In-Reply-To: <201001240033.34253.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Linux PCI <linux-pci@vger.kernel.org>, pm list <linux-pm@lists.linux-foundation.org>, linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>, James Bottomley <James.Bottomley@suse.de>, Linux SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>, Nigel Cunningham <ncunningham@crca.org.au>
List-Id: linux-scsi@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Theoretically, the total time of system sleep transitions (suspend
to RAM, hibernation) can be reduced by running suspend and resume
callbacks of device drivers in parallel with each other.  However,
there are dependencies between devices such that we're not allowed
to suspend the parent of a device before suspending the device
itself.  Analogously, we're not allowed to resume a device before
resuming its parent.

The most straightforward way to take these dependencies into accout
is to start the async threads used for suspending and resuming
devices at the core level, so that async_schedule() is called for
each suspend and resume callback supposed to be executed
asynchronously.

For this purpose, introduce a new device flag, power.async_suspend,
used to mark the devices whose suspend and resume callbacks are to be
executed asynchronously (ie. in parallel with the main suspend/resume
thread and possibly in parallel with each other) and helper function
device_enable_async_suspend() allowing one to set power.async_suspend
for given device (power.async_suspend is unset by default for all
devices).  For each device with the power.async_suspend flag set the
PM core will use async_schedule() to execute its suspend and resume
callbacks.

The async threads started for different devices as a result of
calling async_schedule() are synchronized with each other and with
the main suspend/resume thread with the help of completions, in the
following way:
(1) There is a completion, power.completion, for each device object.
(2) Each device's completion is reset before calling async_schedule()
    for the device or, in the case of devices with the
    power.async_suspend flags unset, before executing the device's
    suspend and resume callbacks.
(3) During suspend, right before running the bus type, device type
    and device class suspend callbacks for the device, the PM core
    waits for the completions of all the device's children to be
    completed.
(4) During resume, right before running the bus type, device type and
    device class resume callbacks for the device, the PM core waits
    for the completion of the device's parent to be completed.
(5) The PM core completes power.completion for each device right
    after the bus type, device type and device class suspend (or
    resume) callbacks executed for the device have returned.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c    |  115 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h       |    6 ++
 include/linux/pm.h           |    3 +
 include/linux/resume-trace.h |    7 ++
 4 files changed, 125 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -26,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <linux/timer.h>
+#include <linux/completion.h>
 
 /*
  * Callbacks for platform drivers to implement.
@@ -412,9 +413,11 @@ struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
 	unsigned int		should_wakeup:1;
+	unsigned		async_suspend:1;
 	enum dpm_state		status;		/* Owned by the PM core */
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
+	struct completion	completion;
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	struct timer_list	suspend_timer;
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -25,6 +25,7 @@
 #include <linux/resume-trace.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/async.h>
 
 #include "../base.h"
 #include "power.h"
@@ -42,6 +43,7 @@
 LIST_HEAD(dpm_list);
 
 static DEFINE_MUTEX(dpm_list_mtx);
+static pm_message_t pm_transition;
 
 /*
  * Set once the preparation of devices for a PM transition has started, reset
@@ -56,6 +58,7 @@ static bool transition_started;
 void device_pm_init(struct device *dev)
 {
 	dev->power.status = DPM_ON;
+	init_completion(&dev->power.completion);
 	pm_runtime_init(dev);
 }
 
@@ -111,6 +114,7 @@ void device_pm_remove(struct device *dev
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
+	complete_all(&dev->power.completion);
 	mutex_lock(&dpm_list_mtx);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
@@ -188,6 +192,31 @@ static void initcall_debug_report(struct
 }
 
 /**
+ * dpm_wait - Wait for a PM operation to complete.
+ * @dev: Device to wait for.
+ * @async: If unset, wait only if the device's power.async_suspend flag is set.
+ */
+static void dpm_wait(struct device *dev, bool async)
+{
+	if (!dev)
+		return;
+
+	if (async || dev->power.async_suspend)
+		wait_for_completion(&dev->power.completion);
+}
+
+static int dpm_wait_fn(struct device *dev, void *async_ptr)
+{
+	dpm_wait(dev, *((bool *)async_ptr));
+	return 0;
+}
+
+static void dpm_wait_for_children(struct device *dev, bool async)
+{
+       device_for_each_child(dev, &async, dpm_wait_fn);
+}
+
+/**
  * pm_op - Execute the PM operation appropriate for given PM event.
  * @dev: Device to handle.
  * @ops: PM operations to choose from.
@@ -466,17 +495,19 @@ static int legacy_resume(struct device *
 }
 
 /**
- * device_resume - Execute "resume" callbacks for given device.
+ * __device_resume - Execute "resume" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
+ * @async: If true, the device is being resumed asynchronously.
  */
-static int device_resume(struct device *dev, pm_message_t state)
+static int __device_resume(struct device *dev, pm_message_t state, bool async)
 {
 	int error = 0;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
+	dpm_wait(dev->parent, async);
 	down(&dev->sem);
 
 	if (dev->bus) {
@@ -511,11 +542,36 @@ static int device_resume(struct device *
 	}
  End:
 	up(&dev->sem);
+	complete_all(&dev->power.completion);
 
 	TRACE_RESUME(error);
 	return error;
 }
 
+static void async_resume(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_resume(dev, pm_transition, true);
+	if (error)
+		pm_dev_err(dev, pm_transition, " async", error);
+	put_device(dev);
+}
+
+static int device_resume(struct device *dev)
+{
+	INIT_COMPLETION(dev->power.completion);
+
+	if (dev->power.async_suspend && !pm_trace_is_enabled()) {
+		get_device(dev);
+		async_schedule(async_resume, dev);
+		return 0;
+	}
+
+	return __device_resume(dev, pm_transition, false);
+}
+
 /**
  * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -530,6 +586,7 @@ static void dpm_resume(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 
@@ -540,7 +597,7 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = device_resume(dev);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -555,6 +612,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 	dpm_show_time(starttime, state, NULL);
 }
 
@@ -732,17 +790,24 @@ static int legacy_suspend(struct device 
 	return error;
 }
 
+static int async_error;
+
 /**
  * device_suspend - Execute "suspend" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
+ * @async: If true, the device is being suspended asynchronously.
  */
-static int device_suspend(struct device *dev, pm_message_t state)
+static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 {
 	int error = 0;
 
+	dpm_wait_for_children(dev, async);
 	down(&dev->sem);
 
+	if (async_error)
+		goto End;
+
 	if (dev->class) {
 		if (dev->class->pm) {
 			pm_dev_dbg(dev, state, "class ");
@@ -773,12 +838,44 @@ static int device_suspend(struct device 
 			error = legacy_suspend(dev, state, dev->bus->suspend);
 		}
 	}
+
+	if (!error)
+		dev->power.status = DPM_OFF;
+
  End:
 	up(&dev->sem);
+	complete_all(&dev->power.completion);
 
 	return error;
 }
 
+static void async_suspend(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = __device_suspend(dev, pm_transition, true);
+	if (error) {
+		pm_dev_err(dev, pm_transition, " async", error);
+		async_error = error;
+	}
+
+	put_device(dev);
+}
+
+static int device_suspend(struct device *dev)
+{
+	INIT_COMPLETION(dev->power.completion);
+
+	if (dev->power.async_suspend) {
+		get_device(dev);
+		async_schedule(async_suspend, dev);
+		return 0;
+	}
+
+	return __device_suspend(dev, pm_transition, false);
+}
+
 /**
  * dpm_suspend - Execute "suspend" callbacks for all non-sysdev devices.
  * @state: PM transition of the system being carried out.
@@ -791,13 +888,15 @@ static int dpm_suspend(pm_message_t stat
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	pm_transition = state;
+	async_error = 0;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.prev);
 
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_suspend(dev, state);
+		error = device_suspend(dev);
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
@@ -805,13 +904,17 @@ static int dpm_suspend(pm_message_t stat
 			put_device(dev);
 			break;
 		}
-		dev->power.status = DPM_OFF;
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &list);
 		put_device(dev);
+		if (async_error)
+			break;
 	}
 	list_splice(&list, dpm_list.prev);
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
+	if (!error)
+		error = async_error;
 	if (!error)
 		dpm_show_time(starttime, state, NULL);
 	return error;
Index: linux-2.6/include/linux/resume-trace.h
===================================================================
--- linux-2.6.orig/include/linux/resume-trace.h
+++ linux-2.6/include/linux/resume-trace.h
@@ -6,6 +6,11 @@
 
 extern int pm_trace_enabled;
 
+static inline int pm_trace_is_enabled(void)
+{
+       return pm_trace_enabled;
+}
+
 struct device;
 extern void set_trace_device(struct device *);
 extern void generate_resume_trace(const void *tracedata, unsigned int user);
@@ -17,6 +22,8 @@ extern void generate_resume_trace(const 
 
 #else
 
+static inline int pm_trace_is_enabled(void) { return 0; }
+
 #define TRACE_DEVICE(dev) do { } while (0)
 #define TRACE_RESUME(dev) do { } while (0)
 
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -472,6 +472,12 @@ static inline int device_is_registered(s
 	return dev->kobj.state_in_sysfs;
 }
 
+static inline void device_enable_async_suspend(struct device *dev)
+{
+	if (dev->power.status == DPM_ON)
+		dev->power.async_suspend = true;
+}
+
 void driver_init(void);
 
 /*
