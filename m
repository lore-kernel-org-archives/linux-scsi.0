From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 02 of 16] Globalize bio_set and bio_vec_slab
Date: Fri, 25 Apr 2008 19:12:04 -0400
Message-ID: <b9f133a520eaf20a1792.1209165124@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44309 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019AbYDYXR1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:27 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

2 files changed, 38 insertions(+), 28 deletions(-)
fs/bio.c            |   36 ++++++++----------------------------
include/linux/bio.h |   30 ++++++++++++++++++++++++++++++


Move struct bio_set and biovec_slab definitions to bio.h so they can
be used outside of bio.c.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r eb54ccf75103 -r b9f133a520ea fs/bio.c
--- a/fs/bio.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/fs/bio.c	Fri Apr 25 17:39:29 2008 -0400
@@ -28,24 +28,9 @@
 #include <linux/blktrace_api.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
-#define BIO_POOL_SIZE 2
-
 static struct kmem_cache *bio_slab __read_mostly;
 
-#define BIOVEC_NR_POOLS 6
-
-/*
- * a small number of entries is fine, not going to be performance critical.
- * basically we just need to survive
- */
-#define BIO_SPLIT_ENTRIES 2
 mempool_t *bio_split_pool __read_mostly;
-
-struct biovec_slab {
-	int nr_vecs;
-	char *name; 
-	struct kmem_cache *slab;
-};
 
 /*
  * if you change this list, also change bvec_alloc or things will
@@ -60,23 +45,18 @@
 #undef BV
 
 /*
- * bio_set is used to allow other portions of the IO system to
- * allocate their own private memory pools for bio and iovec structures.
- * These memory pools in turn all allocate from the bio_slab
- * and the bvec_slabs[].
- */
-struct bio_set {
-	mempool_t *bio_pool;
-	mempool_t *bvec_pools[BIOVEC_NR_POOLS];
-};
-
-/*
  * fs_bio_set is the bio_set containing bio and iovec memory pools used by
  * IO code that does not need private memory pools.
  */
-static struct bio_set *fs_bio_set;
+struct bio_set *fs_bio_set;
 
-static inline struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx, struct bio_set *bs)
+inline int bvec_nr_vecs(int idx)
+{
+	return bvec_slabs[idx].nr_vecs;
+}
+EXPORT_SYMBOL(bvec_nr_vecs);
+
+struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx, struct bio_set *bs)
 {
 	struct bio_vec *bvl;
 
diff -r eb54ccf75103 -r b9f133a520ea include/linux/bio.h
--- a/include/linux/bio.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/include/linux/bio.h	Fri Apr 25 17:39:29 2008 -0400
@@ -331,6 +331,36 @@
 				     int, int);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
+extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set *);
+extern inline int bvec_nr_vecs(int idx);
+
+/*
+ * bio_set is used to allow other portions of the IO system to
+ * allocate their own private memory pools for bio and iovec structures.
+ * These memory pools in turn all allocate from the bio_slab
+ * and the bvec_slabs[].
+ */
+#define BIO_POOL_SIZE 2
+#define BIOVEC_NR_POOLS 6
+
+struct bio_set {
+	mempool_t *bio_pool;
+	mempool_t *bvec_pools[BIOVEC_NR_POOLS];
+};
+
+struct biovec_slab {
+	int nr_vecs;
+	char *name; 
+	struct kmem_cache *slab;
+};
+
+extern struct bio_set *fs_bio_set;
+
+/*
+ * a small number of entries is fine, not going to be performance critical.
+ * basically we just need to survive
+ */
+#define BIO_SPLIT_ENTRIES 2
 
 #ifdef CONFIG_HIGHMEM
 /*


