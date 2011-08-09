From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: fix problem that OBDR devices are not detected
Date: Tue, 09 Aug 2011 08:17:30 -0500
Message-ID: <20110809131730.10599.22108.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:25798 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1HINRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2011 09:17:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, stable@kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The test to detect OBDR ("One Button Disaster Recovery")
cd-rom devices was comparing against uninitialized data.

Fixed by moving the test for the device to where the
inquiry data is collected, and uninitialized variable
altogether as it wasn't really being used.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   47 +++++++++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ec61bdb..1f32f06 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1548,10 +1548,17 @@ static inline void hpsa_set_bus_target_lun(struct hpsa_scsi_dev_t *device,
 }
 
 static int hpsa_update_device_info(struct ctlr_info *h,
-	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device)
+	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
+	unsigned char *is_OBDR_device)
 {
-#define OBDR_TAPE_INQ_SIZE 49
+
+#define OBDR_SIG_OFFSET 43
+#define OBDR_TAPE_SIG "$DR-10"
+#define OBDR_SIG_LEN (sizeof(OBDR_TAPE_SIG) - 1)
+#define OBDR_TAPE_INQ_SIZE (OBDR_SIG_OFFSET + OBDR_SIG_LEN)
+
 	unsigned char *inq_buff;
+	unsigned char *obdr_sig;
 
 	inq_buff = kzalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
 	if (!inq_buff)
@@ -1583,6 +1590,16 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	else
 		this_device->raid_level = RAID_UNKNOWN;
 
+	if (is_OBDR_device) {
+		/* See if this is a One-Button-Disaster-Recovery device
+		 * by looking for "$DR-10" at offset 43 in inquiry data.
+		 */
+		obdr_sig = &inq_buff[OBDR_SIG_OFFSET];
+		*is_OBDR_device = (this_device->devtype == TYPE_ROM &&
+					strncmp(obdr_sig, OBDR_TAPE_SIG,
+						OBDR_SIG_LEN) == 0);
+	}
+
 	kfree(inq_buff);
 	return 0;
 
@@ -1716,7 +1733,7 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 		return 0;
 	}
 
-	if (hpsa_update_device_info(h, scsi3addr, this_device))
+	if (hpsa_update_device_info(h, scsi3addr, this_device, NULL))
 		return 0;
 	(*nmsa2xxx_enclosures)++;
 	hpsa_set_bus_target_lun(this_device, bus, target, 0);
@@ -1808,7 +1825,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	 */
 	struct ReportLUNdata *physdev_list = NULL;
 	struct ReportLUNdata *logdev_list = NULL;
-	unsigned char *inq_buff = NULL;
 	u32 nphysicals = 0;
 	u32 nlogicals = 0;
 	u32 ndev_allocated = 0;
@@ -1824,11 +1840,9 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		GFP_KERNEL);
 	physdev_list = kzalloc(reportlunsize, GFP_KERNEL);
 	logdev_list = kzalloc(reportlunsize, GFP_KERNEL);
-	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
 	tmpdevice = kzalloc(sizeof(*tmpdevice), GFP_KERNEL);
 
-	if (!currentsd || !physdev_list || !logdev_list ||
-		!inq_buff || !tmpdevice) {
+	if (!currentsd || !physdev_list || !logdev_list || !tmpdevice) {
 		dev_err(&h->pdev->dev, "out of memory\n");
 		goto out;
 	}
@@ -1863,7 +1877,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	/* adjust our table of devices */
 	nmsa2xxx_enclosures = 0;
 	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
-		u8 *lunaddrbytes;
+		u8 *lunaddrbytes, is_OBDR = 0;
 
 		/* Figure out where the LUN ID info is coming from */
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
@@ -1874,7 +1888,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 			continue;
 
 		/* Get device type, vendor, model, device id */
-		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice))
+		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
+							&is_OBDR))
 			continue; /* skip it if we can't talk to it. */
 		figure_bus_target_lun(h, lunaddrbytes, &bus, &target, &lun,
 			tmpdevice);
@@ -1898,7 +1913,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		hpsa_set_bus_target_lun(this_device, bus, target, lun);
 
 		switch (this_device->devtype) {
-		case TYPE_ROM: {
+		case TYPE_ROM:
 			/* We don't *really* support actual CD-ROM devices,
 			 * just "One Button Disaster Recovery" tape drive
 			 * which temporarily pretends to be a CD-ROM drive.
@@ -1906,15 +1921,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 			 * device by checking for "$DR-10" in bytes 43-48 of
 			 * the inquiry data.
 			 */
-				char obdr_sig[7];
-#define OBDR_TAPE_SIG "$DR-10"
-				strncpy(obdr_sig, &inq_buff[43], 6);
-				obdr_sig[6] = '\0';
-				if (strncmp(obdr_sig, OBDR_TAPE_SIG, 6) != 0)
-					/* Not OBDR device, ignore it. */
-					break;
-			}
-			ncurrent++;
+			if (is_OBDR)
+				ncurrent++;
 			break;
 		case TYPE_DISK:
 			if (i < nphysicals)
@@ -1947,7 +1955,6 @@ out:
 	for (i = 0; i < ndev_allocated; i++)
 		kfree(currentsd[i]);
 	kfree(currentsd);
-	kfree(inq_buff);
 	kfree(physdev_list);
 	kfree(logdev_list);
 }

