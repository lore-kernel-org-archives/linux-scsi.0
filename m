From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 1/6] block: convert bio.__bi_cnt from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 11:15:57 +0300
Message-ID: <1508487362-26663-2-git-send-email-elena.reshetova@intel.com>
References: <1508487362-26663-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508487362-26663-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>
List-Id: linux-scsi@vger.kernel.org

atomic_t variables are currently used to implement reference
counters with the following properties:
 - counter is initialized to 1 using atomic_set()
 - a resource is freed upon counter reaching zero
 - once counter reaches zero, its further
   increments aren't allowed
 - counter schema uses basic atomic operations
   (set, inc, inc_not_zero, dec_and_test, etc.)

Such atomic variables should be converted to a newly provided
refcount_t type and API that prevents accidental counter overflows
and underflows. This is important since overflows and underflows
can lead to use-after-free situation and be exploitable.

The variable bio.__bi_cnt is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 block/bio.c               | 6 +++---
 fs/btrfs/volumes.c        | 2 +-
 include/linux/bio.h       | 4 ++--
 include/linux/blk_types.h | 3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 101c2a9..58edc1b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -279,7 +279,7 @@ void bio_init(struct bio *bio, struct bio_vec *table,
 {
 	memset(bio, 0, sizeof(*bio));
 	atomic_set(&bio->__bi_remaining, 1);
-	atomic_set(&bio->__bi_cnt, 1);
+	refcount_set(&bio->__bi_cnt, 1);
 
 	bio->bi_io_vec = table;
 	bio->bi_max_vecs = max_vecs;
@@ -557,12 +557,12 @@ void bio_put(struct bio *bio)
 	if (!bio_flagged(bio, BIO_REFFED))
 		bio_free(bio);
 	else {
-		BIO_BUG_ON(!atomic_read(&bio->__bi_cnt));
+		BIO_BUG_ON(!refcount_read(&bio->__bi_cnt));
 
 		/*
 		 * last put frees it
 		 */
-		if (atomic_dec_and_test(&bio->__bi_cnt))
+		if (refcount_dec_and_test(&bio->__bi_cnt))
 			bio_free(bio);
 	}
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b397375..11812ee 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -450,7 +450,7 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 		    waitqueue_active(&fs_info->async_submit_wait))
 			wake_up(&fs_info->async_submit_wait);
 
-		BUG_ON(atomic_read(&cur->__bi_cnt) == 0);
+		BUG_ON(refcount_read(&cur->__bi_cnt) == 0);
 
 		/*
 		 * if we're doing the sync list, record that our
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 275c91c..0fa4dd2 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -253,7 +253,7 @@ static inline void bio_get(struct bio *bio)
 {
 	bio->bi_flags |= (1 << BIO_REFFED);
 	smp_mb__before_atomic();
-	atomic_inc(&bio->__bi_cnt);
+	refcount_inc(&bio->__bi_cnt);
 }
 
 static inline void bio_cnt_set(struct bio *bio, unsigned int count)
@@ -262,7 +262,7 @@ static inline void bio_cnt_set(struct bio *bio, unsigned int count)
 		bio->bi_flags |= (1 << BIO_REFFED);
 		smp_mb__before_atomic();
 	}
-	atomic_set(&bio->__bi_cnt, count);
+	refcount_set(&bio->__bi_cnt, count);
 }
 
 static inline bool bio_flagged(struct bio *bio, unsigned int bit)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a2d2aa7..1ec370e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/bvec.h>
+#include <linux/refcount.h>
 
 struct bio_set;
 struct bio;
@@ -104,7 +105,7 @@ struct bio {
 
 	unsigned short		bi_max_vecs;	/* max bvl_vecs we can hold */
 
-	atomic_t		__bi_cnt;	/* pin count */
+	refcount_t		__bi_cnt;	/* pin count */
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
-- 
2.7.4
