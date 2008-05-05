From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fixes to EMC scsi device handler
Date: Mon, 05 May 2008 13:55:22 +0200
Message-ID: <481EF5AA.7090304@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090404060106050404020001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYEELzZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2008 07:55:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090404060106050404020001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi Chandra,

based on your latest patchset there are some issues which
should be fixed:

- When SYSFS_DEPRECATED is not set also scsi_target and
  scsi_host devices will be attached to the scsi bus.
  So we have to check with 'scsi_is_sdev_device' before
  processing the notifier call
- Newer EMC flarecode also provide for a 'VRAID' device
  model; this should be added to the device map
- The name should be 'emc', not 'emc_clariion', for
  integration with existing multipath-tools
- It's spelled 'detached' :-)

Patch attached.

Some issues which I'd like to see eventually:

- We should have a way of adding/modifying the internal
  device map. Currently we have to recompile the module
  every time a new device definition is found.
- The ->activate function should be able to be triggered
  manually via sysfs.

James, seeing that the scsi_dh pointer is already present
in the sdev structure, would you accept a patch which adds
scsi_dh attributes to drivers/scsi/scsi_sysfs.c?
Having them encapsulated into drivers/scsi/device_handler
somewhere is really painful due to the asynchronous nature
of this whole thing ...

Apart from this: Great work!
I'll check the other device handlers, too; already noticed
that the device map for HP is wrong :-)

Cheers,

hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------090404060106050404020001
Content-Type: text/plain;
 name="scsi-dh-emc-fixes"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-dh-emc-fixes"

Fixes to EMC scsi device handler

Several fixes to the EMC scsi device handler:
- The name should be 'emc' for seamless integration with multipathing
- Newer EMC flarecode also has a 'VRAID' type
- Check if this is really a sdev before processing the notifier call

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 1b18989..0aded96 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -25,7 +25,7 @@
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_device.h>
 
-#define CLARIION_NAME			"emc_clariion"
+#define CLARIION_NAME			"emc"
 
 #define CLARIION_TRESPASS_PAGE		0x22
 #define CLARIION_BUFFER_SIZE		0x80
@@ -390,12 +390,13 @@ static int clariion_check_sense(struct scsi_device *sdev,
 	return SUCCESS;
 }
 
-static const struct {
+static const struct clariion_dev_list_t {
 	char *vendor;
 	char *model;
 } clariion_dev_list[] = {
 	{"DGC", "RAID"},
 	{"DGC", "DISK"},
+	{"DGC", "VRAID"},
 	{NULL, NULL},
 };
 
@@ -422,6 +423,9 @@ static int clariion_bus_notify(struct notifier_block *nb,
 	int i, found = 0;
 	unsigned long flags;
 
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		for (i = 0; clariion_dev_list[i].vendor; i++) {
 			if (!strncmp(sdev->vendor, clariion_dev_list[i].vendor,
@@ -465,7 +469,7 @@ static int clariion_bus_notify(struct notifier_block *nb,
 		sdev->scsi_dh_data = NULL;
 		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n",
+		sdev_printk(KERN_NOTICE, sdev, "Detached %s.\n",
 			    CLARIION_NAME);
 
 		kfree(scsi_dh_data);

--------------090404060106050404020001--
