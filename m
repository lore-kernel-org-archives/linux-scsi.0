From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 3/8] PM: Add a switch for disabling/enabling asynchronous suspend/resume
Date: Sun, 24 Jan 2010 00:36:26 +0100
Message-ID: <201001240036.27069.rjw@sisk.pl>
References: <201001240033.34253.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <201001240033.34253.rjw@sisk.pl>
Sender: linux-acpi-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Linux PCI <linux-pci@vger.kernel.org>, pm list <linux-pm@lists.linux-foundation.org>, linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>, James Bottomley <James.Bottomley@suse.de>, Linux SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>, Nigel Cunningham <ncunningham@crca.org.au>
List-Id: linux-scsi@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add sysfs attribute /sys/power/pm_async allowing the user space to
disable/enable asynchronous suspend/resume of devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/ABI/testing/sysfs-power |   13 +++++++++++++
 drivers/base/power/main.c             |    7 ++++---
 drivers/base/power/power.h            |    6 +++---
 kernel/power/main.c                   |   31 ++++++++++++++++++++++++++++++-
 4 files changed, 50 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -44,6 +44,32 @@ int pm_notifier_call_chain(unsigned long
 			== NOTIFY_BAD) ? -EINVAL : 0;
 }
 
+/* If set, devices may be suspended and resumed asynchronously. */
+int pm_async_enabled = 1;
+
+static ssize_t pm_async_show(struct kobject *kobj, struct kobj_attribute *attr,
+			     char *buf)
+{
+	return sprintf(buf, "%d\n", pm_async_enabled);
+}
+
+static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
+			      const char *buf, size_t n)
+{
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+
+	if (val > 1)
+		return -EINVAL;
+
+	pm_async_enabled = val;
+	return n;
+}
+
+power_attr(pm_async);
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
@@ -208,9 +234,12 @@ static struct attribute * g[] = {
 #ifdef CONFIG_PM_TRACE
 	&pm_trace_attr.attr,
 #endif
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PM_DEBUG)
+#ifdef CONFIG_PM_SLEEP
+	&pm_async_attr.attr,
+#ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
 #endif
+#endif
 	NULL,
 };
 
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -12,10 +12,10 @@ static inline void pm_runtime_remove(str
 
 #ifdef CONFIG_PM_SLEEP
 
-/*
- * main.c
- */
+/* kernel/power/main.c */
+extern int pm_async_enabled;
 
+/* drivers/base/power/main.c */
 extern struct list_head dpm_list;	/* The active device list */
 
 static inline struct device *to_device(struct list_head *entry)
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -201,7 +201,7 @@ static void dpm_wait(struct device *dev,
 	if (!dev)
 		return;
 
-	if (async || dev->power.async_suspend)
+	if (async || (pm_async_enabled && dev->power.async_suspend))
 		wait_for_completion(&dev->power.completion);
 }
 
@@ -563,7 +563,8 @@ static int device_resume(struct device *
 {
 	INIT_COMPLETION(dev->power.completion);
 
-	if (dev->power.async_suspend && !pm_trace_is_enabled()) {
+	if (pm_async_enabled && dev->power.async_suspend
+	    && !pm_trace_is_enabled()) {
 		get_device(dev);
 		async_schedule(async_resume, dev);
 		return 0;
@@ -867,7 +868,7 @@ static int device_suspend(struct device 
 {
 	INIT_COMPLETION(dev->power.completion);
 
-	if (dev->power.async_suspend) {
+	if (pm_async_enabled && dev->power.async_suspend) {
 		get_device(dev);
 		async_schedule(async_suspend, dev);
 		return 0;
Index: linux-2.6/Documentation/ABI/testing/sysfs-power
===================================================================
--- linux-2.6.orig/Documentation/ABI/testing/sysfs-power
+++ linux-2.6/Documentation/ABI/testing/sysfs-power
@@ -101,3 +101,16 @@ Description:
 
 		CAUTION: Using it will cause your machine's real-time (CMOS)
 		clock to be set to a random invalid time after a resume.
+
+What:		/sys/power/pm_async
+Date:		January 2009
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/power/pm_async file controls the switch allowing the
+		user space to enable or disable asynchronous suspend and resume
+		of devices.  If enabled, this feature will cause some device
+		drivers' suspend and resume callbacks to be executed in parallel
+		with each other and with the main suspend thread.  It is enabled
+		if this file contains "1", which is the default.  It may be
+		disabled by writing "0" to this file, in which case all devices
+		will be suspended and resumed synchronously.

