From: michaelc@cs.wisc.edu
Subject: [PATCH 8/9] block: separate failfast into multiple bits.
Date: Tue, 19 Aug 2008 18:45:30 -0500
Message-ID: <1219189531-5243-9-git-send-email-michaelc@cs.wisc.edu>
References: <1219189531-5243-1-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-2-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-3-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-4-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-5-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-6-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-7-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-8-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYHSXqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:46:46 -0400
In-Reply-To: <1219189531-5243-8-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Multipath is best at handling transport errors. If it gets a device
error then there is not much the multipath layer can do. It will just
access the same device but from a different path.

This patch breaks up failfast into device, transport and driver errors.
The multipath layers (md and dm mutlipath) only ask the lower levels to
fast fail transport errors. The user of failfast, read ahead, will ask
to fast fail on all errors.

Note that blk_noretry_request will return true if any failfast bit
is set. This allows drivers that do not support the multipath failfast
bits to continue to fail on any failfast error like before. Drivers
like scsi that are able to fail fast specific errors can check
for the specific fail fast type. In the next patch I will convert
scsi.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c                            |   11 +++++++++--
 drivers/md/dm-mpath.c                       |    2 +-
 drivers/md/multipath.c                      |    4 ++--
 drivers/s390/block/dasd_diag.c              |    2 +-
 drivers/s390/block/dasd_eckd.c              |    2 +-
 drivers/s390/block/dasd_fba.c               |    2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |    3 ++-
 drivers/scsi/device_handler/scsi_dh_emc.c   |    3 ++-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    6 ++++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    3 ++-
 drivers/scsi/scsi_transport_spi.c           |    4 +++-
 include/linux/bio.h                         |   26 +++++++++++++++++---------
 include/linux/blkdev.h                      |   15 ++++++++++++---
 13 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fef79cc..bebf311 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1055,8 +1055,15 @@ void init_request_from_bio(struct request *req, struct bio *bio)
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
+		req->cmd_flags |= REQ_FAILFAST_DRIVER;
 
 	/*
 	 * REQ_BARRIER implies no merging, but lets make it explicit
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 71dd65a..b48e201 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -827,7 +827,7 @@ static int multipath_map(struct dm_target *ti, struct bio *bio,
 	dm_bio_record(&mpio->details, bio);
 
 	map_context->ptr = mpio;
-	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
+	bio->bi_rw |= (1 << BIO_RW_FAILFAST_TRANSPORT);
 	r = map_io(m, bio, mpio, 0);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		mempool_free(mpio, m->mpio_pool);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index c4779cc..2426201 100644
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
@@ -398,7 +398,7 @@ static void multipathd (mddev_t *mddev)
 			*bio = *(mp_bh->master_bio);
 			bio->bi_sector += conf->multipaths[mp_bh->path].rdev->data_offset;
 			bio->bi_bdev = conf->multipaths[mp_bh->path].rdev->bdev;
-			bio->bi_rw |= (1 << BIO_RW_FAILFAST);
+			bio->bi_rw |= (1 << BIO_RW_FAILFAST_TRANSPORT);
 			bio->bi_end_io = multipath_end_request;
 			bio->bi_private = mp_bh;
 			generic_make_request(bio);
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 85fcb43..7844461 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -544,7 +544,7 @@ static struct dasd_ccw_req *dasd_diag_build_cp(struct dasd_device *memdev,
 	}
 	cqr->retries = DIAG_MAX_RETRIES;
 	cqr->buildclk = get_clock();
-	if (req->cmd_flags & REQ_FAILFAST)
+	if (blk_noretry_request(req))
 		set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
 	cqr->startdev = memdev;
 	cqr->memdev = memdev;
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 3590fdb..b904099 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1607,7 +1607,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp(struct dasd_device *startdev,
 			recid++;
 		}
 	}
-	if (req->cmd_flags & REQ_FAILFAST)
+	if (blk_noretry_request(req))
 		set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
 	cqr->startdev = startdev;
 	cqr->memdev = startdev;
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index aa0c533..115e032 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -355,7 +355,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 			recid++;
 		}
 	}
-	if (req->cmd_flags & REQ_FAILFAST)
+	if (blk_noretry_request(req))
 		set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
 	cqr->startdev = memdev;
 	cqr->memdev = memdev;
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index fcdd73f..0fda1c6 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -109,7 +109,8 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 	}
 
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
+	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			 REQ_FAILFAST_DRIVER | REQ_NOMERGE;
 	rq->retries = ALUA_FAILOVER_RETRIES;
 	rq->timeout = ALUA_FAILOVER_TIMEOUT;
 
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index aa46b13..f6abeb3 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -304,7 +304,8 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 
 	rq->cmd[4] = len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_FAILFAST;
+	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			 REQ_FAILFAST_DRIVER;
 	rq->timeout = CLARIION_TIMEOUT;
 	rq->retries = CLARIION_RETRIES;
 
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 9c7a1f8..b1e1017 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -112,7 +112,8 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
-	req->cmd_flags |= REQ_FAILFAST;
+	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			  REQ_FAILFAST_DRIVER;
 	req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
 	memset(req->cmd, 0, MAX_COMMAND_SIZE);
 	req->cmd[0] = TEST_UNIT_READY;
@@ -205,7 +206,8 @@ static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
-	req->cmd_flags |= REQ_FAILFAST;
+	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			  REQ_FAILFAST_DRIVER;
 	req->cmd_len = COMMAND_SIZE(START_STOP);
 	memset(req->cmd, 0, MAX_COMMAND_SIZE);
 	req->cmd[0] = START_STOP;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b093a50..ddee8d0 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -228,7 +228,8 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 	memset(rq->cmd, 0, BLK_MAX_CDB);
 
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
index 0933a14..425a4ec 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -147,15 +147,20 @@ struct bio {
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
@@ -182,7 +187,10 @@ struct bio {
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
index 88d6808..05b41a0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -88,7 +88,9 @@ enum {
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
@@ -111,7 +113,9 @@ enum rq_flag_bits {
 };
 
 #define REQ_RW		(1 << __REQ_RW)
-#define REQ_FAILFAST	(1 << __REQ_FAILFAST)
+#define REQ_FAILFAST_DEV	(1 << __REQ_FAILFAST_DEV)
+#define REQ_FAILFAST_TRANSPORT	(1 << __REQ_FAILFAST_TRANSPORT)
+#define REQ_FAILFAST_DRIVER	(1 << __REQ_FAILFAST_DRIVER)
 #define REQ_SORTED	(1 << __REQ_SORTED)
 #define REQ_SOFTBARRIER	(1 << __REQ_SOFTBARRIER)
 #define REQ_HARDBARRIER	(1 << __REQ_HARDBARRIER)
@@ -523,7 +527,12 @@ enum {
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

