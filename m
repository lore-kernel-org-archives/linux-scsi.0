From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 03/16] block: make blk_rq_map_user take a NULL user-space buffer for WRITE
Date: Thu, 18 Dec 2008 14:49:38 +0900
Message-ID: <1229579391-28753-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46393 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYLRGIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:08:53 -0500
In-Reply-To: <1229579391-28753-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>

The commit 818827669d85b84241696ffef2de485db46b0b5e (block: make
blk_rq_map_user take a NULL user-space buffer) extended
blk_rq_map_user to accept a NULL user-space buffer with a READ
command. It was necessary to convert sg to use the block layer mapping
API.

This patch extends blk_rq_map_user again for a WRITE command. It is
necessary to convert st and osst drivers to use the block layer
apping API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-map.c        |   16 +++++++---------
 drivers/scsi/sg.c      |    1 +
 fs/bio.c               |    2 +-
 include/linux/blkdev.h |    1 +
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index bc0ca0d..01bd7ca 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -42,7 +42,7 @@ static int __blk_rq_unmap_user(struct bio *bio)
 
 static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 			     struct rq_map_data *map_data, void __user *ubuf,
-			     unsigned int len, int null_mapped, gfp_t gfp_mask)
+			     unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long uaddr;
 	struct bio *bio, *orig_bio;
@@ -63,7 +63,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (null_mapped)
+	if (map_data && map_data->null_mapped)
 		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
 
 	orig_bio = bio;
@@ -114,17 +114,15 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 {
 	unsigned long bytes_read = 0;
 	struct bio *bio = NULL;
-	int ret, null_mapped = 0;
+	int ret;
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
-	if (!ubuf) {
-		if (!map_data || rq_data_dir(rq) != READ)
-			return -EINVAL;
-		null_mapped = 1;
-	}
+
+	if (!ubuf && (!map_data || !map_data->null_mapped))
+		return -EINVAL;
 
 	while (bytes_read != len) {
 		unsigned long map_len, end, start;
@@ -143,7 +141,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 			map_len -= PAGE_SIZE;
 
 		ret = __blk_rq_map_user(q, rq, map_data, ubuf, map_len,
-					null_mapped, gfp_mask);
+					gfp_mask);
 		if (ret < 0)
 			goto unmap_rq;
 		if (!bio)
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7d0b3d9..8f0bd3f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1670,6 +1670,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 		md->page_order = req_schp->page_order;
 		md->nr_entries = req_schp->k_use_sg;
 		md->offset = 0;
+		md->null_mapped = hp->dxferp ? 0 : 1;
 	}
 
 	if (iov_count)
diff --git a/fs/bio.c b/fs/bio.c
index 879d4ef..a5fb24d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -706,7 +706,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	/*
 	 * success
 	 */
-	if (!write_to_vm) {
+	if (!write_to_vm && (!map_data || !map_data->null_mapped)) {
 		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 0);
 		if (ret)
 			goto cleanup;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3cef38f..f11c3d0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -681,6 +681,7 @@ struct rq_map_data {
 	int page_order;
 	int nr_entries;
 	unsigned long offset;
+	int null_mapped;
 };
 
 struct req_iterator {
-- 
1.5.6.5

