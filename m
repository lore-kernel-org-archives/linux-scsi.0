From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v14 2/3] libata: scsi: no poll when ODD is powered off
Date: Wed, 23 Jan 2013 15:09:32 +0800
Message-ID: <1358924973-18269-3-git-send-email-aaron.lu@intel.com>
References: <1358924973-18269-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50681 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab3AWHIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2013 02:08:53 -0500
In-Reply-To: <1358924973-18269-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

When the ODD is powered off, any action the user did to the ODD that
would generate a media event will trigger an ACPI interrupt, so the
poll for media event is no longer necessary. And the poll will also
cause a runtime status change, which will stop the ODD from staying in
powered off state, so the poll should better be stopped.

But since we don't have access to the gendisk structure in LLDs, here
comes the disk_events_disable_depth for scsi device. This field is a
hint set by LLDs to convey information to upper layer drivers. A value
of 0 means media poll is necessary for the device, while values above 0
means media poll is not needed and should better be skipped. So we can
increase its value when we are to power off the ODD in ATA layer and
decrease its value when the ODD is powered on, effectively silence the
media events poll.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-zpodd.c |  7 +++++++
 drivers/scsi/scsi_lib.c    | 14 ++++++++++++++
 drivers/scsi/sr.c          | 10 +++++++---
 include/scsi/scsi_device.h |  4 ++++
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 540b0b7..a7df603 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -178,11 +178,16 @@ bool zpodd_zpready(struct ata_device *dev)
  * Enable runtime wake capability through ACPI and set the powered_off flag,
  * this flag will be used during resume to decide what operations are needed
  * to take.
+ *
+ * Also, media poll needs to be silenced, so that it doesn't bring the ODD
+ * back to full power state every few seconds.
  */
 void zpodd_enable_run_wake(struct ata_device *dev)
 {
 	struct zpodd *zpodd = dev->zpodd;
 
+	sdev_disable_disk_events(dev->sdev);
+
 	zpodd->powered_off = true;
 	device_set_run_wake(&dev->sdev->sdev_gendev, true);
 	acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, true);
@@ -231,6 +236,8 @@ void zpodd_post_poweron(struct ata_device *dev)
 
 	zpodd->zp_sampled = false;
 	zpodd->zp_ready = false;
+
+	sdev_enable_disk_events(dev->sdev);
 }
 
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f1bf5af..765398c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2617,3 +2617,17 @@ void scsi_kunmap_atomic_sg(void *virt)
 	kunmap_atomic(virt);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
+
+void sdev_disable_disk_events(struct scsi_device *sdev)
+{
+	atomic_inc(&sdev->disk_events_disable_depth);
+}
+EXPORT_SYMBOL(sdev_disable_disk_events);
+
+void sdev_enable_disk_events(struct scsi_device *sdev)
+{
+	if (WARN_ON_ONCE(atomic_read(&sdev->disk_events_disable_depth) <= 0))
+		return;
+	atomic_dec(&sdev->disk_events_disable_depth);
+}
+EXPORT_SYMBOL(sdev_enable_disk_events);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 2e8ddd7..f2884ee 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -602,9 +602,13 @@ static unsigned int sr_block_check_events(struct gendisk *disk,
 	struct scsi_cd *cd = scsi_cd(disk);
 	unsigned int ret;
 
-	scsi_autopm_get_device(cd->device);
-	ret = cdrom_check_events(&cd->cdi, clearing);
-	scsi_autopm_put_device(cd->device);
+	if (atomic_read(&cd->device->disk_events_disable_depth) == 0) {
+		scsi_autopm_get_device(cd->device);
+		ret = cdrom_check_events(&cd->cdi, clearing);
+		scsi_autopm_put_device(cd->device);
+	} else {
+		ret = 0;
+	}
 
 	return ret;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e65c62e..bb1371b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -161,6 +161,8 @@ struct scsi_device {
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 
+	atomic_t disk_events_disable_depth; /* disable depth for disk events */
+
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
 	struct work_struct event_work;
@@ -397,6 +399,8 @@ extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries,
 			    int *resid);
+extern void sdev_disable_disk_events(struct scsi_device *sdev);
+extern void sdev_enable_disk_events(struct scsi_device *sdev);
 
 #ifdef CONFIG_PM_RUNTIME
 extern int scsi_autopm_get_device(struct scsi_device *);
-- 
1.8.1

