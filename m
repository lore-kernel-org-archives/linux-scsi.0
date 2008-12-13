From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] block: unexport bio_add_pc_page
Date: Sun, 14 Dec 2008 01:23:47 +0900
Message-ID: <1229185427-4130-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229185427-4130-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229185427-4130-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41059 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbYLMQ2R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 11:28:17 -0500
In-Reply-To: <1229185427-4130-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

We can unexport bio_add_pc_page since scsi_req_map_sg has gone.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 fs/bio.c            |    6 +++---
 include/linux/bio.h |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index a482e1f..206209c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -464,8 +464,9 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
  *      smaller than PAGE_SIZE, so it is always possible to add a single
  *      page to an empty bio. This should only be used by REQ_PC bios.
  */
-int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
-		    unsigned int len, unsigned int offset)
+static int bio_add_pc_page(struct request_queue *q, struct bio *bio,
+			   struct page *page, unsigned int len,
+			   unsigned int offset)
 {
 	return __bio_add_page(q, bio, page, len, offset, q->max_hw_sectors);
 }
@@ -1454,7 +1455,6 @@ EXPORT_SYMBOL(__bio_clone);
 EXPORT_SYMBOL(bio_clone);
 EXPORT_SYMBOL(bio_phys_segments);
 EXPORT_SYMBOL(bio_add_page);
-EXPORT_SYMBOL(bio_add_pc_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
 EXPORT_SYMBOL(bio_map_user);
 EXPORT_SYMBOL(bio_unmap_user);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6a64209..87e7f77 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -351,8 +351,6 @@ extern struct bio *bio_clone(struct bio *, gfp_t);
 extern void bio_init(struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
-extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
-			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
 extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
-- 
1.5.5.GIT

