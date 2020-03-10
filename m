Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBEAC3F2C6
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7A8124684
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BWrxrTeK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCJJrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:17 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26501 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJJrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833640; x=1615369640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GPwQZ0HJLXihqtToIOjaKwVIO2sx4QEs+D9iQ1iYFlw=;
  b=BWrxrTeK0WyQphFRjw+nBndOlpCZzhIRMqmWcu5YfclMVZlT9jhbevzc
   m06heVjZrn3Mw5jgsaECLVe+iqkPoby30OfrwhRg/fMEXWBiAezIYKhol
   E2tz23vPPY5GvBWshXfW0XGDeW0lmA4cqPlX/UrAx6RgRI6EyVGVlzkAR
   9Is3f1JKNtl76+5MDs+wJ/YiaLFziA33V7JlAoUwb3/WiQr7DbNJHoaM4
   zKOPqR1EUmyDFfRBkWswW+SRK2X03KBnBfJ3UxSYCCUrqHAEGMzx8U2vm
   eNbTpJGdlaBVYzgke9QOkcUZlymI+PyUjORRKv2IhfcIqWfSJt9OSRxAb
   Q==;
IronPort-SDR: +vzu0PYPy6uEhPavDkkps2P/0M0iPd3tnMnDdRDjhiPFvhSx32De5LJ81kkkaqa896RBZ36SfT
 +YDRldPXZVnbdlXKdiaXE2QsJ1gxlpGknOuinaa9tEOmM0lGE+xBukDBs7AES7bPzpVn0cfqkr
 n5UKhAwQD3qabVVr1rhz4wtn7JpNdQiCVOTCh66nThIb/jRZvqSOb8L33kUjTmWeKyrIXx82op
 kHvwIN1v+CHmKqq7sO9KxZtkr9LKQrq6rijYso3vfU8B1nbXm4gtgGNxzWliszqudSFLVOXU+7
 hfE=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082781"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:20 +0800
IronPort-SDR: QkI1LwfpcAcntJ46tE/63xRUWdUFluw+ygxDaKNEW6mRkgm8DjbimWPOh72icYuNn/tdqXG/vP
 HdIjZ5pL0siZrv8SLNX1+Mgi6l/tgN0HlL0YKQXAcXci1TYILzYvtGuOFZoYsN51x0yRKx5TVb
 UNwx2qXa3GWJS6TpxR6njO5JXmfeZuw7rh9CH2XO+OqF9N7nmyIlDKmuaTNpGHbbAL0dxYOQT8
 9m9mPr+bJ/TtujHSijrAwfVrOq94mJtQ0aOUMqSNUh+zk/0aAJHNiYoT4ttS/DMdsc8/QZ23JK
 1px3EbRBzNzJPWxO6SoogFTu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:38:56 -0700
IronPort-SDR: 1HcwUKh2Ams6epC17LEySXSSIAsp64AFA9n03J9RHLt8cgq/A0OOErbU2e8RwAc26FZ30n1bh9
 JZJjGBq6eGnBKek8Vha8g/C8HlL/QtWpPAph41C0W3bODFgF2Iz27tPLtSOAFS25eU2GGYa/yG
 AIWWV5efmykPQ+ntiLfoC3HXnEFU5PPT+7i2hDkuvLs9vpiaz52ylxLT/uw6Sp7/+69vKnBwDc
 3y2tlt8PcDXONIMj/vV1qFqqB5FD/bgYMPhQbefqpme97GvmGwGB7YZ5KV5EhCj1iIuP1LuNmV
 7AQ=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:15 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 03/11] block: introduce bio_add_append_page
Date:   Tue, 10 Mar 2020 18:46:45 +0900
Message-Id: <20200310094653.33257-4-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For REQ_OP_ZONE_APPEND we cannot add unlimited amounts of pages to a bio,
as the bio cannot be split later on.

This is similar to what we have to do for passthrough pages as well, just
with a different limit.

Introduce bio_add_append_page() which can used by file-systems add pages for
a REQ_OP_ZONE_APPEND bio.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/bio.c         | 37 ++++++++++++++++++++++++++++++-------
 block/blk-map.c     |  2 +-
 include/linux/bio.h |  2 +-
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5bff80fc2ad9..3bd648671a28 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -732,7 +732,7 @@ static bool bio_try_merge_pc_page(struct request_queue *q, struct bio *bio,
  */
 static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		struct page *page, unsigned int len, unsigned int offset,
-		bool *same_page)
+		bool *same_page, unsigned int max_sectors)
 {
 	struct bio_vec *bvec;
 
@@ -742,7 +742,7 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 	if (unlikely(bio_flagged(bio, BIO_CLONED)))
 		return 0;
 
-	if (((bio->bi_iter.bi_size + len) >> 9) > queue_max_hw_sectors(q))
+	if (((bio->bi_iter.bi_size + len) >> 9) > max_sectors)
 		return 0;
 
 	if (bio->bi_vcnt > 0) {
@@ -777,10 +777,20 @@ int bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		struct page *page, unsigned int len, unsigned int offset)
 {
 	bool same_page = false;
-	return __bio_add_pc_page(q, bio, page, len, offset, &same_page);
+	return __bio_add_pc_page(q, bio, page, len, offset, &same_page,
+				 queue_max_hw_sectors(q));
 }
 EXPORT_SYMBOL(bio_add_pc_page);
 
+int bio_add_append_page(struct request_queue *q, struct bio *bio,
+			struct page *page, unsigned int len, unsigned int offset)
+{
+	bool same_page = false;
+	return __bio_add_pc_page(q, bio, page, len, offset, &same_page,
+				 queue_max_zone_append_sectors(q));
+}
+EXPORT_SYMBOL(bio_add_append_page);
+
 /**
  * __bio_try_merge_page - try appending data to an existing bvec.
  * @bio: destination bio
@@ -945,8 +955,15 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 
 		len = min_t(size_t, PAGE_SIZE - offset, left);
 
-		if (__bio_try_merge_page(bio, page, len, offset, &same_page)) {
-			if (same_page)
+		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
+			size = bio_add_append_page(bio->bi_disk->queue, bio,
+						   page, len, offset);
+
+			if (size != len)
+				return -E2BIG;
+		} else if (__bio_try_merge_page(bio, page, len, offset,
+						&same_page)) {
+				if (same_page)
 				put_page(page);
 		} else {
 			if (WARN_ON_ONCE(bio_full(bio, len)))
@@ -1389,11 +1406,12 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
  */
 struct bio *bio_map_user_iov(struct request_queue *q,
 			     struct iov_iter *iter,
-			     gfp_t gfp_mask)
+			     gfp_t gfp_mask, unsigned int op)
 {
 	int j;
 	struct bio *bio;
 	int ret;
+	unsigned int max_sectors;
 
 	if (!iov_iter_count(iter))
 		return ERR_PTR(-EINVAL);
@@ -1402,6 +1420,11 @@ struct bio *bio_map_user_iov(struct request_queue *q,
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
+	if (op == REQ_OP_ZONE_APPEND)
+		max_sectors = queue_max_zone_append_sectors(q);
+	else
+		max_sectors = queue_max_hw_sectors(q);
+
 	while (iov_iter_count(iter)) {
 		struct page **pages;
 		ssize_t bytes;
@@ -1429,7 +1452,7 @@ struct bio *bio_map_user_iov(struct request_queue *q,
 					n = bytes;
 
 				if (!__bio_add_pc_page(q, bio, page, n, offs,
-						&same_page)) {
+						&same_page, max_sectors)) {
 					if (same_page)
 						put_page(page);
 					break;
diff --git a/block/blk-map.c b/block/blk-map.c
index b0790268ed9d..a83ba39251a9 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -72,7 +72,7 @@ static int __blk_rq_map_user_iov(struct request *rq,
 	if (copy)
 		bio = bio_copy_user_iov(q, map_data, iter, gfp_mask);
 	else
-		bio = bio_map_user_iov(q, iter, gfp_mask);
+		bio = bio_map_user_iov(q, iter, gfp_mask, req_op(rq));
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ef640fd76c23..ef69e52cc8d9 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -444,7 +444,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
 void bio_release_pages(struct bio *bio, bool mark_dirty);
 struct rq_map_data;
 extern struct bio *bio_map_user_iov(struct request_queue *,
-				    struct iov_iter *, gfp_t);
+				    struct iov_iter *, gfp_t, unsigned int);
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 				gfp_t);
-- 
2.24.1

