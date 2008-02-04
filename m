From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 3/3] cciss: Add support for multi-lun devices (tape libraries)
Date: Mon, 4 Feb 2008 08:35:59 -0600
Message-ID: <20080204143559.GC3926@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:28594 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYBDOf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 09:35:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk, scameron@beardog.cca.cpqcorp.net



Add support for multi-lun tape devices to the cciss driver.

Signed-off-by: Stephen M. Cameron <smcameron@beardog.cca.cpqcorp.net>
---

 linux-2.6.24/drivers/block/cciss_scsi.c |   40 +++++++++++++++++++++++++++++---
 1 files changed, 37 insertions(+), 3 deletions(-)

diff -puN linux-2.6.24/drivers/block/cciss_scsi.c~cciss_multilun_tape linux-2.6.24/drivers/block/cciss_scsi.c
--- kernel.org2/linux-2.6.24/drivers/block/cciss_scsi.c~cciss_multilun_tape	2008-02-04 07:52:48.000000000 -0600
+++ kernel.org2-root/linux-2.6.24/drivers/block/cciss_scsi.c	2008-02-04 07:52:48.000000000 -0600
@@ -371,16 +371,50 @@ cciss_scsi_add_entry(int ctlr, int hostn
 	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
 	int n = ccissscsi[ctlr].ndevices;
 	struct cciss_scsi_dev_t *sd;
+	int i, bus, target, lun;
+	unsigned char addr1[8], addr2[8];
 
 	if (n >= CCISS_MAX_SCSI_DEVS_PER_HBA) {
 		printk("cciss%d: Too many devices, "
 			"some will be inaccessible.\n", ctlr);
 		return -1;
 	}
-	sd = &ccissscsi[ctlr].dev[n];
-	if (find_bus_target_lun(ctlr, &sd->bus, &sd->target, &sd->lun) != 0)
-		return -1;
 
+	bus = target = -1;
+	lun = 0;
+	/* Is this device a non-zero lun of a multi-lun device */
+	/* byte 4 of the 8-byte LUN addr will contain the logical unit no. */
+	if (scsi3addr[4] != 0) {
+		/* Search through our list and find the device which */
+		/* has the same 8 byte LUN address, excepting byte 4. */
+		/* Assign the same bus and target for this new LUN. */
+		/* Use the logical unit number from the firmware. */
+		memcpy(addr1, scsi3addr, 8);
+		addr1[4] = 0;
+		for (i = 0; i < n; i++) {
+			sd = &ccissscsi[ctlr].dev[i];
+			memcpy(addr2, sd->scsi3addr, 8);
+			addr2[4] = 0;
+			/* differ only in byte 4? */
+			if (memcmp(addr1, addr2, 8) == 0) {
+				bus = sd->bus;
+				target = sd->target;
+				lun = scsi3addr[4];
+				break;
+			}
+		}
+	}
+
+	sd = &ccissscsi[ctlr].dev[n];
+	if (lun == 0) {
+		if (find_bus_target_lun(ctlr,
+			&sd->bus, &sd->target, &sd->lun) != 0)
+			return -1;
+	} else {
+		sd->bus = bus;
+		sd->target = target;
+		sd->lun = lun;
+	}
 	added[*nadded].bus = sd->bus;
 	added[*nadded].target = sd->target;
 	added[*nadded].lun = sd->lun;
_
