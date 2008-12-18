From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 02/16] block: fix the partial mappings with struct rq_map_data
Date: Thu, 18 Dec 2008 14:49:37 +0900
Message-ID: <1229579391-28753-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46395 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbYLRGIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:08:53 -0500
In-Reply-To: <1229579391-28753-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>

This fixes bio_copy_user_iov to properly handle the partial mappings
with struct rq_map_data (which only sg uses for now but st and osst
will shortly). It adds the offset member to struct rq_map_data and
changes blk_rq_map_user to update it so that bio_copy_user_iov can add
an appropriate page frame via bio_add_pc_page().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-map.c        |    3 +++
 drivers/scsi/sg.c      |    1 +
 fs/bio.c               |   12 +++++++++---
 include/linux/blkdev.h |    1 +
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 0f4b4b8..bc0ca0d 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -150,6 +150,9 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 			bio = rq->bio;
 		bytes_read += ret;
 		ubuf += ret;
+
+		if (map_data)
+			map_data->offset += ret;
 	}
 
 	if (!bio_flagged(bio, BIO_USER_MAPPED))
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5103855..7d0b3d9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1669,6 +1669,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 		md->pages = req_schp->pages;
 		md->page_order = req_schp->page_order;
 		md->nr_entries = req_schp->k_use_sg;
+		md->offset = 0;
 	}
 
 	if (iov_count)
diff --git a/fs/bio.c b/fs/bio.c
index 5fd6e98..879d4ef 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -635,6 +635,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	int i, ret;
 	int nr_pages = 0;
 	unsigned int len = 0;
+	unsigned int offset = map_data ? map_data->offset & ~PAGE_MASK : 0;
 
 	for (i = 0; i < iov_count; i++) {
 		unsigned long uaddr;
@@ -661,12 +662,16 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
 
 	ret = 0;
-	i = 0;
-	if (map_data)
+
+	if (map_data) {
 		nr_pages = 1 << map_data->page_order;
+		i = map_data->offset / PAGE_SIZE;
+	}
 	while (len) {
 		unsigned int bytes = PAGE_SIZE;
 
+		bytes -= offset;
+
 		if (bytes > len)
 			bytes = len;
 
@@ -688,10 +693,11 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 			}
 		}
 
-		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes)
+		if (bio_add_pc_page(q, bio, page, bytes, offset) < bytes)
 			break;
 
 		len -= bytes;
+		offset = 0;
 	}
 
 	if (ret)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a135256..3cef38f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -680,6 +680,7 @@ struct rq_map_data {
 	struct page **pages;
 	int page_order;
 	int nr_entries;
+	unsigned long offset;
 };
 
 struct req_iterator {
-- 
1.5.6.5

