From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 04/12] target: avoid to access .bi_vcnt directly
Date: Fri, 11 Nov 2016 20:05:32 +0800
Message-ID: <1478865957-25252-5-git-send-email-tom.leiming@gmail.com>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

When the bio is full, bio_add_pc_page() will return zero,
so use this way to handle full bio.

Also replace access to .bi_vcnt for pr_debug() with bio_segments().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/target/target_core_pscsi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 9125d9358dea..04d7aa7390d0 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -935,13 +935,9 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 			rc = bio_add_pc_page(pdv->pdv_sd->request_queue,
 					bio, page, bytes, off);
-			if (rc != bytes)
-				goto fail;
-
 			pr_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
-				bio->bi_vcnt, nr_vecs);
-
-			if (bio->bi_vcnt > nr_vecs) {
+				bio_segments(bio), nr_vecs);
+			if (rc != bytes) {
 				pr_debug("PSCSI: Reached bio->bi_vcnt max:"
 					" %d i: %d bio: %p, allocating another"
 					" bio\n", bio->bi_vcnt, i, bio);
-- 
2.7.4
