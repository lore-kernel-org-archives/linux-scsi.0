From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 5/6] cciss: add support for multi lun tape devices
Date: Wed, 30 Jul 2008 16:16:40 -0500
Message-ID: <20080730211640.GE1758@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:35380 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404AbYG3VQl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 17:16:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

Patch 5 of 6

This patch adds support for multi-lun devices in a SAS environment. It's
required for the support of media changers.
Please consider this patch for inclusion.

Thanks,
mikem

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index c673ff1..e1233aa 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -371,16 +371,50 @@ cciss_scsi_add_entry(int ctlr, int hostno,
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
