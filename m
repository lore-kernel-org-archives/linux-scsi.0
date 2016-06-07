From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 4/8] nvmet/io-cmd: Hookup sbc_ops->execute_rw backend ops
Date: Tue,  7 Jun 2016 06:36:52 +0000
Message-ID: <1465281416-28355-5-git-send-email-nab@linux-iscsi.org>
References: <1465281416-28355-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465281416-28355-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-nvme <linux-nvme@lists.infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts nvmet_execute_rw() to utilize sbc_ops->execute_rw()
for target_iostate + target_iomem based I/O submission into existing
backends drivers via configfs in /sys/kernel/config/target/core/.

This includes support for passing T10-PI scatterlists via target_iomem
into existing sbc_ops->execute_rw() logic, and is functioning with
IBLOCK, FILEIO, and RAMDISK.

Note the preceeding target/iblock patch absorbs inline bio + bvecs
and blk_poll() optimizations from Ming + Sagi in nvmet/io-cmd into
target_core_iblock.c code.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/nvme/target/io-cmd.c | 116 ++++++++++++++++++++++---------------------
 drivers/nvme/target/nvmet.h  |   7 +++
 2 files changed, 67 insertions(+), 56 deletions(-)

diff --git a/drivers/nvme/target/io-cmd.c b/drivers/nvme/target/io-cmd.c
index 38c2e97..133a14a 100644
--- a/drivers/nvme/target/io-cmd.c
+++ b/drivers/nvme/target/io-cmd.c
@@ -14,20 +14,16 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/blkdev.h>
 #include <linux/module.h>
+#include <target/target_core_base.h>
+#include <target/target_core_backend.h>
 #include "nvmet.h"
 
-#if 0
-static void nvmet_bio_done(struct bio *bio)
+static void nvmet_complete_ios(struct target_iostate *ios, u16 status)
 {
-	struct nvmet_req *req = bio->bi_private;
-
-	nvmet_req_complete(req,
-		bio->bi_error ? NVME_SC_INTERNAL | NVME_SC_DNR : 0);
+	struct nvmet_req *req = container_of(ios, struct nvmet_req, t_iostate);
 
-	if (bio != &req->inline_bio)
-		bio_put(bio);
+	nvmet_req_complete(req, status ? NVME_SC_INTERNAL | NVME_SC_DNR : 0);
 }
-#endif
 
 static inline u32 nvmet_rw_len(struct nvmet_req *req)
 {
@@ -35,72 +31,80 @@ static inline u32 nvmet_rw_len(struct nvmet_req *req)
 			req->ns->blksize_shift;
 }
 
-#if 0
-static void nvmet_inline_bio_init(struct nvmet_req *req)
-{
-	struct bio *bio = &req->inline_bio;
-
-	bio_init(bio);
-	bio->bi_max_vecs = NVMET_MAX_INLINE_BIOVEC;
-	bio->bi_io_vec = req->inline_bvec;
-}
-#endif
-
 static void nvmet_execute_rw(struct nvmet_req *req)
 {
-#if 0
-	int sg_cnt = req->sg_cnt;
-	struct scatterlist *sg;
-	struct bio *bio;
+	struct target_iostate *ios = &req->t_iostate;
+	struct target_iomem *iomem = &req->t_iomem;
+	struct se_device *dev = rcu_dereference_raw(req->ns->dev);
+	struct sbc_ops *sbc_ops = dev->transport->sbc_ops;
 	sector_t sector;
-	blk_qc_t cookie;
-	int rw, i;
-#endif
+	enum dma_data_direction data_direction;
+	sense_reason_t rc;
+	bool fua_write = false, prot_enabled = false;
+
+	if (!sbc_ops || !sbc_ops->execute_rw) {
+		nvmet_req_complete(req, NVME_SC_INTERNAL | NVME_SC_DNR);
+		return;
+	}
+
 	if (!req->sg_cnt) {
 		nvmet_req_complete(req, 0);
 		return;
 	}
-#if 0
+
 	if (req->cmd->rw.opcode == nvme_cmd_write) {
 		if (req->cmd->rw.control & cpu_to_le16(NVME_RW_FUA))
-			rw = WRITE_FUA;
-		else
-			rw = WRITE;
+			fua_write = true;
+
+		data_direction = DMA_TO_DEVICE;
 	} else {
-		rw = READ;
+		data_direction = DMA_FROM_DEVICE;
 	}
 
 	sector = le64_to_cpu(req->cmd->rw.slba);
 	sector <<= (req->ns->blksize_shift - 9);
 
-	nvmet_inline_bio_init(req);
-	bio = &req->inline_bio;
-	bio->bi_bdev = req->ns->bdev;
-	bio->bi_iter.bi_sector = sector;
-	bio->bi_private = req;
-	bio->bi_end_io = nvmet_bio_done;
-
-	for_each_sg(req->sg, sg, req->sg_cnt, i) {
-		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
-				!= sg->length) {
-			struct bio *prev = bio;
-
-			bio = bio_alloc(GFP_KERNEL, min(sg_cnt, BIO_MAX_PAGES));
-			bio->bi_bdev = req->ns->bdev;
-			bio->bi_iter.bi_sector = sector;
-
-			bio_chain(bio, prev);
-			cookie = submit_bio(rw, prev);
-		}
+	ios->t_task_lba = sector;
+	ios->data_length = nvmet_rw_len(req);
+	ios->data_direction = data_direction;
+	iomem->t_data_sg = req->sg;
+	iomem->t_data_nents = req->sg_cnt;
+	iomem->t_prot_sg = req->prot_sg;
+	iomem->t_prot_nents = req->prot_sg_cnt;
+
+	// XXX: Make common between sbc_check_prot and nvme-target
+	switch (dev->dev_attrib.pi_prot_type) {
+	case TARGET_DIF_TYPE3_PROT:
+		ios->reftag_seed = 0xffffffff;
+		prot_enabled = true;
+		break;
+	case TARGET_DIF_TYPE1_PROT:
+		ios->reftag_seed = ios->t_task_lba;
+		prot_enabled = true;
+		break;
+	default:
+		break;
+	}
 
-		sector += sg->length >> 9;
-		sg_cnt--;
+	if (prot_enabled) {
+		ios->prot_type = dev->dev_attrib.pi_prot_type;
+		ios->prot_length = dev->prot_length *
+				       (le16_to_cpu(req->cmd->rw.length) + 1);
+#if 0
+		printk("req->cmd->rw.length: %u\n", le16_to_cpu(req->cmd->rw.length));
+		printk("nvmet_rw_len: %u\n", nvmet_rw_len(req));
+		printk("req->se_cmd.prot_type: %d\n", req->se_cmd.prot_type);
+		printk("req->se_cmd.prot_length: %u\n", req->se_cmd.prot_length);
+#endif
 	}
 
-	cookie = submit_bio(rw, bio);
+	ios->se_dev = dev;
+	ios->iomem = iomem;
+	ios->t_comp_func = &nvmet_complete_ios;
 
-	blk_poll(bdev_get_queue(req->ns->bdev), cookie);
-#endif
+	rc = sbc_ops->execute_rw(ios, iomem->t_data_sg, iomem->t_data_nents,
+				 ios->data_direction, fua_write,
+				 &nvmet_complete_ios);
 }
 
 static void nvmet_execute_flush(struct nvmet_req *req)
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 16c3fa1..73f1df7 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -25,6 +25,7 @@
 #include <linux/configfs.h>
 #include <linux/rcupdate.h>
 #include <linux/blkdev.h>
+#include <target/target_core_base.h>
 
 #define NVMET_ASYNC_EVENTS		4
 #define NVMET_ERROR_LOG_SLOTS		128
@@ -233,6 +234,12 @@ struct nvmet_req {
 	int			sg_cnt;
 	size_t			data_len;
 
+	struct scatterlist	*prot_sg;
+	int			prot_sg_cnt;
+
+	struct target_iostate	t_iostate;
+	struct target_iomem	t_iomem;
+
 	struct nvmet_port	*port;
 
 	void (*execute)(struct nvmet_req *req);
-- 
1.9.1
