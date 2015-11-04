From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 18/27] hpsa: refactor hpsa_figure_bus_target_lun
Date: Wed, 04 Nov 2015 15:51:45 -0600
Message-ID: <20151104215145.15472.70649.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60942 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030199AbbKDVzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:55:38 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@pmcs.com>

setup for sas transport. Need to set the
bus and target accordingly.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   25 ++++++++++++-------------
 drivers/scsi/hpsa.h |    5 +++++
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 80d64ac..c95ff8c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3512,38 +3512,37 @@ static int is_ext_target(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
 	return 0;
 }
 
-/* Helper function to assign bus, target, lun mapping of devices.
- * Puts non-external target logical volumes on bus 0, external target logical
- * volumes on bus 1, physical devices on bus 2. and the hba on bus 3.
+/*
+ * Helper function to assign bus, target, lun mapping of devices.
  * Logical drive target and lun are assigned at this time, but
  * physical device lun and target assignment are deferred (assigned
  * in hpsa_find_target_lun, called by hpsa_scsi_add_entry.)
- */
+*/
 static void figure_bus_target_lun(struct ctlr_info *h,
 	u8 *lunaddrbytes, struct hpsa_scsi_dev_t *device)
 {
-	u32 lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
+	u32 lunid = get_unaligned_le32(lunaddrbytes);
 
 	if (!is_logical_dev_addr_mode(lunaddrbytes)) {
 		/* physical device, target and lun filled in later */
 		if (is_hba_lunid(lunaddrbytes))
-			hpsa_set_bus_target_lun(device, 3, 0, lunid & 0x3fff);
+			hpsa_set_bus_target_lun(device,
+					HPSA_HBA_BUS, 0, lunid & 0x3fff);
 		else
 			/* defer target, lun assignment for physical devices */
-			hpsa_set_bus_target_lun(device, 2, -1, -1);
+			hpsa_set_bus_target_lun(device,
+					HPSA_PHYSICAL_DEVICE_BUS, -1, -1);
 		return;
 	}
 	/* It's a logical device */
 	if (is_ext_target(h, device)) {
-		/* external target way, put logicals on bus 1
-		 * and match target/lun numbers box
-		 * reports, other smart array, bus 0, target 0, match lunid
-		 */
 		hpsa_set_bus_target_lun(device,
-			1, (lunid >> 16) & 0x3fff, lunid & 0x00ff);
+			HPSA_EXTERNAL_RAID_VOLUME_BUS, (lunid >> 16) & 0x3fff,
+			lunid & 0x00ff);
 		return;
 	}
-	hpsa_set_bus_target_lun(device, 0, 0, lunid & 0x3fff);
+	hpsa_set_bus_target_lun(device, HPSA_RAID_VOLUME_BUS,
+				0, lunid & 0x3fff);
 }
 
 /*
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 50e4780..a4cab12 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -367,6 +367,11 @@ struct offline_device_entry {
 #define IOACCEL2_INBOUND_POSTQ_64_LOW	0xd0
 #define IOACCEL2_INBOUND_POSTQ_64_HI	0xd4
 
+#define HPSA_PHYSICAL_DEVICE_BUS	0
+#define HPSA_RAID_VOLUME_BUS		1
+#define HPSA_EXTERNAL_RAID_VOLUME_BUS	2
+#define HPSA_HBA_BUS			3
+
 /*
 	Send the command to the hardware
 */

