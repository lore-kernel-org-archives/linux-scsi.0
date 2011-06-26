From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/3] PM: Limit race conditions between
	runtime PM and system sleep
Date: Sun, 26 Jun 2011 22:21:21 +0200
Message-ID: <201106262221.22219.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1106252249450.10907-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1106252249450.10907-100000@netrider.rowland.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/linux-pm>
List-Post: <mailto:linux-pm@lists.linux-foundation.org>
List-Help: <mailto:linux-pm-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=subscribe>
Sender: linux-pm-bounces@lists.linux-foundation.org
Errors-To: linux-pm-bounces@lists.linux-foundation.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sunday, June 26, 2011, Alan Stern wrote:
> On Sun, 26 Jun 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > One of the roles of the PM core is to prevent different PM callbacks
> > executed for the same device object from racing with each other.
> > Unfortunately, after commit e8665002477f0278f84f898145b1f141ba26ee26
> > (PM: Allow pm_runtime_suspend() to succeed during system suspend)
> > runtime PM callbacks may be executed concurrently with system
> > suspend/resume callbacks for the same device.
> 
> ...
> 
> > Index: linux-2.6/Documentation/power/runtime_pm.txt
> > ===================================================================
> > --- linux-2.6.orig/Documentation/power/runtime_pm.txt
> > +++ linux-2.6/Documentation/power/runtime_pm.txt
> 
> > +The PM core does its best to reduce the probability of race conditions between
> > +the runtime PM and system suspend/resume (and hibernation) callbacks by carrying
> > +out the following operations:
> > +
> > +  * During system suspend it acquires a runtime PM reference to every device
> > +    and resume it if there's a runtime PM resume request pending right before
> > +    executing the subsystem-level .suspend() callback for it.  In addition to
> > +    that it disables the runtime PM framework for every device right after
> > +    executing the subsystem-level .suspend() callback for it.
> > +
> > +  * During system resume it enables the runtime PM framework for all devices
> > +    right before executing the subsystem-level .resume() callbacks for them.
> > +    Additionally, it drops references to all devices right after executing the
> > +    subsystem-level .resume() callbacks for them.
> 
> I think it would be better to be a little more specific here.  Instead 
> of "acquires a runtime PM reference", say "calls 
> pm_runtime_get_noresume()".  Or at least, say "increments the 
> run-time usage counter".
> 
> Likewise, instead of "disables the runtime PM framework", say "calls 
> pm_runtime_disable()" or at least "increments power.disable_depth".

OK, updated patch is appended.

> Hmmm, come to think of it...  The documentation for pm_runtime_enable() 
> and pm_runtime_disable() fails to mention power.disable_depth, which is 
> a surprising omission.  In particular, the description of 
> pm_runtime_enable() is wrong because it ignores the possibility of 
> nested disables.

That's a good point.  There seems to be no description of pm_runtime_barrier()
too.  I'll prepare a separate patch for those issues.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Limit race conditions between runtime PM and system sleep

One of the roles of the PM core is to prevent different PM callbacks
executed for the same device object from racing with each other.
Unfortunately, after commit e8665002477f0278f84f898145b1f141ba26ee26
(PM: Allow pm_runtime_suspend() to succeed during system suspend)
runtime PM callbacks may be executed concurrently with system
suspend/resume callbacks for the same device.

The main reason for commit e8665002477f0278f84f898145b1f141ba26ee26
was that some subsystems and device drivers wanted to use runtime PM
helpers, pm_runtime_suspend() and pm_runtime_put_sync() in
particular, for carrying out the suspend of devices in their
.suspend() callbacks.  However, as it's been determined recently,
there are multiple reasons not to do so, inlcuding:

 * The caller really doesn't control the runtime PM usage counters,
   because user space can access them through sysfs and effectively
   block runtime PM.  That means using pm_runtime_suspend() or
   pm_runtime_get_sync() to suspend devices during system suspend
   may or may not work.

 * If a driver calls pm_runtime_suspend() from its .suspend()
   callback, it causes the subsystem's .runtime_suspend() callback to
   be executed, which leads to the call sequence:

   subsys->suspend(dev)
      driver->suspend(dev)
         pm_runtime_suspend(dev)
            subsys->runtime_suspend(dev)

   recursive from the subsystem's point of view.  For some subsystems
   that may actually work (e.g. the platform bus type), but for some
   it will fail in a rather spectacular fashion (e.g. PCI).  In each
   case it means a layering violation.

 * Both the subsystem and the driver can provide .suspend_noirq()
   callbacks for system suspend that can do whatever the
   .runtime_suspend() callbacks do just fine, so it really isn't
   necessary to call pm_runtime_suspend() during system suspend.

 * The runtime PM's handling of wakeup devices is usually different
   from the system suspend's one, so .runtime_suspend() may simply be
   inappropriate for system suspend.

 * System suspend is supposed to work even if CONFIG_PM_RUNTIME is
   unset.

 * The runtime PM workqueue is frozen before system suspend, so if
   whatever the driver is going to do during system suspend depends
   on it, that simply won't work.

Still, there is a good reason to allow pm_runtime_resume() to
succeed during system suspend and resume (for instance, some
subsystems and device drivers may legitimately use it to ensure that
their devices are in full-power states before suspending them).
Moreover, there is no reason to prevent runtime PM callbacks from
being executed in parallel with the system suspend/resume .prepare()
and .complete() callbacks and the code removed by commit
e8665002477f0278f84f898145b1f141ba26ee26 went too far in this
respect.  On the other hand, runtime PM callbacks, including
.runtime_resume(), must not be executed during system suspend's
"late" stage of suspending devices and during system resume's "early"
device resume stage.

Taking all of the above into consideration, make the PM core
acquire a runtime PM reference to every device and resume it if
there's a runtime PM resume request pending right before executing
the subsystem-level .suspend() callback for it.  Make the PM core
drop references to all devices right after executing the
subsystem-level .resume() callbacks for them.  Additionally,
make the PM core disable the runtime PM framework for all devices
during system suspend, after executing the subsystem-level .suspend()
callbacks for them, and enable the runtime PM framework for all
devices during system resume, right before executing the
subsystem-level .resume() callbacks for them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |   19 +++++++++++++++++++
 drivers/base/power/main.c          |   27 ++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -505,6 +505,7 @@ static int legacy_resume(struct device *
 static int device_resume(struct device *dev, pm_message_t state, bool async)
 {
 	int error = 0;
+	bool put = false;
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
@@ -521,6 +522,9 @@ static int device_resume(struct device *
 	if (!dev->power.is_suspended)
 		goto Unlock;
 
+	pm_runtime_enable(dev);
+	put = true;
+
 	if (dev->pm_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
 		error = pm_op(dev, &dev->pm_domain->ops, state);
@@ -563,6 +567,10 @@ static int device_resume(struct device *
 	complete_all(&dev->power.completion);
 
 	TRACE_RESUME(error);
+
+	if (put)
+		pm_runtime_put_sync(dev);
+
 	return error;
 }
 
@@ -843,16 +851,22 @@ static int __device_suspend(struct devic
 	int error = 0;
 
 	dpm_wait_for_children(dev, async);
-	device_lock(dev);
 
 	if (async_error)
-		goto Unlock;
+		return 0;
+
+	pm_runtime_get_noresume(dev);
+	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
+		pm_wakeup_event(dev, 0);
 
 	if (pm_wakeup_pending()) {
+		pm_runtime_put_sync(dev);
 		async_error = -EBUSY;
-		goto Unlock;
+		return 0;
 	}
 
+	device_lock(dev);
+
 	if (dev->pm_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
 		error = pm_op(dev, &dev->pm_domain->ops, state);
@@ -890,12 +904,15 @@ static int __device_suspend(struct devic
  End:
 	dev->power.is_suspended = !error;
 
- Unlock:
 	device_unlock(dev);
 	complete_all(&dev->power.completion);
 
-	if (error)
+	if (error) {
+		pm_runtime_put_sync(dev);
 		async_error = error;
+	} else if (dev->power.is_suspended) {
+		__pm_runtime_disable(dev, false);
+	}
 
 	return error;
 }
Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -567,6 +567,11 @@ this is:
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
+The PM core always increments the run-time usage counter before calling the
+->suspend() callback and decrements it after calling the ->resume() callback.
+Hence disabling run-time PM temporarily like this will not cause any run-time
+suspend callbacks to be lost.
+
 On some systems, however, system sleep is not entered through a global firmware
 or hardware operation.  Instead, all hardware components are put into low-power
 states directly by the kernel in a coordinated way.  Then, the system sleep
@@ -579,6 +584,20 @@ place (in particular, if the system is n
 be more efficient to leave the devices that had been suspended before the system
 suspend began in the suspended state.
 
+The PM core does its best to reduce the probability of race conditions between
+the runtime PM and system suspend/resume (and hibernation) callbacks by carrying
+out the following operations:
+
+  * During system suspend it calls pm_runtime_get_noresume() and
+    pm_runtime_barrier() for every device right before executing the
+    subsystem-level .suspend() callback for it.  In addition to that it calls
+    pm_runtime_disable() for every device right after executing the
+    subsystem-level .suspend() callback for it.
+
+  * During system resume it calls pm_runtime_enable() and pm_runtime_put_sync()
+    for every device right before and right after executing the subsystem-level
+    .resume() callback for it, respectively.
+
 7. Generic subsystem callbacks
 
 Subsystems may wish to conserve code space by using the set of generic power
