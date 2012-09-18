From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v2 3/4] scsi: sd: set ready_to_power_off for scsi disk
Date: Tue, 18 Sep 2012 15:00:30 +0800
Message-ID: <1347951631-1592-4-git-send-email-aaron.lu@intel.com>
References: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32964 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060Ab2IRHBD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 03:01:03 -0400
In-Reply-To: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Oliver Neukum <oneukum@suse.de>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

The ready_to_power_off flag is used to give indication to ATA layer
if this device's power can be removed after runtime suspended from the
perspective of scsi driver.

It is introduced to support zero power ODD. When ODD is runtime
suspended, it may not be OK to remove its power.

But for disk, there doesn't exist a scenario that when the disk is
runtime suspended, it can't be powered off.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7b0f07a..009d30c 100644
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

