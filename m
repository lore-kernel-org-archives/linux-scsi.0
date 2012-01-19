From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/10] hpsa: refactor hpsa_figure_bus_target_lun
Date: Thu, 19 Jan 2012 14:01:14 -0600
Message-ID: <20120119200114.17835.91593.stgit@beardog.cce.hp.com>
References: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

It should call hpsa_set_bus_target_lun rather
than individually setting bus, target and lun.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   68 +++++++++++++++++++++++----------------------------
 1 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c52bc76..ea9b685 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1628,35 +1628,30 @@ static int is_msa2xxx(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
  * in hpsa_find_target_lun, called by hpsa_scsi_add_entry.)
  */
 static void figure_bus_target_lun(struct ctlr_info *h,
-	u8 *lunaddrbytes, int *bus, int *target, int *lun,
-	struct hpsa_scsi_dev_t *device)
-{
-	u32 lunid;
-
-	if (is_logical_dev_addr_mode(lunaddrbytes)) {
-		/* logical device */
-		lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
-		if (is_msa2xxx(h, device)) {
-			/* msa2xxx way, put logicals on bus 1
-			 * and match target/lun numbers box
-			 * reports.
-			 */
-			*bus = 1;
-			*target = (lunid >> 16) & 0x3fff;
-			*lun = lunid & 0x00ff;
-		} else {
-			*bus = 0;
-			*target = 0;
-			*lun = (lunid & 0x3fff);
-		}
-	} else {
+	u8 *lunaddrbytes, struct hpsa_scsi_dev_t *device)
+{
+	u32 lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
+
+	if (!is_logical_dev_addr_mode(lunaddrbytes)) {
+		/* physical device, target and lun filled in later */
 		if (is_hba_lunid(lunaddrbytes))
-			*bus = 3; /* controller */
+			hpsa_set_bus_target_lun(device, 3, 0, lunid & 0x3fff);
 		else
-			*bus = 2; /* physical device */
-		*target = -1;
-		*lun = -1; /* we will fill these in later. */
+			/* defer target, lun assignment for physical devices */
+			hpsa_set_bus_target_lun(device, 2, -1, -1);
+		return;
+	}
+	/* It's a logical device */
+	if (is_msa2xxx(h, device)) {
+		/* msa2xxx way, put logicals on bus 1
+		 * and match target/lun numbers box
+		 * reports, other smart array, bus 0, target 0, match lunid
+		 */
+		hpsa_set_bus_target_lun(device,
+			1, (lunid >> 16) & 0x3fff, lunid & 0x00ff);
+		return;
 	}
+	hpsa_set_bus_target_lun(device, 0, 0, lunid & 0x3fff);
 }
 
 /*
@@ -1673,12 +1668,11 @@ static void figure_bus_target_lun(struct ctlr_info *h,
 static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *tmpdevice,
 	struct hpsa_scsi_dev_t *this_device, u8 *lunaddrbytes,
-	int bus, int target, int lun, unsigned long lunzerobits[],
-	int *nmsa2xxx_enclosures)
+	unsigned long lunzerobits[], int *nmsa2xxx_enclosures)
 {
 	unsigned char scsi3addr[8];
 
-	if (test_bit(target, lunzerobits))
+	if (test_bit(tmpdevice->target, lunzerobits))
 		return 0; /* There is already a lun 0 on this target. */
 
 	if (!is_logical_dev_addr_mode(lunaddrbytes))
@@ -1687,11 +1681,11 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	if (!is_msa2xxx(h, tmpdevice))
 		return 0; /* It's only the MSA2xxx that have this problem. */
 
-	if (lun == 0) /* if lun is 0, then obviously we have a lun 0. */
+	if (tmpdevice->lun == 0) /* if lun is 0, then we have a lun 0. */
 		return 0;
 
 	memset(scsi3addr, 0, 8);
-	scsi3addr[3] = target;
+	scsi3addr[3] = tmpdevice->target;
 	if (is_hba_lunid(scsi3addr))
 		return 0; /* Don't add the RAID controller here. */
 
@@ -1708,8 +1702,9 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	if (hpsa_update_device_info(h, scsi3addr, this_device, NULL))
 		return 0;
 	(*nmsa2xxx_enclosures)++;
-	hpsa_set_bus_target_lun(this_device, bus, target, 0);
-	set_bit(target, lunzerobits);
+	hpsa_set_bus_target_lun(this_device,
+				tmpdevice->bus, tmpdevice->target, 0);
+	set_bit(tmpdevice->target, lunzerobits);
 	return 1;
 }
 
@@ -1804,7 +1799,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	int ncurrent = 0;
 	int reportlunsize = sizeof(*physdev_list) + HPSA_MAX_PHYS_LUN * 8;
 	int i, nmsa2xxx_enclosures, ndevs_to_allocate;
-	int bus, target, lun;
 	int raid_ctlr_position;
 	DECLARE_BITMAP(lunzerobits, HPSA_MAX_TARGETS_PER_CTLR);
 
@@ -1869,8 +1863,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
 							&is_OBDR))
 			continue; /* skip it if we can't talk to it. */
-		figure_bus_target_lun(h, lunaddrbytes, &bus, &target, &lun,
-			tmpdevice);
+		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
 		this_device = currentsd[ncurrent];
 
 		/*
@@ -1881,14 +1874,13 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		 * there is no lun 0.
 		 */
 		if (add_msa2xxx_enclosure_device(h, tmpdevice, this_device,
-				lunaddrbytes, bus, target, lun, lunzerobits,
+				lunaddrbytes, lunzerobits,
 				&nmsa2xxx_enclosures)) {
 			ncurrent++;
 			this_device = currentsd[ncurrent];
 		}
 
 		*this_device = *tmpdevice;
-		hpsa_set_bus_target_lun(this_device, bus, target, lun);
 
 		switch (this_device->devtype) {
 		case TYPE_ROM:
