From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] tcm/iblock: Convert iblock_map_task_SG() to use for_each_sg()
Date: Fri, 20 Aug 2010 02:06:57 -0700
Message-ID: <1282295217-8880-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:42782 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751886Ab0HTJHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2010 05:07:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts iblock_map_task_SG() to use the include/linux/scatterlist.h
SGL walking macro for_each_sg() when accessing the contigious array of
struct scatterlist in struct se_task->task_sg[].   As we are currently
assured that TCM will always be using a contigious array allocated by
transport_calc_sg_num(), so it is still safe to walk struct se_task->task_sg[]
directly up to task->task_sg_num.

This patch does the minor cleanups to use for_each_sg() to follow mainline
convention for SGL walking (potentially) linked contigious scatterlist array
allocations coming from TCM into IBLOCK in the future..

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d10930e..7945ca8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -798,7 +798,7 @@ static int iblock_map_task_SG(struct se_task *task)
 	struct iblock_dev *ib_dev = (struct iblock_dev *) task->se_dev->dev_ptr;
 	struct iblock_req *ib_req = (struct iblock_req *) task->transport_req;
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
-	struct scatterlist *sg = task->task_sg;
+	struct scatterlist *sg;
 	int ret = 0;
 	u32 i, sg_num = task->task_sg_num;
 	sector_t block_lba;
@@ -832,14 +832,13 @@ static int iblock_map_task_SG(struct se_task *task)
 	 * Use fs/bio.c:bio_add_pages() to setup the bio_vec maplist
 	 * from TCM struct se_mem -> task->task_sg -> struct scatterlist memory.
 	 */
-	for (i = 0; i < task->task_sg_num; i++) {
+	for_each_sg(task->task_sg, sg, task->task_sg_num, i) {
 		DEBUG_IBLOCK("task: %p bio: %p Calling bio_add_page(): page:"
-			" %p len: %u offset: %u\n", task, bio, sg_page(&sg[i]),
-				sg[i].length, sg[i].offset);
+			" %p len: %u offset: %u\n", task, bio, sg_page(sg),
+				sg->length, sg->offset);
 again:
-		ret = bio_add_page(bio, sg_page(&sg[i]), sg[i].length,
-				sg[i].offset);
-		if (ret != sg[i].length) {
+		ret = bio_add_page(bio, sg_page(sg), sg->length, sg->offset);
+		if (ret != sg->length) {
 
 			DEBUG_IBLOCK("*** Set bio->bi_sector: %llu\n",
 					bio->bi_sector);
@@ -861,7 +860,7 @@ again:
 			goto again;
 		}
 		/* Always in 512 byte units for Linux/Block */
-		block_lba += sg[i].length >> IBLOCK_LBA_SHIFT;
+		block_lba += sg->length >> IBLOCK_LBA_SHIFT;
 		sg_num--;
 		DEBUG_IBLOCK("task: %p bio-add_page() passed!, decremented"
 			" sg_num to %u\n", task, sg_num);
-- 
1.5.6.5

