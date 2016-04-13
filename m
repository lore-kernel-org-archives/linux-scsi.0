From: mchristi@redhat.com
Subject: [PATCH 25/42] target: set bi_op to REQ_OP
Date: Wed, 13 Apr 2016 14:36:11 -0500
Message-ID: <1460576188-5751-26-git-send-email-mchristi@redhat.com>
References: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch has the target modules use bio->bi_op for REQ_OPs and rq_flag_bits
to bio->bi_rw.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_iblock.c | 38 +++++++++++++++++++++----------------
 drivers/target/target_core_pscsi.c  |  2 +-
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c887f7d..fb1543b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -312,7 +312,8 @@ static void iblock_bio_done(struct bio *bio)
 }
 
 static struct bio *
-iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int rw)
+iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int op,
+	       int op_flags)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(cmd->se_dev);
 	struct bio *bio;
@@ -334,7 +335,8 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int rw)
 	bio->bi_private = cmd;
 	bio->bi_end_io = &iblock_bio_done;
 	bio->bi_iter.bi_sector = lba;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
+	bio->bi_rw = op_flags;
 
 	return bio;
 }
@@ -480,7 +482,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		goto fail;
 	cmd->priv = ibr;
 
-	bio = iblock_get_bio(cmd, block_lba, 1, WRITE);
+	bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE, 0);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -493,7 +495,8 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
 
-			bio = iblock_get_bio(cmd, block_lba, 1, WRITE);
+			bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE,
+					     0);
 			if (!bio)
 				goto fail_put_bios;
 
@@ -679,8 +682,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct scatterlist *sg;
 	u32 sg_num = sgl_nents;
 	unsigned bio_cnt;
-	int rw = 0;
-	int i;
+	int i, op, op_flags = 0;
 
 	if (data_direction == DMA_TO_DEVICE) {
 		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -690,17 +692,20 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		 * is not enabled, or if initiator set the Force Unit Access bit.
 		 */
 		if (q->flush_flags & REQ_FUA) {
-			if (cmd->se_cmd_flags & SCF_FUA)
-				rw = WRITE_FUA;
-			else if (!(q->flush_flags & REQ_FLUSH))
-				rw = WRITE_FUA;
-			else
-				rw = WRITE;
+			if (cmd->se_cmd_flags & SCF_FUA) {
+				op = REQ_OP_WRITE;
+				op_flags = WRITE_FUA;
+			} else if (!(q->flush_flags & REQ_FLUSH)) {
+				op = REQ_OP_WRITE;
+				op_flags = WRITE_FUA;
+			} else {
+				op = REQ_OP_WRITE;
+			}
 		} else {
-			rw = WRITE;
+			op = REQ_OP_WRITE;
 		}
 	} else {
-		rw = READ;
+		op = REQ_OP_READ;
 	}
 
 	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
@@ -714,7 +719,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		return 0;
 	}
 
-	bio = iblock_get_bio(cmd, block_lba, sgl_nents, rw);
+	bio = iblock_get_bio(cmd, block_lba, sgl_nents, op, op_flags);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -738,7 +743,8 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 				bio_cnt = 0;
 			}
 
-			bio = iblock_get_bio(cmd, block_lba, sg_num, rw);
+			bio = iblock_get_bio(cmd, block_lba, sg_num, op,
+					     op_flags);
 			if (!bio)
 				goto fail_put_bios;
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index de18790..2cf915c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -922,7 +922,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					goto fail;
 
 				if (rw)
-					bio->bi_rw |= REQ_WRITE;
+					bio->bi_op = REQ_OP_WRITE;
 
 				pr_debug("PSCSI: Allocated bio: %p,"
 					" dir: %s nr_vecs: %d\n", bio,
-- 
2.7.2
