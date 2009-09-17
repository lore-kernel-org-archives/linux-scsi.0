From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 09/20] cciss: Handle special case for sysfs attributes of the
	first logical drive.
Date: Thu, 17 Sep 2009 13:47:34 -0500
Message-ID: <20090917184734.15105.71632.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40922 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758222AbZIQSrG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 14:47:06 -0400
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

For c0dx where x is not 0, we handle deletion and addition simply,
but for c0d0, there is the special case that even when there's no
disk, the device node exists so that the controller may be accessed.
So, for c0d0, we only create the sysfs entries once, when a controller
is added, and only remove them once, when a controller is being
taken down.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7043b3b..98d8efe 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -681,6 +681,10 @@ static long cciss_create_ld_sysfs_entry(struct ctlr_info *h,
 {
 	struct device *dev;
 
+	/* Special case for c*d0, we only create it once. */
+	if (drv_index == 0 && h->drv[drv_index].dev != NULL)
+		return 0;
+
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
@@ -697,9 +701,15 @@ static long cciss_create_ld_sysfs_entry(struct ctlr_info *h,
 /*
  * Remove sysfs entries for a logical drive.
  */
-static void cciss_destroy_ld_sysfs_entry(struct ctlr_info *h, int drv_index)
+static void cciss_destroy_ld_sysfs_entry(struct ctlr_info *h, int drv_index,
+	int ctlr_exiting)
 {
 	struct device *dev = h->drv[drv_index].dev;
+
+	/* special case for c*d0, we only destroy it on controller exit */
+	if (drv_index == 0 && !ctlr_exiting)
+		return;
+
 	device_del(dev);
 	put_device(dev); /* the "final" put. */
 	h->drv[drv_index].dev = NULL;
@@ -1919,6 +1929,7 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 	drv_index = cciss_find_free_drive_index(h->ctlr, controller_node);
 	if (drv_index == -1)
 		return -1;
+
 	/*Check if the gendisk needs to be allocated */
 	if (!h->gendisk[drv_index]) {
 		h->gendisk[drv_index] =
@@ -2164,7 +2175,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 	if (h->gendisk[0] != disk) {
 		struct request_queue *q = disk->queue;
 		if (disk->flags & GENHD_FL_UP) {
-			cciss_destroy_ld_sysfs_entry(h, drv_index);
+			cciss_destroy_ld_sysfs_entry(h, drv_index, 0);
 			del_gendisk(disk);
 		}
 		if (q) {
@@ -2210,7 +2221,6 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
-
 	if (clear_all) {
 		/* check to see if it was the last disk */
 		if (drv == h->drv + h->highest_lun) {
@@ -4328,7 +4338,7 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 			struct request_queue *q = disk->queue;
 
 			if (disk->flags & GENHD_FL_UP) {
-				cciss_destroy_ld_sysfs_entry(hba[i], j);
+				cciss_destroy_ld_sysfs_entry(hba[i], j, 1);
 				del_gendisk(disk);
 			}
 			if (q)

