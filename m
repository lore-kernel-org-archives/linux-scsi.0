From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/14] scatterlist: allow chaining to preallocated chunks
Date: Thu, 12 Jun 2014 15:49:04 +0200
Message-ID: <1402580946-11470-13-git-send-email-hch@lst.de>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1402580946-11470-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Blk-mq drivers usually preallocate their S/G list as part of the request,
but if we want to support the very large S/G lists currently supported by
the SCSI code that would tie up a lot of memory in the preallocated request
pool.  Add support to the scatterlist code so that it can initialize a
S/G list that uses a preallocated first chunks and dynamically allocated
additional chunks.  That way the scsi-mq code can preallocate a first
page worth of S/G entries as part of the request, and dynamically extent
the S/G list when needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c     |   16 +++++++---------
 include/linux/scatterlist.h |    6 +++---
 lib/scatterlist.c           |   24 ++++++++++++++++--------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e438726..32fbae4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -567,6 +567,11 @@ static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
 	return mempool_alloc(sgp->pool, gfp_mask);
 }
 
+static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
+{
+	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, false, scsi_sg_free);
+}
+
 static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents,
 			      gfp_t gfp_mask)
 {
@@ -575,19 +580,12 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents,
 	BUG_ON(!nents);
 
 	ret = __sg_alloc_table(&sdb->table, nents, SCSI_MAX_SG_SEGMENTS,
-			       gfp_mask, scsi_sg_alloc);
+			       NULL, gfp_mask, scsi_sg_alloc);
 	if (unlikely(ret))
-		__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS,
-				scsi_sg_free);
-
+		scsi_free_sgtable(sdb);
 	return ret;
 }
 
-static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
-{
-	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, scsi_sg_free);
-}
-
 /*
  * Function:    scsi_release_buffers()
  *
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index a964f72..f4ec8bb 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -229,10 +229,10 @@ void sg_init_one(struct scatterlist *, const void *, unsigned int);
 typedef struct scatterlist *(sg_alloc_fn)(unsigned int, gfp_t);
 typedef void (sg_free_fn)(struct scatterlist *, unsigned int);
 
-void __sg_free_table(struct sg_table *, unsigned int, sg_free_fn *);
+void __sg_free_table(struct sg_table *, unsigned int, bool, sg_free_fn *);
 void sg_free_table(struct sg_table *);
-int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
-		     sg_alloc_fn *);
+int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int,
+		     struct scatterlist *, gfp_t, sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
 int sg_alloc_table_from_pages(struct sg_table *sgt,
 	struct page **pages, unsigned int n_pages,
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 3a8e8e8..48c15d2 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -165,6 +165,7 @@ static void sg_kfree(struct scatterlist *sg, unsigned int nents)
  * __sg_free_table - Free a previously mapped sg table
  * @table:	The sg table header to use
  * @max_ents:	The maximum number of entries per single scatterlist
+ * @skip_first_chunk: don't free the (preallocated) first scatterlist chunk
  * @free_fn:	Free function
  *
  *  Description:
@@ -174,7 +175,7 @@ static void sg_kfree(struct scatterlist *sg, unsigned int nents)
  *
  **/
 void __sg_free_table(struct sg_table *table, unsigned int max_ents,
-		     sg_free_fn *free_fn)
+		     bool skip_first_chunk, sg_free_fn *free_fn)
 {
 	struct scatterlist *sgl, *next;
 
@@ -202,7 +203,9 @@ void __sg_free_table(struct sg_table *table, unsigned int max_ents,
 		}
 
 		table->orig_nents -= sg_size;
-		free_fn(sgl, alloc_size);
+		if (!skip_first_chunk)
+			free_fn(sgl, alloc_size);
+		skip_first_chunk = false;
 		sgl = next;
 	}
 
@@ -217,7 +220,7 @@ EXPORT_SYMBOL(__sg_free_table);
  **/
 void sg_free_table(struct sg_table *table)
 {
-	__sg_free_table(table, SG_MAX_SINGLE_ALLOC, sg_kfree);
+	__sg_free_table(table, SG_MAX_SINGLE_ALLOC, false, sg_kfree);
 }
 EXPORT_SYMBOL(sg_free_table);
 
@@ -241,8 +244,8 @@ EXPORT_SYMBOL(sg_free_table);
  *
  **/
 int __sg_alloc_table(struct sg_table *table, unsigned int nents,
-		     unsigned int max_ents, gfp_t gfp_mask,
-		     sg_alloc_fn *alloc_fn)
+		     unsigned int max_ents, struct scatterlist *first_chunk,
+		     gfp_t gfp_mask, sg_alloc_fn *alloc_fn)
 {
 	struct scatterlist *sg, *prv;
 	unsigned int left;
@@ -269,7 +272,12 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 
 		left -= sg_size;
 
-		sg = alloc_fn(alloc_size, gfp_mask);
+		if (first_chunk) {
+			sg = first_chunk;
+			first_chunk = NULL;
+		} else {
+			sg = alloc_fn(alloc_size, gfp_mask);
+		}
 		if (unlikely(!sg)) {
 			/*
 			 * Adjust entry count to reflect that the last
@@ -324,9 +332,9 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 	int ret;
 
 	ret = __sg_alloc_table(table, nents, SG_MAX_SINGLE_ALLOC,
-			       gfp_mask, sg_kmalloc);
+			       NULL, gfp_mask, sg_kmalloc);
 	if (unlikely(ret))
-		__sg_free_table(table, SG_MAX_SINGLE_ALLOC, sg_kfree);
+		__sg_free_table(table, SG_MAX_SINGLE_ALLOC, false, sg_kfree);
 
 	return ret;
 }
-- 
1.7.10.4
