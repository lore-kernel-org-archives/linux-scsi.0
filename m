From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Thu, 27 Sep 2012 17:43:52 +0800
Message-ID: <20120927094351.GA21156@mint-spring.sh.intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
 <201209241506.11631.rjw@sisk.pl>
 <20120924150449.GB3293@mint-spring.sh.intel.com>
 <201209242346.03414.rjw@sisk.pl>
 <20120925081825.GA1666@mint-spring.sh.intel.com>
 <1348570949.2457.36.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348570949.2457.36.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 25, 2012 at 03:02:29PM +0400, James Bottomley wrote:
> On Tue, 2012-09-25 at 16:18 +0800, Aaron Lu wrote:
> > A example patch would be something like the following, I didn't seperate
> > these ACPI calls in sr.c as this is just a concept proof, if this is the
> > right thing to do, I will separate them into another file sr-acpi.c and
> > make empty stubs for them in sr.h for systems do not have ACPI configured.
> 
> Apart from the needed separation to compile in the !ACPI case
> 
> > +static void sr_acpi_add_pm_notifier(struct device *dev)
> > +{
> > +	struct acpi_device *acpi_dev;
> > +	acpi_handle handle;
> > +	acpi_status status;
> > +
> > +	handle = dev->archdata.acpi_handle;
> 
> This is a complete no-no.  archdata is defined to be specific to the
> architecture it's supposed to be opaque to non-arch code.  You'll find
> that only x86 and ia64 defines an acpi_handle there.  This will
> instantly fail to compile on non intel.  If you need the handle, it
> should be obtained via some accessor like dev_to_acpi_handle() which
> will allow this to continue to function when, say, arm acquires ACPI.
> 
> I've got to say, this looks like a fault in ACPI itself.  If the handles
> are 1:1 with struct device, then why not have all the functions taking
> handles take the device instead and leave the embedded handle safely in
> the architecture specific code?

I've prepared a complete code change for you to take a look, with the
notification code resides in sr, I can move the need_eject flag from
scsi_device to scsi_cd, which should make more sense.


diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 888f73a..9f0a1da 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -177,6 +177,7 @@ sd_mod-objs	:= sd.o
 sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
 
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
+sr_mod-$(CONFIG_ACPI)	+= sr_acpi.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
 		:= -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
 			-DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 4d1a610..cb6703c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -734,6 +734,7 @@ static int sr_probe(struct device *dev)
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
+	sr_acpi_add_pm_notifier(dev);
 	scsi_autopm_put_device(cd->device);
 
 	return 0;
@@ -984,6 +985,7 @@ static int sr_remove(struct device *dev)
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
 	scsi_autopm_get_device(cd->device);
+	sr_acpi_remove_pm_notifier(dev);
 
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 37c8f6b..1f66fa0a 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -48,6 +48,8 @@ typedef struct scsi_cd {
 	bool get_event_changed:1;	/* changed according to GET_EVENT */
 	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
 
+	bool need_eject:1; /* User wakes up the ODD, need eject the tray */
+
 	struct cdrom_device_info cdi;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
@@ -74,4 +76,13 @@ void sr_vendor_init(Scsi_CD *);
 int sr_cd_check(struct cdrom_device_info *);
 int sr_set_blocklength(Scsi_CD *, int blocklength);
 
+/* sr_acpi.c */
+#ifdef CONFIG_ACPI
+extern void sr_acpi_add_pm_notifier(struct device *);
+extern void sr_acpi_remove_pm_notifier(struct device *);
+#else
+static inline void sr_acpi_add_pm_notifier(struct device *dev) {}
+static inline void sr_acpi_remove_pm_notifier(struct device *dev) {}
+#endif
+
 #endif
diff --git a/drivers/scsi/sr_acpi.c b/drivers/scsi/sr_acpi.c
new file mode 100644
index 0000000..ce6bc11
--- /dev/null
+++ b/drivers/scsi/sr_acpi.c
@@ -0,0 +1,64 @@
+#include <linux/cdrom.h>
+#include <linux/pm_runtime.h>
+#include <scsi/scsi_device.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_bus.h>
+#include "sr.h"
+
+static void sr_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
+{
+	struct device *dev = context;
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && pm_runtime_suspended(dev)) {
+		cd->need_eject = 1;
+		pm_runtime_resume(dev);
+	}
+}
+
+void sr_acpi_add_pm_notifier(struct device *dev)
+{
+	struct acpi_device *acpi_dev;
+	acpi_handle handle;
+	acpi_status status;
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	if (!sdev->can_power_off)
+		return;
+
+	handle = DEVICE_ACPI_HANDLE(dev);
+	if (!handle)
+		return;
+
+	status = acpi_bus_get_device(handle, &acpi_dev);
+	if (ACPI_FAILURE(status))
+		return;
+
+	acpi_power_resource_register_device(dev, handle);
+	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+			sr_acpi_wake_dev, dev);
+	device_set_run_wake(dev, true);
+}
+
+void sr_acpi_remove_pm_notifier(struct device *dev)
+{
+	struct acpi_device *acpi_dev;
+	acpi_handle handle;
+	acpi_status status;
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	if (!sdev->can_power_off)
+		return;
+
+	handle = DEVICE_ACPI_HANDLE(dev);
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

Thanks,
Aaron

