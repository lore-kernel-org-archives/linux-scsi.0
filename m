From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 1/2] hpsa: correct skipping masked peripherals
Date: Fri, 1 Jul 2016 13:37:31 -0500
Message-ID: <146739825108.24478.8472505463655523591.stgit@brunhilda>
References: <146739698564.24478.63853333596746262.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0048.outbound.protection.outlook.com ([104.47.33.48]:21984
	"EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752316AbcGAVMR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jul 2016 17:12:17 -0400
In-Reply-To: <146739698564.24478.63853333596746262.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

The SA controller spins down RAID drive spares.

A REGNEWD event causes an inquiry to be sent to all physical
drives. This causes the SA controller to spin up the spare.

The controller suspends all I/O to a logical volume until
the spare is spun up. The spin-up can take over 50 seconds.

This can result in one or both of the following:
 - SML sends down aborts and resets to the logical volume
   and can cause the logical volume to be off-lined.
 - a negative impact on the logical volume's I/O performance
   each time a REGNEWD is triggered.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 74 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ff8dcd5..375a396 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4105,6 +4105,70 @@ static int hpsa_set_local_logical_count(struct ctlr_info *h,
 	return rc;
 }
 
+static bool hpsa_is_disk_spare(struct ctlr_info *h, u8 *lunaddrbytes)
+{
+	struct bmic_identify_physical_device *id_phys;
+	bool is_spare = false;
+	int rc;
+
+	id_phys = kzalloc(sizeof(*id_phys), GFP_KERNEL);
+	if (!id_phys)
+		return false;
+
+	rc = hpsa_bmic_id_physical_device(h,
+					lunaddrbytes,
+					GET_BMIC_DRIVE_NUMBER(lunaddrbytes),
+					id_phys, sizeof(*id_phys));
+	if (rc == 0)
+		is_spare = (id_phys->more_flags >> 6) & 0x01;
+
+	kfree(id_phys);
+	return is_spare;
+}
+
+#define RPL_DEV_FLAG_NON_DISK                           0x1
+#define RPL_DEV_FLAG_UNCONFIG_DISK_REPORTING_SUPPORTED  0x2
+#define RPL_DEV_FLAG_UNCONFIG_DISK                      0x4
+
+#define BMIC_DEVICE_TYPE_ENCLOSURE  6
+
+static bool hpsa_skip_device(struct ctlr_info *h, u8 *lunaddrbytes,
+				struct ext_report_lun_entry *rle)
+{
+	u8 device_flags;
+	u8 device_type;
+
+	if (!MASKED_DEVICE(lunaddrbytes))
+		return false;
+
+	device_flags = rle->device_flags;
+	device_type = rle->device_type;
+
+	if (device_flags & RPL_DEV_FLAG_NON_DISK) {
+		if (device_type == BMIC_DEVICE_TYPE_ENCLOSURE)
+			return false;
+		return true;
+	}
+
+	if (!(device_flags & RPL_DEV_FLAG_UNCONFIG_DISK_REPORTING_SUPPORTED))
+		return false;
+
+	if (device_flags & RPL_DEV_FLAG_UNCONFIG_DISK)
+		return false;
+
+	/*
+	 * Spares may be spun down, we do not want to
+	 * do an Inquiry to a RAID set spare drive as
+	 * that would have them spun up, that is a
+	 * performance hit because I/O to the RAID device
+	 * stops while the spin up occurs which can take
+	 * over 50 seconds.
+	 */
+	if (hpsa_is_disk_spare(h, lunaddrbytes))
+		return true;
+
+	return false;
+}
 
 static void hpsa_update_scsi_devices(struct ctlr_info *h)
 {
@@ -4198,6 +4262,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		u8 *lunaddrbytes, is_OBDR = 0;
 		int rc = 0;
 		int phys_dev_index = i - (raid_ctlr_position == 0);
+		bool skip_device = false;
 
 		physical_device = i < nphysicals + (raid_ctlr_position == 0);
 
@@ -4205,11 +4270,15 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
 			i, nphysicals, nlogicals, physdev_list, logdev_list);
 
-		/* skip masked non-disk devices */
-		if (MASKED_DEVICE(lunaddrbytes) && physical_device &&
-		   (physdev_list->LUN[phys_dev_index].device_type != 0x06) &&
-		   (physdev_list->LUN[phys_dev_index].device_flags & 0x01))
-			continue;
+		/*
+		 * Skip over some devices such as a spare.
+		 */
+		if (!tmpdevice->external && physical_device) {
+			skip_device = hpsa_skip_device(h, lunaddrbytes,
+					&physdev_list->LUN[phys_dev_index]);
+			if (skip_device)
+				continue;
+		}
 
 		/* Get device type, vendor, model, device id */
 		rc = hpsa_update_device_info(h, lunaddrbytes, tmpdevice,

