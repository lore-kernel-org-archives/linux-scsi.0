From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] hpsa: use bus '3' for legacy HBA devices
Date: Thu, 17 Nov 2016 12:15:56 +0100
Message-ID: <1479381356-94616-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36179 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751667AbcKQLQO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 06:16:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Jack Suter <jack@suter.io>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Older controllers use SCSI target id '0' for the first internal
disk. As the controllers are now placed on the same bus than the
internal disks this leads to a clash with the SCSI target id of
controller.
This patch checks the SCSI revision, and moves older controller
to bus '3' to be compatible with older releases and avoid this
problem.

Fixes: 09371d623c9 ("hpsa: Change SAS transport devices to bus 0.")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 14 ++++++++++----
 drivers/scsi/hpsa.h |  2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ef4e81a..d0a22aa 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2034,7 +2034,8 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
 			sd->target = sdev_id(sdev);
 			sd->lun = sdev->lun;
 		}
-	} else
+	}
+	if (!sd)
 		sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
 					sdev_id(sdev), sdev->lun);
 
@@ -3850,6 +3851,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		sizeof(this_device->vendor));
 	memcpy(this_device->model, &inq_buff[16],
 		sizeof(this_device->model));
+	this_device->rev = inq_buff[2];
 	memset(this_device->device_id, 0,
 		sizeof(this_device->device_id));
 	if (hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
@@ -3939,10 +3941,14 @@ static void figure_bus_target_lun(struct ctlr_info *h,
 
 	if (!is_logical_dev_addr_mode(lunaddrbytes)) {
 		/* physical device, target and lun filled in later */
-		if (is_hba_lunid(lunaddrbytes))
+		if (is_hba_lunid(lunaddrbytes)) {
+			int bus = HPSA_HBA_BUS;
+
+			if (!device->rev)
+				bus = HPSA_LEGACY_HBA_BUS;
 			hpsa_set_bus_target_lun(device,
-					HPSA_HBA_BUS, 0, lunid & 0x3fff);
-		else
+					bus, 0, lunid & 0x3fff);
+		} else
 			/* defer target, lun assignment for physical devices */
 			hpsa_set_bus_target_lun(device,
 					HPSA_PHYSICAL_DEVICE_BUS, -1, -1);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 3faf6cf..64e9829 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -69,6 +69,7 @@ struct hpsa_scsi_dev_t {
 	u64 sas_address;
 	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
 	unsigned char model[16];        /* bytes 16-31 of inquiry data */
+	unsigned char rev;		/* byte 2 of inquiry data */
 	unsigned char raid_level;	/* from inquiry page 0xC1 */
 	unsigned char volume_offline;	/* discovered via TUR or VPD */
 	u16 queue_depth;		/* max queue_depth for this device */
@@ -400,6 +401,7 @@ struct offline_device_entry {
 #define HPSA_RAID_VOLUME_BUS		1
 #define HPSA_EXTERNAL_RAID_VOLUME_BUS	2
 #define HPSA_HBA_BUS			0
+#define HPSA_LEGACY_HBA_BUS		3
 
 /*
 	Send the command to the hardware
-- 
1.8.5.6

