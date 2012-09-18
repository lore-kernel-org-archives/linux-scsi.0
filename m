From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v2 1/4] scsi: introduce sync_before_stop flag
Date: Tue, 18 Sep 2012 15:00:28 +0800
Message-ID: <1347951631-1592-2-git-send-email-aaron.lu@intel.com>
References: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Oliver Neukum <oneukum@suse.de>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

When scsi device received stop command, it will take care of its
internal cache before enters stopped power condition. This command is
translated to standby immediate in libata-scsi, but standby doesn't
imply flush cache for ATA device, so to issue stop command to ATA
device, an additional flush cache has to be issued.

Introduce this flag so that when we are to stop the ATA disk in scsi
disk driver, also flush its internal cache.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 include/scsi/scsi_device.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4712aa1..26c3621 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -160,6 +160,7 @@ struct scsi_device {
 	unsigned ready_to_power_off:1;	/* Device is ready to be powered off */
 	unsigned powered_off:1;	/* Device is powered off */
 	unsigned may_power_off:1; /* Power off is allowed by user */
+	unsigned sync_before_stop:1; /* Sync cache before stop */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.12.21.g871e293

