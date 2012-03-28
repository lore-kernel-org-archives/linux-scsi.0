From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v3 5/7] libata: tell scsi layer device supports runtime power off
Date: Wed, 28 Mar 2012 14:22:00 +0800
Message-ID: <1332915722-15963-6-git-send-email-ming.m.lin@intel.com>
References: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

If ATA device supports "Device Attention", then tell scsi layer that
the device supports runtime power off.

Acked-by: Aaron Lu <aaron.lu@amd.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-scsi.c  |    2 ++
 include/scsi/scsi_device.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 231c3ec..0bfbe41 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3445,6 +3445,8 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 				dev->sdev = sdev;
 				scsi_device_put(sdev);
 				ata_acpi_bind(dev);
+				if (dev->flags & ATA_DFLAG_DA)
+					sdev->power_off = 1;
 			} else {
 				dev->sdev = NULL;
 			}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 77273f2..0f69612 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -151,6 +151,7 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
+	unsigned power_off:1; /* Device supports runtime power off */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.2.5

