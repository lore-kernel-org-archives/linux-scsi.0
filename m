From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 11/31] block: Introduce queue flag QUEUE_FLAG_SCSI_SUP
Date: Tue, 23 May 2017 17:34:00 -0700
Message-ID: <20170524003420.5381-12-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

>From the context where a SCSI command is submitted it is not always
possible to figure out whether or not the queue the command is
submitted to has struct scsi_request as the first member of its
private data. Hence introduce the flag QUEUE_FLAG_SCSI_SUP.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Hannes Reinecke <hare@suse.com>
---
 block/bsg-lib.c                   | 1 +
 drivers/block/cciss.c             | 1 +
 drivers/ide/ide-probe.c           | 1 +
 drivers/scsi/scsi_lib.c           | 2 ++
 drivers/scsi/scsi_transport_sas.c | 1 +
 include/linux/blkdev.h            | 2 ++
 6 files changed, 8 insertions(+)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 0a23dbba2d30..420ac014b49c 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -246,6 +246,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, char *name,
 	q->bsg_job_size = dd_job_size;
 	q->bsg_job_fn = job_fn;
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_SCSI_SUP, q);
 	blk_queue_softirq_done(q, bsg_softirq_done);
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index cd375503f7b0..9706718749e5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1956,6 +1956,7 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	disk->queue->cmd_size = sizeof(struct scsi_request);
 	disk->queue->request_fn = do_cciss_request;
 	disk->queue->queue_lock = &h->lock;
+	queue_flag_set_unlocked(QUEUE_FLAG_SCSI_SUP, disk->queue);
 	if (blk_init_allocated_queue(disk->queue) < 0)
 		goto cleanup_queue;
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 023562565d11..fdfa11f80dda 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -773,6 +773,7 @@ static int ide_init_queue(ide_drive_t *drive)
 	q->request_fn = do_ide_request;
 	q->init_rq_fn = ide_init_rq;
 	q->cmd_size = sizeof(struct ide_request);
+	queue_flag_set_unlocked(QUEUE_FLAG_SCSI_SUP, q);
 	if (blk_init_allocated_queue(q) < 0) {
 		blk_cleanup_queue(q);
 		return 1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 59400033aba8..4cecf82960b7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2059,6 +2059,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 {
 	struct device *dev = shost->dma_dev;
 
+	queue_flag_set_unlocked(QUEUE_FLAG_SCSI_SUP, q);
+
 	/*
 	 * this limit is imposed by hardware restrictions
 	 */
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 0ebe2f1bb908..e5eab2685ecf 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -264,6 +264,7 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
 		q->queuedata = shost;
 
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_SCSI_SUP, q);
 	return 0;
 
 out_cleanup_queue:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b5d1e27631ee..6416a5834b05 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -618,6 +618,7 @@ struct request_queue {
 #define QUEUE_FLAG_STATS       27	/* track rq completion times */
 #define QUEUE_FLAG_POLL_STATS  28	/* collecting stats for hybrid polling */
 #define QUEUE_FLAG_REGISTERED  29	/* queue has been registered to a disk */
+#define QUEUE_FLAG_SCSI_SUP    30	/* queue supports SCSI commands */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -708,6 +709,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_secure_erase(q) \
 	(test_bit(QUEUE_FLAG_SECERASE, &(q)->queue_flags))
 #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
+#define blk_queue_scsi_sup(q)	test_bit(QUEUE_FLAG_SCSI_SUP, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
-- 
2.12.2
