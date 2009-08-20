From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 06/17] Rearrange logical drive sysfs code to make the
	"changing a disk" path work.
Date: Thu, 20 Aug 2009 10:18:13 -0500
Message-ID: <20090820151813.22833.6732.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:48886 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbZHTPSK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 11:18:10 -0400
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com

Rearrange logical drive sysfs code to make the "changing a disk" path work.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4f9ef49..557b958 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1915,9 +1915,10 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 		}
 	}
 	h->drv[drv_index].LunID = lunid;
-	if (cciss_create_ld_sysfs_entry(h, drv_index))
-		goto err_free_disk;
-
+	if (h->drv[drv_index].dev == NULL) {
+		if (cciss_create_ld_sysfs_entry(h, drv_index))
+			goto err_free_disk;
+	}
 	/* Don't need to mark this busy because nobody */
 	/* else knows about this disk yet to contend */
 	/* for access to it. */
@@ -2144,8 +2145,10 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 	 */
 	if (h->gendisk[0] != disk) {
 		struct request_queue *q = disk->queue;
-		if (disk->flags & GENHD_FL_UP)
+		if (disk->flags & GENHD_FL_UP) {
+			cciss_destroy_ld_sysfs_entry(h, drv_index);
 			del_gendisk(disk);
+		}
 		if (q) {
 			blk_cleanup_queue(q);
 			/* Set drv->queue to NULL so that we do not try
@@ -2189,7 +2192,6 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
-	cciss_destroy_ld_sysfs_entry(h, drv_index);
 
 	if (clear_all) {
 		/* check to see if it was the last disk */
@@ -4307,15 +4309,13 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		if (disk) {
 			struct request_queue *q = disk->queue;
 
-			if (disk->flags & GENHD_FL_UP)
+			if (disk->flags & GENHD_FL_UP) {
+				cciss_destroy_ld_sysfs_entry(hba[i], j);
 				del_gendisk(disk);
+			}
 			if (q)
 				blk_cleanup_queue(q);
 		}
-		if (hba[i]->drv[j].dev != NULL &&
-			(j == 0 || hba[i]->drv[j].raid_level != -1))
-				cciss_destroy_ld_sysfs_entry(hba[i], j);
-
 	}
 
 #ifdef CONFIG_CISS_SCSI_TAPE

