From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm kcopyd: add WRITE SAME support to dm_kcopyd_zero
Date: Fri, 2 Mar 2012 09:24:53 -0500
Message-ID: <20120302142453.GA13333@redhat.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab2CBOZG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Mar 2012 09:25:06 -0500
Content-Disposition: inline
In-Reply-To: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, vgoyal@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

WRITE SAME is a SCSI command that can be leveraged for more efficient
zeroing of a specified logical extent of a device which supports it.
Only a single zeroed logical block is transfered to the target for each
WRITE SAME and the target then writes that same block across the
specified extent.

Add WRITE SAME support to dm-io and make it accessible to
dm_kcopyd_zero().  dm_kcopyd_zero() provides an asynchronous interface
whereas the blkdev_issue_write_same() interface is synchronous.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-io.c     |   23 ++++++++++++++++++-----
 drivers/md/dm-kcopyd.c |   18 +++++++++++++++---
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index ea5dd28..32e19e3 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -297,7 +297,8 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 	unsigned num_bvecs;
 	sector_t remaining = where->count;
 	struct request_queue *q = bdev_get_queue(where->bdev);
-	sector_t discard_sectors;
+	unsigned short logical_block_size = queue_logical_block_size(q);
+	sector_t num_sectors;
 
 	/*
 	 * where->count may be zero if rw holds a flush and we need to
@@ -307,7 +308,7 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		/*
 		 * Allocate a suitably sized-bio.
 		 */
-		if (rw & REQ_DISCARD)
+		if ((rw & REQ_DISCARD) || (rw & REQ_WRITE_SAME))
 			num_bvecs = 1;
 		else
 			num_bvecs = min_t(int, bio_get_nr_vecs(where->bdev),
@@ -321,9 +322,21 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		store_io_and_region_in_bio(bio, io, region);
 
 		if (rw & REQ_DISCARD) {
-			discard_sectors = min_t(sector_t, q->limits.max_discard_sectors, remaining);
-			bio->bi_size = discard_sectors << SECTOR_SHIFT;
-			remaining -= discard_sectors;
+			num_sectors = min_t(sector_t, q->limits.max_discard_sectors, remaining);
+			bio->bi_size = num_sectors << SECTOR_SHIFT;
+			remaining -= num_sectors;
+		} else if (rw & REQ_WRITE_SAME) {
+			/*
+			 * WRITE SAME only uses a single page.
+			 */
+			dp->get_page(dp, &page, &len, &offset);
+			bio_add_page(bio, page, logical_block_size, offset);
+			num_sectors = min_t(sector_t, q->limits.max_write_same_sectors, remaining);
+			bio->bi_size = num_sectors << SECTOR_SHIFT;
+
+			offset = 0;
+			remaining -= num_sectors;
+			dp->next_page(dp);
 		} else while (remaining) {
 			/*
 			 * Try and add as many pages as possible.
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index bed444c..3cd00aa 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -349,7 +349,7 @@ static void complete_io(unsigned long error, void *context)
 	struct dm_kcopyd_client *kc = job->kc;
 
 	if (error) {
-		if (job->rw == WRITE)
+		if (job->rw & WRITE)
 			job->write_err |= error;
 		else
 			job->read_err = 1;
@@ -361,7 +361,7 @@ static void complete_io(unsigned long error, void *context)
 		}
 	}
 
-	if (job->rw == WRITE)
+	if (job->rw & WRITE)
 		push(&kc->complete_jobs, job);
 
 	else {
@@ -432,7 +432,7 @@ static int process_jobs(struct list_head *jobs, struct dm_kcopyd_client *kc,
 
 		if (r < 0) {
 			/* error this rogue job */
-			if (job->rw == WRITE)
+			if (job->rw & WRITE)
 				job->write_err = (unsigned long) -1L;
 			else
 				job->read_err = 1;
@@ -608,10 +608,22 @@ int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		job->pages = NULL;
 		job->rw = READ;
 	} else {
+		int i;
+
 		memset(&job->source, 0, sizeof job->source);
 		job->source.count = job->dests[0].count;
 		job->pages = &zero_page_list;
 		job->rw = WRITE;
+		/*
+		 * Optimize zeroing via WRITE SAME if all dests support it.
+		 */
+		job->rw |= REQ_WRITE_SAME;
+		for (i = 0; i < job->num_dests; i++) {
+			if (!bdev_write_same(job->dests[i].bdev)) {
+				job->rw &= ~REQ_WRITE_SAME;
+				break;
+			}
+		}
 	}
 
 	job->fn = fn;
-- 
1.7.4.4

