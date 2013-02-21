From: Jan Vesely <jvesely@redhat.com>
Subject: [PATCH] block: modify __bio_add_page check to accept pages that don't
 start a new segment
Date: Thu, 21 Feb 2013 09:30:26 +0100
Message-ID: <5125DB22.7020901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

The original behavior was to refuse all pages after the maximum number of
segments has been reached. However, some drivers (like st) craft their buffers
to potentially require exactly max segments and multiple pages in the last
segment. This patch modifies the check to allow pages that can be merged into
the last segment.

This change fixes EBUSY failures when using large (1mb) tape block size in high
memory fragmentation condition.

Signed-off-by: Jan Vesely <jvesely@redhat.com>
---
  fs/bio.c |   26 ++++++++++++++++----------
  1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b96fc6c..02efbd5 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -500,7 +500,6 @@ static int __bio_add_page(struct request_queue *q, struct 
bio *bio, struct page
  			  *page, unsigned int len, unsigned int offset,
  			  unsigned short max_sectors)
  {
-	int retried_segments = 0;
  	struct bio_vec *bvec;

  	/*
@@ -551,18 +550,12 @@ static int __bio_add_page(struct request_queue *q, struct 
bio *bio, struct page
  		return 0;

  	/*
-	 * we might lose a segment or two here, but rather that than
-	 * make this too complex.
+	 * prepare segment count check, reduce segment count if possible
  	 */

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
@@ -572,6 +565,19 @@ static int __bio_add_page(struct request_queue *q, struct 
bio *bio, struct page
  	bvec->bv_page = page;
  	bvec->bv_len = len;
  	bvec->bv_offset = offset;
+	
+	/*
+	 * the other part of the segment count check, allow mergeable pages
+	 */
+	if ((bio->bi_phys_segments > queue_max_segments(q)) ||
+		( (bio->bi_phys_segments == queue_max_segments(q)) &&
+		!BIOVEC_PHYS_MERGEABLE(bvec - 1, bvec))) {
+			bvec->bv_page = NULL;
+			bvec->bv_len = 0;
+			bvec->bv_offset = 0;
+			return 0;
+	}
+

  	/*
  	 * if queue has other restrictions (eg varying max sector size
-- 
1.7.1
