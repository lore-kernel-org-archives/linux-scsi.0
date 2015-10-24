From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 16/21] hpsa: eliminate fake lun0 enclosures
Date: Sat, 24 Oct 2015 14:54:04 -0500
Message-ID: <20151024195404.17127.43592.stgit@brunhilda>
References: <20151024193306.17127.7819.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:51504 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418AbbJXT5q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2015 15:57:46 -0400
In-Reply-To: <20151024193306.17127.7819.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@pmcs.com>

We don't need to create fake enclosure devices at Lun0
in external target array configurations anymore.
This was done to support Pre-SCSI rev 5 controllers
that didn't suppoprt report luns commands, so the
SCSI layer had to scan targets. If there was no
LUN at LUN 0, then the target scan would stop, and
move to the next target.  Lun0 enclosure device
was added to prevent sparsely-numbered LUNs from
being missed.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   68 ---------------------------------------------------
 1 file changed, 68 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7951ca8..e9652a9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3553,60 +3553,6 @@ static void figure_bus_target_lun(struct ctlr_info *h,
 				0, lunid & 0x3fff);
 }
 
-/*
- * If there is no lun 0 on a target, linux won't find any devices.
- * For the external targets (arrays), we have to manually detect the enclosure
- * which is at lun zero, as CCISS_REPORT_PHYSICAL_LUNS doesn't report
- * it for some reason.  *tmpdevice is the target we're adding,
- * this_device is a pointer into the current element of currentsd[]
- * that we're building up in update_scsi_devices(), below.
- * lunzerobits is a bitmap that tracks which targets already have a
- * lun 0 assigned.
- * Returns 1 if an enclosure was added, 0 if not.
- */
-static int add_ext_target_dev(struct ctlr_info *h,
-	struct hpsa_scsi_dev_t *tmpdevice,
-	struct hpsa_scsi_dev_t *this_device, u8 *lunaddrbytes,
-	unsigned long lunzerobits[], int *n_ext_target_devs)
-{
-	unsigned char scsi3addr[8];
-
-	if (test_bit(tmpdevice->target, lunzerobits))
-		return 0; /* There is already a lun 0 on this target. */
-
-	if (!is_logical_dev_addr_mode(lunaddrbytes))
-		return 0; /* It's the logical targets that may lack lun 0. */
-
-	if (!tmpdevice->external)
-		return 0; /* Only external target devices have this problem. */
-
-	if (tmpdevice->lun == 0) /* if lun is 0, then we have a lun 0. */
-		return 0;
-
-	memset(scsi3addr, 0, 8);
-	scsi3addr[3] = tmpdevice->target;
-	if (is_hba_lunid(scsi3addr))
-		return 0; /* Don't add the RAID controller here. */
-
-	if (is_scsi_rev_5(h))
-		return 0; /* p1210m doesn't need to do this. */
-
-	if (*n_ext_target_devs >= MAX_EXT_TARGETS) {
-		dev_warn(&h->pdev->dev, "Maximum number of external "
-			"target devices exceeded.  Check your hardware "
-			"configuration.");
-		return 0;
-	}
-
-	if (hpsa_update_device_info(h, scsi3addr, this_device, NULL))
-		return 0;
-	(*n_ext_target_devs)++;
-	hpsa_set_bus_target_lun(this_device,
-				tmpdevice->bus, tmpdevice->target, 0);
-	hpsa_update_device_supports_aborts(h, this_device, scsi3addr);
-	set_bit(tmpdevice->target, lunzerobits);
-	return 1;
-}
 
 /*
  * Get address of physical disk used for an ioaccel2 mode command:
@@ -3939,20 +3885,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
 		this_device = currentsd[ncurrent];
 
-		/*
-		 * For external target devices, we have to insert a LUN 0 which
-		 * doesn't show up in CCISS_REPORT_PHYSICAL data, but there
-		 * is nonetheless an enclosure device there.  We have to
-		 * present that otherwise linux won't find anything if
-		 * there is no lun 0.
-		 */
-		if (add_ext_target_dev(h, tmpdevice, this_device,
-				lunaddrbytes, lunzerobits,
-				&n_ext_target_devs)) {
-			ncurrent++;
-			this_device = currentsd[ncurrent];
-		}
-
 		*this_device = *tmpdevice;
 		this_device->physical_device = physical_device;
 

