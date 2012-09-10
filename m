From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Mon, 10 Sep 2012 17:16:22 +0800
Message-ID: <504DAFE6.50507@intel.com>
References: <Pine.LNX.4.44L0.1209061437050.1182-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21972 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab2IJJQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2012 05:16:44 -0400
In-Reply-To: <Pine.LNX.4.44L0.1209061437050.1182-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org

On 09/07/2012 02:50 AM, Alan Stern wrote:
> On Thu, 6 Sep 2012, Oliver Neukum wrote:
> 
>>>>> But in the long run that wouldn't be a good solution.  What I'd really 
>>>>> like is a way to do the status polling without having it reset the 
>>>>> idle timer.
>>>>>
>>>>> Oliver, what do you think?  Would that be a good solution?
>>>>
>>>> Well, we could introduce a flag into the requests for the polls.
>>>> But best would be to simply declare a device immediately idle
>>>> as soon as we learn that it has no medium. No special casing
>>>> would be needed.
>>>
>>> We could do that, but what about idle drives that do have media?
>>
>> Then we do have a problem. To handle this optimally we'd have to make
>> a difference between the first time a new medium is noticed and later
>> polls.
> 
> That's right.  It shouldn't be too difficult to accomplish.
> 
> One case to watch out for is a ZPODD with no media and an open door.  
> We should put the drive into runtime suspend immediately, but continue
> polling and leave the power on.  The runtime suspend after each poll
> will to see if the door is shut; when it is then polling can be turned
> off and power removed.
> 
> This leads to a question: How should the sr device tell its parent 
> whether or not to turn off the power?  Aaron's current patches simply 
> rely on the device being runtime suspended, but that won't work with 
> this scheme.  Do we need a "ready_to_power_down" flag?


Thanks for the suggestions, I've tried to use these ideas and please
take a look to see if below code did the job.

Note that I didn't call disk_block_events in sr_suspend, as there is a
race that I didn't know how to resolve:

sr_suspend				sr_check_events
  disk_block_events			  scsi_autopm_get_device
    wait for all delayed		    wait for suspend finish
    events checking work
    to finish

So it's possible when sr_suspend is executing, sr_check_events is also
executing and disk_block_events will wait for sr_check_events to finish
while sr_check_events waits for this device's suspend routine finish
before the scsi_autopm_get_device can proceed.

I used a flag called powered_off, if it is set, the sr_check_events will
simply return.

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 902b5a4..f91c922 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -869,9 +869,14 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 
 		if (state.event != PM_EVENT_ON) {
 			acpi_state = acpi_pm_device_sleep_state(
-				&dev->sdev->sdev_gendev, NULL, ACPI_STATE_D3);
-			if (acpi_state > 0)
+					&dev->sdev->sdev_gendev, NULL,
+					dev->sdev->ready_to_power_off ?
+					ACPI_STATE_D3 : ACPI_STATE_D0);
+			if (acpi_state > 0) {
 				acpi_bus_set_power(handle, acpi_state);
+				if (acpi_state == ACPI_STATE_D3)
+					dev->sdev->powered_off = 1;
+			}
 			/* TBD: need to check if it's runtime pm request */
 			acpi_pm_device_run_wake(
 				&dev->sdev->sdev_gendev, true);
@@ -880,6 +885,7 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 			acpi_pm_device_run_wake(
 				&dev->sdev->sdev_gendev, false);
 			acpi_bus_set_power(handle, ACPI_STATE_D0);
+			dev->sdev->powered_off = 0;
 		}
 	}
 
@@ -985,8 +991,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
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
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..890cee2 100644
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
@@ -163,9 +172,38 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	scsi_device_put(sdev);
+	scsi_autopm_put_device(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
 
+static int sr_suspend(struct device *dev, pm_message_t msg)
+{
+	return 0;
+}
+
+static int sr_resume(struct device *dev)
+{
+	struct scsi_cd *cd;
+	struct scsi_sense_hdr sshdr;
+
+	cd = dev_get_drvdata(dev);
+
+	if (!cd->device->powered_off)
+		return 0;
+
+	/* get the disk ready */
+	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+
+	/* if user wakes up the ODD, eject the tray */
+	if (cd->device->need_eject) {
+		cd->device->need_eject = 0;
+		if (!(cd->cdi.mask & CDC_CLOSE_TRAY))
+			sr_tray_move(&cd->cdi, 1);
+	}
+
+	return 0;
+}
+
 static unsigned int sr_get_events(struct scsi_device *sdev)
 {
 	u8 buf[8];
@@ -211,7 +249,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 				    unsigned int clearing, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
-	bool last_present;
+	bool last_present = cd->media_present;
 	struct scsi_sense_hdr sshdr;
 	unsigned int events;
 	int ret;
@@ -220,6 +258,11 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	if (CDSL_CURRENT != slot)
 		return 0;
 
+	if (cd->device->powered_off)
+		return 0;
+
+	scsi_autopm_get_device(cd->device);
+
 	events = sr_get_events(cd->device);
 	cd->get_event_changed |= events & DISK_EVENT_MEDIA_CHANGE;
 
@@ -246,10 +289,9 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	}
 
 	if (!(clearing & DISK_EVENT_MEDIA_CHANGE))
-		return events;
+		goto out;
 do_tur:
 	/* let's see whether the media is there with TUR */
-	last_present = cd->media_present;
 	ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/*
@@ -269,8 +311,19 @@ do_tur:
 		cd->tur_changed = true;
 	}
 
+	/* See if we can power off this ZPODD device */
+	if (cd->device->can_power_off) {
+		if (cd->cdi.mask & CDC_CLOSE_TRAY)
+			/* no media for caddy/slot type ODD */
+			cd->device->ready_to_power_off = !cd->media_present;
+		else
+			/* no media and door closed for tray type ODD */
+			cd->device->ready_to_power_off = !cd->media_present &&
+							 sshdr.ascq == 0x01;
+	}
+
 	if (cd->ignore_get_event)
-		return events;
+		goto out;
 
 	/* check whether GET_EVENT is reporting spurious MEDIA_CHANGE */
 	if (!cd->tur_changed) {
@@ -287,6 +340,12 @@ do_tur:
 	cd->tur_changed = false;
 	cd->get_event_changed = false;
 
+out:
+	if (cd->media_present && !last_present)
+		pm_runtime_put_noidle(&cd->device->sdev_gendev);
+	else
+		scsi_autopm_put_device(cd->device);
+
 	return events;
 }
 
@@ -715,9 +774,14 @@ static int sr_probe(struct device *dev)
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
+	disk_events_set_poll_msecs(disk, 5000);
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
+
+	/* enable runtime pm */
+	scsi_autopm_put_device(cd->device);
+
 	return 0;
 
 fail_put:
@@ -965,6 +1029,9 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	/* disable runtime pm */
+	scsi_autopm_get_device(cd->device);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 

Thanks,
Aaron
