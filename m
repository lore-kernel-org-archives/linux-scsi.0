From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Fri, 07 Mar 2014 18:52:06 -0800
Message-ID: <1394247126.10864.3.camel@dwillia2-mobl2.amr.corp.intel.com>
References: <Pine.LNX.4.44L0.1403071028440.1246-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40373 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaCHCwN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Mar 2014 21:52:13 -0500
In-Reply-To: <Pine.LNX.4.44L0.1403071028440.1246-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: tj@kernel.org, JBottomley@Parallels.com, Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, Phillip Susi <psusi@ubuntu.com>, linux-ide@vger.kernel.org, Todd Brandt <todd.e.brandt@linux.intel.com>

On Fri, 2014-03-07 at 10:42 -0500, Alan Stern wrote:
> >  #ifdef CONFIG_PM_SLEEP
> >  
> > +#define do_pm_op(dev, op) \
> > +	dev->driver ? dev->driver->pm ? \
> > +	dev->driver->pm->op(dev) : 0 : 0
> 
> This will crash if dev->driver->pm->op is NULL.  How about making it 
> easier to read, too?
> 
> #define RETURN_PM_OP(dev, op)						\
> 	if (dev->driver && dev->driver->pm && dev->driver->pm->op) 	\
> 		return dev->driver->pm->op(dev);			\
> 	else								\
> 		return 0
> 
> static int do_scsi_suspend(struct device *dev)
> {
> 	RETURM_PM_OP(dev, suspend);
> }
> 
> etc.
> 
> Alternatively, you could put the "dev->driver && dev->driver->pm" part
> of the test directly into scsi_dev_type_suspend and
> scsi_dev_type_resume, to save a little code space.  Then the original 
> macro formulation would become sufficiently simple: one test and one 
> function call.
[..]
> Given that this function is used in only one place; I would put it 
> inline.
> 

Ended up putting the dev->driver->pm lookup into scsi_dev_type_{suspend|
resume} directly, and open coding the pm->op is NULL check.

Moved the lookup of the async function inline.

8<----------------
Subject: scsi: async sd resume

From: Dan Williams <dan.j.williams@intel.com>

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

Inspired by Todd's analysis and initial proposal [2]:
https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-optimization-simpler-approach

Cc: Len Brown <len.brown@intel.com>
Cc: Phillip Susi <psusi@ubuntu.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
[alan: bug fix and clean up suggestion]
Suggested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
[djbw: kick all resume work to the async queue]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi.c      |    3 +
 drivers/scsi/scsi_pm.c   |  119 +++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/scsi_priv.h |    1 
 drivers/scsi/sd.c        |    1 
 4 files changed, 95 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8317cf..990d4a302788 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -91,6 +91,9 @@ EXPORT_SYMBOL(scsi_logging_level);
 ASYNC_DOMAIN(scsi_sd_probe_domain);
 EXPORT_SYMBOL(scsi_sd_probe_domain);
 
+ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain);
+EXPORT_SYMBOL(scsi_sd_pm_domain);
+
 /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
  * You may not alter any existing entry (although adding new ones is
  * encouraged once assigned by ANSI/INCITS T10
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 001e9ceda4c3..06fc787e7787 100644
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
 
@@ -66,20 +108,45 @@ scsi_bus_suspend_common(struct device *dev, int (*cb)(struct device *))
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
+	if (fn)
+		async_schedule_domain(fn, dev, &scsi_sd_pm_domain);
+	else {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
 	}
-	return err;
+	return 0;
 }
 
 static int scsi_bus_prepare(struct device *dev)
@@ -97,38 +164,32 @@ static int scsi_bus_prepare(struct device *dev)
 
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
index f079a598bed4..a26fd44c7738 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -166,6 +166,7 @@ static inline int scsi_autopm_get_host(struct Scsi_Host *h) { return 0; }
 static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 #endif /* CONFIG_PM_RUNTIME */
 
+extern struct async_domain scsi_sd_pm_domain;
 extern struct async_domain scsi_sd_probe_domain;
 
 /* 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 470954aba728..700c595c603e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3020,6 +3020,7 @@ static int sd_remove(struct device *dev)
 	devt = disk_devt(sdkp->disk);
 	scsi_autopm_get_device(sdkp->device);
 
+	async_synchronize_full_domain(&scsi_sd_pm_domain);
 	async_synchronize_full_domain(&scsi_sd_probe_domain);
 	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
 	blk_queue_unprep_rq(sdkp->device->request_queue, NULL);


