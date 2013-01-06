From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v11 8/9] libata: no poll when ODD is powered off
Date: Sun,  6 Jan 2013 10:48:28 +0800
Message-ID: <1357440509-28108-9-git-send-email-aaron.lu@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

When the ODD is powered off, any action the user did to the ODD that
would generate a media event will trigger an ACPI interrupt, so the
poll for media event is no longer necessary. And the poll will also
cause a runtime status change, which will stop the ODD from staying in
powered off state, so the poll should better be stopped.

But since we don't have access to the gendisk structure in LLDs, here
comes the event_driven flag for scsi device. This flag serves as a
capability of the device, conveyed by the LLDs to upper layer. It is set
when LLDs know that this device will no longer generate any media
related events, so that the check_events can simply return 0 without
bothering the device, effectively silence the poll.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-zpodd.c | 8 ++++++++
 drivers/scsi/sr.c          | 6 +++++-
 include/scsi/scsi_device.h | 1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 3c39987..5843a18 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -177,6 +177,13 @@ void zpodd_pre_poweroff(struct ata_device *dev)
 {
 	struct zpodd *zpodd = dev->zpodd;
 
+	/*
+	 * Silence the media change poll, as we will be notified when
+	 * user wants to use the ODD so there is no meaning to poll
+	 * it when it is powered off
+	 */
+	dev->sdev->event_driven = true;
+
 	zpodd->powered_off = true;
 	device_set_run_wake(&dev->sdev->sdev_gendev, true);
 	acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, true);
@@ -209,6 +216,7 @@ void zpodd_post_resume(struct ata_device *dev)
 
 	zpodd->last_ready = 0;
 	zpodd->zp_ready = false;
+	dev->sdev->event_driven = false;
 }
 
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 4d1a610..b034274 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -594,7 +594,11 @@ static unsigned int sr_block_check_events(struct gendisk *disk,
 					  unsigned int clearing)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	return cdrom_check_events(&cd->cdi, clearing);
+
+	if (!cd->device->event_driven)
+		return cdrom_check_events(&cd->cdi, clearing);
+	else
+		return 0;
 }
 
 static int sr_block_revalidate_disk(struct gendisk *disk)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e65c62e..1756151 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -160,6 +160,7 @@ struct scsi_device {
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
+	unsigned event_driven:1; /* No need to poll the device */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.11.7

