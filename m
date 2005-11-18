From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 3/3] cciss: add put_disk into cleanup routines
Date: Fri, 18 Nov 2005 11:46:55 -0600
Message-ID: <20051118174655.GA22116@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161028AbVKRRrO@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@osdl.org, axboe@suse.de, jgarzick@pobox.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Patch 3 of 3

Jeff Garzik pointed me to his code to see how to remove a disk from
the system _properly_. Well, here it is...
Every place we remove disks we are now testing before calling del_gendisk
or blk_cleanup_queue and then call put_disk.

Signed-off-by: Mike Miller <mike.miller@hp.com>
--------------------------------------------------------------------------------

 drivers/block/cciss.c       |   33 ++++++++++++++++++++++++---------
 include/linux/cciss_ioctl.h |    2 +-
 2 files changed, 25 insertions(+), 10 deletions(-)

diff -L cciss.c -puN /dev/null /dev/null
diff -puN drivers/block/cciss.c~cciss_del_gendisk_fixes drivers/block/cciss.c
--- linux-2.6.14.2-save/drivers/block/cciss.c~cciss_del_gendisk_fixes	2005-11-15 15:49:39.000000000 -0600
+++ linux-2.6.14.2-save-mikem/drivers/block/cciss.c	2005-11-18 10:54:52.459084088 -0600
@@ -1138,8 +1138,15 @@ static int revalidate_allvol(ctlr_info_t
 
 	for(i=0; i< NWD; i++) {
 		struct gendisk *disk = host->gendisk[i];
-		if (disk->flags & GENHD_FL_UP)
-			del_gendisk(disk);
+		if (disk) {
+			request_queue_t *q = disk->queue;
+
+			if (disk->flags & GENHD_FL_UP)
+				del_gendisk(disk);
+			if (q)
+				blk_cleanup_queue(q);
+			put_disk(disk);
+		}
 	}
 
         /*
@@ -1453,10 +1460,13 @@ static int deregister_disk(struct gendis
 	 * allows us to delete disk zero but keep the controller registered.
 	*/
 	if (h->gendisk[0] != disk){
-		if (disk->flags & GENHD_FL_UP){
-			blk_cleanup_queue(disk->queue);
-		del_gendisk(disk);
-			drv->queue = NULL;
+		if (disk) {
+			request_queue_t *q = disk->queue;
+			if (disk->flags & GENHD_FL_UP)
+				del_gendisk(disk);
+			if (q)	
+				blk_cleanup_queue(q);
+			put_disk(disk);	
 		}
 	}
 
@@ -3094,9 +3104,14 @@ static void __devexit cciss_remove_one (
 	/* remove it from the disk list */
 	for (j = 0; j < NWD; j++) {
 		struct gendisk *disk = hba[i]->gendisk[j];
-		if (disk->flags & GENHD_FL_UP) {
-			del_gendisk(disk);
-			blk_cleanup_queue(disk->queue);
+		if (disk) {
+			request_queue_t *q = disk->queue;
+
+			if (disk->flags & GENHD_FL_UP) 
+				del_gendisk(disk);
+			if (q)
+				blk_cleanup_queue(q);
+			put_disk(disk);
 		}
 	}
 
