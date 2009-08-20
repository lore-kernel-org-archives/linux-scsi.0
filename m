From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 08/17] Handle cases when cciss_add_disk fails.
Date: Thu, 20 Aug 2009 10:18:23 -0500
Message-ID: <20090820151823.22833.20640.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:48934 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZHTPSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 11:18:21 -0400
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com

Handle cases when cciss_add_disk fails.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   35 +++++++++++++++++++++++++----------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 60fe3c6..7043b3b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -199,6 +199,7 @@ static int scan_thread(void *data);
 static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
 static void cciss_hba_release(struct device *dev);
 static void cciss_device_release(struct device *dev);
+static void cciss_free_gendisk(ctlr_info_t *h, int drv_index);
 
 #ifdef CONFIG_PROC_FS
 static void cciss_procinit(int i);
@@ -1855,8 +1856,14 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time)
 	 * (raid_leve == -1) then we want to update the
 	 * logical drive's information.
 	 */
-	if (drv_index || first_time)
-		cciss_add_disk(h, disk, drv_index);
+	if (drv_index || first_time) {
+		if (cciss_add_disk(h, disk, drv_index) != 0) {
+			cciss_free_gendisk(h, drv_index);
+			printk(KERN_WARNING "cciss:%d could not update "
+				"disk %d\n", h->ctlr, drv_index);
+			--h->num_luns;
+		}
+	}
 
 freeret:
 	kfree(inq_buff);
@@ -1890,6 +1897,12 @@ static int cciss_find_free_drive_index(int ctlr, int controller_node)
 	return -1;
 }
 
+static void cciss_free_gendisk(ctlr_info_t *h, int drv_index)
+{
+	put_disk(h->gendisk[drv_index]);
+	h->gendisk[drv_index] = NULL;
+}
+
 /* cciss_add_gendisk finds a free hba[]->drv structure
  * and allocates a gendisk if needed, and sets the lunid
  * in the drvinfo structure.   It returns the index into
@@ -1930,8 +1943,7 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 	return drv_index;
 
 err_free_disk:
-	put_disk(h->gendisk[drv_index]);
-	h->gendisk[drv_index] = NULL;
+	cciss_free_gendisk(h, drv_index);
 	return -1;
 }
 
@@ -1949,11 +1961,8 @@ static void cciss_add_controller_node(ctlr_info_t *h)
 		return;
 
 	drv_index = cciss_add_gendisk(h, 0, 1);
-	if (drv_index == -1) {
-		printk(KERN_WARNING "cciss%d: could not "
-			"add disk 0.\n", h->ctlr);
-		return;
-	}
+	if (drv_index == -1)
+		goto error;
 	h->drv[drv_index].block_size = 512;
 	h->drv[drv_index].nr_blocks = 0;
 	h->drv[drv_index].heads = 0;
@@ -1962,7 +1971,13 @@ static void cciss_add_controller_node(ctlr_info_t *h)
 	h->drv[drv_index].raid_level = -1;
 	memset(h->drv[drv_index].serial_no, 0, 16);
 	disk = h->gendisk[drv_index];
-	cciss_add_disk(h, disk, drv_index);
+	if (cciss_add_disk(h, disk, drv_index) == 0)
+		return;
+	cciss_free_gendisk(h, drv_index);
+error:
+	printk(KERN_WARNING "cciss%d: could not "
+		"add disk 0.\n", h->ctlr);
+	return;
 }
 
 /* This function will add and remove logical drives from the Logical

