From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 04/17] Fix use of unallocated memory for MSA2xxx enclosure
	device data.
Date: Wed, 11 Nov 2009 10:50:43 -0600
Message-ID: <20091111165043.17754.6076.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:27250 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843AbZKKQtQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 11:49:16 -0500
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com

Fix use of unallocated memory for MSA2xxx enclosure device data.
If you happened to have fewer physical devices reported by
CCISS_REPORT_LUNS than the total number of MSA2012 enclosures
(unlikely), the data for some enclosure(s) would get stored into,
or cause other device data to be stored into unallocated territory.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6c4d9fd..e402155 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1314,7 +1314,8 @@ static void figure_bus_target_lun(struct ctlr_info *h,
 static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *tmpdevice,
 	struct hpsa_scsi_dev_t *this_device, __u8 *lunaddrbytes,
-	int bus, int target, int lun, unsigned long lunzerobits[])
+	int bus, int target, int lun, unsigned long lunzerobits[],
+	int *nmsa2xxx_enclosures)
 {
 	unsigned char scsi3addr[8];
 
@@ -1333,10 +1334,19 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	if (is_hba_lunid(scsi3addr))
 		return 0; /* Don't add the RAID controller here. */
 
+#define MAX_MSA2XXX_ENCLOSURES 32
+	if (*nmsa2xxx_enclosures >= MAX_MSA2XXX_ENCLOSURES) {
+		dev_warn(&h->pdev->dev, "Maximum number of MSA2XXX "
+			"enclosures exceeded.  Check your hardware "
+			"configuration.");
+		return 0;
+	}
+
 	memset(scsi3addr, 0, 8);
 	scsi3addr[3] = target;
 	if (hpsa_update_device_info(h, scsi3addr, this_device))
 		return 0;
+	(*nmsa2xxx_enclosures)++;
 	hpsa_set_bus_target_lun(this_device, bus, target, 0);
 	set_bit(target, lunzerobits);
 	return 1;
@@ -1416,7 +1426,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	struct hpsa_scsi_dev_t **currentsd, *this_device, *tmpdevice;
 	int ncurrent = 0;
 	int reportlunsize = sizeof(*physdev_list) + HPSA_MAX_PHYS_LUN * 8;
-	int i;
+	int i, nmsa2xxx_enclosures, ndevs_to_allocate;
 	int bus, target, lun;
 	DECLARE_BITMAP(lunzerobits, HPSA_MAX_TARGETS_PER_CTLR);
 
@@ -1438,8 +1448,14 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 			logdev_list, &nlogicals))
 		goto out;
 
+	/* We might see up to 32 MSA2xxx enclosures, actually 8 of them
+	 * but each of them 4 times through different paths.  The plus 1
+	 * is for the RAID controller.
+	 */
+	ndevs_to_allocate = nphysicals + nlogicals + MAX_MSA2XXX_ENCLOSURES + 1;
+
 	/* Allocate the per device structures */
-	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
+	for (i = 0; i < ndevs_to_allocate; i++) {
 		currentsd[i] = kzalloc(sizeof(*currentsd[i]), GFP_KERNEL);
 		if (!currentsd[i]) {
 			dev_warn(&h->pdev->dev, "out of memory at %s:%d\n",
@@ -1450,6 +1466,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	}
 
 	/* adjust our table of devices */
+	nmsa2xxx_enclosures = 0;
 	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
 		__u8 *lunaddrbytes;
 
@@ -1482,7 +1499,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		 * there is no lun 0.
 		 */
 		if (add_msa2xxx_enclosure_device(h, tmpdevice, this_device,
-			lunaddrbytes, bus, target, lun, lunzerobits)) {
+				lunaddrbytes, bus, target, lun, lunzerobits,
+				&nmsa2xxx_enclosures)) {
 			ncurrent++;
 			this_device = currentsd[ncurrent];
 		}

