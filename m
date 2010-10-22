From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm/iblock: Fix bio-set leak during bio exception handling
Date: Thu, 21 Oct 2010 19:20:22 -0700
Message-ID: <1287714022-16907-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes two (one known and one potential) bio-set memory
leak cases in TCM/IBLOCK when handling exception / shutdown scenarions
for individually allocated struct bios.  The first case has been reported
as a struct kmem_cache error during iblock_free_device() -> bioset_free()
DRBD block device shutdown.  This was happening when iblock_bio_done() was
called with a final (err != 0) status and bio_put() not being called.

This patch to iblock_bio_done() also now properly accounts for errors
with multiple outstanding chained bios per individual struct se_task
context by adding struct iblock_req->ib_bio_err_cnt.  This is used by
transport_complete_task() in order to determine when to complete
struct se_task w/ non GOOD status in the iblock_bio_done() (err == 0)
case when other bios in the single outstanding chain already failed.

The second bio-set exception case this patch addresses can happen when
iblock_map_task_SG() is called via transport_generic_map_buffers_to_tasks()
to setup struct iblock_req->ib_bio, but the associated struct se_task is
released during struct se_device shutdown before submit_bio() can be called
via iblock_do_task() to dispatch the bios into struct block_device.

So just to verify some items (jaxboe + hch please comment) about how bio_put()
and the struct bio->bi_done() call should function:

*) bio_put() should always be called during bio->bi_bio() -> iblock_bio_done()
   to call bio->bi_destructor() -> iblock_bio_destructor() -> bio_free()
*) bio->bi_bio() -> iblock_bio_done() must always do internal accounting 
   for the completion of chained BIOs dispatched with a *single* call to sumbit_bio()
   as to which is the last outstanding BIO to complete our struct se_task.
*) In order to determine good status for the struct iblock_req <-> struct se_task,
   using the following block in bio->bi_bio() -> iblock_bio_done() is still required:

        /*
         * Set -EIO if !BIO_UPTODATE and the passed is still err=0
         */
        if (!(test_bit(BIO_UPTODATE, &bio->bi_flags)) && !(err))
                err = -EIO;

If these three points are correct, I think this patch should resolve the
original reported issue and address the second 'add missing bio_put)'s for
tasks aborted before submit_bio() is called' scenario as well.

So far this has been lightly tested on v2.6.36-rc8 on TCM_Loop SCSI LUNs, but
this will also need to be addressed on older stable / distro kernels in
lio-core-backports.git code.

Comments folks..?

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   55 ++++++++++++++++++++++++-----------
 drivers/target/target_core_iblock.h |    1 +
 2 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index e7840da..85126b1 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -318,14 +318,15 @@ static void *iblock_allocate_request(
 {
 	struct iblock_req *ib_req;
 
-	ib_req = kmalloc(sizeof(struct iblock_req), GFP_KERNEL);
+	ib_req = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
 	if (!(ib_req)) {
 		printk(KERN_ERR "Unable to allocate memory for struct iblock_req\n");
 		return NULL;
 	}
 
 	ib_req->ib_dev = dev->dev_ptr;
-	return (void *)ib_req;
+	atomic_set(&ib_req->ib_bio_cnt, 0);
+	return ib_req;
 }
 
 static unsigned long long iblock_emulate_read_cap_with_block_size(
@@ -543,11 +544,17 @@ static int iblock_do_discard(struct se_device *dev, sector_t lba, u32 range)
 static void iblock_free_task(struct se_task *task)
 {
 	struct iblock_req *req = task->transport_req;
-
+	struct bio *bio, *hbio = req->ib_bio;
 	/*
-	 * We do not release the bio(s) here associated with this task, as
-	 * this is handled by bio_put() and iblock_bio_destructor().
+	 * We only release the bio(s) here if iblock_bio_done() has not called
+	 * bio_put() -> iblock_bio_destructor().
 	 */
+	while (hbio != NULL) {
+		bio = hbio;
+		hbio = hbio->bi_next;
+		bio->bi_next = NULL;
+		bio_put(bio);
+	}
 
 	kfree(req);
 	task->transport_req = NULL;
@@ -767,8 +774,6 @@ static int iblock_map_task_SG(struct se_task *task)
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 
-	atomic_set(&ib_req->ib_bio_cnt, 0);
-
 	bio = iblock_get_bio(task, ib_req, ib_dev, &ret, block_lba, sg_num);
 	if (!(bio))
 		return ret;
@@ -896,15 +901,32 @@ static sector_t iblock_get_blocks(struct se_device *dev)
 
 static void iblock_bio_done(struct bio *bio, int err)
 {
-	struct se_task *task = (struct se_task *)bio->bi_private;
-	struct iblock_req *ibr = (struct iblock_req *)task->transport_req;
+	struct se_task *task = bio->bi_private;
+	struct iblock_req *ibr = task->transport_req;
+	/*
+	 * Set -EIO if !BIO_UPTODATE and the passed is still err=0
+	 */
+	if (!(test_bit(BIO_UPTODATE, &bio->bi_flags)) && !(err))
+		err = -EIO;
 
-	err = test_bit(BIO_UPTODATE, &bio->bi_flags) ? err : -EIO;
 	if (err != 0) {
 		printk(KERN_ERR "test_bit(BIO_UPTODATE) failed for bio: %p,"
 			" err: %d\n", bio, err);
+		/*
+		 * Bump the ib_bio_err_cnt and release bio.
+		 */
+		atomic_inc(&ibr->ib_bio_err_cnt);
+		smp_mb__after_atomic_inc();
+		bio_put(bio);
+		/*
+		 * Wait to complete the task until the last bio as completed.
+		 */
+		if (!(atomic_dec_and_test(&ibr->ib_bio_cnt)))
+			return;
+
+		ibr->ib_bio = NULL;
 		transport_complete_task(task, 0);
-		goto out;
+		return;
 	}
 	DEBUG_IBLOCK("done[%p] bio: %p task_lba: %llu bio_lba: %llu err=%d\n",
 		task, bio, task->task_lba, bio->bi_sector, err);
@@ -913,17 +935,16 @@ static void iblock_bio_done(struct bio *bio, int err)
 	 * to ibr->ib_bio_set.
 	 */
 	bio_put(bio);
-
 	/*
 	 * Wait to complete the task until the last bio as completed.
 	 */
 	if (!(atomic_dec_and_test(&ibr->ib_bio_cnt)))
-		goto out;
-
+		return;
+	/*
+	 * Return GOOD status for task if zero ib_bio_err_cnt exists.
+	 */
 	ibr->ib_bio = NULL;
-	transport_complete_task(task, (!err));
-out:
-	return;
+	transport_complete_task(task, (!atomic_read(&ibr->ib_bio_err_cnt)));
 }
 
 static struct se_subsystem_api iblock_template = {
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 3582aac..4cbfbff 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -14,6 +14,7 @@ extern struct se_global *se_global;
 struct iblock_req {
 	unsigned char ib_scsi_cdb[TCM_MAX_COMMAND_SIZE];
 	atomic_t ib_bio_cnt;
+	atomic_t ib_bio_err_cnt;
 	u32	ib_sg_count;
 	void	*ib_buf;
 	struct bio *ib_bio;
-- 
1.5.6.5
