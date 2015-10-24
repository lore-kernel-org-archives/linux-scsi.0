From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 07/21] hpsa: correct check for non-disk devices
Date: Sat, 24 Oct 2015 14:53:09 -0500
Message-ID: <20151024195309.17127.32428.stgit@brunhilda>
References: <20151024193306.17127.7819.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:55282 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbbJXT44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2015 15:56:56 -0400
In-Reply-To: <20151024193306.17127.7819.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

The driver is using two MACROs which seemingly are looking in
the wrong location for the device_flags returned from
CISS_REPORT_PHYS. Both MACROs, NON_DISK_PHYS_DEV and
PHYS_IOACCEL, are using the pointer returned from figure_lunaddrbytes
which is the address of the LUN.lunid element in
the extended CISS_REPORT_PHYS.  But the MACROS are using offsets
beyond the range of the element (offset 17 of an 8 byte element).

These MACROs actually are looking at the correct location but
they fail static checker analysis. It also will not work
if any new elements are added to the extended LUN structure.

Change the code to use the structure elements directly
since this MACRO is only used in one location.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |   28 +++++++++++++++-------------
 drivers/scsi/hpsa_cmd.h |    2 --
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0d08682..d42063d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3672,19 +3672,18 @@ static u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position,
 /* get physical drive ioaccel handle and queue depth */
 static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 		struct hpsa_scsi_dev_t *dev,
-		u8 *lunaddrbytes,
+		struct ReportExtendedLUNdata *rlep, int rle_index,
 		struct bmic_identify_physical_device *id_phys)
 {
 	int rc;
-	struct ext_report_lun_entry *rle =
-		(struct ext_report_lun_entry *) lunaddrbytes;
+	struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
 
 	dev->ioaccel_handle = rle->ioaccel_handle;
-	if (PHYS_IOACCEL(lunaddrbytes) && dev->ioaccel_handle)
+	if ((rle->device_flags & 0x08) && dev->ioaccel_handle)
 		dev->hba_ioaccel_enabled = 1;
 	memset(id_phys, 0, sizeof(*id_phys));
-	rc = hpsa_bmic_id_physical_device(h, lunaddrbytes,
-			GET_BMIC_DRIVE_NUMBER(lunaddrbytes), id_phys,
+	rc = hpsa_bmic_id_physical_device(h, &rle->lunid[0],
+			GET_BMIC_DRIVE_NUMBER(&rle->lunid[0]), id_phys,
 			sizeof(*id_phys));
 	if (!rc)
 		/* Reserve space for FW operations */
@@ -3700,11 +3699,12 @@ static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 }
 
 static void hpsa_get_path_info(struct hpsa_scsi_dev_t *this_device,
-	u8 *lunaddrbytes,
+	struct ReportExtendedLUNdata *rlep, int rle_index,
 	struct bmic_identify_physical_device *id_phys)
 {
-	if (PHYS_IOACCEL(lunaddrbytes)
-		&& this_device->ioaccel_handle)
+	struct ext_report_lun_entry *rle = &rlep->LUN[rle_index];
+
+	if ((rle->device_flags & 0x08) && this_device->ioaccel_handle)
 		this_device->hba_ioaccel_enabled = 1;
 
 	memcpy(&this_device->active_path_index,
@@ -3804,6 +3804,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
 		u8 *lunaddrbytes, is_OBDR = 0;
 		int rc = 0;
+		int phys_dev_index = i - (raid_ctlr_position == 0);
 
 		/* Figure out where the LUN ID info is coming from */
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
@@ -3812,7 +3813,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		/* skip masked non-disk devices */
 		if (MASKED_DEVICE(lunaddrbytes))
 			if (i < nphysicals + (raid_ctlr_position == 0) &&
-				NON_DISK_PHYS_DEV(lunaddrbytes))
+				(physdev_list->
+				LUN[phys_dev_index].device_flags & 0x01))
 				continue;
 
 		/* Get device type, vendor, model, device id */
@@ -3877,9 +3879,9 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 				/* Never use RAID mapper in HBA mode. */
 				this_device->offload_enabled = 0;
 				hpsa_get_ioaccel_drive_info(h, this_device,
-					lunaddrbytes, id_phys);
-				hpsa_get_path_info(this_device, lunaddrbytes,
-							id_phys);
+					physdev_list, phys_dev_index, id_phys);
+				hpsa_get_path_info(this_device,
+					physdev_list, phys_dev_index, id_phys);
 			}
 			ncurrent++;
 			break;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 47c756b..c2c0737 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -260,8 +260,6 @@ struct ext_report_lun_entry {
 	u8 wwid[8];
 	u8 device_type;
 	u8 device_flags;
-#define NON_DISK_PHYS_DEV(x) ((x)[17] & 0x01)
-#define PHYS_IOACCEL(x) ((x)[17] & 0x08)
 	u8 lun_count; /* multi-lun device, how many luns */
 	u8 redundant_paths;
 	u32 ioaccel_handle; /* ioaccel1 only uses lower 16 bits */

