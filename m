From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 01/16] block: fix bio_add_page misuse with rq_map_data
Date: Thu, 18 Dec 2008 14:49:36 +0900
Message-ID: <1229579391-28753-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46394 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbYLRGIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:08:53 -0500
In-Reply-To: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>

This fixes bio_add_page misuse in bio_copy_user_iov with rq_map_data,
which only sg uses now.

rq_map_data carries page frames for bio_add_pc_page. bio_copy_user_iov
uses bio_add_pc_page with a larger size than PAGE_SIZE. It's clearly
wrong.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 fs/bio.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 77a55bc..5fd6e98 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -662,28 +662,30 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 
 	ret = 0;
 	i = 0;
+	if (map_data)
+		nr_pages = 1 << map_data->page_order;
 	while (len) {
-		unsigned int bytes;
-
-		if (map_data)
-			bytes = 1U << (PAGE_SHIFT + map_data->page_order);
-		else
-			bytes = PAGE_SIZE;
+		unsigned int bytes = PAGE_SIZE;
 
 		if (bytes > len)
 			bytes = len;
 
 		if (map_data) {
-			if (i == map_data->nr_entries) {
+			if (i == map_data->nr_entries * nr_pages) {
 				ret = -ENOMEM;
 				break;
 			}
-			page = map_data->pages[i++];
-		} else
+
+			page = map_data->pages[i / nr_pages];
+			page += (i % nr_pages);
+
+			i++;
+		} else {
 			page = alloc_page(q->bounce_gfp | gfp_mask);
-		if (!page) {
-			ret = -ENOMEM;
-			break;
+			if (!page) {
+				ret = -ENOMEM;
+				break;
+			}
 		}
 
 		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes)
-- 
1.5.6.5

