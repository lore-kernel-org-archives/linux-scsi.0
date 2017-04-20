From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 1/5] block: convert bio.__bi_cnt from atomic_t to refcount_t
Date: Thu, 20 Apr 2017 14:27:20 +0300
Message-ID: <1492687644-4405-2-git-send-email-elena.reshetova@intel.com>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 block/bio.c               | 6 +++---
 fs/btrfs/volumes.c        | 2 +-
 include/linux/bio.h       | 4 ++--
 include/linux/blk_types.h | 3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5eec5e0..3dffc17 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -275,7 +275,7 @@ void bio_init(struct bio *bio, struct bio_vec *table,
 {
 	memset(bio, 0, sizeof(*bio));
 	atomic_set(&bio->__bi_remaining, 1);
-	atomic_set(&bio->__bi_cnt, 1);
+	refcount_set(&bio->__bi_cnt, 1);
 
 	bio->bi_io_vec = table;
 	bio->bi_max_vecs = max_vecs;
@@ -543,12 +543,12 @@ void bio_put(struct bio *bio)
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
index 13e55d1..ff1fe9d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -441,7 +441,7 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 		    waitqueue_active(&fs_info->async_submit_wait))
 			wake_up(&fs_info->async_submit_wait);
 
-		BUG_ON(atomic_read(&cur->__bi_cnt) == 0);
+		BUG_ON(refcount_read(&cur->__bi_cnt) == 0);
 
 		/*
 		 * if we're doing the sync list, record that our
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8e52119..44ac678 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -234,7 +234,7 @@ static inline void bio_get(struct bio *bio)
 {
 	bio->bi_flags |= (1 << BIO_REFFED);
 	smp_mb__before_atomic();
-	atomic_inc(&bio->__bi_cnt);
+	refcount_inc(&bio->__bi_cnt);
 }
 
 static inline void bio_cnt_set(struct bio *bio, unsigned int count)
@@ -243,7 +243,7 @@ static inline void bio_cnt_set(struct bio *bio, unsigned int count)
 		bio->bi_flags |= (1 << BIO_REFFED);
 		smp_mb__before_atomic();
 	}
-	atomic_set(&bio->__bi_cnt, count);
+	refcount_set(&bio->__bi_cnt, count);
 }
 
 static inline bool bio_flagged(struct bio *bio, unsigned int bit)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d703acb..c41407f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/bvec.h>
+#include <linux/refcount.h>
 
 struct bio_set;
 struct bio;
@@ -73,7 +74,7 @@ struct bio {
 
 	unsigned short		bi_max_vecs;	/* max bvl_vecs we can hold */
 
-	atomic_t		__bi_cnt;	/* pin count */
+	refcount_t		__bi_cnt;	/* pin count */
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 
-- 
2.7.4
