From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v5 6/7] scsi: sr: use may_power_off
Date: Fri, 31 Aug 2012 17:42:34 +0800
Message-ID: <1346406155-4768-7-git-send-email-aaron.lu@intel.com>
References: <1346406155-4768-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab2HaJnX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2012 05:43:23 -0400
In-Reply-To: <1346406155-4768-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

With the introduction of may_power_off, when deciding if we can block
events checking, may_power_off should be used.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 1acfe0e..6b843d1 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -204,7 +204,7 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 	if (!suspend)
 		return -EBUSY;
 
-	if (cd->device->can_power_off) {
+	if (cd->device->may_power_off) {
 		cd->disk_events_blocked = 1;
 		disk_block_events(cd->disk);
 	}
@@ -794,6 +794,9 @@ static int sr_probe(struct device *dev)
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
 
+	if (cd->device->can_power_off)
+		cd->device->may_power_off = 1;
+
 	/* enable runtime pm */
 	scsi_autopm_put_device(cd->device);
 
-- 
1.7.11.5

