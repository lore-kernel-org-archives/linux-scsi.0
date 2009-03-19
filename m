From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC C 1/5] blk_rq_map_pages() new API
Date: Thu, 19 Mar 2009 16:33:27 +0200
Message-ID: <49C257B7.5070301@panasas.com>
References: <49C254FD.7020202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:6997 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753856AbZCSOel (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:34:41 -0400
In-Reply-To: <49C254FD.7020202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scs


Define a new API for mapping array of pages into a request.

Internally the bio is created using the
rq_map_data + null_mapped + NULL_buffer mode of
bio_copy_user(). The bio is only referenced once
and there is no unmap function to call.

TODO:
   out of the 7 users of blk_rq_map_user + rq_map_data, 6 of them
   are null_mapped + NULL_buffer and could be converted to this
   API.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-map.c        |   54 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    3 ++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index ada399e..60a7a0b 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -325,3 +325,57 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	return 0;
 }
 EXPORT_SYMBOL(blk_rq_map_kern);
+
+/**
+ * blk_rq_map_pages - map pages array to a request, for REQ_TYPE_BLOCK_PC usage
+ * @q:		request queue where request should be inserted
+ * @rq:		request to fill
+ * @pages:	an array of struct page pointers to map
+ * @nr_pages:	count of valid pages at @pages
+ * @offset:	Offset into first page to start from (Must be blk_rq_aligned())
+ * @len:	length of user data to map
+ * @gfp_mask:	memory allocation flags
+ *
+ * Description:
+ *    Data will be mapped directly if possible. Otherwise a bounce
+ *    buffer is used. Can be called multiple times to append multiple
+ *    page arrays. No need to call an unmap function, and bio is only
+ *    referenced once. (Pages are of zero order)
+ */
+int blk_rq_map_pages(struct request_queue *q, struct request *rq,
+		    struct page **pages, unsigned nr_pages,
+		    unsigned long offset, unsigned len, gfp_t gfp_mask)
+{
+	struct bio *bio;
+	int reading, ret;
+	struct rq_map_data map_data = {
+		.pages = pages,
+		.nr_entries = nr_pages,
+		.offset = offset,
+		.null_mapped = 1,
+		.page_order = 0,
+	};
+
+	reading = rq_data_dir(rq) == READ;
+
+	/* The name is confusing, but bio_copy_user+map_data+NULL_buffer
+         * Actually just adds the pages to the bio, no copy is performed.
+	 */
+	bio = bio_copy_user(q, &map_data, 0, len, reading, gfp_mask);
+
+	if (IS_ERR(bio))
+		return PTR_ERR(bio);
+
+	bio->bi_flags |= (1 << BIO_NULL_MAPPED);
+
+	/* We might still need to bounce if memory mask does not match */
+	blk_queue_bounce(q, &bio);
+
+	ret = blk_rq_append_bio(q, rq, bio);
+	if (likely(!ret))
+		return 0;
+
+	bio_put(bio);
+	return ret;
+}
+EXPORT_SYMBOL(blk_rq_map_pages);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 22dcdde..81b681c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -784,6 +784,9 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
 extern int blk_rq_unmap_user(struct bio *);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *,
 			   unsigned int, gfp_t);
+extern int blk_rq_map_pages(struct request_queue *, struct request *,
+			    struct page **, unsigned, unsigned long offset,
+			    unsigned , gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       struct rq_map_data *, struct sg_iovec *, int,
 			       unsigned int, gfp_t);
-- 
1.6.2.1


