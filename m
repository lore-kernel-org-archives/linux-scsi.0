From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 09/27] target: avoid to access .bi_vcnt directly
Date: Thu, 14 Apr 2016 20:02:27 +0800
Message-ID: <1460635375-28282-10-git-send-email-tom.leiming@gmail.com>
References: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

When the bio is full, bio_add_pc_page() will return zero,
so use this way to handle full bio.

Also replace access to .bi_vcnt for pr_debug() with bio_segments().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/target/target_core_pscsi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index de18790..66320e8 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -945,13 +945,9 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
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
1.9.1
