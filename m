From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Tue, 25 Sep 2012 16:18:26 +0800
Message-ID: <20120925081825.GA1666@mint-spring.sh.intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
 <201209241506.11631.rjw@sisk.pl>
 <20120924150449.GB3293@mint-spring.sh.intel.com>
 <201209242346.03414.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201209242346.03414.rjw@sisk.pl>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 24, 2012 at 11:46:03PM +0200, Rafael J. Wysocki wrote:
> On Monday, September 24, 2012, Aaron Lu wrote:
> > On Mon, Sep 24, 2012 at 03:06:11PM +0200, Rafael J. Wysocki wrote:
> > > On Monday, September 24, 2012, Aaron Lu wrote:
> > > > need_eject:
> > > > First consider how the device will be runtime resumed:
> > > > 1 Some program opens the block device;
> > > > 2 Events checking poll when it's not powered off yet;
> > > > 3 User presses the eject button or inserts a disc into the slot when the
> > > >   device is in powered off state.
> > > > And the need_eject flag is for case 3, when the device is in powered off
> > > > state and user presses the eject button, it will be powered on(through
> > > > acpi wake notification function) and runtime resumed. In its runtime
> > > > resume callback, its tray needs to be ejected since user just presses
> > > > the eject button. The whole process of ZPODD is opaque to the user,
> > > > he/she doesn't know the ODD lost power so the ODD has to behave exactly
> > > > like it doesn't lose power.
> > > 
> > > Do you think it can be useful for other types of devices, not necessarily
> > > handled through ACPI?
> > 
> > I can only say that it is useful for ZPODD, if ZPODD someday is used on
> > another platform that does not use ACPI, the need_eject flag should
> > still be needed.
> > 
> > As for other scsi devices, I'm not sure.
> 
> I see.  This means we don't really have good arguments for putting that flag
> into struct scsi_device ...

OK.

I'm thinking of moving the acpi wake notification code from ata to scsi,
so that the notification function lives in sr module and then I do not
need to set this need_eject flag in scsi_device and scsi_cd structure
needs to host this flag.

A example patch would be something like the following, I didn't seperate
these ACPI calls in sr.c as this is just a concept proof, if this is the
right thing to do, I will separate them into another file sr-acpi.c and
make empty stubs for them in sr.h for systems do not have ACPI configured.


diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index ef72682..94d17f1 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -46,6 +46,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/acpi.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -57,6 +58,8 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
 
+#include <acpi/acpi_bus.h>
+
 #include "scsi_logging.h"
 #include "sr.h"
 
@@ -212,8 +220,8 @@ static int sr_resume(struct device *dev)
 	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/* If user wakes up the ODD, eject the tray */
-	if (cd->device->need_eject) {
-		cd->device->need_eject = 0;
+	if (cd->need_eject) {
+		cd->need_eject = false;
 		/* But only for tray type ODD when door is not locked */
 		if (!(cd->cdi.mask & CDC_CLOSE_TRAY) && !cd->door_locked)
 			sr_tray_move(&cd->cdi, 1);
@@ -704,6 +711,58 @@ static void sr_release(struct cdrom_device_info *cdi)
 
 }
 
+static void sr_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
+{
+	struct device *dev = context;
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && pm_runtime_suspended(dev)) {
+		cd->need_eject = true;
+		pm_runtime_resume(dev);
+	}
+}
+
+static void sr_acpi_add_pm_notifier(struct device *dev)
+{
+	struct acpi_device *acpi_dev;
+	acpi_handle handle;
+	acpi_status status;
+
+	handle = dev->archdata.acpi_handle;
+	if (!handle)
+		return;
+
+	status = acpi_bus_get_device(handle, &acpi_dev);
+	if (ACPI_FAILURE(status))
+		return;
+
+	acpi_power_resource_register_device(dev, handle);
+	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					sr_acpi_wake_dev, dev);
+	device_set_run_wake(dev, true);
+}
+
+static void sr_acpi_remove_pm_notifier(struct device *dev)
+{
+	struct acpi_device *acpi_dev;
+	acpi_handle handle;
+	acpi_status status;
+
+	handle = dev->archdata.acpi_handle;
+	if (!handle)
+		return;
+
+	status = acpi_bus_get_device(handle, &acpi_dev);
+	if (ACPI_FAILURE(status))
+		return;
+
+	acpi_power_resource_unregister_device(dev, handle);
+	device_set_run_wake(dev, false);
+	acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY, sr_acpi_wake_dev);
+}
+
 static int sr_probe(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -786,7 +845,9 @@ static int sr_probe(struct device *dev)
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
 
-	/* enable runtime pm */
+	if (sdev->can_power_off)
+		sr_acpi_add_pm_notifier(dev);
+
 	scsi_autopm_put_device(cd->device);
 
 	return 0;
@@ -1036,8 +1097,9 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
-	/* disable runtime pm */
 	scsi_autopm_get_device(cd->device);
+	if (cd->device->can_power_off)
+		sr_acpi_remove_pm_notifier(dev);
 
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);


Thanks,
Aaron

