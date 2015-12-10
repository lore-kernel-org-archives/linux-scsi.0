From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/15] scsi xcopy: keep cache of failures
Date: Thu, 10 Dec 2015 12:30:37 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101212220.25927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If xcopy between two devices fails, it is pointless to send more xcopy
command between there two devices because they take time and they will
likely also fail.

This patch keeps a cache of (source_device,destination_device) pairs where
copying failed and makes sure that no xcopy command is sooner than 30
seconds after the last failure.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/scsi/sd.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

Index: linux-4.4-rc4/drivers/scsi/sd.c
===================================================================
--- linux-4.4-rc4.orig/drivers/scsi/sd.c	2015-12-07 16:59:09.000000000 +0100
+++ linux-4.4-rc4/drivers/scsi/sd.c	2015-12-07 16:59:12.000000000 +0100
@@ -939,6 +939,26 @@ static void sd_config_copy(struct scsi_d
 				   (logical_block_size >> 9));
 }
 
+#define SD_COPY_DISABLED_CACHE_TIME		(HZ * 30)
+#define SD_COPY_DISABLED_CACHE_HASH_BITS	6
+#define SD_COPY_DISABLED_CACHE_HASH		(1 << SD_COPY_DISABLED_CACHE_HASH_BITS)
+
+struct sd_copy_disabled_cache_entry {
+	struct scsi_device *src;
+	struct scsi_device *dst;
+	unsigned long jiffies;
+};
+
+static struct sd_copy_disabled_cache_entry sd_copy_disabled_cache[SD_COPY_DISABLED_CACHE_HASH];
+
+static struct sd_copy_disabled_cache_entry *sd_copy_disabled_cache_hash(
+	struct scsi_device *src, struct scsi_device *dst)
+{
+	return &sd_copy_disabled_cache[
+		hash_long((unsigned long)src + ((unsigned long)dst >> 1), SD_COPY_DISABLED_CACHE_HASH_BITS)
+	];
+}
+
 static int sd_setup_copy_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -951,6 +971,7 @@ static int sd_setup_copy_cmnd(struct scs
 	struct bio *bio = rq->bio;
 	struct page *page;
 	unsigned char *buf;
+	struct sd_copy_disabled_cache_entry *e;
 
 	dst_sdp = scsi_disk(rq->rq_disk)->device;
 	dst_queue = rq->rq_disk->queue;
@@ -970,6 +991,12 @@ static int sd_setup_copy_cmnd(struct scs
 	if (src_sdp->sector_size != dst_sdp->sector_size)
 		return BLKPREP_KILL;
 
+	/* The copy failed in the past, so do not retry it for some time */
+	e = sd_copy_disabled_cache_hash(src_sdp, dst_sdp);
+	if (unlikely(jiffies - ACCESS_ONCE(e->jiffies) < SD_COPY_DISABLED_CACHE_TIME) &&
+	    likely(ACCESS_ONCE(e->src) == src_sdp) && likely(ACCESS_ONCE(e->dst) == dst_sdp))
+		return BLKPREP_KILL;
+
 	dst_lba = blk_rq_pos(rq) >> (ilog2(dst_sdp->sector_size) - 9);
 	src_lba = bio->bi_copy->pair[0]->bi_iter.bi_sector >> (ilog2(src_sdp->sector_size) - 9);
 	nr_blocks = blk_rq_sectors(rq) >> (ilog2(dst_sdp->sector_size) - 9);
@@ -2003,6 +2030,16 @@ static int sd_done(struct scsi_cmnd *SCp
 			 */
 			case EXTENDED_COPY:
 				if ((SCpnt->cmnd[1] & 0x1f) == 0) {
+					struct sd_copy_disabled_cache_entry *e;
+					struct scsi_device *src_sdp, *dst_sdp;
+
+					dst_sdp = sdkp->device;
+					src_sdp = scsi_disk(req->bio->bi_copy->pair[0]->bi_bdev->bd_disk)->device;
+					e = sd_copy_disabled_cache_hash(src_sdp, dst_sdp);
+					ACCESS_ONCE(e->src) = src_sdp;
+					ACCESS_ONCE(e->dst) = dst_sdp;
+					ACCESS_ONCE(e->jiffies) = jiffies;
+
 					good_bytes = 0;
 					req->__data_len = blk_rq_bytes(req);
 					req->cmd_flags |= REQ_QUIET;
