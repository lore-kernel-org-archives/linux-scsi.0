From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.20-rc7
Date: Fri, 21 Dec 2018 18:50:56 -0800
Message-ID: <1545447056.2776.11.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is two simple target fixes and one discard related I/O starvation
problem in sd.  The discard problem occurs because the discard page
doesn't have a mempool backing so if the allocation fails due to memory
pressure, we then lose the forward progress we require if the writeout
is on the same device.  The fix is to back it with a mempool.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Jens Axboe (1):
      scsi: sd: use mempool for discard special page

Varun Prakash (2):
      scsi: target: iscsi: cxgbit: add missing spin_lock_init()
      scsi: target: iscsi: cxgbit: fix csk leak

And the diffstat:

 drivers/scsi/sd.c                         | 23 +++++++++++++++++++----
 drivers/target/iscsi/cxgbit/cxgbit_cm.c   |  5 ++++-
 drivers/target/iscsi/cxgbit/cxgbit_main.c |  1 +
 3 files changed, 24 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3bb2b3351e35..bd0a5c694a97 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -133,6 +133,7 @@ static DEFINE_MUTEX(sd_ref_mutex);
 
 static struct kmem_cache *sd_cdb_cache;
 static mempool_t *sd_cdb_pool;
+static mempool_t *sd_page_pool;
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -759,9 +760,10 @@ static int sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	unsigned int data_len = 24;
 	char *buf;
 
-	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!rq->special_vec.bv_page)
 		return BLKPREP_DEFER;
+	clear_highpage(rq->special_vec.bv_page);
 	rq->special_vec.bv_offset = 0;
 	rq->special_vec.bv_len = data_len;
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
@@ -792,9 +794,10 @@ static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd, bool unmap)
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 data_len = sdp->sector_size;
 
-	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!rq->special_vec.bv_page)
 		return BLKPREP_DEFER;
+	clear_highpage(rq->special_vec.bv_page);
 	rq->special_vec.bv_offset = 0;
 	rq->special_vec.bv_len = data_len;
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
@@ -822,9 +825,10 @@ static int sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd, bool unmap)
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 data_len = sdp->sector_size;
 
-	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!rq->special_vec.bv_page)
 		return BLKPREP_DEFER;
+	clear_highpage(rq->special_vec.bv_page);
 	rq->special_vec.bv_offset = 0;
 	rq->special_vec.bv_len = data_len;
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
@@ -1286,7 +1290,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 	u8 *cmnd;
 
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
-		__free_page(rq->special_vec.bv_page);
+		mempool_free(rq->special_vec.bv_page, sd_page_pool);
 
 	if (SCpnt->cmnd != scsi_req(rq)->cmd) {
 		cmnd = SCpnt->cmnd;
@@ -3623,6 +3627,13 @@ static int __init init_sd(void)
 		goto err_out_cache;
 	}
 
+	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
+	if (!sd_page_pool) {
+		printk(KERN_ERR "sd: can't init discard page pool\n");
+		err = -ENOMEM;
+		goto err_out_ppool;
+	}
+
 	err = scsi_register_driver(&sd_template.gendrv);
 	if (err)
 		goto err_out_driver;
@@ -3630,6 +3641,9 @@ static int __init init_sd(void)
 	return 0;
 
 err_out_driver:
+	mempool_destroy(sd_page_pool);
+
+err_out_ppool:
 	mempool_destroy(sd_cdb_pool);
 
 err_out_cache:
@@ -3656,6 +3670,7 @@ static void __exit exit_sd(void)
 
 	scsi_unregister_driver(&sd_template.gendrv);
 	mempool_destroy(sd_cdb_pool);
+	mempool_destroy(sd_page_pool);
 	kmem_cache_destroy(sd_cdb_cache);
 
 	class_unregister(&sd_disk_class);
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 71888b979ab5..b19c960d5490 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -641,8 +641,11 @@ static void cxgbit_send_halfclose(struct cxgbit_sock *csk)
 
 static void cxgbit_arp_failure_discard(void *handle, struct sk_buff *skb)
 {
+	struct cxgbit_sock *csk = handle;
+
 	pr_debug("%s cxgbit_device %p\n", __func__, handle);
 	kfree_skb(skb);
+	cxgbit_put_csk(csk);
 }
 
 static void cxgbit_abort_arp_failure(void *handle, struct sk_buff *skb)
@@ -1206,7 +1209,7 @@ cxgbit_pass_accept_rpl(struct cxgbit_sock *csk, struct cpl_pass_accept_req *req)
 	rpl5->opt0 = cpu_to_be64(opt0);
 	rpl5->opt2 = cpu_to_be32(opt2);
 	set_wr_txq(skb, CPL_PRIORITY_SETUP, csk->ctrlq_idx);
-	t4_set_arp_err_handler(skb, NULL, cxgbit_arp_failure_discard);
+	t4_set_arp_err_handler(skb, csk, cxgbit_arp_failure_discard);
 	cxgbit_l2t_send(csk->com.cdev, skb, csk->l2t);
 }
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index f3f8856bfb68..c011c826fc26 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -58,6 +58,7 @@ static void *cxgbit_uld_add(const struct cxgb4_lld_info *lldi)
 		return ERR_PTR(-ENOMEM);
 
 	kref_init(&cdev->kref);
+	spin_lock_init(&cdev->np_lock);
 
 	cdev->lldi = *lldi;
 
