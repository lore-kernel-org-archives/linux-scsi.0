From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 4/8] PM: Add facility for advanced testing of async suspend/resume
Date: Sun, 24 Jan 2010 00:38:07 +0100
Message-ID: <201001240038.07571.rjw@sisk.pl>
References: <201001240033.34253.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753764Ab0AWXms@vger.kernel.org>
In-Reply-To: <201001240033.34253.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Linux PCI <linux-pci@vger.kernel.org>, pm list <linux-pm@lists.linux-foundation.org>, linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>, James Bottomley <James.Bottomley@suse.de>, Linux SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>, Nigel Cunningham <ncunningham@crca.org.au>
List-Id: linux-scsi@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add configuration switch CONFIG_PM_ADVANCED_DEBUG for compiling in
extra PM debugging/testing code allowing one to access some
PM-related attributes of devices from the user space via sysfs.

If CONFIG_PM_ADVANCED_DEBUG is set, add sysfs attribute power/async
for every device allowing the user space to access the device's
power.async_suspend flag and modify it, if desired.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/ABI/testing/sysfs-devices-power |   26 +++++++++++++
 drivers/base/power/sysfs.c                    |   49 ++++++++++++++++++++++++++
 include/linux/device.h                        |   11 +++++
 kernel/power/Kconfig                          |   14 +++++++
 4 files changed, 100 insertions(+)

Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -54,6 +54,24 @@
  *	wakeup events internally (unless they are disabled), keeping
  *	their hardware in low power modes whenever they're unused.  This
  *	saves runtime power, without requiring system-wide sleep states.
+ *
+ *	async - Report/change current async suspend setting for the device
+ *
+ *	Asynchronous suspend and resume of the device during system-wide power
+ *	state transitions can be enabled by writing "enabled" to this file.
+ *	Analogously, if "disabled" is written to this file, the device will be
+ *	suspended and resumed synchronously.
+ *
+ *	All devices have one of the following two values for power/async:
+ *
+ *	 + "enabled\n" to permit the asynchronous suspend/resume of the device;
+ *	 + "disabled\n" to forbid it;
+ *
+ *	NOTE: It generally is unsafe to permit the asynchronous suspend/resume
+ *	of a device unless it is certain that all of the PM dependencies of the
+ *	device are known to the PM core.  However, for some devices this
+ *	attribute is set to "enabled" by bus type code or device drivers and in
+ *	that cases it should be safe to leave the default value.
  */
 
 static const char enabled[] = "enabled";
@@ -125,12 +143,43 @@ wake_store(struct device * dev, struct d
 
 static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
 
+#ifdef CONFIG_PM_SLEEP_ADVANCED_DEBUG
+static ssize_t async_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	return sprintf(buf, "%s\n",
+			device_async_suspend_enabled(dev) ? enabled : disabled);
+}
+
+static ssize_t async_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t n)
+{
+	char *cp;
+	int len = n;
+
+	cp = memchr(buf, '\n', n);
+	if (cp)
+		len = cp - buf;
+	if (len == sizeof enabled - 1 && strncmp(buf, enabled, len) == 0)
+		device_enable_async_suspend(dev);
+	else if (len == sizeof disabled - 1 && strncmp(buf, disabled, len) == 0)
+		device_disable_async_suspend(dev);
+	else
+		return -EINVAL;
+	return n;
+}
+
+static DEVICE_ATTR(async, 0644, async_show, async_store);
+#endif /* CONFIG_PM_SLEEP_ADVANCED_DEBUG */
 
 static struct attribute * power_attrs[] = {
 #ifdef CONFIG_PM_RUNTIME
 	&dev_attr_control.attr,
 #endif
 	&dev_attr_wakeup.attr,
+#ifdef CONFIG_PM_SLEEP_ADVANCED_DEBUG
+	&dev_attr_async.attr,
+#endif
 	NULL,
 };
 static struct attribute_group pm_attr_group = {
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -478,6 +478,17 @@ static inline void device_enable_async_s
 		dev->power.async_suspend = true;
 }
 
+static inline void device_disable_async_suspend(struct device *dev)
+{
+	if (dev->power.status == DPM_ON)
+		dev->power.async_suspend = false;
+}
+
+static inline bool device_async_suspend_enabled(struct device *dev)
+{
+	return !!dev->power.async_suspend;
+}
+
 void driver_init(void);
 
 /*
Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -27,6 +27,15 @@ config PM_DEBUG
 	code. This is helpful when debugging and reporting PM bugs, like
 	suspend support.
 
+config PM_ADVANCED_DEBUG
+	bool "Extra PM attributes in sysfs for low-level debugging/testing"
+	depends on PM_DEBUG
+	default n
+	---help---
+	Add extra sysfs attributes allowing one to access some Power Management
+	fields of device objects from user space.  If you are not a kernel
+	developer interested in debugging/testing Power Management, say "no".
+
 config PM_VERBOSE
 	bool "Verbose Power Management debugging"
 	depends on PM_DEBUG
@@ -85,6 +94,11 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
 	default y
 
+config PM_SLEEP_ADVANCED_DEBUG
+	bool
+	depends on PM_ADVANCED_DEBUG
+	default n
+
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM && ARCH_SUSPEND_POSSIBLE
Index: linux-2.6/Documentation/ABI/testing/sysfs-devices-power
===================================================================
--- linux-2.6.orig/Documentation/ABI/testing/sysfs-devices-power
+++ linux-2.6/Documentation/ABI/testing/sysfs-devices-power
@@ -51,3 +51,29 @@ Description:
 		drivers.  Changing this attribute to "on" prevents the driver
 		from power managing the device at run time.  Doing that while
 		the device is suspended causes it to be woken up.
+
+What:		/sys/devices/.../power/async
+Date:		January 2009
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../async attribute allows the user space to
+		enable or diasble the device's suspend and resume callbacks to
+		be executed asynchronously (ie. in separate threads, in parallel
+		with the main suspend/resume thread) during system-wide power
+		transitions (eg. suspend to RAM, hibernation).
+
+		All devices have one of the following two values for the
+		power/async file:
+
+		+ "enabled\n" to permit the asynchronous suspend/resume;
+		+ "disabled\n" to forbid it;
+
+		The value of this attribute may be changed by writing either
+		"enabled", or "disabled" to it.
+
+		It generally is unsafe to permit the asynchronous suspend/resume
+		of a device unless it is certain that all of the PM dependencies
+		of the device are known to the PM core.  However, for some
+		devices this attribute is set to "enabled" by bus type code or
+		device drivers and in that cases it should be safe to leave the
+		default value.
