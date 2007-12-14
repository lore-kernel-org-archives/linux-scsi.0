From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/3] cciss: change information displayed in /proc/drivers/cciss
Date: Fri, 14 Dec 2007 16:20:28 -0600
Message-ID: <20071214222028.GB32019@roadking.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel10.hp.com ([156.153.255.245]:51900 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbXLNWU3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Dec 2007 17:20:29 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Patch 2 of 3

This patch modifies our /proc entries to display information about only
the first logical volume on each controller. Primary reason is for hardware
that can support many LUNs (128 or more). In this case we can step on memory
and crash the system trying to display so much information. Users will have
to find information about other LUNs in /sys/block rather than /proc/drivers.
Also took the liberty of making some formatting changes to eliminate a bunch
of white spaces while I was in that part of the code.
Hardware to support this many LUNs should be available in March 2008.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 54080e6..cd5ef4a 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -716,7 +716,7 @@ static int cciss_proc_get_info(char *buffer, char **start, off_t offset,
 {
 	off_t pos = 0;
 	off_t len = 0;
-	int size, i, ctlr;
+	int size, ctlr;
 	ctlr_info_t *h = (ctlr_info_t *) data;
 	drive_info_struct *drv;
 	unsigned long flags;
@@ -736,50 +736,47 @@ static int cciss_proc_get_info(char *buffer, char **start, off_t offset,
 	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 
 	size = sprintf(buffer, "%s: HP %s Controller\n"
-		       "Board ID: 0x%08lx\n"
-		       "Firmware Version: %c%c%c%c\n"
-		       "IRQ: %d\n"
-		       "Logical drives: %d\n"
-		       "Max sectors: %d\n"
-		       "Current Q depth: %d\n"
-		       "Current # commands on controller: %d\n"
-		       "Max Q depth since init: %d\n"
-		       "Max # commands on controller since init: %d\n"
-		       "Max SG entries since init: %d\n\n",
-		       h->devname,
-		       h->product_name,
-		       (unsigned long)h->board_id,
-		       h->firm_ver[0], h->firm_ver[1], h->firm_ver[2],
-		       h->firm_ver[3], (unsigned int)h->intr[SIMPLE_MODE_INT],
-		       h->num_luns,
-		       h->cciss_max_sectors,
-		       h->Qdepth, h->commands_outstanding,
-		       h->maxQsinceinit, h->max_outstanding, h->maxSG);
-
-	pos += size;
-	len += size;
+			"Board ID: 0x%08lx\n"
+			"Firmware Version: %c%c%c%c\n"
+			"IRQ: %d\n"
+			"Max sectors: %d\n"
+			"Current Q depth: %d\n"
+			"Current # commands on controller: %d\n"
+			"Max Q depth since init: %d\n"
+			"Max # commands on controller since init: %d\n"
+			"Max SG entries since init: %d\n"
+			"Logical drives: %d\n\n",
+			h->devname,
+			h->product_name,
+			(unsigned long)h->board_id,
+			h->firm_ver[0], h->firm_ver[1], h->firm_ver[2],
+			h->firm_ver[3], (unsigned int)h->intr[SIMPLE_MODE_INT],
+			h->cciss_max_sectors,
+			h->Qdepth, h->commands_outstanding,
+			h->maxQsinceinit, h->max_outstanding,
+			h->maxSG, h->num_luns);
+
+	pos += size; len += size;
 	cciss_proc_tape_report(ctlr, buffer, &pos, &len);
-	for (i = 0; i <= h->highest_lun; i++) {
-
-		drv = &h->drv[i];
-		if (drv->heads == 0)
-			continue;
-
-		vol_sz = drv->nr_blocks;
-		vol_sz_frac = sector_div(vol_sz, ENG_GIG_FACTOR);
-		vol_sz_frac *= 100;
-		sector_div(vol_sz_frac, ENG_GIG_FACTOR);
+	drv = &h->drv[0];
+	vol_sz = drv->nr_blocks;
+	vol_sz_frac = sector_div(vol_sz, ENG_GIG_FACTOR);
+	vol_sz_frac *= 100;
+	sector_div(vol_sz_frac, ENG_GIG_FACTOR);
 
-		if (drv->raid_level > 5)
-			drv->raid_level = RAID_UNKNOWN;
-		size = sprintf(buffer + len, "cciss/c%dd%d:"
+	if (drv->raid_level > 5)
+		drv->raid_level = RAID_UNKNOWN;
+	if (drv->heads) {
+		size = sprintf(buffer + len, "cciss/c%dd0:"
 			       "\t%4u.%02uGB\tRAID %s\n",
-			       ctlr, i, (int)vol_sz, (int)vol_sz_frac,
+			       ctlr, (int)vol_sz, (int)vol_sz_frac,
 			       raid_label[drv->raid_level]);
-		pos += size;
-		len += size;
+		pos += size; len += size;
 	}
+	size = sprintf(buffer + len, "For information about other logical"
+			" volumes see /sys/block/cciss!c%dd*\n", ctlr);
 
+	pos += size; len += size;
 	*eof = 1;
 	*start = buffer + offset;
 	len -= offset;
