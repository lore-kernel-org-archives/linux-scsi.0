From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 15:49:28 +0800
Message-ID: <52CBB188.2080707@intel.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52CAC067.20601@ubuntu.com>
Sender: linux-pm-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On 01/06/2014 10:40 PM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/6/2014 4:15 AM, Aaron Lu wrote:
>> My guess why it doesn't work for you is that, when you call 
>> blk_pre_runtime_suspend in sd_resume_work, there are requests left
>> in the queue so that call will simply fail, it's not meant to be
>> used that way.
> 
> There should be no other requests during the system resume callback.

There can be requests left when system resume callback is invoked, but
it's not always the case and depends on what you are doing before system
suspend.

> 
>> It seems you are making use of runtime PM to speed up disk resume,
>> if that is the case, I think we can simply make sure the disk's
>> block queue is put into the same state as runtime suspended and
>> then mark it as runtime suspended during system suspend phase; on
>> system resume, call
> 
> I think I tried that and it didn't work; when it is runtime suspended
> when the system suspends, it's no longer runtime suspended when the
> system resume function was called.  Hence why I'm using the

We can modify the device's system resume callback. To better illustrate
the idea, I just made two patches to do this and I did some quick tests
and didn't find anything wrong.

The two patches are here.

From: Aaron Lu <aaron.lu@intel.com>
Date: Tue, 7 Jan 2014 15:02:13 +0800
Subject: [PATCH 1/2] SCSI: pm: make use of runtime PM for SCSI device

To make system resume fast, modify SCSI PM callbacks so that if
CONFIG_PM_RUNTIME is set, during a system suspend transition, make the
disk device's status exactly the same as runtime suspended, i.e. drain
its request queue and set its request queue's status to RPM_SUSPENDED,
so that during system resume phase, instead of resuming the device
synchronously, we can relay the resume operation to runtime PM framework
by calling pm_request_resume to take advantage of the block layer
runtime PM.

The simplest way to achieve this would be to use the bus' runtime suspend
callback for system suspend callback, but for sr driver, it will refuse
to enter runtime suspend state if there is media inside. This is obviously
not acceptable for system suspend, so instead of using driver's runtime
suspend callback, we keep using driver's system suspend callback(which
is the same for sd and doesn't matter for sr). In addition to drain device's
request queue and set proper runtime status for its request queue, we will
also set the device's runtime status accordingly in its system suspend
callback.

This is part 1, we will also need to do the same thing for the disk's
host, i.e. ATA port on PCs. The next patch will handle just that.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_lib.c  | 11 +++++++++
 drivers/scsi/scsi_pm.c   | 60 +++++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/scsi_priv.h |  3 +++
 3 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bd7f0d5f050..2b490813d5ed 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2433,6 +2433,17 @@ void scsi_device_resume(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
+#ifdef CONFIG_PM_RUNTIME
+void scsi_device_drain_queue(struct scsi_device *sdev)
+{
+	scsi_run_queue(sdev->request_queue);
+	while (sdev->request_queue->nr_pending) {
+		msleep_interruptible(200);
+		scsi_run_queue(sdev->request_queue);
+	}
+}
+#endif
+
 static void
 device_quiesce_fn(struct scsi_device *sdev, void *data)
 {
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 001e9ceda4c3..4f3fbd91c396 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -16,6 +16,24 @@
 
 #include "scsi_priv.h"
 
+#ifdef CONFIG_PM_RUNTIME
+static int sdev_runtime_suspend_common(struct device *dev,
+				       int (*cb)(struct device *))
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int err;
+
+	err = blk_pre_runtime_suspend(sdev->request_queue);
+	if (err)
+		return err;
+	if (cb)
+		err = cb(dev);
+	blk_post_runtime_suspend(sdev->request_queue, err);
+
+	return err;
+}
+#endif
+
 #ifdef CONFIG_PM_SLEEP
 
 static int scsi_dev_type_suspend(struct device *dev, int (*cb)(struct device *))
@@ -95,6 +113,35 @@ static int scsi_bus_prepare(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int sdev_system_suspend(struct device *dev, int (*cb)(struct device *))
+{
+	scsi_device_drain_queue(to_scsi_device(dev));
+	return sdev_runtime_suspend_common(dev, cb);
+}
+
+static int scsi_bus_suspend(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int err = 0;
+
+	if (scsi_is_sdev_device(dev))
+		err = sdev_system_suspend(dev, pm ? pm->suspend : NULL);
+
+	if (!err) {
+		__pm_runtime_disable(dev, false);
+		pm_runtime_set_suspended(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return err;
+}
+
+static int scsi_bus_resume(struct device *dev)
+{
+	return pm_request_resume(dev);
+}
+#else
 static int scsi_bus_suspend(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
@@ -106,6 +153,7 @@ static int scsi_bus_resume(struct device *dev)
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	return scsi_bus_resume_common(dev, pm ? pm->resume : NULL);
 }
+#endif
 
 static int scsi_bus_freeze(struct device *dev)
 {
@@ -148,17 +196,7 @@ static int scsi_bus_restore(struct device *dev)
 static int sdev_runtime_suspend(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	struct scsi_device *sdev = to_scsi_device(dev);
-	int err;
-
-	err = blk_pre_runtime_suspend(sdev->request_queue);
-	if (err)
-		return err;
-	if (pm && pm->runtime_suspend)
-		err = pm->runtime_suspend(dev);
-	blk_post_runtime_suspend(sdev->request_queue, err);
-
-	return err;
+	return sdev_runtime_suspend_common(dev, pm->runtime_suspend);
 }
 
 static int scsi_runtime_suspend(struct device *dev)
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f079a598bed4..fdd3a3a04eb4 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -90,6 +90,9 @@ extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
+#ifdef CONFIG_PM_RUNTIME
+extern void scsi_device_drain_queue(struct scsi_device *sdev);
+#endif
 struct request_queue;
 struct request;
 extern struct kmem_cache *scsi_sdb_cache;
-- 
1.8.4.2


From: Aaron Lu <aaron.lu@intel.com>
Date: Tue, 7 Jan 2014 15:14:09 +0800
Subject: [PATCH 2/2] ata: pm: make use of runtime PM for ata port

To realize fast resume for hard disks, the ata port's device will also
need to make use of runtime PM in its system resume callback.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-core.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1393a5890ed5..4f92a7834dd1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5396,10 +5396,18 @@ static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
 
 static int ata_port_suspend(struct device *dev)
 {
+	int err;
+
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return ata_port_suspend_common(dev, PMSG_SUSPEND);
+	err = ata_port_suspend_common(dev, PMSG_SUSPEND);
+	if (!err) {
+		__pm_runtime_disable(dev, false);
+		pm_runtime_set_suspended(dev);
+		pm_runtime_enable(dev);
+	}
+	return err;
 }
 
 static int ata_port_do_freeze(struct device *dev)
@@ -5432,6 +5440,12 @@ static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
 	return __ata_port_resume_common(ap, mesg, NULL);
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int ata_port_resume(struct device *dev)
+{
+	return pm_request_resume(dev);
+}
+#else
 static int ata_port_resume(struct device *dev)
 {
 	int rc;
@@ -5445,6 +5459,7 @@ static int ata_port_resume(struct device *dev)
 
 	return rc;
 }
+#endif
 
 /*
  * For ODDs, the upper layer will poll for media change every few seconds,
-- 
1.8.4.2

