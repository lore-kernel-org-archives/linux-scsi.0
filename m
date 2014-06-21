From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 32-bit bug in iovec iterator changes
Date: Sat, 21 Jun 2014 19:09:22 -0400
Message-ID: <20140621230922.GA13188@thunk.org>
References: <20140619153550.GA12836@thunk.org>
 <53A308DE.7080000@fb.com>
 <20140619160801.GB4907@thunk.org>
 <20140619162144.GC4907@thunk.org>
 <20140619223820.GN4453@dastard>
 <20140621035144.GA8526@thunk.org>
 <20140621055306.GP18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51415 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaFUXJ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2014 19:09:29 -0400
Content-Disposition: inline
In-Reply-To: <20140621055306.GP18016@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Jun 21, 2014 at 06:53:07AM +0100, Al Viro wrote:
> 
> ed include/linux/uio.h <<EOF
> /iov_iter_truncate/s/size_t/u64/
> w
> q
> EOF
> 
> Could you check if that fixes the sucker?

The following patch (attached at the end) appears to fix the problem,
but looking at uio.h, I'm completely confused about *why* it fixes the
problem.  In particular, iov_iter_iovec() makes no sense to me at all,
and I don't understand how the calculation of iov_len makes any sense:

		.iov_len = min(iter->count,
			       iter->iov->iov_len - iter->iov_offset),

It also looks like uio.h is mostly about offsets to memory pointers,
and so why this would make a difference when the issue is the block
device offset goes above 2**30?

There must be deep magic going on here, and so I don't know if your
s/size_t/u64/g substitation also extends to the various functions that
have size_t in them:

unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
size_t iov_iter_copy_from_user_atomic(struct page *page,
		struct iov_iter *i, unsigned long offset, size_t bytes);
void iov_iter_advance(struct iov_iter *i, size_t bytes);
int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
size_t iov_iter_single_seg_count(const struct iov_iter *i);
size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
			 struct iov_iter *i);
size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
			 struct iov_iter *i);
unsigned long iov_iter_alignment(const struct iov_iter *i);
void iov_iter_init(struct iov_iter *i, int direction, const struct iovec *iov,
			unsigned long nr_segs, size_t count);
ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
			size_t maxsize, size_t *start);
ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
			size_t maxsize, size_t *start);


Anyway, this patch does appear to make the problem go away, but given
that I don't understand what is going on here, please take it with a
huge grain of salt.  And might I suggest some comments to perhaps give
some context to someone who is trying to understand
include/linux/uio.h?

Thanks!!

						- Ted

diff --git a/include/linux/uio.h b/include/linux/uio.h
index e2231e4..bea7b7d 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -16,7 +16,7 @@ struct page;
 
 struct kvec {
 	void *iov_base; /* and that should *never* hold a userland pointer */
-	size_t iov_len;
+	u64 iov_len;
 };
 
 enum {
@@ -27,8 +27,8 @@ enum {
 
 struct iov_iter {
 	int type;
-	size_t iov_offset;
-	size_t count;
+	u64 iov_offset;
+	u64 count;
 	union {
 		const struct iovec *iov;
 		const struct bio_vec *bvec;
@@ -41,12 +41,12 @@ struct iov_iter {
  *
  * NOTE that it is not safe to use this function until all the iovec's
  * segment lengths have been validated.  Because the individual lengths can
- * overflow a size_t when added together.
+ * overflow a u64 when added together.
  */
-static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
+static inline u64 iov_length(const struct iovec *iov, unsigned long nr_segs)
 {
 	unsigned long seg;
-	size_t ret = 0;
+	u64 ret = 0;
 
 	for (seg = 0; seg < nr_segs; seg++)
 		ret += iov[seg].iov_len;
@@ -89,12 +89,12 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
 
-static inline size_t iov_iter_count(struct iov_iter *i)
+static inline u64 iov_iter_count(struct iov_iter *i)
 {
 	return i->count;
 }
 
-static inline void iov_iter_truncate(struct iov_iter *i, size_t count)
+static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 {
 	if (i->count > count)
 		i->count = count;
@@ -104,7 +104,7 @@ static inline void iov_iter_truncate(struct iov_iter *i, size_t count)
  * reexpand a previously truncated iterator; count must be no more than how much
  * we had shrunk it.
  */
-static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
+static inline void iov_iter_reexpand(struct iov_iter *i, u64 count)
 {
 	i->count = count;
 }

