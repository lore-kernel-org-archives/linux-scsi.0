From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 5/8] PM: Start asynchronous resume threads upfront
Date: Sun, 24 Jan 2010 00:38:56 +0100
Message-ID: <201001240038.56372.rjw@sisk.pl>
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

It has been shown by testing that total device resume time can be
reduced significantly (by as much as 50% or more) if the async
threads executing some devices' resume routines are all started
before the main resume thread starts to handle the "synchronous"
devices.

This is a consequence of the fact that the slowest devices tend to be
located at the end of dpm_list, so their resume routines are started
very late.  Consequently, they have to wait for all the preceding
"synchronous" devices before their resume routines can be started
by the main resume thread, even if they are "asynchronous".  By
starting their async threads upfront we effectively move those
devices towards the beginning of dpm_list, without breaking their
ordering with respect to their parents and children.  As a result,
their resume routines are started much earlier and we are able to
save much more device resume time this way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -495,12 +495,12 @@ static int legacy_resume(struct device *
 }
 
 /**
- * __device_resume - Execute "resume" callbacks for given device.
+ * device_resume - Execute "resume" callbacks for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
  * @async: If true, the device is being resumed asynchronously.
  */
-static int __device_resume(struct device *dev, pm_message_t state, bool async)
+static int device_resume(struct device *dev, pm_message_t state, bool async)
 {
 	int error = 0;
 
@@ -510,6 +510,8 @@ static int __device_resume(struct device
 	dpm_wait(dev->parent, async);
 	down(&dev->sem);
 
+	dev->power.status = DPM_RESUMING;
+
 	if (dev->bus) {
 		if (dev->bus->pm) {
 			pm_dev_dbg(dev, state, "");
@@ -553,24 +555,16 @@ static void async_resume(void *data, asy
 	struct device *dev = (struct device *)data;
 	int error;
 
-	error = __device_resume(dev, pm_transition, true);
+	error = device_resume(dev, pm_transition, true);
 	if (error)
 		pm_dev_err(dev, pm_transition, " async", error);
 	put_device(dev);
 }
 
-static int device_resume(struct device *dev)
+static bool is_async(struct device *dev)
 {
-	INIT_COMPLETION(dev->power.completion);
-
-	if (pm_async_enabled && dev->power.async_suspend
-	    && !pm_trace_is_enabled()) {
-		get_device(dev);
-		async_schedule(async_resume, dev);
-		return 0;
-	}
-
-	return __device_resume(dev, pm_transition, false);
+	return dev->power.async_suspend && pm_async_enabled
+		&& !pm_trace_is_enabled();
 }
 
 /**
@@ -583,22 +577,33 @@ static int device_resume(struct device *
 static void dpm_resume(pm_message_t state)
 {
 	struct list_head list;
+	struct device *dev;
 	ktime_t starttime = ktime_get();
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
-	while (!list_empty(&dpm_list)) {
-		struct device *dev = to_device(dpm_list.next);
 
+	list_for_each_entry(dev, &dpm_list, power.entry) {
+		if (dev->power.status < DPM_OFF)
+			continue;
+
+		INIT_COMPLETION(dev->power.completion);
+		if (is_async(dev)) {
+			get_device(dev);
+			async_schedule(async_resume, dev);
+		}
+	}
+
+	while (!list_empty(&dpm_list)) {
+		dev = to_device(dpm_list.next);
 		get_device(dev);
-		if (dev->power.status >= DPM_OFF) {
+		if (dev->power.status >= DPM_OFF && !is_async(dev)) {
 			int error;
 
-			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev);
+			error = device_resume(dev, state, false);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)

