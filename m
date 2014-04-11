From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] async scsi resume for 3.15
Date: Thu, 10 Apr 2014 18:24:18 -0700
Message-ID: <1397179458.4303.23.camel@dwillia2-mobl2.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, "Brown, Len" <len.brown@intel.com>, Phillip Susi <psusi@ubuntu.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

James might still be in the process of sending this your way.  However,
given the proximity to -rc1, my reasoning for sending this directly is:

1/ It provides a tangible speed up for a non-esoteric use case (laptop
resume):

  https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-optimization-simpler-approach

2/ You already pulled the first half of this enabling from Tejun.
Quoting Tejun's ATA pull request:

  "Dan finishes the patchset to make libata PM operations
   asynchronous.  Combined with one patch being routed through scsi,
   this should speed resume measurably."

3/ As far as I can tell it is acceptable to James:

  http://marc.info/?l=linux-scsi&m=139499409510791&w=2
  http://marc.info/?l=linux-scsi&m=139508044602605&w=2
  http://marc.info/?l=linux-scsi&m=139536062515216&w=2

4/ I promised Todd I would get it upstream before he returns from
vacation.

Please pull, thank you.

--
Dan

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci async-scsi-resume

for you to fetch changes up to 3c31b52f96f7b559d950b16113c0f68c72a1985e:

  scsi: async sd resume (2014-04-10 15:30:35 -0700)

----------------------------------------------------------------
Dan Williams (1):
      scsi: async sd resume

 drivers/scsi/Kconfig     |   3 ++
 drivers/scsi/scsi.c      |   9 ++++
 drivers/scsi/scsi_pm.c   | 128 ++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/scsi_priv.h |   2 +
 drivers/scsi/scsi_scan.c |   2 +-
 drivers/scsi/sd.c        |   1 +
 6 files changed, 115 insertions(+), 30 deletions(-)


8<-------------
>From 3c31b52f96f7b559d950b16113c0f68c72a1985e Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Apr 2014 15:30:35 -0700
Subject: [PATCH] scsi: async sd resume

async_schedule() sd resume work to allow disks and other devices to
resume in parallel.

This moves the entirety of scsi_device resume to an async context to
ensure that scsi_device_resume() remains ordered with respect to the
completion of the start/stop command.  For the duration of the resume,
new command submissions (that do not originate from the scsi-core) will
be deferred (BLKPREP_DEFER).

It adds a new ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain) as a container
of these operations.  Like scsi_sd_probe_domain it is flushed at
sd_remove() time to ensure async ops do not continue past the
end-of-life of the sdev.  The implementation explicitly refrains from
reusing scsi_sd_probe_domain directly for this purpose as it is flushed
at the end of dpm_resume(), potentially defeating some of the benefit.
Given sdevs are quiesced it is permissible for these resume operations
to bleed past the async_synchronize_full() calls made by the driver
core.

We defer the resolution of which pm callback to call until
scsi_dev_type_{suspend|resume} time and guarantee that the callback
parameter is never NULL.  With this in place the type of resume
operation is encoded in the async function identifier.

There is a concern that async resume could trigger PSU overload.  In the
enterprise, storage enclosures enforce staggered spin-up regardless of
what the kernel does making async scanning safe by default.  Outside of
that context a user can disable asynchronous scanning via a kernel
command line or CONFIG_SCSI_SCAN_ASYNC.  Honor that setting when
deciding whether to do resume asynchronously.

Inspired by Todd's analysis and initial proposal [2]:
https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-optimization-simpler-approach

Cc: Len Brown <len.brown@intel.com>
Cc: Phillip Susi <psusi@ubuntu.com>
[alan: bug fix and clean up suggestion]
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
[djbw: kick all resume work to the async queue]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/Kconfig     |   3 ++
 drivers/scsi/scsi.c      |   9 ++++
 drivers/scsi/scsi_pm.c   | 128 ++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/scsi_priv.h |   2 +
 drivers/scsi/scsi_scan.c |   2 +-
 drivers/scsi/sd.c        |   1 +
 6 files changed, 115 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c8bd092..02832d6 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -263,6 +263,9 @@ config SCSI_SCAN_ASYNC
 	  You can override this choice by specifying "scsi_mod.scan=sync"
 	  or async on the kernel's command line.
 
+	  Note that this setting also affects whether resuming from
+	  system suspend will be performed asynchronously.
+
 menu "SCSI Transports"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8..1b345bf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -91,6 +91,15 @@ EXPORT_SYMBOL(scsi_logging_level);
 ASYNC_DOMAIN(scsi_sd_probe_domain);
 EXPORT_SYMBOL(scsi_sd_probe_domain);
 
+/*
+ * Separate domain (from scsi_sd_probe_domain) to maximize the benefit of
+ * asynchronous system resume operations.  It is marked 'exclusive' to avoid
+ * being included in the async_synchronize_full() that is invoked by
+ * dpm_resume()
+ */
+ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain);
+EXPORT_SYMBOL(scsi_sd_pm_domain);
+
 /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
  * You may not alter any existing entry (although adding new ones is
  * encouraged once assigned by ANSI/INCITS T10
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 001e9ce..7454498 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -18,35 +18,77 @@
 
 #ifdef CONFIG_PM_SLEEP
 
-static int scsi_dev_type_suspend(struct device *dev, int (*cb)(struct device *))
+static int do_scsi_suspend(struct device *dev, const struct dev_pm_ops *pm)
 {
+	return pm && pm->suspend ? pm->suspend(dev) : 0;
+}
+
+static int do_scsi_freeze(struct device *dev, const struct dev_pm_ops *pm)
+{
+	return pm && pm->freeze ? pm->freeze(dev) : 0;
+}
+
+static int do_scsi_poweroff(struct device *dev, const struct dev_pm_ops *pm)
+{
+	return pm && pm->poweroff ? pm->poweroff(dev) : 0;
+}
+
+static int do_scsi_resume(struct device *dev, const struct dev_pm_ops *pm)
+{
+	return pm && pm->resume ? pm->resume(dev) : 0;
+}
+
+static int do_scsi_thaw(struct device *dev, const struct dev_pm_ops *pm)
+{
+	return pm && pm->thaw ? pm->thaw(dev) : 0;
+}
+
+static int do_scsi_restore(struct device *dev, const struct dev_pm_ops *pm)
+{
+	return pm && pm->restore ? pm->restore(dev) : 0;
+}
+
+static int scsi_dev_type_suspend(struct device *dev,
+		int (*cb)(struct device *, const struct dev_pm_ops *))
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err;
 
+	/* flush pending in-flight resume operations, suspend is synchronous */
+	async_synchronize_full_domain(&scsi_sd_pm_domain);
+
 	err = scsi_device_quiesce(to_scsi_device(dev));
 	if (err == 0) {
-		if (cb) {
-			err = cb(dev);
-			if (err)
-				scsi_device_resume(to_scsi_device(dev));
-		}
+		err = cb(dev, pm);
+		if (err)
+			scsi_device_resume(to_scsi_device(dev));
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
 	return err;
 }
 
-static int scsi_dev_type_resume(struct device *dev, int (*cb)(struct device *))
+static int scsi_dev_type_resume(struct device *dev,
+		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err = 0;
 
-	if (cb)
-		err = cb(dev);
+	err = cb(dev, pm);
 	scsi_device_resume(to_scsi_device(dev));
 	dev_dbg(dev, "scsi resume: %d\n", err);
+
+	if (err == 0) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
 	return err;
 }
 
 static int
-scsi_bus_suspend_common(struct device *dev, int (*cb)(struct device *))
+scsi_bus_suspend_common(struct device *dev,
+		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
 	int err = 0;
 
@@ -66,20 +108,54 @@ scsi_bus_suspend_common(struct device *dev, int (*cb)(struct device *))
 	return err;
 }
 
-static int
-scsi_bus_resume_common(struct device *dev, int (*cb)(struct device *))
+static void async_sdev_resume(void *dev, async_cookie_t cookie)
 {
-	int err = 0;
+	scsi_dev_type_resume(dev, do_scsi_resume);
+}
 
-	if (scsi_is_sdev_device(dev))
-		err = scsi_dev_type_resume(dev, cb);
+static void async_sdev_thaw(void *dev, async_cookie_t cookie)
+{
+	scsi_dev_type_resume(dev, do_scsi_thaw);
+}
 
-	if (err == 0) {
+static void async_sdev_restore(void *dev, async_cookie_t cookie)
+{
+	scsi_dev_type_resume(dev, do_scsi_restore);
+}
+
+static int scsi_bus_resume_common(struct device *dev,
+		int (*cb)(struct device *, const struct dev_pm_ops *))
+{
+	async_func_t fn;
+
+	if (!scsi_is_sdev_device(dev))
+		fn = NULL;
+	else if (cb == do_scsi_resume)
+		fn = async_sdev_resume;
+	else if (cb == do_scsi_thaw)
+		fn = async_sdev_thaw;
+	else if (cb == do_scsi_restore)
+		fn = async_sdev_restore;
+	else
+		fn = NULL;
+
+	if (fn) {
+		async_schedule_domain(fn, dev, &scsi_sd_pm_domain);
+
+		/*
+		 * If a user has disabled async probing a likely reason
+		 * is due to a storage enclosure that does not inject
+		 * staggered spin-ups.  For safety, make resume
+		 * synchronous as well in that case.
+		 */
+		if (strncmp(scsi_scan_type, "async", 5) != 0)
+			async_synchronize_full_domain(&scsi_sd_pm_domain);
+	} else {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
 	}
-	return err;
+	return 0;
 }
 
 static int scsi_bus_prepare(struct device *dev)
@@ -97,38 +173,32 @@ static int scsi_bus_prepare(struct device *dev)
 
 static int scsi_bus_suspend(struct device *dev)
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	return scsi_bus_suspend_common(dev, pm ? pm->suspend : NULL);
+	return scsi_bus_suspend_common(dev, do_scsi_suspend);
 }
 
 static int scsi_bus_resume(struct device *dev)
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	return scsi_bus_resume_common(dev, pm ? pm->resume : NULL);
+	return scsi_bus_resume_common(dev, do_scsi_resume);
 }
 
 static int scsi_bus_freeze(struct device *dev)
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	return scsi_bus_suspend_common(dev, pm ? pm->freeze : NULL);
+	return scsi_bus_suspend_common(dev, do_scsi_freeze);
 }
 
 static int scsi_bus_thaw(struct device *dev)
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	return scsi_bus_resume_common(dev, pm ? pm->thaw : NULL);
+	return scsi_bus_resume_common(dev, do_scsi_thaw);
 }
 
 static int scsi_bus_poweroff(struct device *dev)
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	return scsi_bus_suspend_common(dev, pm ? pm->poweroff : NULL);
+	return scsi_bus_suspend_common(dev, do_scsi_poweroff);
 }
 
 static int scsi_bus_restore(struct device *dev)
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	return scsi_bus_resume_common(dev, pm ? pm->restore : NULL);
+	return scsi_bus_resume_common(dev, do_scsi_restore);
 }
 
 #else /* CONFIG_PM_SLEEP */
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f079a59..48e5b65 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -112,6 +112,7 @@ extern void scsi_exit_procfs(void);
 #endif /* CONFIG_PROC_FS */
 
 /* scsi_scan.c */
+extern char scsi_scan_type[];
 extern int scsi_complete_async_scans(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, unsigned int, int);
@@ -166,6 +167,7 @@ static inline int scsi_autopm_get_host(struct Scsi_Host *h) { return 0; }
 static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 #endif /* CONFIG_PM_RUNTIME */
 
+extern struct async_domain scsi_sd_pm_domain;
 extern struct async_domain scsi_sd_probe_domain;
 
 /* 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..6b2f51f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -97,7 +97,7 @@ MODULE_PARM_DESC(max_luns,
 #define SCSI_SCAN_TYPE_DEFAULT "sync"
 #endif
 
-static char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
+char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
 
 module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
 MODULE_PARM_DESC(scan, "sync, async or none");
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 470954a..700c595 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3020,6 +3020,7 @@ static int sd_remove(struct device *dev)
 	devt = disk_devt(sdkp->disk);
 	scsi_autopm_get_device(sdkp->device);
 
+	async_synchronize_full_domain(&scsi_sd_pm_domain);
 	async_synchronize_full_domain(&scsi_sd_probe_domain);
 	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
 	blk_queue_unprep_rq(sdkp->device->request_queue, NULL);
-- 
1.8.3.1



