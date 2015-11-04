From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 15/27] hpsa: simplify update scsi devices
Date: Wed, 04 Nov 2015 15:51:27 -0600
Message-ID: <20151104215127.15472.61739.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53530 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030199AbbKDVzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:55:22 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@pmcs.com>

remove repeated calculation that checks for physical
or logical devices.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   22 +++++++++++++---------
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 77c14ae..62df480 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3752,6 +3752,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 	int ncurrent = 0;
 	int i, n_ext_target_devs, ndevs_to_allocate;
 	int raid_ctlr_position;
+	bool physical_device;
 	DECLARE_BITMAP(lunzerobits, MAX_EXT_TARGETS);
 
 	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);
@@ -3812,16 +3813,16 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		int rc = 0;
 		int phys_dev_index = i - (raid_ctlr_position == 0);
 
+		physical_device = i < nphysicals + (raid_ctlr_position == 0);
+
 		/* Figure out where the LUN ID info is coming from */
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
 			i, nphysicals, nlogicals, physdev_list, logdev_list);
 
 		/* skip masked non-disk devices */
-		if (MASKED_DEVICE(lunaddrbytes))
-			if (i < nphysicals + (raid_ctlr_position == 0) &&
-				(physdev_list->
-				LUN[phys_dev_index].device_flags & 0x01))
-				continue;
+		if (MASKED_DEVICE(lunaddrbytes) && physical_device &&
+			(physdev_list->LUN[phys_dev_index].device_flags & 0x01))
+			continue;
 
 		/* Get device type, vendor, model, device id */
 		rc = hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
@@ -3857,10 +3858,13 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		}
 
 		*this_device = *tmpdevice;
+		this_device->physical_device = physical_device;
 
-		/* do not expose masked devices */
-		if (MASKED_DEVICE(lunaddrbytes) &&
-			i < nphysicals + (raid_ctlr_position == 0))
+		/*
+		 * Expose all devices except for physical devices that
+		 * are masked.
+		 */
+		if (MASKED_DEVICE(lunaddrbytes) && this_device->physical_device)
 			this_device->expose_device = 0;
 		else
 			this_device->expose_device = 1;
@@ -3878,7 +3882,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 				ncurrent++;
 			break;
 		case TYPE_DISK:
-			if (i < nphysicals + (raid_ctlr_position == 0)) {
+			if (this_device->physical_device) {
 				/* The disk is in HBA mode. */
 				/* Never use RAID mapper in HBA mode. */
 				this_device->offload_enabled = 0;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index a6ead07..50e4780 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -37,6 +37,7 @@ struct hpsa_scsi_dev_t {
 	unsigned int devtype;
 	int bus, target, lun;		/* as presented to the OS */
 	unsigned char scsi3addr[8];	/* as presented to the HW */
+	u8 physical_device : 1;
 	u8 expose_device;
 #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
 	unsigned char device_id[16];    /* from inquiry pg. 0x83 */

