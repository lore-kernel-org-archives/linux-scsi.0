From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/2 version 4] osdblk: a Linux block device for OSD objects
Date: Thu, 21 May 2009 17:06:46 +0300
Message-ID: <4A155FF6.3060005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:10101 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754609AbZEUOGy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2009 10:06:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Jens Axboe <jens.axboe@oracle.com>

I'm posting for review a new version of the osdblk driver. What's new?

* Once block/for-2.6.31 and all pending osd patches hit mainline. this new version
  is ready for submission.
  - The relevant osd patches have been posted on the mailing list, but I'll send an orderly
    set for scsi-misc and scsi-post-merge on Sunday.
  - All the prerequisite block patches are already in Jens's tree.

* Below is the diff from Jeff's last version of the patch. these things have changed:
 {SQUASHME: osdblk} Block and OSD Api fixups and bug fixes

 - Block API changes from Tejuns revamps
 - OSD Api changes for supporting bio-chaining
 - do_flush requests do not need bio clonning
   (And might not have any so prevent such a crash)
 - osdblk_make_credential is here to stay
 - Use bio_kmalloc and avoid the bio_alloc dead/live locks.
   TODO: Split request into smaller chunks if allocations fail.
 - Only use __GFP_WAIT on first bio allocation. (Not relevant since
   __GFP_WAIT is not used)

* Added an extra patch:
 - [PATCH 2/2] osdblk: Adjust queue limits to lower device's limits

This is ontop of the post-merge tree. Jeff? will you push this driver
through your tree?

What is left is to bang some serious testing on this driver. I'll do
that next.

Thanks
Boaz
---
 drivers/block/osdblk.c |   48 +++++++++++++++++++++---------------------------
 1 files changed, 21 insertions(+), 27 deletions(-)
---
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index c7a1bb7..531d234 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -118,13 +118,13 @@ static struct block_device_operations osdblk_bd_ops = {
 static const struct osd_attr g_attr_logical_length = ATTR_DEF(
 	OSD_APAGE_OBJECT_INFORMATION, OSD_ATTR_OI_LOGICAL_LENGTH, 8);
 
-/* copied from exofs; move to libosd? */
-static void osd_make_credential(u8 cred_a[OSD_CAP_LEN],
-				const struct osd_obj_id *obj)
+static void osdblk_make_credential(u8 cred_a[OSD_CAP_LEN],
+				   const struct osd_obj_id *obj)
 {
 	osd_sec_init_nosec_doall_caps(cred_a, obj, false, true);
 }
 
+/* copied from exofs; move to libosd? */
 /*
  * Perform a synchronous OSD operation.  copied from exofs; move to libosd?
  */
@@ -216,17 +216,6 @@ out:
 
 }
 
-static void osdblk_end_request(struct osdblk_device *osdev,
-			       struct osdblk_request *orq,
-			       int error)
-{
-	struct request *rq = orq->rq;
-	int rc;
-
-	/* complete request, at block layer */
-	rc = __blk_end_request(rq, error, blk_rq_bytes(rq));
-}
-
 static void osdblk_osd_complete(struct osd_request *or, void *private)
 {
 	struct osdblk_request *orq = private;
@@ -240,7 +229,7 @@ static void osdblk_osd_complete(struct osd_request *or, void *private)
 	osd_end_request(or);
 
 	/* complete request passed to osdblk by block layer */
-	osdblk_end_request(orq->osdev, orq, ret);
+	__blk_end_request_all(orq->rq, ret);
 }
 
 static void bio_chain_put(struct bio *chain)
@@ -260,10 +249,12 @@ static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
 	struct bio *tmp, *new_chain = NULL, *tail = NULL;
 
 	while (old_chain) {
-		tmp = bio_clone(old_chain, gfpmask);
+		tmp = bio_kmalloc(gfpmask, old_chain->bi_vcnt);
 		if (!tmp)
 			goto err_out;
 
+		__bio_clone(tmp, old_chain);
+		gfpmask &= ~__GFP_WAIT;
 		tmp->bi_next = NULL;
 		if (!new_chain)
 			new_chain = tail = tmp;
@@ -293,13 +284,13 @@ static void osdblk_rq_fn(struct request_queue *q)
 
 	while (1) {
 		/* peek at request from block layer */
-		rq = elv_next_request(q);
+		rq = blk_fetch_request(q);
 		if (!rq)
 			break;
 
 		/* filter out block requests we don't understand */
 		if (!blk_fs_request(rq) && !blk_barrier_rq(rq)) {
-			end_request(rq, 0);
+			blk_end_request_all(rq, 0);
 			continue;
 		}
 
@@ -313,10 +304,13 @@ static void osdblk_rq_fn(struct request_queue *q)
 		do_flush = (rq->special == (void *) 0xdeadbeefUL);
 		do_write = (rq_data_dir(rq) == WRITE);
 
-		/* a bio clone to be passed down to OSD request */
-		bio = bio_chain_clone(rq->bio, GFP_ATOMIC);
-		if (!bio)
-			break;
+		if (!do_flush) { /* osd_flush does not use a bio */
+			/* a bio clone to be passed down to OSD request */
+			bio = bio_chain_clone(rq->bio, GFP_ATOMIC);
+			if (!bio)
+				break;
+		} else
+			bio = NULL;
 
 		/* alloc internal OSD request, for OSD command execution */
 		or = osd_start_request(osdev->osd, GFP_ATOMIC);
@@ -335,11 +329,11 @@ static void osdblk_rq_fn(struct request_queue *q)
 			osd_req_flush_object(or, &osdev->obj,
 					     OSD_CDB_FLUSH_ALL, 0, 0);
 		else if (do_write)
-			osd_req_write(or, &osdev->obj, bio,
-				      rq->sector * 512ULL);
+			osd_req_write(or, &osdev->obj, blk_rq_pos(rq) * 512ULL,
+				      bio, blk_rq_bytes(rq));
 		else
-			osd_req_read(or, &osdev->obj, bio,
-				     rq->sector * 512ULL);
+			osd_req_read(or, &osdev->obj, blk_rq_pos(rq) * 512ULL,
+				     bio, blk_rq_bytes(rq));
 
 		/* begin OSD command execution */
 		if (osd_async_op(or, osdblk_osd_complete, orq,
@@ -527,7 +521,7 @@ static ssize_t class_osdblk_add(struct class *c, const char *buf, size_t count)
 	}
 
 	/* build OSD credential */
-	osd_make_credential(osdev->obj_cred, &osdev->obj);
+	osdblk_make_credential(osdev->obj_cred, &osdev->obj);
 
 	/* register our block device */
 	irc = register_blkdev(0, osdev->name);
