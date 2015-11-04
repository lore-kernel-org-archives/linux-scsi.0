From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 14/27] hpsa: simplify check for device exposure
Date: Wed, 04 Nov 2015 15:51:21 -0600
Message-ID: <20151104215120.15472.91256.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60873 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030782AbbKDVzN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:55:13 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@pmcs.com>

remove macros and cleanup device exposure checking

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   25 +++++++++++--------------
 drivers/scsi/hpsa.h |    6 +-----
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 61992c0..77c14ae 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -792,8 +792,7 @@ static ssize_t path_info_show(struct device *dev,
 				PATH_STRING_LEN,
 				"PORT: %.2s ",
 				phys_connector);
-		if (hdev->devtype == TYPE_DISK &&
-			hdev->expose_state != HPSA_DO_NOT_EXPOSE) {
+		if (hdev->devtype == TYPE_DISK && hdev->expose_device) {
 			if (box == 0 || box == 0xFF) {
 				output_len += snprintf(path[i] + output_len,
 					PATH_STRING_LEN,
@@ -1152,7 +1151,7 @@ static void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
 				"RAID-?" : raid_label[dev->raid_level],
 			dev->offload_config ? '+' : '-',
 			dev->offload_enabled ? '+' : '-',
-			dev->expose_state);
+			dev->expose_device);
 }
 
 /* Add an entry into h->dev[] array. */
@@ -1225,7 +1224,7 @@ lun_assigned:
 	added[*nadded] = device;
 	(*nadded)++;
 	hpsa_show_dev_msg(KERN_INFO, h, device,
-		device->expose_state & HPSA_SCSI_ADD ? "added" : "masked");
+		device->expose_device ? "added" : "masked");
 	device->offload_to_be_enabled = device->offload_enabled;
 	device->offload_enabled = 0;
 	return 0;
@@ -1788,7 +1787,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	for (i = 0; i < nremoved; i++) {
 		if (removed[i] == NULL)
 			continue;
-		if (removed[i]->expose_state & HPSA_SCSI_ADD) {
+		if (removed[i]->expose_device) {
 			struct scsi_device *sdev =
 				scsi_device_lookup(sh, removed[i]->bus,
 					removed[i]->target, removed[i]->lun);
@@ -1813,7 +1812,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	for (i = 0; i < nadded; i++) {
 		if (added[i] == NULL)
 			continue;
-		if (!(added[i]->expose_state & HPSA_SCSI_ADD))
+		if (!(added[i]->expose_device))
 			continue;
 		if (scsi_add_device(sh, added[i]->bus,
 			added[i]->target, added[i]->lun) == 0)
@@ -1861,7 +1860,7 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
 		sdev_id(sdev), sdev->lun);
 	if (likely(sd)) {
 		atomic_set(&sd->ioaccel_cmds_out, 0);
-		sdev->hostdata = (sd->expose_state & HPSA_SCSI_ADD) ? sd : NULL;
+		sdev->hostdata = sd->expose_device ? sd : NULL;
 	} else
 		sdev->hostdata = NULL;
 	spin_unlock_irqrestore(&h->devlock, flags);
@@ -1875,7 +1874,7 @@ static int hpsa_slave_configure(struct scsi_device *sdev)
 	int queue_depth;
 
 	sd = sdev->hostdata;
-	sdev->no_uld_attach = !sd || !(sd->expose_state & HPSA_ULD_ATTACH);
+	sdev->no_uld_attach = !sd || !sd->expose_device;
 
 	if (sd)
 		queue_depth = sd->queue_depth != 0 ?
@@ -3861,12 +3860,10 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 
 		/* do not expose masked devices */
 		if (MASKED_DEVICE(lunaddrbytes) &&
-			i < nphysicals + (raid_ctlr_position == 0)) {
-			this_device->expose_state = HPSA_DO_NOT_EXPOSE;
-		} else {
-			this_device->expose_state =
-					HPSA_SG_ATTACH | HPSA_ULD_ATTACH;
-		}
+			i < nphysicals + (raid_ctlr_position == 0))
+			this_device->expose_device = 0;
+		else
+			this_device->expose_device = 1;
 
 		switch (this_device->devtype) {
 		case TYPE_ROM:
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 04f98eb..a6ead07 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -37,6 +37,7 @@ struct hpsa_scsi_dev_t {
 	unsigned int devtype;
 	int bus, target, lun;		/* as presented to the OS */
 	unsigned char scsi3addr[8];	/* as presented to the HW */
+	u8 expose_device;
 #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
 	unsigned char device_id[16];    /* from inquiry pg. 0x83 */
 	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
@@ -75,11 +76,6 @@ struct hpsa_scsi_dev_t {
 	struct hpsa_scsi_dev_t *phys_disk[RAID_MAP_MAX_ENTRIES];
 	int nphysical_disks;
 	int supports_aborts;
-#define HPSA_DO_NOT_EXPOSE	0x0
-#define HPSA_SG_ATTACH		0x1
-#define HPSA_ULD_ATTACH		0x2
-#define HPSA_SCSI_ADD		(HPSA_SG_ATTACH | HPSA_ULD_ATTACH)
-	u8 expose_state;
 };
 
 struct reply_queue_buffer {

