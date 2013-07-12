From: Tanya Brokhman <tlinder@codeaurora.org>
Subject: [RFC/PATCH/RESEND v2 1/4] block: make rq->cmd_flags be 64-bit
Date: Fri, 12 Jul 2013 20:06:18 +0300
Message-ID: <1373648808-16968-1-git-send-email-tlinder@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

We have officially run out of flags in a 32-bit space. Extend it
to 64-bit even on 32-bit archs.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-core.c b/block/blk-core.c
index 93a18d1..cfa4dd3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -174,9 +174,9 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 {
 	int bit;
 
-	printk(KERN_INFO "%s: dev %s: type=%x, flags=%x\n", msg,
+	printk(KERN_INFO "%s: dev %s: type=%x, flags=%llx\n", msg,
 		rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->cmd_type,
-		rq->cmd_flags);
+		(unsigned long long) rq->cmd_flags);
 
 	printk(KERN_INFO "  sector %llu, nr/cnr %u/%u\n",
 	       (unsigned long long)blk_rq_pos(rq),
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 04ceb7e..000abe2 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2886,9 +2886,9 @@ static void do_fd_request(struct request_queue *q)
 		return;
 
 	if (WARN(atomic_read(&usage_count) == 0,
-		 "warning: usage count=0, current_req=%p sect=%ld type=%x flags=%x\n",
+		 "warning: usage count=0, current_req=%p sect=%ld type=%x flags=%llx\n",
 		 current_req, (long)blk_rq_pos(current_req), current_req->cmd_type,
-		 current_req->cmd_flags))
+		 (unsigned long long) current_req->cmd_flags))
 		return;
 
 	if (test_and_set_bit(0, &fdc_busy)) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 80f39b8..aa81364 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -994,7 +994,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
-		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
+		scmd_printk(KERN_ERR, SCpnt, "Unknown command %llx\n", (unsigned long long) rq->cmd_flags);
 		goto out;
 	}
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index fa1abeb..c26801e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -181,16 +181,16 @@ enum rq_flag_bits {
 	__REQ_NR_BITS,		/* stops here */
 };
 
-#define REQ_WRITE		(1 << __REQ_WRITE)
-#define REQ_FAILFAST_DEV	(1 << __REQ_FAILFAST_DEV)
-#define REQ_FAILFAST_TRANSPORT	(1 << __REQ_FAILFAST_TRANSPORT)
-#define REQ_FAILFAST_DRIVER	(1 << __REQ_FAILFAST_DRIVER)
-#define REQ_SYNC		(1 << __REQ_SYNC)
-#define REQ_META		(1 << __REQ_META)
-#define REQ_PRIO		(1 << __REQ_PRIO)
-#define REQ_DISCARD		(1 << __REQ_DISCARD)
-#define REQ_WRITE_SAME		(1 << __REQ_WRITE_SAME)
-#define REQ_NOIDLE		(1 << __REQ_NOIDLE)
+#define REQ_WRITE		(1ULL << __REQ_WRITE)
+#define REQ_FAILFAST_DEV	(1ULL << __REQ_FAILFAST_DEV)
+#define REQ_FAILFAST_TRANSPORT	(1ULL << __REQ_FAILFAST_TRANSPORT)
+#define REQ_FAILFAST_DRIVER	(1ULL << __REQ_FAILFAST_DRIVER)
+#define REQ_SYNC		(1ULL << __REQ_SYNC)
+#define REQ_META		(1ULL << __REQ_META)
+#define REQ_PRIO		(1ULL << __REQ_PRIO)
+#define REQ_DISCARD		(1ULL << __REQ_DISCARD)
+#define REQ_WRITE_SAME		(1ULL << __REQ_WRITE_SAME)
+#define REQ_NOIDLE		(1ULL << __REQ_NOIDLE)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
@@ -206,28 +206,28 @@ enum rq_flag_bits {
 #define REQ_NOMERGE_FLAGS \
 	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
 
-#define REQ_RAHEAD		(1 << __REQ_RAHEAD)
-#define REQ_THROTTLED		(1 << __REQ_THROTTLED)
-
-#define REQ_SORTED		(1 << __REQ_SORTED)
-#define REQ_SOFTBARRIER		(1 << __REQ_SOFTBARRIER)
-#define REQ_FUA			(1 << __REQ_FUA)
-#define REQ_NOMERGE		(1 << __REQ_NOMERGE)
-#define REQ_STARTED		(1 << __REQ_STARTED)
-#define REQ_DONTPREP		(1 << __REQ_DONTPREP)
-#define REQ_QUEUED		(1 << __REQ_QUEUED)
-#define REQ_ELVPRIV		(1 << __REQ_ELVPRIV)
-#define REQ_FAILED		(1 << __REQ_FAILED)
-#define REQ_QUIET		(1 << __REQ_QUIET)
-#define REQ_PREEMPT		(1 << __REQ_PREEMPT)
-#define REQ_ALLOCED		(1 << __REQ_ALLOCED)
-#define REQ_COPY_USER		(1 << __REQ_COPY_USER)
-#define REQ_FLUSH		(1 << __REQ_FLUSH)
-#define REQ_FLUSH_SEQ		(1 << __REQ_FLUSH_SEQ)
-#define REQ_IO_STAT		(1 << __REQ_IO_STAT)
-#define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
-#define REQ_SECURE		(1 << __REQ_SECURE)
-#define REQ_KERNEL		(1 << __REQ_KERNEL)
-#define REQ_PM			(1 << __REQ_PM)
+#define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
+#define REQ_THROTTLED		(1ULL << __REQ_THROTTLED)
+
+#define REQ_SORTED		(1ULL << __REQ_SORTED)
+#define REQ_SOFTBARRIER		(1ULL << __REQ_SOFTBARRIER)
+#define REQ_FUA			(1ULL << __REQ_FUA)
+#define REQ_NOMERGE		(1ULL << __REQ_NOMERGE)
+#define REQ_STARTED		(1ULL << __REQ_STARTED)
+#define REQ_DONTPREP		(1ULL << __REQ_DONTPREP)
+#define REQ_QUEUED		(1ULL << __REQ_QUEUED)
+#define REQ_ELVPRIV		(1ULL << __REQ_ELVPRIV)
+#define REQ_FAILED		(1ULL << __REQ_FAILED)
+#define REQ_QUIET		(1ULL << __REQ_QUIET)
+#define REQ_PREEMPT		(1ULL << __REQ_PREEMPT)
+#define REQ_ALLOCED		(1ULL << __REQ_ALLOCED)
+#define REQ_COPY_USER		(1ULL << __REQ_COPY_USER)
+#define REQ_FLUSH		(1ULL << __REQ_FLUSH)
+#define REQ_FLUSH_SEQ		(1ULL << __REQ_FLUSH_SEQ)
+#define REQ_IO_STAT		(1ULL << __REQ_IO_STAT)
+#define REQ_MIXED_MERGE		(1ULL << __REQ_MIXED_MERGE)
+#define REQ_SECURE		(1ULL << __REQ_SECURE)
+#define REQ_KERNEL		(1ULL << __REQ_KERNEL)
+#define REQ_PM			(1ULL << __REQ_PM)
 
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2fdb4a4..40e3cea 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -99,7 +99,7 @@ struct request {
 
 	struct request_queue *q;
 
-	unsigned int cmd_flags;
+	u64 cmd_flags;
 	enum rq_cmd_type_bits cmd_type;
 	unsigned long atomic_flags;
 
@@ -570,7 +570,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-#define rq_data_dir(rq)		((rq)->cmd_flags & 1)
+#define rq_data_dir(rq)		(((rq)->cmd_flags & 1) != 0)
 
 static inline unsigned int blk_queue_cluster(struct request_queue *q)
 {
-- 
1.7.6
