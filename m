From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 2/3] PM / Runtime: Return special error code if runtime PM is disabled
Date: Sun, 26 Jun 2011 00:55:52 +0200
Message-ID: <201106260055.52859.rjw@sisk.pl>
References: <201106260054.20578.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201106260054.20578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some callers of pm_runtime_get_sync() and other runtime PM helper
functions, scsi_autopm_get_host() and scsi_autopm_get_device() in
particular, need to distinguish error codes returned when runtime PM
is disabled (i.e. power.disable_depth is nonzero for the given
device) from error codes returned in other situations.  For this
reason, make the runtime PM helper functions return -EACCES when
power.disable_depth is nonzero and ensure that this error code
won't be returned by them in any other circumstances.  Modify
scsi_autopm_get_host() and scsi_autopm_get_device() to check the
error code returned by pm_runtime_get_sync() and ignore -EACCES.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |    6 ++++--
 drivers/base/power/runtime.c       |    9 +++++----
 drivers/scsi/scsi_pm.c             |    8 ++++----
 3 files changed, 13 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -135,8 +135,9 @@ static int rpm_check_suspend_allowed(str
 
 	if (dev->power.runtime_error)
 		retval = -EINVAL;
-	else if (atomic_read(&dev->power.usage_count) > 0
-	    || dev->power.disable_depth > 0)
+	else if (dev->power.disable_depth > 0)
+		retval = -EACCES;
+	else if (atomic_read(&dev->power.usage_count) > 0)
 		retval = -EAGAIN;
 	else if (!pm_children_suspended(dev))
 		retval = -EBUSY;
@@ -262,7 +263,7 @@ static int rpm_callback(int (*cb)(struct
 		spin_lock_irq(&dev->power.lock);
 	}
 	dev->power.runtime_error = retval;
-	return retval;
+	return retval != -EACCES ? retval : -EIO;
 }
 
 /**
@@ -458,7 +459,7 @@ static int rpm_resume(struct device *dev
 	if (dev->power.runtime_error)
 		retval = -EINVAL;
 	else if (dev->power.disable_depth > 0)
-		retval = -EAGAIN;
+		retval = -EACCES;
 	if (retval)
 		goto out;
 
Index: linux-2.6/drivers/scsi/scsi_pm.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_pm.c
+++ linux-2.6/drivers/scsi/scsi_pm.c
@@ -144,9 +144,9 @@ int scsi_autopm_get_device(struct scsi_d
 	int	err;
 
 	err = pm_runtime_get_sync(&sdev->sdev_gendev);
-	if (err < 0)
+	if (err < 0 && err !=-EACCES)
 		pm_runtime_put_sync(&sdev->sdev_gendev);
-	else if (err > 0)
+	else
 		err = 0;
 	return err;
 }
@@ -173,9 +173,9 @@ int scsi_autopm_get_host(struct Scsi_Hos
 	int	err;
 
 	err = pm_runtime_get_sync(&shost->shost_gendev);
-	if (err < 0)
+	if (err < 0 && err !=-EACCES)
 		pm_runtime_put_sync(&shost->shost_gendev);
-	else if (err > 0)
+	else
 		err = 0;
 	return err;
 }
Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -291,7 +291,8 @@ drivers/base/power/runtime.c and include
     - execute the subsystem-level suspend callback for the device; returns 0 on
       success, 1 if the device's run-time PM status was already 'suspended', or
       error code on failure, where -EAGAIN or -EBUSY means it is safe to attempt
-      to suspend the device again in future
+      to suspend the device again in future and -EACCES means that disable_depth
+      is different from 0
 
   int pm_runtime_autosuspend(struct device *dev);
     - same as pm_runtime_suspend() except that the autosuspend delay is taken
@@ -304,7 +305,8 @@ drivers/base/power/runtime.c and include
       success, 1 if the device's run-time PM status was already 'active' or
       error code on failure, where -EAGAIN means it may be safe to attempt to
       resume the device again in future, but 'power.runtime_error' should be
-      checked additionally
+      checked additionally, and -EACCES means that disable_depth is different
+      from 0
 
   int pm_request_idle(struct device *dev);
     - submit a request to execute the subsystem-level idle callback for the
