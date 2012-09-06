From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Thu, 06 Sep 2012 13:55:30 +0800
Message-ID: <50483AD2.7070907@intel.com>
References: <Pine.LNX.4.44L0.1209041350490.1605-100000@iolanthe.rowland.org> <11638307.8MbrDPKO6y@linux-lqwf.site> <20120905152251.GA2794@localhost.localdomain> <224495182.5nCXI73U12@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <224495182.5nCXI73U12@linux-lqwf.site>
Sender: linux-ide-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 05, 2012 at 08:06:27PM +0200, Oliver Neukum wrote:
> > 2 It's not easy to implement. Imagine user just inserts a disc, and the
> > sr_suspend routine checks that door is closed so that it wants to
> > suspend the device. But actually, after user just inserts a disc, he
> > definitely wants to use the device, so it's not a good thing to do. And
> > if ZPODD is used, the device will be powered off instantly when the door
> > is closed, this is not good.
> 
> Therefore you use a reasonable delay in the driver core.

As I said in another mail to Alan, the device will not be able to
suspend due to the in kernel poll that occurred every 2s if the delay
is larger than that.

And here is a draft version for sr runtime pm that tries to use callback,
for normal ROM type and WORM type devices, there doesn't seem be
anything stopping them from suspending, so I just return 0 in their
suspend routine, they can be put to runtime suspended no matter if
the door is open or close, medium is inside or not, etc.

Please let me know what do you think, thanks.

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 902b5a4..cc3bc29 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -985,8 +985,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
 	struct ata_device *ata_dev = context;
 
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
-			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
-		scsi_autopm_get_device(ata_dev->sdev);
+			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev)) {
+		ata_dev->sdev->need_eject = 1;
+		pm_runtime_resume(&ata_dev->sdev->sdev_gendev);
+	}
 }
 
 static void ata_acpi_add_pm_notifier(struct ata_device *dev)
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 888f73a..fe36db9 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -176,7 +176,7 @@ scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
 sd_mod-objs	:= sd.o
 sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
 
-sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
+sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o sr_pm_ops.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
 		:= -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
 			-DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..e4cbd6d 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -79,6 +80,8 @@ static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
+static int sr_suspend(struct device *, pm_message_t msg);
+static int sr_resume(struct device *);
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -86,6 +89,8 @@ static struct scsi_driver sr_template = {
 		.name   	= "sr",
 		.probe		= sr_probe,
 		.remove		= sr_remove,
+		.suspend	= sr_suspend,
+		.resume		= sr_resume,
 	},
 	.done			= sr_done,
 };
@@ -146,8 +151,12 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 	kref_get(&cd->kref);
 	if (scsi_device_get(cd->device))
 		goto out_put;
+	if (scsi_autopm_get_device(cd->device))
+		goto out_pm;
 	goto out;
 
+ out_pm:
+	scsi_device_put(cd->device);
  out_put:
 	kref_put(&cd->kref, sr_kref_release);
 	cd = NULL;
@@ -163,9 +172,28 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	scsi_device_put(sdev);
+	scsi_autopm_put_device(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
 
+static int sr_suspend(struct device *dev, pm_message_t msg)
+{
+	struct scsi_cd *cd;
+
+	/* no action for system pm */
+	if (!PMSG_IS_AUTO(msg))
+		return 0;
+
+	cd = dev_get_drvdata(dev);
+	return cd->pm_ops->suspend(dev);
+}
+
+static int sr_resume(struct device *dev)
+{
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+	return cd->pm_ops->resume(dev);
+}
+
 static unsigned int sr_get_events(struct scsi_device *sdev)
 {
 	u8 buf[8];
@@ -220,6 +248,8 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	if (CDSL_CURRENT != slot)
 		return 0;
 
+	scsi_autopm_get_device(cd->device);
+
 	events = sr_get_events(cd->device);
 	cd->get_event_changed |= events & DISK_EVENT_MEDIA_CHANGE;
 
@@ -246,7 +276,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	}
 
 	if (!(clearing & DISK_EVENT_MEDIA_CHANGE))
-		return events;
+		goto out;
 do_tur:
 	/* let's see whether the media is there with TUR */
 	last_present = cd->media_present;
@@ -270,7 +300,7 @@ do_tur:
 	}
 
 	if (cd->ignore_get_event)
-		return events;
+		goto out;
 
 	/* check whether GET_EVENT is reporting spurious MEDIA_CHANGE */
 	if (!cd->tur_changed) {
@@ -287,6 +317,8 @@ do_tur:
 	cd->tur_changed = false;
 	cd->get_event_changed = false;
 
+out:
+	scsi_autopm_put_device(cd->device);
 	return events;
 }
 
@@ -702,6 +734,7 @@ static int sr_probe(struct device *dev)
 	get_capabilities(cd);
 	blk_queue_prep_rq(sdev->request_queue, sr_prep_fn);
 	sr_vendor_init(cd);
+	sr_pm_ops_init(cd);
 
 	disk->driverfs_dev = &sdev->sdev_gendev;
 	set_capacity(disk, cd->capacity);
@@ -718,6 +751,10 @@ static int sr_probe(struct device *dev)
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
+
+	/* enable runtime pm */
+	scsi_autopm_put_device(cd->device);
+
 	return 0;
 
 fail_put:
@@ -965,6 +1002,9 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	/* disable runtime pm */
+	scsi_autopm_get_device(cd->device);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 37c8f6b..face0d8 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -25,6 +25,11 @@
 
 struct scsi_device;
 
+struct sr_pm_ops {
+	int (*suspend)(struct device *dev);
+	int (*resume)(struct device *dev);
+};
+
 /* The CDROM is fairly slow, so we need a little extra time */
 /* In fact, it is very slow if it has to spin up first */
 #define IOCTL_TIMEOUT 30*HZ
@@ -49,6 +54,7 @@ typedef struct scsi_cd {
 	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
 
 	struct cdrom_device_info cdi;
+	struct sr_pm_ops *pm_ops;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
 	struct kref kref;
@@ -74,4 +80,7 @@ void sr_vendor_init(Scsi_CD *);
 int sr_cd_check(struct cdrom_device_info *);
 int sr_set_blocklength(Scsi_CD *, int blocklength);
 
+/* sr_pm_ops.c */
+void sr_pm_ops_init(struct scsi_cd *cd);
+
 #endif
diff --git a/drivers/scsi/sr_pm_ops.c b/drivers/scsi/sr_pm_ops.c
new file mode 100644
index 0000000..610fb74
--- /dev/null
+++ b/drivers/scsi/sr_pm_ops.c
@@ -0,0 +1,104 @@
+#include <linux/cdrom.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include "sr.h"
+
+static int sr_rom_suspend(struct device *dev);
+static int sr_rom_resume(struct device *dev);
+static int sr_zpodd_suspend(struct device *dev);
+static int sr_zpodd_resume(struct device *dev);
+static int sr_worm_suspend(struct device *dev);
+static int sr_worm_resume(struct device *dev);
+
+static struct sr_pm_ops sr_rom_pm_ops = {
+	.suspend	= sr_rom_suspend,
+	.resume		= sr_rom_resume,
+};
+
+static struct sr_pm_ops sr_zpodd_pm_ops = {
+	.suspend	= sr_zpodd_suspend,
+	.resume		= sr_zpodd_resume,
+};
+
+static struct sr_pm_ops sr_worm_pm_ops = {
+	.suspend	= sr_worm_suspend,
+	.resume		= sr_worm_resume,
+};
+
+static int sr_rom_suspend(struct device *dev)
+{
+	/* TODO: add requirement for ROM */
+	return 0;
+}
+
+static int sr_rom_resume(struct device *dev)
+{
+	return 0;
+}
+
+static int sr_worm_suspend(struct device *dev)
+{
+	/* TODO: add requirement for WORM */
+	return 0;
+}
+
+static int sr_worm_resume(struct device *dev)
+{
+	return 0;
+}
+
+static int sr_zpodd_suspend(struct device *dev)
+{
+	int suspend;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	/*
+	 * ZPODD can be runtime suspended when:
+	 * tray type: no media inside and tray closed
+	 * slot type: no media inside
+	 */
+	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+
+	if (cd->cdi.mask & CDC_CLOSE_TRAY)
+		/* no media for caddy/slot type ODD */
+		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a;
+	else
+		/* no media and door closed for tray type ODD */
+		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a &&
+			sshdr.ascq == 0x01;
+
+	if (!suspend)
+		return -EBUSY;
+
+	return 0;
+}
+
+static int sr_zpodd_resume(struct device *dev)
+{
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+	struct scsi_sense_hdr sshdr;
+
+	/* get the disk ready */
+	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+
+	if (cd->device->need_eject) {
+		cd->device->need_eject = 0;
+		if (!(cd->cdi.mask & CDC_CLOSE_TRAY))
+			sr_tray_move(&cd->cdi, 1);
+	}
+
+	return 0;
+
+}
+
+void sr_pm_ops_init(struct scsi_cd *cd)
+{
+	if (cd->device->type == TYPE_ROM) {
+		cd->pm_ops = &sr_rom_pm_ops;
+		if (cd->device->can_power_off)
+			cd->pm_ops = &sr_zpodd_pm_ops;
+	} else if (cd->device->type == TYPE_WORM)
+		cd->pm_ops = &sr_worm_pm_ops;
+}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9895f69..c0019d3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -156,6 +156,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned need_eject:1;	/* Need eject the tray when wakes up */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */

