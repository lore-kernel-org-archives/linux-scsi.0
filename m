From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] tcm/iblock: Add SCSI LBA -> block_lba conversion for non 512-byte block_size
Date: Fri, 20 Aug 2010 02:06:50 -0700
Message-ID: <1282295210-8859-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for 4096, 2048 and 1024 byte block_size / sector conversion
from incoming struct se_task->task_lba from native TCM SCSI sector size into our
the iblock_map_task_SG() caller.  This is required as for each TCM struct se_task ->
struct bio I/O descriptor will always need to be assuming 512-byte sectors into
Linux/Block for submit_bio(), so when iblock_map_task_SG() is called we increment
block_lba in 512 byte units from sg->length for passing into iblock_get_bio() ->
struct bio->bi_sector assignment.

So far this patch has been tested with TCM_Loop virtual SCSI device on top of
IBLOCK+scsi_debug using non 512-byte block_sizes on x86 HVM.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   37 ++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1a0552f..d10930e 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -757,11 +757,12 @@ static void iblock_bio_destructor(struct bio *bio)
 	bio_free(bio, ib_dev->ibd_bio_set);
 }
 
-static struct bio *iblock_get_bio(struct se_task *task,
+static struct bio *iblock_get_bio(
+	struct se_task *task,
 	struct iblock_req *ib_req,
 	struct iblock_dev *ib_dev,
 	int *ret,
-	u64 lba,
+	sector_t lba,
 	u32 sg_num)
 {
 	struct bio *bio;
@@ -792,18 +793,36 @@ static struct bio *iblock_get_bio(struct se_task *task,
 
 static int iblock_map_task_SG(struct se_task *task)
 {
+	struct se_cmd *cmd = task->task_se_cmd;
+	struct se_device *dev = SE_DEV(cmd);
 	struct iblock_dev *ib_dev = (struct iblock_dev *) task->se_dev->dev_ptr;
 	struct iblock_req *ib_req = (struct iblock_req *) task->transport_req;
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
 	struct scatterlist *sg = task->task_sg;
 	int ret = 0;
 	u32 i, sg_num = task->task_sg_num;
-	u64 lba = task->task_lba;
+	sector_t block_lba;
+	/*
+	 * Do starting conversion up from non 512-byte blocksize with
+	 * struct se_task SCSI blocksize into Linux/Block 512 units for BIO.
+	 */
+	if (DEV_ATTRIB(dev)->block_size == 4096)
+		block_lba = (task->task_lba << 3);
+	else if (DEV_ATTRIB(dev)->block_size == 2048)
+		block_lba = (task->task_lba << 2);
+	else if (DEV_ATTRIB(dev)->block_size == 1024)
+		block_lba = (task->task_lba << 1);
+	else if (DEV_ATTRIB(dev)->block_size == 512)
+		block_lba = task->task_lba;
+	else {
+		printk(KERN_ERR "Unsupported SCSI -> BLOCK LBA conversion:"
+				" %u\n", DEV_ATTRIB(dev)->block_size);
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	}
 
 	atomic_set(&ib_req->ib_bio_cnt, 0);
 
-	bio = iblock_get_bio(task, ib_req, ib_dev, &ret,
-			task->task_lba, sg_num);
+	bio = iblock_get_bio(task, ib_req, ib_dev, &ret, block_lba, sg_num);
 	if (!(bio))
 		return ret;
 
@@ -832,7 +851,7 @@ again:
 					bio->bi_vcnt);
 
 			bio = iblock_get_bio(task, ib_req, ib_dev, &ret,
-					lba, sg_num);
+						block_lba, sg_num);
 			if (!(bio))
 				goto fail;
 
@@ -841,13 +860,13 @@ again:
 				" list, Going to again\n", bio);
 			goto again;
 		}
-
-		lba += sg[i].length >> IBLOCK_LBA_SHIFT;
+		/* Always in 512 byte units for Linux/Block */
+		block_lba += sg[i].length >> IBLOCK_LBA_SHIFT;
 		sg_num--;
 		DEBUG_IBLOCK("task: %p bio-add_page() passed!, decremented"
 			" sg_num to %u\n", task, sg_num);
 		DEBUG_IBLOCK("task: %p bio_add_page() passed!, increased lba"
-				" to %llu\n", task, lba);
+				" to %llu\n", task, block_lba);
 		DEBUG_IBLOCK("task: %p bio_add_page() passed!, bio->bi_vcnt:"
 				" %u\n", task, bio->bi_vcnt);
 	}
-- 
1.5.6.5
