From: Jason Yan <yanaijie@huawei.com>
Subject: [RFC PATCH v2] scsi: fix oops in scsi_uninit_cmd()
Date: Sat, 16 Mar 2019 10:09:05 +0800
Message-ID: <20190316020905.14962-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, hch@lst.de, bvanassche@acm.org, tom.leiming@gmail.com, Jason Yan <yanaijie@huawei.com>
List-Id: linux-scsi@vger.kernel.org

If we remove the scsi disk when running io with fio, oops occured with
the following condition.

[scsi_eh_0]                              [fio]
scsi_end_request
  ->blk_update_request
    ->end_bio(io returned to userspace)
                                         close
                                           ->sd_release
                                              ->scsi_disk_put
                                                 ->scsi_disk_release
                                                     ->disk->private_data = NULL;

  ->scsi_mq_uninit_cmd
    ->scsi_uninit_cmd
      ->scsi_cmd_to_driver
    ->drv is NULL, Oops

There is a small window between blk_update_request() and
scsi_mq_uninit_cmd() that scsi disk may have been released. This will
cause a oops like below:

Unable to handle kernel NULL pointer dereference at virtual address
0000000000000000
s/sync.c:67, func=xfer, error=In[11347.116050] Mem abort info:
put/output error
[11347.121598]   ESR = 0x96000006
[11347.126200]   Exception class = DABT (current EL), IL = 32 bits
[11347.132117]   SET = 0, FnV = 0
[11347.135170]   EA = 0, S1PTW = 0
[11347.138308] Data abort info:
[11347.141186]   ISV = 0, ISS = 0x00000006
[11347.145019]   CM = 0, WnR = 0
[11347.147977] user pgtable: 4k pages, 48-bit VAs, pgdp =
00000000a67aece2
[11347.154591] [0000000000000000] pgd=0000002f90774003,
pud=0000002fab098003, pmd=0000000000000000
[11347.163304] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[11347.168870] Modules linked in: hisi_sas_v3_hw hisi_sas_main libsas
[11347.175044] CPU: 56 PID: 4294 Comm: scsi_eh_2 Not tainted
4.19.0-g8052059-dirty #2
[11347.182600] Hardware name: Huawei D06/D06, BIOS Hisilicon D06 UEFI
RC0 - B601 (V6.01) 11/08/2018
[11347.191370] pstate: a0c00009 (NzCv daif +PAN +UAO)
[11347.196155] pc : scsi_uninit_cmd+0x24/0x3c
[11347.200240] lr : scsi_mq_uninit_cmd+0x1c/0x30
[11347.204583] sp : ffff000024dabb60
[11347.207884] x29: ffff000024dabb60 x28: ffff000024dabd38
[11347.213184] x27: ffff000000f5b3a8 x26: ffff7df3b0181600
[11347.218484] x25: 0000000000000000 x24: ffff803bc5d36778
[11347.223783] x23: 000000000000000a x22: 0000000000000000
[11347.229082] x21: ffff803bc7397000 x20: ffff802f9148e530
[11347.234381] x19: ffff802f9148e530 x18: ffff7e0000000000
[11347.239679] x17: 0000000000000000 x16: 0000002f9e37d000
[11347.244979] x15: ffff7e0000000000 x14: 3863206336203839
[11347.250278] x13: 2036302030302038 x12: a46fac3d0d363d00
[11347.255578] x11: ffffffffffffffff x10: a46fac3d0d363d00
[11347.260877] x9 : 0000000040040000 x8 : 000000000000eb4b
[11347.266177] x7 : ffff000009771000 x6 : 0000000000210d00
[11347.271476] x5 : ffff803bc9f50000 x4 : 0000000000000000
[11347.276775] x3 : ffff802fb02b4380 x2 : ffff802f9148e400
[11347.282075] x1 : 0000000000000000 x0 : ffff802f9148e530
[11347.287375] Process scsi_eh_2 (pid: 4294, stack limit =
0x000000007d2257f8)
[11347.294323] Call trace:
Jobs: 6 (f=6): [R[RRR1XXX1XRR3] 47.296758]  scsi_uninit_cmd+0x24/0x3c
[22.7% done] [1516MB/0KB/0KB /s] [754/0/0 iops] [eta 08m:39s]
[11347.308390]  scsi_mq_uninit_cmd+0x1c/0x30
[11347.312387]  scsi_end_request+0x7c/0x1b8
[11347.316297]  scsi_io_completion+0x464/0x668
[11347.320467]  scsi_finish_command+0xbc/0x160
[11347.324636]  scsi_eh_flush_done_q+0x10c/0x170
[11347.328990]  sas_scsi_recover_host+0x84c/0xa98 [libsas]
[11347.334202]  scsi_error_handler+0x140/0x5b0
[11347.338374]  kthread+0x100/0x12c
[11347.341590]  ret_from_fork+0x10/0x18
[11347.345153] Code: 71000c3f 540000e9 f9404c41 f941f421 (f9400021)
[11347.351234] ---[ end trace f496aacdaa1dcc51 ]---

To fix this, move the bio_endio() action from blk_update_request() to
__blk_mq_end_request().

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 block/blk-core.c       | 6 ++++--
 block/blk-mq.c         | 7 +++++++
 include/linux/blkdev.h | 1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4673ebe42255..f39ea78c0535 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -192,8 +192,10 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 	bio_advance(bio, nbytes);
 
 	/* don't actually finish bio if it's part of flush sequence */
-	if (bio->bi_iter.bi_size == 0 && !(rq->rq_flags & RQF_FLUSH_SEQ))
-		bio_endio(bio);
+	if (bio->bi_iter.bi_size == 0 && !(rq->rq_flags & RQF_FLUSH_SEQ)) {
+		bio->bi_next = rq->bio_to_release;
+		rq->bio_to_release = bio;
+	}
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a9c181603cbd..5ad595ebc198 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -529,8 +529,15 @@ EXPORT_SYMBOL_GPL(blk_mq_free_request);
 
 inline void __blk_mq_end_request(struct request *rq, blk_status_t error)
 {
+	struct bio *bio;
 	u64 now = 0;
 
+	while (rq->bio_to_release) {
+		bio = rq->bio_to_release->bi_next;
+		bio_endio(rq->bio_to_release);
+		rq->bio_to_release = bio;
+	}
+
 	if (blk_mq_need_time_stamp(rq))
 		now = ktime_get_ns();
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0de92b29f589..74fe561d5a49 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -143,6 +143,7 @@ struct request {
 
 	struct bio *bio;
 	struct bio *biotail;
+	struct bio *bio_to_release;
 
 	struct list_head queuelist;
 
-- 
2.14.5
