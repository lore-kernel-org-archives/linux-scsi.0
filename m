From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 02/13] block: add offset to struct rq_map_data
Date: Thu, 11 Dec 2008 23:07:39 +0900
Message-ID: <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44279 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbYLKOOJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:14:09 -0500
In-Reply-To: <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Jens Axboe <jens.axboe@oracle.com>

This patch add offset to struct rq_map_data. bio_copy_user_iov uses it
with bio_add_pc_page. It is necessary to convert st and osst drivers
to use the block layer apping API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/sg.c      |    1 +
 fs/bio.c               |    9 ++++++++-
 include/linux/blkdev.h |    1 +
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 820a228..d72162e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1670,6 +1670,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 		md->page_order = req_schp->page_order;
 		md->nr_entries = req_schp->k_use_sg;
 		md->null_mapped = hp->dxferp ? 0 : 1;
+		md->offset = 0;
 	}
 
 	if (iov_count)
diff --git a/fs/bio.c b/fs/bio.c
index 25f456b..a482e1f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -635,6 +635,10 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	int i, ret;
 	int nr_pages = 0;
 	unsigned int len = 0;
+	unsigned int offset = map_data ? map_data->offset : 0;
+
+	if (offset > PAGE_SIZE)
+		return ERR_PTR(-EINVAL);
 
 	for (i = 0; i < iov_count; i++) {
 		unsigned long uaddr;
@@ -670,6 +674,8 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 		else
 			bytes = PAGE_SIZE;
 
+		bytes -= offset;
+
 		if (bytes > len)
 			bytes = len;
 
@@ -686,10 +692,11 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 			break;
 		}
 
-		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes)
+		if (bio_add_pc_page(q, bio, page, bytes, offset) < bytes)
 			break;
 
 		len -= bytes;
+		offset = 0;
 	}
 
 	if (ret)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 39807a9..8922c25 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -681,6 +681,7 @@ struct rq_map_data {
 	int page_order;
 	int nr_entries;
 	int null_mapped;
+	unsigned offset;
 };
 
 struct req_iterator {
-- 
1.5.6.5

