From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] lib/scatterlist: fix memory leak with scsi-mq
Date: Thu, 23 Oct 2014 15:10:21 -0400
Message-ID: <5449529D.5070804@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Fix a memory leak with scsi-mq triggered by commands with large data
transfer length.

Fixes: c53c6d6a68b1 ("scatterlist: allow chaining to preallocated chunks")
Cc: <stable@vger.kernel.org> # 3.17.x
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

For inclusion in 3.18 and 3.17.x.

--- a/lib/scatterlist.c	2014-10-23 13:32:27.000000000 -0400
+++ b/lib/scatterlist.c	2014-10-23 13:32:36.000000000 -0400
@@ -203,10 +203,10 @@ void __sg_free_table(struct sg_table *ta
 		}
 
 		table->orig_nents -= sg_size;
-		if (!skip_first_chunk) {
-			free_fn(sgl, alloc_size);
+		if (skip_first_chunk)
 			skip_first_chunk = false;
-		}
+		else
+			free_fn(sgl, alloc_size);
 		sgl = next;
 	}
 
