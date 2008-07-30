From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 3/6] cciss: fix negative logical drive count in procfs
Date: Wed, 30 Jul 2008 16:12:39 -0500
Message-ID: <20080730211239.GC1758@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:14714 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759349AbYG3VMk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 17:12:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Patch 3 of 6

This patch fixes a problem where the logical volume count may go negative.
In some instances if several logical are configured on a controller and all
of them are deleted using the online utilities the volume count in /proc may
go negative with no way get it correct again.
Please condider this patch for inclusion. It is dependent upon patch 2 in
this set.

Thanks,
mikem

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d372db0..ae663db 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1535,15 +1535,18 @@ mem_msg:
  * where new drives will be added.  If the index to be returned is greater
  * than the highest_lun index for the controller then highest_lun is set
  * to this new index.  If there are no available indexes then -1 is returned.
+ * "controller_node" is used to know if this is a real logical drive, or just
+ * the controller node, which determines if this counts towards highest_lun.
  */
-static int cciss_find_free_drive_index(int ctlr)
+static int cciss_find_free_drive_index(int ctlr, int controller_node)
 {
 	int i;
 
 	for (i = 0; i < CISS_MAX_LUN; i++) {
 		if (hba[ctlr]->drv[i].raid_level == -1) {
 			if (i > hba[ctlr]->highest_lun)
-				hba[ctlr]->highest_lun = i;
+				if (!controller_node)
+					hba[ctlr]->highest_lun = i;
 			return i;
 		}
 	}
@@ -1559,11 +1562,11 @@ static int cciss_find_free_drive_index(int ctlr)
  * a means to talk to the controller in case no logical
  * drives have yet been configured.
  */
-static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid)
+static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 {
 	int drv_index;
 
-	drv_index = cciss_find_free_drive_index(h->ctlr);
+	drv_index = cciss_find_free_drive_index(h->ctlr, controller_node);
 	if (drv_index == -1)
 		return -1;
 	/*Check if the gendisk needs to be allocated */
@@ -1600,7 +1603,7 @@ static void cciss_add_controller_node(ctlr_info_t *h)
 	if (h->gendisk[0] != NULL) /* already did this? Then bail. */
 		return;
 
-	drv_index = cciss_add_gendisk(h, 0);
+	drv_index = cciss_add_gendisk(h, 0, 1);
 	if (drv_index == -1) {
 		printk(KERN_WARNING "cciss%d: could not "
 			"add disk 0.\n", h->ctlr);
@@ -1734,7 +1737,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 
 		/* check if the drive was found already in the array */
 		if (!drv_found) {
-			drv_index = cciss_add_gendisk(h, lunid);
+			drv_index = cciss_add_gendisk(h, lunid, 0);
 			if (drv_index == -1)
 				goto freeret;
 		}
