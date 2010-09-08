From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 42/41 v2] dm: convey that all flushes are processed as empty
Date: Tue, 7 Sep 2010 22:04:30 -0400
Message-ID: <20100908020429.GA24635@redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org>
 <4C84CD18.6060906@redhat.com>
 <20100907211724.GA22525@redhat.com>
 <20100907221543.GB22525@redhat.com>
 <20100907234918.GA23921@redhat.com>
 <20100908000001.GA21552@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100908000001.GA21552@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, jack@suse.cz, mst@redhat.com, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, k-ueda@ct.jp.nec.com, vst@vlnb.net, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, linux-raid@vger.kernel.org, mpatocka@redhat.com, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Rename __clone_and_map_flush to __clone_and_map_empty_flush for added
clarity.

Simplify logic associated with REQ_FLUSH conditionals.

Introduce a BUG_ON() and add a few more helpful comments to the code
so that it is clear that all flushes are empty.

Cleanup __split_and_process_bio() so that an empty flush isn't processed
by a 'sector_count' focused while loop.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

Tejun, please feel free to fold this patch into (or insert after)
0025-dm-relax-ordering-of-bio-based-flush-implementation.patch

v2: Simplify logic associated with REQ_FLUSH conditionals

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index cd2f7e7..f934e98 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -621,16 +621,17 @@ static void dec_pending(struct dm_io *io, int error)
 		if (io_error == DM_ENDIO_REQUEUE)
 			return;
 
-		if (!(bio->bi_rw & REQ_FLUSH) || !bio->bi_size) {
-			trace_block_bio_complete(md->queue, bio);
-			bio_endio(bio, io_error);
-		} else {
+		if ((bio->bi_rw & REQ_FLUSH) && bio->bi_size) {
 			/*
 			 * Preflush done for flush with data, reissue
 			 * without REQ_FLUSH.
 			 */
 			bio->bi_rw &= ~REQ_FLUSH;
 			queue_io(md, bio);
+		} else {
+			/* done with normal IO or empty flush */
+			trace_block_bio_complete(md->queue, bio);
+			bio_endio(bio, io_error);
 		}
 	}
 }
@@ -1132,16 +1133,15 @@ static void __issue_target_requests(struct clone_info *ci, struct dm_target *ti,
 		__issue_target_request(ci, ti, request_nr, len);
 }
 
-static int __clone_and_map_flush(struct clone_info *ci)
+static int __clone_and_map_empty_flush(struct clone_info *ci)
 {
 	unsigned target_nr = 0;
 	struct dm_target *ti;
 
+	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
 		__issue_target_requests(ci, ti, ti->num_flush_requests, 0);
 
-	ci->sector_count = 0;
-
 	return 0;
 }
 
@@ -1282,7 +1282,6 @@ static int __clone_and_map(struct clone_info *ci)
  */
 static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
 {
-	bool is_flush = bio->bi_rw & REQ_FLUSH;
 	struct clone_info ci;
 	int error = 0;
 
@@ -1302,20 +1301,17 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
 	ci.sector = bio->bi_sector;
 	ci.idx = bio->bi_idx;
 
-	if (!is_flush) {
+	start_io_acct(ci.io);
+	if (bio->bi_rw & REQ_FLUSH) {
+		ci.bio = &ci.md->flush_bio;
+		ci.sector_count = 0;
+		error = __clone_and_map_empty_flush(&ci);
+		/* dec_pending submits any data associated with flush */
+	} else {
 		ci.bio = bio;
 		ci.sector_count = bio_sectors(bio);
-	} else {
-		ci.bio = &ci.md->flush_bio;
-		ci.sector_count = 1;
-	}
-
-	start_io_acct(ci.io);
-	while (ci.sector_count && !error) {
-		if (!is_flush)
+		while (ci.sector_count && !error)
 			error = __clone_and_map(&ci);
-		else
-			error = __clone_and_map_flush(&ci);
 	}
 
 	/* drop the extra reference count */
