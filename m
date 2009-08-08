From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] [Target_Core_Mod/pSCSI]: Use blk_make_request() in
	v2.6.31-rc
Date: Sat, 08 Aug 2009 13:12:33 -0700
Message-ID: <1249762353.11105.215.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:21738 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751252AbZHHUTQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2009 16:19:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Hello,

This patch updates the TCM/pSCSI subsystem plugin for v2.6.31-rc to use the new helper function
block/blk-core.c:blk_make_request() for doing struct page -> struct bio -> struct request
mapped I/O to an underlying struct scsi_device.

This patch updates pscsi_map_task_SG() to directly call blk_make_request() for a
bio_kmalloc() allocated chain of struct bios that have had bio_add_pc_page() called on
them from the generic target engine physical (page) memory.  This patch also updates
pscsi_CDB_read_SG() and pscsi_CDB_write_SG() (which both call pscsi_map_task_SG()) and
removes the now un-necessary calls to pscsi_blk_get_request().

This patch also adds a function named pscsi_blk_init_request() that is used by both
pscsi_map_task_SG() that uses blk_make_request() for SCF_SCSI_DATA_SG_IO_CDB type IO,
and by pscsi_blk_get_request() which uses blk_get_request() for all *NON* SCF_SCSI_DATA_SG_IO_CDB type IO.
pscsi_blk_init_request() will set the newly allocated struct request for REQ_TYPE_BLOCK_PC,
and setup the rq callback, CDB copy and sense data pointer between pscsi_plugin_task_t and
struct request.

Also, pscsi_get_max_sectors() was updated to use struct request_queue->limits.max_sectors,
and pscsi_req_done() was also updated to use the new struct request->resid_len.

So far, this patch is passing initial tests with badblocks with LIO-Target on v2.6.31-rc5
x86 KVM with virtual mptfusion SCSI of TYPE_DISK, and with v2.6.31-rc6 on ppc64 using
physical TYPE_ROM export.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |  129 +++++++++++++++++++++++-------------
 1 files changed, 84 insertions(+), 45 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e81c9fa..f261926 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -815,18 +815,8 @@ void *pscsi_allocate_request(
 	return pt;
 }
 
-static int pscsi_blk_get_request(se_task_t *task)
+static inline void pscsi_blk_init_request(se_task_t *task, pscsi_plugin_task_t *pt)
 {
-	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
-	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
-
-	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
-			(pt->pscsi_direction == DMA_TO_DEVICE), GFP_KERNEL);
-	if (!(pt->pscsi_req) || IS_ERR(pt->pscsi_req)) {
-		printk(KERN_ERR "PSCSI: blk_get_request() failed: %ld\n",
-				IS_ERR(pt->pscsi_req));
-		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-	}
 	/*
 	 * Defined as "scsi command" in include/linux/blkdev.h.
 	 */
@@ -848,7 +838,28 @@ static int pscsi_blk_get_request(se_task_t *task)
 	 */
 	pt->pscsi_req->sense = (void *)&pt->pscsi_sense[0];
 	pt->pscsi_req->sense_len = 0;
+}
+
+/*
+ * Used for pSCSI data payloads for all *NON* SCF_SCSI_DATA_SG_IO_CDB
+*/
+static int pscsi_blk_get_request(se_task_t *task)
+{
+	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
+	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
 
+	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
+			(pt->pscsi_direction == DMA_TO_DEVICE), GFP_KERNEL);
+	if (!(pt->pscsi_req) || IS_ERR(pt->pscsi_req)) {
+		printk(KERN_ERR "PSCSI: blk_get_request() failed: %ld\n",
+				IS_ERR(pt->pscsi_req));
+		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+	/*
+	 * Setup the newly allocated struct request for REQ_TYPE_BLOCK_PC,
+	 * and setup rq callback, CDB and sense.
+	 */
+	pscsi_blk_init_request(task, pt);
 	return 0;
 }
 
@@ -1240,10 +1251,13 @@ static void pscsi_bi_endio(struct bio *bio, int error)
 static inline struct bio *pscsi_get_bio(pscsi_dev_virt_t *pdv, int sg_num)
 {
 	struct bio *bio;
-
-	bio = bio_alloc(GFP_KERNEL, sg_num);
+	/*
+	 * Use bio_malloc() following the comment in for bio -> struct request
+	 * in block/blk-core.c:blk_make_request()
+	 */
+	bio = bio_kmalloc(GFP_KERNEL, sg_num);
 	if (!(bio)) {
-		printk(KERN_ERR "PSCSI: bio_alloc() failed\n");
+		printk(KERN_ERR "PSCSI: bio_kmalloc() failed\n");
 		return NULL;
 	}
 	bio->bi_end_io = pscsi_bi_endio;
@@ -1267,12 +1281,12 @@ int pscsi_map_task_SG(se_task_t *task)
 	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
 	struct page *page;
-	struct request *rq = pt->pscsi_req;
 	struct scatterlist *sg;
 	u32 data_len = task->task_size, i, len, bytes, off;
 	int nr_pages = (task->task_size + task->task_sg[0].offset +
 			PAGE_SIZE - 1) >> PAGE_SHIFT;
 	int nr_vecs = 0, ret = 0;
+	int rw = (TASK_CMD(task)->data_direction == SE_DIRECTION_WRITE);
 
 	if (!task->task_size)
 		return 0;
@@ -1304,15 +1318,29 @@ int pscsi_map_task_SG(se_task_t *task)
 			if (!(bio)) {
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
 				nr_pages -= nr_vecs;
-
+				/*
+				 * Calls bio_kmalloc() and sets bio->bi_end_io()
+				 */
 				bio = pscsi_get_bio(pdv, nr_vecs);
 				if (!(bio))
 					goto fail;
+				/*
+				 * FIXME: Use bio_set_dir() when avaliable
+				 */
+				if (rw)
+					bio->bi_rw |= (1 << BIO_RW);
 
 				DEBUG_PSCSI("PSCSI: Allocated bio: %p,"
-					" nr_vecs: %d\n", bio, nr_vecs);
-				if (!tbio)
-					tbio = bio;
+					" dir: %s nr_vecs: %d\n", bio,
+					(rw) ? "rw" : "r", nr_vecs);
+				/*
+				 * Set *hbio pointer to handle the case:
+				 * nr_pages > BIO_MAX_PAGES, where additional
+				 * bios need to be added to complete a given
+				 * se_task_t
+				 */
+				if (!hbio)
+					hbio = tbio = bio;
 				else
 					tbio = tbio->bi_next = bio;
 			}
@@ -1329,18 +1357,16 @@ int pscsi_map_task_SG(se_task_t *task)
 			DEBUG_PSCSI("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
 				bio->bi_vcnt, nr_vecs);
 
-			if (bio->bi_vcnt >= nr_vecs) {
-				bio->bi_flags &= ~(1 << BIO_SEG_VALID);
-				if (rq_data_dir(rq) == WRITE)
-					bio->bi_rw |= (1 << BIO_RW);
-				blk_queue_bounce(rq->q, &bio);
-
-				DEBUG_PSCSI("PSCSI: Calling blk_rq_append_bio()"
-					": i: %d bio: %p\n", i, bio);
-				ret = blk_rq_append_bio(rq->q, rq, bio);
-				if (ret < 0)
-					goto fail;
-
+			if (bio->bi_vcnt > nr_vecs) {
+				DEBUG_PSCSI("PSCSI: Reached bio->bi_vcnt max:"
+					" %d i: %d bio: %p, allocating another"
+					" bio\n", bio->bi_vcnt, i, bio);
+				/*
+				 * Clear the pointer so that another bio will
+				 * be allocated with pscsi_get_bio() above, the
+				 * current bio has already been set *tbio and
+				 * bio->bi_next.
+				 */
 				bio = NULL;
 			}
 
@@ -1350,9 +1376,21 @@ int pscsi_map_task_SG(se_task_t *task)
 			off = 0;
 		}
 	}
-
-	rq->buffer = rq->data = NULL;
-	rq->data_len = task->task_size;
+	/*
+	 * Starting with v2.6.31, call blk_make_request() passing in *hbio to
+	 * allocate the pSCSI task a struct request.
+	 */
+	pt->pscsi_req = blk_make_request(pdv->pdv_sd->request_queue,
+				hbio, GFP_KERNEL);
+	if (!(pt->pscsi_req)) {
+		printk(KERN_ERR "pSCSI: blk_make_request() failed\n");
+		goto fail;
+	}
+	/*
+	 * Setup the newly allocated struct request for REQ_TYPE_BLOCK_PC,
+	 * and setup rq callback, CDB and sense.
+	 */
+	pscsi_blk_init_request(task, pt);
 
 	return task->task_sg_num;
 fail:
@@ -1438,10 +1476,10 @@ int pscsi_CDB_read_SG(se_task_t *task, u32 size)
 	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
 
 	pt->pscsi_direction = DMA_FROM_DEVICE;
-
-	if (pscsi_blk_get_request(task) < 0)
-		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
+	/*
+	 * pscsi_map_task_SG() calls block/blk-core.c:blk_make_request()
+	 * for >= v2.6.31 pSCSI
+	 */
 	if (pscsi_map_task_SG(task) < 0)
 		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
@@ -1473,10 +1511,10 @@ int pscsi_CDB_write_SG(se_task_t *task, u32 size)
 	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
 
 	pt->pscsi_direction = DMA_TO_DEVICE;
-
-	if (pscsi_blk_get_request(task) < 0)
-		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
+	/*
+	 * pscsi_map_task_SG() calls block/blk-core.c:blk_make_request()
+	 * for >= v2.6.31 pSCSI
+	 */
 	if (pscsi_map_task_SG(task) < 0)
 		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
@@ -1576,8 +1614,9 @@ u32 pscsi_get_max_sectors(se_device_t *dev)
 {
 	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) dev->dev_ptr;
 	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
-	return (sd->host->max_sectors > sd->request_queue->max_sectors) ?
-		sd->request_queue->max_sectors : sd->host->max_sectors;
+
+	return (sd->host->max_sectors > sd->request_queue->limits.max_sectors) ?
+		sd->request_queue->limits.max_sectors : sd->host->max_sectors;
 }
 
 /*	pscsi_get_queue_depth():
@@ -1638,7 +1677,7 @@ void pscsi_req_done(struct request *req, int uptodate)
 	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *)task->transport_req;
 
 	pt->pscsi_result = req->errors;
-	pt->pscsi_resid = req->data_len;
+	pt->pscsi_resid = req->resid_len;
 
 	pscsi_process_SAM_status(task, pt);
 	__blk_put_request(req->q, req);
-- 
1.5.4.1



