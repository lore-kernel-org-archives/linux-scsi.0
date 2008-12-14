From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: fix bio_add_page misuse with rq_map_data
Date: Mon, 15 Dec 2008 03:05:32 +0900
Message-ID: <20081215030526G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:48152 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYLNSFj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Dec 2008 13:05:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

This fixes bio_add_page misuse in bio_copy_user_iov with rq_map_data,
which only sg uses now.

rq_map_data carries page frames for bio_add_pc_page. bio_copy_user_iov
uses bio_add_pc_page with a larger size than PAGE_SIZE. it's clearly
wrong, though it works if a request doesn't go to the bounce path, I
think.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 fs/bio.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 77a55bc..0ebf768 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -662,23 +662,26 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 
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
+
+			if (i && (i % nr_pages))
+				page++;
+			else
+				page = map_data->pages[i / nr_pages];
+
+			i++;
 		} else
 			page = alloc_page(q->bounce_gfp | gfp_mask);
 		if (!page) {
-- 
1.5.5.GIT

