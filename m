From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v7 5/6] scsi: sr: use may_power_off
Date: Wed, 12 Sep 2012 16:29:56 +0800
Message-ID: <1347438597-5903-6-git-send-email-aaron.lu@intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

If may_power_off is 0, we do not check if it is ready to be powered off
in its suspend callback.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index ef72682..4c1a182 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -181,7 +181,7 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
-	if (!cd->device->can_power_off)
+	if (!cd->device->may_power_off)
 		return 0;
 
 	/* See if we can power off this ZPODD device */
@@ -786,6 +786,10 @@ static int sr_probe(struct device *dev)
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
 
+	/* By default, we allow power off of ZPODD */
+	if (cd->device->can_power_off)
+		cd->device->may_power_off = 1;
+
 	/* enable runtime pm */
 	scsi_autopm_put_device(cd->device);
 
-- 
1.7.12.21.g871e293

