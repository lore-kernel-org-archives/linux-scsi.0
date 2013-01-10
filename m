From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v12 7/9] libata: scsi: no poll when ODD is powered off
Date: Thu, 10 Jan 2013 17:24:28 +0800
Message-ID: <1357809870-18816-8-git-send-email-aaron.lu@intel.com>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

When the ODD is powered off, any action the user did to the ODD that
would generate a media event will trigger an ACPI interrupt, so the
poll for media event is no longer necessary. And the poll will also
cause a runtime status change, which will stop the ODD from staying in
powered off state, so the poll should better be stopped.

But since we don't have access to the gendisk structure in LLDs, here
comes the disable_disk_events flag for scsi device. This flag serves as
a capability of the device, conveyed by the LLDs to upper layer. It is
set when LLDs know that this device will no longer generate any media
related events, so that the check_events can simply return 0 without
bothering the device, effectively silence the poll.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-zpodd.c | 8 ++++++++
 drivers/scsi/sr.c          | 6 +++++-
 include/scsi/scsi_device.h | 3 +++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 1f5d52a..11fcd58 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -182,6 +182,13 @@ void zpodd_enable_run_wake(struct ata_device *dev)
 {
 	struct zpodd *zpodd = dev->zpodd;
 
+	/*
+	 * Silence the media change poll, as we will be notified when
+	 * user wants to use the ODD so there is no meaning to poll
+	 * it when it is powered off
+	 */
+	dev->sdev->disable_disk_events = true;
+
 	zpodd->powered_off = true;
 	device_set_run_wake(&dev->sdev->sdev_gendev, true);
 	acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, true);
@@ -230,6 +237,7 @@ void zpodd_post_poweron(struct ata_device *dev)
 
 	zpodd->zp_sampled = false;
 	zpodd->zp_ready = false;
+	dev->sdev->disable_disk_events = false;
 }
 
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 4d1a610..c9c7fbb 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -594,7 +594,11 @@ static unsigned int sr_block_check_events(struct gendisk *disk,
 					  unsigned int clearing)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	return cdrom_check_events(&cd->cdi, clearing);
+
+	if (!cd->device->disable_disk_events)
+		return cdrom_check_events(&cd->cdi, clearing);
+	else
+		return 0;
 }
 
 static int sr_block_revalidate_disk(struct gendisk *disk)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e65c62e..6e9781f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -161,6 +161,9 @@ struct scsi_device {
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 
+	bool disable_disk_events; /* disable poll for disk events, used in
+				   * ATA layer, sychronized by PM core */
+
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
 	struct work_struct event_work;
-- 
1.7.11.7

