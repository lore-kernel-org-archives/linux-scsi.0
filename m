From: michaelc@cs.wisc.edu
Subject: [PATCH 6/7] block and drivers: separate failfast into
	multiple bits.
Date: Wed,  4 Jun 2008 20:41:45 -0500
Message-ID: <1212630106-13413-7-git-send-email-michaelc@cs.wisc.edu>
References: <1212630106-13413-1-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-2-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-3-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-4-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-5-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-6-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1212630106-13413-6-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

Multipath is best at handling transport errors. If it gets a device
error then there is not much the multipath layer can do. It will just
access the same device but from a different path. RAID is best at
handling device errors. If it gets a transport error it is going to
do the same thing the lower level would have done - retry it on the
same path.

This patch breaks up failfast into device, transport and driver errors.
The multipath layers (md and dm mutlipath) only ask the lower levels to
fast fail transport errors, but read ahead will ask to fast fail
on all errors.

Note that blk_noretry_request will return true if any failfast bit
is set. This allows drivers that do not support the multipath failfast
bits to continue to fail on any failfast error like before. As a result I
was thinking blk_noretry_request should have a different name like
blk_noretry_any_error or something, but I will do the rename changes
in a different patch.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/blk-core.c                            |   11 +++++++++--
 drivers/md/dm-mpath.c                       |    2 +-
 drivers/md/multipath.c                      |    4 ++--
 drivers/s390/block/dasd_diag.c              |    2 +-
 drivers/s390/block/dasd_eckd.c              |    2 +-
 drivers/s390/block/dasd_fba.c               |    2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |    3 ++-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    3 ++-
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    3 ++-
 drivers/scsi/scsi_transport_spi.c           |    4 +++-
 include/linux/bio.h                         |   26 +++++++++++++++++---------
 include/linux/blkdev.h                      |   15 ++++++++++++---
 12 files changed, 53 insertions(+), 24 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b754a4a..7fefda4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1062,8 +1062,15 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	/*
 	 * inherit FAILFAST from bio (for read-ahead, and explicit FAILFAST)
 	 */
-	if (bio_rw_ahead(bio) || bio_failfast(bio))
-		req->cmd_flags |= REQ_FAILFAST;
+	if (bio_rw_ahead(bio))
+		req->cmd_flags |= (REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+				   REQ_FAILFAST_DRIVER);
+	if (bio_failfast_dev(bio))
+		req->cmd_flags |= REQ_FAILFAST_DEV;
+	if (bio_failfast_transport(bio))
+		req->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+	if (bio_failfast_driver(bio))
+		req->cmd_flags |= BIO_RW_FAILFAST_DRIVER;
 
 	/*
 	 * REQ_BARRIER implies no merging, but lets make it explicit
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e8f704a..f29ab80 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -808,7 +808,7 @@ static int multipath_map(struct dm_target *ti, struct bio *bio,
 	dm_bio_record(&mpio->details, bio);
 
 	map_context->ptr = mpio;
-	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
+	bio->bi_rw |= (1 << BIO_RW_FAILFAST_TRANSPORT);
 	r = map_io(m, bio, mpio, 0);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		mempool_free(mpio, m->mpio_pool);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 42ee1a2..a8030d6 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -172,7 +172,7 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	mp_bh->bio = *bio;
 	mp_bh->bio.bi_sector += multipath->rdev->data_offset;
 	mp_bh->bio.bi_bdev = multipath->rdev->bdev;
-	mp_bh->bio.bi_rw |= (1 << BIO_RW_FAILFAST);
+	mp_bh->bio.bi_rw |= (1 << BIO_RW_FAILFAST_TRANSPORT);
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
 	generic_make_request(&mp_bh->bio);
@@ -390,7 +390,7 @@ static void multipathd (mddev_t *mddev)
 			*bio = *(mp_bh->master_bio);
 			bio->bi_sector += conf->multipaths[mp_bh->path].rdev->data_offset;
 			bio->bi_bdev = conf->multipaths[mp_bh->path].rdev->bdev;
-			bio->bi_rw |= (1 << BIO_RW_FAILFAST);
+			bio->bi_rw |= (1 << BIO_RW_FAILFAST_TRANSPORT);
 			bio->bi_end_io = multipath_end_request;
 			bio->bi_private = mp_bh;
 			generic_make_request(bio);
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index d91df38..60102ce 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -533,7 +533,7 @@ static struct dasd_ccw_req *dasd_diag_build_cp(struct dasd_device *memdev,
 	}
 	cqr->retries = DIAG_MAX_RETRIES;
 	cqr->buildclk = get_clock();
-	if (req->cmd_flags & REQ_FAILFAST)
+	if (blk_noretry_request(req))
 		set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
 	cqr->startdev = memdev;
 	cqr->memdev = memdev;
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index a0edae0..4779e2c 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1604,7 +1604,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp(struct dasd_device *startdev,
 			recid++;
 		}
 	}
-	if (req->cmd_flags & REQ_FAILFAST)
+	if (blk_noretry_request(req))
 		set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
 	cqr->startdev = startdev;
 	cqr->memdev = startdev;
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 1166115..6125041 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -350,7 +350,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 			recid++;
 		}
 	}
-	if (req->cmd_flags & REQ_FAILFAST)
+	if (blk_noretry_request(req))
 		set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
 	cqr->startdev = memdev;
 	cqr->memdev = memdev;
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index ed53f14..376322b 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -294,7 +294,8 @@ static struct request *get_req(struct scsi_device *sdev, int cmd)
 
 	rq->cmd[4] = len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_FAILFAST;
+	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			 REQ_FAILFAST_DRIVER;
 	rq->timeout = CLARIION_TIMEOUT;
 	rq->retries = CLARIION_RETRIES;
 
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 12ceab7..95be4b3 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -89,7 +89,8 @@ static int hp_sw_activate(struct scsi_device *sdev)
 	sdev_printk(KERN_INFO, sdev, "sending START_STOP.");
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
-	req->cmd_flags |= REQ_FAILFAST;
+	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			  REQ_FAILFAST_DRIVER;
 	req->cmd_len = COMMAND_SIZE(START_STOP);
 	memset(req->cmd, 0, MAX_COMMAND_SIZE);
 	req->cmd[0] = START_STOP;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 6fff077..8117674 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -220,7 +220,8 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 	rq->sense_len = 0;
 
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
+	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			 REQ_FAILFAST_DRIVER;
 	rq->retries = RDAC_RETRIES;
 	rq->timeout = RDAC_TIMEOUT;
 
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 75a64a6..b39e12e 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -109,7 +109,9 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 	for(i = 0; i < DV_RETRIES; i++) {
 		result = scsi_execute(sdev, cmd, dir, buffer, bufflen,
 				      sense, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST);
+				      REQ_FAILFAST_DEV |
+				      REQ_FAILFAST_TRANSPORT |
+				      REQ_FAILFAST_DRIVER);
 		if (result & DRIVER_SENSE) {
 			struct scsi_sense_hdr sshdr_tmp;
 			if (!sshdr)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 61c15ea..b6bbad6 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -143,15 +143,20 @@ struct bio {
  * bit 0 -- read (not set) or write (set)
  * bit 1 -- rw-ahead when set
  * bit 2 -- barrier
- * bit 3 -- fail fast, don't want low level driver retries
- * bit 4 -- synchronous I/O hint: the block layer will unplug immediately
+ * bit 3 -- synchronous I/O hint: the block layer will unplug immediately
+ * bit 4 -- meta data
+ * bit 5 -- fail fast device errors
+ * bit 6 -- fail fast transport errors
+ * bit 7 -- fail fast driver errors
  */
-#define BIO_RW		0
-#define BIO_RW_AHEAD	1
-#define BIO_RW_BARRIER	2
-#define BIO_RW_FAILFAST	3
-#define BIO_RW_SYNC	4
-#define BIO_RW_META	5
+#define BIO_RW				0
+#define BIO_RW_AHEAD			1
+#define BIO_RW_BARRIER			2
+#define BIO_RW_SYNC			3
+#define BIO_RW_META			4
+#define BIO_RW_FAILFAST_DEV		5
+#define BIO_RW_FAILFAST_TRANSPORT	6
+#define BIO_RW_FAILFAST_DRIVER		7
 
 /*
  * upper 16 bits of bi_rw define the io priority of this bio
@@ -178,7 +183,10 @@ struct bio {
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
 #define bio_barrier(bio)	((bio)->bi_rw & (1 << BIO_RW_BARRIER))
 #define bio_sync(bio)		((bio)->bi_rw & (1 << BIO_RW_SYNC))
-#define bio_failfast(bio)	((bio)->bi_rw & (1 << BIO_RW_FAILFAST))
+#define bio_failfast_dev(bio)	((bio)->bi_rw &	(1 << BIO_RW_FAILFAST_DEV))
+#define bio_failfast_transport(bio)	\
+	((bio)->bi_rw & (1 << BIO_RW_FAILFAST_TRANSPORT))
+#define bio_failfast_driver(bio) ((bio)->bi_rw & (1 << BIO_RW_FAILFAST_DRIVER))
 #define bio_rw_ahead(bio)	((bio)->bi_rw & (1 << BIO_RW_AHEAD))
 #define bio_rw_meta(bio)	((bio)->bi_rw & (1 << BIO_RW_META))
 #define bio_empty_barrier(bio)	(bio_barrier(bio) && !(bio)->bi_size)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d2a1b71..4abaa3a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -95,7 +95,9 @@ enum {
  */
 enum rq_flag_bits {
 	__REQ_RW,		/* not set, read. set, write */
-	__REQ_FAILFAST,		/* no low level driver retries */
+	__REQ_FAILFAST_DEV,	/* no driver retries of device errors */
+	__REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
+	__REQ_FAILFAST_DRIVER,	/* no driver retries of driver errors */
 	__REQ_SORTED,		/* elevator knows about this request */
 	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
 	__REQ_HARDBARRIER,	/* may not be passed by drive either */
@@ -117,7 +119,9 @@ enum rq_flag_bits {
 };
 
 #define REQ_RW		(1 << __REQ_RW)
-#define REQ_FAILFAST	(1 << __REQ_FAILFAST)
+#define REQ_FAILFAST_DEV	(1 << __REQ_FAILFAST_DEV)
+#define REQ_FAILFAST_TRANSPORT	(1 << __REQ_FAILFAST_TRANSPORT)
+#define REQ_FAILFAST_DRIVER	(1 << __REQ_FAILFAST_DRIVER)
 #define REQ_SORTED	(1 << __REQ_SORTED)
 #define REQ_SOFTBARRIER	(1 << __REQ_SOFTBARRIER)
 #define REQ_HARDBARRIER	(1 << __REQ_HARDBARRIER)
@@ -495,7 +499,12 @@ enum {
 #define blk_special_request(rq)	((rq)->cmd_type == REQ_TYPE_SPECIAL)
 #define blk_sense_request(rq)	((rq)->cmd_type == REQ_TYPE_SENSE)
 
-#define blk_noretry_request(rq)	((rq)->cmd_flags & REQ_FAILFAST)
+#define blk_failfast_dev(rq)	((rq)->cmd_flags & REQ_FAILFAST_DEV)
+#define blk_failfast_transport(rq) ((rq)->cmd_flags & REQ_FAILFAST_TRANSPORT)
+#define blk_failfast_driver(rq)	((rq)->cmd_flags & REQ_FAILFAST_DRIVER)
+#define blk_noretry_request(rq)	(blk_failfast_dev(rq) ||	\
+				 blk_failfast_transport(rq) ||	\
+				 blk_failfast_driver(rq))
 #define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)
 
 #define blk_account_rq(rq)	(blk_rq_started(rq) && blk_fs_request(rq))
-- 
1.5.4.1
