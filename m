From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH v4 Repost 2/2] block: modify __bio_add_page check to accept
 pages, that don't start a new segment
Date: Fri, 27 Sep 2013 14:31:35 +0200
Message-ID: <52457AA7.1070609@redhat.com>
References: <524578D5.1030808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <524578D5.1030808@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Cc: viro@zeniv.linux.org.uk, james.bottomley@hansenpartnership.com, Jens Axboe <axboe@kernel.dk>, Kai.Makisara@kolumbus.fi, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, kent.overstreet@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Jan Vesely <jvesely@redhat.com>

The original behavior was to refuse all pages after the maximum number of
segments has been reached. However, some drivers (like st) craft their buffers
to potentially require exactly max segments and multiple pages in the last
segment. This patch modifies the check to allow pages that can be merged into
the last segment.

Fixes EBUSY failures when using large tape block size in high
memory fragmentation condition. This regression was introduced by commit
46081b166415acb66d4b3150ecefcd9460bb48a1
st: Increase success probability in driver buffer allocation

Signed-off-by: Jan Vesely <jvesely@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 fs/bio.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index ea5035d..419bdd6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -603,7 +603,6 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 			  *page, unsigned int len, unsigned int offset,
 			  unsigned short max_sectors)
 {
-	int retried_segments = 0;
 	struct bio_vec *bvec;
 
 	/*
@@ -654,18 +653,12 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 		return 0;
 
 	/*
-	 * we might lose a segment or two here, but rather that than
-	 * make this too complex.
+	 * The first part of the segment count check,
+	 * reduce segment count if possible
 	 */
-
-	while (bio->bi_phys_segments >= queue_max_segments(q)) {
-
-		if (retried_segments)
-			return 0;
-
-		retried_segments = 1;
+	if (bio->bi_phys_segments >= queue_max_segments(q))
 		blk_recount_segments(q, bio);
-	}
+
 
 	/*
 	 * setup the new entry, we might clear it again later if we
@@ -677,6 +670,21 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	bvec->bv_offset = offset;
 
 	/*
+	 * the other part of the segment count check, allow mergeable pages.
+	 * BIO_SEG_VALID flag is cleared below
+	 */
+	if ((bio->bi_phys_segments > queue_max_segments(q)) ||
+	    ((bio->bi_phys_segments == queue_max_segments(q)) &&
+	     !bvec_mergeable(q, __BVEC_END(bio), bvec,
+			     bio->bi_seg_back_size))) {
+			bvec->bv_page = NULL;
+			bvec->bv_len = 0;
+			bvec->bv_offset = 0;
+			return 0;
+	}
+
+
+	/*
 	 * if queue has other restrictions (eg varying max sector size
 	 * depending on offset), it can specify a merge_bvec_fn in the
 	 * queue to get further control
-- 
1.8.3.1
