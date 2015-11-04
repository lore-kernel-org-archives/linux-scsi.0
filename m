From: mchristi@redhat.com
Subject: [PATCH 32/32] block: remove __REQ op defs and reduce bi_op/bi_rw sizes
Date: Wed,  4 Nov 2015 16:08:29 -0600
Message-ID: <1446674909-5371-33-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patches removes the __REQ/REQ definitions for operations
now defined by REQ_OPs.

There is now no need for bi_rw to be a long, so this makes it a
int. I also moved the priority to its own field, but I guess I could
have just kept this in the bi_rw since there is only 16 bio related
REQ_XYZ flags.

bi_op is also no longer a bitmap, so it only needs to be a u8/char,
so that is changed too.

This is more of a RFC patch, because I still need to update the rest
of the block layer code that was treating bi_rw as a long and I can
also shrink the request->cmd_flags.

I was not sure if or how much or where people wanted to stick things.
There also appears to be room in the bi_flags field. If bi_flags is
only using 13 bits and there are only 16 REQ_XYZs bits related bios,
I could put them all in one variable if we wanted to go wild with trying
to shrink the bio while I am at it..

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 include/linux/bio.h         | 13 ++-----------
 include/linux/blk_types.h   | 23 ++++++-----------------
 include/trace/events/f2fs.h |  1 -
 3 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7cbad7a..34a20cf 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -44,18 +44,9 @@
 #define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
 #define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)
 
-/*
- * upper 16 bits of bi_rw define the io priority of this bio
- */
-#define BIO_PRIO_SHIFT	(8 * sizeof(unsigned long) - IOPRIO_BITS)
-#define bio_prio(bio)	((bio)->bi_rw >> BIO_PRIO_SHIFT)
+#define bio_prio(bio)		(bio)->bi_ioprio
 #define bio_prio_valid(bio)	ioprio_valid(bio_prio(bio))
-
-#define bio_set_prio(bio, prio)		do {			\
-	WARN_ON(prio >= (1 << IOPRIO_BITS));			\
-	(bio)->bi_rw &= ((1UL << BIO_PRIO_SHIFT) - 1);		\
-	(bio)->bi_rw |= ((unsigned long) (prio) << BIO_PRIO_SHIFT);	\
-} while (0)
+#define bio_set_prio(bio, prio)	((bio)->bi_ioprio = prio)
 
 /*
  * various member access, note that bio_data should of course not be used
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 581d353..c32ae3c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -48,14 +48,9 @@ struct bio {
 	struct block_device	*bi_bdev;
 	unsigned int		bi_flags;	/* status, command, etc */
 	int			bi_error;
-	unsigned long		bi_rw;		/* bottom bits rq_flags_bits
-						 * top bits priority
-						 */
-	/*
-	 * this will be a u8 in the next patches and bi_rw can be shrunk to
-	 * a u32. For compat in these transistional patches op is a int here.
-	 */
-	int			bi_op;		/* REQ_OP */
+	unsigned int		bi_rw;		/* rq_flags_bits */
+	unsigned short		bi_ioprio;
+	u8			bi_op;		/* REQ_OP */
 
 
 	struct bvec_iter	bi_iter;
@@ -151,7 +146,6 @@ struct bio {
  */
 enum rq_flag_bits {
 	/* common flags */
-	__REQ_WRITE,		/* not set, read. set, write */
 	__REQ_FAILFAST_DEV,	/* no driver retries of device errors */
 	__REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
 	__REQ_FAILFAST_DRIVER,	/* no driver retries of driver errors */
@@ -159,9 +153,7 @@ enum rq_flag_bits {
 	__REQ_SYNC,		/* request is sync (sync write or read) */
 	__REQ_META,		/* metadata io request */
 	__REQ_PRIO,		/* boost priority in cfq */
-	__REQ_DISCARD,		/* request to discard sectors */
-	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
-	__REQ_WRITE_SAME,	/* write same block many times */
+	__REQ_SECURE,		/* secure discard (used with REQ_OP_DISCARD) */
 
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 	__REQ_INTEGRITY,	/* I/O includes block integrity payload */
@@ -198,15 +190,12 @@ enum rq_flag_bits {
 	__REQ_NR_BITS,		/* stops here */
 };
 
-#define REQ_WRITE		(1ULL << __REQ_WRITE)
 #define REQ_FAILFAST_DEV	(1ULL << __REQ_FAILFAST_DEV)
 #define REQ_FAILFAST_TRANSPORT	(1ULL << __REQ_FAILFAST_TRANSPORT)
 #define REQ_FAILFAST_DRIVER	(1ULL << __REQ_FAILFAST_DRIVER)
 #define REQ_SYNC		(1ULL << __REQ_SYNC)
 #define REQ_META		(1ULL << __REQ_META)
 #define REQ_PRIO		(1ULL << __REQ_PRIO)
-#define REQ_DISCARD		(1ULL << __REQ_DISCARD)
-#define REQ_WRITE_SAME		(1ULL << __REQ_WRITE_SAME)
 #define REQ_NOIDLE		(1ULL << __REQ_NOIDLE)
 #define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
 
@@ -250,8 +239,8 @@ enum rq_flag_bits {
 enum req_op {
 	REQ_OP_READ,
 	REQ_OP_WRITE,
-	REQ_OP_DISCARD,
-	REQ_OP_WRITE_SAME,
+	REQ_OP_DISCARD,		/* request to discard sectors */
+	REQ_OP_WRITE_SAME,	/* write same block many times */
 };
 
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 0c7301b..2446a2f 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -31,7 +31,6 @@ TRACE_DEFINE_ENUM(BG_GC);
 TRACE_DEFINE_ENUM(LFS);
 TRACE_DEFINE_ENUM(SSR);
 TRACE_DEFINE_ENUM(__REQ_RAHEAD);
-TRACE_DEFINE_ENUM(__REQ_WRITE);
 TRACE_DEFINE_ENUM(__REQ_SYNC);
 TRACE_DEFINE_ENUM(__REQ_NOIDLE);
 TRACE_DEFINE_ENUM(__REQ_FLUSH);
-- 
1.8.3.1
