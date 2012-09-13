From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 15:40:48 +0800
Message-ID: <1347522049-1836-2-git-send-email-aaron.lu@intel.com>
References: <1347522049-1836-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1347522049-1836-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

The ready_to_power_off flag is used to give indication to ATA layer
if this device's power can be removed when runtime suspended.

This flag is determined by individual SCSI driver like sr, sd.

This flag is introduced to support zero power ODD. When ODD
is runtime suspended, it may not be OK to remove its power.

But for disk, it is always OK to be powered off, so set this flag.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..de786cf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2638,6 +2638,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
+	sdp->ready_to_power_off = 1;
 	scsi_autopm_put_device(sdp);
 	put_device(&sdkp->dev);
 }
-- 
1.7.12.21.g871e293

