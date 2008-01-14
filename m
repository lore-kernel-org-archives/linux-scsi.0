From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] SG: work with the SCSI fixed maximum allocations
Date: Mon, 14 Jan 2008 10:04:45 -0600
Message-ID: <1200326685.3159.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48022 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbYANQEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 11:04:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

Boaz pointed out that the current sg table code will bug in the SCSI
index function because it assumes a larger sized allocator that SCSI
possesses.  This patch fixes the issue.

James

---

>From 258aae00284d61786758d9e740df08cc4b916f96 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 13 Jan 2008 14:15:28 -0600
Subject: SG: work with the SCSI fixed maximum allocations

SCSI sg table allocation has a maximum size (of SCSI_MAX_SG_SEGMENTS,
currently 128) and this will cause a BUG_ON() in SCSI if something
tries an allocation over it.  This patch adds a size limit to the
chaining allocator to allow the specification of the maximum
allocation size for chaining, so we always chain in units of the
maximum SCSI allocation size.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_lib.c     |    8 +++++---
 include/linux/scatterlist.h |    5 +++--
 lib/scatterlist.c           |   41 +++++++++++++++++++++++++++--------------
 3 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3c681de..e0f40e6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -773,16 +773,18 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents,
 
 	BUG_ON(!nents);
 
-	ret = __sg_alloc_table(&sdb->table, nents, gfp_mask, scsi_sg_alloc);
+	ret = __sg_alloc_table(&sdb->table, nents, SCSI_MAX_SG_SEGMENTS,
+			       gfp_mask, scsi_sg_alloc);
 	if (unlikely(ret))
-		__sg_free_table(&sdb->table, scsi_sg_free);
+		__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS,
+				scsi_sg_free);
 
 	return ret;
 }
 
 static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
 {
-	__sg_free_table(&sdb->table, scsi_sg_free);
+	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, scsi_sg_free);
 }
 
 /*
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index e9cb103..a3d567a 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -207,9 +207,10 @@ void sg_init_one(struct scatterlist *, const void *, unsigned int);
 typedef struct scatterlist *(sg_alloc_fn)(unsigned int, gfp_t);
 typedef void (sg_free_fn)(struct scatterlist *, unsigned int);
 
-void __sg_free_table(struct sg_table *, sg_free_fn *);
+void __sg_free_table(struct sg_table *, unsigned int, sg_free_fn *);
 void sg_free_table(struct sg_table *);
-int __sg_alloc_table(struct sg_table *, unsigned int, gfp_t, sg_alloc_fn *);
+int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
+		     sg_alloc_fn *);
 int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
 
 /*
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 02aaa27..acca490 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -130,13 +130,17 @@ static void sg_kfree(struct scatterlist *sg, unsigned int nents)
 /**
  * __sg_free_table - Free a previously mapped sg table
  * @table:	The sg table header to use
+ * @max_ents:	The maximum number of entries per single scatterlist
  * @free_fn:	Free function
  *
  *  Description:
- *    Free an sg table previously allocated and setup with __sg_alloc_table().
+ *    Free an sg table previously allocated and setup with
+ *    __sg_alloc_table().  The @max_ents value must be identical to
+ *    that previously used with __sg_alloc_table().
  *
  **/
-void __sg_free_table(struct sg_table *table, sg_free_fn *free_fn)
+void __sg_free_table(struct sg_table *table, unsigned int max_ents,
+		     sg_free_fn *free_fn)
 {
 	struct scatterlist *sgl, *next;
 
@@ -149,14 +153,14 @@ void __sg_free_table(struct sg_table *table, sg_free_fn *free_fn)
 		unsigned int sg_size;
 
 		/*
-		 * If we have more than SG_MAX_SINGLE_ALLOC segments left,
+		 * If we have more than max_ents segments left,
 		 * then assign 'next' to the sg table after the current one.
 		 * sg_size is then one less than alloc size, since the last
 		 * element is the chain pointer.
 		 */
-		if (alloc_size > SG_MAX_SINGLE_ALLOC) {
-			next = sg_chain_ptr(&sgl[SG_MAX_SINGLE_ALLOC - 1]);
-			alloc_size = SG_MAX_SINGLE_ALLOC;
+		if (alloc_size > max_ents) {
+			next = sg_chain_ptr(&sgl[max_ents - 1]);
+			alloc_size = max_ents;
 			sg_size = alloc_size - 1;
 		} else {
 			sg_size = alloc_size;
@@ -179,7 +183,7 @@ EXPORT_SYMBOL(__sg_free_table);
  **/
 void sg_free_table(struct sg_table *table)
 {
-	__sg_free_table(table, sg_kfree);
+	__sg_free_table(table, SG_MAX_SINGLE_ALLOC, sg_kfree);
 }
 EXPORT_SYMBOL(sg_free_table);
 
@@ -187,22 +191,30 @@ EXPORT_SYMBOL(sg_free_table);
  * __sg_alloc_table - Allocate and initialize an sg table with given allocator
  * @table:	The sg table header to use
  * @nents:	Number of entries in sg list
+ * @max_ents:	The maximum number of entries the allocator returns per call
  * @gfp_mask:	GFP allocation mask
  * @alloc_fn:	Allocator to use
  *
+ * Description:
+ *   This function returns a @table @nents long. The allocator is
+ *   defined to return scatterlist chunks of maximum size @max_ents.
+ *   Thus if @nents is bigger than @max_ents, the scatterlists will be
+ *   chained in units of @max_ents.
+ *
  * Notes:
  *   If this function returns non-0 (eg failure), the caller must call
  *   __sg_free_table() to cleanup any leftover allocations.
  *
  **/
-int __sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask,
+int __sg_alloc_table(struct sg_table *table, unsigned int nents,
+		     unsigned int max_ents, gfp_t gfp_mask,
 		     sg_alloc_fn *alloc_fn)
 {
 	struct scatterlist *sg, *prv;
 	unsigned int left;
 
 #ifndef ARCH_HAS_SG_CHAIN
-	BUG_ON(nents > SG_MAX_SINGLE_ALLOC);
+	BUG_ON(nents > max_ents);
 #endif
 
 	memset(table, 0, sizeof(*table));
@@ -212,8 +224,8 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask,
 	do {
 		unsigned int sg_size, alloc_size = left;
 
-		if (alloc_size > SG_MAX_SINGLE_ALLOC) {
-			alloc_size = SG_MAX_SINGLE_ALLOC;
+		if (alloc_size > max_ents) {
+			alloc_size = max_ents;
 			sg_size = alloc_size - 1;
 		} else
 			sg_size = alloc_size;
@@ -232,7 +244,7 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask,
 		 * If this is not the first mapping, chain previous part.
 		 */
 		if (prv)
-			sg_chain(prv, SG_MAX_SINGLE_ALLOC, sg);
+			sg_chain(prv, max_ents, sg);
 		else
 			table->sgl = sg;
 
@@ -272,9 +284,10 @@ int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
 {
 	int ret;
 
-	ret = __sg_alloc_table(table, nents, gfp_mask, sg_kmalloc);
+	ret = __sg_alloc_table(table, nents, SG_MAX_SINGLE_ALLOC,
+			       gfp_mask, sg_kmalloc);
 	if (unlikely(ret))
-		__sg_free_table(table, sg_kfree);
+		__sg_free_table(table, SG_MAX_SINGLE_ALLOC, sg_kfree);
 
 	return ret;
 }
-- 
1.5.3.7



